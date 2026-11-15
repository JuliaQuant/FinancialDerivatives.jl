module BlackScholesModule

using Reexport
using Distributions: cdf, Normal
using ...Engines
using ...Instruments
using ...MarketData
import ..LognormalModel, ..growth_rate
@reexport import ...Engines: price

export BlackScholes

"""
    BlackScholes()

[Black-Scholes model](https://en.wikipedia.org/wiki/Black%E2%80%93Scholes_model).
"""
struct BlackScholes <: LognormalModel end

growth_rate(::BlackScholes, md, t) = discount_rate(md, t) - dividend_yield(md)

"""
Price a [`EuropeanOption`](@ref) under the [`BlackScholes`](@ref) model using the
closed-form Black-Scholes-Merton formula.
"""
function price(::AnalyticEngine, option::EuropeanOption, ::BlackScholes,
               md::AbstractMarketData)
    (; k, t) = option
    S = spot(md)
    r = discount_rate(md, t)
    q = dividend_yield(md)
    σ = volatility(md, t)

    d1 = (log(S / k) + (r - q + σ^2 / 2) * t) / (σ * √t)
    d2 = d1 - σ * √t

    if isput(option)
        cdf(Normal(), -d2) * k * exp(-r * t) - cdf(Normal(), -d1) * S * exp(-q * t)
    else
        S * exp(-q * t) * cdf(Normal(), d1) - exp(-r * t) * k * cdf(Normal(), d2)
    end
end

end # module BlackScholesModule
