#pragma once

#include <optional>
#include <string>
#include <variant>

namespace gf {

using order_type = unsigned;
using value_type = long long;
using value_variant_type = std::variant<value_type, std::string>;

value_type value(value_type a, order_type order);
value_type add(value_type a, value_type b, order_type order);
value_type subtract(value_type a, value_type b, order_type order);
value_type multiply(value_type a, value_type b, order_type order);
value_variant_type divide(value_type a, value_type b, order_type order);
value_type power(value_type a, value_type b, order_type order);

namespace detail {
std::optional<value_type> inverse(value_type a, order_type order);
} // namespace detail

} // namespace gf
