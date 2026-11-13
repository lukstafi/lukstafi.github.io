---
title: "Study notes: The Standard of Motion"
essay: the-standard-of-motion
track: physics-and-reality
reviewed-against: "9bf719d"
requires:
  - {at: wolfram-physics-quantum-mechanics#the-starting-point-hypergraph-rewriting, for: hypergraph rewriting and the causal graph, strength: helpful}
  - {at: wolfram-physics-quantum-mechanics#confluence-causal-invariance-and-their-tension, for: causal invariance as a discrete general covariance, strength: helpful}
  - {at: how-does-a-policy-improve#improving-a-distribution-without-throwing-away-the-prior, for: a Lagrange multiplier read as a price, strength: helpful}
introduces:
  - {term: standard of motion, at: the-first-law-carries-the-geometry, gloss: "Heller's term: the motions a dynamics counts as free, against which a force shows as a deviation"}
  - {term: "Aristotle's first and second law", at: the-first-law-carries-the-geometry, gloss: "in Heller's reconstruction: a free body stays at absolute rest, and force is proportional to velocity", related: ["overdamped limit", "three geometries of gradient flow", "Carroll algebra"]}
  - {term: frame bundle and teleparallelism, at: the-first-law-carries-the-geometry}
  - {term: Poisson bracket and Hamiltonian, at: one-bracket-three-mechanics, related: ["Hamiltonian vector field", "generator of a flow"]}
  - {term: "Liouville's theorem", at: one-bracket-three-mechanics, gloss: "Hamiltonian flow preserves phase-space volume, so closed evolution loses no information", related: ["Landauer's principle", "Kolmogorov complexity"]}
  - {term: momentum as the price of a constraint, at: one-bracket-three-mechanics, related: ["temperature as a Lagrange multiplier", "shadow price", "state value and action value"]}
  - {term: kinematical algebra, at: the-algebra-of-free-motions, gloss: "the Lie algebra of the rotations, translations and boosts that preserve a first law", related: ["Lie algebra and Lie bracket"]}
  - {term: contraction and deformation, at: the-algebra-of-free-motions, related: ["Carroll algebra", "Bargmann algebra"]}
  - {term: mass as a central extension, at: the-algebra-of-free-motions, related: ["Bargmann algebra"]}
  - {term: stable algebra, at: the-algebra-of-free-motions, gloss: "Faddeev's criterion: every small deformation of the structure is equivalent to it", related: ["rigid Lie algebra"]}
  - {term: structural stability, at: the-algebra-of-free-motions, gloss: "every small perturbation of the equations leaves the phase portrait topologically the same", related: ["overdamped limit"]}
  - {term: passive and active invariance, at: a-computational-physics-must-earn-its-first-law, gloss: "the description does not depend on the observer's frame; against it, every body has a moving twin at each speed", related: ["gap test", "Bombelli–Henson–Sorkin theorem"]}
  - {term: carrier of motion, at: a-computational-physics-must-earn-its-first-law, gloss: "after Wolfram's \"carriers of pure motion\": a persistent structure that moves without changing", related: ["gap test"]}
  - {term: emergent invariant speed, at: a-computational-physics-must-earn-its-first-law, gloss: "the cap on the carriers of motion, which observers built from them would measure in place of the substrate's own limit"}
uses:
  - {term: hypergraph rewriting, from: wolfram-physics-quantum-mechanics}
  - {term: causal graph, from: wolfram-physics-quantum-mechanics}
  - {term: causal invariance, from: wolfram-physics-quantum-mechanics}
  - {term: bounded and persistent observer, from: wolfram-physics-quantum-mechanics}
see-also:
  - {term: Lagrange multiplier as a price, at: how-does-a-policy-improve#improving-a-distribution-without-throwing-away-the-prior}
---

The answers state what the essay argues. Where a claim is Heller's, Faddeev's, Wolfram's or Gorard's, the answer says so.

### A speed is a machine {kind=compute}

A Life pattern that repeats every $p$ generations, displaced by $d$ cells, moves at $d/p$ of Life's light speed. Give the glider's speed. A ship reappears after $21$ generations, $5$ cells along. How does its speed compare with the glider's, and what would it take to turn one into the other? What in our world does Life fail to match?

::: answer
The glider reappears every four generations one cell further along, so it moves at $c/4$. The ship moves at $5c/21\approx0.238c$, about five percent slower. In Life each ship is a different pattern with its own speed, and nothing carries one into another: "To change its speed you build a different machine." A stone can be thrown at any speed below the speed of light, and it is the same stone at every speed.
:::

### The standard of motion {kind=state at=the-first-law-carries-the-geometry}

What does Heller mean by a "standard of motion"? Why does the first law then say something about geometry? How does Aristotle's second law, in Heller's stylization, agree with his first?

::: answer
A dynamics must first say how to tell that a force is acting, and it does so by naming the motions that need no force. In Heller's words, "A deviation from a free motion witnesses to the appearance of a force." Setting this standard is the task of the first law. In many theories the free motions are fixed by the geometry of space-time, so the first law carries information about the geometry, and the geometry becomes open to empirical test. Aristotle's second law, as Heller stylizes it, is $F=m\cdot v$. With no force the velocity relative to absolute space is zero, which is the first law: the body is at rest.
:::

### Five rungs {kind=recall at=the-first-law-carries-the-geometry}

Heller reconstructs five space-times. For each, state the first law and say where a product structure lives. Then give the essay's own reading of the pattern.

::: answer
- Aristotle: free bodies stay at rest. Absolute rest gives a projection onto absolute space and absolute simultaneity one onto absolute time, so space-time itself is a product, $A=T\times S$.
- Newton: free bodies move uniformly. Rest becomes relative and only the projection onto time survives. $F=m\cdot a$ makes acceleration absolute, so parallelism at a distance is a fact (teleparallelism) and the frame bundle is a product, $F(N)=N\times G$.
- Newton with gravity: free bodies fall. Free-fall paths converge, parallel transport depends on the path, and the product moves to the frame bundle of the frame bundle. Absolute time remains.
- Special relativity: free bodies move uniformly, with neither projection. Minkowski space-time is flat, so $F(M)=M\times G_{\text{Lorentz}}$.
- General relativity: free bodies fall, and the product lives in $F(F(M))$.

The essay's reading: each new first law makes relative something that was absolute. The product that reappears higher up marks what stays absolute, acceleration for Newton and the free-fall connection once gravity enters.
:::

### One bracket, and what it gives free {kind=explain at=one-bracket-three-mechanics}

Hamiltonian mechanics puts three mechanics under one bracket. What evolves in each? What does the framework give for free, and how does the essay set that beside the first law?

::: answer
In classical mechanics a point in phase space evolves, by $\dot f=\{f,H\}$. In statistical mechanics a probability density evolves, by Liouville's equation $\partial_t\rho=\{H,\rho\}$. In quantum mechanics a density operator evolves, with the commutator divided by $i\hbar$ in place of the Poisson bracket. Hamiltonian flow preserves phase-space volume, which is Liouville's theorem, so the entropy $-\int\rho\ln\rho$ of an evolving density stays constant; unitary evolution likewise preserves the von Neumann entropy. Closed evolution therefore loses no information. The first law says which motions need no force, and Liouville's theorem says that evolution which needs nothing from outside forgets nothing.
:::

### The ladder in the algebra {kind=recall at=the-algebra-of-free-motions}

Name the generators of the symmetries of a first law. Which does Aristotle's algebra lack? What do the limits $c\to\infty$ and $c\to0$ of the Poincaré algebra give?

::: answer
Rotations $J_i$, spatial translations $P_i$, time translation $H$ and boosts $K_i$. Aristotle's first law is preserved only by transformations that keep the rest frame, so its algebra has no boosts. Newton's step adds them and enlarges the symmetry, and the steps after Newton deform it. As $c\to\infty$ the boosts commute with each other, and the Poincaré algebra contracts to the Galilei algebra (İnönü and Wigner). As $c\to0$ the light cones close and the result is the Carroll algebra. A free Carroll particle cannot move at all, so Aristotle's first law returns at the far end.
:::

### Mass in the algebra {kind=derive at=the-algebra-of-free-motions}

For a free relativistic particle the boost generator is $K_i=(H/c^2)\,x_i-t\,p_i$, with $H=\sqrt{p^2c^2+m^2c^4}$. Compute $\{K_i,p_j\}$ and take $c\to\infty$. What does the result say mass is?

::: answer
$H$ depends on the momenta only, so it commutes with $p_j$, and $\{x_i,p_j\}=\delta_{ij}$. Hence $\{K_i,p_j\}=(H/c^2)\,\delta_{ij}$. As $c\to\infty$, $H/c^2\to m$, and the bracket becomes $m\,\delta_{ij}$. In the Galilei group proper a boost and a translation commute, so mass enters as a central extension, the one Bargmann found in the group's projective representations. Mass measures how much a change of velocity fails to commute with a change of place.
:::

### Why the ladder climbs {kind=explain at=the-algebra-of-free-motions}

State Faddeev's criterion and apply it to the rotations and boosts of Newton's world. What does the criterion leave unsettled?

::: answer
An algebraic structure is stable if every small deformation of it is equivalent to it. With commuting boosts the algebra is not stable: the bracket of two boosts can be switched on as a small multiple of a rotation, and with parameter $-1/c^2$ the result is the Lorentz algebra. The Lorentz algebra is semisimple, and semisimple algebras are stable. Faddeev reads quantum mechanics the same way, as a deformation of classical mechanics with parameter $\hbar$, and calls both revolutions "deformations from unstable structures into stable ones." Two things stay unsettled. The opposite sign of the parameter gives the rotation algebra of four-dimensional Euclidean space, so experiment selects the sign. And the top is not stable: the Poincaré algebra still deforms to the de Sitter algebras, and Mendes found a stabilizing deformation of relativistic quantum mechanics that points to a fundamental length.
:::

### Two stabilities {kind=distinguish at=the-algebra-of-free-motions}

Applied to dynamics instead of symmetry algebras, stability points the other way. Explain with the pendulum. What protects Newton's first law, and what protects Liouville's theorem?

::: answer
A system is structurally stable if every small perturbation of its equations leaves its phase portrait topologically the same. A frictionless pendulum swings on closed orbits, and the slightest friction turns them into spirals. So conservative systems are structurally unstable among all systems, and gradient flows, in which every motion runs downhill, are the robust ones. Stability depends on which perturbations one allows: among symmetry algebras the ladder climbs toward Lorentz, and among all dynamics Aristotle's first law is generic and Newton's is fragile. Newton's first law holds where invariance under spatial translations protects it, by conserving momentum. Liouville's theorem is protected by the Hamiltonian form of the equations, and friction breaks both.
:::

### Passive and active invariance {kind=distinguish at=a-computational-physics-must-earn-its-first-law}

Define the two. Why does the first deliver the second in a continuum theory and not in a rewriting system? Is Life's trouble that its speeds are quantized?

::: answer
Passive invariance: the description does not depend on the observer's frame. Causal invariance supplies it, since every slicing of the causal graph describes the same graph. Active invariance: a body at rest has a moving twin, the same body at another speed, and a small boost changes the body only a little. In a continuum theory a boost acts on states, so a symmetry of the description carries every body to its twin. In a rewriting system a moving body is a pattern that the rule rebuilds at each new place, and nothing guarantees such a pattern at each speed. Life's trouble is gaps, not quantization: a small boost of a glider is no glider at all.
:::

### The carriers' cap {kind=explain at=a-computational-physics-must-earn-its-first-law}

Gorard and Wolfram treat the speed of light differently. How? Which speed would observers in a rewriting universe measure as invariant, and where has physics seen relativity emerge this way?

::: answer
Gorard takes the light cones of the causal graph as the light cones of space-time, so the constancy of $c$ holds by his definition of edge lengths. The essay calls that a convention of the derivation. Wolfram's $c$ is statistical, the speed of the "average border" of the causal cone, and he suspects that a "space demon" with enough computation could move faster. On his account the substrate allows faster influence than the typical carrier achieves. Life shows the same gap: its rule bounds influence at one cell per generation, and no ship in empty space exceeds $c/2$. Observers built from the carriers would measure the carriers' cap as the invariant speed. Sound in a flowing fluid and electrons in graphene are the precedents: Lorentz symmetry holds for slow excitations, with a speed below the substrate's own, and fails at high energies.
:::

### Michelson–Morley in Life {kind=compute at=a-computational-physics-must-earn-its-first-law}

In Life no ship in empty space exceeds $c/2$ along an axis, and every cell updates at once. A machine rides a ship east at $c/4$ and signals with ships. Relative to itself, how fast can a signal leave it forward, and how fast backward? What can it compute from the two? The diagonal cap is one cell in each coordinate every four generations: what is that in Euclidean cells per generation? Which condition on an emergent $c$ does Life fail?

::: answer
The caps are fixed in the lattice's frame, so velocities add as Galileo said. Forward the signal gains $c/2-c/4=c/4$ on the machine, and backward it recedes at $c/2+c/4=3c/4$. Half the difference is the machine's velocity relative to the lattice, so in Life the Michelson–Morley experiment would succeed. The diagonal cap is $\sqrt2/4\approx0.35$ cells per generation, against $0.5$ along an axis. The condition: every carrier of information must share the same cap, or any faster channel must stay unusable. Life's caps depend on the direction, on the medium (a lightspeed wire carries signals twice as fast as any ship) and on the lattice's frame.
:::

### The obstacle {kind=object at=a-computational-physics-must-earn-its-first-law}

State the Bombelli–Henson–Sorkin theorem and its corollary. Gorard claims compatibility in two steps. What are they, and what does the essay say each leaves?

::: answer
The theorem: no measurable rule can pick out a timelike direction from a random scattering of points in Minkowski space while respecting Lorentz symmetry. The corollary: no graph in which each point has finitely many neighbors can be attached to such a scattering in a Lorentz-invariant way, and the causal graphs of rewriting rules have finitely many edges at each event.

Gorard's first step is that a preferred direction would imply a preferred foliation, which foliation invariance excludes. The essay answers that this is passive invariance again. It shows that no slicing is needed to generate the graph, not that the finished graph has no structure that picks out a frame, and Gorard's own example, a regular grid, has such structure. His second step concedes the corollary for the microscopic graph and claims Lorentz invariance for an effective network, coarse-grained into large classes of events. The classes are defined by a choice of foliation, and the paper does not show that the result is the same for every choice. What survives is approximate Lorentz invariance, which can be tested.
:::

### Three prices {kind=recall at=a-computational-physics-must-earn-its-first-law}

Discrete models of motion have kept relativity at a price. Give the three precedents and the price each pays. Where does a deterministic rewriting rule sit?

::: answer
- A lattice has a rest frame. A defect in a crystal glides against a periodic resistance, the Peierls–Nabarro barrier, which falls off exponentially with the defect's width, and it radiates vibrations and slows. The first law holds up to an exponentially small friction: "Aristotle at the Planck grain."
- A causal set, a random substrate, keeps exact Lorentz symmetry and has no rest frame. Dowker, Henson and Sorkin found that a massive particle on it swerves: its momentum diffuses, and the first law holds only on average.
- A quantum cellular automaton has the Lorentz group as an exact limit at low energies. At the Planck scale the covariance is nonlinearly distorted (Bisio, D'Ariano and Perinotti).

A deterministic rewriting rule sits between these cases. If its causal graph has a preferred slicing, its particles should feel Aristotelian friction; if the graph has no structural frame, they might swerve. Either outcome is a prediction with an experimental bound attached, and neither has been derived.
:::

### The test, and what is open {kind=limits at=a-computational-physics-must-earn-its-first-law}

State the theorem the essay sets as the test of a computational physics. What does the essay count as already derived? Which of its claims does it mark as a suggestion, a report, or its own reading?

::: answer
The test is a theorem: a natural class of rules under which persistent structures have moving twins across the range of speeds below $c$, with no gaps, so that neighboring speeds are carried by nearly the same body. Derived, in Heller's terms, is the geometry: Gorard's discrete Lorentz covariance and vacuum Einstein equations, under assumptions that include a well-behaved continuum limit. The first law is not derived.

Marked as less than established:

- That such a class of rules needs a discrete analogue of conserved momentum is what the qualitative theory "suggests".
- Wolfram thinks it "quite likely" that pure motion is inevitable. The only exhibited particle-like structures live on one-dimensional or grid-like backgrounds, and the essay reports: "I found no work since 2024 that changes this."
- Exact Lorentz symmetry "may be out of reach" for a discrete substrate.
- Reading Wolfram's observer-based account as selection is "my reading rather than his argument". It would make the first law a postulate about observers, and a postulate cannot be checked against the rule.
:::
