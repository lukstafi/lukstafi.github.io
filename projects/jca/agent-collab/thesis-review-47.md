---
title: "What can a failed caller proof teach the next induction jump?"
date: 2026-11-22
---

A caller at $b$ forbids zero. The base returns zero at $a$. If every key admitted at $b$ is also admitted at $a$, every package satisfying the base opens zero at $b$. Adjusting the postcondition cannot help. The inference procedure needs a key admitted at $b$ and absent at $a$.

The same reasoning works through recursion. A finite derivation forcing a forbidden result supplies a list of inclusions between menus of keys. A repair must break at least one inclusion. Given a library of possible key supports, that list lets a search branch only on changes that could repair this proof. A solution using $m$ supports guarantees a successful branch of depth at most $m$ under the checking assumptions below. [Lean proof](thesis-review-47.lean) · [Executable search](thesis-review-47.py) · [Joint witness criterion](thesis-review-46.html#fit)

## A result can come from several inputs {#cover}

Let $A_x$ be the keys admitted at input $x$. Result $r$ opens at $x$ if every key in $A_x$ stores $r$. Consider a ground supplier instance with fixed local values. It opens a finite list of observations $(y_i,s_i)$ and, if all open, stores $t$ at every key in its destination menu. Static guards determine which instances are available. Private package witnesses are existential inside the stored relation.

A proof that $r$ must open at $x$ can use several suppliers. Choose finitely many inputs $D$. For each $y\in D$, give a supplier returning $r$ at $y$, together with proofs of its recursive premises. The sole admission test at this node is
$$
 A_x\subseteq\bigcup_{y\in D} A_y.
$$
Every key at $x$ receives $r$ from at least one chosen supplier. For example, if $A_x=\{u,v\}$, a base at $a$ with menu $\{u\}$ and another at $b$ with menu $\{v\}$ can together force $r$ at $x$. A test for inclusion in a single source menu misses the opening. A call at an input with an empty menu opens every result by an empty cover. Legal program inputs can separately require nonempty menus. [Lean theorem `sound`](thesis-review-47.lean)

When this proof reaches a forbidden caller observation, retain its menu inclusions and the rule instances that produced them. Any new policy satisfying all those inclusions replays the same proof, for *every* package satisfying the suppliers. A caller that forbids a tuple of simultaneous observations can join the finitely many premise proofs at one root. This argument assumes the same ground rules and static guards under the new policy. Explicit key tests in a supplier require their own obligations. [Finite support theorem](thesis-review-47.lean)

For comparison, take one input with a single key, a base returning zero and a caller forbidding one. A trial package that permits every number fails the caller. No supplier returns one, so there is no derivation of the forbidden opening. Keeping the same admission and storing only zero solves the clauses. Learning an admission restriction from that failed candidate would discard a solution.

## Exactly when finite proofs suffice {#complete}

Fix a policy. Suppose that whenever a family of source menus covers $A_x$, some finite subfamily covers it. Finite menus have this property. So do finitely many distinct menu shapes, even with infinitely many inputs and infinitely many keys. Choose one actual source for each shape appearing in the cover.

Let $S(x,r)$ mean that there is a finite proof of this kind. Construct a package by storing $r$ at $k$ whenever some supplier at an input admitting $k$ returns $r$ from calls in $S$. Its opening at $x$ is exactly $S(x,r)$. Indeed, if the package permits the opening, the menus of those suppliers cover $A_x$. Take a finite subcover, choose a supplier and its premise proofs at each source, and attach them below a new root. Conversely, the root of any existing proof names enough suppliers to store $r$ at every key of $x$.

The constructed package therefore validates every supplier. Induction on proofs shows that every other supplier solution contains every entry in this package. It follows that a package satisfying the caller exists iff no forbidden observation has a proof. Moreover every finite proof opens at some finite producer stage. Take the maximum of its finitely many premise stages, then take one supplier step. The union of the finite producer stages is the least package. This gives an $\omega$ bound even for infinite menus with finitely many shapes. [Lean theorems `safe_scheme`, `proof_height` and `at_omega`](thesis-review-47.lean) · [A fixed policy taking two limits](thesis-review-43.html#limits)

The finite-subcover condition is also necessary for completeness *uniformly over supplier systems*. Given any cover lacking a finite subcover, offer a single result unconditionally at exactly its source inputs. Every supplier solution permits the result at the covered input. A finite proof there would exhibit the missing subcover at its root. For instance, take a query menu $[0,1]$ and a base at each singleton $\{u\}$ in that interval. The opening is forced on the first supplier pass. Its ground evidence uses infinitely many sources. This example uses a finite description of the entire family of bases. A symbolic proof could discharge that family with one quantified inclusion. [Lean theorem `uniform_completeness`](thesis-review-47.lean)

## A search with a bound on added keys {#search}

Keep a base policy and a library of supports $C_j$, where $C_j(x)$ means that a fresh key $j$ would be admitted at $x$. Select any subset of the library and infer its package sections freely. A selected key breaks a recorded inclusion $(x,D)$ exactly when
$$
 C_j(x)\quad\text{and}\quad \forall y\in D,\ \neg C_j(y).
$$
An old key keeps its admissions. Adding keys can only destroy cover inclusions. A previously successful scheme still works after an addition by permitting all results at the fresh key. [Lean theorems `extend_cover` and `neutral_open`](thesis-review-47.lean)

**Bounded refinement.** Start with no additions. Check the current policy. A successful check returns an inductive package satisfying the caller. On failure obtain a finite proof that the caller's forbidden observation is forced. Collect the library supports that break at least one of its inclusions. Every safe solution using this library must pick one of the collected supports. If it picked none, the entire proof would replay. Each collected support is fresh to the current selection, since all the recorded inclusions just held there. Save that disjunction for future checks. [Lean theorem `learn_cut`](thesis-review-47.lean)

Suppose a target solution uses $m$ supports. At each failure along a branch consisting of target choices, at least one of the proposed additions belongs to the target. After at most $m$ additions such a branch succeeds. Trying every proposed choice to depth $m$ is complete for that budget if the library is finite and each policy check terminates with a package or a failure proof. Without a budget, testing the full library suffices for semantic existence. If that succeeds, repeated deletion of dispensable keys yields an inclusion-minimal selection. With a budget, a single greedy run can spend its last slot on the wrong key. Let the base return zero at $a$ and let callers at $b,c$ forbid zero. With common initial menus, separating only $b$ repairs the first failure. A key supported at both $b$ and $c$ repairs both for the same cost. The replay learns the two disjunctions and finds the shared key with a budget of one. [Bounded branch theorem](thesis-review-47.lean) · [Finite search](thesis-review-47.py)

Adding finitely many key supports preserves the finite-subcover condition on the base policy. Cover its old keys with finitely many sources, then take one more source for each admitted new key. Thus at every finite search depth the initial condition suffices, even for infinite input and result spaces. For finite ground input and result tables, finite rules and decidable menu inclusions, closure gives the required terminating check. For infinite results the theorem still gives finite evidence of each forced forbidden observation. Deciding that a policy succeeds can still require induction. The least package is a semantic relation. In a restricted answer language, a verified expressible enlargement can witness success. Failure to express the least package alone cannot justify a cut. The depth bound counts selected supports. A short formula can describe infinitely many keys, and branching can visit many subsets. The original Table 4.4 generalization and jump follow different updates and already admit a two-inequality counterexample. [Finite extensions in Lean](thesis-review-47.lean) · [Original feedback loop](thesis-review-3.html#update)

The next review constructs the supports directly from joint assignments of failed proof nodes. It gives a symbolic jump for one affine key and an infinite sequence of pointwise repairs with a one-inequality solution. [Support synthesis and its limits](thesis-review-48.html#fit)

When no key budget is imposed and each input can have a private key, a simpler refinement suffices. Pick any recorded inclusion with $x\notin D$ and give $x$ a fresh private key. Every previous failed proof stays broken, and the same input can never need isolation again. If every recorded inclusion has $x\in D$, the proof works even when each input already has its own key. The failure is then forced by the ordinary suppliers. On $n$ inputs this takes at most $n$ additions and one final check. The method starts with a coarse opening. If it already proves the caller, it can return a package that forgets distinctions in the concrete reachable results. Each later split records a distinction needed to invalidate an actual derivation. This is a form of counterexample-guided abstraction refinement. Here the reusable evidence specifies exactly which admissions can invalidate a particular derivation. [Private-key split in Lean](thesis-review-47.lean) · [Clarke et al. on abstraction refinement](https://doi.org/10.1184/R1/6604547)

## One caller can leave many ways to repair its proof {#chain}

Use input pairs $(a_i,b_i)$ for $1\le i\le n$. The base at $a_1$ returns tag one. For $i<n$, opening tag $i$ at $b_i$ supplies tag $i+1$ at $a_{i+1}$. These are the only rules. The caller at $b_n$ forbids tag $n$. In the least package, the keys storing tag one are exactly $A_{a_1}$. Inductively, the keys storing tag $i+1$ are $A_{a_{i+1}}$ if the preceding opening succeeds and empty otherwise. For nonempty menus the caller therefore fails exactly when
$$
 \bigwedge_{i=1}^n A_{b_i}\subseteq A_{a_i}.
$$
Start with the same one-key menu everywhere. For any $i$, adding a second key only at $b_i$ breaks just that inclusion and yields a safe package. Every one of the $n$ separating choices can be the only available repair. An inference rule that picks a particular pair to separate has made a search decision. Reporting the full disjunction preserves all the solutions. [Chain replay](thesis-review-47.py)

## What InvarGenT can check today {#compiler}

The bit-flip program implements the preceding review's example. The base returns the input bit. The recursive arm switches the input and flips the answer. With the written postcondition $0\le r\le1$, InvarGenT exports that interval with outer budget two. Removing the annotation gives the input-dependent result $r=i$ with budget three. Both generated programs print zero and one. The caller accepts either scheme. InvarGenT checks the weaker hypothesis when it is proposed. These runs exercise its existing inference and checking code. The cover-guided choice of supports above is implemented in the independent finite search. [Bit-flip program](caller_bit_flip.gadt) · [Why weakening can save a key](thesis-review-46.html#flip)

InvarGenT already has the numeric operations for checking an individual cover over rational keys. Project the private witnesses of each source menu separately. To find a gap, ask whether a target cell is satisfiable together with the negation of every projected source cell, keeping the public indices shared. The same conditional satisfiability routine is used when inference checks alternative admission cells. The cover driver tests 127 such inclusions. Two closed half-intervals cover the unit interval when their endpoints meet. Two singletons at the endpoints leave a gap even though they cover every integer in the interval. [Cover driver](thesis-review-47-covers.ml)

A rational valuation can also give a spurious reason to change the admission or package. In the [integer-guard program](lattice_guard.gadt), any positive result $r$ at input $i$ must satisfy
$$
 11\le5(i+r)\le19,\qquad -4\le5(i-r)\le4.
$$
Both runtime values are integers. Rounding yields $i+r=3$ and $i-r=0$, whose unique rational solution is $(3/2,3/2)$. Revision `c74beee` retained this case and rejected the program with outer budget four. Revision `dcfe773` accepts at budget two. The example returns zero. Decreasing the lower bound to ten allows $(1,1)$ and the guard observes one. Making the input type `Num (2 i)` allows the native input three at $i=3/2$ and the guard observes two. Both controls reject the original Boolean branch and reach its numeric replacement at runtime. [Earlier joint relaxation](thesis-review-45.html#native) · [Whole-program replay](thesis-review-47.py)

After projecting out rational witnesses and keys, the compiler visits each feasible alternative of the rounded constraints. It clears denominators in the solved equations and tests whether their target vector is in the integer span of the coefficient columns. Replacing two columns $u,v$ by $v,u-qv$ preserves their integer span. Euclidean division repeats this operation until just one pivot is nonzero in the current row. Its required multiple must be integral. Subtract that multiple and recurse on the remaining columns and rows. A rational alternative survives only if all its solved equations admit a simultaneous integer assignment. For example, two narrow bands in four native values can round to $2x-u-v=0$ and $2y-u+v=1$. Each coordinate ranges over the whole rational line, and each equation separately admits integers. Adding them gives $2(x+y-u)=1$. The repaired checker excludes this entire affine plane. Changing the right-hand side to two leaves an integer point. [Column-operation proofs](thesis-review-47.lean)

General inequalities can still prevent an integer solution of the equations from lying in the cell. For example, $0\le8i+7r\le1$ and $2\le12i+11r\le3$ survive the test. The difference of the two forms would be a multiple of four strictly between zero and four. [Arithmetic replay](thesis-review-47.py) · [Pugh on integer constraint elimination](https://doi.org/10.1145/125826.125848)

## Reproducing the checks {#checks}

The [formal proofs](thesis-review-47.lean) use Lean 4.19 and mathlib v4.19.0. Run `python3 thesis-review-47.py` for the finite policy search. It compares 1,280 closures with every possible package, replays proofs under changed policies, and checks 256 bounded searches against exhaustive joint synthesis. With `z3-solver` installed, pass `--driver` and the executable built from the [numeric driver](thesis-review-45-numeric.ml) to check 220 equality systems in rational, single-native and joint-native modes. Build the cover driver as `src/Cover47.native` with the same ocamlbuild flags and pass it as `--covers`. Pass `--compiler` for the source cases and optionally `--before` for the earlier compiler.

The OCaml 5.3 compatibility build of InvarGenT revision `dcfe773` passed 380 active tests. Ten cases are marked TODO. All 195 previously generated example signatures matched revision `c74beee` byte for byte. The source replays and both numeric drivers ran on the OCaml 5.5 compatibility build.
