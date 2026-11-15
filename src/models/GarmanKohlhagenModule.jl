module GarmanKohlhagenModule

using Reexport
using Distributions: cdf, Normal
using ...Engines
using ...Instruments
using ...MarketData
import ..LognormalModel, ..growth_rate
@reexport import ...Engines: price

export GarmanKohlhagen

"""
    GarmanKohlhagen()

[Garman–Kohlhagen model](https://en.wikipedia.org/wiki/Foreign_exchange_option#Valuation:_the_Garman%E2%80%93Kohlhagen_model).
"""
struct GarmanKohlhagen <: LognormalModel end

growth_rate(::GarmanKohlhagen, md, t) = discount_rate(md, t) - foreign_rate(md, t)

function price(::AnalyticEngine, option::FXOption, ::GarmanKohlhagen,
               md::AbstractMarketData)
    (; k, t) = option
    s = spot(md)
    r_d = discount_rate(md, t)
    r_f = foreign_rate(md, t)
    σ = volatility(md, t)
    d1 = (log(s / k) + (r_d - r_f + σ^2 / 2) * t) / (σ * √t)
    d2 = d1 - σ * √t

    if isput(option)
        return k * exp(-r_d * t) * cdf(Normal(), -d2) -
               s * exp(-r_f * t) * cdf(Normal(), -d1)
    elseif iscall(option)
        return s * exp(-r_f * t) * cdf(Normal(), d1) -
               k * exp(-r_d * t) * cdf(Normal(), d2)
    end
end

end # module GarmanKohlhagenModule
