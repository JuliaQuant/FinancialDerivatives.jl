abstract type Derivative end

abstract type Forward <: Derivative end

abstract type Future <: Derivative end

abstract type Swap <: Derivative end

abstract type Swaption <: Derivative end

struct InterestRateDerivative{T<:Number}
    k::T
    r::T
    σ::T
    θ::T
    t::T
end

struct Option{T<:Number}
    s::T
    k::T
    r::T
    σ::T
    t::T
    call::Int64
end

struct FXOption{T<:Number} 
    s::T
    k::T
    r_d::T
    r_f::T
    σ::T
    t::T
    call::Int64
end
