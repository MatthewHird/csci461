from typing import List, Tuple

from src.model.task import Task


class Settings:
    def __init__(self):
        self.output = self.Output()
        self.iteration_counter = self.IterationCounter()
        self.schedule_parameters = self.ScheduleParameters()

    class Output:
        def __init__(self):
            self.schedule_table = self.ScheduleTable()
            self.schedule_timeline = self.ScheduleTimeline()
            self.schedule_json = self.ScheduleJson()

        class ScheduleTable:
            def __init__(self):
                self.print_table: bool = True
                self.space_frames: bool = False
                self.table_out_file_path: str = None

        class ScheduleTimeline:
            def __init__(self):
                self.print_timeline: bool = False
                self.timeline_out_file_path: str = None

        class ScheduleJson:
            def __init__(self):
                self.print_json: bool = False
                self.json_out_file_path: str = None

    class IterationCounter:
        def __init__(self):
            self.counter_max: int = None
            self.print_counter_every: int = 100

    class ScheduleParameters:
        def __init__(self):
            self.tasks: List[Task] = []
            self.condition_sets = []

        def add_condition_set(self):
            condition_set = self.ConditionSet()
            self.condition_sets.append(condition_set)
            return condition_set

        class ConditionSet:
            def __init__(self):
                self.frame_size: int = None
                self.task_max_parts: List[Tuple[str, int]] = []
                self.job_max_parts: List[Tuple[str, int]] = []
                self.job_frame_usage_edges: List[Tuple[str, str, int]] = []
