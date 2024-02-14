%option c++

%{
#include <iostream>

/*

TODO: FIX !!!!!!!!!!!!!!

*/

%}


/* start conditions */
%s sc_none
%s sc_component
%s sc_cdata


%%
    BEGIN(sc_none);

<sc_none>\< {
    ECHO;
    BEGIN(sc_component);
}
<sc_none><!\[CDATA\[ {
    ECHO;
    BEGIN(sc_cdata);
}
<sc_none><!--((-?[^-])*-?)--> {}

<sc_component>> {
    ECHO;
    BEGIN(sc_none);
}
<sc_component>\".*\" {
    ECHO;
}
<sc_component>\'.*\' {
    ECHO;
}
<sc_component><!--((-?[^-])*-?)--> {}

<sc_cdata>\]\]> {
    ECHO;
    BEGIN(sc_none);
}
%%


int yyFlexLexer::yywrap() {
    return 1;
}

int main(void) {
    yyFlexLexer lexer;

    while (lexer.yylex() != 0) {}

    return 0;
}
