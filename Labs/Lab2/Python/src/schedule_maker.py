import attr
from typing import List, Tuple, Dict

import logging
from collections import defaultdict
from itertools import combinations

import networkx as nx
import numpy as np

from src.model.base_frame import BaseFrame
from src.model.frame import Frame
from src.model.job import Job
from src.model.task import Task
from src.model.job_fragment import JobFragment
from src.model.schedule import Schedule
from src.model.schedule_layout import ScheduleLayout


@attr.s
class ScheduleMaker:
    tasks: List[Task] = attr.ib()
    periods: List[int] = attr.ib()
    deadlines: List[int] = attr.ib()
    major_cycle: int = attr.ib()
    jobs: Dict[str, Job] = attr.ib()
    source_edges: List[Tuple[str, str, dict]] = attr.ib()
    total_wcet: int = attr.ib()

    base_frames: Dict[str, BaseFrame] = attr.ib()
    sink_edges: List[Tuple[str, str, dict]] = attr.ib()

    counter: int = attr.ib(default=0)

    @classmethod
    def from_schedule_layout(cls, schedule_layout: ScheduleLayout):
        return cls(
            tasks=schedule_layout.static_data.tasks,
            periods=schedule_layout.static_data.periods,
            deadlines=schedule_layout.static_data.deadlines,
            major_cycle=schedule_layout.static_data.major_cycle,
            jobs=schedule_layout.static_data.jobs,
            source_edges=schedule_layout.static_data.source_edges,
            total_wcet=schedule_layout.static_data.total_wcet,
            base_frames=schedule_layout.base_frames,
            sink_edges=schedule_layout.sink_edges
        )

    def create_schedule_test(self) -> Schedule:
        job_combinations: Dict[str, List[tuple]] = self.__get_combinations()
        schedule: Schedule = self.__recursive(list(job_combinations.values()), [], [])
        # schedule: Schedule = self.__recursive(list(job_combinations.values()), [], [("J3-1", "F8", 2)])
        x=1

    def __recursive(self, job_combination_list: List[tuple], currently_included: List[tuple],
                    job_frame_usage_edges: List[Tuple[str, str, int]]) -> Schedule:
        schedule: Schedule = None
        if len(job_combination_list) == 0:
            if self.counter % 10 == 0:
                print(self.counter)
            self.counter += 1
            if self.counter == 1040:
                x=1
            schedule = self.create_schedule_single(currently_included, job_frame_usage_edges)
        else:
            job_combo_tuple_list = list(job_combination_list.pop(0))
            for job_combo_tuple in job_combo_tuple_list:
                job_combination_list_copy = job_combination_list.copy()
                schedule = self.__recursive(job_combination_list_copy, currently_included + list(job_combo_tuple), job_frame_usage_edges)
                if self.__is_schedule_valid(schedule, None):
                    break
        return schedule

    def __is_schedule_valid(self, schedule: Schedule, conditions) -> bool:
        if schedule is None:
            return False
        return schedule.is_valid()

    def create_schedule_test_2(self) -> Schedule:
        capacity_edges = []
        for j in self.jobs.values():
            for f in self.base_frames.values():
                if j.release_time <= f.start_time and j.deadline >= f.end_time:
                    capacity_edges.append((j.name, f.name))

        return self.create_schedule_single(capacity_edges, [("J3-1", "F8", 2)])

    def create_schedule_any(self, job_frame_usage_edges: List[Tuple[Job, str, int]]) -> Schedule:
        capacity_edges = []
        for j in self.jobs.values():
            for f in self.base_frames.values():
                if j.release_time <= f.start_time and j.deadline >= f.end_time:
                    capacity_edges.append((j.name, f.name))

        return self.create_schedule_single(capacity_edges, job_frame_usage_edges)

    def create_schedule_single(self, job_frame_capacity_edges: List[Tuple[str, str]],
                               job_frame_usage_edges: List[Tuple[str, str, int]]) -> Schedule:
        job_time_capacity: Dict[str, int] = {j.name: j.wcet for j in self.jobs.values()}
        frame_capacity: Dict[str, int] = {f.name: f.capacity for f in self.base_frames.values()}
        used_time = 0
        for u_edge in job_frame_usage_edges:
            job_time_capacity[u_edge[0]] -= u_edge[2]
            frame_capacity[u_edge[1]] -= u_edge[2]
            used_time += u_edge[2]

        g = nx.DiGraph()
        g.add_edges_from(self.source_edges)
        g.add_edges_from(self.sink_edges)

        for c_edge in job_frame_capacity_edges:
            g.add_edge(c_edge[0], c_edge[1], capacity=job_time_capacity[c_edge[0]])

        for u_edge in job_frame_usage_edges:
            g.add_edge('source', u_edge[0], capacity=job_time_capacity[u_edge[0]])
            g.add_edge(u_edge[1], 'sink', capacity=frame_capacity[u_edge[1]])

        flow_value, flow_dict = nx.maximum_flow(g, 'source', 'sink')

        frames = {bf.name: Frame(bf) for bf in self.base_frames.values()}
        job_fragments = []

        frame_job_timings = defaultdict(int)

        # {j.name: {f.name: time_value}}
        for job_name, frame_dict in flow_dict.items():
            if job_name in self.jobs:
                for frame_name, time_value in frame_dict.items():
                    if frame_name in self.base_frames and time_value > 0:
                        frame = frames[frame_name]
                        start_time = frame.base_frame.start_time + frame_job_timings[frame_name]
                        frame_job_timings[frame_name] += time_value
                        end_time = start_time + time_value
                        job_fragment = JobFragment(
                            start_time=start_time,
                            end_time=end_time,
                            time_units=time_value,
                            job=self.jobs[job_name]
                        )
                        frame.job_fragments.append(job_fragment)
                        job_fragments.append(job_fragment)
        job_fragments.sort(key=sort_by_start_time)
        return Schedule(
            tasks=self.tasks,
            jobs=self.jobs,
            frames=frames,
            time_used=flow_value + used_time,
            total_wcet=self.total_wcet,
            job_fragments=job_fragments
        )

    def __get_combinations(self) -> Dict[str, List[tuple]]:
        all_job_frame_edges = defaultdict(list)
        job_combinations = defaultdict(list)

        for j in self.jobs.values():
            for f in self.base_frames.values():
                if j.release_time <= f.start_time and j.deadline >= f.end_time:
                    all_job_frame_edges[j.name].append((j.name, f.name))
            for i in range(len(all_job_frame_edges[j.name])):
                job_combinations[j.name].extend(list(combinations(all_job_frame_edges[j.name], i + 1)))
        return job_combinations


def sort_by_start_time(item):
    return item.start_time
