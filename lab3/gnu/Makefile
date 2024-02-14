FF := flex
BB := bison


CXX := g++-12
CXX_STD := c++2a
CXX_FLAGS += -std=$(CXX_STD)

all: bison flex
	$(CXX) $(CXX_FLAGS) -o infix_calc infix_calc_lex.cpp infix_calc_parser.cpp galois_field.cpp

bison:
	$(BB) -d -o infix_calc_parser.cpp infix_calc_parser.y

flex:
	$(FF) -o infix_calc_lex.cpp infix_calc.lex

clean:
	rm -f infix_calc infix_calc_lex.cpp infix_calc_parser.hpp infix_calc_parser.cpp
