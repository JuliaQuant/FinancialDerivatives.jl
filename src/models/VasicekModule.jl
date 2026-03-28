module VasicekModule

using Reexport
using ...Engines
using ...Instruments
using ...MarketData
import ..Model
@reexport import ...Engines: price

export Vasicek

"""
    Vasicek()

[Vasicek model](https://en.wikipedia.org/wiki/Vasicek_model).
"""
struct Vasicek <: Model end

function price(engine::BinomialEngine, ird::InterestRateDerivative, ::Vasicek,
               ::InterestRateMarketData)
    IRD = ird
    n = engine.steps
    Δt = IRD.t / n
    rates = [IRD.r]
    for i in 0:n
        dr = IRD.k * (IRD.θ - rates[end]) * Δt + IRD.σ * rates[end] * randn()
        append!(rates, rates[end] + dr)
    end
    return rates
end

end # module VasicekModule
