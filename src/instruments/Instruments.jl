module Instruments

using Dates

export FinancialInstrument
export Derivative, Forward, Future, Option, Swap, Swaption
export EuropeanOption, AmericanOption, AsianOption, FXOption, InterestRateDerivative
export iscall, isput

"Abstract supertype for all financial instruments. Subtypes define contract terms only (strike, expiry, call/put). Market observables belong in an [`AbstractMarketData`](@ref) subtype."
abstract type FinancialInstrument end

include("../derivatives.jl")

end # module
