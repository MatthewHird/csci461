import attr
import typing


@attr.s(auto_attribs=True)
class Task:
    id: int = None
    name: str = None
    phase: int = None
    period: int = None
    wcet: int = None
    deadline: int = None
