"""
    GarmanKohlhagen()

[Garman–Kohlhagen model](https://en.wikipedia.org/wiki/Foreign_exchange_option#Valuation:_the_Garman%E2%80%93Kohlhagen_model).
"""
struct GarmanKohlhagen <: Model end

"""
    evaluate(O::FXOption, GarmanKohlhagen())

Evaluate FX Option using `GarmanKohlhagen` model.

# Arguments
- `O::FXOption`
"""
function evaluate(O::FXOption, m::GarmanKohlhagen)
    d1 = (log(O.s / O.k) + (O.r_d - O.r_f * O.σ / 2) * O.t) / (O.σ * √O.t)
    d2 = d1 - O.σ * √O.t

    if O.call == -1
        return O.k * exp(-O.r_d * O.t) * cdf(Normal(), -d2) - O.s * exp(-O.r_f * O.t) * cdf(Normal(), -d1)
    elseif O.call == 1
        return O.s * exp(-O.r_f * O.t) * cdf(Normal(), d1) - O.k * exp(-O.r_d * O.t) * cdf(Normal(), d2)
    end
end
