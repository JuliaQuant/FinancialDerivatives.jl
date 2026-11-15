module BrennanSchwartzModule

using Reexport
using ...Engines
using ...Instruments
using ...MarketData
import ..Model
@reexport import ...Engines: price

export BrennanSchwartz

"""
    BrennanSchwartz()

Select the one-factor Brennan-Schwartz model of the short rate.

The short rate `r` follows `dr = k (θ - r) dt + σ r dW`. The diffusion term is proportional to
`r`. The [`InterestRateDerivative`](@ref) supplies `k`, `θ`, `σ` and the initial rate. 

# References
- Brennan, M. J., and Schwartz, E. S. (1980). Analyzing convertible bonds. *The Journal of
  Financial and Quantitative Analysis*, 15(4), 907-929.
  [doi:10.2307/2330567](https://doi.org/10.2307/2330567)
"""
struct BrennanSchwartz <: Model end

function price((; steps)::BinomialEngine, (; k, r, σ, θ, t)::InterestRateDerivative,
               ::BrennanSchwartz,
               ::InterestRateMarketData)
    Δt = t / steps
    rates = [r]
    for _ in 1:steps
        dr = k * (θ - rates[end]) * Δt + σ * rates[end] * √Δt * randn()
        append!(rates, rates[end] + dr)
    end
    return rates
end

end # module BrennanSchwartzModule
