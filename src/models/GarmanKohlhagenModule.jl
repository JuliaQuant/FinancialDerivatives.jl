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
    O = option
    d1 = (log(O.s / O.k) + (O.r_d - O.r_f * O.σ / 2) * O.t) / (O.σ * √O.t)
    d2 = d1 - O.σ * √O.t

    if isput(O)
        return O.k * exp(-O.r_d * O.t) * cdf(Normal(), -d2) -
               O.s * exp(-O.r_f * O.t) * cdf(Normal(), -d1)
    elseif iscall(O)
        return O.s * exp(-O.r_f * O.t) * cdf(Normal(), d1) -
               O.k * exp(-O.r_d * O.t) * cdf(Normal(), d2)
    end
end

end # module GarmanKohlhagenModule
