struct CoxRossRubinstein <: Model end

"""
Cox-Ross-Rubinstein binomial model.
"""
function evaluate(O::Option, m::CoxRossRubinstein, N::Int64 = 1000)
    Δt = O.t / N
    U = exp(O.σ * √Δt)
    D = exp(-O.σ * √Δt)
    R = exp(O.r * Δt)
    p = (R - D) / (U - D)
    q = (U - R) / (U - D)

    if O.call == -1
        Z = [max(0, O.k - O.s * exp((2 * i - N) * O.σ * √Δt)) for i = 0:N]
    elseif O.call == 1
        Z = [max(0, O.s * exp((2 * i - N) * O.σ * √Δt) - O.k) for i = 0:N]
    end
    
    for n = N-1:-1:0, i = 0:n
        if O.call == -1
            x = O.k - O.s * exp((2 * i - n) * O.σ * √Δt)
        elseif O.call == 1
            x = O.s * exp((2 * i - n) * O.σ * √Δt) - O.k
        end
        y = (q * Z[i+1] + p * Z[i+2]) / R
        Z[i+1] = max(x, y)
    end
    
    return Z[1]
end
