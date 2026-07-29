# SPRT.jl

![License](https://img.shields.io/github/license/andrew-yoo/SPRT.jl)

SPRT.jl is a lightweight package implementing Wald's Sequential Probability Ratio Test.
This is similar to the CRAN package [SPRT](https://cran.r-project.org/web/packages/SPRT/index.html) but with some additional functionality.

## Usage

SPRTs can be run with the `sprt` function. 
The [Distributions.jl](https://juliastats.org/Distributions.jl/stable/) dependency allows SPRTs to be run on many of distributions.


```julia
using SPRT, Distributions

res = sprt([18,15,18,23,26,30,36], SPRTIn(Normal(10,10), Normal(20,10)); α=0.05, β=0.05)
```

Quick terminal-based plotting is managed by [UnicodePlots.jl](https://juliaplots.org/UnicodePlots.jl/stable/).

```julia
plot_sprt(res)
```

Obviously, you are free to make graphics using your preferred plotting library; the `SPRTOut` struct's `LogL`, `A`, and `B` make that trivial.
