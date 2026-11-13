---
title: "Study notes: Before the Search Settles"
essay: before-the-search-settles
track: learners-and-uncertainty
reviewed-against: "f347d11"
requires:
  - {at: the-bookmaker-is-a-learner#the-bookmaker-is-a-learner, for: "Hedge, the LMSR, liquidity as an inverse learning rate, and the bookmaker in Hedge's position, not a bandit's"}
  - {at: the-demon-is-a-learner#a-gas-of-balls, for: "Boltzmann's assumption of independence and the reversed gas that breaks it"}
  - {at: the-demon-is-a-learner#what-a-bounded-observer-can-compress, for: "a macrostate as what a predictor needs to keep", strength: helpful}
  - {at: presumed-normal, for: "adaptive logics, defeaters, and the weighted encoding of the paraconsistent logic CLuN", strength: helpful}
  - {at: an-ontology-that-pays-for-itself, for: "a reasoner that tracks which source asserts what, and concepts that earn their place by shortening the code", strength: helpful}
  - {at: who-teaches-the-weights, for: "self-distillation, the moving teacher, and training that collapses onto one strategy", strength: helpful}
  - {at: the-given-and-the-found, for: "grounding sets the sign of an update, and search over a given condition differs from discovering the condition", strength: helpful}
  - {at: how-does-a-policy-improve, for: "search in a known model, and amortization", strength: helpful}
introduces:
  - {term: logical omniscience, at: logical-omniscience}
  - {term: logical prior, at: a-prior-over-theories, gloss: "Demski's distribution over theories: draw sentences at random and keep each one that does not contradict those already kept"}
  - {term: Solomonoff's prior, at: a-prior-over-theories}
  - {term: Gaifman inductivity, at: a-prior-over-theories}
  - {term: logical induction criterion, at: a-bookmaker-over-sentences}
  - {term: non-dogmatism, at: a-bookmaker-over-sentences}
  - {term: paradox resistance, at: what-a-truth-maintenance-system-lacks}
  - {term: defensive forecasting, at: what-a-truth-maintenance-system-lacks}
  - {term: multicalibration, at: what-a-truth-maintenance-system-lacks}
  - {term: outcome indistinguishability, at: tests-instead-of-worlds}
  - {term: table of adversaries, at: tests-instead-of-worlds, gloss: "where the adversary sits, inside the believer or outside, against what holds it to account, settlement over time or checks on demand"}
  - {term: presumption of independence, at: presumed-independent}
  - {term: "reason, price and defeater", at: three-answers, gloss: "a reason is a latent structure with independence presumed beyond it; a price is the marginal probability it implies for one sentence; a defeater is structure found outside it"}
  - {term: gaps and gluts, at: what-explosion-becomes}
  - {term: independent check, at: learning-without-new-evidence, gloss: "a check that does not depend on the beliefs being trained, whether it is internal or external"}
  - {term: No Expected Net Update, at: steering-the-search}
uses:
  - {term: regret and no-regret learning, from: the-bookmaker-is-a-learner}
  - {term: liquidity parameter, from: the-bookmaker-is-a-learner}
  - {term: bandit and exploration, from: the-bookmaker-is-a-learner}
  - {term: adaptive logic, from: presumed-normal}
  - {term: condition and marking, from: presumed-normal}
  - {term: abnormality with a price, from: presumed-normal}
  - {term: two-part code, from: an-ontology-that-pays-for-itself}
  - {term: provenance judgment, from: an-ontology-that-pays-for-itself}
  - {term: Self and idealized sources, from: an-ontology-that-pays-for-itself}
  - {term: amplitude and sign of a learning signal, from: the-given-and-the-found}
  - {term: amortizing search versus amortizing discovery, from: the-given-and-the-found}
  - {term: Hedge as a bookmaker, from: the-bookmaker-is-a-learner}
  - {term: cost-function market and the LMSR, from: the-bookmaker-is-a-learner}
  - {term: Boltzmann's assumption, from: the-demon-is-a-learner}
  - {term: macrostate as predictor, from: the-demon-is-a-learner}
  - {term: usable information, from: who-teaches-the-weights}
  - {term: self-distillation with privileged context, from: who-teaches-the-weights}
  - {term: forgetting within a task, from: who-teaches-the-weights}
  - {term: amortization, from: how-does-a-policy-improve}
  - {term: moving teacher and fixed anchor, from: who-teaches-the-weights}
  - {term: combinatorial wall, from: the-bookmaker-is-a-learner}
  - {term: wealth of traders as a second learner, from: the-bookmaker-is-a-learner}
---

The answers state what the essay argues. Its verdict on logical induction is offered as the author's view, and the last question asks what the essay leaves open.

### Why not one in ten? {kind=explain at=logical-omniscience}

Is the $10^{100}$th decimal digit of $\pi$ a 7? Why can probability theory, as usually stated, not give the credence one in ten? What do the repairs from Hacking to the urn models achieve, and what do they leave unanswered?

::: answer
A textbook probability is defined over possible worlds. A mathematical fact is true in every world, so it gets probability 1 and its negation 0. The theory therefore models an agent who already knows every consequence of what it knows, which philosophers call logical omniscience. The repairs weaken that demand. Hacking attaches probabilities to sentences and counts as possible what one does not know to be false. Garber treats "h ⊢ e" as a new atom. Gaifman restricts the axioms to a finite set of sentences in view, and urn models allow inconsistency beyond the depth of quantifiers anyone has examined. These give permission to hold intermediate credences. None says how the credences should move as computation proceeds, or why one in ten is the right number.
:::

### A prior over theories {kind=derive at=a-prior-over-theories}

Describe the generative process behind the 2012 prior. Why does a provable sentence get probability 1, and why is $P(A)\le P(B)$ when $A$ implies $B$? In what sense is the prior computable? What limit does the paper state for it?

::: answer
Let $G$ give every sentence positive probability. Draw $S_1, S_2, \dots$ from $G$, rejecting each candidate that would make the sentences kept so far contradictory. The probability of a sentence is the chance that it ends up in the theory. A provable sentence can never be rejected, so it is eventually drawn, with probability 1. If $A$ implies $B$, whatever contradicts $B$ contradicts $A$, so a theory containing $A$ will eventually contain $B$. Inconsistency is only semi-decidable, so the prior is approximated by sampling theories and spending a growing time on each looking for contradictions: computable in the limit, with no claim of efficiency. The stated limit: if every instance $S[0], S[1], \dots$ is provable and $\forall x.\,S[x]$ is not, then $\exists x.\,\neg S[x]$ keeps positive probability and holds the universal statement below 1. The prior cannot learn new axioms of arithmetic.
:::

### The property that had to go {kind=state at=a-prior-over-theories}

What is Gaifman inductivity? State Sawin and Demski's theorem and the reading they gave it. Which of the two constructions, the 2012 prior and the 2016 logical inductor, has the property?

::: answer
It is the property that credence in a universal claim approaches certainty as its instances are checked. It would price at 1 a universal statement whose instances are all provable, even when the statement itself is not. The theorem: "Computable probability distributions which converge on believing true Π1 sentences will disbelieve true Π2 sentences." The property cannot coexist with computable approximation and a weak form of coherence without making some short true Π2 claims arbitrarily improbable. Sawin and Demski read the theorem as a case against the property. Neither construction has it. The prior never reaches certainty about an unprovable universal statement, however many instances it has seen. A logical inductor is computably approximable, approximately coherent and non-dogmatic, and in its paper's words "so it cannot satisfy" the property ([the next section](/notes/before-the-search-settles.html#a-bookmaker-over-sentences)). The property the 2012 draft wished for is the one the 2016 construction had to drop.
:::

### The logical induction criterion {kind=state at=a-bookmaker-over-sentences}

Define a plausible world on day $n$, a trader, and what it is for a trader to exploit the market. State the criterion. On what does it place the computational bound? Let $\varphi_n$ say that the Ackermann$(n,n)$th decimal digit of $\pi$ is 7. What price do these sentences approach, and why?

::: answer
A deductive process enumerates the theorems of a theory, with $D_n$ the set found by day $n$. A world is plausible on day $n$ if it is propositionally consistent with $D_n$, treating quantified sentences as atoms. A trader chooses each day a number of shares in finitely many sentences, each a continuous function of the day's prices. It exploits the market if the value of its holdings, over all days and all worlds plausible on that day, is bounded below but not above: it risks a bounded amount and can win without bound. The criterion says: "there is no efficiently computable trader T that exploits P relative to D." The bound is on the traders, whose strategy for day $n$ must be written down in time polynomial in $n$, and not on the market. If no polynomial-time method predicts these digits better than chance, $P_n(\varphi_n)\to0.1$. One in ten is the price at which no efficient trader can profit.
:::

### Why no trader wins {kind=derive at=a-bookmaker-over-sentences}

The paper's algorithm has three parts. Say what each does. Then prove that no polynomial-time trader exploits the market, computing the sum that bounds what the other traders can lose.

::: answer
The market maker sets one day's prices against a single trader. The trader's orders are continuous in the prices, so Brouwer's fixed-point theorem gives prices at which its trade gains nothing in any world, and rational prices close enough that day $n$ gains at most $2^{-n}$, at most \$1 over all days. The budgeter turns a trader into one that never loses more than $b$ dollars in any plausible world. The trading firm enumerates the polynomial-time traders and admits trader $k$ once for every budget $b$, with weight $2^{-k-b}$.

Suppose trader $k$ exploited the market. Its losses are bounded, so for some $b$ its budgeted copy is never cut off, and the firm holds $2^{-k-b}$ of an unbounded gain. All the other copies together can lose at most $\sum_{k',b'}2^{-k'-b'}\,b' = \bigl(\sum_k 2^{-k}\bigr)\bigl(\sum_b b\,2^{-b}\bigr) = 1\times2 = 2$ dollars. The firm's gains would be unbounded, but the market maker holds them below \$1.
:::

### What a truth maintenance system lacks {kind=recall at=what-a-truth-maintenance-system-lacks}

Name the three things a truth maintenance system lacks that the theorems of logical induction need. For the second, say what a logical inductor does with a sentence asserting that its own price is below $0.5$, and why it can. Does any of the three need a market? Which virtue of a market does logical induction keep, and which does it drop?

::: answer
- A price for what has not been derived. A system with probabilities on its assumptions propagates a prior. It does not learn from which sentences turn out to be provable.
- A way to handle sentences that refer to the reasoner's own beliefs. Doyle's system loops on that circularity. A logical inductor prices the sentences toward $0.5$, because a trader whose demand varies continuously with the price leaves an equilibrium.
- Aggregation. Budgets and weights let one algorithm stand up to every efficient trader at once.

None of the three needs a market. Defensive forecasting picks a probability at which Skeptic's continuous betting function is zero, and logical induction's Brouwer step is the many-dimensional form of that move. Multicalibration repeats one step: find a group where the predictor is miscalibrated, and correct it there. Logical induction keeps the market's one shared state, in a stronger form, since its traders are inside it and the fixed point is computed jointly. It drops credit: a trader's weight is fixed from the start.
:::

### The table of adversaries {kind=distinguish at=tests-instead-of-worlds}

The adversarial answer varies along two axes. Name them, fill the four cells, and say what kind of guarantee each way of holding the adversary to account gives. Where does a trusted oracle fall?

::: answer
The first axis is where the adversary sits. An internal adversary is enumerated and run by the believer, which must out-compute each test. An external adversary can be stronger than the believer. The second axis is what holds the adversary to account. Settlement over time gives aggregate guarantees: a logical inductor is calibrated across sequences of sentences and can be badly wrong about any one. Checks on demand give a guarantee per instance.

- Internal, settlement: logical induction, multicalibration, defensive forecasting.
- Internal, checks: self-play under exact rules; proof search with a proof checker.
- External, settlement: prediction markets, scoring rules.
- External, checks: interactive proofs, debate.

A trusted oracle falls outside the table. Its answer is testimony, and logical uncertainty becomes empirical uncertainty about the reliability of a source.
:::

### Twin primes {kind=compute at=presumed-independent}

Cramér's model makes each number $n$ prime independently with probability $1/\ln n$. Near $n = e^{10}\approx22{,}000$, what chance does it give that $n$ and $n+2$ are both prime? Why is that wrong, and what is the figure after Hardy and Littlewood's correction? What does the essay call such a correction, and what does it set beside it from physics?

::: answer
$(1/10)^2 = 0.01$. The model treats $n$ and $n+2$ as independent. Yet if $n$ is an odd prime, $n+2$ is odd too, which doubles its chance of being prime, and divisibility by 3, 5, 7 and the other small primes pulls the chance back down. The net correction is about $1.32$, which gives about $0.0132$. The structure the naive model ignored is local and known, and each correction is a defeater of independence, applied where it is found. Boltzmann's gas with its velocities reversed is "a defeater on a grand scale." Both show that a presumption holds until structure is found, and that the structure was there all along.
:::

### Three answers {kind=distinguish at=three-answers}

For each of the three answers, say what it gives, where it fails, and where it keeps the structure. Where do the answers come apart?

::: answer
- A prior gives structure, and in narrow domains such as numerical integration it gives calibrated numbers that a user can check. No general prior over mathematics is computable with good behavior. It keeps the structure in its hypotheses, the model part of a two-part code.
- The adversarial answer gives guarantees, which arrive at an uncomputable rate. A logical inductor keeps the structure inside its traders, and the market retains only the prices.
- The presumption answer gives reasons, such as Hardy and Littlewood's constant. Nobody can yet say formally when a presumption is defeated. It keeps the structure in the explicit part of the argument.

The answers come apart only where structure exists. For the Ackermann digits of $\pi$ the reason is "no known structure," and the presumption alone gives one in ten.
:::

### A price is a reason's shadow {kind=argue at=three-answers}

Define a reason, a price and a defeater. Why do prices underdetermine reasons? State the essay's verdict on logical induction, and describe the reasoner it proposes.

::: answer
A reason is a latent structure together with a presumption of independence beyond it. A price is the marginal probability that a reason implies for one sentence. A defeater is structure found outside the reason's latent variables, and it calls for a new reason, not merely a new number. Different structures can imply the same marginals, so prices underdetermine reasons. The verdict, given as the author's view for now, is that logical induction "has the right kind of definition and the wrong ambition." It defines what it is for a credence to be wrong in a way someone could notice and profit from, which is the right standard for credences that will be acted on. It is not an account of mathematical understanding, because a price is only the structure's shadow on one sentence. The proposed reasoner has three layers. A logic layer records what has been derived and on which conditions, a layer of reasons records what has been explained, and a pricing layer prices everything else. A trader's persistent profit signals missing structure, abduction finds it, and the prior over structures chooses among the candidate reasons.
:::

### A probability with a glut {kind=compute at=what-explosion-becomes}

Take one sentence letter $A$ in the weighted encoding of CLuN: two atoms, `true(A)` and `neg(A)`, at least one of which holds, and weight $e^{-w}$ on the model where both hold. For $w = \ln 2$, compute $P(A)$, $P(\sim A)$ and $P(A\land\sim A)$, and check the identity that relates them. What replaces explosion for credences? What distinction does a single price erase?

::: answer
There are three models, with weights $1$, $1$ and $\tfrac12$, in total $2.5$. $P(A) = P(\sim A) = 1.5/2.5 = 0.6$ and $P(A\land\sim A) = 0.5/2.5 = 0.2$, so $P(A)+P(\sim A) = 1.2 = 1+P(A\land\sim A)$. The sum exceeds 1 for every finite $w$, and $w$ measures how strongly consistency is presumed. A credence of 0.6 in $p$ and 0.6 in $\neg p$ does not make anything certain. What replaces explosion is exploitability, which for a market is arbitrage profit. An adaptive logic confines a contradiction and withdraws what depends on it; a market confines it and charges for it. A sum below 1 is a gap and a sum above 1 is a glut, too little information against too much. A logical inductor's single price erases that distinction.
:::

### Independent checks {kind=case at=learning-without-new-evidence}

When is learning from one's own computation sound? Say where the essay draws the line, then place AlphaZero, MuZero and On-Policy Self-Training on it. What are the two ways out of OPST's position?

::: answer
The line does not fall between internal and external evidence. It falls between checks that are independent of the beliefs being trained and checks that are not. AlphaZero's game outcomes are logical facts, determined by the rules, so its check is internal and independent of its beliefs: it learned mathematics about chess with no evidence beyond its own play. MuZero learns its model of the game, so its search settles against a simulator that may be wrong. In OPST a model writes its own questions and answers, keeps a sample only if it reaches the same answer again in a fresh context, and trains toward an average of its past selves. Nothing outside the model checks anything. It is a market that never resolves, in which traders are paid for agreeing, and coherence is necessary for a good credence and not sufficient. One way out is an internal check that is independent of the beliefs: exact rules, a proof checker, an executable test. The other is an external check: a verifier, a debate in which a liar loses, a source whose testimony is trusted.
:::

### Steering the search {kind=argue at=steering-the-search}

Two operations let old evidence soundly raise confidence in a theory. Name them, and the failure that goes with each. Why can a credence drift when every derivation is valid, and which theorem of logical induction states the constraint? What protects a logical inductor, and what is the remedy for a bounded reasoner?

::: answer
One operation brackets the datum: ask how the hypothesis fares against a body of knowledge with the datum taken out. Its failure is not bracketing at all, answering what the hypothesis predicted with what happened, and it tracks a lack of sophistication. The other computes: the news is that the theory implies the datum. Its failure comes after bracketing, when the reasoner chooses which derivations to look for, and sophistication does not prevent it. A proof checker would pass every derivation and the credence would still drift, because the failures go uncounted. If finding a derivation would raise a credence, failing to find one must lower it. Logical induction states the constraint as No Expected Net Update: a sentence's price today approaches today's expectation of its future price. A logical inductor is protected because its deductive process does not consult its prices, at the cost of having no way to steer its deliberations. A bounded reasoner has to steer, and the remedy is bookkeeping: an account of what it searched for and failed to find.
:::

### What is open {kind=limits}

Name five things the essay reports as unsolved, not found, or beyond what a check can certify.

::: answer
- Nobody can yet say formally when a presumption is defeated, as ARC itself reports. The author has not found an adaptive logic whose abnormalities are dependences.
- Logical induction's guarantees are asymptotic and their rates uncomputable. It did not supply logical counterfactuals, and its paper claims only "a weak sense" in which it solves the problem of old evidence.
- A proof checker certifies only the step from a formal statement to its proof. Whether the statement is the right one is a question about the given condition, which no internal check reaches. In Demski's words, "Lean-verification can't distinguish a good model from a bad one."
- Logical induction answered the question of trust only for a reasoner's trust in its own future beliefs. When a reasoner may trust another that computes more is the question Demski is now working on.
- The verdict on logical induction is "My view, for now." The essay has not found anyone who joins outcome indistinguishability to logical induction.
:::
