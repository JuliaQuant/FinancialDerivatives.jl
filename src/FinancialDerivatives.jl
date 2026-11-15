"""
Compute the fair value of financial derivatives.

The package has the following object: 

- [`FinancialInstrument`](@ref): features that characterizes the contract, for example the strike and the expiry.
- [`AbstractMarketData`](@ref): the market observables, for example the spot price and the volatility. 
- [`Models.Model`](@ref): the stochastic dynamics mathematical modelling of the underlying, and the parameters of the dynamics.
- [`PricingEngine`](@ref): the numerical method and its settings, for example the number of tree steps.

[`price`](@ref) is the only pricing function:

    price(engine, instrument, model, market_data)

Multiple dispatch selects the method from the types of the four arguments.
A closed-form formula has one method for its combination of types.
The binomial tree and the Monte Carlo simulation have generic methods.
A generic method accepts each model and each instrument that implement the functions that the method calls.

[`simulate`](@ref) returns the simulated paths of a model:

    simulate(engine, model, market_data, t)

# Design patterns

The package is based on the following software design patterns:

- **Strategy**: each algorithm has its own type, and one common function runs all the algorithms.
    Here, the engine and the model define the computational strategies, and `price` is the common function.
    The caller passes them to `price` to select the algorithm. The engine also holds the  simulation 
    settings of its algorithm, for example `steps` or `num_paths`. The [`BinomialScheme`](@ref) is a strategy
    of the binomial engine: the scheme selects the moves of the tree.
- **Bridge**: the description of an object and the computation on the object are in two independent type hierarchies.
    Each hierarchy can change without a change to the other one. Here, the instrument types are the description, and the 
    engine types are the computation. Unlike the classic Bridge, the instrument does not hold a reference to the engine.
- **Template method**: one generic method holds the steps of an algorithm, and each type supplies only the steps that are different.
    Here, the tree method and the Monte Carlo method are generic. The instrument supplies [`payoff`](@ref),
    the model supplies [`drift`](@ref) and [`diffusion`](@ref), and the scheme supplies the moves of the tree.
    Unlike the classic Template method, the types supply the steps through multiple dispatch, not through inheritance.
- **Facade**: one module gives the caller a single point of access to many submodules.  After `using FinancialDerivatives`,  
    the caller does not need the names of the submodules. The package does not export those names.

The package also applies the dependency inversion principle.
The engines, the models, the instruments, and the market data depend on function declarations.
They do not depend on each other.
For example, the engines read the market data only through the accessors, such as [`spot`](@ref) and [`discount_rate`](@ref).
If a new type implements those functions, the engines accept the new type.

# Examples

These calls compute the value of the same option with three different algorithms.

```julia
option = AmericanOption(90.0, 0.5, false)
md = EquityMarketData(; spot_price=100.0, risk_free_rate=0.05, dividend_yield=0.0, volatility=0.3)

price(BinomialEngine(; scheme=CoxRossRubinstein()), option, BlackScholes(), md)
price(BinomialEngine(; scheme=JarrowRudd()), option, BlackScholes(), md)
price(MonteCarloEngine(), option, BlackScholes(), md)
```
"""
module FinancialDerivatives

include("sources.jl")

using .Engines
using .MarketData
using .Instruments
using .Models

# The package does not export the names of the submodules. For example, `MarketData` is
# also the name of a registered package.
for submodule in (Engines, MarketData, Instruments, Models), name in names(submodule)
    getfield(submodule, name) isa Module || @eval export $name
end

end # module
