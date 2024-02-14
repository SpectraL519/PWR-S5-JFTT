%option c++

%{
#include <iostream>
#include <optional>
#include <string>

#include "polish_calculator.hpp"

polish_calculator calculator;
std::optional<std::string> error_msg;
%}


/* start conditions */
%s sc_none
%s sc_error


/* patterns */
p_newline (\r\n)|\n
p_number \-?[[:digit:]]+


%%
    BEGIN(sc_none);

<sc_none>{p_number} {
    ECHO;
    calculator.push_value(std::stoi(YYText()));
}

<sc_none>\+ {
    ECHO;
    try {
        calculator.add();
    }
    catch (std::logic_error &err) {
        error_msg = err.what();
        BEGIN(sc_error);
    }
}

<sc_none>\- {
    ECHO;
    try {
        calculator.subtract();
    }
    catch (std::logic_error &err) {
        error_msg = err.what();
        BEGIN(sc_error);
    }
}

<sc_none>\* {
    ECHO;
    try {
        calculator.multiply();
    }
    catch (std::logic_error &err) {
        error_msg = err.what();
        BEGIN(sc_error);
    }
}

<sc_none>\/ {
    ECHO;
    try {
        calculator.divide();
    }
    catch (std::logic_error &err) {
        error_msg = err.what();
        BEGIN(sc_error);
    }
}

<sc_none>\^ {
    ECHO;
    try {
        calculator.power();
    }
    catch (std::logic_error &err) {
        error_msg = err.what();
        BEGIN(sc_error);
    }
}

<sc_none>\% {
    ECHO;
    try {
        calculator.modulo();
    }
    catch (std::logic_error &err) {
        error_msg = err.what();
        BEGIN(sc_error);
    }
}

<sc_none,sc_error>{p_newline} {
    ECHO;
    std::optional<int> result;

    if (!error_msg) {
        try {
            result = calculator.result();
        }
        catch (std::logic_error &err) {
            error_msg = err.what();
        }
    }

    if (result)
        std::cout << "|-> = " << result.value() << std::endl;

    if (error_msg) {
        std::cout << "(ERROR) " << error_msg.value() << std::endl;
    }

    error_msg = std::nullopt;
    calculator.reset();

    std::cout << std::endl;
    BEGIN(sc_none);
}

<sc_none>[[:blank:]]* {
    std::cout << ' ';
}

<sc_none>. {
    std::string invalid = YYText();
    std::cout << invalid;

    error_msg = "Invalid character: " + invalid;

    BEGIN(sc_error);
}

<sc_error>.|[[:blank:]]* {
    ECHO;
}
%%


int yyFlexLexer::yywrap() {
    return 1;
}

int main() {
    yyFlexLexer lexer;

    while (lexer.yylex() != 0) {}

    return 0;
}
