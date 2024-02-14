FF := flex
FFLAGS :=

CXX := g++-12
CXX_STD := c++2a
CXX_FLAGS += -std=$(CXX_STD) -Wall -Wextra -Wcast-align -Wconversion -Wunreachable-code -Wuninitialized -pedantic -g -O3

all:
	${FF} $(FFLAGS) -ocalculator.cpp calculator.lex
	$(CXX) $(CXX_FLAGS) -o calculator calculator.cpp

clean:
	rm -f calculator calculator.cpp
