const ⊗(x, y) = kron(x, y)

function simulate(df::DataFrame, context::Vector{T}, n) where {T}
    _df = get_probs(df, context)
   _df.responses .= rand(Multinomial(n, _df.probs))
   select!(_df, Not([:probs]))
   return _df
end

function simulate(Θ, columns, contexts::Vector{Vector{T}}, n) where {T}
    df = make_df(columns)
    df.probs = Θ
    return map(x -> simulate(df, x, n), contexts)
end

function get_probs(df, context)
    return combine(groupby(df, context), :probs => sum => :probs)
end

function make_df(columns)
    n = length(columns)
    vals = Base.product(fill([:Y,:N], n)...) |> collect
    df = DataFrame(vals[:])
    rename!(df, columns)
    sort!(df, rev=true)
    return df 
end

function compute_chi_square(Θ, data, columns, contexts, n)
    df_pred = make_df(columns)
    df_pred.probs = Θ
    x = 0.0 
    for i ∈ 1:length(contexts) 
        _df = get_probs(df_pred, contexts[i])
        expected = _df.probs * n 
        x += sum((expected .- data[i].responses).^2 ./ expected)
    end
    return x
end

function compute_log_like(Θ, data, columns, contexts, n)
    df_pred = make_df(columns)
    df_pred.probs = Θ
    LL = 0.0 
    for i ∈ 1:length(contexts) 
        _df = get_probs(df_pred, contexts[i])
        LL += logpdf(Multinomial(n, _df.probs), data[i].responses)
    end
    return LL
end

U(θ) = [
    cos(π * θ) -sin(π * θ);
    sin(π * θ) cos(π * θ)
]

function predict(model; t = 1.0)
    #(;Ψ, γₕ, γₗ) = model

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

    # rotate from b to p 
    θpb = .0
    # rotate from L to I 
    θli = .0

    Ψ = sqrt.([.3,.1,.2,.4])

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
    Pp = (Upb * Mn * Upb') ⊗ I(2)
    # projector for responding "yes" to likable    
    Pl = I(2) ⊗ (Uli * My * Uli')

    # joint probabilities for persuasive and informative
    prob_pi = get_joint_probs(Pp, Pi, Ψ)
    # joint probabilities for persuasive and believable
    prob_pb = get_joint_probs(Pp, Pb, Ψ)
    # joint probabilities for persuasive and likable
    prob_pl = get_joint_probs(Pp, Pl, Ψ)
    # joint probabilities for informative and believable
    prob_ib = get_joint_probs(Pi, Pb, Ψ)
    # joint probabilities for informative and likable
    prob_il = get_joint_probs(Pi, Pl, Ψ)
    # joint probabilities for believable and likable
    prob_bl = get_joint_probs(Pb, Pl, Ψ)

    return [prob_pi,prob_pb,prob_pl,prob_ib,prob_il,prob_bl]    
end

function get_prob(P1, P2, Ψ)
    proj = P2 * P1 * Ψ
    return proj' * proj 
end

function get_joint_probs(P1, P2, Ψ)
    n = length(Ψ)
    p_yy = get_prob(P1, P2, Ψ)
    p_yn = get_prob(P1, I(n) - P2, Ψ)
    p_ny = get_prob(I(n) - P1, P2, Ψ)
    p_nn = 1 - (p_yy + p_yn + p_ny)
    return [p_yy,p_yn,p_ny,p_nn]
end