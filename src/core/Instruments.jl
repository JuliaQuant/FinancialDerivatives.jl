module Instruments

using Dates

export FinancialInstrument
export Derivative, Forward, Future, Option, Swap, Swaption
export EuropeanOption, AmericanOption, AsianOption, FXOption
export DayCount, Actual365Fixed, Business252
export iscall, isput, isamerican, payoff

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

"Abstract supertype for the day count conventions. A day count converts an issue date and an expiry date to a time in years."
abstract type DayCount end

"Actual/365 Fixed day count: the number of calendar days between the two dates, divided by 365."
struct Actual365Fixed <: DayCount end

"""
    Business252(calendar)

Business/252 day count: the number of business days of `calendar` between the two dates, divided by 252.

If the issue date is a business day, the count includes it. The count does not include the expiry date.
`calendar` is a `HolidayCalendar` of [BusinessDays.jl](https://github.com/JuliaFinance/BusinessDays.jl), or its name as a `Symbol`, for example `:USNYSE`.
Load BusinessDays.jl before you use this day count.

The market data must use the same time basis as the instrument.
Each rate must be continuously compounded over a year of 252 business days.
The volatility must be annualized over 252 business days.
"""
struct Business252{C} <: DayCount
    calendar::C
end

"""
Return the number of business days of `calendar` from `t0` to `t1`.

The package extension for BusinessDays.jl adds the methods for its calendars.
"""
function business_days(calendar, ::Date, ::Date)
    return throw(ArgumentError("No business day count for a calendar of type $(typeof(calendar)). " *
                               "Load BusinessDays.jl and use a `HolidayCalendar` or its `Symbol` name."))
end

"""
Return the time in years from the issue date `t0` to the expiry date `t1`, with the day count `daycount`.

If `t1` is not after `t0`, or if the time is zero, the function throws `ArgumentError`.
"""
function time_to_expiration(t0::Date, t1::Date, ::Actual365Fixed=Actual365Fixed())
    t1 > t0 || throw(ArgumentError("Expiry date $t1 must be greater than issue date $t0"))
    return Dates.value(t1 - t0) / 365
end

function time_to_expiration(t0::Date, t1::Date, daycount::Business252)
    t1 > t0 || throw(ArgumentError("Expiry date $t1 must be greater than issue date $t0"))
    n = business_days(daycount.calendar, t0, t1)
    # A zero time makes the volatility term of each engine zero or undefined.
    n > 0 || throw(ArgumentError("No business day from $t0 to $t1"))
    return n / 252
end

"""
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

"Construct [`AmericanOption`](@ref) with issue `t0` and expiry `t1` `Date`s. The day count `daycount` converts the two dates to the time `t`."
function AmericanOption(; k::Real, t0::Date, t1::Date, call::Bool,
                        daycount::DayCount=Actual365Fixed())
    t = time_to_expiration(t0, t1, daycount)
    return AmericanOption(k, t, call)
end

"""
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

"Construct [`AsianOption`](@ref) with issue `t0` and expiry `t1` `Date`s. The day count `daycount` converts the two dates to the time `t`."
function AsianOption(; k::Real, t0::Date, t1::Date, call::Bool,
                     daycount::DayCount=Actual365Fixed())
    t = time_to_expiration(t0, t1, daycount)
    return AsianOption(k, t, call)
end

"""
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

"Construct [`EuropeanOption`](@ref) with issue `t0` and expiry `t1` `Date`s. The day count `daycount` converts the two dates to the time `t`."
function EuropeanOption(; k::Real, t0::Date, t1::Date, call::Bool,
                        daycount::DayCount=Actual365Fixed())
    t = time_to_expiration(t0, t1, daycount)
    return EuropeanOption(k, t, call)
end

"""
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

"Construct [`FXOption`](@ref) with issue `t0` and expiry `t1` `Date`s. The day count `daycount` converts the two dates to the time `t`."
function FXOption(; k::Real, t0::Date, t1::Date, call::Bool,
                  daycount::DayCount=Actual365Fixed())
    t = time_to_expiration(t0, t1, daycount)
    return FXOption(k, t, call)
end

"""
Return the amount that `option` pays at exercise for the price `s` of the underlying.
"""
function payoff(option::Union{EuropeanOption,AmericanOption,FXOption}, s)
    (; k) = option
    return iscall(option) ? max(s - k, 0) : max(k - s, 0)
end

"Return `true` if the holder can exercise the `Option` `o` before the expiry"
isamerican(o::Option) = o isa AmericanOption

end # module
