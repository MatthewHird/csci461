from typing import List

from schedulability_testing.model.job import Job


class JobBin:
    def __init__(self, max_capacity: int, start_time: int, end_time: int):
        self.max_capacity: int = max_capacity
        self.bound_capacity: int = max_capacity
        self.max_remaining: int = max_capacity
        self.bound_remaining: int = self.bound_capacity
        self.jobs: List[Job] = []
        self.start_time: int = start_time
        self.end_time: int = end_time

    def insert_job(self, job: Job):
        self.jobs.append(job)
        self.bound_remaining -= job.task.wcet_base_criticality
        self.max_remaining -= job.task.wcet_own_criticality

    def get_switchover_point(self) -> int:
        return self.max_capacity - self.bound_remaining

    def set_bound(self, new_bound: int):
        self.bound_capacity = new_bound
        self.bound_remaining = new_bound
