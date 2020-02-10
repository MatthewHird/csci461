from typing import Dict

from src.model.schedule import Schedule


class ScheduleValidator:
    @staticmethod
    def is_schedule_valid(schedule: Schedule, job_max_parts_dict: Dict[str, int]) -> bool:
        if schedule is None:
            return False

        if not schedule.is_valid():
            return False

        for job_name, max_parts in job_max_parts_dict.items():
            if len(schedule.job_fragments[job_name]) > max_parts:
                return False
        return True
