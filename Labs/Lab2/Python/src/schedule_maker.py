import logging
from typing import List, Tuple, Dict
from collections import defaultdict
from itertools import combinations

import attr
import networkx as nx

from src.model.base_frame import BaseFrame
from src.model.frame import Frame
from src.model.job import Job
from src.model.task import Task
from src.model.job_fragment import JobFragment
from src.model.schedule import Schedule
from src.model.schedule_layout import ScheduleLayout
from src.my_exceptions import CounterMaxError
from src.schedule_validator import ScheduleValidator


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

    def create_schedule_any(self, job_frame_usage_edges: List[Tuple[Job, str, int]]) -> Schedule:
        capacity_edges = []
        for j in self.jobs.values():
            for f in self.base_frames.values():
                if j.release_time <= f.start_time and j.deadline >= f.end_time:
                    capacity_edges.append((j.name, f.name))

        return self.create_schedule_single(capacity_edges, job_frame_usage_edges)

    def create_schedule_single(self, job_frame_capacity_edges: List[Tuple[str, str]],
                               job_frame_usage_edges: List[Tuple[str, str, int]]
                               ) -> Schedule:

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
        job_fragments = defaultdict(list)

        frame_job_timings = defaultdict(int)

        for u_edge in job_frame_usage_edges:
            frame = frames[u_edge[1]]
            job_fragment = self._get_job_fragment(u_edge[0], frame, u_edge[2], frame_job_timings)
            frame.job_fragments.append(job_fragment)
            job_fragments[u_edge[0]].append(job_fragment)

        for job_name, frame_dict in flow_dict.items():
            if job_name in self.jobs:
                for frame_name, time_value in frame_dict.items():
                    if frame_name in self.base_frames and time_value > 0:
                        frame = frames[frame_name]
                        job_fragment = self._get_job_fragment(job_name, frame, time_value, frame_job_timings)
                        frame.job_fragments.append(job_fragment)
                        job_fragments[job_name].append(job_fragment)
                job_fragments[job_name].sort(key=lambda x: x.start_time)

        return Schedule(
            tasks=self.tasks,
            jobs=self.jobs,
            frames=frames,
            time_used=flow_value + used_time,
            total_wcet=self.total_wcet,
            job_fragments=job_fragments
        )

    def recursively_generate_schedules(self, job_combination_list: List[tuple],
                                       currently_included: List[tuple],
                                       job_frame_usage_edges: List[Tuple[str, str, int]],
                                       job_max_parts_dict: Dict[str, int],
                                       counter_max: int,
                                       print_counter_every: int
                                       ) -> Schedule:
        schedule: Schedule = None
        if len(job_combination_list) == 0:
            if counter_max:
                if self.counter > counter_max:
                    raise CounterMaxError(f"Counter has exceeded max value of {counter_max}")
            if print_counter_every:
                if self.counter % print_counter_every == 0:
                    logging.info(f"Schedule combinations tested: {self.counter}")
            self.counter += 1
            schedule = self.create_schedule_single(currently_included,
                                                   job_frame_usage_edges if job_frame_usage_edges else [])
        else:
            job_combo_tuple_list = list(job_combination_list.pop(0))
            for job_combo_tuple in job_combo_tuple_list:
                job_combination_list_copy = job_combination_list.copy()
                schedule = self.recursively_generate_schedules(job_combination_list_copy,
                                                               currently_included + list(job_combo_tuple),
                                                               job_frame_usage_edges,
                                                               job_max_parts_dict,
                                                               counter_max,
                                                               print_counter_every)

                if ScheduleValidator.is_schedule_valid(schedule, job_max_parts_dict):
                    break
        return schedule

    def get_combinations(self, job_frame_usage_edges: List[Tuple[str, str, int]], max_parts_dict: Dict[str, int]) -> Tuple[int, Dict[str, List[tuple]]]:
        all_job_frame_edges = defaultdict(list)
        job_combinations = defaultdict(list)
        combination_count = 1

        job_usage = defaultdict(int)
        frame_usage = defaultdict(int)

        for edge in job_frame_usage_edges:
            j_name: str = edge[0]
            f_name: str = edge[1]
            cap: int = edge[2]
            job_usage[j_name] += cap
            frame_usage[f_name] += cap

        for j in self.jobs.values():
            len_job_combos = 0
            for bf in self.base_frames.values():
                if j.release_time <= bf.start_time and j.deadline >= bf.end_time \
                        and job_usage[j.name] < j.wcet and frame_usage[bf.name] < bf.capacity:
                    all_job_frame_edges[j.name].append((j.name, bf.name))
            for i in range(max_parts_dict[j.name] if j.name in max_parts_dict else len(all_job_frame_edges[j.name])):
                job_combos = list(combinations(all_job_frame_edges[j.name], i + 1))
                len_job_combos += len(job_combos)
                job_combinations[j.name].extend(job_combos)
            combination_count *= len_job_combos if len_job_combos > 0 else 1
        return combination_count, job_combinations

    def _get_job_fragment(self, job_name: str,
                          frame: Frame,
                          time_value: int,
                          frame_job_timings: defaultdict
                          ) -> JobFragment:

        frame_name = frame.base_frame.name
        start_time = frame.base_frame.start_time + frame_job_timings[frame_name]
        frame_job_timings[frame_name] += time_value
        end_time = start_time + time_value
        return JobFragment(
            start_time=start_time,
            end_time=end_time,
            time_units=time_value,
            job=self.jobs[job_name]
        )
