# Outline: an essay on prediction markets, from the 2010 lecture notes

Status: outline for review, 28 Oct 2026. Sample sentences show register only. Sections carry no word budgets; length follows content. Facts and citations come from `prediction-markets-dossier.md` (§ numbers below prefixed "D§" refer to it); its §4 numbers must be rechecked before drafting.

## Form

- **One essay plus a companion page.** The essay carries the ideas, a few displayed equations, one worked example and the 2026 picture. The companion is a corrected English rendering of the 2010 notes' mathematics, with sources: the reference a reader who wants the proofs can follow. The essay links into the companion by section; the companion does not retell the essay.
- **The essay opens from the notes and treats them as a 2010 snapshot, not as authority.** Where later work superseded them (Abernethy–Chen–Vaughan 2013 subsumes the notes' §5) the essay says so. Where they stopped (the empty §§6.3–6.4), the essay finishes them.
- None of the existing essays has an appendix, so the companion sets a pattern. Proposal: a separate page `notes/prediction-markets-companion.md`, listed in the index right after the essay with its own one-line description, so readers who don't want the proofs can skip it.

## Title candidates

1. *Prices Are Weights: Prediction Markets, Sixteen Years On*
2. *The Bookmaker Is a Learner*
3. *What the Market Maker Knew*

Subtitle (Substack): "A market maker that cannot go broke is a learning algorithm. Revisiting my 2010 lecture notes on prediction markets, and what the 2026 markets built instead." (To be tightened.)

---

## 1. Thesis

An automated market maker with bounded loss and a no-regret learning algorithm are the same object. The market's prices are the learner's weights over the outcomes, the shares sold are its negative accumulated losses, and the market maker's worst-case subsidy is its regret bound. Scoring rules, cost functions, convex pari-mutuel programs, and, as it turned out after 2010, constant-function market makers in decentralized finance are four presentations of one convex-duality construction. The construction meets a computational wall when the outcome space is combinatorial, and the learner view is what gets it partly over the wall.

The 2026 twist: the real-money prediction markets that boomed did not adopt the machine. They run order books with paid human and algorithmic dealers, and their largest product, the parlay, is priced on request by a handful of dealers who mostly treat its legs as independent. The parts of the 2010 theory survived elsewhere: the cost function in DeFi, the scoring rule alone in corporate forecasting pools and AI forecasting benchmarks, the learner view in the research that keeps combinatorial market making tractable.

What makes this more than a tutorial:

1. **One identity carries the technical half.** LMSR prices are a softmax of the shares outstanding, with the liquidity parameter $b$ as temperature. A reader who knows softmax from neural networks or Hedge from online learning sees the market maker immediately; everything in §§3–5 unpacks this identity.
2. **The wall is shown, not asserted.** Pair betting has only $n(n-1)$ securities yet matching orders is NP-hard, and pricing is #P-hard. The reader gets one picture (three bets in a cycle that clear jointly though no two match) and the reason the hardness follows.
3. **The 2026 markets are read as an answer to the wall.** Dealers quoting parlays under independence, $40M of arbitrage left on Polymarket's table, negRisk building mutual exclusivity into tokens: each is a way of not maintaining a joint distribution.
4. **The scoring rule outlived the market.** Corporate prediction markets died (Cultivate Labs, 2022) and were replaced by opinion pools scored by proper scoring rules; AI forecasters are trained and ranked by log or Brier loss. Read through the 2010 equivalence, this is the market with the relay removed. What the relay adds, aggregation across diverse holders of information, is exactly what correlated LLM traders lack (D§3.2: a ten-agent market of preference-tuned models underperforms a single agent).

Sample sentence: "A market maker that cannot be bankrupted by any sequence of trades is running a learning algorithm, whether its designers call it one or not."

---

## 2. Essay sections

### §0 Opening

**Purpose:** show the change in sixteen years before introducing any mechanism.

- Two lists. From the 2010 notes, a telecom firm's market questions (InklingMarkets case study): "How many critical bugs will be in the bug tracking system for Product X by Y date?", "Will outsource supplier of widget X fulfil their order by the agreed date?" From October 2026: Kalshi's volume, more than half of it in sports parlays, a parlay being a bet that every one of several games goes a stated way (D§4 items 2, 5).
- The corporate markets are gone and the parlays are booming, and neither outcome shows what the theory in the notes was about. Say in two sentences what it was about (the thesis), and that the notes' unfinished sections get finished here.
- One sentence on provenance: lecture notes for an Algorithmic Game Theory course, spring 2010; the companion page is their corrected mathematics.

Alternative opening (if the user prefers technical first): the softmax identity, then the two lists in §6.

### §1 Three ways to settle a bet

**Purpose:** give the reader the three market types the whole essay uses, and the liquidity problem that motivates the market maker.

- The notes' typology: (1) match orders between traders (exchange); (2) pool the wagers and split the pool among winners (pari-mutuel); (3) trade with a market maker at a price fixed at trade time.
- The liquidity problem: in thin markets, orders don't meet. The combinatorial version: three traders bet A > B, B > C, C > A. No two orders match, yet all three clear together, because at least one must lose (the cycle is impossible as an ordering). This picture returns in §5.
- Map to 2026 in one paragraph: Kalshi and Polymarket are type (1) with paid market makers; type (2) survives in horse racing; the parlay RFQ is type (3) run by private dealers rather than by the venue.
- Lineage aside (box candidate): Eisenberg and Gale's 1959 convex program, now taught as the market-clearing program for Fisher markets, was published as "Consensus of subjective probabilities: the pari-mutuel method" (D§3.1). The notes taught it as market equilibrium and did not know where it came from.

### §2 Paying for honesty

**Purpose:** introduce proper scoring rules and Hanson's market scoring rule as a relay.

- A scoring rule pays a forecaster as a function of the forecast and the outcome; it is proper when reporting your true belief maximizes your expected score. Log rule $s_i(p) = b\log p_i$; quadratic (Brier) rule.
- Hanson's market scoring rule: each trader who moves the market's forecast from $p$ to $p'$ pays the score of $p$ and collects the score of $p'$. The market maker pays only the final forecaster's score minus the initial one, so its subsidy is bounded: for the log rule with $n$ outcomes, $b\ln n$.
- **Worked example** (computed 28 Oct): two outcomes, $b = 100$, market at 50%. A trader who believes 70% buys about 84.7 YES shares for about \$51.08 ($= 100\ln(5/3)$), which moves the price to 70%. If YES occurs they collect \$84.73. Their expected gain at their own belief is about \$8.23, which is $b$ times the KL divergence of their belief from the market's, $b\,[0.7\ln(0.7/0.5)+0.3\ln(0.3/0.5)]$. The most the market maker can lose on this market, whatever happens, is $100\ln 2 \approx \$69.31$.
- Honesty is only myopic. A trader who anticipates later traders may gain by bluffing (Chen et al. 2010). Ostrovsky (2012) gives the reassurance: information is aggregated in every equilibrium iff the security is "separable". One paragraph.
- The one-shot version: Lambert et al.'s wagering mechanisms (pay each wager its score relative to the wager-weighted mean); one paragraph or a box, since it is where corporate pools ended up (§6).

### §3 One mechanism, four faces

**Purpose:** show that the different market makers are one construction.

- The cost-function view (Chen–Pennock 2007): sell Arrow–Debreu shares; buying a bundle costs $C(q+a) - C(q)$; prices are $\partial C/\partial q_i$. LMSR: $C(q) = b\log\sum_i e^{q_i/b}$, so $p = \mathrm{softmax}(q/b)$.
- Conjugacy: every valid convex cost function is $C(q) = \sup_{p\in\Delta}\,(p\cdot q - \alpha(p))$, and $\alpha$ pins down the scoring rule. For LMSR, $\alpha$ is $b$ times negative entropy. The market maker's worst-case loss is the range of $\alpha$, which for LMSR is $b\ln n$ again.
- SCPM: the price is the shadow price of a convex program the operator solves per order (one paragraph; the KKT derivation goes to the companion). The original SCPM was not truthful; charging the integral of marginal prices repairs it and makes it a cost-function market (Agrawal et al. 2009).
- The fourth face, after 2010: constant-function market makers like Uniswap are cost-function prediction markets and define proper scoring rules (Frongillo, Papireddygari, Waggoner, ITCS 2024). The construction lost the prediction-market venues and won decentralized exchange.

### §4 The market maker is a learner

**Purpose:** the essay's core identity, shown in both directions.

- Treat each outcome as an expert. Let the shares outstanding in outcome $i$ be, up to a common shift and scale, the negative of expert $i$'s accumulated loss. Then LMSR prices are exactly the Hedge / exponential-weights algorithm's weights. The learner's regret bound becomes the market maker's loss bound, and in the limit of small trades that bound is $b\ln n$ (Chen et al. 2008).
- The converse (Chen & Wortman Vaughan 2010): any cost-function market maker with bounded loss and smooth prices yields a no-regret learner, regret $\le\sqrt{2B\varphi T}$. The regularizer of follow-the-regularized-leader is the market's $\alpha$.
- What the identity means: liquidity $b$ is an inverse learning rate. A deep market moves slowly and can lose more; a shallow one moves fast and loses little. The market maker pays for information exactly what a learner pays in regret.
- After 2010: Abernethy, Chen, Wortman Vaughan (2013) derive the duality-based cost function from axioms and identify trading with FTRL; price dynamics as mirror descent (Frongillo et al. 2012). One paragraph, which also tells the reader the notes' §5 is subsumed.
- Tie to the blog's ML essays in one sentence: next-token training minimizes the log scoring rule, the same rule whose market version is LMSR. (Link, don't recap.)

### §5 The combinatorial wall

**Purpose:** show why markets over orderings, brackets or Boolean combinations are hard, and the two ways around it the 2010 literature found. This is where the notes stop and the essay finishes them.

- Bidding languages over permutations: subset betting ("candidate α finishes in positions Φ") and pair betting ("α beats β").
- Matching: divisible subset betting is polynomial (ellipsoid with a bipartite-matching separation oracle); pair betting is NP-hard in both versions, via minimum feedback arc set. Return to §1's cycle: a profitable cycle can be found in polynomial time, but interleaved cycles defeat the greedy method.
- Pricing: LMSR prices for subset betting are #P-hard (the permanent), and for pair betting too (counting linear extensions). One sentence on why: a price is a ratio of sums over all $n!$ orderings.
- **First way around: use the learner.** Since LMSR is Hedge, replace it with a learner over permutations that is tractable: Helmbold and Warmuth's PermELearn keeps a doubly stochastic matrix and Sinkhorn-balances it after each update. As a market maker this gives approximate subset-betting prices in polynomial time, with worst-case loss at most $b\,n\ln n$ (Chen et al. 2008). The §4 identity, which looked like a curiosity, turns into an algorithm. (This is the notes' empty §6.3.)
- **Second way around: choose the language.** For tournaments, bets of the form "team *i* wins game *k*" and "*i* beats *j* if they meet" keep LMSR prices exact in $O(n^3)$ per trade, by a Bayesian network on the bracket (Chen, Goel, Pennock 2008). (The notes' empty §6.4.)
- After 2010, one paragraph: the price space is a marginal polytope, and practical combinatorial market makers project onto it with Frank–Wolfe and an integer-programming oracle (Kroer et al. 2016, $2^{63}$ outcomes); the 2025 geometric view (Hossain, Wang, Yu). The same move as variational inference in graphical models; one sentence.

### §6 What 2026 built instead

**Purpose:** read the 2026 markets through §§1–5. Numbers rechecked before drafting.

- Order books with paid market makers won the real-money venues; no notable venue runs a cost-function market maker. The subsidy survives as liquidity-reward budgets, not as a loss bound.
- Parlays are the largest product, and they are combinatorial bets in the simplest language, conjunctions of legs. Venues price them by request for quote. The Oddpool census found 13 quoters, two answering half the requests, and in the authors' reading only one pricing correlations. This is the wall sidestepped: nobody maintains the joint distribution.
- Consistency across linked markets is left to arbitrageurs: about \$40M realized on Polymarket (Saguillo et al. 2025), 2–4% gaps across venues. Polymarket's negRisk builds mutual exclusivity into the tokens, the notes' "simple" market enforced by contract rather than by a market maker.
- The scoring rule outlived the market. Corporate prediction markets died; Cultivate Labs' 2022 reasons (no way to weight a subset of good forecasters, currency puts people off, manipulation, unreadable motives), and their replacement: opinion pools scored by proper scoring rules. Read through §§2–4: the relay removed, the score kept.
- Briefly, what the theory did not model: favourite–longshot bias and makers vs takers (Bürgi, Deng, Whelan 2026), sports as the volume driver, wash trading, insider cases, oracle disputes, and law (the circuit split). One paragraph; the essay is not about regulation.

### §7 Forecasters that are learners

**Purpose:** close on what a market adds over a scoring rule, using AI forecasters as the test.

- AI forecasters are now near the crowd: Metaculus bot benchmark gap shrinking to non-significance in Spring 2026; ForecastBench parity with superforecasters. Prophet Arena: a model better calibrated than Kalshi's prices still lost money trading against them, which is §2's point read from the trader's side: the market pays for information its price lacks, not for calibration.
- Markets of LLM traders aggregate poorly when the traders are alike (errors correlated around 0.7; Begin et al. 2026) and reason only a couple of levels deep about each other (Galanis 2026). A market aggregates diversity of information, not headcount.
- Closing move: the relay of §2 is what made a market more than a scoring rule. The 2026 markets kept the relay for sports and dropped it for organizations; AI forecasting kept the score and has yet to supply the diversity the relay needs. One paragraph, no prediction beyond that.
- Open: a one-paragraph link to the monastery essay (is a market a collective cognizer?). Include only if it earns its place; the default is to leave it out.

---

## 3. Companion page

*Prediction Markets: The Mathematics* (working title). A corrected English rendering of the 2010 notes, by the notes' own sections, with sources attached (D§3.1) and corrections applied silently except where a correction is itself instructive (D§2).

1. Market types and desirable properties; the weighted-score wagering mechanism (Lambert et al. 2008, Thm 3), with the five-property characterization stated correctly.
2. Market scoring rules, cost-function markets, SCPM: definitions.
3. Convex duality toolkit: Lagrangian, weak/strong duality, Slater; zero-sum games as a dual pair; KKT; sensitivity and shadow prices; Eisenberg–Gale (with its pari-mutuel origin); ellipsoid method. Kept short: it is there so §§4–5 can be read without a textbook.
4. SCPM's KKT conditions and Lemma 2 (prices sum to one, nonnegative, monotone, integrable).
5. Equivalences: LMSR = Hedge (with the corrected bound); market → learner (Lemma 3, Thm 4, corrected proof); MSR ⇔ cost function via conjugacy (Lemmas 5–8, Thm 10, with "convex" restored); FTRL (Thm 11); cost function ⇔ SCPM (Thms 13–15; original SCPM's pricing stated correctly).
6. Combinatorial markets: matching (Thm 16; pair-betting NP-hardness via feedback arc set, Lemma 17 "unweighted"; cycle condition and its polynomial search; Lemma 29 as a lower bound); #P-hardness of pricing; **new**: PermELearn + Sinkhorn approximate market maker with its $b\,n\ln n$ bound; **new**: tournament pricing by Bayesian network.
7. A short "since 2010" section pointing to Abernethy–Chen–Vaughan 2013 for the general framework and to the combinatorial market-making line, so the companion does not pretend to be current.
8. Exercises from the 2010 sheet (translated), optionally with solution sketches.

---

## 4. Decisions (user, 28 Oct 2026)

1. **Title:** *The Bookmaker Is a Learner*.
2. **Opening:** the two lists.
3. **Companion:** linked in the *same* index entry as the essay, each link on its own line of one paragraph. Exercises included (translated); solution sketches at our discretion.
4. **Math density:** as proposed; in case of doubt, higher rather than lower.
5. **Provenance:** the user was a teaching assistant for the course at the University of Wrocław and ran the weekly one-hour exercise sessions (the course had a one-hour lecture and a one-hour exercise session per week), gave this one lecture, and wrote two exercise sets (the prediction-market sheet and the bandit sheet); the main lecturer gave the other lectures. The lecturer was Sebastian Bala (the user found out on 28 Oct; an earlier guess of Emanuel Kieroński was wrong), and the essay names him.
6. **Closing:** keep §7's AI-forecaster close **and include the collective-cognizer link to *Is the Monastery Minded?***. Add connections to other blog essays wherever they genuinely connect.
7. **Figures:** all three (LMSR price curve with the worked example; the three-bet cycle; combo share), matplotlib SVG.
8. **New: a box on linear programming**, connected to the Lagrange multipliers covered in *How Does a Policy Improve?* (its Lagrange box, and its REPS section, where the value function arises as multipliers on flow constraints). Placement: §3, beside SCPM's shadow prices, or §5 before the matching LPs.
