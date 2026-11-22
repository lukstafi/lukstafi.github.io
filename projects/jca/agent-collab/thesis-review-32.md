---
title: "Choosing a recursive key when the interval and its guard move"
date: 2026-11-22
---

A parent calls `run s width d`. The child promises a number in $[k,k+n]$, where $n$ is the width and $k$ is a type parameter chosen at the call. Every legal interval contains the state $s\in\{-1,1\}$. The caller needs the result to miss zero. For $s=-1$, choose the interval ending at $-1$. For $s=1$, choose the interval beginning at $1$. These choices can be arbitrarily far apart at the same width. InvarGenT at `3408672` finds both from the written package and checks the original program at iteration budget 2. It also checks the program when an input translates the intervals and the guard together. [Original separation](thesis-review-31.html#width) · [Variable width](variable_width_interval.gadt) · [Moving guard](moving_interval_guard.gadt)

## A recursive call must still have a key {#coverage}

Fix the observed inputs. Let $[L,U]$ be the nonempty range of legal integer keys and $[k+A,k+B]$ the promised result interval, with $A\le B$. All four bounds may depend on the inputs. A nonempty result band $[l,u]$ forbids exactly the keys $[l-B,u-A]$. For one band, try $U$ if $U+A>u$ and $L$ otherwise. If some legal interval fits to the right, $U$ fits. If none fits to the right, any legal interval fitting to the left can be replaced by $L$. The rule always supplies a legal key, including when every legal opening can hit the guard. [Endpoint and coverage proofs](thesis-review-32.lean)

Coverage matters even for a single constructor. Add a state $s=0$ and call the function at width zero. Its only legal key is zero, and its only result is zero. Strengthening the call premise with “the interval avoids zero” makes the guard vacuously unreachable by eliminating the call. A total selector supplies zero here. The original guard is then reachable, and InvarGenT rejects the definition. It also rejects a call that sends a valid parent state to the zero child and a client that demands the wrong result sign. [Executable negative controls](thesis-review-32.py)

## A bound on choosing the key {#sweeps}

With $m$ nonempty bands, start at $x=U$ and visit each forbidden **key** band $[a,b]$. If $a\le x\le b$, move to $a-1$. Every move preserves every safe candidate below the current point. A full sweep either stays put at a safe key or passes at least one lower endpoint that can never be crossed again. After at most $m$ sweeps the point $p$ is the greatest safe integer at most $U$. Returning $\max(L,p)$ preserves the legal domain and is safe whenever any legal key is safe. The argument works pointwise when input-dependent bands exchange order. It bounds the work of selecting a witness for a fixed package. [Lean proof by counting lower endpoints](thesis-review-32.lean) · [Two guards whose order changes](crossing_interval_guards.gadt)

Descending order of lower endpoints gives one sweep. There is another one-sweep case even when sorting would require branching on the inputs. If $U+A\le L+B$, every legal package contains the common point $f=U+A$. For each nonempty result band with $u\ge f$, any feasible interval must lie strictly to its left. Cap the key at $l-B-1$. For every remaining band, a feasible interval must lie strictly to its right, since it contains $f>u$. Taking the greatest key under all the caps preserves these right-hand exclusions whenever a feasible key exists. The compiler tests the common-point inequality under the written premise. Empty result bands impose no restriction. [Single-pass anchor theorem](thesis-review-32.lean)

InvarGenT encodes the choices using existing numeric constraints. For example, it compares $U+A$ with $u+\tfrac12$. On integer inputs that test selects precisely one of the two endpoints. On a rational tie the graph permits the whole interval, which preserves coverage in the numeric checker. The proposal requires integral affine endpoints. A range $2k\in[1,3]$ illustrates the risk of selecting a fractional endpoint when the integer key must be 1. Additional constraints on the key can disconnect its domain. The compiler checks such constraints for the selected key against the original premise with an independently named key. It checks the written package against the proposed exclusions before retrying inference, then checks the guards in the original definition. The OCaml 5.3 compatibility suite passed 344 active tests with ten existing TODOs. All 174 earlier example signatures matched byte for byte. The regression driver verifies the entire printed public domain and result interval over both integers and reals for the width, moving-guard and crossing-guard programs. [Replay and signature equivalences](thesis-review-32.py)

## Two call sites need two choices {#sites}

Call `run s width d` twice with identical arguments. The first opening must exclude zero. The second must exclude $-2$. At $s=-1$ and any positive integer width $n$, the legal keys run from $-1-n$ to $-1$. Excluding zero forces the first key to be $-1-n$. Excluding $-2$ forces the second to be $-1$. Each call has a witness. No shared key works. At $s=1$, both can choose $1$. [Two-site program](two_site_interval.gadt) · [Incompatibility proof](thesis-review-32.lean)

Both instantiations have constant-size descriptions. For the first, the ordinary call premise together with $k+n\le-1\lor 1\le k$ suffices. For the second, $k=s$ suffices. Every opening of each selected package meets its own guard obligation.

Writing the two keys separately typechecks at budget 2 and the emitted OCaml executes. The implicit program fails the final guard. Budgets 2, 3, 40 and 10,000 produce byte-identical traces within each annotation mode. Five inference attempts finish updates 0, 1 and 2. Four reach a live guard and none enters the induction jump. The older `capped_climb` example does reach the jump. On the current compiler the caller supplies the cap on pass 8 and asks for nothing on pass 9. [Reproduction driver](thesis-review-32.py) · [Original infinite recurrence](thesis-review-3.html#update)

## What the erased key tells us about the result {#erasure}

One can type the two-site program without choosing a different interval at each opening. The key $k$ has no runtime argument. Fix a terminating execution at the other arguments and let $r$ be its observable result. If the definition meets its contract for every admitted $k$, the **same** $r$ belongs to every corresponding result set. Private witnesses for an opening can still vary with $k$. In symbols, the conclusion is $\forall k\in K.\,\exists w.\,R(k,r,w)$. To use the rule, one needs a common runtime input admitted at every one of those keys. [Quantifiers and projection](thesis-review-32.lean)

For translated intervals the intersection has a closed form,

$$
\bigcap_{L\le k\le U}[k+A,k+B]=[U+A,L+B].
$$

The two extreme keys give the necessary bounds. Every other interval contains their intersection. Here $L=s-n$, $U=s$, $A=0$ and $B=n$, so the result is exactly $s$. Writing that result in the postcondition makes the two-site program check and execute at budget 2. Adding $r=s$ alongside the original two inequalities also works, at budget 3. The base case returns $s$, and the recursive hypothesis excludes both guarded branches, leaving the same result in the step case. This gives a constant-size inductive solution for the original interval specification. [Inductive certificate](thesis-review-32.lean) Automatically inferring it requires establishing coverage for the actual admitted keys, including any restrictions learned during inference. Assuming that every key in a proposed weakening is already admitted would make the intersection too small. [Exact-result control](thesis-review-32.py) · [Earlier supplier coverage question](thesis-review-17.html)

A subsequent repair checks the same recursive opening at two admitted keys. The punctured-key example shows exactly when a fixed number of such typings runs out. [Two typings of one evaluation](thesis-review-33.html#paired) · [Exact sample bound](thesis-review-33.html#puncture)

To reproduce this revision, run `lean -o thesis-review-31.olean thesis-review-31.lean` in this directory, then `LEAN_PATH=. lean thesis-review-32.lean` with Lean 4.19. Run `python3 thesis-review-32.py /path/to/InvarGenT.native` using the compiler at `3408672` with OCaml and Python's `z3-solver` available. The optional `--before` takes revision `a549d0d`. The optional `--trace` takes the repaired executable built with the four diagnostic patches. [Diagnostics](thesis-review-28.html#policy) · [Compiler build notes](thesis-review-1.html)
