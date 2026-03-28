module BlackKarasinskiModule

using Reexport
using ...Engines
using ...Instruments
using ...MarketData
import ..Model
@reexport import ...Engines: price

export BlackKarasinski

"""
    BlackKarasinski()

[Black-Karasinski model](https://en.wikipedia.org/wiki/Black%E2%80%93Karasinski_model).
"""
struct BlackKarasinski <: Model end

function price(engine::BinomialEngine, ird::InterestRateDerivative, ::BlackKarasinski,
               ::InterestRateMarketData)
    IRD = ird
    n = engine.steps
    Δt = IRD.t / n
    rates = [IRD.r]
    for i in 0:n
        dr = IRD.k * (IRD.θ - log(rates[end])) * Δt + IRD.σ * rates[end] * randn()
        append!(rates, rates[end] + dr)
    end
    return rates
end

end # module BlackKarasinskiModule
