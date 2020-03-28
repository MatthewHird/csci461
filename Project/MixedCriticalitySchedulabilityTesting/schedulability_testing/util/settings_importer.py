import logging

from jsoncomment import JsonComment

from schedulability_testing.model.settings import Settings
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
                    if "output_directory" in output:
                        o.output_directory = str(output["output_directory"]).rstrip("/\\") + "/"
                    if "generated_directory_prefix" in output \
                            and output["generated_directory_prefix"] \
                            and str(output["generated_directory_prefix"]).strip(" _/\\") != "":
                        o.generated_directory_prefix = str(output["generated_directory_prefix"]).strip(" _/\\") + "_"
                if "input" in raw_settings:
                    i = settings.input
                    input_ = raw_settings["input"]
                    if "input_directory" in input_:
                        i.input_directory = str(input_["input_directory"]).rstrip("/\\") + "/"
                if "schedulers" in raw_settings:
                    s = settings.schedulers
                    schedulers = raw_settings["schedulers"]
                    if "ilp" in schedulers:
                        i = s["ilp"]
                        ilp = schedulers["ilp"]
                        if "solver_timeout" in ilp:
                            i["solver_timeout"] = ilp["solver_timeout"]

                return settings
            except OSError as e:
                logging.debug(e)
                logging.warning("Failed to open settings file. Exiting program...")
                raise e
            except Exception as e:
                logging.error(e)
                logging.warning("Failed to convert JSON to Schedulability Testing Settings object. Exiting program...")
                raise e
