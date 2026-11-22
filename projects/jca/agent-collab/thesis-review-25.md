---
title: "Two calls at the same state can need different package parameters"
date: 2026-11-22
---

A recursive function with base results 0 and 4 has a one-equation solution. Current InvarGenT misses it at every outer iteration budget with default component settings. Another function, with base results 1 and 2, lets us follow the induction jump itself. Its postcondition alternates through pass 40. One of the two proposals already has enough information to type the program. Using it requires two different choices of package parameter at the same input state. [All-budget counterexample](scaled_coordinate.gadt) · [Unshifted program](observed_coordinate.gadt) · [Shifted program](translated_coordinate.gadt) · [Lean proofs](thesis-review-25.lean)

## A counterexample at every outer budget {#scaled}

Use the states `A : State 0` and `B : State 1`. At depth zero, `run` observes 0 at `A` and 4 at `B` with an index-preserving external function. At positive depth it returns 0 at `A`. At `B` it opens a recursive call at `B`, returning 5 if the result is at most 0 and returning 4 otherwise. Both external clients require at most 4. The exact scheme $\forall i.\,\mathsf{State}(i)\to\mathsf{Nat}\to\exists().\,\mathsf{Num}(4i)$ checks and executes. The recursive result at `B` is 4, so the branch returning 5 cannot fire.

**With the default component settings at `a3151c0`, no outer budget succeeds.** At budget zero the solver times out after the first update on both available attempts. At budget one, each of the six attempts completes pass 0, enters pass 1 and returns a numeric abduction failure. There are no discard retries. On this path the outer budget is tested only on the successful pass-0 update. The pass-1 failure exits before the next budget test, and the next attempt is selected from the failure kind. Thus replacing one by any larger budget follows the same six paths. The traces at 1, 11 and 10,000 agree event for event. This refutes a convergence guarantee even under a constant bound large enough to admit the displayed solution. [Program](scaled_coordinate.gadt) · [Pass trace and controls](thesis-review-25.py)

The coefficient search and the iteration budget control different decisions. Increasing `-postcond_rotations` alone from 3 to 4 still fails. Increasing `-num_abduction_rotations` alone to 4 infers a valid scheme and executes both clients. With base results 0 and 5, radius 4 again fails and radius 5 succeeds. The binary postcondition itself can use unit coefficients. For base results 0 and $b>0$, admit $i\le b$, choose parameter $k=i$, and require $k\le o\le b$. A recursive opening at `B` now guarantees $o\ge1$ and excludes the dangerous branch. Lean checks this certificate for every positive integer $b$. For $b=4$, the compiler still fails on the written band with its default inner search and accepts it with abduction radius 4. [Exact and unit-coefficient certificates](thesis-review-25.lean) · [Executable comparisons](thesis-review-25.py)

## What the binary postcondition describes {#choices}

Write $i$ for the state index, $k$ for the parameter chosen at a call, and $o$ for the hidden index of the number found when the result is opened. The binary predicate $R(k,o)$ tells the caller which results to handle at its chosen $k$. The unary predicate on the function's arrow determines which choices of $k$ the function admits at $i$. Each use may instantiate that arrow. A call fixes $k$ before seeing its result.

In the shifted program the base case returns 1 at `A` and 2 at `B`. A successor at `A` returns 1. At `B` it opens a recursive call at `B`, returns 3 if the result is at most 1, and otherwise returns 2. Both external clients require at most 2. One solution chooses $k=i$ everywhere and sets $o=k+1$. The dangerous branch is then unreachable.

Here is a second solution, using exactly the interval InvarGenT proposes on a full pass. Admit the arrows with $k\le i\le k+1$ and give each one the postcondition $k+1\le o\le k+2$. The definition must verify **every** admitted arrow. At either state its actual result $i+1$ belongs to that interval. The following instantiations establish the recursive step and the external bounds.

| Call | State index $i$ | Chosen $k$ | What the opening guarantees |
|---|---|---|---|
| External call at `A` | 0 | 0 | $1\le o\le2$ |
| External call at `B` | 1 | 0 | $1\le o\le2$ |
| Recursive call at `B` | 1 | 1 | $2\le o\le3$, so the guard $o\le1$ fails |

**The two choices at `B` are necessary for this interval.** Suppose all calls there have the same $k$. The external client requires every $o$ at $k$ to be at most 2. The recursive guard requires every such $o$ to exceed 1, since the guard would otherwise require the successor result to have both indices 2 and 3 in the joined typing obligations. The base case requires 2 to be present. Over the integers the relation at $k$ must therefore be exactly $\{2\}$. No interval $[k+1,k+2]$ has this property. InvarGenT accepts and executes the two-choice scheme written above and rejects the same interval with $k$ tied to the input. [Sufficiency and necessity](thesis-review-25.lean) · [Both written interfaces](thesis-review-25.py)

## What the iteration does {#iteration}

For an offset $z$, replacing an opening relation by $R'(k,o)=R(k,o-z)$ transports every solution of the unshifted numeric rows to the shifted rows. Translating back gives the inverse. This preserves legal pre-observation choices, recursive openings, the declared observation, and both clients. An exact solution for every offset is $o=k+z$ with $k=i$. A relation that forgets $k$ cannot solve these rows for any offset. Its base at `A` puts $z$ into the relation, where the recursive call at `B` can see it. [Translation and parameter-necessity proofs](thesis-review-25.lean)

At offset 1 the solver infers the exact local match type $\mathsf{State}(i)\to\mathsf{Num}(i+1)$. With the default jump threshold the final search attempt makes these binary updates on passes 4 through 40.

| Pass | Supplier proposal | Caller contribution stored with it |
|---|---|---|
| Even | Parameter $i$, payload $i+1\le o\le i+2$ | $i\le0$ |
| Odd | Empty parameter tuple, arbitrary numeric payload | $o\le2$ from each client |

On an even pass the upper endpoint at `B` is 3. Abduction can ensure the client bound by requiring $i\le0$, which excludes its call at `B`. On an odd pass the caller again demands $o\le2$, but the empty tuple loses the distinction needed by the recursive guard. With the default threshold 8, no numeric jump runs in the recorded passes. Moving the threshold to 3 runs the jump on passes 3 and 4 and yields the same alternation from pass 5 onward. The earlier common-atom example proves an infinite recurrence for a particular Table 4.4 update rule. Here the evidence for the current implementation ends at pass 40. [Trace checks](thesis-review-25.py) · [Earlier infinite recurrence](thesis-review-3.html#update)

## Giving a consumed match a contract {#contract}

At offset zero, both `let t = (match state with …) in obs t` and `obs (match state with …)` now infer $\forall i.\,\mathsf{State}(i)\to\mathsf{Nat}\to\exists().\,\mathsf{Num}(i)$ at budget 4. After the existing attempts fail, inference gives the match arms a fresh local function. Its ordinary unary arrow predicate records $\mathsf{State}(i)\to\mathsf{Num}(i)$. Instantiating the declared observer type then carries the index into the package. The closure keeps the captured environment. Scrutinee, failed guard, selected body and observer each execute once in their original order in the effect test. A local monomorphic alias retains its sharing across uses. [Previous failure at all budgets](thesis-review-24.html#counterexample) · [Effects, captures and higher-order uses](thesis-review-25.py)

There is an exact semantic criterion for introducing this helper with the other predicates fixed. Let $d$ range over legal definition histories, $c$ over legal call histories, and $a$ over candidate arrow instances. At an available observation $v$, allow $a$ precisely when the body checks at $a$ for **every** $d$ with that observation. This gives the largest safe helper relation. There exists a safe relation covering all calls exactly when the largest relation covers them. At each $c$ at least one allowed arrow must also satisfy the continuation. Choosing one per call history suffices. The relation need not have a finite conjunctive presentation. In the two-valued capture example a local choice exists in each environment, but hiding the captured bit makes their shared relation impossible. [Elimination, thinning and capture example](thesis-review-25.lean)

## When a caller rejects a provisional result {#retry}

The type-indexed version returns `Mark` at `M : Tag Marker` and `Box` at `C : Tag Cargo`. An external polymorphic identity observes the result. Merging the two caller demands into an empty-parameter package produces the incompatible equations $o=\mathsf{Marker}$ and $o=\mathsf{Cargo}$. Unifying that stored proposal used to abort the search. InvarGenT now backtracks to its producers, then checks the replacement against both original callers. It infers $\forall a.\,\mathsf{Tag}(a)\to\mathsf{Nat}\to\exists().\,a$ at budget 5. Demanding a `Marker` at the `Cargo` client still fails. [Type-indexed program](observed_tag.gadt) · [Certificate and necessity of a parameter](thesis-review-25.lean)

Backtracking can also regenerate the same proposal with fresh names for its local witnesses. In one ill-typed client an instrumented earlier compiler reached 64 discards, repeatedly renaming the witness that had been forced to `Marker`. For a retry on the same pass, InvarGenT now reuses names when a sort-preserving bijection fixes the parameters and reproduces the entire previous formula. Each opening keeps its own local instance. The same client now terminates with a type error after 20 discards. [Discard and opening checks](thesis-review-25.py) · [Witness transport](thesis-review-25.lean)

Run `lean thesis-review-25.lean` with Lean 4.19 and `python3 thesis-review-25.py /path/to/InvarGenT.native` with OCaml available. The driver's optional arguments compare named historical revisions and instrumented executables. For the current trace, apply the three diagnostic patches in order to InvarGenT revision `a3151c0`. The compiler suite passed 329 active tests with 10 existing TODOs. All 164 example signatures generated before the match-contract change matched byte for byte. [Pass trace](thesis-review-22-trace.patch) · [Interface trace](thesis-review-23-interface.patch) · [Demand and jump trace](thesis-review-24-feedback.patch)
