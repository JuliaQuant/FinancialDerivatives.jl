struct BlackKarasinski <: Model end

"""
`BlackKarasinski`:
    `n`: number of paths to simulate
"""
function evaluate(IRD::InterestRateDerivative, m::BlackKarasinski, n::Int64 = 12)
    Δt = IRD.t / n
    rates = [IRD.r]
    for i = 0:n
        dr = IRD.k * (IRD.θ - log(rates[end])) * Δt + IRD.σ * rates[end] * randn()
        append!(rates, rates[end] + dr)
    end
    return rates
end
