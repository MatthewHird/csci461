from datetime import timedelta
from enum import Enum
from typing import List, Union

from schedulability_testing.model.mc_schedule import McSchedule
from schedulability_testing.util.mc_schedule_json_converter import McScheduleJsonConverter


class Result:
    class SolutionStatus(Enum):
        NOT_SCHEDULABLE = -1
        TIMEOUT = 0
        SCHEDULABLE = 1

    class Header:
        solution_status: str = "Solution Status"
        solution_time: str = "Solution Time"
        json_schedule: str = "JSON Schedule"

    def __init__(
            self,
            solution_status: Union[int, SolutionStatus],
            solution_time: timedelta,
            schedule: McSchedule = None
    ):
        self.solution_status: Result.SolutionStatus = self.SolutionStatus(solution_status) \
            if isinstance(solution_status, int) \
            else solution_status
        self.solution_time: timedelta = solution_time
        self.schedule: McSchedule = schedule
        self.json_schedule: str = McScheduleJsonConverter.mc_schedule_to_json(schedule)

    @classmethod
    def get_csv_headers(cls) -> List[str]:
        return [cls.Header.solution_status, cls.Header.solution_time, cls.Header.json_schedule]

    def get_csv_row(self) -> dict:
        return {
            self.Header.solution_status: self.solution_status.name,
            self.Header.solution_time: self.solution_time,
            self.Header.json_schedule: self.json_schedule
        }
