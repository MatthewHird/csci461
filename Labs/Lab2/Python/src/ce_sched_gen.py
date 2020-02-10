import logging
from collections import defaultdict
from datetime import timedelta

import numpy as np

from typing import Dict, Tuple, List

from src.model.settings import Settings
from src.settings_importer_exporter import SettingsImporterExporter
from src.model.task import Task
from src.model.job import Job
from src.model.static_data import StaticData
from src.model.schedule_layout import ScheduleLayout
from src.my_exceptions import CounterMaxError
from src.schedule_exporter import ScheduleExporter
from src.schedule_maker import ScheduleMaker
from src.model.schedule import Schedule
from src.schedule_validator import ScheduleValidator


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


def _initialize_jobs(tasks: List[Task], major_cycle: int) -> Tuple[int, Dict[str, Job]]:
    jobs = {}
    total_wcet = 0
    for t in tasks:
        total_wcet += (t.wcet * major_cycle // t.period)
        for j in range(major_cycle // t.period):
            jobs[f"J{t.index}-{j + 1}"] = Job(
                task=t,
                index=j + 1,
                release_time=j * t.period,
                deadline=(j * t.period) + t.deadline,
                wcet=t.wcet
            )
    return total_wcet, jobs


def _initialize_frame_candidates(tasks: List[Task], periods: List[int], major_cycle: int) -> List[int]:
    min_period = min(periods)
    initial_frame_candidates = [i for i in _factors(major_cycle) if i <= min_period]

    frame_candidates = []
    for f in initial_frame_candidates:
        valid = True
        for task in tasks:
            if 2 * f - np.gcd(task.period, f) > task.deadline:
                valid = False
                break
        if valid:
            frame_candidates.append(f)
    frame_candidates.sort(reverse=True)
    return frame_candidates


def _initialize_source_edges(jobs: Dict[str, Job]) -> List[Tuple[str, str, dict]]:
    return [('source', j.name, {'capacity': j.wcet}) for j in jobs.values()]


def _get_frame_job_contents_from_flow_dict(flow_dict: dict, jobs: List[Job]) -> dict:
    flipped = defaultdict(dict)
    for j in jobs:
        for frame, capacity in flow_dict[j.name].items():
            if capacity > 0:
                flipped[frame][j.name] = capacity
    return flipped


def _get_frame_task_contents_from_flow_dict(flow_dict: dict, jobs: List[Job]) -> dict:
    flipped = defaultdict(dict)
    for j in jobs:
        for frame, capacity in flow_dict[j.name].items():
            if capacity > 0:
                flipped[frame][j.task.index] = (j.index, capacity)
    return flipped


class CeSchedGen:
    def __init__(self, tasks: List[Task]):
        periods = [i.period for i in tasks]
        deadlines = [i.deadline for i in tasks]
        major_cycle = np.ufunc.reduce(np.lcm, periods)
        total_wcet, jobs = _initialize_jobs(tasks, major_cycle)
        source_edges = _initialize_source_edges(jobs)
        self.frame_candidates: List[int] = _initialize_frame_candidates(tasks, periods, major_cycle)
        self.static_data: StaticData = StaticData(
            tasks=tasks, periods=periods, deadlines=deadlines, total_wcet=total_wcet,
            major_cycle=major_cycle, jobs=jobs, source_edges=source_edges
        )

    def run(self, settings: Settings):
        found_valid_schedule = False

        # SettingsImporterExporter.export_settings_file(settings, "../resources/output/json_test1.txt")
        # settings = SettingsImporterExporter.import_settings_file("../resources/input/json_test2.txt")

        frame_candidates = self.frame_candidates
        logging.info(f"Major cycle length: {self.static_data.major_cycle}..."
                     f"Candidate frame sizes are {frame_candidates}...")

        condition_set_count: int

        if settings.schedule_parameters.condition_sets and len(settings.schedule_parameters.condition_sets) > 0:
            condition_set_count = len(settings.schedule_parameters.condition_sets)
            logging.info(f"{condition_set_count} condition sets found in settings...")
            condition_sets = settings.schedule_parameters.condition_sets
        else:
            condition_set_count = 1
            logging.info(f"No condition sets found in settings. Using default condition set...")
            condition_sets = [Settings.ScheduleParameters.ConditionSet()]

        condition_set: Settings.ScheduleParameters.ConditionSet
        for i, condition_set in enumerate(condition_sets):
            cs_name = f"CS-{i + 1}"
            logging.info(f"Starting condition set # {i + 1} of {condition_set_count} ({cs_name})")

            if not condition_set.frame_size:
                frame_size = max(frame_candidates)
                logging.info(f"No frame size in {cs_name}. Frame size set"
                             f" to {frame_size} (max of frame size candidates)...")
            elif condition_set.frame_size in frame_candidates:
                frame_size = condition_set.frame_size
                logging.info(f"Frame size set to {frame_size} by {cs_name}...")
            else:
                logging.warning(f"Frame size {condition_set.frame_size} not in frame size candidates"
                                f" {tuple(frame_candidates)}. Skipping condition set {cs_name}...")
                continue

            max_parts_dict = {}

            if condition_set.task_max_parts and len(condition_set.task_max_parts) > 0:
                logging.info(f"Maximum number of partitions for Tasks: {condition_set.task_max_parts}")
                for tmp in condition_set.task_max_parts:
                    if tmp[0] in self.static_data.tasks:
                        for j in self.static_data.jobs.values():
                            if j.task.name == tmp[0]:
                                max_parts_dict[j.name] = tmp[1]
            else:
                logging.info(f"No restrictions on number of partitions for Tasks in {cs_name}...")

            if condition_set.job_max_parts and len(condition_set.job_max_parts) > 0:
                logging.info(f"Maximum number of partitions for Jobs: {condition_set.job_max_parts}")
                for jmp in condition_set.job_max_parts:
                    if jmp[0] in self.static_data.jobs:
                        max_parts_dict[jmp[0]] = jmp[1]
            else:
                logging.info(f"No restrictions on number of partitions for Jobs in {cs_name}...")

            logging.info(f"Generating schedules for frame size = {frame_size}...")
            schedule_layout = ScheduleLayout(self.static_data, frame_size)
            schedule_maker = ScheduleMaker.from_schedule_layout(schedule_layout)
            schedule: Schedule

            initial_schedule = schedule_maker.create_schedule_any(
                condition_set.job_frame_usage_edges if condition_set.job_frame_usage_edges else []
            )
            if not initial_schedule.is_valid():
                logging.info(f"No valid schedules exist for {cs_name}...")
                continue

            combination_count, job_combinations = schedule_maker.get_combinations(condition_set.job_frame_usage_edges)

            print(
                f"The worst case number of combinations of job-frame edges is "
                f"{combination_count} ({combination_count:.2E}).\n\n"
                f"Depending on cpu speed and the number of jobs and tasks, "
                f"generating this schedule could take \nupwards"
                f" of {str(timedelta(seconds=(2 * combination_count // 1000)))} (hh:mm:ss) on an average pc, and "
                f"upwards of {str(timedelta(seconds=(10 * combination_count // 1000)))} (hh:mm:ss) on a slow pc.\n\n"
                f"Would you like to continue?\n"
                f"    Y (yes) to continue, N (no) to exit program, S (skip) to skip to the next condition set."
            )

            while True:
                response = input(">>>  ").strip().lower()
                if response.startswith(("y", "n", "s")):
                    break

            if response.startswith("n"):
                break
            elif response.startswith("s"):
                continue
            else:  # response.startswith("y")
                pass

            try:
                schedule = schedule_maker.recursively_generate_schedules(
                    list(job_combinations.values()),
                    [],
                    condition_set.job_frame_usage_edges,
                    max_parts_dict,
                    settings.iteration_counter.counter_max,
                    settings.iteration_counter.print_counter_every
                )
            except CounterMaxError as e:
                logging.info(f"{e.message}...Continuing to next condition set...")
                continue

            if ScheduleValidator.is_schedule_valid(schedule=schedule, job_max_parts_dict=max_parts_dict):
                found_valid_schedule = True
                logging.info(f"Valid schedule found for condition set # {i + 1}...Outputting schedule...")
                if settings.output.schedule_table.print_table or settings.output.schedule_table.table_out_file_path:
                    ScheduleExporter.schedule_to_table(
                        schedule,
                        settings.output.schedule_table.print_table,
                        settings.output.schedule_table.table_out_file_path,
                        settings.output.schedule_table.space_frames
                    )
                if (settings.output.schedule_timeline.print_timeline
                        or settings.output.schedule_timeline.timeline_out_file_path):
                    ScheduleExporter.schedule_to_timeline(
                        schedule,
                        settings.output.schedule_timeline.print_timeline,
                        settings.output.schedule_timeline.timeline_out_file_path
                    )
                if settings.output.schedule_json.print_json or settings.output.schedule_json.json_out_file_path:
                    ScheduleExporter.schedule_to_json(
                        schedule,
                        settings.output.schedule_json.print_json,
                        settings.output.schedule_json.json_out_file_path
                    )
                break
            else:
                logging.info(f"No valid schedule found for {cs_name}...Continuing to next condition set...")

        if found_valid_schedule:
            pass
        else:
            logging.info(f"No valid schedule found for any of {condition_set_count} condition sets...")
        logging.info(f"Exiting program...")




if __name__ == '__main__':
    log_level = 'INFO'
    logging.basicConfig(format='%(asctime)s - %(levelname)s - %(message)s', level=log_level)
    # app = CeSchedGen(tasks=[Task(1, 4, 1, 4), Task(2, 5, 2, 5)])
    # app = CeSchedGen(tasks=[Task(1, 4, 1, 4), Task(2, 5, 2, 5), Task(3, 20, 2, 20)])
    # app = CeSchedGen(tasks=[Task(1, 4, 1, 4), Task(2, 5, 2, 5), Task(3, 20, 3, 20)])
    app = CeSchedGen(tasks=[Task(1, 4, 1, 4), Task(2, 5, 2, 5), Task(3, 20, 4, 20)])
    # app = CeSchedGen(tasks=[Task(1, 14, 1, 14), Task(2, 20, 2, 20), Task(3, 22, 3, 22)])
    # app.run(Settings(print_counter_every=10, counter_max=2000, job_frame_usage_edges=[("J3-1", "F8", 2)]))
    # app.run(Settings(print_counter_every=100, out_file_path='../resources/output/test3.txt', job_frame_usage_edges=[("J3-1", "F8", 2)]))
    # app.run(Settings(print_counter_every=100, export_table=True, table_out_file_path='../resources/output/test3.txt', frame_size=2, job_frame_usage_edges=[("J3-1", "F8", 2), ("J1-1", "F1", 1), ("J2-1", "F2", 2), ("J1-4", "F7", 1)]))
    # app.run(Settings(print_counter_every=100, export_table=True, table_space_frames=True, table_out_file_path='../resources/output/test3.txt', frame_size=2, job_frame_usage_edges=[("J3-1", "F8", 2)]))
    app.run(None)
