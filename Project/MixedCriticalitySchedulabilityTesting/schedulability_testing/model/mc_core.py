import attr
from typing import Dict

from schedulability_testing.model.mc_frame import McFrame


@attr.s
class McCore:
    core: int = attr.ib()
    frames: Dict[int, McFrame] = attr.ib(factory=list)
    name: str = attr.ib()

    @name.default
    def _name_default(self):
        return f"C{self.core}"
