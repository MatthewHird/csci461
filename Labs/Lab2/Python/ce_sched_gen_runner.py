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

    log_level, in_file_path, out_file_path, is_comments, is_display = __get_parameters()
    logging.basicConfig(format='%(asctime)s - %(levelname)s - %(message)s', level=log_level)



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
