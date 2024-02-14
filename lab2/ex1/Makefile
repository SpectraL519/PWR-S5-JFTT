FF := flex
FFLAGS :=

CXX := g++-12
CXX_STD := c++2a
CXX_FLAGS += -std=$(CXX_STD) -Wall -Wextra -Wcast-align -Wconversion -Wunreachable-code -Wuninitialized -pedantic -g -O3

all:
	${FF} $(FFLAGS) -oprune_whitespaces.cpp prune_whitespaces.lex
	$(CXX) $(CXX_FLAGS) -o prune_whitespaces prune_whitespaces.cpp

clean:
	rm -f prune_whitespaces prune_whitespaces.cpp
