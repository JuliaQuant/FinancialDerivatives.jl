# Getting Started

`FinancialDerivatives` is a unregistered package for the moment. To add it to your Julia packages, simply do the following in REPL:

```julia
(v1.0) pkg> add https://github.com/brilhana/FinancialDerivatives.jl
```

To price an American option, simply create a new `AmericanOption` and pass it to `evaluate` with the desired valuation model:

```julia
julia> using FinancialDerivatives

julia> american_put = AmericanOption(100.0, 90.0, 0.05, 0.3, 180/365, -1)

julia> evaluate(american_put, BlackScholes())
3.2281936525908073
```
