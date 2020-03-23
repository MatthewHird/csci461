from typing import List, Set
import attr


from shared.model.task import Task


@attr.s
class DataSet:

    utilization_level: float = attr.ib()
    number_of_cores: int = attr.ib()
    tasks_per_task_set: int = attr.ib()
    number_of_criticality_levels: int = attr.ib()
    period_set: Set[int] = attr.ib(factory=set)
    task_sets: List[List[Task]] = attr.ib(factory=list)

    def task_set_count(self) -> int:
        return len(self.task_sets)
