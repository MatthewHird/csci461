import attr


@attr.s
class Task:
    id: int = attr.ib()
    wcet_base_criticality: int = attr.ib()
    wcet_own_criticality: int = attr.ib()
    period: int = attr.ib()
    deadline: int = attr.ib()
    criticality_level: int = attr.ib()
    name: str = attr.ib()

    @name.default
    def _name_default(self):
        return f"T{self.id}"
