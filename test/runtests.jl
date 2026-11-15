using Test
using Dates
using Random
using Statistics
using FinancialDerivatives

# --- Equity options ---
eu_md = EquityMarketData(; spot_price=100.0, risk_free_rate=0.05, dividend_yield=0.01,
                         volatility=0.3)
eu_put = EuropeanOption(90.0, 180 / 365, false)
eu_call = EuropeanOption(90.0, 180 / 365, true)

am_md = EquityMarketData(; spot_price=100.0, risk_free_rate=0.05, dividend_yield=0.0,
                         volatility=0.3)
am_put = AmericanOption(90.0, 180 / 365, false)
am_call = AmericanOption(90.0, 180 / 365, true)

# --- FX options ---
fx_md = FXMarketData(; spot_price=100.0, domestic_rate=0.05, foreign_rate=0.025,
                     volatility=0.3)
fxp = FXOption(90.0, 180 / 365, false)
fxc = FXOption(90.0, 180 / 365, true)

@testset "Black-Scholes" begin
    @test price(AnalyticEngine(), eu_put, BlackScholes(), eu_md) ≈ 3.34 atol = 0.1
    @test price(AnalyticEngine(), eu_call, BlackScholes(), eu_md) ≈ 15.04 atol = 0.1
    # put-call parity
    k, t = eu_call.k, eu_call.t
    r, q, S = discount_rate(eu_md, t), dividend_yield(eu_md), spot(eu_md)
    @test price(AnalyticEngine(), eu_call, BlackScholes(), eu_md) + k * exp(-r * t) ≈
          price(AnalyticEngine(), eu_put, BlackScholes(), eu_md) + S * exp(-q * t)
end

@testset "Cox-Ross-Rubinstein" begin
    engine = BinomialEngine(; scheme=CoxRossRubinstein())
    @test price(engine, am_put, BlackScholes(), am_md) ≈ 3.22 atol = 0.1
    @test price(engine, am_call, BlackScholes(), am_md) ≈ 15.42 atol = 0.1
end

@testset "Jarrow-Rudd" begin
    engine = BinomialEngine(; scheme=JarrowRudd())
    @test price(engine, am_put, BlackScholes(), am_md) ≈ 3.22 atol = 0.25
    @test price(engine, am_call, BlackScholes(), am_md) ≈ 15.42 atol = 0.25
end

@testset "Longstaff-Schwartz" begin
    engine = MonteCarloEngine(; rng=Xoshiro(59))
    @test price(engine, am_put, BlackScholes(), am_md) ≈ 3.22 atol = 0.4
    @test price(engine, am_call, BlackScholes(), am_md) ≈ 15.42 atol = 1.0
end

@testset "Tian" begin
    engine = BinomialEngine(; scheme=Tian())
    @test price(engine, am_put, BlackScholes(), am_md) ≈ 3.22 atol = 0.25
    @test price(engine, am_call, BlackScholes(), am_md) ≈ 15.42 atol = 0.25
end

@testset "Leisen-Reimer" begin
    engine = BinomialEngine(; scheme=LeisenReimer())
    @test price(engine, am_put, BlackScholes(), am_md) ≈ 3.22 atol = 0.25
    @test price(engine, am_call, BlackScholes(), am_md) ≈ 15.42 atol = 0.25
end

@testset "Garman-Kohlhagen" begin
    @test price(AnalyticEngine(), fxp, GarmanKohlhagen(), fx_md) ≈ 3.51 atol = 0.25
    @test price(AnalyticEngine(), fxc, GarmanKohlhagen(), fx_md) ≈ 14.48 atol = 0.25
end

@testset "Rendleman-Bartter" begin
    engine = BinomialEngine(; scheme=RendlemanBartterTree())
    @test price(engine, am_put, BlackScholes(), am_md) ≈ 3.22 atol = 0.25
    @test price(engine, am_call, BlackScholes(), am_md) ≈ 15.42 atol = 0.25
end

@testset "Engines agree" begin
    # A European option has one value, for each engine and for each asset class.
    exact = price(AnalyticEngine(), eu_put, BlackScholes(), eu_md)
    monte_carlo = MonteCarloEngine(; num_paths=100_000, num_steps=1, rng=Xoshiro(59))
    @test price(BinomialEngine(), eu_put, BlackScholes(), eu_md) ≈ exact atol = 0.01
    @test price(monte_carlo, eu_put, BlackScholes(), eu_md) ≈ exact atol = 0.1
    @test price(BinomialEngine(), fxp, GarmanKohlhagen(), fx_md) ≈
          price(AnalyticEngine(), fxp, GarmanKohlhagen(), fx_md) atol = 0.01
end

@testset "Term structure" begin
    t = eu_put.t
    rate(horizon) = 0.04 + 0.02 * horizon
    vol(horizon) = 0.25 + 0.1 * horizon
    curve_md = EquityMarketData(; spot_price=100.0, risk_free_rate=rate,
                                dividend_yield=0.01,
                                volatility=vol)
    flat_md = EquityMarketData(; spot_price=100.0, risk_free_rate=rate(t),
                               dividend_yield=0.01, volatility=vol(t))

    exact = price(AnalyticEngine(), eu_put, BlackScholes(), flat_md)
    @test price(AnalyticEngine(), eu_put, BlackScholes(), curve_md) ≈ exact
    # With more than one step, the simulation must use the forward rate of each step.
    monte_carlo = MonteCarloEngine(; num_paths=100_000, num_steps=4, rng=Xoshiro(59))
    @test price(monte_carlo, eu_put, BlackScholes(), curve_md) ≈ exact atol = 0.1
end

@testset "Short-rate paths" begin
    k, r, σ, θ, t = 1.0, 0.1, 0.2, 0.05, 1.0
    steps, paths = 200, 5_000
    md = InterestRateMarketData(; short_rate=r)
    engine = MonteCarloEngine(; num_paths=paths, num_steps=steps, rng=Xoshiro(60))

    # Exact mean and standard deviation at expiry, of the rate or of its logarithm.
    decay = exp(-k * t)
    rate_mean = θ + (r - θ) * decay
    ou_std = σ * √((1 - decay^2) / (2k))
    a = 2k - σ^2
    decay2 = exp(-a * t)
    bs_integral = θ * (1 - decay2) / a + (r - θ) * (decay - decay2) / (a - k)
    bs_second_moment = r^2 * decay2 + 2k * θ * bs_integral
    cir_var = r * σ^2 / k * (decay - decay^2) + θ * σ^2 / (2k) * (1 - decay)^2
    cases = [(Vasicek(; k, θ, σ), identity, rate_mean, ou_std),
             (BrennanSchwartz(; k, θ, σ), identity, rate_mean,
              √(bs_second_moment - rate_mean^2)),
             (CoxIngersollRoss(; k, θ, σ), identity, rate_mean, √cir_var),
             (BlackKarasinski(; k, θ, σ), log, log(θ) + (log(r) - log(θ)) * decay, ou_std),
             (RendlemanBartter(; θ, σ), log, log(r) + (θ - σ^2 / 2) * t, σ * √t)]

    for (model, scale, μ, s) in cases
        sims = simulate(engine, model, md, t)
        @test size(sims) == (steps + 1, paths)
        final = scale.(sims[end, :])
        @test mean(final) ≈ μ atol = 5s / √paths
        @test std(final) ≈ s rtol = 0.1
    end

    # Shocks this large push the simulated rate below zero.
    wild = CoxIngersollRoss(; k, θ=0.01, σ=2.0)
    wild_md = InterestRateMarketData(; short_rate=0.01)
    @test all(isfinite, simulate(engine, wild, wild_md, t))
end

@testset "Heston" begin
    s, r, σ, q, k = 56371, 0.05078, 0.86, 0.005, 58000
    t0 = Date(2024, 5, 11)
    t1 = t0 + Month(3)
    heston_md = EquityMarketData(spot_price=float(s), risk_free_rate=r,
                                 dividend_yield=q, volatility=σ)
    m = HestonModel(v=σ^2, v̄=σ^2, κ=2, σ=σ, ρ=-0.7)
    eu_put_h = EuropeanOption(; k, t0, t1, call=false)
    eu_call_h = EuropeanOption(; k, t0, t1, call=true)

    @test price(AnalyticEngine(), eu_call_h, m, heston_md) ≈ 8982 atol = 1
    # put-call parity
    @test price(AnalyticEngine(), eu_call_h, m, heston_md) + k * exp(-r * eu_call_h.t) ≈
          price(AnalyticEngine(), eu_put_h, m, heston_md) + s * exp(-q * eu_put_h.t)
end
