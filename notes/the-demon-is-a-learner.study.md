---
title: "Study notes: The Demon Is a Learner"
essay: the-demon-is-a-learner
track: learners-and-uncertainty
reviewed-against: "48dc4b5"
requires:
  - {at: the-standard-of-motion#the-first-law-carries-the-geometry, for: "Heller's reconstruction of Aristotle's second law, force proportional to velocity"}
  - {at: the-standard-of-motion#one-bracket-three-mechanics, for: "Liouville's theorem: closed Hamiltonian evolution keeps phase-space volume, so it loses no information"}
  - {at: the-standard-of-motion#the-algebra-of-free-motions, for: "gradient flows as the robust dynamics and frictionless motion as the fragile exception", strength: helpful}
  - {at: the-bookmaker-is-a-learner#the-bookmaker-is-a-learner, for: "the LMSR cost function, its liquidity parameter, and mirror descent on prices", strength: helpful}
  - {at: who-teaches-the-weights, for: "a learner that narrows its behavior, and the Fisher information as the divergence a small move causes", strength: helpful}
  - {at: how-does-a-policy-improve, for: "the improved policy as a Gibbs tilt of a prior", strength: helpful}
introduces:
  - {term: overdamped limit, at: aristotle-was-right-about-a-regime}
  - {term: Polyak–Łojasiewicz condition, at: aristotle-was-right-about-a-regime}
  - {term: three geometries of gradient flow, at: aristotle-was-right-about-a-regime, gloss: "weights under constant drag, densities under the Wasserstein distance, and probabilities under the Fisher drag; in each, velocity follows force"}
  - {term: Boltzmann's assumption, at: a-gas-of-balls, gloss: "two balls about to collide are independent"}
  - {term: coarse graining, at: a-gas-of-balls}
  - {term: Landauer's principle, at: what-forgetting-costs}
  - {term: Kolmogorov complexity, at: the-entropy-of-one-state}
  - {term: physical entropy, at: the-entropy-of-one-state, gloss: "Zurek's sum of the missing information and the algorithmic information content of the record"}
  - {term: score, at: the-demon-is-a-learner}
  - {term: relevant and irrelevant memory, at: the-demon-is-a-learner}
  - {term: macrostate as predictor, at: what-a-bounded-observer-can-compress, gloss: "a state that predicts its own future; what a predictor needs to keep"}
  - {term: Levin search, at: what-a-bounded-observer-can-compress}
uses:
  - {term: "Aristotle's first and second law", from: the-standard-of-motion}
  - {term: "Liouville's theorem", from: the-standard-of-motion}
  - {term: structural stability, from: the-standard-of-motion}
  - {term: mirror descent, from: the-bookmaker-is-a-learner}
  - {term: liquidity parameter, from: the-bookmaker-is-a-learner}
  - {term: two-part code, from: an-ontology-that-pays-for-itself}
  - {term: exponential tilt, from: how-does-a-policy-improve}
  - {term: cost-function market and the LMSR, from: the-bookmaker-is-a-learner}
  - {term: forgetting within a task, from: who-teaches-the-weights}
  - {term: usable information, from: who-teaches-the-weights}
  - {term: JEPA, from: which-world-model}
---

### Aristotle's law as a limit {kind=compute at=aristotle-was-right-about-a-regime}

Newton's equation for a body pushed against linear drag is $m\ddot x = F - \gamma\dot x$. What first-order law remains when inertia is small, and which quantity has to be small? A body of mass $2$ on a spring of stiffness $8$ moves against drag $\gamma = 10$: is it overdamped, and below what drag would it oscillate? What is gradient descent in these terms?

::: answer
The velocity relaxes almost at once to $F/\gamma$ and then follows it, which leaves $\dot x = F/\gamma$ (Tikhonov's theorem). The small quantity is $mk/\gamma^2$, where $k$ measures how steeply the force changes with position; $m/\gamma$ is a time. Here $mk/\gamma^2 = 16/100 = 0.16$, below the threshold $1/4$, so the body slides to rest without oscillating. It would oscillate below $\gamma = \sqrt{4mk} = 8$, and the first-order law is accurate only when $mk/\gamma^2$ is well below $1/4$. Gradient descent is this limit with the loss as potential energy, $F = -\nabla L$. Heller's $m$ in $F = m\cdot v$ plays the role of the drag coefficient $\gamma$.
:::

### Where the loss is high, the ground is steep {kind=derive at=aristotle-was-right-about-a-regime}

The Polyak–Łojasiewicz condition says $\tfrac12|\nabla L(w)|^2 \ge \mu\,(L(w) - L^*)$ at every point of a region. Derive the rate at which gradient flow lowers the loss there. What does the condition forbid, and what does it not require? Where can it hold for a neural network?

::: answer
Along $\dot w = -\nabla L$ the loss falls at the rate $|\nabla L|^2$, so $\frac{d}{dt}(L - L^*) \le -2\mu\,(L - L^*)$ and the excess shrinks at least as fast as $e^{-2\mu t}$. The condition forbids a flat spot anywhere but at the minimum value: the region holds no saddles, no spurious local minima and no local maxima. It does not need convexity, and the minimizers may form a curved valley with a flat floor. A network's loss has other critical points, for example where every weight is zero, so the condition can hold only on part of the landscape. Wide networks satisfy it in a ball around their initialization.
:::

### Drag that depends on position {kind=compute at=aristotle-was-right-about-a-regime}

In the limit of small steps, mirror descent on a distribution gives $\dot p_i = -p_i\bigl(\partial_i L - \sum_j p_j\,\partial_j L\bigr)$. For $p = (0.5,\,0.3,\,0.2)$ and gradient $(1,\,0,\,-1)$, compute $\dot p$. What plays the part of the drag, and how much more divergence does a given small move cost at probability $0.01$ than at $0.1$? Name the other two geometries in which the essay finds the same law.

::: answer
The average gradient is $0.5 - 0.2 = 0.3$, so $\dot p = (-0.35,\ 0.09,\ 0.26)$, which sums to zero. A move $\Delta$ costs $\tfrac12\sum_i\Delta_i^2/p_i$ of divergence to second order, so the Fisher matrix is diagonal with $1/p_i$ in place $i$, and the same move costs ten times as much at $0.01$ as at $0.1$. Dividing the force by that matrix multiplies it by $p_i$. Heller's $m$ becomes $1/p_i$, and a probability near zero barely moves. Evolutionary game theory knows the equation as the replicator dynamics. The other two geometries are gradient flow on the weights and the flow of a density downhill on its free energy, measured by the Wasserstein distance.
:::

### The one line {kind=argue at=a-gas-of-balls}

Boltzmann's derivation of the H-theorem is "mechanics until one line." Which line? Give two arguments that the arrow of time enters there and not in the collisions.

::: answer
The line is the assumption that two balls about to collide are independent, so that the number of such pairs is the product of the two one-ball densities. Mechanics does not supply that number. A collision conserves energy and momentum and runs equally well backward. First argument: assume instead that balls are independent just after they collide, and the same algebra proves that entropy falls. Second, Loschmidt's: reversing every velocity turns an entropy-raising history into an entropy-lowering one, so mechanics alone cannot make entropy rise. In the reversed gas the assumption fails, because each incoming pair is an outgoing pair of the original run, correlated by the collisions it has had.
:::

### Running the reversal {kind=compute at=a-gas-of-balls}

In the simulated gas each collision per disk multiplies a typical error by about a hundred. One run reverses the gas from velocities rounded to six decimal places. How large is a typical error after two and a half collisions per disk? How many more decimal places does each further collision of reversal demand? What do the three runs show?

::: answer
$10^{-6}\times100^{2.5} = 10^{-1}$, so by then the rounded gas leaves the exact curve and its fall stops. Each further collision per disk costs a factor of a hundred: about two more decimal places in every position and velocity, a demand that grows without limit ([the last section](/notes/the-demon-is-a-learner.html#what-a-bounded-observer-can-compress) draws the consequence for a bounded observer). The mechanical gas and the gas whose colliding pairs are drawn at random give the same entropy curve, which is the H-theorem at work. The mechanical gas, reversed exactly at four collisions per disk, falls back to the entropy it began with. The rounded gas does not.
:::

### What forgets {kind=explain at=a-gas-of-balls}

The entropy of the joint distribution of all the balls is constant, by Liouville's theorem, and the entropy of the H-theorem rises. Where does the risen entropy sit, and what has forgotten it? Why may the description discard it in a gas prepared by ordinary means?

::: answer
The entropy that rises belongs to a description that keeps one ball at a time, a coarse graining. If the balls start uncorrelated, every unit gained by the one-ball distribution, summed over the balls, is a unit stored in correlations among them. Boltzmann's assumption says the description may discard those correlations, because none of them will come back as an incoming pair. In a gas prepared by ordinary means that is true, since nothing has tuned its correlations to its future. So the H-theorem is a theorem about forgetting, and what forgets is the description. A description forgets for free, and a physical system that shrinks its own possibilities has to send the difference somewhere.
:::

### What has to pay {kind=distinguish at=what-forgetting-costs}

For each of these, say whether it must give up heat, and why: a gradient flow carrying a cloud of possible weights toward a minimum; resetting a bit of unknown value; a computation; a demon's measurement.

::: answer
- *Gradient flow.* It expands volume at the rate $-\operatorname{tr}\nabla^2L$, negative near a minimum, which a closed Hamiltonian system cannot do. A law that contracts volume is the shadow of a system coupled to a medium, and the medium takes up the volume, which is entropy.
- *Resetting a bit.* It maps two logical states onto one. Hamiltonian dynamics conserves fine-grained entropy, so the entropy $k\ln 2$ goes to the rest of the machine and the environment, as heat of at least $kT\ln 2$ into a bath at temperature $T$. This is Landauer's principle.
- *A computation.* It need not pay. Any computation can be done by a logically reversible machine: compute, copy the answer, then run backward to clean up. What costs is throwing information away.
- *A measurement.* It can be done reversibly. The demon pays when it clears its memory to measure again, at least what it gained, which in Szilard's engine is $kT\ln 2$ of work for one bit.
:::

### Erasing the digits of π {kind=compute at=the-entropy-of-one-state}

A demon's memory holds the first $n = 2^{20}$ binary digits of $\pi$ and must be reset to blank. Counting in units of $kT\ln 2$, what does a demon pay that erases the string without understanding it? What does a demon pay that first recognizes the digits? Why does the recognition cost nothing?

::: answer
The first demon pays for $n = 1{,}048{,}576$ bits. The second converts the string into a short program that prints it: a fixed routine for $\pi$, plus about $\log n = 20$ bits to say how many digits. It then erases the program and pays for about $20$ bits. The conversion can run reversibly at no cost because it forgets nothing: with $x$ the string and $y$ the program, $K(x\mid y)$ is close to zero, since running the program gives the string back. The other $n - \log n$ bits were only a longer way of writing the program. A learner that has found the regularity in its data stands where the second demon stands.
:::

### The entropy a demon faces {kind=state at=the-entropy-of-one-state}

State Zurek's physical entropy for a demon holding a record $d$. What does a measurement do to its two terms? Why can the demon not win by keeping only its lucky runs? Which principle of statistics has the same form?

::: answer
$S = H(\text{state}\mid d) + K(d)$: the missing information plus the algorithmic information content of the record. A measurement shrinks the first term and grows the second, and for a system in equilibrium the decrease of ignorance is, on average, compensated by the growth of the minimal record. A single run can come out ahead. Keeping only the lucky runs needs a record of which runs were lucky, and that record costs, on average, at least what the luck gained. The sum is a two-part code, the length of a model plus the length of the data given the model, which is the minimum description length principle. The demon's thermodynamic account and a learner's model-selection account have the same form.
:::

### Bath, learner, demon {kind=distinguish at=the-demon-is-a-learner}

"The arrow of the H-theorem rests on something not knowing something." What does a heat bath not know? What does a diffusion model learn that a bath lacks, and what does a demon build beyond that? Which two results say what the best demon is and what it must contain?

::: answer
A bath's noise is set before the system arrives and knows nothing of the distribution it acts on, so a process driven by it, with its law held fixed, drifts toward that law's stationary distribution. Undoing the drift takes the time reversal of the diffusion, whose drift depends on the density at every moment through the score, the gradient of the log density. A diffusion model learns the score from data and with it turns noise into samples. A demon goes one step further and builds a correlation with the particular state in front of it, the thing Boltzmann's assumption says is absent. Boyd, Crutchfield and Gu show that the work-maximizing demon is the maximum-likelihood learner. Boyd, Mandal and Crutchfield show that a demon can harvest correlations in its input only if its own memory reflects the structure that generated them.
:::

### An engine with a memory {kind=compute at=the-demon-is-a-learner}

Still's engine writes its memory at temperature $T$ and extracts work at $T' = 3T$. The memory holds $5$ bits, of which $3$ are relevant to extracting work. Compute the efficiency and compare Carnot's limit. How many irrelevant bits is one more relevant bit worth? What does that exchange rate become in learning, and which bound do the irrelevant bits loosen?

::: answer
$\eta = 1 - \frac{T}{T'}\frac{I_{\text{mem}}}{I_{\text{rel}}} = 1 - \frac13\cdot\frac53 = \frac49$, against Carnot's $1 - \frac13 = \frac23$, which the engine reaches only if all of its memory is relevant. Every bit written costs heat in proportion to $T$, and every relevant bit earns work in proportion to $T'$. Counted in units of $T$, a relevant bit is worth $T'/T - 1 = 2$ and an irrelevant one costs $1$, so one more relevant bit pays off even if up to two irrelevant bits come with it. That exchange rate is the trade-off of the information bottleneck, which minimizing the bound on the engine's dissipation gives. The irrelevant bits also loosen Kawaguchi and colleagues' bound on the gap between training and test loss, roughly $\sqrt{(I_{\text{mem}} - I_{\text{rel}} + 1)/n}$ for $n$ examples.
:::

### Whose second law? {kind=explain at=what-a-bounded-observer-can-compress}

A state evolves by a computable deterministic law. How much can its Kolmogorov complexity grow, and what follows about where entropy comes from? If entropy is relative to a coarse graining, is the second law a fact about us? Give Shalizi and Moore's answer, and say what it makes a macrostate.

::: answer
$K(x_t) \le K(x_0) + K(f) + K(t) + O(1)$, and $K(t)$ grows only like $\log t$ ([the bound](/notes/the-demon-is-a-learner.html#the-entropy-of-one-state)). So entropy grows because observers describe the world coarsely, not because the fine-grained state gets more complex. Shalizi and Moore's answer has two halves. The observer supplies the observables. The dynamics then decides which refinement of them makes states that predict their own future, and those are the macrostates. A macrostate is what a predictor needs to keep. Boltzmann's assumption makes the one-ball distribution such a state for a gas prepared by ordinary means, while the reversed gas has the same histogram with the opposite future. A JEPA searches for such states from data, and needs an anti-collapse term to do what the observables do.
:::

### What the search charges {kind=compute at=what-a-bounded-observer-can-compress}

In Levin search a program $p$ of length $\ell(p)$ runs for $2^{i-\ell(p)}$ steps in phase $i$, and phase $i$ takes at most $2^i$ steps. A program of $10$ bits produces a checkable answer within $1{,}000$ steps. In which phase does it finish, and how does the total compare with the bound $4\cdot 2^{\ell(p)}\,t(p)$? What does the search charge an observer holding a message encrypted under a key of $k$ bits? What does the thermodynamic ledger make of that charge?

::: answer
The program finishes in the first phase with $2^i \ge 2^{10}\times1000 = 1{,}024{,}000$, which is phase $20$. The phases up to that one take at most $2^{21}\approx 2.1$ million steps, within the bound of $4.096$ million. For the ciphertext, the shortest fast program that decrypts the message contains the key, so the search takes about $2^k$ times the time of one decryption, the cost of trying every key. The thermodynamic ledger does not see it. Decryption can in principle run reversibly, at no cost in heat, and it adds no Shannon information while adding plenty of usable information, which is defined relative to the predictors an observer can afford. Bits price what an observer stores and forgets, and time prices what it can do with them.
:::

### One ledger, or only a formula {kind=limits at=the-demon-is-a-learner}

Under what condition do the essay's results put the demon and the learner "on one ledger"? Name five places where it marks a link as an analogy, a reading of its own, a further hypothesis, or still argued.

::: answer
The condition is that the learner is a physical system in a bath. "Where it is not, they share only a formula."

- Training in software has no literal engine cycle, since Carnot's argument needs a conserved energy and a loss is not conserved. Reading the Boltzmann machine's two strokes as an engine is the authors' reading and not Still's, and the analogy stops at the output: the update dissipates the free energy instead of delivering it as work.
- Goldt and Seifert's bound concerns the weights as a physical system, not the processors that compute them, which dissipate many orders of magnitude more.
- Friston's variational free energy counts surprise against a model, in nats, and nothing in it is paid. That a system's thermodynamic free energy encodes it is a further hypothesis.
- Kawaguchi and colleagues add that compressing is one way to generalize, not the only one and not a necessary one.
- Whether Landauer's principle is independent of the second law is [still argued](/notes/the-demon-is-a-learner.html#what-forgetting-costs).
:::
