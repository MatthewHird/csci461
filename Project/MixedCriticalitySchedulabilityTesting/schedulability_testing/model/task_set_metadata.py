from typing import List
import attr

from shared.model.data_set import DataSet


@attr.s
class TaskSetMetadata:

    utilization_level: float = attr.ib()
    number_of_cores: int = attr.ib()
    tasks_per_task_set: int = attr.ib()
    number_of_criticality_levels: int = attr.ib()
    period_set: List[int] = attr.ib(factory=list)

    @staticmethod
    def from_data_set(data_set: DataSet):
        return TaskSetMetadata(
            data_set.utilization_level,
            data_set.number_of_cores,
            data_set.tasks_per_task_set,
            data_set.number_of_criticality_levels,
            list(data_set.period_set)
        )
