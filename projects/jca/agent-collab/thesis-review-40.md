---
title: "What can one client tell the joint abduction problem?"
date: 2026-11-22
---

InvarGenT could infer the written scheme of a recursive function on its own. It could also check two clients against that scheme in a later declaration. Attaching the same clients to the definition as a `test` made inference fail. The flag-zero client fixes a package index through a disjunction. When this client comes second, its admission also depends on opening the first call. Propagating the forced key under the right premise lets joint inference handle both client orders. The exported scheme retains the whole interval of indices. [Source program](interior_result_key.gadt) · [Executable checks](thesis-review-40.py)

## Where the iteration stopped {#clients}

The function takes a flag $f$, a width $n\ge2$ and a natural number for recursion. The flag satisfies $0\le f\le1$. The caller chooses a rational index $k$ satisfying $0\le k\le n$ and $k\le0\lor1\le f$. The result has a numeric payload $r$ with

$$
0\le r\le f,\qquad k+r\le n\ \lor\ n\le k.
$$

The base case returns zero. The successor calls the function at the same flag and width. If the previous result satisfies $1\le r\le f$, it returns a Boolean, otherwise it returns zero. The Boolean arm must be unreachable for the declared numeric return type to hold. Each numeric introduction supplies zero at every admitted key. At the guard $f=r=1$, opening the call at $k=n-1/2$ excludes that observation. [Guard check for all admitted typings](thesis-review-39.html#all)

At revision `ea0cf2c`, each row below uses the same definition without a written $r=0$.

| How the clients enter inference | Outcome with iteration budget two |
|---|---|
| Definition alone | Full written domain and package |
| An attached call at flag one | Same scheme, prints 0 |
| An attached call at flag zero | Type mismatch |
| Attached calls at zero and then one | Type mismatch |
| Those same two calls in a subsequent declaration | Same scheme, prints 0 twice |
| Attached calls at zero and then one, successor replaced by literal zero | Numeric abduction fails |

On the recursive two-client case the solver made fourteen attempts, each entering iteration zero, completing its update and failing in numeric abduction at iteration one. No attempt reached the guard check. The event sequence was identical at outer budgets 2 and 10,000. In this revision the predicate loop tests its budget after a completed update. Every positive budget allows the observed iteration-zero update, and there is no iteration-one update at which extra fuel could matter. This is a failure of candidate search before the next Table 4.4 update. [Trace and replay](thesis-review-40.py) · [Predicate loop in Table 4.4](../lukstafi-phd-thesis.pdf#page=71)

## An unconditional numeric consequence can enter a guard {#cut}

Consider the numeric abduction problem on **one pass**. Let $P$ be the conjunction of the conclusions of its active rows with empty numeric premise. For each remaining row $D_i\Rightarrow C_i$, choose facts $H_i$ with $P\models H_i$. Then

$$
P\land\bigwedge_i(D_i\Rightarrow C_i)
\quad\longleftrightarrow\quad
P\land\bigwedge_i((D_i\land H_i)\Rightarrow C_i).
$$

Fix a valuation, including the witnesses chosen by the candidate answer. From left to right, discard $H_i$ when applying the original row. From right to left, $P$ holds in that same valuation, so $H_i$ holds wherever the original guard holds. Both directions keep every witness and every quantifier dependency. Among valuations compatible with the candidate and its chosen witnesses, each original guard has exactly the same live witnesses after the change. This matters when a branch must remain satisfiable. [Lean proof](thesis-review-40.lean)

At a call with $f=0$, its admission gives $0\le k$ and $k\le0\lor1\le0$. Thus *that call's own* $k$ is zero. At a call with $f=1$ the whole interval remains available. On a failed numeric search InvarGenT solves the conjunction $P$, takes the constant bindings the solver obtained, and retries with each binding added to premises that mention its variable. The original provider and its conclusion are still present. A comparison build collecting only explicit equations continued to fail on the literal-zero version. The inequalities and the disjunction can establish a constant together. [Program and controls](thesis-review-40.py)

A conditional provider would need a stronger argument. Suppose mode zero permits only $(k,r)=(0,0)$ and mode one permits $0\le k\le1$ with $r=k$. Then $f=0\Rightarrow k=0$. Adding $k=0$ to the guard of $f=1\Rightarrow r=0$ would make the row pass. Its guard would even have a live witness at $(1,0,0)$. The original row fails at $(1,1,1)$. A provider deferred to a later pass likewise supplies no premise for this pass. [Checked countermodel](thesis-review-40.lean)

The repaired compiler reaches the tuple check at iteration two, excludes the Boolean arm and prints zero for each client. The per-key exported package still allows positive payloads at some keys. In a control whose contract returns its input flag, the Boolean arm really is reachable at flag one. InvarGenT rejects that arm, and replacing it by a numeric return prints zero and one. [Exported scheme and native execution checks](thesis-review-40.py)

## A bounded solution can require infinitely many fixed probes {#finite}

Fix $f=1$ and any **integral** width $n\ge2$. At $k=n$ the package admits every $r\in[0,1]$. At each $k<n$ it admits $[0,\min(1,n-k)]$. The intersection over all rational keys is exactly $\{0\}$. For any $0<r\le1$, the rational key $k=n-r/2$ lies in the interval and makes both alternatives of the package false.

Now choose any finite set of rational keys **before observing the result**. They can depend on the entire input. At this fixed input, take a common positive denominator $D$ of the chosen keys, with $D=1$ for the empty set. Whenever $k<n$, the gap $n-k$ is at least $1/D$. Every chosen key therefore admits $r=1/D>0$. Sampling even the entire $1/D$ grid in $[0,n]$ leaves exactly $[0,1/D]$, since the predecessor $n-1/D$ attains the upper bound. In particular, every integral key together still permits the native result one, even at width four. [Denominator and predecessor proofs](thesis-review-40.lean) · [Compiler arithmetic checks](thesis-review-40.py)

This example gives an exact criterion whenever the per-key sets of results are nested by inclusion. At a fixed input with at least one admitted key, a finite sample recovers the full intersection **if and only if one admitted key has a smallest result set**. Every nonempty finite sample has a smallest member, and its intersection is that member. If the sample is exact, this member lies inside the result set of every admitted key. Conversely, a smallest member alone is an exact sample. Here the intervals shrink as $k$ approaches $n$ from below and jump back to $[0,1]$ at $n$. No key attains the smallest interval. [Finite-basis theorem](thesis-review-40.lean)

The dyadic grids give the strict sequence $[0,1], [0,1/2], [0,1/4],\ldots$. Their limit has the one-equation description $r=0$, yet no finite grid reaches it. One affine expression using the observed result, $n-r/2$, certifies every positive rational refutation. If only the integer guard $r=1$ matters, the fixed fractional probe $n-1/2$ already suffices. This separates exact recovery of a rational result set from excluding this particular program arm. It refutes a bounded-solution argument based on enumerating input-dependent probes. The actual Table 4.4 recurrence has other ways to obtain a candidate, including the implemented tuple check. [Result-dependent affine proposals](thesis-review-39.html#elimination) · [Predicate-update recurrence](thesis-review-21.html#feedback)

## How many input-only probes can a closed guard need? {#packing}

There is also a constant-size package for which a finite sample excludes the guard at every input width, yet the number required grows without bound. Admit $0\le k\le n$ at integral width $n\ge1$, and give the package the constraints
$$
-1\le r\le n,\qquad r+1\le k\ \lor\ k+1\le r.
$$
A supplier returning $-1$ works at every key. Consider the closed guard $0\le r\le n$. For every observed result in that guard, the single expression $k=r$ gives an admitted refutation. It also follows that the full common result set is exactly $\{-1\}$, since $k=0$ refutes $-1<r<0$.

**Exactly $\lfloor n/2\rfloor+1$ input-only keys are necessary and sufficient to exclude this guard.** A key rules out the open interval $(k-1,k+1)$. The guard contains $0,2,\ldots,2\lfloor n/2\rfloor$. An open interval of length two contains at most one of those points. For the upper bound, split $[0,n]$ into $t=\lfloor n/2\rfloor+1$ equal closed intervals. Each has length $n/t<2$. Its midpoint is an admitted rational key and excludes the whole interval, including both endpoints. Thus even for a *closed* guard and a one-equation common result, no fixed number of input-only proposals can serve all widths. The lower bound already uses native integer observations. [Sharp lower bound and midpoint construction in Lean](thesis-review-40.lean) · [Seven widths checked by the compiler's arithmetic solver](thesis-review-40.py)

## When the client fixing the key comes second {#order}

Keep the calls' width, recursion depth and positions. Exchange only their flags. The repair using unconditional rows alone, revision `de5fd6a`, still rejects the order $1,0$. Even replacing the whole successor branch with literal zero leaves a numeric abduction failure. Reversing the internal list of numeric rows on the retry also fails on that reduced program. The source-level order has changed which premises guard the obligations. [Two client orders](thesis-review-40.py) · [Numeric row diagnostic](thesis-review-40-rows.patch)

Write $O_1$ for the first package opening and $O_2$ for the second. In the reduced program, the numeric rows for the client include an unconditional admission for the first call, a row $O_1\Rightarrow A_2$ requiring admission of the second call, and a row with premise $O_1\land O_2$ for its result. At flag zero, $A_2$ forces the second key to zero. The deepest row can use this equality because it already assumes $O_1$. The earlier row has to keep proving $A_2$ wherever $O_1$ holds. [Program](interior_result_key.gadt) · [Conditional-provider countermodel](thesis-review-40.lean)

**Ranked conditional cut.** Give each active provider row a natural-number rank. Keep $P$ and every conclusion. An added premise $H_i$ is sound if $P$, $D_i$, and the original implications of strictly smaller rank entail $H_i$. The strengthened system implies the original by induction on rank. In a valuation satisfying the strengthened rows and $D_i$, induction gives the earlier implications, so $H_i$ holds. Applying the strengthened row yields $C_i$. The converse drops $H_i$ from the evidence required to use an original row. At every witness choice satisfying the original rows, $D_i$ entails $H_i$, so the strengthening also preserves the live witnesses of that guard. [Machine-checked ranked cut and witness lemma](thesis-review-40.lean)

The rank condition prevents circular justification. For two unconditional rows with conclusions $x=0$ and $y=0$, importing each conclusion into the other's premise leaves $y=0\Rightarrow x=0$ and $x=0\Rightarrow y=0$. Both implications hold at $x=y=1$. Each provider must be proved before another row can rely on it. [Cyclic counterexample](thesis-review-40.lean)

InvarGenT uses premise length as the rank. After the ordinary search and the retry with unconditional constants fail, it looks for active rows whose premises are shorter and whose atoms all occur in the target premise. It solves their conclusions together with $P$ and the target premise. Only newly available constant bindings on variables of that guard can trigger the extra search. A variable keeps its original scope. With the reversed clients this recovers the full scheme for both the literal-zero and recursive programs. In both orders the recursive program reaches the tuple check at iteration two. The recursive cases with three clients at flags $1,0,1$ and $0,0,0$ also retain the scheme and each print three zeros. [Compiler and scheme checks](thesis-review-40.py)

The rank theorem allows more than the compiler's syntactic test. For example, $x\le0$ entails $x\le1$ although those singleton premises share no atom. A proof order that puts the second premise's obligation first can license that use. Which additional entailments help candidate search remains open. The rank decreases within one numeric retry, and the table can still change the predicates on its next pass. This proof gives no bound on the number of outer updates, even when a small solution exists. [A repeating jump and caller demand](thesis-review-21.html#feedback)

## Reproducing the checks {#replay}

InvarGenT revisions `de5fd6a` and `f11480e` implement the unconditional and ranked conditional retries. At the latter revision the OCaml 5.3 compatibility build passed all 369 active suite cases, with ten recorded as TODO. All 188 earlier example signatures were byte-identical, and the two new regression programs produced the expected schemes. Run Lean 4.19 on [the proof file](thesis-review-40.lean). The finite-probe proofs clear denominators and use integer arithmetic on the rescaled coordinates. Run `python3 thesis-review-40.py --compiler /path/to/InvarGenT.native` with Python's `z3-solver` and OCaml available. The replay compares the exported domain and package with the displayed formulas over both integer and rational-linear coordinates. Add `--before` with a compiler at `ea0cf2c` to reproduce the client-placement comparisons, and `--unconditional` with `de5fd6a` for the scope of the first repair. The program checks use a budget of two throughout. Add `--chains` to run the three-client comparisons.

To inspect the two client admissions, apply the [row diagnostic](thesis-review-40-rows.patch) to `ea0cf2c` and pass the resulting compiler as `--rows`. The replay checks which admission is unconditional and which is guarded by a preceding opening in the first `NUMROWS` block for each order. For the iteration trace, apply the [iteration diagnostic](thesis-review-22-trace.patch) and [tuple diagnostic](thesis-review-39-trace.patch) to each compiler revision. Pass the resulting binaries as `--trace` and `--old-trace`. For the arithmetic checks, build [the numeric driver](thesis-review-39-numeric.ml) as `src/JointOracle.native` and pass it as `--numeric-driver`. Its 55 checks cover six rational grids and seven widths of the closed guard.
