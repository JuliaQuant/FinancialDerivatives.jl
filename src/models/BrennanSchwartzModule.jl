module BrennanSchwartzModule

using Reexport
using ...Engines
using ...Instruments
using ...MarketData
import ..Model
@reexport import ...Engines: price

export BrennanSchwartz

"""
    BrennanSchwartz()

[Brennan and Schwartz model](https://link.springer.com/chapter/10.1057/9781403946027_3).
"""
struct BrennanSchwartz <: Model end

function price(engine::BinomialEngine, ird::InterestRateDerivative, ::BrennanSchwartz,
               ::InterestRateMarketData)
    IRD = ird
    n = engine.steps
    Δt = IRD.t / n
    rates = [IRD.r]
    for i in 0:n
        dr = IRD.k * (IRD.θ - rates[end]) * Δt + IRD.σ * randn()
        append!(rates, rates[end] + dr)
    end
    return rates
end

end # module BrennanSchwartzModule
