%option c++

%{
#include <iostream>
#include <cstring>

bool omit_docs = false;

bool multiline_doc_comment = false;
bool line_break = false;

#define PRINT_IF_OMIT if (omit_docs) ECHO
#define PRINT_MULTILINE_IF_OMIT if (omit_docs && multiline_doc_comment) ECHO
%}


/* start conditions */
%s sc_none
%s sc_include
%s sc_string
%s sc_multiline_comment


/* patterns */
p_newline (\r\n)|\n
p_opt_line_breaks (\\[[:blank:]]*{p_newline})*
p_slash \/
p_asterisk \*
p_excl \!

p_begin_singleline_docs ({p_slash}{p_opt_line_breaks}){2}({p_slash}|{p_excl})
p_begin_multiline_docs {p_slash}{p_opt_line_breaks}{p_asterisk}{p_opt_line_breaks}({p_asterisk}|{p_excl})

p_begin_singleline_comment {p_slash}{p_opt_line_breaks}{p_slash}
p_begin_multiline_comment {p_slash}{p_opt_line_breaks}{p_asterisk}
p_end_multiline_comment {p_asterisk}{p_opt_line_breaks}{p_slash}

p_anything_opt_break_lines (.*{p_opt_line_breaks})*


%%
    BEGIN(sc_none);

<sc_none>#include {
    ECHO;
    BEGIN(sc_include);
}
<sc_none>\" {
    ECHO;
    BEGIN(sc_string);
}
<sc_none>{p_begin_singleline_docs}{p_anything_opt_break_lines} {
    PRINT_IF_OMIT;
}
<sc_none>{p_begin_multiline_docs} {
    multiline_doc_comment = true;
    PRINT_IF_OMIT;
    BEGIN(sc_multiline_comment);
}
<sc_none>{p_begin_singleline_comment}{p_anything_opt_break_lines} {}
<sc_none>{p_begin_multiline_comment} {
    BEGIN(sc_multiline_comment);
}

<sc_include>> {
    ECHO;
    BEGIN(sc_none);
}

<sc_string>\\\" {
    ECHO;
}
<sc_string>\" {
    ECHO;
    BEGIN(sc_none);
}

<sc_multiline_comment>{p_end_multiline_comment} {
    PRINT_MULTILINE_IF_OMIT;
    BEGIN(sc_none);
    multiline_doc_comment = false;
}
<sc_multiline_comment>.|{p_newline}|[[:blank:]] {
    PRINT_MULTILINE_IF_OMIT;
}
%%


int yyFlexLexer::yywrap() {
    return 1;
}

int main(int argc, char* argv[]) {
    if (argc > 1 && std::strcmp(argv[1], "--omit-docs") == 0) {
        omit_docs = true;
    }

    yyFlexLexer lexer;
    while (lexer.yylex() != 0) {}

    return 0;
}
