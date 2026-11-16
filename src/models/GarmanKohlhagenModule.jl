module GarmanKohlhagenModule

using ...MarketData
import ..LognormalModel, ..growth_rate

export GarmanKohlhagen

"""
[Garman–Kohlhagen model](https://en.wikipedia.org/wiki/Foreign_exchange_option#Valuation:_the_Garman%E2%80%93Kohlhagen_model).
"""
struct GarmanKohlhagen <: LognormalModel end

growth_rate(::GarmanKohlhagen, md, t) = discount_rate(md, t) - foreign_rate(md, t)

end # module GarmanKohlhagenModule
