module MarketData

export AbstractMarketData
export EquityMarketData, FXMarketData, InterestRateMarketData

"Abstract supertype for market observables (spot prices, rates, volatilities, etc.)."
abstract type AbstractMarketData end

"Market observables required to price equity derivatives."
Base.@kwdef struct EquityMarketData{S<:Real,R<:Real,Q<:Real,V<:Real} <: AbstractMarketData
    "Current price of the underlying asset"
    spot_price::S
    "Continuously compounded risk-free interest rate"
    risk_free_rate::R
    "Continuous dividend yield"
    dividend_yield::Q
    "Implied or realised volatility of the underlying"
    volatility::V
end

"Market observables required to price foreign-exchange derivatives."
Base.@kwdef struct FXMarketData{S<:Real,RD<:Real,RF<:Real,V<:Real} <: AbstractMarketData
    "Current spot FX rate (units of domestic per unit of foreign)"
    spot_price::S
    "Continuously compounded domestic risk-free rate"
    domestic_rate::RD
    "Continuously compounded foreign risk-free rate"
    foreign_rate::RF
    "FX volatility"
    volatility::V
end

"Market observables required to price interest-rate derivatives."
Base.@kwdef struct InterestRateMarketData{R<:Real,V<:Real,K<:Real,Θ<:Real} <:
                   AbstractMarketData
    "Current short-term interest rate"
    short_rate::R
    "Instantaneous rate volatility"
    volatility::V
    "Speed of mean reversion (κ in standard notation)"
    mean_reversion_speed::K
    "Long-run mean of the short rate (θ in standard notation)"
    long_term_mean::Θ
end

end # module
