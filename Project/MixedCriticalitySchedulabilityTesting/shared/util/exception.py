class Error(Exception):
    def __init__(self, message):
        self.message = message


class MissingFilePathError(Error):
    def __init__(self, info):
        self.message = f'MissingFilePathError: "{info}"'
