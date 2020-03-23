from argparse import ArgumentParser
import logging
from typing import List

from shared.util.custom_help_formatter import CustomHelpFormatter
from schedulability_testing.schedulability import Schedulability
from task_generation.model.settings import Settings
from shared.model.task import Task
from schedulability_testing.util.settings_importer_exporter import SettingsImporterExporter
from schedulability_testing.util.exit_code import ExitCode


def __main():

    log_level, verbose_settings_template, \
        empty_settings_template, settings_file, tasks, generate_schedule_any = __get_parameters()
    logging.basicConfig(format='%(asctime)s - %(levelname)s - %(message)s', level=log_level)

    if verbose_settings_template:
        if verbose_settings_template == "STDOUT":
            SettingsImporterExporter.export_settings_template(True, None, True)
        else:
            SettingsImporterExporter.export_settings_template(False, verbose_settings_template, True)
    elif empty_settings_template:
        if empty_settings_template == "STDOUT":
            SettingsImporterExporter.export_settings_template(True, None, False)
        else:
            SettingsImporterExporter.export_settings_template(False, empty_settings_template, False)
    else:
        if settings_file:
            settings = SettingsImporterExporter.import_settings_file(settings_file)
        else:
            settings = Settings()

        task_list: List[Task]
        if tasks and len(tasks) > 0:
            task_list = []
            for task_ints in tasks:
                task_list.append(Task(task_ints[0], task_ints[1], task_ints[2], task_ints[3]))
            settings.schedule_parameters.tasks = task_list

        if len(settings.schedule_parameters.tasks) > 0:
            schedulability = Schedulability(settings)

            if generate_schedule_any:
                schedulability.run()
            else:
                schedulability.run()
        else:
            print("Incorrect usage: Use -h option to see help and usage.")

    return ExitCode.SUCCESS


def __get_parameters():
    def custom_help_formatter(prog):
        return CustomHelpFormatter(prog)

    parser = ArgumentParser(formatter_class=custom_help_formatter,
                            description='A tool to aid in the discovery of a feasible cycle-executive schedule for a '
                                        'set of periodic tasks.')

    parser.add_argument('-v', '--verbose_settings_template', nargs='?',
                        default=None, type=str, metavar='<out_filepath>',
                        help='Generate settings template file (JSON) with examples and descriptions for all fields. '
                             'If <out_filepath> = STDOUT, the settings template will be printed to STDOUT.'),
    parser.add_argument('-e', '--empty_settings_template', nargs='?', default=None, type=str, metavar='<out_filepath>',
                        help='Generate an \'empty\' settings template file (JSON) with default values in all fields. '
                             'If <out_filepath> = STDOUT, the settings template will be printed to STDOUT.'),
    parser.add_argument('-s', '--settings_file', type=str, metavar='<filepath>',
                        help='Path of settings file to run. The settings file can contain tasks and should be used to '
                             'specify schedule parameters. A settings template file with examples can be generated '
                             'with -v.')
    parser.add_argument('-t', '--task', type=int, nargs=4, action='append',
                        metavar=('<index>', '<period>', '<wcet>', '<deadline>'),
                        help='Manually enter task a task as 4 integers. '
                             '-t can be used multiple times to enter multiple tasks. '
                             'Tasks can also be set in the settings file.')
    parser.add_argument('-a', '--generate_schedule_any', action='store_true',
                        help='Generate a schedule with no conditions. Will always find a schedule, if one exists, '
                             'in a single iteration, though the resulting schedule may frequently split jobs into '
                             'many parts.'),
    parser.add_argument('-g', '--log_level', default='INFO', type=str,
                        choices=['DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL'],
                        help='Set the logging output level.', metavar="{INFO, WARNING, ERROR}"
                        )
    args = parser.parse_args()
    return args.log_level, args.verbose_settings_template, args.empty_settings_template, \
        args.settings_file, args.task, args.generate_schedule_any


if __name__ == '__main__':
    __main()
