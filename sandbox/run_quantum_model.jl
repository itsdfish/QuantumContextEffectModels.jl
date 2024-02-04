cd(@__DIR__)
using Pkg 
Pkg.activate("..")
using Revise
using QuantumContextEffectModels

parms = (
    Ψ = sqrt.([.3,.1,.2,.4]),
    θli = .7,
    θpb = .8,
)

model = QuantumModel(; parms...)
preds = predict(model; n_way=2)

sum.(preds)

var_names = [
    :B,
    :I,
    :P,
    :L
]
values = fill([:yes,:no], 4)



show_structure(var_names, values, 2)

function to_dataframe(var_names, values, data, n_way)
    df = DataFrame(
        group = Int[],
        variables = String[],
        values = String[],
        probs = Float64[],
    )
    var_combs = combinations(var_names, n_way)
    val_combs = combinations(values, n_way)
    vals_combs = map(c -> collect(Base.product(c...))[:], val_combs)
    cnt = 0
    group_idx = 0
    for (vars,vals) ∈ zip(var_combs, vals_combs)
        group_idx += 1
        val_idx = 0
        for vals1 ∈ vals
            val_idx += 1
            order_idx = 0
            for (vi,_v) ∈ zip(permutations(vars), permutations(vals1))
                order_idx += 1
                strvi = mapreduce(x -> string(x), *, vi)
                str_v = mapreduce(x -> string(x), *, _v)
                push!(df, [group_idx strvi str_v data[group_idx][order_idx][val_idx]])
            end
        end
    end
    sort!(df,[:group,:variables])
    return df
end