module Models

using Reexport
using ..MarketData

export drift, diffusion

"Abstract supertype for stochastic process models. Subtypes hold model-specific calibrated parameters."
abstract type PricingModel end

"""
Abstract supertype for all the pricing models in this package.

Each subtype is a strategy of the Strategy pattern. A subtype holds the parameters of its
model. The type of the model selects the [`price`](@ref) method.

To add a model with a closed-form formula, define a subtype and a [`price`](@ref) method
for that subtype. To add a model to the generic engines, define a subtype of
[`LognormalModel`](@ref) or of [`ShortRateModel`](@ref).
"""
abstract type Model <: PricingModel end

"""
Abstract supertype for the models in which the price of the underlying is lognormal.

The [`BinomialEngine`](@ref FinancialDerivatives.Engines.BinomialEngine) and the
[`MonteCarloEngine`](@ref FinancialDerivatives.Engines.MonteCarloEngine) accept each subtype.

To add a model, define a subtype and a [`growth_rate`](@ref) method for that subtype.
"""
abstract type LognormalModel <: Model end

"""
Abstract supertype for the models of the short rate.

[`simulate`](@ref FinancialDerivatives.Engines.simulate) accepts each subtype. The market data
supplies the initial rate.

To add a model, define a subtype and its [`drift`](@ref) and [`diffusion`](@ref) methods.
"""
abstract type ShortRateModel <: Model end

"""
    drift(model, md, t, x)

Return the drift coefficient of the state `x` of `model` at the time `t`, in years.
"""
function drift end

"""
    diffusion(model, md, t, x)

Return the diffusion coefficient of the state `x` of `model` at the time `t`, in years.
"""
function diffusion end

"""
    growth_rate(model, md, t)

Return the growth rate of the underlying in the risk-neutral measure for the horizon `t`.
"""
function growth_rate end

initial_state(::LognormalModel, md) = spot(md)
initial_state(::ShortRateModel, md) = short_rate(md)

# Return the state after the time step `Δt`, for the standard normal shock `z`.
# This method is one Euler-Maruyama step. A model with a better step defines its own method.
function evolve(model::Model, md, t, x, Δt, z)
    return x + drift(model, md, t, x) * Δt + diffusion(model, md, t, x) * √Δt * z
end

# Growth and variance of the logarithm of the underlying between the times `t1` and `t2`.
# The market data gives each rate for a horizon that starts at the time zero.
function log_growth(model, md, t1, t2)
    return growth_rate(model, md, t2) * t2 - growth_rate(model, md, t1) * t1
end
log_variance(md, t1, t2) = volatility(md, t2)^2 * t2 - volatility(md, t1)^2 * t1

# `drift` and `diffusion` read the forward values on an interval of this length, in years.
const INSTANT = 1e-4

function drift(model::LognormalModel, md, t, x)
    return log_growth(model, md, t, t + INSTANT) / INSTANT * x
end

function diffusion(::LognormalModel, md, t, x)
    return √(log_variance(md, t, t + INSTANT) / INSTANT) * x
end

# The logarithm of the underlying is normal, thus this step is exact.
function evolve(model::LognormalModel, md, t, x, Δt, z)
    variance = log_variance(md, t, t + Δt)
    return x * exp(log_growth(model, md, t, t + Δt) - variance / 2 + √variance * z)
end

include("BlackKarasinskiModule.jl")
@reexport using .BlackKarasinskiModule

include("BlackScholesModule.jl")
@reexport using .BlackScholesModule

include("BrennanSchwartzModule.jl")
@reexport using .BrennanSchwartzModule

include("CoxIngersollRossModule.jl")
@reexport using .CoxIngersollRossModule

include("GarmanKohlhagenModule.jl")
@reexport using .GarmanKohlhagenModule

include("RendlemanBartterModule.jl")
@reexport using .RendlemanBartterModule

include("VasicekModule.jl")
@reexport using .VasicekModule

include("HestonModelModule.jl")
@reexport using .HestonModelModule

end # module
