---
title: "Which calls can one convex recursive invariant cover?"
date: 2026-11-22
---

Moving one call into a `test` clause changes the type InvarGenT infers for the moving-floor function. The new type covers two safe calls that the original run failed to combine. Moving the stationary call one unit past the caller's cap exposes a limit of that repair. Over the rational indices of the thesis, no convex input invariant can cover that call together with the rising call. A partial annotation lets InvarGenT infer the full two-region domain. [Unannotated source](moving_floor_symbolic.gadt) · [Partial annotation and boundary calls](symbolic_floor_hint.gadt) · [Comparison driver](thesis-review-11.py)

## The exact domain over rational indices {#rationals}

Let $p$ be the floor, $m$ the cap parameter and $x=m-p$. Each child adds $e$ to the floor and $d$ to the cap parameter. The base case returns $p$. The caller needs $p\le r\le\max(p,m+L)$ from the child. A successor can return the floor or any payload $u$ with $p\le u\le m+c$ and $u\le r+1$. The depth is unrestricted. Assume $c\le L$. [Program clauses and the integer domain theorem](thesis-review-8.html#domain)

**Theorem.** A rational input admits a solution, allowing arbitrary input and result predicates, exactly when
$$
0\le e,\qquad d\le L-c,\qquad e\le\max(0,d),\qquad e\le\max(0,x+L).
$$
One result predicate works throughout this domain, namely the band $p\le r\le\max(p,m+c)$.

For necessity, fix an admitted point and choose a common denominator $N\ge1$ for $c,L,e,d,p,x$. Restrict the proposed predicates to inputs and payloads on the $1/N$ grid. Recursive calls and the floor-valued base case stay on this grid. Multiplying every index by $N$ gives integer numerator clauses with payload increment $N$. In particular they allow every unit increment used in the integer necessity proof. Apply that theorem to the numerator predicates and divide the resulting inequalities by $N$. This restriction works even when the proposed predicates have no finite description. For sufficiency, any proposed violation of the displayed input condition's inductiveness or of the result band's obligations uses finitely many rational values. Put those values on a common grid. The numerator band satisfies all constructor and caller obligations at stride $N$, contradicting that violation. Lean checks both implications of the integer grid lemma for every positive stride. The passage to arbitrary rationals is the common-denominator argument above. [Proofs of `grid_scheme` and `grid_exact`](thesis-review-8.lean)

At $c=19,L=20$, the integer rising case has $e=d=1$. The rational domain also admits $e=d=1/2$, $p=39/2$, $m=0$. The child floor reaches the caller limit $20$ exactly. The example runs with the float backend using exactly representable halves. [Fractional boundary and unsafe midpoint](thesis-review-11.py)

## The two maximal convex domains {#convex}

Write $s=x+L$ and $h=L-c$. For $h>0$ the exact rational domain has exactly two maximal convex subsets $S$ and $A$, given by
$$
S=\{e=0,\ d\le h\},\qquad
A=\{0\le e\le d,\ d\le h,\ e\le s\}.
$$
Their union is the exact domain. Each is closed under recursive calls. In $S$ the floor stays fixed and the domain places no bound on $s$. In $A$ the child has $s'=s+d-e\ge s$. Each region therefore supplies a solution with the same result band. When $h=0$, $S$ contains the whole domain.

To prove maximality, let a convex safe set contain a rising point $v$ and a stationary point $w$. For every positive integer $N$, the point $(Nw+v)/(N+1)$ also belongs to the set. Its floor rises, so its $d-e$ and $s-e$ must both be nonnegative. If $d(w)<0$, the numerator $N d(w)+d(v)-e(v)$ is negative for sufficiently large $N$. The same argument rules out $s(w)<0$. Thus $w$ belongs to $A$. Every safe rising point also belongs to $A$. It follows that every convex safe set lies wholly in $S$ or wholly in $A$. For $h>0$, each has a point outside the other, proving the claim. This argument uses only rational convex combinations and applies even to convex sets with open boundaries. [Lean proof of the endpoint inequality](thesis-review-8.lean)

Consequently a collection of safe test calls admits one conjunctive affine input guard exactly when all calls belong to $S$ or all belong to $A$. Necessity holds for every choice of result predicate. For sufficiency, use the corresponding region itself as the input guard.

For a concrete obstruction take $p=3$. The stationary call has $(e,d,m)=(0,-1,-18)$ and the rising call has $(1,1,-16)$. Both are safe. Their midpoint has $(e,d,m)=(1/2,0,-17)$. The child can immediately return $3+1/2$, while the parent can accept at most $\max(3,-17+20)=3$. This single base return rules out the midpoint for *any* result predicate. A finite set of test points can therefore require a nonconvex invariant even when those test points themselves are integers. The midpoint argument uses the thesis's rational index semantics. [Lean checks on the halves grid](thesis-review-8.lean)

## Where the induction jump gets stuck {#iteration}

InvarGenT normally finishes a top-level definition before processing later definitions. At revision `2f2e099`, the unannotated `climb` chooses $e=0$ before the induction jump. A later use cannot revise that choice. An attached `test` participates in the inference of the definition, as described in the thesis's appendix on generating constraints. [Thesis source](../lukstafi-phd-thesis-older.tex) · [Reproducible runs](thesis-review-11.py)

| Calls visible while inferring the definition ($c=19$, $L=20$, $p=3$) | Actual result |
|---|---|
| No attached call, rising use in a later binding | Exports the stationary region. The later use fails. |
| Rising call $(1,1,-16)$ attached | Infers $A$. The later stationary call $(0,1,-17)$ also passes. |
| Both of those calls attached | Infers $A$ and both run. |
| Stationary call $(0,-1,-18)$ and rising call $(1,1,-16)$ attached | Reports “Answers do not converge” with budgets 11 and 40. |

On the last input the three predicate comparison tests all succeed on passes 8 through 40. The input predicate has the function shape and no numeric restriction. The stored result includes the supplier band. On each pass the splitter again contributes the caller's lower and upper bounds, so the stopping test for an empty postcondition contribution fails. With an unrestricted input, accepting the repeated predicates would admit the unsafe midpoint.

The trace also shows why equality of the printed predicates alone fails to establish an infinite execution. Generalizing the suppliers allocates a fresh numeric result variable on every observed widened pass. The solver registers it among the variables owned by predicate instances. That set grows from 51 entries on pass 9 to 82 on pass 40, although the explicit predicate arguments and residual passed to the loop repeat. Extending this observation to every budget requires showing how those additional variables affect subsequent search. The failure through pass 40 is an executable counterexample to completeness at those budgets with a six-atom solution. The original common-atom jump has a separate recurrence proving failure at every budget. [Original induction-jump counterexample](thesis-review-3.html#update)

## Supplying part of the invariant {#annotation}

InvarGenT revision `e7dc91c` accepts a written result band and three input atoms on the same definition. The user supplies $d\le1$, $e\le\max(0,d)$ and $e\le\max(0,m-p+20)$. Inference adds $0\le e$, exports the exact domain and accepts the two calls whose midpoint is unsafe. It rejects a call violating each of the four input atoms individually. Both the integer boundary calls and the half-unit call execute against a primitive that checks its incoming bounds. [Source program](symbolic_floor_hint.gadt) · [Positive and negative controls](thesis-review-11.py)

A written top-level annotation in the thesis is partial. If its type is $\tau(\alpha)$ with guard $D(\alpha)$, the permitted instances are the types $b$ satisfying $\exists\alpha.\ b=\tau(\alpha)\land D(\alpha)$. The solver still infers a unary predicate $\chi(b)$. For each admitted $b$ it must show that $b$ is a permitted instance and that the body typechecks at $b$. Each recursive use instantiates the written scheme and the inferred predicate together. This formulation gives the unary predicate the variable argument expected by the splitter. The old implementation passed the entire arrow type as its argument, triggering an internal assertion even on an annotated numeric identity.

When the declared return is existential, an `efunction` in that result position now packs each returning branch with the constructor for the declared existential. Its constructor obligations check the payload bounds. Previously the compiler synthesized a second, nominally distinct package. Printing the resulting signature also requires capture avoidance. If the caller's floor is named $n$ and the package binds $n$, the printer first chooses a new bound variable $i$, preserving the lower bound $n\le i$.

One negative control exposed a separate error in guard generation. For `function x when x <= 0 -> assert false | x -> x`, the old compiler inferred $\forall a.\ a\to a$ and admitted a call at zero. Keeping the impossible branch in generated OCaml exposed the ill-typed comparison between a polymorphic value and zero. Revision `d3be076` checks the guard using the actual scrutinee type. The default integer solver infers $\forall n[1\le n].\ \mathrm{Num}(n)\to\mathrm{Num}(n)$, accepts one and rejects zero.

Lean 4.19.0 checked the grid and endpoint lemmas. The OCaml 5.3.0 compatibility suite passed 278 tests with 10 existing TODOs. All 131 previously generated signatures matched byte for byte. The new fixture also passed on OCaml 5.5.1.
