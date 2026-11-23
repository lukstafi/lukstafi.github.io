---
title: "How many private indices does a small recursive typing need?"
date: 2026-11-23
---

A cyclic value with three public rational indices and a single recursive field can require **exponentially many public facets** with the same ground use and the same guard on every instance. Exact unfolding of the public guard reaches its fixed point in exponentially many rounds. The same value and use have a conjunctive linear typing with **linearly many inequalities and private coordinates**. With polynomially many inequalities the minimum number of private coordinates is $\Theta(n/\log n)$ for this family of inputs of bit length $\Theta(n)$. Even the witness dimension matters when promising Table 4.4 a small solution. [Exact arithmetic replay](thesis-review-59.py) · [Earlier fixed-caller undecidability theorem](thesis-review-58.html#fixed)

## A slowly turning value {#source}

Write the indices as a point $p=(x,y)$ and a slack $t$. The constructor checks $x\le1+t$. Its only field has indices $(Rp,\lambda t)$. Bind `let rec probe = Spin probe` and ask for $\mathrm{Probe}(2,0,1)$ on every instance. For $n\ge2$ set
$$
 h=2^{-n},\qquad
 R=\frac1{1+h^2}\begin{pmatrix}1-h^2&-2h\\2h&1-h^2\end{pmatrix},
 \qquad\lambda=1+h^3/16 .
$$
Each rational coefficient takes $O(n)$ bits to write as a fraction of integers. All the programmes have the same single-node heap. The angle $\theta=2\arctan h$ lies between $h$ and $2h$. A walk of length $j$ reaches $(2R^j e,\lambda^j)$ for $e=(1,0)$. Its guard always holds. The folded scheme below gives a finite public certificate on each individual instance by projection. Here the rotation varies with the input. [Earlier chain of public typings](thesis-review-58.html#probe)

### Exponentially many vertices at the caller {#lower}

Suppose a closed convex rational polyhedron $P$ certifies this ground call. We can work over the reals. Rational points are dense in a rational polyhedron, the guard is closed, and the field map is continuous. Let $K=\lfloor 2\pi/\theta\rfloor$ and $t_0=\lambda^K$. Cut $P$ with $0\le t\le t_0$ and project the slab onto the plane, dividing the planar coordinates by two. The resulting polygon contains $R^j e$ for $0\le j\le K$. Every point $p$ of the polygon also satisfies
$$
 (R^j p)_x\le(1+\lambda^{2K})/2 \qquad (0\le j\le K).
$$
Indeed a point of the slab has a lift at some $t\le t_0$ and its next $j$ unfoldings remain in $P$. Put $\eta=(\lambda^{2K}-1)/2$. Since $K<7/h$, the inequality $1+u\le e^u$ gives $\lambda^{2K}\le\exp(7h^2/8)$. For $0\le u\le1/2$ we have $e^u\le1/(1-u)\le1+2u$. Thus $\eta\le7h^2/8<h^2$.

The normals of these half-spaces turn once around the circle with gaps at most $\theta$. Every projected point therefore has radius at most $(1+\eta)/\cos(\theta/2)=(1+\eta)\sqrt{1+h^2}$. This is less than $1/\cos\theta=(1+h^2)/(1-h^2)$ because $(1-h^2)^2(1+h^2)<1$. The slab is bounded. For each inner direction $u=R^j e$, the polygon must have a vertex $v$ with $u\cdot v\ge1$. The angle between such a vertex and $u$ is strictly less than $\theta$.

Take $j=0,2,\ldots,2^n$. These $2^{n-1}+1$ directions lie on an arc of length at most two radians. Two of them cannot use the same vertex. If $P$ has $F$ public facets, the slab has at most $F+2$ and, in dimension three, at most $2F$ vertices by Euler's formula. It is full dimensional: the first four orbit points in $(x,y,t)$ are affinely independent. Their augmented coordinate matrix is equivalent over $\mathbb C$ to a Vandermonde matrix at the four distinct numbers $1,\exp(i\theta),\exp(-i\theta),\lambda$. Projection cannot create more vertices. Thus **$F\ge2^{n-2}+1$**. The same support argument applied to the convex hull of a union also handles public Boolean combinations. With $m$ distinct affine tests in three dimensions, all bounded slab-cell vertices come from triples of the $m+2$ hyperplanes. Even these formulas need $2^{\Omega(n)}$ tests. For strict tests take the closures of the nonempty cells first. Linearity and continuity preserve the guard and recursive closure. [Rational checks of the angular gaps and distinct supports](thesis-review-59.py)

### Exact convergence of public guard unfolding {#rounds}

On the domain $t\ge1$ there is a matching **$\Theta(2^n)$ bound on the number of public facets and on the number of rounds of exact guard unfolding**. Begin with $P_0=\{t\ge1\}$ and put $P_{j+1}=\{t\ge1,\ x\le1+t,\ (Rp,\lambda t)\in P_j\}$. Thus $P_j$ asks for the first $j$ guards. Set $L=23\cdot2^n$. The first $K+1$ guard normals from the lower-bound proof already imply
$$
 \lVert p\rVert_2\le(1+\lambda^Kt)\sqrt{1+h^2}.
$$
We have $L-K\ge16/h$, so Bernoulli's inequality gives $\lambda^{L-K}\ge1+h^2$. For $u=\lambda^Kt\ge1$, the last radial bound is at most $(1+u)(1+h^2/2)\le1+u(1+h^2)\le1+\lambda^Lt$. Hence **every guard at depth $L$ or greater already follows**. The prefix $P_L$ gives exactly the safe domain with $t\ge1$, and has at most $L+1$ facets. Conversely, every prefix contains the caller. If $P_j=P_{j+1}$, it is itself a certificate with at most $j+1$ facets, so $j\ge2^{n-2}$. This is exponential stabilization of this particular preimage iteration despite the polynomial-size lifted solution below. It gives a round bound for a concrete constructor update. The general Table 4.4 feedback loop also changes the predicate through abduction and generalization.

There is an exact test for the first redundant guard using only the plane $t=1$. Write $v_i=(R^i)^T e/(1+\lambda^i)$. The guard at $j$ follows from its predecessors on that slice exactly when $v_j\in\operatorname{conv}(0,v_0,\ldots,v_{j-1})$. Indeed, at $t=1$ each predecessor says $v_i\cdot p\le1$, and separation gives the converse. Equivalently, nonnegative weights $w_i$ express the unit normal at $j$ as a sum of earlier unit normals with $\sum_i w_i(1+\lambda^i)\le1+\lambda^j$. The triangle inequality gives $\sum_i w_i\ge1$, whence $\sum_i w_i\lambda^i\le\lambda^j$. The same weights prove the guard on every $t\ge1$. This lets us stop at the *first* return to the planar convex hull and certify the complete public fixed point. The first redundant guard has index **51, 76, 151 and 201** at $n=2,3,4,5$, respectively, numbering the root guard zero. A vertex of the final polar hull corresponds to an indispensable guard at $t=1$, while the weights remove every other guard at all larger slacks. The four full public domains have 52, 77, 152 and 202 facets, respectively, including $t\ge1$. [Exact polar-hull replay](thesis-review-59.py)

## A typing with rational private witnesses {#lift}

At an opening the scheme may quantify additional coordinates used in its constraints. Projecting them away gives its admitted public tuples. A child may choose fresh private coordinates. We use the folded approximation of a Euclidean disk from the lifted second-order cone construction of Ben-Tal and Nemirovski. Kocuk gives rational versions using Pythagorean triples. Here dyadic half-angle parameters give rational coefficients and explicit witnesses, with the precision fixed by the growth of the slack. [Ben-Tal and Nemirovski, 2001](https://www2.isye.gatech.edu/~nemirovs/Mor-LorentzAppr_2001.pdf) · [Kocuk, §3](https://arxiv.org/pdf/1912.00256)

Set $a_j=2^{-j}$, $c_j=(1-a_j^2)/(1+a_j^2)$ and $s_j=2a_j/(1+a_j^2)$. First describe a region $U$ that can serve after one unfolding. Introduce private pairs $(X_j,Y_j)$ for $0\le j\le m$. The following is a conjunction of linear constraints. Each absolute value in a lower bound stands for two inequalities.
$$
\begin{aligned}
 X_0&\ge |x|,&Y_0&\ge |y|,\\
 X_j&=c_jX_{j-1}+s_jY_{j-1},&
 Y_j&\ge |c_jY_{j-1}-s_jX_{j-1}| &&(1\le j\le m),\\
 c_mY_m&\le s_m X_m,& X_m+a_mY_m&\le1+t,& t&\ge1 .
\end{aligned}
$$

**Every admitted point satisfies $\lVert p\rVert_2\le1+t$.** The private coordinates are nonnegative. The initial inequalities and each relaxed fold can only increase squared length, because $c_j^2+s_j^2=1$. The last wedge inequality implies $(1-a_m^2)Y_m\le2a_mX_m$. Multiplying by $Y_m$ gives $X_m^2+Y_m^2\le(X_m+a_mY_m)^2$. This proves the constructor guard for every opening.

**Every point with $(1+\delta)\lVert p\rVert_2\le1+t$ and $t\ge1$ has an opening**, where $\delta=4^{-m}/2$. Use equality in the absolute-value bounds. Each step rotates towards the horizontal axis and reflects the vertical component if necessary. After the first step the angle is at most $\theta_1=2\arctan(1/2)$, because $\theta_1\ge\pi/4$. Thereafter $\theta_{j-1}\le2\theta_j$ by concavity of $\arctan$ on the positive axis. Folding a point between angles zero and $\theta_{j-1}$ therefore leaves it between zero and $\theta_j$. The last wedge holds. The tight folds preserve length and Cauchy–Schwarz gives $X_m+a_mY_m\le\sqrt{1+a_m^2}\lVert p\rVert_2\le(1+\delta)\lVert p\rVert_2$. The witnesses use rational linear operations and absolute values, including at the next recursive field.

Choose $m=\lceil(3n+4)/2\rceil$. Then $2\delta\le\lambda-1$, so $(1+\delta)(1+t)\le1+\lambda t$ for every $t\ge1$. Rotation preserves length. Thus every point in $U$ maps to a point in $U$ with newly chosen tight witnesses.

The fixed caller sits exactly on the first guard. Use the scheme $P=\{(p,t):t\ge1,\ x\le1+t,\ (Rp,\lambda t)\in U\}$. Its child belongs to $U$, and $U\subseteq P$ by the preceding induction and guard proofs. At the start $\lVert R(2e)\rVert_2=2$ and $2(1+\delta)\le1+\lambda$, so the child admits a tight opening. Writing the folds on $Rp$ at the root needs $2m+2$ private coordinates and $4m+8$ inequalities, counting an equality as two and omitting the redundant $\lambda t\ge1$. The coefficient bit lengths sum to $O(n^2)$. At $n=20$ these counts are **66 private coordinates and 136 inequalities**, against a lower bound of **262,145 public facets**. The source and certificate bounds use the thesis's unbounded rational literals. [Arbitrary-depth rational witness and induction proofs in Lean](thesis-review-59.lean) · [Source scheme generator](thesis-review-59.py)

### A lower bound on the number of private coordinates {#dimension}

Suppose a conjunctive scheme uses $m'$ inequalities and $d$ private coordinates. Cut its extended polyhedron with the same two slab inequalities. Each vertex of the planar projection lifts to a distinct nonempty face: maximize a linear functional that exposes that vertex. This holds even if the fibre or the extended slab is unbounded. A face can be specified by at most $D=d+3$ independent tight rows relative to the affine hull. There are at most $2^{m'+2}$ faces and at most $\sum_{j=0}^{D}\binom{m'+2}{j}$ choices of independent rows. Equalities can be counted as two inequalities or absorbed into the affine hull. [Why the projection needs many vertices](#lower)

The first bound gives $m'=\Omega(n)$. If $m'$ is polynomial in $n$, the second gives $d=\Omega(n/\log n)$. If $m'=O(n)$, it gives $d=\Omega(n)$: when $D=o(n)$ the logarithm of the binomial sum is at most $O(D\log(en/D))=o(n)$. The lifted scheme therefore attains the asymptotically optimal counts when the number of inequalities is linear.

The $\Omega(n/\log n)$ bound for polynomially many inequalities is also attainable. Keep private coordinates only at the ends of blocks of $b=\lceil\log_2 n\rceil$ consecutive folds and eliminate all the intermediate pairs within each block. Each block has $O(b)$ inequalities, so the projection describing the relation between its two endpoints has at most $2^{O(b)}$ facets. Its coefficients still have polynomial bit length. After clearing row denominators, Farkas elimination uses extreme nonnegative row combinations cancelling the discarded columns. These can be chosen from determinants of order $O(b)$ of entries of $O(n)$ bits. The projected blocks fit together exactly because neighbouring blocks share only their endpoint pairs. This gives $O(n/\log n)$ private coordinates and polynomial total size.

More generally, write $M_n(d)$ for the least number of inequalities in a certificate with at most $d$ private coordinates. For $0\le d\le n$ the trade-off is
$$
 \log_2\!\left(1+\frac{M_n(d)}{d+1}\right)=\Theta\!\left(\frac{n}{d+1}\right).
$$
For the upper bound use $\lfloor d/2\rfloor+1$ blocks of nearly equal size, keeping just the two coordinates at each internal boundary. The first block absorbs the initial absolute values and the last absorbs the final wedge. Each block projects to at most $2^{O(1+n/(d+1))}$ inequalities on its public variables and retained endpoints. For the converse put $B=M_n(d)+2$ and $D=d+3$. When $D\le B$, the binomial sum above is at most $(e B/D)^D$. Together with the $2^{n-1}+1$ exposed vertices this gives the stated lower bound. When $D>B$, the bound $B\ge n-1$ already suffices since $d\le n$. In particular, **every fixed private dimension costs exponentially many inequalities**, while a linear inequality budget forces linear private dimension.

### How many affine witness choices does one ground orbit need? {#policies}

Fix any conjunctive certificate with $M\ge2$ inequalities. Suppose an opening chooses from $k$ assignments of the form $z=L_i q+b_i$, where $q=(x,y,t)$ is the public tuple and $z$ contains all private indices. Even if we ask for witnesses only on the first $2^n+1$ points of the fixed caller's orbit, we need
$$
 k\ \ge\ \left\lceil\frac{2^{n-1}+1}{2M}\right\rceil .
$$

To see this, substitute each assignment in the certificate. The public tuples for which it succeeds form a polyhedron with at most $M$ inequalities inside the certified domain. Clip each of these polyhedra to the slab from the lower-bound proof. A three-dimensional cell has at most $2M$ vertices by Euler's formula. A two-dimensional cell has at most $M+2\le 2M$ vertices, and a segment or a point has at most two. The projected convex hull of the resulting cells lies inside the same outer radius and contains the selected orbit points. Its $2^{n-1}+1$ required vertices must come from the clipped cells. This proves the bound. If the witness assignment for a recursive call reads the *parent's public* tuple, the inverse of the affine field map expresses that tuple in the child's coordinates. Taking the odd orbit points $1,3,\ldots,2^n+1$ gives the same bound for recursive calls alone.

At $n=20$, any 136-row certificate needs **at least 1,928 affine witness choices**. A circuit that computes witnesses with affine operations and $s$ binary choices, including absolute values, has at most $2^s$ affine cases. Thus $s\ge n-O(\log M)$ even along this one walk. The tight folds attain $O(n)$ such operations. They open the fixed caller and every child of an arbitrary admitted parent, using fresh witnesses at the child. The small certificate comes with a small *composed* witness computation. Expanding the computation into a list of affine substitutions can cost exponentially more. This matters when applying the compatibility and coverage conditions in the repair to Theorem 4.5. [Rigid interfaces and chosen discharged witnesses](thesis-review-2.html#combination) · [Fold construction](#lift)

For comparison, an exponential list always suffices on the whole domain of a rational conjunctive lift with $M$ rows and $d$ private coordinates. In each nonempty fibre add $-w\le z_j\le w$ and $w\ge0$, and minimize $w$. The optimal face is nonempty and bounded, so it contains a vertex. At that vertex, $d+1$ independent tight rows determine $(z,w)$ as an affine function of the public tuple. Enumerating the row subsets gives at most $2^{M+2d+1}$ choices. In particular, for linearly many rows and private coordinates the worst-case list size on this family is $2^{\Theta(n)}$.

### Discovering a public measurement {#measurement}

The two public inequalities $x^2+y^2\le4$ and $t\ge1$ suffice if the index language can express squared radius. They admit the fixed caller, imply the guard, and survive the recursive field. The constructor itself determines which quadratic to try, even after an arbitrary invertible rational affine change of the three public coordinates.

Append a constant coordinate and let $A$ be the resulting four-by-four field matrix. Solve $A^T H A=H$ for a symmetric matrix $H$. The equations are rational and linear in its ten unknown entries. Over the complex numbers, the eigenvalues of $A$ are $e^{i\theta},e^{-i\theta},\lambda,1$. They are distinct, so the action on quadratic forms is diagonalizable with eigenvalues given by unordered products of two eigenvalues of $A$, allowing repetition. Exactly two products are one. The preserved forms are therefore the constants and multiples of squared radius, in any affine coordinate system. Choose a nonconstant solution and orient its quadratic part to be positive semidefinite. Its value at the caller supplies the upper bound, absorbing any additive constant.

The determinant of the three-by-three linear part gives $\lambda$. In homogeneous coordinates there is a unique line of affine forms satisfying $\ell A=\lambda\ell$. Normalize its generator to take value one at the fixed caller. This recovers $t$, and its lower bound is the second conjunct. Together the two computations recover the certificate for every rational affine conjugate of the family. This supplies the refined-datatype programme with a case where the datatype declaration determines a useful new measurement and the caller determines its bound. [Exact recovery on transformed inputs](thesis-review-59.py) · [Quadratic certificate and uniqueness of the planar measurement in Lean](thesis-review-59.lean) · [Companion programme on synthesizing datatypes](refined-datatypes/index.html)

## What InvarGenT infers from its callers {#compiler}

On the earlier rotation $(3/5,4/5)$ with $t'=2t$, the previous compiler inferred $p=0,\ t\ge0$ for the unannotated value. It rejected even $(1,0,1)$. The compiler now reads the written types of later aliases of the same binding, respecting shadowing. These types give the search a family of requested tuples. Every use still goes through the ordinary type checker against the one scheme published for the recursive binding.

For an affine guard $a\cdot p\le bt+c$ with $b>0$ and $c\ge0$, the square $\lVert p\rVert_\infty\le (b/\lVert a\rVert_1)t$ supplies a candidate. The solver tries the signed public coordinates as $t$, intersects the bounds from all guard rows, and checks each candidate against the actual fields. For an inductive seed $S$, put $P_0=S$ and $P_{j+1}=G\cap\bigcap_e f_e^{-1}(P_j)$, where $G$ is the constructor guard. Monotonicity and $S\subseteq P_1$ make this an increasing family of inductive polyhedra. Every candidate published by the compiler is rechecked against all original fields. It retains the previous type's admitted tuples through the existing inclusion and join checks. [Earlier witness and join proof](thesis-review-58.html#witnesses)

An identity field would make every update stop at $S$. For a convex inductive type the identity imposes no condition. The compiler removes it and any field lying in the convex hull of the identity and the other affine maps before unrolling. It checks convex membership with one set of nonnegative weights for the whole matrix and translation. If each retained field maps $P$ into $P$, a convex combination of their images and the parent also lies in $P$. The procedure removes one map at a time, so equivalent fields cannot all disappear without a justification. This changes which inductive types the iteration can reach.

The replay includes rotation in both directions, an identity field, a convex combination of a rotation and the identity, an unannotated alias and a symbolic caller family. On $\{(1,0,t):t\ge2^{-12}\}$ InvarGenT now infers one scheme covering the whole family. Re-eliminating the inferred constraints at a plain alias used to overflow on this case. The alias can reuse the original polymorphic scheme. Numerical search still has a configurable step budget, and exported coefficients must fit the native integer representation. An intermediate rational coefficient may be much larger. Internal containment checks retain the exact rational row. A contradiction can also be reported when the row explaining it exceeds the printable range. On the hard unannotated family the compiler now locates an oversized inferred answer at the source binding. On a written lifted scheme the checker can eliminate private equalities first, discard implied inequalities when eliminating a coordinate would produce too many pairs, and check containment on the remaining public space. To refute a row over a nonempty polyhedron, it looks for a point in the homogenized cone with violation at least one. This also catches violations along recession directions. At an explicitly typed alias it can substitute the requested public arguments before projecting private coordinates. [Native example](caller_cyclic_value.gadt) · [Caller oracle and generated OCaml replay](thesis-review-59.py)

## Replay {#replay}

```sh
python3 thesis-review-59.py --compiler /path/to/InvarGenT.native
python3 thesis-review-59.py --instance 20 --folded
python3 thesis-review-59.py --rounds 4
```

The exact checks use Python's rational arithmetic. A separate three-variable Z3 query confirmed both sides of the stabilization threshold at $n=2,3,4,5$. The native replay compares 48 accepted and rejected ground uses with the independent orbit procedure, checks five symbolic families through depth twelve, and checks written certificates with one through five folds. InvarGenT also accepts the five-fold $n=2$ member of the fixed-caller family, and OCaml verifies its back pointer. At $n=3$ the native checker reached a five-minute diagnostic limit on the seven-fold written scheme. Lean 4.19 checks the arbitrary-depth folded certificate at the source rotation and rate, as well as the shared finite-frontier argument for caller families. The facet counts and the geometric classification are proved in the text. [Written three-fold example](folded_cyclic_value.gadt) · [Lean proofs](thesis-review-59.lean)

Both research replays passed with the OCaml 5.3 and 5.5.1 compatibility builds. The full 5.3 suite passed all 404 active tests, with ten existing TODOs. All 206 previously generated signatures matched byte for byte. On 480 further lifted-polyhedron containment questions, Z3 and the native checker agreed on 59 positive and 421 negative answers. In a separate check with coefficients exceeding the source integer range, 80 entailments that previously raised an exception now returned their exact truth values. [Caller-directed synthesis and private opening checks](https://github.com/lukstafi/invargent/commit/b390f9622f956891408a2baed297e02178dbbd41) · [Internal rational arithmetic and source diagnostics](https://github.com/lukstafi/invargent/commit/0fb35c0b365da8c6b3ce69f9197f61f144f77dcd)

The same slice argument decides exact stabilization for any number of orthogonal fields with expanding slack. It also identifies a case where every safe ground call has a convex typing although their union has infinitely many facets. [Switched-field classification](thesis-review-60.html#criterion)
