from sly import Lexer
from galois_field import GaloisField as gf


class InfixCalcLexer(Lexer):
    tokens = {NUMBER, COMMENT}
    literals = {'(', ')', '+', '-', '*', '/', '^'}

    ignore = ' \t'

    @_(r'\d+')
    def NUMBER(self, token):
        token.value = gf.Type.value(token.value)
        return token

    COMMENT = r'\#.*'

    def error(self, _):
        self.index += 1
