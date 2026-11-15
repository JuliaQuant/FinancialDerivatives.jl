"""
Compute the fair value of financial derivatives.

The package has the following object: 

- [`FinancialInstrument`](@ref): features that characterizes the contract, for example the strike and the expiry.
- [`AbstractMarketData`](@ref): the market observables, for example the spot price and the volatility. 
- [`Models.Model`](@ref): the stochastic dynamics mathematical modelling of the underlying. 
- [`PricingEngine`](@ref): the numerical method and its settings, for example the number of tree steps.

[`price`](@ref) is the only pricing function:

    price(engine, instrument, model, market_data)

Multiple dispatch selects the method from the types of the four arguments.
Each supported combination of types has one method.

# Design patterns

The package is based on the following software design patterns:

- **Strategy**: each algorithm has its own type, and one common function runs all the algorithms.
    Here, the engine and the model define the computational strategies, and `price` is the common function.
    The caller passes them to `price` to select the algorithm. The engine also holds the  simulation 
    settings of its algorithm, for example `steps` or `num_paths`.
- **Bridge**: the description of an object and the computation on the object are in two independent type hierarchies.
    Each hierarchy can change without a change to the other one. Here, the instrument types are the description, and the 
    engine types are the computation. Unlike the classic Bridge, the instrument does not hold a reference to the engine.
- **Facade**: one module gives the caller a single point of access to many submodules.  After `using FinancialDerivatives`,  
    the caller does not need the names of the submodules.

# Examples

These calls compute the value of the same option with three different algorithms.

```julia
option = AmericanOption(100.0, 90.0, 0.05, 0.3, 0.5, false)
md = EquityMarketData(; spot_price=100.0, risk_free_rate=0.05, dividend_yield=0.0, volatility=0.3)

price(BinomialEngine(), option, CoxRossRubinstein(), md)
price(BinomialEngine(), option, JarrowRudd(), md)
price(MonteCarloEngine(), option, LongstaffSchwartz(), md)
```
"""
module FinancialDerivatives

using Reexport

include("sources.jl")

@reexport using .Engines
@reexport using .MarketData
@reexport using .Instruments
@reexport using .Models

end # module
