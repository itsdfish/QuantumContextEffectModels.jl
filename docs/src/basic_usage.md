# Overview

This page provides an overview of the API along with examples. 

# Make Predictions

The quantum order effect model (QOEM) generates predictions for six conditions:

## Order 1
1. Pr(disease)
2. Pr(disease | lab test)
3. Pr(disease | lab test, medical history)

## Order 2
4. Pr(disease)
5. Pr(disease | medical history)
6. Pr(disease | medical history, lab test)

```@example 
using QuantumOrderEffectModels
Ψ = @. √([.35,.35,.15,.15])
γₕ = 2
γₗ = .5
σ = .05
model = QOEM(;Ψ, γₕ, γₗ, σ)
predict(model)
```

# Simulate Model

The code block below demonstrates how to generate simulated data from the model using `rand`. In the example, we will generate 100 simulated trials for each condition. 
```@example 
using QuantumOrderEffectModels
Ψ = @. √([.35,.35,.15,.15])
γₕ = 2
γₗ = .5
σ = .05
n_trials = 100
model = QOEM(;Ψ, γₕ, γₗ, σ)
data = rand(model, n_trials)
```

# Evaluate Log Likelihood

The log likelihood of data can be evaluated using `logpdf`. In the code block below, we generate simulated data and evaluate the logpdf: 
```@example 
using QuantumOrderEffectModels
Ψ = @. √([.35,.35,.15,.15])
γₕ = 2
γₗ = .5
σ = .05
n_trials = 100
model = QOEM(;Ψ, γₕ, γₗ, σ)
data = rand(model, n_trials)
logpdf(model, data)
```