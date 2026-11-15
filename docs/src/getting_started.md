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

julia> opt = EuropeanOption(90.0, 180/365, false)

julia> price(AnalyticEngine(), opt, BlackScholes(), md)
3.2281936525908073
```

`price` reads the spot price, the rates, and the volatility from the market data.
The instrument holds only the terms of the contract: the strike, the expiry, and the type of the option.

The engine selects the numerical method. The model stays the same:

```julia
julia> price(BinomialEngine(), opt, BlackScholes(), md)
3.2275741636134345

julia> american = AmericanOption(90.0, 180/365, false)

julia> price(BinomialEngine(; scheme=JarrowRudd()), american, BlackScholes(), md)
3.307495452412955
```

A model holds its parameters. To get the paths of a model, call `simulate`.
Each column of the result is one path:

```julia
julia> model = Vasicek(; k=1.0, θ=0.05, σ=0.02)

julia> rates = InterestRateMarketData(; short_rate=0.03)

julia> paths = simulate(MonteCarloEngine(; num_paths=1_000, num_steps=250), model, rates, 1.0)

julia> size(paths)
(251, 1000)
```
