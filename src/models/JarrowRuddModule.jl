module JarrowRuddModule

using Reexport
using ...Engines
using ...Instruments
using ...MarketData
import ..Model
@reexport import ...Engines: price

export JarrowRudd

"""
    JarrowRudd()

[Jarrow-Rudd model](http://simulations.lpsm.paris/binomial_trees/jr).
"""
struct JarrowRudd <: Model end

function price((; steps)::BinomialEngine, option::Option, ::JarrowRudd, ::EquityMarketData)
    (; s, k, r, σ, t) = option
    Δt = t / steps
    R = exp(r * Δt)
    U = exp((r - σ^2 / 2) * Δt + σ * √Δt)
    D = exp((r - σ^2 / 2) * Δt - σ * √Δt)
    p = (R - D) / (U - D)
    q = (U - R) / (U - D)

    if isput(option)
        Z = [max(0, k - s * exp((2 * i - steps) * σ * √Δt)) for i in 0:steps]
    elseif iscall(option)
        Z = [max(0, s * exp((2 * i - steps) * σ * √Δt) - k) for i in 0:steps]
    end

    for n in (steps - 1):-1:0, i in 0:n
        if isput(option)
            x = k - s * exp((2 * i - n) * σ * √Δt)
        elseif iscall(option)
            x = s * exp((2 * i - n) * σ * √Δt) - k
        end
        y = (q * Z[i + 1] + p * Z[i + 2]) / exp(r * Δt)
        Z[i + 1] = max(x, y)
    end

    return Z[1]
end

end # module JarrowRuddModule
