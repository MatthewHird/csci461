import attr
import typing


@attr.s(auto_attribs=True)
class Job:
    task_id: int = None
    id: int = None
    name: str = None
    release_time: int = None
    deadline: int = None
    wcet: int = None
