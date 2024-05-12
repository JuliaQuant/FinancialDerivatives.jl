using Documenter
using FinancialDerivatives

DocMeta.setdocmeta!(FinancialDerivatives, :DocTestSetup, :(using FinancialDerivatives);
                    recursive=true)

makedocs(; sitename="FinancialDerivatives.jl",
         clean=true, doctest=false, linkcheck=false,
         format=Documenter.HTML(;
                                prettyurls=get(ENV, "CI", "false") == "true",
                                canonical="https://JuliaQuant.github.io/FinancialDerivatives.jl",
                                edit_link="main",
                                assets=String[]),
         pages=["index.md",
                "getting_started.md",
                "api.md"])

deploydocs(; repo="github.com/JuliaQuant/FinancialDerivatives.jl.git", push_preview=true)
