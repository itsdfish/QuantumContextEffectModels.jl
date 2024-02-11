# Developing a Context Effect Model

In this example, we illustrate the process of creating a new model of context effects using the model developed in Busemeyer & Wang (2018). This model is included with the package and is used throughout the documentation to illustrate how to use the API. 

# Model Overview

The model was developed by Busemeyer & Wang (2018) to explain context effects in judgments of public service announcement (PSA) posters. Subjects made binary (yes,no) judgments along the following four attributes:

- Believable
- Informative
- Persuasive
- Likable 

Subjects judged pairs of attributes rather than all four attributes simultanouesly. In total, there were $P(4,2) = 12$ permutations (e.g., $[[B,I],[I,B],[B,P],[P,B], \dots]$), where each permutation constitutes a unique question context. Each pair forms a $2 \times 2$ table because each attribute assumes binary values. A context effect is observed if the twelve $2 \times 2$ tables cannot be deduced from a single joint probability distribution defined over the four attributes. 

If all attributes are compatible, the quantum model is formally equivalent to a classical model because all events can be represented by a single basis spanning all $2^4 = 16$ dimensions. As such, this model does not produce context effects. By contrast, if some attributes are incompatible, the joint distribution of the incompatible attributes is not defined. Instead, sets of incompatible attributes are represented in a lower dimensional space by different bases (and attributes within a set are compatible). Specifically, the basis for incompatible pairs are found by rotating the basis for compatible pairs. As a consequence, the model can produce context effects.

In this model, *believable* and *informative* are compatible, meaning they are defined within a common basis. Similarly, *persuasive* and *likable* are compatible are defined within the same basis. The basis for attributes *persuasive* and *likable* are found by rotating the basis for *believable* and *informative*.

## Create Model Subtype

The first step in developing a new model is to create a new subtype of `AbstractQuantumModel`. Any subtype of `AbstractQuantumModel` will be compatible with default internal functions used to compute predictions, simulate data, and evaluate the loglikelihood of data with respect to the model. 

The model object below contains six parameters: 

-  $\Psi$: a $4 \times 1$ initial state vector consisting of four parameters
-  $\theta_{i,l} \in [-1,1]$: a rotation parameter to rotate basis $i$ to basis $l$ 
-  $\theta_{p,b} \in [-1,1]$: a rotation parameter to rotate basis $p$ to basis $b$

```julia 
mutable struct QuantumModel{T<:Real} <: AbstractQuantumModel
    Ψ::Vector{T}
    θil::T 
    θpb::T 
end
```
The API requires each subtype of `AbstractQuantumModel` to have a field for $\Psi$, but places no other contraints on the remaining fields. 

## Create Projector Generator

The other step is to extend the function `make_projectors`, which, as its name implies, creates projectors. There are two basic steps for creating the projectors. First, we create projectors for responding *yes* to each of the binary attributes. For example, the projector `Pb = My ⊗ I(2)` projects the superposition state onto the subspace corresponding to *believable*. Second, all possible projectors are enumerated and organized into a vector of vectors, where the subvectors correspond to all possible responses to a given attribute. In the case of binary attributes, each subvector is of length 2 and responding *no* is the complement of responding *yes*: $\mathbf{P}_n = I - \mathbf{P}_y$. The vector of projectors is organized accordingly:

$[[\mathbf{P}_{b,y},\mathbf{P}_{b,n}],[\mathbf{P}_{i,y},\mathbf{P}_{i,n}],[\mathbf{P}_{p,y},\mathbf{P}_{p,n}],[\mathbf{P}_{l,y},\mathbf{P}_{l,n}]],$ 

where subscripts $b$, $i$, $p$ and $l$ correspond to attributes believable, informative, persuasive and likable, respectively. Note that the package can accomodate projectors an arbitrary number of dimensions, including attributes with different number of response outcomes.

```julia 
function make_projectors(model::QuantumModel)
    (;θil, θpb) = model

    # 2D projector for responding "yes"
    My = [1 0; 0 0]
    # unitary transformation matrices
    Upb = 𝕦(θpb)
    Uil = 𝕦(θil)

    # projector for responding "yes" to believable
    Pb = My ⊗ I(2)
    # projector for responding "yes" to informative
    Pi = I(2) ⊗ My
    # projector for responding "yes" to persuasive    
    Pp = (Upb * My * Upb') ⊗ I(2)
    # projector for responding "yes" to likable    
    Pl = I(2) ⊗ (Uil * My * Uil')
    
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
