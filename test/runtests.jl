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
    # The default number of steps is even. The tree must then use one more step.
    engine = BinomialEngine(; scheme=LeisenReimer())
    @test price(engine, eu_put, BlackScholes(), eu_md) ≈
          price(AnalyticEngine(), eu_put, BlackScholes(), eu_md) atol = 1e-5
    @test price(engine, am_put, BlackScholes(), am_md) ≈ 3.22 atol = 0.25
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
    monte_carlo = MonteCarloEngine(; num_paths=100_000, rng=Xoshiro(59))
    @test price(BinomialEngine(), eu_put, BlackScholes(), eu_md) ≈ exact atol = 0.01
    @test price(monte_carlo, eu_put, BlackScholes(), eu_md) ≈ exact atol = 0.1
    # The type of the option does not select the asset class.
    @test price(BinomialEngine(), eu_put, GarmanKohlhagen(), fx_md) ≈
          price(AnalyticEngine(), fxp, GarmanKohlhagen(), fx_md) atol = 0.01
end

@testset "Term structure" begin
    # Each curve fails outside the horizons from zero to the expiry.
    t = 2.0
    strict(curve) = h -> 0 ≤ h ≤ t ? curve(h) : throw(DomainError(h))
    rate = strict(h -> 0.02 + 0.01h)
    vol = strict(h -> 0.25 + 0.05h)
    put = EuropeanOption(100.0, t, false)
    american_put = AmericanOption(100.0, t, false)

    # A European option has the value of the flat market data at the expiry.
    curve_md = EquityMarketData(; spot_price=100.0, risk_free_rate=rate,
                                dividend_yield=0.01,
                                volatility=vol)
    flat_md = EquityMarketData(; spot_price=100.0, risk_free_rate=rate(t),
                               dividend_yield=0.01, volatility=vol(t))
    exact = price(AnalyticEngine(), put, BlackScholes(), flat_md)
    @test price(AnalyticEngine(), put, BlackScholes(), curve_md) ≈ exact
    @test price(BinomialEngine(), put, BlackScholes(), curve_md) ≈ exact atol = 0.01

    # An American option depends on the forward rate of each step. The reference value is
    # from a tree that reads the forward rate of each step.
    rate_md = EquityMarketData(; spot_price=100.0, risk_free_rate=rate, dividend_yield=0.0,
                               volatility=0.3)
    @test price(BinomialEngine(), american_put, BlackScholes(), rate_md) ≈ 13.84 atol = 0.01
    monte_carlo = MonteCarloEngine(; num_paths=100_000, num_steps=100, rng=Xoshiro(59))
    @test price(monte_carlo, american_put, BlackScholes(), curve_md) ≈
          price(BinomialEngine(), american_put, BlackScholes(), curve_md) atol = 0.2
end

@testset "Invalid inputs" begin
    @test_throws ArgumentError BinomialEngine(; steps=0)
    @test_throws ArgumentError MonteCarloEngine(; num_steps=0)
    @test_throws ArgumentError EquityMarketData(; spot_price=100.0, risk_free_rate="5%",
                                                dividend_yield=0.0, volatility=0.3)

    # With too few steps for the rate, a probability of the tree is more than 1.
    call = EuropeanOption(100.0, 1.0, true)
    low_vol = EquityMarketData(; spot_price=100.0, risk_free_rate=0.1, dividend_yield=0.0,
                               volatility=0.01)
    @test_throws ArgumentError price(BinomialEngine(; steps=10), call, BlackScholes(),
                                     low_vol)

    # The total variance of this volatility decreases.
    falling = EquityMarketData(; spot_price=100.0, risk_free_rate=0.05, dividend_yield=0.0,
                               volatility=h -> 0.4 - 0.3h)
    @test_throws ArgumentError price(MonteCarloEngine(; num_steps=10),
                                     AmericanOption(90.0, 1.0, false), BlackScholes(),
                                     falling)

    # The Monte Carlo engine has no method for a model with two factors.
    heston = HestonModel(; v=0.09, v̄=0.09, κ=2.0, σ=0.3, ρ=-0.7)
    @test_throws MethodError price(MonteCarloEngine(), eu_put, heston, eu_md)
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

    # The time between the two dates has the Actual/365 Fixed day count.
    @test eu_call_h.t == 92 / 365
    @test price(AnalyticEngine(), eu_call_h, m, heston_md) ≈ 8982 atol = 1
    # put-call parity
    @test price(AnalyticEngine(), eu_call_h, m, heston_md) + k * exp(-r * eu_call_h.t) ≈
          price(AnalyticEngine(), eu_put_h, m, heston_md) + s * exp(-q * eu_put_h.t)
end
