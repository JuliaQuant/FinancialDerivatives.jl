# Getting Started

## Installation

`FinancialDerivatives` is a registered package. To add it to your Julia packages, simply do the following in REPL:

```julia
pkg> add FinancialDerivatives
```

## Usage

To price an European option, simply create a new `EuropeanOption` and pass it to `evaluate` with the desired valuation model:

```julia
julia> using FinancialDerivatives

julia> euro_put = EuropeanOption(100.0, 90.0, 0.05, 0.3, 180/365, true)

julia> evaluate(euro_put, BlackScholes())
3.2281936525908073
```
