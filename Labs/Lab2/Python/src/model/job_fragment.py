import attr

from src.model.job import Job
from src.model.frame import Frame


@attr.s
class JobFragment:
    start_time: int = attr.ib()
    end_time: int = attr.ib()
    time_units: int = attr.ib()
    job: Job = attr.ib()
    frame: Frame = attr.ib()
