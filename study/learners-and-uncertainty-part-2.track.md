---
title: "Across the track: Learners, bets and heat, part 2"
track: learners-and-uncertainty
stage: part-2
---

Questions whose answers draw on more than one of *The Demon Is a Learner*, its mathematics page and *Before the Search Settles*. Attempt them after the last of the three.

### One presumption, four places {kind=connect}

Boltzmann assumed that two balls about to collide are independent. Find the same presumption in a heat bath, in belief propagation and in Cramér's model of the primes. What spoils it in each of the last two?

::: answer
- *The gas.* Mechanics does not supply the number of pairs about to meet, and the assumption is where the arrow of time enters ([the essay](/notes/the-demon-is-a-learner.html#a-gas-of-balls)).
- *The bath.* A kernel chosen without reference to the distribution it acts on is "the Stosszahlansatz for a bath": the molecule arriving at the system has not met it before ([§9.7](/notes/the-demon-is-a-learner-mathematics.html#an-h-theorem-for-any-markov-chain)).
- *Belief propagation.* Messages entering a node are taken to be independent, which is Boltzmann's assumption "moved from time to a graph." What spoils it is correlation coming back around a short loop, a recollision ([§12.9](/notes/the-demon-is-a-learner-mathematics.html#mean-field-and-the-cavity)).
- *The primes.* Cramér treats $n$ and $n+2$ as independent. Divisibility by small primes spoils it, and Hardy and Littlewood's constant is the defeater, as the reversed gas is "a defeater on a grand scale" ([*Before the Search Settles*](/notes/before-the-search-settles.html#presumed-independent)).

In each place the presumption holds until structure is found, and the structure was there all along.
:::

### A reason is a macrostate {kind=connect}

*Before the Search Settles* calls a reason a macrostate. What is a macrostate in *The Demon Is a Learner*? How does the comparison run for a logical inductor, and where does it break?

::: answer
In Shalizi and Moore's construction the observer supplies the observables, and the dynamics decides which refinement of them makes states that predict their own future. A macrostate is what a predictor needs to keep ([the essay](/notes/the-demon-is-a-learner.html#what-a-bounded-observer-can-compress)). A reason is a latent structure with independence presumed beyond it: what a predictor needs to keep, so that the rest can be presumed independent ([*Before the Search Settles*](/notes/before-the-search-settles.html#three-answers)). A logical inductor keeps its structure inside its traders and retains only the prices. It stands to its reasons as Boltzmann's one-ball distribution stands to a gas, which records each ball's statistics and none of the correlations among balls. The comparison breaks because traders act on what they hold. A correlation left out of a gas's description stays out. One left out of the prices is a profit for any efficient trader that finds it, so the market corrects it.
:::

### The same weights, spent three ways {kind=connect}

Chaitin's $\Omega$, Solomonoff's prior and Levin's search each weight a program of length $\ell$ by $2^{-\ell}$. What does each do with the weights, and which of the three is computable? How does a logical inductor's trading firm weight its traders?

::: answer
$\Omega = \sum 2^{-\ell(x)}$ over the halting programs is the chance that a universal computer halts on fair coin flips. It has the shape of a partition function, and it is not computable ([the essay](/notes/the-demon-is-a-learner.html#the-entropy-of-one-state)). Solomonoff's prior spends the weights as probabilities: $M(x)$ is the chance that a monotone machine fed coin flips prints an output beginning with $x$. It must run every program to the end, which no computer can do, and it is logically omniscient about its programs ([the box](/notes/before-the-search-settles.html#a-prior-over-theories)). Levin spends the weights as time. Each program gets the share $2^{-\ell(p)}$ of every phase, the search ends within $4\cdot2^{\ell(p)}\,t(p)$ steps, and it is computable ([the box](/notes/the-demon-is-a-learner.html#what-a-bounded-observer-can-compress)). The trading firm gives trader $k$ with budget $b$ the fixed weight $2^{-k-b}$. The weights halve along the enumeration, not with each bit of a trader's description, and every trader runs in polynomial time, so the inductor is computable ([the construction](/notes/before-the-search-settles.html#a-bookmaker-over-sentences)).
:::

### One theorem, three clocks {kind=connect}

The mathematics page proves $D(\mu P\,\|\,\pi P)\le D(\mu\,\|\,\pi)$ for any Markov kernel. Name three places where the two Demon pages apply it. What do the three kernels have in common? Which process escapes the theorem, and what must it know?

::: answer
- *Depth.* Stochastic layers connected only in sequence form a Markov chain in depth. Two distributions of inputs can only grow harder to tell apart as they pass up the stack, so each layer is a coarse graining ([the essay](/notes/the-demon-is-a-learner.html#what-forgetting-costs)).
- *A bath.* Noise set before the system arrives drives any process, with its law held fixed, toward the stationary distribution of that law ([the essay](/notes/the-demon-is-a-learner.html#the-demon-is-a-learner)).
- *Training.* For stochastic gradient descent the assumption is that each minibatch is drawn fresh, whatever the current weights. Sweeping through a shuffled dataset breaks it a little ([§9.7](/notes/the-demon-is-a-learner-mathematics.html#an-h-theorem-for-any-markov-chain)).

In each the kernel is chosen without reference to the distribution it acts on. The time reversal of a diffusion escapes. Its drift carries the correction $2T\,\nabla\ln(\rho_t/\pi)$, which depends on $\rho_t$, and a diffusion model learns that dependence from data as the score ([§12.10](/notes/the-demon-is-a-learner-mathematics.html#reversing-a-diffusion)).
:::
