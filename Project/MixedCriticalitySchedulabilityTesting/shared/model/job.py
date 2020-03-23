import attr

from shared.model.task import Task


@attr.s
class Job:
    task: Task = attr.ib()
    id: int = attr.ib()
    release_time: int = attr.ib()
    deadline_time: int = attr.ib()
    wcet: int = attr.ib()
    name: str = attr.ib()

    @name.default
    def _name_default(self) -> str:
        return f"J{self.task.id}-{self.id}"
