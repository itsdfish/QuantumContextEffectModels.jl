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




# parms = (
#     Ψ = sqrt.([.3,.1,.2,.4]),
#     θli = .3,
#     θpb = .3,
# )
# θlis = range(-1, 1, length=51)
# θpbs = range(-1, 1, length=51)
# preds = [
#             predict(
#                 QuantumModel(; parms..., θli, θpb); 
#                 joint_func = get_joint_probs,
#                 n_way = 2
#             )
#             for θli ∈ θlis for θpb ∈ θpbs]

# preds = map(p -> p[5], preds)

# preds = stack(preds)'
# p1 = plot(θlis[1:500], preds[1:500,:], leg=false, title="first half [-1,0)")
# p2 = plot(θlis[1:500], preds[501:end-1,:], leg=false, title="second half [0,1)")
# plot(p1, p2, layout=(2,1))