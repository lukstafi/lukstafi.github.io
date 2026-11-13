---
title: "Study notes: The Given and the Found"
essay: the-given-and-the-found
track: structure-in-networks
reviewed-against: "2fd78b8"
requires:
  - {at: who-teaches-the-weights, for: "the collapse onto one strategy under on-policy reinforcement learning, and Vector Policy Optimization as a remedy", strength: helpful}
introduces:
  - {term: correctness condition, at: three-things-the-field-conflates, gloss: "what makes an answer right: a fact about the task, prior to any network"}
  - {term: landscape and search, at: three-things-the-field-conflates, gloss: "the learned dynamics whose attractors are a trained surrogate for the condition, and the trajectory followed through it at inference"}
  - {term: spectrum of givenness, at: the-spectrum-of-givenness, gloss: "how much of the correctness condition is guaranteed by construction, and how much is approximated by a surrogate trustworthy only in distribution"}
  - {term: sound but incomplete deduction, at: the-spectrum-of-givenness}
  - {term: spurious attractor, at: convergence-is-not-self-certifying, gloss: "a stable, low-residual state that decodes to the wrong answer"}
  - {term: convergence as a learned proxy, at: convergence-is-not-self-certifying, gloss: "the system's internal signal of having settled is a trained artifact, calibrated only as far as the data that shaped it"}
  - {term: depth and breadth, at: depth-and-breadth-are-two-knobs-not-one, gloss: "iterations within one trajectory, which entrench its basin, and independent restarts, which cover more basins"}
  - {term: limit cycle as terminal behavior, at: depth-and-breadth-are-two-knobs-not-one, gloss: "a single trajectory that visits the valid answers in turn and does not settle; the essay's own suggestion"}
  - {term: amortization as learning and as efficiency, at: amortization-is-learning, gloss: "raising the ceiling attainable at fixed data, against cutting the compute needed to reach a ceiling already attainable"}
  - {term: equilibrium internalization, at: amortization-is-learning}
  - {term: manufactured target, at: the-engine-is-signal-amplification, gloss: "a training target produced by a confident intermediate computation, such as a converged loop state or a search's visit counts"}
  - {term: amplitude and sign of a learning signal, at: the-engine-is-signal-amplification, gloss: "the target's confidence sets the size of the update; whether the target is grounded in truth sets its direction"}
  - {term: grounded and ungrounded targets, at: the-engine-is-signal-amplification}
  - {term: underdetermination of the landscape, at: the-engine-is-signal-amplification, gloss: "supervision constrains the model only along the trajectories training visits and leaves the rest free"}
  - {term: optimal granularity, at: the-engine-is-signal-amplification, gloss: "the step size at which the pull toward fewer, bigger steps balances the difficulty of learning a bigger step"}
  - {term: amortizing search versus amortizing discovery, at: the-boundary-amortizing-search-versus-amortizing-discovery, gloss: "speeding up search under a correctness condition that is given, against finding the condition"}
uses:
  - {term: Vector Policy Optimization, from: who-teaches-the-weights}
---

The answers state what the essay argues. Where a reading is the essay's own and not that of the papers it draws on, the answer says so. The last question collects what the essay marks as unsettled.

### A regularizer toward correctness {kind=explain}

At inference a fixed operator $f_\theta$ injects no information it did not already encode. Why is iterating it to a fixed point not idle all the same? Which analogy does the essay draw?

::: answer
A fixed point is a state that $f_\theta$ leaves unchanged, so requiring one admits only answers that are self-consistent under the learned dynamics. In an aligned landscape, self-consistency correlates with correctness. The requirement is therefore a regularizer toward correctness, structurally like a simplicity bias toward generalization. Neither contains the answer. Each tilts the search toward it under favorable conditions and toward a confident mistake under unfavorable ones. A self-consistent state that is wrong is the analogue of the simplest hypothesis that is false.
:::

### Three things the field conflates {kind=distinguish at=three-things-the-field-conflates}

Name the three objects in play when an iterative reasoner solves a puzzle. Which of them does the iteration act on, and where does the essay say the interesting questions lie?

::: answer
The correctness condition is what makes an answer right: Sudoku's constraints, a reward, an energy. It is a fact about the task, prior to any network. The landscape is the learned dynamical system, whose attractors are supposed to coincide with answers that satisfy the condition. Training produces it, and it is an imperfect surrogate. The search is the trajectory actually followed at inference, restarts included, paid for by iterations and parallel runs. The iteration acts on the landscape and the search; the condition comes from somewhere else. The interesting questions sit at the seams: where the condition comes from, how faithfully the landscape approximates it, and when traversing the landscape finds answers to the condition and not to its surrogate.
:::

### The spectrum of givenness {kind=recall at=the-spectrum-of-givenness}

Order the four families of systems from most to least guaranteed by construction. For each, say what is given and what is left to training.

::: answer
- *Energy-based models.* Someone wrote the energy down, and inference descends it. Convergence is a theorem.
- *The Lattice Deduction Transformer.* The architecture guarantees the form of soundness, since the dynamics live on a lattice and can only remove candidates. Training supplies the strength of the deduction.
- *MuZero.* The condition is given, because the environment supplies reward. The search runs on a learned, value-equivalent model that is faithful where MuZero already plays and unreliable off-policy. The policy prior keeps the search where the surrogate holds.
- *Pure learned dynamics* (Equilibrium Reasoners, HRM, TRM, Attractor Models, GRAM). There is no energy, no contraction and no guarantee. Training carries the whole burden of making attractors coincide with solutions.

Down the spectrum, correctness migrates from the architecture into a trained surrogate, and its guarantee weakens from "theorem" to "holds where we trained it".
:::

### Deduction on a lattice {kind=compute at=the-spectrum-of-givenness}

LDT's abstract state gives each Sudoku cell the set of digits still viable. How many binary candidates encode a $9\times9$ state? Now take a toy row of three cells that must hold a permutation of $\{1,2,3\}$, in the state $(\{1,2\},\{1,2\},\{1,2,3\})$. Apply $\mathit{ded}_p(a)=\alpha(\gamma(a)\cap\lVert p\rVert)$. The essay calls the operator "sound by design but incomplete". What does that say about the trained approximation?

::: answer
$9\times9\times9=729$. The concretization $\gamma(a)$, intersected with the valid solutions, leaves the permutations $(1,2,3)$ and $(2,1,3)$. Abstracting back gives $(\{1,2\},\{1,2\},\{3\})$: candidates 1 and 2 leave the third cell because they survive in no valid solution. Deduction descends the lattice and only removes candidates. The trained operator approximates $\mathit{ded}_p$. A step may fail to derive a true fact, and it never derives a false one, so the model returns a correct answer or abstains. In the essay's words, "Correctness is architectural; competence is trained."
:::

### Convergence is not self-certifying {kind=explain at=convergence-is-not-self-certifying}

Equilibrium Reasoners measure convergence by the residual $\lVert f_\theta(z;x)-z\rVert$. In a baseline without landscape shaping, choosing the best-converged of several restarts does worse than a majority vote among them. What does that inversion show? Name the four regimes it belongs among, and the one in which "iterate to convergence and trust the result" is valid.

::: answer
If the residual were a good per-instance signal of correctness, the lowest-residual run would win. That it loses means the residual says nothing about which answers are right. A falling residual can mean convergence to a spurious attractor, a stable state that decodes to the wrong answer. The dangerous regime is deployable accuracy paired with a confidence signal that cannot be read.

- (a) No reachable attractor decodes to a correct answer: misalignment, and no amount of compute helps.
- (b) Correct and spurious attractors coexist: the failure is basin selection.
- (c) The correct attractor exists and its basin is too narrow: reachability.
- (d) The well-aligned regime, where residual decay is coupled to error reduction. Only here is trusting convergence valid.

The essay generalizes: wherever the objective at inference is a learned surrogate, the signal of having "figured it out" is a trained artifact, calibrated only as far as its training data.
:::

### Depth and breadth {kind=distinguish at=depth-and-breadth-are-two-knobs-not-one}

Define depth and breadth. In which two situations does more depth fail, and how do the two differ? State the maxim that unifies them and name three brakes that serve it.

::: answer
Depth is the number of iterations in one trajectory, and it entrenches whatever basin the trajectory has entered. Breadth is the number of independent restarts from different initializations, and it covers more basins. The inference budget is their product, but they do different work. Depth fails in the spurious-attractor regime: a trajectory settled on a wrong answer sinks deeper, and the only escape is to start elsewhere. It also fails under genuine multiplicity, where several attractors are all correct. Settling on one is then information loss, not error. Both are premature convergence, and the maxim is *do not over-settle*: keep the distribution alive until the task demands commitment. The brakes are randomized initialization with path noise, which also shape the landscape so that convergence can be trusted; GRAM's stochastic transitions; and LDT's decide-temperature with parallel chains.
:::

### Two senses of amortization {kind=distinguish at=amortization-is-learning}

"Amortize" has two senses that give opposite verdicts. State them and the discriminator between them. What is equilibrium internalization, and why does it have two faces?

::: answer
As learning, the weights change to absorb computation that would otherwise happen at inference, and the ceiling attainable at fixed data rises. As efficiency, the ceiling stays and compute is reallocated: a halting head stops easy instances early, or more training buys fewer deployment steps. The discriminator is ceiling versus cost-to-ceiling. Equilibrium internalization is observed in Attractor Models. Trained only on next-token loss, the backbone's initial guess drifts toward the fixed point, until the solver can be removed at inference with little degradation. The loop self-distills into the feedforward initialization. The same absorbed computation can be cashed as a higher ceiling at a fixed budget or as the same ceiling at lower deployment cost. Which one we observe depends on whether we hold accuracy or compute fixed.
:::

### What is matched {kind=compute at=amortization-is-learning}

A 42-block feedforward Sudoku network is compared with a weight-tied network of 2 blocks run for 21 iterations, each trained on about a thousand examples. What is matched, and by what factor do the parameter counts differ? The tied model scores far higher. What does that show, and why does the headline comparison of the feedforward score with the fully iterated one not show the same thing?

::: answer
$2\times21=42$ block applications, so inference compute is matched, and the tied model has about 21 times fewer parameters. At fixed compute and far fewer parameters, iterative structure raises the ceiling. The gain comes from the structure and not from raw depth, and it appears where data is scarce, which is the signature of help to learning. The headline comparison does not hold test-time effort constant. It shows test-time depth extrapolation: an operator trained at 16 iterations generalizes to over a thousand, which a feedforward network cannot do at all. That is a capability claim, not a measurement of the learning effect.
:::

### Amplitude and sign {kind=derive at=the-engine-is-signal-amplification}

For cross-entropy the gradient scales roughly as (prediction − target). Why is it then false that a confident prediction gets a stronger push? Where does the confidence sit instead? A head now predicts $(0.5,0.5)$: compare the push from the target $(0.95,0.05)$ with the push from $(0.55,0.45)$. What sets the amplitude of a learning signal, and what sets its sign?

::: answer
Against a fixed correct label, a confidently correct prediction has (prediction − target) near zero and contributes almost nothing. The confidence sits on the target side: a confident intermediate computation manufactures a peaked target. In Attractor Models the target is the loop's converged state. In MuZero it is the search's visit counts. In LDT it is the $\alpha$-aggregate of still-consistent solutions. The peaked target gives $(-0.45,+0.45)$ and the diffuse one $(-0.05,+0.05)$, a push nine times weaker. The confidence of the manufactured target sets the amplitude. Whether the target is grounded in truth sets the sign.
:::

### What grounding does and does not do {kind=explain at=the-engine-is-signal-amplification}

What happens to a confident wrong convergence when the target is grounded, and when it is not? Then name two failures that grounding does not prevent, and the cause of each.

::: answer
Grounded targets include a supervised label, LDT's $\alpha$-aggregate computed from real solutions, and an actual game outcome. Against one, a confident wrong convergence meets a large error and is pushed back down: the gradient flattens the wrong basin. With an ungrounded target, such as a policy head regressed onto its own confidently mistaken search, the same strong push writes the error into the weights and biases the next search the same way.

Grounding does not prevent the loss of alternatives. When each step's target is built from the previous iterate, correctly signed pushes compound, and a strategy slightly below the best disappears. Nor does it prevent spurious attractors. They come from underdetermination: output-level supervision constrains the decoded answer only along the trajectories training visits, and the rest of the latent landscape is free to hold stable states the loss never sees. That is why the remedies are geometric. Randomized initialization, path noise and breadth manage coverage of the landscape, not the sign of the push.
:::

### Two forces on step size {kind=argue at=the-engine-is-signal-amplification}

Amplification alone would predict that one big step is best. What refutes that? State the two hypotheses the essay sets against each other, where they settle, and the curriculum that follows. Which recurring design choice does the essay read as paying for learnability?

::: answer
The single-step limit is the feedforward network, which solves a small fraction of the puzzles the iterated operator solves. Hypothesis (1), amplification: compressing toward fewer, bigger steps is self-reinforcing, because a more decisive operator manufactures a more peaked target. Hypothesis (2), learnability: at a fixed parameter count, an operator that must make a bigger change per step is harder to fit. The claim is about fitting, not about a fixed operator computing a big step badly. Both forces act on the operator during training with opposite signs, so they settle at an optimal granularity, finer where the target map is harder. Early in training only a small step is learnable; as competence accrues the step coarsens and the loop compresses. The prescription is to amortize no faster than learnability permits. Deep supervision at every iteration is the field paying to keep each step learnable, and LDT's $\alpha$-operator is the most principled case: it hands over the most precise sound refinement of the current state as the target.
:::

### Shaping the sign {kind=compute at=the-engine-is-signal-amplification}

Two design choices shape the sign of the amplification and not its grain. Name them. Then: across a fourfold increase in LDT's training budget, soundness stays at 100% and inference cost falls from $0.78$ to $0.028$ seconds per example. Compute the reduction. What did training buy, and what was never training's to give?

::: answer
MuZero's policy prior is a confidence gate. It lets amplification act only where the learned model is reliable, which confines the search and the targets it manufactures to the region the surrogate fits. LDT's candidate-elimination head uses an asymmetric cross-entropy that weights false eliminations eight times more heavily than false retentions, because a wrongly eliminated candidate cannot be recovered. That is deliberate de-amplification in the unsound direction. The reduction is $0.78/0.028\approx28$-fold. Training bought completeness and speed. Soundness never moved, because the architecture installed it.
:::

### Search and discovery {kind=argue at=the-boundary-amortizing-search-versus-amortizing-discovery}

State the demarcation. What happens when LDT is ported to ARC, and why? Which move do LDT's authors imagine, and why does the essay say that making it dissolves the scaffold that made amortization work?

::: answer
Everything in the earlier sections amortizes search over a correctness condition that is given. None of these systems amortizes the discovery of the condition. The line is structural, not a limit on compute or parameters. Some problems hand over the condition: the rules, the energy, the reward, the task metric, the Galois connection. Others require it to be inferred per instance before the machinery can run. ARC is of the second kind, since each task carries its own rules. A naive port of LDT plateaus and gets no benefit from test-time search, because the conflict head becomes unreliable and the search cannot tell good branches from bad. The authors imagine an abstract domain "over the *programs* that produce solutions, rather than over the solution states themselves". The essay reads that as the move from deduction to abduction and induction. The lattice, the contraction and the energy each encode a fixed condition, and that is what the iteration exploits. Without a fixed condition the search has no structure to descend.
:::

### What would refute it, and what is unsettled {kind=limits}

What prediction does the demarcation make, and what would show it wrong? Name four further places where the essay marks a claim as its own reading, as unseparated from alternatives, as untested, or as beyond what settling shows.

::: answer
The prediction: scaling these architectures keeps winning on Sudoku-, maze- and SAT-shaped problems and keeps hitting a wall on ARC-shaped rule induction, at essentially any scale. The dividing line is givenness, not difficulty and not size. It would be wrong if a system in this family cracked open-ended rule induction by scaling depth, breadth and amortized training alone, with no new mechanism for representing and searching over candidate conditions.

- A limit cycle as the right terminal behavior for inputs with many solutions is "our reading, not theirs". No architecture in the cluster makes a non-converging recurrent set its terminal competence.
- That the binding constraint on step size is learnability and not forward expressivity is isolated by none of the papers. Deep supervision confounds learnability with optimization stability, and the separating experiment is described, not run.
- Whether iterating a locally competent operator or compressing it carries the headline quality is unsettled. The two experiments that would tell have not been run cleanly: "We think it; we have not proven it."
- Settling certifies nothing about the world. A system can settle with every internal signal of completion into a spurious attractor.
:::
