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
@kwdef struct InterestRateDerivative{KT<:Real,RT<:Real,σT<:Real,θT<:Real,TT<:Real}
    k::KT
    r::RT
    σ::σT
    θ::θT
    t::TT
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
@kwdef struct AmericanOption{ST<:Real,KT<:Real,RT<:Real,σT<:Real,TT<:Real} <: Option
    s::ST
    k::KT
    r::RT
    σ::σT
    t::TT
    call::Bool
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
@kwdef struct AsianOption{ST<:Real,KT<:Real,RT<:Real,σT<:Real,TT<:Real} <: Option
    s::ST
    k::KT
    r::RT
    σ::σT
    t::TT
    call::Bool
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
@kwdef struct EuropeanOption{ST<:Real,KT<:Real,RT<:Real,QT<:Real,σT<:Real,TT<:Real} <:
              Option
    s::ST
    k::KT
    r::RT
    q::QT
    σ::σT
    t::TT
    call::Bool
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
@kwdef struct FXOption{ST<:Real,KT<:Real,RDT<:Real,RFT<:Real,σT<:Real,TT<:Real} <: Option
    s::ST
    k::KT
    r_d::RDT
    r_f::RFT
    σ::σT
    t::TT
    call::Bool
end
