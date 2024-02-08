abstract type AbstractQuantumModel{T} end 

function make_projectors(model::AbstractQuantumModel) end

"""
    predict(
        model::AbstractQuantumModel; 
        n_way, 
        joint_func = get_ordered_joint_probs
    )

Computes response probabilities for six two-way joint probability tables.


# Arguments

- `model::AbstractQuantumModel`:an abstract quantum model object

# Keywords

- `n_way`: the number of attributes judged simultaneously to form an n-way joint probability table 
- `joint_func=get_ordered_joint_probs`: joint probability function. The function `get_ordered_joint_probs` returns 
all possible orders where as the function `get_joint_probs` returns joint probabilities in the order specified in 
`make_projectors`.

# Returns  

This function returns a vector of vectors where each sub-vector represents the two-way joint probability 
table for binary (yes,no) responses. Each sub-vector corresponds to the following response combinations:

- `yes, yes`
- `yes, no`
- `no, yes`
- `no, no`

Assuming 4 binary variables, the tables will correspond to the following two-way tables:
```julia 
variables = [
    :believable,
    :informative,
    :persuasive,
    :likeable
]
combs = combinations(variables, 2) |> collect
# output
[:believable, :informative]
[:believable, :persuasive]
[:believable, :likeable]
[:informative, :persuasive]
[:informative, :likeable]
[:persuasive, :likeable]
```
"""
function predict(
        model::AbstractQuantumModel; 
        n_way, 
        joint_func = get_ordered_joint_probs
    )
    (;Ψ, θli, θpb) = model
    # generate all projectors 
    projectors = make_projectors(model)
    # generate all combinations of projectors for 2-way tables 
    combs = combinations(projectors, n_way)
    # generate all 2-way joint probability tables 
    return map(p -> joint_func(model, p, Ψ), combs)
end

"""
    U(θ)

Generates a 2 × 2 unitary transition matrix by rotating the standard basis.

# Arguments

- `θ`: rotation factor where θ ∈ [-1,1]
"""
U(θ) = [
    cos(π * θ) -sin(π * θ);
    sin(π * θ) cos(π * θ)
]

"""
    get_joint_probs(model::AbstractQuantumModel, projectors, Ψ)

Computes joint probabilities for a distribution with an arbitrary number of dimensions and values per dimension. The total number of elements is `n = Πᵢᵐ nᵢ`,
where `nᵢ` is the number of possible values for the ith dimension. For example, the joint probabilties for two binary variables is organized as follows:

- `yes yes`
- `yes no`
- `no yes`
- `no no`

# Arguments

- `model::AbstractQuantumModel`:an abstract quantum model object
- `projectors`: a vector of projectors
- `Ψ`: superposition state vector 
"""
function get_joint_probs(model::AbstractQuantumModel, projectors, Ψ)
    combs = Base.product(projectors...)
    n = length(combs)
    joint_probs = fill(0.0, n)
    i = 1
    for c ∈ combs  
        joint_probs[i] = get_joint_prob(model, c, Ψ)
        i += 1
    end
    return joint_probs
end

"""
    get_ordered_joint_probs(model::AbstractQuantumModel, projectors, Ψ)

Computes joint probabilities for all posible orders. The function works for a distribution with an arbitrary number of dimensions and values per dimension. The total number of elements is `n = Πᵢᵐ nᵢ`,
where `nᵢ` is the number of possible values for the ith dimension. 

# Arguments

- `model::AbstractQuantumModel`:an abstract quantum model object
- `projectors`: a vector of projectors
- `Ψ`: superposition state vector 
"""
function get_ordered_joint_probs(model::AbstractQuantumModel{T}, projectors, Ψ) where {T}
    combs = Base.product(projectors...)
    n = length(combs)
    n_perms = factorial(length(projectors))
    joint_probs = [Vector{T}(undef,n) for _ ∈ 1:n_perms]
    c = 1
    for comb ∈ combs  
        order = 1
        for perm ∈ permutations(comb)
            joint_probs[order][c] = get_joint_prob(model, perm, Ψ)
            order += 1
        end
        c += 1
    end
    return joint_probs
end

"""
    get_joint_prob(model::AbstractQuantumModel, projectors, Ψ)

Computes the joint probability of a sequence of events whose projectors are defined in `projectors`. 

# Arguments

- `model::AbstractQuantumModel`:an abstract quantum model object
- `projectors`: a vector of projectors 
- `Ψ`: superposition state vector 
"""
function get_joint_prob(model::AbstractQuantumModel, projectors, Ψ)
    proj = prod(projectors) * Ψ
    return proj' * proj 
end

const ⊗(x, y) = kron(x, y)

"""
    rand(
        dist::AbstractQuantumModel,
        n_trials::Int;
        joint_func = get_ordered_joint_probs,
        n_way
    )

Simulates `n_trials` of judgements per condition for all possible ordered pairs of size `n_way`.

# Arguments

- `model::AbstractQuantumModel`:an abstract quantum model object
- `projectors`: a vector of projectors 

# Keywords 

- `joint_func=get_ordered_joint_probs`: joint probability function. The function `get_ordered_joint_probs` returns 
all possible orders where as the function `get_joint_probs` returns joint probabilities in the order specified in 
`make_projectors`.
- `n_way`: the number of attributes simultaneously judged, forming an n_way-table. 
"""
function rand(
        dist::AbstractQuantumModel,
        n_trials::Int;
        joint_func = get_ordered_joint_probs,
        n_way
    )
    preds = predict(dist; joint_func, n_way)
    return _rand(n_trials, preds)
end

function _rand(n_trials, preds::Vector{Vector{Vector{Float64}}})
    return map(p -> rand.(Multinomial.(n_trials, p)), preds)
end

function _rand(n_trials, preds::Vector{Vector{Float64}})
    return rand.(Multinomial.(n_trials, preds))
end

function rand(dist::AbstractQuantumModel, n_trials::Int, n_reps::Int)
    return map(_ -> rand(dist, n_trials), 1:n_reps)
end

function logpdf(
        dist::AbstractQuantumModel,
        data::Vector{Vector{Vector{Int}}},
        n_trials::Int;
        n_way
    )

    preds = predict(
        dist; 
        joint_func = get_ordered_joint_probs,
        n_way
    )
    return sum(_logpdf(n_trials, data, preds))
end

function logpdf(
        dist::AbstractQuantumModel,
        data::Vector{Vector{Int}},
        n_trials::Int;
        n_way
    )

    preds = predict(
        dist; 
        joint_func = get_joint_probs,
        n_way
    )
    return _logpdf(n_trials, data, preds)
end

function _logpdf(
        n_trials, 
        data::Vector{Vector{Vector{Int}}}, 
        preds::Vector{Vector{Vector{T}}}
    ) where {T}
    return mapreduce((p,d) -> logpdf.(Multinomial.(n_trials, p), d), +, preds, data)
end

function _logpdf(
        n_trials, 
        data::Vector{Vector{Int}},
        preds::Vector{Vector{T}}
    ) where {T}
    return sum(logpdf.(Multinomial.(n_trials, preds), data))
end