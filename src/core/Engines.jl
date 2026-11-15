module Engines

export PricingEngine
export AnalyticEngine, BinomialEngine, MonteCarloEngine, FiniteDifferenceEngine
export price

"""
Abstract supertype for the numerical pricing methods: analytic, binomial tree, Monte Carlo, and finite difference.

Each subtype is a strategy of the Strategy pattern. A subtype holds the settings of its
numerical method, for example the number of tree steps.

To add an engine, define a subtype and the [`price`](@ref) methods that take the subtype
as the first argument.
"""
abstract type PricingEngine end

"Pricing engine for instruments with closed-form or semi-analytic solutions."
struct AnalyticEngine <: PricingEngine end

"Pricing engine based on recombining binomial tree methods."
Base.@kwdef struct BinomialEngine <: PricingEngine
    "Number of time steps in the tree"
    steps::Int = 1000
end

"Pricing engine based on Monte Carlo simulation."
Base.@kwdef struct MonteCarloEngine <: PricingEngine
    "Number of simulated paths"
    num_paths::Int = 10_000
    "Number of time steps per path"
    num_steps::Int = 1_000
end

"Pricing engine based on finite-difference PDE methods."
struct FiniteDifferenceEngine <: PricingEngine end

"""
    price(engine, instrument, model, market_data) -> Real

Compute the fair value of `instrument` under `model` with `engine` and `market_data`.

This declaration has no methods. It is the abstract interface of the package (dependency
inversion). The model modules depend on this declaration and add the methods.

Multiple dispatch selects the method from the types of the four arguments.
Each supported combination of types has one method.
If a combination has no method, `price` throws a `MethodError`.
"""
function price end

end # module
