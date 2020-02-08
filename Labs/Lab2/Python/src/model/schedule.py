import attr
from typing import Dict, List

from src.model.job import Job
from src.model.job_fragment import JobFragment
from src.model.task import Task
from src.model.frame import Frame


@attr.s
class Schedule:
    tasks: List[Task] = attr.ib()
    jobs: Dict[str, Job] = attr.ib()
    frames: Dict[str, Frame] = attr.ib()
    time_used: int = attr.ib()
    total_wcet: int = attr.ib()
    job_fragments: List[JobFragment] = attr.ib(list)

    def is_valid(self) -> bool:
        return self.time_used == self.total_wcet
