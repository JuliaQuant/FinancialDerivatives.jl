module RendlemanBartterModule

import ..ShortRateModel, ..drift, ..diffusion

export RendlemanBartter

"""
Select the [Rendleman-Bartter model](https://en.wikipedia.org/wiki/Rendleman%E2%80%93Bartter_model) of the short rate.

The short rate `r` follows `dr = θ r dt + σ r dW`. The drift term and the diffusion term
are proportional to `r`. The
[`InterestRateMarketData`](@ref FinancialDerivatives.MarketData.InterestRateMarketData)
supplies the initial rate.

# References
- Rendleman, R. J., and Bartter, B. J. (1980). The pricing of options on debt securities.
  *The Journal of Financial and Quantitative Analysis*, 15(1), 11-24.
  [doi:10.2307/2979016](https://doi.org/10.2307/2979016)
"""
Base.@kwdef struct RendlemanBartter{θT<:Real,σT<:Real} <: ShortRateModel
    "Drift of the short rate, as a fraction of the rate"
    θ::θT
    "Volatility of the short rate, as a fraction of the rate"
    σ::σT
end

drift((; θ)::RendlemanBartter, _, _, r) = θ * r
diffusion((; σ)::RendlemanBartter, _, _, r) = σ * r

end # module RendlemanBartterModule
