module CoxIngersollRossModule

using Reexport
using ...Engines
using ...Instruments
using ...MarketData
import ..Model
@reexport import ...Engines: price

export CoxIngersollRoss

"""
    CoxIngersollRoss()

[Cox-Ingersoll-Ross model](https://en.wikipedia.org/wiki/Cox%E2%80%93Ingersoll%E2%80%93Ross_model).
"""
struct CoxIngersollRoss <: Model end

function price(engine::BinomialEngine, ird::InterestRateDerivative, ::CoxIngersollRoss,
               ::InterestRateMarketData)
    IRD = ird
    n = engine.steps
    Δt = IRD.t / n
    rates = [IRD.r]
    for i in 0:n
        dr = IRD.k * (IRD.θ - rates[end]) * Δt + IRD.σ * √rates[end] * randn()
        append!(rates, rates[end] + dr)
    end
    return rates
end

end # module CoxIngersollRossModule
