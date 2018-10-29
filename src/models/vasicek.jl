"""
    Vasicek()

[Vasicek model](https://en.wikipedia.org/wiki/Vasicek_model).
"""
struct Vasicek <: Model end

"""
    evaluate(IRD, Vasicek(), n = 12)

Evaluate interest rate derivative `IRD` using `Vasicek` model.

# Arguments
- `n`: number of paths to simulate

"""
function evaluate(IRD::InterestRateDerivative, m::Vasicek, n::Int64 = 12)
    Δt = IRD.t / n
    rates = [IRD.r]
    for i = 0:n
        dr = IRD.k * (IRD.θ - rates[end]) * Δt + IRD.σ * rates[end] * randn()
        append!(rates, rates[end] + dr)
    end
    return rates
end
