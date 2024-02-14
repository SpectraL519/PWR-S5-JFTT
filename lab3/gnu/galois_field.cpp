#include "galois_field.hpp"

#include <tuple>



namespace gf {

value_type value(value_type a, order_type order) {
    return a % order;
}

value_type add(value_type a, value_type b, order_type order) {
    return (a + b) % order;
}

value_type subtract(value_type a, value_type b, order_type order) {
    return (order + (a - b) % order) % order;
}

value_type multiply(value_type a, value_type b, order_type order) {
    return (a * b) % order;
}

value_variant_type divide(value_type a, value_type b, order_type order) {
    if (!b)
        return "Cannot invert 0 (mod " + std::to_string(order) + ")";

    const auto b_inverse = detail::inverse(b, order);
    if (!b_inverse)
        return "Cannot invert " + std::to_string(b) + " (mod " + std::to_string(order) + ")";

    return (a * b_inverse.value()) % order;
}

value_type power(value_type base, value_type exponent, order_type order) {
    value_type result = 1;

    while (exponent > 0) {
        if (exponent % 2)
            result = (result * base) % order;
        base = (base * base) % order;
        exponent /= 2;
    }

    return result;
}

namespace detail {

std::optional<value_type> inverse(value_type a, order_type order) {
    value_type t = 0, new_t = 1;
    value_type r = order, new_r = a;

    while (new_r) {
        value_type quotient = r / new_r;
        std::tie(t, new_t) = std::make_pair(new_t, t - quotient * new_t);
        std::tie(r, new_r) = std::make_pair(new_r, r - quotient * new_r);
    }

    if (r > 1)
        return std::nullopt;

    return t < 0 ? t + order : t;
}

} // namespace detail

} // namespace gf
