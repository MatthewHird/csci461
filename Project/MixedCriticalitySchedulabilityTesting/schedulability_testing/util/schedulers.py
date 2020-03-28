from datetime import datetime
import logging
from collections import namedtuple, defaultdict
import pulp
import numpy as np
from typing import List, Tuple, Dict
import copy

from shared.model.task import Task
from shared.util.exception import JobContainerOverflowError, FfbbJobAssignmentError

from schedulability_testing.model.result import Result
from schedulability_testing.model.task_set_metadata import TaskSetMetadata
from schedulability_testing.model.job_container import JobContainer
from schedulability_testing.model.job import Job
from schedulability_testing.model.minor_cycle import MinorCycle
from schedulability_testing.model.frame import Frame
from schedulability_testing.model.mc_schedule import McSchedule
from schedulability_testing.model.mc_core import McCore
from schedulability_testing.model.mc_frame import McFrame
from schedulability_testing.model.mc_criticality_level import McCriticalityLevel
from schedulability_testing.model.mc_job import McJob
from schedulability_testing.model.job_bin import JobBin


# interface Scheduler
#   @staticmethod
#   def validate_task_set(task_set: List[Task]) -> Result:
#       pass

def _factors(number: int) -> List[int]:
    result = []
    i = 1
    while i * i <= number:
        if number % i == 0:
            result.append(i)
            if number // i != i:
                result.append(number // i)
        i += 1
    return result


def _generate_minor_cycle_size(tasks: List[Task], periods: List[int], major_cycle_size: int) -> int:
    min_period = min(periods)
    initial_frame_candidates = [i for i in _factors(major_cycle_size) if i <= min_period]

    frame_candidates = []
    for f in initial_frame_candidates:
        valid = True
        for task in tasks:
            if 2 * f - np.gcd(task.period, f) > task.deadline:
                valid = False
                break
        if valid:
            frame_candidates.append(f)
    return max(frame_candidates)


def _get_ce_cycle_data(task_set: List[Task], metadata: TaskSetMetadata) -> Tuple[int, int, int]:
    major_cycle_size = int(np.ufunc.reduce(np.lcm, metadata.period_set))
    minor_cycle_size = int(_generate_minor_cycle_size(task_set, metadata.period_set, major_cycle_size))
    minor_cycle_count = int(major_cycle_size // minor_cycle_size)
    return major_cycle_size, minor_cycle_size, minor_cycle_count


def _get_minor_cycles(minor_cycle_size: int, minor_cycle_count: int, core_count: int) -> List[MinorCycle]:
    return [
        MinorCycle(
            id=i,
            start_time=i * minor_cycle_size,
            end_time=(i + 1) * minor_cycle_size,
            capacity=minor_cycle_size,
            job_container=JobContainer(
                max_capacity=minor_cycle_size * core_count
            )
        )
        for i in range(minor_cycle_count)
    ]


def _get_frames(minor_cycles: List[MinorCycle], core_count: int) -> List[Frame]:
    return [
        Frame(
            core_id=c,
            minor_cycle=mc,
            job_container=JobContainer(
                max_capacity=mc.capacity
            )
        )
        for mc in minor_cycles
        for c in range(core_count)
    ]


def _get_jobs(task_set: List[Task], major_cycle_size: int) -> List[Job]:
    jobs = [
        Job(
            task=t,
            id=i,
            release_time=i * t.period,
            deadline_time=(i * t.period) + t.deadline
        )
        for t in task_set
        for i in range(major_cycle_size // t.period)
    ]
    jobs.sort(key=lambda x: (x.task.criticality_level,
                             -1 * x.task.wcet_base_criticality,
                             -1 * x.task.wcet_own_criticality))
    return jobs


class IlpScheduler:
    name: str = "ilp"

    @classmethod
    def validate_task_set(cls, task_set: List[Task], metadata: TaskSetMetadata, solver_timeout: int = 60) -> Result:
        major_cycle_size, minor_cycle_size, minor_cycle_count = _get_ce_cycle_data(task_set, metadata)

        JobVar = namedtuple('JobVar', ['t_id', 'j_id', 'm_id', 'c_id', 'crit_level', 'wcet_own', 'wcet_base', 'lp_var'])

        jobs = {}
        frames = {}
        s_var = {}
        job_vars = []
        for m in range(minor_cycle_count):
            s_var[(m, -1)] = 0
            for cl in range(metadata.number_of_criticality_levels):
                s_var[(m, cl)] = pulp.LpVariable(f"S_{m}_{cl}", lowBound=0, upBound=minor_cycle_size, cat=pulp.LpInteger)
            for c in range(metadata.number_of_cores):
                frames[(m, c)] = []

        for t in task_set:
            for j in range(major_cycle_size // t.period):
                release_time = j * t.period
                deadline_time = (j * t.period) + t.deadline

                jobs[(t.id, j)] = []

                for m in range(minor_cycle_count):
                    if release_time <= m * minor_cycle_size and deadline_time >= (m + 1) * minor_cycle_size:
                        for c in range(metadata.number_of_cores):
                            job_var = JobVar(
                                t.id, j, m, c, t.criticality_level, t.wcet_own_criticality, t.wcet_base_criticality,
                                pulp.LpVariable(f"Job_{str(t.id)}_{str(j)}_{str(m)}_{str(c)}", cat=pulp.LpBinary)
                            )
                            frames[(m, c)].append(job_var)
                            jobs[(t.id, j)].append(job_var)
                            job_vars.append(job_var)

        problem = pulp.LpProblem()
        for cl in range(metadata.number_of_criticality_levels):
            for (m, c), job_var_list in frames.items():
                jv_list = []
                for j in job_var_list:
                    if j.crit_level == cl:
                        jv_list.append(j)
                problem += pulp.lpSum(j.lp_var * j.wcet_own for j in jv_list) <= minor_cycle_size - s_var[(m, cl - 1)]
                problem += pulp.lpSum(j.lp_var * j.wcet_base for j in jv_list) <= s_var[(m, cl)] - s_var[(m, cl - 1)]

        for jv_list in jobs.values():
            problem += pulp.lpSum(j.lp_var for j in jv_list) == 1

        status = problem.solve(pulp.PULP_CBC_CMD(maxSeconds=solver_timeout)) \
            if solver_timeout and solver_timeout > 0 \
            else problem.solve()

        if problem.solutionTime > 1:
            logging.info(f"status: {status}; time: {problem.solutionTime}")

        schedule = None

        if status == Result.SolutionStatus.SCHEDULABLE.value:
            schedule = McSchedule(
                scheduler=cls.name,
                periods=list(metadata.period_set),
                major_cycle_length=major_cycle_size,
                minor_cycle_length=minor_cycle_size,
                number_of_minor_cycles=minor_cycle_count,
                number_of_criticality_levels=metadata.number_of_criticality_levels,
                tasks={t.id: t for t in task_set},
                cores={c: McCore(
                    core=c,
                    frames={m: McFrame(
                        minor_cycle=m,
                        core=c,
                        start_time=m * minor_cycle_size,
                        end_time=(m + 1) * minor_cycle_size,
                        criticality_levels={cl: McCriticalityLevel(
                            criticality_level=cl,
                            switchover_time=int(s_var[(m, cl)].value())
                        ) for cl in range(metadata.number_of_criticality_levels)}
                    ) for m in range(minor_cycle_count)}
                ) for c in range(metadata.number_of_cores)}
            )

            for (m, c), job_var_list in frames.items():
                # 't_id', 'j_id', 'm_id', 'c_id', 'crit_level', 'wcet_own', 'wcet_base', 'lp_var'
                jv: JobVar
                for jv in job_var_list:
                    if jv.lp_var.roundedValue() == 1:
                        schedule.cores[c].frames[m].criticality_levels[jv.crit_level].jobs.append(McJob(
                            job_id=jv.j_id,
                            task_id=jv.t_id,
                            wcet_base=jv.wcet_base,
                            wcet_own=jv.wcet_own,
                            release_time=schedule.tasks[jv.t_id].period * jv.j_id,
                            deadline_time=(schedule.tasks[jv.t_id].period * jv.j_id)
                            + schedule.tasks[jv.t_id].deadline
                        ))

        return Result(solution_status=status, solution_time=problem.solutionTime, schedule=schedule)


class WfScheduler:
    name: str = "wf"

    @classmethod
    def validate_task_set(cls, task_set: List[Task], metadata: TaskSetMetadata) -> Result:
        start_time = datetime.now()
        major_cycle_size, minor_cycle_size, minor_cycle_count = _get_ce_cycle_data(task_set, metadata)
        jobs: List[Job] = _get_jobs(task_set, major_cycle_size)

        minor_cycles: List[MinorCycle] = _get_minor_cycles(
            minor_cycle_size,
            minor_cycle_count,
            metadata.number_of_cores
        )

        frames: List[Frame] = _get_frames(minor_cycles, metadata.number_of_cores)
        switchover_times: Dict[Tuple[int, int], int]
        try:
            WfScheduler._allocate_jobs_to_minor_cycles(jobs, minor_cycles, metadata.number_of_criticality_levels)
            switchover_times = WfScheduler._allocate_jobs_to_frames(minor_cycles, frames, metadata.number_of_criticality_levels)
        except JobContainerOverflowError as e:
            x = e
            runtime = datetime.now() - start_time
            return Result(Result.SolutionStatus.NOT_SCHEDULABLE, runtime.total_seconds())

        status = Result.SolutionStatus.SCHEDULABLE
        runtime = datetime.now() - start_time

        schedule = McSchedule(
            scheduler=cls.name,
            periods=list(metadata.period_set),
            major_cycle_length=major_cycle_size,
            minor_cycle_length=minor_cycle_size,
            number_of_minor_cycles=minor_cycle_count,
            number_of_criticality_levels=metadata.number_of_criticality_levels,
            tasks={t.id: t for t in task_set},
            cores={c: McCore(
                core=c,
                frames={m: McFrame(
                    minor_cycle=m,
                    core=c,
                    start_time=m * minor_cycle_size,
                    end_time=(m + 1) * minor_cycle_size,
                    criticality_levels={cl: McCriticalityLevel(
                        criticality_level=cl,
                        switchover_time=switchover_times[(m, cl)]
                    ) for cl in range(metadata.number_of_criticality_levels)}
                ) for m in range(minor_cycle_count)}
            ) for c in range(metadata.number_of_cores)}
        )

        for f in frames:
            for cl, jobs in f.job_container.jobs_at_crit_level.items():
                for j in jobs:
                    schedule.cores[f.core_id].frames[f.minor_cycle.id].criticality_levels[cl].jobs.append(McJob(
                        job_id=j.id,
                        task_id=j.task.id,
                        wcet_base=j.task.wcet_base_criticality,
                        wcet_own=j.task.wcet_own_criticality,
                        release_time=j.release_time,
                        deadline_time=j.deadline_time
                    ))

        return Result(solution_status=status, solution_time=runtime.total_seconds(), schedule=schedule)

    @staticmethod
    def _allocate_jobs_to_minor_cycles(jobs: List[Job], minor_cycles: List[MinorCycle], criticality_levels: int):
        jobs_at_crit_level: Dict[int, List[Job]] = defaultdict(list)
        for job in jobs:
            jobs_at_crit_level[job.task.criticality_level].append(job)
        for cl in range(criticality_levels):
            for job in jobs_at_crit_level[cl]:
                index = -1
                for i, mc in enumerate(minor_cycles):
                    if job.release_time <= mc.start_time and job.deadline_time >= mc.end_time:
                        if job.task.wcet_base_criticality > mc.job_container.remaining_space:
                            raise JobContainerOverflowError(
                                f"Job {job.name} with base wcet {str(job.task.wcet_base_criticality)}"
                                f" > MinorCycle name {mc.name}"
                                f" with capacity {str(mc.job_container.max_capacity)}"
                                f" and remaining space {str(mc.job_container.remaining_space)}"
                            )
                        index = i
                        break
                min_cycle: MinorCycle = minor_cycles.pop(index)
                min_cycle.job_container.insert_job(job)
                index = len(minor_cycles)
                for i, mc in enumerate(minor_cycles):
                    if min_cycle.job_container.remaining_space > mc.job_container.remaining_space:
                        index = i
                        break
                minor_cycles.insert(index, min_cycle)
        minor_cycles.sort(key=lambda x: x.id)

    @staticmethod
    def _allocate_jobs_to_frames(
            minor_cycles: List[MinorCycle],
            frames: List[Frame],
            criticality_levels: int
    ) -> Dict[Tuple[int, int], int]:
        minor_cycle_frames: Dict[int, List[Frame]] = defaultdict(list)
        switchover_times: Dict[Tuple[int, int], int] = defaultdict(int)
        for frame in frames:
            minor_cycle_frames[frame.minor_cycle.id].append(frame)
        for mc in minor_cycles:
            for cl in range(criticality_levels):
                for job in mc.job_container.jobs_at_crit_level[cl]:
                    index = -1
                    for i, f in enumerate(minor_cycle_frames[mc.id]):
                        if job.task.wcet_base_criticality > f.job_container.remaining_space:
                            break
                        if job.task.wcet_own_criticality <= f.job_container.own_crit_remaining_space:
                            index = i
                            break
                    if index == -1:
                        raise JobContainerOverflowError(
                            f"Job {job.name} with base wcet {str(job.task.wcet_base_criticality)}"
                            f" and own wcet {str(job.task.wcet_own_criticality)}"
                            f" does not fit in any frames"
                        )
                    frame: Frame = minor_cycle_frames[mc.id].pop(index)
                    frame.job_container.insert_job(job)
                    index = len(minor_cycle_frames[mc.id])
                    for i, f in enumerate(minor_cycle_frames[mc.id]):
                        if frame.job_container.remaining_space > f.job_container.remaining_space:
                            index = i
                            break
                    minor_cycle_frames[mc.id].insert(index, frame)
                fs = minor_cycle_frames[mc.id]
                min_cap_jc = fs[len(fs) - 1].job_container
                switchover_times[(mc.id, cl)] = min_cap_jc.max_capacity - min_cap_jc.remaining_space
                for frame in minor_cycle_frames[mc.id]:
                    frame.job_container.remaining_space = min_cap_jc.remaining_space
                    frame.job_container.own_crit_remaining_space = min_cap_jc.remaining_space
            minor_cycle_frames[mc.id].sort(key=lambda x: x.core_id)
        return switchover_times


class FfbbScheduler:
    name: str = "ffbb"

    @classmethod
    def validate_task_set(cls, task_set: List[Task], metadata: TaskSetMetadata) -> Result:
        start_time = datetime.now()
        major_cycle_size, minor_cycle_size, minor_cycle_count = _get_ce_cycle_data(task_set, metadata)
        jobs: List[Job] = _get_jobs(task_set, major_cycle_size)

        minor_cycles: List[MinorCycle] = _get_minor_cycles(
            minor_cycle_size,
            minor_cycle_count,
            metadata.number_of_cores
        )

        frames: List[Frame] = _get_frames(minor_cycles, metadata.number_of_cores)
        switchover_times: Dict[Tuple[int, int], int]
        try:
            FfbbScheduler._allocate_jobs_to_minor_cycles(jobs, minor_cycles, metadata.number_of_criticality_levels)
            switchover_times = FfbbScheduler._allocate_jobs_to_frames(minor_cycles, frames,
                                                                      metadata.number_of_criticality_levels)
        except FfbbJobAssignmentError as e:
            x = e
            runtime = datetime.now() - start_time
            return Result(Result.SolutionStatus.NOT_SCHEDULABLE, runtime.total_seconds())

        status = Result.SolutionStatus.SCHEDULABLE
        runtime = datetime.now() - start_time

        schedule = McSchedule(
            scheduler=cls.name,
            periods=list(metadata.period_set),
            major_cycle_length=major_cycle_size,
            minor_cycle_length=minor_cycle_size,
            number_of_minor_cycles=minor_cycle_count,
            number_of_criticality_levels=metadata.number_of_criticality_levels,
            tasks={t.id: t for t in task_set},
            cores={c: McCore(
                core=c,
                frames={m: McFrame(
                    minor_cycle=m,
                    core=c,
                    start_time=m * minor_cycle_size,
                    end_time=(m + 1) * minor_cycle_size,
                    criticality_levels={cl: McCriticalityLevel(
                        criticality_level=cl,
                        switchover_time=switchover_times[(m, cl)]
                    ) for cl in range(metadata.number_of_criticality_levels)}
                ) for m in range(minor_cycle_count)}
            ) for c in range(metadata.number_of_cores)}
        )

        for f in frames:
            for cl, jobs in f.minor_cycle.job_container.jobs_at_crit_level.items():
                for j in jobs:
                    schedule.cores[f.core_id].frames[f.minor_cycle.id].criticality_levels[cl].jobs.append(McJob(
                        job_id=j.id,
                        task_id=j.task.id,
                        wcet_base=j.task.wcet_base_criticality,
                        wcet_own=j.task.wcet_own_criticality,
                        release_time=j.release_time,
                        deadline_time=j.deadline_time
                    ))

        return Result(solution_status=status, solution_time=runtime.total_seconds(), schedule=schedule)

    @staticmethod
    def _allocate_jobs_to_minor_cycles(jobs: List[Job], minor_cycles: List[MinorCycle], criticality_levels: int):
        jobs_at_crit_level: Dict[int, List[Job]] = defaultdict(list)
        for job in jobs:
            jobs_at_crit_level[job.task.criticality_level].append(job)
        for cl in range(criticality_levels):
            job_bins: List[JobBin] = [JobBin(max_capacity=mc.job_container.remaining_space) for mc in minor_cycles]
            job_bins = FfbbScheduler._first_fit_branch_and_bound(jobs_at_crit_level[cl], job_bins)
            for i, jb in enumerate(job_bins):
                for j in jb.jobs:
                    minor_cycles[i].job_container.insert_job(j)

    @staticmethod
    def _allocate_jobs_to_frames(
            minor_cycles: List[MinorCycle],
            frames: List[Frame],
            criticality_levels: int
    ) -> Dict[Tuple[int, int], int]:
        minor_cycle_frames: Dict[int, List[Frame]] = defaultdict(list)
        switchover_times: Dict[Tuple[int, int], int] = defaultdict(int)
        for frame in frames:
            minor_cycle_frames[frame.minor_cycle.id].append(frame)
        frame_max_capacity = frames[0].job_container.max_capacity
        for mc in minor_cycles:
            fs = minor_cycle_frames[mc.id]
            for cl in range(criticality_levels):
                job_bins = [JobBin(f.job_container.remaining_space) for f in fs]
                job_bins = FfbbScheduler._first_fit_branch_and_bound(mc.job_container.jobs_at_crit_level[cl], job_bins)
                for i, jb in enumerate(job_bins):
                    for j in jb.jobs:
                        fs[i].job_container.insert_job(j)
                min_remaining_space = min([f.job_container.remaining_space for f in fs])

                switchover_times[(mc.id, cl)] = frame_max_capacity - min_remaining_space
                for frame in minor_cycle_frames[mc.id]:
                    frame.job_container.remaining_space = min_remaining_space
                    frame.job_container.own_crit_remaining_space = min_remaining_space
            minor_cycle_frames[mc.id].sort(key=lambda x: x.core_id)
        return switchover_times

    @staticmethod
    def _first_fit_branch_and_bound(jobs: List[Job], job_bins: List[JobBin]) -> List[JobBin]:
        u_list: List[Job] = []
        j_bins = copy.deepcopy(job_bins)
        for job in jobs:
            unassigned = True
            for jb in j_bins:
                if job.task.wcet_base_criticality <= jb.bound_remaining \
                        and job.task.wcet_own_criticality <= jb.max_remaining:
                    jb.insert_job(job)
                    unassigned = False
                    break
            if unassigned:
                u_list.append(job)
        best_job_bins: List[JobBin] = j_bins if len(u_list) == 0 else None
        s_max = max([jb.get_switchover_point() for jb in j_bins]) if best_job_bins else j_bins[0].max_capacity
        s_min = min([jb.get_switchover_point() for jb in j_bins])

        while s_max > s_min:
            u_list: List[Job] = []
            j_bins = copy.deepcopy(job_bins)
            for jb in j_bins:
                jb.set_bound(s_max)
            for job in jobs:
                unassigned = True
                for jb in j_bins:
                    if job.task.wcet_base_criticality <= jb.bound_remaining \
                            and job.task.wcet_own_criticality <= jb.max_remaining:
                        jb.insert_job(job)
                        unassigned = False
                        break
                if unassigned:
                    u_list.append(job)
            if len(u_list) == 0:
                best_job_bins = j_bins
            s_max -= 1

        if best_job_bins is None:
            raise FfbbJobAssignmentError(f"Unable to assign jobs to job_bins")
        return best_job_bins
