module Engines

export PricingEngine
export AnalyticEngine, BinomialEngine, MonteCarloEngine, FiniteDifferenceEngine
export price

"""
Abstract supertype for numerical pricing methods (analytic, binomial tree, Monte Carlo, FD).
Subtypes should implement:
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

Compute the fair value of `instrument` under `model` using `engine` and `market_data`.
"""
function price end

end # module
