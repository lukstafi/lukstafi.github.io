---
title: "Recovering a cap from two constructors"
date: 2026-11-22
---

One constructor returns zero. The other returns a nonnegative $u\le m+19$. Together they guarantee $u\le\max(0,m+19)$. InvarGenT used to lose $m$ on this program, even though it inferred the cap when a single constructor stated the same bound. The solver now recovers $m$ from the two branches and instantiates it at the recursive call. With a caller limit $\max(0,m+20)$, the symbolic child call at $m+d$ gets the exact precondition $d\le1$. [Original split program](split_capped_climb.gadt) · [Proof of the shift threshold](thesis-review-6.html#boundary)

## Where a constructor can violate a bound {#coverage}

Suppose the last postcondition contained an arm $r\le k$. At the next pass, try $u\le k$ on the *definition's* result coordinate $u$. Pair it with an affine supplier bound $u\le f(m)+s$. Which offsets $s$ can the suppliers justify?

**Residual test.** For supplier regions $P_i$, the candidate is valid exactly when

$$
\forall i,m,u.\quad P_i(m,u)\land u>k\ \Longrightarrow\ u-f(m)\le s.
$$

Every result at or below $k$ already satisfies the constant arm. Every result strictly above $k$ needs the affine arm. With $k=0$, replacing the strict test by $u\ge0$ would reject the desired cap. The zero constructor at $m=-20$ would then have to prove $0\le-1$. This test also commutes with projecting away private variables whenever the constant arm uses only public coordinates. [Lean proofs](thesis-review-7.lean)

A single supplier region can need both arms. On the line $u=m$, every point satisfies $u\le0\lor u\le2m$. Positive $m$ needs the second arm and negative $m$ needs the first. Testing whether each whole region entails one arm would miss this valid formula. InvarGenT checks the disjunction on each projected region by searching for a point where both arms fail.

The implementation transfers the sign and constant of a one-variable arm from the previous answer. It takes the result variable and the affine expression from the definition's supplier faces. Every variable must be in scope, and every feasible supplier region must prove the resulting atom. A third supplier that may return $u=1$ for arbitrary $m$ defeats the candidate at $m=-20$. A regression exercises this case with different variable names at the use and the definition. The search retains the existing limit on the number of extrema.

## A bound can become redundant during abduction {#feedback}

In the direct call at $m+1$, the child promises $r\le\max(0,m'+19)$. One branch of numeric abduction established $m'=m+1$. Another branch had already requested $r\le\max(m+20,0)$ from the caller. Once the equation was available, the child promise proved the whole request. The old solver still sent the request back to the postcondition. Simply reversing the printed order of the two max arguments could change whether inference finished.

The repaired solver checks the completed positive numeric answer before splitting it among predicates. It tries deleting a provisional non-equational atom, keeping the equations that connect the actual call arguments. It commits a deletion only if the remaining answer proves every original numeric implication. The implementation applies this pass to answers containing a disjunctive inequality, with no negative branches or discarded numeric answers. Separate checks still govern those cases. A failed deletion stays failed when further assumptions are removed, so each eligible atom needs only one attempt. This gives deletion minimality among those atoms, conditional on a valid starting answer. [Deletion lemma](thesis-review-7.lean)

For offsets $(19,20),(3,5),(0,0),(-2,-1)$ the split supplier inferred $d\le L-c$. Reflecting every numeric index gives a minimum and the reversed precondition $d\ge c-L$. For each of the eight configurations, the driver tests the boundary, one shift inside, and one outside. The solver accepted and executed all 16 safe calls and rejected all eight unsafe calls. [Executable matrix](thesis-review-7-calls.py)

## When simplification is allowed to forget a constraint {#pruning}

Under $n=\max(x,y)$, asking for $n+1\le\max(x,y)$ is impossible. The old pruning routine could erase that requirement, leaving an empty conjunction. It used the wrong sign on the face where one extremum arm is zero. A second route to the same error let an inequality derived from a disjunction serve as a premise for its own deletion. Some legal numeric formulas, including extrema whose two normalized arms share no variable, could also trigger an assertion.

There are two distinct logical obligations. If $F$ simplifies to $R$ under guard $G$, then $G\models F\leftrightarrow R$. If $R$ is an *initial supplier generalization*, $G\models F\Rightarrow R$ suffices. For example, a supplier summary forcing $x=y=0$ can safely generalize to $y=\max(0,x)$. Ordinary simplification must preserve the restriction to zero. Subsequent widening still has its own supplier and caller checks.

InvarGenT now checks the appropriate implication or implications on changes involving extrema. If the proposed simplification fails the check, it keeps the input formula. In a fixed sample of 4,000 rational-arithmetic judgments, the previous implementation changed the truth of 853 guarded formulas and raised exceptions on a further 354. Revision `3ba298f` had zero discrepancies and zero exceptions on the same inputs. Extending the sample to 12,000 judgments at revision `6642c67` also gave zero discrepancies and zero exceptions. The oracle asks Z3 whether any valuation satisfies the guard and distinguishes the input from the output. [OCaml driver](thesis-review-7-pruning.ml) · [Z3 comparison](thesis-review-7.py)

The capture and abduction changes are in InvarGenT `f5e4fcc`, followed by the pruning repair in `3ba298f`. Lean 4.19.0 checks the accompanying lemmas. The OCaml 5.3.0 compatibility build passed 270 OUnit cases with 10 marked TODO. All 127 previously generated signatures matched byte for byte. The split fixture also passed in the OCaml 5.5.1 compatibility build. To reproduce the oracle comparison, compile the OCaml driver as `src/Audit.ml` in the solver build and pass its binary to the Python comparison with `z3-solver` installed.

Letting the floor move at each call gives an exact maximal domain and a new bounded-size convergence counterexample. [When both ends of a recursive result interval move](thesis-review-8.html)
