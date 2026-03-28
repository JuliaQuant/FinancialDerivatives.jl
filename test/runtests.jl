using Test
using Dates
using FinancialDerivatives

# --- Equity options ---
eu_md = EquityMarketData(; spot_price=100.0, risk_free_rate=0.05, dividend_yield=0.01,
                         volatility=0.3)
eu_put = EuropeanOption(100.0, 90.0, 0.05, 0.01, 0.3, 180 / 365, false)
eu_call = EuropeanOption(100.0, 90.0, 0.05, 0.01, 0.3, 180 / 365, true)

am_md = EquityMarketData(; spot_price=100.0, risk_free_rate=0.05, dividend_yield=0.0,
                         volatility=0.3)
am_put = AmericanOption(100.0, 90.0, 0.05, 0.3, 180 / 365, false)
am_call = AmericanOption(100.0, 90.0, 0.05, 0.3, 180 / 365, true)

# --- FX options ---
fx_md = FXMarketData(; spot_price=100.0, domestic_rate=0.05, foreign_rate=0.025,
                     volatility=0.3)
fxp = FXOption(100.0, 90.0, 0.05, 0.025, 0.3, 180 / 365, false)
fxc = FXOption(100.0, 90.0, 0.05, 0.025, 0.3, 180 / 365, true)

# --- Interest rate derivatives ---
ir_md = InterestRateMarketData(; short_rate=0.20, volatility=0.01,
                               mean_reversion_speed=0.01875, long_term_mean=0.012)
ird = InterestRateDerivative(0.01875, 0.20, 0.01, 0.012, 180 / 365)

@testset "Black-Scholes" begin
    @test price(AnalyticEngine(), eu_put, BlackScholes(), eu_md) ≈ 3.34 atol = 0.1
    @test price(AnalyticEngine(), eu_call, BlackScholes(), eu_md) ≈ 15.04 atol = 0.1
    # put-call parity
    k, t = eu_call.k, eu_call.t
    r, q, S = eu_md.risk_free_rate, eu_md.dividend_yield, eu_md.spot_price
    @test price(AnalyticEngine(), eu_call, BlackScholes(), eu_md) + k * exp(-r * t) ≈
          price(AnalyticEngine(), eu_put, BlackScholes(), eu_md) + S * exp(-q * t)
end

@testset "Cox-Ross-Rubinstein" begin
    @test price(BinomialEngine(), am_put, CoxRossRubinstein(), am_md) ≈ 3.22 atol = 0.1
    @test price(BinomialEngine(), am_call, CoxRossRubinstein(), am_md) ≈ 15.42 atol = 0.1
end

@testset "Jarrow-Rudd" begin
    @test price(BinomialEngine(), am_put, JarrowRudd(), am_md) ≈ 3.22 atol = 0.25
    @test price(BinomialEngine(), am_call, JarrowRudd(), am_md) ≈ 15.42 atol = 0.25
end

@testset "Longstaff-Schwartz" begin
    @test price(MonteCarloEngine(), am_put, LongstaffSchwartz(), am_md) ≈ 3.22 atol = 0.4
    @test price(MonteCarloEngine(), am_call, LongstaffSchwartz(), am_md) ≈ 15.42 atol = 1.0
end

@testset "Tian" begin
    @test price(BinomialEngine(), am_put, Tian(), am_md) ≈ 5.15 atol = 0.25
    @test price(BinomialEngine(), am_call, Tian(), am_md) ≈ 11.87 atol = 0.25
end

@testset "Garman-Kohlhagen" begin
    @test price(AnalyticEngine(), fxp, GarmanKohlhagen(), fx_md) ≈ 3.51 atol = 0.25
    @test price(AnalyticEngine(), fxc, GarmanKohlhagen(), fx_md) ≈ 14.48 atol = 0.25
end

@testset "Black-Karasinski" begin
    @test price(BinomialEngine(steps=2), ird, BlackKarasinski(), ir_md) ≈
          [0.2, 0.2, 0.2, 0.2] atol = 0.25
end

@testset "Brennan-Schwartz" begin
    @test price(BinomialEngine(steps=2), ird, BrennanSchwartz(), ir_md) ≈
          [0.2, 0.2, 0.2, 0.2] atol = 0.25
end

@testset "Rendleman-Bartter" begin
    @test price(BinomialEngine(), am_put, RendlemanBartter(), am_md) ≈ 3.22 atol = 0.25
    @test price(BinomialEngine(), am_call, RendlemanBartter(), am_md) ≈ 15.42 atol = 0.25
    @test price(BinomialEngine(steps=2), ird, RendlemanBartter(), ir_md) ≈
          [0.2, 0.2, 0.2, 0.2] atol = 0.025
end

@testset "Vasicek" begin
    @test price(BinomialEngine(steps=2), ird, Vasicek(), ir_md) ≈ [0.2, 0.2, 0.2, 0.2] atol = 0.025
end

@testset "Heston" begin
    s, r, σ, q, k = 56371, 0.05078, 0.86, 0.005, 58000
    t0 = Date(2024, 5, 11)
    t1 = t0 + Month(3)
    heston_md = EquityMarketData(spot_price=float(s), risk_free_rate=r,
                                 dividend_yield=q, volatility=σ)
    m = HestonModel(v=σ^2, v̄=σ^2, κ=2, ρ=-0.7)
    eu_put_h = EuropeanOption(; s, k, r, q, σ, t0, t1, call=false)
    eu_call_h = EuropeanOption(; s, k, r, q, σ, t0, t1, call=true)

    @test price(AnalyticEngine(), eu_call_h, m, heston_md) ≈ 8982 atol = 1
    # put-call parity
    @test price(AnalyticEngine(), eu_call_h, m, heston_md) +
          eu_call_h.k * exp(-eu_call_h.r * eu_call_h.t) ≈
          price(AnalyticEngine(), eu_put_h, m, heston_md) +
          eu_put_h.s * exp(-eu_put_h.q * eu_put_h.t)
end
