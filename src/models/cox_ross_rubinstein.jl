"""
    CoxRossRubinstein()

[Cox-Ross-Rubinstein binomial model (aka Binomial options pricing model)](https://en.wikipedia.org/wiki/Binomial_options_pricing_model).
"""
struct CoxRossRubinstein <: Model end

"""
    evaluate(O, CoxRossRubinstein(), N = 1000)

Evaluate option `O` using `CoxRossRubinstein`.

# Arguments
- `O::Option`: option
- `N`: number of paths to simulate
"""
function evaluate(O::Option, m::CoxRossRubinstein, N::Int64=1000)
    Δt = O.t / N
    U = exp(O.σ * √Δt)
    D = exp(-O.σ * √Δt)
    R = exp(O.r * Δt)
    p = (R - D) / (U - D)
    q = (U - R) / (U - D)

    if isput(O)
        Z = [max(0, O.k - O.s * exp((2 * i - N) * O.σ * √Δt)) for i in 0:N]
    elseif iscall(O)
        Z = [max(0, O.s * exp((2 * i - N) * O.σ * √Δt) - O.k) for i in 0:N]
    end

    for n in (N - 1):-1:0, i in 0:n
        if isput(O)
            x = O.k - O.s * exp((2 * i - n) * O.σ * √Δt)
        elseif iscall(O)
            x = O.s * exp((2 * i - n) * O.σ * √Δt) - O.k
        end
        y = (q * Z[i + 1] + p * Z[i + 2]) / R
        Z[i + 1] = max(x, y)
    end

    return Z[1]
end
