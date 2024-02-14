import sys
from ic_lexer import InfixCalcLexer
from ic_parser import InfixCalcParser



def main():
    lexer = InfixCalcLexer()
    parser = InfixCalcParser()
    parser.set_order(1234577)

    input_marker = '> '

    if len(sys.argv) < 2:
        while True:
            try:
                line = input(input_marker)
                print(line)
                parser.parse(lexer.tokenize(line))
            except EOFError:
                break
    else:
        with open(sys.argv[1], 'r') as input_file:
            lines = input_file.readlines()
            for line in lines:
                print(f'{input_marker}{line.strip()}')
                parser.parse(lexer.tokenize(line))
                print('\n')


if __name__ == '__main__':
    main()
