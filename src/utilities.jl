"""
    to_dataframe(
        data::Vector{Vector{Vector{Float64}}},
        attributes::T1,
        values::T2,
        n_way::Int
    )



# Arguments

- `data::Vector{Vector{Vector{T}}}:` a three-level nested data vector of vectors representing data or predictions. The first level contains different subsets of 
    `n_way` joint probabilities (e.g., {B,I},{B,P},...). The second level contains all orders for a given subset (e.g., [B,I], [I,E]). The third level contains specific
    elemnts of the `n_way` joint probability table. 
- `attributes::T1`: a vector of attribute names
- `values::T2`: a vector of vectors where each sub-vector responses to possible values for a given attribute name
- `n_way::Int`: the number of attributes defining the `n₁ × … × nₘ` joint probability table where `m=n_way`.

where `T1`,`T2` `<:` `Vector`. 

# Example output 

```julia
48×6 DataFrame
 Row │ group  order  attributes  values        val_idx  preds       
     │ Int64  Int64  Array…      Array…        Int64    Float64     
─────┼──────────────────────────────────────────────────────────────
   1 │     1      1  [:B, :I]    [:yes, :yes]        1  0.3
   2 │     1      1  [:B, :I]    [:no, :yes]         2  0.2
   3 │     1      1  [:B, :I]    [:yes, :no]         3  0.1
   4 │     1      1  [:B, :I]    [:no, :no]          4  0.4
   5 │     1      2  [:I, :B]    [:yes, :yes]        1  0.3
   6 │     1      2  [:I, :B]    [:yes, :no]         2  0.2
   7 │     1      2  [:I, :B]    [:no, :yes]         3  0.1
   8 │     1      2  [:I, :B]    [:no, :no]          4  0.4
   9 │     2      1  [:B, :P]    [:yes, :yes]        1  0.329624
  10 │     2      1  [:B, :P]    [:no, :yes]         2  0.624449
  11 │     2      1  [:B, :P]    [:yes, :no]         3  0.0300594
  12 │     2      1  [:B, :P]    [:no, :no]          4  0.0158673
  13 │     2      2  [:P, :B]    [:yes, :yes]        1  0.138197
  14 │     2      2  [:P, :B]    [:yes, :no]         2  0.392705
  ⋮
```
"""
function to_dataframe(
        data::Vector{Vector{Vector{T}}},
        attributes::T1,
        values::T2,
        n_way::Int
    ) where {T,T1<:Vector,T2<:Vector}

    dv_name = T == Int ? "data" : "preds"
    df = DataFrame(
        "group" => Int[],
        "order" => Int[],
        "attributes" => T1[],
        "values" => T2(),
        "val_idx" => Int[],
        dv_name => T[],
    )
    var_combs = combinations(attributes, n_way)
    val_combs = combinations(values, n_way)
    vals_combs = map(c -> collect(Base.product(c...))[:], val_combs)
    cnt = 0
    group_idx = 0
    for (vars,vals) ∈ zip(var_combs, vals_combs)
        group_idx += 1
        val_idx = 0
        for vals1 ∈ vals
            val_idx += 1
            order_idx = 0
            for (vi,_v) ∈ zip(permutations(vars), permutations(vals1))
                order_idx += 1
                push!(df, (group_idx, order_idx, vi, _v, val_idx, data[group_idx][order_idx][val_idx]))
            end
        end
    end
    sort!(df,[:group,:attributes])
    return df
end

"""
    to_dataframe(
        data::Vector{Vector{Vector{T}}},
        attributes::T1,
        values::T2,
        n_way::Int
    )

Flattens input `data` into a long form DataFrame. 
# Arguments

- `data::Vector{Vector{T}}:` a two-level nested data vector of vectors representing data or predictions. Each sub-vector is a different set of 
    variables comprising the `n_way` joint probability table. Only one order of a given set of variables included, which is the order 
    specified in the function `make_projectors`.
- `attributes::T1`: a vector of attribute names
- `values::T2`: a vector of vectors where each sub-vector responses to possible values for a given attribute name
- `n_way::Int`: the number of attributes defining the `n₁ × … × nₘ` joint probability table where `m=n_way`.

where `T1`,`T2` `<:` `Vector`. 

# Output

```julia
24×4 DataFrame
 Row │ group  attributes  values        preds       
     │ Int64  Array…      Array…        Float64     
─────┼──────────────────────────────────────────────
   1 │     1  [:B, :I]    [:yes, :yes]  0.3
   2 │     1  [:B, :I]    [:no, :yes]   0.2
   3 │     1  [:B, :I]    [:yes, :no]   0.1
   4 │     1  [:B, :I]    [:no, :no]    0.4
   5 │     2  [:B, :P]    [:yes, :yes]  0.329624
   6 │     2  [:B, :P]    [:no, :yes]   0.624449
   7 │     2  [:B, :P]    [:yes, :no]   0.0300594
   8 │     2  [:B, :P]    [:no, :no]    0.0158673
   9 │     3  [:B, :L]    [:yes, :yes]  0.333826
  10 │     3  [:B, :L]    [:no, :yes]   0.599901
  11 │     3  [:B, :L]    [:yes, :no]   0.0661739
  12 │     3  [:B, :L]    [:no, :no]    9.88958e-5
  13 │     4  [:I, :P]    [:yes, :yes]  0.467509
  14 │     4  [:I, :P]    [:no, :yes]   0.486564
  15 │     4  [:I, :P]    [:yes, :no]   0.0324905
  16 │     4  [:I, :P]    [:no, :no]    0.0134361
  17 │     5  [:I, :L]    [:yes, :yes]  0.322595
  18 │     5  [:I, :L]    [:no, :yes]   0.611132
  19 │     5  [:I, :L]    [:yes, :no]   0.0433761
  20 │     5  [:I, :L]    [:no, :no]    0.0228967
  21 │     6  [:P, :L]    [:yes, :yes]  0.933579
  22 │     6  [:P, :L]    [:no, :yes]   0.000148166
  23 │     6  [:P, :L]    [:yes, :no]   0.0204943
  24 │     6  [:P, :L]    [:no, :no]    0.0457785
```
"""
function to_dataframe(
        data::Vector{Vector{T}},
        attributes::T1,
        values::T2,
        n_way::Int
    ) where {T,T1<:Vector,T2<:Vector}

    dv_name = T == Int ? "data" : "preds"
    df = DataFrame(
        "group" => Int[],
        "attributes" => T1[],
        "values" => T2(),
        dv_name => T[],
    )
    var_combs = combinations(attributes, n_way)
    val_combs = combinations(values, n_way)
    vals_combs = map(c -> collect(Base.product(c...))[:], val_combs)
    cnt = 0
    group_idx = 0
    for (vars,vals) ∈ zip(var_combs, vals_combs)
        group_idx += 1
        val_idx = 0
        for v ∈ vals
            val_idx += 1
            push!(df, (group_idx, vars, [v...], data[group_idx][val_idx]))
        end
    end
    sort!(df,[:group,:attributes])
    return df 
end

"""
    to_tables(
        data::Vector{Vector{Vector{T}}},
        attributes::T1,
        values::T2,
        n_way::Int
    )
Returns a nested vector of DataFrames where each DataFrame is an `n₁ × n₂` joint probability table. Each sub-vector
of DataFrames contains a DataFrame for each order of a fixed set of attributes. 

# Example Output 

The example output shows the two joint probability tables for attributes `B` and `I`---one for each order.

```julia 
julia> df[1]
2-element Vector{DataFrame}:
 4×6 DataFrame
 Row │ group  order  attributes  values        val_idx  probs   
     │ Int64  Int64  Array…      Array…        Int64    Float64 
─────┼──────────────────────────────────────────────────────────
   1 │     1      1  [:B, :I]    [:yes, :yes]        1      0.3
   2 │     1      1  [:B, :I]    [:no, :yes]         2      0.2
   3 │     1      1  [:B, :I]    [:yes, :no]         3      0.1
   4 │     1      1  [:B, :I]    [:no, :no]          4      0.4
 4×6 DataFrame
 Row │ group  order  attributes  values        val_idx  probs   
     │ Int64  Int64  Array…      Array…        Int64    Float64 
─────┼──────────────────────────────────────────────────────────
   1 │     1      2  [:I, :B]    [:yes, :yes]        1      0.3
   2 │     1      2  [:I, :B]    [:yes, :no]         2      0.2
   3 │     1      2  [:I, :B]    [:no, :yes]         3      0.1
   4 │     1      2  [:I, :B]    [:no, :no]          4      0.4
```
"""
function to_tables(
        data::Vector{Vector{Vector{T}}},
        attributes::T1,
        values::T2,
        n_way::Int
    ) where {T,T1,T2}

    df_long = to_dataframe(data, attributes, values, n_way)
    dfs = Vector{Vector{DataFrame}}()
    df_groups = groupby(df_long, :group)
    for group ∈ df_groups
        df_inner = DataFrame[]
        df_orders = groupby(group, :order)
        for order ∈ df_orders 
            push!(df_inner, DataFrame(order))
        end
        push!(dfs, df_inner)
    end
    return dfs
end

"""
    to_tables(
        data::Vector{Vector{Float64}},
        attributes::T1,
        values::T2,
        n_way::Int
    )

Returns a nested vector of DataFrames where each DataFrame is an `n₁ × n₂` joint probability table. Each sub-vector
of DataFrames contains a DataFrame for each order of a fixed set of attributes. 

# Example Output

``` julia
julia> df[1:2]
2-element Vector{DataFrames.DataFrame}:
 4×4 DataFrame
 Row │ group  attributes  values        preds   
     │ Int64  Array…      Array…        Float64 
─────┼──────────────────────────────────────────
   1 │     1  [:B, :I]    [:yes, :yes]      0.3
   2 │     1  [:B, :I]    [:no, :yes]       0.2
   3 │     1  [:B, :I]    [:yes, :no]       0.1
   4 │     1  [:B, :I]    [:no, :no]        0.4
 4×4 DataFrame
 Row │ group  attributes  values        preds     
     │ Int64  Array…      Array…        Float64   
─────┼────────────────────────────────────────────
   1 │     2  [:B, :P]    [:yes, :yes]  0.329624
   2 │     2  [:B, :P]    [:no, :yes]   0.624449
   3 │     2  [:B, :P]    [:yes, :no]   0.0300594
   4 │     2  [:B, :P]    [:no, :no]    0.0158673
```
"""
function to_tables(
        data::Vector{Vector{T}},
        attributes::T1,
        values::T2,
        n_way::Int
    ) where {T,T1,T2}

    df_long = to_dataframe(data, attributes, values, n_way)
    dfs = DataFrame[]
    df_groups = groupby(df_long, :group)
    for group ∈ df_groups
        push!(dfs, DataFrame(group))
    end
    return dfs
end