module BlackScholesModule

using ...MarketData
import ..LognormalModel, ..growth_rate

export BlackScholes

"""
[Black-Scholes model](https://en.wikipedia.org/wiki/Black%E2%80%93Scholes_model).
"""
struct BlackScholes <: LognormalModel end

growth_rate(::BlackScholes, md, t) = discount_rate(md, t) - dividend_yield(md)

end # module BlackScholesModule
