using Documenter
using FinancialDerivatives

makedocs(
    format = :html,
    sitename = "FinancialDerivatives.jl",
    pages = [
        "index.md",
        "getting_started.md"
    ]
)

deploydocs(
    repo = "github.com/brilhana/FinancialDerivatives.jl.git", # eventually "github.com/JuliaQuant/FinancialDerivatives.jl.git"
    julia  = "1.0",
    latest = "master",
    target = "build",
    deps = nothing,
    make = nothing
)