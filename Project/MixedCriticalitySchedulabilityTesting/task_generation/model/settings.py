from typing import Set


class Settings:
    def __init__(self):
        self.output = self.Output()
        self.task_set_validation = self.TaskSetValidation
        self.task_generation = self.TaskGeneration()

    class Output:
        def __init__(self):
            self.print_data_sets: bool = False
            self.pretty_print: bool = False
            self.output_directory: str = None

    class TaskSetValidation:
        def __init__(self):
            self.schedulable_task_sets_only: bool = True
            self.validator_timeout: int = 20

    class TaskGeneration:
        def __init__(self):
            self.default = self.DataSetCollection()
            self.data_set_collections = []

        def add_data_set_collection(self):
            data_set_collection = self.DataSetCollection()
            self.data_set_collections.append(data_set_collection)
            return data_set_collection

        class DataSetCollection:
            def __init__(self):
                self.name: str = None
                self.number_of_cores: int = 1
                self.tasks_per_task_set: int = 0
                self.utilization_levels = self.Range()
                self.task_sets_per_utilization_level: int = 0
                self.period_set: Set[int] = set()
                self.deadline_to_period_range = self.Range()
                self.number_of_criticality_levels: int = 1
                self.wcet_at_own_crit_to_base_crit_range = self.Range()

            class Range:
                def __init__(self):
                    self.low: float = float(0)
                    self.high: float = float(0)
                    self.increment: float = float(0.1)
