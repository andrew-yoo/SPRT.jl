module SPRT

using Distributions

export SPRTResult, sprt

struct SPRTResult
    decision::String
    n_decision::Union{Int, Nothing}
    logL::Vector{Float64}
    A::Float64
    B::Float64
end

function sprt(x::AbstractVector{<:Real}; α=0.05, β=0.05, p0, p1, dist, σ=nothing)

    A = log((1 - β) / α)
    B = log(β / (1 - α))

    logL = Float64[]
    s = 0.0

    for (i, xi) in enumerate(x)
        if dist == "bernoulli"
            lr = logpdf(Bernoulli(p1), xi) - logpdf(Bernoulli(p0), xi)

        elseif dist == "poisson"
            lr = logpdf(Poisson(p1), xi) - logpdf(Poisson(p0), xi)

        elseif dist == "normal"
            if σ === nothing
                error("σ is required for normal distributions")
            end
            lr = logpdf(Normal(p1, σ), xi) - logpdf(Normal(p0, σ), xi)

        else
            error("dist must be one of: \"bernoulli\", \"poisson\", or \"normal\"")
        end

        s += lr
        push!(logL, s)

        if s >= A
            return SPRTResult("Reject H0", i, logL, A, B)
        end

        if s <= B
            return SPRTResult("Accept H0", i, logL, A, B)
        end
    end

    return SPRTResult("Continue sampling", nothing, logL, A, B)
end

end
