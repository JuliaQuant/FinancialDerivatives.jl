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
    repo = "github.com/JuliaQuant/FinancialDerivatives.jl.git"
)
