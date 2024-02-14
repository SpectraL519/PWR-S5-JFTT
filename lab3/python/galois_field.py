import numpy as np
from typing import Union


class GaloisField:
    class Type:
        value = np.int64
        order = np.uint32
        error = str


    @staticmethod
    def value(a: Type.value, order: Type.order) -> Type.value:
        return np.mod(a, order)


    @staticmethod
    def add(a: Type.value, b: Type.value, order: Type.order) -> Type.value:
        return np.mod(a + b, order)


    @staticmethod
    def subtract(a: Type.value, b: Type.value, order: Type.order) -> Type.value:
        return np.mod(order + np.mod(a - b, order), order)


    @staticmethod
    def multiply(a: Type.value, b: Type.value, order: Type.order) -> Type.value:
        return np.mod(a * b, order)


    @staticmethod
    def _inverse(a: Type.value, order: Type.order):
        t, new_t = GaloisField.Type.value(0), GaloisField.Type.value(1)
        r, new_r = order, a

        while new_r:
            quotient = r // new_r
            t, new_t = new_t, t - quotient * new_t
            r, new_r = new_r, r - quotient * new_r

        if r > 1:
            return None

        return t + order if t < 0 else t


    @staticmethod
    def divide(a: Type.value, b: Type.value, order: Type.order) -> Union[Type.value, Type.error]:
        if not b:
            return f"Cannot invert 0 (mod {order})"

        b_inverse = GaloisField._inverse(b, order)
        if b_inverse is None:
            return f"Cannot invert {b} (mod {order})"

        return np.mod(a * b_inverse, order)


    @staticmethod
    def power(base: Type.value, exponent: Type.value, order: Type.order) -> Type.value:
        result = GaloisField.Type.value(1)

        while exponent > 0:
            if np.mod(exponent, 2):
                result = np.mod(result * base, order)
            base = np.mod(base * base, order)
            exponent //= 2

        return result
