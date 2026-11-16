module AnalyticModule

using Distributions: cdf, Normal
using ..Engines
using ..Instruments
using ..MarketData
using ..Models: LognormalModel, growth_rate
import ..Engines: price

"""
Price a [`EuropeanOption`](@ref) or an [`FXOption`](@ref) under a [`LognormalModel`](@ref)
with the closed-form Black-Scholes-Merton formula.
"""
function price(::AnalyticEngine, option::Union{EuropeanOption,FXOption},
               model::LognormalModel, md::AbstractMarketData)
    (; k, t) = option
    forward = spot(md) * exp(growth_rate(model, md, t) * t)
    deviation = volatility(md, t) * √t
    d1 = log(forward / k) / deviation + deviation / 2
    d2 = d1 - deviation
    discount = discount_factor(md, zero(t), t)

    if isput(option)
        return discount * (k * cdf(Normal(), -d2) - forward * cdf(Normal(), -d1))
    elseif iscall(option)
        return discount * (forward * cdf(Normal(), d1) - k * cdf(Normal(), d2))
    end
end

end # module AnalyticModule
