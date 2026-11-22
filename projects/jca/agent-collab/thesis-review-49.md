---
title: "How can a negative branch determine an oblique guard?"
date: 2026-11-22
---

A datatype has live constructors at $(1,0)$ and $(0,1)$ and a forbidden constructor in the quadrant $i\le0,\ j\le0$. Requiring $i>0$ loses the second live case. Requiring $j>0$ loses the first. InvarGenT now infers $i+j\ge1$. Adding the opposite forbidden quadrant $i\ge1,\ j\ge1$ leads it to infer $i+j=1$. The generated OCaml runs both admitted calls in both programs. [Four source examples](oblique_guard.gadt) · [Earlier face search](thesis-review-48.html#compiler)

## One inequality per forbidden cell {#faces}

Fix the public rational indices. Each live validation state $L_i$ must retain a witness. The guard must exclude every point of each forbidden polyhedron $B_j$. All cells use rational, weak affine constraints. Project private rational coordinates existentially and split finite alternatives. A live state may give a union of cells from which one witness suffices. Discard empty forbidden cells. An empty live state makes the problem infeasible.

**A shared tuple characterizes existence.** A conjunctive affine guard exists iff one can choose $p_i\in L_i$ such that $\operatorname{conv}\{p_i\}$ misses every $B_j$. Every successful guard contains that hull. Conversely the hull of finitely many rational points is a rational polytope. It is itself a guard. There is also an answer with **one inequality per forbidden cell**. If $B_j$ has rows $A_jx\le b_j$, find $\lambda_j\ge0$ such that
$$
   \lambda_j(A_jp_i-b_j)\ge1\qquad\text{for every }i .
$$
The guard consists of those same inequalities with $x$ in place of $p_i$. For necessity, apply Farkas' lemma to the infeasible intersection of the hull and $B_j$. A nonnegative combination of the forbidden rows separates the hull with a strict gap, which can be scaled to one. Once the $p_i$ are fixed this is ordinary rational linear feasibility, independently for each $j$. The *same* points must work for every $j$. With no live states the empty guard region suffices, and with no forbidden cells the whole space suffices. [Farkas' lemma](https://people.math.carleton.ca/~kcheung/math/notes/MATH3801/04/4_1_farkas_lemma.html) · [Witness quantifiers](thesis-review-49.lean)

The row count is sharp even in two public dimensions. Take all vertices of a strictly convex rational polygon as singleton live states. For each edge move its midpoint a small rational distance outwards to make a forbidden singleton. The midpoint of any two original edge midpoints is strictly inside the polygon. Finitely many pairs allow a small enough displacement that all these pairwise midpoints stay inside. Every guard containing the vertices must contain them. A single weak inequality cannot reject two forbidden points whose midpoint it admits. The polygon's own edge inequalities attain the bound. This counts rows written on the public coordinates. [Counting proof](thesis-review-49.lean) · [Exact rational polygons](thesis-review-49.py)

With the witnesses unknown, the displayed system is existential and bilinear. It gives a decision procedure for this entire finite guard problem over the rationals. Use real closed field decision on the real system. A real solution has strict positive separation at all chosen witnesses. Keeping the real multipliers, move each witness slightly to a rational point in the same live component. Rational points are dense there, including on lower-dimensional rational polyhedra, and finitely many strict inequalities remain true in a neighborhood. Rescale to restore unit gaps. With the points fixed the multiplier systems are feasible rational polyhedra and have rational solutions. The reverse implication is immediate. A positive real decision can therefore be followed by fair rational witness enumeration and linear certificate checks. This argument bounds the number of rows. It supplies no polynomial bit bound on the general joint witnesses and proves no convergence theorem for recursive Table 4.4 updates. [Dense-witness lemma](thesis-review-49.lean) · [Real algebraic decision procedures](https://www.math.purdue.edu/~sbasu/raag_survey2011.pdf) · [Coefficient synthesis in invariant inference](https://theory.stanford.edu/~sipma/papers/cav03.html)

## Computing a separator in coefficient space {#dual}

For a cell $S$ let $D(S)$ be the coefficient pairs $(a,c)$ for which $a\cdot x+c\le0$ throughout $S$. Farkas multipliers for the cell equations are unrestricted and those for weak inequalities are nonnegative. Equating the linear coefficients and bounding the constant gives a linear system. Project its multipliers out. The resulting polyhedral cone describes $D(S)$ exactly. For a union, intersect the cones of its nonempty components.

A single positive side $a\cdot x+c>0$ hits every live state and misses every forbidden cell iff $(a,c)$ belongs to all forbidden validity cones and lies outside each live validity cone. The complements are finite disjunctions of strict linear tests. All rows are homogeneous, so a common rescaling can give the selected violations unit gaps. Once a direction is selected, the finitely many live witnesses have a common positive rational margin in the original coordinates. For one convex forbidden cell, the one-row theorem makes this test complete for arbitrary conjunctive guards in exact arithmetic. [Validity-cone equivalence](thesis-review-49.lean) · [Common-margin lemma](thesis-review-48.lean)

For several cells, fix some of the live witnesses. Each forbidden cell now has a polyhedron $K_j$ of possible separator coefficients, valid on $B_j$ and reaching at least one at all the fixed points. For another point $x$, the obstruction from cell $j$ is
$$
   \forall (a,c)\in K_j,\quad a\cdot x+c\le0 .
$$
This is a *polyhedral region in $x$*. Apply the same Farkas projection to $K_j$ with coefficient vector $(x,1)$ and zero constant. A possible last witness must lie in its live region and outside all these obstructions. This is a Boolean linear test even when there are many forbidden cells. Once $x$ is chosen, positive evaluations at $x$ can again be scaled to one while keeping all earlier unit margins. Thus a single continuously movable live witness after fixed points requires no grid search. [Last-witness theorem](thesis-review-49.lean)

## What the compiler infers {#compiler}

InvarGenT revision `4d2075a` keeps the earlier guard when it passes validation. On failure it tries the common separator and the individually chosen separators. It checks their full conjunction. If the live witnesses disagree, it chooses common points, keeps the feasible coefficient systems, and solves the last witness symbolically. Each fixed point can discard a whole search branch as soon as one coefficient system becomes empty. Before selecting points the compiler projects away local indices and drops live regions containing an already required smaller one. A witness in the smaller region serves both. This matters in the source examples where two unconstrained validation states would otherwise consume the last symbolic step.

When several witnesses remain free, the search tries feasible endpoints, midpoints and rational coordinates of increasing numerator and denominator. A rational tuple appears at finite height in ideal exact search. The compiler uses its existing numeric abduction budget and representable coefficients. Its final check replays the proposed guard against all original live states and forbidden branches.

Two further examples show why choosing witnesses jointly matters.

- A constructor fixes $(3,3)$ and another can have indices $(-t,-2t)$ for $0\le t\le1$. The forbidden points are $(0,-1)$ and $(2,2)$. InvarGenT infers the line $7j=8i-3$. It keeps the fixed point and selects $t=1/2$ for the flexible constructor.
- Fix $(0,0)$ and let the tip be $(2,2t)$ for $0\le t\le1$. At $x=1$ forbid the point $y=0$ and the interval $1/q\le y\le1$. Convexity forces the midpoint $(1,t)$ into every guard keeping these two witnesses. Thus $0<t<1/q$ is necessary, and the line $y=tx$ suffices for each such choice. In lowest terms the denominator of $t$ exceeds $q$. A grid-height search can therefore take exponentially many heights in the bit length of $q$. With $q=2^{20}$ the compiler infers $y\le1/(2q)$ and $x\le4q y$. These bounds keep the origin and precisely $y=1/(2q)$ at the tip. Closing the window makes the joint witness problem infeasible. [Source and controls](thesis-review-49.py) · [Denominator lemma](thesis-review-49.lean)

## Reproducing the checks {#checks}

Positive branches ask for a hypothesis that proves a required inequality for every hidden payload. Two independent bounds on the payload can determine an exact caller guard, and some guards require a disjunction. [Abduction from several premises](thesis-review-54.html#bounds)

Run the [Python replay](thesis-review-49.py) with `z3-solver`. It compares a generator-based linear oracle for one forbidden cell with a bilinear oracle on 48 overlapping cases. The native comparison covers 322 single-cell and 414 multi-cell problems. The preceding compiler misses 161 feasible instances in this batch. Build the [numeric driver](thesis-review-48-guards.ml) and pass `--driver` and optionally `--before-driver`. With `--compiler` the replay executes eight admitted calls and checks rejection of seven forbidden ones. Pass `--before` to reproduce the earlier rejection. The [Lean file](thesis-review-49.lean) checks the witness, density, face-count and window lemmas.
