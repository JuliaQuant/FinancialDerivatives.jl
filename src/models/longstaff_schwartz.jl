"""
    LongstaffSchwartz()

[Longstaff-Schwartz model](https://en.wikipedia.org/wiki/Longstaff%E2%80%93Schwartz_model).
"""
struct LongstaffSchwartz <: Model end

"""
    evaluate(O, LongstaffSchwartz(), N = 1000, P = 10000)

Evaluate option `O` using `LongstaffSchwartz` binomial model.

# Arguments
- `N`: number of paths to simulate
- `P`: number of periods
"""
function evaluate(O::AmericanOption, m::LongstaffSchwartz, N::Int64 = 1000, P::Int64 = 10000)
    Δt = O.t / N
    R = exp(O.r * Δt)
    T = typeof(O.s * exp(-O.σ^2 * Δt / 2 + O.σ * √Δt * 0.1) / R)
    X = Array{T}(undef, N+1, P)

    for p = 1:P
        X[1, p] = x = O.s
        for n = 1:N
            x *= R * exp(-O.σ^2 * Δt / 2 + O.σ * √Δt * randn())
            X[n+1, p] = x
        end
    end

    if O.call == -1
        V = [max(O.k - x, 0) / R for x in X[N+1, :]]
    elseif O.call == 1
        V = [max(x - O.k, 0) / R for x in X[N+1, :]]
    end

    for n = N-1:-1:1
        I = V .!= 0
        A = [x^d for d = 0:3, x in X[n+1, :]]
        β = A[:, I]' \ V[I]
        cV = A' * β
        for p = 1:P
            ev = max(O.k - X[n+1, p], 0)
            if I[p] && cV[p] < ev
                V[p] = ev / R
            else
                V[p] /= R
            end
        end
    end

    if O.call == -1
        return max(mean(V), O.k - O.s)
    elseif O.call == 1
        return max(mean(V), O.s - O.k)
    end
end
