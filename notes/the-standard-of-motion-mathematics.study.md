---
title: "Study notes: The Standard of Motion: The Mathematics"
essay: the-standard-of-motion-mathematics
track: physics-and-reality
reviewed-against: "71595bb"
requires:
  - {at: the-standard-of-motion, for: what the structures are for, strength: helpful}
introduces:
  - {term: principal bundle and parallelizable manifold, at: bundles-and-connections-in-brief}
  - {term: "connection, geodesic and curvature", at: bundles-and-connections-in-brief}
  - {term: canonical form and connection form, at: bundles-and-connections-in-brief}
  - {term: Newton–Cartan space-time, at: hellers-ladder-in-frame-bundle-terms}
  - {term: generator of a flow, at: one-bracket-three-mechanics}
  - {term: Hamiltonian vector field, at: one-bracket-three-mechanics, related: ["overdamped limit"]}
  - {term: Lie algebra and Lie bracket, at: kinematical-lie-algebras}
  - {term: Bargmann algebra, at: the-galilean-limit-and-the-mass}
  - {term: Carroll algebra, at: the-family-of-contractions}
  - {term: rigid Lie algebra, at: stability, gloss: "one whose every small deformation is a change of basis: its second cohomology with coefficients in itself vanishes"}
  - {term: Morse–Smale flow, at: stability, related: ["Polyak–Łojasiewicz condition"]}
  - {term: gap test, at: moving-patterns-in-a-cellular-automaton, gloss: "neighboring speeds must be realized by nearly the same pattern, at the scale an observer resolves", related: ["hypergraph rewriting"]}
  - {term: Bombelli–Henson–Sorkin theorem, at: the-bombellihensonsorkin-theorem, related: ["causal graph"]}
uses:
  - {term: standard of motion, from: the-standard-of-motion}
  - {term: frame bundle and teleparallelism, from: the-standard-of-motion}
  - {term: Poisson bracket and Hamiltonian, from: the-standard-of-motion}
  - {term: "Liouville's theorem", from: the-standard-of-motion}
  - {term: kinematical algebra, from: the-standard-of-motion}
  - {term: contraction and deformation, from: the-standard-of-motion}
  - {term: mass as a central extension, from: the-standard-of-motion}
  - {term: stable algebra, from: the-standard-of-motion}
  - {term: structural stability, from: the-standard-of-motion}
see-also:
  - {term: Lagrange multiplier as a price, at: how-does-a-policy-improve#improving-a-distribution-without-throwing-away-the-prior}
---

These questions cover the spine of the page: the geometry of a first law, the bracket, the algebras of free motion and their stability, and two results about discrete substrates.

### Parallelizable or not {kind=case at=bundles-and-connections-in-brief}

Define a principal $G$-bundle and a parallelizable manifold. Why does a global section of a principal bundle make it a product? Decide for the torus, the sphere $S^2$ and the three-sphere $S^3$.

::: answer
In a principal $G$-bundle a group $G$ acts on every fiber, and any two points of one fiber differ by exactly one element of $G$. A frame bundle is the example. Given a global section, every frame is the chosen frame times a unique group element, so $F(X)\cong X\times G$. A manifold is parallelizable if its frame bundle has a global section: $n$ vector fields that form a basis at every point.

- The torus is. The two directions of the square's sides survive the gluing.
- $S^2$ is not. The first vector of a global frame would be a continuous vector field with no zeros, which the hairy ball theorem rules out. By Poincaré–Hopf a compact surface has such a field only if its Euler characteristic is zero, and the sphere's is $2$.
- $S^3$ is. It is the group of unit quaternions, and a frame at the identity, multiplied by each group element, spreads over the whole space.
:::

### The first law as a geodesic {kind=state at=bundles-and-connections-in-brief}

Write the geodesic equation and say why it is the first law in geometric form. What is curvature? When does a connection give teleparallelism, and what can free fall not remove?

::: answer
$\ddot x^\nu+\Gamma^\nu_{\mu\lambda}\,\dot x^\mu\dot x^\lambda=0$: a geodesic is a curve whose own velocity is parallel along it. A connection on space-time thus picks out the curves that need no force, so it is Heller's standard of motion as a piece of geometry. Curvature is the rotation of a vector carried around a small closed loop, per unit of enclosed area. If the curvature vanishes and the space has no holes, transport is independent of the path, and one frame carried everywhere is a global parallel frame. That is teleparallelism, the sense of "product" in Section 1. A freely falling frame can make $\Gamma=0$ at one point, but the curvature remains, as the tidal convergence of nearby free-fall paths.
:::

### The product two levels up {kind=derive at=hellers-ladder-in-frame-bundle-terms}

The frame bundle of a curved space-time has no parallel product structure. Show that its own frame bundle is nevertheless a product, and count the forms for $n=4$. Why does the argument cover Newton–Cartan space-time and fail for a general principal bundle?

::: answer
On the bundle of linear frames $P=F(X)$ the canonical form $\theta$ expresses the displacement of the base point in the frame itself, with values in $\mathbb R^n$. The connection form $\omega$ measures the departure from parallel transport, with values in $\mathfrak{gl}(n)$. Together they give $n+n^2=\dim P$ linearly independent one-forms at every point, a global coframe; for $n=4$ that is $4+16=20$. A global coframe makes the frame bundle of $P$ trivial, so $F(F(M))\cong F(M)\times G'$. The argument uses only the connection, so it holds for Newton–Cartan space-time, where free fall follows the geodesics of a curved connection. A general principal bundle has no canonical form.
:::

### The bracket is the time derivative {kind=derive at=one-bracket-three-mechanics}

From Hamilton's equations, show that $\dot f=\{f,H\}$ for an observable $f(x,p)$. Recover Newton's second law for $H=p^2/2m+V(x)$. What changes if $f$ depends on time explicitly?

::: answer
By the chain rule $\dot f=\frac{\partial f}{\partial x_i}\dot x_i+\frac{\partial f}{\partial p_i}\dot p_i$. Substituting $\dot x_i=\partial H/\partial p_i$ and $\dot p_i=-\partial H/\partial x_i$ gives $\{f,H\}$. For the particle the equations read $\dot x=p/m$ and $\dot p=-\nabla V$, which together are Newton's second law. A function with $\{f,H\}=0$ is conserved. With explicit time dependence, $\dot f=\partial f/\partial t+\{f,H\}$, and $f$ is conserved when the two terms cancel. $H$ itself is conserved when it does not depend on time explicitly.
:::

### Swirl and spread {kind=derive at=one-bracket-three-mechanics}

Compute the divergence of the Hamiltonian vector field $X_H=(\partial H/\partial p,\ -\partial H/\partial x)$ and state what follows. Then compute the divergence of the damped oscillator $(\dot x,\dot p)=(p,\ -x-\varepsilon p)$. Which part of that field is responsible?

::: answer
The divergence is $\frac{\partial^2H}{\partial x\,\partial p}-\frac{\partial^2H}{\partial p\,\partial x}=0$, because mixed partial derivatives agree. The flow therefore preserves phase-space volume, which is Liouville's theorem, and $\int s(\rho_t)\,dx\,dp$ is constant for any function $s$. With $s(\rho)=-\rho\ln\rho$ that is the Gibbs–Shannon entropy. The damped oscillator has divergence $0+(-\varepsilon)=-\varepsilon$, so its flow contracts volume. The field splits into $(p,-x)$, the Hamiltonian field of $H=(x^2+p^2)/2$, and $(0,-\varepsilon p)$, a gradient slide in the momentum direction. All of the divergence comes from the second part: Newton's flow swirls and never compresses, and Aristotle's spreads or compresses and never swirls.
:::

### What a Lie bracket records {kind=explain at=kinematical-lie-algebras}

What does the Lie bracket of two generators generate? Give the example of rotations. What is left over when a boost and a time translation are applied in the two orders, and which bracket records it?

::: answer
Apply two small motions, then undo the first, then undo the second. The result is not the identity but a motion of second order in the small parameters, and the bracket $[A,B]$ is its generator. For small turns about $x$ and $y$ the leftover is a turn about $z$: $[J_x,J_y]=J_z$. A Lie algebra is the vector space of generators with this bracket, which is bilinear, antisymmetric and satisfies the Jacobi identity. Boost a body by $v$ and then let time run for $t$, or do the two in the other order: the results differ by a displacement $vt$. The leftover is a spatial translation, so the Galilean bracket of a boost with the Hamiltonian is a momentum, $\{K_i,H\}=p_i$.
:::

### The Poincaré brackets of a free particle {kind=derive at=the-free-particle-as-a-realization}

Take $H=\sqrt{p^2c^2+m^2c^4}$ and $K_i=(H/c^2)\,x_i-t\,p_i$. Compute $\{K_i,H\}$ and $\{K_i,p_j\}$. Show that $K_i$ is conserved, and say what it records.

::: answer
$\{x_i,H\}=\partial H/\partial p_i=c^2p_i/H$, so $\{K_i,H\}=(H/c^2)(c^2p_i/H)=p_i$. $H$ depends on $p$ only, so $\{K_i,p_j\}=(H/c^2)\{x_i,p_j\}=(H/c^2)\,\delta_{ij}$. $K_i$ depends on time explicitly, and the two terms of its rate of change cancel: $\dot K_i=\partial_tK_i+\{K_i,H\}=-p_i+p_i=0$. Dividing by the constant $H/c^2$ gives $x_i-t\,v_i$, the position the particle had at time $0$. A boost generator records where a uniformly moving body started. With $\{K_i,K_j\}=-\varepsilon_{ijk}L_k/c^2$ these are the brackets of the Poincaré algebra.
:::

### Mass is the obstruction {kind=explain at=the-galilean-limit-and-the-mass}

Take the Galilean limit of $\{K_i,p_j\}$. On events, boosts and translations commute. Why do their generating functions on a particle's phase space not commute, and why can the constant not be removed? When does the central term survive the contraction?

::: answer
Write $H=mc^2+E$. Then $\{K_i,p_j\}=(m+E/c^2)\,\delta_{ij}\to m\,\delta_{ij}$, and $K_i\to m\,x_i-t\,p_i$. On events a translation by $a$ and a boost by $v$ give $x+a+vt$ in either order, so $[K_i,P_j]=0$. On a particle's states the two motions still commute, but the generating functions have a constant bracket. A constant generates no motion, and shifting $K_i$ or $p_j$ by constants cannot remove it, since constants drop out of every bracket. The constant is needed because a boost must change the momentum by $mv$, which depends on the body, and space-time alone knows no masses. The Galilei algebra with this central generator is the Bargmann algebra. Contracting the Poincaré group itself gives the Galilei group without the term; it appears when the rest energy $mc^2$ is separated off before the limit.
:::

### The Carroll limit {kind=compute at=the-family-of-contractions}

Rescale the Poincaré boosts to $K'_i=c^2K_i$. Compute $\{K'_i,P_j\}$, $\{K'_i,H\}$ and $\{K'_i,K'_j\}$, and let $c\to0$. How does the result differ from the Galilei algebra, and what does a free particle do?

::: answer
$\{K'_i,P_j\}=c^2\cdot\delta_{ij}H/c^2=\delta_{ij}H$. $\{K'_i,H\}=c^2P_i\to0$. $\{K'_i,K'_j\}=c^4\cdot(-\varepsilon_{ijk}J_k/c^2)=-c^2\varepsilon_{ijk}J_k\to0$. The Galilei algebra keeps $\{K_i,H\}=P_i$ and loses $\{K_i,P_j\}$, apart from the Bargmann mass term. The Carroll algebra does the reverse. In it a single free particle has no motion: its velocity vanishes identically. With all three brackets zero the algebra is the static one.
:::

### Rigidity {kind=state at=stability}

Define a 2-cocycle and a 2-coboundary of a Lie algebra. When is the algebra rigid, and which algebras always are? Why are the homogeneous Galilei algebra and the Poincaré algebra not semisimple? What is the one deformation of the first?

::: answer
A first-order correction $\varphi_1$ to the bracket is a 2-cocycle if it keeps the Jacobi identity to first order. It is a 2-coboundary if it comes from relabeling the generators, $A\mapsto A+tf(A)$; the algebra it produces is the old one in disguise. $H^2(\mathfrak g,\mathfrak g)$ is the space of cocycles modulo coboundaries. If it vanishes, every small deformation is a change of basis, and the algebra is rigid. Semisimple algebras, those with no abelian ideal other than $\{0\}$, are rigid by Whitehead's second lemma. In the homogeneous Galilei algebra the boosts form an abelian ideal, and in the Poincaré algebra the translations do. The single nontrivial deformation of the first is $[K_i,K_j]=t\,\varepsilon_{ijk}J_k$. At $t=-1/c^2$ it is the Lorentz algebra $\mathfrak{so}(3,1)$ and at $t>0$ it is $\mathfrak{so}(4)$; both are semisimple, so stability selects semisimplicity and the sign is an empirical input.
:::

### Two stabilities, opposite rankings {kind=case at=stability}

Define structural stability of a vector field. Show with the harmonic oscillator that a conservative system is not structurally stable. Why are gradient flows robust, and what does the KAM theorem save? How do the two notions of stability rank Aristotle and Newton?

::: answer
A vector field is structurally stable if every $C^1$-close field is topologically equivalent to it: a homeomorphism carries the orbits of one onto the orbits of the other, preserving direction. The oscillator $\dot x=p$, $\dot p=-x$ has only closed orbits. The perturbation $\dot p=-x-\varepsilon p$ makes the origin attracting for every $\varepsilon>0$, and no homeomorphism carries closed orbits onto orbits that converge to a point. The gradient flow of a Morse function has no periodic orbits and only hyperbolic equilibria, and an arbitrarily small perturbation makes it Morse–Smale, which is structurally stable. The KAM theorem saves the invariant tori with Diophantine frequencies of a nearly integrable system, but only under Hamiltonian perturbations; a dissipative perturbation destroys the family. Among Lie algebras Galilei is unstable and Lorentz rigid. Among vector fields the conservative dynamics of both is unstable, and the dissipative, first-order dynamics of Aristotle is generic.
:::

### Counting speeds {kind=compute at=moving-patterns-in-a-cellular-automaton}

A spaceship has speed $r/q$ in lowest terms, and every phase of it fits in a box of area $A$ cells. Bound $q$. What is the bound for a $5\times5$ box, and how many cells does a denominator of $10^6$ need? What does this counting fail to capture?

::: answer
The period is a multiple of $q$, so the ship passes through at least $q$ distinct phases. A box of $A$ cells has at most $2^A$ configurations, so $q\le2^A$. A $5\times5$ box allows $q\le2^{25}\approx3.4\times10^7$, and a denominator of $10^6$ needs at least $\log_2 10^6\approx20$ cells. Precision costs size only logarithmically, so for a pattern of macroscopic size counting forbids no speed an observer could resolve. What breaks Newton's first law is a gap: two nearby speeds carried by patterns that have nothing in common, so that a small boost turns a body into a different kind of thing. A rule passes the gap test if neighboring speeds are realized by nearly the same pattern at the scale an observer resolves. In Life they are not.
:::

### No invariant direction {kind=state at=the-bombellihensonsorkin-theorem}

State the Bombelli–Henson–Sorkin theorem, the idea of its proof, and its corollary.

::: answer
Let $\Omega$ be the space of Poisson sprinklings of Minkowski space $\mathbb M^n$, $n>1$, with its Lorentz-invariant probability measure, and $\mathcal H$ the hyperboloid of future-directed unit timelike vectors. There is no measurable map $D:\Omega\to\mathcal H$ with $D(\Lambda\omega)=\Lambda D(\omega)$ for all $\Lambda$ in the connected Lorentz group. The idea: such a map would push the measure on $\Omega$ forward to a Lorentz-invariant probability measure on $\mathcal H$. None exists, because the invariant measure on the hyperboloid has infinite total volume. The corollary: no finite-valency graph can be associated to a sprinkling consistently with Lorentz invariance. Intuitively a sprinkled point has no nearest neighbor, since every Lorentz-invariant neighborhood has infinite volume.
:::

### What carries over to a hypergraph {kind=limits at=the-bombellihensonsorkin-theorem}

The last two sections bear on hypergraph rewriting. What does the page say its results do and do not establish there?

::: answer
- Fact 2 and the gap test are stated for a fixed lattice with a uniform background, and a hypergraph has neither. The gap test carries over, with "nearly the same pattern" read at the observer's scale ([Section 5](/notes/the-standard-of-motion-mathematics.html#moving-patterns-in-a-cellular-automaton)).
- Gorard's first argument, from invariance under changes of foliation, establishes independence of the slicing. It does not establish the absence of an equivariantly definable direction in the graph itself.
- A causal-invariant rule produces a single graph, on which the Lorentz group does not act. The measure-theoretic setting of the theorem therefore does not transfer without further construction.
- His second argument grants the corollary for the microscopic graph. What it leaves is approximate, emergent Lorentz invariance below observational resolution.
:::
