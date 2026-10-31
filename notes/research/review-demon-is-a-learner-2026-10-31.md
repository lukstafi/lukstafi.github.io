# Review: *The Demon Is a Learner* (draft of 31 Oct 2026)

Scope: `notes/the-demon-is-a-learner.md`, checked against `citecheck-essayB-2026-10-31.md`, `citecheck-qualitative-2026-10-31.md`, the outline (B1/B2, E), *The Standard of Motion* and its companion §4, and the three cross-linked essays. Every DOI was resolved through the Crossref API, every arXiv ID through the arXiv API, and the Wolfram and Information Distance texts were fetched and searched.

Overall: the physics and mathematics are in good shape. The overdamping direction is correct. Most corrections from the citecheck reports were folded in correctly: Rovelli's quadratic drag, the SGD/Gibbs caveat, Kovachki–Stuart, Nesterov's 3/t, the antisymmetric information-distance cost, Kolchinsky–Wolpert ℓ(p) − K(output), the K(f) term, Ω at β = 0, Goldt–Seifert's caveat about the weights, the softened Boyd–Mandal–Crutchfield claim, and the Bennett 1973/1982 split. All links resolve to the right papers. The findings below are ranked most severe first.

---

## A. Physics and mathematics

**A1. "A first-order law is always the shadow of a system coupled to a medium" is false as stated.** (§What forgetting costs, para 1)
- *Problem.* A first-order law need not contract volume, and need not involve a medium. The standard counterexample is a charged particle in a strong magnetic field. The massless (guiding-centre) limit of m ẍ = F + q ẋ × B gives the drift ẋ = F × B/(qB²). That law is first-order, it contains no medium, and it is Hamiltonian: in 2D, x and y are conjugate, so it preserves area. The argument of the paragraph only needs volume contraction.
- *Fix.* "A law that contracts volume is always the shadow of a system coupled to a medium, and the medium takes up the volume the system loses." Alternatively: "A first-order law like this one, velocity along the force, …".

**A2. The Nesterov exception contradicts Kovachki–Stuart as cited.** (§Aristotle was right, para 4: "The exception is Nesterov's accelerated method, whose continuous limit has friction 3/t")
- *Problem.* The citecheck (item 17) says that Kovachki–Stuart's fixed-momentum result covers heavy ball *and* Nesterov at fixed β. The 3/t limit belongs to Nesterov's original schedule, where β_k = (k−1)/(k+2) → 1. "Nesterov momentum" as used in deep learning has fixed β, so it falls under the rule, not the exception.
- *Fix.* "The exception is Nesterov's accelerated method in its original form, whose momentum coefficient rises toward 1: its continuous limit has friction 3/t that fades over time."

**A3. The threshold of 1/4 is not where the first-order law becomes accurate.** (§Aristotle was right, para 2)
- *Problem.* The direction is correct. Overdamped means γ² > 4mk, i.e. mk/γ² < 1/4. In the companion's units (m = k = 1, γ = ε) this is ε > 2, which matches its "focus while ε < 2, a node beyond." Confirmed. But at the threshold itself the slow rate is −2k/γ, not the first-order law's −k/γ: a factor of 2. The paragraph puts "the small parameter is mk/γ²" next to "overdamped once mk/γ² falls below 1/4", so readers may take 1/4 as the point where Tikhonov's reduction holds.
- *Fix.* Add a clause: "…once mk/γ² falls below 1/4, and the first-order law becomes accurate as it goes well below that."

**A4. "Near every minimum the flow squeezes volume."** (§What forgetting costs, para 1)
- *Problem.* Near a minimum the divergence is −tr Hess L ≤ 0, and it can be zero where the loss is flat in every direction. Neural-network minima are highly degenerate, though the trace is positive whenever any eigenvalue is.
- *Fix.* "Near every minimum where the loss curves upward at all, the flow squeezes volume." The earlier "on balance over directions" clause is correct as it stands.

**A5. The Kolchinsky–Wolpert irreducible cost is not necessarily heat.** (§What forgetting costs, para 7: "The cost that no realization escapes is K(input | output)")
- *Problem.* Per citecheck item 8, a computable realisation can pay K(x|y) in heat, in the complexity of the input–output map, or in the complexity of its heat function. In a paragraph about heat, readers will read "cost" as heat.
- *Fix.* "…is K(input | output), what the computation forgets about where it started, paid in heat or in the complexity of the machine."

**A6. The π example: "a million of them … pays for a million bits."** (§What forgetting costs, para 6)
- *Problem.* The paper (arXiv 1006.3520, §8, checked in the PDF) says "the digits of π" and "a full n bits", with no million. A million *decimal* digits carry about 3.3 million bits.
- *Fix.* "erases a million binary digits of π", or "n digits … pays for n digits' worth of bits".

**A7. Narrowing behaviour is conflated with physical entropy export.** (§What forgetting costs, last para: "Landauer's principle counts the physical side of narrowing: a system that comes to occupy fewer states has exported the entropy of the states it left.")
- *Problem.* *Who Teaches the Weights?* is about the model's *output distribution* narrowing. That is a property of a fixed weight vector, not a smaller occupied region of physical state space. A digital training run pays Landauer's cost for overwriting weight bits, whether or not behaviour narrows. The analogy holds for the cloud of possible weights (para 1), not for the output distribution.
- *Fix.* Make the step explicit, e.g. "Landauer's principle counts the physical side: a learner whose possible weights shrink to fewer states has exported the entropy of the states it left." Or mark it as an analogy: "a physical counterpart".

**A8. "Statistical mechanics assigns entropy to ensembles … A single configuration … has no entropy in this sense."** (§The entropy of one state, para 1)
- *Problem.* Boltzmann's entropy, log W of the macrostate, is assigned to a single microstate, through a choice of coarse-graining. Gács's paper is titled "The Boltzmann entropy and randomness tests" for this reason. "In this sense" saves the sentence, but a physicist will think of Boltzmann at once, and the essay's later coarse-graining point would read better with him named.
- *Fix.* "Boltzmann's entropy belongs to a single state only through a chosen macrostate. Kolmogorov complexity gives it one without that choice."

**A9. Zurek's sum and MDL: "are the same quantity."** (§The entropy of one state, para 3)
- *Problem.* The *form* matches: a code for the record plus a code for the rest given the record. But in MDL the data is known and the model is chosen to minimise the sum. In Zurek's sum the record is what is known and the state is unknown, and nothing is minimised. MDL is also the principle of minimising the sum, not the sum itself. This is the author's synthesis, which is fine, but "the same quantity" is stronger than the sources.
- *Fix.* "…make a two-part code, the shape of the minimum description length principle … The demon's thermodynamic account and a learner's model-selection account have the same form."

**A10. The demon of choice: "that record costs what the luck gained."** (§The entropy of one state, para 2)
- *Problem.* Zurek 1998 (citecheck item 4): "on average that record costs at least what the lucky runs gain".
- *Fix.* "…and on average that record costs at least what the luck gained."

**A11. "Learners live in the generic regime."** (§Aristotle was right, para 3)
- *Problem.* Gradient flows are robust: Morse–Smale flows are structurally stable, an open condition. They are not generic among all vector fields. Exact gradients are a thin subclass, and in dimension 3 and above structural stability is not dense. Essay A's "a generic gradient flow is structurally stable" is about genericity *within* gradient flows.
- *Fix.* "Learners live in the robust regime."

**A12. "deterministic reversible dynamics cannot raise a state's algorithmic entropy by more than a logarithm."** (§The entropy of one state, para 4)
- *Problem.* The displayed bound has a K(f) term, and the gloss drops it. The upper bound also does not need reversibility; reversibility (bijectivity) is what bounds the *decrease*.
- *Fix.* "…by more than the law's own complexity plus a logarithm." Optionally add: "and, if the law is reversible, cannot lower it by more either", which is what makes the "Liouville" label apt.

**A13. "Aristotle's law holds exactly" with viscous drag.** (§Aristotle was right, para 2)
- *Problem.* It holds exactly only at terminal velocity, which the next sentences make clear. A smaller point: Heller's F = m·v maps to F = γv, so Heller's "m" plays the role of the drag γ, not of Newton's mass m in the next equation. A reader comparing the two formulas may stumble.
- *Fix.* "…and Aristotle's law holds exactly at terminal velocity, with the drag coefficient in the role of Heller's m."

**A14. Noise called "uniform".** (§Aristotle was right, para 4: "as it would if the noise were uniform"; para 5: "an overdamped particle with uniform noise")
- *Problem.* "Uniform" can be misread as a uniform distribution. The condition is isotropic, position-independent noise.
- *Fix.* "isotropic and constant" in both places. "SGD does not settle" should also read "SGD generally does not settle".

Checked and correct:
- Tikhonov's pair and slow manifold, and m/γ as a time.
- Divergence −tr ∇²L.
- The Landauer/Bennett chain, including heat only with a bath.
- The information-distance formula, which matches citecheck item 5 verbatim.
- The E_P K inequality (G&V Thm 10).
- Zurek's S = H(state|d) + K(d), and the averaging claim apart from A10.
- K(x_t) ≤ K(x_0) + K(f) + K(t) + O(1).
- Baez–Stay: Ω at β = 0.
- The LMSR C(q), which matches the bookmaker essay. The worst-case loss b ln n equals b × ln n, the range of b·(negative entropy): temperature times maximum entropy.
- Still et al.: β⟨W_diss⟩ ≥ I_mem − I_pred.
- Goldt–Seifert.
- Bits-back: KL(Q‖P) + expected misfit, with −ELBO having the right sign.
- The Li–Tai–E SDE, including √(η/B).
- Kovachki–Stuart's 1/(1−β).
- JKO's ∫Ψρ + T∫ρ log ρ.
- Łojasiewicz and Polyak–Łojasiewicz.

## B. Quotes and attribution

**B1. Wolfram's hedge is dropped.** (§What a bounded observer can compress: he writes that "all three of general relativity … are actually derivable, and from the same ultimate foundation…")
- *Problem.* Fetched from the source page, the sentence reads: "And the remarkable thing is that it now seems as if all three of general relativity, quantum mechanics and statistical mechanics are actually derivable, and from the same ultimate foundation: the interplay between computational irreducibility and the computational boundedness of observers like us." The quoted words are exact, but starting the quote after "it now seems as if" turns a hedged claim into a flat one.
- *Fix.* "he writes that 'it now seems as if all three of …'". Alternatively, keep the cut and add "he suggests that".

**B2. Bennett 2003 does not answer the objections still argued.** (§What forgetting costs, para 3: "still argued, by John Norton among others; Bennett's 2003 notes answer the main objections.")
- *Problem.* Bennett's abstract says "Here I attempt to refute some of the arguments against Landauer's principle." Norton's main critiques ("Eaters of the lotus", 2005; "Waiting for Landauer", 2011) postdate Bennett's notes.
- *Fix.* "…is still argued, by John Norton among others. Bennett's 2003 notes answer the earlier objections." That also fixes the chained semicolon (E3).

**B3. Poincaré's motive.** (§What a bounded observer can compress, para 1: "founded the qualitative theory of differential equations because the three-body problem has no solution in closed form")
- *Problem.* The founding memoir, "Mémoire sur les courbes définies par une équation différentielle", came out in 1881–86. That is before Poincaré's three-body prize work (1889–90) and before Bruns's and Poincaré's non-integrability results. Celestial mechanics was a motive, but the "because" is folklore.
- *Fix.* "Henri Poincaré founded the qualitative theory of differential equations in the 1880s and turned it on the three-body problem, which has no solution in closed form."

**B4. "Fredkin and Toffoli built reversible logic from idealized colliding billiard balls."**
- *Problem.* The billiard-ball computer is a theoretical model, and "built" suggests hardware.
- *Fix.* "designed".

The other quotes match the reports or source essays verbatim:
- Rovelli, both phrases.
- Bennett 2003, the block quote.
- Bennett et al., "without taking the trouble to understand it" (checked in the PDF).
- Zurek 1989 (APS abstract) and Zurek 1998.
- Ebtekar–Hutter.
- Hinton–van Camp, "bits back".
- *Who Teaches the Weights?*: "Alternatives the model could once produce stop appearing", line 23.

The syntheses ("A first-order law is always the shadow…", "Liouville's theorem in algorithmic form", "The demon is a learner", the thesis paragraph) carry no attribution, which is correct. Boyd–Crutchfield–Gu is credited with max work = max likelihood, which is theirs.

## C. Links

All checked links resolve to the right works.

- **DOIs, via Crossref.** Landauer 10.1147/rd.53.0183, Bennett 1973 10.1147/rd.176.0525, Bennett 1982 10.1007/BF02084158, Bérut 10.1038/nature10872, Fredkin–Toffoli 10.1007/BF01857727, Feynman 10.1007/BF01886518, Zurek 10.1103/PhysRevA.40.4731, JKO 10.1137/S0036141096303359, Hinton–van Camp 10.1145/168304.168306.
- **arXiv IDs, via the arXiv API.** 1511.06251 (Li, Tai, E: "Stochastic modified equations and adaptive stochastic gradient algorithms"), 1503.01243 (Su, Boyd, Candès), 2609.15897 (Blumenthal, Claussen, Eysenbach, Ji, Reddy, Scheibner, Sorkin, Sept 2026: "Bridging Control, Inference, Transport, and Thermodynamics…"), and all the others.
- **JMLR.** The Kovachki–Stuart URL v22/19-466 is "Continuous Time Analysis of Momentum Methods", JMLR 22(17), 2021. 19-466 is the submission ID, and the URL is correct.

**C1. Feynman's date.** The link goes to the 1986 *Foundations of Physics* reprint, but the text says 1985. Write "(1985; [reprinted 1986](…))", or leave it as is and accept the mismatch.

**C2. Missing cross-links.** *Who Teaches the Weights?* and *How Does a Policy Improve?* are named without links, while the bookmaker essay is linked. Add `https://lukstafi.github.io/notes/who-teaches-the-weights.html` and `https://lukstafi.github.io/notes/how-does-a-policy-improve.html`. "The companion page of *The Standard of Motion*" (§Aristotle, para 2) also deserves a link to the companion.

**C3. Li, Tai and E "2017".** arXiv lists no venue. The year rests on ICML 2017 (citecheck, from memory) or the JMLR 2019 version. This is fine, but confirm before publishing.

## D. Claims stronger than sources (minor)

- **D1.** "The most it can gain, in work or in predictions, is set by how well it compresses its environment" (thesis paragraph). This is defensible through log-likelihood as code length (Boyd–Crutchfield–Gu), but it is the author's gloss. It is fine as the author's thesis.
- **D2.** "On time scales longer than about 1/(1−β) steps … the inertia is invisible." "Negligible" is more accurate: Kovachki–Stuart have an O(η) correction at finite step.
- **D3.** "On average, the bits needed to describe a typical state equal the bits of uncertainty in the ensemble." Add "when the distribution itself is simple". The gap is up to K(P).

## E. Style (AGENTS.md)

- **E1. The thesis paragraph is a recap.** "Now the thesis can be stated whole…" restates intro para 3 and the section just finished. Either cut it to the two sentences that add something (the best demon is the max-likelihood model; the cheapest memory keeps only what predicts), or trim the intro's version.
- **E2. Repetition.** "Ebtekar and Hutter's bound says the same from the other side: entropy grows because descriptions are coarse." This repeats the closing sentence of §The entropy of one state almost word for word. Since it is only two sections back, consider "A bounded observer's coarse description is what turns…" alone.
- **E3. Chained semicolon.** "…by John Norton among others; Bennett's 2003 notes answer…" chains two moves. Split it (see B2).
- **E4. Unclear referents.**
  - "Goldt and Seifert brought **the bound** to neural networks." The preceding paragraph (Boyd–Mandal–Crutchfield) states a requirement, not a bound, so "the bound" points back two paragraphs, to Still et al. Write "brought bounds of this kind to neural networks" or "Goldt and Seifert bounded what a neural network learns".
  - "Rolf Landauer turned **this** into a price." "This" is the medium absorbing lost volume. Write "turned the lost volume into a price".
  - "**This** settles Maxwell's demon" comes before the demon is described. Given-before-new suggests opening with the demon ("Maxwell's demon watches molecules…") and ending with the settlement.
- **E5. Term before introduction.** "IBDF/NIBDF" appear in the block quote and are defined after it. That is acceptable for a quote, but a short lead-in before the quote ("…splitting the machine into information-bearing degrees of freedom (IBDF) and the rest (NIBDF)") would follow given-before-new.
- **E6. Undefined term.** "algorithmic temperature" is never defined. "(the parameter multiplying running time set to zero)" or "at infinite temperature in their analogy" suffices.
- **E7. Full name repeated.** "Boris Polyak" appears in full in two consecutive paragraphs. Use "Polyak's heavy-ball method of 1964" the second time.
- **E8. Awkward phrase.** "a free energy in code length" reads oddly. Write "a free energy measured in bits".
- **E9. Ambiguous "it".** "as far as it can compress it" (intro and outline sample). The second "it" is the environment. Write "as far as it can compress that environment".
- **E10. Overlap with essay A.** The Rovelli paragraph repeats A's quote, and the structural-stability sentence repeats A's point. Both are short and save a lookup, so they are acceptable under AGENTS.md. No cut needed. The Liouville sentence ("*The Standard of Motion* reads it as a second freedom") is the one-sentence restatement the outline asked for.
- **E11. log and ln.** C(q) uses "log" and b ln n uses "ln". This matches the bookmaker essay, but "ln" throughout would be cleaner in a physics essay where k ln 2 appears.
