module BlackKarasinskiModule

using Reexport
using ...Engines
using ...Instruments
using ...MarketData
import ..Model
@reexport import ...Engines: price

export BlackKarasinski

"""
    BlackKarasinski()

Select the [Black-Karasinski model](https://en.wikipedia.org/wiki/Black%E2%80%93Karasinski_model) of the short rate.

The logarithm of the short rate `r` follows `d ln r = k (ln θ - ln r) dt + σ dW`. The short
rate is always positive. `θ` is a rate. `ln θ` is the long-term mean of `ln r`.

The [`InterestRateDerivative`](@ref) supplies `k`, `θ`, `σ` and the initial rate. `θ` and the
initial rate. 

# References
- Black, F., and Karasinski, P. (1991). Bond and option pricing when short rates are
  lognormal. *Financial Analysts Journal*, 47(4), 52-59.
  [doi:10.2469/faj.v47.n4.52](https://doi.org/10.2469/faj.v47.n4.52)
"""
struct BlackKarasinski <: Model end

function price((; steps)::BinomialEngine, (; k, r, σ, θ, t)::InterestRateDerivative,
               ::BlackKarasinski,
               ::InterestRateMarketData)
    Δt = t / steps
    rates = [r]
    x = log(r)
    for _ in 1:steps
        x += k * (log(θ) - x) * Δt + σ * √Δt * randn()
        append!(rates, exp(x))
    end
    return rates
end

end # module BlackKarasinskiModule
