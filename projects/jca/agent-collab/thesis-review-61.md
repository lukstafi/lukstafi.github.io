---
title: "Can InvarGenT infer a small typing without unfolding its public facets?"
date: 2026-11-23
---

InvarGenT now infers the recursive type of `let rec probe = Spin probe` at the boundary caller $\mathrm{Probe}(2,0,1)$ on the slowly rotating family. At $n=18$, every conjunctive certificate using public coordinates alone needs at least **65,537 facets**. The inferred type has **129 inequalities and 62 private indices**, counting an equality twice. Feeding the exported type back as an annotation checks the same caller. The heap still consists of one node. [Lower bound for this caller](thesis-review-59.html#lower) · [Native and independent replay](thesis-review-61.py)

## What the checker uses as a witness {#witnesses}

A public point has coordinates $p$. Two rational affine measurements $u(p),v(p)$ give it a length $R=\sqrt{u^2+Dv^2}$, for rational $D>0$. The constructor and its type contain only linear terms. Square roots occur in the correctness argument. For example, a field can rotate the measured plane while multiplying a third coordinate $t$ by a rational rate greater than one. A single affine choice of all the child's private indices can fail even when every parent has a child opening. On the slowly rotating family, any polynomial-size lift needs exponentially many affine choices to open the whole ground orbit. [Witness-policy lower bound](thesis-review-59.html#policies)

The type starts with private variables $X_0\ge |u|$ and $Y_0\ge |v|$. Each absolute-value lower bound abbreviates two linear inequalities. A fold with $c,s>0$ and $c^2+Ds^2=1$ introduces a **fresh** pair
$$
 X'=cX+DsY,\qquad Y'\ge|cY-sX|.
$$
Every allowed opening can only increase squared length. Choosing equality in every absolute-value bound preserves length. A chain of $m$ such choices gives a piecewise-linear witness with $O(m)$ operations. Its intermediate values can be shared.

For the tight opening, the first fold maps the nonnegative quadrant into $cY'\le sX'$ if $c^2\le Ds^2$. Suppose the preceding pair is in $Y\le kX$. The next tight pair satisfies $cY'\le sX'$ if $k(c^2-Ds^2)\le 2cs$. To see the inequality, take the two signs of $cY-sX$. Only the positive sign needs the preceding wedge bound. The checker obtains each $c,s,D$ from the input rows, checks the common $D$, and accounts for every private constraint. The matcher requires each stage to allocate distinct private indices. [Weighted fold and wedge lemmas in Lean](thesis-review-61.lean)

The last pair lies in a written wedge $0\le Y\le kX$. A terminal cap has the form $X+aY\le B(p)$ with $a\ge0$. If $(D-a^2)k\le 2a$, then $X^2+DY^2\le(X+aY)^2$. Hence **every opening** gives $R\le B(p)$. Conversely the tight opening satisfies $X+aY\le\sqrt{1+a^2/D}\,R$ by weighted Cauchy–Schwarz. For a field, the checker introduces one rational-LP variable standing for the parent's radius and puts it below every cap. It checks the guard and each child cap against those simultaneous bounds. It also checks that the tight child lies in its written wedge and that the parent type has an opening. At each field occurrence the child gets fresh witnesses. Rational approximation only enlarges the upper bounds used in sufficient checks. Feasibility over rational linear inequalities also establishes the corresponding real implications. [Rational lifted approximations of the second-order cone, Kocuk](https://arxiv.org/abs/1912.00256)

## Recovering a measurement from the field and guard {#metric}

Consider a direct constructor with three public indices. After an unknown rational affine change of coordinates, one field rotates a plane and sends $t$ to $rt$, where $r>1$. Suppose its guard is $g=u-t+C\le0$ with constant $C$ and nonzero rotating component $u$. Let $A$ act on affine forms by composition with the field. For the field's linear part $L$, put $r=|\det L|$ and $s=\operatorname{tr} L-r$. On the rotating plane $A^2-sA+I=0$. Consequently
$$
 H=(A^2-sA+I)g=-(r^2-sr+1)t+(2-s)C,\qquad
 t=-\frac{(A-I)H}{(r-1)(r^2-sr+1)}.
$$
This also recovers $C$ and $u=g+t-C$. Write $c=s/2$, take any positive rational $K\ge\sqrt{1-c^2}$, and set
$$
 v=(Au-cu)/K,\qquad D=K^2/(1-c^2).
$$
In these coordinates $Au=cu+Kv$ and $Av=-(1-c^2)u/K+cv$, so $A$ preserves $u^2+Dv^2$. The implementation checks that the three recovered forms have independent linear parts. It verifies the actual action of **every** field on the same quadratic form and on the slack. It can try a composition of two fields to expose the plane. Two reflections preserving $x^2+2y^2$ give a regression case where the product supplies the rotation and the original two fields must each pass the check.

The weight matters over the rationals. If $x^2+2y^2=q(U^2+V^2)$ for two rational linear coordinates with matrix $M$ and rational $q$, determinants give $2=(q\det M)^2$. This is impossible. In the native example the matrix with rows $(7/9,-8/9)$ and $(4/9,7/9)$ preserves $x^2+2y^2$. With the public coordinates renamed and translated to $(u,v,t)=(i+j+1,j+k-2,i+j+k-1)$, the guard becomes $1\le k$. The same source-level inference succeeds, including for symbolic callers. [Generate the reindexed program](thesis-review-61.py)

## Why increasing the precision terminates on a class of callers {#synthesis}

**Theorem.** Suppose all fields preserve $R=\sqrt{u^2+Dv^2}$ and send $t$ to $r_e t$, where $r=\min_e r_e>1$. Use the single guard $u\le1+t$. Let a family of requested callers satisfy
$$
 t\ge0,\qquad |u|,|v|\le b t,\qquad R\le1+t
$$
for a common finite $b>0$. For the weight recovered above, the dyadic construction below yields a finite conjunctive rational inductive typing covering the whole family. The inequalities allow callers on the guard or disk boundary, and slack approaching zero. This is a certificate-existence theorem in the unbounded rational syntax.

Choose a rational $h$ with $R\le ht$ on the callers and a rational $H>h$. The generator doubles $b$ from one until the two coordinate bounds hold, then uses $H=(1+D)b$. One can take $h=(1+D/2)b$, since $(1+D/2)^2\ge1+D$. Keep the public guard and $t\ge0$. Give the private folds two caps, with right-hand sides $Ht$ and $1+rt$. The first cap gives a feasible zero-radius opening at $t=0$. The second allows the boundary point $(2,0,1)$ as soon as the fold is precise enough.

For $j=1,\dots,m$, put $a_j=2^{-j}$, $c_j=(1-Da_j^2)/(1+Da_j^2)$ and $s_j=2a_j/(1+Da_j^2)$. Take $a=Da_m$ in both terminal caps. The generator rounds the square root of a rational $n/d$ upwards as $\lceil\sqrt{nd}\rceil/d$ for positive coprime integers $n,d$. Hence its recovered weight satisfies $1\le D<4$. The first fold angle $2\arctan(\sqrt D/2)$ in the coordinates $(u,\sqrt D v)$ is at least $\pi/4$ and less than $\pi/2$. Concavity of $\arctan$ gives an angular decrease of at most a factor of two at each later stage. Thus the tight folds meet their final wedge. The last wedge and cap satisfy the preceding rational inequalities with slope $s_m/c_m$. The tight overhead is at most $1+\delta$ with $\delta=D4^{-m}/2$.

Every admitted parent has $R\le Ht$ and $R\le1+rt$. To open the child it suffices to have
$$
 \delta\le r-1,\qquad \delta H\le r(r-1).
$$
Indeed $(1+\delta)R\le Hrt$. Also $R+\delta R\le1+rt+\delta Ht\le1+r^2t$. Every child satisfies its public guard since $u'\le R\le1+rt$. The same argument works for any $r_e\ge r$.

For the callers it suffices that $(1+\delta)h\le H$ and $\delta h\le r-1$. The first condition gives the conical cap. The second gives $R+\delta R\le1+t+\delta ht\le1+rt$. All four precision bounds have strictly positive headroom at $\delta=0$, so a finite $m$ satisfies them. The proof uses the same bounds at the point where the tighter cap changes. [Child caps, caller caps and finite precision in Lean](thesis-review-61.lean)

For the fixed ground use of the slowly rotating family, $H,h,D$ can be held constant and $r-1=2^{-3n}/16$. This proves $m=O(n)$ precision refinements. Exact public preimage iteration needs $\Theta(2^n)$ rounds on $t\ge1$. Here the induction jump constructs the private invariant directly. The original Table 4.4 update can loop even with a two-inequality solution. A size promise alone supplies no termination proof for that iteration. The native generator also has finite literal and search budgets. [Exact public unfolding](thesis-review-59.html#rounds) · [Two-inequality recurrence](thesis-review-3.html#update)

### Extending the construction beyond the disk {#prefix}

Some safe callers violate even $R\le1+rt$, an upper bound imposed by the inferred one-step cap. There is a finite extension with the **same private fold chain** for any safe caller family satisfying $t\ge0$ and $R\le ht$ for finite $h$. Choose $H>h$. Retain the actual public guards for all field words of lengths $0$ through $N-1$. Replace the future cap $1+rt$ by $1+r^N t$. Each child owes one new layer of public guards at the frontier. The parent radius is at most $1+r^Nt$, and all words of length $N$ multiply the slack by at least $r^N$. This pays for every frontier guard.

Write $L=r^N$. The child cap proof above now needs $\delta H\le L(r-1)$ and $\delta\le r-1$. Choose $N$ with $L>h$, and then choose $m$ with $(1+\delta)h\le\min(H,L)$ as well. These choices open the entire caller family. If the family is specified by a rational polyhedron, checking the finite prefix against it is rational linear entailment. A failure supplies a violating caller and word. A success supplies a typing. This gives a decision procedure on the cone-bounded class with known geometry. Its number of explicit word guards can be large. The finite-horizon seed construction also decides this class. Here **one** folded relation serves every frontier word. [Predecessor construction from a robust seed](thesis-review-60.html#coverage)

An explicit polyhedral caller also determines how many guards to retain. Write its image in $(u,v,t)$ as the convex hull of finitely many vertices plus the cone of finitely many recession generators. The cone bound permits only the zero measured direction at zero slack. For a vertex $v$ with $t_v>0$, take $(R(v)-1)/t_v$. For a ray $d$ with $t_d>0$, take $R(d)/t_d$, using the linear part of the measurements on directions. Let $A$ be the maximum of these numbers, with an empty maximum imposing no condition. Then $R\le1+Lt$ on the entire caller exactly when $L\ge A$, for $L>0$. Necessity follows at the vertices and by taking a limit along each ray. Sufficiency follows by the triangle inequality in a vertex-and-ray decomposition. Since there are finitely many generators, $L>A$ gives room for a common positive $\delta$ in $(1+\delta)R\le1+Lt$. Equality can still admit a tight opening and needs a separate check. The first positive $N$ with $r^N>A$ is computable by squared rational comparisons, doubling and bisection. For the fixed boundary caller $(2,0,1)$ this rule picks $N=1$ for every $n$. Thus the choice of horizon preserves the linear-depth result even when $r$ is extremely close to one. From the generators one can also check every retained public guard, choose $H$ by doubling, and select the first depth meeting the four cap inequalities. The standalone procedure recovers the native fold counts at all six tested values of $n$. For two rotating fields, it agrees with an independent finite guard check on 98 point and ray callers, including 52 safe cases.

For the $x^2+2y^2$ field above, take $(x,y,t)=(-51/25,0,1)$. Its radius exceeds $1+r^2$ for $r=65/64$. The first three guards hold. Using $N=3$, $H=8$ and five folds gives a written inductive type that the compiler verifies at this caller. The current native generator selects the one-step cap. The replay selects a prefix from explicit caller generators. Extending the native synthesis path to make that selection from caller constraints would cover these points directly. [Executable three-guard example](thesis-review-61.py) · [Child frontier in Lean](thesis-review-61.lean)

## How to check a whole caller family {#callers}

The generated scheme is a conjunction, so its projection is convex. Fix all but one public coordinate of a rational polyhedral caller. A bounded nonempty fibre is an interval. Open both endpoints and take convex combinations of the complete lifted points. If the interval is a ray, open the finite endpoint and lift the unbounded direction into the recession cone. A whole line needs a section and both signs of its direction. Each finite endpoint is attained on an input hyperplane. Substitution there removes a coordinate. This proves a finite verification rule provided its leaf obligations can be solved. Rational public points can use rational interpolation coefficients.

The implementation first substitutes equations with a single unresolved private variable, then takes tight absolute values whose signs the caller fixes. It rechecks every affine row after substitution. If the signs vary it can apply the interval rule above, subject to a budget. General projection remains a fallback. A plain value alias can copy an already checked folded scheme. These steps give one published type covering a point, a box crossing both coordinate axes, and an unbounded ray. The replay independently asks Z3 for a violating point anywhere in either symbolic family. [Executable caller checks](thesis-review-61.py)

## Native replay and arithmetic diagnostics {#replay}

For $n=2,3,4,8,12,18$, the compiler checks the earlier written certificates, synthesizes a type for the unannotated binding, and verifies its own exported type on re-entry. The written seven-fold $n=3$ case previously reached a five-minute diagnostic cutoff. At $n=18$, the written type uses 29 folds and inference chooses 30. A separate exact check reads the exported constraints of the weighted examples, leaves every parent witness arbitrary, and instantiates the child's tight witnesses. Z3 proves closure over the entire parent domain in the original and affinely reindexed examples. It finds a counterexample when a field expands $u$ tenfold. OCaml checks that each caller still points to the original node. A partially annotated caller can acquire a stronger precondition when its requested family is too broad. The ground negative control requires a definite outside point. [Source and checks](thesis-review-61.py) · [InvarGenT implementation](https://github.com/lukstafi/invargent/commit/a92a630d1aab58f361fb221ac938224da1fd90e1) · [Partial annotations in the thesis](thesis-review-11.html)

The numeric synthesis routine also finds a common type for two reflections by trying their product. End-to-end unannotated inference on that source and on a two-field affine reindexing each reached a 90-second diagnostic cutoff at default settings. On the reindexed source, instrumentation placed the delay in ordinary inference before the folded proposal. Setting only `-term_abduction_timeout 1` lets both examples reach the proposal and infer their types. The replay checks both original fields against each exported scheme, including both heap pointers. The compiler first tries to preserve a successful existing type. Reaching the folded proposal promptly by default while retaining that coverage remains open.

The large coefficients exposed an independent error before the rational solver. With $M$ the machine's largest positive integer, `Num (M i + M i)` could parse as `Num (-2 i)`. At $i=1$ the old compiler consequently accepted a result annotated `Num (-2)`. Arithmetic on large source coefficients now uses exact fractions, with an unevaluated sum available when its coefficient exceeds the literal range. The erroneous call fails and the same declaration still works at $i=0$. A closed example reproduces the bug using just two datatypes. A constructor from $\mathrm{Input}(i)$ to $\mathrm{Output}(Mi+Mi)$ previously admitted $\mathrm{Output}(-2)$ at $i=1$. InvarGenT can retain the original sum in the constructor guard when a normalized coefficient would exceed the source range. The constructor still gives $\mathrm{Output}(0)$ at $i=0$. The smallest signed literal keeps its sign, a second negation outside the range gets a source diagnostic, and a zero denominator is rejected at its location. [Constructor normalization](https://github.com/lukstafi/invargent/commit/50b2a4e9ee7863cc13af031498ab799a2328d119) · [Exact source arithmetic](https://github.com/lukstafi/invargent/commit/319abd0414e502993f5332bb68400014cb36a21f)

The native replay passed on OCaml 5.3 and 5.5.1 compatibility builds. The full 5.3 suite passed all 410 active tests, with ten existing TODOs. All 208 previously generated signatures matched byte for byte.

A differential replay removes individual rows, changes signs and weights, reuses private names, and adds inconsistent bounds. It eliminates the private coordinates independently and asks Z3 about the resulting public polyhedron. The native checker agreed on all 416 cases, including 36 inductive schemes. [Projection oracle and OCaml driver](thesis-review-61-oracle.py)

With Python and `z3-solver`, run the following next to the preceding review's source generator.

```sh
python3 thesis-review-61.py --compiler /path/to/InvarGenT.native
python3 thesis-review-61.py --source
```
