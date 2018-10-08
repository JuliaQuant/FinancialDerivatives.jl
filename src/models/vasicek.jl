struct Vasicek <: Model end

"""
Vasicek.
"""
function evaluate(IRD::InterestRateDerivative, m::Vasicek, n::Int64 = 1000)
    Δt = IRD.t / n
    rates = [IRD.r]
    for i = 0:n
        dr = IRD.k * (IRD.θ - rates[end]) * Δt + IRD.σ * rates[end] * Normal()
        rates += rates[end] + dr
    end
    return rates
end
