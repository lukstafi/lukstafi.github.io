---
title: "When can two typings determine one recursive result?"
date: 2026-11-22
---

Two calls to `run s width d` can choose different type parameters. The harder case is one call whose result is inspected twice. On the negative state $s=-1$, the first inspection must exclude zero and the second must exclude $-2$. At positive width $n$, every permitted interval $[k,k+n]$ contains $s$. Only the interval ending at $-1$ excludes zero. Only the interval beginning at $-1$ excludes $-2$. Their intersection is the singleton $\{-1\}$. InvarGenT at revision `4fd76e5` checks both inspections on the same opening at budget 2. [Previous failure](thesis-review-32.html#sites) · [Two calls](two_site_interval.gadt) · [Shared opening and generated code checks](thesis-review-33.py)

## Two typings of one evaluation {#paired}

Fix the runtime arguments of a call. Its inferred input predicate admits some keys $k$. Write $P(k,r)$ for $\exists w.\,R(k,r,w)$, where $r$ is the index of the number returned at runtime and $w$ is private to the package. If the call admits both $a$ and $b$, every terminating evaluation gives a number satisfying $P(a,r)\land P(b,r)$. The two openings can have different witnesses. For instance, write the interval as $r=k+w$, $0\le w\le n$. At the observed result $r=s$, the lower key $s-n$ needs $w=n$ and the upper key $s$ needs $w=0$. [Typing rule and witness proof](thesis-review-33.lean)

In the notation of Table 4.4, let $\chi(\tau_k)$ say that the recursive function admits the arrow at key $k$. The new call clause demands both $\chi(\tau_a)$ and $\chi(\tau_b)$ at the same argument types. The consumer can then use both instantiated postconditions in (4.3), with their numeric payload indices equal. This changes the constraints presented to the iteration. The successful run finishes on pass 2, before the induction jump applies. [Table 4.4](../lukstafi-phd-thesis.pdf#page=71)

The elaborator checks the original argument expressions once. At a let that opens a saturated recursive call, it relates each package to the one returned number. It keeps separate bound variables for the two constructors' private indices. This retry handles failed interval guards on directly applied recursive functions. A test with an effect in the recursive argument records exactly three evaluations for calls of depths one and two. The exported type still describes the interval at the caller's chosen key. A later client asking for exactly $-1$ at state $-1$ and width 19 fails. Writing $r=s$ in the public postcondition lets the same client check. [Compiler replay and public type checks](thesis-review-33.py)

The shared result need not be a singleton. Let $s\in\{-3,3\}$ and promise $[k,k+n+1]$ with $s-n\le k\le s$. The two endpoint packages have intersection $[s,s+1]$, which excludes both $-1$ and $-4$. The base case uses an effectful supplier. Two consecutive base calls with the same negative state and width return $-2$ and $-3$. The inferred public type preserves the extra unit of slack. [Two-result program](two_result_interval.gadt)

## Which keys does the function admit? {#admission}

Change the base result to $s-1$ and require $n\ge1$. To contain this result, a written interval must also satisfy $k\le s-1$. With live numeric bodies in every arm, the compiler infers exactly $s-n\le k\le s-1$. The written upper key $s$ has disappeared. Now restore the branches that return a Boolean when a number hits zero or $-2$. The negative state at width 2 reaches the $-2$ arm at depth one, so the definition must fail. The repaired compiler rejects it. [Reachable-guard program](unavailable_interval_key.gadt) · [Exact inferred domain of the live control](thesis-review-33.py)

An experimental build kept both copies of the written precondition and removed only the second obligation on the **inferred** call predicate. It accepted the program, erased the reachable branch, and the emitted OCaml raised an assertion. The incorrect public signature even reported the narrowed range. That range contradicts the second typing used inside the definition. Checking the public signature in isolation would miss the bug. [Mutation replay](thesis-review-33.py) · [Coverage calculation](thesis-review-33.lean)

## When endpoints suffice {#criterion}

For a fixed proposed result $r$, consider the set of keys $k$ at which $P(k,r)$ holds. Two endpoint typings recover the full intersection on every integer interval **if and only if every such set contains all the integers between any two of its members**. If the set has that property, membership at the endpoints entails membership at every interior key. Conversely, two members with a missing integer between them give an interval on which the endpoint test is inexact. The criterion applies after projecting the private witnesses. Over integer witnesses, even the single equation $2w=k$ admits keys 0 and 2 while missing 1. [Equivalence and parity counterexample](thesis-review-33.lean)

For translated intervals $[k+A,k+B]$, the bounds are monotone in $k$. The smallest and largest *admitted* keys $L,U$ determine the exact intersection $[U+A,L+B]$, even when some intervening keys are unavailable. Both endpoints must themselves be admitted. [Attained-extrema theorem](thesis-review-33.lean)

## A fixed package can require arbitrarily many typings {#puncture}

Let the runtime input be $n\ge1$. The keys are $1,\ldots,n$. At key $k$, return any integer $0\le r\le n$ except $k$. The function actually returns zero in the base case. The recursive branch opens one call, tests $1\le r\le n$, and returns zero on the surviving path. The public client merely observes a nonnegative number. [Punctured-key program](punctured_key.gadt)

For any package, a set of sampled keys excludes a guard exactly when it includes, for each result in the guard, a key whose package excludes that result. In this example the intersection over all keys is $\{0\}$. Every positive $j\le n$ is excluded by exactly one key, namely $j$. Omitting that key leaves $j$ in the sampled intersection. Hence **exactly $n$ result-independent typings are needed** to rule out this guard using only the written packages. The source and the inductive strengthening $r=0$ have constant size as the runtime input grows. For a fixed numeral $n$, the same family also has a conjunctive presentation over integers with one private witness,

$$
\exists w.\quad 1\le r-k-(n+1)w\le n.
$$

On the stated ranges choose $w=0$ for $r>k$ and $w=-1$ for $r<k$. At equality, no multiple of $n+1$ is in $[1,n]$. With a binary-encoded coefficient this gives an exponential lower bound on the number of sampled keys in terms of formula length. The runnable source spells out the disequality using the two unit-separated inequalities. [Sharp sample bound and conjunctive encoding](thesis-review-33.lean)

The compiler checks the original package with $n\le2$ at budget 2. Allowing $n=3$ already defeats the endpoint pair. After the paired retry, each final failing guard projects exactly to $1\le k_{\rm parent}\le n$ and $2\le r\le n-1$, with both private copies reporting the same $r$. Thus $(n,r)=(3,2)$ is the first surviving integer case. Budgets 2, 40 and 10,000 give byte-identical traces within each annotation mode. No induction jump runs. Writing $r=0$ alongside the original package checks and executes at budget 2 for unbounded $n$. [Trace projections and executable controls](thesis-review-33.py)

There is a short symbolic proof. Fix a hypothetical result in the guard, then take the refuting key $k=r$. Its package excludes that very result. The total choice $k=\max(1,r)$ works for every result in the first opening, including zero. This is a proof about one evaluation that meets every admitted typing. The call made by the program still chooses its parameters before returning. Inference would have to justify admission at the proposed key from facts already available at the opening. Can Table 4.4 use the caller’s hypothetical bad result to generate that positive admission obligation? [Result-dependent refutation rule](thesis-review-33.lean)

The OCaml 5.3 compatibility suite passed 347 active tests with ten existing TODOs. All 176 previous example signatures matched byte for byte. The source replays use the OCaml 5.5 build.

Run Lean 4.19 on `thesis-review-33.lean`. Run `python3 thesis-review-33.py /path/to/InvarGenT.native` with OCaml and Python's `z3-solver`. Use `--before` with `3408672`. For `--trace`, add the opening diagnostics to the four earlier patches. To reproduce the negative control with `--missing-admission`, in an experimental checkout remove the leading `PredVarU` atom from the second endpoint's obligations, retaining its type equality, key equality and written premise. [Opening diagnostics](thesis-review-33-openings.patch) · [Earlier diagnostic patches](thesis-review-28.html#policy)

The next review implements the result-dependent choice, checks a mutation that erases a reachable guard, and proves when the key and result sets stabilize. The replay above describes revision `4fd76e5`. [Result-dependent admission](thesis-review-34.html#opening) · [Exact local closure](thesis-review-34.html#closure)
