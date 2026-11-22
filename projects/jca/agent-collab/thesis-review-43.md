---
title: "What happens at the limit of recursive package openings?"
date: 2026-11-22
---

An exact recursive update can finish its first infinite sequence of rounds and still produce a new result on the next round. A scalar affine supplier gives an example with a constant-size inductive answer. Its least relation takes exactly $\omega+\omega$ rounds. The extra rounds come from a choice the previous rank calculation held fixed. A single runtime result must satisfy the package at **every** admitted key. [Single-key rank theorem](thesis-review-42.html#rank) · [InvarGenT’s all-keys check](thesis-review-39.html#all)

## Which update is being iterated? {#operator}

Let $A_x$ be the nonempty set of keys admitted at input $x$. Write $R(k)$ for the set of results in the package at key $k$. Opening the recursive call at all its typings permits the set
$$
 H_R(x)=\bigcap_{k\in A_x}R(k).
$$
A base supplier returns $x$. A successor at the same input maps a result $r$ to $f_x(r)$. Every introduced result must be stored at every admitted key. The exact producer step is
$$
 F(R)(k)=\{x:k\in A_x\}\ \cup\!
    \bigcup_{x:\,k\in A_x} f_x(H_R(x)).
$$
The sets range over legal inputs. Take $R_0$ to be the base and $R_{\alpha+1}=F(R_\alpha)$. At a limit take the union separately at each key. The sequence is increasing by monotonicity. It is contained in every relation satisfying the base and successor clauses. Its first fixed point is therefore the least such relation. This gives a semantic version of the producer update in (4.1–4.2) with exact simultaneous openings. InvarGenT uses the all-keys rule for selected checks on an inferred scheme. Table 4.4 also runs generalization, caller abduction and widening. [Table 4.4](../lukstafi-phd-thesis.pdf#page=71) · [Cousot and Cousot on transfinite fixed-point iteration](https://www.di.ens.fr/~cousot/COUSOTpapers/Tarski-79.shtml)

If each $A_x$ is finite, the union of the finite rounds is already a fixed point. For $r$ to survive at $x$ in the union, each key must have admitted $r$ at some finite round. The largest of those finitely many round numbers works for all keys. This gives $H_{\cup_n R_n}(x)=\bigcup_n H_{R_n}(x)$, and the producer images and unions commute with the ascending union. There need be no uniform bound on the sizes of the finite $A_x$. The same proof works if each input has finitely many distinct types of key, where keys have the same type when exactly the same legal inputs admit them. Such keys start equal and receive identical introductions at every round. [Finite synchronization proof](thesis-review-43.lean)

Changing admission between rounds has two effects. Adding a key gives an introduction another place to store its result and gives an opening another constraint to satisfy. For example, let inputs zero and one admit only keys $a$ and $b$, respectively. Take a candidate $R(a)=\{0,1,2\}$, $R(b)=\{0,1\}$ and successor $f_x(r)=2r-x$. The old step stores $4$ at $a$, and at $b$ it stores only $-1$ and $1$. Now also admit $b$ at input zero. Its common opening shrinks to $\{0,1\}$. The new step loses $4$ at $a$ and gains $2$ at $b$. The candidate covers the base for both admissions. Even adjoining the candidate itself to both updates leaves them incomparable, since neither differing result was already stored at its respective key. A convergence proof for changing admissions needs another invariant besides pointwise growth of the stored relation. [Finite calculation](thesis-review-43.py)

## How many parameters does a choice of keys carry? {#menus}

Some supplier families force an opening to determine its input exactly. For example, on $[0,1]^d$ let the base return the vector $x$. The successors recenter $r\mapsto x+T(r-x)$ at that same input. One matrix shifts errors one place left and another negates them. The caller only checks $r_1\le x_1$. If $r$ survives every key of $x$, successive shifts move any chosen error to the first coordinate. The caller bounds it above by zero. Negating before the shifts bounds its negative above by zero as well. Thus $r=x$.

For such a family a package exists exactly when $A_x\subseteq A_y$ implies $x=y$ on legal inputs. Indeed, the base at $y$ supplies result $y$ at every key of $A_y$. Inclusion then opens $y$ at $x$, forcing equality. Conversely, store $r$ at $k$ exactly when $r$ is legal and $k\in A_r$. The opening at $x$ now gives $A_x\subseteq A_r$ and hence $r=x$. Every recentered successor preserves $x$. Nonempty admissions ensure that a result surviving all keys is legal. [Exact-opening criterion in Lean](thesis-review-43.lean)

One scalar key **with $d$ choices** suffices on the cube. At input $x$ admit the keys $2j+x_j$ for $j=0,\ldots,d-1$. Their disjoint unit intervals identify the coordinate. Inclusion of two menus implies equality in every interval. The single-key theorem requires $d$ independent affine parameters on this same cube. The distinction is the information carried by all the choices together.

More precisely, suppose each menu consists of at most $m$ points in $\mathbb Q^p$, and admission is rational semilinear. Then $mp\ge d$ is necessary on any domain containing an open $d$-dimensional box. Sort each nonempty menu lexicographically and repeat its last point to fill $m$ slots. This is a definable map into $\mathbb Q^{mp}$ by linear quantifier elimination, and distinct menus give distinct lists. A semilinear single-valued map is affine on finitely many polyhedral pieces. To see this, split its graph into relatively open convex polyhedra. The affine hull of each such piece projects injectively onto the input coordinates, since a vertical direction would give two outputs inside the piece. One input piece has full dimension, and an injective affine map there has rank $d$. On the cube this bound is sharp. Group the coordinates into blocks of at most $p$, pad the last block with zeros, and give each block a disjoint unit interval in its first key coordinate by adding an even integer. Exactly $\lceil d/p\rceil$ choices suffice for $p\ge1$. The arithmetic replay checks menus for one through six input coordinates and one or two coordinates per key, including what becomes possible when one key is omitted. [Menu checks](thesis-review-43.py)

## One extra admission changes the limit {#example}

Let the legal inputs and keys be rationals in $[0,1]$. An input admits every key $k\le1-x$. The input $x=1$ also admits $k=1$. Equivalently the joint admission is a closed triangle together with the point $(1,1)$. The successor returns
$$
 f_x(r)=2r-x .
$$
One caller requires $r\le x$ at every input. The following closed package has constant size.
$$
 C(k,r)\ \equiv\ r\le1\ \land\ (k+r\le1\ \lor\ k=1).
$$
For $x>0$, open at $k=1-x<1$ to get $r\le x$. At $x=0$ all ordinary $k<1$ give $r\le1-k$, hence $r\le0$. Conversely every $r\le x$ satisfies the package at each admitted key. The base returns $x$ and $2r-x\le x$ whenever $r\le x$. This proves all three clauses. Projecting the forced opening $r\le x$ onto the admitted keys derives this formula directly. [Construction and completeness for interval sections](thesis-review-44.html#projection) A finite collection of keys at input zero still leaves a positive rational result possible, since each ordinary cap in that collection is positive. [Inductiveness and caller bound in Lean](thesis-review-43.lean)

## Every finite approximation {#finite}

Put $c_n=2^n-1$ and $S_n=\{1\}\cup\{1-2^j:0\le j\le n\}$. The exact finite relation and its openings are

| Place | Results after round $n$ |
|---|---|
| Ordinary key $0\le k<1$ | $[-c_n(1-k),\,1-k]$ |
| Exceptional key $k=1$ | $S_n$ |
| Input $x=0$, after opening all its keys | $\{0\}$ |
| Input $0<x<1$, after opening all its keys | $[-c_n x,\,x]$ |
| Input $x=1$, after opening both keys | $S_n$ |

At round zero the intervals give just the base results stored at each key. For $0<x<1$, the smallest admitted interval is the one at $1-x$. Applying the successor to it gives $[-(2c_n+1)x,x]$. For an ordinary $k>0$, input $x=1-k$ fills the whole new interval. At $k=0$ inputs $x<1$ fill its interior and input one supplies both endpoints. At key one the only suppliers are inputs zero and one. They supply zero, one and the images $2(1-2^j)-1=1-2^{j+1}$. This proves the table by induction. In particular, for *every* finite round a caller at zero asking for $r\ge0$ passes. [Symbolic replay over all rational inputs and results](thesis-review-43.py)

## The two limits {#limits}

At the first limit an ordinary key $k<1$ admits every rational $r\le1-k$, since its negative endpoint tends to $-\infty$. At key one the stored results are $1$ and $1-2^j$ for natural $j$. Thus $-1$ now survives **all** keys at input zero. No finite round admitted it at that input. For a direct proof against any proposed invariant, fix an ordinary $k$ and choose $n$ large enough that $x=1/(2^n-1)\le1-k$. Result zero is available at every key of this $x$ from the base at zero. Applying the successor $n$ times at $x$ forces $-(2^n-1)x=-1$ at $k$. At the exceptional key use $x=1$ and one step. Every producer invariant therefore violates the lower-bound caller at zero. This is a limitation of the specified package interface. The source recursion starting at its own base always returns $x$. [Proof for arbitrary candidate relations](thesis-review-43.lean)

The producer itself also moves at the limit. At input zero the newly common $-1$ gives $-2$, which has never appeared at key one. From here the ordinary keys keep their half-lines. A successor at input $x>0$ receives only $r\le x$, so its output is $\le x\le1-k$ at each ordinary key it supplies. At input zero all common results are nonpositive. The exceptional key keeps $1$. Describe its other values by their nonnegative deficits $d=-r$. At the first limit the deficits are $2^j-1$, binary strings of ones including zero. Input zero sends $d$ to $2d$ and input one sends it to $2d+1$. Both inputs can use every stored deficit. Each successor round retains the old values and appends one binary digit to any old deficit.

After $m$ further rounds, at most $m$ digits have been appended to an initial string of ones. In particular $2^{m+1}$ is still missing, and the next round produces it from $2^m$. Its binary expansion needs $m+1$ trailing zeros after a positive starting value. At the second limit every nonnegative integer occurs, since every finite binary string can be built from zero. Only the exceptional key has changed since the first limit. If a result survives all keys at the second limit, it already survives them together at the finite stage after the first limit when that exceptional key admits it. If the input does not admit the exceptional key, its first-limit opening already suffices. This synchronizes the surviving result for the next producer step. The least fixed point is reached at **exactly $\omega+\omega$**. Its section at key one consists of $1$ and the nonpositive integers, so no finite union of rational intervals and points defines it. The closed formula $C$ still certifies the upper-bound caller. [Strict steps, both limits, fixedness and leastness in Lean](thesis-review-43.lean)

## What a closed constraint language can express {#closed}

Closing the *joint graph* of the relation at the first limit gives a different exact result. For $k<1$, every nonpositive rational $r$ is already stored. To see this directly for any producer invariant, choose $n$ with $x=-r/(2^n-1)\le1-k$ and repeat the argument for $-1$. If the graph is closed, approaching $k=1$ with that same $r$ puts $r$ at the exceptional key too. Input one supplies the point $(1,1)$. Together with the base triangle these facts force the closed relation
$$
 D(k,r)\quad\equiv\quad r\le1-k\ \lor\ (k=1\land r=1)
$$
on legal keys. It is inductive. At input zero the possible results are nonpositive. At input one they are nonpositive or exactly one. Both sets are preserved by their respective successors. Every other input sees $r\le x$, just as it did with $C$. Thus $D$ is the **least closed producer invariant**, and taking joint closure at the first limit reaches it. Convexifying each individual key section of $D$ gives $C$. Convexifying the joint graph would lose the caller bound even at input zero. The two base points $(0,1)$ and $(1,1)$ force $(k,1)$ at every key by convexity. [Least-closed-invariant proof](thesis-review-43.lean)

Remove the single admission $(1,1)$ and the difference becomes an expressibility obstruction. Input zero is now the only supplier at key one. That key keeps $\{0\}$, while each $k<1$ eventually admits every $r\le1-k$. This relation is fixed at the first limit and validates the lower-bound caller $r\ge0$ at zero. Its key sections are individually closed. Any *jointly* closed producer invariant still contains $(1,-1)$ by the ordinary keys approaching one, so it fails that caller. A formula with finitely many rational affine equations, weak inequalities, min/max branches and existential rational witnesses defines a finite union of closed polyhedra. Each conjunction projects by linear elimination and the finite union stays closed. No package in that language can certify this lower bound at the specified interface. Allowing a strict test $k<1$ expresses the displayed solution. [Triangle control and closed-graph obstruction in Lean](thesis-review-43.lean) · [Projection of private witnesses](thesis-review-38.html#projection)

The choice of interface resolves the lower-bound failure in both examples. Carry $x$ along with $k$ and use the single equation $r=x$. It contains the base, and $2x-x=x$ proves the successor clause. In the version with the isolated admission, every candidate at the old interface had failed. In the triangle alone, a candidate existed there but the weak inequalities of the answer language could not express it. This gives two distinct reasons to add a parameter when a postcondition update continues to fail. [Thesis discussion of branch generalization](../lukstafi-phd-thesis.pdf#page=134)

## What the compiler checks {#compiler}

The [source example](limit_result_keys.gadt) gives the recursive function the admission above and the package $C$. It passes $x+1$ as a second numeric argument. Before computing $2r-x$, the successor checks the guard $x+1\le r$ and gives that arm a Boolean result. Inferring the numeric function therefore requires ruling out the arm. The external arithmetic operation returns the exact integer when it succeeds. A range check can stop it before overflow. At the two tested inputs the program returns zero and one.

There is a short certificate for the guard. The key $(1-x)/2$ is admitted at every input. Its ordinary upper bound is $(1+x)/2$, strictly below $1+x$. Even the stronger rational claim $r\le x$ has a single refuting expression once the hypothetical result is known. For $x<r\le1$ take $k=1-(x+r)/2$. It is admitted, is less than one, and gives $k+r>1$. The absence of a finite input-only sample at zero concerns the exact rational upper bound. [Symbolic checks for both choices](thesis-review-43.py)

The previous compiler scheduled the all-keys check early when an admission disjunction mentioned the key on only one side. Here both sides mention it. The source uses $i+k\le1$ or $i+k\ge2$, which is exactly the triangle and isolated point in the unit square. The two inequalities give opposite directions in $k$. The box bounds also imply $2-i-k\ge0$, so the second inequality can hold only at equality. InvarGenT now normalizes the key coefficients and tries the complete guard check early when the two directions are opposite and an arm is confined to an attainable equality by the linear admission constraints. A key-free arm retains the earlier priority. Two separated intervals with interior keep their existing order of probes. The criterion selects a proposal. Admission still uses the intersection of the written and inferred domains, and the checker verifies the original guard against every admitted typing before using the exclusion.

To compare proposals, first let the successor return $x$ after the guard. Revision `a953fc1` tried three families of probes before the all-keys check succeeded. With the change that check is the first proposal. The two exported schemes have the same domain and the same package. Restoring $2r-x$ also passes in the revised compiler at outer budget four. On that transfer the diagnostic for the earlier revision was stopped during its second probe proposal after 230 seconds. Its eventual outcome is unknown. In a control the base returns one, and its written package permits one at every admitted key. At input zero the Boolean arm is reachable and the compiler rejects it. Returning the numeric value from that arm instead prints one. A further source control requires $r=x$ in the package and gives the negative-result arm a Boolean body. Its full exported scheme retains that equality, and the two calls print zero and one. [Proposal diagnostic](thesis-review-43-trace.patch) · [Scheme, execution and diagnostic replay](thesis-review-43.py)

## Reproducing the checks {#replay}

InvarGenT revision `f872939` implements the proposal order. Its OCaml 5.3 compatibility run passed all 375 active tests, with ten recorded as TODO. The 192 earlier example signatures were byte-identical to those at `a953fc1`. The arithmetic driver on the OCaml 5.5 compatibility build checked 92 finite menus and 80 guards, each with a rational and an integral observation.

Run the [Lean proof](thesis-review-43.lean) with Lean 4.19 and mathlib v4.19.0. The theorems `finite_strict`, `after_strict`, `second_fixed` and `second_least` use the producer step itself. Run `python3 thesis-review-43.py` with `z3-solver`. The [replay](thesis-review-43.py) eliminates the input and key quantifiers to compare the first ten entire producer steps with the displayed formulas. It also checks the closed solution and the binary deficits through 4096. Pass `--driver` with the executable built from the [InvarGenT arithmetic driver](thesis-review-41-numeric.ml) to check the closed solution and slices of the finite approximations against the implemented all-keys predicate, with both rational and native observations. Add `--compiler` for the end-to-end source checks. Build each compiler with the diagnostic and pass it as `--before-trace` or `--trace` to replay the proposal counts.
