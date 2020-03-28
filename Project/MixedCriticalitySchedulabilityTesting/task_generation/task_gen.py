import os
import random
import logging
from datetime import datetime
from typing import List

from shared.model.task import Task
from shared.model.data_set import DataSet
from shared.util.data_set_importer_exporter import DataSetImporterExporter

import task_generation.util.task_set_utilization_gen as ts_util_gen
from task_generation.model.settings import Settings
from task_generation.util.multi_core_ce_scheduler import MultiCoreCeScheduler


class TaskGen:
    @staticmethod
    def run(settings: Settings):
        start_time = datetime.now()

        ds_collection_count = len(settings.task_generation.data_set_collections)
        if ds_collection_count == 0:
            return
        root_out_dir = f"{settings.output.output_directory}" \
                       f"{settings.output.generated_directory_prefix}" \
                       f"{datetime.now().strftime('%Y-%m-%d_%H%M%S')}/"
        os.mkdir(root_out_dir)

        logging.info(f"Creating output directory at {root_out_dir}")

        logging.info(
            f"Data set collections found in settings: "
            f"{str(len(settings.task_generation.data_set_collections))}"
        )

        data_set_collection: Settings.TaskGeneration.DataSetCollection
        for data_set_collection in settings.task_generation.data_set_collections:
            logging.info(f"Starting data set collection: {data_set_collection.name}")

            dsc_out_dir = root_out_dir + data_set_collection.name.rstrip("/\\") + "/"
            os.mkdir(dsc_out_dir)

            utilization_level = data_set_collection.utilization_levels.low
            while utilization_level <= data_set_collection.utilization_levels.high:
                logging.info(f"Generating data set for utilization level: {str(utilization_level)}")

                data_set = DataSet(
                    utilization_level=utilization_level,
                    number_of_cores=data_set_collection.number_of_cores,
                    tasks_per_task_set=data_set_collection.tasks_per_task_set,
                    number_of_criticality_levels=data_set_collection.number_of_criticality_levels,
                    period_set=data_set_collection.period_set
                )

                scheds_tested = 0
                while len(data_set.task_sets) < data_set_collection.task_sets_per_utilization_level:
                    task_sets_to_gen = data_set_collection.task_sets_per_utilization_level - len(data_set.task_sets)
                    current_task_set_count = scheds_tested
                    scheds_tested += task_sets_to_gen

                    logging.info(f"Current Runtime: {str(datetime.now() - start_time)}")
                    logging.info(
                        f"Generating "
                        f"{str(task_sets_to_gen)}"
                        f" new task sets; Total so far: {str(scheds_tested)}"
                    )

                    # generate task sets
                    ts = TaskGen._generate_task_sets(
                        data_set_collection=data_set_collection,
                        utilization_level=utilization_level,
                        number_of_task_sets=data_set_collection.task_sets_per_utilization_level - len(data_set.task_sets)
                    )

                    # validate task sets
                    if settings.task_set_validation.schedulable_task_sets_only:
                        data_set.task_sets.extend(TaskGen._validate_task_sets(
                            task_sets=ts,
                            periods=list(data_set_collection.period_set),
                            core_count=data_set_collection.number_of_cores,
                            solver_timeout=settings.task_set_validation.validator_timeout,
                            current_task_set_count=current_task_set_count,
                            util_level=utilization_level
                        ))

                        logging.info(
                            f"Schedulable task sets generated: "
                            f"{str(len(data_set.task_sets))} of "
                            f"{str(data_set_collection.task_sets_per_utilization_level)}"
                        )
                    else:
                        data_set.task_sets.extend(ts)
                        logging.info(
                            f"Unvalidated task sets generated: {str(len(data_set.task_sets))} of "
                        )

                logging.info(f"Exporting data set for utilization level: {str(utilization_level)}")
                # write task sets to file
                DataSetImporterExporter.export_data_set_file(
                    data_set=data_set,
                    print_data_sets=settings.output.print_data_sets,
                    pretty_print=settings.output.pretty_print,
                    output_file_path=f"{dsc_out_dir}util_{str(round(data_set.utilization_level, 4)).replace('.', '_')}.json"
                )

                utilization_level = round(utilization_level + data_set_collection.utilization_levels.increment, 4)
        logging.info(f"Current Runtime: {str(datetime.now() - start_time)}")
        logging.info(f"Exiting program...")

    @staticmethod
    def _generate_task_sets(
            data_set_collection: Settings.TaskGeneration.DataSetCollection,
            utilization_level: float,
            number_of_task_sets: int
    ) -> List[List[Task]]:
        task_sets = []
        ts_utils = ts_util_gen.rand_fixed_sum(
            tasks_per_task_set=data_set_collection.tasks_per_task_set,
            utilization_level=utilization_level,
            number_of_task_sets=number_of_task_sets
        )

        for ts_util in ts_utils:
            task_set = []

            num_crit_levels = data_set_collection.number_of_criticality_levels

            crit_levels = [
                i
                for i in range(num_crit_levels)
                for j in range(data_set_collection.tasks_per_task_set // num_crit_levels)
            ]
            random.shuffle(crit_levels)

            for i, util in enumerate(ts_util):
                criticality_level = crit_levels.pop()
                period = random.choice(list(data_set_collection.period_set))
                dpr = data_set_collection.deadline_to_period_range
                deadline = round(period * TaskGen._random_range_float(dpr.low, dpr.high, dpr.increment))

                # NEW_WAY
                # wcet_own_criticality = round(util * period)
                # wcet_own = data_set_collection.wcet_at_own_crit_to_base_crit_range
                # wcet_base_criticality = wcet_own_criticality \
                #     if criticality_level == num_crit_levels - 1 \
                #     else round(util * period / TaskGen._random_range_float(
                #         wcet_own.low, wcet_own.high, wcet_own.increment))

                # OLD_WAY
                wcet_base_criticality = round(util * period)
                wcet_own = data_set_collection.wcet_at_own_crit_to_base_crit_range
                wcet_own_criticality = wcet_base_criticality \
                    if criticality_level == num_crit_levels - 1 \
                    else round(util * period * TaskGen._random_range_float(
                        wcet_own.low, wcet_own.high, wcet_own.increment))

                task_set.append(
                    Task(
                        id=i,
                        wcet_base_criticality=wcet_base_criticality,
                        wcet_own_criticality=wcet_own_criticality,
                        period=period,
                        deadline=deadline,
                        criticality_level=criticality_level
                    )
                )
            task_sets.append(task_set)

        return task_sets

    @staticmethod
    def _random_range_float(start: float, stop: float, step: float) -> float:
        return round(random.randint(0, round((stop - start) / step)) * step + start, 4)

    @staticmethod
    def _validate_task_sets(
            task_sets: List[List[Task]],
            periods: List[int],
            core_count: int,
            solver_timeout: int,
            current_task_set_count: int,
            util_level: int = None
    ) -> List[List[Task]]:

        valid_task_sets: List[List[Task]] = []

        for i, task_set in enumerate(task_sets):
            if MultiCoreCeScheduler.is_valid_task_set(
                    task_set=task_set,
                    periods=periods,
                    core_count=core_count,
                    solver_timeout=solver_timeout,
                    set_name=f"u_{str(round(util_level, 4)).replace('.', '_')}_t_{str(i + current_task_set_count)}"
            ):
                valid_task_sets.append(task_set)

        return valid_task_sets


if __name__ == '__main__':
    from task_generation.util.settings_importer import SettingsImporter
    logging.basicConfig(format='%(asctime)s - %(levelname)s - %(message)s', level='INFO')
    TaskGen.run(SettingsImporter.import_settings_file(
        "/home/hirdm/Documents/csci461/Project/MixedCriticalitySchedulabilityTesting/"
        "resources/input/task_gen_test5.json"
    ))
