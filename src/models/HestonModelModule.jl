module HestonModelModule

using Reexport
using QuadGK: quadgk
using ...Engines
using ...Instruments
using ...MarketData
import ..Model

@reexport import ...Engines: price

export HestonModel

"""
[Heston model](https://en.wikipedia.org/wiki/Heston_model).
"""
@kwdef struct HestonModel{VT<:Real,VVT<:Real,KT<:Real,σT<:Real,RT<:Real} <: Model
    "Initial stock variance"
    v::VT
    "Long term variance mean"
    v̄::VVT
    "Mean reversion term of stock variance `v`"
    κ::KT
    "Volatility of stock variance `v`"
    σ::σT
    "Correlation between stock price `s` and it's variance `v`"
    ρ::RT
end

"""
Characteristic function Heston model for an European call option from [A Closed-Form Solution for Options with Stochastic Volatility with Applications to Bond and Currency Options, L. Heston](https://www.jstor.org/stable/2962057)
"""
function φ((; t)::EuropeanOption, (; v, v̄, κ, σ, ρ)::HestonModel,
           md::AbstractMarketData, ω::Number)
    s, q, r = spot(md), dividend_yield(md), discount_rate(md, t)

    α = -ω^2 / 2 - im * ω / 2
    β = κ - ρ * σ * im * ω
    γ = σ^2 / 2
    h = sqrt(β^2 - 4 * α * γ)
    r₊ = (β + h) / σ^2
    r₋ = (β - h) / σ^2
    g = r₋ / r₊
    C = κ * (r₋ * t - (2 / σ^2) * log((1 - g * exp(-h * t)) / (1 - g)))
    D = r₋ * (1 - exp(-h * t)) / (1 - g * exp(-h * t))

    return exp(C * v̄ + D * v + im * ω * log(s * exp((r - q) * t)))
end

function price(::AnalyticEngine, option::EuropeanOption, model::HestonModel,
               md::AbstractMarketData; N=100)
    (; k, t) = option
    s, q, r = spot(md), dividend_yield(md), discount_rate(md, t)
    (; σ, κ, v̄) = model

    2 * κ * v̄ ≥ σ^2 ||
        throw(ArgumentError("The Feller condition is not satisfied: 2κθ ≥ σ^2"))

    integrand1(ω::Real)::Real = real(exp(-im * ω * log(k)) * φ(option, model, md, ω - im) /
                                     (im * ω * φ(option, model, md, -im)))

    integrand2(ω::Real)::Real = real(exp(-im * ω * log(k)) * φ(option, model, md, ω) /
                                     (im * ω))

    π1, _ = quadgk(integrand1, 0, N)
    π2, _ = quadgk(integrand2, 0, N)

    π1 = π1 / π + 0.5
    π2 = π2 / π + 0.5

    C = s * exp(-q * t) * π1 - k * exp(-r * t) * π2
    if iscall(option)
        C
    elseif isput(option)
        P = C + k * exp(-r * t) - s * exp(-q * t)
    end
end

end # module HestonModelModule
