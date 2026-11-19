# API

## Instruments

```@docs
FinancialInstrument
AmericanOption
AsianOption
EuropeanOption
FXOption
payoff
isamerican
```

### Day counts

```@docs
DayCount
Actual365Fixed
Business252
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
discount_factor
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
FinancialDerivatives.Engines.tree_steps
```

## Models

```@docs
FinancialDerivatives.Models.Model
OneFactorModel
LognormalModel
ShortRateModel
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
initial_state
growth_rate
drift
diffusion
FinancialDerivatives.Models.transition
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
