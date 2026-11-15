module VasicekModule

using Reexport
using ...Engines
using ...Instruments
using ...MarketData
import ..Model
@reexport import ...Engines: price

export Vasicek

"""
    Vasicek()

Select the [Vasicek model](https://en.wikipedia.org/wiki/Vasicek_model) of the short rate.

The short rate `r` follows `dr = k (θ - r) dt + σ dW`. The diffusion term does not depend on
`r`. The [`InterestRateDerivative`](@ref) supplies `k`, `θ`, `σ` and the initial rate.

# References
- Vasicek, O. (1977). An equilibrium characterization of the term structure. *Journal of
  Financial Economics*, 5(2), 177-188.
  [doi:10.1016/0304-405X(77)90016-2](https://doi.org/10.1016/0304-405X%2877%2990016-2)
"""
struct Vasicek <: Model end

function price((; steps)::BinomialEngine, (; k, r, σ, θ, t)::InterestRateDerivative,
               ::Vasicek,
               ::InterestRateMarketData)
    Δt = t / steps
    rates = [r]
    for _ in 1:steps
        dr = k * (θ - rates[end]) * Δt + σ * √Δt * randn()
        append!(rates, rates[end] + dr)
    end
    return rates
end

end # module VasicekModule
