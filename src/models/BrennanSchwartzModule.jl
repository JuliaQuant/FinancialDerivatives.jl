module BrennanSchwartzModule

import ..ShortRateModel, ..drift, ..diffusion

export BrennanSchwartz

"""
Select the one-factor Brennan-Schwartz model of the short rate.

The short rate `r` follows `dr = k (θ - r) dt + σ r dW`. The diffusion term is proportional to
`r`. The
[`InterestRateMarketData`](@ref FinancialDerivatives.MarketData.InterestRateMarketData)
supplies the initial rate.

# References
- Brennan, M. J., and Schwartz, E. S. (1980). Analyzing convertible bonds. *The Journal of
  Financial and Quantitative Analysis*, 15(4), 907-929.
  [doi:10.2307/2330567](https://doi.org/10.2307/2330567)
"""
Base.@kwdef struct BrennanSchwartz{KT<:Real,θT<:Real,σT<:Real} <: ShortRateModel
    "Speed of the reversion to the long-term mean"
    k::KT
    "Long-term mean of the short rate"
    θ::θT
    "Volatility of the short rate, as a fraction of the rate"
    σ::σT
end

drift((; k, θ)::BrennanSchwartz, _, _, r) = k * (θ - r)
diffusion((; σ)::BrennanSchwartz, _, _, r) = σ * r

end # module BrennanSchwartzModule
