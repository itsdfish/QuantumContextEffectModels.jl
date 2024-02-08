"""
    QuantumModel{T<:Real} <: AbstractQuantumModel

# Fields 

- `Ψ::Vector{T}`: initial state vector 
- `θli::T`: parameter for rotating basis from `likable` to `informative`. `θli ∈ [-1,1]`
- `θpb::T`:  parameter for rotating basis from `persuasive` to `believable`. `θli ∈ [-1,1]`

# Reference

Busemeyer, J. R., & Wang, Z. (2018). Hilbert space multidimensional theory. Psychological Review, 125(4), 572.
"""
mutable struct QuantumModel{T<:Real} <: AbstractQuantumModel{T}
    Ψ::Vector{T}
    θli::T 
    θpb::T 
end

function QuantumModel(; Ψ, θli, θpb)
    _,θli,θpb = promote(Ψ[1], θli, θpb)
    Ψ = convert(Vector{typeof(θpb)}, Ψ)
    return QuantumModel(Ψ, θli, θpb)
end

"""
    make_projectors(model::QuantumModel)

Returns projectors for each value of each variable. 

# Arguments

- `model::AbstractQuantumModel`:an abstract quantum model object

# Returns 

- `projectors::Vector{Vector{Float64}}`: a nested vector of projectors 

For this model, there are four variables (believable,infromative,persuasive,likable) with binary values (yes, no).
The projectors organized as follows `[[Pby Pbn],[Piy Pin],[Ppy Ppn],[Ply Pln]]`, where the first index corresponds
to the variable and the second index correspons to the binary value. For example, `Pbn`,
is the projector for responding "no" to the question about believable. 
"""
function make_projectors(model::QuantumModel)
    (;θli, θpb) = model

    # 2D projector for responding "yes"
    My = [1 0; 0 0]
    # unitary transformation matrices
    Upb = U(θpb)
    Uli = U(θli)

    # projector for responding "yes" to believable
    Pb = My ⊗ I(2)
    # projector for responding "yes" to informative
    Pi = I(2) ⊗ My
    # projector for responding "yes" to persuasive    
    Pp = (Upb * My * Upb') ⊗ I(2)
    # projector for responding "yes" to likable    
    Pl = I(2) ⊗ (Uli * My * Uli')
    
    projectors = [
        [Pb,I(4)-Pb],
        [Pi,I(4)-Pi],
        [Pp,I(4)-Pp],
        [Pl,I(4)-Pl],
    ]
    return projectors
end