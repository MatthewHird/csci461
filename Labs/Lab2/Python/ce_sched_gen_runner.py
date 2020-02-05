from argparse import ArgumentParser
import logging
from enum import Enum
from typing import Dict, Tuple, Sequence
from src.my_exceptions import *


class ExitCode(Enum):
    SUCCESS = 0
    UNEXPECTED_IO_EXCEPTION = 10
    READ_FILE_ERROR = 11
    WRITE_FILE_ERROR = 12
    UNEXPECTED_APP_EXCEPTION = 20
    GENERAL_APP_ERROR = 21


def __main():
    ass_file_string = None
    mac_file_string = None

    log_level, in_file_path, out_file_path, is_comments, is_display = __get_parameters()
    logging.basicConfig(format='%(asctime)s - %(levelname)s - %(message)s', level=log_level)
    ass_mac_converter = None  # create program

    try:
        ass_file_string = __load_file(in_file_path)
    except Exception as e:
        logging.exception(e)
        logging.info("Failed to load file: {}. Program aborted...".format(in_file_path))
        return ExitCode.READ_FILE_ERROR

    try:
        # run program
        mac_file_string = ass_mac_converter.run(ass_file_string, is_comments)
    except Error as e:
        logging.info(e.message)
        logging.info("A fatal error has occurred. Program aborted...")
        return ExitCode.GENERAL_APP_ERROR
    except Exception as e:
        logging.exception(e)
        logging.info("An unexpected error has occurred. Program aborted...")
        return ExitCode.UNEXPECTED_APP_EXCEPTION

    try:
        if out_file_path:
            __write_file(out_file_path, mac_file_string)
    except Exception as e:
        logging.exception(e)
        logging.info("Failed to write to file: {}. Program aborted...".format(out_file_path))
        return ExitCode.WRITE_FILE_ERROR

    if is_display:
        print(mac_file_string)

    return ExitCode.SUCCESS


def __get_parameters():
    parser = ArgumentParser(description='A tool to aid in the discovery of a feasible cycle-executive schedule for a '
                                        'set of periodic tasks')
    parser.add_argument('infile', help='path of assembly code file to process')
    parser.add_argument('outfile', default='mac', nargs='?',
                        help='path of machine code file create (default: \'./mac\')')
    parser.add_argument('-c', '--comments', action='store_true',
                        help='flag to add assembly comments to machine code file')
    parser.add_argument('-d', '--display', action='store_true',
                        help='flag to display created machine code in terminal')
    parser.add_argument('-g', '--log_level', default='INFO', type=str,
                        choices=['DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL'],
                        help='Set the logging output level')
    args = parser.parse_args()
    return args.log_level, args.infile, args.outfile, args.comments, args.display


def __load_file(file_path):
    file = open(file_path, 'r')
    file_string = file.read()
    file.close()
    return file_string


def __write_file(file_path, contents):
    file = open(file_path, 'w')
    file.write(contents)
    file.close()


if __name__ == '__main__':
    __main()
