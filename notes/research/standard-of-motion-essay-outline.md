# Outline: two essays on physics, information and learning machines

Status: outline for review, 31 Oct 2026. The user chose two essays the same day: A, *The Standard of Motion* (mechanics), and B, *The Demon Is a Learner* (information and learning), published in that order. Sample sentences show register only. Sections carry no word budgets; length follows content. Citations were checked on 31 Oct; corrections are folded in below, and `standard-of-motion-citation-check.md` lists them with pointers to the three agent reports (quotes, DOIs, URLs). Heller 2006 was read in full (`notes/private/From Aristotle to Einstein--Michal Heller.pdf`, gitignored).

## Seeds

- Heller, "Evolution of Space-Time Structures", *Concepts of Physics* III (2006) 117–131. The first law fixes a "standard of motion"; the geometry of space-time encodes it. The Cartesian product structure disappears at one level and reappears one level up (A = T × S; F(N) = N × Galileo; F(M) = M × Lorentz; F(F(M)) for GR; the groupoid F(M) × G as the proposed next step, where points and instants lose meaning below the Planck level).
- The user's old seminar, led by Piotr Biler around 2003, probably the winter semester 2003/2004 (user, 31 Oct: "around 2003" is certain, the semester is not; the seminar's exact name not found): classical, statistical and quantum mechanics in one Lagrangian/Hamiltonian framework. Its opening chapter was the qualitative theory of differential equations, before the Lagrangian (user unsure) and Hamiltonian (certain) pictures (user, 31 Oct). The user doesn't remember its details, so the essay credits Biler with the seminar and its unifying frame only, and the derivations in A§3 are the essay's own.
- Rovelli, "Aristotle's Physics: A Physicist's Look" (J. Am. Philos. Assoc. 1, 2015): Aristotle's dynamics is a correct *approximation* of Newton's for motion in fluids, with quadratic drag ("What Aristotle does not have is only the square root"). Heller's F = m·v is the linear-drag (Stokes) case; "overdamped" is our gloss.
- Algorithmic information and thermodynamics: Landauer, Bennett, Zurek 1989, Bennett–Gács–Li–Vitányi–Zurek 1998, Baez–Stay.
- Learning thermodynamics: Still et al. 2012, Goldt–Seifert 2017, Boyd–Mandal–Crutchfield 2017; bits-back (Hinton–van Camp 1993).
- Blumenthal et al., arXiv 2609.15897 (Princeton review): reference scaffold for control ↔ inference ↔ transport ↔ thermodynamics, not a seed.
- Our Wolfram exposition (`notes/wolfram-physics-quantum-mechanics.md`) and the 31 Oct "motion is easy" discussion.

## How the two essays divide

The shared idea: a mechanics opens by saying what happens without a cause. Essay A follows that idea through physics: what each theory takes to be free, how that fixes geometry and algebra, and what a computational physics would have to derive. Essay B follows the price of everything that is not free: free evolution conserves information, forgetting costs heat, and a learner is a machine that pays to compress.

The hinge is Liouville's theorem. A ends on it as the strongest freedom (free evolution preserves information); B starts from it as the reason forgetting costs. B restates it in one sentence rather than sending the reader back (AGENTS.md: repetition across essays is fine when it saves a lookup).

Aristotle appears in both, in different roles. In A he is the first rung of Heller's ladder: natural rest as a first law. In B he is a regime: Rovelli's friction limit, where learners live.

---

# Essay A: *The Standard of Motion*

## A1. Thesis

Every mechanics opens by saying what happens without a cause, and Heller shows that this first law fixes the geometry. Aristotle's natural rest gives space-time a product structure; Newton's uniform motion gives a bundle over absolute time, with the product moved up into the frame bundle; free fall gives curvature. The symmetry group of a first law, the transformations that carry free motions to free motions, is where the theories meet algebraically: Galilei is a contraction of Poincaré, and Newtonian mass is a central charge of the Galilei algebra. Hamiltonian mechanics names one more thing that comes free: evolution that conserves information. A computational physics that wants to recover our world has to derive a first law, not only field equations, and for a rewriting universe that is the hard part.

What makes this more than a tour:

1. **Heller's principle does work outside his paper.** It says what Wolfram's model owes: Gorard derives the Einstein equations, which is the geometry; nobody has derived the first law, a natural class of rules under which motion is easy.
2. **Motion is surprising.** In a rewriting universe a moving body is rebuilt at each step from different elements. In Conway's Game of Life, each moving pattern has exactly one speed. From random initial conditions moving patterns appear at only six speeds; engineered and adjustable designs reach many more, but a pattern with period p and displacement d moves at d/p, so another speed means another pattern built from a recipe; nothing has a boosted twin. Newton's first law reports that our world lets one and the same body move at any speed below c, intact, with nothing pushing. Wolfram says the same is "something one has to explicitly derive" in his model (*On the Concept of Motion*, 2022); what A adds is what the derivation must deliver.
3. **The ladder has an algebra.** Contractions and central extensions show the ladder's rungs as limits of one another, and stability arguments may say why the chain runs the way it does.

Sample sentence: "In a world built by rewriting, nothing is carried along; a body that moves has to be rebuilt somewhere else, step after step, and stay itself."

## A2. Sections

### A§0 Opening
A glider in the Game of Life (Richard K. Guy, 1970): it moves diagonally at c/4, cycling through four phases, and it cannot go any other speed. Started from random noise, Life produces moving patterns at only six speeds (LifeWiki, "List of spaceships", rows marked as soup-occurring). Every other speed needs an engineered machine; the adjustable families (Simkin's caterloopillars, reportedly any speed below c/4) are recipes with speed as a construction parameter, and each speed is a different pattern of tens or hundreds of thousands of cells. Newton's first law is the report that our world is different: one body, any speed, nothing built.

### A§1 The first law fixes the geometry (Heller)
Heller's §2 principle: a dynamics first fixes which motions need no force; when geometry sets that standard, geometry becomes physics. Aristotle's first law (natural rest) and second law F = m·v as Heller stylizes them; Newton's uniform motion; free fall. The ladder as a table and one figure (the product structure moving up a level). Newtonian gravity as curvature of the frame bundle, not of space-time (Newton–Cartan: cite Trautman 1963 or his 1965–66 lectures, or Cartan 1923–24 with Malament 2012; not Trautman 1970). One sentence on Rovelli's fluid approximation, pointing to essay B.

### A§2 The algebra of free motions
The symmetry group of a first law maps free motions to free motions. Letting c → ∞ contracts Poincaré to Galilei (İnönü–Wigner); Bacry and Lévy-Leblond (1968, "Possible kinematics") classified the kinematical algebras and their limits, including static and Carroll ones. Figueroa-O'Farrill & Prohazka (JHEP 2019) classify spatially isotropic homogeneous space-times; their "Aristotelian" ones have no boosts at all, so rest is absolute: the algebraic rung under Heller's A = T × S. Newtonian mass as Bargmann's central charge: in Galilean physics, the price of motion sits in the algebra. Stability (verified): Faddeev ("A mathematician's view of the development of physics", 1989; IHÉS reprint 1998) reads both revolutions as "deformations from unstable structures into stable ones"; the stable endpoint he names is the Lorentz group, and Poincaré itself still deforms to (anti-)de Sitter. Mendes ("Deformations, stable theories and fundamental constants", 1994) finds the relativistic quantum algebra unstable too and proposes a further two-parameter deformation. This gives Heller's "logic inherent in the evolutionary chain" an engine, and it predicts a next rung, as Heller's groupoid does. Details in the companion (see §C).

### A§3 One bracket, three mechanics
The seminar's framework. The Hamiltonian moves a point (Hamilton), a density (Liouville), a density operator (von Neumann); the Poisson bracket becomes the commutator over iħ, and deformation quantization makes the second a deformation of the first. The Gibbs state is stationary because it is a function of H. The freedom this framework names: free evolution preserves phase-space volume and von Neumann entropy, so it preserves information. General relativity strains the frame: for a closed universe its Hamiltonian is a constraint (H ≈ 0), with no time for evolution to happen in (with asymptotic flatness the Hamiltonian is the ADM energy; Kuchař 1992 or Isham 1993 for the problem of time).

### A§4 A computational physics must earn its first law
Start from Wolfram's own statement that pure motion is not obvious and "has to be explicitly derive[d]" (*On the Concept of Motion*, 2022), and that he expects it from general topological features of hypergraph rewriting. The 2020 Technical Introduction supplies only passive invariance: "motion: possible because of causal invariance; associated with change of causal foliations" (§8.3; §8.6). Gorard 2020 derives Lorentz covariance by re-foliating one fixed causal graph, under further assumptions (discrete hyperbolicity, flat hypersurfaces, c fixed by the definition of edge lengths, asymptotic dimension preservation, weak ergodicity, a continuum limit), and asserts geodesic motion of a "persistent nonplanar tangle" without deriving it. Motion needs active invariance: persistent structures with boosted twins, speeds dense below c. The only exhibited Wolfram-model particles live on 1D or grid-like backgrounds; nothing new on particles since 2024. The Wolfram model's own reading of mass (timelike causal flux, events that reuse hypergraph elements) and of time dilation as a budget (*On the Nature of Time*, 2024: a moving object "has to be 're-created at a different place in space'") show what a derivation would have to connect. Obstacle: Bombelli–Henson–Sorkin prove no measurable Lorentz-equivariant map from sprinklings to timelike directions; the corollary is that no finite-valency graph fits a sprinkling Lorentz-invariantly. Gorard (arXiv 2011.12174) claims compatibility, so engage his reply. Any result can only be approximate, and the bounds are tight (LHAASO 2024: E_QG,1 > 10 E_Planck). Precedents: causal-set "swerves" (Dowker–Henson–Sorkin), where the first law holds only on average under Lorentz-invariant momentum diffusion, bounded by Kaloper–Mattingly; exactly Lorentz-covariant Clock QCA (Arrighi–Facchini–Forets 2014); Bisio–D'Ariano–Perinotti's quantum walks, covariant at low energy with nonlinear (DSR-like) boosts at the grain (ties to A§2's deformations). Route: particles as topological defects; dislocations and the Peierls–Nabarro barrier as precedent, with the substrate's rest frame surviving as exponentially small friction: Aristotle at the Planck grain. Wolfram's likely reply, observer selection, and why it is weaker. Heller's groupoid endpoint as a parallel: space-time emerging at low energy from a structure without points, with Tomita–Takesaki state-dependent dynamics (Heller, Pysiak, Sasin 2005, citing Connes–Rovelli; they expect the state dependence to vanish in realistic models).

### A§5 Closing
What is free is something each theory discovers about the world, not a convention. Hand-offs: to B (what everything else costs) and to the observers/Ruliad essay (whether an observer's first law is derived or selected).

---

# Essay B: *The Demon Is a Learner*

## B1. Thesis

Free evolution conserves information, so departing from it has a price, and the cheapest unit of that price is the bit: forgetting one releases at least kT ln 2 (Landauer, read as a corollary of Liouville). Algorithmic information gives the price a target: a single state has an entropy, and Zurek's physical entropy, K(record) + H(rest | record), is a two-part code length. Learning machines live in Aristotle's regime. Gradient descent is a first-order law, velocity proportional to force: nothing moves without a gradient, and what it discards it pays for. A learner is a Maxwell demon in Aristotle's world. It extracts predictions from an environment as far as it can compress it.

What makes this more than a tour:

1. **The Aristotelian regime is real, and learners are in it.** Rovelli shows Aristotle's dynamics is a correct approximation for motion in fluids; Aristotle's F ∝ v is its linear-drag case, the overdamped limit of Newton's. Gradient flow, small-step SGD and Wasserstein gradient flows are that regime. Momentum methods seem to put inertia back, but with fixed momentum they reduce to rescaled gradient flow as the step size shrinks (Kovachki & Stuart 2021): learners stay Aristotelian.
2. **Algorithmic information gives the single state an entropy.** Classical mechanics follows a point and has no entropy; statistical mechanics has entropy only for ensembles. Zurek's split makes a demon's thermodynamic account an MDL account.
3. **The thermodynamics of learning is already measured in bits.** Still et al., Goldt–Seifert and Boyd–Mandal–Crutchfield turn "prediction is compression" from a slogan into bounds on dissipation, and Boyd, Crutchfield & Gu (New J. Phys. 2022) prove that choosing the agent that extracts the most work is maximum-likelihood model selection.

Sample sentence: "A neural network in training obeys Aristotle's law of motion: its weights move only while a force pushes them, and at a speed proportional to that force."

## B2. Sections

### B§0 Opening
The training loop and Aristotle's F = m·v side by side. The update w ← w − η∇L is a first-order law: no gradient, no motion. Promise: the essay prices what a learner does.

### B§1 Aristotle was right about a regime
Rovelli: motion in fluids, quadratic drag, Aristotle missed "only the square root". The linear-drag case is overdamped dynamics dx/dt = −∇V, Aristotle's F ∝ v as Heller writes it. Gradient flow; small-step SGD is first-order, but its noise is anisotropic and position-dependent, so its stationary state is not Gibbs on the loss (Chaudhari & Soatto, ICLR 2018; Gibbs e^(−L/T) only for isotropic noise; Mandt et al. 2017 for the quadratic case). The Aristotelian claim rests on the drift, not the stationary state. Wasserstein gradient flows and JKO 1998 (Princeton review §V.2); Onsager's least dissipation. Momentum: heavy ball with fixed momentum reduces to rescaled gradient flow as the step shrinks (Kovachki & Stuart 2021); Nesterov's ODE (Su–Boyd–Candès) has vanishing friction 3/t, the one non-Aristotelian exception. Cross-link: *How Does a Policy Improve?* (entropy-regularized RL as a free-energy objective).

### B§2 What forgetting costs
Liouville in one sentence (link to A§3). Landauer from Liouville (Bennett 2003 gives this derivation): erasure merges two states into one; a Hamiltonian flow cannot shrink volume, so the volume goes into the environment as heat. Bérut et al. 2012 reach the bound for slow erasure. Bennett 1973: reversible Turing machines; Bennett 1982: the demon pays at erasure, not measurement. Fredkin–Toffoli and Feynman 1985 as computation done by free evolution. Kolchinsky & Wolpert 2020: producing an output can cost O(1) heat; what costs is K(input | output), what the computation forgets about its input. Information distance (Bennett–Gács–Li–Vitányi–Zurek 1998): K(x|y) + K(y|x) irreversible bit operations to convert, with thermodynamic cost K(x|y) − K(y|x) in units of kT ln 2. Cross-link: *Who Teaches the Weights* calls self-distillation "forgetting of alternatives"; here forgetting gets its price.

### B§3 Entropy of one state
Kolmogorov complexity; E_P[K] = H(P) + O(K(P)) (Li–Vitányi; section to confirm). Zurek's physical entropy (S = H given the record + K of the record) and why the demon cannot win on average; the two-part-code reading. The second law needs coarse-graining: K(x_t) ≤ K(x_0) + K(dynamics) + K(t) + O(1) is Liouville for a single trajectory (Ebtekar & Hutter, Phys. Rev. E 2025, Cor. 3–4). Baez–Stay: AIT as a Gibbs ensemble over programs, with log runtime as energy and length as volume; Ω is the partition function at β = 0, γ = ln 2 (temperature with length as energy: Calude–Stay 2006, Tadaki 2008). Cross-link: *The Bookmaker Is a Learner* (LMSR's cost function is a log-partition function, a free energy).

### B§4 The demon is a learner
Lead with Boyd, Crutchfield & Gu 2022: the agent that extracts the most work is the maximum-likelihood model. Still et al. 2012: memory without predictive value dissipates. Goldt–Seifert 2017: what a network learns about its labels is bounded by the entropy production of the weights as physical degrees of freedom (not hardware dissipation). Boyd–Mandal–Crutchfield 2017: a ratchet leverages environmental correlations only as far as its structure matches them (soften: "requisite variety"). Bits-back: the variational free energy is a code length. Thesis stated in full: an Aristotelian demon extracts predictions as far as it compresses, and pays for what it discards.

### B§5 Closing
Wolfram's second law (computationally bounded observers) as the meeting point with A§4 and the observers/Ruliad essay: what a bounded observer can compress sets the laws it sees, the work it can extract, and the predictions it can make.

---

## C. Lie algebras and a companion page

Not a primer. A§3 needs only the word "bracket". A§2 states the contractions and Bargmann's central charge in prose with one or two displayed brackets. The companion page to A (decided 31 Oct; working file name `notes/the-standard-of-motion-mathematics.md`, following *The Bookmaker Is a Learner — Mathematics*) holds:

1. Heller's ladder in frame-bundle terms: the projections pr_T and pr_S, the frame bundles and their structure groups, teleparallelism as a product F(N) = N × G, Newtonian gravity as curvature of F(N), F(F(M)) for GR.
2. Kinematical Lie algebras: the brackets of Poincaré and Galilei, the İnönü–Wigner contraction c → ∞ (PNAS 1953), the Bacry–Lévy-Leblond family with its static and Carroll limits, and Figueroa-O'Farrill–Prohazka's Aristotelian (boost-free) space-times.
3. Bargmann's central extension of the Galilei algebra (Ann. Math. 1954) and why mass appears there; hedge any claim that Bargmann proved mass superselection.
4. The stability argument: Faddeev (Lorentz stable; Poincaré deforms to (A)dS), Mendes 1994 (a further two-parameter deformation), Chryssomalakos–Okon 2004.
5. The Poisson bracket, the commutator and the Moyal bracket, if A§3 needs more than the word.

The companion does not retell the essay. B's equations (Landauer, Zurek's split, the K(x_t) bound) fit in B without a companion.

---

## D. Open questions for the user

1. ~~Titles.~~ **Decided (user, 31 Oct): keep the echo.** A is *The Standard of Motion*; B is *The Demon Is a Learner*, deliberately echoing *The Bookmaker Is a Learner*. B should cross-link the bookmaker essay early (the LMSR cost function as a free energy, B§3) so the echo is earned.
2. ~~Is A§4 (Wolfram) here, or in the observers/Ruliad essay?~~ **Decided (user, 31 Oct): keep it in A.** A becomes a prerequisite for the observers/Ruliad essay, which can cite A§4 instead of rebuilding the motion test.
3. ~~Lie algebras: box in A§2, or a companion page to A?~~ **Decided (user, 31 Oct): a companion page to A**, listed in A's index entry as a second link (as with the bookmaker essay). It carries the contractions (Bacry–Lévy-Leblond, İnönü–Wigner), Bargmann's central charge, the stability argument if it survives checking (Mendes, Faddeev), and the frame-bundle statements behind Heller's table. A§2 keeps prose with one or two displayed brackets and links into the companion by section.
4. ~~Openings.~~ **Decided (user, 31 Oct): the Game of Life glider opens A; the training loop beside F = m·v opens B.**
5. **Provenance:** the seminar was Piotr Biler's; its name is not found. Proposal: "a seminar Piotr Biler ran around 2003" in A§3's first sentence, without a title.
6. ~~Math density.~~ **Decided (user, 31 Oct): as in the bookmaker essay, "in case of doubt higher".**

All open questions are settled. Citation check done 31 Oct (`standard-of-motion-citation-check.md`); the LifeWiki claims were checked by hand the same day (addendum), and the rest of its "Still unverified" list needs a manual check before the affected sentences are drafted. Next: draft A and its companion.

---

## E. Qualitative theory of differential equations (31 Oct; the A items are folded into the draft, the B items wait for B)

Provenance: the seminar opened with it (see Seeds), so A§2's credit line can say so.

- **A, stability section: two notions of stability.** Faddeev/Mendes stability is structural stability (Andronov–Pontryagin 1937, *systèmes grossiers*) carried to Lie algebras; Mendes's abstract defines stable theories as those that "do not change in a qualitative manner under a small change of parameters". Among all vector fields, conservative systems are structurally unstable (centers become foci under friction; Peixoto 1962 on surfaces), gradient/Morse–Smale flows are structurally stable (Palis–Smale 1970), and Hamiltonian behavior is stable only within the Hamiltonian class (KAM). So Aristotle's first law is the generic one and Newton's (with Liouville) is protected by symmetry (Noether: translation invariance → momentum).
- **A, Wolfram test refined.** A generic discrete substrate should give Aristotelian motion (the Peierls–Nabarro precedent agrees); the natural class of rules probably needs a discrete Noether-type invariant that forbids drag. A sharper target than "motion is easy".
- **B§1.** Overdamped limit as singular perturbation: m ẍ = F − γẋ, m/γ → 0, reduces to the slow manifold ẋ = F/γ (Tikhonov 1952; Fenichel 1979), the ODE counterpart of A's contractions. Gradient flows have Lyapunov functions and no recurrence; learning-convergence proofs use the Łojasiewicz gradient inequality (1963) and the Polyak–Łojasiewicz condition (Polyak 1963).
- **B§5.** Poincaré founded the qualitative theory because the three-body problem has no closed-form solution; studying invariants without solving is what a computationally bounded observer does.

Citations checked 31 Oct (`citecheck-qualitative-2026-10-31.md`), all verified for B. For B§1: write the limit as ẋ = v, (m/γ) v̇ = F/γ − v; m/γ has units of time, so the true small parameter is mk/γ² (stiffness k), and overdamping begins at mk/γ² ≥ 1/4, the same threshold at which the damped oscillator's focus becomes a node (ε = 2). Cite Łojasiewicz 1963 (CNRS colloque 117, pp. 87–89) with Kurdyka 1998 for the finite-length consequence; the "Polyak–Łojasiewicz" name is from Karimi–Nutini–Schmidt 2016.
