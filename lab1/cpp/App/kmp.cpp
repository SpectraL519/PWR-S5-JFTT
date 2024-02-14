#include <iostream>

#include <kmp_matcher.hpp>
#include <matcher.hpp>



int main(int argc, char* argv[]) {
    const auto data = jftt::parse_input(argc, argv);

    std::cout << "Finite Automation Matcher\n\n";
    std::cout << "Pattern: " << data.pattern << "\n";

    if (data.text.length() <= 100)
        std::cout << "Text: " << std::endl << data.text << "\n\n";
    else
        std::cout << "Text is over 100 characters" << "\n\n";

    std::cout << "Matches found:\n";

    jftt::kmp_matcher matcher;
    const auto offset_list = matcher.match(data);

    if (offset_list.size() == 0)
        std::cout << "None\n";
    else
        for (const auto offset : offset_list)
            std::cout << offset << "\n";


    return 0;
}
