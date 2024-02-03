

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

The two-way tables are as follows: 

- `persuasive and informative`
- `persuasive and believable`
- `persuasive and likable`
- `informative and believable`
- `informative and likable`
- `believable and likable`
"""
function predict(model::AbstractQuantumModel)
    (;Ψ, θli, θpb) = model

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

    # joint probabilities for persuasive and informative
    prob_pi = get_joint_probs(model, Pp, Pi, Ψ)
    # joint probabilities for persuasive and believable
    prob_pb = get_joint_probs(model, Pp, Pb, Ψ)
    # joint probabilities for persuasive and likable
    prob_pl = get_joint_probs(model, Pp, Pl, Ψ)
    # joint probabilities for informative and believable
    prob_ib = get_joint_probs(model, Pi, Pb, Ψ)
    # joint probabilities for informative and likable
    prob_il = get_joint_probs(model, Pi, Pl, Ψ)
    # joint probabilities for believable and likable
    prob_bl = get_joint_probs(model, Pb, Pl, Ψ)

    return [prob_pi,prob_pb,prob_pl,prob_ib,prob_il,prob_bl]    
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
- `P1`: projector for the first event 
- `P2`: projector for the second event 
- `Ψ`: superposition state vector 
"""
function get_joint_prob(model::AbstractQuantumModel, P1, P2, Ψ)
    proj = P2 * P1 * Ψ
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
function get_joint_probs(model::AbstractQuantumModel, P1, P2, Ψ)
    n = length(Ψ)
    p_yy = get_joint_prob(model, P1, P2, Ψ)
    p_yn = get_joint_prob(model, P1, I(n) - P2, Ψ)
    p_ny = get_joint_prob(model, I(n) - P1, P2, Ψ)
    p_nn = 1 - (p_yy + p_yn + p_ny)
    return [p_yy,p_yn,p_ny,p_nn]
end

const ⊗(x, y) = kron(x, y)

# function rand(dist::AbstractQuantumModel, n_trials::Int)
#     preds = predict(dist)
#     return rand.(Multinomial.(n_trials, preds))
# end

function rand(dist::AbstractQuantumModel, n_trials::Int)
    preds = predict(dist)
    return rand.(Multinomial.(n_trials, preds))
end

function rand(dist::AbstractQuantumModel, n_trials::Int, n_reps::Int)
    return map(_ -> rand(dist, n_trials), 1:n_reps)
end