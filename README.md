# FinancialDerivatives.jl

[![Build Status](https://travis-ci.org/brilhana/FinancialDerivatives.jl.svg?branch=master)](https://travis-ci.org/brilhana/FinancialDerivatives.jl)
[![Coverage Status](https://coveralls.io/repos/brilhana/FinancialDerivatives.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/brilhana/FinancialDerivatives.jl?branch=master)
[![codecov.io](http://codecov.io/github/brilhana/FinancialDerivatives.jl/coverage.svg?branch=master)](http://codecov.io/github/brilhana/FinancialDerivatives.jl?branch=master)

Financial derivatives modeling and pricing in Julia.

## Models

* Black-Scholes.
* Brennan-Schwartz.
* Cox-Ross-Rubinstein.
* Garman-Kohlhagen.
* Longstaff-Schwartz.
* Rendlemen-Bartter.
* Vasicek.

## Installation

```julia
(v1.0) pkg> add https://github.com/brilhana/FinancialDerivatives.jl
```

## Usage

```julia
using FinancialDerivatives

american_put = Option(100.0, 90.0, 0.05, 0.3, 180/365, -1)

evaluate(american_put, BlackScholes())
```