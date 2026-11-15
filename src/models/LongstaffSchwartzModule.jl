module LongstaffSchwartzModule

using Reexport
using Statistics: mean
using ...Engines
using ...Instruments
using ...MarketData
import ..Model
@reexport import ...Engines: price

export LongstaffSchwartz

"""
    LongstaffSchwartz()

[Longstaff-Schwartz model](https://en.wikipedia.org/wiki/Longstaff%E2%80%93Schwartz_model).
"""
struct LongstaffSchwartz <: Model end

function price((; num_steps, num_paths)::MonteCarloEngine, option::AmericanOption,
               ::LongstaffSchwartz, ::EquityMarketData)
    (; s, k, r, σ, t) = option
    Δt = t / num_steps
    R = exp(r * Δt)
    T = typeof(s * exp(-σ^2 * Δt / 2 + σ * √Δt * 0.1) / R)
    X = Array{T}(undef, num_steps + 1, num_paths)

    for p in 1:num_paths
        X[1, p] = x = s
        for n in 1:num_steps
            x *= R * exp(-σ^2 * Δt / 2 + σ * √Δt * randn())
            X[n + 1, p] = x
        end
    end

    if isput(option)
        V = [max(k - x, 0) / R for x in X[num_steps + 1, :]]
    elseif iscall(option)
        V = [max(x - k, 0) / R for x in X[num_steps + 1, :]]
    end

    for n in (num_steps - 1):-1:1
        I = V .!= 0
        A = [x^d for d in 0:3, x in X[n + 1, :]]
        β = A[:, I]' \ V[I]
        cV = A' * β
        for p in 1:num_paths
            ev = max(k - X[n + 1, p], 0)
            if I[p] && cV[p] < ev
                V[p] = ev / R
            else
                V[p] /= R
            end
        end
    end

    if isput(option)
        return max(mean(V), k - s)
    elseif iscall(option)
        return max(mean(V), s - k)
    end
end

end # module LongstaffSchwartzModule
