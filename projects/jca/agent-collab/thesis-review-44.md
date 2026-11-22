---
title: "When can the supplier clauses determine an induction jump?"
date: 2026-11-22
---

The previous example takes $\omega+\omega$ rounds to reach its least producer relation. Its upper-bound caller nevertheless has a short proof. The supplier clauses determine the bound $r\le x$ at the recursive opening. Projecting that bound onto the keys constructs the package in one step. This calculation works for a whole family of scalar suppliers, including examples in which the caller allows slack. It also detects exactly when a package needs a gap between two results stored at the same key. [Two-limit example](thesis-review-43.html#limits) · [Formal proof](thesis-review-44.lean)

## What does expansion force at the opening? {#orbit}

Fix a set of legal inputs. At input $x$, let $A_x$ be its nonempty set of admitted keys. The base returns a rational $g(x)$, called its centre. Each successor at that input maps $r$ to
$$
 f_{x,a}(r)=g(x)+a(r-g(x)).
$$
The set of available gains may depend on $x$. They are nonnegative, and at least one gain $a>1$ is available at every input. A caller checks $r\le d(x)$ for a finite rational $d(x)$. The same input, admissions and available gains apply on each recursive call. All the theorems below concern this fixed interface. [Producer clauses and their place in Table 4.4](thesis-review-43.html#operator)

Write $P(k,r)$ for the stored package. A result opens at $x$ if it is stored at every key of $A_x$. The base must open at $x$, and each successor applied to an open result must itself open at $x$. If some $r>g(x)$ opened there, repeated use of a single available gain $a>1$ would open
$$
 g(x)+a^n(r-g(x))
$$
there for every $n$. Eventually this exceeds $d(x)$. Thus **every solution forces $r\le g(x)$ at the opening**, however large the caller’s finite allowance. Checking $g(x)\le d(x)$ for all $x$ is necessary already at the base. Assume that check passes below. [Lean theorem `upper_forces_centre`](thesis-review-44.lean)

## One projection decides whether interval sections suffice {#projection}

For a proposed relation $S(x,r)$ at the opening, store it at every key its input admits. Opening a package intersects its key sections. These operations are
$$
 (L S)(k,r)\iff\exists y\ (k\in A_y\land S(y,r)),\qquad
 (H P)(x,r)\iff\forall k\in A_x\ P(k,r).
$$
Then $L S\subseteq P$ iff $S\subseteq H P$. Both statements require each result in $S$ to be stored at each of its input’s keys. In particular $S$ can be the *exact* opening of a package iff $H L S=S$. Indeed $S\subseteq H L S$ always. If $S=H P$, then $L S\subseteq P$ and $H L S\subseteq H P=S$. This adjunction is independent of the suppliers. [Formal statements `store_open` and `exact_open`](thesis-review-44.lean)

Take $S(x,r)$ to be $r\le g(x)$. Its projection is the explicit candidate
$$
 C(k,r)\iff\exists y\ (k\in A_y\land r\le g(y)).
$$
**A solution with a convex result set at each key exists iff $H C(x,r)$ implies $r\le g(x)$ at every input.** In that case $C$ is such a solution, and its opening is exactly $r\le g(x)$. Convexity here means that a key storing $u$ and $v$ must store every rational between them. The key domain and the joint graph of the package can have any shape.

For sufficiency, each $r\le g(x)$ is stored at every key of $x$ using witness $y=x$. The base opens. A nonnegative gain sends any such $r$ to another value at most $g(x)$, so the supplier and caller clauses hold. For necessity, suppose $H C$ admitted $r>g(x)$ at input $x$. At each of its keys $k$ there would be an input $y$ admitting $k$ with $g(y)\ge r$. Every solution stores both base values $g(x)$ and $g(y)$ at $k$. Convexity would force it to store $r$ there as well. This happens at *every* key of $x$, contradicting the expanding orbit. The witness $y$ may vary with $k$. The argument needs neither a greatest centre at a key nor a finite set of keys. [Lean theorem `cap_complete`](thesis-review-44.lean)

For rational semilinear admissions and a rational semilinear graph of $g$, linear quantifier elimination performs the projection and checks its opening. In the two-limit example $0\le x,k\le1$, $g(x)=x$, and admission means $x+k\le1$ or $(x,k)=(1,1)$. Eliminating $y$ gives
$$
 C(k,r)\iff r\le1\ \land\ (k+r\le1\ \lor\ k=1)
$$
on legal keys. Opening gives exactly $r\le x$. This derives the earlier closed certificate directly from the clauses. It also explains why a finite input-only sample at zero can miss the bound. Each positive hypothetical result may require a different key to refute it. [Quantifier-elimination replay](thesis-review-44.py) · [Earlier finite-sample obstruction](thesis-review-43.html#example)

Here is a case where projection exposes the need for a gap. Give inputs $0,1,2$ the centres $0,1,2$, gain two, and respective menus $\{a,b\},\{a\},\{b\}$. At $a$ the projected interval reaches one and at $b$ it reaches two. Their intersection opens one at input zero. The theorem rules out every solution with convex sections. Yet storing $r\le0$ or $r=1$ at $a$, and $r\le0$ or $r=2$ at $b$, is inductive. The only results opening at zero are nonpositive. At each other input the positive point is its own centre. [Finite replay and compiler guard checks](thesis-review-44.py)

## Which jumps survive a change in admission? {#changing}

Suppose the solver may change the menu at each input between known bounds $A^-_x\subseteq A_x\subseteq A^+_x$. Keep the legal inputs, centres, gains and callers fixed. Seek one package that certifies every policy in this interval, including its two endpoints. **Store using the largest menus and open using the smallest.** More precisely, form $C^+=L_{A^+}(r\le g(x))$. A common solution with convex sections exists exactly when
$$
 (H_{A^-} C^+)(x,r)\implies r\le g(x) \qquad\text{for all }x,r.
$$

For sufficiency, every intermediate menu admits enough keys to inherit the upper bound from the smallest menu. Every key it admits lies in the largest menu, so $C^+$ stores every result at or below the input’s centre there. These two facts give the base, successor and caller clauses at every policy. For necessity, take a result above the centre surviving the displayed test at input $x$. At each key of the smallest menu, the smallest policy forces the base $g(x)$. The largest policy forces some base $g(y)\ge r$ at that same key. Any common convex solution must therefore open $r$ under the smallest policy, where the expanding orbit rules it out. [Lean theorem `admission_interval`](thesis-review-44.lean)

Checking each endpoint with its *own* package can miss the conflict. At centre zero let the small menu be $\{a\}$ and the large one $\{a,c\}$. At centre one let them be $\{b\}$ and $\{a,b\}$. Each endpoint has an interval solution. Under the large policy, key $c$ protects the caller at zero. But the base at one now forces one at $a$, the only key tested at zero under the small policy. No single package, even with gaps, works for both. Of the 361 nested menu pairs for two centres and three keys, 18 admit separate endpoint solutions but no common one. [Exhaustive replay](thesis-review-44.py)

If several policies can occur but the pointwise smallest menu cannot, one can instead store using their union and check each actual menu. This is the fixed-admission projection theorem applied to inputs $(\text{policy},x)$ that share the same stored package.

## Finitely many centres decide the case with gaps {#finite}

Now assume that the sets of centres $G$ and available gains are finite and nonempty. In this part every gain is at least one, and each input still has an expanding gain. Inputs and key menus may be infinite. Let $m=\min G$. **There is a terminating test for the existence of any package for these upper-bound callers**, provided the admission and branch-availability formulas admit effective projection and universal tests, as rational semilinear formulas do.

First put the whole tail $r\le m$ at every key. This preserves feasibility. Given any solution $P$, adjoin the tail. Results above $m$ have exactly their old openings. For $r\le m\le g(x)$ and $a\ge1$, the successor returns at most $r$, already in the tail. The caller admits every tail value. The enlarged solution contains the new seed, and any solution built with the seed also satisfies the original clauses. This move depends on the direction of the caller and on the gains. [Lean theorem `add_tail`](thesis-review-44.lean)

Above $m$ start with the base values. A value $t$ opening at $x$ has three possible effects.

| Condition | Consequence |
|---|---|
| $t>g(x)$ | Reject. Repeating an expanding branch at this input eventually breaks the caller. |
| $t=g(x)$ or $a=1$, after the preceding check | The output is already stored at every key of $x$. |
| $t<g(x)$ and $a>1$ | Store $v=g(x)+a(t-g(x))<t$ throughout $A_x$. If $v\le m$ the tail already contains it. |

Only finitely many values above $m$ need consideration. Form a tree rooted at each base value above $m$. Its children are all strict images $v$ in the last row with $v>m$, allowing every centre and gain from the two finite sets. If a path were infinite, some pair $(c,a)$ would occur infinitely often. Let $t_0<c$ be the value at its first occurrence. Every later use of this pair would decrease the current value by at least $(a-1)(c-t_0)>0$. Other steps also decrease it. Enough uses would take the path below $m$. Thus every path is finite. A finitely branching tree with infinitely many nodes would have a child with infinitely many descendants at each successive depth. Hence the trees themselves are finite. [Lean proofs of well-foundedness and finite closure](thesis-review-44.lean)

Process these values from greatest to least. The row $E_t$ is the set of keys so far required to store $t$. Initialize it with the keys admitted by inputs of centre $t$. When processing $t$, test $A_x\subseteq E_t$ for the opening at $x$. All strict introductions into this row come from larger values, so the row is complete when tested. For each strict output $v>m$, add to $E_v$ all keys admitted by an input where $t$ opens and the corresponding branch is available. Each addition is an existential projection. Empty rows can be skipped by keeping a queue of values actually introduced. Universal admission tests still range over the whole menu.

Every entry above $m$ in these rows is forced in every original solution. The base starts the induction, and a strict introduction uses a larger row already proved necessary. A rejection therefore rules out arbitrary solutions, including ones with gaps. If no check rejects, use the package
$$
 r\le m\quad\lor\quad\bigvee_{t>m\ \text{in the processed rows}}(r=t\land k\in E_t).
$$
Every base is present. The three cases in the table cover every successor, and the orbit check bounds each opening by its centre. This proves sufficiency. With rational semilinear data and finite rational gains the construction is effective in rational linear arithmetic. Its row formulas may use strict inequalities. Existence in the thesis’s weak-inequality language can impose an additional closedness condition. [Closedness and projection](thesis-review-43.html#closed)

## A fixed answer can still take exponentially many rounds {#rounds}

Use three inputs again, with the following admissions. The caller at each input asks for its centre as the upper bound.

| Centre | Keys |
|---|---|
| $0$ | $c$ |
| $1$ | $a,b$ |
| $2$ | $b$ |

All three use the same gain $1+1/q$, with $q=2^N$ and $N\ge1$. The projected solution is always $r\le0$ at $c$, $r\le1$ at $a$, and $r\le2$ at $b$. Only the gain in the supplier changes. The answer and its three bounds are independent of $N$.

Start simultaneous rounds with the bases and the entire tail $r\le0$. Above the tail, $a$ keeps just one and $c$ stays empty. At $b$ the centre two is fixed. The base one starts a second sequence there. Each round adds exactly the next positive value
$$
 t_j=2-(1+1/q)^j,\qquad t_0=1,
$$
until the next value lies in the tail. No other input supplies a new positive value. Let $h$ be the first $j$ with $(1+1/q)^j\ge2$. There are exactly $h-1$ productive rounds after seeding. For $j\le q/3$, the binomial expansion gives $(1+1/q)^j\le\sum_{i\ge0}(j/q)^i\le3/2$. At $j=q$, Bernoulli’s inequality gives $(1+1/q)^q\ge2$. Thus the round count is $\Theta(q)$, exponential in the binary length of the gain. Without the initial tail, the same orbit continues through infinitely many negative values at $b$. The literal producer reaches its first fixed point at $\omega$, since all menus here are finite. With the projected jump, one calculation gives the three bounds for every $N$. [Exact rational replay](thesis-review-44.py)

## What this changes for InvarGenT {#compiler}

In InvarGenT revision `f872939`, `NumS.converge` can retain an earlier inequality when all projected suppliers imply it. The solver can also schedule a pass to recover a tighter cap when a caller keeps renewing a demand. The projection above supplies a different source of candidate inequalities. An expanding branch derives the bound at the *opening*, and projecting through admission translates it to a formula at the *stored keys*. A compiler could try that formula as soon as it recognizes the recentered suppliers. An implementation would need to establish that the expanding branch can repeat at the same input and check the projected candidate against the original clauses. The admission-interval theorem supplies a certificate that survives subsequent changes within proved bounds. Whether the evolving predicates in Table 4.4 provide useful such bounds early enough to guide an actual jump remains open. [Supplier bounds in the implemented jump](thesis-review-42.html#repair) · [Changing-admission example](thesis-review-43.html#operator) · [Original Table 4.4 recurrence](thesis-review-3.html#update)

The [Lean file](thesis-review-44.lean) checks the adjunction, the orbit argument, completeness for convex sections at fixed and varying admissions, tail extension, and finiteness of the strict value graph with Lean 4.19 and mathlib v4.19.0. The [Python replay](thesis-review-44.py) takes `z3-solver`. It checks the triangle projection symbolically, compares descending evaluation with simultaneous rounds on 1,372 finite menu, branch and caller configurations, checks 361 nested admission pairs for two centres, and verifies the round family through $q=512$. With `--driver` pointed to the executable built from the [InvarGenT arithmetic driver](thesis-review-41-numeric.ml), it also checks the two packages in the gap example against 48 guards with both rational and native result observations. These guards exercise the existing all-keys predicate.
