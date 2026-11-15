module Instruments

using Dates

export FinancialInstrument
export Derivative, Forward, Future, Option, Swap, Swaption
export EuropeanOption, AmericanOption, AsianOption, FXOption
export iscall, isput, payoff

"Abstract supertype for all financial instruments. Subtypes define contract terms only (strike, expiry, call/put). Market observables belong in an [`AbstractMarketData`](@ref FinancialDerivatives.MarketData.AbstractMarketData) subtype."
abstract type FinancialInstrument end

"""
Abstract type for [derivative contract](https://en.wikipedia.org/wiki/Derivative_(finance)).
"""
abstract type Derivative <: FinancialInstrument end

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
    AmericanOption(k, t, call)

[American option](https://en.wikipedia.org/wiki/Option_style#American_and_European_options).

# Arguments
- `k`: strike price
- `t`: time to expiration
- `call`: `true` if call, `false` if put
"""
struct AmericanOption{KT<:Real,TT<:Real} <: Option
    k::KT
    t::TT
    call::Bool
end

"Construct [`AmericanOption`](@ref) with issue `t0` and expiry `t1` `Date`s."
function AmericanOption(; k::Real, t0::Date, t1::Date, call::Bool)
    t = time_to_expiration(t0, t1)
    return AmericanOption(k, t, call)
end

"""
    AsianOption(k, t, call)

[Asian option](https://en.wikipedia.org/wiki/Option_style#Asian_option).

# Arguments
- `k`: strike price
- `t`: time to expiration
- `call`: `true` if call, `false` if put
"""
struct AsianOption{KT<:Real,TT<:Real} <: Option
    k::KT
    t::TT
    call::Bool
end

"Construct [`AsianOption`](@ref) with issue `t0` and expiry `t1` `Date`s."
function AsianOption(; k::Real, t0::Date, t1::Date, call::Bool)
    t = time_to_expiration(t0, t1)
    return AsianOption(k, t, call)
end

"""
    EuropeanOption(k, t, call)

[European option](https://en.wikipedia.org/wiki/Option_style#American_and_European_options).

# Arguments
- `k`: strike price
- `t`: time to expiration
- `call`: `true` if call, `false` if put
"""
struct EuropeanOption{KT<:Real,TT<:Real} <: Option
    k::KT
    t::TT
    call::Bool
end

"Construct [`EuropeanOption`](@ref) with issue `t0` and expiry `t1` `Date`s."
function EuropeanOption(; k::Real, t0::Date, t1::Date, call::Bool)
    t = time_to_expiration(t0, t1)
    return EuropeanOption(k, t, call)
end

"""
    FXOption(k, t, call)

[Foreign exchange option](https://en.wikipedia.org/wiki/Foreign_exchange_option).

# Arguments
- `k`: strike price
- `t`: time to expiration
- `call`: `true` if call, `false` if put
"""
struct FXOption{KT<:Real,TT<:Real} <: Option
    k::KT
    t::TT
    call::Bool
end

"Construct [`FXOption`](@ref) with issue `t0` and expiry `t1` `Date`s."
function FXOption(; k::Real, t0::Date, t1::Date, call::Bool)
    t = time_to_expiration(t0, t1)
    return FXOption(k, t, call)
end

"""
    payoff(option, s)

Return the amount that `option` pays at exercise for the price `s` of the underlying.
"""
function payoff(option::Union{EuropeanOption,AmericanOption,FXOption}, s)
    (; k) = option
    return iscall(option) ? max(s - k, 0) : max(k - s, 0)
end

"Return `true` if the holder can exercise the `Option` `o` before the expiry"
isamerican(o::Option) = o isa AmericanOption

end # module
