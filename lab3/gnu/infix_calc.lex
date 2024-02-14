%option noyywrap

%{
#include <iostream>

#include "infix_calc_parser.hpp"

int yylex();
%}

p_newline (\r\n)|\n


%%

[ \t]                           {}
\\{p_newline}                   {}
^#(.|\\{p_newline})*{p_newline} {}

[0-9]+ {
    ECHO;
    yylval.val = std::stoll(yytext);
    return NUMBER;
}

\(          { ECHO; return '('; }
\)          { ECHO; return ')'; }
\+          { ECHO; return '+'; }
\-          { ECHO; return '-'; }
\*          { ECHO; return '*'; }
\/          { ECHO; return '/'; }
\^          { ECHO; return '^'; }
{p_newline} { ECHO; return EOL; }
q|(exit)    { ECHO; return EXIT; }
.           { ECHO; return SYNTAX_ERROR; }

%%
