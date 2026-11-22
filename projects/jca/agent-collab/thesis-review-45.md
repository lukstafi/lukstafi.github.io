---
title: "Which changes of admission must an induction jump survive?"
date: 2026-11-22
---

To certify a recursive package while its input predicate changes, suppose we know two bounds. Every future menu at input $x$ contains $L_x$ and lies inside $U_x$. A supplier might fail its check at some intermediate menu even if it passes at both bounds. For the all-keys producer clauses, testing the lower menus with **one additional key at one input** suffices. This holds for arbitrary package relations and for suppliers that open several recursive calls. It gives a bound of $\omega$ on the exact producer iteration when the lower menus are finite, even if every upper menu is infinite. Reversing the calculation can take longer. With the package held fixed, exact recomputation of admission can take $\omega+1$ steps to find a singleton domain. [Earlier certificate for convex sections](thesis-review-44.html#changing) · [Formal proofs](thesis-review-45.lean)

## A key used for storage is also available for opening {#one}

Write $P(k,r)$ when the package at key $k$ contains result $r$. A recursive result $s$ opens at $y$ if $P(j,s)$ holds for every $j\in A_y$. Fix a supplier clause and values for its local variables. Its static premises determine which instances are legal. An instance opens a finite list of calls $(y_i,s_i)$ and introduces result $t$ at input $x$. A base clause has an empty list. The step must store $t$ at every key $k\in A_x$. One can tag the input and key spaces with the recursive function name for a mutually recursive group. Private package witnesses are already existentially quantified inside $P$. [Semantic producer step](thesis-review-43.html#operator) · [Witness scope at recursive openings](thesis-review-39.html#all)

**One-key criterion.** Fix $k\in U_x$. The clause can introduce $t$ at $k$ under some intermediate policy exactly when the following requirements hold for every recursive call in the instance.

1. $P(j,s_i)$ holds for every $j\in L_{y_i}$.
2. Whenever $y_i=x$, also $P(k,s_i)$ holds.

To prove necessity, take a policy witnessing the introduction. It contains the lower menus everywhere and contains $k$ at $x$. Each opening satisfies both requirements. Conversely, take the lower policy and add $k$ just at $x$. The two requirements list *all* the keys needed by each opening under this policy. The supplier can now store $t$ at $k$. Consequently a violation under any policy has a witness at this one-key change. A caller clause with a fixed forbidden conclusion requires only the lower policy, since shrinking menus preserves its open premises. Nonempty lower menus ensure every legal input still admits a typing. [Lean theorems `body_pin` and `one_key_step`](thesis-review-45.lean)

The same argument covers extra explicit positive admission tests. Collect the finitely many pairs required by a violating instance in $E$, including the destination pair if it has one. Suppose the remaining condition $D(A)$ is preserved by shrinking $A$. There exists a policy between $L$ and $U$ containing $E$ and satisfying $D$ iff $E\subseteq U$ and $D(L\cup E)$. This removes the quantifier over policies. In rational linear arithmetic, the test for an opened call becomes an ordinary first-order formula using equality of input tuples. If the solver requires additional correlations between optional keys, testing the entire interval gives a sufficient certificate for that smaller family. An exact test for correlated policies can use their least legal extension of $L\cup E$ when it exists. [Lean theorem `least_completion`](thesis-review-45.lean)

## What if only the existence of a key is guaranteed? {#coverage}

A caller can require *some* key in a set without fixing a representative. Replacing such a requirement by the intersection of all legal menus can lose every useful key. There is a dual way to eliminate the policy quantifier. For one concrete list of openings, take the **largest compatible menus**
$$
 M_y=\{j\in U_y:\ \forall i,\ y_i=y\implies P(j,s_i)\}.
$$
A policy below $U$ permits all the openings exactly when it is contained in $M$. Let $N(A)$ be any admission demand preserved by adding keys. A witnessing policy exists iff $N(M)$ holds. Necessity follows from containment and upward preservation. For sufficiency take $A=M$. Include the destination test $k\in A_x$ in $N$ if the violation concerns a supplier. The requirements can couple different calls or inputs. For a demand to hit a given set, one tests whether $M$ intersects it. Calls at the same input must use the same $M_y$, even when they open different results. [Lean theorem `greatest_completion`](thesis-review-45.lean)

For example, allow key zero and require at least one positive key from $[0,1]$. Store the package $0\le r\le1-k$. Every permissible menu opens only zero for an integer result. Their intersection can consist of key zero alone, where one also opens. The largest compatible menu for the hypothetical one contains only zero, so it fails the positive-key demand. This gives an exact certificate without choosing a mandatory positive representative. The moving program below realizes the same demand.

## Why checking the endpoints misses a supplier {#endpoints}

Use one input, base zero, and a guarded successor that returns two when it opens one. Let $L=\{a\}$ and $U=\{a,b,c\}$. The key sections of the proposed package are $P_a=[0,2]$, $P_b=[0,1]$ and $P_c=\{0\}$.

| Admitted keys | Does one open? | Supplier check |
|---|---|---|
| $\{a\}$ | Yes | $a$ stores two. |
| $\{a,b,c\}$ | No | $c$ excludes one. |
| $\{a,b\}$ | Yes | $b$ fails to store two. |

There is also a false alarm if one opens at $L$ and unconditionally writes at every key of $U$. Remove $b$ from the example. Every remaining policy works. Storing two at $c$ would require admitting $c$, and that same admission prevents the supplier from opening one. This dependence accounts for the second requirement in the criterion. When the recursive call is at a *different* input, adding $k$ at the destination places no constraint on that call. The [finite replay](thesis-review-45.py) compares the criterion with explicit policy enumeration on 12,960 cases, including repeated calls to the same input.

## A finite lower menu bounds the common producer by one limit {#omega}

Define $T(P)$ to be the union of the exact producer steps over all intermediate policies. A package satisfies the producers throughout the interval iff $T(P)\subseteq P$. The operation $T$ is monotone in $P$. For an increasing sequence $P_n$, any result introduced from $\bigcup_n P_n$ has a witnessing clause instance, destination key and list of calls. By the criterion, that instance tests only the mandatory keys of those calls and, at calls to the destination, one extra key. If each mandatory menu is finite, all those tests already pass at one finite stage. Take the maximum of the stages at which the required entries appear. It follows that
$$
 T\left(\bigcup_n P_n\right)=\bigcup_n T(P_n).
$$

Starting at the empty package, the union of the finite iterates is therefore fixed and is contained in every common producer invariant. The argument also extends to independently chosen menus with finitely many mandatory keys and finitely many requirements per input to hit specified sets. In a policy witnessing an introduction at the limit, retain the mandatory keys and one witness for each requirement at each called input. Keep the destination key if it is present at one of those inputs. Leave the policy alone elsewhere. The revised policy still meets the demands, and the instance now tests finitely many package entries. This finite selection uses no bound on the sizes of the prescribed sets. The bound is sharp. With one input, one mandatory key, base zero and successor $r\mapsto r+1$, the producer introduces every natural number and adds a new one at every finite round. With an infinite mandatory menu the earlier $\omega+\omega$ example applies by taking $L=U$. These bounds concern the least relation closed under the specified clauses. A fixed caller with positive opening premises can be checked at the least relation. Whether that relation has a formula in the answer language is a separate question. [Lean theorem `least_at_omega`](thesis-review-45.lean) · [Two-limit producer](thesis-review-43.html#limits)

## Recomputing admission can take one more step after the limit {#recheck}

Now freeze the package $P$ and recompute the admission predicate itself. Given a domain $A$ for recursive calls, let $G(A)_x$ contain each $k\in U_x$ at which every supplier checks. For a clause instance whose prospective result $t$ fails $P(k,t)$, keeping $(x,k)$ requires at least one of its calls $(y_i,s_i)$ to have an admitted key $j$ with $\neg P(j,s_i)$. An instance with no calls has no such defence. This translates a fixed postcondition into explicit demands on the unary predicate. The domain is sound exactly when $A\subseteq G(A)$. Enlarging $A$ can only add defences, so $G$ is monotone. Iterating down from $U$, taking intersections at limits, computes the greatest sound domain. Upward-preserved caller demands can then be tested on that domain. [General greatest-domain theorem](thesis-review-26.html#calls) · [Fixed-package clause equivalence](thesis-review-45.lean)

If each offending instance has only finitely many possible blocking pairs $(y_i,j)$ in $U$, descending rechecks reach their greatest fixed point by $\omega$. If a destination key survives every recheck, each offending instance has a blocker at every stage. Among finitely many possible blockers, one must remain throughout the decreasing domains. Thus the destination key survives the recheck of their intersection. This condition counts the keys that can *refute* an observation. The finite-core producer theorem counted the keys needed to *permit* one. [Lean theorem `recheck_limit`](thesis-review-45.lean)

**With a constant-size fixed package and a singleton admission solution, the exact recheck can take $\omega+1$ steps.** Use one input, two isolated keys $a,b$ and all ordinary rational keys $k\ge0$. Numeric results are tagged separately from two marker results $p,q$. The package at $a$ accepts everything. The package at $b$ accepts everything except $q$. The ordinary key $k$ accepts $q$, rejects $p$, and accepts a numeric $r$ exactly when $r+1\le k$ or $k+1\le r$. All numeric constraints are weak affine inequalities with a finite disjunction. The base supplies zero. One rule takes a nonnegative open number $r$ to $r+1$. Another takes an open $p$ to $q$.

Start with all keys available. After $n$ rechecks the domain consists of $a,b$ and the ordinary tail $[n,\infty)$. Indeed a nonnegative numeric result opens against that tail exactly when $r+1\le n$. If $r\ge n$, key $r$ blocks it. If $r<n$, key $n$ gives the required inequality. The base removes $[0,1)$ on the first pass. For $n\ge1$ the successor then supplies all numbers in $[1,n]$, which together with the base exclude exactly the ordinary keys below $n+1$. A remaining ordinary key always blocks $p$, protecting $b$.

At $\omega$ the ordinary tail is empty. The two isolated keys both permit $p$. The next recheck supplies $q$ and removes $b$. Every numeric result also opens, so the base and successors still exclude every ordinary key. The domain $\{a\}$ is fixed and is greatest by monotonicity. Every finite stage still admits the client requiring $b$, although no sound domain admits it. The surviving scheme for a client requiring $a$ has constant size. This is the exact unary subproblem with a fixed package. Table 4.4 can also change the package and generalize an approximation. [Strict stages, fixedness and greatestness in Lean](thesis-review-45-admission.lean) · [Symbolic recheck](thesis-review-45.py)

There is a short induction jump for this particular recheck. In *any* sound policy, zero opens by the base. If the natural number $n$ opens, the numeric successor makes $n+1$ open. Thus every admitted key must store every natural number. An ordinary key $k$ fails on $\lfloor k\rfloor$, whose distance from it is less than one. Drop the whole ordinary half-line at once. The marker rule then drops $b$. This proof constructs the singleton domain directly from the supplier clauses. [Orbit certificate in Lean](thesis-review-45-admission.lean)

## A sequence of individually valid schemes can lose its proof {#limit}

A different question arises if we check only the menu actually chosen on each pass. Let $A_n$ decrease and $P_n$ increase. For a fixed input $x$ and result $r$, the keys that block the opening form the decreasing sets
$$
 D_n(x,r)=\{k\in A_{n,x}:\neg P_n(k,r)\}.
$$
At the limiting menu and package the blocking set is exactly $\bigcap_n D_n(x,r)$. If $D_0$ is compact and each $D_n$ is closed in the key space, nonempty blockers at every finite stage have a common point. A result opening at the limit must then have opened at some finite stage. Conversely, once it opens it stays open. For a finite list of calls we can synchronize those stages. Every destination key still admitted at the limit was admitted on the synchronized pass. If that pass validated its suppliers, their output belongs to the limiting package. A fixed caller inherits validity by the same argument. A nonempty common lower menu also preserves the existence of a typing at each legal input. The compactness hypothesis concerns the **blocking keys for each observation**. [Lean theorems `diagonal_open` and `diagonal_inductive`](thesis-review-45.lean)

A positive margin can supply the compactness argument even with weak package inequalities. Suppose the menus are closed in a compact metric key space. For this fixed observation, suppose every pass has an admitted blocking key whose entire open ball of radius $\varepsilon>0$ also blocks the observation. The same radius must work on every pass. These centres form closed sets inside the menus. Indeed, all keys within distance strictly less than $\varepsilon$ of any permitted key form an open set. Since the menus shrink and the permitted keys grow, the closed sets of centres decrease. Their common point blocks the observation at the limit.

Consider one input with $A_n=[0,1/(n+1)]$, base zero and successor $r\mapsto2r$. Keep the same package throughout:
$$
 P(k,r)\iff r=0\ \lor\ (k=0\land 0\le r\le1).
$$
At each finite pass a positive admitted key restricts the opening to zero. Every pass validates the successor and the caller $r\le0$. The limit menu is $\{0\}$, where one now opens. The caller fails, and its double, two, fails the supplier check. For observation one the blocking keys are $(0,1/(n+1)]$ and disappear at the limit. The example works over the rationals and over the reals. Over the reals every menu is a compact interval and the package graph is closed. This shows why compactness of the menus alone cannot justify a limit jump when the evidence excluding a result moves on each pass. [Exact finite and limiting openings in Lean](thesis-review-45.lean)

## A moving menu in InvarGenT {#compiler}

The [recursive program](moving_native_menu.gadt) takes a native numeric argument $i$ between zero and two. Its written and exported admissions both give
$$
 0\le k\le1,\qquad k\le |2i-3|.
$$
At key $k$ the result satisfies $0\le r$ and $r+k\le1$. The base opens a seed package. The seed permits a positive number only at $i=3/2$. The recursive branch treats $r\ge1$ as impossible and otherwise doubles $r$. For a rational input of $3/2$ the sole admitted key is zero and the package permits one. At every native integer input the whole unit interval of keys is admitted, so the recursive opening is zero and doubling preserves it.

For this native caller, any one positive mandatory key suffices. The integer result is at most $1-k<1$. If a possible menu contains only zero, it permits one. Thus the concrete lower bound $L_i=\{1/2\}$ and upper bound $U_i=[0,1]$ certify the displayed package for every intermediate menu at native inputs. The implementation checks the domain actually exported by inference. A proposed lower bound for future passes would still have to be established for those passes. [Symbolic projection, exported scheme and scaled-key control](thesis-review-45.py)

Revision `f872939` rejected the Boolean guarded arm even at outer budget four. Revision `c74beee` accepts the complete scheme at budget two and both example calls return zero. A diagnostic records passes zero, one and two in the accepted all-keys trial. It records no call to numeric widening, even when its configured threshold is lowered from eight to one. A scaled version admits $0\le2k\le1$ and uses $r+2k\le1$ in the package. There every positive refuting key is fractional, and the guard is still proved. This repair acts when the candidate recursive typings are checked against the inferred and written domains. The proof of convergence for the common producer above applies to a separate, exact update. [Quantified guard checker](thesis-review-39.html#all) · [Whole-program replay](thesis-review-45.py) · [Pass and proposal diagnostic](thesis-review-45-trace.patch)

## Which coordinates are native? {#native}

At a fully applied recursive call, a direct `Num` argument and a `Num` component of an actual tuple each have an integral value on the OCaml integer target. Its numeric index can be a whole affine expression. If the argument is `Num (2i)`, the runtime value three realizes $i=3/2$. The corresponding source control reaches the guard with result one. An abstract type carrying index $i$ can have a perfectly good value at $i=3/2$. Private package witnesses and fresh key choices remain rational.

The [second program](joint_native_guard.gadt) makes the correlation visible. Its seed permits a positive result only when $2r+2i=5$. The function takes a pair of native arguments $(i,h)$ and tests $1\le r\le h$. At $h=2$ the guard requires genuinely joint information. Checking only an integer result permits $(i,r)=(3/2,1)$. Checking only an integer input permits $(1,3/2)$. Both satisfy the guard at that same upper bound. Joint integrality rules out the equation itself. Replacing the input by a constructor at phantom index $3/2$ lets a native result of one enter the guard. Changing the right-hand side to four also makes the arm reachable, and a float-target call reaches it at native floating-point argument $1.5$. A further control takes $(i,h)=(0,2)$ and returns two in the base case. The test reaches the guard through the second component. The compiler now tracks the numeric operand through the tuple pattern and its local aliases. The replay checks the rejected Boolean body and the observed numeric result in all five reachable controls.

InvarGenT first eliminates the rational keys and private witnesses as in the earlier guard test. In a remaining region it names the observed native expressions, projects away other rational coordinates, and keeps the positive slack used for strict inequalities. A projected side has the form $u+c+bd\le0$ at $d=0^+$. Clear denominators and divide the variable coefficients of the slack-free side by their positive gcd, rescaling the constant as well. The resulting $u$ is an integer linear form on the joint native tuple. For $b\le0$ the constraint becomes $u+\lceil c\rceil\le0$. For $b>0$ it becomes $u+\lfloor c\rfloor+1\le0$. The checker applies this to both sides of equations and to the alternatives of min/max constraints. If every remaining rounded cell is inconsistent, the guard is unreachable. [Scalar slack calculation](thesis-review-41.html#native) · [Rounding and difference bounds in Lean](thesis-review-45.lean)

This test is exact on unions of cells whose rounded inequalities are integer difference bounds. A rational solution of $z_i-z_j\le b$ with integral $b$ still satisfies the inequality after flooring every coordinate. Unary bounds use zero as the other coordinate. General integer feasibility can require more work. For example, $1\le5(i+r)\le9$ and $-4\le5(i-r)\le4$ round to $i+r=1$ and $i-r=0$. The rational point $(1/2,1/2)$ survives the relaxed joint check at revision `c74beee`. A later compiler repair rules it out by solving the rounded equations together. [Integer compatibility and a remaining inequality gap](thesis-review-47.html#compiler) · [Arithmetic replay](thesis-review-45.py) · [Omega Project on eliminating integer variables](https://www.cs.umd.edu/projects/omega/paragraphstar3_2_0_0_2.html)

The next review lets both predicates vary and asks when they can express a particular relation between inputs and opened results. [Choosing admission and package witnesses together](thesis-review-46.html#fit)

## Reproducing the checks {#checks}

The OCaml 5.3 compatibility build of InvarGenT revision `c74beee` passed all 378 active tests, with ten marked TODO. All 193 previously generated example signatures were byte-identical to those at `f872939`. The whole-program replay and arithmetic driver ran on the OCaml 5.5 compatibility build.

Use Lean 4.19 with mathlib v4.19.0 for the [policy and convergence proofs](thesis-review-45.lean) and the [exact descending iteration](thesis-review-45-admission.lean). Run `python3 thesis-review-45.py` with `z3-solver` for the policy comparison and symbolic moving menu. Add `--compiler` with the patched InvarGenT binary and optionally `--before` with revision `f872939` for the source comparisons. Copy the [arithmetic driver](thesis-review-45-numeric.ml) to `src/Native45.ml` in the patched source tree. Build `src/Native45.native` with the same ocamlbuild options as InvarGenT and pass the executable as `--driver`. It tests 205 cases with exact expected answers and another 161 with general affine constraints against Z3. The displayed parallelogram is the single conservative answer in that run. Apply the pass diagnostic to a separate compiler build and pass it as `--trace` to check the winning trial under both widening thresholds.
