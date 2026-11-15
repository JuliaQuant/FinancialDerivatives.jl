module TianModule

using Reexport
using ...Engines
using ...Instruments
using ...MarketData
import ..Model
@reexport import ...Engines: price

export Tian

"""
    Tian()

[Tian binomial model](http://simulations.lpsm.paris/binomial_trees/tian).
"""
struct Tian <: Model end

function price((; steps)::BinomialEngine, option::Option, ::Tian, ::EquityMarketData)
    (; s, k, r, σ, t) = option
    Δt = t / steps
    R = exp(r * Δt)
    v = exp(σ^2 * Δt)
    U = 0.5 * R * v * (v + 1 + sqrt(v^2 + 2 * v - 3))
    D = 0.5 * R * v * (v + 1 - sqrt(v^2 + 2 * v - 3))
    p = (R - D) / (U - D)
    q = (U - R) / (U - D)

    Z = if isput(option)
        [max(0, k - s * exp((2 * i - steps) * σ * √Δt)) for i in 0:steps]
    elseif iscall(option)
        [max(0, s * exp((2 * i - steps) * σ * √Δt) - k) for i in 0:steps]
    end

    for n in (steps - 1):-1:0, i in 0:n
        if isput(option)
            x = k - s * exp((2 * i - n) * σ * √Δt)
        elseif iscall(option)
            x = s * exp((2 * i - n) * σ * √Δt) - k
        end
        y = (q * Z[i + 1] + p * Z[i + 2]) / R
        Z[i + 1] = max(x, y)
    end

    return Z[1]
end

end # module TianModule
