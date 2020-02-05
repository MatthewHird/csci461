class Error(Exception):
    def __init__(self, message):
        self.message = message


class MyError(Error):
    def __init__(self, info):
        self.message = f'MyError: "{info}" '
