from typing import List
import math


def _lcm_list(int_list: List[int]) -> int:
    return _lcm_list_destructive(int_list.copy())


def _lcm_list_destructive(int_list: List[int]) -> int:
    if len(int_list) == 1:
        return int_list.pop()
    elif len(int_list) > 1:
        a = int_list.pop()
        b = int_list.pop()
        int_list.append(abs(a * b) // math.gcd(a, b))
        return _lcm_list_destructive(int_list)
    else:
        raise ValueError


def _get_periods_from_string(task_set_string: str) -> List[int]:
    return [int(task_string.strip("() ").split(",")[0]) for task_string in task_set_string.splitlines()]


def _get_periods_from_filepath(filepath: str) -> List[int]:
    if filepath:
        try:
            file = open(filepath, "r")
            task_set_string = file.read()
            file.close()
            return _get_periods_from_string(task_set_string)

        except OSError as e:
            print(e)
            print("Failed to open task file...")
        except Exception as e:
            print(e)
            print("Failed to parse task file...")


def _get_gaps(int_list: List[int]) -> List[int]:
    return _get_gaps_destructive(sorted(int_list), [])


def _get_gaps_destructive(int_list: List[int], gap_list: List[int]) -> List[int]:
    if len(int_list) == 1:
        return gap_list
    elif len(int_list) > 1:
        gap_list.append(int_list[1] - int_list[0])
        int_list.pop(0)
        return _get_gaps_destructive(int_list, gap_list)
    else:
        raise ValueError


def generate_virtual_timer_c_array_from_filepath(filepath: str):
    periods = _get_periods_from_filepath(filepath)
    major_cycle = _lcm_list(periods.copy())

    abs_events = set()

    for period in periods:
        event_time = 0
        while event_time <= major_cycle:
            abs_events.add(event_time)
            event_time += period

    rel_events = _get_gaps(sorted(abs_events))

    print("Absolute event times: " + str(sorted(abs_events)))
    print("#define VIRTUAL_TIMER_LENGTH " + str(len(rel_events)))
    print('const unsigned char virtual_timer[' + str(len(rel_events)) + '] = {' + ', '.join([str(i) for i in rel_events]) + '};')


if __name__ == '__main__':
    import sys
    if len(sys.argv) == 1:
        sys.exit("Missing task list filename argument...")
    generate_virtual_timer_c_array_from_filepath(sys.argv[1])
    # generate_virtual_timer_c_array_from_filepath("../resources/input/taskSet1.txt")
