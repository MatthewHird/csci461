import logging
from collections import defaultdict

import networkx as nx
import numpy as np

from typing import Dict, Tuple, Sequence, List
from src.model.task import Task
from src.model.frame import Frame
from src.model.job import Job


class CeSchedGen:
    def __init__(self, tasks: List[Task]):
        self.tasks = tasks
        self.periods = [i.period for i in self.tasks]
        self.deadlines = [i.deadline for i in self.tasks]

    def run(self):
        gcd = np.ufunc.reduce(np.gcd, self.periods)
        major_cycle = np.ufunc.reduce(np.lcm, self.periods)
        min_deadline = min(self.deadlines)
        min_period = min(self.periods)
        frame_cand = [i for i in self.__factors(major_cycle) if i <= min_period]

        frame_size = self.__get_frame_size_from_candidates(frame_cand)
        frame_count = major_cycle // frame_size

        frames = [
            Frame(id=i, name=f'F{i + 1}', start_time=i * frame_size, end_time=(i + 1) * frame_size, capacity=frame_size)
            for i in range(frame_count)
        ]

        jobs = []
        for t in self.tasks:
            for j in range(major_cycle // t.period):
                jobs.append(Job(
                    task_id=t.id,
                    id=j + 1,
                    name=f'J{t.id}-{j + 1}',
                    release_time=j * t.period,
                    deadline=(j * t.period) + t.deadline,
                    wcet=t.wcet
                ))

        edges = [(f.name, 'sink', {'capacity': f.capacity}) for f in frames]

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
            for t in self.tasks:
                task_row_frame = f"{'':<{f_total_time}}" if f_total_time else ""
                if frame_task_contents.get(f.name) and frame_task_contents.get(f.name).get(t.id):
                    j_id = frame_task_contents.get(f.name).get(t.id)[0]
                    t_time_units = frame_task_contents.get(f.name).get(t.id)[1]
                    f_total_time += t_time_units
                    task_row_frame += f"{'':{str(j_id)[-1]}<{t_time_units}}"
                task_row[t.id].append(f"{task_row_frame:{f.capacity}}")
            time_row.append(f"{'+':->{f.capacity}}")

        file.write(f"{'':=<10}+{''.join(time_row)}\n")
        for t in self.tasks:
            file.write(f"{t.name:10}|{''.join(task_row[t.id])}\n")
        file.write(f"{'':=<10}+{''.join(time_row)}\n")

        file.close()

        return

    def run_interactive(self):
        pass

    def __get_frame_size_from_candidates(self, frame_candidates: List[int]) -> int:
        frame_size = 1
        for f in frame_candidates:
            valid = True
            for task in self.tasks:
                if 2 * f - np.gcd(task.period, f) > task.deadline:
                    valid = False
                    break
            if valid:
                frame_size = max(f, frame_size)
        return frame_size

    @staticmethod
    def __get_frame_job_contents_from_flow_dict(flow_dict: dict, jobs: List[Job]):
        flipped = defaultdict(dict)
        for j in jobs:
            for frame, capacity in flow_dict[j.name].items():
                if capacity > 0:
                    flipped[frame][j.name] = capacity
        return flipped

    @staticmethod
    def __get_frame_task_contents_from_flow_dict(flow_dict: dict, jobs: List[Job]):
        flipped = defaultdict(dict)
        for j in jobs:
            for frame, capacity in flow_dict[j.name].items():
                if capacity > 0:
                    flipped[frame][j.task_id] = (j.id, capacity)
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
    app = CeSchedGen(tasks=[Task(1, 'T1', 0, 4, 1, 4), Task(2, 'T2', 0, 5, 2, 5), Task(3, 'T3', 0, 20, 5, 20)])
    # app = CeSchedGen(tasks=[Task(1, 'T1', 0, 14, 1, 14), Task(2, 'T2', 0, 20, 2, 20), Task(3, 'T3', 0, 22, 3, 22)])
    app.run()
