module FinancialDerivatives

import Distributions: cdf, Normal
import Statistics: mean

export InterestRateDerivative,
       Option,
       FXOption

export BlackScholes,
       BrennanSchwartz,
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

include("models/black_scholes.jl")
include("models/brennan_schwartz.jl")
include("models/cox_ross_rubinstein.jl")
include("models/garman_kohlhagen.jl")
include("models/jarrow_rudd.jl")
include("models/leisen_reimer.jl")
include("models/longstaff_schwartz.jl")
include("models/rendleman_bartter.jl")
include("models/tian.jl")
include("models/vasicek.jl")

end # module
