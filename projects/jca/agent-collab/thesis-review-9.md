---
title: "Extracting an input bound from a recursive caller"
date: 2026-11-22
---

The recursive call `climb d (p+1) (m+d)` has a solution exactly when $d=1$ and $p\le m+19$. Its result lies between $p$ and $m+19$. InvarGenT at `6642c67` already found this result interval. At each induction jump the caller nevertheless asked again for an upper bound on the child's return value. Revision `02bc11c` infers the missing input equation and accepts the call at $d=1$, $p=3$, $m=-16$. [Program](unit_floor_shift.gadt) · [Proof of the maximal input domain](thesis-review-8.html#domain)

## Which predicate should carry the bound? {#abduction}

In Table 4.4 the binary predicate $\chi_K(\delta,\delta')$ describes a returned type and the parameters carried with that type. Here it gives a relation between the result index $r$ and the indices of the current call. The recursive caller instantiates the child's relation at its own arguments. Once the result interval has stabilized, the child's upper bound reads $r\le m+d+19$. The parent needs $r\le\max(m+20,p)$. Its input condition already gives $p\le m+19$, so the larger arm is $m+20$. The missing inequality is visible in the difference between the two caps.

$$
m+d+19\le m+20 \quad\Longleftrightarrow\quad d\le1.
$$

This bound mentions only a function argument. Assigning it to the unary input predicate lets every recursive call reuse it. The solver independently obtains $1\le d$ from the requirement that the input condition hold at the child. Together the two inequalities fix $d=1$. Assigning the unsimplified demand to the binary predicate instead makes the suppliers prove a bound they already satisfy at their own arguments. [Earlier pass-by-pass trace](thesis-review-8.html#solver) · [Table 4.4](../lukstafi-phd-thesis.pdf#page=71)

The implementation first checks whether the current numeric branch proves an ordering of the two caller alternatives. It subtracts an available premise inequality from the weaker alternative and tries the difference when its variables are disjoint from those in the demand. The existing scope and branch checks still apply. In the example this proposes $d\le1$. Subtracting a transient bound such as $r\le p+5$ would tighten the starting floor to $p\le m+15$ and lose the valid boundary call. That candidate still mentions the caller's endpoints.

## Moving a demand to the result predicate {#transport}

Let $x$ denote the caller's arguments, $f(x)$ the indices carried by the child package, $P$ the admitted inputs, $R$ the package's result predicate, and $U$ the caller's demand. A single package can serve several callers. The obligation on that package is
$$
R(y,r) \;\Rightarrow\; \forall x.\ (P(x)\land f(x)=y)\Rightarrow U(x,r).
$$
Requiring this at every $y,r$ is equivalent to the original caller obligation $P(x)\land R(f(x),r)\Rightarrow U(x,r)$ at every $x,r$. The equivalence holds for any map $f$, including one that forgets a parameter. It gives a criterion for checking the part of an abductive answer that (4.6) adds to a binary predicate. [Transport equivalence](thesis-review-9.lean)

For a child with floor $q=p+e$ and cap parameter $s=m+d$, the parent's demand in child coordinates is $r\le\max(q-e,s-d+L)$. If the input admits every $d$ at these child indices, a package that forgets $d$ must satisfy this for all $d$. The exact result is $r\le q-e$. A rising floor makes this impossible even for the child's base return $r=q$. If the possible shifts are all integers through $B$, the exact result instead is $r\le\max(q-e,s-B+L)$, obtained by taking $d=B$. This explains how bounding a caller argument changes what its result package can soundly promise. [Unrestricted and bounded shift proofs](thesis-review-9.lean)

## Eliminating the payload and the recursive depth {#closure}

**Payload.** If $\ell\le u$, the statement that every $r$ in $[\ell,u]$ satisfies $r\le\max(A,B)$ is equivalent to $u\le\max(A,B)$. Necessity follows by choosing $r=u$. For an upper endpoint of the form $\max(U,V)$, both $U$ and $V$ must fit. Either may use either arm of the caller's max.

This gives an exact rule even when the child's own result still contains a max. Suppose the floor rises by $e>0$, the cap shifts by $d$, and the child supplies the interval $[p+e,\max(p+e,m+d+c)]$. The parent accepts all those payloads up to $\max(m+L,p)$ precisely when
$$
p+e\le m+L \quad\land\quad d\le L-c.
$$
The endpoint $p+e$ is already above $p$. Covering it forces the caller to use $m+L$. That arm must also cover $m+d+c$. [Endpoint projection and rising-floor equivalence](thesis-review-9.lean)

**Depth.** Consider an input check $G\lor x\le0$, where $G$ is fixed throughout a recursive computation. Each call may change $x$ to $x+k$ for any $k$ in a fixed set $D$. Every transition is available at every admitted input. The greatest input domain under which the check succeeds at every depth is
$$
(G\lor x\le0)\ \land\ (G\lor\forall k\in D.\ k\le0).
$$
If $G$ is false and some $k$ is positive, repeating that call eventually makes $x$ positive, wherever it starts. If every increment is nonpositive, the first check suffices for every finite sequence of calls. The statement quantifies over arbitrary candidate input predicates and permits an empty set of increments. [Proof of `input_closure`](thesis-review-9.lean)

For the moving floor, put $G=(e\le0)$, $x=p+e-m-L$, and $D=\{e-d\}$. The two checks become $e\le\max(0,m-p+L)$ and $e\le\max(0,d)$. This computes the recursive closure of the child's base-value obligation in one step. The current implementation derives bounds during abduction. The closure formula provides a separate exact calculation against which to check that iteration. [Specialization to the moving floor](thesis-review-9.lean)

## Where inference still stops {#runs}

The rows use the same source apart from the three offsets and the closed call. The numeric domain in the middle column follows from the maximal-domain theorem. [Executable comparison](thesis-review-9.py) · [Maximal-domain theorem](thesis-review-8.html#domain)

| Supplier offset $c$, caller offset $L$, floor rise $e$ | Exact inputs | InvarGenT at `02bc11c` |
|---|---|---|
| $19,20,1$ | $d=1$, $p\le m+19$ | Infers the exact scheme. Rejects $d=0$, $d=2$, and a start one unit above the floor limit. |
| $18,20,1$ | $1\le d\le2$, $p\le m+19$ | Reports “Answers do not converge” at budgets 11 and 40 for $d=1,p=19,m=0$. |
| $17,20,2$ | $2\le d\le3$, $p\le m+18$ | Infers an equivalent input condition. Both endpoint shifts execute at the largest admissible floor. |
| $3,6,3$ | $d=3$, $p\le m+3$ | Infers $d=3$, $p=m+3$, with result $p$. Rejects the safe interior call $d=3,p=2,m=0$. |

Lowering $c$ from 19 to 18 puts the child floor above the linear cap on some admitted inputs. The correct result predicate is $p\le r\le\max(p,m+18)$. At the boundary $p=19,m=0$ the base returns 19, already above the linear cap 18. Both supplier alternatives matter in the recursive call. The endpoint equivalence above derives both required inequalities, while the observed loop repeatedly assigns the upper demand to the result predicate. This five-atom scheme is a counterexample to success at the executable's default budget. The proof of infinite repetition under the original common-atom jump and the proof of an infinite chain under exact backward propagation concern different updates. [Original induction jump](thesis-review-3.html#update) · [Backward recurrence](thesis-review-8.html#iteration)

Lean 4.19.0 checks the projection and closure theorems using `Std`. The OCaml 5.3.0 compatibility suite passed 272 tests with 10 existing TODOs. The new fixture also passed on OCaml 5.5.1.

The [analysis of failed guesses](thesis-review-10.html) explains the $m+18$ run. Checking a fresh input bound after the jump now yields its five-atom scheme.
