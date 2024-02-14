%option c++

%{
#include <iostream>

bool line_break = false;
%}


/* start conditions */
%s sc_none
%s sc_string
%s sc_comment


/* patterns */
p_line_break \\
p_slash \/

p_begin_singleline_comment \/\\\n\/

p_anything .|\n|[[:blank:]]


%%
    BEGIN(sc_none);

<sc_none>\" {
    ECHO;
    BEGIN(sc_string);
}
<sc_none>{p_begin_singleline_comment} {
    std::cout << "// comment detected\n";
    BEGIN(sc_comment);
}
<sc_none>{p_anything} {
    ECHO;
}

<sc_string>\" {
    ECHO;
    BEGIN(sc_none);
}

<sc_comment>{p_line_break} {
    line_break = true;
}
<sc_comment>\n {
    if (!line_break) {
        BEGIN(sc_none);
    }
    line_break = false;
}
<sc_comment>.|[[:blank:]] {}
%%


int yyFlexLexer::yywrap() {
    return 1;
}

int main(int argc, char* argv[]) {
    yyFlexLexer lexer;
    while (lexer.yylex() != 0) {}

    return 0;
}
