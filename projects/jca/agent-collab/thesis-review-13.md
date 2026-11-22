---
title: "Feeding a supplier’s result bounds back to the recursive input"
date: 2026-11-22
---

A size bound on a solution does not guarantee that InvarGenT’s Table 4.4 iteration finds it. The counterexample below has four input atoms and two result atoms. Removing one guarantee from a constructor makes inference succeed on the same function body. Restoring the guarantee makes numeric abduction fail on pass 2 for every outer budget that reaches that pass. The default induction jump is scheduled for pass 8. [Counterexample](tighter_supplier.gadt) · [Six-atom certificate](thesis-review-13.lean) · [Budget and runtime controls](thesis-review-13.py)

The moving-floor example has a solution with four input conditions and two result bounds. Revision `8c9d34f` still asked for the same result bounds on pass 80. Revision `8f22708` infers the six atoms on pass 9 with the default induction jump. Two calls attached to the definition force it to admit both a stationary floor and a rising floor. Their midpoint is unsafe. [Unannotated program](moving_floor_calls.gadt) · [Earlier trace and proof of the greatest domain](thesis-review-11.html#convex) · [Executable comparisons](thesis-review-13.py)

## Projecting both ends of the interval {#coverage}

Write $p$ for the floor and $m+c$ for the cap. The recursive call moves $(p,m)$ to $(p+e,m+d)$ and leaves $e,d$ fixed. The parent can consume every $r$ in $[p,\max(p,m+L)]$. The supplier offers $[p+e,\max(p+e,m+d+c)]$ at the child. Assume $c\le L$, and put $s=m-p+L$ and $h=L-c$.

The lower endpoint fits exactly when $0\le e$. Each of the two terms in the supplier’s upper endpoint has to fit under the caller’s maximum. Subtracting $p$ gives
$$
(e\le0\lor e\le s)\quad\land\quad(d\le h\lor s+d\le h).
$$
These tests are exact. To see necessity, offer the largest value in the supplier interval. For sufficiency, every offered value is at most that large.

The same caller check must work at every recursive depth. After one call the slack becomes $s+d-e$. In the first disjunction, $e\le0$ is stationary. When it fails, the inequality $e\le s$ survives all calls exactly when the slack does not decrease. The additional guard is $e\le0\lor e\le d$. In the second disjunction, $d\le h$ is stationary. When it fails, $s+d\le h$ survives all calls exactly when $s$ does not increase. This gives $d\le h\lor d\le e$.

**Together these five tests reduce to the four input atoms**
$$
0\le e,\qquad d\le h,\qquad e\le\max(0,d),\qquad e\le\max(0,s).
$$
Indeed, $d>h\ge0$ would force $d\le e$, hence $e>0$, and then $e\le s$. The second endpoint would require $s+d\le h$, an impossibility. In the other direction the four displayed atoms give every test directly. Replacing $s$ by $s+d-e$ preserves all four. This recovers the greatest domain proved earlier even when other result predicates are allowed. The result band is $p\le r\le\max(p,m+c)$. Lean checks endpoint coverage, simplification and the successor on integer numerators. Multiplying by a common positive denominator gives the rational statement. [Lean companion](thesis-review-13.lean) · [Greatest-domain proof](thesis-review-11.html)

In Table 4.4 the binary predicate relates the packed result type to its captured parameters. A call can ask the solver to strengthen that predicate. The missing fact in this example belongs to the *input* predicate. The implementation now cancels the result variable between caller and supplier bounds, uses the recursive argument equations to compute how each remaining inequality changes, and checks the proposed input guard against the branch obligations. When removing redundant atoms it also checks the obligations already proved at the recursive arguments. Testing only the present call had allowed it to delete the slope condition that the next call needs. [Table 4.4](../lukstafi-phd-thesis.pdf#page=71) · [Deriving a guard from a stationary alternative](thesis-review-9.html)

At $c=19,L=20$, the driver executes both integer calls and a half-unit call exactly on the boundary. It rejects the unsafe midpoint and four calls that violate individual input atoms. A separate client checks the inferred upper bound on a payload strictly above the floor. Asking the solver to certify that payload as at most the floor fails. [Driver and primitive bodies](thesis-review-13.py)

## An outer budget cannot rescue an early abduction failure {#reflection}

Change the sign convention for the first input. Pass $f=-e$ to the function and advance the floor by $-f$. This is an involution on rational inputs, and every branch of the two programs corresponds under this substitution. The four input conditions become $f\le0$, $d\le1$, $-f\le\max(0,d)$ and $-f\le\max(0,m-p+20)$. The result band is identical. The reflected calls use $f=0$ and $f=-1$. [Reflected source](reflected_floor.gadt)

**At revision `8f22708`, the reflected program fails for every outer iteration budget with the other solver settings at their defaults.** On pass 2 the original program offers $p\le r\le\max(p,m+19)$. The reflected program also offers $r\le\max(p,m-f+20)$. This extra atom puts $f$ into the existential package. Numeric abduction returns failure on the same pass. A partial annotation with the result band and three input atoms succeeds, and the solver infers $f\le0$.

Here the all-budget claim follows from the control flow. The trace takes the outer budget comparison on passes 0 and 1. It returns the abduction error on pass 2 without reaching that comparison or retrying. The only other read of the outer budget in the solver is after a successful return. Every budget at least 2 therefore takes this same finite failing path. Smaller budgets cannot advance farther. This is a counterexample to *successful* convergence under a solution-size promise with the component searches fixed. The original common-atom jump has a separate example that keeps iterating indefinitely if the outer timeout is removed. [Original infinite recurrence](thesis-review-3.html#update) · [Capped-pair restart theorem](thesis-review-12.html#restart)

Revision `c93489b` postpones a candidate during the guessing phase if another bound shares one arm and captures a strict subset of its parameters. In the reflected example the bound with $m+19$ can carry the result without capturing $f$. The unannotated reflected program then infers the exact scheme. This preference changes which parameter interface the early passes explore. A smaller parameter set alone gives no implication between the two bounds. The table’s original common-atom counterexample remains a negative answer to a uniform convergence claim. A decision procedure that enumerates all bounded schemes and verifies them fairly answers a different question. [Bounded-certificate search](thesis-review-2.html#convergence)

A different change of coordinates exposes a second issue. Write $p=2u+v$ and $m=u+v$. The child takes $u'=u+e-d$, $v'=v+2d-e$. Then $p'=p+e$ and $m'=m+d$ as before. The parent's upper alternatives both mention $u$ and $v$. Projecting the child result should eliminate $r$ while retaining the difference $m-p=-u$. A test that treated *every* shared index as a result index rejected this projection through pass 80. Revision `9b21d72` identifies the indices that actually disappear from all endpoint differences. It infers the guard with $e\le\max(0,20-u)$ and the band $2u+v\le r\le\max(2u+v,u+v+19)$ on the unannotated program. [Skew-coordinate source](skew_floor.gadt)

## A six-atom solution that every outer budget misses {#counterexample}

Pass the reflected rate $f$ explicitly to the step primitive and add it as an index to its result datatype. The child advances the floor by $-f$. The input guard is
$$
 f\le0,\quad d\le1,\quad -f\le\max(0,d),\quad -f\le\max(0,m-p+20).
$$
The packed result has the two bounds $p\le r\le\max(p,m+19)$.

At first the payload constructor guarantees $p\le u$, $u\le n+1$ and $u\le m+19$, where $n$ is the incoming result. The solver infers the six atoms and both attached calls execute. Now give the constructor one **additional** guarantee,
$$
u\le\max(p,m+19+f).
$$
The primitive body is identical in the two runs and satisfies the stronger declaration. It takes the minimum of its three upper bounds and returns the floor constructor if that minimum is at most $p$. Every payload allowed by the stronger declaration was already allowed by the weaker one. Hence the same scheme meets every result and caller obligation. Both constructors remain live, for example with $f=d=p=m=0$ and incoming result zero the declaration allows the floor and also payload 1. Lean checks the base, recursive input, consumer, both return cases and the primitive’s arithmetic on integer grids. A grid denominator of 1 gives the integer case. Multiplying all indices and constants in a rational clause instance by a common positive denominator gives the general case. [Source of both runs](thesis-review-13.py) · [Formal certificate](thesis-review-13.lean)

**At revision `761939f`, the solver fails with the additional guarantee for every outer pass budget**, holding the component algorithms and their settings fixed. On the unannotated source, passes 0 and 1 continue. On pass 2 the supplier summary adds $r\le\max(p,m+19+f)$ alongside $r\le\max(p,m+20)$ and $p\le r$. Numeric abduction rejects this choice before the timeout comparison, and the error reaches the driver. Budgets 0 and 1 terminate earlier with a timeout. For any budget at least 2 the only earlier comparisons are $0<B$ and $1<B$, so the same finite execution fails. There are no earlier inferred definitions whose schemes could depend on the budget. This proof also applies if the outer timeout is removed. It proves a failure to *reach a solution*. The separate common-atom example proves an infinite *outer iteration*. [Unannotated counterexample](tighter_supplier.gadt) · [Original infinite iteration](thesis-review-3.html#update)

A control separates two ways in which extra supplier information can affect a run. At revision `e78f3a1`, adding just $u\le\max(n+1,p+f)$ also caused an all-budget pass-2 failure. This addition is redundant for every instantiation, since the constructor already guarantees $u\le n+1$. Removing it leaves the constructor arity and OCaml body untouched and restores successful inference. Revision `761939f` checks whether an affine arm already follows before splitting a numeric disjunction into supplier regions. This makes both equivalent declarations succeed. The bound $u\le\max(p,m+19+f)$ in the counterexample can genuinely restrict the payload, so this simplification leaves the counterexample in place. [Redundant constructor declaration](redundant_supplier.gadt) · [Control and former failure](thesis-review-13.py)

## A result that carries its own check value {#tag}

Let the function return $(r,r+p)$ at floor $p$. The parent receives $(r,t)$ from the child and feeds $t-(p+e)$ to the primitive. The child’s second component makes this expression exactly $r$. The original six numeric atoms still suffice. Change only the packed result type to $(\mathrm{Num}(r),\mathrm{Num}(r+p))$. The base returns $(p,2p)$ and each returning constructor attaches the current floor to its own payload. This proves the scheme at every depth. [Tagged source](tagged_floor.gadt) · [Lean proof of decoding](thesis-review-13.lean)

With the default settings the splitter encountered an equation between two local result witnesses that it could assign to no unary input predicate. The solver asserted that the residual had to be empty. Its trace visits pass 9, backtracks and reaches that assertion on a retry of pass 8. Revision `e78f3a1` checks whether the current residual already proves the obligation. Otherwise it returns the failure to the existing backtracking search. The revised run reports “Answers do not converge” at outer budgets 11 and 80. The six-atom certificate gives a bounded-size counterexample at both budgets. I also interrupted a diagnostic run with the full tagged annotation after four minutes on pass 2. The certificate above follows by substitution and the Lean decoding lemma. An infinite recurrence for the unannotated run would also have to account for the state carried through the retries. [Executable comparison](thesis-review-13.py)

## Duplicating a supplier used to change a true upper bound into a false one {#arms}

Let a constructor return $i$ only when $j+1\le i$, and let another always return $j$. The result satisfies $j\le r\le\max(i,j)$. Add a third constructor with exactly the first constructor’s guard and payload. The set of possible numeric results stays the same. Yet revision `8c9d34f` then exports $j\le r\le i$. At $(i,j)=(0,3)$ the unconditional constructor returns 3. A client whose primitive asserts $r\le0$ passes inference and fails the assertion in generated OCaml. Removing the duplicate makes that same solver reject the client. [Three-branch source](choice_arms.gadt) · [Compiled counterexample and two-branch control](thesis-review-13.py)

The numeric generalizer scored an arm ordering by its *feasibility* on the supplier regions. Turning the winner into an unconditional bound instead requires *entailment* on every region. Revision `03a5cb6` proves the proposed equality or inequality against each region. During initialization it can also try an ordering on one input parameter. It checks that the ordering leaves every region live and proves the arm there, then sends the ordering itself to abduction. The old path discarded that obligation. The repaired solver returns the same true bound with two or three constructors.

## When both sides of an input guard move {#walk}

Consider a function that advances $x$ by 2 at each successor and demands $x\le-1\lor x\ge1$ at the base. Depth is arbitrary. Its greatest rational input domain is
$$
[1,\infty)\;\cup\;\{-1,-3,-5,\ldots\}.
$$
For an initial value below 1, consider the first iterate at least 1. Safety requires its predecessor to be at most $-1$. A step of exactly 2 can cross that interval only by going from $-1$ to 1. Conversely every listed point is safe at every depth. The Lean proof works on every positive-denominator grid. [Program](stride_walk.gadt) · [Proof of the first-crossing characterization](thesis-review-13.lean)

No finite formula of rational affine constraints, binary extrema and existential numeric witnesses describes this greatest domain. Splitting the finitely many alternatives gives finitely many polyhedra. Their projections onto one coordinate are intervals or points. A finite union cannot have these infinitely many isolated negative points. Every particular safe input nevertheless belongs to a finitely describable inductive domain. Starting at $-(2N-1)$, take the first $N$ negative odd points and the entire positive ray.

InvarGenT illustrates the distinction. With a call at $-9$ attached, it infers the positive ray and all five required negative points. A later call at $-8$ is rejected. At $-31$ the default pass budget fails and budget 40 succeeds. This example concerns the absence of a greatest *expressible* type. Each accepted individual call still has a finite certificate. [Runnable comparisons](thesis-review-13.py)


Lean 4.19.0 checked the companion proofs. The OCaml 5.3.0 compatibility build passed 289 tests with 10 existing TODOs. All 134 previously generated signatures matched their baseline files byte for byte. The comparison driver also passed on OCaml 5.5.1. To reproduce the historical runs, pass executables from revisions `8c9d34f` and `8f22708` as `--baseline` and `--projection`. Use `--before-pruning` with `e78f3a1` for the redundant-declaration comparison. [Comparison driver](thesis-review-13.py)
