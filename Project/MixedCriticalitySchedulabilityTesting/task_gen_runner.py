from argparse import ArgumentParser
import logging

from shared.util.custom_help_formatter import CustomHelpFormatter
from task_generation.task_gen import TaskGen
from task_generation.model.settings import Settings
from task_generation.util.settings_importer_exporter import SettingsImporterExporter
from task_generation.util.exit_code import ExitCode


def __main():

    log_level, verbose_settings_template, empty_settings_template, settings_file = __get_parameters()
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

        if len(settings.task_generation.data_set_collections) > 0:
            TaskGen.run(settings)
        else:
            print("Incorrect usage: Use -h option to see help and usage.")

    return ExitCode.SUCCESS


def __get_parameters():
    def custom_help_formatter(prog):
        return CustomHelpFormatter(prog)

    parser = ArgumentParser(formatter_class=custom_help_formatter,
                            description='A tool to generate random task sets for mixed criticality, multi-core programs.')

    parser.add_argument('-v', '--verbose_settings_template', nargs='?',
                        default=None, type=str, metavar='<out_filepath>',
                        help='Generate settings template file (JSON) with examples and descriptions for all fields. '
                             'If <out_file_path> = STDOUT, the settings template will be printed to STDOUT.'),
    parser.add_argument('-e', '--empty_settings_template', nargs='?', default=None, type=str, metavar='<out_filepath>',
                        help='Generate an \'empty\' settings template file (JSON) with default values in all fields. '
                             'If <out_file_path> = STDOUT, the settings template will be printed to STDOUT.'),
    parser.add_argument('-s', '--settings_file', type=str, metavar='<filepath>',
                        help='Path of settings file to run. The settings file can contain tasks and should be used to '
                             'specify schedule parameters. A settings template file with examples can be generated '
                             'with -v.')
    parser.add_argument('-g', '--log_level', default='INFO', type=str,
                        choices=['DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL'],
                        help='Set the logging output level.', metavar="{INFO, WARNING, ERROR}"
                        )
    args = parser.parse_args()
    return args.log_level, args.verbose_settings_template, args.empty_settings_template, args.settings_file


if __name__ == '__main__':
    __main()
