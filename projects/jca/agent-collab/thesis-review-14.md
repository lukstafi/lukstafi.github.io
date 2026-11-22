---
title: "What the induction jump loses when two supplier caps cross"
date: 2026-11-22
---

A six-atom type is enough to type the recursive function below at every depth. InvarGenT fails on pass 2 with that solution available, for every outer pass budget that reaches pass 2. A neighboring example reaches the induction jump and exhibits a different failure. There the solver knows both supplier bounds, but widening one of them costs a unit that an attached caller needs. A change to the jump and to caller abduction recovers the greatest input domain on pass 11. [Six-atom counterexample](double_rate_supplier.gadt) · [Crossing caps](crossing_caps.gadt) · [Lean proofs](thesis-review-14.lean) · [Comparison driver](thesis-review-14.py)

## Two caps give one exact domain {#domain}

The floor starts at $p$ and advances by $e$ per recursive call. The cap parameter starts at $m$ and advances by $d$. The program passes $f=-e$ to the primitive. At each successor, the primitive requires the child’s result $n$ to satisfy $p\le n\le\max(p,m+L)$. It can return the floor, or any payload $u$ satisfying
$$
p\le u,\quad u\le n+1,\quad u\le m+c,\quad u\le\max(p,m+b).
$$
The offsets $b,c$ can depend on the rates, which stay fixed along a recursive path.

Put $C=\min(c,b)$. For $u>p$, the last inequality says exactly $u\le m+b$, so the two caps together say $u\le m+C$. At $u=p$ the floor branch already supplies the result, even when $m+C<p$. The supplier obligations are therefore equivalent to those for the single cap $C$. This equivalence holds for **every** candidate input predicate $P$ and result relation $Q$. In particular, choosing a different $Q$ cannot admit inputs that the one-cap necessity proof excludes. [Equivalence and exactness](thesis-review-14.lean) · [One-cap necessity proof](thesis-review-8.lean)

For $c\le L$, the greatest admissible input domain is
$$
0\le e,\qquad d\le L-C,\qquad e\le\max(0,d),\qquad e\le\max(0,m-p+L).
$$
One result contract attaining it is $p\le r\le\max(p,m+C)$. In the solver’s language its upper bound is a conjunction of $r\le\max(p,m+c)$ and $r\le\max(p,m+b)$. Lean checks necessity for arbitrary $P,Q$ and sufficiency on every integer grid with a positive payload increment. For a rational starting point, restrict any proposed solution to the grid containing the inputs, offsets and increments. Necessity on that grid excludes the same points. The displayed scheme works over all rationals since each clause instance can be scaled to such a grid.

At $c=19$, $L=20$, $b=19-e$, the two upper bounds reduce to one throughout the admissible domain. The constructor’s extra guarantee permits $d\le1+e$. For example, the call with $e=1,d=2,p=3,m=0$ becomes admissible. With the extra guarantee removed, the sharp bound is $d\le1$. At revision `761939f`, the stronger declaration made inference fail on pass 2. The numeric generalizer had deferred a max bound that captured an additional parameter, then copied the same bound straight back from a constructor. Revision `a52dbe2` applies the same preference when filling the remaining slots during guessing. It infers the exact six atoms on pass 9. The driver executes the newly admitted call and checks rejection at $d=3$. [Earlier trace](thesis-review-13.html#counterexample) · [Program](tighter_supplier.gadt)

## A safe rate on either side of an unsafe interval {#crossing}

Keep $c=19$ and $L=20$, and take $b=22-2e$. The cap-growth condition becomes
$$
d\le\max(1,2e-2).
$$
A positive floor rate also requires $e\le d$. Hence for sufficiently large initial slack there exists an admissible $d$ precisely for $0<e\le1$ or $2\le e$. One can take $d=e$ on either interval. Throughout $1<e<2$, **no choice of $d$ or result predicate can make the call safe for arbitrary depth**. Four input atoms and three result atoms express the whole domain and its result contract. [Checked characterization](thesis-review-14.lean) · [Unannotated source](crossing_caps.gadt)

The same greatest input domain has a **six-atom** certificate if the result package captures $d$. Use the caller’s own limit, moved back one step, as the result cap:
$$
p\le r\le\max(p,m+L-d).
$$
The input guard gives $C\le L-d$, so every supplier establishes this weaker bound. At the child the second arm becomes $(m+d)+L-d=m+L$, exactly the parent’s limit. The other arm is the child’s floor $p+e$, which the input guard already covers. This construction works throughout the two-cap family. The sharper output records the supplier caps. The shorter certificate records how far the next call moves. Writing the shorter certificate as a complete type annotation still elicits a numeric abduction failure at `752520c`. The unannotated run below succeeds with the sharper output. [Proof for arbitrary offsets](thesis-review-14.lean) · [Annotated source](crossing_caps_annotated.gadt)

The gap is observable with the supplied primitive body. Set $p=m=0$ and $d=e=3/2$. The floor and cap parameter then coincide at every depth. While calls remain legal, the largest payload above its own floor after $k$ steps is $\min(19,5k/2)$, and the primitive in the program returns exactly that amount. At depth 8 it returns 19. A parent at depth 9 receives $19+3/2$, beyond its limit of 20. The driver calls the emitted OCaml directly to observe the failed assertion. The typed interface rejects the midpoint. At the two endpoints $e=d=1$ and $e=d=2$ the same OCaml runs to depth 30. [Runtime and typechecking controls](thesis-review-14.py)

## The unit that widening loses {#jump}

Take the attached call $e=d=1,p=3,m=-16$. Its child has $p'=4,m'=-15$. The child’s true first cap is $m'+19=4$. Replacing 19 by 20 lets the child offer 5, which also satisfies its second cap. The parent can consume at most 4. No input guard admitting this attached call can make the widened offer fit. [Lean witness](thesis-review-14.lean)

At revision `a52dbe2`, the default jump starts on pass 8. The supplier proposes 19, the widened result retains 20, and the caller again asks for $r\le\max(p,m+20)$. In the trace the stored input and output predicates both repeat. The outstanding caller contribution keeps the stopping test false. The run still rejects at budget 80. This trace diagnoses a particular run. The all-budget counterexample below has a separate proof.

Two changes let the caller use the information the suppliers already provide.

1. When the input and output predicates stabilize after the jump and only the caller’s postcondition demand remains, try a tighter supplier cap for one pass. It must use the shared result interface, keep one arm of a retained bound, and tighten its other arm by a constant. The next pass resumes ordinary widening. The stopping test still checks the predicates in the repaired run.
2. If a premise bounds a payload by both $\max(F,A)$ and $\max(F,B)$, it bounds it by $\max(F,\min(A,B))$. Cover the common floor with the caller’s alternatives. For the remaining cap, it suffices for one caller arm to cover either $A$ or $B$. Trying these two choices recovers $d\le\max(1,2e-2)$. The implementation checks the candidate against the branches and the recursive arguments before accepting it.

At revision `752520c`, the default run lets the tighter cap reach the caller on pass 10. The inferred guard covers both safe rate intervals and stabilizes on pass 11. Pass numbers throughout start at zero. Replaying the entire incoming summary also solved the example, but made the older two-result program backtrack for over 180 seconds at budget 80. Restricting the replay to a changed cap brings that run back to about three seconds. [Executable comparison](thesis-review-14.py) · [Two-result program](tagged_floor.gadt)

## A constant-size solution still missed for every outer budget {#counterexample}

Now change the successful $b=19-e$ example to $b=19-2e$, keeping its two attached calls. The exact solution still has six atoms. Its inputs satisfy
$$
0\le e,\qquad d\le1+2e,\qquad e\le\max(0,d),\qquad e\le\max(0,m-p+20).
$$
The result satisfies $p\le r\le\max(p,m+19-2e)$. Both calls meet the guard, one with $e=0,d=-1$, the other with $e=d=1$. Both constructors are live, for example at $e=d=p=m=n=0$ the step permits the floor and payload 1. Lean checks a direct certificate for this scheme in addition to the greatest-domain theorem. [Counterexample source](double_rate_supplier.gadt) · [Certificate](thesis-review-14.lean)

At `752520c`, passes 0 and 1 continue. On pass 2 the numeric supplier summary includes $r\le\max(p,m+20-e)$ and $r\le\max(p,m+19-2e)$. Numeric abduction returns an error before the outer budget comparison. The trace returns that error without retrying. There is one inferred definition, and the only earlier reads of the outer limit compare it with 0 and 1. Every budget at least 2 follows the same failing path, including the execution with the outer timeout removed. Budgets 0 and 1 stop earlier. The component algorithms and their search limits are fixed throughout. The early return is in `src/Invariants.ml`, in the `Aux.Left` arm of `match answer`. The later test `iter_no >= !timeout_count` is in the successful-abduction arm. [Driver](thesis-review-14.py)

Changing the component search does change the outcome. With `-postcond_subopti_limit 1`, the same unannotated program succeeds by pass 9. The printed input bound is $d\le\max(1+2e,e)$, which reduces to $d\le1+2e$ because the scheme also infers $e\ge0$. The one retained upper result bound is $r\le\max(p,m+19-2e)$. The solver then admits $e=1,d=3$ and rejects $e=1,d=4$. On the crossing-cap program the same one-bound setting times out at the default pass limit, despite the six-atom caller-based certificate above. The choice of which bound to retain matters even when one bound suffices. [Reproduction](thesis-review-14.py)

This gives a negative answer to guaranteed **successful** convergence, even under a constant solution-size promise. An early abduction failure and an infinite sequence of outer updates are different counterexamples. The original common-atom jump also has a proved infinite recurrence on a two-inequality solution. A bounded search that fairly enumerates and verifies certificates has a different convergence argument. [Infinite recurrence](thesis-review-3.html#update) · [Bounded enumeration](thesis-review-2.html#convergence)


Lean 4.19.0 checked the proofs. To reproduce them, compile `thesis-review-8.lean` with `lean -o` into a directory on `LEAN_PATH` as `thesis-review-8.olean`, then run `lean thesis-review-14.lean`. The full OCaml 5.3.0 compatibility suite passed 292 tests with 10 existing TODOs. All 139 signatures generated at `761939f` matched byte for byte. The comparison driver also passed on the OCaml 5.5.1 build. It takes the current executable as its positional argument and accepts the executable from `a52dbe2` as `--before-replay`. [Driver](thesis-review-14.py)
