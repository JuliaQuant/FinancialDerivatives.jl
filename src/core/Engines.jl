module Engines

using Random: default_rng

export PricingEngine
export AnalyticEngine, BinomialEngine, MonteCarloEngine, FiniteDifferenceEngine
export BinomialScheme
export CoxRossRubinstein, JarrowRudd, LeisenReimer, RendlemanBartterTree, Tian
export price, simulate

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

"""
Abstract supertype for the schemes of the [`BinomialEngine`](@ref).

A scheme sets the two moves of the tree and the probability of the up move. Each subtype
is a strategy of the Strategy pattern.

To add a scheme, define a subtype and a [`tree_parameters`](@ref) method for that subtype.
If the scheme needs a special number of steps, also define a [`tree_steps`](@ref) method.
"""
abstract type BinomialScheme end

"""
[Cox-Ross-Rubinstein binomial model (aka Binomial options pricing model)](https://en.wikipedia.org/wiki/Binomial_options_pricing_model).
"""
struct CoxRossRubinstein <: BinomialScheme end

"""
[Jarrow-Rudd model](http://simulations.lpsm.paris/binomial_trees/jr).
"""
struct JarrowRudd <: BinomialScheme end

"""
[Leisen-Reimer binomial model](http://www.goddardconsulting.ca/option-pricing-binomial-alts.html#lr).

The tree must have an odd number of steps. If `steps` is even, the tree has `steps + 1` steps.
"""
struct LeisenReimer <: BinomialScheme end

"""
Binomial tree of Rendleman and Bartter. The two moves have the same probability.

# References
- Rendleman, R. J., and Bartter, B. J. (1979). Two-state option pricing. *The Journal of
  Finance*, 34(5), 1093-1110.
  [doi:10.1111/j.1540-6261.1979.tb00058.x](https://doi.org/10.1111/j.1540-6261.1979.tb00058.x)
"""
struct RendlemanBartterTree <: BinomialScheme end

"""
[Tian binomial model](http://simulations.lpsm.paris/binomial_trees/tian).
"""
struct Tian <: BinomialScheme end

"""
    tree_parameters(scheme, m, w, x, steps) -> (u, d, p)

Return the up factor `u`, the down factor `d`, and the probability `p` of the up move for
one step of the tree.

The ratio `u / d` must not depend on `m`. If the ratio depends on `m`, the tree does not
recombine.

# Arguments
- `scheme`: the [`BinomialScheme`](@ref) of the tree.
- `m`: the growth factor of the underlying on the step, in the risk-neutral measure.
- `w`: the variance of the logarithm of the underlying on the step.
- `x`: the logarithm of the ratio of the forward price at the expiry to the strike.
- `steps`: the number of time steps in the tree.
"""
function tree_parameters end

"""
    tree_steps(scheme, steps)

Return the number of time steps in the tree of `scheme` for the engine setting `steps`.

The method for a [`BinomialScheme`](@ref) returns `steps`.
"""
function tree_steps end

"Pricing engine based on recombining binomial tree methods."
Base.@kwdef struct BinomialEngine{S<:BinomialScheme} <: PricingEngine
    "Number of time steps in the tree"
    steps::Int = 1000
    "Scheme that sets the moves of the tree and their probabilities"
    scheme::S = CoxRossRubinstein()

    function BinomialEngine{S}(steps, scheme) where {S<:BinomialScheme}
        steps > 0 || throw(ArgumentError("`steps` must be positive, got $steps"))
        return new{S}(steps, scheme)
    end
end

function BinomialEngine(steps, scheme::S) where {S<:BinomialScheme}
    return BinomialEngine{S}(steps, scheme)
end

"Pricing engine based on Monte Carlo simulation."
Base.@kwdef struct MonteCarloEngine{R} <: PricingEngine
    "Number of simulated paths"
    num_paths::Int = 10_000
    "Number of time steps per path"
    num_steps::Int = 1_000
    "Source of the random numbers"
    rng::R = default_rng()

    function MonteCarloEngine{R}(num_paths, num_steps, rng) where {R}
        num_paths > 0 ||
            throw(ArgumentError("`num_paths` must be positive, got $num_paths"))
        num_steps > 0 ||
            throw(ArgumentError("`num_steps` must be positive, got $num_steps"))
        return new{R}(num_paths, num_steps, rng)
    end
end

function MonteCarloEngine(num_paths, num_steps, rng::R) where {R}
    return MonteCarloEngine{R}(num_paths, num_steps, rng)
end

"Pricing engine based on finite-difference PDE methods."
struct FiniteDifferenceEngine <: PricingEngine end

"""
    price(engine, instrument, model, market_data) -> Real

Compute the fair value of `instrument` under `model` with `engine` and `market_data`.

This declaration has no methods. It is the abstract interface of the package (dependency
inversion). The model modules and the engine modules depend on this declaration and add
the methods.

Multiple dispatch selects the method from the types of the four arguments.
The [`AnalyticEngine`](@ref), the [`BinomialEngine`](@ref) and the [`MonteCarloEngine`](@ref)
each have one generic method for the subtypes of
[`LognormalModel`](@ref FinancialDerivatives.Models.LognormalModel).
A closed-form formula of one model has one method for its combination of types.
If a combination has no method, `price` throws a `MethodError`.
"""
function price end

"""
    simulate(engine, model, market_data, t) -> Matrix

Simulate paths of the state of `model` from the time zero to the time `t`, in years.

Each column of the result is one path. The first row holds the initial state. The last row
holds the state at the time `t`.
"""
function simulate end

end # module
