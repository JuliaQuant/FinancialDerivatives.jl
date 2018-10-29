"""
CoxIngersollRoss model
"""
struct CoxIngersollRoss <: Model end

"""
    evaluate(IRD, CoxIngersollRoss(), n)

Evaluate interest rate derivative `IRD` using `CoxIngersollRoss` model.

# Arguments
- `IRD::InterestRateDerivative`: interest rate derivative
- `n`: number of paths to simulate
"""
function evaluate(IRD::InterestRateDerivative, m::CoxIngersollRoss, n::Int64 = 12)
    Δt = IRD.t / n
    rates = [IRD.r]
    for i = 0:n
        dr = IRD.k * (IRD.θ - rates[end]) * Δt + IRD.σ * √rates[end] * randn()
        append!(rates, rates[end] + dr)
    end
    return rates
end
