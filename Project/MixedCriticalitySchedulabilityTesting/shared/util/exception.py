class Error(Exception):
    def __init__(self, message):
        self.message = message


class MissingFilePathError(Error):
    def __init__(self, info):
        self.message = f'MissingFilePathError: "{info}"'


class DirNotExistError(Error):
    def __init__(self, info):
        self.message = f'DirNotExistError: "{info}"'


class JobContainerOverflowError(Error):
    def __init__(self, info):
        self.message = f'JobContainerOverflowError: "{info}"'


class FfbbJobAssignmentError(Error):
    def __init__(self, info):
        self.message = f'FfbbJobAssignmentError: "{info}"'
