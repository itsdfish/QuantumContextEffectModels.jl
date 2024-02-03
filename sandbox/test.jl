###############################################################################################################
#                                           load dependencies
###############################################################################################################
cd(@__DIR__)
using Pkg 
Pkg.activate("..")
using Revise
using QuantumContextEffectModels
using DataFrames
using Distributions 
using LinearAlgebra
using Plots 
include("functions.jl")

columns = [:A,:B,:C,:D]
n = 100 

Θ = rand(16)
Θ ./= sum(Θ)

contexts = [[:A,:B],[:A,:C],[:B,:C]]

x = map(_ -> let 
        data = simulate(Θ, columns, contexts, n)
        Χ² = compute_chi_square(Θ, data, columns, contexts, n)
    end,
    1:10000)

xs = range(0, 30, length=200)
dens = pdf.(Chisq(9), xs)

histogram(x, norm=true)
plot!(xs, dens)

using Optim
function objective(Θ, data, columns, contexts, n)
    any(x -> x < 0, Θ) ? (return Inf) : nothing
    Θ = copy(Θ)
    push!(Θ, 1.0)
    Θ ./= sum(Θ)
    return -compute_log_like(Θ, data, columns, contexts, n)
end

columns = [:A,:B,:C]
n = 1000 
Θ = range(.1, 1, length=8) |> collect
Θ ./= sum(Θ)
data = simulate(Θ, columns, contexts, n)

x0 = rand(7)
f = wrapper(data, columns, contexts, n)
@time result = optimize(
    x -> objective(x, data, columns, contexts, n), x0,
    NelderMead(),
    #ParticleSwarm(n_particles=10),
)
best = Optim.minimizer(result)
push!(best, 1)
best ./= sum(best)
[best Θ]
Optim.minimum(result)