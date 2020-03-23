import sys
import logging

from jsoncomment import JsonComment

from task_generation.model.settings import Settings


class SettingsImporterExporter:
    @staticmethod
    def import_settings_file(settings_input_file_path: str = None) -> Settings:
        if not settings_input_file_path:
            return Settings()
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
                logging.warning("Failed to open settings file. Default settings used.")
                return Settings()
            except Exception as e:
                logging.error(e)
                logging.warning("Failed to convert JSON to TaskGen Settings object. Default settings used.")
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
    "output": {
        //  print_table: bool           (default: true)     If 'true', print schedule table to STDOUT.
        //  space_frames: bool          (default: false)    If 'true', an additional newline is added after every frame.
        //  table_out_file_path: str    (default: null)     The path of the file the schedule table should write to. 
        //                                                      If 'null', the table will not be written to a file.
        "schedule_table": {
            "print_table": true,
            "space_frames": false,
            "table_out_file_path": null
        },
        //  print_timeline:         NOT YET IMPLEMENTED
        //                              If 'true', print schedule timeline to STDOUT.
        //  schedule_out_file_path: NOT YET IMPLEMENTED
        //                              The path of the file the schedule timeline should write to. 
        //                              If 'null', the schedule timeline will not be written to a file.
        "schedule_timeline": {
            "print_timeline": false,
            "schedule_out_file_path": null
        },
        //  print_json:             NOT YET IMPLEMENTED
        //                              If 'true', print schedule in JSON format to STDOUT.
        //  json_out_file_path:     NOT YET IMPLEMENTED
        //                              The path of the file the schedule in JSON format should write to. 
        //                              If 'null', the schedule in JSON format will not be written to a file.
        "schedule_json": {
            "print_json": false,
            "json_out_file_path": null
        }
    },
    //  counter_max: int            (default: null)     The number of schedule combinations the program should attempt 
    //                                                      before giving up and exiting the program. If 'null', the 
    //                                                      program will run until completion regardless of the number
    //                                                      of combinations tried.
    //
    //  print_counter_every: int    (default: 100)      Every 'print_counter_every' schedule combinations attempted, 
    //                                                      a message will be printed to STDOUT containing the total 
    //                                                      number of schedule combinations attempted so far. 
    //                                                      If 'null', no combination counter messages will be printed.
    "iteration_counter": {
        "counter_max": null,
        "print_counter_every": 100
    },
    "schedule_parameters": {
        //  tasks: []           List of <task> (Tasks) in the form [<index>, <period>, <wcet>, <relative_deadline>].
        //      <task>: []          A Task in the form [<index>, <period>, <wcet>, <relative_deadline>].
        //          <index>: int                Must be a unique integer value. It is used to identify the task.
        //                                          e.g. If <index> = 7, the task will have the name "T7", and its jobs
        //                                          will have the names "J7-1", "J7-2", etc.
        //          <period>: int               The period of the task in a unitless time value (ticks).
        //          <wcet>: int                 The worst case execution time of the task in a unitless time value.
        //          <relative_deadline>: int    The relative deadline of the task in a unitless time value (ticks).
        "tasks": [
            // [1, 4, 1, 4],  
            // [2, 5, 2, 5],
            // [3, 20, 4, 20],
        ],
        //  condition_sets: []  List of <condition_set> (dictionary of conditions) to give to a schedule. The condition
        //                          sets will be attempted in the order they are listed. If a valid schedule is found 
        //                          using a condition set, that schedule will be returned and the program will exit. If
        //                          no schedule is found after exhausting all combinations (or after reaching 
        //                          'counter_max' combinations), the next condition set will be attempted. This process
        //                          continues until all condition sets are tried or a valid schedule is found.
        //            
        //      <condition_set>: {} A condition set in the form {"frame_size": <frame_size>, 
        //                              "task_max_parts": <task_max_parts>, "job_max_parts": <job_max_parts>, 
        //                              "job_frame_usage_edges": <job_frame_usage_edges>}.
        //                          
        //          frame_size: int     The frame size to be used to create the schedule. If 'frame_size' is not in the
        //                                  list of candidate frame sizes for a set of tasks, a warning will be printed
        //                                  and the condition set will be skipped. If 'frame_size' is 'null', the 
        //                                  largest candidate frame size will be used.
        //                  
        //          task_max_parts: []  List of <tmp> (pair of a task name with the maximum number of partitions each 
        //                                  job instance of that task can be broken into).
        //              
        //              <tmp>: []           Pair in the form [<task_name>, <max_parts>].
        //                  <task_name>: str    The name of a task in the form "T<task_index>" (e.g. "T2").
        //                  <max_parts>: int    The maximum number of parts each job of <task_name> can be broken into. 
        //                  
        //          job_max_parts: []   List of <jmp> (pair of a job name with the maximum number of partitions that
        //                                  job can be broken into). 
        //                  
        //              <jmp>: []           Pair in the form [<job_name>, <max_partitions>].
        //                  <job_name>: str     The name of a job in the form "J<task_index>-<job_index>"
        //                                          (e.g. "J3-1" is the 1th instance of task 3).
        //                  <max_parts>: int    The maximum number of partitions a job can be broken into. This 
        //                                          partition restriction overrides the value given by 'task_max_parts'
        //                                          for <task_name> whose task index is <task_index>.
        //              
        //          job_frame_usage_edges: []
        //                              List of <jfue> (triple of a job name, the frame name of the frame to assign 
        //                                  the job to, and the number of unitless time units of the job to assign to
        //                                  the frame). Assigning jobs to frames reduces the number of possible
        //                                  scheduling combinations, drastically reducing the worst case runtime of 
        //                                  the schedule generator, though poor assignments could make finding a valid
        //                                  schedule impossible.
        //          
        //              <jfue>: []          List of triples in the form [<job_name>, <frame_name>, <time_units>]. 
        //                  <job_name>: str     The name of a job in the form "J<task_index>-<job_index>"
        //                                          (e.g. "J2-4" is the 4th instance of task 2).
        //                  <frame_name>: str   The name of a frame in the form "F<frame_number>" 
        //                                          (e.g. "F8" is the 8th frame in the schedule). Each frame has 
        //                                          a length/capacity of <frame_size>. Frame "F1" starts at time 0.
        //                                              <frame_number> = (frame_start_time / <frame_size>) + 1 
        //                                              <frame_start_time> = (<frame_number> - 1) * <frame_size>
        //                  <time_units>: int   The number of unitless time units from job <job_name> to assign to 
        //                                          frame <frame_name>. 
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
//      * Note: This is in a modified JSON format. It is identical to JSON except it allows for single line comments.
//              Each comment must be on its own line (cannot be on a code line).
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
