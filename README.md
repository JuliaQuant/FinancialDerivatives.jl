# FinancialDerivatives.jl

[![Build Status](https://travis-ci.org/brilhana/FinancialDerivatives.jl.svg?branch=master)](https://travis-ci.org/brilhana/FinancialDerivatives.jl)

Financial derivatives modeling and pricing in Julia.

## Derivatives

* `AmericanOption`
* `AsianOption`
* `EuropeanOption`
* `FXOption`
* `InterestRateDerivative`

## Models

* `BlackScholes`
* `BrennanSchwartz`
* `CoxRossRubinstein`
* `GarmanKohlhagen`
* `JarrowRudd`
* `LeisenReimer`
* `LongstaffSchwartz`
* `RendlemenBartter`
* `Tian`
* `Vasicek`

## Installation

```julia
(v1.0) pkg> add https://github.com/brilhana/FinancialDerivatives.jl
```

## Usage

```julia
julia> using FinancialDerivatives

julia> american_put = AmericanOption(100.0, 90.0, 0.05, 0.3, 180/365, -1)

julia> evaluate(american_put, BlackScholes())
3.2281936525908073
```

## TODO

* Documentation.
* Plotting.
* Support for Greeks using dual numbers.