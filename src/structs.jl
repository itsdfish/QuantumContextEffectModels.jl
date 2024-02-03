abstract type AbstractQuantumModel end 

mutable struct QuantumModel{T<:Real} <: AbstractQuantumModel
    Ψ::Vector{T}
    θli::T 
    θpb::T 
end

function QuantumModel(;Ψ, θli, θpb)
    _,θli,θpb = promote(Ψ[1], θli, θpb)
    Ψ = convert(Vector{typeof(θpb)}, Ψ)
    return QuantumModel(Ψ, θli, θpb)
end