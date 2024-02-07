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
using QuantumContextEffectModels
n_way = 2
parms = (
    Ψ = sqrt.([.3,.1,.2,.4]),
    θli = .3,
    θpb = .3,
)

model = QuantumModel(; parms...)
preds = predict(model; n_way)

var_names = [
    :B,
    :I,
    :P,
    :L
]
values = fill([:yes,:no], 4)

df = to_tables(preds, var_names, values, n_way)
```

# Simulate Model

The code block below demonstrates how to generate simulated data from the model using `rand`. In the example, we will generate 100 simulated trials for each condition. 
```@example 
using QuantumContextEffectModels
```

# Evaluate Log Likelihood

The log likelihood of data can be evaluated using `logpdf`. In the code block below, we generate simulated data and evaluate the logpdf: 
```@example 
using QuantumContextEffectModels
```