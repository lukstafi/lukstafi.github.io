# Editorial read: *Before the Search Settles* (9 Nov 2026)

Proposals only. No file but this one was changed. Line numbers (l.) refer to `notes/before-the-search-settles.md` as it stood on 9 Nov, after the day's piecemeal revisions. Each "Original" is quoted exactly so it can be matched. Findings are ranked by how much they matter to a reader: structure first, then sections, then sentences. Facts and citations are left to the technical review. Where proposed wording could change a claim, or where existing wording reads as an overclaim, the item is marked and repeated under "Questions for the correctness reader".

## Top proposals, ranked

1. **S1.** Take the logical-induction material out of the Solomonoff box and put it where traders exist (l. 88, l. 92). Gloss Hedge at its first use.
2. **S2.** Unload *A bookmaker over sentences*. Move the Polymarket paragraph to the place in *What a truth maintenance system lacks* where "arbitrageurs draw a market's boundary" (l. 138). Split the three-part construction into three paragraphs. Stop the runtime paragraph from using "inside" before *Tests instead of worlds* explains it. Gloss *non-dogmatic* where the essay first uses it in its own voice.
3. **S3.** The ending: "the settlement criterion" (l. 241) names the wrong cell of the table. Tie Abram's Lean experience to the steered search of l. 233 and to Vingean reflection in the MIRI box.
4. **S4.** In *Three answers*, cut one recap sentence, split the three-layer paragraph where the layers start working together, and say which two layers prover–estimator debate instantiates.
5. **S5.** Move the Kalshi paragraph up so *Presumed independent* ends on its open question. Move Abram's radical-probabilism sentence out of the MIRI box to l. 209, where Jeffrey is listed.
6. **S6.** Consider splitting *Learning without new evidence* at l. 225 into a section of its own.
7. Sentence items E1–E24, mostly unglossed terms borrowed from companion essays (combinatorial wall, LMSR, Eisenberg–Gale box, shallow market, coherent myth, multiaccuracy, explosion, counterfactual mugging) and four paragraphs that do two jobs.

## Part 1. Structure

### What works and should be left alone

The whole holds together. The opening promises three answers and an application. The sections deliver them in that order (prior, adversary, presumption, synthesis, logic layer, machines), and every section opening except one (*A bookmaker over sentences*, see S2) picks up where the previous section stopped. Some hand-offs are particularly good. *Logical omniscience* closes on "or why one in ten is the right number for the digit" and *A prior over theories* opens with "Abram's prior answers both questions in principle." *Tests instead of worlds* closes on debate and calibration, and *Presumed independent* opens with "The third answer is older than either of the others." "The logic layer need not be classical" opens *What explosion becomes* straight off the three-layer paragraph.

The best things in the essay, which no proposal below touches:

- L. 21: "The answer is settled; nobody knows it." A true parallel pair, and the essay's whole problem in six words.
- L. 86: "It risks a bounded amount and can win without bound." and "The bound is on the traders, not on the market." Two definitions a reader can carry.
- L. 94, the proof sketch. Four moves, each one sentence, ending on the contradiction. The new construction material was worth adding for this paragraph alone.
- L. 100: "One in ten is the price at which no efficient trader can profit." This answers the opening.
- L. 102, last sentence: "The property Abram's 2012 draft wished for is the one the 2016 construction had to drop." A clean close for the main text of the section.
- L. 49, the box's last sentence: "A bounded reasoner faces the opposite case: it has found the short program, and still cannot run it far enough."
- L. 122, continuity explained by the trader that would leave no equilibrium.
- L. 152 and the table: two axes the reader can see.
- L. 179, the definition of a reason. This is the essay's intellectual core. "Prices underdetermine reasons, because different structures can imply the same marginals" is exactly one move.
- L. 183: "The answers come apart only where structure exists." L. 185: "the right kind of definition and the wrong ambition."
- L. 211: "If a model gains from training on its own reasoning, it was not logically omniscient."
- L. 221: "A question on which the model is unanimously wrong is dropped, and the error stays."
- L. 233: "A fair search cannot be expected to raise a credence: if finding a derivation would raise it, failing to find one must lower it." and "Someone who expects thinking to confirm their view is making that forecast."
- L. 243, the last paragraph, which lands on the title (see S3).

Semicolons are clean. The three in prose outside citations (l. 21, l. 33, l. 169) are all true parallel pairs. The voice holds throughout. The first person appears where it should: the correspondence, "My view, for now", the two "I have not found" admissions, and the ring at l. 241.

### S1. The Solomonoff box spends a paragraph on the next section (highest priority)

The box is in the right place: at first mention of Solomonoff, where a reader who knows the prior can skip it. Its size is right for paragraphs 1–3 and 5. Paragraph 2 also pays off the opening's otherwise opaque correction about monotone machines (l. 17), which is reason enough to keep the tape description.

The fourth paragraph is the problem. It says "the subject of the next section" and then talks about traders, prices of $\varphi$ and $\neg\varphi$, and buying shares, none of which exist yet. A share paying \$1 is defined at l. 78. Hedge is never glossed anywhere, though the essay relies on it three times (l. 47, l. 140, l. 223, the last of which turns on Hedge seeing every expert's loss).

Proposal: the box keeps the mixture and Hedge, with Hedge glossed, and the logical-induction sentences move to where the reader meets traders and their weights. With the cut, the box drops to about 480 words.

- Original: `Bayes' rule is Hedge at log loss, so in the bookmaker essay's terms $M$ is a market in which every computable predictor bets on its own predictions, starting with wealth that halves with every bit of its description. The logical induction paper, the subject of the next section, names Solomonoff and Gaifman as the two frameworks it merges. It too weights its traders by a prior that halves along an enumeration. Its traders are different: "our 'experts' are not themselves predicting the world." A trader that sees the prices of $\varphi$ and $\neg\varphi$ sum to well below \$1 can buy both and profit without knowing which is true.`
- Proposed: `Hedge, the learner at the center of the bookmaker essay, sees every expert's loss each round and multiplies each expert's weight by a factor that falls with that loss. Bayes' rule is Hedge at log loss, so in that essay's terms $M$ is a market in which every computable predictor bets on its own predictions, starting with wealth that halves with every bit of its description.`

The moved sentences, in the bookmaker section:

- Original (l. 92): `Trader $k$ joins the firm once for every budget $b$, with the fixed weight $2^{-k-b}$.`
- Proposed: `Trader $k$ joins the firm once for every budget $b$, with the fixed weight $2^{-k-b}$. The weights halve along an enumeration, as in Solomonoff's mixture, and the paper names Solomonoff and Gaifman as the two frameworks it merges.`
- Original (l. 88): `so prices are held to consistency with whatever has been proved.`
- Proposed: `so prices are held to consistency with whatever has been proved. A trader that sees the prices of $\varphi$ and $\neg\varphi$ sum to well below \$1 can buy both and profit without knowing which is true. Unlike Solomonoff's predictors, in the paper's words, "our 'experts' are not themselves predicting the world."`

The buy-both example now illustrates the quotation right before it, "arbitrage between sentences that never 'pay out'," which it fits exactly.

### S2. *A bookmaker over sentences* is overloaded in one place, and its seams show

In order, the section has credits, setup, the trader, the criterion, the no-regret reading, Polymarket, the construction, the proof, the runtime, LMSR, π, rates, and the MIRI box. Everything from setup to rates is one line of argument (definition, construction, proof, cost, what it learns, what it gave up), except the Polymarket paragraph, which interrupts it between the definition and the construction. The other items are seams.

**(a) Move Polymarket to l. 138 (recommended).** In the bookmaker section the paragraph illustrates a point the reader has not needed yet. At l. 138 it is evidence for a claim the essay makes there without evidence: "consistency between linked markets is left to traders, so arbitrageurs draw a market's boundary." The \$95,000 against \$39.6 million is exactly that boundary. It also sets up the contrast in the next sentence, where a logical inductor's coupling "runs through its own state." Split l. 138 after the boundary sentence and insert the paragraph:

- Original: `A real market shows how much incoherence bounded arbitrageurs find.`
- Proposed: `Polymarket shows how far they get.`
- The paragraph then continues unchanged. After it, a new paragraph begins at `A logical inductor also prices sentences one at a time,`.
- L. 140 is now three paragraphs from "the first", so re-anchor it:
  - Original: `Logical induction drops the second.`
  - Proposed: `Logical induction drops the market's second virtue, credit.`

Second choice, if the author wants the figures elsewhere: the first point of *What explosion becomes* (l. 193), after "For a market, the measure is arbitrage profit." There Polymarket would be that measure taken on a real market. I prefer l. 138, because there the paragraph's last sentence about structured incoherence does the argument's work.

**(b) Split the construction into three paragraphs.** At 217 words, l. 92 carries three parts, each a paragraph's job. The opening also says the parts "prove" the criterion, which parts cannot do.

- Original: `The paper's algorithm has three parts, and together they prove the criterion in a few lines. The first, a *market maker*,`
- Proposed: `The paper's algorithm has three parts, and with them the criterion has a proof of a few lines. The first, a *market maker*,`
- New paragraphs at `The second part, a *budgeter*,` and `The third part, a *trading firm*,`.

**(c) "Inside" before inside is explained.** L. 96 cashes in the internal/external distinction 54 lines before l. 150 introduces it. Say what it costs here, and save the name for l. 150, which then explains the runtime.

- Original: `Being slower than every trader it defends against is the price of keeping the adversaries inside.`
- Proposed: `Being slower than every trader it defends against is the price of running them all itself.`
- Original (l. 150): `In logical induction and multicalibration the tests are internal: the believer enumerates them and runs them. It must then out-compute each one.`
- Proposed: `In logical induction and multicalibration the tests are internal: the believer enumerates them and runs them. It must then out-compute each one, which is why a logical inductor's runtime is abysmal.`

**(d) The LMSR paragraph (l. 98) is in the right place.** A reader of the bookmaker essay asks "is this the LMSR?" right after seeing the market maker, and the section title invites the question. Keep the paragraph, but drop the remark about the title, and expand the acronym, which the essay never does. "The Eisenberg–Gale box" points into another essay without saying so.

- Original: `The market maker is not the bookmaker of the earlier essay, despite this section's title. Like that bookmaker,`
- Proposed: `The market maker is not the bookmaker of the earlier essay, Robin Hanson's logarithmic market scoring rule (LMSR). Like that bookmaker,`
- Original: `The nearest relative in that essay is the Eisenberg–Gale box, whose clearing prices fix the odds of a betting pool.`
- Proposed: `The nearest relative in that essay is the Eisenberg–Gale program of one of its boxes, whose clearing prices fix the odds of a betting pool.`
- Original: `The nearest thing to a learning rate is the trader weights and budgets.`
- Proposed: `The nearest things to a learning rate are the trader weights and budgets.`

Moving l. 98 into the "What does the market add" block (l. 138) would also anchor the Kelly market's "also clears" at l. 140. I considered it and do not recommend it. The comparison belongs where the market maker is fresh. E9 fixes "also" in place.

**(e) Why the digit changed.** The opening asks about the $10^{100}$th digit. L. 100 switches to the Ackermann$(n,n)$th without saying why, and a careful reader will stop.

- Original: `The construction learns what the essay's opening asked for. Let $\varphi_n$ say`
- Proposed: `The construction learns what the essay's opening asked for. Its theorems are about sequences of sentences, so the single remote digit becomes a sequence of ever more remote ones. Let $\varphi_n$ say`

**(f) *Non-dogmatic* is glossed 120 lines after the essay first uses it in its own voice.** It appears in a quotation at l. 68, in prose at l. 102 (where the whole clash with Gaifman inductivity depends on it), and is explained only at l. 223. Give the l. 223 gloss at l. 102. L. 223 can keep it, since repetition there saves a lookup. (Wording copied from l. 223. See Q3.)

- Original: `Logical induction is computably approximable, approximately coherent, and non-dogmatic, "so it cannot satisfy" Gaifman inductivity.`
- Proposed: `Logical induction is computably approximable, approximately coherent, and non-dogmatic, which keeps the limiting price of every sentence the axioms do not refute above zero, "so it cannot satisfy" Gaifman inductivity.`

**(g) The section opens cold.** Every other section picks up the last. This one opens on a citation after probabilistic numerics. One sentence turns the page (optional):

- Original: `[*Logical Induction*](https://arxiv.org/abs/1609.03543), by Scott Garrabrant,`
- Proposed: `The answer that was built gave up the distribution over theories and priced sentences directly. [*Logical Induction*](https://arxiv.org/abs/1609.03543), by Scott Garrabrant,`

**(h) The MIRI box is in the right place and nearly the right size.** It belongs after the section's last sentence. Before the construction it would delay the construction. Two changes. First, the five-and-ten paragraph (271 words) does two jobs. Start a new paragraph at `Logical induction did not supply logical counterfactuals either.` Second, the third paragraph has three topics: Vingean reflection, Abram's reading of radical probabilism, and MIRI's later history. The radical-probabilism sentence belongs at l. 209, where Jeffrey is listed and nothing introduces him (see S5).

With (a), (b) and S1, the bookmaker section's main text runs straight from definition to proof to cost to results. Its length barely changes (about 130 words out, about 70 in), but none of it digresses.

### S3. The ending names the wrong criterion, and misses its two best echoes

*Trust between inductors* lands. L. 243 brings back *Presumed Normal*'s withdrawn line and closes on the title phrase, "the search had not settled," a better landing than anything that could replace it. The ring at l. 241 ("In 2012 I asked him about 'self outputs.' Fourteen years later…") works too. Two closings in a row are acceptable here, because they close different things: the story, then the argument.

L. 241 needs repair.

- "The settlement criterion" is not a term the essay has used. In the table, "settlement over time" is one axis, and a proof checker sits in the other column ("proof search with a proof checker", internal × checks on demand). The criterion the paragraph means is l. 213's independence of the check from the beliefs.
- The paragraph misses the echo that makes Abram's experience land: l. 233 says "A proof checker would pass every derivation, and the credence would still drift." Abram's "it is much easier now to fool yourself with math" is that sentence happening. The proposal states the echo, which is the author's call, since it reads Abram's experience as steering (see Q4).
- "When a reasoner may trust another that computes more" is the MIRI agenda's fourth problem, Vingean reflection. The box at l. 108 explains it 130 lines earlier, and a repeated gloss saves the lookup. The OPST comparison is loose, because OPST's teacher is an average of past selves, not a stronger reasoner. Naming Vingean reflection first gives the comparison something to stand on.

- Original: `Abram's experience shows the settlement criterion meeting its own limit. A proof checker is the cleanest independent check there is, and it certifies only the step from a formal statement to its proof. Whether the statement is the right one is a question about the given condition, which no internal check reaches. The question Abram is now asking with logical inductors, when a reasoner may trust another that computes more, is the question OPST raises about a model and its average past selves.`
- Proposed: `Abram's experience is the steered search of l. 233 with a proof checker passing every step. A proof checker is the cleanest independent check there is, and it certifies only the step from a formal statement to its proof. Whether the statement is the right one is a question about the given condition, which no internal check reaches. The question Abram is now asking with logical inductors, when a reasoner may trust another that computes more, is the problem MIRI's 2014 agenda called Vingean reflection. Logical induction answered it only for a reasoner's trust in its own future beliefs. OPST raises it about a model and its average past selves.`

("Of l. 233" stands for a phrase the author chooses, such as "of the previous section". If S6's split is taken, it becomes "the steered search of the previous section" exactly.)

The section heading fits l. 239–241 but not l. 243. That is acceptable for a closing section, and I would not rename it.

### S4. *Three answers*: one recap sentence, one paragraph doing two jobs, one unanchored "two"

**The opening summary (l. 177)** is the one place where the synthesis restates rather than synthesizes. Most of it earns its place: each answer's gift and failure in one pair of sentences, plus attributions that save lookups. One sentence repeats l. 100 and adds nothing to the pair.

- Original: `The adversarial answer gives guarantees. A logical inductor cannot be exploited by any efficient trader, its prices learn pseudorandom frequencies, and it trusts its future beliefs. Its guarantees arrive at an uncomputable rate.`
- Proposed: `The adversarial answer gives guarantees. They arrive at an uncomputable rate.`

**The three-layer paragraph (l. 187), after the merge.** It reads well up to "prices everything else." Then "The layers would also work together" starts a second job, the abduction loop, and the paragraph ends by restating that loop in one sentence. Split at that point, and put the restatement first as a map, where it orients the reader instead of repeating.

- Original: `The layers would also work together. A trader's persistent profit signals structure that no current reason models.`
- Proposed (new paragraph): `The layers would work together. The market detects missing structure, the reason layer represents it, and the prior decides which representation to keep. A trader's persistent profit signals structure that no current reason models.`
- Original: `Once adopted, the new reason absorbs the correlation and the profit stops. The market detects missing structure, the reason layer represents it, and the prior decides which representation to keep. Prover–estimator debate`
- Proposed: `Once adopted, the new reason absorbs the correlation and the profit stops. Prover–estimator debate`

The logic layer is what the truth maintenance section said a logical inductor's deductive process does (l. 112). The merge removed the paragraph that made that link, so one sentence restores it:

- Original: `records what has been derived and on which conditions. A layer of reasons`
- Proposed: `records what has been derived and on which conditions. In a logical inductor the deductive process plays this part. A layer of reasons`

"Two of the layers" leaves the reader to guess which two. L. 161 already gave the answer, and repeating it here saves the lookup. (The mapping is my reading; see Q5.)

- Original: `Prover–estimator debate is a small working instance of two of the layers.`
- Proposed: `Prover–estimator debate is a small working instance of two of the layers: the steps that get checked are the logic layer, and the estimator's probabilities are the pricing layer.`

**L. 181, two small repairs.** The relative clause attaches to "a gas", and the last sentence claims more than the market delivers. The market corrects only what an efficient trader finds, as l. 183 itself says.

- Original: `A logical inductor stands to its reasons as Boltzmann's one-ball distribution stands to a gas, which records each ball's statistics and none of the correlations among balls.`
- Proposed: `A logical inductor stands to its reasons as Boltzmann's one-ball distribution stands to a gas. The distribution records each ball's statistics and none of the correlations among balls.`
- Original: `A correlation left out of a gas's description stays out, while one left out of the prices is a profit for somebody, so the market's omissions get corrected.`
- Proposed: `A correlation left out of a gas's description stays out. One left out of the prices is a profit for any efficient trader that finds it, so the market corrects it.`

### S5. Two paragraphs in the wrong place

**Kalshi (l. 173).** *Presumed independent* runs from mathematics (Cramér) to physics (Boltzmann) to a research program (ARC) to logic (Markov logic networks), and then ends on a market anecdote. The MLN paragraph ends on the section's open question ("would be the proof theory to match. I have not found one."), which is the better close. It also hands on to *Three answers*, where MLNs return. Move the Kalshi paragraph to follow Boltzmann (l. 167), drop the remark about vocabulary, and give ARC's opener a referent, since "this kind of argument" would then point at parlays.

- Original: `The bookmaker essay showed the presumption at work for money. Most dealers who quote parlays on Kalshi appear to price the legs as if they were independent, and one appears to model the correlations. In the vocabulary of this section, the others presume independence and that one dealer has found defeaters.`
- Proposed (moved after l. 167): `The presumption is also at work for money. The bookmaker essay reported that most dealers who quote parlays on Kalshi appear to price the legs as if they were independent, and one appears to model the correlations. The others presume independence, and that one dealer has found defeaters.`
- Original: `The Alignment Research Center (ARC), founded by Christiano, made this kind of argument a research program.`
- Proposed: `The Alignment Research Center (ARC), founded by Christiano, made presumed independence a research program.`

**Radical probabilism (l. 108 → l. 209).** L. 209 lists "Jeffrey's radical probabilism" among views of belief that changes by thinking. The only gloss is in the MIRI box, 100 lines earlier, attached to Abram's reading of logical induction. Bringing that sentence to l. 209 introduces Jeffrey where he is used, and it leaves the box's third paragraph about trust and MIRI's history only.

- Original (l. 108, delete): `Abram later read logical induction as "merely a specific way to flesh out" Richard Jeffrey's radical probabilism, in which beliefs change without conditioning on observations. `
- Original (l. 209): `Good's evolving probability, Garber's learning of implications, Abram's inductive treatment of unproved statements, logical induction's movement of prices as the deductive process proceeds, and Jeffrey's radical probabilism all describe belief that changes by thinking.`
- Proposed: `Good's evolving probability, Garber's learning of implications, Abram's inductive treatment of unproved statements and logical induction's movement of prices as the deductive process proceeds all describe belief that changes by thinking. Abram later read logical induction as "merely a specific way to flesh out" Richard Jeffrey's radical probabilism, in which beliefs change without conditioning on observations.`

### S6. *Learning without new evidence* has two halves (matter of judgment)

At about 1,765 words this is the longest section, and it coheres less well than the others. L. 209–223 ask about machines: is self-training sound (independence of the check), and does anything bid up what is priced near zero (exploration). L. 225–233 ask about human reasoners and steering: old evidence, bracketing, motivated derivation, No Expected Net Update, and the bookkeeping remedy. L. 235 then sets up the ending's "given condition." OPST appears in both halves, but the second half's question is new: who chooses which derivations to look for.

A heading at l. 225 would give the reader a rest at a real turn, and would let S3's "the steered search of the previous section" point at it. Suggested heading: `## Steering the search`. Stitch:

- Original: `Old evidence is the human precedent. Mercury's perihelion`
- Proposed: `Old evidence is the human case of learning without new evidence. Mercury's perihelion`

L. 235 should stay where it is, as the last paragraph before *Trust between inductors*. The ending's "the given condition, which no internal check reaches" depends on it. I would not move it nearer l. 213.

If the split is declined, nothing else needs changing. The section's paragraphs follow well from one another, and only the four long paragraphs need splitting (E18–E20).

### Redundancy across distant sections

Repetitions I checked, with verdicts under the house rule:

- "Bayes' rule is Hedge at log loss" (box l. 47, l. 140). **Keep both.** They are 90 lines apart, and at l. 140 the phrase saves a lookup into a skippable box. With S1's gloss the first one also explains Hedge.
- The 2012 prior "limited to the incompleteness of whatever axioms it is given" (l. 66, l. 235). **Keep.** L. 235 needs the fact to draw its line.
- "Unambiguously a distribution over structures" (l. 17, l. 183). **Keep.** L. 183 adds the game-playing quotation, which the opening lacks.
- Mercury and old evidence (l. 29, l. 225). **Keep.**
- Gaifman inductivity dropped (l. 68, l. 102, l. 235). **Keep.** Each use makes a different move: the theorem, the construction's choice, the demarcation.
- The recap list at l. 209 (Good, Garber, Abram, logical induction, Jeffrey). **Keep.** It gathers the given before the new ("Machine learning met the same phenomenon from the other side"). S5 changes only its last item.
- *Three answers* l. 177 and the abduction loop in l. 187. **Cut one sentence each** (S4). These are the only restated conclusions that sit near what they restate.
- L. 161's last sentence and l. 187's prover–estimator remark. With S4's proposal they become a deliberate echo.

## Part 2. Sentences

### Confident, ranked

**E1** (l. 21). The exponent renders literally as "10^100th" in the HTML.
- Original: `Is the 10^100th decimal digit of π a 7?`
- Proposed: `Is the $10^{100}$th decimal digit of π a 7?`

**E2** (l. 144). Overclaim by date. Barak's post is from 2015 and logical induction from 2016, so "the connection" cannot be the one the previous sentence suggests, between logical induction and pseudorandomness.
- Original: `Boaz Barak drew the connection in a 2015 blog post,`
- Proposed: `Boaz Barak connected pseudorandomness to logical uncertainty in a 2015 blog post,`

**E3** (l. 122 against l. 126). "What the market buys" is followed four lines later by "None of the three needs a market." The reader feels the contradiction. The point of the sentence is the contrast with a truth maintenance system's labels.
- Original: `This is the smallest example of what the market buys.`
- Proposed: `Continuity is the smallest example of what a price can do that a label cannot.`

**E4** (l. 112). *Adaptive logic* first appears at l. 17 and is never explained. This is its first use in the argument, and later the essay leans on "marking" and "unmarking" lines (l. 223, l. 243).
- Original: `*Presumed Normal*'s adaptive logics do the same job: the condition attached to a line plays the role of an assumption-based system's label, and marking a line is retracting it.`
- Proposed: `*Presumed Normal*'s adaptive logics do the same job. An adaptive proof writes each conclusion on a line together with a condition, the abnormalities it assumes false, and marks the line when one of them is derived. The condition plays the role of an assumption-based system's label, and marking a line is retracting it.`

**E5** (l. 88). "The combinatorial wall" is a term from another essay, and that essay calls it the computational wall.
- Original: `Exact coherence over all sentences would be the combinatorial wall of that essay, raised from #P-hard to undecidable.`
- Proposed: `Exact coherence over all sentences would be the computational wall of that essay, where pricing bets on combinations of outcomes is #P-hard, raised to undecidability.`

**E6** (l. 217). Two borrowed terms with no gloss, in a paragraph that does two jobs. Split at the liquidity parameter.
- Original: `as the ontology essay's coherent myth passes the compression test.`
- Proposed: `as a coherent myth told by many independent sources passes the ontology essay's compression test.`
- Original: `the shallow market of the bookmaker essay.`
- Proposed: `the shallow market of the bookmaker essay, which moves with every trade.`
- New paragraph at `OPST even has a liquidity parameter:`.
- Original: `In the bookmaker's terms, OPST is a market` (the essay says "the bookmaker essay's terms" elsewhere)
- Proposed: `In the bookmaker essay's terms, OPST is a market`

**E7** (l. 150). *Multiaccurate* is never explained, and l. 169 uses *multiaccuracy* again. The paragraph also does two jobs, internal and then external adversaries. Split it.
- Original: `Dwork, Daniel Lee, Huijia Lin and Pranay Tankala proved in 2023 a lower bound on the size of multiaccurate predictors relative to their tests,`
- Proposed: `Multiaccuracy, a weaker cousin of multicalibration, asks only that a predictor be unbiased on each group. Dwork, Daniel Lee, Huijia Lin and Pranay Tankala proved in 2023 a lower bound on the size of multiaccurate predictors relative to their tests,`
- New paragraph at `An external adversary can be stronger than the believer, and that changes what the believer can justify.`

**E8** (l. 191). The section title's key word is never named in the text. The sentence gives its content but not its name.
- Original: `*Presumed Normal* opened with paraconsistent logic, which keeps a contradiction from implying everything.`
- Proposed: `*Presumed Normal* opened with paraconsistent logic, which blocks *explosion*, the classical principle by which a contradiction implies everything.`

**E9** (l. 140). "Also" is anchored at l. 98, 40 lines back.
- Original: `[That market](https://arxiv.org/abs/1201.6655) also clears through an auctioneer`
- Proposed: `[That market](https://arxiv.org/abs/1201.6655), like a logical inductor, clears through an auctioneer`

**E10** (box, l. 104). Counterfactual mugging is named and never explained, so the digit-of-π variant shows nothing to a reader who does not know the original. "This" and "such" are also both loosely anchored in one sentence. (The gloss is mine; see Q6.)
- Original: `Vladimir Nesov's 2009 variant of counterfactual mugging replaces a coin with "the 10000-th digit of pi."`
- Proposed: `Counterfactual mugging asks whether an agent should pay a predictor now because, had a coin fallen the other way, the predictor would have rewarded agents that pay. Vladimir Nesov's 2009 variant replaces the coin with "the 10000-th digit of pi."`
- Original: `made this the core of the case against classical rationality for such agents.`
- Proposed: `made embeddedness the core of their case against classical rationality.`

**E11** (l. 165). One sentence carries three moves: the assumption, the parity correction, and the small-prime correction.
- Original: `It treats $n$ and $n+2$ as independent, though if $n$ is an odd prime, $n+2$ is odd too, which doubles its chance of being prime, while divisibility by 3, 5, 7 and the other small primes pulls the chance back down.`
- Proposed: `It treats $n$ and $n+2$ as independent. Yet if $n$ is an odd prime, $n+2$ is odd too, which doubles its chance of being prime. Divisibility by 3, 5, 7 and the other small primes pulls the chance back down.`

**E12** (l. 195–199). The display switches from $\neg$ to $\sim$ without a word, and the reader cannot tell whether that is a typo. (Check the reading; see Q7.)
- Original: `Weighting each model by $e^{-wk}$, where $k$ counts letters with both atoms true, gives`
- Proposed: `Write $\sim$ for CLuN's negation. Weighting each model by $e^{-wk}$, where $k$ counts letters with both atoms true, gives`

**E13** (l. 201). Two jobs: the CLuN weighting, and the general theory of gaps and gluts. Start a new paragraph at `Dominik Klein, Ondrej Majer and Soroush Rafiee Rad's`.

**E14** (l. 233). At 226 words, the paragraph does three jobs: drift under valid steps and No Expected Net Update; OPST as steering; the logical inductor's protection, its cost, and the remedy. Start a new paragraph at `OPST is the machine version of steering,`.

**E15** (l. 106, box). Two jobs: the proof-based five-and-ten, then the logical-inductor version and $\varepsilon$-exploration. Start a new paragraph at `Logical induction did not supply logical counterfactuals either.` (See S2(h).)

**E16** (l. 17). Two jobs at 200 words: the correspondence about the prior, then the neural network. The network pays off at l. 215, so it deserves to be seen.
- Start a new paragraph at `Around the same time we talked about building a neural network`.

**E17** (l. 114). "That" has no clear referent: Laskey and Lehner's result, or the system?
- Original: `That propagates a prior. It does not learn`
- Proposed: `The probabilistic system propagates a prior. It does not learn`

**E18** (l. 215). "The same corner" points to a table 60 lines back. Naming it saves the lookup.
- Original: `would have been in the same corner, because`
- Proposed: `would have been in the same corner of the table of adversaries, because`

**E19** (l. 173 if not moved, l. 98, l. 100). Remarks about the essay where the claim would do. S2(d) and S5 cover the first two. "The essay's opening" at l. 100 is fine.

**E20** (l. 165, l. 177). British spellings in an American essay ("favors", "analyzed", "formalize").
- Original: `Harald Cramér modelled the primes`
- Proposed: `Harald Cramér modeled the primes`
- Original: `is computable with good behaviour`
- Proposed: `is computable with good behavior`

**E21** (l. 62). A loose "this", and the subject changes in the middle of the sentence.
- Original: `The paper says plainly that this shows the prior is computable in the limit and makes no claim of efficiency.`
- Proposed: `The paper says plainly that the prior is therefore computable in the limit, and it makes no claim of efficiency.`

**E22** (l. 29). Three repairs in one paragraph (Hacking; Glymour and Garber; Good). Old evidence returns at l. 225, so give it its own paragraph. Start a new one at `Clark Glymour posed the problem of old evidence in 1980.` Good then follows Garber. Low priority.

**E23** (l. 227). "Both failures" names the failures before they are shown. This is minor, since the first sentence says "can fail at each". Optional: move `Both failures feel empirical, because the reasoner is holding a real datum.` to the start of l. 229, as `Both failures feel empirical, because the reasoner is holding a real datum. The first is not bracketing at all.`

**E24** (l. 223). Three cases in one paragraph: the logical inductor, AlphaZero, and the logic layer. Optional break at `A logic layer does not meet the problem at all.`

### Tics

**T1. "The bookmaker essay" (13 uses).** The essay leans on its companion more than on any other, and each use brings in a term from it: regret, Hedge, the computational wall, the ellipsoid and Frank–Wolfe steps, shared state and credit, the second learner, parlays, simulation by delegation, the shallow market, the cheap outcome. Most of these are glossed where they appear. Hedge (S1), the wall (E5), the Eisenberg–Gale box (S2(d)) and the shallow market (E6) are not. With those four fixed, the dependency is honest and the reader can follow without the companion.

**T2. "The same" as a connective** (about 20 uses). It is lighter than in *The Demon Is a Learner*, and most uses are earned. Three can become "this" without loss:
- Original: `reaches the same structure from algorithmic fairness`
- Proposed: `reaches this structure from algorithmic fairness`
- Original: `The bookmaker essay met the same step twice`
- Proposed: `The bookmaker essay met this step twice`
- Original: `Logical induction uses the same idea at its base.`
- Proposed: `Logical induction uses this idea at its base.`

**T3. The short moral at a paragraph's end.** It is present but well spaced, and the best of them are listed above under what works. None needs demoting.

### Matters of taste

- **A1** (l. 90, if kept in place). "The structured incoherence is the kind that is hard to see, and little of it was harvested" makes two claims. See Q1 on the second.
- **A2** (l. 136). The citations paragraph ("does not cite… closest named precedent… Kosoy… Perdomo and Recht") is a bibliographic interlude between two parts of an argument. It introduces the Kelly market that l. 140 needs, so it must stay before l. 140. Keep it, but it could open with the Kelly market and put the non-citations after it.
- **A3** (l. 231). At 191 words it does one job, but a long one. A possible break: `Nor does the reasoner notice.`
- **A4** (l. 243). "Logical uncertainty gives a fourth" depends on three answers the reader has not seen. This is fine as a pointer, and the concrete lines 5 and 8 carry it.

## Part 3. Terms used before they are introduced

| Term | First use | Explained | Status and fix |
|---|---|---|---|
| monotone machine | l. 17 | l. 41 (box) | Late, by design. The box pays it off. OK |
| adaptive logic | l. 17 | partly, l. 112 | **Never fully**. E4 |
| impossible possible worlds | l. 17 | l. 33 | OK |
| traders, prices, shares | l. 47 (box) | l. 78–80 | **Late**. S1 |
| Hedge | l. 47 | never | **Never**. S1 |
| regret | l. 45 | same sentence | OK |
| deductive process | l. 76 (quotation) | l. 78 | OK |
| non-dogmatic | l. 68 (quotation), l. 102 | l. 223 | **Late**. S2(f) |
| Gaifman inductivity | l. 68 | l. 68 | OK |
| combinatorial wall | l. 88 | never | **Never**. E5 |
| internal adversary | l. 96 ("inside") | l. 150 | **Late**. S2(c) |
| LMSR | l. 98 | never expanded | **Never**. S2(d) |
| Eisenberg–Gale box | l. 98 | never | **Never**. S2(d) |
| Vingean reflection | l. 104 | l. 108 | OK, within the box |
| counterfactual mugging | l. 104 | never | **Never**. E10 |
| Löb's theorem | l. 106 | same paragraph | OK |
| radical probabilism | l. 108 | l. 108 | OK. Moves with S5 |
| multiaccurate | l. 150 | never | **Never**. E7 |
| defeater | l. 165 | context | OK |
| two-part code | l. 181 | not stated | OK for the audience |
| explosion | l. 189 (heading) | content only, l. 191 | **Never named**. E8 |
| $\sim$ (CLuN negation) | l. 199 | never | E12 |
| shallow market | l. 217 | never | **Never**. E6 |
| coherent myth | l. 217 | never | **Never**. E6 |
| PUCT | l. 223 | "a bandit rule" | OK |
| settlement criterion | l. 241 | not a term of the essay | S3 |

## Questions for the correctness reader

- **Q1** (l. 90). "Little of it was harvested." Saguillo and colleagues measure realized arbitrage. Does the data support a claim about how much structured incoherence was available, or only about how much was taken? If only the latter: `and profit from it was small.`
- **Q2** (l. 181). The original "the market's omissions get corrected" reads as all omissions. S4's wording restricts it to what an efficient trader finds, which l. 183 implies. Please confirm.
- **Q3** (l. 102). S2(f) copies l. 223's gloss of non-dogmatism ("above zero" for sentences the axioms do not refute). The paper's definition also has the dual (below 1 for sentences not proved), and that dual is what clashes with Gaifman inductivity. Should the gloss give both halves?
- **Q4** (l. 241). S3 reads Abram's Lean experience as steered search, formal statements chosen because they could be proved. Is that fair to his post?
- **Q5** (l. 187). S4 maps prover–estimator debate onto the logic and pricing layers. Is that what the author meant by "two of the layers", or reasons and pricing?
- **Q6** (l. 104). Check the one-sentence gloss of counterfactual mugging in E10.
- **Q7** (l. 195–199). Is $\sim A$ CLuN's negation, true when `neg(A)` holds? E12 assumes so.
- **Q8** (l. 140). E9 makes explicit that the Kelly market's auctioneer is like a logical inductor's, taking no profit and absorbing no loss. The original "also" implies this. Please confirm it is true of the market maker.

## Tally

6 structural findings (S1–S6), with 25 stitches quoted; 24 sentence-level findings (E1–E24); 3 tics; 4 matters of taste; 26 terms in the table, 13 of them never explained or explained late; 8 questions for the correctness reader. Nothing is cut wholesale. Four sentences are deleted as recap or moved: one in l. 177, one in l. 187, and the box's logical-induction and radical-probabilism sentences, which move to l. 88, l. 92 and l. 209.
