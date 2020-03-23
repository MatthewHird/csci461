import sys
import logging

from jsoncomment import JsonComment

from schedulability_testing.model.settings import Settings
from shared.model.task import Task


class SettingsImporterExporter:
    @staticmethod
    def import_settings_file(settings_input_file_path: str = None) -> Settings:
        if not settings_input_file_path:
            return Settings()

        if settings_input_file_path:
            try:
                raw_settings = JsonComment().loadf(settings_input_file_path)

                settings = Settings()

                if "output" in raw_settings:
                    output = raw_settings["output"]
                    if "schedule_table" in output:
                        table = output["schedule_table"]
                        if "print_table" in table:
                            settings.output.schedule_table.print_table = table["print_table"]
                        if "space_frames" in table:
                            settings.output.schedule_table.space_frames = table["space_frames"]
                        if "table_out_file_path" in table:
                            settings.output.schedule_table.table_out_file_path = table["table_out_file_path"]
                    if "schedule_timeline" in output:
                        timeline = output["schedule_timeline"]
                        if "print_timeline" in timeline:
                            settings.output.schedule_timeline.print_timeline = timeline["print_timeline"]
                        if "timeline_out_file_path" in timeline:
                            settings.output.schedule_timeline.timeline_out_file_path = \
                                                                                timeline["timeline_out_file_path"]
                    if "schedule_json" in output:
                        schedule_json = output["schedule_json"]
                        if "print_json" in schedule_json:
                            settings.output.schedule_json.print_json = schedule_json["print_json"]
                        if "json_out_file_path" in schedule_json:
                            settings.output.schedule_json.json_out_file_path = schedule_json["json_out_file_path"]
                if "iteration_counter" in raw_settings:
                    counter = raw_settings["iteration_counter"]
                    if "counter_max" in counter:
                        settings.iteration_counter.counter_max = counter["counter_max"]
                    if "print_counter_every" in counter:
                        settings.iteration_counter.print_counter_every = counter["print_counter_every"]
                if "schedule_parameters" in raw_settings:
                    params = raw_settings["schedule_parameters"]
                    if "tasks" in params:
                        for t in params["tasks"]:
                            settings.schedule_parameters.tasks.append(Task(
                                index=t[0],
                                period=t[1],
                                wcet=t[2],
                                deadline=t[3]
                            ))
                    if "condition_sets" in params:
                        for cs in params["condition_sets"]:
                            condition_set = settings.schedule_parameters.add_condition_set()
                            if "frame_size" in cs:
                                condition_set.frame_size = cs["frame_size"]
                            if "task_max_parts" in cs:
                                for tmp in cs["task_max_parts"]:
                                    condition_set.task_max_parts.append(tuple(tmp))
                            if "job_max_parts" in cs:
                                for jmp in cs["job_max_parts"]:
                                    condition_set.job_max_parts.append(tuple(jmp))
                            if "job_frame_usage_edges" in cs:
                                for jfue in cs["job_frame_usage_edges"]:
                                    condition_set.job_frame_usage_edges.append(tuple(jfue))
                return settings
            except OSError as e:
                logging.debug(e)
                logging.warning("Failed to open settings file. Default settings used.")
                return Settings()
            except Exception as e:
                logging.error(e)
                logging.warning("Failed to convert JSON to CeSchedGen Settings object. Default settings used.")
                return Settings()

    @staticmethod
    def export_settings_file(settings: Settings,
                             print_settings: bool = False,
                             settings_output_file_path: str = None
                             ) -> str:
        settings_dict = {
            "output": {
                "schedule_table": {
                    "print_table": settings.output.schedule_table.print_table,
                    "space_frames": settings.output.schedule_table.space_frames,
                    "table_out_file_path": settings.output.schedule_table.table_out_file_path
                },
                "schedule_timeline": {
                    "print_timeline": settings.output.schedule_timeline.print_timeline,
                    "timeline_out_file_path": settings.output.schedule_timeline.timeline_out_file_path
                },
                "schedule_json": {
                    "print_json": settings.output.schedule_json.print_json,
                    "json_out_file_path": settings.output.schedule_json.json_out_file_path
                }
            },
            "iteration_counter": {
                "counter_max": settings.iteration_counter.counter_max,
                "print_counter_every": settings.iteration_counter.print_counter_every
            },
            "schedule_parameters": {
                "tasks": [(t.index, t.period, t.wcet, t.deadline) for t in settings.schedule_parameters.tasks],
                "condition_sets": [
                    {
                        "frame_size": cs.frame_size,
                        "task_max_parts": cs.task_max_parts,
                        "job_max_parts": cs.job_max_parts,
                        "job_frame_usage_edges": cs.job_frame_usage_edges
                    }
                    for cs in settings.schedule_parameters.condition_sets
                ]
            }
        }
        settings_json = JsonComment().dumps(settings_dict, indent=4)

        if print_settings:
            print(settings_json)

        if settings_output_file_path:
            try:
                file = open(settings_output_file_path, "w") if settings_output_file_path else sys.stdout

                file.write(settings_json)

                if settings_output_file_path:
                    file.close()

            except OSError as e:
                logging.debug(e)
                logging.warning("Failed to open settings file. Settings not saved.")
            except Exception as e:
                logging.error(e)
                logging.warning("Failed to open settings file. Settings not saved.")

    @staticmethod
    def export_settings_template(print_template: bool = False,
                                 settings_output_file_path: str = None,
                                 verbose: bool = True
                                 ) -> str:

        settings_template_verbose = """\
//  Verbose Settings Template for CeSchedGen (Feb 2020)
//      * Note: This is in a modified JSON format. It is identical to JSON except it allows for single line comments.
//              Each comment must be on its own line (cannot be on a code line).
{
    
    }
}"""

        settings_template_empty = """\
//  Empty Settings Template for CeSchedGen (Feb 2020)
//      * Note: This is in a modified JSON format. It is identical to JSON except it allows for single line comments.
//              Each comment must be on its own line (cannot be on a code line).
{
    
    }
}"""

        settings_template = settings_template_verbose if verbose else settings_template_empty

        if print_template:
            print(settings_template)

        if settings_output_file_path:
            try:
                file = open(settings_output_file_path, "w") if settings_output_file_path else sys.stdout
                file.write(settings_template)
                if settings_output_file_path:
                    file.close()

            except OSError as e:
                logging.debug(e)
                logging.warning("Failed to open settings file. Settings not saved.")
