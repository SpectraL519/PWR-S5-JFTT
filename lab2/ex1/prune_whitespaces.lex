%option c++

%{
#include <iostream>

std::size_t num_lines = 0;
std::size_t num_words = 0;
%}


/* start conditions */
%s sc_none
%s sc_newline
%s sc_word
%s sc_whitespace


/* patterns */
p_newline (\r\n)|\n
p_line_break \\{p_newline}


%%
    BEGIN(sc_none);

<sc_none,sc_newline>[[:blank:]]|{p_newline}|{p_line_break} {}
<sc_newline>. {
    std::cout << std::endl;
    REJECT;
}
<sc_none,sc_newline>. {
    ECHO;
    BEGIN(sc_word);
    num_lines++;
    num_words++;
}

<sc_word>[[:blank:]] {
    BEGIN(sc_whitespace);
}
<sc_word>{p_line_break} {}
<sc_word>{p_newline} {
    BEGIN(sc_newline);
}

<sc_whitespace>[[:blank:]]|{p_line_break} {}
<sc_whitespace>{p_newline} {
    BEGIN(sc_newline);
}
<sc_whitespace>. {
    std::cout << ' ';
    ECHO;
    BEGIN(sc_word);
    num_words++;
}
%%


int yyFlexLexer::yywrap() {
    return 1;
}

int main(void) {
    yyFlexLexer lexer;

    while (lexer.yylex() != 0) {}

    std::cerr << "words: " << num_words << std::endl
              << "lines: " << num_lines << std::endl;
    return 0;
}
