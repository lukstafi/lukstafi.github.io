---
title: "When must a guarded call constrain an input type?"
date: 2026-11-22
---

The four-constructor example that failed at every outer budget now finishes on pass 6. The call sits under `Pick n when 1 <= n`. Its argument has the fixed type $\mathrm{Tag}(M,M,\mathrm{Cargo},M)$, where $M$ abbreviates `Marker`. A legal typing must admit this argument because the hidden index of `Pick` can be 1. Changing the external OCaml value from `Pick 1` to `Pick 0` changes which arm executes. The type checker sees the same constructor declaration in both programs. [Guarded source](guarded_payload.gadt) · [Earlier all-budget failure](thesis-review-18.html#guard) · [Executable checks](thesis-review-20.py)

## A call that every typing must admit {#occurrence}

Let $Q$ be the original quantifier prefix, $F$ the facts known about the branch, and $G$ the entire guard of a call. A strategy chooses existential witnesses using only the universal moves already visible. A play follows that strategy for one sequence of universal moves. Call a strategy legal when $F$ holds on every one of its plays. Assume there is a legal strategy. Then the following statements are equivalent.

1. Every legal strategy has a play on which $G$ holds.
2. $Q.(F\land\neg G)$ is false.
3. $\bar Q.(F\Rightarrow G)$ is true, where $\bar Q$ exchanges the quantifiers in place.

A strategy winning $F\land\neg G$ is precisely a legal strategy that avoids the call on every play. Negating this statement gives the first equivalence. Quantifier duality gives the second. The Lean proof allows the domain of each move to depend on previous moves. [Proof of both equivalences](thesis-review-20.lean)

For example, under $\exists x\,\forall y$, the guard $x=y$ occurs on some play of every strategy. Whatever $x$ the strategy picks, the opponent can match it. Under $\forall y\,\exists x$, the strategy $x=y+1$ can avoid the guard. Testing satisfiability after erasing the prefix would give the same answer to both queries.

A candidate input pattern must **overlap** the instantiated arguments at each such site. Take the play supplied by the theorem. The original call obligation puts its argument in the candidate domain. Different sites may obtain their witnesses on different plays and at different instances of the candidate type. For a fixed argument this recovers the argument itself. A call with a varying argument can warrant just one instance. Admitting *every* public instance takes the stronger coverage condition from the earlier review. The solver uses overlap to guide term abduction, then checks the original clauses. [Lean overlap lemma](thesis-review-20.lean) · [Public argument coverage](thesis-review-18.html#coverage)

The same theorem applies to a family of sites offering one fixed argument $t$. Use $G=\bigvee_i G_i$. If every legal strategy must reach *some* site, the domain must admit $t$, even when every individual site has an avoiding strategy. For instance, let the original prefix be $\exists n$ and put the same call under $n\le0$ and $0\le n$. Choosing 1 avoids the first, choosing $-1$ avoids the second, and no choice avoids both. This is a further source of required input instances beyond the implementation's per-site test. [Common-argument theorem and two-site example](thesis-review-20.lean)

### Patterns, numeric guards and witness order

A constructor match can determine how to interpret a later test. Suppose an earlier test $H$ entails an equation $e$. Simplify the remaining test $J$ using $e$, obtaining $J'$. Under the facts, $H\land J$ is equivalent to $H\land J'$. Keeping $H$ in the accumulated guard is essential. Taking $H$ to be false and $J'$ to be true already shows what goes wrong if the earlier test disappears. InvarGenT processes premises contained in the guard in order of size and retains the tests that licensed each rewrite. This covers nested constructor matches, including a GADT witness, and a constructor with two hidden indices and guard $m+1\le n$. [Guarded rewrite proof](thesis-review-20.lean) · [Compiler examples](thesis-review-20.py)

The dual game can share an index between the type and arithmetic components. Consider $\exists a\,\forall n\,\exists k.\ a=\mathrm{Num}(k)\land k=n$. It is false. Choosing the type $a$ also fixes the enclosed index before $n$ is known. Moving $n$ before $a$ makes the same matrix true. In general, a proposed value for a type witness can be chosen at its move exactly when it is constant on plays with the same visible history. The implementation checks a sufficient condition on the variables of the solved term. When all remaining numeric moves belong to the witness player, it can fix their joint values in advance. [Witness factorization lemma](thesis-review-20.lean)

A numeric subproblem exposed an independent error. The conjunction $x\le0,\ y\le0,\ 1\le\max(x,y)$ has no solution. InvarGenT previously returned a feasible state, even though its implication check could prove a contradiction from that state. The satisfiability routine now chooses one arm from each unresolved alternative and checks their joint linear system. It stops at the first feasible combination and returns the original state so later constraints can still choose another arm. A source constructor with these three constraints now allows `assert false` in its match arm. Relaxing $x\le0$ to $x\le1$ makes the arm possible, and the assertion is rejected. [Source-level comparison](thesis-review-20.py)

## A second call behind the first return {#replay}

Consider this attached client, with the all-$M$ call first.

```ocaml
let (u,v) = f (Third Mark) Z in
let first = same u Mark in
let (x,y) = f (Third Box) (S Z) in
same x Box
```

Opening the first pair puts its binary postcondition $X_1(u',s)$ into the premise of the second call. Here $u'$ is the carried type and $s$ is the captured parameter tuple. With the later call hidden, an input proposal that covers only the all-$M$ instance can stabilize on pass 5. Restoring the clients rejects it on pass 6. The solver now substitutes the rejected producer proposal into the earlier opening and can then see the later call. The argument fed to the next search comes from the original equations at that call. The new proposal stabilizes on pass 5 and passes with every original branch restored on pass 6. Putting the marked call first gives the same type. [Driver for both call orders](thesis-review-20.py) · [The restored-client pass](thesis-review-17.html)

Evidence from a particular proposal can suggest a later call that another solution could avoid. The accepted answer still owes the complete validation. A stronger justification is available if every solution covers the original suppliers and one can exhibit a supplier return satisfying the continuation. That return witnesses the guarded call in every solution. The formalization proves this implication separately. [Supplier-return lemma](thesis-review-20.lean)

There is a finite bound on the **additional retries induced by earlier openings**. Count the originally deferred call clauses. Every further proposal consumes at least one of them and puts none back. With $k$ deferred clauses there can be at most $k$ such proposals, independently of any size bound on answers. A proposal still runs the predicate iteration, including the induction jump. Its convergence requires a separate argument. [Lean bound](thesis-review-20.lean) · [Table 4.4](../lukstafi-phd-thesis.pdf#page=71)

## A function that eventually returns a package {#alias}

The inferred type is $\forall a.\;\mathrm{Tag}(M,M,a,M)\to\mathrm{Nat}\to\exists().\,(a,a)$. It has two arrows before the package. Passing the function through a callback exposed a discrepancy. Inference accepted the erased program. Writing the inferred type caused the elaborator to reject the callback argument with “Should not be existential”. The elaborator knew that an eventual result was packaged and applied that information to the function's outermost constructor. Keeping separate information about the head repairs this round trip. [Inferred and written program checks](thesis-review-20.py)

A local alias exposed the same distinction earlier in elaboration. In revision `dbd005d`, `let g = f in …` opened `f` itself. Among the normalized clauses were $\top\Rightarrow X_2(v)\land v=K(s)$ and $X_2(t)\Rightarrow t=A\to B$. These clauses are jointly impossible in the free type algebra. The source has the written type above, which checks and executes. Failure of the predicate iteration on these particular clauses says nothing about convergence on satisfiable clauses. [Constructor clash proof](thesis-review-20.lean) · [Erased and written alias comparison](thesis-review-20.py)

Leading lambdas and declared arrows give a lower bound $d$ on the function's arrow depth. After $k<d$ applications, the value still has an arrow at its head. The elaborator can bind a variable pattern directly at that monotype and use the same type at every occurrence of the alias. Applying this rule through two aliases and a partial application gives `let g = f in let h = g in let at_box = h (Third Box) in …`. The final call `at_box (S Z)` opens the package. The same implementation also recovers the original input when it reaches the call through a higher-order argument. [Arrow-depth lemma](thesis-review-20.lean) · [Executed examples](thesis-review-20.py)

## A small solution missed at revision `253cd6b` {#budget}

Change just the constructor declaration to `Pick : ∀i[i≤0]. Num i ⟶ Seed` and implement the external seed by `Pick 0`. The function and the attached client's guard $1\le n$ remain the same. This time the call cannot occur. The normalized constructor branch supplies $i\le0\Rightarrow h=i\land l=1$. The client's antecedent contains $i\le0\land l\le h$, which is therefore impossible. The written type still checks and the generated OCaml executes. [Guard contradiction](thesis-review-20.lean) · [Budget sweep and positive controls](thesis-review-20.py)

There is also a certificate for the **erased** clauses. Interpret $X_2$ as all instances of the displayed function type, and $X_1$ as the relation between $(a,a)$ and the parameter tuple $\langle a\rangle$. Choose that tuple at the definition and preserve it at the recursive call. The third constructor gives a payload of type $a$. Each of the other three forces its payload and $a$ to be $M$. The base supplies the pair and the successor repacks it at the same parameter. The existential witness for an initial $X_2$ instance can use $a=M$. Every additional client obligation that would require the call has the impossible antecedent above. The certificate has zero side-condition atoms and fixed total length. [Erased predicate construction](thesis-review-16.html#package) · [Four-constructor invariant](thesis-review-17.html#four)

At revision `253cd6b`, the complete search starts with a pass-0 proposal that fails on pass 1. A further pass-0 attempt ends in a quantifier violation. Deferring external openings yields four pass-0 proposals, each rejected on pass 1. Term abduction then fails on pass 0. There is no required call with an informative argument and no stable producer proposal to replay. Only successful pass-0 updates reach the outer-budget comparison. Thus every **positive** outer budget takes the same finite failing path with the other settings at their defaults. Budget zero stops at the first comparison. The driver checks budgets 0, 1, 6, 80 and 10,000. Changing the guard to $0\le n$ admits the endpoint zero and restores successful inference. Adding a live call on `Third Box` before the match also recovers the type while keeping the impossible arm in the program.

This gives two answers to the size-bound question. The original common-atom jump has an infinite execution in which a caller restores the same upper bound at every pass, even though the stored two-inequality result is already inductive. The current implementation repairs that feedback on the arithmetic example. At revision `253cd6b` it can still exhaust type search on the constant-size solution above before reaching a jump. A bound on certificate size gives completeness for a fair enumeration of a finite, checkable certificate language. It supplies no progress measure for either of these executions. [Infinite recurrence and jump repair](thesis-review-3.html#update) · [Finite certificate search](thesis-review-2.html)

A later revision proves this direct guard impossible and finishes on pass 5. Two incompatible calls under an opaque guard give a further constant-size certificate and a finite all-budget failure. [Conditional typing at revision `16509d9`](thesis-review-21.html#residual) · [Current two-package counterexample](thesis-review-22.html#binary)

## Reproduction {#checks}

The guard checker was compared with independent quantified queries in Z3. Of 9,828 two-index rational queries, 6,038 had facts admitting a winning strategy. On those, the checker reported zero spurious occurrences and missed 432 necessary ones. It agreed on all 264 conjunctions of two linear tests with no additional facts. The mixed type-and-index comparison tried 144 combinations of order, polarity and comparison. It found zero spurious occurrences and three missed ones. These finite comparisons measure the sufficient test. The equivalence for arbitrary games is proved separately. [Probe](guard_probe.ml) · [Z3 comparison](thesis-review-20-audit.py) · [Lean proofs](thesis-review-20.lean)

Run the program checks with `python3 thesis-review-20.py /path/to/InvarGenT.native`. Optional arguments `--before` and `--before-alias` take executables at `f570a4b` and `dbd005d`. Successful cases execute the generated OCaml with full annotations. For the guard comparison, copy `guard_probe.ml` to `src/Guard_probe.ml` in an InvarGenT build checkout, build `src/Guard_probe.native` with the solver libraries, then run `python3 thesis-review-20-audit.py /path/to/Guard_probe.native` with the Python Z3 bindings installed. Lean 4.19 checks `thesis-review-20.lean` using only `Std`. [Build notes](thesis-review-1.html)

The InvarGenT commits are `cc0a90f` (joint numeric feasibility), `73f409f` (quantified guards), `40b289a` (calls behind earlier openings), `10e0da6` (scoped witnesses and caller arguments), `dbd005d` (written callback types) and `253cd6b` (ordinary function aliases). The OCaml 5.3 compatibility build passed 315 active tests with 10 existing TODOs. All 149 example signatures generated by the baseline at `f570a4b` compared byte for byte with the final build. The program driver used OCaml 5.5.1.
