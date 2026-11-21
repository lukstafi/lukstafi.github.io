---
title: "The parameter an induction jump has to remember"
date: 2026-11-22
---

Start at zero. Take one numeric step for each successor of an unindexed natural number. The function closes over an integer $m$. Its first step can return $1$ when $m=0$. When $m=-21$, every result must equal $0$. InvarGenT sees both cases, but its supplier summary forgets $m$. The caller puts $m$ back in an inequality on every pass. The tuple of captured parameters stays empty. [Runnable program](zero_capped_climb.gadt) · [Lean proofs](thesis-review-5.lean)

## A two-atom solution that requires one captured parameter {#capture}

Write $r$ for the recursive result and $u$ for the next result. The external function requires the caller contract $D$ and its result constructor guarantees $E$.

$$
D(m,r)\equiv 0\le r\ \land\ r\le\max(m+20,0),\qquad
E(m,r,u)\equiv 0\le u\ \land\ u\le r+1\ \land\ u\le\max(m+19,0).
$$

For a function admitting every $m$, the obligations for its result predicate $R$ are

$$
R(m,0),\qquad R(m,r)\Rightarrow D(m,r),\qquad
R(m,r)\land D(m,r)\land E(m,r,u)\Rightarrow R(m,u).
$$

**Taking $R=D$ solves all three obligations.** The base satisfies both inequalities. The step case follows from $\max(m+19,0)\le\max(m+20,0)$. The resulting type is $\forall m.\,\mathrm{Num}(m)\to\mathrm{Nat}\to\exists r\,[D(m,r)].\,\mathrm{Num}(r)$.

**No relation on $r$ alone can solve them.** At $m=0$, the base puts $0$ in the relation. The step from $0$ can produce $1$, so the relation must contain $1$. At $m=-21$, the caller contract would then require $1\le 0$. This rules out every parameter-free interpretation, of any size, for the unrestricted input scheme. Capturing $m$ is sufficient. [Machine-checked necessity and sufficiency](thesis-review-5.lean)

Here “binary” refers to the two *type* arguments of the thesis predicate $\chi_K(\delta,\delta')$. The first describes the hidden payload type $\mathrm{Num}(r)$. The second describes the tuple of types or indices the package remembers from its context. Both $\delta'=()$ and $\delta'=(m)$ are legal presentations. Only the second can express this contract at independent calls. [Table 4.4 and its stopping condition](../lukstafi-phd-thesis.pdf#page=71)

## What happens at the jump {#runs}

The original linear capped-climb already refutes convergence from a bound on solution size. Under the common-atom jump, pass 8 stores the valid band $m\le r\le m+20$. On every later pass the suppliers return the stronger upper bound $r\le m+19$. The jump drops the differing upper atom and the caller restores it. Table 4.4 requires the new caller contribution to be empty. The recurrence proves that this run never passes the stopping test, even when every stored predicate fits a constant bound. The first repair kept old linear inequalities that follow from the new summary. [Proof and original solver trace](thesis-review-3.html#update)

I used two max-bound variants to separate a failure of the numeric checks from a failure of parameter capture. The first starts at $m$ and uses $m\le r$ as its lower bound. The second starts at $0$ and uses $0\le r$. They use the same upper bounds and step.

| Program and solver | Result with the default jump on pass 8 |
|---|---|
| Start at $m$, revision `8987d49` | Accepts just $m\le r$. The upper-bound obligation remains in the residual. |
| Start at $m$, revision `4560a1f` | Stores the requested max upper bound on pass 8 and accepts on pass 9. The tuple contains $m$. |
| Start at $0$, revision `4560a1f` | Restores the max upper bound on every pass from 8 to 40 with the limit set to 40. The tuple stays empty. The default run stops with an error on pass 11. |

For the last row the supplier summary on pass 9 is $0\le r$. The individual supplier branches still prove $D$. The previous tuple and the newly inferred tuple both omit $m$, so the numeric jump has no shared public slot for it. Equations (4.4–4.6) reintroduce the upper bound, while (4.7) asks for no additional precondition. The printed predicates, supplier cases and caller demand agree on passes 9 through 40 modulo whitespace. Delaying the jump to pass 24 or 80 also failed with a limit of 85. The arity proof explains why any run that keeps this empty interface must fail to find the unrestricted scheme. The finite traces by themselves do not establish a theorem about every scheduling or abduction choice.

To reproduce the last row with InvarGenT revision `4560a1f`, run

```sh
invargent -inform -no_ml -no_sig -iterations_timeout 40 zero_capped_climb.gadt
```

### Checking a caller obligation before accepting a package {#repair}

On the first variant, revision `8987d49` had correctly generated $r\le\max(m+20,0)$ as an obligation of the recursive use. Its scoped numeric checks detected restrictions on universal indices in equations and linear inequalities. A surviving min/max disjunction bypassed those checks. The split could put the obligation in a residual involving a local copy of the recursive result. The exported relation $m\le r$ then admitted the counterexample $(m,r)=(0,21)$.

There is an executable control. Raise the supplier cap from 19 to 21, leave the consumer limit at 20, and make the external body check its declared upper bound on entry. Apply `climb 0` to 22 successors. Revision `8987d49` accepted the program, and its generated OCaml compiled. The twenty-second step called the external function with $r=21$ and failed its assertion. Revision `4560a1f` reports nonconvergence on this input. The operational witness establishes the violation independently of the timeout diagnostic.

The repaired numeric checks apply the existing quantifier-order test to surviving extremum atoms after substitution. If the checked linear facts entail the atom, the requirement is discharged. Otherwise a restriction at a predicate-owned universal goes back to the splitter, and a forbidden restriction raises a quantifier violation. Parallel affine arms with a constant difference can first be reduced to the dominating arm. For example, $r\le\max(m+20,m)$ reduces to $r\le m+20$. This is a repair of scope handling for these obligations. General validity under arbitrary alternating prefixes would require a separate argument. [Earlier counterexamples for numeric implication](thesis-review-4.html)

At the jump, the solver first tests the new summary against an old numeric atom. If the summary is too weak, it can test the atom against every projected numeric supplier branch that contributed to the generalization. Replay uses variables on the aligned public interface of both predicates. It requires a supplied family of branches and retains an atom only if all feasible branches entail it. Omitting a variable from a branch leaves that variable unconstrained in its implication test. For the start-at-$m$ example the base proves the upper bound, and each recursive case proves either $r\le m+19$ or $r\le 0$. Their union proves $r\le\max(m+20,0)$ even when the computed summary has lost it. The stopping test then sees an empty caller contribution. [InvarGenT change and end-to-end fixture](https://github.com/lukstafi/invargent/commit/4560a1fa455ceecfc3155ccd557690352b0885a3)

## A convergence theorem with a fixed vocabulary {#templates}

Fix the captured interfaces and the unary preconditions. For each postcondition, supply a finite set of candidate atoms over its public arguments. Let $N$ count the atoms across all predicates, counting an atom separately at each predicate. A state $X$ selects some of these atoms, interpreted conjunctively. Assume that recursive result predicates occur positively in the suppliers, and that making result predicates stronger preserves caller safety. These hypotheses allow mutual recursion. They exclude a changing parameter interface.

Start with every candidate atom. For each pass retain $a\in X$ exactly when all its defining branches, instantiated with $X$ at recursive uses, entail $a$ at the supplied result. Include every base branch. Use the same state for all tests in a pass. Assume decidable, exact branch tests and keep atom identities fixed across passes. This is the elimination rule of Houdini applied to the binary postconditions of Table 4.4. The implemented jump rechecks existing atoms but obtains its starting formulas and interfaces from inference. [Flanagan and Leino, *Houdini, an Annotation Assistant for ESC/Java*](https://doi.org/10.1007/3-540-45251-6_29)

**Theorem.** Within $N+1$ passes, including a final verification pass, elimination finds the strongest conjunction in the pool closed under all suppliers. It satisfies every caller obligation if and only if some conjunction in the pool is closed and satisfies those obligations.

To prove it, take any closed candidate $I$. Initially $I\subseteq X$ as sets of atoms. Every recursive row admitted by $X$ is then admitted by $I$. Positivity means each supplier row obtained under $X$ is also obtained under $I$. Every atom of $I$ therefore survives the pass. Induction keeps $I\subseteq X$ throughout. Each changing pass deletes at least one atom. At stabilization every surviving atom holds on every supplier row, and all closed candidates are subsets of the surviving set. If any closed candidate makes the callers safe, the stronger surviving conjunction does too. Conversely a safe final conjunction is itself such a candidate. On a successful run the caller never needs to add an atom, since even the intermediate conjunction after each deletion still entails the successful candidate. [Lean proof of stabilization, preservation and caller safety](thesis-review-5.lean)

This gives a bounded-size corollary for conjunctive postconditions on a known interface. For a bit bound $b$, put every well-formed, predicate-tagged atom encodable in at most $b$ bits in the pool. A solution of total encoded size at most $b$ contributes all of its atoms. With the stated checks and monotonicity, the search succeeds on that promise. There are $2^{b+1}-1$ binary strings of lengths zero through $b$. The number of passes can therefore be exponential even when $b$ is polynomial in the input size. The strongest returned conjunction can exceed $b$. Deciding whether an answer itself fits $b$ uses the bounded certificate search described in the previous review. [Bounded verification](thesis-review-2.html#convergence)

The implementation still has to discover that $m$ belongs in the package. The start-at-zero program gives a test for any proposed capture rule. The rule has to identify the parameter at the definition and instantiate it with the corresponding argument at each recursive use. Carrying an incidental local variable with the same printed name would miss the distinction as soon as a recursive call changes $m$.

**Checks.** The Lean companion runs with Lean 4.19.0 and `Std`. In the OCaml 5.3.0 compatibility build, 263 OUnit cases passed and 10 remained marked TODO. All 125 signatures from the preceding run were byte-identical. The new end-to-end fixture also passed on OCaml 5.5.1. The rational numeric implication checker agreed with Z3 on the same 50,000 deterministic judgments as the previous review. Those comparisons exercise numeric implication; the whole-program runs exercise splitting, widening and parameter capture. [Numeric comparison driver](thesis-review-4.py)
