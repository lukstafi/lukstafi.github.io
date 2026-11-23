---
title: "Which whole caller families have a polyhedral recursive typing?"
date: 2026-11-23
---

A caller with **zero slack** can satisfy every recursive guard and still have no polyhedral typing. Rotate $(1/4,0)$ through an angle of infinite order about the origin and require $x\le1$. The whole orbit stays strictly inside the unit disk. Any inductive polygon containing the caller would have to accommodate every rotation of its own vertices. In this example only the origin has a polyhedral typing at zero slack.

For several required recursive fields and any number of measured indices, the same obstruction has an exact linear description. The zero-slack values that have finite orbits in the coordinates visible to the guards form a computable **rational subspace**. Intersect that subspace with finitely many guards and one obtains the greatest polyhedrally typable zero-slack domain. This gives a decision for a *whole polyhedral family* of callers, including families with positive slack arbitrarily close to zero and unbounded families with zero-slack recession directions. [Earlier fixed-axis example](thesis-review-60.html#families)

## The caller test {#criterion}

Suppose the public indices are $(p,t)$ with $p\in\mathbb Q^d$. Each required field sends them to $(O_ep,r_et)$, where $r_e>1$ and every $O_e$ preserves the same positive-definite rational form $Q$. The guards are $a_i p\le c_i+t$ for finitely many rational rows $a_i$ and constants $c_i$. Both the field list and the guard list are nonempty. A strictly positive coefficient of slack in a guard can be normalized to one. A typing is a closed rational polyhedron satisfying the guards, closed under **each** field, and covering the designated callers. This is an existence question about the invariant that can supply a Table 4.4 postcondition. The table's iteration still has its own convergence question. [Table 4.4 and bounded solutions](thesis-review-2.html#convergence) · [Fijalkow and colleagues on the general affine invariant problem](https://arxiv.org/abs/1907.08257)

Compute a basis $B$ of the row span of all $a_iO_w$, where $w$ ranges over field words, including the empty word. Closing a row basis under the finitely many generators gives this span after at most $d$ independent rows. Set $y=Bp$, write each guard as $b_i y\le c_i+t$, and define $M_e$ by $BO_e=M_e B$. Thus every guard at every descendant depends only on $y$ and $t$. Projecting a typing onto these coordinates preserves inductiveness, and taking its inverse image supplies a typing in the original coordinates. The quotient metric is $P=(BQ^{-1}B^T)^{-1}$, since $M_e$ preserves the inverse form $BQ^{-1}B^T$ on rows. With zero observable dimensions all guard evaluations simply omit $y$.

Write a nonempty caller polyhedron as a convex hull of rational points plus a cone of rational recession generators. Include both signs for each lineality direction. Map each generator to $(y,t,\lambda)$ with $\lambda=1$ for a point and $\lambda=0$ for a direction. The homogeneous guard is $b_i y\le c_i\lambda+t$.

**Theorem.** One polyhedral typing covers the caller exactly when every generator passes the following test.

| Slack of generator | Test |
|---|---|
| $t<0$ | Reject. Repeating any field sends the slack to $-\infty$, while the measured part stays bounded. |
| $t=0$ | The orbit of $y$ under the $M_e$ must be finite. Every image $v$ in that orbit must satisfy $b_i v\le c_i\lambda$ for all guards. |
| $t>0$ | Check the actual guards through a finite prefix of field words. Stop before depth $N$ once $c_i\lambda+r_{\min}^N t\ge\lVert b_i\rVert_{P^{-1}}\lVert y\rVert_P$ for every guard, where $r_{\min}=\min_e r_e$. |

The last test terminates even for a negative intercept. The left side eventually becomes positive and grows without bound. Every word of length at least $N$ satisfies every guard by Cauchy–Schwarz. Squaring after the sign check keeps the computation rational. A failed guard on a recession direction gives actual failing callers sufficiently far along that direction.

The theorem also covers a finite union of caller polyhedra and finitely many private rational linear indices in the typing. Project private indices first. For an inductive finite union, take the closed convex hull of its public cells. This is rational polyhedral, the closed convex guards contain it, and each continuous affine field preserves it. Thus these representations give the same existence test. [Projection and disjunctive typings](thesis-review-58.html)

## Why a finite orbit is necessary {#necessity}

Homogenize an alleged typing. For a nonempty polyhedron $Ay+bt\le d$, its closed homogenization is $Ay+bt\le d\lambda$, $\lambda\ge0$. At $\lambda=0$ this includes its entire recession cone. It contains every lifted caller generator and is preserved by $(y,t,\lambda)\mapsto(M_e y,r_e t,\lambda)$. Rational polyhedra have dense rational points, so we can work with their real realizations.

Let $G$ be the closure of the positive products of the $M_e$, including the identity. It is a compact group of isometries. Positive powers of each generator approach the identity along a subsequence, so its inverse lies in the closure. On the slice $t=0$ with $\lambda$ fixed, all of $G$ therefore preserves the homogenized typing onto itself. Fix also the component $f$ of $y$ that is fixed by all of $G$, using the orthogonal projection in the metric $P$.

The remaining, moving coordinates in this slice are bounded. To see this, identify each guard normal with a vector using the metric. Subtract its fixed part and take the closed convex hull of its $G$-orbit. The centroid in its affine hull is fixed by $G$ and orthogonal to every fixed vector. Hence it is zero. The centroid belongs to the relative interior, so the hull contains a ball about zero in its span. Together these moving spans fill the orthogonal complement of the fixed space, by the construction of $B$. The convex hull of their union thus contains a ball in the whole moving space. Each orbit normal has an upper bound on its pairing with the moving coordinates, given by $c_i\lambda-b_i f$. The ball gives a common bound on their length.

The slice containing the generator is consequently a nonempty bounded polyhedron. Each $g\in G$ permutes its finitely many vertices. An action on the vertices determines the action throughout their convex hull. Every point of this slice has a finite orbit. This also explains why an unobservable infinite orbit is harmless. A guard on a fixed coordinate alone leaves a rotating plane entirely free. [Centroid argument for a guard orbit](thesis-review-60.html#criterion)

## A single rational typing suffices {#sufficiency}

Choose rational $b>0$ with $b\lVert b_i\rVert_1\le1/2$ for every guard and put $c_-=\max(0,\max_i(-c_i))$. The rational cone
$$
D=\{\lambda\ge0,\quad t\ge 2c_-\lambda,\quad \lVert y\rVert_\infty\le bt\}
$$
satisfies all guards. The products $M_w$ have a common bound $K$ on their infinity operator norms, by their common metric. For instance one can take any rational $K\ge1$ whose square is at least $(\max_i(P^{-1})_{ii})\sum_{ij}|P_{ij}|$ in positive dimension. Choose $m\ge1$ with $r_{\min}^m\ge K$. Every length-$m$ word maps $D$ into $D$. The intersection $S$ of the inverse images of $D$ under the words of length less than $m$ is therefore one-step inductive.

Use all the images of the passing zero-slack generators. There are finitely many. For each positive-slack generator, every sufficiently long word sends it into $D$, since its measured length remains bounded. Take a single $N\ge1$ large enough for all of them. Every word of length $N$ already sends its generator into $S$, since all further images lie in $D$ as well.

Form the conic hull of $S$, the finite zero-slack orbits, and all positive-slack images at depths less than $N$. This is a finitely generated rational cone. Every generator satisfies every homogeneous guard. Every successor either belongs to the same finite sets or has reached $S$. Linearity then proves inductiveness on the entire cone. Its section at $\lambda=1$ gives one conjunctive typing, with witnesses compatible across every point and ray of the caller. Lean checks the conic closure and the finite-prefix step in this proof. [Lean lemmas](thesis-review-62.lean)

### Compatible field witnesses in generator coordinates {#witnesses}

The construction can emit a certificate without projecting out the private indices. Put $H=\max(1,2c_-)$ and choose $b=1/(2K\max(1,\max_i\lVert b_i\rVert_1))$. The inner box $\lVert y\rVert_\infty\le bt$, $t\ge H\lambda$, $\lambda\ge0$, has explicit generators. At $t=1$ take every corner $y\in\{-b,b\}^k$ with $\lambda=0$ and with $\lambda=1/H$. Every word image of this box satisfies the guards, since the transient growth of $y$ is at most $K$ and the slack never decreases. Every length-$m$ word takes the box into itself. Thus one may use the cone of the images of its corners under words of length less than $m$ as the seed. Add the same finite zero orbits and positive paths until they enter the box.

Write $V$ for the matrix of the resulting generator columns. The private indices are the nonnegative weights $z$ in $Vz=(y,t,1)$. For each field's homogeneous matrix $F_e$, open each column of $F_eV$ in the cone of $V$. The chosen coefficients give a rational nonnegative matrix $A_e$ with $F_e V=V A_e$. A parent opening $z$ supplies the child opening $A_e z$, for *every* parent opening and all siblings. Caller generators get coefficients in exactly the same way, including the recession generators with final coordinate zero.

This last argument works for **any** rational polyhedral invariant under deterministic affine fields, using its homogenized generators. It gives a uniform linear child-witness policy in the extended coordinates. Listing the generators can be expensive. A compact folded type may need many distinct affine choices when asked to open its private indices from the public point alone. The replay constructs a 131-column generator lift for a three-dimensional measurement with two required fields and checks every rational coefficient equation, including a nonzero zero-slack caller. [Generator certificate](thesis-review-62.py) · [Size of witness policies](thesis-review-59.html#policies)

**Opening at the caller is a different witness problem.** If a homogeneous caller generator $u_j$ designates the public state $D u_j$, a single affine opening from the caller parameters exists precisely when there is a matrix $T$ with $T u_j\ge0$ and $V T u_j=D u_j$ for every $j$. These are rational linear constraints on the entries of $T$. They cover unbounded callers by including their recession generators. Individual openings at the generators suffice for pointwise coverage. They need not give a single $T$.

For a bounded polytope in its own vertex lift, such a global affine opening exists exactly when the polytope is a simplex in its affine hull. At each vertex the weights must be its corresponding unit vector. An affine map can send all the vertices to these affinely independent vectors only if the original vertices are affinely independent. Conversely a simplex has affine barycentric coordinates. On the unit square, take weights $z_{00},z_{01},z_{10},z_{11}$. Choosing $z_{11}=\min(i,j)$ and solving the three affine equations supplies an opening on the full square in two pieces. The recursive quarter turn and the field that replaces both coordinates by their average still have one *linear* weight update each. InvarGenT checks this four-weight written type and a caller ranging over the entire square. An independent linear query finds a policy on each triangle and proves the single-policy query infeasible on their union. [Caller and native checks](thesis-review-62.py)

## Computing the whole zero-slack domain {#finite}

There is a finite computation even when the group on the observable space is infinite. Choose an odd prime $\ell$ coprime to the denominators of the entries of all $M_e$ and $M_e^{-1}$. Their reductions generate a finite group in $\mathrm{GL}_k(\mathbb F_\ell)$, where $k$ is the observable dimension. Traverse this finite graph once. For each residue $s$ keep one actual word matrix $g_s$, starting with $g_I=I$. For every edge $s\xrightarrow{e}s'$ impose the linear equations
$$
(M_e g_s-g_{s'})y=0.
$$
Call their common kernel $L$. If $y\in L$, induction on word length gives exactly the finite set of images $g_s y$.

Conversely, suppose $y$ has finite orbit. Its rational linear span $W$ is invariant, and the group acts on $W$ by permuting a finite spanning set. The two matrices on each edge have the same reduction, so $h=g_{s'}^{-1}M_e g_s$ is congruent to the identity. Work over the rationals with denominators prime to $\ell$. Their coordinate lattice intersected with $W$ is a full lattice in $W$ over this local ring. If $(h-I)u$ is divisible by $\ell$ in the ambient lattice, dividing by $\ell$ keeps it in $W$. Thus the restriction of $h$ is still congruent to the identity in a basis of the smaller lattice.

The congruence kernel at an odd prime is torsion-free. Indeed, an element of prime order $q$ in it would have the form $I+\ell^j A$ with $j\ge1$ and $A$ nonzero modulo $\ell$. Expanding its $q$th power modulo $\ell^{j+1}$ forces $q=\ell$. Expanding again modulo $\ell^{j+2}$ leaves the nonzero term $\ell^{j+1}A$. The restriction of $h$ acts in a finite group, so it is the identity. In particular the edge equations hold on $y$. [Serre on Minkowski's lemma and finite matrix groups](https://arxiv.org/abs/1011.0346)

It follows that the whole typable face at zero slack is the rational polyhedron
$$
y\in L,\qquad b_i g_s y\le c_i\quad\text{for every }i,s.
$$
Use zero intercepts for the corresponding recession cone. The face itself is inductive. For a single generator the replay can instead restrict to its cyclic span and stop on the first collision of unequal rational matrices with the same reduction. The two implementations agree on 81 vectors in a mixed system with an infinite rotation, a sign change and a fixed coordinate. Two reflections of order two give a separate check. Their product has infinite order, and the common finite-orbit subspace is zero. [Exact rational algorithms](thesis-review-62.py)

## Recovering the geometry from affine fields {#frame}

The rates, metric, centre and measured coordinates need not be supplied. Given raw fields $x\mapsto A_e x+d_e$, a conjugacy of the required shape forces $r_e=|\det A_e|>1$. Solve the simultaneous equations $(I-A_e)x_0=d_e$ for a common centre. The shared expanding right and left eigenspaces for eigenvalues $r_e$ must each be one-dimensional and pair nontrivially. Indeed every eigenvalue in the isometric part has absolute value one. Choose a right generator $u$ and a left generator $s$. The kernel of $s$ is the measured plane, of codimension one in any dimension. A basis of this kernel followed by $u$ gives rational coordinates $(p,t)$ for $x-x_0$.

Orient $u$ so that every written guard normal has strictly negative pairing with it. Division by the negative of that pairing puts each guard in the required form. On the measured subspace solve the linear equations $O_e^TQO_e=Q$ on symmetric forms. Existence of a positive-definite solution is decidable over the reals. The solution space is rational and positive definiteness is open, so rational coefficients sufficiently close to a positive solution supply an exact rational metric. These checks are necessary and sufficient for the stated affine class. The replay recovers a frame for two translated fields with different rates and two nonparallel guards. It rejects a shear, incompatible centres, and opposite required slack signs. [Executable recognition test](thesis-review-62.py)

## What InvarGenT infers {#native}

For the field preserving $x^2+2y^2$ with slack gain $65/64$, the caller $(-51/25,0,1)$ previously required a written annotation. InvarGenT now infers **three actual word guards and four private folds**. The same type admits the whole ray $(-26s/25,0,1+s)$ for $s\ge0$. Its recession slope also exceeds $(65/64)^2$. Adding the inverse rotation with gain $2$ still needs only those three guards and the same folds. The compiler orders words by the product of their slack gains. It retains an early guard if earlier rows do not imply it. When every caller has enough radial headroom, a single folded bound pays for the unexamined frontier. The final checker replays the proposed type on every original field and caller. A separate ground caller passes the first two guards and fails the third. [Previous written certificate](thesis-review-61.html#prefix)

To measure headroom in source callers, the compiler projects their private indices, homogenizes the public constraints and takes the section $t+\lambda=1$. Its existing cone bound on both measured coordinates makes the section compact. A convex norm fits below an affine cap on the section exactly when it fits at every vertex. Vertices with $\lambda=0$ measure the recession directions. The four-fold type has ten private indices and 27 inequalities counting an equality twice. Z3 checks that the emitted inequalities admit every point of the ray and that each field can open the type from every allowed parent.

A different example has a public answer with no private indices. Take $H(x,y)=((x-3y)/2,(x+y)/2)$, a sixth turn for $x^2+3y^2$. Give $H$ slack gain $6/5$ and $H^{-1}$ gain $9$, with guard $x\le1+t$. Every orientation is reached by at most five forward turns. The cheapest way to reach the **inverse** orientation costs $(6/5)^5<9$. The greatest safe domain consists of $t\ge0$ and the six guards obtained by zero through five forward turns. At $(2,2,1)$ all words through length four pass. Five forward turns give $4>1+(6/5)^5$. The earlier compiler inferred the origin alone and rejected the safe zero-slack caller $(1,0,0)$. The new compiler infers all seven inequalities at default settings and rejects the late failure. Z3 proves that both the exported binding and its ordinary alias equal this exact domain. [Source and independent checks](thesis-review-62.py)

For a finite group of recovered planar isometries the compiler can make this proposal before ordinary abduction. At nonnegative slack the least gain at each guard orientation gives its strongest constraint. At negative slack the guard used to recover the frame eventually fails. Every retained row is therefore necessary, and the independent closure check establishes sufficiency. A finite planar rotation group is cyclic. Its generator has rational trace, which is an algebraic integer, so its order is one of $1,2,3,4,6$. Including reflections gives at most twelve orientations per original guard. The compiler uses this bound when exploring a candidate frame.

Two further affine reindexings have three guards, including a negative intercept and a guard independent of slack. The first uses three fields. The second uses two noncommuting reflections. Each native result equals an independent eleven-level unfolding with orientation costs minimized by word length. On the three-field program an ordinary unannotated alias previously reached a 60-second diagnostic cutoff after its source binding had already inferred the exact answer. A plain alias now reuses that checked scheme directly, including through subsequent aliases. [Compiler change](https://github.com/lukstafi/invargent/commit/48178c0a73ad51f3e7fca7ff122ecdb018f42256)

The general decision procedure is available in the replay. Native inference recovers selected planar frames and still has budgets for word search and source coefficients. The binary infinite-rotation replay uses `-term_abduction_timeout 1` to reach its folded proposal promptly. For a field that leaves slack unchanged, the finite-orbit restriction can apply even to strictly positive slack. InvarGenT now exploits this in the plane. [Arbitrary rational slack gains](thesis-review-63.html#signed) · [Exact neutral inference](thesis-review-63.html#compiler) · [Earlier scheduling behaviour](thesis-review-61.html#replay)

## Replay {#replay}

The final native build passed all 413 active tests on OCaml 5.3, with ten existing TODOs. All 209 previously generated signatures matched byte for byte. The new golden example has identical signature tokens on the 5.3 and 5.5.1 compatibility builds, with different line wrapping. On both builds OCaml also checked that the recursive fields and their callers point to the original nodes. The earlier 416-case differential check of folded schemes still agrees with independent projection. [Projection oracle](thesis-review-61-oracle.py)

Run the first command with Python 3.10 or later. The second also checks affine recognition and the actual compiler exports with `z3-solver`. The independent seven-inequality formula agrees with the decision on 200 point and ray examples, including zero and negative slack.

```sh
python3 thesis-review-62.py
python3 thesis-review-62.py --compiler /path/to/InvarGenT.native
```
