using Test
using Dates
using FinancialDerivatives

eu_put = EuropeanOption(; s=100.0, k=90.0, r=0.05, q=0.01, σ=0.3, t=180 / 365, call=false)
eu_call = EuropeanOption(; s=eu_put.s, k=eu_put.k, r=eu_put.r, q=eu_put.q, σ=eu_put.σ,
                         t=eu_put.t, call=true)

am_put = AmericanOption(100.0, 90.0, 0.05, 0.3, 180 / 365, false)
am_call = AmericanOption(100.0, 90.0, 0.05, 0.3, 180 / 365, true)

@testset "Black-Scholes" begin
    @test evaluate(eu_put, BlackScholes()) ≈ 3.34 atol = 0.1
    @test evaluate(eu_call, BlackScholes()) ≈ 15.04 atol = 0.1
    @test evaluate(eu_call, BlackScholes()) + eu_call.k * exp(-eu_call.r * eu_call.t) ==
          evaluate(eu_put, BlackScholes()) + eu_put.s * exp(-eu_put.q * eu_put.t)
end

@testset "Cox-Ross-Rubinstein" begin
    @test evaluate(am_put, CoxRossRubinstein()) ≈ 3.22 atol = 0.1
    @test evaluate(am_call, CoxRossRubinstein()) ≈ 15.42 atol = 0.1
end

@testset "Jarrow-Rudd" begin
    @test evaluate(am_put, JarrowRudd()) ≈ 3.22 atol = 0.25
    @test evaluate(am_call, JarrowRudd()) ≈ 15.42 atol = 0.25
    @test evaluate(am_put, JarrowRudd(), false) ≈ 3.22 atol = 0.25
    @test evaluate(am_call, JarrowRudd(), false) ≈ 15.42 atol = 0.25
end

@testset "Longstaff-Schwartz" begin
    @test evaluate(am_put, LongstaffSchwartz()) ≈ 3.22 atol = 0.4
    @test evaluate(am_call, LongstaffSchwartz()) ≈ 15.42 atol = 0.4
end

@testset "Tian" begin
    @test evaluate(am_put, Tian()) ≈ 5.15 atol = 0.25
    @test evaluate(am_call, Tian()) ≈ 11.87 atol = 0.25
end

@testset "Garman–Kohlhagen" begin
    fxp = FXOption(100.0, 90.0, 0.05, 0.025, 0.3, 180 / 365, false)
    fxc = FXOption(100.0, 90.0, 0.05, 0.025, 0.3, 180 / 365, true)
    @test evaluate(fxp, GarmanKohlhagen()) ≈ 3.51 atol = 0.25
    @test evaluate(fxc, GarmanKohlhagen()) ≈ 14.48 atol = 0.25
end

ird = InterestRateDerivative(0.01875, 0.20, 0.01, 0.012, 180 / 365)

@testset "Black-Karasinski" begin
    @test evaluate(ird, BlackKarasinski(), 2) ≈ [0.2, 0.2, 0.2, 0.2] atol = 0.25
end

@testset "Brennan-Schwartz" begin
    @test evaluate(ird, BrennanSchwartz(), 2) ≈ [0.2, 0.2, 0.2, 0.2] atol = 0.25
end

@testset "Rendleman-Bartter" begin
    @test evaluate(am_put, RendlemanBartter()) ≈ 3.22 atol = 0.25
    @test evaluate(am_call, RendlemanBartter()) ≈ 15.42 atol = 0.25
    @test evaluate(ird, RendlemanBartter(), 2) ≈ [0.2, 0.2, 0.2, 0.2] atol = 0.025
end

@testset "Vasicek" begin
    @test evaluate(ird, Vasicek(), 2) ≈ [0.2, 0.2, 0.2, 0.2] atol = 0.025
end

@testset "Heston" begin
    s = 56371 # Initial stock price
    r = 0.05078 # Risk-free rate
    σ = 0.86 # Volatility
    q = 0.005 # Dividend yield (staking yield)
    k = 58000 # Strike price
    v = σ^2 # Initial variance
    v̄ = σ^2 # Long term variance mean
    κ = 2 # Mean reversion rate
    σ_v = 0.86 # Volatility of volatility
    ρ = -0.7 # Correlation between price and volatility

    t0 = Date(2024, 5, 11)
    t1 = t0 + Month(3)
    τ = t1 - t0
    year_days = Dates.value(lastdayofyear(Date(2024))) -
                Dates.value(firstdayofyear(Date(2024)))
    t = Dates.value(τ) / year_days

    m = HestonModel(v, v̄, κ, ρ)
    eu_put = EuropeanOption(; s, k, r, q, σ, t, call=false)
    eu_call = EuropeanOption(; s, k, r, q, σ, t, call=true)

    @test evaluate(eu_call, m) ≈ 8982 atol = 1
    @test evaluate(eu_call, m) + eu_call.k * exp(-eu_call.r * eu_call.t) ==
          evaluate(eu_put, m) + eu_put.s * exp(-eu_put.q * eu_put.t)
end
