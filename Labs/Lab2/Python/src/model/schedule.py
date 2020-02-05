import attr
import typing

from src.model.job import Job
from src.model.task import Task
from src.model.frame import Frame


@attr.s(auto_attribs=True)
class Schedule:
    tasks: typing.List[Task] = attr.Factory(list)
    jobs: typing.List[Job] = attr.Factory(list)
    frames: typing.List[Frame] = attr.Factory(list)
