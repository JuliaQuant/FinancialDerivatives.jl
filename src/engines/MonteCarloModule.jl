module MonteCarloModule

using Random: AbstractRNG
using Statistics: mean
using ..Engines
using ..Instruments
using ..MarketData
using ..Models: OneFactorModel, LognormalModel, initial_state, transition
import ..Engines: price, simulate

# The shocks come from this one function, so that a package extension can add a
# quasi-random source.
standard_normals(rng::AbstractRNG, dims...) = randn(rng, dims...)

# The last time is exactly `t`, thus no step reads the market data after the horizon.
time_grid(t, num_steps) = range(zero(t), t; length=num_steps + 1)

function simulate((; num_paths, num_steps, rng)::MonteCarloEngine, model::OneFactorModel,
                  md::AbstractMarketData, t)
    times = time_grid(t, num_steps)
    steps = [transition(model, md, times[n], times[n + 1]) for n in 1:num_steps]
    shocks = standard_normals(rng, num_steps, num_paths)
    x0 = initial_state(model, md)

    # The element type must hold the type of each input, for example a dual number.
    T = typeof(first(steps)(x0, zero(eltype(shocks))))
    paths = Matrix{T}(undef, num_steps + 1, num_paths)
    for p in 1:num_paths
        paths[1, p] = x0
        for n in 1:num_steps
            paths[n + 1, p] = steps[n](paths[n, p], shocks[n, p])
        end
    end

    return paths
end

"""
Price an option under a [`LognormalModel`](@ref) with Monte Carlo simulation.

If [`isamerican`](@ref) is `false` for the option, the value is the mean of the discounted
payoffs at the expiry. The step of a lognormal model is exact. Thus the method goes to the
expiry in one step, and does not use `num_steps`.

If `isamerican` is `true`, the method is the least-squares Monte Carlo method. At each time
step, a regression on the paths that are in the money estimates the continuation value. If
the exercise value of a path is more than that estimate, the holder exercises the option on
that path.

# References
- Longstaff, F. A., and Schwartz, E. S. (2001). Valuing American options by simulation: a
  simple least-squares approach. *The Review of Financial Studies*, 14(1), 113-147.
  [doi:10.1093/rfs/14.1.113](https://doi.org/10.1093/rfs/14.1.113)
"""
function price(engine::MonteCarloEngine, option::Option, model::LognormalModel,
               md::AbstractMarketData)
    isamerican(option) && return least_squares_price(engine, option, model, md)

    (; t) = option
    (; num_paths, rng) = engine
    s = initial_state(model, md)
    step = transition(model, md, zero(t), t)
    shocks = standard_normals(rng, 1, num_paths)

    return discount_factor(md, zero(t), t) * mean(z -> payoff(option, step(s, z)), shocks)
end

function least_squares_price(engine, option, model, md)
    (; k, t) = option
    (; num_steps) = engine
    times = time_grid(t, num_steps)
    discounts = [discount_factor(md, times[n], times[n + 1]) for n in 1:num_steps]
    paths = simulate(engine, model, md, t)

    # Cash flow of each path, discounted to the current time step.
    cash = [one(eltype(discounts)) * payoff(option, x) for x in @view paths[end, :]]
    for n in num_steps:-1:2
        cash .*= discounts[n]
        exercise = [payoff(option, x) for x in @view paths[n, :]]
        in_the_money = findall(>(0), exercise)
        isempty(in_the_money) && continue

        # A cubic polynomial in the moneyness estimates the continuation value.
        basis = [(paths[n, p] / k)^j for p in in_the_money, j in 0:3]
        continuation = basis * (basis \ cash[in_the_money])
        for (i, p) in enumerate(in_the_money)
            exercise[p] > continuation[i] && (cash[p] = exercise[p])
        end
    end

    return max(discounts[1] * mean(cash), payoff(option, paths[1, 1]))
end

end # module MonteCarloModule
