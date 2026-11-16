module CoxIngersollRossModule

import ..ShortRateModel, ..drift, ..diffusion

export CoxIngersollRoss

"""
Select the [Cox-Ingersoll-Ross model](https://en.wikipedia.org/wiki/Cox%E2%80%93Ingersoll%E2%80%93Ross_model) of the short rate.

The short rate ``r`` follows

```math
dr = k (θ - r)\\,dt + σ \\sqrt{r}\\,dW
```

The diffusion term is proportional to ``\\sqrt{r}``. The
[`InterestRateMarketData`](@ref FinancialDerivatives.MarketData.InterestRateMarketData)
supplies the initial rate.

# References
- Cox, J. C., Ingersoll, J. E., and Ross, S. A. (1985). A theory of the term structure of
  interest rates. *Econometrica*, 53(2), 385-407.
  [doi:10.2307/1911242](https://doi.org/10.2307/1911242)
"""
Base.@kwdef struct CoxIngersollRoss{KT<:Real,θT<:Real,σT<:Real} <: ShortRateModel
    "Speed of the reversion to the long-term mean"
    k::KT
    "Long-term mean of the short rate"
    θ::θT
    "Volatility of the short rate, as a multiple of the square root of the rate"
    σ::σT
end

drift((; k, θ)::CoxIngersollRoss, _, _, r) = k * (θ - r)
# An Euler step can push the rate below zero, where the square root fails.
diffusion((; σ)::CoxIngersollRoss, _, _, r) = σ * √(max(r, 0))

end # module CoxIngersollRossModule
