

class Settings:
    def __init__(self):
        self.output = self.Output()
        self.input = self.Input()
        self.schedulers = {
            "ilp": {"solver_timeout": 60},
            "wf": {},
            "ffbb": {}
        }

    class Output:
        def __init__(self):
            self.output_directory: str = None
            self.generated_directory_prefix: str = ""

    class Input:
        def __init__(self):
            self.input_directory: str = None
