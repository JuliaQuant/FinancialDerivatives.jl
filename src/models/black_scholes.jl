"""
    BlackScholes()

[Black-Scholes model](https://en.wikipedia.org/wiki/Black%E2%80%93Scholes_model).
"""
struct BlackScholes <: Model end

"""
    evaluate(O, BlackScholes())

Evaluate option `O` using `BlackScholes` model.

# Arguments
- `O::Option`: Option
"""
function evaluate(O::EuropeanOption, m::BlackScholes)
    d1 = (log(O.s / O.k) + (O.r + O.σ * O.σ / 2) * O.t) / (O.σ * √O.t)
    d2 = d1 - O.σ * √O.t

    if O.call == -1
        return cdf(Normal(), -d2) * O.k * exp(-O.r * O.t) - cdf(Normal(), -d1) * O.s
    elseif O.call == 1
        return O.s * cdf(Normal(), d1) - exp(-O.r * O.t) * O.k * cdf(Normal(), d2)
    end
end


"""
    evaluate(o)

Evaluate option `o` using Back-Scholes model as default valuation model.
"""
evaluate(O::EuropeanOption) = evaluate(O::EuropeanOption, m::BlackScholes)
