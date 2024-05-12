using Documenter
using FinancialDerivatives

makedocs(; format=:html,
         sitename="FinancialDerivatives.jl",
         clean=true, doctest=false, linkcheck=true,
         pages=["index.md",
                "getting_started.md",
                "api.md"])

deploydocs(; repo="github.com/JuliaQuant/FinancialDerivatives.jl.git", push_preview=true)
