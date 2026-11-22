---
title: "Which recursive typings can license one another?"
date: 2026-11-22
---

The signed program returns zero, but its package at key $k$ promises only $-n\le r\le n$, $r\ne k$ and $r\ne-k$. At positive $r$, choosing key $r$ rules it out. At negative $r$, choosing key $-r$ rules it out. InvarGenT now uses both typings of the same returned number and checks the program on Table 4.4 pass 2. An effect in a recursive argument still runs once per call. [Signed program](signed_result_key.gadt) · [Earlier failure](thesis-review-34.html#signed) · [Compiler replay](thesis-review-35.py)

Combining two proofs raises an admission question. The first typing may tell us that the second key is legal. If we also use the second typing to license the first, the compiler can erase a reachable guard. The ordering that avoids this cycle has its own convergence theorem.

## A finite iteration with a sharp bound {#saturation}

Fix the runtime arguments, an inferred domain $D$, and a finite pool of $m$ proposed typings. A proposal $i$ assigns a key $q_i(r)$ to the observed payload $r$. Write $A_i(r)$ for $q_i(r)\in D$ and $P_i(r)$ for what the package at that key says about $r$. Private witnesses in $P_i$ are existential and fresh at each opening. Let $B$ be the possible payloads after one unconditional typing. If we have licensed the proposals in $T$, the remaining payloads form the set

$$
S(T)=B\cap\bigcap_{i\in T} P_i.
$$

Start with $T=\varnothing$. In one round, license every remaining $i$ for which $S(T)\subseteq A_i$. Only after those checks add their package facts to the next round. This procedure stops after at most $m$ productive rounds. Every productive round removes at least one untried proposal.

**With exact entailment the terminal family contains every proposal that any sound sequence of these admissions can reach.** More openings shrink $S(T)$, so an enabled proposal stays enabled. Take any terminal family and follow a legal sequence from the initial opening. If its earlier proposals belong to the terminal family, its next proposal is enabled there too. Closure puts it in the terminal family. Soundness follows by a separate induction. Every actual result obeys $B$. If it obeys the previously licensed postconditions, each new key is admitted for that result, and its typing supplies the next postcondition. This proof excludes a circular grant of admission even when all the keys in the cycle would pass if checked together. [Termination, maximality and soundness proofs](thesis-review-35.lean)

The bound is attained. Take possible results $0,\ldots,m$ and probes numbered $0,\ldots,m-1$. Probe $i$ rules out result $i+1$. Probe 0 is always admitted. Each other probe $i$ requires result $i$ to have been ruled out. After $j$ productive rounds the possible results are $0$ and $j+1,\ldots,m$. Exactly one new probe is enabled. The final result guarantee is the same one equality $r=0$ at every $m$. With all natural numbers as results and infinitely many probes, every finite prefix still permits a positive return. Their intersection is $\{0\}$. A further probe requiring $r=0$ would become available only at that limit. This is a bound on admission within a fixed proposed solution. In the full table the inferred domain and the supplier summaries can change. The common-atom induction jump still has its two-inequality counterexample. [Sharp chain](thesis-review-35.lean) · [Original recurrence](thesis-review-3.html#update)

## A program that needs the second round {#staged}

Let $n\ge6$. The recursive function admits the integer keys $1,\ldots,n$ except 3. Its package says that $r$ is either $-5$ or in $[1,n]$ and excludes $k=r$ and $k=r+3$. Both surviving branches of the program return $-5$. Write $[t]$ for $t$ clipped to $[1,n]$. Open first at key 1. [Source program](staged_result_keys.gadt)

1. The probe $[r+3]$ is admitted immediately. It is 1 at $r=-5$ and at least 4 at every positive result. Payload 3 would choose key 6 and thereby contradict its own package. This opening can still admit $r=n-1$.
2. The probe $[r]$ would have requested the missing key 3 at the first opening. After the first probe, that payload has been ruled out. The second probe is now admitted and excludes every remaining positive result.

The trace records one ready and one pending probe, then one ready and none pending. The emitted program prints `-5`. The exported input predicate still excludes key 3, and the postcondition preserves both punctures. The replay checks both formulas against the inferred signature. [Arithmetic proof](thesis-review-35.lean) · [Trace and exported-domain checks](thesis-review-35.py)

For a negative control, remove both keys 3 and 6, restrict the possible results to $-5$ and 3, and make the base return 3. Key 1 permits that return. At $r=3$ the two probes request exactly the missing keys. Neither admission can begin. A mutant supplies each probe with the other probe's postcondition during the admission check. Each then excludes 3 on the other's authority. The mutant accepts and the generated OCaml reaches the erased guard. The repaired checker rejects it. Giving both step arms the numeric result 3 makes the control execute and print 3. [Mutation and live control](thesis-review-35.py)

## Which proposals survive a change of the inferred domain? {#retry}

The compiler tries individual targets, then combines the distinct candidates extracted from the package's disjunctive inequalities. The combined trial gives the guard checker a fresh copy of each candidate package with one shared payload. The primary call generates its ordinary positive typing obligation. For a combined trial the extra package premises remain provisional until the admission iteration checks them against the exported recursive predicate. Each productive round imports only the numeric facts of packages licensed in that round. Unresolved private facts can make this check conservative.

A provisional proof can contain an unnecessary, unavailable key. Consider $n\ge3$, $1\le k\le2n$, $-n\le r\le n$, with three excluded equalities

$$
k=r,\qquad k=-r,\qquad k=n+1+r.
$$

The base result 0 removes key $n+1$ from the inferred domain. At $r=0$ the third probe still requests precisely that key. The first two probes take values in $[1,n]$ and suffice to rule out every nonzero result. After both are licensed the third probe is still unavailable. InvarGenT restores the local package declarations from before this trial, regenerates the definition using only the licensed pair, solves again, and rechecks admission against the new inferred domain. Its public type admits every key in $[1,2n]$ except $n+1$ on integer inputs. On the rerun the pair is admitted in one round. [Program generator, trace and exact signature](thesis-review-35.py)

## Two typings can express more than one min/max key {#separation}

For a second example let $1\le k\le n$, $-n\le r\le n$, and forbid the keys $r$ and $n+1+r$. The clipped versions of the two terms are always admitted. Every positive result is excluded by the first. Every negative result is excluded by the second. At the actual result 0 they choose 1 and $n$. If the package also records $r=k+w$, its two private witnesses must be $-1$ and $-n$. The compiler handles this version with an effect in the recursive argument. A depth-two call prints `!!0`. [Exact intersection and witnesses](thesis-review-35.lean) · [Effectful replay](thesis-review-35.py)

No single finite expression made from integer-affine leaves, addition, negation, minimum and maximum can make this choice uniformly in $n$, even after the first opening at key 1. At every $n\ge4$, the initial opening still permits $r=-1$ and $r=2$. Their only refuting keys are $n$ and 2. A finite expression of this grammar changes by at most $3C$ when $r$ moves from $-1$ to 2 with $n$ fixed. An affine leaf uses the absolute value of its coefficient on $r$ for $C$. Addition adds the bounds, negation preserves them, and min and max use the larger bound. Choosing $n>3C+2$ gives a contradiction. Two probes avoid the need to synthesize a discontinuous selector. [Machine-checked separation](thesis-review-35.lean)

## What a payload-dependent admission test would add {#conditional}

Fix a single hypothetical payload $r$. Any sequence of admissions that refutes it on this singleton can be replaced by one probe $i$ with $A_i(r)$ true and $P_i(r)$ false. Until a postcondition excludes $r$, the singleton remains intact, so every admission proved on it held at $r$ all along. Conversely, a probe with these two properties is already licensed on the singleton. This gives a precise target for a branch-sensitive checker. It must find expressible conditions under which the refuting probes are admitted. [Pointwise normal form](thesis-review-35.lean)

Suppose the projected integer postcondition is a key-independent bound $H(r)$ together with excluded equalities $k\ne h_i(r)$. For **any inhabited admitted domain** $D$ its full intersection is exactly

$$
H(r)\ \land\ \bigwedge_i h_i(r)\notin D.
$$

If $h_i(r)$ were admitted, its own typing would exclude $r$. Conversely, every admitted key differs from every excluded value when the right-hand side holds. The formula also covers disconnected domains. [Elimination theorem](thesis-review-35.lean)

Let $D=[1,n]\cup[3n+1,4n]$, $n\ge2$. For $-n\le r\le n$ take $h_1(r)=n+1+r$ and $h_2(r)=3n+r$. At zero both proposals are in the unadmitted gap. The first opening permits zero, so neither clipped proposal is admitted for every remaining result. The finite iteration stops immediately for these two proposals. Yet the full intersection is $\{0\}$. For a negative result choose $h_1(r)$ in the lower band, for a positive result choose $h_2(r)$ in the upper band, and at zero choose the already admitted key 1. Budgets 2, 40 and 10,000 all fail with no proposal licensed in the final two-key trial. Writing $r=0$ in the package checks and executes at budget 40. The same budget accepts a control with numeric bodies in every arm and preserves both written bands in the exported domain. A way forward is to check admission under the sign condition that selects each key. [Program](separated_result_keys.gadt) · [Conditional selector proof](thesis-review-35.lean)

The rejection above was reproduced at revision `b56ec02`. The next review checks this program by projecting the two targets onto different components of the admitted domain. [Two-interval repair](thesis-review-36.html#program)

The compiler change in this review is revision `b56ec02`. The OCaml 5.3 compatibility suite passed all 353 active tests with ten existing TODOs. All 180 previous example signatures matched byte for byte. The program replays use the OCaml 5.5 build.

Run Lean 4.19 on `thesis-review-35.lean`. With OCaml and Python's `z3-solver`, run `python3 thesis-review-35.py /path/to/InvarGenT.native`. The optional `--before` accepts revision `72c1ec3`. For `--trace`, apply the review 22, 23, 24 and 26 diagnostics, followed by the admission-round diagnostics. To reproduce `--circular` in a separate checkout, add the facts from all other pending probes to the premise of each admission check in `certify`. [Round diagnostics](thesis-review-35-admission.patch) · [Earlier diagnostic patches](thesis-review-28.html#policy)
