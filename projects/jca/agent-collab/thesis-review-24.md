---
title: "Where the induction jump loses the state index"
date: 2026-11-22
---

The two-state recursive function now infers $\forall i.\,\mathsf{State}(i)\to\mathsf{Nat}\to\exists().\,\mathsf{Num}(i)$ at outer budget 3. Inserting a single index-preserving observation into its base case gives a constant-size solution that revision `fc7c3ab` misses at **every** outer budget. A second spelling lets us watch the caller restore the same bound through pass 40 and test the induction jump itself. [Two-state program](state_coordinate.gadt) · [Counterexample with the observation](observed_coordinate.gadt) · [Executable checks](thesis-review-24.py)

## Which facts reach a package introduction? {#placement}

In the base arm of `run`, a match on an input of type $\mathsf{State}(i)$ returns 0 at constructor `A` and 1 at `B`. The original normalization produces the following term, with $K$ the fresh constructor of the existential result.

```ocaml
let xcase = (match state with A -> 0 | B -> 1) in K xcase
```

The supplier for $K$ sees a variable of unknown type. The two equations assigning it $\mathsf{Num}(0)$ and $\mathsf{Num}(1)$ have stronger premises than the supplier row. InvarGenT collects conclusions whose premises are included in the current row's premise. Neither equation reaches that supplier. The first binary proposal admits any payload at the empty parameter tuple. [Previous interface trace](thesis-review-23.html#counterexample)

InvarGenT now retries a failed inference with the package introduction in each returning arm of a tail match. The `A` supplier sees both $i=0$ and the value 0. The `B` supplier sees both $i=1$ and the value 1. Generalization can express the common equation $o=i$. At positive recursive depth, `run B d` consequently returns 1. Its caller's guard $o\le0$ cannot trigger a return of 2. The two original search attempts still fail on pass 1. The new placement takes passes 0 through 3 and runs both attached clients. Changing the recursive call to `run A d` makes 2 reachable and inference rejects the client bound. Widening the comparison to $o\le1$ also reaches 2, as a separately typed call at depth one confirms. [Programs and pass checks](thesis-review-24.py)

## When can the witnesses be shared? {#witnesses}

Fix the outer predicate assignment and the package parameter. Let $h$ be the history available before the match and $b$ a reachable branch observation at $h$. Write $U_h$ for witnesses satisfying obligations at the outer introduction and $V_{h,b}$ for witnesses satisfying the branch obligations. A witness includes the payload monotype and any opening decision that must be shared. Branch obligations include all subsequent universal choices.

Packing after the match requires a witness function $w(h)$. For unrestricted semantic strategies it exists exactly when, at every legal $h$,
$$
U_h\cap\bigcap_{b\text{ reachable at }h} V_{h,b}\ne\varnothing.
$$
Restriction gives necessity. Selecting an element of each intersection gives sufficiency. A written scheme additionally needs a selector expressible in the answer language. Even when no branch is reachable, a supplier clause emitted outside the branch guards can require $U_h$ to contain a witness. Packing in an arm only requires a witness in $U_h\cap V_{h,b}$ there. The common state index $i$ supplies a selector for the original two-state program. With two constructors of the same unindexed type `Switch`, one arm can return `True` and the other 0. Both can return the same existential package. Their payload types have different heads, so the original match has no shared monotype. [Lean proofs of the criterion, both examples and the empty case](thesis-review-24.lean)

For fixed opening and packing operations the operational argument is associativity of sequential evaluation. Evaluate the scrutinee and guards to select an arm, evaluate that arm to a payload, then open and pack the result. Moving the final operation just inside the selected arm preserves this sequence, including effects and failure. The implementation retains the package identity and allocates a separate binding for each arm's opening decision. One test arm opens a previous package while its sibling packs an ordinary number. Another packs a closure. A runtime check records four scrutinee evaluations followed by the two failed guard comparisons in their original order. [Evaluation law](thesis-review-24.lean) · [Generated openings and runtime checks](thesis-review-24.py)

## A constant-size solution missed at every budget {#counterexample}

Change only the base computation. The external function `obs` has type $\forall j.\,\mathsf{Num}(j)\to\mathsf{Num}(j)$ and evaluates to the identity.

```ocaml
let t = (match state with A -> 0 | B -> 1) in obs t
```

Use the same unary arrow and binary result predicates as before. In a call at input $i$, choose parameter $i$. Before case selection, assign $\mathsf{Num}(i)$ to the match result and instantiate `obs` at $i$. Its contract gives the same index on return. The recursive call at `B` chooses parameter 1 before opening its result, and each top-level call uses its own input index. This is a solution of the joined obligations. Writing the scheme compiles and executes the exact source. Lean also checks that **every** result relation independent of the parameter fails, even when the unary call predicate is free. A shared relation must admit 0 from `A`. The recursive opening at `B` can then supply 2 to a client requiring at most 1. [Certificate and necessity of the parameter](thesis-review-24.lean)

At InvarGenT revision `fc7c3ab`, the base package wraps `obs t`. Distributing the successor's packages still leaves this base supplier outside the match. All four attempts, covering both placements and their guard retries, complete pass 0 and fail in numeric abduction on pass 1. There are no discard retries. Budget zero stops on the first update. For every positive budget, none of the four attempts reaches another budget-dependent decision after passing the pass-0 test. The traces at 1 and 10,000 agree. This refutes convergence under a solution-size bound for the default choices at that revision, including any polynomial bound that admits the displayed scheme. Moving `obs` separately into each base arm recovers the exact inferred type. [Source](observed_coordinate.gadt) · [Budget and placement comparisons](thesis-review-24.py)

## Does the induction jump actually run? {#jump}

Write the same base computation as `obs (match state with A -> 0 | B -> 1)`. The first two attempts fail as before. The third reaches pass 40. On every pass from 2 through 40, the supplier proposal admits $\mathsf{Num}(o)$ at $()$ without an upper bound. The two client openings each demand $o\le1$. The stored relation regains that bound, the additional input constraint is empty, and all three predicate comparisons report equality with the previous pass. The outstanding client demand prevents termination. Returning the repeated predicates would be unsound by the preceding parameter-necessity proof. [Supplier, demand and stopping-test trace](thesis-review-24-feedback.patch)

With the default jump threshold 8, the implementation calls numeric widening only when both the current and preceding passes are out of initialization. From pass 4 onward the search alternates a base-case restart with a full supplier pass. **No numeric induction jump runs in this 40-pass trace.** The scheduler marks pass 10 for one-pass supplier-cap recovery. That pass restarts, so the code path that could use the recovery flag never runs. Setting `-convergence_step 3` makes numeric widening run on pass 3. The binary proposal still carries $()$, and the caller restores the same bound through pass 40. These are finite traces. The all-budget result above uses the separate early-failing spelling. For this example successful inference must recover a parameter that distinguishes the states. Changing when the algorithm widens an empty-parameter relation cannot supply that distinction. [Both schedules and the 39 repeated updates](thesis-review-24.py) · [Original common-atom jump with a proved infinite recurrence](thesis-review-3.html#update)

The next revision introduces a local arrow predicate for the consumed match. Both spellings now infer the exact result at budget 4. Translating the payloads by one gives a new alternating pair of interfaces, one of which can already type the program with different external and recursive parameter choices. [Match contracts](thesis-review-25.html#contract) · [Shifted postcondition](thesis-review-25.html#choices)

## Reproduction {#checks}

Run `python3 thesis-review-24.py /path/to/InvarGenT.native` with OCaml on the path. Pass an executable from `e9d7a45` with `--before` for the original comparison. Pass `fc7c3ab` with `--before-contracts` for the observed failures. For `--trace`, build `fc7c3ab` with the three diagnostic patches. Run `lean thesis-review-24.lean` with Lean 4.19. The solver suite passed 327 active tests with 10 existing TODOs on the OCaml 5.3 compatibility build. The CLI and trace checks used the OCaml 5.5 compatibility build. All 162 previous generated example signatures matched byte for byte. [Pass trace](thesis-review-22-trace.patch) · [Interface trace](thesis-review-23-interface.patch) · [Demand and jump trace](thesis-review-24-feedback.patch)
