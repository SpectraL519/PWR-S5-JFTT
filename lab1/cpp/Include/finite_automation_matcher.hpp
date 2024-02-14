#pragma once

#include <compare>
#include <cstdint>
#include <unordered_map>
#include <unordered_set>

#include <matcher.hpp>



namespace jftt {

class finite_automation_matcher : public imatcher {
public:
    finite_automation_matcher() = default;

    std::vector<offset_type> match(const matcher_data& data) const override;

private:
    using state_type = std::size_t;
    using letter_type = char;

    using alphabet_type = std::unordered_set<letter_type>;
    using transition_map_type = std::unordered_map<letter_type, state_type>;
    using transition_function_type = // delta_type
        std::vector<transition_map_type>;


    const alphabet_type _get_alphabet(const std::string& text) const;
    const transition_function_type _get_transition_function(
        const std::string& pattern, const alphabet_type& alphabet
    ) const;

    std::vector<offset_type> _match(
        const matcher_data& data, const transition_function_type& delta) const;
};

} // namespace jftt
