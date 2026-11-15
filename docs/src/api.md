# API

## Instruments

```@docs
FinancialInstrument
AmericanOption
AsianOption
EuropeanOption
FXOption
payoff
```

## Market Data

```@docs
FinancialDerivatives.MarketData.AbstractMarketData
EquityMarketData
FXMarketData
InterestRateMarketData
```

### Accessors

```@docs
spot
discount_rate
foreign_rate
dividend_yield
volatility
short_rate
```

## Pricing Engines

```@docs
FinancialDerivatives.Engines.PricingEngine
AnalyticEngine
BinomialEngine
MonteCarloEngine
FiniteDifferenceEngine
```

### Binomial schemes

```@docs
BinomialScheme
CoxRossRubinstein
JarrowRudd
LeisenReimer
RendlemanBartterTree
Tian
FinancialDerivatives.Engines.tree_parameters
```

## Models

```@docs
FinancialDerivatives.Models.Model
FinancialDerivatives.Models.LognormalModel
FinancialDerivatives.Models.ShortRateModel
BlackKarasinski
BlackScholes
BrennanSchwartz
CoxIngersollRoss
GarmanKohlhagen
HestonModel
RendlemanBartter
Vasicek
```

### Model interface

```@docs
drift
diffusion
FinancialDerivatives.Models.growth_rate
```

## Pricing and simulation

```@docs
price
simulate
```

## Private

```@docs
FinancialDerivatives.Instruments.Derivative
FinancialDerivatives.Instruments.Forward
FinancialDerivatives.Instruments.Future
FinancialDerivatives.Instruments.Option
FinancialDerivatives.Instruments.Swap
FinancialDerivatives.Instruments.Swaption
```
