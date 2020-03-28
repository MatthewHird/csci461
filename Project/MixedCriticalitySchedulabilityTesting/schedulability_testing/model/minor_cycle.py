import attr

from schedulability_testing.model.job_container import JobContainer


@attr.s
class MinorCycle:
    id: int = attr.ib()
    start_time: int = attr.ib()
    end_time: int = attr.ib()
    capacity: int = attr.ib()
    job_container: JobContainer = attr.ib(default=None)
    name: str = attr.ib()

    @name.default
    def _name_default(self):
        return f"MC{self.id}"
