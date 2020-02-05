import attr
import typing


@attr.s(auto_attribs=True)
class Frame:
    id: int = None
    name: str = None
    start_time: int = None
    end_time: int = None
    capacity: int = None
