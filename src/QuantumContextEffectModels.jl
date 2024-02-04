module QuantumContextEffectModels

    using Combinatorics: combinations
    using Combinatorics: permutations
    using Distributions: Multinomial
    using LinearAlgebra
    using PrettyTables

    import Distributions: logpdf 
    import Distributions: rand

    export AbstractQuantumModel
    export QuantumModel
    export make_projectors
    export predict  
    export show_structure

    include("structs.jl")
    include("functions.jl")
    include("utilities.jl")
end
