import attr


@attr.s
class BaseFrame:
    index: int = attr.ib()
    start_time: int = attr.ib()
    end_time: int = attr.ib()
    capacity: int = attr.ib()
    name: str = attr.ib()

    @name.default
    def _name_default(self):
        return f"F{self.index}"

    @classmethod
    def from_end_time(cls, index: int, start_time: int, end_time: int = None, capacity: int = None, name: str = None):
        end: int
        cap: int
        if end_time is not None and capacity is not None:
            end = end_time
            cap = capacity
        elif end_time is not None:
            end = end_time
            cap = end_time - start_time
        elif capacity is not None:
            end = start_time + capacity
            cap = capacity
        else:
            end = start_time
            cap = 0

        return cls(
            index=index,
            start_time=start_time,
            end_time=end,
            capacity=cap,
            name=f"F{index}" if name is None else name
        )
