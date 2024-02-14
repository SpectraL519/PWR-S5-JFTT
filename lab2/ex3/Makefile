FF := flex
FFLAGS :=

CXX := g++-12
CXX_STD := c++2a
CXX_FLAGS += -Wall -Wextra -Wcast-align -Wconversion -Wunreachable-code -Wuninitialized -pedantic -g -O3

all:
	${FF} $(FFLAGS) -oprune_cpp_comments.cpp prune_cpp_comments.lex
	$(CXX) $(CXX_FLAGS) -o prune_cpp_comments prune_cpp_comments.cpp

clean:
	rm -f prune_cpp_comments prune_cpp_comments.cpp
