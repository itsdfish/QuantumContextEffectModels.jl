import Base: show 

function show_structure(var_names, values, n_way)
    name_combs = combinations(var_names, n_way) |> collect
    combs = combinations(values, n_way)
    vals = map(c -> collect(Base.product(c...))[:], combs)
    structure = map(v -> make_strings(v...), zip(name_combs, vals))
    return S(structure)
end

struct S{T}
    x::T
end

function Base.show(io::IO, ::MIME"text/plain", x::S)
    map(i -> _show(io, i...), enumerate(x.x));
end

function _show(io::IO, n, values)
    return pretty_table(io,
        values;
        #title="table $n",
        #row_label_column_title="Field",
        compact_printing=false,
        header=["Table $n"],
        row_label_alignment=:l,
        #row_labels=values,
        formatters=ft_printf("%5.2f"),
        alignment=:l,
    )
end

function make_strings(vars, vals)
    return map(v -> make_string(vars, v), vals)
end

function make_string(vars, vals)
    str = ""
    n = length(vars)
    for i ∈ 1:n 
        str *= string(vars[i], " = ",vals[i])
        if i ≠ n 
            str *= " ∩ "
        end
    end
    return str
end