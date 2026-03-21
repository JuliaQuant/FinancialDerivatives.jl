# Getting Started

## Installation

`FinancialDerivatives` is a registered package. To add it to your Julia packages, simply do the following in REPL:

```julia
pkg> add FinancialDerivatives
```

## Usage

To price a European option, create an `EuropeanOption`, an `EquityMarketData` with the current
market observables, and call `price` with the desired engine and model:

```julia
julia> using FinancialDerivatives

julia> md = EquityMarketData(spot_price=100.0, risk_free_rate=0.05, dividend_yield=0.0, volatility=0.3)

julia> opt = EuropeanOption(100.0, 90.0, 0.05, 0.0, 0.3, 180/365, false)

julia> price(AnalyticEngine(), opt, BlackScholes(), md)
3.2281936525908073
```
