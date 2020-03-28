import attr
from typing import Dict

from schedulability_testing.model.mc_criticality_level import McCriticalityLevel


@attr.s
class McFrame:
    minor_cycle: int = attr.ib()
    core: int = attr.ib()
    start_time: int = attr.ib()
    end_time: int = attr.ib()
    criticality_levels: Dict[int, McCriticalityLevel] = attr.ib(factory=list)
    name: str = attr.ib()

    @name.default
    def _name_default(self):
        return f"F{self.minor_cycle}_{self.core}"
