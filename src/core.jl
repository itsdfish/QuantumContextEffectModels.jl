abstract type AbstractQuantumModel{T} end 

function make_projectors(model::AbstractQuantumModel) 
    error("A method for `make_projectors` is not defined for $(typeof(model))")
end

"""
    predict(
        model::AbstractQuantumModel; 
        n_way, 
        joint_func = get_ordered_joint_probs
    )

Computes response probabilities all possible `n_way` joint probability tables. If `get_ordered_joint_probs`
is assigned to `joint_func`, all orders within each `n_way` table is included. If `get_joint_probs` is assigned to
`joint_func`, the output will include only one order perh `n_way` joint probability table. The order used is based 
on the projectors defined in `make_projectors`.

# Arguments

- `model::AbstractQuantumModel`:an abstract quantum model object

# Keywords

- `n_way`: the number of attributes judged simultaneously to form an n-way joint probability table 
- `joint_func=get_ordered_joint_probs`: joint probability function. The function `get_ordered_joint_probs` returns 
all possible orders where as the function `get_joint_probs` returns joint probabilities in the order specified in 
`make_projectors`.
"""
function predict(
        model::AbstractQuantumModel; 
        n_way, 
        joint_func = get_ordered_joint_probs
    )
    (;Ψ) = model
    # generate all projectors 
    projectors = make_projectors(model)
    # generate all combinations of projectors for 2-way tables 
    combs = combinations(projectors, n_way)
    # generate all 2-way joint probability tables 
    return map(p -> joint_func(model, p, Ψ), combs)
end

"""
    𝕦(θ)

Generates a 2 × 2 unitary transition matrix by rotating the standard basis.

# Arguments

- `θ`: rotation factor where θ ∈ [-1,1]
"""
𝕦(θ) = [
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

Simulates `n_trials` of judgements per condition for all possible ordered collections of size `n_way`.

# Arguments

- `dist::AbstractQuantumModel`:an abstract quantum model object
- `n_trials::Int`: number of trials per condition 

# Keywords 

- `joint_func = get_ordered_joint_probs`: joint probability function. The function `get_ordered_joint_probs` returns 
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

"""
    logpdf(
        dist::AbstractQuantumModel,
        data::Vector{Vector{Vector{Int}}},
        n_trials::Int;
        n_way
    )


Evaluates the log likelihood of all judgements per condition for all possible ordered collections of size `n_way`.

# Arguments

- `dist::AbstractQuantumModel`:an abstract quantum model object
- `data::Vector{Vector{Vector{Int}}}`: frequencies of yes responses for all `n_way` tables and orders
- `n_trials::Int`: number of trials per condition 

# Keywords 

- `n_way`: the number of attributes simultaneously judged, forming an n_way-table. 
"""
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

"""
    logpdf(
        dist::AbstractQuantumModel,
        data::Vector{Vector{Int}},
        n_trials::Int;
        n_way
    )


Evaluates the log likelihood of all judgements for all possible joint probability tables with `n_way` dimensionality.

# Arguments

- `dist::AbstractQuantumModel`:an abstract quantum model object
- `data::Vector{Vector{Int}}`: frequencies of yes responses for all `n_way` tables (excluding order)
- `n_trials::Int`: number of trials per condition 

# Keywords 

- `n_way`: the number of attributes simultaneously judged, forming an n_way-table. 
"""
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