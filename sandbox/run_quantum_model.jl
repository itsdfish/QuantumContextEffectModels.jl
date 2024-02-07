cd(@__DIR__)
using Pkg 
Pkg.activate("..")
using Revise
using QuantumContextEffectModels

parms = (
    Ψ = sqrt.([.3,.1,.2,.4]),
    θli = .3,
    θpb = .3,
)

model = QuantumModel(; parms...)
preds = predict(
    model; 
    joint_func = get_joint_probs,
    n_way = 2
)

data = rand(model, 100; n_way=2)
logpdf(model, data, 100; n_way=2)


var_names = [
    :B,
    :I,
    :P,
    :L
]
values = fill([:yes,:no], 4)
n_way = 2

df = to_tables(preds, var_names, values, n_way)
