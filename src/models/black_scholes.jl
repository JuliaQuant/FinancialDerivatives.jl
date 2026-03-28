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
    d1 = (log(O.s / O.k) + (O.r - O.q + O.σ^2 / 2) * O.t) / (O.σ * √O.t)
    d2 = d1 - O.σ * √O.t

    if isput(O)
        cdf(Normal(), -d2) * O.k * exp(-O.r * O.t) -
        cdf(Normal(), -d1) * O.s * exp(-O.q * O.t)
    elseif iscall(O)
        O.s * exp(-O.q * O.t) * cdf(Normal(), d1) -
        exp(-O.r * O.t) * O.k * cdf(Normal(), d2)
    end
end

"""
    evaluate(o)

Evaluate option `o` using Back-Scholes model as default valuation model.
"""
evaluate(O::EuropeanOption) = evaluate(O::EuropeanOption, m::BlackScholes)

"""
Price a [`EuropeanOption`](@ref) under the [`BlackScholes`](@ref) model using the
closed-form Black-Scholes-Merton formula.
"""
function price(::AnalyticEngine, option::EuropeanOption, ::BlackScholes,
               md::EquityMarketData)
    S = md.spot_price
    r = md.risk_free_rate
    q = md.dividend_yield
    σ = md.volatility
    k = option.k
    t = option.t

    d1 = (log(S / k) + (r - q + σ^2 / 2) * t) / (σ * √t)
    d2 = d1 - σ * √t

    if isput(option)
        cdf(Normal(), -d2) * k * exp(-r * t) - cdf(Normal(), -d1) * S * exp(-q * t)
    else
        S * exp(-q * t) * cdf(Normal(), d1) - exp(-r * t) * k * cdf(Normal(), d2)
    end
end
