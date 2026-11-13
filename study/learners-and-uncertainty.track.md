---
title: "Across the track: Learners, bets and heat"
track: learners-and-uncertainty
---

Questions whose answers draw on more than one essay. Attempt each group after the last essay of its stage.

## Bets and defaults

Questions whose answers draw on more than one of the first three essays of the track. Attempt them after *An Ontology That Pays for Itself*.

### Finding one and counting all {kind=connect}

*The Bookmaker Is a Learner* and *Presumed Normal* each meet a gap between finding one extreme object and summing over all of them, and each cites the other there. State the two instances. Which parameter connects the two sides of the gap in each?

::: answer
- On a race, matching asks for the finishing order that would cost the house most, which a maximum-weight matching finds in polynomial time. LMSR pricing asks for a sum over all finishing orders, which is #P-hard. As the liquidity $b$ shrinks toward zero the cost function tends to the maximum, so matching is pricing at zero temperature ([the combinatorial wall](/notes/the-bookmaker-is-a-learner.html#the-combinatorial-wall)).
- With a price $w$ on each abnormality, the limit $w\to\infty$ needs only the models of least total price, which an optimization statement finds. Any finite $w$ needs every model, weighted, which takes a count, and counting answer sets is harder than finding one ([the solver keeps no proof](/notes/presumed-normal.html#the-solver-keeps-no-proof)).

In the market $b$ is the temperature. In the logic $w$ is an inverse temperature.
:::

### A proposer with a prior {kind=connect}

*An Ontology That Pays for Itself* states the risk of a language-model proposer in the terms of *The Bookmaker Is a Learner*: it is a bandit problem. Spell out the correspondence. Which remedies does the ontology essay give, and what are their counterparts in the bookmaker essay?

::: answer
A bandit sees only the gain of the arm it pulls. The code length scores only what it is shown. A structure that the proposer's prior makes improbable is rarely shown, so it never collects the evidence that would make it probable. That is the cold learner of the bandit box, which pulls its disfavored arms so rarely that its estimates of them turn into noise ([the bookmaker is a learner](/notes/the-bookmaker-is-a-learner.html#the-bookmaker-is-a-learner)).

The ontology essay calls its remedies those of bandits and markets ([what the language model is for](/notes/an-ontology-that-pays-for-itself.html#what-the-language-model-is-for)).

- Mix into the search some proposals drawn without the prior. Exp3 mixes a little uniform probability into its weights for the same reason.
- Take proposals from sources whose priors differ, and let each source's share of the proposals grow with the bits its accepted proposals save. A market escapes the cold learner's problem because a trader who believes in a cheap outcome profits most by buying it, and over many questions it reweights its traders through their accumulated money.
:::

### Voices that are not independent {kind=connect}

Why does the ontology essay refuse to count several prompts to one language model as several sources? Which result from the bookmaker essay does it cite? What does each essay say that consensus, or a market, needs?

::: answer
Several prompts to one model, or to models trained on the same text, share errors the way copied sources do. Counted separately they would manufacture consensus. In the ontology's code a claim becomes a fact once enough independent sources state it, and detecting copies is a prerequisite for counting sources as independent ([who says so](/notes/an-ontology-that-pays-for-itself.html#who-says-so)). The essay cites the bookmaker essay's report of a simulated market of ten preference-tuned language-model traders whose errors were correlated. The market was right less often than a single one of them. The bookmaker essay draws the matching conclusion for markets: a market aggregates diversity of information, and AI forecasting has yet to supply the diversity the relay needs ([what a market adds to a scoring rule](/notes/the-bookmaker-is-a-learner.html#what-a-market-adds-to-a-scoring-rule)).
:::

### Where a default lives {kind=connect}

The ontology essay divides defaults and contradictions between its code and the logics of *Presumed Normal*. What does the code decide, and what is left to inference? Where can a contradiction still arise in the ontology, and what does an adaptive logic do with it?

::: answer
The code decides whether a default exists: it survives while the rule plus its list of exceptions is cheaper than listing every case or splitting the class ([text is not the world](/notes/an-ontology-that-pays-for-itself.html#text-is-not-the-world)). Whether the default applies to a given dog is a question for inference. *Presumed Normal* describes logics that presume normality case by case unless the premises rule it out, as the rule `flies(X) :- bird(X), not ab(X).` lets a bird fly unless it is shown to be abnormal ([answer sets](/notes/presumed-normal.html#answer-sets)). One three-legged dog breaks a strict "every", so a class-level tuple can carry a typicality strength and leave the rest to default inference.

Two sources that disagree do not make the knowledge base inconsistent: they are two records. Contradictions can still arise inside *Self* ([one judgment](/notes/an-ontology-that-pays-for-itself.html#one-judgment)). There an adaptive logic keeps them from spreading. It falls back to its lower limit logic only where it has to, as the opening proof of *Presumed Normal* lost disjunctive syllogism for $p$ and kept it for $q$ ([a logic in three parts](/notes/presumed-normal.html#a-logic-in-three-parts)).
:::

## Heat and search

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
