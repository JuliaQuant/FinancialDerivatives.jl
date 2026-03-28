module RendlemanBartterModule

using Reexport
using ...Engines
using ...Instruments
using ...MarketData
import ..Model
@reexport import ...Engines: price

export RendlemanBartter

"""
    RendlemanBartter()

[Rendleman-Bartter model](https://en.wikipedia.org/wiki/Rendleman%E2%80%93Bartter_model).
"""
struct RendlemanBartter <: Model end

function price(engine::BinomialEngine, ird::InterestRateDerivative, ::RendlemanBartter,
               ::InterestRateMarketData)
    IRD = ird
    n = engine.steps
    Δt = IRD.t / n
    rates = [IRD.r]
    for i in 0:n
        dr = IRD.θ * rates[end] * Δt + IRD.θ * rates[end] * randn()
        append!(rates, rates[end] + dr)
    end
    return rates
end

function price(engine::BinomialEngine, option::Option, ::RendlemanBartter,
               ::EquityMarketData)
    O = option
    N = engine.steps
    k = 1
    Δt = O.t / N
    p = 1 / (1 + k^2)
    q = 1 - p

    if isput(O)
        Z = [max(0, O.k - O.s * exp((2 * i - N) * O.σ * √Δt)) for i in 0:N]
    elseif iscall(O)
        Z = [max(0, O.s * exp((2 * i - N) * O.σ * √Δt) - O.k) for i in 0:N]
    end

    for n in (N - 1):-1:0, i in 0:n
        if isput(O)
            x = O.k - O.s * exp((2 * i - n) * O.σ * √Δt)
        elseif iscall(O)
            x = O.s * exp((2 * i - n) * O.σ * √Δt) - O.k
        end
        y = (q * Z[i + 1] + p * Z[i + 2]) / exp(O.r * Δt)
        Z[i + 1] = max(x, y)
    end

    return Z[1]
end

end # module RendlemanBartterModule
