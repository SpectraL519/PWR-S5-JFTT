#pragma once

#include <string>
#include <vector>



namespace jftt {

struct matcher_data {
    std::string pattern;
    std::string text;
};

const matcher_data parse_input(int argc, char* argv[]);


class imatcher {
public:
    using offset_type = std::size_t;
    virtual std::vector<offset_type> match(const matcher_data& data) const = 0;
};

} // namespace jftt
