module Models

using Reexport

"Abstract supertype for stochastic process models. Subtypes hold model-specific calibrated parameters."
abstract type PricingModel end

"""
Abstract supertype for all the pricing models in this package.

Each subtype is a strategy of the Strategy pattern. The type of the model selects the
[`price`](@ref) method.

To add a model, define a subtype and a [`price`](@ref) method for that subtype.
"""
abstract type Model <: PricingModel end

include("BlackKarasinskiModule.jl")
@reexport using .BlackKarasinskiModule

include("BlackScholesModule.jl")
@reexport using .BlackScholesModule

include("BrennanSchwartzModule.jl")
@reexport using .BrennanSchwartzModule

include("CoxIngersollRossModule.jl")
@reexport using .CoxIngersollRossModule

include("CoxRossRubinsteinModule.jl")
@reexport using .CoxRossRubinsteinModule

include("GarmanKohlhagenModule.jl")
@reexport using .GarmanKohlhagenModule

include("JarrowRuddModule.jl")
@reexport using .JarrowRuddModule

include("LeisenReimerModule.jl")
@reexport using .LeisenReimerModule

include("LongstaffSchwartzModule.jl")
@reexport using .LongstaffSchwartzModule

include("RendlemanBartterModule.jl")
@reexport using .RendlemanBartterModule

include("TianModule.jl")
@reexport using .TianModule

include("VasicekModule.jl")
@reexport using .VasicekModule

include("HestonModelModule.jl")
@reexport using .HestonModelModule

end # module
