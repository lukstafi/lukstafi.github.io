---
title: "Across the track: Learners, bets and heat, part 1"
track: learners-and-uncertainty
stage: part-1
---

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
