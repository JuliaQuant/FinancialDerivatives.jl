using FinancialDerivatives
using Test

op = Option(100.0, 90.0, 0.05, 0.3, 180/365, -1)
oc = Option(100.0, 90.0, 0.05, 0.3, 180/365, 1)

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
end

@testset "Longstaff-Schwartz" begin
    @test isapprox(evaluate(op, LongstaffSchwartz()), 3.22, atol=1)
    @test isapprox(evaluate(oc, LongstaffSchwartz()), 15.42, atol=1)
end

@testset "Garman–Kohlhagen" begin
    fxp = FXOption(100.0, 90.0, 0.05, 0.025, 0.3, 180/365, -1)
    fxc = FXOption(100.0, 90.0, 0.05, 0.025, 0.3, 180/365, 1)
    @test isapprox(evaluate(fxp, GarmanKohlhagen()), 3.51, atol=0.25)
    @test isapprox(evaluate(fxc, GarmanKohlhagen()), 14.48, atol=0.25)
end
