abstract type Derivative end

abstract type Forward <: Derivative end

abstract type Future <: Derivative end

abstract type Option <: Derivative end

abstract type Swap <: Derivative end

abstract type Swaption <: Derivative end

"""
`InterestRateDerivative`:
    `k`: speed of reversion
    `r`: initial interest rate
    `σ`: instantaneous volatility
    `θ`: long term mean level
    `t`: time interval
"""
struct InterestRateDerivative{T<:Number}
    k::T
    r::T
    σ::T
    θ::T
    t::T
end

"""
`AmericanOption`:
    `s`: underlying price
    `k`: strike price
    `r`: risk-free interest rate
    `σ`: volatility
    `t`: time to expiration
    `call`: 1 if call, -1 if put
"""
struct AmericanOption{T<:Number} <: Option
    s::T
    k::T
    r::T
    σ::T
    t::T
    call::Int64
end

"""
AsianOption:
    `s`: underlying price
    `k`: strike price
    `r`: risk-free interest rate
    `σ`: volatility
    `t`: time to expiration
    `call`: 1 if call, -1 if put
"""
struct AsianOption{T<:Number} <: Option
    s::T
    k::T
    r::T
    σ::T
    t::T
    call::Int64
end

"""
`EuropeanOption`:
    `s`: underlying price
    `k`: strike price
    `r`: risk-free interest rate
    `σ`: volatility
    `t`: time to expiration
    `call`: 1 if call, -1 if put
"""
struct EuropeanOption{T<:Number} <: Option
    s::T
    k::T
    r::T
    σ::T
    t::T
    call::Int64
end

"""
`FXOption`:
    `s`: underlying price
    `k`: strike price
    `r_d`: domestic risk-free interest rate
    `r_f`: foreign risk-free interest rate
    `σ`: volatility
    `t`: time to expiration
    `call`: 1 if call, -1 if put
"""
struct FXOption{T<:Number} <: Option
    s::T
    k::T
    r_d::T
    r_f::T
    σ::T
    t::T
    call::Int64
end
