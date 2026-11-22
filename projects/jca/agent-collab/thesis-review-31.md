---
title: "Choosing a recursive witness from an input bound"
date: 2026-11-22
---

On the two-input program, a child call must choose an interval containing $4(i+j)+1$ that misses the guard $[2,4]$. Neither $i$ nor $j$ alone determines a safe choice. The written upper bound on the child key already contains the sum. InvarGenT at `a549d0d` reads that bound, constructs a witness, and checks the implicit program at iteration budget 2. The same construction works when the inputs range over all integers. [Earlier failure](thesis-review-30.html#joint) · [Two-state inputs](two_input_interval.gadt) · [Unbounded numeric inputs](joint_affine_interval.gadt)

## One observed bound suffices {#projection}

Let an input history $h$ admit integer keys between $L(h)$ and $U(h)$. A key $k$ promises a result anywhere in $[k+a,k+b]$, for fixed integer offsets $a\le b$. The recursive use must exclude the result band $[l,u]$. Such an opening is possible exactly when $k+b\ge l$ and $k+a\le u$. The forbidden **keys** therefore form $[l-b,u-a]$. Several guards give a finite union $B$ of such bands.

Let $P_B(x)$ be the greatest integer at most $x$ outside $B$. For every history,

$$
\exists k\in[L(h),U(h)]\setminus B
\quad\Longleftrightarrow\quad
L(h)\le P_B(U(h)).
$$

Indeed, $P_B(U(h))$ dominates every feasible key and is itself safe. This gives one policy for all histories, including histories with the same upper endpoint and different lower endpoints. A child that can observe $U(h)$ needs no access to $L(h)$ to make its choice. The statement allows infinitely many histories and imposes no bound on recursion depth. [Lean proof of pointwise elimination and uniform choice](thesis-review-31.lean)

The thesis's numeric language can express $P_B$. For one forbidden key band $[a,b]$, set

$$
P_{[a,b]}(x)=\min\left(x,\max\left(a-1,\;a-1+(b-a+2)(x-b)\right)\right).
$$

At $x=b$ the affine term is $a-1$. At $b+1$ it is $b+1$. On integers the expression returns $a-1$ throughout the forbidden band and $x$ everywhere else. Merge overlapping or adjacent bands and apply the expression in decreasing order of their lower endpoints. Moving below a later band preserves the exclusions already established. With one intermediate variable per computed value, the graph uses two extrema per merged band. Taking the minimum of $m$ written upper bounds costs another $m-1$ extrema. The number of input states plays no role in this size bound. [One-band identity, merging and composition](thesis-review-31.lean)

## What the compiler infers {#implementation}

InvarGenT first tries its existing witnesses from sampled scalar inputs. If those fail, it looks for affine upper bounds on $k$ involving numeric indices exposed by the arguments. It takes their minimum, converts the forbidden result bands to key bands, and constructs the graph above. Reflecting $k$ about zero gives the dual proposal from lower bounds. Each recursive occurrence gets fresh graph variables. The ordinary solver checks the recursive call, the original guards and the public type. The construction gives a completeness result for choosing from the specified integer interval with fixed exclusions. The solver also has to find the interval in the program's constraints and discharge its other obligations. [End-to-end checks](thesis-review-31.py)

For the two-state inputs the forbidden keys are $[0,4]$. Applying $P_{[0,4]}$ to $4(i+j)+1$ yields $-1,5,9$ at sums $0,1,2$. The parents retain all their legal choices. An unbounded variant supplies $f=i+j$ and allows $f\le1$ or $5\le f$. For example, the parent of a positive call at $f=5$ may require the result in $[3,5]$, whereas the child must choose $[5,7]$ to exclude the guard. The compiler checks both choices. Using $2i-3j+1$ for the supplier or adding a second band $[10,12]$ also works. Z3 checks the inferred public domains against the written ones over integers and rationals. Every program executes its client assertions at budget 2 in both annotation modes. Allowing $f=3$ and calling that input makes the compiler reject the program. [Unbounded program](joint_affine_interval.gadt) · [Signature and negative checks](thesis-review-31.py)

## A growing width separates a relation from a witness term {#width}

Take a state $s\in\{-1,1\}$ and any integer width $n\ge0$. Both surviving branches return $s$. A call promises a result in $[k,k+n]$, which must contain $s$. The recursive use must exclude zero from the whole interval. This forces one choice at each sign.

| State | Forced child key | Reason |
|---:|---:|---|
| $-1$ | $-1-n$ | The right endpoint must equal $-1$. |
| $1$ | $1$ | The left endpoint must equal $1$. |

The graph of these choices has a constant-size formula in the existing assertion language,

$$
k\le s\le k+n \quad\land\quad \min(k+n+1,1-k)\le0.
$$

Yet **no finite term built from integer-affine expressions, addition, negation, minimum and maximum computes this key for every width**. Each term has a constant $C$ such that changing the sign from $-1$ to $1$ changes its value by at most $2C$, uniformly in $n$. For an affine leaf take the absolute value of the sign coefficient. Addition adds the two bounds. Negation preserves the bound. Minimum and maximum take the larger bound. The forced keys differ by $n+2$. Choosing $n>2C$ gives a contradiction. [Machine-checked separation](thesis-review-31.lean) · [Variable-width program](variable_width_interval.gadt)

Bounding the *width* changes the result. For $0\le n\le N$, let $M=\lceil N/2\rceil$. A single minimum now works,

$$
k=\min\bigl(s,(M+1)s+M-n\bigr).
$$

The graph of the conditional choice has constant size even as $N$ increases. A uniform size bound on that relational solution therefore gives no uniform bound on the change of an explicit affine-extremum witness over the two signs. The compiler verifies and executes the displayed minimum as an explicit key contract at $N=240$. It also verifies the unbounded relational contract when a source function branches on the state to supply the key. [Bounded-width proof](thesis-review-31.lean) · [Both explicit controls](thesis-review-31.py)

## The feedback loop has two ways to discharge the guard {#feedback}

At `a549d0d` the unbounded variable-width program still fails with its key implicit. Both failed searches finish their predicate updates on pass 2. The final guard in each search projects exactly to $s=-1$, $n\ge1$, $k\le s\le k+n$, child key $c=s$, child width $n$, and opened value $r=0$. Choosing $c=-1$ admits zero as soon as the width is positive. The forced choice $c=-1-n$ excludes it. Budgets 2, 3, 40 and 10,000 produce identical traces in each annotation mode. There is no induction jump on this path. [Trace and exact projections](thesis-review-31.py)

Changing only the written postcondition gives another way through the same program. Writing $r=s$ makes the implicit call check at budget 2. Writing $r=s$ together with the original interval bounds checks at budget 3. The exact postcondition discharges the guard for every opening because the result retains the input sign. This leaves two distinct inference questions for Table 4.4. Can the implementation synthesize a total conditional choice for the written package? When both surviving branches already return the input sign, can it infer the missing dependency in the postcondition? Each intervention on its own suffices for this source. [Three runs on the same body](thesis-review-31.py)

The subsequent repair infers the conditional choice from the original variable-width contract. Two calls with identical arguments can still require incompatible choices. [Conditional selection and the next obstruction](thesis-review-32.html#sites)

Run Lean 4.19 on `thesis-review-31.lean`. Run `python3 thesis-review-31.py /path/to/InvarGenT.native` with the executable from revision `a549d0d`, OCaml and Python's `z3-solver` available. The optional `--before` takes `bee08b1`. The optional `--trace` takes `a549d0d` with the four existing diagnostics. The source checks used the OCaml 5.5 compatibility build. The OCaml 5.3 suite passed 341 active tests, with ten existing TODOs. All 173 previous generated example signatures matched byte for byte. [Diagnostic patches](thesis-review-28.html#policy)
