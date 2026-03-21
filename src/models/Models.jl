module Models

using Reexport
using Distributions: cdf, Normal
using Statistics: mean
using QuadGK: quadgk
using Dates

@reexport using ..Engines
using ..Instruments
using ..MarketData
import ..Engines: price

export PricingModel
export BlackScholes, GarmanKohlhagen, CoxRossRubinstein, JarrowRudd, Tian,
       LeisenReimer, LongstaffSchwartz, HestonModel, RendlemanBartter
export BlackKarasinski, BrennanSchwartz, CoxIngersollRoss, Vasicek

"Abstract supertype for stochastic process models. Subtypes hold model-specific calibrated parameters."
abstract type PricingModel end

"Base abstract type for all pricing models in this package."
abstract type Model <: PricingModel end

include("black_karasinski.jl")
include("black_scholes.jl")
include("brennan_schwartz.jl")
include("cox_ingersoll_ross.jl")
include("cox_ross_rubinstein.jl")
include("garman_kohlhagen.jl")
include("jarrow_rudd.jl")
include("leisen_reimer.jl")
include("longstaff_schwartz.jl")
include("rendleman_bartter.jl")
include("tian.jl")
include("vasicek.jl")
include("heston.jl")

end # module
