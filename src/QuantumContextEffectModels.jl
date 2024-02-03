module QuantumContextEffectModels

    using Combinatorics: combinations
    using Distributions: Multinomial
    using LinearAlgebra

    import Distributions: logpdf 
    import Distributions: rand

    export AbstractQuantumModel
    export QuantumModel
    export make_projectors
    export predict  

    include("structs.jl")
    include("functions.jl")
end
