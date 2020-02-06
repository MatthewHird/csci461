import attr
from typing import List

from src.model.job_fragment import JobFragment


@attr.s
class Frame:
    id: int = attr.ib()
    start_time: int = attr.ib()
    end_time: int = attr.ib()
    capacity: int = attr.ib()
    name: str = attr.ib()
    job_fragments: List[JobFragment] = attr.ib(factory=list)

    @name.default
    def _name_default(self):
        return f"F{self.id}"
