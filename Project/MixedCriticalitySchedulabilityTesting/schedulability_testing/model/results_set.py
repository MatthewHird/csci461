import attr
from typing import List

from schedulability_testing.model.result import Result
from schedulability_testing.model.task_set_metadata import TaskSetMetadata


@attr.s
class ResultsSet:
    class Header:
        utilization_level: str = "utilization_level"
        schedulable_count: str = "schedulable_count"
        not_schedulable_count: str = "not_schedulable_count"
        timeout_count: str = "timeout_count"
        results_count: str = "results_count"
        percent_schedulable: str = "percent_schedulable"
        percent_not_schedulable: str = "percent_not_schedulable"
        percent_timeout: str = "percent_timeout"
        total_time_seconds: str = "total_time_seconds"
        average_time_seconds: str = "average_time_seconds"
        time_count_over_1: str = "time_count_over_1"
        time_count_over_10: str = "time_count_over_10"
        time_count_over_30: str = "time_count_over_30"
        time_count_over_60: str = "time_count_over_60"
        number_of_cores: str = "number_of_cores"
        tasks_per_task_set: str = "tasks_per_task_set"
        number_of_criticality_levels: str = "number_of_criticality_levels"
        period_set: str = "period_set"

    utilization_level: float = attr.ib()
    number_of_cores: int = attr.ib()
    tasks_per_task_set: int = attr.ib()
    number_of_criticality_levels: int = attr.ib()
    period_set: List[int] = attr.ib()
    schedulable_count: int = attr.ib()
    not_schedulable_count: int = attr.ib()
    timeout_count: int = attr.ib()
    results_count: int = attr.ib()
    total_time_seconds: float = attr.ib()
    time_count_over_1: int = attr.ib()
    time_count_over_10: int = attr.ib()
    time_count_over_30: int = attr.ib()
    time_count_over_60: int = attr.ib()
    percent_schedulable: float = attr.ib()
    percent_not_schedulable: float = attr.ib()
    percent_timeout: float = attr.ib()
    average_time_seconds: float = attr.ib()

    @classmethod
    def get_csv_headers(cls) -> List[str]:
        return [
            cls.Header.utilization_level,
            cls.Header.schedulable_count,
            cls.Header.not_schedulable_count,
            cls.Header.timeout_count,
            cls.Header.results_count,
            cls.Header.percent_schedulable,
            cls.Header.percent_not_schedulable,
            cls.Header.percent_timeout,
            cls.Header.total_time_seconds,
            cls.Header.average_time_seconds,
            cls.Header.time_count_over_1,
            cls.Header.time_count_over_10,
            cls.Header.time_count_over_30,
            cls.Header.time_count_over_60,
            cls.Header.number_of_cores,
            cls.Header.tasks_per_task_set,
            cls.Header.number_of_criticality_levels,
            cls.Header.period_set
        ]

    def get_csv_row(self) -> dict:
        return {
            self.Header.utilization_level: self.utilization_level,
            self.Header.schedulable_count: self.schedulable_count,
            self.Header.not_schedulable_count: self.not_schedulable_count,
            self.Header.timeout_count: self.timeout_count,
            self.Header.results_count: self.results_count,
            self.Header.percent_schedulable: self.percent_schedulable,
            self.Header.percent_not_schedulable: self.percent_not_schedulable,
            self.Header.percent_timeout: self.percent_timeout,
            self.Header.total_time_seconds: self.total_time_seconds,
            self.Header.average_time_seconds: self.average_time_seconds,
            self.Header.time_count_over_1: self.time_count_over_1,
            self.Header.time_count_over_10: self.time_count_over_10,
            self.Header.time_count_over_30: self.time_count_over_30,
            self.Header.time_count_over_60: self.time_count_over_60,
            self.Header.number_of_cores: self.number_of_cores,
            self.Header.tasks_per_task_set: self.tasks_per_task_set,
            self.Header.number_of_criticality_levels: self.number_of_criticality_levels,
            self.Header.period_set: str(self.period_set)
        }
