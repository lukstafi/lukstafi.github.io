---
title: "How large a type does one quadratic guard orbit need?"
date: 2026-11-23
---

One two-index constructor separates three meanings of a bound on solution size. A public conjunction needs exponentially many facets in the length of the caller. A lifted conjunction with a single affine update for all private witnesses also needs exponentially many inequalities. If each child can open its private witnesses afresh, a polynomial-size type suffices. InvarGenT now infers the small type directly from the unannotated binding and its callers.

## Points of contact force public facets {#size}

Use rational indices $(z,x)$, require $x\ge0$, and give the recursive field the update
$$
T(z,x)=(z-1,x-2z+1).
$$
The caller asks for $(N,N^2)$ with $N$ a positive integer written in binary. At depth $k$ the second index is $x-2kz+k^2$. For this caller it equals $(N-k)^2$. Replacing $N^2$ by $N^2-1$ first violates the guard at step $N$.

Any inductive typing of the caller contains the points $(j,j^2)$ for $0\le j\le N$. Its safety at depth $j$ puts the whole type in the half-plane $x\ge 2jz-j^2$. The point $(j,j^2)$ is on that supporting line. A public polyhedron typing the caller has full dimension because the forward orbit contains three noncollinear points. Every contact therefore lies on some facet. A line intersects the parabola in at most two distinct points, so at least $\lceil(N+1)/2\rceil$ facets are necessary. This lower bound concerns **any** typing covering the one caller, including types that give up other safe callers.

For an upper bound impose $z\le N$ and retain the tangents $x\ge 2kz-k^2$ for $0\le k\le N$. The child satisfies the cap. Its first $N$ tangents are parent tangents with $k$ increased by one. The last follows from the tangent at $N$ since $z\le N$. This type, denoted $H_N$, covers every safe caller on the capped half-plane. No greatest public polyhedral type exists across all caps. Such a type would have a facet through each of infinitely many parabola contacts.

## A short type with fresh child witnesses {#fold}

Write $g_N(z)=\max_{0\le k\le N}(2kz-k^2)$ with integer $k$. For $N=2c$ the substitution $k=c+j$ gives
$$
g_{2c}(z)=2cz-c^2+g_c(|z-c|).
$$
The two signs of $j$ account for the absolute value. The function $g_c$ is nondecreasing. Thus $x\ge g_{2c}(z)$ is equivalent to the existence of a rational $u$ with $u\ge z-c$, $u\ge c-z$, and $x-2cz+c^2\ge g_c(u)$. A feasible choice is $u=|z-c|$. Repeat down to $g_1(u)=\max(0,2u-1)$.

For $N=2^m$ the type has $m$ private indices, $2m+3$ inequalities including the cap, and polynomial binary encoding length. The cap at the caller gives $H_N$. Each child computes its own tight absolute values from its *new public indices*, so the folded type inherits the public induction proof. The signs can change at every fold. On the native example $N=1024$, the lower bound is **513 public facets**, and the inferred type has **ten private indices and 23 inequalities**. [Projection and child-opening replay](thesis-review-66.py)

## What if every opening must be one affine map? {#affine}

Let a lifted polyhedron have $s$ inequalities and one affine update taking every admitted public/private tuple to an admitted child. Include a constant one alongside the $s$ nonnegative slacks. By affine Farkas, every next slack is a nonnegative affine combination of the current slacks and one. The same holds for the public guard slack $x$. Equalities can be eliminated on the affine hull. Choosing one opening for the caller now gives a nonnegative matrix realization of $(N-n)^2$ of dimension $d\le s+1$. This is the stronger witness requirement in which one update works on the entire lift. [Polyhedral typings and positive realizations](thesis-review-65.html#realization)

The support of a nonnegative realization is the set of lengths of walks from a positive initial coordinate to a positive output coordinate along positive matrix entries. Its only missing length here is $N$. Choose an accepted length $L>N+d$ congruent to $N$ modulo $\operatorname{lcm}(1,\ldots,d)$. Its walk visits a vertex on a cycle of length $p\le d$, by taking the first repeated vertex. Shorten the part before that vertex and the part after it separately, preserving their endpoints and lengths modulo $p$. The graph with vertices augmented by a residue modulo $p$ has $dp$ states, so each shortest part has length at most $dp-1$. Their concatenation has length at most $2dp-2$ and is still congruent to $N$ modulo $p$. If $N\ge2d^2$, insert copies of the cycle to obtain a walk of length $N$, a contradiction. Hence $s+1>\sqrt{N/2}$. For a binary caller this too is exponential. Results on the last zero of an impulse response give stronger quantitative bounds for positive realizations. [Nagy and Matolcsi on realization dimension](https://real.mtak.hu/7969/)

Fresh openings evade this bound because a fold chooses its sign from the new indices. The example rules out a uniform polynomial public-facet bound and a uniform polynomial bound for a single affine witness update. Whether polynomial-size typings with unrestricted fresh linear witnesses suffice for every positive one-field instance remains open here. The general one-field existence decision requires no such promise.

## What the compiler recognizes {#compiler}

Let $g\le0$ be the written guard, $T$ its affine field pullback, and $\Delta=T-I$. If $\Delta^2g=-D$ is a negative rational constant, compute
$$
x=-2g/D,\qquad z=1/2+\Delta g/D.
$$
These affine observations satisfy exactly the update above. The compiler can recover them even when the sources use translated or mixed coordinates. A typable polyhedral caller must have bounded $z$ above. Otherwise on a recession ray $z$ grows linearly, the lower bound on $x$ grows quadratically, and the caller supplies only linear growth. Likewise every recession direction must have nonnegative $x$ increment, by the root guard.

Project each caller to this $(z,x)$ plane. Splitting along the coordinate axes makes each cell pointed, even for callers with lines. Enumerate the feasible intersections of boundary lines and the feasible boundary directions of the cells. At each vertex the most demanding tangent occurs at the nonnegative integer nearest to $z$. The ray tests above and these finite vertex tests decide safety on the whole caller by convexity. Choose one power-of-two cap covering all the vertices across callers. InvarGenT builds the corresponding folds and preserves its earlier inferred type when choosing an improvement. Its projection, arithmetic and search routines have finite budgets. A written fold of this shape can be checked by matching all of its rows, up to renaming, order and positive scaling, without expanding the public facets.

For the two-index source the previous compiler admitted $(1,1)$ and rejected $(2,4)$ at the unannotated binding. The updated compiler infers the folded scheme at $(1024,1048576)$, through a plain alias, with an unbounded ray and a second two-dimensional caller family. Independent linear-arithmetic checks compare the projection with every literal tangent and verify the fresh child openings for powers of two through 128. The native replay compares the binding and its alias with the folded formula through $N=262144$ and rejects the unannotated program at each corresponding late violation. For a separately written ten-fold annotation followed by an incompatible ground alias at $N=1024$, the generic alias checker exceeded a four-second cutoff. Rejection time for that written path remains unresolved. The graph replay enumerates 4,674 graph/start/end combinations through three vertices. [Executable checks and source generator](thesis-review-66.py) · [Single-field decision](thesis-review-65.html#decision)

```sh
python3 thesis-review-66.py
python3 thesis-review-66.py --source 10
python3 thesis-review-66.py --compiler /path/to/InvarGenT.native
```
