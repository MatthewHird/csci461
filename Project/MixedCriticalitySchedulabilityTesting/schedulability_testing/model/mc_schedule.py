import attr
from typing import List, Dict

from schedulability_testing.model.mc_core import McCore
from shared.model.task import Task


@attr.s
class McSchedule:
    scheduler: str = attr.ib()
    periods: List[int] = attr.ib()
    major_cycle_length: int = attr.ib()
    minor_cycle_length: int = attr.ib()
    number_of_minor_cycles: int = attr.ib()
    number_of_criticality_levels: int = attr.ib()
    tasks: Dict[int, Task] = attr.ib(factory=dict)
    cores: Dict[int, McCore] = attr.ib(factory=dict)
    name: str = attr.ib()

    @name.default
    def _name_default(self) -> str:
        return f"{self.scheduler}_generated_schedule"
