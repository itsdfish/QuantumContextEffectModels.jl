# Overview

The purpose of this page is to demonstrate basic usage of the API. The following examples will be based on the context efect model described in Busemeyer & Wang (2018). A brief description of the model can be found [here](developing_a_model.md) and a more detailed description can be found [here](model_description.md).

## Make Predictions

The function `predict` will generate all possible joint probability tables of a dimensionality specified by `n_way`. 

### Two-way Tables 

The code block below demonstrates how to generate predictions for 2-way joint probability tables. Each table is of size $2 \times 2$ because each attribute is binary. Given four attributes and `n_way=2`, there are $P(4,2) = 12$ joint probability tables in total (including the order of attributes within a pair). 

```@example basic_usage
using QuantumContextEffectModels
n_way = 2
parms = (
    Ψ = sqrt.([.3,.1,.2,.4]),
    θli = .3,
    θpb = .3,
)

model = QuantumModel(; parms...)
preds = predict(model; n_way)
```

The nested vector `preds` contains $C(4,2) = 6$ combinations of attributes (ignoring order). As shown below, each sub-vector contains a flattened joint probability table, one for each order. 

```@example basic_usage
preds[1]
```

### Three-way Tables 

The code block below shows how to create all possible joint probability tables of dimensionality 3 by
changing `n_way=2` to `n_way=3`. In this example,there are $P(4,3) = 24$ joint probability tables (6 orders for each unique set of 3 attributes). 

```@example basic_usage
preds = predict(model; n_way = 3)
```
In general, if there are $n_a$ attributes, the function `predict` can generate tables of dimensionality
$[1,2,\dots, n_a]$.

### Single Order

As shown below, you can assign the function `get_joint_probs` to the keyword `joint_func` to omit
the orders of joint probability tables (e.g., [A,B] instead of [A,B], [B,A]). 

```@example basic_usage
using QuantumContextEffectModels
n_way = 2
parms = (
    Ψ = sqrt.([.3,.1,.2,.4]),
    θli = .3,
    θpb = .3,
)

model = QuantumModel(; parms...)
preds = predict(
    model;
    joint_func = get_joint_probs, 
    n_way
)
```

## Simulate Model

The code block below demonstrates how to generate simulated data from the model using `rand`. In the example, we will generate 100 simulated trials for each condition. 

```@example basic_usage
using QuantumContextEffectModels
n_way = 2
n_trials = 100
parms = (
    Ψ = sqrt.([.3,.1,.2,.4]),
    θli = .3,
    θpb = .3,
)

model = QuantumModel(; parms...)
data = rand(model, n_trials; n_way)
```

## Labeled Tables

Interpreting the large number of nested arrays can be challenging. In the model illustrated here, there are 12 two-way tables embedded within the nested arrays. We can use `to_table` to assign labels to aid in the intepretation. In the code block below, we define two variables: `var_names`, which is the name of the attributes, and `values` which are the corresponding values for each attribute. To ensure the tables are labeled correctly, it is necessary to use the same order of attributes and values defined in `make_projectors`. 

There are 12 tables in the full set. For ease of presentation, we will focus on the first two sets. The first set contains two tables for attributes *believable* and *informative*---one for each order. The predictions are the same for each order because *believable* and *informative* are compatible. For example, 

$\Pr(B = -1 \cap I = 1) = \Pr(I = 1 \cap B = -1) = .20,$

where 1 corresponds to yes and -1 correspond to no. 

```@example basic_usage
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
    :B, # believable
    :I, # informative
    :P, # persuasive
    :L  # likable
]
values = fill([:yes,:no], 4)

df = to_tables(preds, var_names, values, n_way)
df[1]
```
The code block below shows the second set for *believable* and *persuasive*. Again, there is a $2 \times 2$ table for each order. However, in this case, the $2 \times 2$ tables are different because *believable* and *persuasive* are incompatible, resulting in order effects. For example, 

$\Pr(B = -1 \cap P = 1) \ne \Pr(P = 1 \cap B = -1).$

```@example basic_usage
df[2]
```
## DataFrame 

In many cases, the use of a flat data structure can facilitate data analysis and plotting. The function `to_dataframe` converts a nested array into a flat `DataFrame` object. Similar to the function `to_tables`, `to_dataframe` requires attribute names and attribute values, which are specified in the same order as the projectors in `make_projectors`. 

```@example basic_usage
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
    :B, # believable
    :I, # informative
    :P, # persuasive
    :L  # likable
]
values = fill([:yes,:no], 4)

df = to_dataframe(preds, var_names, values, n_way)
first(df, 8)
```

## Evaluate Log Likelihood

The log likelihood of data can be evaluated using `logpdf`. In the code block below, we generate simulated data and evaluate the logpdf: 
```@example basic_usage
using QuantumContextEffectModels
n_way = 2
n_trials = 100
parms = (
    Ψ = sqrt.([.3,.1,.2,.4]),
    θli = .3,
    θpb = .3,
)

model = QuantumModel(; parms...)
data = rand(model, n_trials; n_way)
logpdf(model, data, n_trials; n_way)
```