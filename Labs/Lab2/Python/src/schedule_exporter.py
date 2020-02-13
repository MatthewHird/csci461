import sys
from collections import defaultdict
from typing import List, Dict
from jsoncomment import JsonComment

from src.model.job_fragment import JobFragment
from src.model.schedule import Schedule


class ScheduleExporter:
    @staticmethod
    def schedule_to_table(schedule: Schedule,
                          print_table: bool = True,
                          out_file_path: str = None,
                          space_frames: bool = False
                          ):
        fp_list = []
        file_path = None
        if out_file_path:
            file_path = open(out_file_path, "w")
            fp_list.append(file_path)

        if print_table:
            fp_list.append(sys.stdout)

        for file in fp_list:
            file.write(
                f"{'Job Name':10}{'Time':6}{'To Frame':10}{'% of Frame':12}{'Frame Completion':18}{'% of Job':10}{'Job Completion':16}\n"
                f"{'========':10}{'====':6}{'========':10}{'==========':12}{'================':18}{'========':10}{'==============':16}\n"
            )

            job_completion = defaultdict(int)
            for f in schedule.frames.values():
                f_total_time = 0
                for jf in f.job_fragments:
                    f_total_time += jf.time_units
                    j_total_time = job_completion[jf.job.name] + jf.time_units
                    job_completion[jf.job.name] = j_total_time % jf.job.wcet
                    file.write(
                        f"{jf.job.name:10}{jf.time_units:<6}{f.base_frame.name:10}"
                        f"{'':2}{jf.time_units / f.base_frame.capacity * 100:5.1f}"
                        f"{'':5}{f_total_time:6} of {f.base_frame.capacity:<6}{'':2}"
                        f"{'':1}{jf.time_units / jf.job.wcet * 100:5.1f}{'':4}"
                        f"{j_total_time:5} of {jf.job.wcet:<5}{'':2}\n"
                    )
                if space_frames:
                    file.write("\n")
        if out_file_path:
            file_path.close()

    @staticmethod
    def schedule_to_timeline(schedule: Schedule, print_timeline: bool = False, out_file_path: str = None):
        pass
        # file = open(out_file_path, "w") if out_file_path else sys.stdout
        #
        # time_row = []
        # frame_task_contents = self.__get_frame_task_contents_from_flow_dict(flow_dict, jobs)
        #
        # task_row = defaultdict(list)
        # for f in frames:
        #     f_total_time = 0
        #     for t in self.static_data.tasks:
        #         task_row_frame = f"{'':<{f_total_time}}" if f_total_time else ""
        #         if frame_task_contents.get(f.name) and frame_task_contents.get(f.name).get(t.index):
        #             j_id = frame_task_contents.get(f.name).get(t.index)[0]
        #             t_time_units = frame_task_contents.get(f.name).get(t.index)[1]
        #             f_total_time += t_time_units
        #             task_row_frame += f"{'':{str(j_id)[-1]}<{t_time_units}}"
        #         task_row[t.index].append(f"{task_row_frame:{f.capacity}}")
        #     time_row.append(f"{'+':->{f.capacity}}")
        #
        # file.write(f"{'':=<10}+{''.join(time_row)}\n")
        # for t in self.static_data.tasks:
        #     file.write(f"{t.name:10}|{''.join(task_row[t.index])}\n")
        # file.write(f"{'':=<10}+{''.join(time_row)}\n")
        #
        # file.close()

    @staticmethod
    def schedule_to_json(schedule: Schedule, print_json: bool = False, out_file_path: str = None):
        pass
