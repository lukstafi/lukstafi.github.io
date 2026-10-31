# Citation check: *The Demon Is a Learner* (essay B), 31 Oct 2026

Every citation below was first given from memory by an AI. Each was checked against the primary source where one was reachable: arXiv full text, publisher abstract pages, or the author's own PDF. "Checked in full text" means the passage was read in the paper itself. Bibliographic data I could not confirm at the source is marked *(unconfirmed)*.

## Summary of verdicts

| # | Citation | Verdict | One-line note |
|---|---|---|---|
| 1 | Landauer 1961; Liouville framing | VERIFIED | Bennett 2003 gives the conservation-of-fine-grained-entropy (Liouville) derivation explicitly |
| 2 | Bennett 1973; Bennett 1982 | CORRECTED | The 1973 paper is about reversible Turing machines only. The point that the demon pays at erasure is from 1982 |
| 3 | Bérut et al. 2012 | VERIFIED | The bound is reached only in the limit of slow erasure |
| 4 | Zurek 1989, physical entropy | VERIFIED | S = H + K, but the K is of the demon's *record*. The "no win" result holds only on average |
| 5 | Bennett–Gács–Li–Vitányi–Zurek 1998 | CORRECTED | max{K(x\|y),K(y\|x)} is *not* the thermodynamic cost. The cost is K(x)−K(y) (antisymmetric). The sum K(x\|y)+K(y\|x) counts irreversible bit operations |
| 6 | Gács 1994 | VERIFIED | PhysComp '94, pp. 209–216 |
| 7 | Baez & Stay 2012; Tadaki 2002 | CORRECTED | Baez–Stay: verified (energy = log runtime). Tadaki 2002 has Ω^D with D a *compression rate*. The "temperature" reading comes from Calude & Stay 2006 and Tadaki 2008 |
| 8 | Kolchinsky & Wolpert 2020 | CORRECTED | The *minimal* heat to produce x is **O(1)**, not ~K(x). Via the coding theorem, the heat on input p is ℓ(p) − K(output) |
| 9 | E_P[K] = H(P) + O(K(P)) | VERIFIED (statement); section number unconfirmed | Exact form: 0 ≤ Σ P K − H(P) ≤ K(P) + O(1). Cite Grünwald & Vitányi 2008, Thm 10 |
| 10 | K(x_t) ≤ K(x_0) + K(t) + O(1) | CORRECTED (source) | The bound is true and elementary. It needs a K(dynamics) term. Best citation: Ebtekar & Hutter 2025, Cor. 3–4. Also Aaronson 2011 (blog) |
| 11 | Still et al. 2012 | VERIFIED | — |
| 12 | Goldt & Seifert 2017 | VERIFIED (caveat) | I(σ_T:σ) ≤ ΔS(ω) + ΔQ is about the weights' *own* entropy production, not the hardware's dissipation |
| 13 | Boyd, Mandal & Crutchfield 2017 | VERIFIED (soften) | J. Stat. Phys. 167:1555. "Only to the extent their structure matches" overstates it. Add Boyd–Crutchfield–Gu 2022 (max work = max likelihood) |
| 14 | Hinton & van Camp 1993 | VERIFIED | §5.2 is titled "The 'bits back' argument" and §7 is the free-energy lemma |
| 15 | Fredkin & Toffoli 1982; Feynman 1985/86 | VERIFIED | — |
| 16 | SGD ≈ overdamped Langevin, Gibbs e^{−L/T} | CORRECTED | Gibbs on L only for isotropic, constant noise. Chaudhari & Soatto is **ICLR 2018**. Mandt et al. is an OU/quadratic model. SGLD is a different algorithm |
| 17 | Polyak 1964; Su–Boyd–Candès; Wibisono–Wilson–Jordan | VERIFIED (caveat) | Nesterov's ODE has *vanishing* friction 3/t. Add Kovachki & Stuart 2021: fixed-momentum methods reduce to rescaled gradient flow |
| 18 | Jordan, Kinderlehrer & Otto 1998 | VERIFIED | — |
| 19 | Rovelli 2015 | CORRECTED (wording) | Rovelli uses *quadratic* drag, so v ∝ √(W/ρ). "Strong friction" is not his phrase. Overdamped v ∝ F is the linear-drag (Stokes) case |

---

## 1. Landauer (1961)

**(a)** R. Landauer, "Irreversibility and Heat Generation in the Computing Process," *IBM Journal of Research and Development* 5(3): 183–191 (1961). DOI 10.1147/rd.53.0183.

**(b) VERIFIED.** Landauer argues that a logically irreversible operation, such as resetting a bit of unknown value to a standard state, must dissipate at least kT ln 2 of heat into the environment.

**Liouville framing.** Presenting the principle this way is standard. The cleanest source is C. H. Bennett, "Notes on Landauer's principle, reversible computation, and Maxwell's Demon," *Studies in History and Philosophy of Modern Physics* 34: 501–510 (2003), arXiv:physics/0210005. Checked in full text. Bennett splits the computer into information-bearing and non-information-bearing degrees of freedom. The whole system obeys Hamiltonian or unitary dynamics, but "two or more distinct logical states hav[e] a single logical successor." He continues: "because Hamiltonian/unitary dynamics conserves (fine-grained) entropy, the entropy decrease of the IBDF during a logically irreversible operation must be compensated by an equal or greater entropy increase in the NIBDF and environment. This is Landauer's principle." Bennett also points to the phase-space-volume picture in Fig. 12 of his 1982 review. Parrondo, Horowitz & Sagawa, "Thermodynamics of information," *Nature Physics* 11: 131–139 (2015), DOI 10.1038/nphys3230, is a modern review of the same ground *(bibliographic data from memory; not rechecked)*.

**(c) Caveats.**
- Liouville's theorem yields an *entropy* transfer. It becomes *heat* kT ln 2 only when the environment is a thermal bath at temperature T. Bennett notes that entropy "need not" leave as heat; it can also go out by randomising configurational degrees of freedom.
- The bound applies to erasing a bit whose value is uncertain. A copy known to be identical to another bit can be erased reversibly.
- Earman & Norton, and Norton in later papers, dispute that the principle is independent of the second law. Bennett (2003) answers them. A sentence acknowledging the dispute would be honest; the essay need not argue it.

## 2. Bennett (1973) and Bennett (1982)

**(a)**
- C. H. Bennett, "Logical Reversibility of Computation," *IBM J. Res. Dev.* 17(6): 525–532 (1973). DOI 10.1147/rd.176.0525.
- C. H. Bennett, "The Thermodynamics of Computation — a Review," *International Journal of Theoretical Physics* 21(12): 905–940 (1982). DOI 10.1007/BF02084158.

**(b) CORRECTED (attribution split).**
- **1973** shows that any computation can be done by a logically reversible Turing machine (compute, copy the result, uncompute). It does not discuss Maxwell's demon.
- **1982** is the source for the demon claim: measurement can in principle be done reversibly, and the unavoidable cost comes when the demon's memory is reset (Landauer erasure).
- Bennett, "Demons, Engines and the Second Law," *Scientific American* 257(5): 108–116 (1987) is the popular statement.

**(c)** Write "Bennett (1973) showed computation can be reversible; Bennett (1982) showed the demon pays at erasure, not at measurement." Penrose (1970) anticipated part of the erasure argument; credit him if the essay makes priority claims.

## 3. Bérut et al. (2012)

**(a)** A. Bérut, A. Arakelyan, A. Petrosyan, S. Ciliberto, R. Dillenschneider & E. Lutz, "Experimental verification of Landauer's principle linking information and thermodynamics," *Nature* 483: 187–189 (2012). DOI 10.1038/nature10872.

**(b) VERIFIED.** The experiment used a colloidal bead in a double-well optical trap. The mean dissipated heat approaches kT ln 2 as the erasure cycle gets longer.

**(c)** The bound is *approached* in the quasi-static limit. Fast erasure dissipates more. Later confirmations include Jun, Gavrilov & Bechhoefer, *PRL* 113, 190601 (2014), with a feedback trap, and Hong et al., *Science Advances* (2016), with nanomagnets *(both from memory; not rechecked)*.

## 4. Zurek (1989), "Algorithmic randomness and physical entropy"

**(a)** W. H. Zurek, "Algorithmic randomness and physical entropy," *Physical Review A* 40(8): 4731–4751 (1989). DOI 10.1103/PhysRevA.40.4731. The APS abstract page was checked.

**(b) VERIFIED, with the definition stated precisely.**
- The APS abstract defines physical entropy as "the sum of the missing information (Shannon's entropy) and of the algorithmic information content — algorithmic randomness — present in the available data about the system."
- In Zurek's own later summary (Zurek 1998, "Algorithmic randomness, physical entropy, measurements, and the demon of choice," arXiv:quant-ph/9807007, in *Feynman and Computation*, ed. A. J. G. Hey; checked in full text), the definition is written Z(ρ) = H(ρ) + K(ρ). Here ρ is the demon's record or description of the system's state, H is the Shannon entropy that remains given that record, and K(ρ) is the length of the shortest program that reproduces the record.
- The 1989 paper writes it as S_d = H_d + K_d, for data d *(notation as usually quoted; the 1989 full text was not reachable)*.
- Li & Vitányi present it, via Baez–Stay, as S_A(x) = (k ln 2)(K(x) + H_x).

**Demon claim: accurate, but only on average.**
- Zurek (1998) states that in an ideal measurement on an equilibrium ensemble, "the decrease of ignorance is, on the average, compensated for by the increase of the size of the minimal record," with ΔH ≃ −⟨ΔK⟩. The proof rests on Shannon's noiseless coding theorem.
- The work extracted per cycle is at most k_B T (Z(ρ) − Z(ρ_i)).
- A demon working on an equilibrium system therefore "will never be able to threaten the second law, for the ensemble average of Z is at best conserved, so that ⟨ΔZ⟩ ≤ 0."

**(c) Caveats.**
- "On average" is essential. Individual runs can gain.
- Zurek (1998) handles the "demon of choice", which keeps only its lucky runs. It cannot do so without recording success or failure, and on average that record costs at least what the lucky runs gain.
- The K term is the complexity of the *record*, not of the microstate itself. (In the 1989 abstract, the microstate's own algorithmic randomness is also discussed as a measure of disorder.)
- Companion paper: Zurek, "Thermodynamic cost of computation, algorithmic complexity and the information metric," *Nature* 341: 119–124 (1989) *(volume and pages unconfirmed; some reference lists give 347)*.

## 5. Bennett, Gács, Li, Vitányi & Zurek (1998), "Information distance"

**(a)** C. H. Bennett, P. Gács, M. Li, P. M. B. Vitányi & W. H. Zurek, "Information Distance," *IEEE Transactions on Information Theory* 44(4): 1407–1423 (1998). DOI 10.1109/18.681318. arXiv:1006.3520 (posted 2010). Checked in full text.

**(b) CORRECTED.** The paper defines several distances. Only one of them is the thermodynamic cost.
- **E1(x,y) = max{K(x|y), K(y|x)}.** This is the length of the shortest program that converts x to y *and* y to x, up to a logarithmic term. It is the "optimal" cognitive metric.
- **E2.** The length of the shortest *reversible* program between them. It equals E1 up to a logarithmic term.
- **E3(x,y) = K(x|y) + K(y|x) + O(log …).** This is "the minimal number of irreversible bit operations in an otherwise reversible computation from x to y in which the program is not retained." It counts bits supplied plus bits erased, and E1 ≤ E3 ≤ 2E1.
- **Thermodynamic work (Section 8).** The cost should be *antisymmetric and transitive*, unlike the metrics above. Using Landauer's principle, the authors argue for W(y|x) = K(x) − K(y): "the thermodynamic cost, i.e. the minimal entropy increase in the environment, of a transformation of x into y." Their reasoning is to erase x first, then produce y by randomisation. Equivalently, up to log terms, W′(y|x) = K(x|y) − K(y|x). The paper describes this as "the number of irreversibly erased bits minus the number of irreversibly provided bits." W′ is Zurek's measure.

**(c)** Do not call max{K(x|y), K(y|x)} a thermodynamic cost. Use this wording: "converting x into y requires supplying about K(y|x) bits and erasing about K(x|y) bits. The net dissipation is about kT ln 2 · [K(x|y) − K(y|x)] ≈ kT ln 2 · [K(x) − K(y)]."

The paper also states the demon point the essay needs. A demon that erases a random-looking string such as the digits of π "without taking the trouble to understand it" pays the full n bits. A demon that recognises the redundancy can compress reversibly first and erase "at very little thermodynamic cost." In limited time the demon cannot compress as far, so it generates more entropy. This is a speed–efficiency tradeoff that converges with uncomputable slowness.

## 6. Gács (1994), "The Boltzmann entropy and randomness tests"

**(a)** P. Gács, "The Boltzmann entropy and randomness tests," in *Proceedings of the Workshop on Physics and Computation (PhysComp '94)*, IEEE Computer Society Press, pp. 209–216 (1994). A CWI technical-report version is dated 1993. DOI not confirmed (probably on IEEE Xplore).

**(b) VERIFIED.** Gács defines a coarse-grained algorithmic entropy for individual states in a continuous phase space, built from universal randomness tests. Ebtekar & Hutter (2025; see item 10) summarise it: "Gács' coarse-grained algorithmic entropy leverages universal computation to quantify the information content of any given physical state," without "prior commitment to macrovariables or probabilistic ensembles."

**(c)** Gács's *Lecture notes on descriptional complexity and randomness* (arXiv:2105.04704) give a modern account. Ebtekar & Hutter build their algorithmic second law on Gács's entropy. The essay may cite both.

## 7. Baez & Stay, "Algorithmic thermodynamics"; Tadaki (2002)

**(a)**
- J. C. Baez & M. Stay, "Algorithmic thermodynamics," *Mathematical Structures in Computer Science* 22(5): 771–787 (2012), special issue "Computability of the Physical". arXiv:1010.2067. Checked in full text.
- K. Tadaki, "A generalization of Chaitin's halting probability Ω and halting self-similar sets," *Hokkaido Mathematical Journal* 31(1): 219–253 (2002). arXiv:nlin/0212001.

**(b) Baez–Stay: VERIFIED. Tadaki: CORRECTED.**
- In Baez–Stay the microstates are the halting programs of a universal prefix-free machine. The observables are E = log runtime (the analogue of energy), V = program length (volume) and N = output (number of molecules).
- The Gibbs measure is p ∝ e^{−βE − γV − δN}. In the authors' words: "The partition function reduces to Chaitin's number Ω when β = 0, γ = ln 2 and δ = 0." Ω is therefore the partition function at *infinite* algorithmic temperature (β = 1/T = 0), with γ = ln 2 playing the role of a pressure term.
- They also say "the randomness described by Chaitin and Tadaki then arises as the infinite-temperature limit," and that the analogies "were chosen somewhat arbitrarily."
- Tadaki (2002) defines Ω^D = Σ 2^{−|p|/D}, whose degree of randomness, or compressibility, is exactly D. He relates it to Hausdorff dimension. Calling D a "temperature" comes later: Calude & Stay pointed out the equivalence ("Natural halting probabilities, partial randomness, and zeta functions," *Information and Computation* 204: 1718–1739, 2006 *(from memory)*). Tadaki then built it explicitly in "A statistical mechanical interpretation of algorithmic information theory," arXiv:0801.4194 (2008), with *length* as energy.

**(c)**
- Write "Tadaki (2002) generalised Ω to Ω^D with partial randomness D, which Calude & Stay and Tadaki (2008) read as a temperature."
- Do not mix the two conventions. In Tadaki and Calude–Stay, length is the energy and T = D ≤ 1. In Baez–Stay, log runtime is the energy and Ω sits at β = 0.

## 8. Kolchinsky & Wolpert (2020), "Thermodynamic costs of Turing Machines"

**(a)** A. Kolchinsky & D. H. Wolpert, "Thermodynamic costs of Turing Machines," *Physical Review Research* 2: 033312 (2020). DOI 10.1103/PhysRevResearch.2.033312. arXiv:1912.04685. Checked in full text.

**(b) CORRECTED.** The claim as given, "minimal heat to produce x related to K(x) via the coding theorem," gets the main result backwards. The paper studies two physical realisations of a Turing machine.
- **Coin-flipping realisation.** This realisation is thermodynamically reversible when inputs are random bits. Using Levin's coding theorem, the heat generated on input p is Q_coin(p) = kT ln 2 · [ℓ(p) − K(φ_U(p))] + O(1): the *excess* length of the program over the shortest program with the same output.
  - Consequently, the minimal heat to produce a given output y is min_{p: U(p)=y} Q_coin(p) = **O(1)**, bounded independently of y. The authors call this the "thermodynamic complexity" of y and stress that it is bounded, "unlike the Kolmogorov complexity."
  - Reaching that bound requires knowing the shortest program for y, which is uncomputable. The authors prove that no computable map y ↦ p achieves O(1) heat.
- **Dominating realisation.** Its heat function is Q_dom(p) = kT ln 2 · K(p | φ(p)). This is no larger than the heat of any computable realisation, up to a constant. It too produces any y with O(1) heat, and there is a simple scheme for choosing the input.
- **Expected heat.** For both realisations, with inputs drawn from the natural distribution, the expected heat is *infinite*.
- **Tradeoff.** Any computable realisation that produces y from x faces a fundamental cost of K(x|y). It can pay that cost in heat, in the complexity of the input–output map, or in the complexity of its heat function. The paper works through the example of erasing a long string.

**(c)** Correct statement for the essay: "Kolchinsky & Wolpert show that the heat to run a program on a reversible-for-random-input machine is proportional to how much longer the program is than the shortest one with the same output, ℓ(p) − K(output). Producing x from its shortest program costs only O(1). The irreducible cost is K(input | output), the information about the input that the output loses." If the essay wants "heat ≈ K(x)", the right citation is Zurek's or Bennett et al.'s erasure picture: erasing x costs about K(x) bits after reversible compression.

## 9. Expected Kolmogorov complexity ≈ Shannon entropy

**(a)**
- P. Grünwald & P. Vitányi, "Algorithmic information theory," in P. Adriaans & J. van Benthem (eds.), *Handbook of the Philosophy of Information*, Elsevier (2008), pp. 281–320 *(pages from memory)*. arXiv:0809.2754, **Theorem 10**. Checked in full text.
- Also Grünwald & Vitányi, "Shannon information and Kolmogorov complexity," arXiv:cs/0410002, Theorem 2.10.
- Li & Vitányi, *An Introduction to Kolmogorov Complexity and Its Applications*. The result is usually cited to Chapter 8, "Physics, Information, and Computation," §8.1 (3rd ed. 2008; 4th ed. 2019). I could not confirm the exact theorem number (often given as Theorem 8.1.1).

**(b) VERIFIED (statement).** For a computable probability mass function P on {0,1}* and *prefix* complexity K: 0 ≤ Σ_x P(x) K(x) − H(P) ≤ K(P) + O(1). The lower bound is exact, by the noiseless coding theorem. The upper bound comes from the coding theorem together with P(x) ≤ 2^{K(P)+O(1)} m(x).

**(c)** "E_P K = H(P) + O(K(P))" is a fair shorthand, but write the one-sided form. It needs prefix complexity and computable P. When K(P) is large the gap can be large; Grünwald & Vitányi give the example of a point mass on a complex string. Cite Grünwald & Vitányi 2008, Thm 10, unless the Li–Vitányi number can be checked in a physical copy.

## 10. K(x_t) ≤ K(x_0) + K(t) + O(1) for deterministic computable dynamics

**(a) Recommended sources.**
- A. Ebtekar & M. Hutter, "Foundations of algorithmic thermodynamics," *Physical Review E* (2025). The venue is per the Google DeepMind publication page dated 8 Jan 2025; volume and article number unconfirmed. arXiv:2308.06927 (v4, Dec 2024). Checked in full text.
- S. Aaronson, "The First Law of Complexodynamics," *Shtetl-Optimized* blog (2011), https://scottaaronson.blog/?p=762. Informal, but it states the point plainly: for a deterministic system the complexity of the state "increases at most logarithmically in time."
- Related: Janzing, Chaves & Schölkopf, "Algorithmic independence of initial condition and dynamical law in thermodynamics and causal inference," *New Journal of Physics* 18: 093052 (2016). Not checked for this exact inequality.

**(b) CORRECTED (source).** The inequality is correct and elementary. To describe x_t, give x_0's shortest program, the dynamics, and t. In full, K(x_t) ≤ K(x_0) + K(f) + K(t) + O(1). K(f) is absorbed into the O(1) only when the dynamics f are fixed. Since K(t) ≤ log t + 2 log log t + O(1), the growth is at most logarithmic in t.
- Ebtekar & Hutter Corollary 3: for any computable bijection f, K(f(x)) − K(x) = I(f(x):f) − I(x:f) up to a constant. If I(x:f) = 0, then 0 ≤ K(f(x)) − K(x) ≤ K(f) up to constants. Taking f as the t-step map gives the bound.
- They comment that for deterministic reversible laws "that we can feasibly write down, Corollary 3 really says that the entropy cannot change by a physically meaningful amount," so "randomness (which in classical physics comes from coarse-graining) is necessary for substantial entropy production."
- Corollary 4, their duration-dependent second law, has a K(t − s) fluctuation term. They note it "allows periodic visits to low-entropy states, such as in a deterministic process with a very long cycle," which fits Poincaré recurrence.
- I did not find this inequality stated in Zurek 1989's abstract or in Aaronson–Carroll–Ouellette 2014 (arXiv:1405.6903, the coffee automaton paper). Do not attribute it to them without checking.

**(c)**
- Include the K(dynamics) term, or say "for fixed dynamics."
- For continuous physical systems the bound applies to a finite-precision or coarse-grained description, which is Gács's and Ebtekar–Hutter's setting.
- The same bound limits *decrease* as well as increase for bijective dynamics.

## 11. Still, Sivak, Bell & Crooks (2012), "Thermodynamics of prediction"

**(a)** S. Still, D. A. Sivak, A. J. Bell & G. E. Crooks, "Thermodynamics of Prediction," *Physical Review Letters* 109: 120604 (2012). DOI 10.1103/PhysRevLett.109.120604. arXiv:1203.3271.

**(b) VERIFIED.** For a system driven by a stochastic protocol, the average dissipated work is bounded below by the nonpredictive information it keeps: β⟨W_diss⟩ ≥ I_mem − I_pred. Here I_mem is the information the system's state holds about the past signal, and I_pred is the part that predicts the next signal.

**(c)** The "memory" is the physical state of a driven system, not a separate storage device. The bound holds step by step along the protocol.

## 12. Goldt & Seifert (2017), "Stochastic thermodynamics of learning"

**(a)** S. Goldt & U. Seifert, "Stochastic Thermodynamics of Learning," *Physical Review Letters* 118: 010601 (2017). DOI 10.1103/PhysRevLett.118.010601. arXiv:1611.09428. Checked in full text.

**(b) VERIFIED.** The abstract says "the information acquired by the network is bounded by the thermodynamic cost of learning," and the paper introduces a learning efficiency η ≤ 1. The main inequality, Eq. 10, is I(σ_T : σ) ≤ ΔS(ω) + ΔQ.
- I(σ_T : σ) is the mutual information between the true labels and the network's predicted labels on the training inputs.
- ΔS(ω) + ΔQ is the total entropy production of the *weights*: their change in Shannon entropy plus the heat their Markovian (Langevin-type) dynamics dissipate into the medium.
- The paper then defines η = I/(ΔS + ΔQ) ≤ 1 and analyses Hebbian learning.

**(c)** The bound concerns a model in which the weights are physical degrees of freedom in a heat bath. It is not about a GPU's energy use, which exceeds it by many orders of magnitude. The information measured is about the training labels, not generalisation.

## 13. Boyd, Mandal & Crutchfield (2017), "Leveraging environmental correlations"

**(a)** A. B. Boyd, D. Mandal & J. P. Crutchfield, "Leveraging Environmental Correlations: The Thermodynamics of Requisite Variety," *Journal of Statistical Physics* 167(6): 1555–1585 (2017). DOI 10.1007/s10955-017-1776-0. arXiv:1609.05353.

**(b) VERIFIED, but the claim should be softened.** The abstract (paraphrased) says:
- a memoryless ratchet suffices to exploit an *uncorrelated* input;
- a ratchet *needs memory* to exploit temporal correlations, and its memory should reflect the memory of the input's generator;
- finite-state ratchets facing correlated inputs cannot reach the bounds set by the information-processing second law, while infinite-state ratchets can.

"Requisite variety" is a nod to Ashby.

**(c)** "Extract work only to the extent their structure matches the environment's" is a fair gloss, not a theorem statement. Say "a ratchet can harvest environmental correlations only if its own memory reflects the structure that generates them."

**Strongly recommended addition.** A. B. Boyd, J. P. Crutchfield & M. Gu, "Thermodynamic machine learning through maximum work production," *New Journal of Physics* 24: 083040 (2022), DOI 10.1088/1367-2630/ac4309, arXiv:2006.15416. Its central result is that picking the agent that extracts the most work from given data is equivalent to maximum-likelihood model selection. That is close to the essay's title thesis.

## 14. Hinton & van Camp (1993); bits-back

**(a)** G. E. Hinton & D. van Camp, "Keeping the neural networks simple by minimizing the description length of the weights," in *Proceedings of the Sixth Annual Conference on Computational Learning Theory (COLT '93)*, ACM, pp. 5–13 (1993). DOI 10.1145/168304.168306. The author's PDF title reads "Keeping Neural Networks Simple by Minimizing the Description Length of the Weights." Checked in full text.

**(b) VERIFIED.**
- §5.2 is titled "The 'bits back' argument." The sender draws precise weights from the posterior Q using random bits and codes them under the prior P. The receiver can recover those random bits, so the net expected cost is KL(Q‖P) plus the cost of the data misfits.
- §7, "A lemma from statistical mechanics," defines the Helmholtz free energy F = Σ r_i E_i − Σ r_i log(1/r_i) and identifies the expected code cost minus the bits back with a free energy, minimised by the Boltzmann distribution.

**(c)** The term "bits back" is already in the 1993 paper, so credit it to Hinton & van Camp. Frey & Hinton, "Efficient stochastic source coding and an application to a Bayesian network source model," *The Computer Journal* 40(2/3): 157–165 (1997), made the coding scheme practical. Hinton & Zemel (NIPS 1994), "Autoencoders, minimum description length and Helmholtz free energy," extended it to autoencoders *(both from memory)*. Wallace's minimum message length work anticipated the idea.

## 15. Fredkin & Toffoli (1982); Feynman (1985/86)

**(a)**
- E. Fredkin & T. Toffoli, "Conservative Logic," *International Journal of Theoretical Physics* 21(3/4): 219–253 (1982). DOI 10.1007/BF01857727. The billiard-ball model of computation appears here.
- R. P. Feynman, "Quantum Mechanical Computers," *Optics News* 11(2): 11–20 (1985). Reprinted in *Foundations of Physics* 16(6): 507–531 (1986), DOI 10.1007/BF01886518.

**(b) VERIFIED** (standard references; bibliographic data consistent across sources).

**(c)** The billiard-ball computer is Fredkin & Toffoli's, not Feynman's. Feynman's paper is about reversible quantum gates and Hamiltonians.

## 16. SGD as overdamped Langevin; Gibbs stationary distribution

**(a) References.**
- S. Mandt, M. D. Hoffman & D. M. Blei, "Stochastic Gradient Descent as Approximate Bayesian Inference," *JMLR* 18(134): 1–35 (2017). arXiv:1704.04289.
- M. Welling & Y. W. Teh, "Bayesian Learning via Stochastic Gradient Langevin Dynamics," *ICML 2011*, pp. 681–688.
- P. Chaudhari & S. Soatto, "Stochastic gradient descent performs variational inference, converges to limit cycles for deep networks," **ICLR 2018** (arXiv:1710.11029). *Correction: the venue is ICLR 2018, not ITA.*
- Q. Li, C. Tai & W. E, "Stochastic modified equations and adaptive stochastic gradient algorithms," *ICML 2017*. Journal version: "Stochastic modified equations and dynamics of stochastic gradient algorithms I: mathematical foundations," *JMLR* 20(40): 1–47 (2019). This is the rigorous SDE approximation.
- S. Jastrzębski et al., "Three factors influencing minima in SGD," arXiv:1711.04623 (2017). Source of the "temperature ∝ learning rate / batch size" reading, under an isotropic-noise assumption.
- U. Şimşekli, L. Sagun & M. Gürbüzbalaban, "A tail-index analysis of stochastic gradient noise in deep neural networks," *ICML 2019* (PMLR 97). Argues for heavy-tailed noise.
- A. Panigrahi et al., "Non-Gaussianity of stochastic gradient noise," arXiv:1910.09626 (2019), and Z. Xie, I. Sato & M. Sugiyama, "A diffusion theory for deep learning dynamics," *ICLR 2021*. Dispute the heavy-tail claim.

*(Venues for Li–Tai–E, Jastrzębski, Şimşekli, Panigrahi and Xie are from memory; the Chaudhari–Soatto venue was confirmed.)*

**(b) CORRECTED.** The unqualified claim "SGD is overdamped Langevin with stationary distribution ∝ e^{−L/T}" is false in general.
- For small learning rate η and batch size B, SGD is approximated by dθ = −∇L(θ) dt + √(η/B) Σ(θ)^{1/2} dW (Li–Tai–E), where Σ(θ) is the per-example gradient covariance. This is indeed first-order, overdamped dynamics, but the diffusion is *state-dependent and anisotropic*.
- Only if Σ were constant and isotropic, Σ = σ²I, would the stationary density be Gibbs, ∝ exp(−L/T) with T = ησ²/(2B).
- Mandt et al. assume a constant learning rate, Gaussian noise with constant covariance, and a locally quadratic loss. They get a multivariate Ornstein–Uhlenbeck process with a *Gaussian* stationary distribution, then tune SGD so that distribution approximates the posterior in KL divergence.
- SGLD (Welling–Teh) is a *different algorithm*. It injects isotropic Gaussian noise of variance equal to the step size, with decreasing step sizes, so that it samples from the posterior ∝ e^{−U}. Plain SGD does not do this.
- Chaudhari & Soatto show that SGD minimises "an average potential over the posterior distribution of weights along with an entropic regularization term," and that this potential is "not the original loss function in general." Mini-batch gradient noise is highly non-isotropic, with covariance rank as low as about 1% of the dimension. The dynamics are out of equilibrium: the most likely trajectories are limit cycles, not Brownian motion near critical points.
- Whether the noise is heavy-tailed is disputed (Şimşekli et al. versus Panigrahi et al. and Xie et al.).

**(c) Wording for the essay.** "In the small-step limit SGD is an overdamped (first-order) Langevin-type process. Its noise is anisotropic and depends on position, so its stationary state is generally not the Gibbs distribution of the training loss. It is a nonequilibrium steady state concentrated on a different effective potential (Chaudhari & Soatto 2018). Only under an isotropic-noise idealisation does it reduce to e^{−L/T} with T ∝ η/B."

The "Aristotelian" (first-order) claim survives intact, because it rests on the drift, not on the stationary distribution.

## 17. Momentum as damped Newtonian dynamics

**(a)**
- B. T. Polyak, "Some methods of speeding up the convergence of iteration methods," *USSR Computational Mathematics and Mathematical Physics* 4(5): 1–17 (1964). DOI 10.1016/0041-5553(64)90137-5.
- W. Su, S. Boyd & E. J. Candès, "A Differential Equation for Modeling Nesterov's Accelerated Gradient Method: Theory and Insights," *NIPS 2014*; *JMLR* 17(153): 1–43 (2016).
- A. Wibisono, A. C. Wilson & M. I. Jordan, "A variational perspective on accelerated methods in optimization," *PNAS* 113(47): E7351–E7358 (2016). DOI 10.1073/pnas.1614734113. arXiv:1603.04245.

**(b) VERIFIED.**
- Polyak's heavy ball discretises ẍ + a ẋ + b∇f(x) = 0: a heavy ball with *constant* friction.
- Su–Boyd–Candès derive the limit ODE Ẍ + (3/t)Ẋ + ∇f(X) = 0.
- Wibisono–Wilson–Jordan generate the family of accelerated methods from a "Bregman Lagrangian."

**(c) Caveats.**
- Nesterov's ODE has friction 3/t that *vanishes* over time. That is an increasingly underdamped, Newtonian regime, the opposite of Aristotelian.
- Add N. B. Kovachki & A. M. Stuart, "Continuous Time Analysis of Momentum Methods," *JMLR* 22(17): 1–40 (2021), arXiv:1906.04285. They show that fixed-momentum methods (heavy ball and Nesterov at fixed β) approach a *time-rescaled gradient flow* as the learning rate goes to zero. At finite learning rate there is a second-order correction proportional to η, and the dynamics reduce approximately to gradient flow on a modified loss on an attractive invariant manifold.
- So deep-learning practice (SGD with momentum β ≈ 0.9, or Adam) is effectively first-order on time scales longer than about 1/(1−β) steps. This supports the essay's thesis better than ignoring momentum would.

## 18. Jordan, Kinderlehrer & Otto (1998)

**(a)** R. Jordan, D. Kinderlehrer & F. Otto, "The Variational Formulation of the Fokker–Planck Equation," *SIAM Journal on Mathematical Analysis* 29(1): 1–17 (1998). DOI 10.1137/S0036141096303359.

**(b) VERIFIED.** The JKO time-discrete scheme minimises, at each step, the free energy F(ρ) = ∫Ψρ + β^{−1}∫ρ log ρ plus a Wasserstein-2 proximity term. As the step size goes to zero the iterates converge to the Fokker–Planck solution. The Fokker–Planck equation is thus the W₂ gradient flow of the free energy.

**(c)** The free energy uses the *potential Ψ* of an isotropic-diffusion Fokker–Planck equation. By item 16, SGD's Fokker–Planck equation has anisotropic diffusion, so JKO with Ψ = L describes the idealised dynamics, not SGD exactly.

## 19. Rovelli (2015), "Aristotle's Physics: A Physicist's Look"

**(a)** C. Rovelli, "Aristotle's Physics: A Physicist's Look," *Journal of the American Philosophical Association* 1(1): 23–40 (2015). DOI 10.1017/apa.2014.11. arXiv:1312.4057. Checked in full text.

**(b) CORRECTED (wording).**
- Rovelli argues that Aristotelian physics is "a correct and non-intuitive approximation of Newtonian physics in the suitable domain (motion in fluids)."
- His model is Newton's law with gravity, buoyancy and *quadratic* drag, F = −mg + Vρ − Cρ|v|v. A falling body has a short transient, then a steady fall at terminal velocity, v = c√(W/ρ).
- He says Aristotle had the dependence right (faster for heavier bodies, slower in denser media) and missed "only the square root."

**(c)**
- "Strong friction" is not Rovelli's phrase. His regime is "motion in fluids" after the transient, i.e. terminal velocity.
- His drag is quadratic (high Reynolds number), so velocity grows as the square root of force. The overdamped, linear rule v = F/γ, the analogue of gradient flow, is the *Stokes* (low-Reynolds, linear-drag) version of the same limit.
- The essay can say "Rovelli reads Aristotle's dynamics as Newton's in the terminal-velocity regime of motion through a medium; with linear (viscous) drag, that regime is exactly first-order, velocity proportional to force." Do not attribute v ∝ F to Rovelli.

---

## Sources consulted (primary)

- APS abstract, Zurek 1989: https://journals.aps.org/pra/abstract/10.1103/PhysRevA.40.4731
- Zurek 1998, full text: https://arxiv.org/abs/quant-ph/9807007
- Bennett et al., Information distance, full text: https://arxiv.org/abs/1006.3520
- Kolchinsky & Wolpert, full text: https://arxiv.org/abs/1912.04685
- Goldt & Seifert, full text: https://arxiv.org/abs/1611.09428
- Boyd, Mandal & Crutchfield: https://arxiv.org/abs/1609.05353
- Boyd, Crutchfield & Gu: https://arxiv.org/abs/2006.15416
- Baez & Stay, full text: https://arxiv.org/abs/1010.2067
- Tadaki 2002: https://arxiv.org/abs/nlin/0212001
- Bennett 2003, full text: https://arxiv.org/abs/physics/0210005
- Grünwald & Vitányi 2008, full text: https://arxiv.org/abs/0809.2754 ; Grünwald & Vitányi 2004: https://arxiv.org/abs/cs/0410002
- Ebtekar & Hutter, full text: https://arxiv.org/abs/2308.06927 ; DeepMind publication page: https://deepmind.google/research/publications/82794/
- Aaronson blog: https://scottaaronson.blog/?p=762
- Aaronson, Carroll & Ouellette: https://arxiv.org/abs/1405.6903
- Chaudhari & Soatto: https://arxiv.org/abs/1710.11029 ; ICLR 2018: https://iclr.cc/virtual/2018/poster/152
- Mandt, Hoffman & Blei: https://arxiv.org/abs/1704.04289
- Kovachki & Stuart: https://www.jmlr.org/papers/v22/19-466.html
- Hinton & van Camp, full text: https://www.cs.toronto.edu/~hinton/absps/colt93.pdf
- Rovelli, full text: https://arxiv.org/abs/1312.4057
