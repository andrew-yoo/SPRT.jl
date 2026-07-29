module SPRT

using Distributions
using UnicodePlots

export SPRTOut, SPRTIn, sprt, plot_sprt

struct SPRTIn{D}
    null::D
    alt::D
end

struct SPRTOut
    decision::String
    n_decision::Int
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
    
    return SPRTOut("Continue sampling", length(x), logL, A, B)
end

function plot_sprt(out::SPRTOut)
    lst = pushfirst!(out.logL, 0)
    len = length(lst)
    min_ = min(out.B, minimum(lst))
    max_ = max(out.A, maximum(lst))

    p = lineplot(0:len-1, lst; xlim=(0, len-1), ylim=(min_, max_), xlabel="Sample", ylabel="Cumulative LLR", title="Sequential Probability Ratio Test", color=:blue, canvas=BrailleCanvas)
    hline!(p, out.A, color=:green)
    hline!(p, out.B, color=:red)
end

end
