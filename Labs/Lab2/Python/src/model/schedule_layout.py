from typing import List, Tuple, Dict

from src.model.base_frame import BaseFrame
from src.model.static_data import StaticData


class ScheduleLayout:
    def __init__(self, static_data: StaticData, frame_size: int):
        self.static_data: StaticData = static_data
        self.base_frames: Dict[str, BaseFrame] = \
            ScheduleLayout.__initialize_base_frames(frame_size, static_data.major_cycle)
        self.sink_edges: List[Tuple[str, str, dict]] = ScheduleLayout.__initialize_sink_edges(self.base_frames)

    @staticmethod
    def __initialize_base_frames(frame_size: int, major_cycle: int) -> Dict[str, BaseFrame]:
        return {
            f"F{i + 1}":
            BaseFrame(index=i + 1, start_time=i * frame_size, end_time=(i + 1) * frame_size, capacity=frame_size)
            for i in range(major_cycle // frame_size)
        }

    @staticmethod
    def __initialize_sink_edges(base_frames: Dict[str, BaseFrame]) -> List[Tuple[str, str, dict]]:
        return [(f.name, 'sink', {'capacity': f.capacity}) for f in base_frames.values()]
