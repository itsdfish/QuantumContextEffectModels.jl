cd(@__DIR__)
using Pkg 
Pkg.activate("..")
using Revise
using QuantumContextEffectModels

parms = (
    Ψ = sqrt.([.3,.1,.2,.4]),
    θli = -.2,
    θpb = .5,
)

model = QuantumModel(; parms...)
preds = predict(model)

sum.(preds)