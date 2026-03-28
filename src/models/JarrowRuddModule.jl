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

function price(engine::BinomialEngine, option::Option, ::JarrowRudd, ::EquityMarketData)
    O = option
    N = engine.steps
    Δt = O.t / N
    R = exp(O.r * Δt)
    U = exp((O.r - O.σ^2 / 2) * Δt + O.σ * √Δt)
    D = exp((O.r - O.σ^2 / 2) * Δt - O.σ * √Δt)
    p = (R - D) / (U - D)
    q = (U - R) / (U - D)

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

end # module JarrowRuddModule
