import logging

from jsoncomment import JsonComment

from task_generation.model.settings import Settings
from shared.util.exception import MissingFilePathError


class SettingsImporter:
    @staticmethod
    def import_settings_file(settings_input_file_path: str = None) -> Settings:
        if not settings_input_file_path:
            logging.warning("No settings file specified. Exiting program...")
            raise MissingFilePathError("No settings file specified")
        else:
            try:
                raw_settings = JsonComment().loadf(settings_input_file_path)

                settings = Settings()

                if "output" in raw_settings:
                    o = settings.output
                    output = raw_settings["output"]
                    if "print_task_sets" in output:
                        o.print_task_sets = output["print_task_sets"]
                    if "pretty_print" in output:
                        o.pretty_print = output["pretty_print"]
                    if "output_directory" in output:
                        o.output_directory = str(output["output_directory"]).rstrip("/\\") + "/"
                    if "generated_directory_prefix" in output\
                            and output["generated_directory_prefix"] \
                            and str(output["generated_directory_prefix"]).strip(" _/\\") != "":
                        o.generated_directory_prefix = str(output["generated_directory_prefix"]).strip(" _/\\") + "_"
                if "task_set_validation" in raw_settings:
                    tsv = settings.task_set_validation
                    task_set_validation = raw_settings["task_set_validation"]
                    if "schedulable_task_sets_only" in task_set_validation:
                        tsv.schedulable_task_sets_only = task_set_validation["schedulable_task_sets_only"]
                    if "validator_timeout" in task_set_validation:
                        tsv.validator_timeout = task_set_validation["validator_timeout"]
                if "task_generation" in raw_settings:
                    tg = settings.task_generation
                    task_gen = raw_settings["task_generation"]
                    if "default" in task_gen:
                        d = tg.default
                        d.name = "default"
                        default = task_gen["default"]
                        if "number_of_cores" in default:
                            d.number_of_cores = default["number_of_cores"]
                        if "tasks_per_task_set" in default:
                            d.tasks_per_task_set = default["tasks_per_task_set"]
                        if "utilization_levels" in default:
                            util_levels = default["utilization_levels"]
                            if "low" in util_levels:
                                d.utilization_levels.low = round(util_levels["low"], 4)
                            if "high" in util_levels:
                                d.utilization_levels.high = round(util_levels["high"], 4)
                            if "increment" in util_levels:
                                d.utilization_levels.increment = round(util_levels["increment"], 4)
                        if "task_sets_per_utilization_level" in default:
                            d.task_sets_per_utilization_level = default["task_sets_per_utilization_level"]
                        if "period_set" in default:
                            d.period_set = set(default["period_set"])
                        if "deadline_to_period_range" in default:
                            deadline_range = default["deadline_to_period_range"]
                            if "low" in deadline_range:
                                d.deadline_to_period_range.low = deadline_range["low"]
                            if "high" in deadline_range:
                                d.deadline_to_period_range.high = deadline_range["high"]
                            if "increment" in deadline_range:
                                d.deadline_to_period_range.increment = deadline_range["increment"]
                        if "number_of_criticality_levels" in default:
                            d.number_of_criticality_levels = default["number_of_criticality_levels"]
                        if "wcet_at_own_crit_to_base_crit_range" in default:
                            wcet_range = default["wcet_at_own_crit_to_base_crit_range"]
                            if "low" in wcet_range:
                                d.wcet_at_own_crit_to_base_crit_range.low = wcet_range["low"]
                            if "high" in wcet_range:
                                d.wcet_at_own_crit_to_base_crit_range.high = wcet_range["high"]
                            if "increment" in wcet_range:
                                d.wcet_at_own_crit_to_base_crit_range.increment = wcet_range["increment"]
                    if "data_set_collections" in task_gen:
                        default = tg.default
                        for i, data_set_col in enumerate(task_gen["data_set_collections"]):
                            dsc = tg.add_data_set_collection()
                            dsc.name = data_set_col["name"] if ("name" in data_set_col and data_set_col[
                                "name"] is not None) else f"data_set_{str(i + 1)}"
                            dsc.number_of_cores = data_set_col["number_of_cores"] \
                                if "number_of_cores" in data_set_col else default.number_of_cores
                            dsc.tasks_per_task_set = data_set_col["tasks_per_task_set"] \
                                if "tasks_per_task_set" in data_set_col else default.tasks_per_task_set
                            dsc.utilization_levels.low = data_set_col["utilization_levels"]["low"] if (
                                    "utilization_levels" in data_set_col and "low" in data_set_col[
                                        "utilization_levels"]) else default.utilization_levels.low
                            dsc.utilization_levels.high = data_set_col["utilization_levels"]["high"] if (
                                    "utilization_levels" in data_set_col and "high" in data_set_col[
                                        "utilization_levels"]) else default.utilization_levels.high
                            dsc.utilization_levels.increment = data_set_col["utilization_levels"]["increment"] if (
                                    "utilization_levels" in data_set_col and "increment" in data_set_col[
                                        "utilization_levels"]) else default.utilization_levels.increment
                            dsc.task_sets_per_utilization_level = data_set_col["task_sets_per_utilization_level"] \
                                if "task_sets_per_utilization_level" in data_set_col \
                                else default.task_sets_per_utilization_level
                            dsc.period_set = set(
                                data_set_col["period_set"]) if "period_set" in data_set_col else default.period_set
                            dsc.deadline_to_period_range.low = data_set_col["deadline_to_period_range"]["low"] if (
                                "deadline_to_period_range" in data_set_col and "low" in data_set_col[
                                    "deadline_to_period_range"]) else default.deadline_to_period_range.low
                            dsc.deadline_to_period_range.high = data_set_col["deadline_to_period_range"]["high"] if (
                                "deadline_to_period_range" in data_set_col and "high" in data_set_col[
                                    "deadline_to_period_range"]) else default.deadline_to_period_range.high
                            dsc.deadline_to_period_range.increment = data_set_col["deadline_to_period_range"][
                                "increment"] if (
                                    "deadline_to_period_range" in data_set_col and "increment" in data_set_col[
                                        "deadline_to_period_range"]) else default.deadline_to_period_range.increment
                            dsc.number_of_criticality_levels = data_set_col["number_of_criticality_levels"] \
                                if "number_of_criticality_levels" in data_set_col \
                                else default.number_of_criticality_levels
                            dsc.wcet_at_own_crit_to_base_crit_range.low = \
                                data_set_col["wcet_at_own_crit_to_base_crit_range"]["low"] if (
                                    "wcet_at_own_crit_to_base_crit_range" in data_set_col and "low" in data_set_col[
                                        "wcet_at_own_crit_to_base_crit_range"]
                                ) else default.wcet_at_own_crit_to_base_crit_range.low
                            dsc.wcet_at_own_crit_to_base_crit_range.high = \
                                data_set_col["wcet_at_own_crit_to_base_crit_range"]["high"] if (
                                    "wcet_at_own_crit_to_base_crit_range" in data_set_col and "high" in data_set_col[
                                        "wcet_at_own_crit_to_base_crit_range"]
                                ) else default.wcet_at_own_crit_to_base_crit_range.high
                            dsc.wcet_at_own_crit_to_base_crit_range.increment = \
                                data_set_col["wcet_at_own_crit_to_base_crit_range"]["increment"] if (
                                    "wcet_at_own_crit_to_base_crit_range" in data_set_col
                                    and "increment" in data_set_col[
                                        "wcet_at_own_crit_to_base_crit_range"]
                                ) else default.wcet_at_own_crit_to_base_crit_range.increment

                return settings
            except OSError as e:
                logging.debug(e)
                logging.warning("Failed to open settings file. Exiting program...")
                raise e
            except Exception as e:
                logging.error(e)
                logging.warning("Failed to convert JSON to TaskGen Settings object. Exiting program...")
                raise e
