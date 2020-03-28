from typing import Dict, List
from collections import defaultdict

from schedulability_testing.model.results_set import ResultsSet


class AggregateResults:
    def __init__(self, results_sets_dict: Dict[str, List[ResultsSet]]):
        self.results_sets_dict: Dict[str, List[ResultsSet]] = results_sets_dict

    def get_csv_headers(self) -> List[str]:
        headers = [
            ResultsSet.Header.utilization_level,
            ResultsSet.Header.results_count
        ]

        for s in self.results_sets_dict.keys():
            headers.extend([
                f"{s}_{ResultsSet.Header.schedulable_count}"
            ])

        for s in self.results_sets_dict.keys():
            headers.extend([
                f"{s}_{ResultsSet.Header.not_schedulable_count}"
            ])

        for s in self.results_sets_dict.keys():
            headers.extend([
                f"{s}_{ResultsSet.Header.timeout_count}"
            ])

        for s in self.results_sets_dict.keys():
            headers.extend([
                f"{s}_{ResultsSet.Header.percent_schedulable}"
            ])

        for s in self.results_sets_dict.keys():
            headers.extend([
                f"{s}_{ResultsSet.Header.percent_not_schedulable}"
            ])

        for s in self.results_sets_dict.keys():
            headers.extend([
                f"{s}_{ResultsSet.Header.percent_timeout}"
            ])

        for s in self.results_sets_dict.keys():
            headers.extend([
                f"{s}_{ResultsSet.Header.total_time_seconds}"
            ])

        for s in self.results_sets_dict.keys():
            headers.extend([
                f"{s}_{ResultsSet.Header.average_time_seconds}"
            ])

        headers.extend([
            ResultsSet.Header.number_of_cores,
            ResultsSet.Header.tasks_per_task_set,
            ResultsSet.Header.number_of_criticality_levels,
            ResultsSet.Header.period_set
        ])
        return headers

    def get_csv_rows(self) -> List[dict]:
        rows = []
        if len(self.results_sets_dict.keys()) == 0:
            return rows

        row_dict: Dict[int, Dict[str, ResultsSet]] = defaultdict(dict)

        for s, results_sets in self.results_sets_dict.items():
            for i, rs in enumerate(results_sets):
                row_dict[i][s] = rs

        for i, rsd in sorted(row_dict.items()):
            row = {}

            rs_0: ResultsSet = [v for v in rsd.values()][0]
            row[ResultsSet.Header.utilization_level] = rs_0.utilization_level
            row[ResultsSet.Header.results_count] = rs_0.results_count

            for s, rs in rsd.items():
                row[f"{s}_{ResultsSet.Header.schedulable_count}"] = rs.schedulable_count
                row[f"{s}_{ResultsSet.Header.not_schedulable_count}"] = rs.not_schedulable_count
                row[f"{s}_{ResultsSet.Header.timeout_count}"] = rs.timeout_count
                row[f"{s}_{ResultsSet.Header.percent_schedulable}"] = rs.percent_schedulable
                row[f"{s}_{ResultsSet.Header.percent_not_schedulable}"] = rs.percent_not_schedulable
                row[f"{s}_{ResultsSet.Header.percent_timeout}"] = rs.percent_timeout
                row[f"{s}_{ResultsSet.Header.total_time_seconds}"] = rs.total_time_seconds
                row[f"{s}_{ResultsSet.Header.average_time_seconds}"] = rs.average_time_seconds

            row[ResultsSet.Header.number_of_cores] = rs_0.number_of_cores
            row[ResultsSet.Header.tasks_per_task_set] = rs_0.tasks_per_task_set
            row[ResultsSet.Header.number_of_criticality_levels] = rs_0.number_of_criticality_levels
            row[ResultsSet.Header.period_set] = rs_0.period_set
            rows.append(row)

        return rows
