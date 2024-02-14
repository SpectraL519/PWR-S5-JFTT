#pragma once

#include <cmath>
#include <stack>
#include <stdexcept>


class polish_calculator {
public:
    polish_calculator() = default;
    ~polish_calculator() = default;

    inline void push_value(const int value) {
        this->_values.push(value);
    }

    void add() {
        this->_check_num_values('+');

        const int sum = this->_extract_top() + this->_extract_top();
        this->_values.push(sum);
    }

    void subtract() {
        this->_check_num_values('-');

        const int a = this->_extract_top();
        const int b = this->_extract_top();

        this->_values.push(b - a);
    }

    void multiply() {
        this->_check_num_values('*');

        const int product = this->_extract_top() * this->_extract_top();
        this->_values.push(product);
    }

    void divide() {
        this->_check_num_values('/');

        const int a = this->_extract_top();
        const int b = this->_extract_top();
        this->_check_denominator(a, '/');

        this->_values.push(b / a);
    }

    void power() {
        this->_check_num_values('^');

        const int exponent = this->_extract_top();
        const int base = this->_extract_top();

        const int power = static_cast<int>(std::pow(base, exponent));
        this->_values.push(power);
    }

    void modulo() {
        this->_check_num_values('%');

        const int a = this->_extract_top();
        const int b = this->_extract_top();
        this->_check_denominator(a, '%');

        this->_values.push(b % a);
    }

    int result() {
        this->_check_num_values('=', 1);

        const int result = this->_get_result();
        this->reset();

        return result;
    }

    void reset() {
        while (!this->_values.empty()) {
            this->_values.pop();
        }
    }

private:
    void _check_num_values(const char op, const std::size_t min_size = 2) {
        if (this->_values.size() < min_size) {
            this->reset();
            throw std::logic_error(
                std::string("Not enough values to perform operation: ") + op
            );
        }
    }

    inline void _check_denominator(const int denominator, const char op) const {
        if (denominator == 0)
            throw std::logic_error(std::string("Deviding by 0 - operation: ") + op);
    }

    int _extract_top() {
        int top = this->_values.top();
        this->_values.pop();
        return top;
    }

    int _get_result() {
        const bool remaining_values = this->_values.size();

        if (remaining_values == 0)
            throw std::logic_error("No value present - cannot perform operation: =");

        if (remaining_values != 1)
            throw std::logic_error("Values remaining after operation = (not enough operations)");

        return this->_extract_top();
    }

    std::stack<int> _values;
};
