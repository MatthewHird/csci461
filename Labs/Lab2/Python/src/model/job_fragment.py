import attr

from src.model.job import Job


@attr.s
class JobFragment:
    start_time: int = attr.ib()
    end_time: int = attr.ib()
    time_units: int = attr.ib()
    job: Job = attr.ib()
