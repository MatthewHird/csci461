import attr
from typing import List

from schedulability_testing.model.mc_job import McJob


@attr.s
class McCriticalityLevel:
    criticality_level: int = attr.ib()
    switchover_time: int = attr.ib()
    jobs: List[McJob] = attr.ib(factory=list)
