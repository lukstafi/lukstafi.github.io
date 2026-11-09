# Technical review of *Before the Search Settles*, 9 November 2026

Draft checked: `notes/before-the-search-settles.md`, working copy of 9 November. This covers the claims, the mathematics and the citations. Priority went to material added today: the Solomonoff box, the construction and proof sketch in "A bookmaker over sentences", the five-and-ten paragraph, and the new links in "Learning without new evidence". Items that `citecheck-logical-uncertainty-2026-11-01.md` already verified were not redone unless the wording has drifted since.

Sources read for this pass:

- *Logical Induction* arXiv:1609.03543v5, from the scratchpad text extraction: §§3.3–3.6, all of §5, §7.2, Desiderata 7, 8 and 13, Theorems 4.6.2 and 4.11.2.
- Sawin and Demski, `intelligence.org/files/Pi1Pi2Problem.pdf`, full text.
- Garrabrant's 2017 post, on greaterwrong.
- OPST arXiv:2610.32770, HTML full text.
- Beygelzimer, Langford and Pennock arXiv:1201.6655, full text.
- Dwork et al., *Outcome Indistinguishability*, full text.
- Demski's "What comes with cheap math?".
- MIRI's 2020 strategy update.
- The abstract of Solomonoff 1978, through secondary sources, and Hutter's statement of the 1978 bound (cs/9912008).
- The anchors of the linked companion essays, in the built HTML.

Findings are numbered so they can be cited. Within each part, the ones that matter most come first.

## 1. Errors and imprecisions worth fixing

### E1. The semimeasure inequality is justified by containment alone, and it needs disjointness

**Original:** "Monotonicity makes the probabilities of prefixes fit together. Every output that begins with $x1$ also begins with $x$, so $M(x0)+M(x1)\le M(x)$."

**Problem:** Containment gives $M(x0)\le M(x)$ and $M(x1)\le M(x)$ separately, but it does not give their sum. The sum needs the two events to be disjoint: no output begins with both $x0$ and $x1$. Monotonicity is what makes them disjoint. Because output is never revised, each infinite input (the coin flips) determines a single output, finite or infinite, so "begins with $x0$" and "begins with $x1$" cannot both hold. This is the step on which the box's point rests (that the draft's comparison needed monotone machines). As written, the sentence reads as if monotonicity were not used.

**Evidence:** the standard definition is $M(x)=\lambda\{\omega: U(\omega)\sqsupseteq x\}$ over infinite inputs $\omega$. Disjointness of the cylinders $\{U(\omega)\sqsupseteq x0\}$ and $\{U(\omega)\sqsupseteq x1\}$ follows because $U(\omega)$ is a single sequence (Li and Vitányi, §4.5).

**Proposed:** "Monotonicity makes the probabilities of prefixes fit together. Because nothing printed is ever revised, each run of coin flips produces one output, so no output begins with both $x0$ and $x1$, and every output that begins with either begins with $x$. Hence $M(x0)+M(x1)\le M(x)$."

### E2. M averages the predictors that can be approximated from below, not only the computable ones

**Original:** "$M$ is a Bayesian mixture. Up to a constant factor, it averages all computable predictors, weighting each by $2^{-K}$ for its own description length. Bayes' rule is Hedge at log loss, so in the bookmaker essay's terms $M$ is a market in which every computable predictor bets on its own predictions, starting with wealth that halves with every bit of its description."

**Problem:** The theorem behind "up to a constant factor" (Zvonkin and Levin 1970; Li and Vitányi §4.5) says that $M$ equals, within constant factors both ways, the mixture $\xi=\sum_\nu 2^{-K(\nu)}\nu$ over all *lower semicomputable semimeasures* $\nu$. These are predictors whose probabilities can be approximated from below and need not sum to 1. The computable measures are a proper subset. A mixture over the computable measures alone is not lower semicomputable, and the textbook equivalence is not stated for it (Hutter, *Universal Artificial Intelligence*, §2.4). The difference does matter at the box's level, in two places:
- The box's own last paragraph says that $M$ "can be approximated from below", which makes $M$ one of the predictors it averages. A mixture over the computable predictors could not contain $M$, since $M$ is not computable.
- The defective components are why $M$ is a semimeasure. They are what makes the inequality in the second paragraph strict.

Dominance over every computable $\mu$ (the third paragraph) is unaffected, because it holds a fortiori.

**Proposed:** "$M$ is a Bayesian mixture. Up to a constant factor, it averages every predictor whose probabilities can be approximated from below, the computable ones among them, weighting each by $2^{-K}$ for its own description length. Bayes' rule is Hedge at log loss, so in the bookmaker essay's terms $M$ is a market in which each of these predictors bets on its own predictions, starting with wealth that halves with every bit of its description." A shorter alternative keeps "computable" and drops "Up to a constant factor": "In effect, it averages all computable predictors…". That alternative is acceptable but loose.

### E3. "A program that produces $x$ … contributes $2^{-\ell}$" double-counts

**Original:** "A program that produces $x$ after reading $\ell$ bits contributes $2^{-\ell}$, so short programs carry most of the weight, and a string with a short description gets a high probability."

**Problem:** If $p$ has printed $x$ after reading its $\ell$ bits, then $p0$ and $p1$ have also printed $x$ after $\ell+1$ bits. Summing $2^{-\ell}$ over all such programs counts the same coin flips several times and can exceed 1. Only the *minimal* programs count: those that have printed $x$ by their last bit, while no proper prefix had. Then $M(x)=\sum_{p\ \text{minimal}}2^{-|p|}$. The previous sentence ("the chance that the output begins with $x$") is already correct, so this is a slip in the gloss.

**Proposed:** "A program that has printed $x$ by the time it has read its $\ell$ bits, and not before, contributes $2^{-\ell}$, so short programs carry most of the weight…"

### E4. Convergence from Solomonoff's bound is almost sure, not on every sequence

**Original:** "If the sequence is in fact drawn from $\mu$, Solomonoff proved in 1978 that the expected squared errors of $M$'s predictions, summed over the whole infinite sequence, total at most about $\tfrac{\ln 2}{2}K(\mu)$. So $M$'s predictions converge to $\mu$'s."

**What checks out:** the constant and the attribution. The abstract of Solomonoff, "Complexity-based induction systems: comparisons and convergence theorems", *IEEE Trans. Inf. Theory* 24(4) (1978), 422–432, bounds "the expected value of the total squared error in these conditional probabilities" by $-\tfrac12\ln C$, where $C$ is the constant in $P_M\ge C\mu$. With $C=2^{-K(\mu)-O(1)}$, that is $\tfrac{\ln 2}{2}K(\mu)$ plus a constant. Hutter (IDSIA-11-00, cs/9912008) states it as $\sum_t \mathbb E[(\xi(0|x_{<t})-\mu(0|x_{<t}))^2]<\tfrac12\ln 2\cdot K(\mu)$. The "about" covers the additive constant and the choice of normalized or unnormalized $M$. Secondary sources state the bound for the conditional probabilities of the approximating measure. I could not confirm from the 1978 full text which form of $M$ the bound is proved for, and the essay's "about" makes that harmless. The 1978 abstract also describes the 1964 machine as having "unidirectional output tape and a randomly coded unidirectional input tape". That supports introducing the monotone machine as Solomonoff's own 1964 construction.

**Problem:** A finite expected sum gives convergence with $\mu$-probability 1 (and in mean square), not on every sequence. The box contrasts this with the regret bound, which does hold "on every sequence", so the difference is worth one word.

**Proposed:** "So, with probability 1 under $\mu$, $M$'s predictions converge to $\mu$'s."

### E5. Garrabrant's exploration is triggered by the agent's own forecast, not by a fixed coin

**Original:** "Making the agent take every action with some small probability $\varepsilon$ lets it learn to take the ten, at the cost of taking a bad action, perhaps a disastrous one, a fraction $\varepsilon$ of the time."

**Problem:** This is not wrong, but it is not Garrabrant's rule. In the post, the agent takes an action whenever its logical inductor's probability that it takes that action is below $\varepsilon$, and otherwise compares conditional expectations. The self-reference is what keeps traders from predicting the exploration. Everything else in the paragraph checks out (see V9).

**Evidence:** Garrabrant, "Two Major Obstacles for Logical Inductor Decision Theory" (17 Apr 2017): the agent "does in fact converge to choosing 10 all but epsilon proportion or the time", and "taking a bad action with probability epsilon could be disastrous for an agent that makes many different decisions."

**Proposed:** "Making the agent take any action that its own market gives it less than a small probability $\varepsilon$ of taking lets it learn to take the ten, at the cost of taking a bad action, perhaps a disastrous one, a fraction $\varepsilon$ of the time."

### E6. MIRI did not quite "abandon" the 2017 directions

**Original:** "MIRI abandoned its undisclosed 2017 research directions in December 2020 and made policy and communication its priority in January 2024."

**Problem:** The essay's wording has drifted from the citecheck (correction 5: "largely failed"). The December 2020 post says the project "has, at this point, largely failed" and that "MIRI sees the need for a change of course with respect to these projects". It adds that some staff were trying to rescue the lines of research and that MIRI "may carry forward theories and insights" from them. Calling that "abandoned" is a stretch, though not by much.

**Proposed:** "MIRI wrote in December 2020 that its undisclosed 2017 research directions had "largely failed," and made policy and communication its priority in January 2024."

## 2. Minor wording and optional precision

### M1. The paradox-resistance theorem drops "e.c."

**Original:** "The paper's theorem on paradox resistance states, for any rational $p$ strictly between 0 and 1,"

Theorem 4.11.2 assumes an "e.c. sequence of 'paradoxical sentences'". Without that assumption the statement is not the theorem, because a market can only be held to account on sequences that traders can compute. **Proposed:** "The paper's theorem on paradox resistance states, for any rational $p$ strictly between 0 and 1 and any efficiently computable sequence of such sentences,".

### M2. LI's prior halves along the index, which is far steeper than Solomonoff's

**Original:** "It too weights its traders by a prior that halves along an enumeration."

This is accurate (eq. 5.3.2, weight $2^{-k-b}$). But "It too" invites the reader to equate the two priors. In Solomonoff's prior the weight halves with every bit of description. In LI's it halves with every step of the enumeration of machine–polynomial pairs, and a trader whose code is $\ell$ bits long sits near index $2^\ell$. Any summable weights would serve the proof. This is optional. **Proposed, if wanted:** "It too weights its traders by a prior that halves, though along an enumeration instead of with each bit."

### M3. "Abysmal" describes logical inductors in general

**Original:** "It is computable, and the paper calls its runtime "abysmal.""

§7.2 says logical inductors "have abysmal runtime and uncomputable convergence bounds", and §5.5 says LIA's runtime is "underspecified". The essay's sentence is fair. **Proposed, if exactness is wanted:** "It is computable, and the paper says logical inductors have "abysmal runtime.""

### M4. The multiplicative-step sentence could also name the sampling

**Original:** "Unmarking a line in an adaptive proof restores its conclusion at once, while a learner that has driven a hypothesis near zero climbs back slowly, because a multiplicative step moves a probability in proportion to its size."

This is correct. It is the same claim as the bookmaker essay's box ("A multiplicative step changes a probability in proportion to its size"). Under full-information Hedge, the climb from $p$ takes on the order of $\ln(1/p)/\eta$ rounds of consistent advantage, which is slow compared with "at once". On-policy, it is worse: the step on the logit is itself scaled by the chance of sampling the hypothesis, so the climb grows like $1/p$. The previous paragraph has just made the bandit point, so this is optional. **Proposed, if wanted:** "…climbs back slowly, because a multiplicative step moves a probability in proportion to its size, and an on-policy learner samples the hypothesis in proportion to its size too."

### M5. Five-and-ten: the hedge is right, and one clause would show why it is needed

**Original:** "With a suitable order of search, the agent can prove from its own code that if $\varphi$ is provable, it takes the five, and so that $\varphi$ is true if provable."

This checks out (V8). The hedge is needed, not merely cautious. The same Löbian argument applied to $\psi$ = "five gets 0, ten gets 10" also goes through, and which of the two the agent proves depends only on the order of its search. This is optional and would make the point sharper. **Proposed, if wanted:** add after "the proof is valid": "Under another order the same argument proves the opposite statement and the agent takes the ten; the logic does not decide which."

### M6. Proof sketch: trader $k$ joins on day $k$

**Original:** "Trader $k$ joins the firm once for every budget $b$, with the fixed weight $2^{-k-b}$."

In eq. 5.3.2, the firm uses $S^k$, which is trader $k$'s strategy from day $k$ on and zero before. The missing early trades differ by a bounded amount, so the sketch's argument is unaffected. Leave it as is unless "joins" should be literal. It already reads naturally as "joins on day $k$".

## 3. Verified

### Solomonoff box

- **V1. Monotone machine.** The three tapes, the one-way input and output heads and the free work tapes match the standard definition. Solomonoff's own 1978 description of the 1964 machine is "unidirectional output tape and a randomly coded unidirectional input tape".
- **V2. Prefixes and continuations.** $M(x)$ is the probability that the output begins with $x$, and the next-bit prediction is $M(x1)/M(x)$. The inequality can be strict because programs may print nothing more. A machine that prints a whole answer gives the discrete $m(x)$, which treats $x$ and its extensions as separate outcomes. That is correct, but see E1 for the justification of the inequality.
- **V3. Dominance and regret.**
  - Dominance $M(x)\ge 2^{-K(\mu)}\mu(x)$, up to a machine-dependent constant factor, is correct for every computable $\mu$, and in fact for every lower semicomputable semimeasure. Here $K$ is prefix complexity.
  - The regret reading is correct on every sequence and every $n$, because $-\log_2 M(x_{1:n})$ telescopes into the summed log loss of the conditionals (and $M(\epsilon)=1$).
- **V4. Approximation and π.**
  - It is correct that $M$ is lower semicomputable but not computable, and that no computable bound on the approximation error exists, since one would make $M$ computable.
  - The claim that, shown π, $M$ predicts every later digit with near certainty holds even jointly. Since $\lim_n M(\pi_{1:n})\ge 2^{-K(\pi)-c}>0$, the conditional probability that all future bits follow π tends to 1.
- **V5. LI quotes in the box.** LI §7.2: "This merges the framework of Solomonoff (1964a) with that of Gaifman (1964)", which supports "names Solomonoff and Gaifman as the two frameworks it merges". "our "experts" are not themselves predicting the world" is verbatim (§7.2, "Keep the experts small"). The same passage has "if a trader sees that P(φ) + P(¬φ) ≪ 1, they can buy shares", which matches the box's last sentence.

### Construction and proof sketch

- **V6. Definitions.**
  - Def. 3.3.1 and §3.4 support "efficiently computable if its trading strategy for day $n$ can be written down in time polynomial in $n$". Traders "have to produce their trading strategy in a time polynomial in n".
  - The holdings formula is the paper's $W(\sum_{i\le n}T_i(P))$ written out by linearity, using $T=\sum\xi_i(\varphi_i-\varphi_i^{*n})$.
  - Exploitation, plausible worlds and the criterion are verbatim or exact paraphrase (Defs. 3.5.1, 3.0.1). So is "rewards traders for arbitrage…" (§3.5).
- **V7. The three parts.**
  - MarketMaker: the Brouwer fixed point of $\mathrm{fix}$ gives prices at which the trader buys only at \$1 and sells only at \$0 (Lemma 5.1.1). A rational approximation gives gain $\le 2^{-n}$ in every world (5.1.2), so the total is $<\sum 2^{-i}<1$ (Lemma 5.1.3). The search is by brute force over belief states (proof of 5.1.2).
  - Budgeter: the trade is zero once losses reached $-b$ in a plausible world on an earlier day, and otherwise scaled by the infimum over plausible worlds. A trader whose losses always stay above $-b$ is unchanged (Lemma 5.2.2, parts 1 and 2).
  - TradingFirm: the enumeration of pairs $(M_k,f_k)$, with $M_k(n)$ run for $f_k(n)$ steps, is Prop. 5.3.1. The weight $2^{-k-b}$ over all $b$ is eq. 5.3.2. The firm's order goes to MarketMaker each day (Alg. 5.4.1).
  - Proof sketch: matches Lemma 5.3.3 and Thm 5.4.2. $\sum_{k\ge1}2^{-k}\cdot\sum_{b\ge1}b\,2^{-b}=1\cdot2=2$, and the paper uses exactly the bound $\ge -2$ for the other copies. "Holds them below \$1" is Lemma 5.1.3, which gives the firm's value in every world $<1$.
  - Runtime: "runs every trader admitted so far" is right, since only $k\le n$ trade on day $n$ (§5.3). There is no single polynomial clock, so the inductor is not polynomial-time.
- **V8. Löb and five-and-ten.**
  - The statement of Löb's theorem is correct: if $T\vdash\Box\varphi\to\varphi$ then $T\vdash\varphi$.
  - The derivation is valid given that the agent provably acts on a proof of $\varphi$ once found: $\Box\varphi\to A{=}5$, and $A{=}5\to\varphi$ (the ten-clause is vacuous, and the five provably pays 5). "With a suitable order of search" is the right and sufficient hedge (M5).
  - "The proof is valid" is right. $\varphi$ is true in the actual run, so no unsoundness is involved.
- **V9. Garrabrant 2017.**
  - The agent compares $E(U\mid A{=}5)$ and $E(U\mid A{=}10)$.
  - A trader pushes the estimates toward 0.5 for the five and 0 for the ten. "the bets made conditioned on An=10 do not matter, since the condition will be false". "This trader will therefore lose no money, and be able to do the same thing again next round."
  - With exploration, the agent converges to the ten "all but epsilon proportion" of the time, at a possibly disastrous cost. The essay matches, apart from the form of the exploration (E5).

### Elsewhere in the essay

- **V10. Links.** `who-teaches-the-weights.html` has `id="where-self-teaching-breaks"`, `id="what-on-policy-training-forgets"` and `id="the-model-with-privileged-context-as-teacher"`.
  - The first section contains "A moving teacher has no fixed reference", the momentum discussion and the collapse under a teacher that tracks the student, so it fits "moving teacher".
  - The second derives collapse onto one strategy under iterated tilting ("Collapsing onto one strategy is the cheap direction…"), so it fits.
  - Other anchors also exist: `#a-reusable-way-to-read-the-algorithms` and `#the-different-jobs-of-a-world-model` (*How Does a Policy Improve?*), `#a-gas-of-balls` and `#what-a-bounded-observer-can-compress` (*The Demon*). Both quotes from *How Does a Policy Improve?* are verbatim.
- **V11. OPST.** All checked against the full text:
  - The seed is "coarse topic descriptors" (§3.1, §3.3).
  - A sample is kept only if the generator re-solves the question in a fresh context and re-solves a reworded version, both with the same answer (§3.4).
  - The consensus gate discards samples on which every rollout agrees (§3.4).
  - The teacher receives the rationale as privileged information (§3.3).
  - The EMA teacher is $\phi_k=(1-\beta)\phi_{k-1}+\beta\theta_k$, so β is the weight on the student. "errors can reinforce themselves" is verbatim (§3.5).
  - β = 1 gives 38.1 against a base of 37.5, and β = 0.05 is best at 47.7.
- **V12. Sawin and Demski.** The title quote and "so great as to argue strongly against Π1 convergence as a desirable property for rational agents" are verbatim. The essay's "making some short true Π2 claims … arbitrarily improbable" matches the abstract ("arbitrarily low limiting probabilities assigned to some short true Π2 statements"). Theorem 1 (coherence, scientific induction, Π2 open-mindedness) matches "a weak form of coherence". The paper is dated July 2013.
- **V13. LI related work and desiderata.**
  - "Demski (2012), whose framework we use" is verbatim (§1.2).
  - "The first formal statement of Desideratum 7 that we know of is given by Demski (2012)" matches the essay's paraphrase. Desideratum 7 is non-zero probability for every c.e. consistent theory.
  - "Logical inductors are not the first computable procedure…" is verbatim (§4.1).
  - The "non-dogmatic, Gaifman inductive…" summary and "so it cannot satisfy" are verbatim (§1).
  - Desideratum 13 is "Proposed by Gaifman (1964)".
  - Non-dogmatism (Thm 4.6.2: if $\Gamma\nvdash\neg\varphi$ then $P_\infty(\varphi)>0$) supports "keeps the limiting price … above zero".
  - The No Expected Net Update quote and the paradox-resistance quote are verbatim.
  - Demski is a co-author of arXiv:1510.03370 (six authors) and of 1604.05288 (Garrabrant, Fallenstein, Demski, Soares).
- **V14. Beygelzimer, Langford and Pennock.** "We model the market as an auctioneer matching supply and demand, taking no profit and absorbing no loss" (§3). The abstract has "reacts exactly as if updating according to Bayes' Law" and "a wealth-weighted average of the individual participants' beliefs".
- **V15. Demski, "What comes with cheap math?"** (LessWrong, 28 June 2026). All six quotes are verbatim. The only difference is that "…fool yourself with math" ends in a semicolon in the original, so the essay's full stop is fine. Anson Berns and "two months" are right. Demski says he used Claude (Opus 4.8, via Claude Code).
- **V16. Outcome indistinguishability.** "Perhaps Nature is deterministic, but we do not have enough information or computing resources to carry out the predictions ourselves" is verbatim. The paper cites Dawid's "On individual risk" in a footnote on why individual risk "remains elusive", which supports "after A. P. Dawid's argument". "subtle and elusive" is Dawid's own abstract (citecheck).
- **V17. Hennig, Osborne and Girolami (2015).** The abstract phrase "arising from the loss of precision induced by numerical calculation with limited time or hardware" matches (MPI publication page).
- **V18. Number theory.** The twin-prime correction $2C_2\approx1.3203$ is right. So is the decomposition: a factor 2 from parity, and the product over odd primes $\prod(1-2/p)/(1-1/p)^2\approx0.66$ pulling back down.
- **V19. Earlier verified items re-read for drift: none found.** These are the Polymarket figures, Lampinen, Kunda, Stanovich–West–Toplak, Hacking, Garber, Gaifman, Vovk et al., Barak and Steurer, Dwork et al. 2023, Irving et al., Barnes, prover–estimator debate, Christiano–Neyman–Xu, Doyle, Laskey–Lehner, Levesque and Klein et al.

## 4. Not verifiable here

- The contents of Demski's July 2012 draft and the August 2012 correspondence. These are private, and the essay is the author's account.
- The full text of Solomonoff 1978. The constant was checked through its abstract as quoted in secondary sources and through Hutter's statement of it.
