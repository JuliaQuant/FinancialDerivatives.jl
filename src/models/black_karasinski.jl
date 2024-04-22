"""
    BlackKarasinski()

[Black-Karasinski model](https://en.wikipedia.org/wiki/Black%E2%80%93Karasinski_model).
"""
struct BlackKarasinski <: Model end

"""
    evaluate(IRD, BlackKarasinski(), n = 12)

Evaluate interest rate derivative using `BlackKarasinski` model.

# Arguments
- `IRD::InterestRateDerivative`: interest rate derivative
- `n`: number of paths to simulate
"""
function evaluate(IRD::InterestRateDerivative, m::BlackKarasinski, n::Int64=12)
    Δt = IRD.t / n
    rates = [IRD.r]
    for i in 0:n
        dr = IRD.k * (IRD.θ - log(rates[end])) * Δt + IRD.σ * rates[end] * randn()
        append!(rates, rates[end] + dr)
    end
    return rates
end
