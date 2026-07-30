

using SequentialProbability
using Distributions
using Test

@testset "SPRT" begin
    @testset "Bernoulli" begin
        input = SPRTIn(Bernoulli(0.1), Bernoulli(0.9))

        x1 = zeros(Int, 10)
        x2 = [0,1,0,1,0,1,0,1,0,1]
        x3 = ones(Int, 10)
        
        @test sprt(x1, input).decision == "Accept H0"
        @test sprt(x2, input).decision == "Continue sampling"
        @test sprt(x3, input).decision == "Reject H0"
    end

    @testset "Poisson" begin
        input = SPRTIn(Poisson(1), Poisson(10))

        x1 = zeros(Int, 10)
        x2 = fill(4, 10)
        x3 = vcat(fill(10, 5), fill(11, 5))

        @test sprt(x1, input).decision == "Accept H0"
        @test sprt(x2, input).decision == "Continue sampling"
        @test sprt(x3, input).decision == "Reject H0"
    end

    @testset "Normal" begin
        input = SPRTIn(Normal(0,1), Normal(1,1))

        x1 = zeros(10)
        x2 = fill(0.5, 10)
        x3 = fill(1, 10)

        @test sprt(x1, input).decision == "Accept H0"
        @test sprt(x2, input).decision == "Continue sampling"
        @test sprt(x3, input).decision == "Reject H0"
    end
end