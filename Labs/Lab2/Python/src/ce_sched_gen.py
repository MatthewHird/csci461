import logging
from collections import defaultdict
from itertools import combinations

import networkx as nx
import numpy as np

from typing import Dict, Tuple, Sequence, List

from src.model.base_frame import BaseFrame
from src.model.task import Task
from src.model.frame import Frame
from src.model.job import Job
from src.model.static_data import StaticData
from src.model.schedule_layout import ScheduleLayout
from src.schedule_maker import ScheduleMaker
from src.model.schedule import Schedule


class CeSchedGen:
    def __init__(self, tasks: List[Task]):
        periods = [i.period for i in tasks]
        deadlines = [i.deadline for i in tasks]
        major_cycle = np.ufunc.reduce(np.lcm, periods)
        total_wcet, jobs = self.__initialize_jobs(tasks, major_cycle)
        source_edges = self.__initialize_source_edges(jobs)
        self.frame_candidates: List[int] = self.__initialize_frame_candidates(tasks=tasks, periods=periods, major_cycle=major_cycle)
        self.static_data: StaticData = StaticData(
            tasks=tasks, periods=periods, deadlines=deadlines, total_wcet=total_wcet,
            major_cycle=major_cycle, jobs=jobs, source_edges=source_edges
        )

    def test(self):
        frame_size = max(self.frame_candidates)
        schedule_layout = ScheduleLayout(self.static_data, frame_size)
        schedule_maker = ScheduleMaker.from_schedule_layout(schedule_layout)
        test_schedule: Schedule = schedule_maker.create_schedule_test()
        x = 1

    def run(self):
        for frame_size in self.frame_candidates:
            schedule_layout = ScheduleLayout(self.static_data, frame_size)
            schedule_maker = ScheduleMaker.from_schedule_layout(schedule_layout)
            test_schedule: Schedule = schedule_maker.create_schedule_test()
        
    def run_2(self):
        gcd = np.ufunc.reduce(np.gcd, self.static_data.periods)
        min_deadline = min(self.static_data.deadlines)
        min_period = min(self.static_data.periods)

        frame_size = max(self.frame_candidates)
        frame_count = self.static_data.major_cycle // frame_size

        frames = [
            BaseFrame(id=i, start_time=i * frame_size, end_time=(i + 1) * frame_size, capacity=frame_size)
            for i in range(frame_count)
        ]

        sink_edges = [(f.name, 'sink', {'capacity': f.capacity}) for f in frames]

        edges = [(f.name, 'sink', {'capacity': f.capacity}) for f in frames]

        jobs = self.static_data.jobs
        for j in jobs:
            edges.append(('source', j.name, {'capacity': j.wcet}))
            for f in frames:
                if j.release_time <= f.start_time and j.deadline >= f.end_time:
                    edges.append((j.name, f.name, {'capacity': j.wcet}))

        g = nx.DiGraph()
        g.add_edges_from(edges)

        flow_value, flow_dict = nx.maximum_flow(g, 'source', 'sink')

        frame_contents = self.__get_frame_job_contents_from_flow_dict(flow_dict, jobs)

        file = open("../resources/output/test1.txt", "w")
        file.write(
            f"{'Job Name':10}{'Time':6}{'To Frame':10}{'% of Frame':12}{'Frame Completion':18}{'Job Completion':16}\n"
            f"{'========':10}{'====':6}{'========':10}{'==========':12}{'================':18}{'==============':16}\n"
        )

        job_completion = defaultdict(int)
        for f in frames:
            f_total_time = 0
            for j in jobs:
                if frame_contents.get(f.name) and frame_contents.get(f.name).get(j.name):
                    j_time_units = frame_contents.get(f.name).get(j.name)
                    f_total_time += j_time_units
                    j_total_time = job_completion[j.name] + j_time_units
                    job_completion[j.name] = j_total_time % j.wcet
                    file.write(
                        f"{j.name:10}{j_time_units:<6}{f.name:10}{'':2}{j_time_units / f.capacity * 100:5.1f}"
                        f"{'':5}{f_total_time:6} of {f.capacity:<6}{'':2}{j_total_time:5} of {j.wcet:<5}{'':2}\n"
                    )
        file.close()

        file = open("../resources/output/test2.txt", "w")

        time_row = []
        frame_task_contents = self.__get_frame_task_contents_from_flow_dict(flow_dict, jobs)

        task_row = defaultdict(list)
        for f in frames:
            f_total_time = 0
            for t in self.static_data.tasks:
                task_row_frame = f"{'':<{f_total_time}}" if f_total_time else ""
                if frame_task_contents.get(f.name) and frame_task_contents.get(f.name).get(t.index):
                    j_id = frame_task_contents.get(f.name).get(t.index)[0]
                    t_time_units = frame_task_contents.get(f.name).get(t.index)[1]
                    f_total_time += t_time_units
                    task_row_frame += f"{'':{str(j_id)[-1]}<{t_time_units}}"
                task_row[t.index].append(f"{task_row_frame:{f.capacity}}")
            time_row.append(f"{'+':->{f.capacity}}")

        file.write(f"{'':=<10}+{''.join(time_row)}\n")
        for t in self.static_data.tasks:
            file.write(f"{t.name:10}|{''.join(task_row[t.index])}\n")
        file.write(f"{'':=<10}+{''.join(time_row)}\n")

        file.close()

        return

    def run_interactive(self):
        pass

    @staticmethod
    def __initialize_jobs(tasks: List[Task], major_cycle: int) -> Tuple[int, Dict[str, Job]]:
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

    def __initialize_frame_candidates(self, tasks: List[Task], periods: List[int], major_cycle: int) -> List[int]:
        min_period = min(periods)
        initial_frame_candidates = [i for i in self.__factors(major_cycle) if i <= min_period]

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

    @staticmethod
    def __initialize_source_edges(jobs: Dict[str, Job]) -> List[Tuple[str, str, dict]]:
        return [('source', j.name, {'capacity': j.wcet}) for j in jobs.values()]

    @staticmethod
    def __get_frame_job_contents_from_flow_dict(flow_dict: dict, jobs: List[Job]) -> dict:
        flipped = defaultdict(dict)
        for j in jobs:
            for frame, capacity in flow_dict[j.name].items():
                if capacity > 0:
                    flipped[frame][j.name] = capacity
        return flipped

    @staticmethod
    def __get_frame_task_contents_from_flow_dict(flow_dict: dict, jobs: List[Job]) -> dict:
        flipped = defaultdict(dict)
        for j in jobs:
            for frame, capacity in flow_dict[j.name].items():
                if capacity > 0:
                    flipped[frame][j.task.index] = (j.index, capacity)
        return flipped

    @staticmethod
    def __factors(number: int) -> List[int]:
        result = []
        i = 1
        while i * i <= number:
            if number % i == 0:
                result.append(i)
                if number // i != i:
                    result.append(number // i)
            i += 1
        return result


if __name__ == '__main__':
    app = CeSchedGen(tasks=[Task(1, 0, 4, 1, 4), Task(2, 0, 5, 2, 5)])
    # app = CeSchedGen(tasks=[Task(1, 0, 4, 1, 4), Task(2, 0, 5, 2, 5), Task(3, 0, 20, 2, 20)])
    # app = CeSchedGen(tasks=[Task(1, 0, 4, 1, 4), Task(2, 0, 5, 2, 5), Task(3, 0, 20, 5, 20)])
    # app = CeSchedGen(tasks=[Task(1, 0, 14, 1, 14), Task(2, 0, 20, 2, 20), Task(3, 0, 22, 3, 22)])
    app.test()
