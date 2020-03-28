from typing import List, Dict
from collections import defaultdict

from schedulability_testing.model.job import Job


class JobContainer:
    def __init__(self, max_capacity: int):
        self.max_capacity: int = max_capacity
        self.remaining_space: int = max_capacity
        self.own_crit_remaining_space: int = max_capacity
        self.jobs_at_crit_level: Dict[int, List[Job]] = defaultdict(list)

    def insert_job(self, job: Job):
        self.jobs_at_crit_level[job.task.criticality_level].append(job)
        self.remaining_space -= job.task.wcet_base_criticality
