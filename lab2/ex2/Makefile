FF := flex
FFLAGS :=

CXX := g++-12
CXX_STD := c++2a
CXX_FLAGS += -std=$(CXX_STD) -Wall -Wextra -Wcast-align -Wconversion -Wunreachable-code -Wuninitialized -pedantic -g -O3

all:
	${FF} $(FFLAGS) -oprune_xml_comments.cpp prune_xml_comments.lex
	$(CXX) $(CXX_FLAGS) -o prune_xml_comments prune_xml_comments.cpp

clean:
	rm -f prune_xml_comments prune_xml_comments.cpp
