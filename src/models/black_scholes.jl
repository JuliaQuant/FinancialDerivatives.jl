struct BlackScholes <: Model end

"""
Black-Scholes.
"""
function evaluate(O::Option, m::BlackScholes)
    d1 = (log(O.s / O.k) + (O.r + O.σ * O.σ / 2) * O.t) / (O.σ * √O.t)
    d2 = d1 - O.σ * √O.t

    if O.call == -1
        return cdf(Normal(), -d2) * O.k * exp(-O.r * O.t) - cdf(Normal(), -d1) * O.s
    elseif O.call == 1
        return O.s * cdf(Normal(), d1) - exp(-O.r * O.t) * O.k * cdf(Normal(), d2)
    end
end

evaluate(O::Option) = evaluate(O::Option, m::BlackScholes)
