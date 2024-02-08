!!! warning "Warning"
    Documentation is under construction

# QuantumContextEffectModels.jl

This package contains code for a quantum cognition model of order effects in medical diagonsis.

## Installation

There are two methods for installing the package. Option 1 is to install without version control. In the REPL, use `]` to switch to the package mode and enter the following:

```julia
add https://github.com/itsdfish/QuantumContextEffectModels.jl
```
Option 2 is to install via a custom registry. The advantage of this approach is greater version control through Julia's package management system. This entails two simple steps. 

1. Install the registry using the directions found [here](https://github.com/itsdfish/Registry.jl).
2. Add the package by typing `]` into the REPL and then typing (or pasting):

```julia
add QuantumContextEffectModels
```
I recommend adding the package to a [project-specific environment](https://pkgdocs.julialang.org/v1/environments/) and specifying version constraints in the Project.toml to ensure reproducibility. For an example, see the [Project.toml](Project.toml) file associated with this package.  

# References 

Busemeyer, J. R., & Wang, Z. (2018). Hilbert space multidimensional theory. Psychological Review, 125(4), 572.
