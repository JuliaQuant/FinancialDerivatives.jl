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

"Return `true` if the `Option` `o` is a put option"
isput(o::Option) = !iscall(o)

"Return `true` if the `Option` `o` is a call option"
iscall(o::Option) = o.call

"""
Abstract type for [swap](https://en.wikipedia.org/wiki/Swap_(finance)).
"""
abstract type Swap <: Derivative end

"""
Abstract type for [swaption](https://en.wikipedia.org/wiki/Swaption).
"""
abstract type Swaption <: Derivative end

"Compute the time to expiration in years between two dates."
function time_to_expiration(t0::Date, t1::Date)
    t1 > t0 || throw(ArgumentError("Expiry date $t1 must be greater than issue date $t0"))
    τ = t1 - t0
    year_days = Dates.value(lastdayofyear(t0)) - Dates.value(firstdayofyear(t0))
    return Dates.value(τ) / year_days
end

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
struct InterestRateDerivative{KT<:Real,RT<:Real,σT<:Real,θT<:Real,TT<:Real}
    k::KT
    r::RT
    σ::σT
    θ::θT
    t::TT
end

"Construct `InterestRateDerivative` with parameters and start `t0` and final `t1` `Date`s."
function InterestRateDerivative(; k::Real, r::Real, σ::Real, θ::Real, t0::Date, t1::Date)
    t = time_to_expiration(t0, t1)
    return InterestRateDerivative(k, r, σ, θ, t)
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
- `call`: `true` if call, `false` if put
"""
struct AmericanOption{ST<:Real,KT<:Real,RT<:Real,σT<:Real,TT<:Real} <: Option
    s::ST
    k::KT
    r::RT
    σ::σT
    t::TT
    call::Bool
end

"Construct [`AmericanOption`](@ref) with issue `t0` and expiry `t1` `Date`s."
function AmericanOption(; s::Real, k::Real, r::Real, σ::Real, t0::Date, t1::Date,
                        call::Bool)
    t = time_to_expiration(t0, t1)
    return AmericanOption(s, k, r, σ, t, call)
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
- `call`: `true` if call, `false` if put
"""
struct AsianOption{ST<:Real,KT<:Real,RT<:Real,σT<:Real,TT<:Real} <: Option
    s::ST
    k::KT
    r::RT
    σ::σT
    t::TT
    call::Bool
end

"Construct [`AsianOption`](@ref) with issue `t0` and expiry `t1` `Date`s."
function AsianOption(; s::Real, k::Real, r::Real, σ::Real, t0::Date, t1::Date, call::Bool)
    t = time_to_expiration(t0, t1)
    return AsianOption(s, k, r, σ, t, call)
end

"""
    EuropeanOption(s, k, r, σ, t, call)

[European option](https://en.wikipedia.org/wiki/Option_style#American_and_European_options).

# Arguments
- `s`: underlying price
- `k`: strike price
- `r`: risk-free interest rate
- `q`: dividend yield
- `σ`: volatility
- `t`: time to expiration
- `call`: `true` if call, `false` if put
"""
struct EuropeanOption{ST<:Real,KT<:Real,RT<:Real,QT<:Real,σT<:Real,TT<:Real} <:
       Option
    s::ST
    k::KT
    r::RT
    q::QT
    σ::σT
    t::TT
    call::Bool
end

"Construct [`EuropeanOption`](@ref) with issue `t0` and expiry `t1` `Date`s."
function EuropeanOption(; s::Real, k::Real, r::Real, q::Real, σ::Real, t0::Date, t1::Date,
                        call::Bool)
    t = time_to_expiration(t0, t1)
    return EuropeanOption(s, k, r, q, σ, t, call)
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
- `call`: `true` if call, `false` if put
"""
struct FXOption{ST<:Real,KT<:Real,RDT<:Real,RFT<:Real,σT<:Real,TT<:Real} <: Option
    s::ST
    k::KT
    r_d::RDT
    r_f::RFT
    σ::σT
    t::TT
    call::Bool
end

"Construct [`FXOption`](@ref) with issue `t0` and expiry `t1` `Date`s."
function FXOption(; s::Real, k::Real, r_d::Real, r_f::Real, σ::Real, t0::Date, t1::Date,
                  call::Bool)
    t = time_to_expiration(t0, t1)
    return FXOption(s, k, r_d, r_f, σ, t, call)
end
