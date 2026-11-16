module VasicekModule

import ..ShortRateModel, ..drift, ..diffusion

export Vasicek

"""
Select the [Vasicek model](https://en.wikipedia.org/wiki/Vasicek_model) of the short rate.

The short rate ``r`` follows

```math
dr = k (θ - r)\\,dt + σ\\,dW
```

The diffusion term does not depend on ``r``. The
[`InterestRateMarketData`](@ref FinancialDerivatives.MarketData.InterestRateMarketData)
supplies the initial rate.

# References
- Vasicek, O. (1977). An equilibrium characterization of the term structure. *Journal of
  Financial Economics*, 5(2), 177-188.
  [doi:10.1016/0304-405X(77)90016-2](https://doi.org/10.1016/0304-405X%2877%2990016-2)
"""
Base.@kwdef struct Vasicek{KT<:Real,θT<:Real,σT<:Real} <: ShortRateModel
    "Speed of the reversion to the long-term mean"
    k::KT
    "Long-term mean of the short rate"
    θ::θT
    "Volatility of the short rate"
    σ::σT
end

drift((; k, θ)::Vasicek, _, _, r) = k * (θ - r)
diffusion((; σ)::Vasicek, _, _, _) = σ

end # module VasicekModule
