import logging

from jsoncomment import JsonComment

from shared.util.exception import MissingFilePathError
from shared.model.data_set import DataSet
from shared.model.task import Task


class DataSetImporterExporter:
    @staticmethod
    def import_data_set_file(input_file_path: str = None) -> DataSet:
        if not input_file_path:
            raise MissingFilePathError("No input_file_path given for import_data_set_file()")
        else:
            try:
                raw_ds = JsonComment().loadf(input_file_path)

                data_set = DataSet(
                    utilization_level=raw_ds["utilization_level"],
                    number_of_cores=raw_ds["number_of_cores"],
                    tasks_per_task_set=raw_ds["tasks_per_task_set"],
                    number_of_criticality_levels=raw_ds["number_of_criticality_levels"],
                    period_set=set(raw_ds["period_set"])
                )

                for ts in raw_ds["task_sets"]:
                    data_set.task_sets.append([Task(t[0], t[1], t[2], t[3], t[4], t[5]) for t in ts])

                return data_set
            except OSError as e:
                logging.debug(e)
                logging.warning("Failed to open data_set file.")
                raise e
            except Exception as e:
                logging.error(e)
                logging.warning("Failed to convert JSON to DataSet object.")
                raise e

    @staticmethod
    def export_data_set_file(
            data_set: DataSet,
            print_data_sets: bool = False,
            pretty_print: bool = False,
            output_file_path: str = None
    ):
        data_set_dict = {
            "utilization_level": data_set.utilization_level,
            "number_of_cores": data_set.number_of_cores,
            "tasks_per_task_set": data_set.tasks_per_task_set,
            "number_of_criticality_levels": data_set.number_of_criticality_levels,
            "period_set": list(data_set.period_set),
            "task_sets": [
                [
                    (t.id, t.wcet_base_criticality, t.wcet_own_criticality, t.period, t.deadline, t.criticality_level)
                    for t in ts
                ]
                for ts in data_set.task_sets
            ]
        }

        data_set_json = JsonComment().dumps(
            data_set_dict,
            indent=(4 if pretty_print else None),
            separators=((', ', ': ') if pretty_print else (',', ':'))
        )

        if print_data_sets:
            print(data_set_json)

        if output_file_path:
            try:
                file = open(output_file_path, "w")
                file.write(data_set_json)
                if output_file_path:
                    file.close()

            except OSError as e:
                logging.debug(e)
                logging.warning(f"Failed to open data set file at {output_file_path}")
                raise e
