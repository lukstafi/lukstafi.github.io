---
title: "Which calls make a fixed postcondition usable?"
date: 2026-11-22
---

InvarGenT now infers the two exact postconditions that defeated the previous revision, $o=4i$ and $o=i+1$. The remaining failure occurs a step later. Give the compiler a correct width-two result interval and its admissible input parameters in the source. It can recover the written arrow and still reject the program at every outer budget. The guard check retains a range of possible recursive call parameters. A proof needs to choose one of them before opening the result. [Implicit parameter](implicit_interval_parameter.gadt) · [Same choice supplied as an argument](explicit_interval_parameter.gadt)

## Fix the result relation and solve for the calls {#calls}

Hold the binary result relations fixed. An arrow instance $h$ includes the input and the chosen package parameter. A strategy for the body at $h$ must respect the quantifier prefix. It checks the local obligations for every permitted opening and specifies which recursive arrow instances the body can use. Given a set $S$ of available arrows, let $F(S)$ contain the instances for which some such strategy uses only arrows in $S$. Mutually recursive functions can share this construction by including the function name in $h$.

A sound set of admitted arrows satisfies $S\subseteq F(S)$. The same strategy still works when more recursive arrows are available, so $F$ is monotone. Let $G$ be the union of all sound sets. A strategy witnessing membership in a sound set works in $G$, giving $G\subseteq F(G)$. Monotonicity now makes $F(G)$ sound, hence $F(G)\subseteq G$. For client demands preserved by adding admitted arrows, **some sound set covers the clients exactly when $G$ covers them**. The result concerns semantic relations with the other predicates and the legal information at each call fixed. Expressing $G$ in the thesis's answer language is a further requirement. This complements the least producer relation obtained by fixing the call choices. [Greatest-call theorem](thesis-review-26.lean) · [Least-result theorem](thesis-review-23.html#least)

For the two-state program this eliminates the unknown arrow predicate entirely. Let $a<b$ be the base values at `A` and `B`. A successor at `A` returns $a$. At `B` a recursive result at most $a$ can trigger the bad result $b+1$. Both external clients require at most $b$. Write $R_k$ for the set of values a caller must handle after choosing parameter $k$. Exactly three tests on the fixed relation decide the numeric rows.

| Use | Required result belongs to the set | Every member of the set satisfies |
|---|---|---|
| External `A` | $a\in R_{k_A}$ | $o\le b$ |
| External `B` | $b\in R_{k_B}$ | $o\le b$ |
| Recursive `B` | $b\in R_{k_R}$ | $o>a$ |

Each row chooses its own parameter. For necessity, the base suppliers force the stated memberships. A value at most $a$ at the recursive opening would require both $b$ and $b+1$ as the successor index. For sufficiency, admit just the three displayed arrows. Both calls that enter `B` use $k_R$ for their own recursive call, so $k_R$ also supports itself. Three distinct choices can be necessary. At $a=0,b=1$, give the three parameters the result sets $\{0\}$, $\{-1,1\}$ and $\{1,2\}$ respectively. Each satisfies exactly one row. [Elimination and sharpness proofs](thesis-review-26.lean)

## The exact width threshold {#width}

Take $R_k=[k,k+w]$ for $w\ge0$. With independent parameters **every width works**. Use $a-w$ and $b-w$ at the external sites to put their actual results at the upper endpoints. Use $b$ at the recursive site to put its actual result at the lower endpoint. The guard cannot fire.

If every call at `B` must use the same parameter, the exact condition is **$w<b-a$**. The shared interval must contain $b$, end at or below $b$, and start strictly above $a$. Its only possible lower endpoint is therefore $b-w$. For a uniform, writable arrow with independent choices, set $f(i)=a+(b-a)i$ and admit every $k$ with $k\le f(i)\le k+w$. Lean checks the body at every instance of that arrow, including indices other than the two constructor indices. [Threshold and written-arrow proofs](thesis-review-26.lean)

## A correct written interval still fails {#guard}

Set $a=1$, $b=2$, $w=2$. The written scheme admits $k\le i+1\le k+2$ and returns an index in $[k,k+2]$. At InvarGenT revision `3ce4575` the implicit-parameter program fails at every outer budget. At budgets at least 2, each of six searches retaining the original arm fails on pass 1. Its retry with the proposed guard exclusion reaches a stable arrow on pass 2. All six retries fail their final check that the bad arm is unreachable. The last proposed arrow contains the written input inequalities and output interval. No discard or subsequent budget comparison occurs on that path. Budgets 0 and 1 stop earlier. Traces at 2, 40 and 10,000 agree event for event. [Source](implicit_interval_parameter.gadt) · [Budget and final-guard checks](thesis-review-26.py)

The final numeric guard is a conjunction of difference constraints. Solving the recorded conjunction allows $(k,o)=(0,0),(0,1),(1,1)$ at the recursive opening. Fixing $k=2$ makes it inconsistent. Supplying the call parameter as a numeric argument lets the ordinary solver check the program at budget 2. The external arguments are $-1$ and 0, and the recursive argument is 2. Passing 0 recursively fails. The explicit program also checks and executes with width 97 and the corresponding external arguments. A sound implicit recovery would have to commit the recursive choice across every obligation sharing that call, while leaving the opened value universal within the selected interval. [Explicit program](explicit_interval_parameter.gadt) · [Guard diagnostic](thesis-review-26-guard.patch)

A later retry verifies the implicit program at budget 2 and can recover an interior parameter shared by two guards. Two finite forbidden bands still defeat the search. [Shared parameters and current counterexample](thesis-review-27.html)

## Recovering the two affine postconditions {#affine}

In the scaled program one supplier needs the numeric equation $g=0$ under a premise fixing $v=x$. Any equation $g+\lambda(v-x)=0$ suffices there. If another branch fixes $v=x'$ and $g=y$, with $x'\ne x$, the unique coefficient making the equation hold there is $-y/(x'-x)$. The solver collects these values after substituting equations inherited from weaker premises. An input can be visible through a local alias in one row and directly in another. Each candidate passes the existing scope, branch and caller checks. Three collinear branches infer the expected slope. Changing just the third result by one rejects the exact client. [Secant proof](thesis-review-26.lean) · [Signed and rational examples](thesis-review-26.py)

The translated example needs a second operation. At a base-case restart one supplier presents the line $o=i+1$. Another presents the point $(0,1)$. Their equation spaces share the line equation even though their displayed rows differ. InvarGenT already computed this intersection for product results. Its new retry also computes it for a scalar result with input parameters. The compiler first tries its original search on the whole item. After a failure with an opportunity for numeric recovery, it replays the search with both operations enabled. Both earlier programs now infer the exact result at budget 4. The same checks recover slopes $100003$, $-11$ and $17/3$. No bound on the convergence of the general predicate iteration follows from these recoveries. [Previous counterexamples](thesis-review-25.html#scaled) · [Compiler checks](thesis-review-26.py)

Run `python3 thesis-review-26.py /path/to/InvarGenT.native` with OCaml available. The optional `--before` uses revision `a3151c0`. For `--trace`, apply the review 22, 23, 24 and 26 diagnostic patches in order to `3ce4575`. To check the proofs with Lean 4.19, run the following commands from this directory. On the OCaml 5.3 compatibility build the solver suite passed 331 active tests with 10 existing TODOs. All 166 previous example signatures matched byte for byte. The CLI traces used the OCaml 5.5 compatibility build. [Pass trace](thesis-review-22-trace.patch) · [Interface trace](thesis-review-23-interface.patch) · [Demand trace](thesis-review-24-feedback.patch) · [Final guard](thesis-review-26-guard.patch)

```sh
proof_dir=$(mktemp -d)
lean -o "$proof_dir/thesis-review-25.olean" thesis-review-25.lean
LEAN_PATH="$proof_dir" lean thesis-review-26.lean
```
