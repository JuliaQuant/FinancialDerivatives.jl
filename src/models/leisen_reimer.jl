"""
LeisenReimer binomial model
"""
struct LeisenReimer <: Model end

function h(z::T, n::Int64) where {T<:Number}
    return 0.5 + sign(z) * 0.5 * sqrt(1 - exp(-((z / (n + 1.0 / 3.0))^2.0) * (n + 1.0 / 6.0)))
end

"""
    evaluate(O, LeisenReimer(), N = 1001)

Evaluate option `O` using `LeisenReimer` binomial model.

# Arguments
- `N`: number of paths to simulate, must be odd
"""
function evaluate(O::Option, m::LeisenReimer, N::Int64 = 1001)
    Δt = 0.01 # O.t / N
    R = exp(O.r * Δt)
    d1 = (log(O.s / O.k) + (O.r + O.σ * O.σ / 2) * O.t) / (O.σ * √O.t)
    d2 = d1 - O.σ * √O.t
    p = h(d2, N)
    q = 1 - p

    if O.call == -1
        Z = [max(0, O.k - O.s * exp((2 * i - N) * O.σ * √Δt)) for i = 0:N]
    elseif O.call == 1
        Z = [max(0, O.s * exp((2 * i - N) * O.σ * √Δt) - O.k) for i = 0:N]
    end
    
    for n = N-1:-1:0, i = 0:n
        if O.call == -1
            x = O.k - O.s * exp((2 * i - n) * O.σ * √Δt)
        elseif O.call == 1
            x = O.s * exp((2 * i - n) * O.σ * √Δt) - O.k
        end
        y = (q * Z[i+1] + p * Z[i+2]) / exp(O.r * Δt)
        Z[i+1] = max(x, y)
    end
    
    return Z[1]
end
