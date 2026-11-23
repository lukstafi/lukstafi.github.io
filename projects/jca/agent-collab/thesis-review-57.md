---
title: "Can a computable size bound suffice for cyclic constructor typings?"
date: 2026-11-23
---

A cyclic value can allocate a single heap node and still have an undecidable typing problem. Give that node six rational indices, a single linear guard, and several recursive fields. A second constructor packages the node at some point of a specified ray. **It is undecidable whether a conjunctive rational polyhedral scheme for the recursive node can type this closed use.** On the positive instances one such scheme suffices. On the negative instances every proposed root on the ray violates the guard after finitely many field selections. The construction uses ordinary datatype declarations, with no recursive function or external primitive. It assumes the unbounded rational index language of the thesis. [Generated programs and exact checks](thesis-review-57.py)

## The source program {#source}

Take rational three-by-three matrices $A_1,\ldots,A_p$. Represent a symmetric three-by-three matrix $Q$ by six phantom indices, in the order $00,01,02,11,12,22$. Write $B_i Q=A_i Q A_i^T$. Each entry of $B_i Q$ is a **linear** expression in these six indices. The products of rational matrix coefficients are computed when generating the source. The constructor and its only ground use have the following form. Here $T(Q)=Q_{00}+Q_{11}+Q_{22}$.

```text
datatype Orbit : num * num * num * num * num * num
datacons Fork : ∀Q[1≤T(Q)]. Orbit (B₁Q) * … * Orbit (BₚQ) ⟶ Orbit Q
let rec ring = Fork (ring,…,ring)

datatype Seen
datacons Observe : ∀n[1≤n]. Orbit (0,0,0,n,n,n) ⟶ Seen
let observed = Observe ring
```

The displayed vector notation expands into the source language's scalar syntax. Let $x=(0,1,1)^T$. The caller opens the scheme at $Q=sxx^T$ for a rational $s\ge1$. A convex scheme $P$ works if and only if it contains one such point, implies $T(Q)\ge1$, and each $B_i$ takes it into itself. In the forward direction, follow the constructor guard and each of its recursive fields. In the reverse direction, write the scheme $\forall Q[P(Q)].\,\mathrm{Orbit}(Q)$ and instantiate each recursive occurrence directly at $B_iQ$. Different fields can use different instances of the same binding. The ground constructor fixes the one common scale at its own use. [Expanded six-index source](scaled_orbit.gadt) · [Cyclic typing rule](thesis-review-56.html#paths)

## Where the matrices come from {#reduction}

Fijalkow et al. reduce infinite Post correspondence to the existence of a closed separating semilinear invariant. An instance consists of pairs of nonempty words $(u_i,v_i)$ over digits $0,2$. A solution is an infinite sequence of tile indices for which the concatenations of the upper and lower words agree. The paper gives three-dimensional rational matrices for which the following dichotomy holds. We use column vectors and transpose the paper's row-vector matrices. [Fijalkow et al., Theorem 3.1 and Lemmas 4.1–4.3](https://people.mpi-sws.org/~joel/publications/Monniaux-JACM25.pdf)

For a word $u$, let $[u]$ be its base-four fraction. Tile $(u,v)$ sends $(a,b,c)$ to
$$
 (a+[u]b-[v]c,\;4^{-|u|}b,\;4^{-|v|}c).
$$
Starting at $x$, the last two coordinates stay positive. If an infinite match exists, the vectors along its prefixes tend to zero. For every finite scale $s$, the traces $T(szz^T)=s\lVert z\rVert^2$ along that word therefore fall below one. No typing that respects every recursive field can satisfy the closed use.

In the other case the paper constructs a finite depth $N$ and a rational $\alpha>0$. Every vector reached at depth $N$ already lies in one of the two polyhedra
$$
 C_\pm=\{(a,b,c): b,c\ge0,\quad \pm a\ge \tfrac23(b+c)+\alpha\}.
$$
Each tile preserves each of these polyhedra individually. Indeed $[u]\le\tfrac23(1-4^{-|u|})$, with the corresponding inequality for $v$. Subtracting the largest possible loss from $\pm a$ leaves the required margin at the child. Adjoin one singleton for every prefix of length less than $N$. The resulting finite family contains the start, and every tile sends each member entirely into one member. It matters that the whole member has a common destination. A general invariant union need not have this property. [Construction of the two regions](https://people.mpi-sws.org/~joel/publications/Monniaux-JACM25.pdf)

## One convex scheme for the positive instances {#convex}

Taking the convex hull of the two sign regions in the original coordinates could introduce the origin. To retain the separation, take symmetric products *within each region* before combining their generators. For vectors $z,w$ put $z\odot w=(zw^T+wz^T)/2$. Its trace is $z\cdot w$. The map $(z,w)\mapsto z\odot w$ is bilinear, and $B_i(z\odot w)=(A_i z)\odot(A_i w)$.

Homogenize each member of the finite family, writing its cone in coordinates $(z,h)$ with $h\ge0$. For a singleton $v$ this is the ray through $(v,1)$. For $C_\pm$, replace $\alpha$ by $\alpha h$ in the displayed inequalities. Each cone has finitely many rational generators. For every pair $(z,h),(w,k)$ of generators from the **same** cone, include $(z\odot w,hk)$ in a list in seven dimensions. Let $K$ be the cone generated by the whole list.

1. $K$ contains $(xx^T,1)$. It comes from the singleton for the empty prefix.
2. The map $(Q,t)\mapsto(B_iQ,t)$ preserves $K$. Both generators of a pair go into a common destination cone under $(z,h)\mapsto(A_i z,h)$. Expand each image in its destination generators. Bilinearity expresses their product as a nonnegative combination in the list.
3. There is a rational $\delta>0$ such that $T(Q)\ge\delta t$ on $K$. For a sign cone the first coordinates have a common sign and absolute values at least $\alpha h$ and $\alpha k$. The other coordinate products are nonnegative. Thus $z\cdot w\ge\alpha^2 hk$. For a prefix ray the corresponding bound is $\lVert v\rVert^2 hk$. Each of the finitely many prefix norms is positive. Take the minimum of their squares and $\alpha^2$.

Fix a rational $s\ge\max(1,1/\delta)$. The slice $P=\{Q:(Q,s)\in K\}$ is one rational polyhedron. It contains $sxx^T$, is closed under every field map, and proves $T(Q)\ge1$. A rational half-space description of this slice gives the promised source scheme. The slice may contain matrices that could never be written as $zz^T$. The trace inequality holds on those matrices too. This completes the reduction. The undecidability enters through the infinite word problem. The passage to six indices and one conjunctive guard uses the invariant regions and the symmetric-square construction above. [Lean verification of the tile, cone and trace identities](thesis-review-57.lean)

There is also a direct witness for each recursive call. Name the generators $g_1,\ldots,g_m$ and write $(Q,s)=\sum_j w_jg_j$ with $w_j\ge0$. For each tile, express the image of each generator as a nonnegative rational combination of generators. Collect those coefficients in a matrix $W_i$. The child can take $W_iw$ for its private witnesses at every root simultaneously. This gives an alternative certificate that can be checked by matrix multiplication and signs before eliminating the weights. The replay extracts such coefficients and verifies their identities in exact rational arithmetic. [Witness replay](thesis-review-57.py)

### Two recursive fields suffice {#binary}

To fix the arity at two, use $p$ blocks of six indices. One field rotates the blocks, and the other applies the block-diagonal matrix with $B_i$ at position $i$. Place the start in the first block, with zeros elsewhere. Use the sum of the block traces for the guard. Rotations can move the occupied block to any desired tile before each matrix application. Thus a failing word still gives a finite guard failure. Given a positive certificate $P$, embed one copy of $P$ in each block with the other blocks zero. The closed convex hull of their union is a rational polyhedron. Rotation permutes the copies, and the block-diagonal map preserves each copy. The closed linear guard holds on their closed convex hull. This gives two fields and $6p$ indices, with $p$ fixed by the word-problem reduction. The six-index construction itself uses one field per tile. [Original two-matrix construction, Corollary 3.3](https://people.mpi-sws.org/~joel/publications/Monniaux-JACM25.pdf)

## What a size promise buys {#bound}

**No computable function of the input size bounds even the number of facets needed on all positive instances of this construction.** Suppose $f$ gave such a bound. Use $f$ rows with unknown real coefficients $C,d$, allowing redundant rows. Decide the following first-order formula over real closed fields, where $P(Q)$ abbreviates $CQ\le d$.
$$
 \exists C,d,s\;\bigl(s\ge1\ \land\ P(sxx^T)\ \land\
 \forall Q\,[P(Q)\Rightarrow (1\le T(Q)\ \land\ \bigwedge_i P(B_iQ))]\bigr).
$$
On the positive instances the assumed rational certificate makes the formula true. On the negative instances even a real scale and a real invariant cannot survive the shrinking orbit. Quantifier elimination would therefore decide the infinite word problem. The argument allows arbitrarily large coefficients. In fixed ambient dimension, lower-dimensional polyhedra can be described by adding at most twelve inequalities for their affine hull. [Real closed field decision procedure](https://www.rand.org/pubs/reports/R109.html)

A *supplied* facet budget still defines a finite-dimensional real feasibility problem. A supplied bit bound on rational answers also permits an exact enumerative procedure with linear checks on each candidate. The theorem rules out a universal computable completeness budget for this source class. In particular, a known bound can justify a separate bounded search. Proving that Table 4.4 itself visits an available bounded solution would require a property of its updates. The caller here chooses a scale. The next construction fixes the caller completely, using eight indices at one node or six at the largest of two nodes. [Fixed-caller proof](thesis-review-58.html#fixed) · [Two-node construction](thesis-review-58.html#coverage) · [Exact finite-direction inference](thesis-review-56.html#affine)

## A jump the compiler can already check {#jump}

For a concrete caller ray there is a short sufficient construction. Decompose a guard row $a$ into rows $a=\sum_j r_j$ such that $r_j B_i=\lambda_{ij}r_j$ for every field, with $0\le\lambda_{ij}\le1$. The replay finds candidate rows by rational spectral projection and verifies each identity. Write the root as $sQ_0$. Take $b_j=r_jQ_0$ for a row fixed by all fields, and $b_j=\min(0,r_jQ_0)$ for the other rows. The inequalities $r_jQ\ge s b_j$ hold at the root and are preserved by every field. In the second case a nonpositive lower bound survives multiplication by any factor between zero and one.

Choose a rational $s\ge1$ for which $s aQ_0\ge1$ and $s\sum_j\lambda_{ij} b_j\ge1$ at every field. Then $aQ\ge1$ together with the component inequalities is an inductive scheme. The guard holds at the root by the first check. Each child proves it by summing its component bounds. All these checks are linear once the rows are given. A failed decomposition or scale test leaves the instance open.

For the two tiles $(2,0)$ and $(22,0)$ the construction finds four components of the trace, five inequalities in the scheme, and scale $9/2$. A driver synthesizes the annotation from the matrices and the caller, checks closure independently, then asks InvarGenT to type the value at exactly that scale. The unannotated compiler used for this experiment missed this caller. A subsequent compiler infers the sharp scale $8/3$ by leaving the bounds available for instantiation at the binding. [Native inference at the sharp boundary](thesis-review-58.html#compiler) · [Synthesizer and compiler replay](thesis-review-57.py) · [Native solver for finite guard directions](thesis-review-56.html#affine)

## Replaying the construction {#replay}

The Python companion expands the matrices into actual InvarGenT source and checks finite generator certificates with rational arithmetic and Z3. Its examples include both sign cones and a match that survives the first tile. For tiles $(2,0)$ and $(22,0)$, the linear expression $a+2b/3$ is invariant. Its square supplies a linear equality in the six indices. At scale nine this equality reads $Q_{00}+4Q_{01}/3+4Q_{11}/9=4$. InvarGenT accepts the explicit scheme and the closed use. The emitted OCaml has two fields that both point back to the root. The driver also checks the independently synthesized scheme above. A second instance contains the tile $(0,0)$, whose repeated application divides the trace on the start ray by sixteen. The negative control checks rejection. [Runnable annotated programme](scaled_orbit.gadt)

```sh
python3 thesis-review-57.py --compiler /path/to/InvarGenT.native
```
