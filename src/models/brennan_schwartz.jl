struct BrennanSchwartz <: Model end

"""
Brennan-Schwartz.
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
