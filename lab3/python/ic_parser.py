from sly import Parser
from ic_lexer import InfixCalcLexer
from galois_field import GaloisField as gf


class InfixCalcParser(Parser):
    # tokens & precedence
    tokens = InfixCalcLexer.tokens
    precedence = (
        ('left', '+', '-'),
        ('left', '*', '/'),
        ('right', NEGATION),
        ('right', '^')
    )


    # arithmetic discriminators
    _order = None
    _exp_order = None

    def set_order(self, order: gf.Type.value):
        self._order = order
        self._exp_order = self._order - 1


    # result & error handlers
    _rpn_expression = ''
    _error_msg = ''

    def reset_expr(self):
        self._rpn_expression = ''
        self._error_msg = ''

    def error(self, _):
        print('|-> [SYNTAX ERROR]')
        self.reset_expr()

    @_('COMMENT')
    def line(self, _):
        pass


    # correct input line production
    @_('expression')
    def line(self, prod):
        if self._rpn_expression:
            print(f'|-> [rpn] : {self._rpn_expression}')
            if not self._error_msg:
                print(f'|-> [result] : {prod.expression}')
            else:
                print(f'|-> [SEMANTIC ERROR] : {self._error_msg}')
        self.reset_expr()


    # expression productions
    @_('NUMBER')
    def expression(self, prod):
        value = gf.value(prod.NUMBER, self._order)
        self._rpn_expression += f'{value} '
        return value

    @_('"-" NUMBER %prec NEGATION')
    def expression(self, prod):
        value = gf.subtract(0, prod.NUMBER, self._order)
        self._rpn_expression += f'{value} '
        return value

    @_('"(" expression ")"')
    def expression(self, prod):
        return prod.expression

    @_('"-" expression')
    def expression(self, prod):
        self._rpn_expression += "~ "
        return gf.subtract(0, prod.expression, self._order)

    @_('expression "+" expression')
    def expression(self, prod):
        self._rpn_expression += '+ '
        return gf.add(prod.expression0, prod.expression1, self._order)

    @_('expression "-" expression')
    def expression(self, prod):
        self._rpn_expression += '- '
        return gf.subtract(prod.expression0, prod.expression1, self._order)

    @_('expression "*" expression')
    def expression(self, prod):
        self._rpn_expression += '* '
        return gf.multiply(prod.expression0, prod.expression1, self._order)

    @_('expression "/" expression')
    def expression(self, prod):
        self._rpn_expression += '/ '

        result = gf.divide(prod.expression0, prod.expression1, self._order)
        if isinstance(result, gf.Type.value):
            return result

        self._error_msg = result
        return 0

    @_('expression "^" exponent')
    def expression(self, prod):
        self._rpn_expression += '^ '
        return gf.power(prod.expression, prod.exponent, self._order)


    # exponentation productions
    @_('NUMBER')
    def exponent(self, prod):
        value = gf.value(prod.NUMBER, self._exp_order)
        self._rpn_expression += f'{value} '
        return value

    @_('"-" NUMBER %prec NEGATION')
    def exponent(self, prod):
        value = gf.subtract(0, prod.NUMBER, self._exp_order)
        self._rpn_expression += f'{value} '
        return value

    @_('"(" exponent ")"')
    def exponent(self, prod):
        return prod.exponent

    @_('"-" exponent')
    def exponent(self, prod):
        self._rpn_expression += "~ "
        return gf.subtract(0, prod.exponent, self._exp_order)

    @_('exponent "+" exponent')
    def exponent(self, prod):
        self._rpn_expression += '+ '
        return gf.add(prod.exponent0, prod.exponent1, self._exp_order)

    @_('exponent "-" exponent')
    def exponent(self, prod):
        self._rpn_expression += '- '
        return gf.subtract(prod.exponent0, prod.exponent1, self._exp_order)

    @_('exponent "*" exponent')
    def exponent(self, prod):
        self._rpn_expression += '* '
        return gf.multiply(prod.exponent0, prod.exponent1, self._exp_order)

    @_('exponent "/" exponent')
    def exponent(self, prod):
        self._rpn_expression += '/ '

        result = gf.divide(prod.exponent0, prod.exponent1, self._exp_order)
        if isinstance(result, gf.Type.value):
            return result

        self._error_msg = result
        return 0
