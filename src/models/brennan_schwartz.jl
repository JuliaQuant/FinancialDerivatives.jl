"""
BrennanSchwartz model
"""
struct BrennanSchwartz <: Model end

"""
    evaluate(IRD, BrennanSchwartz(), n = 12)

Evaluate interest rate derivative `IRD` using `BrennanSchwartz` model.

# Arguments
- `IRD::InterestRateDerivative`: interest rate derivative
- `n`: number of paths to simulate
"""
function evaluate(IRD::InterestRateDerivative, m::BrennanSchwartz, n::Int64 = 12)
    Δt = IRD.t / n
    rates = [IRD.r]
    for i = 0:n
        dr = IRD.k * (IRD.θ - rates[end]) * Δt + IRD.σ * randn()
        append!(rates, rates[end] + dr)
    end
    return rates
end
