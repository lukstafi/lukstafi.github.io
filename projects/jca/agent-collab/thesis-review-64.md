---
title: "When does one recursive typing cover every typable caller?"
date: 2026-11-23
---

A decision for each caller leaves two questions. Is there **one** polyhedral typing that covers every typable caller? If so, will unfolding the written guards actually reach it? For the isometric fields with scalar slack, we can decide the first question. When every field strictly expands positive slack, we can also decide the second. The answers can differ even for a two-inequality greatest type.

Two guards can also succeed together when each fails separately. Rotate $(x,y)$ by $(3/5,4/5)$, fix $z$, and double $t$. Each of the guards $x+z\le1+t$ and $y-z\le-1+t$, taken alone, has no greatest polyhedral typing. Their conjunction reaches its greatest typing after **five layers**, with two guards per layer. A Z3 check proves closure. InvarGenT checks the ten-row recursive type and rejects a caller violating only the last layer. [Executable example](thesis-review-64.py)

## From caller coverage to a cone of normals {#cone}

Take the strictly expanding system $f_e(p,t)=(M_e p,r_e t)$ in observable coordinates. Every $r_e>1$, every $M_e$ preserves a common positive form, and the written guards are $b_i p\le c_i+t$. We work over the rationals with closed polyhedral types. The earlier caller theorem gives a typing at every safe point with $t>0$. A safe point at $t=0$ is a limit of safe points with positive slack. Each negative-slack point eventually violates a guard. Hence a greatest polyhedral typing, if it exists, must equal the whole semantic safe domain. Conversely, a polyhedral safe domain that describes all words is itself inductive. In this argument rational safe points suffice. Taking $p=0$ and sufficiently large $t$ gives an interior point with uniform strict margin, because the unscaled guard normals have bounded length. Convex interpolation with this point and rational approximation give density. [Individual and family coverage](thesis-review-62.html#criterion)

Homogenize the intercept with $\lambda\ge0$. An augmented normal is $a_i=(b_i^T,-c_i)$, and a field acts on normals by $D_e=\operatorname{diag}(M_e^T,1)$. Include $d=(0,-1)$ for $\lambda\ge0$. The orbit normals impose
$$
(D_w a_i)\cdot(p,\lambda)\le r_w t,\qquad d\cdot(p,\lambda)\le0,
$$
where $r_w$ is the product of the field gains. Reversing a word when following transposes gives exactly the same set of all words and costs. For a nonempty safe domain its recession directions are exactly the homogeneous word constraints at $\lambda=0$. One direction follows by adding a feasible base point, the other by following a ray to infinity.

At $t=1$ the polar of the safe slice is
$$
D=\operatorname{conv}\big(\{0\}\cup\{D_w a_i/r_w\}_{i,w}\big)+\operatorname{cone}(d).
$$
The scaled orbit points tend uniformly to zero with word length. Their union with zero is compact, so its convex hull is compact and the displayed sum is closed. The polar description follows by separation. The entire homogeneous domain on $t\ge0$ is recovered from the unit slice by scaling and adjoining its recession directions.

Let $C$ be the closed positive cone of the **unscaled** orbit normals and $d$. If the safe domain is polyhedral, $D$ is a polyhedron, and its conic hull is polyhedral and closed. That hull is $C$. In the opposite direction, suppose finitely many *actual word normals* and $d$ generate $C$. Keep the scaled versions of those normals, zero and the ray through $d$. Their convex hull plus the ray contains $C$ in a sufficiently small neighbourhood of zero. Indeed the facets through zero define the tangent cone $C$, and the other facets have positive distance from zero in its span. Every sufficiently long scaled word normal is already inside. Adding the finitely many shorter words therefore gives the whole polar. [Single-guard polar argument on $t\ge1$](thesis-review-60.html#fields)

## A finite test for all the guards together {#test}

Let $G$ be the compact closure of the word actions $D_w$. Write $F$ for its fixed space. For every initial normal $a$, including $d$, let $f_a$ be its orthogonal projection onto $F$ in an invariant metric on normals. Form the finite cone $C_F=\operatorname{cone}\{f_a\}$, and let $J=C_F\cap(-C_F)$ be its lineality, the subspace in which both directions belong to the cone. Finally form
$$
W=\operatorname{span}\{D_w a : f_a\in J\}.
$$

**Criterion.** A greatest polyhedral typing exists exactly when every initial normal has a **finite orbit modulo $W$**. In that case finitely many actual word guards, together with $t\ge0$, describe it. All spaces and tests are rational. The moving complement of $F$ is the sum of the images of $D_e-I$, so the fixed projection can be found by linear equations. Membership in $J$ needs only conic feasibility, and finite orbit on the quotient is decidable by modular reduction. [Rational implementation](thesis-review-64.py) · [Finite-orbit test](thesis-review-62.html#finite)

To prove the criterion, first compute the lineality of $C$. For each $a$, the closed convex hull of its orbit has $f_a$ in its relative interior. Its fixed component is constant, and the centroid of its moving orbit hull is zero. In particular $f_a$ is a convex combination of finitely many actual word images. To see why closure causes no problem, take a small cross-polytope about $f_a$ inside its relative affine hull and approximate its vertices by convex combinations of actual orbit points, within less than its inradius. In dimension zero the orbit is a singleton. The projections and word images are rational, so feasibility of the finite convex combination also gives rational coefficients.

For $f_a\in J$, its negative is a conic combination of the fixed projections. We just saw how to realize those projections using actual normals. Thus the cone of actual normals also contains $D_w a-f_a$ for every $w$. These differences positively span the moving part of that orbit, since zero is in the relative interior of their convex hull. Together with $\pm f_a$ they generate the whole orbit span in both signs. It follows that finitely many actual normals and $d$ already generate $W$ as a cone.

To prove the reverse inclusion, choose a fixed linear functional that vanishes on $J$ and is strictly positive on the remaining finitely many $f_a$. Such a functional exists on the pointed finite cone $C_F/J$. Its value on every image of $a$ equals its value on $f_a$. If a sequence of conic combinations converges to a point with functional value zero, the total weight on each remaining orbit must tend to zero. The unscaled orbit vectors are bounded, so their contribution disappears. The limit belongs to $W$. If there are no remaining normals, the preceding construction already gives $C=W$. Thus $W$ is exactly the lineality, and $C/W$ is pointed.

If $C$ is polyhedral, the compact group on this pointed quotient permutes finitely many extreme rays. Normalize each ray to unit length in the quotient metric. The resulting finite set spans the cone's linear span, so the action on that span is finite. Conversely, when every initial normal has finite orbit modulo $W$, choose one actual representative for each projected image. Together with the finite generators for $W$, these generate every actual normal, and their cone is closed. The polar argument supplies a finite word horizon. In the positive case one can synthesize the type by unfolding until a whole new layer follows from its predecessors and $t\ge0$.

A strictly positive written floor $t\ge\tau>0$ changes the test in a simple way. It adds the normal $(0,\tau)$, while $d=(0,-1)$ is already present. The entire intercept axis is now lineality, so the existence of a greatest typing depends only on the measured normals and the fields. For one dense plane rotation, $x\le1+t$ has a greatest type on $t\ge1$ and lacks one on $t\ge0$. At zero slack its semantic disk contains points with infinite observable orbit. [Earlier positive-floor criterion](thesis-review-60.html#criterion)

## Does the iteration itself derive the sign? {#unfolding}

The constructor need not state $t\ge0$. With that row omitted initially, **raw guard unfolding stabilizes exactly when the criterion above succeeds and at least one written guard has $f_{a_i}\in J$**. The second condition concerns an actual written guard, so $d$ alone does not count.

Indeed finite word guards entail $t\ge0$ exactly when some nonzero nonnegative combination of their measured normals vanishes and the same combination of their intercepts is nonpositive. This is Farkas' lemma applied to the finite, feasible system. The coefficient on $t$ is then strictly negative, since every gain is positive. In homogeneous notation the condition is a positive dependence among actual augmented normals and $d$, with at least one actual guard assigned positive weight. Projecting that dependence to $F$ forces the relevant fixed projection into $J$. Conversely any such guard belongs to $W$, and its negative has a finite conic expression from actual normals and $d$. This gives the required dependence. Once a finite prefix proves the sign, the finite word description from the criterion closes the iteration. If a prefix is already inductive, it implies every word guard and hence the sign.

For example, let $x$ stay fixed, double $t$, and require $x\le1+t$. The greatest type is exactly $t\ge0$ and $x\le1+t$. No finite prefix produces it from the written guard. At $x=0$, take $t=-2^{-(N+1)}$. Every word through length $N$ passes and a later word fails. An induction jump can insert the necessary sign immediately. Lean checks the finite positive-dependence implication and a negative-slack counterexample for every finite prefix of this example. The replay realizes all four combinations of the two tests. This is exact public unfolding for the specified field updates. Table 4.4 also makes choices of abduction and generalization that can change the sequence of predicates. [Lean sign and nonconvergence lemmas](thesis-review-64.lean) · [Bounded solutions and the feedback loop](thesis-review-2.html#convergence)

## The five-layer example and the signed extension {#example}

In the opening example the two fixed projections, in coordinates $(z,\lambda)$, are $(1,-1)$ and $(-1,1)$. Together they generate a line. Both guards consequently enter $W$, including their moving directions. Either guard alone leaves an infinite orbit in the pointed quotient. For the pair, coverage at zero slack reduces to $(x,y,z)=(0,0,1)$. Four layers are insufficient. At $(-11,-5,-5,1)$ the guards through depth three hold. At depth four the second guard requires $9456/625\le15$. InvarGenT checks the recursive scheme containing depths zero through four. With the recursive annotation removed and the same ten rows requested through a later alias, ordinary inference supplies a stronger six-inequality type. Both the binding and the alias exclude $(1,-1,1,1)$, which the written greatest scheme admits. This gives a concrete target for passing an exact unfolding certificate to the induction jump. Z3 verifies that those rows imply nonnegative slack as well as the next layer. A separate replay compares 45 two-guard systems with literal unfolding through sixteen layers. Twenty-nine reach closure with the sign available, and twenty-nine derive the sign. [Independent unfolding and native replay](thesis-review-64.py)

For nonnegative gains with both neutral and expanding fields, decide greatest-type existence **after** restricting to the largest admissible subspace and saturating the neutral group. If a greatest reduced typing exists, closing its finitely many neutral translates produces an original typing containing it. This closure also satisfies the reduced problem, so greatestness forces equality. Conversely a greatest original typing contains every reduced one because each reduced typing has such a closure. In the remaining signed or contracting cases the finite-domain construction already computes the whole greatest polyhedral domain. The empty domain represents the case with no typable caller. The raw sign test above uses strictly expanding fields. [Neutral reduction and signed domains](thesis-review-63.html#neutral)

```sh
python3 thesis-review-64.py
python3 thesis-review-64.py --compiler /path/to/InvarGenT.native
```
