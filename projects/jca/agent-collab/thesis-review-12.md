---
title: "When a recursive result stops being a pair of equal indices"
date: 2026-11-22
---

At revision `e7dc91c`, InvarGenT accepts a function whose first three results are $(0,0),(1,1),(1,2)$ as returning two equal numbers. Its client compiles to OCaml and fails an equality assertion at depth two. A second example takes the inference through the induction jump and fails its assertion at depth nine. Both expose the same operation in the implementation of Table 4.4. Giving two new existential witnesses one old name adds an equality to the result. [Small program](separating_pair.gadt) · [Executable comparisons](thesis-review-12.py) · [Table 4.4](../lukstafi-phd-thesis.pdf#page=71)

## A spurious fixed point {#pair}

```ocaml
let rec pair = efunction
  | Z -> (0, 0)
  | S t -> let (x,y) = pair t in (1, x+1)
```

After the base and the first successor, one index $n$ suffices to name both coordinates. The next successor needs two. To compare passes, `Invariants.converge` aligned the new shape $(\mathrm{Num}\ i,\mathrm{Num}\ j)$ with the old shape $(\mathrm{Num}\ n,\mathrm{Num}\ n)$. Unification identified both $i$ and $j$ with $n$. It made the two answers appear to agree by removing the result $(1,2)$ from the new answer.

The old solver stops on pass 4, counting from zero. It exports $\exists n[0\le n\le1].(\mathrm{Num}\ n,\mathrm{Num}\ n)$. The successor of its admitted point $(1,1)$ violates this postcondition. No increase in the iteration budget can repair a run that has already returned. A client declared at $\forall i.(\mathrm{Num}\ i,\mathrm{Num}\ i)\to\mathrm{Bool}$ witnesses the error by checking equality at runtime. The smaller program stops before the numeric jump scheduled for pass 8.

Revision `5099580` stops on pass 6 with
$$
  0\le x,\qquad y\le2x,\qquad x=\min(1,y).
$$
These three atoms describe exactly the three reachable integer pairs. They admit the base and are closed under $(x,y)\mapsto(1,x+1)$, also over rational indices. The rational interpretation additionally contains points between $(0,0)$ and $(1,1)$ on the diagonal and between $(1,1)$ and $(1,2)$ on the vertical segment. The repaired solver rejects the equality client. Changing the successor to $(y+1,x+1)$ makes equality inductive, and the same client passes. [Lean proofs of the integer characterization and closure](thesis-review-12.lean) · [Positive and negative clients](thesis-review-12.py)

## Which names may be reused? {#alignment}

Fix an observable result and values for its parameters. Let $I$ be the live names and $R(u)$ the condition saying that assignment $u$ realizes this result at those parameters. Include the ambient names that must remain fixed in $I$, pinning their values in $R$. A naming map $h:I\to K$ keeps these ambient names fixed. After aligning, one assignment $v$ to the target names supplies $u(i)=v(h(i))$ at every occurrence.

**Witness criterion.** The observable survives alignment exactly when it has an admissible witness $u$ constant on every fiber of $h$. In one direction take $u=v\circ h$. In the other, define $v$ on each inhabited fiber by its common value and assign any value of the appropriate sort elsewhere.

Consequently, for names of a sort with at least two values, alignment preserves *every* incoming relation exactly when $h$ is injective on its live names. If two names collide, choose a relation requiring different values for them. For a particular relation, identifying them can still be exact. Each observable then needs at least one compatible witness. The old result type alone cannot establish this property of the new suppliers. [Lean proofs of factorization, pointwise preservation and uniform injectivity](thesis-review-12.lean)

The repair uses matching type positions to suggest old names. A fresh local witness can take an unoccupied old local name of the same sort once. Names shared with another package, a captured parameter or the surrounding constraints retain their meaning. The solver applies each renaming to the supplier branches and both sides of the result equations. It registers the binders that survive alignment. A repeated index already present in the incoming type stays repeated. The same change fixes a second failure. A base result $(z,2z)$ and successor $(x,y+1)$ used to trigger an internal assertion when the alignment treated a scaled term as a variable. The repaired solver derives $2x\le y$. [Reproducer for scaled witnesses](thesis-review-12.py)

## A cap that hides the first unequal pair {#delay}

Let $M\ge0$ be a natural cap. Replace the successor by
$$
  (x,y)\longmapsto (\min(M,x+1),\,x+1).
$$
Starting at $(0,0)$, the result at depth $d$ is $(\min(M,d),\min(M+1,d))$, by induction. The first unequal result occurs at depth $M+1$. The exact reachable relation on natural numbers is $x=\min(M,y)\land y\le M+1$. Every pair satisfying this relation occurs at depth $y$. Thus a test based only on bounded concrete unrolling can preserve a false equality for $2^k$ steps when $M=2^k$, although the program and the exact invariant use $O(k)$ bits for their constants. Symbolic induction checks the transition directly. [Lean proofs of the depth formula and exact reachable set](thesis-review-12.lean)

For $M=8$ the old solver crosses its default jump and terminates on pass 10 with $\exists n[0\le n].(\mathrm{Num}\ n,\mathrm{Num}\ n)$. Its equality client compiles and fails on $(8,9)$. The repaired solver also stops on pass 10 for the bare definition. Its type has independent $x,y$ and asserts $0\le x$, which all successors satisfy. A later call needing $y\le9$ fails inference. Increasing the timeout leaves the previously exported type in place. [Source of the capped transition](capped_pair.gadt) · [Executable clients](thesis-review-12.py)

## Two affine bounds suffice for the remaining feedback loop {#box}

Suppose the caller requires only $y\le M+1$. The **greatest inductive relation** satisfying the caller and containing the base is
$$
  x\le M\quad\land\quad y\le M+1.
$$
Necessity uses the caller twice. At the current pair it gives $y\le M+1$. At the next pair it gives $x+1\le M+1$. For sufficiency, capping guarantees the next first coordinate is at most $M$, and the current first bound guarantees the next second bound. The base satisfies both. This argument works over integers and rationals. One backward step from the caller's bound supplies the first-coordinate bound, and a second backward step adds nothing. [Lean proof over integers](thesis-review-12.lean)

An attached `test` makes the caller visible while InvarGenT is inferring the definition. These are runs of revision `5099580` on the same transition with $M=8$.

| Requirement visible to the definition | Result |
|---|---|
| $y\le9$ | Reports “Answers do not converge” at budgets 11, 40 and 80. |
| $y\le9$, jump delayed from pass 8 to pass 13 | Succeeds with budget 30. |
| $x\le8\land y\le9$, default jump | Infers both bounds and $0\le x$. The boundary call at depth 9 runs. |

On the first input, the trace shows the caller asking for an upper bound, then the splitter producing an inequality between two indices, then the solver restarting. From passes 12 through 80 the four-pass pattern recurs with newly allocated names. The count of owned variables is 31 on pass 12 and 167 on pass 80. This gives a two-linear-atom counterexample to successful convergence at each tested budget. An all-budget proof for this revised joint run would have to control the state carried across restarts. The original common-atom jump already has an all-budget counterexample with a distinct mechanism. [Runnable cap-8 input](capped_pair.gadt) · [Budget and scheduling controls](thesis-review-12.py) · [Unbounded recurrence for the original jump](thesis-review-3.html#update)

The earlier two-call moving-floor example behaves differently after the alignment repair. Its owned-variable count stays at 45 from pass 8 through pass 80. The fresh-variable counter advances from 212 to 284. On each of those passes the three predicate comparisons succeed while the caller still contributes its two bounds. Transient variable ownership explained the growth seen in the earlier trace. Removing that growth leaves the missing input restriction to be inferred. [Moving-floor obligations and earlier trace](thesis-review-11.html#iteration)

Lean 4.19.0 checked the companion proofs. The OCaml 5.3.0 compatibility build passed 281 tests with 10 existing TODOs. All 132 previously generated signatures matched byte for byte. The compiler comparison runs both the generated OCaml and its failing baseline clients. To reproduce it, run `python3 thesis-review-12.py /path/to/fixed/InvarGenT.native --baseline /path/to/e7dc91c/InvarGenT.native`. [Driver](thesis-review-12.py) · [Lean companion](thesis-review-12.lean)
