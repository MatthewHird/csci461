import sys
import logging

from jsoncomment import JsonComment

from src.model.settings import Settings
from src.model.task import Task


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
{
    "output": {
        //  print_table:            If 'true', print schedule table to STDOUT.
        //  space_frames:           If 'true', an additional newline is added after every frame.
        //  table_out_file_path:    The path of the file the schedule table should write to. 
        //                              If 'null', the schedule table will not be written to a file.
        "schedule_table": {
            "print_table": true,
            "space_frames": false,
            "table_out_file_path": null
        },
        //  print_timeline:         If 'true', print schedule timeline to STDOUT.
        //  schedule_out_file_path: The path of the file the schedule timeline should write to. 
        //                              If 'null', the schedule timeline will not be written to a file.
        "schedule_timeline": {
            "print_timeline": false,
            "schedule_out_file_path": null
        },
        //  print_json:             If 'true', print schedule in JSON format to STDOUT.
        //  json_out_file_path:     The path of the file the schedule in JSON format should write to. 
        //                              If 'null', the schedule in JSON format will not be written to a file.
        "schedule_json": {
            "print_json": false,
            "json_out_file_path": null
        }
    },
    //  counter_max:            The number of schedule combinations the program should attempt before 
    //                              giving up and exiting the program. If 'null', the program will run
    //                              until completion regardless of the number of combinations tried.
    //
    //  print_counter_every:    Every 'x' schedule combinations attempted, A message will be printed 
    //                              to STDOUT containing the total number of schedule combinations 
    //                              attempted so far, where 'x' is the value of print_counter_every. 
    //                              If 'null', no combination counter messages will be printed.
    "iteration_counter": {
        "counter_max": null,
        "print_counter_every": 100
    },
    "schedule_parameters": {
        //  tasks:  List of tasks in the form [index, period, wcet, relative_deadline]
        //              'index' must be a unique integer value. It is used to identify the task.
        //                  e.g. If 'index' = 7, the task will have the name 'T7', and its jobs 
        //                  will have the names 'J7-1', 'J7-2', etc.
        //              'period', 'wcet', and 'relative_deadline' are all integers representing 
        //                  unitless time values (ticks).
        "tasks": [
            // [1, 4, 1, 4],  
            // [2, 5, 2, 5],
            // [3, 20, 4, 20],
        ],
        //  List of sets of conditions to give to a schedule in the form {frame_size, max_parts, job_frame_usage_edges}. 
        //      The condition sets will be attempted in the order they are listed. If a valid schedule is found using 
        //      a first condition set, that schedule will be returned and the program will exit. If no schedule is 
        //      found after exhausting all combinations (or after reaching 'counter_max' combinations), the next 
        //      condition set will be attempted. This process continues until all condition sets are tried or 
        //      a valid schedule is found.
        //      
        //      frame_size:             The frame size to be used to create the schedule. If 'frame_size' is not
        //                                  in the list of candidate frame sizes for a set of tasks, a warning will
        //                                  be printed and the condition set will be skipped. If frame_size is 'null',
        //                                  the largest candidate frame size will be used.
        //
        //      task_max_parts:         List of pairs in the form [task_name, max_parts].
        //                                  'task_name' is the name of a task in the form 'T<task_index>' (e.g. 'T2').
        //                                  'max_parts' is the maximum number of partitions each job of 'task_name' 
        //                                      can be broken into. 
        //
        //      job_max_parts:          List of pairs in the form [job_name, max_partitions].
        //                                  'job_name' is the name of a job (instance of a task) in the form
        //                                      'J<task_index>-<job_index>' (e.g. 'J3-1' is the 1th instance of task 3).
        //                                  'max_parts' is the maximum number of partitions a job can be broken into. 
        //                                      This partition restriction overrides the value given by 
        //                                      'task_max_parts' for 'job_name'.
        //
        //      job_frame_usage_edges:  List of triples in the form [job_name, frame_name, time_units]. 
        //                                  Assigns 'time_units' time units of job 'job_name' to frame 'frame_name'.
        //                                  Assigning jobs to frames reduces the number of possible scheduling 
        //                                  combinations, drastically reducing the worst case runtime of the 
        //                                  schedule generator, though poor assignments could make finding 
        //                                  a valid schedule impossible. 
        //
        //                                  'job_name' is the name of a job (instance of a task) in the form
        //                                      'J<task_index>-<job_index>' (e.g. 'J2-4' is the 4th instance of task 2).
        //                                  'frame_name' is the name of a frame in the form 'F<frame_number>' 
        //                                      (e.g. 'F8' is the 8th frame in the schedule). Each frame has 
        //                                      a length/capacity of 'frame_size'. Frame 'F1' starts at time 0.
        //                                          <frame_number> = (frame_start_time / <frame_size>) + 1 
        //                                          <frame_start_time> = (<frame_number> - 1) * <frame_size>
        //                                  'time_units' is the amount of time from job 'job_name' to assign to 
        //                                      frame 'frame_name'. 
        "condition_sets": [
            //{
            //    "frame_size": 2,
            //    "task_max_parts": [
            //        ["T2", 1],
            //    ],
            //    "job_max_parts": [
            //        ["J3-1", 2],
            //    ],
            //    "job_frame_usage_edges": [
            //        ["J3-1", "F8", 2],
            //        ["J2-4", "F10", 2],
            //        ["J2-1", "F2", 2],
            //    ]
            //},              
        ]
    }
}"""

        settings_template_empty = """\
//  Empty Settings Template for CeSchedGen (Feb 2020)
{
    "output": {
        "schedule_table": {
            "print_table": true,
            "space_frames": false,
            "table_out_file_path": null
        },
        "schedule_timeline": {
            "print_timeline": false,
            "schedule_out_file_path": null
        },
        "schedule_json": {
            "print_json": false,
            "json_out_file_path": null
        }
    },
    "iteration_counter": {
        "counter_max": null,
        "print_counter_every": 100
    },
    "schedule_parameters": {
        "tasks": [],
        "condition_sets": [
            {
                "frame_size": null,
                "task_max_parts": [],
                "job_max_parts": [],
                "job_frame_usage_edges": []
            },              
        ]
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
