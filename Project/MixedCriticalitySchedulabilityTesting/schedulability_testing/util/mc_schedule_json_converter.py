from typing import List, Tuple, Dict

from jsoncomment import JsonComment

from schedulability_testing.model.mc_schedule import McSchedule


class McScheduleJsonConverter:
    @staticmethod
    def mc_schedule_to_json(schedule: McSchedule):
        if schedule is None:
            return ""
        schedule_dict = {
            "name": schedule.name,
            "scheduler": schedule.scheduler,
            "periods": schedule.periods,
            "major_cycle_length": schedule.major_cycle_length,
            "minor_cycle_length": schedule.minor_cycle_length,
            "number_of_minor_cycles": schedule.number_of_minor_cycles,
            "number_of_criticality_levels": schedule.number_of_criticality_levels,
            "tasks": [
                {
                    "name": t.name,
                    "id": t.id,
                    "wcet_base_criticality": t.wcet_base_criticality,
                    "wcet_own_criticality": t.wcet_own_criticality,
                    "period": t.period,
                    "deadline": t.deadline,
                    "criticality_level": t.criticality_level
                }
                for t in schedule.tasks.values()
            ],
            "cores": [
                {
                    "name": c.name,
                    "core": c.core,
                    "frames": [
                        {
                            "name": f.name,
                            "minor_cycle": f.minor_cycle,
                            "core": f.core,
                            "start_time": f.start_time,
                            "end_time": f.end_time,
                            "criticality_levels": [
                                {
                                    "criticality_level": cl.criticality_level,
                                    "switchover_time": cl.switchover_time,
                                    "jobs": [
                                        {
                                            "name": j.name,
                                            "job_id": j.job_id,
                                            "task_id": j.task_id,
                                            "wcet_base": j.wcet_base,
                                            "wcet_own": j.wcet_own,
                                            "release_time": j.release_time,
                                            "deadline_time": j.deadline_time
                                        }
                                        for j in cl.jobs
                                    ]
                                }
                                for cl in f.criticality_levels.values()
                            ]
                        }
                        for f in c.frames.values()
                    ]
                }
                for c in schedule.cores.values()
            ]
        }
        pretty_print = False
        return JsonComment().dumps(
            schedule_dict,
            indent=(4 if pretty_print else None),
            separators=((', ', ': ') if pretty_print else (',', ':'))
        )
