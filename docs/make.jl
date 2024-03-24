using Documenter
using QuantumContextEffectModels

makedocs(
    warnonly = true,
    sitename = "QuantumContextEffectModels",
    format = Documenter.HTML(
        assets = [
            asset(
            "https://fonts.googleapis.com/css?family=Montserrat|Source+Code+Pro&display=swap",
            class = :css
        )
        ],
        collapselevel = 1
    ),
    modules = [
        QuantumContextEffectModels
    # Base.get_extension(SequentialSamplingModels, :TuringExt),  
    # Base.get_extension(SequentialSamplingModels, :PlotsExt) 
    ],
    pages = [
        "Home" => "index.md",
        "Basic Usage" => "basic_usage.md",
        "Developing a Model" => "developing_a_model.md",
        "Model Description" => "model_description.md",
        "Parameter Estimation" => "parameter_estimation.md",
        "API" => "api.md"
    ]
)

deploydocs(
    repo = "github.com/itsdfish/QuantumContextEffectModels.jl.git",
)
