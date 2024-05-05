# FinancialDerivatives.jl

[![Build Status](https://travis-ci.org/JuliaQuant/FinancialDerivatives.jl.svg?branch=master)](https://travis-ci.org/JuliaQuant/FinancialDerivatives.jl)

## Installation
```julia
(v1.0) pkg> add FinancialDerivatives
```

## Usage
To price an European option, simply create a new `EuropeanOption` and pass it to `evaluate` with the desired valuation model:

```julia
julia> using FinancialDerivatives

julia> euro_put = EuropeanOption(; s=100.0, k=90.0, r=0.05, q=0.0, σ=0.3, t=180 / 365, call=false)

julia> evaluate(euro_put, BlackScholes())
3.2281936525908073
```

## Documentation
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://juliaquant.github.io/FinancialDerivatives.jl/stable)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://juliaquant.github.io/FinancialDerivatives.jl/dev/)
