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

preds1 = [
    [0.29999999999999993 0.1; 0.19999999999999998 0.4],
    [2.2496396739927864e-33 0.3999999999999999; 0.6000000000000001 1.4997597826618576e-33],
    [0.06617387872822834 0.33382612127177164; 9.889577692232744e-5 0.5999011042230776],
    [0.20000000000000004 0.29999999999999993; 0.4 0.09999999999999996],
    [0.043376094045810484 0.3225948223531861; 0.02289668045934019 0.6111324031416632],
    [9.889577692232687e-5 0.5999011042230777; 0.06617387872822836 0.3338261212717716],
]


projectors = make_projectors(model)

x = [[:a1,:a2,:a3],[:b1,:b2],[:c1,:c2],[:d1,:d2]]
combs = combinations(x, 2) |> collect 

variables = [
    :believable,
    :informative,
    :persuasive,
    :likeable
]
combs = combinations(variables, 2) |> collect


x = [[1 1; 2 4], [2 4; 8 2]]

prod(x)