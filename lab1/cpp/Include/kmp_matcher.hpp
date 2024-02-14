#pragma once

#include <vector>

#include <matcher.hpp>



namespace jftt {

class kmp_matcher : public imatcher {
public:
    kmp_matcher() = default;

    std::vector<offset_type> match(const matcher_data& data) const override;

private:
    const std::vector<std::size_t> _get_lookup_table(const std::string& pattern) const;
};

} // namespace jftt
