import csv
from typing import List

from schedulability_testing.model.result import Result
from schedulability_testing.model.results_set import ResultsSet
from schedulability_testing.model.aggregate_results import AggregateResults


class ResultsExporter:
    @staticmethod
    def export_results_to_csv(out_file_path: str, results: List[Result]):
        with open(out_file_path, 'w', newline='') as csv_file:
            writer = csv.DictWriter(csv_file, fieldnames=Result.get_csv_headers())
            writer.writeheader()
            for result in results:
                writer.writerow(result.get_csv_row())

    @staticmethod
    def export_results_sets_to_csv(out_file_path: str, results_sets: List[ResultsSet]):
        with open(out_file_path, 'w', newline='') as csv_file:
            writer = csv.DictWriter(csv_file, fieldnames=ResultsSet.get_csv_headers())

            writer.writeheader()
            for result_set in results_sets:
                writer.writerow(result_set.get_csv_row())

    @staticmethod
    def export_aggregate_results_to_csv(out_file_path: str, aggregate_results: AggregateResults):
        if len(aggregate_results.results_sets_dict.keys()) == 0:
            return

        with open(out_file_path, 'w', newline='') as csv_file:
            writer = csv.DictWriter(csv_file, fieldnames=aggregate_results.get_csv_headers())
            writer.writeheader()
            for row in aggregate_results.get_csv_rows():
                writer.writerow(row)
