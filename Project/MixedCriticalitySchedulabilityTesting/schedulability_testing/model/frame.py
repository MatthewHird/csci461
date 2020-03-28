import attr

from schedulability_testing.model.minor_cycle import MinorCycle
from schedulability_testing.model.job_container import JobContainer


@attr.s
class Frame:
    core_id: int = attr.ib()
    minor_cycle: MinorCycle = attr.ib()
    job_container: JobContainer = attr.ib(default=None)
    name: str = attr.ib()

    @name.default
    def _name_default(self) -> str:
        return f"F{self.minor_cycle.id}_{self.core_id}"
