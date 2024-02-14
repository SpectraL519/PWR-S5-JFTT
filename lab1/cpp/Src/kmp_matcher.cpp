#include <iostream>

#include <kmp_matcher.hpp>



namespace jftt {

std::vector<imatcher::offset_type> kmp_matcher::match(const matcher_data& data) const {
    std::vector<offset_type> offset_list;

    const auto pattern_len = data.pattern.length();
    const auto text_len = data.text.length();
    const auto pi = _get_lookup_table(data.pattern);
    std::size_t pi_idx = 0;

    for (std::size_t i = 0; i < text_len; i++) {
        while (pi_idx > 0 and data.pattern.at(pi_idx) != data.text.at(i))
            pi_idx = pi.at(pi_idx - 1);

        if (data.pattern.at(pi_idx) == data.text.at(i))
            pi_idx++;

        if (pi_idx == pattern_len) {
            offset_list.push_back(i - pattern_len + 1);
            pi_idx = pi.at(pi_idx - 1);
        }
    }

    return offset_list;
}


const std::vector<std::size_t> kmp_matcher::_get_lookup_table(const std::string& pattern) const {
    auto pattern_len = pattern.length();
    std::vector<std::size_t> pi(pattern_len, 0);
    std::size_t match_len = 0;

    for (std::size_t pi_idx = 1; pi_idx < pattern_len; pi_idx++) {
        while (match_len > 0 and pattern.at(match_len) != pattern.at(pi_idx))
            match_len = pi.at(match_len - 1);

        if (pattern.at(match_len) == pattern.at(pi_idx))
            match_len++;

        pi.at(pi_idx) = match_len;
    }

    return pi;
}

} // namespace jftt
