%code requires {
#include "galois_field.hpp"
}

%code {
#include <iostream>
#include <optional>

#include "galois_field.hpp"

constexpr gf::order_type gf_order = 1234577;
constexpr gf::order_type gf_exp_order = gf_order - 1;
constexpr std::string input_marker = "> ";

std::string rpn_expression;
std::optional<std::string> error_msg;
gf::order_type order;
void reset_expr();

extern int yylex();
extern int yyparse();
int yyerror(char const *s);
}



/* bison declarations */

%union {
    gf::value_type val;
}

%type <val> value expression exponent_value exponent

%token <val> NUMBER
%token EOL EXIT SYNTAX_ERROR

%left '+' '-'
%left '*' '/'
%precedence NEGATION  /* unary negation */
%right '^'            /* exponentiation */



/* grammar */
%%
input:
    %empty { std::cout << input_marker; }
    | input line
    ;


line:
    EOL { std::cout << std::endl << input_marker; }
    | expression EOL {
        std::cout << "|-> [rpn] : " << rpn_expression << std::endl;
        if (error_msg) {
            std::cout << "|-> [SEMANTIC ERROR] " << error_msg.value() << std::endl;
        }
        else {
            std::cout << "|-> [result] : " << $1 << std::endl;
        }

        reset_expr();
        std::cout << std::endl << input_marker;
    }
    | EXIT EOL { std::exit(0); }
    | error EOL {
        std::cout << "|-> [SYNTAX ERROR]" << std::endl;
        reset_expr();
        std::cout << std::endl << input_marker;
    }


value:
    NUMBER { $$ = gf::value($1, gf_order); }
    ;


expression:
    value {
        rpn_expression += std::to_string($1) + ' ';
        $$ = $1;
    }
    | '(' expression ')' { $$ = $2; }
    | '-' expression %prec NEGATION {
        rpn_expression += "~ ";
        $$ = gf::subtract(0, $2, gf_order);
    }
    | expression '+' expression {
        rpn_expression += "+ ";
        $$ = gf::add($1, $3, gf_order);
    }
    | expression '-' expression {
        rpn_expression += "- ";
        $$ = gf::subtract($1, $3, gf_order);
    }
    | expression '*' expression {
        rpn_expression += "* ";
        $$ = gf::multiply($1, $3, gf_order);
    }
    | expression '/' expression {
        rpn_expression += "/ ";

        gf::value_variant_type result = gf::divide($1, $3, gf_order);
        if (std::holds_alternative<gf::value_type>(result))
            $$ = std::get<gf::value_type>(result);
        else if (!error_msg)
            error_msg = std::get<std::string>(result);
    }
    | expression '^' exponent {
        rpn_expression += "^ ";
        $$ = gf::power($1, $3, gf_order);
    }


exponent_value:
    NUMBER { $$ = gf::value($1, gf_exp_order); }
    ;


exponent:
    exponent_value {
        rpn_expression += std::to_string($1) + ' ';
        $$ = $1;
    }
    | '(' exponent ')' { $$ = $2; }
    | '-' exponent %prec NEGATION {
        rpn_expression += "~ ";
        $$ = gf::subtract(0, $2, gf_exp_order);
    }
    | exponent '+' exponent {
        rpn_expression += "+ ";
        $$ = gf::add($1, $3, gf_exp_order);
    }
    | exponent '-' exponent {
        rpn_expression += "- ";
        $$ = gf::subtract($1, $3, gf_exp_order);
    }
    | exponent '*' exponent {
        rpn_expression += "* ";
        $$ = gf::multiply($1, $3, gf_exp_order);
    }
    | exponent '/' exponent {
        rpn_expression += "/ ";

        gf::value_variant_type result = gf::divide($1, $3, gf_exp_order);
        if (std::holds_alternative<gf::value_type>(result))
            $$ = std::get<gf::value_type>(result);
        else if (!error_msg)
            error_msg = std::get<std::string>(result);
    }
%%



void reset_expr() {
    rpn_expression = "";
    error_msg = std::nullopt;
}

int yyerror(const char* s) {
    return 1;
}

int main(void) {
    reset_expr();

    yyparse();

    return 0;
}
