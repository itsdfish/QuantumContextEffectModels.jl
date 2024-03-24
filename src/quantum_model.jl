"""
    QuantumModel{T<:Real} <: AbstractQuantumModel

# Fields 

- `Ψ::Vector{T}`: initial state vector 
- `θil::T`: parameter for rotating basis from `informative` to `likable`. `θil ∈ [-1,1]`
- `θpb::T`:  parameter for rotating basis from `believable` to `persuasive`. `θpb ∈ [-1,1]`

# Constructors 

    QuantumModel( Ψ, θil, θpb)
    
    QuantumModel(; Ψ, θil, θpb)

# Reference

Busemeyer, J. R., & Wang, Z. (2018). Hilbert space multidimensional theory. Psychological Review, 125(4), 572.
"""
mutable struct QuantumModel{T <: Real} <: AbstractQuantumModel{T}
    Ψ::Vector{T}
    θil::T
    θpb::T
end

function QuantumModel(; Ψ, θil, θpb)
    _, θil, θpb = promote(Ψ[1], θil, θpb)
    Ψ = convert(Vector{typeof(θpb)}, Ψ)
    return QuantumModel(Ψ, θil, θpb)
end

"""
    make_projectors(model::QuantumModel)

Returns projectors for each value of each variable. 

# Arguments

- `model::AbstractQuantumModel`:an abstract quantum model object

# Returns 

- `projectors::Vector{Vector{Float64}}`: a nested vector of projectors 

For this model, there are four variables corresponding to believable, infromative, persuasive, and likable
which have binary values (e.g., yes, no). The projectors organized as follows `[[Pby Pbn],[Piy Pin],[Ppy Ppn],[Ply Pln]]`, where the first index corresponds
to the variable and the second index correspons to the binary value. For example, `Pbn`,
is the projector for responding "no" to the question about believable. 
"""
function make_projectors(model::QuantumModel)
    (; θil, θpb) = model

    # 2D projector for responding "yes"
    My = [1 0; 0 0]
    # unitary transformation matrices
    Upb = 𝕦(θpb)
    Uil = 𝕦(θil)

    # projector for responding "yes" to believable
    Pb = My ⊗ I(2)
    # projector for responding "yes" to informative
    Pi = I(2) ⊗ My
    # projector for responding "yes" to persuasive    
    Pp = (Upb * My * Upb') ⊗ I(2)
    # projector for responding "yes" to likable    
    Pl = I(2) ⊗ (Uil * My * Uil')

    projectors = [
        [Pb, I(4) - Pb],
        [Pi, I(4) - Pi],
        [Pp, I(4) - Pp],
        [Pl, I(4) - Pl]
    ]
    return projectors
end
