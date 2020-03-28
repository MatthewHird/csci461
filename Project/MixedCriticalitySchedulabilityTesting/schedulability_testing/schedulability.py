import os
import logging
from datetime import datetime
from typing import List, Dict

from shared.model.data_set import DataSet
from shared.util.data_set_importer_exporter import DataSetImporterExporter
from shared.util.exception import DirNotExistError

from schedulability_testing.model.settings import Settings
from schedulability_testing.model.task_set_metadata import TaskSetMetadata
from schedulability_testing.util.schedulers import IlpScheduler, WfScheduler, FfbbScheduler
from schedulability_testing.util.results_exporter import ResultsExporter
from schedulability_testing.model.scheduler_results import SchedulerResults
from schedulability_testing.model.results_set import ResultsSet
from schedulability_testing.model.aggregate_results import AggregateResults


class Schedulability:
    @staticmethod
    def run(settings: Settings):

        # schedulers = [IlpScheduler]
        # schedulers = [WfScheduler]
        schedulers = [FfbbScheduler]
        # schedulers = [WfScheduler, FfbbScheduler]
        # schedulers = [IlpScheduler, WfScheduler, FfbbScheduler]

        # find input_dir
        root_in_dir = settings.input.input_directory
        if not os.path.isdir(root_in_dir):
            logging.info(
                f"Input dir not found: {root_in_dir}\nExiting program... "
            )
            raise DirNotExistError(f"Dir does not exist: {root_in_dir}")
        logging.info(
            f"Input dir found: {root_in_dir}"
        )

        # create output_dir
        root_out_dir = f"{settings.output.output_directory}" \
                       f"{settings.output.generated_directory_prefix}" \
                       f"{datetime.now().strftime('%Y-%m-%d_%H%M%S')}/"
        os.mkdir(root_out_dir)
        logging.info(f"Creating output directory at {root_out_dir}")

        in_dir_contents = os.listdir(root_in_dir)
        data_set_collection_dirs = []
        for d in in_dir_contents:
            if os.path.isdir(root_in_dir + d):
                data_set_collection_dirs.append(d)
        # for data_set_collection_dir in input_dir
        for dsc_dir_rel in sorted(data_set_collection_dirs):
            logging.info(f"Starting data set collection {dsc_dir_rel}")
            # create dsc_output_dir
            dsc_in_dir_abs = str(root_in_dir + dsc_dir_rel).rstrip("/\\") + "/"
            dsc_out_dir_abs = str(root_out_dir + dsc_dir_rel).rstrip("/\\") + "/"
            os.mkdir(dsc_out_dir_abs)
            sched_result_sets: Dict[str, List[ResultsSet]] = {scheduler.name: [] for scheduler in schedulers}
            sched_dirs: Dict[str, str] = \
                {scheduler.name: dsc_out_dir_abs + scheduler.name + "/" for scheduler in schedulers}
            # for scheduler_name in [ilp, wf, ffbb]
            for scheduler in schedulers:
                # create scheduler_name_output_dir
                os.mkdir(sched_dirs[scheduler.name])
            # for data_set_file in data_set_collection_dir
            dsc_dir_contents = os.listdir(dsc_in_dir_abs)
            data_sets_files = []
            for f in dsc_dir_contents:
                if os.path.isfile(dsc_in_dir_abs + f) and f.lower().endswith(".json"):
                    data_sets_files.append(f)
            dsf: str
            for dsf in sorted(data_sets_files):
                logging.info(f"Starting data set file {dsf}")
                # import data_set_file
                ds: DataSet = DataSetImporterExporter.import_data_set_file(dsc_in_dir_abs + dsf)
                # scheduling_algorithms = [ilp(), wf(), ffbb()]
                ts_metadata = TaskSetMetadata.from_data_set(ds)
                sched_results: Dict[str, SchedulerResults] = {
                    scheduler.name: SchedulerResults(
                        scheduler=scheduler,
                        out_file_path=f"{sched_dirs[scheduler.name]}"
                                      f"util_"
                                      f"{str(ts_metadata.utilization_level).replace('.', '_')}"
                                      f".csv",
                        task_set_metadata=ts_metadata,
                        results=[]
                    )
                    for scheduler in schedulers
                }
                # for task_set in data_set_file.task_sets
                for task_set in ds.task_sets:
                    # for scheduler in scheduling_algorithms
                    for sr in sched_results.values():
                        # check schedulability of task_set with scheduler
                        # add result to scheduler.results
                        sr.results.append(sr.scheduler.validate_task_set(
                            task_set=task_set,
                            metadata=sr.task_set_metadata,
                            **settings.schedulers[sr.scheduler.name]
                        ))
                # for scheduler in scheduling_algorithms
                for sr in sched_results.values():
                    logging.info(f"Exporting results of scheduler {sr.scheduler.name} "
                                 f"for util level {str(sr.task_set_metadata.utilization_level)}")
                    # export results to scheduler_name_output_dir/util_level.csv
                    ResultsExporter.export_results_to_csv(
                        out_file_path=sr.out_file_path,
                        results=sr.results
                    )
                    sched_result_sets[sr.scheduler.name].append(sr.generate_results_set())

            for s, rs in sched_result_sets.items():
                logging.info(f"Exporting result sets of scheduler {s} "
                             f"for data set collection {dsc_dir_rel}")
                ResultsExporter.export_results_sets_to_csv(
                    out_file_path=f"{dsc_out_dir_abs}{s}_results.csv",
                    results_sets=rs
                )
            logging.info(f"Exporting aggregate result sets for data set collection {dsc_dir_rel}")
            ResultsExporter.export_aggregate_results_to_csv(
                out_file_path=f"{root_out_dir}{dsc_dir_rel}_aggregate_results.csv",
                aggregate_results=AggregateResults(sched_result_sets)
            )


if __name__ == '__main__':
    from schedulability_testing.util.settings_importer import SettingsImporter
    logging.basicConfig(format='%(asctime)s - %(levelname)s - %(message)s', level='INFO')
    # Schedulability.run(SettingsImporter.import_settings_file(
    #     "/home/hirdm/Documents/csci461/Project/MixedCriticalitySchedulabilityTesting/"
    #     "resources/schedulability_in/schedulability_settings_test.json"
    # ))
    Schedulability.run(SettingsImporter.import_settings_file(
        "/home/hirdm/Documents/csci461/Project/MixedCriticalitySchedulabilityTesting/"
        "resources/schedulability_in/sched_t1.json"
    ))
