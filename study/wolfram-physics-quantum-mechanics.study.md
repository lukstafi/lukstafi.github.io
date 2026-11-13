---
title: "Study notes: Quantum Mechanics, Observers, and the Ruliad"
essay: wolfram-physics-quantum-mechanics
track: physics-and-reality
reviewed-against: "c542323"
requires:
  - {at: causation-computation-indexicality, for: "the claim that causation and computation are one generative primitive, and that physics describes its regularities", strength: helpful}
introduces:
  - {term: hypergraph rewriting, at: the-starting-point-hypergraph-rewriting}
  - {term: causal graph, at: the-starting-point-hypergraph-rewriting}
  - {term: multiway system, at: the-source-of-quantum-behavior-non-determinism-and-multiway-systems}
  - {term: confluence, at: confluence-causal-invariance-and-their-tension}
  - {term: causal invariance, at: confluence-causal-invariance-and-their-tension}
  - {term: measurement as Knuth-Bendix completion, at: measurement-as-knuth-bendix-completion}
  - {term: branchlike hypersurface and foliation, at: measurement-as-knuth-bendix-completion}
  - {term: multiway invariance, at: multiway-relativity-quantum-mechanics-as-general-relativity-in-branchial-space}
  - {term: bounded and persistent observer, at: the-observer-as-the-source-of-physical-law, gloss: "Wolfram's two conditions on an observer: computationally bounded, and persistent in time"}
  - {term: Ruliad and rulial space, at: the-ruliad-why-the-choice-of-rule-shouldnt-matter}
  - {term: universality conjecture, at: the-ruliad-why-the-choice-of-rule-shouldnt-matter}
---

The essay is an exposition of a programme by Wolfram, Gorard and their collaborators. The answers report what the programme claims and name the claimant where the essay does. The last question asks which claims the essay counts as established.

### One primitive {kind=state at=the-starting-point-hypergraph-rewriting}

What is the model's single dynamical primitive? How do space and time arise from it, and what is Gorard's result for gravity?

::: answer
The universe is a hypergraph, a graph whose edges may join any non-empty set of vertices. A law of physics is a rule $H_1\to H_2$: a subhypergraph matching $H_1$ is replaced by one matching $H_2$. Space is the large-scale limit of the hypergraph, defined by its connectivity alone, with no background manifold. Time comes from the causal graph. Its vertices are rewriting events, and event B depends on event A if B's input uses hyperedges that A's output produced. Gorard's result is that requiring the causal graph to keep a fixed limiting dimension is equivalent to a discrete form of the Einstein field equations.
:::

### Dimension by counting {kind=compute at=the-starting-point-hypergraph-rewriting}

Around some vertex, $500$ vertices lie within distance $10$ and $4{,}000$ within distance $20$. What is the dimension there, if the region is flat? In a two-dimensional region with scalar curvature $R=0.06$, by what fraction does the count within distance $2$ fall short of the flat value?

::: answer
A flat region has $N(r)\sim ar^n$. Doubling $r$ multiplies the count by $8=2^3$, so $n=3$. With curvature, $N(r)=ar^n\bigl(1-\frac{R\,r^2}{6(n+2)}+\dots\bigr)$, where $R$ is the Ollivier-Ricci scalar curvature. Here the correction is $0.06\times4/24=0.01$: one percent fewer vertices than in flat space.
:::

### One path and all paths {kind=distinguish at=the-source-of-quantum-behavior-non-determinism-and-multiway-systems}

Why is the evolution non-deterministic? What does a single path through the multiway system correspond to, and what does the whole system correspond to?

::: answer
A rule may match several subhypergraphs at one step, and different choices give different successor states. The multiway system is a directed acyclic graph that holds every choice: each vertex is a hypergraph state and each edge is one rewrite. A single path is one updating order. It is a deterministic, classical history, and the essay also calls it a choice of gauge. The whole system is claimed to be the quantum state, with its branching in the role of superposition and entanglement.
:::

### Two demands on one rule {kind=explain at=confluence-causal-invariance-and-their-tension}

General relativity and quantum mechanics ask opposite things of the rewriting system. What are they, and how does the model reconcile them?

::: answer
A system is confluent if two rewrite sequences that diverge from a common ancestor can always be brought to a common descendant. Confluence implies causal invariance: every path through the multiway system yields the same causal graph. Causal invariance is the discrete analog of general covariance, with the updating order as the coordinate choice and the causal graph as the invariant content. Quantum mechanics needs branches that do not reconverge, because branching encodes superposition. A globally confluent system would be a classical universe. The reconciliation: the fundamental rule need not be confluent, and an observer embedded in the multiway system imposes an effective confluence.
:::

### Measurement as completion {kind=explain at=measurement-as-knuth-bendix-completion}

What does the Knuth-Bendix algorithm do, and how does Gorard read it as measurement? Why does one observer's completion make the rest of the universe look classical?

::: answer
The algorithm takes a non-confluent rewriting system and adds rules that force unresolved critical pairs to converge. A critical pair is two states that descend from a common ancestor and fail to reconverge. Gorard proposes that this completion is formally equivalent to measurement: the observer's coarse-graining identifies distinct branches and leaves one effective history. If the observer is macroscopic enough to be a statistically representative sample of the hypergraph, the minimal rules that make its own representation causally invariant also make the rest of the universe appear so. The added rules can also make new states reachable, which the essay reads as interference between neighboring branches.
:::

### Path counts are not amplitudes {kind=object at=measurement-as-knuth-bendix-completion}

Each state on a branchlike hypersurface is weighted by the number of paths that lead to it. Path counts are positive integers, and positive integers cannot cancel. How does the essay answer?

::: answer
The counts are the magnitudes of discrete proto-amplitudes. Complex amplitudes appear only in the continuum limit, when the branchial geometry acquires a complex metric signature. The phases come from the imaginary component of the multiway-Minkowski norm, which encodes branchlike separation. Interference is therefore a property of the geometry in which the hypersurfaces are embedded. It is not visible on a single hypersurface.
:::

### The observer and its frame {kind=distinguish at=measurement-as-knuth-bendix-completion}

Define a branchlike hypersurface, an observer, and a branchlike foliation. How do the last two differ?

::: answer
A branchlike hypersurface is a slice of the multiway graph at one time step: all the states that coexist then, separated in the branch direction. An observer is a persistent structure inside the multiway system that perceives a single definite history. It is embedded, not external, and its own local branch pairs must converge. A branchlike foliation is an ordered sequence of non-intersecting branchlike hypersurfaces that covers the graph, and each observer induces one. "The foliation is not the observer; it is the observer's reference frame."
:::

### Uncertainty from order {kind=explain at=the-uncertainty-principle-from-non-commuting-rewrites}

When do two rewriting relations commute? How does the uncertainty relation follow from those that do not?

::: answer
Two relations commute if branches that diverge under them from a common state can always be made to reconverge, whatever the order of application. A system is confluent exactly when it commutes with itself. In a non-confluent system some pairs of updating events do not commute, and the outcome depends on their order. Read as linear operators on the limiting Hilbert space, the rewrite relations then have the commutator structure of quantum mechanics. Observables that correspond to non-commuting relations are measured on distinct branches, and that limits how precisely both can be prepared at once.
:::

### Three steps to Hilbert space {kind=recall at=branchial-geometry-and-the-convergence-to-projective-hilbert-space}

Gorard's convergence proof passes through three metrics. Name them in order. The multiway-Minkowski norm is $\|(t,x,y)\|=\|x\|^2+i\|y\|^2-(1+i)t^2$, with $x$ spatial and $y$ branchial: evaluate it for a unit step in space, in the branch direction, and in time. Why must it be complex?

::: answer
- The combinatorial distance on a branchial hypersurface equals, up to a constant, the information distance: the length of the shortest program that turns each of two states into the other.
- In the continuum limit the information distance converges to the Fisher information metric.
- Extended to complex projective spaces, the Fisher metric becomes the Fubini-Study metric.

The norm takes the values $1$, $i$ and $-(1+i)$. The multiway causal graph has three kinds of separation between events: spacelike, branchlike and timelike. By Sylvester's law of inertia, keeping all three distinguishable for every observer requires eigenvalues with at least three distinct signs, and that requires complex numbers. The Hilbert space is projective because one mods out by the nonzero complex numbers, a rescaling that leaves the combinatorial structure of the multiway graph unchanged.
:::

### Relativity in the branch direction {kind=recall at=multiway-relativity-quantum-mechanics-as-general-relativity-in-branchial-space}

State the principle of multiway invariance. What plays the role of gravitational time dilation, and how does the model satisfy Bell's theorem?

::: answer
The ordering of timelike-separated measurement events is the same under every branchlike foliation, that is, for every observer. The ordering of branchlike-separated events is not. The principle is the analog of Lorentz invariance for "branchtime". The quantum Zeno effect plays the role of time dilation: more frequent measurement is a steeper foliation, and the perceived evolution slows, so that the maximum entanglement rate is not exceeded. Bell's theorem is met through nonlocality. The multiway causal graph connects events on distinct branches, which gives a nonlocal, deterministic theory that violates the CHSH inequality as de Broglie-Bohm theory does.
:::

### What makes an observer {kind=state at=the-observer-as-the-source-of-physical-law}

Name the two features that make an observer, and say what each forces. In what sense does the multiway system not "generate" quantum mechanics?

::: answer
The observer is computationally bounded. It cannot reverse-engineer the irreducible computation of individual rewrites, so it must treat vast numbers of distinct microstates as equivalent. The observer is persistent in time. It keeps one thread of experience across the branching, so it must resolve the branching into a definite history. That resolution is the completion of the earlier section, now a consequence of being an observer and not an operation imposed from outside. Quantum mechanics is what the multiway system looks like to such an observer, as fluid mechanics is what molecular dynamics looks like to an observer who cannot track molecules. Observers with other bounds or another kind of persistence would in principle extract other effective laws.
:::

### Physics from somewhere {kind=argue at=a-philosophical-connection-indexicality-causation-and-the-observers-constitution}

The essay sets Wolfram's two features of an observer beside its authors' own metaphysics. What does each feature become there? Where do the two frameworks reach the same conclusion?

::: answer
Computational boundedness is what makes the observer a finite mind and not a Laplacian demon. Persistence in time is what makes it an indexical being, a "this" progressing through a world. The authors had argued that without a representing mind there is no fact of the matter whether a universe is real or merely mathematical. The essay finds the same structure in the Wolfram model: without an observer the multiway system has no distinguished foliation, no definite history, no measurement outcomes and no effective laws. "The raw Ruliad, viewed from nowhere, has no physics. Physics is what the Ruliad looks like from somewhere."
:::

### Where an observer stands {kind=recall at=the-ruliad-why-the-choice-of-rule-shouldnt-matter}

What is the Ruliad? Along which three axes is an observer located in it, and what does the universality conjecture claim?

::: answer
The Ruliad is the multiway system of every rule run on every initial condition, and there is only one. An observer has a position in physical space (which part of the hypergraph it occupies), in branchial space (which branch it is on) and in rulial space (which neighborhood of rules it samples). The three positions determine which galaxies it sees, which measurement outcomes it perceives, and which effective laws it experiences. The conjecture is that every position in rulial space that supports an observer gives the same large-scale physics: something like quantum mechanics and something like general relativity. If it holds, asking which rule is the correct law is the wrong question. The open problem becomes to prove that structure like the Standard Model's is generic across the relevant region of rulial space.
:::

### Established and conjectural {kind=limits at=what-this-is-and-what-it-isnt}

Which results does the essay list as rigorously established, and what does it leave conjectural or open?

::: answer
Listed as established:

- the multiway geometry converges to complex projective Hilbert space, with the Fubini-Study metric;
- the multiway system is a dagger-symmetric compact-closed monoidal category, and the ZX-calculus embeds in it;
- the branchial metric is an entanglement monotone, and the branchial and Sorkin-Johnston entropies are monotonically related across large classes of rules;
- the uncertainty principle, the path integral, the discrete Schrödinger equation, compatibility with Bell's theorem and the Zeno effect follow from multiway geometry and multiway invariance.

Left open:

- quantum mechanics as the unique continuum limit, with decoherence and the Born rule derived from multiway geometry and not by analogy with Knuth-Bendix completion;
- the physical consequences of the multiway Einstein equations;
- whether the Standard Model is generic in the Ruliad;
- whether locality in rulial space can be defined without presupposing an observer's coarse-graining ([the Ruliad section](/notes/wolfram-physics-quantum-mechanics.html#the-ruliad-why-the-choice-of-rule-shouldnt-matter));
- whether the finite-size corrections to branchial geometry carry computability-theoretic signatures ([the branchial section](/notes/wolfram-physics-quantum-mechanics.html#branchial-geometry-and-the-convergence-to-projective-hilbert-space)).
:::
