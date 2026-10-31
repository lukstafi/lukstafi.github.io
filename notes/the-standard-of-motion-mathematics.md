---
title: "The Standard of Motion: The Mathematics"
subtitle: "For The Standard of Motion and The Demon Is a Learner: Heller's ladder of space-times in frame-bundle terms, the Hamiltonian brackets, the kinematical Lie algebras and their contractions, mass as a central charge, algebraic and structural stability, moving patterns in cellular automata, the Bombelli–Henson–Sorkin theorem, the overdamped limit, the entropy that learning exports, and algorithmic bounds"
author: "Łukasz Stafiniak and Claude (Anthropic)"
date: 2026-10-31
header-includes:
  - |
    <style>
    .katex-display { overflow-x: auto; overflow-y: hidden; padding: 0.3em 0; }
    .katex-display > .katex { width: max-content; min-width: 100%; }
    article table { display: block; max-width: 100%; overflow-x: auto; }
    </style>
---

*This page accompanies [The Standard of Motion](https://lukstafi.github.io/notes/the-standard-of-motion.html) and its sequel, [The Demon Is a Learner](https://lukstafi.github.io/notes/the-demon-is-a-learner.html). It writes out the structures the essays describe in prose; Sections 1–6 serve the first essay and Section 7 the second. Section 1 follows Michał Heller, "Evolution of Space-Time Structures", Concepts of Physics 3 (2006) 117–131; the other sections are standard material, with sources given where they are used.*

Notation: indices $i, j, k$ run over three spatial directions; $\varepsilon_{ijk}$ is the Levi-Civita symbol; repeated indices are summed.

## 1. Heller's ladder in frame-bundle terms

**Projections.** A space-time is a four-dimensional manifold $X$. *Absolute time* is a surjection $\mathrm{pr}_T: X\to T$ onto a one-dimensional manifold whose fibers are the sets of simultaneous events. *Absolute space* is a surjection $\mathrm{pr}_S: X\to S$ onto a three-dimensional manifold whose fibers are the world lines of bodies at absolute rest. If both exist and $(\mathrm{pr}_T,\mathrm{pr}_S)$ is a diffeomorphism, $X\cong T\times S$.

**Aristotle.** The first law (a free body stays at absolute rest) supplies $\mathrm{pr}_S$; absolute simultaneity supplies $\mathrm{pr}_T$. So Aristotelian space-time is $A = T\times S$, a trivial bundle over $S$ (and over $T$). The second law in Heller's stylization is $F = m v$, a first-order equation: no force, no velocity.

**Frame bundles.** For a manifold $X$ with a structure group $G$ acting on frames, the frame bundle $\pi: F(X)\to X$ has as its fiber over $x$ the set of admissible frames at $x$, and $G$ acts freely and transitively on each fiber. A global section of $F(X)$ is a global field of frames. A principal bundle with a global section is trivial, $F(X)\cong X\times G$.

*In what sense "product".* As a bare bundle, a frame bundle is often trivial anyway: $F(N)$ over $\mathbb R^4$ is, and so is the Lorentz frame bundle of any noncompact space-time with a spin structure (Geroch 1968). The product structure that matters here is one compatible with the connection, a global field of frames that is parallel. "Not a product" below means that no such parallel field exists.

**Teleparallelism.** A connection on $F(X)$ defines parallel transport of frames. If the connection is flat and its holonomy is trivial, transporting one frame to every point gives a global section, so $F(X)\cong X\times G$. Conversely, a product structure defines such a flat connection. Heller uses "teleparallelism" for this property.

**Newton without gravity.** The first law (a free body moves uniformly) makes all inertial frames equivalent, so $\mathrm{pr}_S$ is gone. Absolute time survives, since instantaneous signals synchronize distant clocks. The second law $F = ma$ makes acceleration absolute, so non-accelerated world lines define a flat affine connection with trivial holonomy. The structure group acting on frames is the homogeneous Galileo group (rotations and boosts), and $F(N) = N\times G_{\text{Gal}}$ with a parallel product structure.

**Newton with gravity (Newton–Cartan).** The geometric form is due to Cartan (1923–24); see D. Malament, *Topics in the Foundations of General Relativity and Newtonian Gravitation Theory* (Chicago, 2012), ch. 4. Its ingredients:

- a closed one-form $\tau = dt$, the absolute time;
- a degenerate symmetric tensor $h^{ab}$ of rank 3 with $h^{ab}\tau_b = 0$, the spatial metric (there is no nondegenerate space-time metric);
- a torsion-free affine connection $\nabla$ compatible with both, $\nabla\tau = 0$ and $\nabla h = 0$;
- the field equation $R_{ab} = 4\pi G\rho\,\tau_a\tau_b$.

Free fall follows the geodesics of $\nabla$. Because $\nabla$ is curved, the holonomy is nontrivial, and $F(N)$ has no global parallel section: there is no product $F(N) = N\times G$ compatible with the connection. Recovering a Newtonian potential needs further curvature conditions (Trautman 1963; Künzle).

**Special relativity.** Minkowski space-time $M$ has neither $\mathrm{pr}_T$ nor $\mathrm{pr}_S$. It is flat, so $F(M) = M\times G_{\text{Lor}}$.

**General relativity.** $M$ is curved, so $F(M)$ has no parallel product structure. But the bundle of frames of a manifold with a linear connection is parallelizable; this uses the solder form, which a general principal bundle lacks. On the bundle of linear frames $P = F(X)$, with $n = \dim X$, the canonical one-form $\theta$ (with values in $\mathbb R^n$) and the connection form $\omega$ (with values in $\mathfrak{gl}(n)$) together give $n + n^2 = \dim P$ linearly independent one-forms at every point, a global coframe (Kobayashi and Nomizu, *Foundations of Differential Geometry*, vol. 1, ch. III). A global coframe makes the frame bundle of $P$ trivial, so $F(F(M))\cong F(M)\times G'$ for the relevant structure group $G'$. This is Heller's observation that the product reappears two levels up. Heller states it for general relativity, but the argument uses only the connection, so it holds equally for Newton–Cartan space-time: $F(F(N))$ is a product too.

**Heller's next rung.** Heller proposes the transformation groupoid $\Gamma = F(M)\times G$, with composition $(p, g_1)\circ(pg_1, g_2) = (p, g_1g_2)$, and the convolution algebra of compactly supported functions on it,
$$(f_1 * f_2)(\gamma) = \int_{\Gamma_p} f_1(\gamma_1)\,f_2(\gamma_1^{-1}\gamma)\,d\gamma_1,$$
which is noncommutative. In the resulting geometry, points and their neighborhoods have no meaning; the usual space-time appears only at lower energies. The dynamics is the Tomita–Takesaki modular flow of a state on this algebra (M. Heller, L. Pysiak, W. Sasin, "Noncommutative dynamics of random operators", [Int. J. Theor. Phys. 44 (2005) 619](https://arxiv.org/abs/gr-qc/0409063)).

## 2. One bracket, three mechanics

On phase space with coordinates $(x_i, p_i)$,
$$\{f, g\} = \frac{\partial f}{\partial x_i}\frac{\partial g}{\partial p_i} - \frac{\partial f}{\partial p_i}\frac{\partial g}{\partial x_i},\qquad \{x_i, p_j\} = \delta_{ij}.$$

**Liouville's theorem.** The Hamiltonian vector field $X_H = (\partial H/\partial p,\, -\partial H/\partial x)$ has zero divergence, so its flow $\phi_t$ preserves phase-space volume. A density transported by the flow, $\rho_t = \rho_0\circ\phi_t^{-1}$, satisfies $\partial_t\rho = \{H,\rho\}$, and for any function $s$,
$$\frac{d}{dt}\int s(\rho_t)\,dx\,dp = 0,$$
by the change of variables $\phi_t$ with unit Jacobian. With $s(\rho) = -\rho\ln\rho$ this is the constancy of the Gibbs–Shannon entropy. In quantum mechanics, $\hat\rho_t = U_t\hat\rho_0U_t^\dagger$ with $U_t$ unitary, so the spectrum of $\hat\rho$, and with it the von Neumann entropy $-\operatorname{tr}\hat\rho\ln\hat\rho$, is constant.

**Stationary states.** If $\rho = \varphi(H)$, then $\{H, \rho\} = \varphi'(H)\{H, H\} = 0$. The Gibbs state $\rho = e^{-\beta H}/Z$ is the case $\varphi(h) = e^{-\beta h}/Z$.

**Moyal bracket.** With the bidifferential operator $\overleftrightarrow{\Lambda} = \overleftarrow{\partial_x}\cdot\overrightarrow{\partial_p} - \overleftarrow{\partial_p}\cdot\overrightarrow{\partial_x}$,
$$\{f, g\}_M = \frac{2}{\hbar}\, f\,\sin\!\Big(\frac{\hbar}{2}\overleftrightarrow{\Lambda}\Big)\,g = \{f, g\} + O(\hbar^2).$$
Under the Weyl correspondence between phase-space functions and operators, $\{f, g\}_M$ corresponds to $[\hat f, \hat g]/(i\hbar)$ exactly. Quantum mechanics on phase space is thus a deformation of the Poisson algebra in the parameter $\hbar$.

**Problem of time.** In the canonical (ADM) form of general relativity on a closed spatial slice, the Hamiltonian is a sum of constraints, $H = \int(N\mathcal H + N^i\mathcal H_i)$ with $\mathcal H\approx 0$ and $\mathcal H_i\approx 0$. It vanishes on solutions, and quantizing gives the Wheeler–DeWitt equation $\hat{\mathcal H}\Psi = 0$ with no time parameter. For asymptotically flat data, a boundary term survives and equals the ADM energy. See C. J. Isham, ["Canonical quantum gravity and the problem of time"](https://arxiv.org/abs/gr-qc/9210011) (1993).

## 3. Kinematical Lie algebras

### 3.1 The free particle as a realization

For a free relativistic particle of mass $m\neq 0$, realize the generators by phase-space functions:
$$H = \sqrt{p^2c^2 + m^2c^4},\qquad J_i = L_i = \varepsilon_{ijk}x_jp_k,\qquad K_i = \frac{H}{c^2}x_i - t\,p_i,$$
with $P_i = p_i$. The $K_i$ are conserved: $\partial_t K_i + \{K_i, H\} = -p_i + p_i = 0$. Using $\{x_i, H\} = \partial H/\partial p_i = c^2p_i/H$:

- $\{K_i, p_j\} = \dfrac{H}{c^2}\{x_i, p_j\} = \dfrac{H}{c^2}\,\delta_{ij}$,
- $\{K_i, H\} = \dfrac{H}{c^2}\{x_i, H\} = p_i$,
- $\{K_i, K_j\} = \dfrac{1}{c^4}\{Hx_i, Hx_j\} + t\,\dfrac{H}{c^2}\delta_{ij} - t\,\dfrac{H}{c^2}\delta_{ij} = \dfrac{1}{c^4}\Big(H\dfrac{c^2p_i}{H}x_j - x_iH\dfrac{c^2p_j}{H}\Big) = -\dfrac{1}{c^2}\,\varepsilon_{ijk}L_k$,
- $\{L_i, L_j\} = \varepsilon_{ijk}L_k$, $\{L_i, K_j\} = \varepsilon_{ijk}K_k$, $\{L_i, p_j\} = \varepsilon_{ijk}p_k$, and $\{p_i, p_j\} = \{p_i, H\} = \{L_i, H\} = 0$.

These are the brackets of the Poincaré algebra, realized on the particle's phase space. (In the third item, the cross terms come from $\{Hx_i/c^2, -tp_j\} = -t\,H\delta_{ij}/c^2$ and $\{-tp_i, Hx_j/c^2\} = +t\,H\delta_{ij}/c^2$, using that $H$ depends on $p$ only.)

### 3.2 The Galilean limit and the mass

Write $H = mc^2 + E$, so that $E = p^2/2m + O(1/c^2)$. As $c\to\infty$:
$$\{K_i, p_j\} = \Big(m + \frac{E}{c^2}\Big)\delta_{ij}\ \to\ m\,\delta_{ij},\qquad \{K_i, K_j\}\to 0,\qquad \{K_i, E\} = p_i,$$
and $K_i\to m\,x_i - t\,p_i$, the Galilean boost. The constant $mc^2$ commutes with everything, so it drops out of the brackets once subtracted from $H$, and the limit is the Galilei algebra with one extra central generator whose value is $m$: the *Bargmann algebra*. Without that central term, the Galilei algebra has $\{K_i, P_j\} = 0$, and its realization on the phase space of a free particle is impossible. Mass is the obstruction.

Quantum mechanically, V. Bargmann, ["On unitary ray representations of continuous groups"](https://doi.org/10.2307/1969831), Ann. Math. 59 (1954) 1–46, showed that projective representations of the Galilei group do not reduce to ordinary ones: their cocycle is labeled by a real parameter, the mass. For the Poincaré group the second cohomology vanishes and the projective representations reduce to ordinary ones; mass there is fixed by a Casimir, $H^2 - p^2c^2 = m^2c^4$, not by a central charge. (A superselection rule for mass is often attributed to Bargmann; that attribution is disputed.)

Contracting the Poincaré group itself, as E. İnönü and E. P. Wigner did in ["On the contraction of groups and their representations"](https://doi.org/10.1073/pnas.39.6.510) (PNAS 39, 1953), gives the Galilei group without the central term. The central term appears when the rest energy $mc^2$ is separated off before the limit, as above.

### 3.3 The family of contractions

Using the conventions of §3.1, the kinematical algebras connected by contraction differ in three brackets (rotations act on $K$, $P$ as vectors and commute with $H$ in all of them):

| Algebra | $\{K_i, H\}$ | $\{K_i, P_j\}$ | $\{K_i, K_j\}$ |
|---|---|---|---|
| Poincaré | $P_i$ | $\delta_{ij}H/c^2$ | $-\varepsilon_{ijk}J_k/c^2$ |
| Galilei ($c\to\infty$) | $P_i$ | $0$ (Bargmann: $m\,\delta_{ij}$) | $0$ |
| Carroll ($c\to 0$, $K\mapsto c^2K$) | $0$ | $\delta_{ij}H$ | $0$ |
| static | $0$ | $0$ | $0$ |

For the Carroll limit, set $K' = c^2K$; then $\{K'_i, P_j\} = \delta_{ij}H$, $\{K'_i, H\} = c^2P_i\to 0$ and $\{K'_i, K'_j\} = -c^2\varepsilon_{ijk}J_k\to 0$. The Carroll group was introduced by J.-M. Lévy-Leblond (Ann. Inst. Henri Poincaré A 3, 1965). In it a single free particle has no motion: its velocity vanishes identically (E. Bergshoeff, J. Gomis, G. Longhi, ["Dynamics of Carroll particles"](https://arxiv.org/abs/1405.2264), 2014). H. Bacry and J.-M. Lévy-Leblond, ["Possible kinematics"](https://doi.org/10.1063/1.1664490) (J. Math. Phys. 9, 1968), classified the kinematical algebras under three assumptions (isotropy; parity and time reversal are automorphisms; boosts generate non-compact subgroups) and found eleven, including the de Sitter and Newton–Hooke algebras, connected by contractions.

**Aristotelian algebras.** J. Figueroa-O'Farrill and S. Prohazka, ["Spatially isotropic homogeneous spacetimes"](https://arxiv.org/abs/1809.01224) (JHEP 01 (2019) 229), call a Lie algebra *aristotelian* if it is spanned by rotations, spatial translations and time translation, with no boosts. The homogeneous spaces of such algebras are "spacetimes without boosts". They carry both an invariant clock form and an invariant time vector field, that is, absolute time and absolute space together. The simplest, the static aristotelian space-time, is $\mathbb R\times\mathbb R^3$ with both structures, Heller's $A = T\times S$. The step from Aristotle to Newton adds the boosts; the steps after Newton deform their brackets.

## 4. Stability

A deformation of a Lie algebra $(\mathfrak g, [\cdot,\cdot])$ is a family of brackets $[\cdot,\cdot]_t = [\cdot,\cdot] + t\,\varphi_1 + t^2\varphi_2 + \cdots$ satisfying the Jacobi identity. The first-order term $\varphi_1$ must be a 2-cocycle in the Chevalley–Eilenberg complex with coefficients in the adjoint representation, and deformations that differ by a change of basis correspond to coboundaries. If $H^2(\mathfrak g, \mathfrak g) = 0$, every deformation is trivial and $\mathfrak g$ is *rigid* (stable). Semisimple Lie algebras are rigid, by Whitehead's second lemma.

**Galilei to Lorentz.** The homogeneous Galilei algebra (rotations $J$ and boosts $K$ with $[K_i, K_j] = 0$) has a single nontrivial deformation, which switches on
$$[K_i, K_j] = t\,\varepsilon_{ijk}J_k.$$
At $t = -1/c^2$ this is the Lorentz algebra $\mathfrak{so}(3,1)$; at $t > 0$ it is $\mathfrak{so}(4)$. Both are semisimple, hence rigid. Stability selects semisimplicity; the sign of $t$, and so Lorentzian signature, is an empirical input (C. Chryssomalakos and E. Okon, ["Generalized quantum relativistic kinematics: a stability point of view"](https://arxiv.org/abs/hep-th/0410212), Int. J. Mod. Phys. D 13 (2004) 2003–2034, §2).

**Faddeev's thesis.** L. D. Faddeev, ["A mathematician's view of the development of physics"](https://doi.org/10.5802/pmihes.19) (1989 talk; reprinted Publ. Math. IHÉS S88 (1998) 73–79): "quantum mechanics is a deformation of the classical one with ħ playing the role of deformation parameter"; "classical mechanics is not stable"; "the Lorentz group is stable"; and "the two main revolutions in physics … are deformations from unstable structures into stable ones." He adds general relativity as a third deformation, with Newton's constant as parameter.

**The inhomogeneous algebras.** The Poincaré algebra is not semisimple, and it is not rigid: switching on $[H, P_i]$ and $[P_i, P_j]$ proportional to $1/R^2$ times boosts and rotations deforms it to the de Sitter or anti-de Sitter algebra, $\mathfrak{so}(4,1)$ or $\mathfrak{so}(3,2)$, which are semisimple. R. Vilela Mendes, ["Deformations, stable theories and fundamental constants"](https://doi.org/10.1088/0305-4470/27/24/019) (J. Phys. A 27 (1994) 8091–8104), considered the algebra of relativistic quantum mechanics, Poincaré together with the canonical position–momentum commutators. He found it unstable and found a two-parameter stabilizing deformation; in his later summary the parameters are a fundamental length $\ell$ and a curvature $1/R$. Chryssomalakos and Okon (2004) extend the analysis and find a three-dimensional space of stable algebras "with an instability double cone at its origin."

**Structural stability of vector fields.** A $C^1$ vector field $X$ on a compact manifold is *structurally stable* if every vector field $C^1$-close to $X$ is topologically equivalent to it: a homeomorphism carries the orbits of one onto the orbits of the other, preserving their direction. A. A. Andronov and L. S. Pontryagin introduced the notion for planar systems on a disc, as "systèmes grossiers" (Dokl. Akad. Nauk SSSR 14 (1937) 247–250); the global form on compact manifolds is M. Peixoto's. This is the dynamical counterpart of rigidity.

- *Conservative systems are not structurally stable.* The harmonic oscillator $\dot x = p$, $\dot p = -x$ has a center: every orbit is closed. The perturbation $\dot p = -x - \varepsilon p$ makes the origin an attracting equilibrium for every $\varepsilon > 0$ (a stable focus while $\varepsilon < 2$, a node beyond), and no homeomorphism carries closed orbits onto orbits that converge to a point. On compact orientable surfaces, M. Peixoto ("Structural stability on two-dimensional manifolds", [Topology 1 (1962) 101–120](https://doi.org/10.1016/0040-9383(65)90018-2)) showed that the structurally stable flows are exactly the Morse–Smale ones: finitely many equilibria and periodic orbits, all hyperbolic; every other orbit tends to one of them in both directions of time; and no orbit joins two saddles. So there are no centers. Such flows are open and dense.
- *Gradient flows are robust.* For a Morse function $V$ on a compact manifold, the flow $\dot x = -\nabla V$ has $V$ as a strict Lyapunov function, so it has no periodic orbits, and its equilibria are hyperbolic, since the linearization $-\mathrm{Hess}\,V$ is self-adjoint with nonzero eigenvalues. It need not be Morse–Smale: on an upright torus, the height function's two saddles are joined by an orbit. An arbitrarily $C^1$-small perturbation, again a gradient flow for a modified metric, makes the stable and unstable manifolds meet transversally, and the result is Morse–Smale (S. Smale, "On gradient dynamical systems", [Ann. Math. 74 (1961) 199–206](https://doi.org/10.2307/1970311)). Morse–Smale flows are structurally stable in any dimension (J. Palis and S. Smale, "Structural stability theorems", [Proc. Sympos. Pure Math. 14 (1970) 223–231](https://doi.org/10.1090/pspum/014/0267603)); the converse fails from dimension 3.
- *Hamiltonian systems keep most of their order, but only under Hamiltonian perturbations.* For a nearly integrable Hamiltonian $H_0 + \varepsilon H_1$, analytic, with $\det\partial^2H_0/\partial I^2\neq 0$, the Kolmogorov–Arnold–Moser theorem shows that the invariant tori of $H_0$ with Diophantine frequencies persist, deformed, for small $\varepsilon$, and the measure of the rest tends to zero (A. N. Kolmogorov, Dokl. Akad. Nauk SSSR 98 (1954) 527–530; V. I. Arnold, [Russian Math. Surveys 18:5 (1963) 9–36](https://doi.org/10.1070/RM1963v018n05ABEH004130); J. Moser, Nachr. Akad. Wiss. Göttingen (1962) 1–20). Resonant tori break up, so with two or more degrees of freedom an integrable system is not structurally stable even among Hamiltonian systems. A dissipative perturbation contracts phase-space volume, so no invariant set of positive volume survives, and the family of tori is destroyed. Isolated tori can persist as attractors when a parameter is tuned (R. Calleja, A. Celletti, R. de la Llave, [J. Differential Equations 255 (2013) 978–1049](https://doi.org/10.1016/j.jde.2013.05.001)).
- *The class of perturbations decides.* The rotation of the sphere about an axis is structurally stable among divergence-free vector fields and unstable among all vector fields (Scholarpedia, "Structural stability").

The two notions of stability rank the same theories in opposite orders. Among Lie algebras of symmetries, Galilei is unstable and Lorentz rigid. Among vector fields, the conservative dynamics of both is unstable and the dissipative, first-order dynamics of Aristotle is generic.

## 5. Moving patterns in a cellular automaton

Let a pattern in a two-dimensional cellular automaton be a *spaceship* if, after $p$ generations, it reappears translated by a nonzero vector $(d_x, d_y)$, and $p$ is the least such period. Its speed, in Life's convention, is $\max(|d_x|, |d_y|)/p$ times $c$.

**Fact 1 (speeds are rational).** Immediate from the definition.

**Fact 2 (dense speeds need unbounded size).** Suppose every phase of a spaceship fits, up to translation, in an $a\times b$ box. Then the ship has at most $2^{ab}$ distinct phases, so $p\le 2^{ab}$, and since the displacement per generation is bounded by the automaton's radius, $|d_x|, |d_y|\le rp$. So ships fitting in a given box have speeds in a finite set. A family of ships whose speeds are dense in an interval must contain ships of unbounded size.

In Conway's Life the radius is 1, and Conway showed in 1970 that a spaceship's speed is at most $c/2$ orthogonally and $c/4$ diagonally. Below these caps, engineered ships exist in every rational direction, and adjustable designs (Simkin's caterloopillars, 2016) reportedly reach every rational orthogonal speed below $c/4$ ([LifeWiki, "Caterloopillar"](https://conwaylife.com/wiki/Caterloopillar)). Each built instance is a separate pattern ([LifeWiki, "List of spaceships"](https://conwaylife.com/wiki/List_of_spaceships), revision of 30 June 2026).

The counting assumes a fixed lattice and a uniform background, as in Life. A hypergraph rewriting system has neither, so Fact 2 shows what a fixed-lattice carrier of motion cannot do, not what a hypergraph carrier cannot do.

## 6. The Bombelli–Henson–Sorkin theorem

Let $\Omega$ be the space of Poisson sprinklings of Minkowski space $\mathbb M^n$ with $n > 1$, with its Lorentz-invariant probability measure, and let $\mathcal H$ be the hyperboloid of future-directed unit timelike vectors. **Theorem** (L. Bombelli, J. Henson, R. D. Sorkin, ["Discreteness without symmetry breaking: a theorem"](https://arxiv.org/abs/gr-qc/0605006), Mod. Phys. Lett. A 24 (2009) 2579–2587): there is no measurable map $D:\Omega\to\mathcal H$ with $D(\Lambda\omega) = \Lambda D(\omega)$ for all $\Lambda$ in the connected Lorentz group.

*Idea of proof.* Such a map would push the Lorentz-invariant probability measure on $\Omega$ forward to a Lorentz-invariant probability measure on $\mathcal H$. No such measure exists, because the invariant measure on the hyperboloid has infinite total volume.

**Corollary** (stated in the same paper). "There is no way to associate a finite-valency graph to a sprinkling consistently with Lorentz invariance." Intuitively, a point in a sprinkling has no nearest neighbor: every Lorentz-invariant neighborhood has infinite volume, so infinitely many points lie arbitrarily close to its light cone.

**Gorard's reply.** J. Gorard, ["Algorithmic causal sets and the Wolfram model"](https://arxiv.org/abs/2011.12174) (2020, §3), restates the proof and offers two arguments that causal-invariant Wolfram model systems are compatible with it. (i) A preferred direction map would induce a preferred foliation, contradicting the invariance of the causal network under changes of foliation. This establishes independence of the slicing, not the absence of an equivariantly definable direction in the graph itself; and since a causal-invariant rule produces a single graph, on which the Lorentz group does not act, the measure-theoretic setting of the theorem does not transfer without further construction. (ii) The infinite valency is granted for the microscopic graph and recovered only in an effective network, coarse-grained into foliation-defined equivalence classes whose out-degree "may be unbounded, even if the out-degree of vertices in the underlying (microscopic) is bounded." The result is approximate, emergent Lorentz invariance below observational resolution.

## 7. For *The Demon Is a Learner*

This part supports the sequel essay, [The Demon Is a Learner](https://lukstafi.github.io/notes/the-demon-is-a-learner.html). Entropies are in nats with Boltzmann's constant set to 1; a bit is $\ln 2$ nats. Kolmogorov complexities and Shannon entropies in §7.3 are in bits.

### 7.1 The overdamped limit

Take Newton's equation for a body of mass $m$ under a force $F(x)$ and linear drag $\gamma$, $m\ddot x = F(x) - \gamma\dot x$. Let $\ell$ be a length scale and $k$ a stiffness scale for the force, so that $F = k\ell\,\varphi(X)$ with $x = \ell X$ and $\varphi$ of order one. Measure time in the slow unit $\gamma/k$, the time drag needs to move the body a distance $\ell$ against forces of size $k\ell$: $t = (\gamma/k)\tau$. The equation becomes
$$\varepsilon X'' + X' = \varphi(X),\qquad \varepsilon = \frac{mk}{\gamma^2},$$
with primes for $d/d\tau$. As a first-order system,
$$X' = U,\qquad \varepsilon\,U' = \varphi(X) - U.$$
For fixed $X$, the fast equation has the equilibrium $U = \varphi(X)$, and its linearization has eigenvalue $-1/\varepsilon < 0$, so the equilibrium attracts. Tikhonov's theorem (A. N. Tikhonov, "Systems of differential equations containing small parameters in the derivatives", Mat. Sb. 31(73) (1952) 575–586) then gives: as $\varepsilon\to 0$, after an initial layer of duration $O(\varepsilon)$, solutions converge on bounded time intervals to those of the reduced equation $X' = \varphi(X)$, that is,
$$\dot x = \frac{F(x)}{\gamma}.$$
N. Fenichel's geometric theory ("Geometric singular perturbation theory for ordinary differential equations", [J. Differential Equations 31 (1979) 53–98](https://doi.org/10.1016/0022-0396(79)90152-9)) adds that for small $\varepsilon > 0$ an invariant slow manifold $U = \varphi(X) + O(\varepsilon)$ persists and attracts. The small parameter is the dimensionless $mk/\gamma^2$, not $m/\gamma$, which is a time.

**The linear case.** For $\varphi(X) = -X$ (a spring), the characteristic equation is $\varepsilon\lambda^2 + \lambda + 1 = 0$, with roots
$$\lambda_\pm = \frac{-1\pm\sqrt{1-4\varepsilon}}{2\varepsilon}.$$
They are real, and the motion is overdamped, exactly when $\varepsilon\le 1/4$, i.e. $\gamma^2\ge 4mk$. The slow root is $\lambda_+ = -1 - \varepsilon - 2\varepsilon^2 - O(\varepsilon^3)$, which tends to the reduced rate $-1$; the fast root is $\lambda_- \approx -1/\varepsilon$. At the threshold $\varepsilon = 1/4$ both roots equal $-2$, so the first-order law is off by a factor of 2 there and becomes accurate only well below it. In the units of §4's damped oscillator ($m = k = 1$, friction $\gamma$), the threshold is $\gamma = 2$, where the focus becomes a node.

### 7.2 Volume contraction and the entropy it exports

**Deterministic flows.** Let a density $\rho$ on $\mathbb R^n$ be carried by a flow $\dot x = v(x)$, so that $\partial_t\rho + \nabla\cdot(\rho v) = 0$. Its Gibbs entropy $S = -\int\rho\ln\rho$ changes at the rate
$$\frac{dS}{dt} = \int(\ln\rho + 1)\,\nabla\cdot(\rho v) = -\int\rho\, v\cdot\nabla\ln\rho = -\int v\cdot\nabla\rho = \int\rho\,\nabla\cdot v = \mathbb E_\rho[\nabla\cdot v],$$
integrating by parts twice with vanishing boundary terms. For a Hamiltonian flow $\nabla\cdot v = 0$, and $S$ is constant: this is the entropy form of Liouville's theorem (§2). For a gradient flow $v = -\nabla L$,
$$\frac{dS}{dt} = -\,\mathbb E_\rho\bigl[\operatorname{tr}\nabla^2 L\bigr],$$
which is negative while $\rho$ sits where the loss curves upward on balance, as near a nondegenerate minimum. The flow concentrates the density, and the entropy falls.

**With thermal noise.** Couple the body to a bath at temperature $T$ (overdamped Langevin dynamics with mobility $1/\gamma$ and isotropic noise): $dx = -\gamma^{-1}\nabla L\,dt + \sqrt{2T/\gamma}\,dW$. The density obeys the Fokker–Planck equation $\partial_t\rho = -\nabla\cdot J$ with probability current
$$J = -\frac{1}{\gamma}\bigl(\rho\nabla L + T\nabla\rho\bigr).$$
The system's entropy changes at the rate $\dot S_{\text{sys}} = -\int J\cdot\nabla\ln\rho$. The force $-\nabla L$ does work that the drag passes to the bath, so heat flows into the bath at the rate $\dot Q = -\int\nabla L\cdot J$ (with $L$ time-independent, $\dot Q = -\tfrac{d}{dt}\mathbb E_\rho[L]$). Adding the two,
$$\dot S_{\text{sys}} + \frac{\dot Q}{T} = -\int J\cdot\frac{\rho\nabla L + T\nabla\rho}{T\rho} = \int\frac{\gamma\,|J|^2}{T\rho}\ \ge\ 0.$$
The left side is the total entropy production, of system and bath together (U. Seifert, "Stochastic thermodynamics, fluctuation theorems and molecular machines", [Rep. Prog. Phys. 75 (2012) 126001](https://doi.org/10.1088/0034-4885/75/12/126001)). Integrated over a process, $\Delta S_{\text{sys}} + Q/T\ge 0$: if the system's entropy falls by $\Delta$ nats, at least $T\Delta$ of heat goes to the bath. One bit is $\ln 2$ nats, so a process that removes one bit of uncertainty from the system releases at least $T\ln 2$, in units with Boltzmann's constant 1. This is Landauer's bound inside the model. Goldt and Seifert's bound on learning, discussed in *The Demon Is a Learner*, is built on this balance, with the weights as the system.

With anisotropic, position-dependent noise, as in SGD, the diffusion term becomes $\nabla\cdot(D\nabla\rho)$ with a matrix $D(x)$, the stationary state generally carries a nonzero current, and entropy production continues at stationarity. This is the nonequilibrium steady state that Chaudhari and Soatto describe.

### 7.3 Algorithmic bounds

Let $K$ be prefix Kolmogorov complexity, in bits, relative to a fixed universal machine.

**Average complexity and Shannon entropy.** For a computable distribution $P$ on strings,
$$0\ \le\ \sum_x P(x)\,K(x) - H(P)\ \le\ K(P) + O(1).$$
The lower bound holds because the shortest programs form a prefix-free code, so by Kraft's inequality their average length is at least $H(P)$ (Shannon's noiseless coding theorem). The upper bound holds because $x$ can be described by a description of $P$ followed by the Shannon–Fano codeword for $x$ under $P$, of length $\lceil-\log_2P(x)\rceil$; averaging gives $H(P) + K(P) + O(1)$. See P. Grünwald and P. Vitányi, ["Algorithmic information theory"](https://arxiv.org/abs/0809.2754) (2008), Theorem 10.

**Logarithmic growth under deterministic laws.** Let $x_t = f^t(x_0)$ for a computable map $f$. A program for $x_t$ can consist of a shortest program for $x_0$, a self-delimiting description of $f$, a self-delimiting description of $t$, and a fixed routine that applies $f$ $t$ times. So
$$K(x_t)\ \le\ K(x_0) + K(f) + K(t) + O(1),\qquad K(t)\le\log_2 t + 2\log_2\log_2 t + O(1).$$
If $f$ is a computable bijection, the same argument run backward bounds $K(x_0)$ by $K(x_t) + K(f) + K(t) + O(1)$, so the complexity can neither rise nor fall by more than these terms. A. Ebtekar and M. Hutter, ["Foundations of algorithmic thermodynamics"](https://arxiv.org/abs/2308.06927) (Phys. Rev. E, 2025), Corollaries 3–4, give the sharp form and build an algorithmic second law on it.

**Zurek's accounting of a measurement.** Zurek's physical entropy for a demon holding a record $d$ is $S = H(\text{state}\mid d) + K(d)$ (W. H. Zurek, [Phys. Rev. A 40 (1989) 4731](https://doi.org/10.1103/PhysRevA.40.4731)). Consider an ideal measurement with outcome $d$ drawn from a distribution $P_D$. On average it lowers the demon's missing information by $H(P_D)$, the information the outcome carries. The record's average complexity is at least $H(P_D)$, by the lower bound above. So on average $\Delta S\ge 0$: the decrease of ignorance is paid for by the growth of the record. The work the demon can extract from what it learned is at most $T\ln 2$ per bit of ignorance removed, and returning to its initial state means erasing the record, which costs at least $T\ln 2$ per bit of its compressed length. Over a cycle the demon gains nothing on average (Zurek, ["Algorithmic randomness, physical entropy, measurements, and the demon of choice"](https://arxiv.org/abs/quant-ph/9807007), 1998).

**Converting one string into another.** C. H. Bennett, P. Gács, M. Li, P. M. B. Vitányi and W. H. Zurek, ["Information distance"](https://arxiv.org/abs/1006.3520) (IEEE Trans. Inf. Theory 44 (1998) 1407–1423), show that a computation from $x$ to $y$ that is otherwise reversible needs $K(x\mid y) + K(y\mid x)$ irreversible bit operations, up to logarithmic terms: about $K(y\mid x)$ bits supplied and $K(x\mid y)$ bits erased. The net thermodynamic cost they propose is $T\ln 2\,[K(x\mid y) - K(y\mid x)]$, which equals $T\ln 2\,[K(x) - K(y)]$ up to logarithmic terms; it is antisymmetric, as a cost of conversion should be.

**The bookmaker's loss.** The cost function $C(q) = b\log\sum_i e^{q_i/b}$ of the logarithmic market scoring rule is a log-partition function at temperature $b$, and the market maker's worst-case loss is $b\ln n$, temperature times the maximum entropy of a distribution on $n$ outcomes. The derivation is on [the mathematics page for *The Bookmaker Is a Learner*](https://lukstafi.github.io/notes/the-bookmaker-is-a-learner-mathematics.html).
