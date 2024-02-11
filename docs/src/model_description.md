!!! warning "Warning"
    This page is under construction.
# Introduction 

Prior research has found that the judged likelihood of a hypothesis often depends on the order in which evidence is presented. In other words, the final judgment that a hypothesis is true is different for evidence sequence $S_i, S_j$ and evidence sequence $S_j, S_i$. The goal of this tutorial is to describe a quantum order effect model (QOEM) as it applies to a medical diagnosis task. The basic model can be adapted to other tasks in which evidence is evaluated sequentially.  

# Attribute Judgment Task

In the attribute judgment task, subjects make judgements about stimuli which vary along some dimensions (e.g., attractiveness, intelligence, friendliness etc.). Subjects might make simultaneous judgments about a subset of attributes. For example, attractiveness and friendliness is a subset, which forms a 2-way joint probability table. The collection of attributes judged together, including the order in which they are presented, constitutes a question context. That means *attractiveness and friendliness* and *friendliness and attractiveness* are different question contexts. The general question of interest is whether the judgments can be characterized by a single underlying joint probability distribution across all attributes. In other words, is it possible to deduce the judgments of subsets by marginalizing across non-judged attributes.

In general, suppose there are $n_a$ attributes $[a_1, a_2, \dots, a_{n_a}]$ which can describe stimuli in a domain of interest. Each attribute $i$ has $k_i$ discrete values. Thus, in total, there are $\Pi_{i}^{n_a} k_i$ possible values. A subset of $1 \geq s \geq n_a$ attributes are measured at a time, forming s-way joint probability tables. Thus, there are $C(n_a,s)$ combinations of attributes of size $s$ and $P(n_a, s)$ permutations where order matters. Thus, there are $P(n_a, s)$ possible question contexts. 

# Context Effects

 Broadly speaking, a context effect occurs when set of judgments cannot be deduced from a single underlying joint probability distribution. There are several ways this may manifest. One way is a violation of marginal invariance, which occurs when the marginal probability of an event cannot be computed by summing the joint probabilities comprising the event. The other way a context effect may emerge is when the joint probability table depends on order in which $s$ attributes are presented. Suppose there are $n_a=4$ attributes corresponding to 
 
 - believable
 - informative
 - persuasive
 - likable

## Marginal Invariance 

 Define $\{V_1, V_2, V_3, V_4 \}$ as a set of random variables representing judgments of the four attributes. Suppose subjects judge a subset of $s=2$ attributes $\{V_1, V_2 \}$ from a set of four attributes. Marginal invariance requires that the probability judgment for attribute 1 is $V_1=v_1$ and judgment for attribute 2 is $V_2=v_2$ can be found by marginalizing over the other two judgments $\{V_3,V_4\}$, as follows:

$\Pr(V_1=v_1 \cap V_2=v_2) = \sum_{x_3 \in X_3} \sum_{x_4 \in X_4}\Pr(V_1=v_1 \cap V_2=v_2 \cap V_3=x_3 \cap V_4=x_4)$

where $X_3$ and $X_4$ are all possible values for $V_3$ and $V_4$.

## Order Effect 

An order effect occurs when the final probability judgment of disease depends on the order in which evidence is presented. An order effect for two sources of evidence can be stated formally as: 

$\Pr(V_1 = v_1 \cap V_2 = v_2) = \Pr(V_2 = v_2 \cap V_1 = v_1)$

# Quantum Context Effect Model 

According to the QOEM, evidence sources constitute *incompatible* events, meaning they cannot be considered simultaneously because the joint probability distribution is not defined. In particular, a person cannot represent the 8 dimensional joint distribution of events over disease status (present vs. absent), evidence type (positive vs. negative), and information source (medical history vs. laboratory test). Instead, incompatible events are represented in a lower 4 dimensional space using different bases, which must be evaluated sequentially. Bases correspond to different perspectives of a situation. In the medical diagnosis task, the QOEM assumes that medical history and laboratory tests are viewed one at a time from different perspectives. Order effects arise from this process because the linear algebra operations described below are non-commutative. 

## Basis

The first step in the process of defining a quantum model is to determine which events are compatible and which are incompatible. The QOEM assumes information source is incompatible, but disease status and evidence type are compatible. Consequentially, the basis of the QOEM consists of four states corresponding to the all possible combinations of disease status and evidence type:

1. disease present (p) and positive evidence for disease (p)
2. disease present (p) and negative evidence for disease (n)
3. disease absent (a) and positive evidence for disease (p)
4. disease absent (a) and negative evidence for disease (n)

where the values in the parentheses correspond to indices. In the notation used below, the first index corresponds to the presence or absence of the disease, and the second index corresponds to the type of evidence for the disease (positive or negative). Information source is represented as different bases within the reduced 4 dimensional space. Each basis for information source is related to the other bases through a rotation factor, which corresponds to the idea of viewing the diagnosis from different perspectives. More formally, the basis is given by the following orthonormal vectors in the standard position:  

```math
\mathbf{B} = \{\ket{\textrm{B}_{p,p}},\ket{\textrm{B}_{p,n}},\ket{\textrm{B}_{a,p}},\ket{\textrm{B}_{a,n}}\},
```
where each basis vector consists of a 1 with all other elements equal to zero, e.g., 

$\ket{\textrm{B}_{p,p}} = \begin{bmatrix}
	1 \\ 
	0 \\ 
	0 \\ 
	0\\ 
\end{bmatrix}$
 
Combining the basis vectors into a single matrix, we get the identity matrix:

```math
\mathbf{I}_4 = \begin{bmatrix}		
	1 & 0 & 0 & 0\\
	0 & 1 & 0 & 0\\
	0 & 0 & 1 & 0\\
	0 & 0 & 0 & 1\\
\end{bmatrix}
```
## States

The state of the cognitive system is a superposition (i.e. linear combination) over basis states:

$\ket{\boldsymbol{\psi}} = \alpha_{p,p} \ket{B_{p,p}} + \alpha_{p,n} \ket{\textrm{B}_{p,n}}+ \alpha_{a,p}\ket{\textrm{B}_{a,p}}+ \alpha_{a,n} \ket{\textrm{B}_{a,n}},$

where $\lVert\ket{\boldsymbol{\psi}} \rVert = 1$. The coefficients can be written as:

$\boldsymbol{\alpha} = \begin{bmatrix}
	\alpha_{p,p} \\ 
	\alpha_{p,n} \\ 
	\alpha_{a,p} \\ 
	\alpha_{a,n} \\ 
\end{bmatrix}.$

The initial state is is based on the mean probability judgment after the first symptoms are described: 

$\ket{\boldsymbol{\psi}} = \begin{bmatrix}
	\sqrt(\frac{.676}{2}) \\ 
	\sqrt(\frac{.676}{2}) \\ 
	\sqrt(\frac{.324}{2}) \\ 
	\sqrt(\frac{.324}{2}) \\ 
\end{bmatrix}.$

## Projectors 

The QOEM makes repeated use of three projection matrices. The following projector is used to evaluate the probability of disease:

$\mathbf{P}_d = \ket{\textrm{B}_{p,p}} \bra{\textrm{B}_{p,p}} + \ket{\textrm{B}_{p,n}} \bra{\textrm{B}_{p,n}} = \begin{bmatrix}		
	1 & 0 & 0 & 0\\
	0 & 1 & 0 & 0\\
	0 & 0 & 0 & 0\\
	0 & 0 & 0 & 0\\
\end{bmatrix}.$

Notice it spans the 2D sub-space in which the disease is present. The next projector is used to evaluate the probability of positive evidence:

$\mathbf{P}_p = \ket{\textrm{B}_{p,p}} \bra{\textrm{B}_{p,p}} + \ket{\textrm{B}_{a,p}} \bra{\textrm{B}_{a,p}} = \begin{bmatrix}		
	1 & 0 & 0 & 0\\
	0 & 0 & 0 & 0\\
	0 & 0 & 1 & 0\\
	0 & 0 & 0 & 0\\
\end{bmatrix}.$

Similarly, the projector spans the 2D sub-space in which positive evidence is discovered. Finally, the following projector evaluates the probability of negative evidence:

$\mathbf{P}_n = \ket{\textrm{B}_{p,n}} \bra{\textrm{B}_{p,n}} + \ket{\textrm{B}_{a,n}} \bra{\textrm{B}_{a,n}} = \begin{bmatrix}		
	0 & 0 & 0 & 0\\
	0 & 1 & 0 & 0\\
	0 & 0 & 0 & 0\\
	0 & 0 & 0 & 1\\
\end{bmatrix}.$
As before, the projector spans the 2D sub-space in which negative evidence is discovered. 

## Hamiltonian Matrices

Hamiltonian matrices govern the decision dynamics of the model. The Hamiltonian matrix $\mathbf{H}(\gamma)$ consists of two components: $\mathbf{H}_1$ is sensitive to the payoff matrix, and $\mathbf{H}_2$ is sensitive to cognitive dissonance between beliefs and actions. The component $\mathbf{H}_1$ is defined as follows: 

$\mathbf{H}_1 = I_2 \otimes \begin{bmatrix}		
	1 & 1\\
	1 & -1\\
\end{bmatrix} = \begin{bmatrix}		
	1 & 1 & 0 & 0\\
	1 & -1 & 0 & 0\\
	0 &  0 & 1 & 1\\
	0 & 0 & 1 & -1\\
\end{bmatrix}$

The second component is defined as:

$\mathbf{H}_{2} = \begin{bmatrix}		
	1 & 0 & 1 & 0\\
	0 & -1 & 0 & 1\\
	1 &  0 & -1 & 0\\
	0 & 1 & 0 & 1\\
\end{bmatrix}.$

$\mathbf{H} = \frac{1}{\sqrt{2}}\left(\mathbf{H}_1 + \mathbf{H}_2 \right)$

## Evidence Evaluation

This selection describes the process of selecting an action and determining the defection probability. The time evolution is governed by the unitary transformation matrix which is given by:

$\mathbf{U}_h= e^{-i \cdot t \cdot \gamma_h \cdot \mathbf{H}},$

$\mathbf{U}_l = e^{-i \cdot t \cdot  \gamma_l \cdot \mathbf{H}},$

## QOEM Predictions

In this section, we go through the steps for computing the predictions in the condition in which the medical history is provided followed by the laboratory test. The predictions follow a similar procedure in the condition in which the order of evidence is reversed.

### Assessment Without Evidence Sources

First, we will compute the probability that the disease is present before additional evidence is collected from medical history and laboratory tests. The computation involves projecting the intial state onto the 2D sub-space spanning disease present and squaring the magnitude of the projection, which is computed as:

$\Pr(D=d) = \lVert \mathbf{P}_d \ket{\psi} \rVert^2.$

### Assessment With Medical History
Next, suppose we update the assessment of the disease given positive evidence from test $i$ is found. The process involves three computations: (1) projecting the initial state onto the positive evidence sub-space, (2) normalizing the state vector, and (3) projecting the new state onto the 2D sub-space spanning disease present. To update the state, we first project onto the sub-space representing medical history.

$\ket{\psi_p^\prime} = \mathbf{P}_p \mathbf{U}_h\ket{\psi}.$ 

Note that he unitary matrix $\mathbf{U}_p$ changes the system to the basis for medical history. After projecting on to the 2D sub-space for positive, the state collapses onto that sub-space. As a result, the new state must be normalized such that the squared magnitude is 1:

$\ket{\psi_p} = \frac{\ket{\psi_p^\prime}}{\lVert \ket{\psi_p^\prime} \rVert}.$ 

The last step involves projecting onto the 2D sub-space spanning disease present and squaring the magnitude to obtain the revised probability judgment for the disease:

$\Pr(D=d \mid S_i = 1) = \lVert \mathbf{P}_d \ket{\psi_p} \rVert^2.$

### Assessment With Medical History and Laboratory Test 

Next, negative evidence is presented from the laboratory test. A similar sequence of steps is followed. The first step involves projecting onto the 2D sub-space spanned by negative evidence: 

$\ket{\psi_{pn}^\prime} = \mathbf{P}_n \mathbf{U}_l \mathbf{U}_h^\dagger \ket{\psi_p}.$ 

Notice that the process of changing bases involves an extra step. Because the model state is currently in the positive medical history basis, it is necessary to perform the inverse operation with the conjugate transpose $\mathbf{U}_h^\dagger$ and then switch to the basis for the laboratory test with $\mathbf{U}_l$. As before, the state collapses to negative evidence because negative evidence was observed. Thus, the state must be normalized:

$\ket{\psi_{pn}} = \frac{\ket{\psi_{pn}^\prime}}{\lVert \ket{\psi_{pn}^\prime} \rVert}.$ 

Now that the state is in the sub-space for negative evidence, the last step involves projecting onto the 2D sub-space for disease present to obtain a probability judgment for the presense of the disease:

$\Pr(D=d \mid S_i = 1, S_j=-1) = \lVert \mathbf{P}_d \ket{\psi_{pn}} \rVert^2.$



| Evidence 	| Data  	| Model 	|
|----------	|-------	|-------	|
|          	| 0.674 	| 0.676 	|
| H        	| 0.778 	| 0.793 	|
| H,L      	| 0.509 	| 0.504 	|
|          	| 0.678 	| 0.676 	|
| L        	| 0.440 	| 0.437 	|
| L,H      	| 0.591 	| 0.590 	|

The code used to generate the predictions can be viewed by expanding the code block below:

```@raw html
<details>
<summary><b>Show Code</b></summary>
```
```@example model_preds
using QuantumContextEffectModels

```
```@raw html
</details>
```

### Dynamics 

The plot below shows the dynamics of the model for each condition.

### Interference Effects

The plot below shows the interference effect as a function of $\mu$ for multiple values of $\gamma$. In the simulations below, we fix $t=\frac{\pi}{2}$.

# References

Trueblood, J. S., & Busemeyer, J. R. (2011). A quantum probability account of order effects in inference. Cognitive science, 35(8), 1518-1552.