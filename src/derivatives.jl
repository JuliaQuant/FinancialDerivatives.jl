"""
Abstract type for [derivative contract](https://en.wikipedia.org/wiki/Derivative_(finance)).
"""
abstract type Derivative end

"""
Abstract type for [forward contract](https://en.wikipedia.org/wiki/Forward_contract).
"""
abstract type Forward <: Derivative end

"""
Abstract type for [futures contract](https://en.wikipedia.org/wiki/Futures_contract).
"""
abstract type Future <: Derivative end

"""
Abstract type for [option](https://en.wikipedia.org/wiki/Option_(finance)).
"""
abstract type Option <: Derivative end

"""
Abstract type for [swap](https://en.wikipedia.org/wiki/Swap_(finance)).
"""
abstract type Swap <: Derivative end

"""
Abstract type for [swaption](https://en.wikipedia.org/wiki/Swaption).
"""
abstract type Swaption <: Derivative end

"""
    InterestRateDerivative(k, r, σ, θ, t)

[Interest rate derivative](https://en.wikipedia.org/wiki/Interest_rate_derivative).

# Arguments
- `k`: speed of reversion
- `r`: initial interest rate
- `σ`: instantaneous volatility
- `θ`: long term mean level
- `t`: time interval
"""
struct InterestRateDerivative
    k::Real
    r::Real
    σ::Real
    θ::Real
    t::Real
end

"""
    AmericanOption(s, k, r, σ, t, call)

[American option](https://en.wikipedia.org/wiki/Option_style#American_and_European_options).

# Arguments
- `s`: underlying price
- `k`: strike price
- `r`: risk-free interest rate
- `σ`: volatility
- `t`: time to expiration
- `call`: 1 if call, -1 if put
"""
struct AmericanOption <: Option
    s::Real
    k::Real
    r::Real
    σ::Real
    t::Real
    call::Int64
end

"""
    AsianOption(s, k, r, σ, t, call)

[Asian option](https://en.wikipedia.org/wiki/Option_style#Asian_option).

# Arguments
- `s`: underlying price
- `k`: strike price
- `r`: risk-free interest rate
- `σ`: volatility
- `t`: time to expiration
- `call`: 1 if call, -1 if put
"""
struct AsianOption <: Option
    s::Real
    k::Real
    r::Real
    σ::Real
    t::Real
    call::Int64
end

"""
    EuropeanOption(s, k, r, σ, t, call)

[European option](https://en.wikipedia.org/wiki/Option_style#American_and_European_options).

# Arguments
- `s`: underlying price
- `k`: strike price
- `r`: risk-free interest rate
- `σ`: volatility
- `t`: time to expiration
- `call`: 1 if call, -1 if put
"""
struct EuropeanOption <: Option
    s::Real
    k::Real
    r::Real
    σ::Real
    t::Real
    call::Int64
end

"""
    FXOption(s, k, r_d, r_f, σ, t, call)

[Foreign exchange option](https://en.wikipedia.org/wiki/Foreign_exchange_option).

# Arguments
- `s`: underlying price
- `k`: strike price
- `r_d`: domestic risk-free interest rate
- `r_f`: foreign risk-free interest rate
- `σ`: volatility
- `t`: time to expiration
- `call`: 1 if call, -1 if put
"""
struct FXOption <: Option
    s::Real
    k::Real
    r_d::Real
    r_f::Real
    σ::Real
    t::Real
    call::Int64
end
