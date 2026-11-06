# Editorial read: *The Demon Is a Learner* and its mathematics page (6 Nov 2026)

Proposals only. No file but this one was changed. Line numbers (l.) refer to `notes/the-demon-is-a-learner.md` and `notes/the-demon-is-a-learner-mathematics.md` as they stood on 6 Nov. Each "Original" is quoted exactly so it can be matched. Findings are ranked by how much they matter to a reader. Questions of fact are marked as questions for the correctness reader, and I have not changed any claim in the proposed wording except where a finding says so.

## Part 1. The essay: structure

### What works and should be left alone

*A gas of balls* is the best section in the essay. It shows something the reader can see, it gives the one line where the arrow enters, and its last two sentences (l. 64) hand on cleanly to *What forgetting costs*. The late addition at the head of *The demon is a learner* (l. 110) is the only bridge from the gas to learning, and it is needed. The Shalizi–Moore paragraph (l. 139) is the essay's real intellectual climax. The last sentence of l. 143 ("Bits price what an observer stores and forgets, and time prices what it can do with them.") is the best closing line in the essay. Semicolons are clean: the only one in prose outside citations is the true parallel pair at l. 74.

### S1. The closing section has four endings and starts cold (highest priority)

*What a bounded observer can compress* reads as four attempts to finish. L. 139 closes on "the learner gets to find its answer from data". L. 141 closes on "The structure of a population is what a learner can compress." L. 143 closes on "Bits price…". L. 145 then closes again, by announcing that it is closing. Each cadence is good. Together they tell the reader three times that the essay is over.

The section also opens in the wrong place. The reader leaves the previous section on Kiefer's hypothesis about the brain and lands on Poincaré in the 1880s, with no hand-on, and "bounded observer" has not yet been a character in the essay. The Poincaré–Wolfram paragraph is the oldest text here, and the additions were put after it. The concrete paragraph (the gas puts a number on the limit) is buried fourth, though classic style would show it first.

**Proposed order** (no paragraph is cut):

1. L. 141, the gas puts a number on the limit; the diffusion model takes a different task.
2. L. 135, Poincaré and Wolfram. "That move" now has a real antecedent: giving up each history for the structure.
3. L. 137, Ebtekar and Hutter.
4. L. 139, the objection and Shalizi–Moore.
5. L. 143, "Compression is not enough, though."
6. L. 145, the close.

This takes the reader from a number, to the principle, to the objection, to the limit of the principle, and leaves the "Bits price…" line next to the close. Stitches needed:

- Hand-on from the Friston paragraph, and an entry for the observer.
  - Original: `The gas of balls puts a number on an observer's limits.`
  - Proposed: `A learner is a bounded observer. The gas of balls puts a number on the bound.`
- Lead-in to Poincaré once he follows l. 141.
  - Original: `Henri Poincaré founded the qualitative theory of differential equations in the 1880s, and his work`
  - Proposed: `Giving up each history for the structure is an old move. Henri Poincaré founded the qualitative theory of differential equations in the 1880s, and his work`
- L. 137 is largely recap, and "the same move" has lost its referent ("the bound" was defined 35 lines earlier). A repeated gloss saves the lookup here.
  - Original: `Ebtekar and Hutter's bound is the same move seen from the other side. A bounded observer's coarse description is what turns reversible dynamics into a second law.`
  - Proposed: `Ebtekar and Hutter's bound says this from the other side. Deterministic dynamics with a short law cannot raise a state's complexity, so a bounded observer's coarse description supplies the second law.`

**The ending (l. 145).** Is it earned? The first sentence is: laws (l. 137–139), work (l. 78, l. 114) and futures (l. 116, l. 141) have each been shown, and "still use" comes from the paragraph before. The rest is not a landing. "This essay ends with the other half of that question" tells the reader what is happening instead of showing it, and the last words are a promise of a different essay. The essay also never comes back to where it began. It opened on a network's weights, which move only while a force pushes them, and Aristotle's name last appears at l. 139. The header note gives a ready-made ring: "This one asks what everything else costs."

- Original: `*The Standard of Motion* ends by asking which motions a computational universe makes free. This essay ends with the other half of that question: what the observers inside it must pay. A later essay on observers takes up both.`
- Proposed: `*The Standard of Motion* ends by asking which motions a computational universe makes free. A later essay on observers takes that up. Everything else moves the way a network's weights do: only while a force pushes, and at the price of what it discards.`

If the author prefers to keep "the other half", the minimal repair is to move the sentence about the later essay ahead of it, so the essay ends on "what the observers inside it must pay."

### S2. *The demon is a learner* accumulates; a small reorder makes it build

After l. 112 ("Several results show that these are one ledger") the section is eight paragraphs of the same shape: name, verb, result, moral. The order is the order of insertion. Two signs of the seams: the two Boyd papers are separated by four paragraphs, and "this kind of bound" (l. 127) points past Boyd 2017 and the Boltzmann machine to Still 2012.

**Proposed order:** l. 114 (Boyd 2022: the best demon is the likeliest model), l. 125 (Boyd 2017: what that demon must contain), l. 116 (Still 2012: what memory costs), l. 120 (Still 2020: the engine), l. 123 (Boltzmann machine: the analogy in training), l. 127 (Goldt and Seifert: the literal bound for a network), l. 129 (bits back: the objective), l. 131 (Friston). This runs from the demon, through its memory, to the network and its objective, and the analogy of l. 123 is followed at once by the literal bound.

- Paragraph break missing. A trailing space at the end of l. 122 and no blank line run Still's engine and the Boltzmann machine into one paragraph, and "counterpart" has nothing to attach to.
  - Original: `Training has no literal counterpart, since Carnot's argument needs a conserved energy and a loss is not conserved.`
  - Proposed (as a new paragraph): `Training a network has no literal engine cycle, since Carnot's argument needs a conserved energy and a loss is not conserved.`
- "The matching requirement" has not been mentioned.
  - Original: `Boyd, Dibyendu Mandal and Crutchfield showed the matching requirement on structure ([2017](https://arxiv.org/abs/1609.05353)).`
  - Proposed: `Boyd, Dibyendu Mandal and Crutchfield showed what such a demon must contain ([2017](https://arxiv.org/abs/1609.05353)).`
- With the reorder, "this kind of bound" needs an anchor, and the contrast with the analogy is worth stating.
  - Original: `Sebastian Goldt and Udo Seifert brought this kind of bound to neural networks ([2017](https://arxiv.org/abs/1611.09428)).`
  - Proposed: `Sebastian Goldt and Udo Seifert brought a literal bound to neural networks ([2017](https://arxiv.org/abs/1611.09428)).`
- **"One ledger" against "nothing in it is paid".** L. 112 says demon and learner are one ledger. L. 129 says "Even the learner's objective is a free energy". L. 131 then says that this quantity is not paid in anything. The Friston paragraph is a useful limit, but it pulls the rug from l. 129. A slight hedge at l. 129 lets the two stand. This touches a claim, so it is the author's call.
  - Original: `Even the learner's objective is a free energy, measured in code length.`
  - Proposed: `Even the learner's objective has the form of a free energy, measured in code length.`
- **A promise not cashed.** L. 23 says algorithmic information theory tells "what a learner can avoid paying". The payoff is "Understanding lowers the bill" (l. 82), but it is said of a demon erasing digits of $\pi$ and never transferred to a learner. One sentence would do it, wherever that paragraph lands (see S3).
  - Original: `Understanding lowers the bill.`
  - Proposed: `Understanding lowers the bill. A learner that has found the regularity in its data stands where the second demon stands.`
- **The section ends on a citation of a further hypothesis** (Kiefer). Acceptable as a limit, and the reorder in S1 gives the next section a better start. I would not add a closing line here.

### S3. $K$ is priced before it is justified, and *What forgetting costs* ends on a recap

**L. 86 is out of place.** After Kolchinsky and Wolpert, the section suddenly returns to the "cloud of possible weight settings" from l. 68, recaps *Who Teaches the Weights?*, and ends on a third "has to go somewhere". The reader has moved on to Turing machines. The natural home is straight after the Landauer paragraph (l. 74), where "Landauer's principle counts a cost on another level" has its referent, and the last sentence should go.

- Original: `That essay counted the loss in what the model can still learn. Landauer's principle counts a cost on another level. As the cloud of possible weight settings shrinks toward a minimum, the entropy it loses has to go somewhere.`
- Proposed (moved to follow l. 74): `That essay counted the loss in what the model can still learn. Landauer's principle counts the same narrowing in heat.`

**L. 80–84 are in the wrong section (matter of judgment, but I recommend it).** "Algorithmic information theory refines the price" brings in Kolmogorov complexity to price conversions. Only then does the next section ask whether a single state has an entropy, and answers with Kolmogorov complexity. The roadmap at l. 23 has the opposite order: "how many bits a single state holds, and with it what a learner can avoid paying". §11 of the mathematics page also has that order: average complexity, logarithmic growth, Zurek, conversion, bookmaker. Moving l. 80–84 to follow l. 102 would let *What forgetting costs* end on the demon's payment (l. 78), a firm hand-on, and would put "Understanding lowers the bill" after the reader knows what $K$ is. Stitches:

- Original: `Kolmogorov complexity gives it one without that choice.`
- Proposed: `The Kolmogorov complexity $K(x)$ of a string, the length of the shortest program that prints it, gives it one without that choice.`
- Original: `Algorithmic information theory refines the price. The Kolmogorov complexity $K(x)$ of a string is the length of the shortest program that prints it. Bennett, Péter Gács, Ming Li, Paul Vitányi and Wojciech Zurek worked out`
- Proposed: `Complexity also refines Landauer's price. Bennett, Gács, Ming Li, Paul Vitányi and Zurek worked out`
- First names then move forward: `Gács built` (l. 92) becomes `Péter Gács built`, and see E20 for Zurek at l. 94.

If the move is declined, the fix for l. 86 stands by itself.

**The Baez–Stay and bookmaker paragraph (l. 104–106)** has nothing to do with the section title, but it ends on "The traders are the bookmaker's demons", which hands on well. Keep it (see E21 and E22 for its unanchored terms).

### S4. *Aristotle was right about a regime* runs on past its point and has no landing; it also opens a vocabulary debt

The section's claim is complete at "Learners live in the robust regime." (l. 36). Noise and momentum (l. 38–40) are objections and earn their place. JKO (l. 42) and mirror descent (l. 44–46) are extensions that the essay itself does not use again. The mathematics page does (§10.2, §12.8), and the bookmaker benefits, so I would keep them. But the section stops on a technical remark about a discrete step, and the next section opens elsewhere. It needs one sentence that says what the three geometries add up to.

Add to the end of l. 46 (see E5 for the rest of that sentence):

- Proposed new last sentence: `Three geometries, one law: velocity follows force, and where the force vanishes the motion stops.`

"Newton's world has a property that Aristotle's lacks." then follows naturally.

**Vocabulary debt.** Gibbs distribution, temperature, free energy, Wasserstein distance and Kullback–Leibler divergence all come in this section, before the word "entropy" has appeared (l. 50). Later the essay leans on terms it never explains: *score*, *forward process*, *mutual information*, *partition function*, *surprisal*, *nat*, *second law*. The word *divergence* is used in two unrelated senses (l. 68 of a vector field, elsewhere between distributions). The companion's §8 says openly that the essay assumes temperature, entropy and free energy, so that is by design. But a non-physicist can be given a clause at first use at no cost to the argument. See E3–E5, E8, E10, E11, E21, E22, E26 and the term table in Part 3.

## Part 2. The essay: sentences

### Confident, ranked

**E1** (l. 120). Garden path: "Still later" reads as an adverb.
- Original: `Still later built this bound into a full engine cycle ([2020]`
- Proposed: `Susanne Still later built this bound into a full engine cycle ([2020]`

**E2** (l. 52). "does not decrease from the mechanics" misattaches. "The seminar" is also definite for a reader who has not read *The Standard of Motion*, and the essay never names the second law it goes on to use (first at l. 74). See V1 for "I".
- Original: `The seminar Piotr Biler ran around 2003 took this on directly. We derived the theorem that entropy does not decrease from the mechanics of an ideal gas, with the molecules as balls.`
- Proposed: `A seminar I took part in, run by Piotr Biler around 2003, took this on directly. From the mechanics of an ideal gas, with the molecules as balls, we derived the second law of thermodynamics: entropy does not decrease.`

**E3** (l. 110, l. 141). *Score* and *forward process* are never explained, and "produces" has no object. Introduce the score where the essay first needs it.
- Original: `at every moment. A diffusion model learns that dependence from data, and with it turns noise into samples.`
- Proposed: `at every moment, through the gradient of the log density, called the *score*. A diffusion model learns the score from data, and with it turns noise into samples.`
- Original: `The forward process produces at most the divergence of the data from the noise, however long it runs, and Akhil Premkumar argues that this total is the floor`
- Proposed: `The forward process, which turns data into noise, produces entropy, at most the divergence of the data from the noise, however long it runs. Akhil Premkumar argues that this total is the floor`

**E4** (l. 42). $\Psi$ is never introduced, and "free energy" and "Wasserstein distance" get no gloss. Using $L$ keeps the essay's one symbol for the potential.
- Original: `the density of an overdamped particle with isotropic, constant noise flows downhill on the free energy $\int\Psi\rho + T\int\rho\log\rho$, as measured by the Wasserstein distance between distributions`
- Proposed: `the density of an overdamped particle in a potential $L$, with isotropic, constant noise, flows downhill on the free energy $\int L\rho + T\int\rho\log\rho$, a mean energy minus a temperature times an entropy. Downhill is measured by the Wasserstein distance, the cost of carrying one distribution onto another`

**E5** (l. 46). "JKO's" discrete step is not in the essay: l. 42 gives only the continuous flow. The sentence also brings in KL, undefined, in a subordinate position. "Squared" is added from JKO; see Q5.
- Original: `The discrete step is built like JKO's: minimize the loss plus a divergence from the current point, scaled by the step, with the Kullback–Leibler divergence in place of the Wasserstein distance.`
- Proposed: `Its discrete step minimizes the loss plus a divergence from the current point, scaled by the step. Here the divergence is the Kullback–Leibler divergence, a directed measure of how far one distribution lies from another. JKO build their flow from the same kind of step, with the squared Wasserstein distance in its place. Three geometries, one law: velocity follows force, and where the force vanishes the motion stops.`

**E6** (l. 34). "The small parameter" is definite, but no small parameter has been named.
- Original: `The small parameter is not $m/\gamma$, which is a time, but $mk/\gamma^2$,`
- Proposed: `The quantity that must be small is not $m/\gamma$, which is a time, but $mk/\gamma^2$,`

**E7** (l. 44). The second object of "moves" is a garden path.
- Original: `#the-bookmaker-is-a-learner), and a policy improved by natural policy gradient. It takes its gradient steps`
- Proposed: `#the-bookmaker-is-a-learner). It also moves a policy under natural policy gradient. It takes its gradient steps`

**E8** (l. 23). $k$ and $T$ are unglossed. "Maxwell demon" is the title word, explained only at l. 78. "Put together, these results support the title" is a remark about the essay, where the reader wants the claim.
- Original: `forgetting one costs at least $kT\ln 2$ of heat.`
- Proposed: `forgetting one costs at least $kT\ln 2$ of heat, where $T$ is the temperature and $k$ is Boltzmann's constant.`
- Original: `Put together, these results support the title. A learner is a Maxwell demon working in Aristotle's world: it extracts`
- Proposed: `A learner is then a Maxwell demon, the imagined sorter of molecules who turns knowledge into work, set down in Aristotle's world. It extracts`

**E9** (l. 68). The opening "it" attaches awkwardly to "the fact". The curvature clause is said twice. Dropping the word "divergence" here also removes the clash with the divergence between distributions, which is the sense used everywhere else.
- Original: `Here is the fact that turns Aristotle's world into an economy: it violates Liouville's theorem. The gradient flow $\dot w = -\nabla L$ has divergence $-\operatorname{tr}\nabla^2 L$, which is negative wherever the loss is, on balance over directions, curved upward. Near a minimum where the loss curves upward, the flow squeezes volume. A cloud`
- Proposed: `One fact turns Aristotle's world into an economy: that world violates Liouville's theorem. The gradient flow $\dot w = -\nabla L$ expands volume at the rate $-\operatorname{tr}\nabla^2 L$. That rate is negative wherever the loss curves upward on balance over directions, as it does near a minimum. A cloud`

**E10** (l. 50). "A closed system's density" can be read as mass density, and this is the essay's first "entropy".
- Original: `The entropy $-\int\rho\ln\rho$ of a closed system's density stays constant forever.`
- Proposed: `Take a probability density $\rho$ over the states of a closed system. Its entropy $-\int\rho\ln\rho$, a measure of how spread out the density is, stays constant forever.`

**E11** (l. 117). $\beta$ is never defined. The essay writes $kT$ everywhere else, and the sentence before already says "at least $kT$ times".
- Original: `$$\beta\langle W_{\text{diss}}\rangle \ge I_{\text{mem}} - I_{\text{pred}}.$$`
- Proposed: `$$\langle W_{\text{diss}}\rangle \ge kT\,(I_{\text{mem}} - I_{\text{pred}}).$$`

**E12** (l. 120–121). $\eta$ is the step size at l. 18 and l. 39, and it is an efficiency at l. 121 with no introduction.
- Original: `It reaches Carnot's limit only if everything in its memory predicts:`
- Proposed: `Its efficiency $\eta$, no longer the step size, reaches Carnot's limit only if everything in its memory predicts:`

**E13** (l. 123). Dangling modifier: the gap is not read as an engine.
- Original: `Read as an engine, the gap between data and model does the work of the gap between $T$ and $T'$.`
- Proposed: `Read the machine as an engine, and the gap between data and model does the work of the gap between $T$ and $T'$.`

**E14** (l. 131). A system is not a hypothesis.
- Original: `A system whose thermodynamic free energy directly encodes its variational free energy is a further hypothesis, which Alex Kiefer has worked out for the brain`
- Proposed: `That a system's thermodynamic free energy directly encodes its variational free energy is a further hypothesis, which Alex Kiefer has worked out for the brain`

**E15** (l. 84). "No computable realization" of what? The sentence also does two jobs, and the second half seems to take back the first.
- Original: `The cost that no computable realization escapes is $K(\text{input}\mid\text{output})$, what the computation forgets about where it started, though it can be paid in the complexity of the machine instead of in heat.`
- Proposed: `No computable realization of a computation escapes one cost: $K(\text{input}\mid\text{output})$, what the computation forgets about where it started. That cost can be paid in the complexity of the machine instead of in heat.`

**E16** (l. 70). New before given: "the exported entropy" comes after a paragraph that spoke only of volume, and a pointer to the mathematics page stands in between.
- Original: `Rolf Landauer turned the exported entropy into a price`
- Proposed: `The volume a system loses is entropy. Rolf Landauer turned that exported entropy into a price`

**E17** (l. 40). A 185-word paragraph doing two jobs. Break it where momentum starts, and gloss the Gibbs distribution at first use.
- Original: `Momentum looks like a return to Newton. Polyak's heavy-ball method`
- Proposed: start a new paragraph at `Momentum looks like a return to Newton.`
- Original: `so SGD does not settle into the Gibbs distribution $e^{-L/T}$ of its loss, as it would if the noise were isotropic and constant.`
- Proposed: `so SGD does not settle into the Gibbs distribution $e^{-L/T}$, the equilibrium of a system with energy $L$ at temperature $T$, as it would if the noise were isotropic and constant.`

**E18** (l. 36). *Qualitative theory* is used here and explained 99 lines later. The Polyak–Łojasiewicz condition is named and its content never stated, though the companion's §10.2 calls it "the Polyak–Łojasiewicz condition of the essay" and relies on it.
- Original: `Its qualitative theory is simple, and that simplicity is what learning relies on.`
- Proposed: `Its qualitative theory, the study of what its orbits do without solving for them, is simple, and learning relies on that simplicity.`
- Original: `Boris Polyak's condition of the same year, now called the Polyak–Łojasiewicz condition, gives convergence at a geometric rate.`
- Proposed: `Boris Polyak's condition of the same year, now called the Polyak–Łojasiewicz condition, says that the squared gradient bounds the height of the loss above its minimum. It gives convergence at a geometric rate.`

**E19** (l. 27). A capitalized quotation after "and", with no speaker. Same repair as made in *The Standard of Motion* on 5 Nov.
- Original: `Aristotle said that heavier bodies fall faster and denser media slow them down, and "What Aristotle does not have is only the square root."`
- Proposed: `Aristotle said that heavier bodies fall faster and denser media slow them down. In Rovelli's words, "What Aristotle does not have is only the square root."`

**E20** (l. 94). "It" reaches for the nearest antecedent, Gács's entropy of 1994, which Zurek in 1989 cannot have used.
- Original: `Zurek used it to define the entropy a demon actually faces`
- Proposed: `Zurek used $K$ to define the entropy a demon actually faces`
- If S3's move is taken, write `Wojciech Zurek used $K$…`, since this becomes his first appearance.

**E21** (l. 104). "Kinship" between what? *Partition function* is unexplained.
- Original: `The formal kinship goes further.`
- Proposed: `The kinship between computation and statistical mechanics goes further.`
- Original: `is then a partition function, evaluated where`
- Proposed: `is then a partition function, the normalizing sum of a Gibbs distribution, evaluated where`

**E22** (l. 105–106). $q$ is never defined. A reader who has not read the bookmaker essay cannot parse the cost function, and "nat" and "surprisal" are unexplained. The sentence after the display also chains three claims.
- Original: `is a log-partition function with temperature $b$, its prices are Gibbs probabilities, and its worst-case loss,`
- Proposed: `where $q_i$ counts the shares sold on outcome $i$, is a log-partition function with temperature $b$. Its prices are Gibbs probabilities, and its worst-case loss,`
- Original: `Each trader is paid $b$ for every nat by which they reduce the surprisal of the outcome that occurs.`
- Proposed: `A nat is the unit of entropy with natural logarithms, about 1.44 bits. Each trader is paid $b$ for every nat by which they reduce the surprisal of the outcome that occurs, its negative log probability.`

**E23** (l. 110). "The same kind of thing" is vague where the essay is making its key link.
- Original: `The noise of a heat bath is the same kind of thing: it is fixed in advance and knows nothing of the distribution it acts on.`
- Proposed: `The noise of a heat bath is ignorant in the same way. It is fixed in advance and knows nothing of the distribution it acts on.`

**E24** (l. 80). $K(y\mid x)$ is used without being defined. The sentence also joins two moves. (If S3's move is taken, the same edit applies in the new place.)
- Original: `Converting $x$ into $y$ needs about $K(y\mid x)$ bits supplied and about $K(x\mid y)$ bits erased, and the net dissipation is about`
- Proposed: `Write $K(y\mid x)$ for the length of the shortest program that prints $y$ given $x$. Converting $x$ into $y$ needs about $K(y\mid x)$ bits supplied and about $K(x\mid y)$ bits erased. The net dissipation is about`

**E25** (l. 82). Number mismatch between "bits of them" and "understand it".
- Original: `A demon that erases $n$ bits of them "without taking the trouble to understand it" pays for $n$ bits.`
- Proposed: `A demon that erases a string of $n$ of them "without taking the trouble to understand it" pays for $n$ bits.`

**E26** (l. 116, l. 127). *Mutual information* first appears, unexplained, at l. 143, but the bounds of l. 116–121 are written in it. *Langevin dynamics* is unexplained.
- Original: `A physical system driven by a changing signal keeps some information about the signal's past.`
- Proposed: `A physical system driven by a changing signal keeps some information about the signal's past, measured as mutual information: the bits that knowing one saves in describing the other.`
- Original: `learning by Langevin dynamics.`
- Proposed: `learning by Langevin dynamics, gradient flow with thermal noise.`

**E27** (l. 90). An easy concrete anchor. The reader has just seen an entropy curve for one gas, and this is why it existed.
- Original: `a choice of macrostates, a coarse description.`
- Proposed: `a choice of macrostates, a coarse description such as the histogram of energies in our simulation.`

**E28** (l. 54). Spelling: the essay and *The Standard of Motion* are American ("behavior", "center").
- Original: `along the line between their centres.`
- Proposed: `along the line between their centers.`

**E29** (l. 23, 34, 74, 78, 81, 106, 116). $k$ is Boltzmann's constant everywhere except l. 34, where it is the stiffness, and l. 34 must stay $k$ to match the companion's $\varepsilon = mk/\gamma^2$. Mechanical fix: write Boltzmann's constant as $k_{\mathrm B}$ throughout the essay.

### Tics

**T1. The pseudo-cleft "X is what Y"** (nine uses). Lines: 36, 56 ("is where"), 62, 68, 137, 139 twice, 141 twice. Five are in the last section, four of them in two adjacent paragraphs. This is the most noticeable tic and, in that concentration, the one that reads as generated. L. 36 and l. 137 are fixed above. Also:
- Original: `Boltzmann's assumption is what makes the one-ball distribution such a state, and the reversed gas shows the failure: the same histogram, with the opposite future.`
- Proposed: `Boltzmann's assumption makes the one-ball distribution such a state. The reversed gas shows the failure: the same histogram, with the opposite future.`
- Original: `The history of each particle is what no observer can hold. The structure of a population is what a learner can compress.`
- Proposed: `No observer can hold the history of each particle. A learner can compress the structure of a population.`

**T2. "The same" as the universal connective** (about 20 uses, a dozen of them asserting an identity flatly: "The same regime", "The same accounting", "the same form", "the same mathematics", "the same theorem", "the same quantity", "the same structure", "The quantity is the same", "the same move", "The same description", "the same test"). The essay's thesis is an identity, so many are earned. Thin them where "this" will do:
- Original: `meets the same structure in reinforcement learning`
- Proposed: `meets this structure in reinforcement learning`
- Original: `Aristotle's law passes the same test`
- Proposed: `Aristotle's law passes this test`
- Original: `runs the same mathematics`
- Proposed: `runs on this mathematics`

**T3. Escalating openers.** "Algorithmic information theory refines the price" (l. 80), "sharpened this" (l. 84), "The formal kinship goes further" (l. 104), "built this bound into a full engine cycle" (l. 120), "takes this objective much further" (l. 131). Each says "and there is more", which is what accumulation sounds like. S2 and S3 reduce the need. Those that remain should say what the next step adds.

**T4. The short moral at the end of a paragraph.** About thirteen: l. 19, 21, 36, 40, 62, 76, 82, 106, 114, 118, 127, 141, 143. Many are the best sentences in the essay ("Understanding lowers the bill."), but the pattern is audible, and a reader learns to expect a mic-drop. I would demote two of the weaker ones: l. 118's second sentence adds nothing to its first, and l. 114 restates the sentence before it (see taste item A3).

**T5. "Turns X into Y"** (l. 68, 70, 80, 110, 137, 131 "Turning", 135 "makes that move into"). Not serious. E3 and the l. 137 repair remove two.

**T6. Paragraphs opening on a name and a verb of showing** (nine "showed"). This comes with the survey material. S2's order and the openers above help more than swapping verbs would.

### Voice

**V1. There is no "I" in this essay.** A count gives zero "I" and zero "my". The only first person is "we", three times (l. 52, l. 58 twice). The essay is meant to be in the author's voice, and the 5 Nov prompt asked for more personal touch, but the seminar is told at arm's length, and without *The Standard of Motion* a reader cannot tell who "we" is. "We" also changes reference between l. 52 (the seminar) and l. 58 (author and Claude) with only "More than twenty years after" to mark it. E2 gives one "I". A second is available if the author wants it:
- Original: `More than twenty years after the seminar, we simulated a two-dimensional version of its gas:`
- Proposed: `More than twenty years after the seminar, Claude and I simulated a two-dimensional version of its gas:`

**V2. Phrases that sound generated or are out of voice.** "Put together, these results support the title." (E8). "This essay ends with the other half of that question" (S1). "The formal kinship goes further." (E21). "Several results show that these are one ledger." is fine as a section thesis but would be stronger with the section's shape in it. Otherwise the voice holds, and the gas section is entirely in it.

### Matters of taste

- **A1** (l. 42). The Blumenthal sentence is a bibliographic note that ends a paragraph with no move. It is the essay's seed and credit is due. It could become a parenthesis on the JKO citation.
- **A2** (l. 72–74). The Bennett quotation has "IBDF" in it, and the gloss comes after. Glossing first ("Charles Bennett, who calls the bits the information-bearing degrees of freedom, IBDF, and everything else the NIBDF, gives the argument in the form used here") spares the reader the stumble. "In the form used here" is itself dispensable.
- **A3** (l. 114). Adjacent sentences say the same thing. Possible: `The work-maximizing demon is the maximum-likelihood learner: choosing one is equivalent to choosing the other.` for the two sentences beginning `The answer: choosing the agent`.
- **A4** (l. 23, 64, 68, 86). "Send the difference somewhere" is a refrain. L. 23 and l. 64 work. S3 removes the third use, at l. 86.
- **A5** (l. 98). "The demon's thermodynamic account and a learner's model-selection account have the same form" anticipates the next section's thesis. It is correct where it stands, but a bit early. It could close that section's first paragraph instead.
- **A6** (l. 135). "An observer survives by finding the parts of it that can." "Survives" is stronger than the argument, and the ellipsis is long. Possible: `An observer gets by on the parts of it that can.`
- **A7** (l. 120, companion §10.3). The essay writes $I_{\text{pred}}$ for Still 2020 and the companion writes $I_{\text{rel}}$, so a reader following the link meets a new name. Either note "the relevant part, written $I_{\text{rel}}$ there" or leave it (see Q3).
- **A8.** The essay mixes $\log$ (l. 42, 46, 102, 105, $b\log n$) and $\ln$ ($kT\ln 2$, entropy at l. 50). The companion uses $\ln$ except in §11. Harmless, but easily unified.
- **A9** (l. 15). The header note is long, and its last sentence has three coordinated clauses. Possible split at "which continues the first essay's companion."

### Questions for the correctness reader (essay)

- **Q1** (l. 116–118 against the subtitle and l. 23). The thesis is that a learner pays for what it *discards*. Still et al. charge for what the system *keeps* and cannot use, and l. 118 then says that an efficient memory "forgets the rest", which by Landauer costs. Presumably the unpredictive memory is what must be erased or dissipated as the signal moves on. A careful reader will feel the tension, and one sentence reconciling them may be needed.
- **Q2** (l. 68). "A law that contracts volume is always the shadow of a system coupled to a medium." Is "always" safe? It may need "physically realized".
- **Q3** (l. 120–122). Still 2012's $I_{\text{pred}}$ is about the signal's future. Still 2020's quantity is relevance to a work-extraction variable. Is "predicts" right for the engine, or should the essay say "relevant"?
- **Q4** (l. 92). "On average, the bits needed to describe a typical state equal the bits of uncertainty" drops the $K(P)$ slack just displayed. Fine as a gloss?
- **Q5** (l. 46). "Scaled by the step": the divergence is divided by the step, and JKO's distance is squared (E5 adds "squared"). Please confirm.

## Part 3. The essay: technical terms

Status: **OK** means explained at or before first use, or clear from context for an educated technical reader. **Late** means used before it is explained. **Never** means not explained in the essay.

| Term | First use | Explained | Status and fix |
|---|---|---|---|
| Maxwell demon | l. 23 | l. 78 | **Late**. E8 |
| temperature $T$, constant $k$ | l. 23 | $T$ in passing at l. 74, $k$ nowhere | **Never** for $k$. E8, E29 |
| bit | l. 23 | context | OK |
| Kolmogorov complexity | l. 80 (algorithmic information theory at l. 23) | l. 80 | OK |
| conditional complexity $K(y\mid x)$ | l. 80 | not stated | **Never**. E24 |
| singular perturbation, slow manifold | l. 31 | context, formula | OK |
| overdamped | l. 34 | l. 34 | OK |
| Lyapunov function | l. 36 | same sentence | OK |
| analytic function, critical point | l. 36 | not stated | OK for the audience |
| qualitative theory | l. 36 | l. 135 | **Late**. E18 |
| Polyak–Łojasiewicz condition | l. 36 | content not stated | **Never**. E18 |
| diffusion (process) | l. 38 | formula only | OK, thin |
| isotropic, anisotropic | l. 40 | not stated | OK for the audience |
| Gibbs distribution | l. 40 | formula only | **Never**. E17, E21 |
| free energy | l. 42 | formula with undefined $\Psi$ | **Never** in words. E4 |
| Wasserstein distance | l. 42 | not stated | **Never**. E4 |
| Fisher information metric | l. 44 | "whose inverse is diag(p)" | OK, thin |
| natural policy gradient | l. 44 | linked essay | OK |
| replicator dynamics | l. 46 | same sentence | OK |
| Kullback–Leibler divergence; "divergence" of distributions | l. 46 | not stated | **Never**. E5 |
| divergence of a vector field | l. 68 | not stated, clashes with the above | E9 removes it |
| phase space, Hamiltonian flow | l. 50 | deferred to *The Standard of Motion* | OK, thin. A clause ("the space of positions and momenta") would cost nothing |
| Liouville's theorem | l. 50 | same paragraph | OK |
| entropy | l. 50 | formula only | Thin. E10 |
| H-theorem | l. 52 | same section | OK |
| second law | l. 74 | never connected to the H-theorem | **Never**. E2 |
| Maxwell's distribution | l. 54 | context (l. 52) | OK |
| correlation, arrow of time | l. 56 | context | OK |
| coarse graining | l. 62 | l. 62 | OK |
| macrostate | l. 90 | l. 90 | OK |
| microstate | l. 104 | not stated | OK given macrostate |
| heat bath | l. 68 | not stated | OK for the audience |
| Landauer's principle, logically irreversible | l. 70–72 | same section | OK |
| dissipation | l. 81 | context | OK |
| Shannon's entropy, $H(P)$ | l. 90 | formula, context | OK |
| minimum description length, two-part code | l. 98 | same paragraph | OK |
| partition function | l. 104 | not stated | **Never**. E21 |
| surprisal; surprise | l. 106; l. 131 | not stated | **Never**. E22 |
| nat | l. 106 | implied by "per nat, which is $kT\ln 2$ per bit" | **Never** directly. E22 |
| time reversal of a diffusion | l. 110 | same sentence | OK |
| diffusion model | l. 110 | one clause | OK, thin |
| score | l. 141 | not stated | **Never**. E3 |
| forward process | l. 141 | not stated | **Never**. E3 |
| mutual information | l. 143 (in use from l. 116) | not stated | **Never**. E26 |
| information bottleneck | l. 122 | same sentence | OK |
| Boltzmann machine, clamped, visible units | l. 123 | same sentence | OK |
| information ratchet, requisite variety | l. 125 | same paragraph | OK |
| Langevin dynamics | l. 127 | not stated | **Never**. E26 |
| entropy production | l. 127 | same sentence | OK |
| evidence lower bound, variational inference | l. 129 | not stated | OK for an ML reader |
| computational irreducibility | l. 135 | gloss in the next sentence | OK |
| usable information, logical depth | l. 143 | same paragraph | OK |

Symbols: $\beta$ undefined (E11). $\eta$ used twice (E12). $k$ used twice (E29). $\Psi$ undefined (E4). $q$ undefined (E22).

## Part 4. The mathematics page

### Does it read as a continuation?

Yes. Section and figure numbering run on, Figure 1 is on the previous page, the previous page's last line points here, and "§2 of the previous page" is used consistently. Style differs in three small ways: British spelling (C21), one misleading statement of where the previous page ended (C10), and "the essay", which on the previous page meant *The Standard of Motion* (C19). All six anchors the essay links to resolve in the HTML: `#the-overdamped-limit`, `#the-h-theorem-for-a-gas-of-balls`, `#friction-from-a-hamiltonian-bath`, `#every-h-theorem-has-this-shape`, `#reversing-a-diffusion`, `#information-as-work`.

### Confident, ranked

**C1** (l. 371). $c$ is used as if already defined.
- Original: `Out of equilibrium, the second term is what reversal needs in addition.`
- Proposed: `Out of equilibrium, the second term is a correction $c$ that reversal needs in addition.`
- Original: `In terms of the correction $c$ itself, the entropy production`
- Proposed: `In terms of $c$, the entropy production`

**C2** (l. 269). Reads as though Hinton and van Camp wrote the identification in the essay.
- Original: `Hinton and van Camp make this identification in the essay.`
- Proposed: `This is the identification of Hinton and van Camp, described in the essay.`

**C3** (l. 35, §7 last paragraph). The pointer to §9.8 stands between "Aristotle's law" and "the same thing", so "the same thing" reads as where the drag comes from.
- Original: `§9.8 shows where the drag itself comes from. The swirl-and-slide decomposition of §2 shows the same thing from the side of the vector field. The overdamped limit is the regime where the slide dominates.`
- Proposed: `The swirl-and-slide decomposition of §2 shows the same thing from the side of the vector field: the overdamped limit is the regime where the slide dominates. §9.8 shows where the drag itself comes from.`

**C4** (l. 313). "That assumption" has no referent. The last assumption named is isotropic noise, and the sentence before speaks of a Gibbs state.
- Original: `A relation that holds without that assumption comes from stationarity alone.`
- Proposed: `A relation that does not need a Gibbs state comes from stationarity alone.`

**C5** (l. 215). Two lines earlier the page gives the dissipation over a cycle as at least $T\,I_{\text{irrel}}$, at a single temperature. This sentence restarts with a different bound and no transition, and a reader takes them for a contradiction (see QC1).
- Original: `The heat dissipated over a cycle is at least $T\,I_{\text{mem}} - T'\,I_{\text{rel}}$.`
- Proposed: `With two temperatures, the net heat dissipated over a cycle is at least $T\,I_{\text{mem}} - T'\,I_{\text{rel}}$.`

**C6** (l. 157). Dangling participle.
- Original: `Simulating a free particle with 4,000 oscillators, its velocity falls as $e^{-\gamma t/m}$ to within a percent over the times checked, and its mean squared velocity approaches $T/m$.`
- Proposed: `In a simulation of a free particle with 4,000 oscillators, the velocity falls as $e^{-\gamma t/m}$ to within a percent over the times checked, and the mean squared velocity approaches $T/m$.`

**C7** (l. 123). "It" can only refer to "nothing".
- Original: `Nothing has been lost from the gas. It has moved to a place the one-ball description cannot see.`
- Proposed: `Nothing has been lost from the gas. The information has moved to a place the one-ball description cannot see.`

**C8** (l. 307, l. 373). "Score" has two senses on this page: in the score-function identity it is the gradient in the parameters, and in §12.10 the gradient in the state. Readers from statistics will conflate them.
- Original: `The unknown in the drift is the *score* $\nabla\ln\rho_t$, and it is learnable:`
- Proposed: `The unknown in the drift is the *score* $\nabla\ln\rho_t$, a gradient in the state, where the score function of §12.5 is a gradient in the parameters. It is learnable:`

**C9** (l. 388, 390; §12.4, §12.6). The table uses "BIC" and "SGLD", which appear nowhere in the body.
- Original: `and the width term becomes G. Schwarz's $\frac d2\ln N$`
- Proposed: `and the width term becomes the $\frac d2\ln N$ of G. Schwarz's Bayesian information criterion (BIC)`
- Original: `M. Welling and Y. W. Teh added Gaussian noise to minibatch gradient steps, which turns them into Langevin dynamics (ICML 2011).`
- Proposed: `M. Welling and Y. W. Teh added Gaussian noise to minibatch gradient steps, which turns them into Langevin dynamics. The method is stochastic gradient Langevin dynamics, SGLD (ICML 2011).`

**C10** (l. 19). The previous page ends on the Bombelli–Henson–Sorkin theorem, not on a conservation law. A reader coming straight from §6 will be puzzled.
- Original: `The previous page ended its account of closed systems with a conservation law.`
- Proposed: `The previous page's account of closed systems, in §2, ends with a conservation law.`

**C11** (l. 125). Ebtekar and Hutter have not appeared yet on this page.
- Original: `Ebtekar and Hutter's bound, as the essay reads it, is the same point in modern form.`
- Proposed: `Ebtekar and Hutter's bound (§11), as the essay reads it, makes the same point in modern form.`

**C12** (l. 43, l. 159). §9.8 closes on "A coarse graining is what turns Newton into Aristotle", and this page never defines the term. §8.1 is the place.
- Original: `The full list saying which ball is in which box is the *microstate*.`
- Proposed: `The full list saying which ball is in which box is the *microstate*. Passing from the second to the first is *coarse graining*.`

**C13** (l. 47). Too many jobs for one paragraph, and "Here… was" has no clear place. Start a new paragraph at Gibbs.
- Original: `Gibbs's entropy $-\int\rho\ln\rho$ has the same form with a different meaning. Here $p_i$ was the fraction of balls in box $i$,`
- Proposed: `Gibbs's entropy $-\int\rho\ln\rho$ has the same form with a different meaning. In the count above, $p_i$ was the fraction of balls in box $i$,`

**C14** (l. 65). $H$ is Shannon's entropy two paragraphs earlier, and it will be Boltzmann's in §9.
- Original: `since any function of $H$ is stationary.`
- Proposed: `since any function of the Hamiltonian is stationary.`

**C15** (l. 176). §9.8 has already derived fluctuation–dissipation. Without a pointer, §10.2 reads as though it were new.
- Original: `**The Einstein relation.** The noise strength here is not free.`
- Proposed: `**The Einstein relation.** The noise strength here is not free, as §9.8 found from the oscillators. The density equation shows it again.`

**C16** (l. 186). Two jobs. Break the paragraph at the rate.
- Original: `nats. How fast? If $\pi$ satisfies`
- Proposed: `nats.` new paragraph `How fast? If $\pi$ satisfies`

**C17** (l. 341). Two jobs, and $D$ becomes a number here while meaning a divergence everywhere else. Break at the price.
- Original: `The exponential average has a price.`
- Proposed: start a new paragraph here.

**C18** (l. 361). "Here" is unclear, and "spin glass" is unexplained.
- Original: `A sparse graph has one further failure with no counterpart here: below a spin glass transition, many long loops`
- Proposed: `A sparse graph has one further failure with no counterpart in the gas: below a spin glass transition, where the system freezes into one of many disordered states, many long loops`

**C19** (l. 17). On the previous page "the essay" meant *The Standard of Motion*. The page says "the essay" often, and a reader following on needs the switch stated.
- Original: `$D(p\|q) = \sum_x p(x)\ln\frac{p(x)}{q(x)}$ is the Kullback–Leibler divergence.`
- Proposed: `$D(p\|q) = \sum_x p(x)\ln\frac{p(x)}{q(x)}$ is the Kullback–Leibler divergence. On this page "the essay" means *The Demon Is a Learner*.`

**C20** (l. 96). The shorthand $f_*$, $f'$, $\varphi_*$, $\varphi'$ is used from here on and never stated.
- Original: `For any function $\varphi$ of velocity, consider`
- Proposed: `Write $f_* = f(v_*)$, $f' = f(v')$, $f_*' = f(v_*')$, and likewise for other functions. For any function $\varphi$ of velocity, consider`

**C21** (throughout). British spellings on an American page, and the previous page has none: `centre` (l. 79 twice), `relabellings` (l. 97), `colour` and `colours` (l. 131, and the Figure 4 caption at l. 375), `neighbours` and `neighbourhood` (l. 355, 357, 361), `travelled` (l. 361). Mechanical. Change them to center, relabelings, color, neighbors, neighborhood, traveled.

**C22** (l. 75). "Fine-grained" is used without a gloss at its first appearance on this page.
- Original: `Hamiltonian evolution keeps the fine-grained entropy constant, and yet a gas in a box relaxes.`
- Proposed: `Hamiltonian evolution keeps the fine-grained entropy, that of the density on the full phase space, constant, and yet a gas in a box relaxes.`

**C23** (l. 71). A pseudo-cleft that delays the point.
- Original: `Work is what the name refers to: the fall in $F$`
- Proposed: `The name refers to work: the fall in $F$`

**C24** (l. 315). $d$ was defined in §12.4 for a basin and not here.
- Original: `For Langevin dynamics the left side would be $dT$,`
- Proposed: `For Langevin dynamics the left side would be $dT$, with $d$ the number of weights,`

**C25** (l. 223). There is no race on this page.
- Original: `grow at the rate $D(p\|\pi)$ per race`
- Proposed: `grow at the rate $D(p\|\pi)$ per bet`

### §12: is the pattern consistent?

The stated pattern (l. 245) is one tool as physicists use it, then the same tool at work in learning. Every subsection follows it. Each has a physics part, then a single *In learning.* marker, which may govern several paragraphs. Each also ties back to something earlier on the page. The marker never reappears inside a subsection, which is consistent. The table in §12.11 has one row per subsection, in order.

| § | Heading form | Physics part | *In learning.* | Ties back to | Deviation |
|---|---|---|---|---|---|
| 12.1 | claim | 1 para | 2 paras | bookmaker | none |
| 12.2 | claim | 1 | 1 | §10.3 | see C2 |
| 12.3 | claim | 2 | 2 | §2, bookmaker | second physics idea (Maxwell relations) has its own learning paragraph; works well |
| 12.4 | claim | 1 + Figure 3 | 2 | the essay's two-part code | "The caveat is instructive." is filler; see below |
| 12.5 | claim | 1 (shortest) | 3 | §10.2 | see C4, C24 |
| 12.6 | claim | 1 | 1 | §10.2 | Welling and Teh cited as "(ICML 2011)" only, with no title or link, unlike every neighbor; see C9 |
| 12.7 | claim | derivation, 3 paras | 1 | §12.2 | none |
| 12.8 | claim | 1 | 1 | essay's third geometry | none |
| 12.9 | **no verb** | 3 paras | 1 | §9 | heading breaks the pattern; see below |
| 12.10 | **no verb** | 1 | 1 + Figure 4 + 2 | §9.4, §9.7, §10.2, §12.7 | heading breaks the pattern; see below |

Eight of the ten headings state the tool's claim. Two name a topic. Proposed, as a matter of taste:

- Original: `### 12.9 Mean field and the cavity`
- Proposed: `### 12.9 Mean field and the cavity move Boltzmann's assumption onto a graph`
- Original: `### 12.10 Reversing a diffusion`
- Proposed: `### 12.10 Reversing a diffusion takes the score`. This changes the anchor, so the essay's link to `#reversing-a-diffusion` at l. 110 would need updating. Leaving this heading as it is would also be reasonable.

Other small items in §12:

- L. 299: `The caveat is instructive. L. Dinh,` could be `There is a caveat. L. Dinh,`. "Instructive" announces a value the reader should find for themselves.
- L. 297 has "David MacKay's" where the rest of §12 uses initials. §9 mixes both ("Mark Kac", "O. E. Lanford"). A single convention would help: initials in citations, full name when a person enters the prose.

### Matters of taste

- **CA1** (l. 123). The last sentence ("For an isotropic gas of disks…") is a technical footnote at the end of a paragraph about reading. It would serve better as its own short paragraph, or right after "Its histogram is a macrostate in the sense of §8.1."
- **CA2** (l. 219). `Training does have something shaped like a cycle, and the following reading is an analogy.` could be `Training does have something shaped like a cycle, by analogy only.` The next paragraph ends with where the analogy stops, so the hedge can be short.
- **CA3** (l. 19). "Each section below asks some form of the same question" is not quite true of §8 or §12. Possible: "Most of what follows asks some form of one question".
- **CA4** (l. 182). Three coordinated clauses in one sentence; split before "the stationary state".
- **CA5** (l. 186). "(D. Bakry and M. Émery)" has no year or reference, unlike its neighbors.
- **CA6.** Symbols reused within the focus sections, none of them wrong but some costly to a reader moving between sections: $W$ (count in §8, work from §10.3); $H$ (Hamiltonian, Shannon, Boltzmann, Hessian in §12.4, max-entropy function in §12.3); $D$ (divergence, data in §12.4, dissipation in §12.7); $I$ (Fisher information in §10.2, mutual information in §10.3, adjacent subsections); $m$ (mass, curvature bound in §10.2, spin mean in §12.9); $\gamma$ (drag, tempering exponent in §12.8); $A$ (log-partition in §12.1, observable in §12.5). The two most worth changing are $m$ in the curvature bound and $D$ for data at l. 297, where it stands near the divergence.

### Questions for the correctness reader (companion)

- **QC1** (l. 213–215). $T\,I_{\text{irrel}}$ at one temperature and $T\,I_{\text{mem}} - T'\,I_{\text{rel}}$ in general. The second can be negative for a working engine. Is "heat dissipated" the right name for it, and is the minimization then of net dissipation or of something else? The essay says "Minimizing the engine's dissipation".
- **QC2** (l. 107). "two objections to Boltzmann turned on that": Loschmidt's does, but does Zermelo's recurrence objection turn on the choice between the two assumptions?
- **QC3** (l. 186). "The log-Sobolev condition is the Polyak–Łojasiewicz condition of the essay, one level up": the essay does not state that condition unless E18 is taken.

## Tally

Essay: 4 structural findings; 29 confident sentence-level findings (E1–E29); 6 tics; 2 voice findings; 9 matters of taste; 5 questions; 17 terms flagged in the table (15 never explained, 2 explained late), all covered by E-items.

Companion: 25 confident findings (C1–C25); 2 heading proposals and 2 smaller items in §12; 6 matters of taste; 3 questions.
