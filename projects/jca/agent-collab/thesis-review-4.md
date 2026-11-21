---
title: "What it takes to prove a min or max postcondition"
date: 2026-11-21
---

Take $x=a=0$ and $b=1$. InvarGenT’s original numeric implication checker accepted $x=\max(a,b)$. The answer matters when a caller asks whether its requirements on a recursive result already follow. Checking equality with one of the two arguments establishes only half the claim. [Numeric abduction in the thesis](../lukstafi-phd-thesis.pdf#page=121) · [Original checker](https://github.com/lukstafi/invargent/blob/772b9b45b31ac11ef2a0d8e88b391db21d55eaa5/src/NumS.ml#L1272-L1373) · [The induction jump that uses numeric implication](thesis-review-3.html#repair)

## Two meanings for a pair of affine forms {#meaning}

InvarGenT represents an extremum equality by two affine forms $u,v$ with $\max(u,v)=0$. For $x=\max(a,b)$, take $u=a-x$ and $v=b-x$. Both must be nonpositive and at least one must vanish. The row $(x,a,b)=(0,0,1)$ has $u=0$ but $v=1$. The same bug occurs for a minimum after reversing the signs. [Numeric representations](https://github.com/lukstafi/invargent/blob/772b9b45b31ac11ef2a0d8e88b391db21d55eaa5/src/NumDefs.ml)

The other representation expresses $\min(u,v)\le0$. Either arm being nonpositive suffices. The original substitution routine applied the zero test for an extremum equality to this representation too. For example, $\min(0,2)\le1$ has arms $-1$ and $1$. The first arm satisfies the inequality. Discarding it as a nonzero constant forces $1\le0$ and can make a feasible guard look contradictory. The repaired substitution checks equality to zero or nonpositivity according to the atom. It uses the full solved substitution, including bindings inherited from an earlier call. [Original propagation code](https://github.com/lukstafi/invargent/blob/772b9b45b31ac11ef2a0d8e88b391db21d55eaa5/src/NumS.ml#L1167-L1195)

## Testing implication on a linear branch {#implication}

Let $P$ be a conjunction of linear equations and weak inequalities over the rationals. For each conclusion in the table, try adding the displayed strict constraints to $P$. The conclusion follows exactly when each listed system is infeasible.

| Conclusion | Counterexamples to exclude |
|---|---|
| $w\le0$ | $w>0$ |
| $w=0$ | $w>0$, or $w<0$ |
| $\max(u,v)=0$ | $u>0$, or $v>0$, or the joint system $u<0\land v<0$ |
| $\min(u,v)\le0$ | The joint system $u>0\land v>0$ |

Joint feasibility matters. For any $x$, $\min(x,-x)\le0$. Each of $x>0$ and $-x>0$ has a witness on its own, but no witness satisfies both. A solver that insists on picking one fixed nonpositive arm misses the implication. The four tests in the table follow by negating their conclusions. The implementation reuses the strict linear solver for inequality and extremum conclusions. For an ordinary equality, it can read the same information more cheaply from the projected bounds.

A premise can contain its own extrema. To see why those branches matter even for a linear conclusion, assume $\min(x,y)\le z$ and $y\ge z+1$. The alternative $y\le z$ is impossible, so $x\le z$. The earlier checker skipped premise alternatives when the conclusion was linear. The repair first tries the linear part of the premise, which is cheaper and sound when it succeeds. Otherwise it visits the alternatives depth first, closing an infeasible branch as soon as it finds a contradiction and stopping at the first feasible counterexample. This avoids allocating every branch combination in advance. Worst-case proof search can still visit all combinations.

### Reading an equality from the bounds {#affine-hull}

In a Fourier–Motzkin projection, the lower and upper bounds for one variable $x$ are affine functions of the remaining coordinates $y$. For fixed $y$, the feasible values of $x$ form an interval. To recover the affine equations of a nonempty rational polyhedron, visit the variables in reverse elimination order. Reduce its lower and upper bounds by the equations already found on $y$. If a lower and an upper bound become the same affine form $h$, then $x=h(y)$ throughout the polyhedron.

Why does this find every new affine equation in an exact projection? Such an equation either concerns only $y$, or it makes the entire fiber a singleton for every $y$. In the latter case take $y$ in the relative interior of the projection. Some lower bound and some upper bound coincide there. Their difference is an affine function that is nonnegative on the projection and vanishes at a relative interior point. It vanishes throughout the affine hull, since a short displacement in either direction along the hull stays in the projection. The equations already known on $y$ therefore identify this pair of bounds. Induction over the coordinates gives the result.

The repaired checker uses this argument for equalities that survive substitution by the explicit equations. On the existing `liquid_tower_asserted` example, trying two full strict-feasibility searches for each candidate equality made one test take minutes. Comparing the reduced bounds brought the example back to about one second on the test machine. For example, $b=\max(c,0)$ and $b\le2c$ imply $b=c$. On the branch $b=0$, the inequalities force $c=0$ even if the solved substitution has yet to record that equation.

## What was checked {#checks}

The solver regressions check all four forms of conclusion on the 125 triples from $\{-2,-1,0,1,2\}^3$, including ties. Separate tests exercise symbolic alternatives, substitutions supplied in one batch or incrementally, and a counterexample with 30 independent premise disjunctions.

I also compared the OCaml checker with Z3 5.4.1 on 50,000 deterministically sampled implications. Each premise has one to five atoms on three rational variables. The oracle asks whether the premise and negated conclusion are jointly satisfiable. It interprets minima and maxima using Z3 conditional expressions. InvarGenT parses the same premises and conclusions through its own formula parser. A false positive means InvarGenT accepted an implication for which the oracle found a counterexample. [Reproducible comparison and OCaml driver](thesis-review-4.py)

| Numeric checker | False positives | False negatives |
|---|---:|---:|
| Original, revision `772b9b4` | 591 | 884 |
| Repaired, revision `8987d49` | 0 | 0 |

These counts describe the sampled numeric judgments. The arithmetic identities above justify the reduction to strict feasibility. Proving correctness for all inputs would additionally require proving the underlying OCaml linear solver and its state representation correct.

I ran the full OUnit suite with OCaml 5.3.0 using a temporary compatibility build. The compiler for generated examples also had the legacy `Pervasives` shim on its include path. The original revision had 255 passing cases and 10 TODOs. The repaired revision had 260 passing cases and the same 10 TODOs. All 124 previously generated `.gadti` files were byte-for-byte identical. On OCaml 5.5.1 a separate run had the same 129 failing cases before and after the changes, including historical pretty-printing expectations. All five added cases passed on both compilers.

To reproduce the comparison, use a buildable checkout of InvarGenT and a Python interpreter with the `z3-solver` package. From that checkout, with `review` set to the path of the downloaded script, run

```sh
python3 "$review" --driver > src/CheckImplications.ml
ocamlbuild -use-ocamlfind -pkg num src/CheckImplications.native
python3 "$review" ./CheckImplications.native
```

The script exits with a nonzero status if it finds a disagreement. It prints the first three disagreements so that the same formulas can be tested independently.
