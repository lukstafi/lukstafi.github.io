---
title: "When can the induction jump reuse a failed guess?"
date: 2026-11-22
---

InvarGenT records $p\le m+19$ as a failed guess on pass 2 of the moving-cap example. Every valid type for this function must nevertheless imply that inequality. The solver needs to keep it and add $1\le d\le2$. Recovering the second upper bound on pass 8 lets the definition converge on pass 10. [Complete program with both boundary calls](moving_cap_interval.gadt) · [Comparison driver](thesis-review-9.py) · [Lean proofs](thesis-review-10.lean)

## The rejected inequality is necessary {#necessary}

The function takes an arbitrary unindexed natural number as its recursion depth. At floor $p$ and cap parameter $m$, its base case returns $p$. Its recursive case calls the child at floor $p+1$ and cap parameter $m+d$. The parent must supply that child's return $r$ to an operation requiring $p\le r\le\max(p,m+20)$. The operation can return the floor or a payload at most $m+18$.

Take any admitted input to any valid scheme, with arbitrary input and result predicates. Its child must also be admitted. That child can return its base value $p+1$, which the parent must accept. Since $p+1>p$, it follows that $p+1\le m+20$, hence $p\le m+19$. This proves the inequality for every admitted input. [Proof of `cut_is_necessary`](thesis-review-10.lean)

Now try $p\le m+19$ as the *whole* input condition. It admits $d=0,p=19,m=0$. The child has $p=20,m=0$ and violates the condition. No choice of result predicate repairs that recursive call. Adding $1\le d\le2$ does repair it. The five-atom scheme is
$$
P(d,p,m)=(p\le m+19\land 1\le d\land d\le2),\qquad
R(d,p,m,r)=(p\le r\land r\le\max(p,m+18)).
$$
Consequently, a rule excluding every complete input predicate that entails the failed guess would exclude every solution. InvarGenT applies its discard test to local abductive answers. The trace shows that this particular test reaches the proposed input repair. [Invalid guess and certified refinement](thesis-review-10.lean) · [Proof that the input domain is maximal](thesis-review-8.html#domain)

## What a discard certifies {#cuts}

A branch-coverage failure and a failed implication justify different conclusions about stronger answers. Let $A$ be a candidate answer and $D$ the guard of a branch that requires a witness. If $A\land D$ has no witness, strengthening $A$ cannot create one. On a later pass the guard might be $E$. Every coverage failure at $D$ transfers to $E$, under every strengthening, exactly when $E\Rightarrow D$. Sufficiency follows by taking a proposed new witness and applying both implications. For necessity, choose a point satisfying $E$ outside $D$ and take the singleton containing that point as both candidates. It has a new witness. This converse quantifies over arbitrary predicates. [Coverage transport theorem](thesis-review-10.lean)

For a pointwise obligation $G$, failure of $A\Rightarrow G$ gives one counterexample. That counterexample can disappear when $A$ is strengthened. In fact, *every nonempty strengthening* of $A$ fails the same obligation exactly when no point of $A$ satisfies $G$. A single good point gives a successful singleton strengthening. This criterion isolates what can be inferred from the one obligation before considering other branches. [Nonempty-refinement theorem](thesis-review-10.lean)

In Table 4.4 a failed call to the next iteration can send the previous split answer back to the search as a discard. At revision `02bc11c`, the numeric parameter test rejects local answers implying the recorded condition. On the example above it rejects the conjunction $p\le m+19\land d\le2$ because of its first conjunct. The test has remembered a formula but no witness showing why all its refinements would fail under the current postcondition. [Table 4.4](../lukstafi-phd-thesis.pdf#page=71)

## Checking a replacement on the widened pass {#repair}

At the recursive call the child promises $r\le\max(p+1,m+d+18)$. The parent needs $r\le\max(p,m+20)$. The candidate becomes visible once the abducer has collected the equations relating the two sets of arguments. Since $p+1>p$, the caller's $m+20$ arm must cover $p+1$. It is therefore larger than $p$ and must cover $m+d+18$ too. Subtraction gives $p\le m+19$ and $d\le2$. Preservation of the input domain supplies the complementary bound $1\le d$. [Endpoint lemma](thesis-review-10.lean) · [Transport through the child parameters](thesis-review-9.html#transport)

InvarGenT revision `2f2e099` tests this alternative on a fresh widened pass. It uses the completed answer's equations, checks the scope of the proposed inequalities, and replays all original unsplit positive numeric obligations. Each previously possible branch must remain possible. Recursive uses also go through the solver's existing validation. The ordinary search keeps its discard list. If the new pass itself fails and backtracks, that retry uses the usual cuts. The recovery is enabled for positive problems with binary predicates.

| Experiment on the $m+18$ example | Result |
|---|---|
| Original solver at `02bc11c` | Reports “Answers do not converge” at budgets 11 and 40. |
| Clear the old numeric discards at the jump, using the original candidate search | Still reaches the default limit. |
| Generate both input bounds, applying the inherited discard test to the replacement | Rejects the replacement and reaches the default limit. |
| Generate the replacement on a fresh widened pass and check the current obligations | Pass 8 recovers both inequalities. Pass 10 finishes with the five-atom scheme. |

Both $d=1$ and $d=2$ compile and execute at $p=19,m=0$. Inference rejects $d=0$, $d=3$, and $p=20,m=0$. With offsets $c=3,L=6$ and the same unit floor rise, the solver also finds the input range $1\le d\le3$, $p\le m+5$. [Reproducible comparison](thesis-review-9.py)

## The two symbolic shifts {#regions}

The strictly missed endpoint supplies the decisive comparison in this repair. With a symbolic floor rise $e$, the child floor may equal the parent floor. The program requiring both a stationary and a rising call still fails numeric abduction. Its solution has a conditional input bound. The general convergence question for the repaired iteration remains open. [Two symbolic increments](moving_floor_symbolic.gadt) · [Their exact input domain](thesis-review-8.html#domain)

At $c=19,L=20$ the exact integer domain splits into two regions. The stationary region has $e=0,d\le1$. The rising region has $e=d=1,p\le m+19$. Both use the same result band. With the result predicate fixed, the union of any family of safe, recursively closed input domains is again safe and recursively closed. Each admitted point belongs to one member, which supplies both its local safety proof and its children's membership in the union. [Region equivalence and union theorem](thesis-review-10.lean)

A control run isolates the rising region by applying an identity function of type $\forall i[1\le i].\,\mathrm{Num}(i)\to\mathrm{Num}(i)$ to $e$ in the successor branch. On the rising boundary call the executable infers $e=d=1$ and $p\le m+19$. Weakening the identity's guard to $0\le i$ makes that same call fail. Duplicating the original successor body on the two sides of `eif e <= 0` still reaches the iteration limit. Recovering and combining the input regions is the remaining inference problem.

Lean 4.19.0 checked the proofs using `Std`. The OCaml 5.3.0 compatibility suite passed 273 cases with 10 existing TODOs. All 130 previously generated signatures compared byte-for-byte equal. The new two-call fixture also passed on OCaml 5.5.1.

The next review characterizes the two maximal convex domains over rational indices and tests which calls the solver can combine. [Covering stationary and rising calls](thesis-review-11.html#convex)
