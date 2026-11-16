module BinomialTreeModule

using ..Engines
using ..Instruments
using ..MarketData
using ..Models: LognormalModel, log_growth, log_variance
import ..Engines: price, tree_parameters, tree_steps

tree_steps(::BinomialScheme, steps) = steps

"Probability of the up move that makes the mean growth of the step equal to `m`."
up_probability(u, d, m) = (m - d) / (u - d)

function tree_parameters(::CoxRossRubinstein, m, w, _, _)
    u = exp(√w)
    d = 1 / u
    return u, d, up_probability(u, d, m)
end

function tree_parameters(::JarrowRudd, m, w, _, _)
    u = m * exp(-w / 2 + √w)
    d = m * exp(-w / 2 - √w)
    return u, d, up_probability(u, d, m)
end

function tree_parameters(::RendlemanBartterTree, m, w, x, steps)
    u, d, _ = tree_parameters(JarrowRudd(), m, w, x, steps)
    return u, d, 1 / 2
end

function tree_parameters(::Tian, m, w, _, _)
    v = exp(w)
    u = m * v / 2 * (v + 1 + √(v^2 + 2v - 3))
    d = m * v / 2 * (v + 1 - √(v^2 + 2v - 3))
    return u, d, up_probability(u, d, m)
end

# The Peizer-Pratt inversion needs an odd number of steps.
tree_steps(::LeisenReimer, steps) = isodd(steps) ? steps : steps + 1

# Peizer-Pratt inversion of the normal distribution function at `z`, for `n` steps.
function peizer_pratt(z, n)
    return 0.5 + sign(z) * 0.5 * √(1 - exp(-((z / (n + 1 / 3))^2) * (n + 1 / 6)))
end

function tree_parameters(::LeisenReimer, m, w, x, steps)
    deviation = √(w * steps)
    d2 = x / deviation - deviation / 2
    p = peizer_pratt(d2, steps)
    u = m * peizer_pratt(d2 + deviation, steps) / p
    d = (m - p * u) / (1 - p)
    return u, d, p
end

function equal_variance_times(md, t, steps)
    # The sum makes sure that the variance does not decrease on a uniform step.
    uniform = range(zero(t), t; length=steps + 1)
    total = sum(log_variance(md, uniform[j], uniform[j + 1]) for j in 1:steps)

    times = [float(zero(t))]
    for j in 1:(steps - 1)
        low, high = times[end], t
        for _ in 1:60
            middle = (low + high) / 2
            if log_variance(md, zero(t), middle) < j * total / steps
                low = middle
            else
                high = middle
            end
        end
        push!(times, (low + high) / 2)
    end

    return push!(times, t)
end

"""
Price an option under a [`LognormalModel`](@ref) with a recombining binomial tree.

The method accepts a [`EuropeanOption`](@ref), an [`AmericanOption`](@ref), and an
[`FXOption`](@ref). If [`isamerican`](@ref) is `true` for the option, the method compares
the exercise value with the continuation value at each node.

Each step of the tree has the same variance. The method reads the growth and the discount
factor of each step from the market data.
"""
function price((; steps, scheme)::BinomialEngine, option::Option, model::LognormalModel,
               md::AbstractMarketData)
    (; k, t) = option
    s = spot(md)
    n = tree_steps(scheme, steps)
    times = equal_variance_times(md, t, n)
    w = log_variance(md, zero(t), t) / n
    x = log(s / k) + log_growth(model, md, zero(t), t)

    moves = map(1:n) do j
        m = exp(log_growth(model, md, times[j], times[j + 1]))
        return tree_parameters(scheme, m, w, x, n)
    end
    all(((u, d, p),) -> 0 ≤ p ≤ 1 && 0 < d ≤ u, moves) ||
        throw(ArgumentError("The tree has a move or a probability that is not valid. " *
                            "Increase `steps`, or examine the rates and the volatility."))
    discounts = [discount_factor(md, times[j], times[j + 1]) for j in 1:n]

    # The price at the node `i` of the step `j` is `exp(lows[j + 1] + i * ratio)`.
    # The ratio of the two moves is the same at each step, thus the tree recombines.
    ratio = log(moves[1][1] / moves[1][2])
    lows = cumsum([log(s); [log(d) for (_, d, _) in moves]])

    # The element type must hold the type of each input, for example a dual number.
    T = typeof(discounts[1] * moves[1][3] * payoff(option, exp(lows[end] + ratio)))
    values = T[payoff(option, exp(lows[end] + i * ratio)) for i in 0:n]
    for j in (n - 1):-1:0
        p = moves[j + 1][3]
        for i in 0:j
            continuation = discounts[j + 1] * ((1 - p) * values[i + 1] + p * values[i + 2])
            values[i + 1] = if isamerican(option)
                max(continuation, payoff(option, exp(lows[j + 1] + i * ratio)))
            else
                continuation
            end
        end
    end

    return values[1]
end

end # module BinomialTreeModule
