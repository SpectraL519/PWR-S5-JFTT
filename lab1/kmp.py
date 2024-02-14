from matcher import *


class KMPMatcher(AbstractMatcher):
    def __init__(self, pattern: str):
        self._pattern = pattern
        self._compute_lookup_table()

    def _compute_lookup_table(self):
        pattern_len = len(self._pattern)
        self._pi = [0] * pattern_len

        match_len = 0
        for pi_idx in range(1, pattern_len):
            while match_len > 0 and self._pattern[match_len] != self._pattern[pi_idx]:
                match_len = self._pi[match_len - 1]

            if self._pattern[match_len] == self._pattern[pi_idx]:
                match_len += 1

            self._pi[pi_idx] = match_len

    def match(self, text: str):
        offset_list = list()
        text_len = len(text)
        pattern_len = len(self._pattern)

        pi_idx = 0
        for i in range(text_len):
            while pi_idx > 0 and self._pattern[pi_idx] != text[i]:
                pi_idx = self._pi[pi_idx - 1]

            if pattern[pi_idx] == text[i]:
                pi_idx += 1

            if pi_idx == pattern_len:
                offset_list.append(i - pattern_len + 1)
                pi_idx = self._pi[pi_idx - 1]

        return offset_list


if __name__ == '__main__':
    prog = "Knuth-Morris-Pratt Matcher"
    args = parse_matcher_args(prog)

    pattern = args.get("pattern")
    text = read_file(args.get("file"))

    print(prog, end="\n\n")
    print(f"Pattern: {pattern}")
    if len(text) < 100:
        print(f"Text:{text}")

    matcher = KMPMatcher(pattern)
    print(f"Pattern matches: {matcher.match(text)}")
