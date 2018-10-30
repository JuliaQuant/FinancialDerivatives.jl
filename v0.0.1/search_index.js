var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "FinancialDerivatives Overview",
    "title": "FinancialDerivatives Overview",
    "category": "page",
    "text": ""
},

{
    "location": "#FinancialDerivatives",
    "page": "FinancialDerivatives Overview",
    "title": "FinancialDerivatives",
    "category": "module",
    "text": "The FinancialDerivatives module provides convenient models for pricing financial derivatives in Julia.\n\n\n\n\n\n"
},

{
    "location": "#FinancialDerivatives-Overview-1",
    "page": "FinancialDerivatives Overview",
    "title": "FinancialDerivatives Overview",
    "category": "section",
    "text": "FinancialDerivatives"
},

{
    "location": "#Contents-1",
    "page": "FinancialDerivatives Overview",
    "title": "Contents",
    "category": "section",
    "text": "Pages = [\n  \"getting_started.md\",\n  \"api.md\"\n]"
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
    "text": ""
},

{
    "location": "getting_started/#Installation-1",
    "page": "Getting Started",
    "title": "Installation",
    "category": "section",
    "text": "FinancialDerivatives is a unregistered package for the moment. To add it to your Julia packages, simply do the following in REPL:(v1.0) pkg> add https://github.com/JuliaQuant/FinancialDerivatives.jl"
},

{
    "location": "getting_started/#Usage-1",
    "page": "Getting Started",
    "title": "Usage",
    "category": "section",
    "text": "To price an European option, simply create a new EuropeanOption and pass it to evaluate with the desired valuation model:julia> using FinancialDerivatives\n\njulia> euro_put = EuropeanOption(100.0, 90.0, 0.05, 0.3, 180/365, -1)\n\njulia> evaluate(euro_put, BlackScholes())\n3.2281936525908073"
},

{
    "location": "api/#",
    "page": "API",
    "title": "API",
    "category": "page",
    "text": ""
},

{
    "location": "api/#API-1",
    "page": "API",
    "title": "API",
    "category": "section",
    "text": ""
},

{
    "location": "api/#FinancialDerivatives.AmericanOption",
    "page": "API",
    "title": "FinancialDerivatives.AmericanOption",
    "category": "type",
    "text": "AmericanOption(s, k, r, σ, t, call)\n\nAmerican option.\n\nArguments\n\ns: underlying price\nk: strike price\nr: risk-free interest rate\nσ: volatility\nt: time to expiration\ncall: 1 if call, -1 if put\n\n\n\n\n\n"
},

{
    "location": "api/#FinancialDerivatives.AsianOption",
    "page": "API",
    "title": "FinancialDerivatives.AsianOption",
    "category": "type",
    "text": "AsianOption(s, k, r, σ, t, call)\n\nAsian option.\n\nArguments\n\ns: underlying price\nk: strike price\nr: risk-free interest rate\nσ: volatility\nt: time to expiration\ncall: 1 if call, -1 if put\n\n\n\n\n\n"
},

{
    "location": "api/#FinancialDerivatives.EuropeanOption",
    "page": "API",
    "title": "FinancialDerivatives.EuropeanOption",
    "category": "type",
    "text": "EuropeanOption(s, k, r, σ, t, call)\n\nEuropean option.\n\nArguments\n\ns: underlying price\nk: strike price\nr: risk-free interest rate\nσ: volatility\nt: time to expiration\ncall: 1 if call, -1 if put\n\n\n\n\n\n"
},

{
    "location": "api/#FinancialDerivatives.FXOption",
    "page": "API",
    "title": "FinancialDerivatives.FXOption",
    "category": "type",
    "text": "FXOption(s, k, r_d, r_f, σ, t, call)\n\nForeign exchange option.\n\nArguments\n\ns: underlying price\nk: strike price\nr_d: domestic risk-free interest rate\nr_f: foreign risk-free interest rate\nσ: volatility\nt: time to expiration\ncall: 1 if call, -1 if put\n\n\n\n\n\n"
},

{
    "location": "api/#FinancialDerivatives.InterestRateDerivative",
    "page": "API",
    "title": "FinancialDerivatives.InterestRateDerivative",
    "category": "type",
    "text": "InterestRateDerivative(k, r, σ, θ, t)\n\nInterest rate derivative.\n\nArguments\n\nk: speed of reversion\nr: initial interest rate\nσ: instantaneous volatility\nθ: long term mean level\nt: time interval\n\n\n\n\n\n"
},

{
    "location": "api/#Derivatives-1",
    "page": "API",
    "title": "Derivatives",
    "category": "section",
    "text": "AmericanOption\nAsianOption\nEuropeanOption\nFXOption\nInterestRateDerivative"
},

{
    "location": "api/#FinancialDerivatives.BlackKarasinski",
    "page": "API",
    "title": "FinancialDerivatives.BlackKarasinski",
    "category": "type",
    "text": "BlackKarasinski()\n\nBlack-Karasinski model.\n\n\n\n\n\n"
},

{
    "location": "api/#FinancialDerivatives.BlackScholes",
    "page": "API",
    "title": "FinancialDerivatives.BlackScholes",
    "category": "type",
    "text": "BlackScholes()\n\nBlack-Scholes model.\n\n\n\n\n\n"
},

{
    "location": "api/#FinancialDerivatives.BrennanSchwartz",
    "page": "API",
    "title": "FinancialDerivatives.BrennanSchwartz",
    "category": "type",
    "text": "BrennanSchwartz()\n\nBrennan and Schwartz model.\n\n\n\n\n\n"
},

{
    "location": "api/#FinancialDerivatives.CoxIngersollRoss",
    "page": "API",
    "title": "FinancialDerivatives.CoxIngersollRoss",
    "category": "type",
    "text": "CoxIngersollRoss()\n\nCox-Ingersoll-Ross model.\n\n\n\n\n\n"
},

{
    "location": "api/#FinancialDerivatives.CoxRossRubinstein",
    "page": "API",
    "title": "FinancialDerivatives.CoxRossRubinstein",
    "category": "type",
    "text": "CoxRossRubinstein()\n\nCox-Ross-Rubinstein binomial model (aka Binomial options pricing model).\n\n\n\n\n\n"
},

{
    "location": "api/#FinancialDerivatives.GarmanKohlhagen",
    "page": "API",
    "title": "FinancialDerivatives.GarmanKohlhagen",
    "category": "type",
    "text": "GarmanKohlhagen()\n\nGarman–Kohlhagen model.\n\n\n\n\n\n"
},

{
    "location": "api/#FinancialDerivatives.JarrowRudd",
    "page": "API",
    "title": "FinancialDerivatives.JarrowRudd",
    "category": "type",
    "text": "JarrowRudd()\n\nJarrow-Rudd model.\n\n\n\n\n\n"
},

{
    "location": "api/#FinancialDerivatives.LeisenReimer",
    "page": "API",
    "title": "FinancialDerivatives.LeisenReimer",
    "category": "type",
    "text": "LeisenReimer()\n\nLeisen-Reimer binomial model.\n\n\n\n\n\n"
},

{
    "location": "api/#FinancialDerivatives.LongstaffSchwartz",
    "page": "API",
    "title": "FinancialDerivatives.LongstaffSchwartz",
    "category": "type",
    "text": "LongstaffSchwartz()\n\nLongstaff-Schwartz model.\n\n\n\n\n\n"
},

{
    "location": "api/#FinancialDerivatives.RendlemanBartter",
    "page": "API",
    "title": "FinancialDerivatives.RendlemanBartter",
    "category": "type",
    "text": "RendlemanBartter()\n\nRendleman-Bartter model.\n\n\n\n\n\n"
},

{
    "location": "api/#FinancialDerivatives.Tian",
    "page": "API",
    "title": "FinancialDerivatives.Tian",
    "category": "type",
    "text": "Tian()\n\nTian binomial model.\n\n\n\n\n\n"
},

{
    "location": "api/#FinancialDerivatives.Vasicek",
    "page": "API",
    "title": "FinancialDerivatives.Vasicek",
    "category": "type",
    "text": "Vasicek()\n\nVasicek model.\n\n\n\n\n\n"
},

{
    "location": "api/#Models-1",
    "page": "API",
    "title": "Models",
    "category": "section",
    "text": "BlackKarasinski\nBlackScholes\nBrennanSchwartz\nCoxIngersollRoss\nCoxRossRubinstein\nGarmanKohlhagen\nJarrowRudd\nLeisenReimer\nLongstaffSchwartz\nRendlemanBartter\nTian\nVasicek"
},

{
    "location": "api/#FinancialDerivatives.evaluate",
    "page": "API",
    "title": "FinancialDerivatives.evaluate",
    "category": "function",
    "text": "evaluate(IRD, BlackKarasinski(), n = 12)\n\nEvaluate interest rate derivative using BlackKarasinski model.\n\nArguments\n\nIRD::InterestRateDerivative: interest rate derivative\nn: number of paths to simulate\n\n\n\n\n\nevaluate(O, BlackScholes())\n\nEvaluate option O using BlackScholes model.\n\nArguments\n\nO::Option: Option\n\n\n\n\n\nevaluate(o)\n\nEvaluate option o using Back-Scholes model as default valuation model.\n\n\n\n\n\nevaluate(IRD, BrennanSchwartz(), n = 12)\n\nEvaluate interest rate derivative IRD using BrennanSchwartz model.\n\nArguments\n\nIRD::InterestRateDerivative: interest rate derivative\nn: number of paths to simulate\n\n\n\n\n\nevaluate(IRD, CoxIngersollRoss(), n)\n\nEvaluate interest rate derivative IRD using CoxIngersollRoss model.\n\nArguments\n\nIRD::InterestRateDerivative: interest rate derivative\nn: number of paths to simulate\n\n\n\n\n\nevaluate(O, CoxRossRubinstein(), N = 1000)\n\nEvaluate option O using CoxRossRubinstein.\n\nArguments\n\nO::Option: option\nN: number of paths to simulate\n\n\n\n\n\nevaluate(O::FXOption, GarmanKohlhagen())\n\nEvaluate FX Option using GarmanKohlhagen model.\n\nArguments\n\nO::FXOption\n\n\n\n\n\nevaluate(O, JarrowRudd(), risk_neutral = true, N = 1000)\n\nEvaluate option O using JarrowRudd binomial model (defaults to the risk-neutral version).\n\nArguments\n\nO::Option: option\nrisk_neutral: true if risk neutral, false if equal probability.\nN: number of paths to simulate\n\n\n\n\n\nevaluate(O, LeisenReimer(), N = 1001)\n\nEvaluate option O using LeisenReimer binomial model.\n\nArguments\n\nN: number of paths to simulate, must be odd\n\n\n\n\n\nevaluate(O, LongstaffSchwartz(), N = 1000, P = 10000)\n\nEvaluate option O using LongstaffSchwartz binomial model.\n\nArguments\n\nN: number of paths to simulate\nP: number of periods\n\n\n\n\n\nevaluate(IRD, RendlemanBartter(), n = 12)\n\nEvaluate interest rate derivative IRD using RendlemanBartter model.\n\nArguments\n\nn: number of paths to simulate\n\n\n\n\n\nevaluate(O, RendlemanBartter(), k = 1, N = 1000)\n\nEvaluate option O using RendlemanBartter model.\n\nArguments\n\nk:\nN: \n\n\n\n\n\nevaluate(O, Tian(), N = 1000)\n\nEvaluate option O using Tian binomial model.\n\nArguments\n\nN: number of paths to simulate\n\n\n\n\n\nevaluate(IRD, Vasicek(), n = 12)\n\nEvaluate interest rate derivative IRD using Vasicek model.\n\nArguments\n\nn: number of paths to simulate\n\n\n\n\n\n"
},

{
    "location": "api/#Evaluation-1",
    "page": "API",
    "title": "Evaluation",
    "category": "section",
    "text": "evaluate"
},

{
    "location": "api/#FinancialDerivatives.Derivative",
    "page": "API",
    "title": "FinancialDerivatives.Derivative",
    "category": "type",
    "text": "Abstract type for derivative contract.\n\n\n\n\n\n"
},

{
    "location": "api/#FinancialDerivatives.Forward",
    "page": "API",
    "title": "FinancialDerivatives.Forward",
    "category": "type",
    "text": "Abstract type for forward contract.\n\n\n\n\n\n"
},

{
    "location": "api/#FinancialDerivatives.Future",
    "page": "API",
    "title": "FinancialDerivatives.Future",
    "category": "type",
    "text": "Abstract type for futures contract.\n\n\n\n\n\n"
},

{
    "location": "api/#FinancialDerivatives.Option",
    "page": "API",
    "title": "FinancialDerivatives.Option",
    "category": "type",
    "text": "Abstract type for option.\n\n\n\n\n\n"
},

{
    "location": "api/#FinancialDerivatives.Swap",
    "page": "API",
    "title": "FinancialDerivatives.Swap",
    "category": "type",
    "text": "Abstract type for swap.\n\n\n\n\n\n"
},

{
    "location": "api/#FinancialDerivatives.Swaption",
    "page": "API",
    "title": "FinancialDerivatives.Swaption",
    "category": "type",
    "text": "Abstract type for swaption.\n\n\n\n\n\n"
},

{
    "location": "api/#Private-1",
    "page": "API",
    "title": "Private",
    "category": "section",
    "text": "FinancialDerivatives.Derivative\nFinancialDerivatives.Forward\nFinancialDerivatives.Future\nFinancialDerivatives.Option\nFinancialDerivatives.Swap\nFinancialDerivatives.Swaption"
},

]}
