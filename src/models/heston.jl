using QuadGK: quadgk

"""
[Heston model](https://en.wikipedia.org/wiki/Heston_model).
"""
@kwdef struct HestonModel{VT<:Real,VVT<:Real,KT<:Real,RT<:Real}
    "Initial stock variance"
    v::VT
    "Long term variance mean"
    v̄::VVT
    "Mean reversion term of stock variance `v`"
    κ::KT
    "Correlation between stock price `s` and it's variance `v`"
    ρ::RT
end

""""
Evaluate option `O` using the [`HestonModel`](@ref) model.
"""
function evaluate(O::EuropeanOption, m::HestonModel; N=100)
    k, t, s, q, r, σ = O.k, O.t, O.s, O.q, O.r, O.σ
    κ, v̄ = m.κ, m.v̄

    2 * κ * v̄ ≥ σ^2 ||
        throw(ArgumentError("The Feller condition is not satisfied: 2κθ ≥ σ^2"))

    function integrand1(ω)
        return real(exp(-im * ω * log(k)) * φ(O, m, ω - im) /
                    (im * ω * φ(O, m, -im)))
    end

    function integrand2(ω)
        return real(exp(-im * ω * log(k)) * φ(O, m, ω) /
                    (im * ω))
    end

    π1, _ = quadgk(integrand1, 0, N)
    π2, _ = quadgk(integrand2, 0, N)

    π1 = π1 / π + 0.5
    π2 = π2 / π + 0.5

    C = s * exp(-q * t) * π1 - k * exp(-r * t) * π2
    if iscall(O)
        C
    elseif isput(O) # Calculate the put option value using put-call parity
        P = C + k * exp(-r * t) - s * exp(-q * t)
    end
end

"""
Characteristic function Heston model for an European call option: 
"""
function φ(O::EuropeanOption, m::HestonModel, ω::Number)
    (; v, v̄, κ, ρ) = m
    s, r, q, σ, t = O.s, O.r, O.q, O.σ, O.t

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
