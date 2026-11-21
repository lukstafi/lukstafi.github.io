---
title: "How far can a recursive call move the cap?"
date: 2026-11-22
---

Change one argument of the recursive call from $m$ to $m+d$. A child at $m+d$ promises a result at most $\max(m+d+19,0)$. Its parent, still at $m$, can use any result up to $\max(m+20,0)$. A shift of one spends the entire unit of slack. A shift of two already fails at $m=-20$ on a tree with two successors. The repaired InvarGenT infers $d\le1$ with $m$ unrestricted. [Executable comparison](thesis-review-6.py) · [Lean proofs](thesis-review-6.lean)

## The sharp precondition {#boundary}

Write $C_c(m)=\max(m+c,0)$ and $R_c(m,r)=(0\le r\le C_c(m))$. The external function takes a parent argument $m$ and a child result $r$ satisfying $R_L(m,r)$. It returns a payload $u$ satisfying $R_c(m,u)$ and $u\le r+1$. The unindexed input $t$ can have any finite depth.

```ocaml
let rec climb d m = efunction
  | Z -> 0
  | S t -> let r = climb d (m + d) t in
           let B u = step m r in u
```

Fix $d$. Let $P(m)$ admit the starting argument and let $Q(m,r)$ describe a returned payload. Table 4.4 must solve these obligations after instantiating the recursive predicate at its actual argument.

$$
\begin{aligned}
P(m)&\Rightarrow P(m+d),\\
P(m)&\Rightarrow Q(m,0),\\
P(m)\land Q(m+d,r)&\Rightarrow R_L(m,r),\\
P(m)\land Q(m+d,r)\land R_L(m,r)\land R_c(m,u)\land u\le r+1
 &\Rightarrow Q(m,u).
\end{aligned}
$$

**Theorem.** Suppose $c\le L$. For any initial $m$, there exist predicates $P,Q$ satisfying all four obligations with $P(m)$ if and only if $d\le L-c$. The quantification includes arbitrary predicates, even ones outside the InvarGenT language.

**Sufficiency.** Take $P$ to admit every integer and $Q=R_c$. Zero belongs to every band. The supplier explicitly bounds the next result. At the call, $m+d+c\le m+L$ implies $C_c(m+d)\le C_L(m)$.

**Necessity.** Suppose $c+d>L$ and some $m$ is admitted. Since $c\le L$, the integer shift is positive. Every recursive argument $m+jd$ is admitted. Choose one, $z$, large enough that $z+L\ge0$. The child at $z+d$ can produce $z+L+1$, one more than the parent can accept.

To see why every valid $Q$ must permit that result, take any admitted $x$. For each natural $n\le C_c(x)$, induction on $n$ forces $Q(x,n)$. The base returns zero. For $n+1$, the child at $x+d$ may return $n$ because the cap increases with $x$. The call obligation licenses the step and its constructor permits $n+1$. At $x=z+d$, this argument supplies exactly the forbidden value. A smaller witness suffices to refute the scheme that admits every $m$. At $m=-L$ the outer limit is zero, and a child one level down may return one. [Proofs of both necessity statements](thesis-review-6.lean)

## What the induction jump sees {#run}

There are two coordinates worth following in the implementation. At the definition, the constructor states an upper bound using its formal parameter $m$. At a recursive use, the existential package instantiates that slot with $m+d$. The base case $u=0$ also proves $u\le C_c(m)$. The numeric generalizer now takes candidate extrema from the supplier formulas and retains a candidate only if every feasible projected supplier case proves it. This gives the existing parameter-capture code a reason to put $m$ in the package.

At the caller, $r\le\max(m+d+c,0)$ says that $r\le0$ or $r\le m+d+c$. The first alternative already meets the caller limit. For the second, $d\le L-c$ suffices. The numeric abducer now tries this comparison between the two remaining arms and sends the candidate through the usual scope, consistency and validation checks. The same rule works when one arm is already stronger by a constant. With supplier floor $1$ and caller floor $2$, the solver also infers $d\le1$ for offsets $19,20$.

In the zero-based trace for $c=19,L=20$, the supplier on pass 2 introduces the cap and captures $m$. Before the jump it also proves a succession of temporary bounds on depth, ending with $r\le6$ on entry to pass 8. The jump drops that temporary bound, keeps the cap and finishes on pass 9 with an empty caller demand. The emitted scheme includes $d\le r+1$, which already follows from $d\le1$ and $0\le r$. The old solver at revision `4560a1f` exhausted its default iteration budget on the start-at-zero program even when the child stayed at $m$. [Earlier trace and capture obstruction](thesis-review-5.html#runs)

| Supplier offset $c$ | Caller offset $L$ | Sole inferred input condition | Accepted and executed shifts | Rejected shift |
|---:|---:|---|---|---:|
| 19 | 20 | $d\le1$ | 0, 1 | 2 |
| 3 | 5 | $d\le2$ | 1, 2 | 3 |
| 0 | 0 | $d\le0$ | −1, 0 | 1 |
| −2 | −1 | $d\le1$ | 0, 1 | 2 |

The driver invokes inference on a fresh program for every table entry. Each program calls the polymorphic definition at $m=-L$ with input `S (S Z)`. It runs the emitted OCaml for each accepted call, including a runtime assertion for the external function's input contract. The four rejected calls fail during numeric abduction. [Run the comparison](thesis-review-6.py)

## The same cap in two constructors {#split}

Give the supplier two ways to return. Constructor `Zero` supplies $u=0$. Constructor `B` supplies $0\le u\le r+1$ and $u\le m+c$. For every legal input $r\ge0$, their union is *exactly* the old supplier relation. If $m+c<0$, only zero is possible. Otherwise the second constructor covers the whole interval. The same two-atom result predicate therefore solves the numeric obligations. The inner existential match can package its result with that same bound. [Runnable split-constructor program](split_capped_climb.gadt) · [Equivalence of the two presentations](thesis-review-6.lean)

In this program the exact max bound occurs in neither supplier. Even with $d=0$, the repaired solver reports “Answers do not converge” at the default limit. Raising the limit to 40 gives the following observations on every pass from 9 through 40.

| Component | Value after alignment |
|---|---|
| Captured parameters, old and new | Empty tuple |
| Projected suppliers | Zero, or $0\le u\le m+19$ with $0\le m+19$ |
| Generalized and widened result | $0\le u$ |
| Added by the caller | $u\le\max(m+20,0)$ |

This is a counterexample to completeness of the revised executable with its default budget. The trace records a repeated update through a finite cutoff. The earlier common-atom jump has a separate recurrence proving indefinite repetition with a constant-size solution. In the split case, a prospective repair has to *form* the missing maximum from alternative linear bounds or transport the caller's demand back to the definition and validate the captured parameter there. Retaining an extremum that already occurs in a supplier cannot discover it here. [Original Table 4.4 counterexample](thesis-review-3.html#update)

**Reproduction.** The solver runs above use InvarGenT revision `6d2c213`. The driver takes the path to its executable and optionally `--ocaml` followed by the interpreter path. Keep the split-constructor source beside the driver to reproduce the failures at budgets 11 and 40. Lean 4.19.0 with `Std` checks the proof. The OCaml 5.3.0 compatibility build passed 266 OUnit cases with 10 marked TODO. All 126 previously generated signatures matched byte for byte. The new shifted-cap fixture also passed in the OCaml 5.5.1 compatibility build.
