---
title: "Across the track: Physics for bounded observers"
track: physics-and-reality
stage: physics-for-bounded-observers
---

Questions whose answers draw on more than one page. Attempt them after the mathematics page.

### Derived and not derived {kind=connect}

The exposition reports what Gorard derived from causal invariance. What is it? How does *The Standard of Motion* qualify the report, and what does it say is still missing?

::: answer
The exposition: confluence implies causal invariance, the discrete analog of general covariance, and Gorard proved that causal invariance implies discrete analogs of Lorentz covariance and the Einstein field equations ([exposition](/notes/wolfram-physics-quantum-mechanics.html#confluence-causal-invariance-and-their-tension)). *The Standard of Motion* calls this the geometry, in Heller's terms, and states the conditions: the vacuum equations, with further assumptions, a well-behaved continuum limit among them. The first law is the other half, and it is open ([essay](/notes/the-standard-of-motion.html#a-computational-physics-must-earn-its-first-law)). Causal invariance does not supply it, because it is passive. It says that every slicing describes the same causal graph, not that a body has a moving twin.
:::

### What re-slicing shows {kind=connect}

A change of foliation appears on all three pages. What does each page say it shows?

::: answer
- The exposition: different updating orders are different foliations of one causal graph, as coordinate charts are different descriptions of one space-time. An observer's foliation is its reference frame ([exposition](/notes/wolfram-physics-quantum-mechanics.html#measurement-as-knuth-bendix-completion)).
- The essay: re-slicing one fixed causal graph is passive invariance. Gorard's Lorentz argument and Wolfram's entry for motion ("associated with change of causal foliations") rest on it, and it supplies no moving twin ([essay](/notes/the-standard-of-motion.html#a-computational-physics-must-earn-its-first-law)).
- The mathematics page: against the Bombelli–Henson–Sorkin theorem, invariance under changes of foliation establishes independence of the slicing. It does not establish the absence of an equivariantly definable direction in the graph itself ([mathematics](/notes/the-standard-of-motion-mathematics.html#the-bombellihensonsorkin-theorem)).
:::

### What a bounded observer cannot do {kind=connect}

The exposition makes computational boundedness one of the two features of an observer. Where does *The Standard of Motion* rely on boundedness, and where does it decline to rely on observers?

::: answer
In the exposition boundedness forces the observer to coarse-grain. In rulial space, the exposition suggests as a partial answer, it plays the role the speed of light plays in physical space: an observer samples only the rules it has the resources to reach ([exposition](/notes/wolfram-physics-quantum-mechanics.html#the-ruliad-why-the-choice-of-rule-shouldnt-matter)). The essay applies it to physical space itself. Wolfram's "space demon" could outrun $c$ with enough computation, and his answer is that scaling this up needs resources nobody could muster. If that holds, the cap holds for computationally bounded observers, "and relativity becomes a law about what such observers can do." The essay declines the same move for the first law. Read as selection, Wolfram's observer-based account of pure motion would make the first law a postulate about observers, and "a postulate cannot be checked against the rule, and a theorem can" ([essay](/notes/the-standard-of-motion.html#a-computational-physics-must-earn-its-first-law)).
:::

### Momentum as a price {kind=connect}

The essay says that momentum is the price of a constraint. Derive the claim as the mathematics page does. Where does the sign in Hamilton's equations come from?

::: answer
Make velocity a separate variable $v$ and enforce $\dot x=v$ with a multiplier $p(t)$: $S=\int\bigl[L(x,v)+p\cdot(\dot x-v)\bigr]dt$. Varying $v$ gives $p=\partial L/\partial v$, so the multiplier is the momentum. Eliminating $v$ leaves $S=\int(p\cdot\dot x-H)\,dt$ with $H=p\cdot v-L$, which is the essay's sentence: "The Hamiltonian is what remains of the Lagrangian once the price is paid" ([essay](/notes/the-standard-of-motion.html#one-bracket-three-mechanics)). Varying $p$ gives $\dot x=\partial H/\partial p$. Varying $x$, the term $p\cdot\dot x$ must be integrated by parts, which gives $\dot p=-\partial H/\partial x$. The sign flip, and with it the right-angle turn that keeps phase-space volume, comes from that integration by parts ([mathematics](/notes/the-standard-of-motion-mathematics.html#one-bracket-three-mechanics)).
:::

### Quantized is not the trouble {kind=connect}

The essay says that Life's problem "is not that its speeds are quantized but that they have gaps". Which result on the mathematics page backs the first half? How does each page state the test a rule must pass?

::: answer
Fact 2: a ship with speed $r/q$ whose phases fit in a box of area $A$ has $q\le2^A$. Resolving a speed to precision $1/q$ costs only $\log_2q$ cells, so for patterns of macroscopic size counting forbids no speed an observer could resolve ([mathematics](/notes/the-standard-of-motion-mathematics.html#moving-patterns-in-a-cellular-automaton)). The gap is in which speeds the dynamics realizes, and by what: the glider's nearest neighbors in speed are unrelated ships. The mathematics page states the test for carriers: they must come in families where neighboring speeds are realized by nearly the same pattern, at the scale an observer resolves. The essay states it as a theorem to be proved: a natural class of rules whose persistent structures have moving twins across the range of speeds below $c$, with no gaps ([essay](/notes/the-standard-of-motion.html#a-computational-physics-must-earn-its-first-law)).
:::
