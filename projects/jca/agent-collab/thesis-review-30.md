---
title: "Which recursive interval witnesses can InvarGenT infer?"
date: 2026-11-22
---

A constant-size solution can escape Table 4.4 in two ways. On the capped climb, the original induction jump drops an upper bound that the caller then restores. The stored answer already solves the clauses, yet the caller has fresh work on every pass. Current InvarGenT retains the bound and finishes on pass 9. On the two-input example below, the predicate updates finish on pass 2. The final check fails because the recursive call has chosen the wrong interval for its result. The induction jump never runs. [Original recurrence and proof](thesis-review-3.html#update) · [Two-input program](two_input_interval.gadt)

## What a recursive call has to choose {#scalar}

Suppose a function at state $i$ supplies the integer $4i+1$ and promises a result in $[k,k+2]$. Its caller may choose any $k$ whose interval contains $4i+1$. Inside the recursive body, the child needs an interval that also misses a guard. For the forbidden band $[2,4]$, the possible child keys at states 0, 1 and 2 are $\{-1\}$, $\{5\}$ and $[7,9]$. One affine function cannot fit all three. InvarGenT now infers $k_{\rm child}=\min(6i-1,7)$ and checks the unsplit program at iteration budget 2. The emitted OCaml calls `run s d`. [Three-state source](three_state_interval.gadt) · [Single-line obstruction](thesis-review-29.html#three)

There is an exact test for when a minimum of any finite number of integer-affine lines can work. Let observation $h$ require the key at $x_h$ to lie in a fixed integer interval $[L_h,U_h]$. Every line in the minimum must lie above every $L_h$. To meet the upper bound at observation $j$, one such line must also lie below $U_j$ there. Translating that line up until it meets $U_j$ gives the following slope test.

$$
\text{For each } j\text{ there is an }m_j\in\mathbb Z
\text{ such that } m_j(x_j-x_h)\le U_j-L_h\quad\text{for every }h.
$$

If the test passes, the lines $x\mapsto m_j(x-x_j)+U_j$ give a witness. For fixed $j$, each other observation imposes an upper or lower integer bound on $m_j$, or a slope-independent test when the coordinates coincide. If the bounds have empty intersection, at most two of them suffice to show it. Thus **on a finite set of observations, every triple admits a minimum if and only if the whole set does**. Repeated observations cover sets of size one or two. The bound is sharp. Take the exact values 5, 7, 13 at coordinates 1, 2, 3. Each pair lies on an integer line. At the middle coordinate a supporting line would need slope at most 2 and at least 6. Negating the intervals gives the dual test for maxima. [Lean proofs of the criterion and sharpness](thesis-review-30.lean) · [Four observations for a single line](thesis-review-29.html#four)

The compiler first tries the single affine line. For a minimum it considers the observations in increasing order. It fits one line to the longest initial block of upper bounds it can cover while clearing *all* lower bounds, then starts a new block. An active line in a pointwise minimum is active on an interval, since comparison with each competitor cuts out a half-line or the whole domain. With ties assigned in slope order, an optimal envelope therefore partitions the observations into consecutive blocks. Extending its first block to the greedy endpoint leaves a suffix of the original partition. Repeating gives the fewest lines on the supplied rows. Computing the slope bounds for a new upper endpoint costs one scan over the lower endpoints, so the fit takes $O(n^2)$ arithmetic operations on $n$ rows.

## Four states require both changes of slope {#mixed}

Add a fourth state and forbid $[10,12]$ as well as $[2,4]$. The permissible child keys are now singletons.

| State | Supplier | Child key | Child interval |
|---:|---:|---:|---:|
| 0 | 1 | $-1$ | $[-1,1]$ |
| 1 | 5 | 5 | $[5,7]$ |
| 2 | 9 | 7 | $[7,9]$ |
| 3 | 13 | 13 | $[13,15]$ |

The successive slopes are 6, 2 and 6. A minimum of lines has nonincreasing slopes, and a maximum has nondecreasing slopes. Neither can fit the table. With $v_+=\max(0,v)$, one expression serves all four states,

$$
k_{\rm child}(i)=6i-1-4(i-1)_+ +4(i-2)_+ .
$$

Each change in slope contributes its coefficient times a positive part. Across an integer gap of length $d$ with a rise of $a$, write $a=md+r$ with $0\le r<d$. Use slope $m$ for the first $d-r$ units and $m+1$ for the last $r$. This also works for a negative rise. Joining consecutive observations gives every finite table on distinct integer inputs an expression with linearly many terms. Lean checks the bridge identity and, independently, a finite-table construction using integer point indicators. [Four-state source](four_state_interval.gadt) · [Extremum obstruction and interpolation proofs](thesis-review-30.lean)

Revision `bee08b1` proposes these graphs for a recursive use and runs the existing branch and guard checks on each proposal. The intermediate numeric variables are fresh at each call. A test makes three calls in the same branch, at the first state, the last state, and the current state. The generated program executes with distinct interval choices. Other tests reverse the guard to require a maximum, space the observations three units apart, and obtain the observations from the written bounds on a plain numeric argument. All check and execute at budget 2. For a row with disjoint legal intervals, the fitter uses the leftmost component. Constructor indices and written scalar boundaries supply sample coordinates. The finite-table theorem assumes those rows are given. Additional inhabitants, public input bounds, and the other calls still have to pass the checker. [Executable controls](thesis-review-30.py)

## A private witness can hide a public precondition {#public}

The first three-state experiment also exposed a bad exported type. It occurs on the unmodified compiler at `3eb191e`. Give the function an extra numeric argument $l$ and write $k=\min(l,4i+1)$ and $k\le4i+1\le k+2$ in its precondition. Every result must lie in $[k,k+2]$. At $i=0$, $l=-3$, the upper bound on the supplier would require $1\le-1$. The old public signature lost this bound. The compiler accepted a client calling `run A (-3) Z` and passing its result to a function requiring a nonpositive number. The base case returns 1. Running the generated OCaml reaches the client's failing assertion. [Source program](public_interval_bound.gadt) · [Client and historical compiler check](thesis-review-30.py)

The numeric abducer had found the bound. When it trimmed the joint answer, facts about a private recursive witness sufficed to discharge the same obligations without that bound. Splitting the remaining answer put the private facts outside the public interface. In miniature, $y=x\land y\le0$ entails $x\le0$. Erasing the public restriction on $x$ would let a client supply $x=1$, for which no private $y$ exists.

Revision `0c3c4fc` checks each proposed erasure against the remaining facts in every predicate interface that owns the atom, as well as against the joint obligations. The repaired compiler rejects the bad client, accepts the valid calls and exports exactly the written input domain on this example. Z3 checks that last equality over integers and over rationals after reading the generated signature. [Scope lemma](thesis-review-30.lean) · [Public signature check](thesis-review-30.py)

## A witness can depend on two arguments together {#joint}

Give the function two independent states $i,j\in\{0,1\}$ and let the supplier return $f=4(i+j)+1$. The recursive result must again miss $[2,4]$. Fix $i=0$. At $j=0$ the only possible child key is $-1$. At $j=1$ it is 5. So no function of $i$ alone works, however large its expression. Holding $j=0$ rules out a function of $j$ alone. The joint witness

$$
k_{\rm child}=\min\bigl(6(i+j)-1,\;4(i+j)+1\bigr)
$$

satisfies all four input pairs. Its interval contains the supplier and avoids the forbidden guard for every permitted opening. The base and surviving step branches both return $f$, which every legal parent interval contains. The same argument thus works at every recursion depth. Making the key an explicit source argument verifies and executes at budget 2. [Implicit program](two_input_interval.gadt) · [Explicit control](thesis-review-30.py) · [Lean witness and impossibility of either unary policy](thesis-review-30.lean)

The implicit program still fails at `bee08b1`. InvarGenT considers one input coordinate at a time, and the supplier bounds involve both. Each of two candidate searches finishes its predicate updates on pass 2. Projecting either failing guard onto the inputs, parent key $k$, child key $c$ and result $r$ gives exactly

$$
i,j\in\{0,1\},\qquad k\le f\le k+2,\qquad
c=k,\qquad c\le r\le c+2,\qquad 2\le r\le4.
$$

For instance, $i=j=0$, $k=c=1$, $r=2$ satisfies that guard. Budgets 0 and 1 stop in the supplier. From budget 2 onward both final checks fail before a jump, and the other searches encounter incompatible return types. The trace is identical at budgets 2, 3, 40 and 10,000 in each annotation mode. Z3 checks both projections over integer and rational variables. This leaves a concrete inference question. Can the compiler recover the scalar observation $i+j$ from the supplier bounds while preserving the full set of choices available to each caller? [Trace and projection checks](thesis-review-30.py)

Run Lean 4.19 on `thesis-review-30.lean` and `python3 thesis-review-30.py /path/to/InvarGenT.native` with OCaml and Python's `z3-solver` available. Supply `--before` with revision `3eb191e` to reproduce the failing client and `--trace` with `bee08b1` built with the four existing diagnostics to check the guard traces. The source runs used the OCaml 5.5 compatibility build. The OCaml 5.3 suite passed 339 active tests with ten existing TODOs. All 171 previous generated example signatures matched byte for byte. [Diagnostic patches](thesis-review-28.html#policy)
