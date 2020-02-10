class Error(Exception):
    def __init__(self, message):
        self.message = message


class CounterMaxError(Error):
    def __init__(self, info):
        self.message = f'CounterMaxError: "{info}" '
