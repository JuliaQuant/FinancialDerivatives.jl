<div align="center">

# FinancialDerivatives.jl

| **Documentation** |**Status** |**License** | 
|:-----------------:|:----------------------------:|:-----------:|
| [![docs-dev][dev-img]][dev-url] | [![CI][ci-img]][ci-url] [![codecov][cov-img]][cov-url] |  [![license][lic-img]][lic-url] |

<img src="docs/src/assets/hero.webp" alt="A binomial tree grows from one point, turns into random price paths, and the path ends form a bell curve" width="800">

</div>

---
## 💾 [Installing](https://julialang.github.io/Pkg.jl/v1/managing-packages/)

`FinancialDerivatives.jl` is a registered Julia package and [as such you can install it](https://julialang.github.io/Pkg.jl/v1/managing-packages/) by activating the `pkg` mode (type `]`, and to leave it, type `<backspace>`),
followed by

```julia
pkg> add FinancialDerivatives
```

## 📓 Usage
To price a European option, create an `EuropeanOption` and an `EquityMarketData`, and pass them to `price` with the engine and the model:

```julia
julia> eu_put = EuropeanOption(90.0, 180 / 365, false)
EuropeanOption{Float64, Float64}(90.0, 0.4931506849315068, false)

julia> eu_md = EquityMarketData(; spot_price=100.0, risk_free_rate=0.05, dividend_yield=0.01, volatility=0.3)
EquityMarketData{Float64, Float64, Float64, Float64}(100.0, 0.05, 0.01, 0.3)

julia> price(AnalyticEngine(), eu_put, BlackScholes(), eu_md) 
3.345574972744167
```

[dev-img]: https://img.shields.io/badge/docs-stable-blue.svg
[dev-url]: https://JuliaQuant.github.io/FinancialDerivatives.jl/dev/
[ci-img]: https://github.com/JuliaQuant/FinancialDerivatives.jl/actions/workflows/CI.yml/badge.svg?branch=master
[ci-url]: https://github.com/JuliaQuant/FinancialDerivatives.jl/actions/workflows/CI.yml?query=branch%3Amaster
[cov-img]: https://codecov.io/gh/JuliaQuant/FinancialDerivatives.jl/branch/master/graph/badge.svg
[cov-url]: https://codecov.io/gh/JuliaQuant/FinancialDerivatives.jl
[lic-img]: https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000
[lic-url]: https://github.com/mvanzulli/FinancialDerivatives.jl/blob/master/LICENSE
