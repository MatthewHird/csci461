import attr
from typing import List

from src.model.base_frame import BaseFrame
from src.model.job_fragment import JobFragment


@attr.s
class Frame:
    base_frame: BaseFrame = attr.ib()
    job_fragments: List[JobFragment] = attr.ib(factory=list)

    def remaining_capacity(self) -> int:
        used_capacity = 0
        for jf in self.job_fragments:
            used_capacity += jf.time_units
        return self.base_frame.capacity - used_capacity

    def is_full(self) -> bool:
        return self.remaining_capacity() == 0
