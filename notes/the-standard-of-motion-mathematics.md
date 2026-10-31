---
title: "The Standard of Motion: The Mathematics"
subtitle: "Heller's ladder of space-times in frame-bundle terms, the Hamiltonian brackets, the kinematical Lie algebras and their contractions, mass as a central charge, algebraic and structural stability, moving patterns in cellular automata, and the Bombelli–Henson–Sorkin theorem"
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

*This page accompanies [The Standard of Motion](https://lukstafi.github.io/notes/the-standard-of-motion.html). It writes out the structures the essay describes in prose. Section 1 follows Michał Heller, "Evolution of Space-Time Structures", Concepts of Physics 3 (2006) 117–131; the other sections are standard material, with sources given where they are used.*

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
