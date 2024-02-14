####################################################################################
#                                    load packages 
####################################################################################
cd(@__DIR__)
using Pkg 
Pkg.activate("../../docs")
using Revise
using Pigeons
using Plots 
using Random
using Turing 
using QuantumContextEffectModels
####################################################################################
#                                    generate data
####################################################################################
Random.seed!(84)
n_trials = 25
n_way = 2
parms = (
    Ψ = sqrt.([.7,.1,.1,.1]),
    θil = .6,
    θpb = .3,
)
model = QuantumModel(; parms...)
data = rand(model, n_trials; n_way)
####################################################################################
#                             define Turing model
####################################################################################
@model function turing_model(data, parms, n_trials; n_way)
    θil ~ Uniform(0, 1)
    θpb ~ Uniform(0, 1)
    model = QuantumModel(; parms..., θil, θpb)
    Turing.@addlogprob! logpdf(model, data, n_trials; n_way)
end

sampler = turing_model(data, parms, n_trials; n_way)
####################################################################################
#                             Pigeons
####################################################################################
pt = pigeons(
    target=TuringLogPotential(sampler), 
    record=[traces,index_process],
    multithreaded=true)
samples = Chains(sample_array(pt), ["θil", "θbp", "LL"])
plot(samples)
# index plot 
plot(pt.reduced_recorders.index_process)
# local barrier
plot(pt.shared.tempering.communication_barriers.localbarrier)
####################################################################################
#                             Turing
####################################################################################
chain = sample(sampler, NUTS(1000, .85), MCMCThreads(), 1000, 4)
plot(chain)
####################################################################################
#                         marginal likelihood surface
####################################################################################
θils = range(-.99, .99, length=10_000)
LLs = map(θil -> logpdf(QuantumModel(; parms..., θil), data, n_trials; n_way=2), θils)
_,idx = findmax(LLs)
plot(θils, LLs)