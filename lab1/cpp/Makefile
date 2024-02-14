# TODO: os detection

.PHONY = all clean fa kmp

# CXX
CXX := g++
CXX_STD := -std=c++2a

# COMPILER FLAGS
CXX_FLAGS :=
ifeq ($(CXX), clang++)
	CXX_FLAGS += -Weverything -pedantic -Wno-c++98-compat -g -O3
else
	CXX_FLAGS += -Wall -Wextra -Wcast-align -Wconversion -Wunreachable-code -Wuninitialized -pedantic -g -O3
endif

# STRUCTURE
APP_DIR = App
SRC_DIR = Src
INCLUDE_DIR = Include

# COMPILE ARGS
COMPILE_ARGS = $(CXX_STD) -I $(INCLUDE_DIR)
STRICT ?= 1
ifeq ($(STRICT), 1)
	COMPILE_ARGS += $(CXX_FLAGS)
endif



all: fa kmp

fa:
	$(CXX) -o fa $(APP_DIR)/fa.cpp $(SRC_DIR)/*.cpp $(COMPILE_ARGS)

kmp:
	$(CXX) -o kmp $(APP_DIR)/kmp.cpp $(SRC_DIR)/*.cpp $(COMPILE_ARGS)

clean:
	del *.exe
