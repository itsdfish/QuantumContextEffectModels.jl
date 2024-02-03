module QuantumContextEffectModels

    using Distributions: Multinomial
    using LinearAlgebra

    import Distributions: logpdf 
    import Distributions: rand

    export AbstractQuantumModel
    export QuantumModel
    export predict  

    include("structs.jl")
    include("functions.jl")
end
