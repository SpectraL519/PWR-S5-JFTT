#include <matcher.hpp>

#include <iostream>
#include <fstream>
#include <stdexcept>



namespace jftt {

const matcher_data parse_input(int argc, char* argv[]) {
    if (argc < 3)
        throw std::invalid_argument("Invalid args!");

    std::string pattern = argv[1];
    std::string file_name = argv[2];

    std::ifstream file(file_name);
    if (not file.is_open())
        throw std::invalid_argument("Cannot open: " + file_name);

    std::string file_content;
    std::string line;

    while (std::getline(file, line))
        file_content += line + '\n';
    file_content.pop_back();

    return matcher_data{
        .pattern = pattern,
        .text = file_content
    };
}

} // namespace match
