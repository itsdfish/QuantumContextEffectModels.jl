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

