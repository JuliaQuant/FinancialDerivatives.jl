# FinancialDerivatives.jl

| **Documentation** |**Status** |**License** | 
|:-----------------:|:----------------------------:|:-----------:|
| [![docs-dev][dev-img]][dev-url] | [![CI][ci-img]][ci-url] [![codecov][cov-img]][cov-url] |  [![license][lic-img]][lic-url] |


---
## 💾 [Installing](https://julialang.github.io/Pkg.jl/v1/managing-packages/)

`FinancialDerivatives.jl` is a registered Julia package and [as such you can install it](https://julialang.github.io/Pkg.jl/v1/managing-packages/) by activating the `pkg` mode (type `]`, and to leave it, type `<backspace>`),
followed by

```julia
pkg> add FinancialDerivatives
```

## 📓 Usage
To price an European option, simply create a new `EuropeanOption` and pass it to `evaluate` with the desired valuation model:

```julia
julia> using FinancialDerivatives

julia> euro_put = EuropeanOption(s=100.0, k=90.0, r=0.05, q=0.0, σ=0.3, t=180 / 365, call=false)

julia> evaluate(euro_put, BlackScholes())
3.2281936525908073
```

[dev-img]: https://img.shields.io/badge/docs-stable-blue.svg
[dev-url]: https://JuliaQunat.github.io/FinancialDerivatives.jl/dev/
[ci-img]: https://github.com/JuliaQuant/FinancialDerivatives.jl/actions/workflows/CI.yml/badge.svg?branch=main
[ci-url]: https://github.com/JuliaQuant/FinancialDerivatives.jl/actions/workflows/CI.yml?query=branch%3Amain
[cov-img]: https://codecov.io/gh/JuliaQuant/FinancialDerivatives.jl/branch/main/graph/badge.svg
[cov-url]: https://codecov.io/gh/JuliaQuant/FinancialDerivatives.jl
[doi-img]: https://zenodo.org/badge/170120732.svg
[doi-url]: https://zenodo.org/badge/latestdoi/
[lic-img]: https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000
[lic-url]: https://github.com/mvanzulli/FinancialDerivatives.jl/blob/main/LICENSE
[com-url]: https://app.slack.com/client/T04QWNG5T2Q/C04R6TMDV0R
[com-img]: https://user-images.githubusercontent.com/50339940/224228295-4ff7c201-975f-4e87-af51-86036a10f289.svg



