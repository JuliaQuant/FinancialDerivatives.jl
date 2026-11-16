module MarketData

export AbstractMarketData
export EquityMarketData, FXMarketData, InterestRateMarketData
export spot, discount_rate, foreign_rate, dividend_yield, volatility, short_rate
export discount_factor

"""
Abstract supertype for the market observables: spot prices, rates, and volatilities.

The `price` methods read each observable from the market data through an accessor function.
They do not read the observables from the instrument.

Each subtype must implement the accessors of its asset class:

- Equity: [`spot`](@ref), [`discount_rate`](@ref), [`dividend_yield`](@ref), [`volatility`](@ref).
- Foreign exchange: [`spot`](@ref), [`discount_rate`](@ref), [`foreign_rate`](@ref), [`volatility`](@ref).
- Interest rate: [`short_rate`](@ref).

Each rate and each volatility applies to a horizon `t` that starts at the time zero.
A closed-form formula reads them for the expiry of the instrument.
A tree and a simulation read them for the two ends of each time step, and compute the
forward value of the step.

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

"""
Return the discount factor between the times `t1` and `t2`, in years.
"""
function discount_factor(md::AbstractMarketData, t1, t2)
    return exp(discount_rate(md, t1) * t1 - discount_rate(md, t2) * t2)
end

# A field holds a constant, or a function of the horizon.
at_horizon(value::Real, _) = value
at_horizon(curve, t) = curve(t)

function check_curve(name, value)
    value isa Real || applicable(value, 0.0) ||
        throw(ArgumentError("`$name` must be a number or a function of the horizon, " *
                            "got a `$(typeof(value))`"))
    return nothing
end

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

    function EquityMarketData{S,R,Q,V}(spot_price, risk_free_rate, dividend_yield,
                                       volatility) where {S<:Real,R,Q<:Real,V}
        check_curve(:risk_free_rate, risk_free_rate)
        check_curve(:volatility, volatility)
        return new{S,R,Q,V}(spot_price, risk_free_rate, dividend_yield, volatility)
    end
end

function EquityMarketData(spot_price::S, risk_free_rate::R, dividend_yield::Q,
                          volatility::V) where {S<:Real,R,Q<:Real,V}
    return EquityMarketData{S,R,Q,V}(spot_price, risk_free_rate, dividend_yield, volatility)
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

    function FXMarketData{S,RD,RF,V}(spot_price, domestic_rate, foreign_rate,
                                     volatility) where {S<:Real,RD,RF,V}
        check_curve(:domestic_rate, domestic_rate)
        check_curve(:foreign_rate, foreign_rate)
        check_curve(:volatility, volatility)
        return new{S,RD,RF,V}(spot_price, domestic_rate, foreign_rate, volatility)
    end
end

function FXMarketData(spot_price::S, domestic_rate::RD, foreign_rate::RF,
                      volatility::V) where {S<:Real,RD,RF,V}
    return FXMarketData{S,RD,RF,V}(spot_price, domestic_rate, foreign_rate, volatility)
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
