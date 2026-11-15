module BinomialTreeModule

using ..Engines
using ..Instruments
using ..Instruments: isamerican
using ..MarketData
using ..Models: LognormalModel, growth_rate
import ..Engines: price, tree_parameters

# Probability of the up move that makes the mean growth of the tree equal to `g`.
up_probability(u, d, g, Δt) = (exp(g * Δt) - d) / (u - d)

function tree_parameters(::CoxRossRubinstein, (; t)::Option, _, g, σ, steps)
    Δt = t / steps
    u = exp(σ * √Δt)
    d = 1 / u
    return u, d, up_probability(u, d, g, Δt)
end

function tree_parameters(::JarrowRudd, (; t)::Option, _, g, σ, steps)
    Δt = t / steps
    u = exp((g - σ^2 / 2) * Δt + σ * √Δt)
    d = exp((g - σ^2 / 2) * Δt - σ * √Δt)
    return u, d, up_probability(u, d, g, Δt)
end

function tree_parameters(::RendlemanBartterTree, option::Option, s, g, σ, steps)
    u, d, _ = tree_parameters(JarrowRudd(), option, s, g, σ, steps)
    return u, d, 1 / 2
end

function tree_parameters(::Tian, (; t)::Option, _, g, σ, steps)
    Δt = t / steps
    v = exp(σ^2 * Δt)
    u = exp(g * Δt) * v / 2 * (v + 1 + √(v^2 + 2v - 3))
    d = exp(g * Δt) * v / 2 * (v + 1 - √(v^2 + 2v - 3))
    return u, d, up_probability(u, d, g, Δt)
end

# Peizer-Pratt inversion of the normal distribution function at `z`, for `n` steps.
function peizer_pratt(z, n)
    return 0.5 + sign(z) * 0.5 * √(1 - exp(-((z / (n + 1 / 3))^2) * (n + 1 / 6)))
end

function tree_parameters(::LeisenReimer, (; k, t)::Option, s, g, σ, steps)
    # The Peizer-Pratt inversion needs an odd number of steps.
    n = isodd(steps) ? steps : steps + 1
    d2 = (log(s / k) + (g - σ^2 / 2) * t) / (σ * √t)
    d1 = d2 + σ * √t
    p = peizer_pratt(d2, n)
    growth = exp(g * t / steps)
    u = growth * peizer_pratt(d1, n) / p
    d = (growth - p * u) / (1 - p)
    return u, d, p
end

"""
Price an option under a [`LognormalModel`](@ref) with a recombining binomial tree.

The method accepts a [`EuropeanOption`](@ref), an [`AmericanOption`](@ref), and an
[`FXOption`](@ref). For an `AmericanOption`, the method compares the exercise value with
the continuation value at each node.
"""
function price((; steps, scheme)::BinomialEngine, option::Option, model::LognormalModel,
               md::AbstractMarketData)
    (; t) = option
    s = spot(md)
    g = growth_rate(model, md, t)
    u, d, p = tree_parameters(scheme, option, s, g, volatility(md, t), steps)
    discount = exp(-discount_rate(md, t) * t / steps)

    # The element type must hold the type of each input, for example a dual number.
    T = typeof(discount * p * payoff(option, s * u * d))
    values = T[payoff(option, s * u^i * d^(steps - i)) for i in 0:steps]
    for n in (steps - 1):-1:0, i in 0:n
        continuation = discount * ((1 - p) * values[i + 1] + p * values[i + 2])
        values[i + 1] = if isamerican(option)
            max(continuation, payoff(option, s * u^i * d^(n - i)))
        else
            continuation
        end
    end

    return values[1]
end

end # module BinomialTreeModule
