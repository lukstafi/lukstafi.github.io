---
title: "Which recursive caller domains can finite term guards express?"
date: 2026-11-22
---

Take the type indices `Base` and `Step a`, represented by the GADT values `Root` and `Next x`. A recursive function accepts `Root`, fails on `Next Root`, and strips two constructors from any longer argument. Every call terminates. The safe inputs have exactly the even depths. No finite Boolean combination of equational patterns on this input expresses its safe domain. This gives a boundary for the [closure of term guards under sequential composition](thesis-review-52.html#sequence).

## What a public guard can say about one index {#guard}

On the represented indices $S^n B$, a single unary pattern is empty, a singleton depth, or a tail containing all depths at least $k$. A pattern matching a represented index must be a chain of successors ending at its base or at a hole. Projecting private equational witnesses gives a pattern of the same kind.

Consequently, **finite Boolean combinations of unary patterns express exactly the eventually constant depth predicates**. Beyond all the constructor depths in a finite formula, every singleton test is false and every tail test is true. Conversely, take all the accepted singleton depths below a cutoff and add the tail if all later depths are accepted. In particular, any such guard that excludes every odd depth can admit only finitely many even depths. [Lean theorems `expressible` and `even_inexpressible`](thesis-review-53.lean)

## What happens during recursive checking {#iteration}

Write $D$ for the currently permitted depths. Rechecking the three arms gives
$$
 F(D)=\{0\}\cup\{n+2\mid n\in D\}.
$$
The first arm always succeeds. The second always fails. The third demands permission for its child call. Starting from all depths, after $t$ rechecks the candidate consists of all evens and all depths at least $2t$. The next round removes $2t+1$. Every finite round changes the candidate, and their intersection is exactly the evens. This is the descending semantic recheck for the greatest safe domain. Table 4.4 also makes separate choices about abduction and generalization. [Lean theorems `stage_spec`, `strict_stage` and `limit`](thesis-review-53.lean)

An inductive safe contract only requires $D\subseteq F(D)$. In particular, the singleton $\{0\}$ suffices if the base is the sole mandatory input. Requiring depth $2m$ forces admission of $2m-2,\ldots,2,0$ as well. Each safe positive pattern can cover at most one of these depths. **Exactly $m+1$ conjunctive alternatives suffice**: take those $m+1$ singleton patterns as the admitted union and check recursive calls against that union. Already the safe call at depth two belongs to no inductive *single-pattern* domain. More generally every nonempty inductive domain expressible by a finite Boolean guard is an initial segment of the even depths. Each has a strictly larger expressible inductive extension. [Lean predecessor, safety and induction proofs](thesis-review-53.lean)

InvarGenT infers and runs the total Boolean classifier when the depth-one arm returns false. Replacing that arm by `assert false` yields a rejected unannotated definition. The written depth-two scheme also fails. In the mathematical safety calculation, the base-only domain discharges the successor obligations vacuously. InvarGenT rejects the base-only annotation too, including in the run with `-allow_dead_code`. A semantic induction argument and a successful Table 4.4 search are distinct requirements. [Compiler replay](thesis-review-53.py)

## A decision for finite control, and an indexed witness {#cycle}

Suppose the recursive computation has a finite control state $q$. Reading a successor transfers to $\delta(q)$ on the child. At the base a fixed Boolean $b(q)$ decides success. At depth $n$ the verdict is $b(\delta^n(q))$. Follow the orbit from the chosen initial state to its first repeated state. The states before the repeat give a finite prefix followed by a nonempty cycle.

The exact public domain has a finite Boolean term guard **iff all states on that cycle have the same verdict**. With a uniform verdict the prefix and the eventual truth value construct the guard. With a mixed cycle both verdicts recur arbitrarily late, which violates eventual constancy. This decides whether this guard language can express the exact answer, including for a recursive procedure whose visible index grows without bound across possible calls. The replay enumerates all transition tables, accepting sets and initial states with one through four named states. It checks 17,066 choices, of which 12,658 admit a finite guard. [Lean cycle criterion](thesis-review-53.lean) · [Finite-state replay](thesis-review-53.py)

There is also a constructive way to pass the missing information. Declare a GADT `OK(q,a)`. For each accepting state give a nullary constructor of type `OK(q,Base)`. For every state give a constructor taking `OK(δ(q),a)` to `OK(q,Step a)`. Induction on the represented depth shows that a finite constructor value of this type exists exactly when the computation accepts. For a fixed initial state and depth, the outer constructor is forced at every step. This encoding introduces an explicit value argument at the program interface. An existential quantifier over equational type variables alone would still project to an ordinary pattern.

For even depth, two constructors suffice: `ERoot : Even Base` and `EPair : Even a ⟶ Even (Step (Step a))`. InvarGenT checks the recursive consumer with type $\forall a.\;\mathrm{Even}(a)\to\mathrm{Rep}(a)\to\mathrm{Bool}$. The generated OCaml runs at depth four, and supplying the base proof at depth one fails. The replay also generates an evidence datatype for a four-state machine with a nonconstant three-state cycle, runs five certified inputs and rejects evidence for the wrong initial state. [Even-index source](even_index_proof.gadt) · [Lean evidence theorem](thesis-review-53.lean) · [Generated machine and compiler checks](thesis-review-53.py)
