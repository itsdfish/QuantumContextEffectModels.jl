

    # variables 
    # (B) believable 
    # (P) persuasive 
    # (I) informative
    # (L) likable 

    # values per dimension: Yes or No 
    # total possible dimensions (if compatible) 2^4 = 16

    # bases
    # B and I 
    # B and L 
    # P and I
    # P and L 

    # note that:  
    # P is a rotation of B 
    # L is a rotation of I

    # Basis vectors for B and I is in standard form and have four dimensions 
    # ψyy: believable and informative 
    # ψyn: believable and not informative 
    # ψny: not believable and informative 
    # ψnn: not believable and not informative 

    # # rotate from b to p 
    # θpb = .0
    # # rotate from L to I 
    # θli = .0

    # Ψ = sqrt.([.3,.1,.2,.4])

"""
    predict(model::AbstractQuantumModel)

Computes response probabilities for six two-way joint probability tables.


# Arguments

- `model::AbstractQuantumModel`:an abstract quantum model object

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
function predict(model::AbstractQuantumModel)
    (;Ψ, θli, θpb) = model
    # generate all projectors 
    projectors = make_projectors(model)
    # generate all combinations of projectors for 2-way tables 
    combs = combinations(projectors, 2)
    # generate all 2-way joint probability tables 
    return map(p -> get_joint_probs(model, p, Ψ), combs)
end

"""
"""
function make_projectors(model::QuantumModel)
    (;θli, θpb) = model

    # 2D projector for responding "yes"
    My = [1 0; 0 0]
    # unitary transformation matrices
    Upb = U(θpb)
    Uli = U(θli)

    # projector for responding "yes" to believable
    Pb = My ⊗ I(2)
    # projector for responding "yes" to informative
    Pi = I(2) ⊗ My
    # projector for responding "yes" to persuasive    
    Pp = (Upb * My * Upb') ⊗ I(2)
    # projector for responding "yes" to likable    
    Pl = I(2) ⊗ (Uli * My * Uli')
    projectors = [
        [Pb,I(4)-Pb],
        [Pi,I(4)-Pi],
        [Pp,I(4)-Pp],
        [Pl,I(4)-Pl],
    ]
    return projectors
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
    get_joint_prob(model::AbstractQuantumModel, P1, P2, Ψ)

Computes the joint probability of two events. 

# Arguments

- `model::AbstractQuantumModel`:an abstract quantum model object
- `projectors`: a vector of projectors 
- `Ψ`: superposition state vector 
"""
function get_joint_prob(model::AbstractQuantumModel, projectors, Ψ)
    proj = prod(projectors) * Ψ
    return proj' * proj 
end

"""
    get_joint_probs(model::AbstractQuantumModel, P1, P2, Ψ)

Computes the joint four probabilities of two binary (yes, no) events. The four joint probabilities are as follows:

- `yes yes`
- `yes no`
- `no yes`
- `no no`

# Arguments

- `model::AbstractQuantumModel`:an abstract quantum model object
- `P1`: projector for the first event 
- `P2`: projector for the second event 
- `Ψ`: superposition state vector 
"""
function get_joint_probs(model::AbstractQuantumModel, projectors, Ψ)
    return  map(p -> get_joint_prob(model, p, Ψ), Base.product(projectors...))
end

const ⊗(x, y) = kron(x, y)

function rand(dist::AbstractQuantumModel, n_trials::Int)
    preds = predict(dist)
    return rand.(Multinomial.(n_trials, preds))
end

function rand(dist::AbstractQuantumModel, n_trials::Int, n_reps::Int)
    return map(_ -> rand(dist, n_trials), 1:n_reps)
end