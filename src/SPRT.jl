module SPRT

using Distributions

export SPRTOut, SPRTIn, sprt

struct SPRTIn{D}
    null::D
    alt::D
end

struct SPRTOut
    decision::String
    n_decision::Union{Int, Nothing}
    logL::Vector{Float64}
    A::Float64
    B::Float64
end

function sprt(x::AbstractVector{<:Real}, plan::SPRTIn; α=0.05, β=0.05)
    # Thresholds
    A = log((1 - β) / α)
    B = log(β / (1 - α))

    logL = Float64[]
    s = 0.0 # cumulative LLR

    for (i, xi) in enumerate(x)
        s += logpdf(plan.alt, xi) - logpdf(plan.null, xi)
        push!(logL, s)

        # Check thresholds
        if s >= A
            return SPRTOut("Reject H0", i, logL, A, B)
        end
        if s <= B
            return SPRTOut("Accept H0", i, logL, A, B)
        end
    end
    
    return SPRTOut("Continue sampling", i, logL, A, B)
end

end
