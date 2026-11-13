---
title: "Study notes: The Bookmaker Is a Learner"
essay: the-bookmaker-is-a-learner
track: learners-and-uncertainty
reviewed-against: "d5ebe56"
requires:
  - {at: how-does-a-policy-improve#improving-a-distribution-without-throwing-away-the-prior, for: "the exponential tilt and its optimal value $\\eta\\log Z$, which the essay reads as an LMSR trade", strength: helpful}
  - {at: is-the-monastery-minded#simulation, for: "simulation by delegation and by artifact, which the last section applies to markets", strength: helpful}
  - {at: is-the-monastery-minded#the-nation-and-residual-integration, for: "the price system as the case that essay left open", strength: helpful}
introduces:
  - {term: the relay, at: paying-for-honesty, gloss: "the essay's name for Hanson's market scoring rule: a trader is paid the score of their forecast minus the score of the forecast they replaced"}
  - {term: liquidity parameter, at: the-bookmaker-is-a-learner, gloss: "the $b$ of the LMSR, which bounds the subsidy at $b\\log n$ and acts as an inverse learning rate"}
  - {term: regret and no-regret learning, at: the-bookmaker-is-a-learner}
  - {term: bandit and exploration, at: the-bookmaker-is-a-learner}
  - {term: mirror descent, at: the-bookmaker-is-a-learner}
  - {term: constant-function market maker, at: one-bookmaker-four-faces}
  - {term: matching as pricing at zero temperature, at: the-combinatorial-wall, gloss: "as $b\\to0$ the LMSR cost function tends to the house's worst-case liability, which is what matching computes"}
  - {term: marginal polytope, at: the-combinatorial-wall}
  - {term: proper scoring rule, at: paying-for-honesty}
  - {term: subset betting and pair betting, at: the-combinatorial-wall}
  - {term: market scoring rule, at: paying-for-honesty}
  - {term: cost-function market and the LMSR, at: one-bookmaker-four-faces}
  - {term: Hedge as a bookmaker, at: the-bookmaker-is-a-learner}
  - {term: follow the regularized leader, at: the-bookmaker-is-a-learner}
  - {term: combinatorial wall, at: the-combinatorial-wall, gloss: "over the $n!$ finishing orders of a race, matching pair bets is NP-hard and exact LMSR pricing is #P-hard for both betting languages"}
  - {term: wealth of traders as a second learner, at: is-the-market-minded, gloss: "across many questions a market reweights its traders through their accumulated money, multiplicatively for those who stake a fixed fraction of their wealth, as Hedge reweights experts"}
uses:
  - {term: exponential tilt, from: how-does-a-policy-improve}
  - {term: five conditions of mentality, from: minds-by-degrees-draft-v2}
  - {term: residual integration, from: is-the-monastery-minded}
---

The [mathematics companion](/notes/the-bookmaker-is-a-learner-mathematics.html) has its own study page, with the definitions and proofs. These questions follow the essay: what the bookmaker is, where it stops being computable, and what the markets of 2026 built instead.

### Three kinds of market {kind=distinguish at=three-ways-to-settle-a-bet}

Name the three kinds of market in the 2010 notes. Three traders bet on pairs among runners A, B and C: A ahead of B, B ahead of C, C ahead of A. Each bet pays \$1 and costs 70 cents. Why can the three clear together although no two of them match, and what does the third kind of market give up to avoid the problem?

::: answer
Orders that execute when they match, as on a stock exchange. A pool divided among the winners, the pari-mutuel system. A bookmaker who quotes a price, with the payout fixed at the moment of the trade.

The three bets cannot all win: under every finishing order one or two of them do. The house collects \$2.10 and pays out at most \$2. Finding such combinations among thousands of orders is a computational problem, and for pair bets a hard one. The bookmaker always takes the other side, so traders never need to find each other. The price of that convenience is that the bookmaker can lose money, so it needs a pricing rule that bounds the loss.
:::

### The worked example as a relay {kind=compute at=paying-for-honesty}

Two outcomes, logarithmic rule with $b=100$, market at 50%. A trader who believes YES has probability 70% moves the forecast to 70%. What are they paid if YES occurs, and if NO occurs? What is their expected gain at their own belief, and what is that quantity called? What is the most the market can cost its operator?

::: answer
The relay pays the score of the new forecast minus the score of the old one. If YES occurs: $100\log(0.7/0.5)\approx33.65$. If NO occurs: $100\log(0.3/0.5)\approx-51.08$, so they pay \$51.08. The expected gain is $0.7\cdot33.65-0.3\cdot51.08\approx8.23$, which is $b$ times the Kullback–Leibler divergence of their belief from the previous forecast. Moving the market to any other number would give a smaller expected gain at a belief of 70%. The operator pays in effect one forecaster, the last, for improving on the first, so its cost is at most $100\log2\approx69.31$.
:::

### The same trade as a purchase {kind=compute at=one-bookmaker-four-faces}

In the LMSR cost-function market with $b=100$ and no shares sold, how many YES shares move the price of YES from 50% to 70%, and what do they cost? Check the result against the relay's payments.

::: answer
The price of YES is $e^{q_Y/b}/(e^{q_Y/b}+e^{q_N/b})$, so a price of 0.7 needs $q_Y-q_N=100\log(0.7/0.3)\approx84.73$ shares. Their cost is $C(84.73,0)-C(0,0)=100\log\frac{1}{0.3}-100\log2=100\log(0.5/0.3)\approx51.08$. If YES occurs the shares pay \$84.73, a net gain of \$33.65. If NO occurs the \$51.08 is lost. Both figures are the relay's. The cost is the area under the price curve between the old share count and the new one.
:::

### Four faces {kind=recall at=one-bookmaker-four-faces}

Give the four descriptions of the bookmaker. Why are the first two one mechanism? Which description appeared after 2010?

::: answer
- Hanson's relay: each trader replaces the forecast and is paid the difference in score.
- Chen and Pennock's cost function: the bookmaker sells shares, and a bundle $a$ costs $C(q+a)-C(q)$.
- The sequential convex pari-mutuel mechanism: the bookmaker fills each order by solving a convex program, and the price is the dual variable of the constraint that tracks shares outstanding.
- The constant-function market maker of decentralized exchanges, which accepts any trade that keeps a fixed function of its reserves constant.

The first two are tied by convex duality: $C(q)=\sup_p\bigl(p\cdot q-\alpha(p)\bigr)$, where $\alpha(p)$ is the expected score of a forecaster who believes $p$ and announces it. The fourth came after 2010: in 2023 Frongillo, Papireddygari and Waggoner showed that every such market maker with a concave potential is equivalent to a cost-function prediction market.
:::

### What the liquidity parameter trades off {kind=explain at=the-bookmaker-is-a-learner}

In the dictionary between the LMSR and Hedge, what is $b$? Compare a deep market with a shallow one. When does the bookmaker's worst case occur? Why does $b$ drop out of the regret of the learner built from the LMSR?

::: answer
$b$ is an inverse learning rate, $\eta=1/b$. A deep market, with large $b$, moves slowly in response to each trade and risks a larger subsidy. A shallow one moves quickly and risks little, but it pays traders little for being right, and one trade can carry its price far from any consensus. The worst case comes when the traders were right: the outcome that occurs is the one they bought most, much of it while its price was still low. With $B=b\log n$ and $\varphi=2/b$ the regret bound $\sqrt{2B\varphi T}$ is $2\sqrt{T\log n}$. The essay's reason: a learner's regret cannot depend on the currency in which the market is denominated.
:::

### Hedge's position, not the bandit's {kind=distinguish at=the-bookmaker-is-a-learner}

How does a bandit differ from Hedge in what it sees, and what second job does temperature do in a bandit? Which position is the bookmaker in, and where does the exploration happen?

::: answer
Hedge sees every expert's gain in every round. A bandit sees only the gain of the arm it pulls, so it must sometimes pull the other arms and give up gains it expects from the arm it favors. In a bandit, spreading the weights hedges and also keeps sampling the arms the learner disfavors. A cold learner pulls them so rarely that dividing the observed gain by their probability turns its estimates into noise. The bookmaker is in Hedge's position: traders can buy any outcome, so it hears about all of them without acting. The exploration happens outside the mechanism, in the research traders do before they trade, and the subsidy is what makes that research pay. A bandit pays for information with its own gains; the bookmaker buys it.
:::

### The same reweighting elsewhere {kind=connect at=the-bookmaker-is-a-learner}

The essay finds the bookmaker's exponential reweighting again in the reinforcement-learning essays. What corresponds to the LMSR cost function, to a single trade, and to Hedge's accumulation of gains? What does a market escape that an on-policy learner does not?

::: answer
The regularized improvement step reweights a reference policy by $e^{Q/\eta}$, and its optimal value $\eta\log Z$ is the LMSR cost function, with the reference policy as the starting prices and $\eta$ as the liquidity. A single such step, which maximizes $\mathbb E_q[Q]-\eta\,\mathrm{KL}(q\|p)$, is a mirror-descent step, and so is an LMSR trade that buys $Q$ shares at $b=\eta$. Repeated improvement steps tilt the original policy by $kR/\eta$ after $k$ steps, which is Hedge's accumulation of gains applied to a policy.

A multiplicative step barely moves a probability near zero until the evidence for it is large. In a bandit or an on-policy learner that evidence arrives only through sampling, and an action near zero is rarely sampled. A market escapes this, because a trader who believes in a cheap outcome profits most by buying it.
:::

### Matching is pricing at zero temperature {kind=derive at=the-combinatorial-wall}

A house has sold $q_{kl}$ shares in "runner $k$ finishes in position $l$". Write what it owes under a finishing order $\sigma$, what matching asks for and what LMSR pricing asks for. Show how the first is a limit of the second, and say which is easy.

::: answer
The house owes $Q_\sigma=\sum_kq_{k\sigma(k)}$. Matching asks for the worst order, $\max_\sigma Q_\sigma$, which a maximum-weight matching between runners and positions finds in polynomial time. Pricing asks for $C(q)=b\log\sum_\sigma e^{Q_\sigma/b}$, which is $b$ times the logarithm of a permanent and is #P-hard. As $b$ shrinks toward zero the largest term dominates the sum, and $C(q)$ tends to $\max_\sigma Q_\sigma$. At zero temperature the bookmaker needs only the worst finishing order. At any positive temperature it needs a sum over all of them.
:::

### Two ways past the wall {kind=distinguish at=the-combinatorial-wall}

The 2010 notes end with empty headings. One answer from the literature changes the bookmaker and another changes the language of bets. Describe each. What licenses the first?

::: answer
*Changing the bookmaker.* Helmbold and Warmuth's learner over permutations keeps an $n\times n$ matrix of weights, one per runner and position, and rebalances it after each round so that rows and columns sum to one. Run as a bookmaker it quotes subset-betting prices in polynomial time, and its regret bound becomes a bound on its loss. It is not the exact LMSR. The identity licenses the substitution: what we need from a bookmaker is a bounded loss and prices that move toward the traders' information, and a learner with bounded regret supplies both.

*Changing the language.* For a single-elimination tournament, bets such as "team $i$ wins game $k$" keep the LMSR distribution representable as a Bayesian network whose graph is the bracket. A trade touches only a few local tables, so prices stay exact.
:::

### What the venues built {kind=recall at=what-2026-built-instead}

Which of the three kinds of market do the large venues of 2026 run? How are parlays priced, and who keeps a joint distribution over their legs? Where is consistency between related markets enforced, and where is it left to traders?

::: answer
Kalshi and Polymarket run limit order books, the first kind, with professional firms quoting both sides. The subsidy survives as liquidity rewards paid to those firms, a cash budget and not a bound like $b\log n$. Parlays are priced by request for quote: a trader asks and dealers answer. Almost nobody keeps a joint distribution. The venue keeps none, one dealer seems to model the correlations between legs, and the others, by Oddpool's guess, multiply single-game prices together. The essay calls this the combinatorial wall sidestepped, not climbed. Polymarket builds one consistency rule into its tokens: for mutually exclusive answers, a NO share on one converts into YES shares on all the others, so the prices sum to one. Everything more structured is left to arbitrageurs.
:::

### Why the corporate markets closed {kind=recall at=what-2026-built-instead}

Cultivate Labs stopped supporting prediction markets in 2022. Which four problems did it cite, what did it keep, and what was not among its reasons?

::: answer
- A price depends on the whole sequence of trades, so a crowd forecast cannot be recomputed from a chosen subset of forecasters, such as the best ones.
- The market currency intimidates people.
- Markets invite manipulation, through duplicate accounts or questions written by people who control the outcome.
- In the vendor's words, "we don't know what game people are playing."

It replaced the market with opinion pools rewarded by a proper scoring rule. In the essay's terms, it kept the score and removed the relay. Accuracy was not among the reasons: the vendor wrote that market prices were "just as accurate" as its other aggregation methods.
:::

### What the relay pays for {kind=explain at=what-a-market-adds-to-a-scoring-rule}

What does a market scoring rule pay for that a scoring rule does not? On one benchmark a model's forecasts were better calibrated than the market's prices, and betting on them returned 94 cents per dollar staked, against 90 cents for betting blindly at the market's prices. How does the essay read that result? What do markets of language-model traders show "from the other side"?

::: answer
A scoring rule pays each forecaster for their forecast. A market scoring rule pays each trader only for the part of their forecast that the market did not already have. The better forecasts narrowed the loss without turning it into a profit: a market pays only for moving its price toward the truth, and only when the move is worth more than the cost of trading. A forecaster whose information is mostly in the price already has little to sell. From the other side, a simulated market of preference-tuned traders with correlated errors was right less often than a single agent. A market aggregates diversity of information, and AI forecasting has yet to supply the diversity the relay needs.
:::

### Is the market minded? {kind=case at=is-the-market-minded}

The essay tests four conditions of *Minds by Degrees* on prediction markets: accuracy-responsive dynamics, unity, vehicles and simulation. Give its verdict on each, and say how the tournament bookmaker differs from a market of independent contracts and from the 2026 parlay venues.

::: answer
*Accuracy-responsiveness* the bookmaker has by design: trades are rewarded only when they move the price toward the truth, and the revision rule is a no-regret learner. *Unity* depends on design. An LMSR over all the outcomes of a question is a single economy, because a purchase in one outcome moves every other price through the bookmaker's own state. Separate binary markets are coupled only when an arbitrageur notices a contradiction. *Vehicles*: the exact combinatorial bookmaker's distribution over all finishing orders is as counterfactually rich as a vehicle can be, and it is the one that cannot be computed.

*Simulation* divides the cases. In a market of independent contracts every model of the world runs inside some trader and only orders enter, which is simulation by delegation and fails the condition. The tournament bookmaker propagates a trade through its Bayesian network, a transformation of its own that mirrors the tournament: simulation by artifact. The 2026 venues are still delegation, since the joint structure lives, if anywhere, in one dealer.
:::

### How weak the claim is {kind=limits at=is-the-market-minded}

The market with the strongest claim to a thin mind is the one the notes described and the 2026 venues did not build. Why does the essay call even that claim weak? What does it offer as a kind of memory, and what does it leave open?

::: answer
The bookmaker's accuracy-responsiveness is the learning of a single distribution about a single question, and it ends when the question resolves. Nothing a market learned carries into the next market, except in the wealth of the traders who were right. That wealth is a kind of memory: over many questions a market does weight its best forecasters, through their accumulated money. For traders who stake a fixed fraction of their wealth the reweighting is multiplicative, a second learner at a longer timescale with traders as its experts. Whether psychology has anything to add to that description beyond economics is left open, as the monastery essay left it. The verdict also qualifies that essay, which had credited futures prices with running a model of the world forward: each correction of a futures price is computed in some trader's head.
:::
