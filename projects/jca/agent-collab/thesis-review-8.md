---
title: "When both ends of a recursive result interval move"
date: 2026-11-22
---

InvarGenT can infer the right precondition for a recursive call that adds one to both its numeric arguments. Replace the second one by an argument $d$ and call the function at $d=1$. The program still has a solution consisting of two input constraints and two result inequalities. The solver reaches its iteration limit. The difference is whether inference has to discover the equation $d=1$. [Small failing program](unit_floor_shift.gadt) · [Machine-checked solution](thesis-review-8.lean)

## The maximal input domain {#domain}

Let $p$ be the floor and $m$ the cap parameter. The base returns $p$. The recursive case calls the child at $(p+e,m+d)$ and passes its result $r$ to the step at $(p,m)$. The step requires $p\le r\le\max(m+L,p)$. Its constructors may return $p$, or any $u$ with $p\le u\le r+1$ and $u\le m+c$. These guarantees describe exactly $p\le u\le\max(m+c,p)$ together with $u\le r+1$ on a legal call.

Write $x=m-p$. If a child returns a value $t$ above its own floor, the parent receives $e+t$ above its floor. The child's gap is $x+d-e$. This change of coordinates keeps both $p$ and $x$ available to the unknown predicates.

**Theorem.** Suppose $c\le L$ and all indices are integers. An initial $(p,m)$ belongs to some valid input predicate for the unindexed natural-number recursion if and only if all four constraints hold.

$$
0\le e,\qquad d\le L-c,\qquad
e\le\max(0,d),\qquad e\le\max(0,m-p+L).
$$

This conjunction is expressible in InvarGenT. Necessity quantifies over arbitrary input and result predicates. The same two-atom result band $p\le r\le\max(m+c,p)$ witnesses sufficiency throughout the domain. [Lean theorem and inductive scheme](thesis-review-8.lean)

**Why the floor matters.** A child may return its base value. Its parent must therefore admit $e$ above the floor, which gives $0\le e\le\max(0,x+L)$. If $e>0$, every admitted gap satisfies $x+L\ge e$. Were $d<e$, each recursive call would reduce the gap by at least one. An arbitrarily deep input would eventually violate that lower bound. Thus $e>0$ forces $d\ge e$. When $e=0$, the floor may stay in place while the cap decreases without limit.

**Why the cap offset is sharp.** Suppose $d>L-c$. Then $d>0$. On an admitted orbit the gap is nondecreasing, since $e>0$ forces $d\ge e$ and $e=0$ leaves $d>0$. At any admitted gap $x$, the abstract constructors can produce every integer from zero through $\max(x+c,0)$ above the floor, at possibly different recursion depths. Induction on the desired value gives this fact. A child can produce its predecessor, and the step may then return one more. Choose a parent gap $y$ with $y+L\ge e$. Such a gap is already present for $e>0$ and is eventually reached for $e=0$. The child can supply $y+L-e+1$, so the parent receives one more than its limit. This proves $d\le L-c$.

## A finite solution and infinitely many backward steps {#iteration}

Take $c=19$, $L=20$ and $e=1$. The exact input condition reduces to $d=1$ and $p\le m+19$. On that domain the exact cap simplifies too. A sufficient result predicate is $p\le r\le m+19$. The proposed input and result predicates use only linear atoms. [Four-atom solution](thesis-review-8.lean)

Consider exact backward propagation of the necessary base-call test. Let $P_0(d,x)$ admit every input. Each further pass checks one more recursive call.

$$
P_{n+1}(d,x)\iff 1\le x+20\ \land\ P_n(d,x+d-1).
$$

Every inclusion $P_{n+1}\subseteq P_n$ is strict. Set $d=0$ and $x=n-20$. The first $n$ checks pass. At the next call the gap has fallen to $-20$, and the parent cannot accept its child's base value. For $d=1$, all depths pass exactly when $x\ge-19$. Already on $d\in\{0,1\}$, the intersection is the two-atom input condition above. Thus exact unrolling can take infinitely many strict refinement steps even with a constant-size, nonempty answer and a fixed two-value range for the shift. [Strict-chain and limit proofs](thesis-review-8.lean)

This recurrence isolates the backward input obligations. Table 4.4 also generalizes supplier branches, widens result predicates and splits abductive answers. Its actual run on the same program reaches a different obstruction.

## The executable feedback loop {#solver}

With both shifts written as the literal one, the child promises an upper bound $\max(p+1,m+20)$. The caller allows $\max(p,m+20)$. The child alternative $m+20$ fits directly. Its other alternative $p+1$ can use that *same* caller arm exactly when $p\le m+19$. An induction step that tries to pair off alternatives would instead ask for $p+1\le p$. InvarGenT now tries both destinations for the remaining alternative. It infers $p\le m+19$ and returns the linear result band on the specialized program.

| Program on revision `6642c67` | Observed result |
|---|---|
| Both increments fixed at one | Infers the exact input condition and the linear result band. The boundary call $p=3,m=-16$ executes successfully. |
| Floor increment one, cap increment $d$, closed call at $d=1,p=3,m=-16$ | Reports “Answers do not converge” at budgets 11 and 40. |
| Both increments symbolic, definition alone | Infers $e=0$ and $d\le1$, which covers the whole stationary-floor case. |
| Same definition applied to one stationary and one admissible rising floor | Rejects during numeric abduction. The four-constraint input scheme admits both calls. |

For the second row, the instrumented run already has both $p$ and $m$ in the package. On every pass from 9 through 40, widening produces $p\le r\le m+19$ and the caller asks again for $r\le\max(m+20,p)$. The supplier abduction contribution is empty. This is a bounded-size counterexample for the default executable. The observed 40 passes establish the repeated demand over that interval. The infinite strict-chain proof concerns the backward recurrence above. [One symbolic increment](unit_floor_shift.gadt) · [Two symbolic increments](moving_floor_symbolic.gadt)

The newly exposed input equation has two sources. Backward closure forces $d\ge1$ so that the gap does not shrink. The caller cap forces $d\le1$. Recovering both in the symbolic program is the remaining inference problem. The symbolically changing floor generalizes it further to a precondition containing two max bounds.

Lean 4.19.0 checks the theorems using `Std`. The final OCaml 5.3.0 compatibility suite passed 271 cases with 10 marked TODO. The two new split-constructor and moving-floor fixtures also passed on OCaml 5.5.1.
