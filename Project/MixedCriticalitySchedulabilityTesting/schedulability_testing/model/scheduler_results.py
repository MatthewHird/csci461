import attr
from typing import List

from schedulability_testing.model.result import Result
from schedulability_testing.model.results_set import ResultsSet
from schedulability_testing.model.task_set_metadata import TaskSetMetadata


@attr.s
class SchedulerResults:
    scheduler = attr.ib()
    out_file_path: str = attr.ib()
    task_set_metadata: TaskSetMetadata = attr.ib()
    results: List[Result] = attr.ib(factory=list)

    def generate_results_set(self):
        schedulable_count = 0
        not_schedulable_count = 0
        timeout_count = 0
        results_count = len(self.results)
        total_time_seconds = 0
        time_count_over_1 = 0
        time_count_over_10 = 0
        time_count_over_30 = 0
        time_count_over_60 = 0

        for result in self.results:
            if result.solution_status == Result.SolutionStatus.SCHEDULABLE:
                schedulable_count += 1
            elif result.solution_status == Result.SolutionStatus.NOT_SCHEDULABLE:
                not_schedulable_count += 1
            elif result.solution_status == Result.SolutionStatus.TIMEOUT:
                timeout_count += 1
            total_time_seconds += result.solution_time
            if result.solution_time > 1:
                time_count_over_1 += 1
            if result.solution_time > 10:
                time_count_over_10 += 1
            if result.solution_time > 30:
                time_count_over_30 += 1
            if result.solution_time > 60:
                time_count_over_60 += 1
        percent_schedulable = schedulable_count / results_count * 100
        percent_not_schedulable = not_schedulable_count / results_count * 100
        percent_timeout = timeout_count / results_count * 100
        average_time_seconds = total_time_seconds / results_count

        return ResultsSet(
            utilization_level=self.task_set_metadata.utilization_level,
            number_of_cores=self.task_set_metadata.number_of_cores,
            tasks_per_task_set=self.task_set_metadata.tasks_per_task_set,
            number_of_criticality_levels=self.task_set_metadata.number_of_criticality_levels,
            period_set=self.task_set_metadata.period_set,
            schedulable_count=schedulable_count,
            not_schedulable_count=not_schedulable_count,
            timeout_count=timeout_count,
            results_count=results_count,
            total_time_seconds=total_time_seconds,
            time_count_over_1=time_count_over_1,
            time_count_over_10=time_count_over_10,
            time_count_over_30=time_count_over_30,
            time_count_over_60=time_count_over_60,
            percent_schedulable=percent_schedulable,
            percent_not_schedulable=percent_not_schedulable,
            percent_timeout=percent_timeout,
            average_time_seconds=average_time_seconds
        )
