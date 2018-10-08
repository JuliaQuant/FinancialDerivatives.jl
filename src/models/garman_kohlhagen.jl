struct GarmanKohlhagen <: Model end

"""
Garman–Kohlhagen.
"""
function evaluate(O::FXOption, m::GarmanKohlhagen)
    d1 = (log(O.s / O.k) + (O.r_d - O.r_f * O.σ / 2) * O.t) / (O.σ * √O.t)
    d2 = d1 - O.σ * √O.t

    if O.call == -1
        return O.k * exp(-O.r_d * O.t) * cdf(Normal(), -d2) - O.s * exp(-O.r_f * O.t) * cdf(Normal(), -d1)
    end
    
    return O.s * exp(-O.r_f * O.t) * cdf(Normal(), d1) - O.k * exp(-O.r_d * O.t) * cdf(Normal(), d2)
end
