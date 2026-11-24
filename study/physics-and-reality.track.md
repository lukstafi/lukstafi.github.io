---
title: "Across the track: Physics and reality"
track: physics-and-reality
---

## Physics for bounded observers

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

## Structure and what answers to it

Questions that draw on *What a Description Answers To* together with the pages it builds on, and on its companion, *What Mary Could Not Build*.

### One requirement, stated twice {kind=connect}

*The Standard of Motion* ends on a test that a rewriting rule must pass. *What a Description Answers To* makes a requirement on physics. How are the two related, and what does the later essay take from the earlier one's obstacle?

::: answer
The earlier essay distinguishes passive invariance, the independence of a description from the observer's frame, from active invariance, the existence of the transformed thing, and says the test is a theorem: a natural class of rules under which persistent structures have moving twins across the range of speeds ([essay](/notes/the-standard-of-motion.html#a-computational-physics-must-earn-its-first-law)). The later essay applies the same distinction to a shift of base. That rules can emulate one another is passive. That physics exists, as the same pattern, over each base of a region is active, and it is "a theorem nobody has" ([essay](/notes/what-a-description-answers-to.html#bases-and-where-we-are)). From the obstacle, that exact Lorentz symmetry seems to need unboundedly many causal neighbours while a finite rule gives finitely many, it draws a wider reading: physics may be a pattern in the applications of many rules taken together. Its list of what would change the author's mind restates the earlier test: if rules in general slow a free body or make it swerve, inertia holds only over rules chosen to protect it.
:::

### Is a rule a frame? {kind=connect}

The exposition of the Wolfram model treats an observer's foliation as its reference frame and places observers at locations in rulial space. What does *What a Description Answers To* deny about rules and frames, and on what ground?

::: answer
In the exposition different observers induce different foliations, "just as different observers in general relativity induce different foliations of spacetime" ([exposition](/notes/wolfram-physics-quantum-mechanics.html#measurement-as-knuth-bendix-completion)), and an observer samples a neighbourhood of rules ([exposition](/notes/wolfram-physics-quantum-mechanics.html#the-ruliad-why-the-choice-of-rule-shouldnt-matter)). The later essay holds that a base is a process and not a frame. A frame is a description, and if bases were descriptions their production would fall on the modal side and the regress of section three would start again. Against the stronger reading, one Ruliad with each rule a frame on it, it replies that the Ruliad taken all at once, as one object, would be a structure and so a description, with nothing that generates. What generates is each application of a rule ([essay](/notes/what-a-description-answers-to.html#bases-and-where-we-are)).
:::

### Esse and measure, carried forward {kind=connect}

*Presence and Actuality* granted Thomas's second tier, could not see what *esse* adds, and left reality measure unresolved. What does *What a Description Answers To* add on each point, and what does it still leave open?

::: answer
The earlier essay: "we cannot grant that it exists and then ask whether it additionally possesses existence" ([essay](/notes/presence-and-actuality.html#what-does-michał-mean-by-actuality)), and the problem of reality measure, how occurrences should be counted or weighted, stays unresolved ([essay](/notes/presence-and-actuality.html#suffering-and-reality-measure)). The later essay gives *esse* a place in closure: a perfectly closed level is a base when taken in itself, so a pattern has production of its own in the limit of closure and by degrees short of it ([essay](/notes/what-a-description-answers-to.html#what-makes-a-thing-one)). It expects a Thomist to reply that a degree of closure still describes what a thing is. On measure it says only what kind of thing a measure would be: a count of ways of being generated, and not a weight that occurrences carry, so that chances enter with types as counterfactuals do. It lists the measure as a debt and does not answer how much what occurs elsewhere counts for ([essay](/notes/what-a-description-answers-to.html#a-thesis-with-a-hostage)).
:::

### Production is not a quiddity {kind=connect}

*What a Description Answers To* answers van Fraassen by granting that structure needs something that is not structure. *What Mary Could Not Build* faces the charge that this gives it a quiddity of its own. How does the second essay use the first's answer, and what does it add?

::: answer
The first essay accepts what van Fraassen's second option demands and denies its cost: "Something that is not structure is needed, and it is production. Production is not a bearer." A bearer is what it is apart from its structure, and an occurrence individuated by what it came from is nothing apart from the generation ([essay](/notes/what-a-description-answers-to.html#counterfactuals-come-with-descriptions)). The second essay grants Alter that beneath structure there is no nature, for the same reason: an occurrence has no character of its own that a lesson could leave out ([essay](/notes/what-mary-could-not-build.html#what-i-grant)). Against the Russellian it adds what a quiddity is asked to do and production is not. A quiddity is a nature that experience is said to be made of. Production has nothing in it to be acquainted with, and a stone is produced as much as an experience is ([essay](/notes/what-mary-could-not-build.html#russellian-monism)). It also adds a contrast over laws: Alter has to posit a law that ties a quiddity to the disposition it underlies, while an experience, being an organization at a grain, needs no law to join it to the physics.
:::

### Describable, conceivable, possible {kind=connect}

The first essay postulates that what descriptions answer to is not one more description, and says what the postulate buys. The second uses the postulate against the view of possibility behind Alter's bridge principle. Trace the connection, and say what the stone and the zombie have in common.

::: answer
The first essay says that if the whole of what is generated were abstract, "Every structure that can be coherently described would have the same standing", and to describe a thing would be to show that it exists ([essay](/notes/what-a-description-answers-to.html#bases-and-where-we-are)). Its account of what is possible is that the stone's hitting the window is possible if a support for it could be rebuilt, level by level, down to a base, which we imagine in a toy model that is a proxy and "can skip a step" ([essay](/notes/what-a-description-answers-to.html#the-neighbours)). The second essay turns both on Chalmers, for whom what is coherent to describe is possible once the description is ideal. It answers that a description does not make a possibility, that restricting the possible to what can be built removes a modal primitive and adds none, and that this rests on the postulate ([essay](/notes/what-mary-could-not-build.html#possible-and-conceivable)). The stone and the zombie are both conceived by an imagined rebuilding. The stone's hitting survives it. The zombie is conceived by skipping a step, since a physical duplicate imagined in the full detail of the physics already has the organization at the grain of experience.
:::
