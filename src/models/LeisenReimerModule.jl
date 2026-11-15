module LeisenReimerModule

using Reexport
using ...Engines
using ...Instruments
using ...MarketData
import ..Model
@reexport import ...Engines: price

export LeisenReimer

"""
    LeisenReimer()

[Leisen-Reimer binomial model](http://www.goddardconsulting.ca/option-pricing-binomial-alts.html#lr).
"""
struct LeisenReimer <: Model end

function h(z::T, n::Int64) where {T<:Number}
    return 0.5 +
           sign(z) * 0.5 * sqrt(1 - exp(-((z / (n + 1.0 / 3.0))^2.0) * (n + 1.0 / 6.0)))
end

function price((; steps)::BinomialEngine, option::Option, ::LeisenReimer,
               ::EquityMarketData)
    (; s, k, r, σ, t) = option
    Δt = 0.01 # t / steps
    R = exp(r * Δt)
    d1 = (log(s / k) + (r + σ^2 / 2) * t) / (σ * √t)
    d2 = d1 - σ * √t
    p = h(d2, steps)
    q = 1 - p

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

end # module LeisenReimerModule
