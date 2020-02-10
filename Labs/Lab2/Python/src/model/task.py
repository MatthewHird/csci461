import attr


@attr.s
class Task:
    index: int = attr.ib()
    period: int = attr.ib()
    wcet: int = attr.ib()
    deadline: int = attr.ib()
    name: str = attr.ib()

    @name.default
    def _name_default(self):
        return f"T{self.index}"
