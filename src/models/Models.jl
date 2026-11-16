module Models

using Reexport
using ..MarketData

export OneFactorModel, LognormalModel, ShortRateModel
export drift, diffusion, growth_rate, initial_state

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
Abstract supertype for the models with one state that one Brownian motion drives.

The state ``x`` follows the diffusion process

```math
dx = a(t, x)\\,dt + b(t, x)\\,dW
```

``W`` is the Brownian motion. The drift term is ``a(t, x)\\,dt``, and [`drift`](@ref)
returns ``a``. The diffusion term is ``b(t, x)\\,dW``, and [`diffusion`](@ref) returns
``b``. The diffusion term is the random shock of the process.

[`simulate`](@ref FinancialDerivatives.Engines.simulate) accepts each subtype.

To add a model, define a subtype and its [`initial_state`](@ref), [`drift`](@ref) and
[`diffusion`](@ref) methods. `simulate` then moves the state with Euler-Maruyama steps.
If the model has a better step, define a [`transition`](@ref) method for the subtype.
"""
abstract type OneFactorModel <: Model end

"""
Abstract supertype for the models in which the price of the underlying is lognormal.

The state is the price ``s`` of the underlying. The price follows the diffusion process

```math
ds = g(t)\\,s\\,dt + σ(t)\\,s\\,dW
```

The drift term is ``g(t)\\,s\\,dt``, and the diffusion term is ``σ(t)\\,s\\,dW``. ``g`` is
the growth rate in the risk-neutral measure, and ``σ`` is the volatility.

[`growth_rate`](@ref) returns the mean of ``g`` between the time zero and the horizon ``t``.
The volatility of the market data is the square root of the mean of ``σ^2`` in the same
interval.

The
[`AnalyticEngine`](@ref FinancialDerivatives.Engines.AnalyticEngine), the
[`BinomialEngine`](@ref FinancialDerivatives.Engines.BinomialEngine) and the
[`MonteCarloEngine`](@ref FinancialDerivatives.Engines.MonteCarloEngine) accept each subtype.

To add a model, define a subtype and a [`growth_rate`](@ref) method for that subtype.
"""
abstract type LognormalModel <: OneFactorModel end

"""
Abstract supertype for the models of the short rate.

The state is the short rate ``r``. The rate follows the diffusion process

```math
dr = a(t, r)\\,dt + b(t, r)\\,dW
```

[`drift`](@ref) returns ``a``, and [`diffusion`](@ref) returns ``b``.

The market data supplies the initial rate.

To add a model, define a subtype and its [`drift`](@ref) and [`diffusion`](@ref) methods.
"""
abstract type ShortRateModel <: OneFactorModel end

"""
    initial_state(model, md)

Return the state of `model` at the time zero.
"""
function initial_state end

initial_state(::LognormalModel, md) = spot(md)
initial_state(::ShortRateModel, md) = short_rate(md)

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

"""
Return the function that moves the state of `model` from the time `t1` to the time `t2`.

The result is a function `(x, z) -> y`. `x` is the state at the time `t1`, `z` is a
standard normal shock, and `y` is the state at the time `t2`.

The method for a [`OneFactorModel`](@ref) is one Euler-Maruyama step.
The method for a [`LognormalModel`](@ref) is exact.
"""
function transition(model::OneFactorModel, md, t1, t2)
    Δt = t2 - t1
    return (x, z) -> x + drift(model, md, t1, x) * Δt +
                     diffusion(model, md, t1, x) * √Δt * z
end

# Growth of the logarithm of the underlying between the times `t1` and `t2`.
# The market data gives each rate for a horizon that starts at the time zero.
function log_growth(model, md, t1, t2)
    return growth_rate(model, md, t2) * t2 - growth_rate(model, md, t1) * t1
end

# Variance of the logarithm of the underlying between the times `t1` and `t2`.
function log_variance(md, t1, t2)
    variance = volatility(md, t2)^2 * t2 - volatility(md, t1)^2 * t1
    variance ≥ 0 ||
        throw(ArgumentError("The total variance of the volatility decreases between the " *
                            "horizons $t1 and $t2 (calendar arbitrage)"))
    return variance
end

function transition(model::LognormalModel, md, t1, t2)
    growth = log_growth(model, md, t1, t2)
    variance = log_variance(md, t1, t2)
    return (x, z) -> x * exp(growth - variance / 2 + √variance * z)
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
