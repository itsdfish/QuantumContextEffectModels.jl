# Developing a Context Effect Model

In this example, we illustrate the process of creating a new model of context effects using the model developed in Busemeyer & Wang (2018). This model is included with the package and is used throughout the documentation to illustrate how to use the API. 

# Model Overview

The model was developed by Busemeyer & Wang (2018) to explain context effects in judgments of public service announcement (PSA) posters. Subjects made binary (yes,no) judgments along the following four attributes:

- Believable
- Informative
- Persuasive
- Likable 

Subjects judged pairs of attributes rather than all four attributes simultanouesly. In total, there were $P(4,2) = 12$ permutations (e.g., [B,I],[I,B],[B,P], ...). Each pair forms a $2 \times 2$ table. A context effect is observed if the twelve $2 \times 2$ tables cannot be deduced from a single joint probability distribution across the four attributes. 

A quamtum model for compatible events represents beliefs in an attribute space with $2^4 = 16$ dimensions. This type of model does not produce context effects, and is formally equivalent to a classical probability model. However, when events are incompatible, their joint distribution is not defined. Instead, attributes are represented in a lower dimensional space in which different bases are used to describe incompatible events. Specifically, the basis for incompatible pairs are found by rotating the basis for compatible pairs. The following pairs are incompatible 

- Believable and Perusaive
- Informative and Likable

## Create Model Subtype

The first step in developing a new model is to create a new subtype of `AbstractQuantumModel`. Any subtype of `AbstractQuantumModel` will be compatible with default internal functions used to compute predictions, simulate data, and evaluate the loglikelihood of data with respect to the model. 

The model object below contains six parameters: 

-  $\Psi$: a $4 \times 1$ initial state vector consisting of four parameters
-  $\theta_{l,i} \in [-1,1]$: a rotation parameter to rotate the 
-  $\theta_{p,b} \in [-1,1]$: a rotation parameter to rotate the 

```julia 
mutable struct QuantumModel{T<:Real} <: AbstractQuantumModel
    Ψ::Vector{T}
    θli::T 
    θpb::T 
end
```

## Create Projector Generator

The other step is to extend the function `make_projectors`, which, as its name implies, creates projectors. There are two basic steps for creating the projectors. First, we create projectors for responding *yes* to each of the binary attributes. For example, `Pb = My ⊗ I(2)` projects the superposition state onto the subspace corresponding to *believable*. Second, all possible projectors are enumerated and organized into a vector of vectors, where the subvectors correspond to all possible responses to a given attribute. In the case of binary attributes, each subvector is of length 2 and responding *no* is the complement of responding *yes*: $\mathbf{P}_n = I - \mathbf{P}_y$. The vector of projectors is organized accordingly:

$[[\mathbf{P}_{b,y},\mathbf{P}_{b,n}],[\mathbf{P}_{i,y},\mathbf{P}_{i,n}],[\mathbf{P}_{p,y},\mathbf{P}_{p,n}],[\mathbf{P}_{l,y},\mathbf{P}_{l,n}]],$ 

where subscripts $b$, $i$, $p$ and $l$ correspond to attributes believable, informative, persuasive and likable, respectively. Note that the package can accomodate projectors an arbitrary number of dimensions, including attributes with different number of response outcomes.

```julia 
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
```
After defining the model subtype and `make_projectors`, the model will work with the package API. 

# References 

Busemeyer, J. R., & Wang, Z. (2018). Hilbert space multidimensional theory. Psychological Review, 125(4), 572.
