"""
The `FinancialDerivatives` module provides convenient models for pricing financial derivatives in Julia.
"""
module FinancialDerivatives

import Distributions: cdf, Normal
import Statistics: mean

export InterestRateDerivative,
       AmericanOption,
       AsianOption,
       EuropeanOption,
       FXOption,
       iscall,
       isput

export BlackKarasinski,
       BlackScholes,
       BrennanSchwartz,
       CoxIngersollRoss,
       CoxRossRubinstein,
       GarmanKohlhagen,
       JarrowRudd,
       LeisenReimer,
       LongstaffSchwartz,
       RendlemanBartter,
       Tian,
       Vasicek

export evaluate

abstract type Model end

include("derivatives.jl")

include("models/black_karasinski.jl")
include("models/black_scholes.jl")
include("models/brennan_schwartz.jl")
include("models/cox_ingersoll_ross.jl")
include("models/cox_ross_rubinstein.jl")
include("models/garman_kohlhagen.jl")
include("models/jarrow_rudd.jl")
include("models/leisen_reimer.jl")
include("models/longstaff_schwartz.jl")
include("models/rendleman_bartter.jl")
include("models/tian.jl")
include("models/vasicek.jl")

end # module
