---
title: "When the induction jump drops an inductive postcondition"
date: 2026-11-21
---

InvarGenT at revision `772b9b4` can infer a valid binary postcondition on pass 8 and report “Answers do not converge” on pass 11. The example has one recursive function, a fixed type shape, and a postcondition of two linear inequalities. The result of pass 8 is already inductive. What keeps the iteration going is a caller obligation that the induction jump recreates on every pass. [Runnable InvarGenT program](capped_climb.gadt) · [Lean proof](thesis-review-3.lean)

## A recursive call with one unit of slack {#program}

Let `climb m t` start at the integer $m$ and take one step for each successor in the unindexed natural number $t$. Each step adds one until the result reaches $m+19$. Its declared input range allows one extra unit, up to $m+20$.

```ocaml
let rec climb m = efunction
  | Z -> m
  | S t -> let r = climb m t in
           let B u = step m r in u
```

The declaration of `step` requires $m\le r\le m+20$. The constructor `B` gives its payload $u$ the guarantees $m\le u$, $u\le r+1$ and $u\le m+19$. The supplied OCaml body computes $\min(r+1,m+19)$. Inference uses the declaration. The captured index $m$ survives in the existential package. Write $R(m,r)$ for the numeric part of $\chi_K(\delta,\delta')$ when the carried type is $\mathrm{Num}(r)$ and its parameter tuple contains $m$. [Complete declarations and body](capped_climb.gadt)

Write $B_t(m,r)$ for $m\le r\le m+t$, and $E(m,r,u)$ for the three guarantees of the constructor. With the type shapes fixed, the original recursive obligations are

$$
\begin{aligned}
  &R(m,m),\\
  &R(m,r)\Rightarrow B_{20}(m,r),\\
  &R(m,r)\land B_{20}(m,r)\land E(m,r,u)\Rightarrow R(m,u).
\end{aligned}
$$

**Both $B_{19}$ and $B_{20}$ are solutions.** The base result belongs to both bands. Each band licenses the call to `step`. Every payload returned by that call belongs to $B_{19}$, which is contained in $B_{20}$. No numeric precondition on $m$ is necessary. The two complete type schemes differ only in the upper bound on the existential result.

## One pass of Table 4.4 {#update}

Suppose the stored postcondition is $B_t$, with $0\le t\le20$. The exact generalization of the defining branches in (4.1–4.2), before the jump, is

$$
  F(B_t)=B_{\min(t+1,19)}.
$$

The upper bounds follow by substitution into the constructor guarantees. For the reverse inclusion, take the recursive result $r=m+t$. Its abstract contract permits every output $u$ in the displayed band. The base branch contributes $m$, which also lies there. Thus the formulas used below capture the full projection of the suppliers. [Formal projection lemma](thesis-review-3.lean)

Starting at the configured jump pass, $H$ aligns the variables, solves the numeric systems, expands equations into inequalities, and takes common atoms of the two presentations before pruning. On these bands, it keeps the lower bound $m\le u$ and keeps an upper bound exactly when the two offsets match. The consumer then sees this widened postcondition in (4.3). If it sees only the lower bound, (4.4–4.5) assigns the missing $u\le m+20$ to the postcondition. Equation (4.6) stores it. Both supplier branches already prove that inequality, so (4.7) returns an empty additional precondition and (4.8) leaves the inputs unrestricted. [Table 4.4](../lukstafi-phd-thesis.pdf#page=71) · [Appendix B.3.2](../lukstafi-phd-thesis.pdf#page=125) · [Numeric widening implementation](https://github.com/lukstafi/invargent/blob/772b9b45b31ac11ef2a0d8e88b391db21d55eaa5/src/NumS.ml#L3998-L4037)

In the trace below, offsets are relative to $m$. An entry $[0,20]$ means $m\le r\le m+20$.

| Pass (from zero) | Stored on entry | Suppliers before $H$ | After $H$ | Caller asks for | Stored on exit |
|---|---|---|---|---|---|
| 7 | $[0,5]$ | $[0,6]$ | $[0,6]$ | nothing | $[0,6]$ |
| 8 | $[0,6]$ | $[0,7]$ | $[0,\infty)$ | $r\le m+20$ | $[0,20]$ |
| 9 | $[0,20]$ | $[0,19]$ | $[0,\infty)$ | $r\le m+20$ | $[0,20]$ |
| Every further pass with the same rules | $[0,20]$ | $[0,19]$ | $[0,\infty)$ | $r\le m+20$ | $[0,20]$ |

**Counterexample.** The last row reproduces its own input, including the fixed parameter interface. It also produces a nonempty $A_{\beta_{\chi_K}}$ on every pass. Table 4.4 requires that contribution to be empty before returning a solution. The implementation records it in `unfinished_postcond_flag`. Induction on the number of subsequent passes gives perpetual failure of the stopping test if the timeout is removed. The implementation with its finite timeout returns an error. A size bound covering the two-inequality solution, or even all stored predicates in this run, cannot force successful convergence. This refutes a guarantee for every run with the specified common-atom jump. The table allows choices of component routines, and other runs can succeed on this very input. [Stopping condition and rationale](../lukstafi-phd-thesis.pdf#page=137) · [Recording the demand](https://github.com/lukstafi/invargent/blob/772b9b45b31ac11ef2a0d8e88b391db21d55eaa5/src/Invariants.ml#L1694-L1732) · [Stopping test](https://github.com/lukstafi/invargent/blob/772b9b45b31ac11ef2a0d8e88b391db21d55eaa5/src/Invariants.ml#L1803-L1849)

The argument works for any nonnegative supplier cap $c$ and consumer limit $L$ with $c<L$. If the first jump compares $B_t$ and $B_{t+1}$ for $t<c$, it drops the changing upper bound and the caller restores $B_L$. Every later supplier yields $B_c$. The offsets $c$ and $L$ never match, although $B_c$ entails $B_L$. This gives a counterexample for any fixed finite delay that starts widening while the bounds are growing. The Lean file proves the exact projection, the two solution checks, and the recurrence for arbitrarily many passes on this numeric specialization. [Machine-checked argument](thesis-review-3.lean)

## What the solver does {#runs}

I ran InvarGenT 1.2 at commit `772b9b4` with OCaml 5.5.1 using the standard-library and reserved-name compatibility edits described in the first review. The uninstrumented binary gave the outcomes below. A build with diagnostic prints at the widening, caller abduction, and supplier abduction gave the intermediate rows above. The executable initializes the last pass to 11, although its command-line help says 7. [Build notes](thesis-review-1.html) · [Phase defaults](https://github.com/lukstafi/invargent/blob/772b9b45b31ac11ef2a0d8e88b391db21d55eaa5/src/Invariants.ml#L8-L18)

| Run on the supplied file | Result |
|---|---|
| Default settings | Fails on pass 11 with “Answers do not converge”. |
| `-iterations_timeout 40` | Fails on pass 40. Every pass from 9 through 40 restores the same bound. |
| `-convergence_step 24 -iterations_timeout 35` | Accepts $B_{19}$ on pass 21. The generated OCaml compiles. |
| Default settings, changing only the consumer limit from 20 to 19 | Accepts $B_{19}$ on pass 9. The supplier and consumer now write the same upper atom. |

To reproduce the first three outcomes with a solver built from `772b9b4`, run these commands in the directory containing the example.

```sh
invargent -inform -no_ml -no_sig capped_climb.gadt
invargent -inform -no_ml -no_sig -iterations_timeout 40 capped_climb.gadt
invargent -inform -convergence_step 24 -iterations_timeout 35 capped_climb.gadt
```

## Keeping old inequalities the suppliers imply {#repair}

For old linear inequalities $O$ and a new supplier summary $G$ on aligned variables, retain each $a\in O$ for which $G\models a$. Each retained inequality holds for the new suppliers. An expanding bound such as $r\le m+6$ still disappears when the new upper offset is 7. Once the caller has restored $r\le m+20$, the supplier bound $r\le m+19$ suffices to keep it.

This gives a local recognition property. Suppose all other components and the parameter interface are stable, the stored $O$ satisfies every use, and the computed $G$ entails every atom of $O$. In the linear-inequality fragment an exact entailment test retains all of $O$. The uses then require no strengthening, so this component passes both the equality and empty-demand tests. For the example, pass 8 still discovers $B_{20}$ and pass 9 accepts it. A general convergence theorem would also have to control changes to the interface, other predicates, and demands introduced before such an inductive candidate is found.

InvarGenT commit `3804807` implements this rule in `NumS.converge`. It checks each unmatched old `Leq` against the solved new state in the same variable order. The program is now an end-to-end regression in the solver repository. With default phases, the build returned $\forall m.\,\mathrm{Num}(m)\to\mathrm{Nat}\to\exists r\,[m\le r\le m+20].\,\mathrm{Num}(r)$ on pass 9. Raising the supplier cap to 21 while leaving the consumer limit at 20 still produced an error. In that variant the permitted sequence $m,m+1,\ldots,m+21$ reaches an illegal argument for the next recursive step. The Lean proof checks the inconsistency for every $c>L$. [Numeric implication checker](https://github.com/lukstafi/invargent/blob/772b9b45b31ac11ef2a0d8e88b391db21d55eaa5/src/NumS.ml#L1354-L1373) · [Proof of the repaired step and the unsafe control](thesis-review-3.lean)


### A finite bound when the caller contract is itself inductive {#fixed-demands}

Let $D$ be a fixed finite set of caller inequalities. Identify each set of atoms with its conjunction. Suppose the captured parameters, type shape and other predicates have stabilized. At the start of widening, let the stored set $O_0$ entail $D$. Assume the supplier summary computed from **every** subsequent $O$ entailing $D$ also entails $D$. For example, this holds for an exact monotone supplier operator $F$ if $F(D)\models D$. The capped program satisfies this condition since every successor lies in $B_{19}$.

Suppose a pass keeps exactly the old atoms entailed by its supplier summary. The caller may restore missing atoms of $D$ until its contract holds. Assume it requests an atom only when the current widened formula fails to entail it. Store the union on a fixed vocabulary without rewriting it into fresh atoms, and assume the auxiliary supplier abduction needs no additional preconditions.

**Bound.** There are at most $|O_0\setminus D|+|D\setminus O_0|$ passes that change the stored set, followed by at most one verification pass.

Every stored caller atom survives widening because the supplier entails $D$. Each caller atom added for the first time therefore stays. Each atom outside $D$ comes from $O_0$ and disappears at most once. Formally the number of atoms in the symmetric difference of $O$ and $D$ decreases at every change. If the stored set stays fixed, a caller request would have introduced a previously absent atom, so the demand must be empty. This also establishes the often troublesome third part of the stopping condition. [Lean proof of the decreasing rank and pass bound](thesis-review-3.lean)

This bound counts the atoms in the initial candidate and the caller contract. It applies when widening and abduction have the stated behavior on that vocabulary. In the full solver, solving and pruning can change the presentation, and a caller can require an auxiliary inductive strengthening. Numerical implication itself also needs to respect the meaning of min and max. [Extrema in the numeric checker](thesis-review-4.html) A follow-up run isolates the role of the interface itself. Changing the base from a captured parameter to zero makes the capture necessary but easy for the generalizer to miss. [The missing parameter and a finite-vocabulary theorem](thesis-review-5.html)
