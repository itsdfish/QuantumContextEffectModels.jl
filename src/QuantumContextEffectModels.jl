module QuantumContextEffectModels

using Combinatorics: combinations
using Combinatorics: permutations
using DataFrames
using Distributions: Multinomial
using LinearAlgebra
using PrettyTables

import Distributions: logpdf
import Distributions: rand

export AbstractQuantumModel
export QuantumModel

export add_labels
export get_ordered_joint_probs
export get_joint_probs
export logpdf
export make_projectors
export predict
export rand
export to_dataframe
export to_tables

include("core.jl")
include("quantum_model.jl")
include("utilities.jl")
end
