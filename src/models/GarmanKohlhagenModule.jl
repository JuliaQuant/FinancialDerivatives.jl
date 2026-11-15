module GarmanKohlhagenModule

using Reexport
using Distributions: cdf, Normal
using ...Engines
using ...Instruments
using ...MarketData
import ..Model
@reexport import ...Engines: price

export GarmanKohlhagen

"""
    GarmanKohlhagen()

[Garman–Kohlhagen model](https://en.wikipedia.org/wiki/Foreign_exchange_option#Valuation:_the_Garman%E2%80%93Kohlhagen_model).
"""
struct GarmanKohlhagen <: Model end

function price(::AnalyticEngine, option::FXOption, ::GarmanKohlhagen, ::FXMarketData)
    (; s, k, r_d, r_f, σ, t) = option
    d1 = (log(s / k) + (r_d - r_f * σ / 2) * t) / (σ * √t)
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
