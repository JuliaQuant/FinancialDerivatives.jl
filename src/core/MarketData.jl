module MarketData

export AbstractMarketData
export EquityMarketData, FXMarketData, InterestRateMarketData
export spot, discount_rate, foreign_rate, dividend_yield, volatility, short_rate

"""
Abstract supertype for the market observables: spot prices, rates, and volatilities.

The `price` methods read each observable from the market data through an accessor function.
They do not read the observables from the instrument.

Each subtype must implement the accessors of its asset class:

- Equity: [`spot`](@ref), [`discount_rate`](@ref), [`dividend_yield`](@ref), [`volatility`](@ref).
- Foreign exchange: [`spot`](@ref), [`discount_rate`](@ref), [`foreign_rate`](@ref), [`volatility`](@ref).
- Interest rate: [`short_rate`](@ref).

Each rate and each volatility applies to a horizon `t` that starts at the time zero.
The `price` methods read them for the expiry of the instrument.

In the subtypes of this package, a rate or a volatility is a constant or a function of the
horizon. The function must accept each horizon from zero to the expiry.
"""
abstract type AbstractMarketData end

"""
    spot(md)

Return the spot price of the underlying.
"""
function spot end

"""
    discount_rate(md, t)

Return the continuously compounded discount rate for the horizon `t`, in years.

For [`FXMarketData`](@ref), the discount rate is the domestic rate.
"""
function discount_rate end

"""
    foreign_rate(md, t)

Return the continuously compounded foreign rate for the horizon `t`, in years.
"""
function foreign_rate end

"""
    dividend_yield(md)

Return the continuous dividend yield of the underlying.
"""
function dividend_yield end

"""
    volatility(md, t)

Return the volatility of the underlying for the horizon `t`, in years.
"""
function volatility end

"""
    short_rate(md)

Return the current short-term interest rate.
"""
function short_rate end

# A field holds a constant, or a function of the horizon.
at_horizon(value::Real, _) = value
at_horizon(curve, t) = curve(t)

"Market observables required to price equity derivatives."
Base.@kwdef struct EquityMarketData{S<:Real,R,Q<:Real,V} <: AbstractMarketData
    "Current price of the underlying asset"
    spot_price::S
    "Continuously compounded risk-free interest rate: a constant, or a function of the horizon"
    risk_free_rate::R
    "Continuous dividend yield"
    dividend_yield::Q
    "Implied or realised volatility of the underlying: a constant, or a function of the horizon"
    volatility::V
end

spot(md::EquityMarketData) = md.spot_price
discount_rate(md::EquityMarketData, t) = at_horizon(md.risk_free_rate, t)
dividend_yield(md::EquityMarketData) = md.dividend_yield
volatility(md::EquityMarketData, t) = at_horizon(md.volatility, t)

"Market observables required to price foreign-exchange derivatives."
Base.@kwdef struct FXMarketData{S<:Real,RD,RF,V} <: AbstractMarketData
    "Current spot FX rate (units of domestic per unit of foreign)"
    spot_price::S
    "Continuously compounded domestic risk-free rate: a constant, or a function of the horizon"
    domestic_rate::RD
    "Continuously compounded foreign risk-free rate: a constant, or a function of the horizon"
    foreign_rate::RF
    "FX volatility: a constant, or a function of the horizon"
    volatility::V
end

spot(md::FXMarketData) = md.spot_price
discount_rate(md::FXMarketData, t) = at_horizon(md.domestic_rate, t)
foreign_rate(md::FXMarketData, t) = at_horizon(md.foreign_rate, t)
volatility(md::FXMarketData, t) = at_horizon(md.volatility, t)

"Market observables required to simulate the short rate."
Base.@kwdef struct InterestRateMarketData{R<:Real} <: AbstractMarketData
    "Current short-term interest rate"
    short_rate::R
end

short_rate(md::InterestRateMarketData) = md.short_rate

end # module
