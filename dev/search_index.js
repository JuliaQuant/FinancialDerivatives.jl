var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "FinancialDerivatives Overview",
    "title": "FinancialDerivatives Overview",
    "category": "page",
    "text": ""
},

{
    "location": "#FinancialDerivatives-Overview-1",
    "page": "FinancialDerivatives Overview",
    "title": "FinancialDerivatives Overview",
    "category": "section",
    "text": "The FinancialDerivatives package provides convenient models for pricing financial derivatives in Julia."
},

{
    "location": "#Contents-1",
    "page": "FinancialDerivatives Overview",
    "title": "Contents",
    "category": "section",
    "text": "Pages = [\n  \"getting_started.md\"\n]"
},

{
    "location": "getting_started/#",
    "page": "Getting Started",
    "title": "Getting Started",
    "category": "page",
    "text": ""
},

{
    "location": "getting_started/#Getting-Started-1",
    "page": "Getting Started",
    "title": "Getting Started",
    "category": "section",
    "text": "FinancialDerivatives is a unregistered package for the moment. To add it to your Julia packages, simply do the following in REPL:(v1.0) pkg> add https://github.com/brilhana/FinancialDerivatives.jlTo price an American option, simply create a new AmericanOption and pass it to evaluate with the desired valuation model:julia> using FinancialDerivatives\n\njulia> american_put = AmericanOption(100.0, 90.0, 0.05, 0.3, 180/365, -1)\n\njulia> evaluate(american_put, BlackScholes())\n3.2281936525908073"
},

]}
