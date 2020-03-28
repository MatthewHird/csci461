import attr


@attr.s
class McJob:
    job_id: int = attr.ib()
    task_id: int = attr.ib()
    wcet_base: int = attr.ib()
    wcet_own: int = attr.ib()
    release_time: int = attr.ib()
    deadline_time: int = attr.ib()
    # criticality_level: int = attr.ib()
    name: str = attr.ib()

    @name.default
    def _name_default(self) -> str:
        return f"J{self.task_id}_{self.job_id}"
