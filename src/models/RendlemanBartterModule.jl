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

Select the [Rendleman-Bartter model](https://en.wikipedia.org/wiki/Rendleman%E2%80%93Bartter_model).

For an [`InterestRateDerivative`](@ref), the short rate `r` follows `dr = θ r dt + σ r dW`.
The drift term and the diffusion term are proportional to `r`. The `InterestRateDerivative`
supplies `θ`, `σ` and the initial rate.

# References
- Rendleman, R. J., and Bartter, B. J. (1980). The pricing of options on debt securities.
  *The Journal of Financial and Quantitative Analysis*, 15(1), 11-24.
  [doi:10.2307/2979016](https://doi.org/10.2307/2979016)
"""
struct RendlemanBartter <: Model end

function price((; steps)::BinomialEngine, (; r, σ, θ, t)::InterestRateDerivative,
               ::RendlemanBartter,
               ::InterestRateMarketData)
    Δt = t / steps
    rates = [r]
    for _ in 1:steps
        dr = θ * rates[end] * Δt + σ * rates[end] * √Δt * randn()
        append!(rates, rates[end] + dr)
    end
    return rates
end

function price((; steps)::BinomialEngine, option::Option, ::RendlemanBartter,
               ::EquityMarketData)
    (; s, k, r, σ, t) = option
    c = 1
    Δt = t / steps
    p = 1 / (1 + c^2)
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

end # module RendlemanBartterModule
