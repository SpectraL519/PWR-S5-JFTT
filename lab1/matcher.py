from abc import ABC, abstractmethod
import argparse
import io


def parse_matcher_args(prog="None") -> dict:
    parser = argparse.ArgumentParser(prog)

    parser.add_argument(
        "-p", "--pattern",
        type=str,
        required=True
    )
    parser.add_argument(
        "-f", "--file",
        type=str,
        required=True
    )

    return vars(parser.parse_args())


def read_file(file_path: str) -> str:
    with io.open(file_path, mode='r', encoding="utf-8") as file:
        return file.read()


class AbstractMatcher(ABC):
    @abstractmethod
    def match(text: str) -> list:
        pass
