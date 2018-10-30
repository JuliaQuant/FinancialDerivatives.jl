# Getting Started

## Installation

`FinancialDerivatives` is a unregistered package for the moment. To add it to your Julia packages, simply do the following in REPL:

```julia
(v1.0) pkg> add https://github.com/JuliaQuant/FinancialDerivatives.jl
```

## Usage

To price an European option, simply create a new `EuropeanOption` and pass it to `evaluate` with the desired valuation model:

```julia
julia> using FinancialDerivatives

julia> euro_put = EuropeanOption(100.0, 90.0, 0.05, 0.3, 180/365, -1)

julia> evaluate(euro_put, BlackScholes())
3.2281936525908073
```
