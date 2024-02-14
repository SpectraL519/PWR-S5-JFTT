#include <iostream>

#include <finite_automation_matcher.hpp>

// ! Implementation is not correct
// Matcher doesn't detect overlaying patterns



namespace jftt {

std::vector<imatcher::offset_type> finite_automation_matcher::match(const matcher_data& data) const {
    return this->_match(
        data, this->_get_transition_function(data.pattern, this->_get_alphabet(data.pattern))
    );
}


const finite_automation_matcher::alphabet_type finite_automation_matcher::_get_alphabet(
    const std::string& pattern
) const {
    alphabet_type alphabet;

    for (const auto letter : pattern)
        alphabet.insert(letter);

    return alphabet;
}

const finite_automation_matcher::transition_function_type finite_automation_matcher::_get_transition_function(
    const std::string& pattern, const alphabet_type& alphabet
) const {
    const auto pattern_len = pattern.length();
    transition_function_type delta(pattern_len + 1, transition_map_type{});

    for (state_type state = 0; state <= pattern_len; state++) {
        auto& state_delta = delta.at(state);
        for (const auto letter : alphabet) {
            state_type new_state = std::min(pattern_len, state + 1);
            while (
                new_state > 0 and
                pattern.substr(0, state) + letter != pattern.substr(0, new_state)
            ) new_state--;

            state_delta[letter] = new_state;
        }
    }

    return delta;
}

std::vector<imatcher::offset_type> finite_automation_matcher::_match(
    const matcher_data& data, const transition_function_type& delta
) const {
    std::vector<offset_type> offset_list;

    const auto pattern_len = data.pattern.length();
    const auto text_len = data.text.length();
    state_type state = 0;

    for (std::size_t i = 0; i < text_len; i++) {
        const auto& letter = data.text.at(i);
        const auto& state_delta = delta.at(state);
        state = (state_delta.find(letter) == state_delta.end()) ? 0 : state_delta.at(letter);

        if (state == pattern_len)
            offset_list.push_back(i - pattern_len + 1);
    }

    return offset_list;
}

} // namespace jftt
