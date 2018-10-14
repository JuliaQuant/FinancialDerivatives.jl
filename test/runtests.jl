using FinancialDerivatives
using Test

op = AmericanOption(100.0, 90.0, 0.05, 0.3, 180/365, -1)
oc = AmericanOption(100.0, 90.0, 0.05, 0.3, 180/365, 1)

@testset "Black-Scholes" begin
    @test isapprox(evaluate(op, BlackScholes()), 3.22, atol=0.1)
    @test isapprox(evaluate(oc, BlackScholes()), 15.42, atol=0.1)
end

@testset "Cox-Ross-Rubinstein" begin
    @test isapprox(evaluate(op, CoxRossRubinstein()), 3.22, atol=0.1)
    @test isapprox(evaluate(oc, CoxRossRubinstein()), 15.42, atol=0.1)
end

@testset "Jarrow-Rudd" begin
    @test isapprox(evaluate(op, JarrowRudd()), 3.22, atol=0.25)
    @test isapprox(evaluate(oc, JarrowRudd()), 15.42, atol=0.25)
    @test isapprox(evaluate(op, JarrowRudd(), false), 3.22, atol=0.25)
    @test isapprox(evaluate(oc, JarrowRudd(), false), 15.42, atol=0.25)
end

@testset "Longstaff-Schwartz" begin
    @test isapprox(evaluate(op, LongstaffSchwartz()), 3.22, atol=1)
    @test isapprox(evaluate(oc, LongstaffSchwartz()), 15.42, atol=1)
end

@testset "Tian" begin
    @test isapprox(evaluate(op, Tian()), 5.15, atol=0.25)
    @test isapprox(evaluate(oc, Tian()), 11.87, atol=0.25)
end

@testset "Garman–Kohlhagen" begin
    fxp = FXOption(100.0, 90.0, 0.05, 0.025, 0.3, 180/365, -1)
    fxc = FXOption(100.0, 90.0, 0.05, 0.025, 0.3, 180/365, 1)
    @test isapprox(evaluate(fxp, GarmanKohlhagen()), 3.51, atol=0.25)
    @test isapprox(evaluate(fxc, GarmanKohlhagen()), 14.48, atol=0.25)
end

ird = InterestRateDerivative(0.01875, 0.20, 0.01, 0.012, 180/365)

@testset "Brennan-Schwartz" begin
    @test isapprox(evaluate(ird, BrennanSchwartz(), 2), [0.2, 0.2, 0.2, 0.2], atol=0.25)
end

@testset "Rendleman-Bartter" begin
    @test isapprox(evaluate(op, RendlemanBartter()), 3.22, atol=0.25)
    @test isapprox(evaluate(oc, RendlemanBartter()), 15.42, atol=0.25)
    @test isapprox(evaluate(ird, RendlemanBartter(), 2), [0.2, 0.2, 0.2, 0.2], atol=0.025)
end

@testset "Vasicek" begin
    @test isapprox(evaluate(ird, Vasicek(), 2), [0.2, 0.2, 0.2, 0.2], atol=0.025)
end
