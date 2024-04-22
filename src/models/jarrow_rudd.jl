"""
    JarrowRudd()

[Jarrow-Rudd model](http://simulations.lpsm.paris/binomial_trees/jr).
"""
struct JarrowRudd <: Model end

"""
    evaluate(O, JarrowRudd(), risk_neutral = true, N = 1000)

Evaluate option `O` using `JarrowRudd` binomial model (defaults to the risk-neutral version).

# Arguments 
- `O::Option`: option
- `risk_neutral`: `true` if risk neutral, `false` if equal probability.
- `N`: number of paths to simulate
"""
function evaluate(O::Option, m::JarrowRudd, risk_neutral::Bool=true, N::Int64=1000)
    Δt = O.t / N
    R = exp(O.r * Δt)

    if risk_neutral
        U = exp((O.r - O.σ^2 / 2) * Δt + O.σ * √Δt)
        D = exp((O.r - O.σ^2 / 2) * Δt - O.σ * √Δt)
        p = (R - D) / (U - D)
        q = (U - R) / (U - D)
    else
        p = q = 0.5
    end

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
        y = (q * Z[i + 1] + p * Z[i + 2]) / exp(O.r * Δt)
        Z[i + 1] = max(x, y)
    end

    return Z[1]
end
