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

Select the [Cox-Ingersoll-Ross model](https://en.wikipedia.org/wiki/Cox%E2%80%93Ingersoll%E2%80%93Ross_model) of the short rate.

The short rate `r` follows `dr = k (θ - r) dt + σ √r dW`. The diffusion term is proportional to
`√r`. The [`InterestRateDerivative`](@ref) supplies `k`, `θ`, `σ` and the initial rate.

# References
- Cox, J. C., Ingersoll, J. E., and Ross, S. A. (1985). A theory of the term structure of
  interest rates. *Econometrica*, 53(2), 385-407.
  [doi:10.2307/1911242](https://doi.org/10.2307/1911242)
"""
struct CoxIngersollRoss <: Model end

function price((; steps)::BinomialEngine, (; k, r, σ, θ, t)::InterestRateDerivative,
               ::CoxIngersollRoss,
               ::InterestRateMarketData)
    Δt = t / steps
    rates = [r]
    for _ in 1:steps
        # An Euler step can push the rate below zero, where the square root fails.
        dr = k * (θ - rates[end]) * Δt + σ * √(max(rates[end], 0)) * √Δt * randn()
        append!(rates, rates[end] + dr)
    end
    return rates
end

end # module CoxIngersollRossModule
