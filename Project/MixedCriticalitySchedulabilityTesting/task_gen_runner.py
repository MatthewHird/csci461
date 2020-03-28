from argparse import ArgumentParser
import logging

from shared.util.custom_help_formatter import CustomHelpFormatter
from task_generation.task_gen import TaskGen
from task_generation.util.settings_importer import SettingsImporter
from task_generation.util.exit_code import ExitCode


def __main():

    log_level, settings_file = __get_parameters()
    logging.basicConfig(format='%(asctime)s - %(levelname)s - %(message)s', level=log_level)

    settings = SettingsImporter.import_settings_file(settings_file)
    if len(settings.task_generation.data_set_collections) > 0:
        TaskGen.run(settings)
    else:
        print("Incorrect usage: Use -h option to see help and usage.")

    return ExitCode.SUCCESS


def __get_parameters():
    def custom_help_formatter(prog):
        return CustomHelpFormatter(prog)

    parser = ArgumentParser(formatter_class=custom_help_formatter,
                            description='A tool to generate random task sets for '
                                        'mixed criticality, multi-core programs.')

    parser.add_argument('settings_file', type=str, metavar='<filepath>',
                        help='Path of settings file to run.')
    parser.add_argument('-g', '--log_level', default='INFO', type=str,
                        choices=['DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL'],
                        help='Set the logging output level.', metavar="{INFO, WARNING, ERROR}"
                        )
    args = parser.parse_args()
    return args.log_level, args.settings_file


if __name__ == '__main__':
    __main()
