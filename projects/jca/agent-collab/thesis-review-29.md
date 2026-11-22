---
title: "Choosing a recursive interval from the input state"
date: 2026-11-22
---

Table 4.4 leaves choices to the widening and abduction routines. With the original common-atom jump, the suppliers can imply an upper bound that widening discards and the caller restores on every pass. The stopping test requires an empty caller demand, so this recurrence persists even when the stored two inequalities already solve the clauses. On the capped-climb example at revision `3eb191e`, the caller restores the bound on pass 8. The jump retains it on pass 9 and the solver returns with an empty demand. A second failure occurs earlier. An update can finish and then fail a guard check because the recursive call chose the wrong existential parameter. The two-state and three-state programs below distinguish these failures. [Original recurrence](thesis-review-3.html#update) · [Two-state trace before the repair](thesis-review-28.html#policy)

## A call can choose its own interval {#recovery}

The recursive function returns an integer in $[k,k+2]$. The caller may choose any $k$ whose interval contains the supplier value $4i+1$ at input state $i$. Inside the recursive branch, the child call needs its own interval. Every value in that interval must miss the guard $[2,4]$. With states 0 and 1 the only possible child keys are $-1$ and 5, respectively. InvarGenT now infers the single equation $k_{\rm child}=6i-1$ and checks the program at an outer iteration budget of 2. [Program](state_dependent_interval.gadt) · [Uniqueness proof](thesis-review-28.lean)

After the ordinary guard checks fail, the compiler takes literal forbidden bands from the unresolved arms. It reads sample indices from constructors of the argument type and drops those incompatible with the written precondition. Suppose the package bounds its result between $k+a$ and $k+b$. Avoiding a band $[l,u]$ requires $k\le l-b-1$ or $k\ge u-a+1$. The compiler intersects those choices with the input bounds. When each sample leaves one finite interval of keys, it fits an integer slope and intercept using the pair inequalities below. It adds the proposed equation to the fresh instance at each recursive use. All original branches, calls and negative guards go through the checker again. The samples guide inference even when the datatype also has a constructor whose index varies. [Executable checks](thesis-review-29.py)

One client requires the result at state 0 to be at least 1. This forces its *parent* key to be 1, although its child must choose $-1$. The client at state 1 requires a result at most 5 and forces parent key 3, although its child must choose 5. Both clients check and execute together. The emitted OCaml still calls `run s d`. Reversing the sign of the slope, exchanging the two guard comparisons, and using constructor indices $-2$ and 1 also pass. A constructor carrying an arbitrary index can supply the reachable value 3 in a negative control. The compiler rejects that program. [Clients and controls](thesis-review-29.py)

## A third state needs a different witness {#three}

Add a constructor with index 2. The supplier values now give the following choices after removing the forbidden band.

| Input state $i$ | Supplier $4i+1$ | Legal child keys |
|---:|---:|---:|
| 0 | 1 | $\{-1\}$ |
| 1 | 5 | $\{5\}$ |
| 2 | 9 | $[7,9]$ |

The first two rows force slope 6 and intercept $-1$. At the third input that line gives 11. Every pair of rows admits an integer line, for example $4i-1$ on states 0 and 2 and $2i+3$ on states 1 and 2. One minimum of two lines serves all three states,

$$ k_{\rm child}=\min(6i-1,4i+1). $$

At each state this interval contains the supplier and excludes the guard for every opening. Both the base branch and the surviving recursive branch return $4i+1$, which lies in every permitted parent interval. This proves the same local obligation at every recursive depth. The clients can choose the interval ending at $4i+1$. Supplying the minimum explicitly or splitting on the three constructors before the call both verify and execute at budget 2. [Three-state source](three_state_interval.gadt) · [Lean proof](thesis-review-29.lean) · [Both controls](thesis-review-29.py)

With the key implicit, the final guards fail at revision `3eb191e`. The later piecewise fitter checks this program at budget 2. [Three-state repair](thesis-review-30.html#scalar)

At the earlier revision, Z3 projects each failing guard exactly onto the input $i$, parent key $k$, child key $j$, and opened result $r$.

$$
i\in\{0,1,2\},\quad k\le4i+1\le k+2,\quad j=k,\quad
j\le r\le j+2,\quad 2\le r\le4.
$$

On this path state 0 admits $k=j=1$ and $r=2$. State 1 admits $k=j=3$ and $r=4$. State 2 cannot enter the bad guard. Budgets 0 and 1 stop in the definition of the supplier. For any budget of at least 2, the supplier finishes on pass 2, and two searches of the recursive definition finish their predicate updates on pass 2. Their final guards fail. The other searches encounter the Boolean branch where a numeric result is required, and the affine retry has no witness on the three rows. None of these outcomes depends on an additional pass or reaches the induction jump. Traces at budgets 2, 3, 40 and 10,000 agree byte for byte in each annotation mode. The projection holds over integers and over rationals for the index domain written in the source. [Pass and projection checks](thesis-review-29.py)

## Four observations characterize failure of an affine witness {#four}

Let each history $h$ have an integer observation $x_h$ and a closed range of keys $[L_h,U_h]$ with finite integer endpoints. **One integer-affine policy works on every history if and only if one works on every subset of at most four histories.** This also holds for infinitely many histories. For finite families the upper bound is an instance of the lattice Helly theorem in the two integer coordinates $(m,c)$. The interval structure gives a direct proof, a way to compute the policy, and a sharp example using actual package constraints. [Doignon](https://link.springer.com/article/10.1007/BF01949705) · [Lattice bound](https://arxiv.org/abs/1405.2480) · [Formal proof](thesis-review-29.lean)

For $x_h<x_j$, set $d=x_j-x_h$. The two rows admit a common intercept at an integer slope $m$ precisely when both rows are nonempty and
$$
\left\lceil\frac{L_j-U_h}{d}\right\rceil \le m \le
\left\lfloor\frac{U_j-L_h}{d}\right\rfloor .
$$
If every four histories fit, any two of these closed slope intervals meet. Even in an infinite family, the integer intervals have a common point. Indeed, any one upper endpoint bounds all their lower endpoints, which therefore attain a maximum. Histories with the same observation impose the slope-independent checks $L_h\le U_j$. For a slope satisfying all pairs, the intervals $[L_h-mx_h,U_h-mx_h]$ have a common integer intercept by the same argument. If all observations coincide, take slope zero. For $n$ explicit rows the compiler intersects $n^2$ slope inequalities and then takes the largest adjusted lower endpoint as the intercept. This step finds a policy whenever the rows admit one and its coefficients fit the term representation. Inferring the rows and checking the rest of the program are separate obligations. [Shared-intercept criterion](thesis-review-28.html#uniform)

Four histories can be necessary.

| Observation $x$ | Legal key interval |
|---:|---:|
| $-2$ | $[-5,0]$ |
| $-1$ | $[0,5]$ |
| $1$ | $[1,5]$ |
| $2$ | $[-5,2]$ |

The rows at $-2$ and 1 force $3m\ge1$. The rows at $-1$ and 2 force $3m\le2$. No integer slope meets both. Omitting the rows in table order gives the respective witnesses $1$, $x$, $0$, and $x+1$. Each row is realizable with the same package width 7, supplier $U_h$, and a single forbidden value $L_h-1$. Thus checking every triple can miss a genuine incompatibility between recursive interval requirements. [Sharpness and package realization](thesis-review-29.lean)

To reproduce the checks, compile reviews 27 and 28 into a temporary Lean search path and run Lean 4.19 on `thesis-review-29.lean`. Run `python3 thesis-review-29.py /path/to/InvarGenT.native` with OCaml available and revision `3eb191e` as the first executable. The optional `--original` runs the capped climb at revision `772b9b4`. The optional `--before` takes revision `311a5e4`. The optional `--trace` uses Python's `z3-solver` and revision `3eb191e` built with the existing diagnostics for passes, interfaces, jumps, and guards. The OCaml 5.3 compatibility build passed 335 active tests with 10 existing TODOs. All 170 previous example signatures matched byte for byte. The source executions and traces used the OCaml 5.5 compatibility build. [Build diagnostics](thesis-review-28.html#policy)
