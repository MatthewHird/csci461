from typing import List, Set
from collections import namedtuple
import logging

import pulp

import numpy as np

from shared.model.task import Task
from shared.model.job import Job


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


def _generate_minor_cycle_size(tasks: List[Task], periods: List[int], major_cycle_size: int) -> List[int]:
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


class MultiCoreCeScheduler:
    @staticmethod
    def is_valid_task_set(
            task_set: List[Task],
            periods: List[int],
            core_count: int,
            solver_timeout: int,
            set_name: str = None
    ) -> bool:
        major_cycle_size = np.ufunc.reduce(np.lcm, periods)
        minor_cycle_size: List[int] = _generate_minor_cycle_size(task_set, periods, major_cycle_size)
        minor_cycle_count = major_cycle_size // minor_cycle_size

        JobVar = namedtuple('JobVar', ['t_id', 'j_id', 'm_id', 'c_id', 'wcet', 'lp_var'])

        jobs = {}
        frames = {}
        job_vars = []
        for m in range(minor_cycle_count):
            for c in range(core_count):
                frames[(m, c)] = []

        for t in task_set:
            for j in range(major_cycle_size // t.period):
                release_time = j * t.period,
                deadline_time = (j * t.period) + t.deadline,
                wcet = t.wcet_base_criticality

                jobs[(t.id, j)] = []

                for m in range(minor_cycle_count):
                    if release_time <= m * minor_cycle_size and deadline_time >= (m + 1) * minor_cycle_size:
                        for c in range(core_count):
                            job_var = JobVar(t.id, j, m, c, wcet, pulp.LpVariable(f"Test_{str(t.id)}_{str(j)}_{str(m)}_{str(c)}", cat=pulp.LpBinary))
                            frames[(m, c)].append(job_var)
                            jobs[(t.id, j)].append(job_var)
                            job_vars.append(job_var)

        problem = pulp.LpProblem()
        for jv_list in frames.values():
            problem += pulp.lpSum(j.lp_var * j.wcet for j in jv_list) <= minor_cycle_size

        for jv_list in jobs.values():
            problem += pulp.lpSum(j.lp_var for j in jv_list) == 1

        problem.solve(pulp.PULP_CBC_CMD(maxSeconds=solver_timeout))
        if problem.solutionTime > 1:
            logging.info(f"TaskSet: {set_name}; SolTime: {str(problem.solutionTime)}; SolStatus: {str(problem.status)}")

        return problem.status > 0
