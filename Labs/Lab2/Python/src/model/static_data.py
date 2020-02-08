from typing import List, Tuple, Dict
import attr

from src.model.job import Job
from src.model.task import Task


@attr.s
class StaticData:
    tasks: List[Task] = attr.ib()
    periods: List[int] = attr.ib()
    deadlines: List[int] = attr.ib()
    major_cycle: int = attr.ib()
    jobs: Dict[str, Job] = attr.ib()
    source_edges: List[Tuple[str, str, dict]] = attr.ib()
    total_wcet: int = attr.ib()
