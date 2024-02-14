from matcher import *


class FiniteAutomationMatcher(AbstractMatcher):
    def __init__(self, pattern: str):
        self._pattern = pattern
        self._alphabet = set(pattern)
        self._compute_transition_func()

    def _compute_transition_func(self):
        pattern_len = len(self._pattern)
        self._delta = [dict() for _ in range(pattern_len + 1)]

        for state in range(pattern_len + 1):
            for letter in self._alphabet:
                new_state = min(pattern_len, state + 1)
                while (
                    new_state > 0 and
                    not (self._pattern[:state] + letter).endswith(self._pattern[:new_state])
                ):
                    new_state -= 1

                self._delta[state][letter] = new_state

    def match(self, text: str):
        offset_list = list()
        text_len = len(text)
        pattern_len = len(self._pattern)

        state = 0
        for i in range(text_len):
            state = self._delta[state][text[i]] if text[i] in self._delta[state] else 0
            if state == pattern_len:
                offset_list.append(i - pattern_len + 1)

        return offset_list


if __name__ == '__main__':
    prog = "Finite Automation Matcher"
    args = parse_matcher_args(prog)

    pattern = args.get("pattern")
    text = read_file(args.get("file"))

    print(prog, end="\n\n")
    print(f"Pattern: {pattern}")
    if len(text) < 100:
        print(f"Text:{text}")

    matcher = FiniteAutomationMatcher(pattern)
    print(f"Pattern matches: {matcher.match(text)}")
