module BlackKarasinskiModule

import ..ShortRateModel, ..drift, ..diffusion, ..evolve

export BlackKarasinski

"""
    BlackKarasinski(k, θ, σ)

Select the [Black-Karasinski model](https://en.wikipedia.org/wiki/Black%E2%80%93Karasinski_model) of the short rate.

The logarithm of the short rate `r` follows `d ln r = k (ln θ - ln r) dt + σ dW`. The short
rate is always positive. `θ` is a rate. `ln θ` is the long-term mean of `ln r`.

The
[`InterestRateMarketData`](@ref FinancialDerivatives.MarketData.InterestRateMarketData)
supplies the initial rate.

# References
- Black, F., and Karasinski, P. (1991). Bond and option pricing when short rates are
  lognormal. *Financial Analysts Journal*, 47(4), 52-59.
  [doi:10.2469/faj.v47.n4.52](https://doi.org/10.2469/faj.v47.n4.52)
"""
Base.@kwdef struct BlackKarasinski{KT<:Real,θT<:Real,σT<:Real} <: ShortRateModel
    "Speed of the reversion of `ln r` to `ln θ`"
    k::KT
    "Rate whose logarithm is the long-term mean of `ln r`"
    θ::θT
    "Volatility of `ln r`"
    σ::σT
end

# Ito's lemma gives the coefficients of `r` from the coefficients of `ln r`.
drift((; k, θ, σ)::BlackKarasinski, _, _, r) = r * (k * (log(θ) - log(r)) + σ^2 / 2)
diffusion((; σ)::BlackKarasinski, _, _, r) = σ * r

# A step on `ln r` keeps the rate positive.
function evolve((; k, θ, σ)::BlackKarasinski, _, _, r, Δt, z)
    x = log(r)
    return exp(x + k * (log(θ) - x) * Δt + σ * √Δt * z)
end

end # module BlackKarasinskiModule
