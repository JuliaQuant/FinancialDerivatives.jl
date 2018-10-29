"""
    RendlemanBartter()

[Rendleman-Bartter model](https://en.wikipedia.org/wiki/Rendleman%E2%80%93Bartter_model).
"""
struct RendlemanBartter <: Model end

"""
    evaluate(IRD, RendlemanBartter(), n = 12)

Evaluate interest rate derivative `IRD` using `RendlemanBartter` model.

# Arguments
- `n`: number of paths to simulate
"""
function evaluate(IRD::InterestRateDerivative, m::RendlemanBartter, n::Int64 = 12)
    Δt = IRD.t / n
    rates = [IRD.r]
    for i = 0:n
        dr = IRD.θ * rates[end] * Δt + IRD.θ * rates[end] * randn()
        append!(rates, rates[end] + dr)
    end
    return rates
end

"""
    evaluate(O, RendlemanBartter(), k = 1, N = 1000)

Evaluate option `O` using `RendlemanBartter` model.

# Arguments
- `k`:
- `N`: 
"""
function evaluate(O::Option, m::RendlemanBartter, k::Int64 = 1, N::Int64 = 1000)
    Δt = O.t / N
    p = 1 / (1 + k^2)
    q = 1 - p

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
        y = (q * Z[i+1] + p * Z[i+2]) / exp(O.r * Δt)
        Z[i+1] = max(x, y)
    end
    
    return Z[1]
end
