# 4.2 Constraint Abduction

Abduction is a reasoning technique concerned with the search for explanations. An abduction problem is usually given by a background theory $\Gamma$ and a formula $C$, and the answer is a formula $A$ such that $\Gamma \cup \{A\} \models C$ (relevance), $\Gamma \not\models \neg A$ (consistency), and $A$ has some restricted syntactical form, see Marta Mayer and Fiora Pirri [31]. We are however interested in constraint abduction problems, with constraints expressed over a fixed model $\mathcal{M}$. A constraint abduction problem is then given by a pair of formulas $D, C$, and $A$ is its answer when (at least) $\mathcal{M} \models (D \land A) \Rightarrow C$ (relevance) and $\mathcal{M} \models \exists \text{FV}(D, A). D \land A$ (consistency), see Michael Maher *Herbrand constraint abduction* [27]. We extend the formulation of joint constraint abduction (see [27]) to constraints with quantifiers. In general abduction, where a model is built as a solution, the quantifiers could be eliminated by Herbrandization. However, Herbrandization (and Skolemization) are operations on the level of a logic, not within a model — they do not return equivalent formulas and do not work in a fixed model. The introduced functions are uninterpreted. We opt to keep the model $\mathcal{M}$ and handle quantification explicitly. We develop a combination procedure for abduction algorithms when their domains of constraints are combined in a very simple way (yet sufficing for type-inference-driven invariant generation).

## 4.2.1 Formulating the Joint Constraint Abduction Problem

In joint, also called simultaneous, problems, we expect a single answer to solve several problems, here: to solve a conjunction of implications.

A *solved form* is a syntactically specified class of formulas, associated with a class of problems, for which satisfiability is trivial to check. We restrict solved forms to existentially quantified conjunctions of atoms, $\exists \bar{\beta}: A$. The variables $\bar{\beta}$ of a solved form $\exists \bar{\beta}: A$ that is an abduction problem answer, are *free parameters* of the answer, they are required to be unconstrained.

Due to the iterative nature of the main algorithm, we need to account for prior parameters $\bar{\delta}$ similar to the new parameters $\bar{\beta}$.

The constraints that we need to solve form a *Joint Constraint Abduction under a Quantifier Prefix problem* (JCAQP problem for short) of the form $Q: \bigwedge_i (D_i \Rightarrow C_i)$, where $D_i$ and $C_i$ are conjunctions of atomic formulas, and $Q$ is an arbitrary quantifier prefix. We assume that $\text{FV}(\bigwedge_i (D_i \Rightarrow C_i)) \subseteq Q$. We also have a set $\bar{\chi}$ of parameters of the invariants. The conditions on abduction answers $\exists \bar{\beta}: A$ are as follows:

1. **relevance condition:** $\mathcal{M} \models \bigwedge_i (D_i \land A \Rightarrow C_i)$,

2. **validity condition:** $\mathcal{M} \models Q: A[\bar{\chi}\ \bar{\delta} := \bar{t}]$ for some $\bar{t}$,

3. **consistency condition:** $\mathcal{M} \models \bigwedge_i \exists \text{FV}(D_i \land A). D_i \land A$,

4. **no escaping variables condition:** for all atoms $c \in A$ such that $\mathcal{M} \not\models Q: c$ and $\text{FV}(c) \cap \bar{\chi} \neq \emptyset$, and for all $\alpha_1 \in \text{FV}(c)$ such that $(\forall \alpha_1) \in Q$, there exists $\alpha_2 \in \text{FV}(c) \cap \bar{\chi}$ such that $\alpha_1 \not\leq_Q \alpha_2$.

   a. **Strong no escaping variables condition** is a stronger variant we use for sorts whose solved forms are substitutions. For all atoms $\alpha_2 \doteq t \in A$ such that $\alpha_2 \in \bar{\chi}$, if $\alpha_1 \in \text{FV}(c)$ such that $(\forall \alpha_1) \in Q$, then $\alpha_1 \not\leq_Q \alpha_2$.

**Definition 4.1.** $\exists \bar{\beta}: A$ is an *answer* to a JCAQP problem $Q: \bigwedge_i (D_i \Rightarrow C_i)$ with parameters $\bar{\chi}$ for model $\mathcal{M}$, written $\exists \bar{\beta}: A \in \text{Abd}(Q; \bar{\chi}; D_i; C_i)$, when $A$ is a conjunction of atoms, $\bar{\beta} \# \text{FV}(\bigwedge_i (D_i \Rightarrow C_i), \bar{\chi})$, meeting the relevance condition, validity condition, consistency condition and no escaping variables condition.

We can also consider Joint Abduction under a Quantifier Prefix problems for a logic, checking relevance condition: $\bigwedge_i (D_i \land A \Rightarrow C_i)$ and validity condition: $Q: A[\bar{\chi}\ \bar{\delta} := \bar{t}]$. The consistency conditions: for all $i$, $D_i \not\models \neg A$, are always met.

The natural setting for constraint abduction problems is with a fixed model. Above we extend the definition to the case where instead of a model just a logic is given, just to shed light on relations between constraint abduction, general abduction, and decision (i.e. validity or satisfiability) problems.

We call a JCAQP problem $Q: D \Rightarrow C$ (i.e. a non-simultaneous problem) a *simple constraint abduction under a quantifier prefix problem* SCAQP. We write $\text{JCAQP}_\mathcal{M}$ to indicate the model.

**Proposition 4.2.** If the $\text{JCAQP}_\mathcal{M}$ problem $Q: \bigwedge_i (D_i \Rightarrow C_i)$ without parameters has an answer, then $\mathcal{M} \models Q: \bigwedge_i (D_i \Rightarrow C_i)$.

We say that $\text{JCAQP}_\mathcal{M}$ answer $\exists \bar{\beta}: A$ is *more general* than $\exists \bar{\gamma}: B$, when there exist terms $\bar{t}$ such that $\mathcal{M} \models B \Rightarrow A[\bar{\beta} := \bar{t}]$.

**Example 4.3.** For a free term algebra $\mathcal{T}(\mathcal{F})$ over signature $\mathcal{F}$ containing binary functors $f, g$ and constants $a, b$, and $\text{JCAQP}_{\mathcal{T}(\mathcal{F})}$ problem $\exists x, y, z: (y \doteq f(a, x) \Rightarrow z \doteq a) \land (y \doteq f(b, x) \Rightarrow z \doteq b)$, the most general answer is $\exists \gamma: y \doteq f(z, \gamma)$. Indeed, $\forall \gamma\ \exists x, y, z: y \doteq f(z, \gamma) \land y \doteq f(a, x)$ holds with $x = \gamma; y = f(a, \gamma); z = a$ and $\forall \gamma\ \exists x, y, z: y \doteq f(z, \gamma) \land y \doteq f(b, x)$ holds with $x = \gamma; y = f(b, \gamma); z = b$. For the $\text{SCAQP}_{\mathcal{T}(\mathcal{F})}$ problem $\exists x, y, z: (y \doteq f(a, x) \Rightarrow z \doteq a)$, the set of maximally general answers is $\{\exists \gamma: y \doteq f(z, \gamma); z \doteq a\}$.

Consider a conjunction of atoms $C$ interpreted in any free term algebra $\mathcal{T}(\mathcal{F})$ over a signature $\mathcal{F}$. If $C$ is satisfiable, let $\mathcal{U}(C)$ be a conjunction of equations whose left-hand-sides are variables not occurring in any of the right-hand-sides, such that $\mathcal{T}(\mathcal{F}) \models C \Leftrightarrow \mathcal{U}(C)$, otherwise let $\mathcal{U}(C) = \bot$. Let $\mathcal{U}(Q: C)$ in case $\mathcal{T}(\mathcal{F}) \not\models Q: C$ be $\bot$, and otherwise be as before but with equations directed so that variables later in the prefix are on the left. $\mathcal{U}(Q: C)$ can be computed by unification with linear constant restrictions, see Baader and Schulz [3]. In effect: if for some $x \doteq t \in \mathcal{U}(C)$ such that $(\exists t) \not\in Q$ (e.g. $t$ is not a variable) and $(\forall x) \in Q$, then $\mathcal{U}(Q: C) = \bot$; if for some $x \doteq t \in \mathcal{U}(C)$ such that $(\exists x) \in Q$, there is a $y \in \text{FV}(t)$, $(\forall y) \in Q$ and $x \not\leq_Q y$, then $\mathcal{U}(Q: C) = \bot$; otherwise $\mathcal{U}(Q: C) = \mathcal{U}(C)$. Let $\mathcal{U}^\chi(Q: C)$ be $\mathcal{U}((Q \setminus \{\forall \bar{\chi}\}) \exists \bar{\chi}: C)$, i.e. $\mathcal{U}^\chi(Q: C) = \mathcal{U}(Q': C)$ where variables $\bar{\chi}$ are existentially quantified in $Q'$ and otherwise $Q'$ is like $Q$. Computing $\mathcal{U}^\chi(Q: A)$ decides the validity condition for $\mathcal{M} = \mathcal{T}(\mathcal{F})$.

**Definition 4.4.** An *abduction algorithm* for $\text{JCAQP}_\mathcal{M}$ with parameters $\bar{\chi}$, $\text{Abd}(Q; \bar{\chi}; D_i; C_i)$, generates a sequence of quantified conjunctions of atoms $\exists \bar{\beta}_j: A_j$, possibly infinite. The algorithm is *correct* if for every $j$, $\exists \bar{\beta}_j: A_j$ is an answer to the $\text{JCAQP}_\mathcal{M}$ problem $Q: \bigwedge_i (D_i \Rightarrow C_i)$ with parameters $\bar{\chi}$. It is *complete* if for every $\text{JCAQP}_\mathcal{M}$ answer $\exists \bar{\beta}: A$, there is a $j$ and some $\bar{t}$ such that $\mathcal{M} \models A \Rightarrow A_j[\bar{\beta}_j := \bar{t}]$ (with variables renamed so that $\bar{\beta} \# \text{FV}(A_j)$). If the sequence is empty, we write $\text{Abd}(Q; \bar{\chi}; D_i; C_i) = \bot$.

Note that we do not require that only maximally general answers are returned. Although this would be preferable, it is costly to guarantee in many constraint domains even with incomplete algorithms.

## 4.2.2 Abduction Algorithm for The Combination of Domains

We provide a plug-in architecture where to add a new sort to the logic it is enough to give an algorithm solving the JCAQP problem. Define an *alien subterm* (cf. [3]) of a term $\tau$ of sort $s_{\text{type}}$ to be a maximally large subterm $t$ of $\tau$ of sort $s \neq s_{\text{type}}$.

Let $L_{ty} = \mathcal{T}(\mathcal{F}, \bigcup_{s \in \text{sorts}} X_s)$ be a language interpreted in a multi-sorted free term algebra $\mathcal{T} = \mathcal{T}(\mathcal{F} \cup \bigcup_{s \in \text{usorts}} D_s)$ which, besides the term variables $X_{s_{\text{type}}}$, has alien subterm variables $\bigcup_{s \in \text{usorts}} X_s$.

Let $Q$ be a quantifier prefix and $D_i, C_i$ be atomic conjunctions in $L$ that form a joint abduction problem $Q: \bigwedge_i (D_i \Rightarrow C_i)$. For the purpose of Theorem 4.5, let $\text{Abd}_s$ be complete JCAQP algorithms for $s \in \text{usorts}$ and $\text{Abd}_\mathcal{T}$ be a complete JCAQP algorithm for the free term algebra $\mathcal{T}$. We start the multi-sorted abduction procedure $\text{Abd}(Q; \bar{\chi}; D_i; C_i)$ by performing $\text{Abd}_\mathcal{T}$ on the $s_{\text{type}}$ part of constraints with alien subterms replaced by variables. For each JCAQP solution $\exists \bar{\beta}_j: A_j$, we replace the $s_{\text{type}}$ part of the $i$th premise by the residual formula $A^p_{ij}$ and of $i$th conclusion by residual formula $A^c_{ij}$, defined in Table 4.1. We split the resulting JCAQP problem into single-sort problems for each sort $s \in \text{usorts}$, and we solve them using $\text{Abd}_s$ algorithms. Finally, we build answers as conjunctions of answers for each sort.

Let $Q$ be a quantifier prefix and $D_i, C_i$ be atomic conjunctions in $L$ that form a joint abduction problem $Q: \bigwedge_i (D_i \Rightarrow C_i)$ with parameters $\bar{\chi}$, and $\forall \bar{\chi} \prec Q$. Let $\text{Abd}_s$ be correct and complete JCAQP algorithms for $s \in \text{usorts}$ and $\text{Abd}_\mathcal{T}$ be a correct and complete JCAQP algorithm for language $L_{ty} = \mathcal{T}(\mathcal{F}, \bigcup_{s \in \text{sorts}} X_s)$ and model $\mathcal{T}(\mathcal{F} \cup \bigcup_{s \in \text{usorts}} D_s)$. We define the algorithm $\text{Abd}(Q; \bar{\chi}; D_i; C_i)$ in Table 4.1. In this algorithm, we separate formulas into single-sorted formulas, we perform abduction for terms, and we perform abduction for other sorts with additional equations due to abduction for terms. The proof of the following theorem is in Section A.2.2.

**Theorem 4.5.** Assume the conditions listed above. Then $\text{Abd}$ meets Definition 4.4 correct and complete algorithm conditions.

Introducing new variables $\bar{r}_j$ puts additional burden on abduction in other sorts. In the current implementation of InvarGenT, we only replace $A^\mathcal{T}_j$ with $A'^\mathcal{T}_j$ in the first iteration, when abduction in other sorts is not performed.

For the details of the implementation, see Section B.2.1.

---

### Table 4.1: Complete multi-sorted abduction $\text{Abd}(Q; \bar{\chi}; D_i; C_i)$

```
let D_i ≡ ⋀_s D^s_i and C_i ≡ ⋀_s C^s_i, where, for s ∈ sorts, D^s_i, C^s_i are atomic conjunctions in L_s.

let D^t_i, C^t_i be formulas D^{s_type}_i, C^{s_type}_i with subterms r_i replaced with fresh variables r̄_i
    (such that r ∈ X_s for r of sort s)
    where r_i are all alien subterms in D^{s_type}_i, C^{s_type}_i

let r̄ = r̄_1...r̄_n, r = r_1...r_n

if D^t_i is not satisfiable for some i, then Abd(Q; χ̄; D_i; C_i) := Abd(Q; χ̄; D_j; C_j | j≠i)
else if C^t_i is not satisfiable for some i, then return Abd(Q; χ̄; D_i; C_i) := ⊥
else let ⋀_s D^t_{i,s} = U(D^t_i), ⋀_s C^t_{i,s} = U(C^t_i) be solved forms of D^t_i, C^t_i

Similarly, discard branches i for which D^t_{i,s} ∧ D^s_i is not satisfiable for some s ∈ usorts.

if Abd_T(Q; r̄χ̄; D^t_{i,s_type}; C^t_{i,s_type}) = ⊥, then Abd(Q; χ̄; D_i; C_i) := ⊥
else let ∃β̄^T_j: A^T_j = Abd_T(Q; r̄χ̄; D^t_{i,s_type}; C^t_{i,s_type})

let A'^T_j be A^T_j with alien subterms replaced by distinct fresh variables r̄'_j, β̄'_j = β̄_j r̄'_j

let A^p_{ij} = {x ≐ t ∈ U(D^t_{i,s_type} ∧ A'^T_j) | x ∈ X_s, s ≠ s_type}
let A^c_{ij} = {x ≐ t ∈ U(D^t_{i,s_type} ∧ C^t_{i,s_type} ∧ A'^T_j) | x ∈ X_s, s ≠ s_type}

let A^i_{p/c,j} = ⋀_s A^i_{p/c,j,s}, A^i_{p/c,j,s} ∈ L_s

let J_s = {j | Abd_s(Q; r̄'_j χ̄; D^s_i ∧ (D^t_{i,s} ∧ A^p_{i,j,s})[r̄ := r]; C^s_i ∧ (C^t_{i,s} ∧ A^c_{i,j,s})[r̄ := r]) ≠ ⊥}

let ∃β̄^{k^s_j}_s: A^{k^s_j}_s = Abd_s(Q; r̄'_j χ̄; D^s_i ∧ (D^t_{i,s} ∧ A^p_{i,j,s})[r̄ := r]; C^s_i ∧ (C^t_{i,s} ∧ A^c_{i,j,s})[r̄ := r]),
    j ∈ ⋂_{s∈usorts} J_s

if for some s ∈ usorts, J_s = ∅, then Abd(Q; χ̄; D_i; C_i) := ⊥

return Abd(Q; χ̄; D_i; C_i) := ∃β̄^{k̄_j}: A^T_j ∧ ⋀_s A^{k^s_j}_s,
    where k̄^s_j is β̄'_j ∩ FV(A^T_j ∧ ⋀_s A^{k^s_j}_s),
    j ∈ ⋂_s J_s, k̄_j is a concatenation of k̄^s_j for s ∈ usorts,
    for j ∈ ⋂_s J_s, k̄^s_j span the cartesian product ×_{s∈usorts} Abd_s of solutions for fixed j
```

---

## 4.2.3 Joint Constraint Abduction

In Table 4.1, we assumed abduction algorithms are returning sequences of answers, from which the answers of interest are extracted. We implement abduction algorithms differently. We maintain a *discard list* — a list of answers to avoid, and the algorithms return the first answer they find which does not imply any answer in the discard list.

Besides the discard list, the simple abduction algorithms take another argument: the partial answer. By starting the search for an answer to an implication from the joint solution to already solved implications, we ensure by construction that the final answer to the joint constraint abduction problem meets validity and consistency conditions. The relevance and no escaping variables conditions would be met regardless of starting from the partial answer. However, the search is greatly facilitated, because simple constraint abduction does not need to rediscover relevant parts of the answers to already solved implications.

Sometimes such rediscovery is not possible. Abduction answer $\exists \bar{\beta}: A$ to $D \Rightarrow C$ is *fully maximal* when $\mathcal{M} \models (\exists \bar{\beta}: D \land A) \Leftrightarrow D \land C$. The notion was introduced by Michael Maher, see e.g. [27], to curb the difficulty of finding all abduction answers. Even equipped only with fully maximal abduction algorithms, by accumulating answers across implications we can still solve problems where some implications do not have fully maximal answers. To this effect, we vary the order in which implications are solved, so that when an implication $D \Rightarrow C$ without fully maximal answers is encountered, the answer $\exists \bar{\beta}_p: A_p$ to previous implications is such that $D \land A_p \Rightarrow C$ has a fully maximal answer. In fact, our simple constraint abduction algorithms go beyond fully maximal answers.

Rather than testing permutations blindly, we use a search scheme which might not capture all opportunities to solve a JCA problem, but detects unsolvable JCA problems earlier. We set aside branches that do not have any answer extending the partial answer so far. After all branches have been tried and the partial answer is not an empty conjunction (i.e. not $\top$), we retry the set-aside branches. If during the retry, any of the set-aside branches fails, we add the partial answer to discarded answers — which are avoided during simple abduction — and restart. Restart puts the set-aside branches to be tried first. If, when left with set-aside branches only, the partial answer is an empty conjunction, i.e. all the answer-contributing branches have been set aside, we fail — return $\bot$ from the joint abduction.

Before starting joint constraint abduction, we separate out negative constraints, as explained in Section 4.3. To ensure the overall consistency and validity conditions without needless backtracking, we pass a validation suite to SCA algorithms. The validation ensures that the partial answers are consistent with all implications of the constraint. That is, we reject the partial answers $A$ such that $\mathcal{M} \not\models \bigwedge_i \exists \text{FV}(D_i \land C_i \land A). D_i \land C_i \land A$.

For the details of the algorithm, see Section B.2.2.

## 4.2.4 Simple Constraint Abduction

JCA problems for most interesting domains are unknown to be decidable, because the corresponding SCA problems are not known to have effective characterizations of the sets of answers. Maher [27] introduces subsets of answers which are more amenable to search: abduction answer $\exists \bar{\beta}: A$ to SCA problem $D \Rightarrow C$ is *fully maximal* when $\mathcal{M} \models (\exists \bar{\beta}: D \land A) \Leftrightarrow D \land C$. We can search for fully maximal answers using various forms of a brute-force approach: starting from an initial candidate $D \land C$ and generalizing until we find a formula, implied by $D \land C$, which meets all conditions for a correct SCA answer and all its further generalizations do not imply $C$. It turns out that fully maximal answers are insufficient. We have come up with two additional ways to introduce initial candidates. One is to add — guess — atoms constraining variables which are already significantly constrained by the premise $D$. The significant constraint condition limits the number of guesses to try. The other way is to decompose the SCA problem $D \Rightarrow C$ into subproblems $d \Rightarrow c$ for atoms $d \in D, c \in C$ and add their answers to initial candidates. In many domains, all maximally general answers to $d \Rightarrow c$ can be easily enumerated. Even considering all initial candidates described in this paragraph does not ensure finding all maximally general answers.

We preprocess the initial SCA answer candidate $C_a$ by trying to eliminate universally quantified variables, using the premise of the SCA problem. We define this preprocessing, separately for the different sorts, as $\text{Rev}_\forall(Q; \bar{\chi}; D; C_a)$. It makes the validity condition of the resulting answer, $\mathcal{M} \models Q: A$, easier to meet. See Dillig, Dillig, Li and McMillan [12] for a similar approach.

### 4.2.4.1 Abduction for Terms

The JAQP problem for first order logic with function symbols and equality is undecidable, because it is equivalent, by Herbrandization, to simultaneous rigid E-unification (see Degtyarev and Voronkov [11]): the substitution that is a solution to simultaneous rigid E-unification when expressed as a conjunction of equations has the same properties as a JCAQP answer (therefore the existence of JCAQP answers coincides with intuitionistic satisfiability).

Remember that outside of Definition 4.1, we use $\models$ as a shorthand for $\mathcal{M} \models$.

The decision problem $\mathcal{T}(\mathcal{F}) \models Q: \bigwedge_i (D_i \Rightarrow C_i)$ is decidable, see Comon [9]. Actually, [9] provides a disjunction as a solution, each disjunct meeting the relevance and validity conditions of the $\text{JCAQP}_{\mathcal{T}(\mathcal{F})}$ problem. It is often the case though that each disjunct does not meet the consistency condition, despite the $\text{JCAQP}_{\mathcal{T}(\mathcal{F})}$ problem considered having answers.

The JCAQP problem for free term algebra $\mathcal{T}(\mathcal{F})$ is unknown to be decidable. A limited form of JCA is to find the fully maximal answers, introduced in [27], using non-simultaneous abduction algorithm from Maher and Huang [29]. [27] refers to [25] as establishing that there are finitely many fully maximal answers. [29] gives an algorithm finding fully maximal answers for simple (i.e. non-simultaneous) constraint abduction problems.

Let us recall why Herbrandization is insufficient and therefore we cannot apply the algorithm from [29] without some adjustments. Take a formula $\exists x: (a \doteq b(x) \Rightarrow x \doteq b(x)) \land \varphi(x)$. In the original model $\mathcal{T}(\mathcal{F})$, the formula is equivalent to $\exists x: \varphi(x)$, because $a \doteq b(x)$ is equivalent to falsehood. However, it is a Herbrandization of $\exists x: (\forall b: a \doteq b \Rightarrow x \doteq b) \land \varphi(x)$, which is equivalent to $\varphi(a)$.

Fully maximal answers are not sufficient for the practical application of joint constraint abduction. Consider a constructor $\text{Pair}: \forall \alpha \beta. \text{Term}(\alpha) \times \text{Term}(\beta) \longrightarrow \text{Term}((\alpha, \beta))$ and a pattern matching branch that we could add to our `eval` function: `| Pair (y1, y2) -> (eval y1, eval y2)`. It leads to an implication:

$$\tau \doteq \text{Term}((\alpha', \beta')) \Rightarrow \gamma \doteq (\alpha'', \beta'')$$

where $\alpha', \beta'$ are universally quantified and $\alpha'', \beta''$ are existentially quantified. The expected abduction answer $\tau \doteq \text{Term}(\gamma) \land \alpha'' \doteq \alpha' \land \beta'' \doteq \beta'$ is not fully maximal because:

$$\tau \doteq \text{Term}((\alpha', \beta')) \land \tau \doteq (\alpha'', \beta'') \not\models \alpha' \doteq \alpha'' \land \beta' \doteq \beta''$$

In the case of `eval`, the inference problem is solved by our JCA scheme even based on fully maximal abduction. But examples from Chuan-kai Lin [22] (for example the `zip2` and `zip1` functions) motivated a development that goes beyond fully maximal answers: guessing equations between variables.

To show how we eliminate universally quantified variables, we slightly abuse notation:

$$S = [\bar{t}_u := t'_u] \text{ for } \text{FV}(t_u) \cap \bar{u} \neq \emptyset; \forall \bar{u} \prec Q \text{ such that } \mathcal{M} \models D \Rightarrow \dot{S};$$

$$S' = [\bar{u}' := t'_u] \text{ for } \bar{u}' \subseteq \bar{u}; \forall \bar{u} \prec Q \text{ such that } \mathcal{M} \models D \land C \Rightarrow \dot{S}';$$

$$\text{Rev}_\forall(Q; \bar{\chi}; D; C) = \{c' \mid c = x \doteq t \in C, \text{ if } x = S'(t) \text{ then } c' = S(c) \text{ else } c' = S \circ S'(c)\}$$

$S$ is a substitution of subterms rather than a regular substitution of variables.

To solve $D \Rightarrow C$ the algorithm from [29] page 13, reproduced in Table 2.5, starts with $\mathcal{U}(D \land C)$ and iteratively replaces subterms by fresh variables $\gamma \in \bar{\beta}$ for a final solution $\exists \bar{\beta}: A$. If the same subterm occurs at multiple positions, we try replacing by the same variable at subsets of these positions. We start from $\text{Rev}_\forall(Q; \bar{\chi}; \mathcal{U}(D \land A_p); \mathcal{U}(A_p \land D \land C))$, where $\exists \bar{\beta}_p: A_p$ is the solution to previous problems solved by the joint abduction algorithm. Optionally, we also substitute-out in the initial candidates, constants $\bar{\delta} := \bar{\gamma}$ when $\bar{\delta} \doteq \bar{\gamma} \in \mathcal{U}(D \land A_p)$. The modification going beyond fully maximal answers, is to consider candidate atoms not implied by $D \land C$, even in the case without an initial partial answer: $A_p = \top$. A natural choice is to consider equations $\chi_1 \doteq \chi_2$ for parameters $\chi_1 \in \bar{\chi}$. To curtail the search space, we limit the choices of pairs $\chi_1, \chi_2$ to cases $A_p \land D \land C \models \chi_1 \doteq \tau_1 \land \chi_2 \doteq \tau_2$ where $\tau_1$ and $\tau_2$ are not variables but are unifiable.

For the details of the algorithm, see Section B.2.3.

### 4.2.4.2 Abduction for Linear Arithmetic

We start with some insights into abduction for linear arithmetic, and then discuss our algorithm. Unlike in term abduction, there is no need to introduce variables.

**Proposition 4.6.** The domain of linear arithmetic has the following quantifier elimination property: for every constraint (i.e. conjunction of atoms) $A$ and variables $\bar{\alpha}$ there exists a constraint $A'$ such that $\mathcal{M} \models (\exists \bar{\alpha}: A) \Leftrightarrow A'$.

With inequalities, it can happen that there are no maximally general answers, there can also be infinitely many maximally general answers outside of fully maximal answers.

The *implicit equalities* $E$ of a conjunction $C$ is a conjunction of equations of biggest rank such that $\mathcal{M} \models C \Rightarrow E$ and $E$ are linearly independent of equations in $C$.

**Proposition 4.7.** ([26] p. 14 Lemma 10) Suppose $D \land C$ has implicit equalities $E$. Then $A \land D \Rightarrow C$ iff $A \land D \Rightarrow E$ and $\tilde{E}(A \land D) \Rightarrow \tilde{E}(C)$.

Consider the SCA problem $x \doteq 2r \land y \doteq 2s \Rightarrow z \doteq 2t$ and a maximally general answer $A = x + y \doteq z \land r + s \doteq t$. It is not fully maximal, because $C \land D$ does not imply any relation between $x, y$ and $z$.

To simplify the search in presence of a quantifier prefix, we preprocess the initial candidates by trying to eliminate universally quantified variables:

$$S = [\bar{\alpha}_u := t_u] \text{ for } \forall \bar{\alpha}_u \prec Q \text{ such that } \mathcal{M} \models D \Rightarrow \dot{S};$$

$$\text{Rev}_\forall(Q; \bar{\chi}; D; C) = \{c' \mid c \in C, \text{ if } \mathcal{M} \models Q: c[\bar{\chi} := \bar{t}] \text{ for some } \bar{t} \text{ then } c' = c \text{ else } c' = S(c)\}$$

We approach solving for equations $c = t_1 \doteq t_2 \in C$ and inequalities $c = t_1 \leq t_2 \in C$ differently. For equations, we construct initial candidates as linear combinations of $c$ and selected equations from $D$. For inequalities, we construct the initial candidates by finding the abduction answers to $d \Rightarrow c$ for each inequality $d \in D$.

To find the abduction answers to $d \Rightarrow c$, pick a common variable $\alpha \in \text{FV}(d) \cap \text{FV}(c)$ or the constant $\alpha = 1$. We have four possibilities:

1. $d \equiv \alpha \leq \tau_d$ and $c \equiv \alpha \leq \tau_c$: the abduction answers are $c$ and $\tau_d \leq \tau_c$,
2. $d \equiv \alpha \leq \tau_d$ and $c \equiv \tau_c \leq \alpha$: the abduction answer is only $c$,
3. $d \equiv \tau_d \leq \alpha$ and $c \equiv \alpha \leq \tau_c$: the abduction answer is only $c$,
4. $d \equiv \tau_d \leq \alpha$ and $c \equiv \tau_c \leq \alpha$: the abduction answers are $c$ and $\tau_c \leq \tau_d$.

Thanks to cases (1) and (4) above, the abduction algorithm can find some answers which are not fully maximal.

To check whether $A \Rightarrow B$, we check for each $b \in B$:

- if $b = x \doteq y$, that $\hat{A}(x) = \hat{A}(y)$, where $\hat{A}(\cdot)$ is the substitution corresponding to equations and implicit equalities in $A$;
- if $b = x \leq y$, that $A \land y < x$ is not satisfiable.

For more details of the algorithm, see Section B.2.4.
