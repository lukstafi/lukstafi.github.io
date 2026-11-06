# Review: *The Demon Is a Learner* and its mathematics page, final pass, 6 Nov 2026

Scope: `notes/the-demon-is-a-learner.md` read whole, `notes/the-demon-is-a-learner-mathematics.md`, and the references from `notes/the-standard-of-motion-mathematics.md`. Effort went to the passages no reviewer has read. "Essay L" and "math L" are line numbers in the Markdown files. Scripts are in the session scratchpad, `py/bath2.py` and `py/broadwell.py`.

Overall: the derivations in §9.8 and in Still's cycle are right, every sign and factor included, and all anchors resolve. One number in §9.8 is wrong. The rest of the findings concern what the essay concludes: where it says the arrow comes from, who pays and when, and what a learner builds. These are places where a later passage takes back an earlier one, or where an analogy is stated at more than the source supports.

Sources, and how far each was reached:
- Full text read: Still 2020 (arXiv 1705.00612v3), Shalizi and Moore, Xu et al. (the parts that matter), Premkumar v3.
- Friston 2019: abstract and keyword search of the 148-page monograph.
- Kiefer 2020: abstract only, from the Crossref record.
- Ford, Kac and Mazur 1965: **not read**. Crossref record plus secondary descriptions; the publisher and the mirror copies refused.
- Bennett 1988: **not read**. Secondary statements of the definition only.
- Sagawa and Ueda 2009, used in finding 4: a secondary summary, and its listing as Still's ref. [4].

---

## A. Findings, most severe first

**1. The kick at recurrence is 74% of the initial speed, not 40%.** (math L157, §9.8)
- *Problem.* The figure comes from a scratch run (`bath.py`: N = 4000, cutoff 60, m = 1, γ = 0.5) that printed the velocity only at T_R − 0.5, T_R and T_R + 0.5. It gave 0.39 at T_R + 0.5, and evidently that sample was taken for the height of the kick (my inference: no other printed value is near 40%). The velocity goes on rising. Rerun with the same parameters: 0.005 at T_R, 0.39 at +0.5, 0.61 at +1, 0.74 at +2, 0.30 at +6.
- The value follows analytically. Γ repeats at T_R with a full spike of area 2γ, which gives v(T_R + u) = 2(γ/m) u e^(−γu/m) v₀. The peak is 2/e ≈ 0.736 at u = m/γ, for any bath with a cutoff well above γ/m. The run gives 0.740. A second echo reaches 0.62.
- "At the recurrence time" is also off: at T_R itself the particle is still at rest. "Within a percent over the times checked" fails at the last time checked in the script: relative errors are 0.26%, 0.006%, 0.5%, 1.6% at t = 1, 2, 4, 8 (2.8% at 12). The checked times are not stated, so the sentence cannot be tested.
- *Fix.* "Simulating a free particle with 4,000 oscillators, its velocity falls as $e^{-\gamma t/m}$, to within 2% down to 2% of its initial speed, and its mean squared velocity approaches $T/m$. The kernel repeats its spike at the recurrence time, and a particle that had come to rest is kicked back up, to $2/e\approx 74\%$ of its initial speed a time $m/\gamma$ later."
- Not needing change: on the midpoint grid the script uses, every cosine equals −1 at T_R and the echo has the sign of the original velocity. On ω_j = jΔ the echo has the opposite sign (−0.63 to −0.75 in my runs). "Realign" covers both.

**2. "Every H-theorem has this shape" does not cover Boltzmann's own, so the essay's "the same theorem" is too strong.** (math §9.7, L133–139; essay L110)
- *Problem.* The theorem needs a linear kernel: D(μP‖πP) ≤ D(μ‖π) with one P applied to both. Boltzmann's collision term is quadratic in f. The rate at which a ball leaves velocity v depends on f itself, because the partner is drawn from f. So f ↦ f′ is not of the form μP, and the kernel for one ball is not fixed in advance. It "knows the distribution it acts on", which is what §9.7 says a kernel in this theorem does not do.
- This is more than a technicality. The contraction property fails: in a homogeneous four-velocity Broadwell gas, a solution falls monotonically toward its own equilibrium, yet two solutions can move apart (D(f_t‖g_t) rose from 1.698 to 1.715 over t = 0.05). For a fixed kernel this cannot happen. Boltzmann's theorem needs the symmetrization of §9.3, and §9.7 does not replace it.
- The form does apply one level up. The random-pair run of Figure 2 is a fixed Markov kernel on N-ball states, as in Kac's master equation, and the quantity that cannot rise is the N-ball divergence. One-ball H follows only with propagation of chaos.
- *Fix (math).* After the first paragraph of §9.7: "Boltzmann's equation is not itself of this form, since the kernel for one ball depends on $f$. The form applies one level up: the random-pair run of Figure 2 is a fixed kernel on the states of all $N$ balls." Consider retitling the section "An H-theorem for any Markov chain". The essay links to its anchor, so update the link too.
- *Fix (essay).* "by [a theorem of the same form]" in place of "by the same theorem in a general form". See finding 3 for the rest of that sentence.

**3. "Any process driven by such noise drifts toward equilibrium" contradicts the essay's own account of SGD.** (essay L110 against L40)
- *Problem.* L40 says SGD, whose noise is fresh at each step (math §9.7), settles into "a nonequilibrium state" and that its trajectories can circulate. The theorem gives drift toward the stationary distribution of the kernel. That is equilibrium only under detailed balance. It also needs a stationary distribution to exist and the kernel not to be driven.
- *Fix.* "Any process driven by such noise, with its law held fixed, drifts toward the stationary distribution of that law."

**4. Who pays, and when, shifts between passages without notice.** (essay L23, L78, L118, L120; math L204, L206)
- *Problem, first part.* The essay says the demon pays "when it clears its memory" and that measurement can be free (L78, Bennett). Still's cycle pays at writing and never clears: "The memory is not reset to a specific state", and −Q_M ≥ kT I[M,X] is dissipated at the write. That bound rests on her assumption that the memory's marginal is the same before and after (ΔH_M = −I[M,X]). The memory starts in some distribution, not a blank state, so writing overwrites old contents. Bennett's and Still's accounts are compatible because only the sum of the two costs is bounded (Sagawa and Ueda 2009, her ref. [4]). Neither page says so, and step 1 of the companion reads as a flat contradiction of the essay's L78.
- "Susanne Still joined the last three results in one engine" (math L204) names Landauer's erasure as one of the three, but the cycle contains no erasure.
- *Problem, second part.* The essay's opening prices forgetting: "forgetting one costs at least kT ln 2". L118 then says "An efficient memory keeps what predicts and forgets the rest", where forgetting is what saves heat. L120 charges for what is kept, T per nat written, and nothing for what is not stored. The subtitle's "pay for what they discard" is true of a bit already held, and false of a bit never taken up. In the information bottleneck the discarded bits are never stored, and that is why they cost nothing.
- *Fix (essay L118).* "An efficient memory keeps what predicts and does not take up the rest."
- *Fix (essay, after L121).* "Still's memory is never cleared. It is overwritten, so her bill falls at writing, where Bennett's falls at erasure. A bit is paid for once, and only the total is fixed."
- *Fix (math step 1).* "Write the memory at temperature $T$. The memory's marginal distribution stays the same and it is never reset, so writing overwrites old contents. The joint entropy of memory and system falls by $I_{\text{mem}}$, and at least $T\,I_{\text{mem}}$ of heat is dissipated. Bennett's account puts the same cost at erasure, and only the sum of measurement and erasure is bounded (T. Sagawa and M. Ueda, Phys. Rev. Lett. 102 (2009) 250602)."
- *Fix (math L204).* "joined Szilard's engine, the cost of memory and Carnot's bound in one engine".

**5. The essay says a learner builds the correlations Boltzmann's assumption excludes, and later says it builds none of them.** (essay L110 against L141; math §12.10, L377)
- *Problem.* L110: a learner is a device "for building the correlations with its environment that Boltzmann's assumption says are absent." Those are correlations between the particular balls of a particular run, the kind that make the reversed gas run backward. L141 and §12.10 say the opposite of a diffusion model: it "leaves each particular history alone", "looks at nothing", and holds "statistical knowledge of a population". What the paragraph needs is dependence on the density, and that is knowledge of a distribution. A demon's record is correlated with one molecule, which is the kind of correlation the sentence names, and so is Still's memory. A score network's weights are not. The sentence merges the two kinds.
- *Fix.* "No bath has such knowledge. A learner is a device for acquiring it. A demon goes one step further and builds the thing Boltzmann's assumption says is absent, a correlation with the particular state in front of it."

**6. The floor on what a trained network stores drops "perfectly", and the source says the difference matters.** (essay L141)
- *Problem.* The essay: "this total is the floor on what a trained network must store". Premkumar's claim is about perfect training: "a perfectly trained network stores at least the same amount of information". He then limits it: the quantity "is not always the true measure of the information stored in the network. This is often beneficial; if the neural network stored Stot perfectly for a relatively sparse dataset, such as images, the diffusion model would learn to reconstruct a series of Dirac delta functions." So a trained network can store less, and it is better that it does. The divergence is also finite only for a data density with finite divergence from the noise, which an empirical dataset is not. The companion (L379) keeps "perfectly" and is right.
- *Fix.* "…argues that this total is the floor on what a perfectly trained network must store. A real network stores less and generalizes."
- Smaller: L379 says Premkumar calls the total "the neural entropy". His Ŝ_NN := S_tot is the *ideal* neural entropy, and S_NN of Eq. 18 is a separate estimate. Write "the ideal neural entropy".

**7. "Fixed in advance" is not the property that gives the arrow.** (math §9.7, L139; essay L110; math §9.4, §9.8)
- *Problem, first part.* §9.7 says "a kernel fixed in advance says that the randomness applied at step t knows nothing of the distribution it acts on". A trained diffusion model is a counterexample to the implication. Its reverse kernels are fixed before sampling starts, the weights are frozen, and they are tuned to ρ_t. D(ρ‖π) rises along them. What fails there is the second clause, "leaves π alone". The operative pair of conditions is: chosen without reference to μ_t, and π invariant.
- *Problem, second part.* The word "advance" presupposes a direction of time, and on the face of it §9.4 ("the arrow lies in the initial conditions") and §9.7 ("it came in with a kernel") give two locations. §9.8 is the bridge: the kernel fixed in advance *is* the bath's initial state, through ξ as a fixed function of initial conditions. It says so only in one sentence, three subsections later, and the essay never says it. Nothing is contradictory, but §9.7 reads as if it were.
- *Fix (math).* "It came in with a kernel chosen without reference to $\mu_t$ that leaves $\pi$ alone. Such a kernel says that the randomness applied at step $t$ knows nothing of the distribution it acts on, and §9.8 shows where it comes from: a bath whose initial state was set before the system arrived, so this arrow is the arrow of §9.4 again."
- *Fix (essay L110).* "it is set before the system arrives and knows nothing of the distribution it acts on." That also keeps the essay's arrow in the same place as its L62, "prepared by ordinary means".

**8. The Boltzmann-machine passage reverses Still's reading, and "stalls" does not track the gap.** (essay L123; math L221)
- *Problem, first part.* Still is correctly cited for the number. Her text: input patterns drive the network "out of its parameter dependent equilibrium state, qθ, to a non-equilibrium state, p. The associated additional free energy, Fadd = kT D[p‖qθ] … has to be dissipated during the relaxation process involved in predicting labels on new patterns." Learning minimizes "a lower bound on the dissipation encountered during prediction." For her the gap is waste at prediction time. The essay makes it the driving difference of an engine, as T′ − T is, where a larger gap would be better. "As Still notes" sits next to "learning runs that gap down", and the engine reading can be taken for hers. It is the essay's own.
- *Problem, second part.* The gap and the stall are different things. The strokes agree when the moments match, E_p[t] = E_q[t]. In any model that cannot represent the data, that happens at the optimum with D(p‖q_θ) > 0. So the engine stalls with free energy still in hand, which has no counterpart at T′ = T. "When the model matches the data" is true as an implication, and the reader takes it as "gap closed iff stalled".
- *Problem, third part.* The companion says the difference of statistics "drives the strokes". The strokes run regardless. The difference drives the weights.
- *Problem, fourth part.* "A free energy of T times the divergence" is literal only for a physical network at a physical T. A few paragraphs later the essay warns that the shared name is a trap. The stated reason training has no counterpart (a loss is not conserved) also does not apply to that physical network, for which Still does think the efficiency argument applies.
- *Fix (essay).* "The data hold a physical network away from its own equilibrium by a free energy of $T$ times the divergence between them. Still reads that as heat the network must shed when it predicts, and learning as lowering it. Read instead as an engine, which is our reading and not hers, the gap between data and model does the work of the gap between $T$ and $T'$: when the two strokes agree the engine stalls, as Carnot's does when $T' = T$, though a model too small for the data stalls with a gap left."
- *Fix (math).* "The difference of statistics then plays the part of $T' - T$: it moves the weights, and when it vanishes the engine stalls, which can happen with $D(p\|q_\theta) > 0$ if the family cannot represent $p$."

**9. "One ledger" claims more than the results listed under it, and the same section withdraws it.** (essay L112 against L123, L131, L143)
- *Problem.* "Several results show that these are one ledger." Of what follows, Still's bounds and Goldt–Seifert concern physical systems with a bath. Boyd et al. identify two objectives. Bits back and the free energy principle share a formula: L131 says "nothing in it is paid". L123 says training has no literal counterpart. L143 says the thermodynamic ledger "does not see" what an observer can use. So the sentence is true of a physical learner in a bath and not of learning in general.
- *Fix.* "For a learner that is a physical system in a bath, several results put the two on one ledger. Where it is not, they share only a formula."

**10. Logical depth is not the counterpart of the encryption example.** (essay L143)
- *Problem.* Depth is the running time of a nearly shortest program. Take a ciphertext of a simple message under a short key. Its near-shortest program is key, message and cipher, and it runs fast, so the ciphertext is shallow. What stands between the observer and the plans is the time to *find* that program, not the time to run it. Depth therefore gives the wrong answer on the paragraph's own example. "A string can be short to state and slow to unpack" is true, and describes a different case. Definition checked in secondary sources only.
- *Fix.* "Bennett's logical depth (1988) is a cousin, the time a nearly shortest program takes to run: a string can be short to state and slow to unpack. A ciphertext shows the difference. Its short program runs fast, and what the observer lacks is the program."

**11. A dangling reference survives on the previous page.** (`the-standard-of-motion-mathematics.md` L111)
- *Problem.* "the overdamped limit of §7.1 is the passage from one to the other": §7 no longer has subsections. L15 also still says "from §7, for the sequel", which reads as if the sequel were unpublished, though L272 and L140 are correct.
- *Fix.* L111: "the [overdamped limit](…#the-overdamped-limit) of §7 on the next page". L15: "from §7."

**12. The factor in the Ohmic limit is right but unstated, and a reader gets 2γ.** (math L153–154, §9.8)
- *Problem.* Substituting Γ → 2γδ(t − s) into ∫₀ᵗ gives γẋ only because the delta sits at the endpoint and contributes half its weight. The page moves from 2γδ to −γẋ with no comment, and two lines later uses the same 2γδ at full weight in the noise. Both are correct, and they are what makes the result agree with the Einstein relation.
- *Fix.* After "dephase at once everywhere else": "The friction integral ends at $s = t$, so it takes half of the delta function's weight and gives $\gamma\dot x$. The noise correlation has $t - s$ in the interior and takes all of it."

**13. Carnot did not state 1 − T/T′.** (essay L120)
- *Problem.* "Sadi Carnot showed … at most a fraction $1 - T/T'$". Carnot (1824) showed that the limit depends only on the two temperatures, in caloric terms and with no absolute scale. The formula is due to Thomson and Clausius in the 1850s. Secondary sources, which mostly agree on this.
- *Fix.* "Sadi Carnot showed that the fraction of the heat an engine can turn into work depends only on the two temperatures, and the absolute scale of Thomson and Clausius gave it the form $1 - T/T'$."

**14. Attribution of the bath model.** (math L143, §9.8)
- *Problem.* Ford, Kac and Mazur's system is reported by secondary sources as a chain of coupled harmonic oscillators, with everything quadratic. The page's Hamiltonian has an arbitrary V(x). The exact nonlinear equation is usually credited to Zwanzig, "Nonlinear generalized Langevin equations", J. Stat. Phys. 9 (1973) 215–220, DOI 10.1007/BF01008729 (Crossref confirmed). Ariel and Vanden-Eijnden name the model after both, as "first introduced by Ford, Kac and Mazur, and later by Zwanzig". I could not read the 1965 paper, so this is a strong presumption and not a verified discrepancy.
- *Fix.* Add after the FKM citation: "for a wholly harmonic system, and R. Zwanzig, [J. Stat. Phys. 9 (1973) 215–220](https://doi.org/10.1007/BF01008729), for a particle in any potential". Check against the 1965 text if a copy can be had.

**15. The essay's symbols and a loose "this bound" for Still 2020.** (essay L120–122)
- *Problem.* The essay writes I_pred in the efficiency, and the companion writes I_rel for the same formula. Still's symbol is I_rel, "relevant, or predictive, information", and it differs from the I_pred of the 2012 bound four lines above (a signal's next value there, Y here). The reader following the link finds a different letter. "Built this bound into a full engine cycle": the 2020 paper does not cite the 2012 paper, and it has a different setup, measurement and feedback instead of a driven system. The shape is the same. "Minimizing the engine's dissipation" should be its lower bound, as in her abstract.
- *Fix.* Use $I_{\text{rel}}$ in the essay, glossed once: "the part of the memory relevant to work extraction". "Still later reached a bound of the same shape for a full engine cycle." "Minimizing the bound on the engine's dissipation".

**16. The opening promises what the closing withdraws.** (essay L23 against L143, L145)
- *Problem.* L23: a learner extracts predictions "as far as it can compress that environment". L143: "Compression is not enough, though." The closing sentence has the right form: "can compress and still use". The opening should not need correcting by the end.
- *Fix.* "as far as it can compress that environment into a form it can use".

**17. The reversed gas in the Shalizi–Moore paragraph is the essay's own step.** (essay L139)
- *Problem.* The citation is accurate: "predict their own future" is verbatim, and the two halves match the abstract. Boltzmann's assumption and the reversed gas are not in the paper, which mentions only a "Boltzmannian level" of description. The next sentence follows the citation without a break. Causal states are also defined over an ensemble of histories. A reversed gas has vanishing measure there, so it does not make the one-ball histogram fail as a macrostate for the gases that ensemble contains. It shows what the state assumes about the ensemble, and that is the point the essay wants.
- *Fix.* "In these terms, Boltzmann's assumption is what makes the one-ball distribution such a state for a gas prepared by ordinary means. The reversed gas lies outside that ensemble: the same histogram, with the opposite future." The Aristotle sentence is sound. Their Appendix B gives the matching example: position alone is non-Markovian for a moving particle, and position with velocity is Markovian.

**18. Smaller points of statement.**
- Essay L143: "An encrypted message has high mutual information with the plans it hides." This follows Xu et al., and it holds for a key short relative to the message. A one-time pad gives exactly zero. Write "A message encrypted under a short key".
- Essay L62: "The entropy of the full state of all the balls". L90 says a single configuration has no entropy in this sense. Write "the entropy of the joint distribution of all the balls".
- Math L379: "a physical run of the reversal would lower the system's entropy". The rise is in free energy. Entropy falls only if the data are narrower than π. The earlier review's fix did not contain this clause. Write "would raise the system's free energy by $T\,D(\rho_{\text{data}}\|\pi)$ and cost at least that much work".
- Essay L141: "two more decimal places in every velocity". Positions need the same precision. Figure 2 keeps them exact, as the companion says. Write "in every position and velocity".
- Essay L131: "It reads any system…". A fair report of the monograph's stated ambition ("a theory of every 'thing'"), though its result is for weakly mixing systems at nonequilibrium steady state, and the generality is disputed (from memory: Biehl, Pollock and Kiefer 2021; Aguilera et al. 2022). Write "It claims to read" if the essay wants distance.
- Essay L143: "Decryption can run reversibly, at no cost in heat": in the slow limit. "In principle" would suffice.

**19. Lost paragraph break.** (essay L122–123)
- L123 follows L122 without a blank line, and L122 ends in a trailing space. The built HTML has "trade-off parameter. Training has no literal counterpart" inside one `<p>`. Your brief calls these two paragraphs, so a blank line is missing.

---

## B. Earlier review's fixes

All applied, none undone: A1–A21, B1 (`twin` run is in the script, L204), B2, C1–C5, D1–D10, D12 (κ for the diffusion coefficient, C for total correlation, ν for number density, φ for the Kac fraction, G for the perturbation in §12.5). The only departure is the added clause listed in finding 18. The old review's E items were style and I did not recheck them.

## C. Checked and correct

**§9.8.**
- Equations of motion from the Hamiltonian, with the counterterm leaving V unrenormalized.
- The solution for q_j, the integration by parts, the boundary term at s = 0 producing the shifted Q_j.
- Γ(t) with its coefficient, ξ(t), Gibbs variances T/m_jω_j² and m_jT, ⟨ξξ⟩ = TΓ.
- Density 2γ/π giving ∫₀^∞ Γ = γ, Γ → 2γδ, noise 2γTδ, overdamped diffusion 2T/γ (agrees with §10.2).
- ⟨v²⟩/T = 1 − e^(−2γt/m) to five digits in the exact mode solution.
- Recurrence at 2π/Δ, 1.8×10⁻⁵ before it (particle at rest).
- Zwanzig 1960 and Mori 1965 records.

**Still's cycle (against the paper).**
- All four steps; the definitions of X, Y, I_mem, I_rel, I_irrel.
- Eqs. 5–8 and 11; the condition I_rel/I_mem ≥ T/T′; dissipation ≥ T I_irrel at one temperature.
- Eq. 9 with α = T′/T, and the reference to the information bottleneck.
- "Carnot's limit only if everything predicts". Her ΔH and sign conventions match the page.
- "As Still notes": the number and the sentence exist.

**Boltzmann-machine gradient.** ∇D(p‖q_θ) = E_q[t] − E_p[t]; fully visible case; the 1985 DOI in the essay resolves (it differs from the citecheck's but is the same paper).

**Sources.**
- Shalizi and Moore: observer, dynamics, refinement, optimal predictors; verbatim quotation.
- Xu et al.: "high mutual information", computation creating usable information, predictors under constraints. *Who Teaches the Weights?* L106 uses the notion as stated.
- Kiefer: "directly encodes" (abstract).
- Friston: the description of the claim, and that variational free energy bounds surprise.
- Premkumar: S_tot ≤ D(p_d‖p_eq) by his Eq. 15, so "at most the divergence, however long it runs" and "does not grow with the time reversed" both hold. His "faster diffusion needs more information" concerns the speed of a process to a fixed endpoint, not how far back it reaches, so there is no conflict.
- Bennett's depth definition (secondary).
- Still 2020 DOI; Ford–Kac–Mazur record.

**Gas of balls.**
- Mirror theorem, Loschmidt, the correlation account, the total-correlation sentence.
- All figure numbers against the companion: 2,000, 4, 6 decimals, a hundred, two and a half, "fell back to where it began".
- Two decimals per collision agrees with a factor of a hundred.

**Consistency, essay and companion.** Ten tools (eleven subsections minus the table; ten rows); dates; Einstein relation; T_eff; Zurek; Kolchinsky–Wolpert; BGLVZ; bookmaker b per nat.

**Links.**
- All six essay anchors into the companion, and #the-bookmaker-is-a-learner, against the built HTML.
- All companion anchors outward.
- #the-overdamped-limit and #volume-contraction from the previous page.
- Every anchor into the previous page from any note.
- All 23 distinct § targets inside the companion exist and say what is claimed. Figures 2–4 follow Figure 1 on the previous page.
- *The Standard of Motion* L75 supports "a second freedom".
