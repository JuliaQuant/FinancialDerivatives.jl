# FinancialDerivatives.jl

[![Build Status](https://travis-ci.org/brilhana/FinancialDerivatives.jl.svg?branch=master)](https://travis-ci.org/brilhana/FinancialDerivatives.jl)

Financial derivatives modeling and pricing in Julia.

## Derivatives

* Options (American, Asian, European).
* Interest rate derivatives.

## Models

* Black-Scholes.
* Brennan-Schwartz.
* Cox-Ross-Rubinstein.
* Garman-Kohlhagen.
* Jarrow-Rudd.
* Leisen-Reimer.
* Longstaff-Schwartz.
* Rendlemen-Bartter.
* Tian.
* Vasicek.

## Installation

```julia
(v1.0) pkg> add https://github.com/brilhana/FinancialDerivatives.jl
```

## Usage

```julia
using FinancialDerivatives

american_put = AmericanOption(100.0, 90.0, 0.05, 0.3, 180/365, -1)

evaluate(american_put, BlackScholes())
```

## TODO

* Documentation.
* Plotting with `Plots`.
* Support for Greeks using `Dual` from `ForwardDiff`.