from schedulability_testing.model.settings import Settings
from shared.util.data_set_importer_exporter import DataSetImporterExporter


class Schedulability:
    @staticmethod
    def run(settings: Settings):
        DataSetImporterExporter.import_data_set_file(
            "/home/hirdm/Documents/csci461/Project/MixedCriticalitySchedulabilityTesting/resources/"
            "task_gen_out/2020-03-21_234128/cl2_fs25_mc25/util_0_2.json"
        )


if __name__ == '__main__':
    from schedulability_testing.util.settings_importer_exporter import SettingsImporterExporter
    # Schedulability.run(SettingsImporterExporter.import_settings_file(
    #     "/home/hirdm/Documents/csci461/Project/MixedCriticalitySchedulabilityTesting/"
    #     "resources/input/task_gen_test1.json"
    # ))
    Schedulability.run(Settings())
