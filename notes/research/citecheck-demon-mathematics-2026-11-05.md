# Citation check: mathematics page companion to *The Demon Is a Learner*, 5 Nov 2026

Format follows `citecheck-essayB-2026-10-31.md`; nothing that report confirmed is repeated. Bibliographic data were checked against Crossref (DOI records) and the arXiv API. Claims were checked against full text where it was reachable: arXiv PDFs, author-hosted PDFs (Jaynes 1965 by OCR of a scan, Cover 1994, Ackley et al. 1985, Neal's AIS report), and the Annals of Mathematics page. "Secondary" means only a survey or search summary was seen. Items marked *(memory)* were not rechecked.

## Summary of verdicts

| # | Item | Verdict | One-line note |
|---|---|---|---|
| 1 | Boltzmann 1872 | VERIFIED | Wien. Ber. 66, 275–370 (some modern lists wrongly give vol. 63) |
| 2 | Loschmidt 1876; Zermelo 1896 | VERIFIED (caveat) | Zermelo also gave an independent, pre-recurrence Liouville argument |
| 3 | Burbury; Stosszahlansatz; molecular chaos | CORRECTED / UNVERIFIABLE | Ehrenfests coined Stosszahlansatz (dated 1911 or 1912 by different sources); who coined "molecular chaos" is not settled |
| 4 | Kac ring | CORRECTED | 1956 note is the primary source; period is 2N in general, N when the number of marks is even |
| 5 | Lanford 1975 | VERIFIED | Time is a fraction of the first-collision time (usually quoted as about 1/5) |
| 6 | Deng–Hani–Ma | VERIFIED | Paper 1 on R^d, forthcoming in Annals; paper 2 on 2D/3D tori, no journal ref found |
| 7 | Jaynes 1965, 1957 | VERIFIED | Theorem 1: S_G ≤ S_B, equality iff the N-particle density factorises |
| 8 | Cover 1994; Villani 2002 | VERIFIED; Villani details UNVERIFIABLE | Chapter 5, pp. 98–107. Villani chapter end page and H-theorem section not seen |
| 9 | Wainwright–Jordan 2008 | VERIFIED | Published numbering: Proposition 2 and Theorem 2 |
| 10 | Ackley–Hinton–Sejnowski; Hinton 2002; HVD | VERIFIED | HVD is a NIPS 2014 workshop paper |
| 11 | Neal–Hinton; "Feynman–Bogoliubov" | CORRECTED | The standard names are Gibbs–Bogoliubov or Peierls–Bogoliubov; Neal–Hinton cite neither Feynman nor Bogoliubov |
| 12 | Yedidia et al.; Mézard–Montanari; Stosszahlansatz link | VERIFIED; no source found for the link | No source found that compares cavity independence to the Stosszahlansatz |
| 13 | Hopfield; AGS; Zdeborová–Krzakala | VERIFIED | 0.138 is the replica-symmetric value |
| 14 | Flat minima etc. | VERIFIED | |
| 15 | SGD as Bayesian inference etc. | VERIFIED (caveat) | Smith–Le give Gibbs only under stationary, isotropic noise |
| 16 | Einstein, Sutherland, Kubo | VERIFIED | |
| 17 | Metropolis, Hastings, Kirkpatrick | VERIFIED | |
| 18 | Jarzynski, Crooks, Neal | VERIFIED | Neal does mention Jarzynski (quote below) |
| 19 | IWAE, TVO, Gelman–Meng | VERIFIED | |
| 20 | Thermodynamic length; Chopin et al. | CORRECTED | Bound holds in slow-driving regime; the friction metric is τ∘Fisher, equal to Fisher only if the relaxation time is constant |
| 21 | Diffusion-model references | VERIFIED | |
| 22 | Premkumar; Ikeda et al. | CORRECTED | Premkumar is NeurIPS 2025. Ikeda et al. is Phys. Rev. X 15, 031031 (2025), with a new title |
| 23 | Vempala–Wibisono; Otto–Villani | VERIFIED | The T-scaled identity is a short derivation, not a quotation |
| 24 | Esposito–Van den Broeck; PHS; Sagawa–Ueda | VERIFIED | |
| 25 | Vinkler et al.; Kelly | CORRECTED | The paper establishes an analogy, not an identity |
| 26 | Callen; Zia et al.; Maxwell | Zia VERIFIED; Callen chapter numbers UNVERIFIABLE; Maxwell VERIFIED | |

---

## History of the H-theorem

### 1. Boltzmann 1872 — VERIFIED
L. Boltzmann, "Weitere Studien über das Wärmegleichgewicht unter Gasmolekülen," *Sitzungsberichte der Kaiserlichen Akademie der Wissenschaften in Wien, Math.-Naturwiss. Classe* **66**: 275–370 (1872). Reprinted in *Wissenschaftliche Abhandlungen* I, pp. 316–402. English translation in Brush (2003), pp. 262–349. Brown & Myrvold, arXiv:0809.1304, give exactly this reference. The Heidelberg Boltzmann bibliography and the SEP linked bibliography agree on vol. 66 (secondary). One arXiv reference list (1604.04239) and one EPJ H article give vol. 63, which appears to be an error. I did not see the original scan.

### 2. Loschmidt 1876; Zermelo 1896 — VERIFIED (caveat)
- J. Loschmidt, "Über den Zustand des Wärmegleichgewichtes eines Systemes von Körpern mit Rücksicht auf die Schwerkraft," *Sitzungsberichte der Akademie der Wissenschaften Wien, Math.-Naturwiss. Klasse* **73** (II. Abt.): 128–142 (1876). The reference is as given by Brown & Myrvold; Flamm's chapter lists the same start page. The reversibility objection (Umkehreinwand) is in this gravity-field paper.
- E. Zermelo, "Ueber einen Satz der Dynamik und die mechanische Wärmetheorie," *Annalen der Physik* **57** (= 293): 485–494 (1896). DOI 10.1002/andp.18962930314 (Crossref: volume 293, issue 3, pp. 485–494).
- Companion papers, if wanted: Boltzmann, "Entgegnung auf die wärmetheoretischen Betrachtungen des Hrn. E. Zermelo," *Ann. Phys.* **57**: 773–784 (1896); Zermelo, "Ueber mechanische Erklärungen irreversibler Vorgänge," *Ann. Phys.* **59**: 793–801 (1896).
- Caveat: "built on Poincaré recurrence" is right in outline. Poincaré's recurrence theorem (1890) is Zermelo's main weapon. But Brown & Myrvold stress that Zermelo's 1896 paper also contains a separate "pre-recurrence" argument that uses Liouville's theorem and a measure-theoretic point. The wording "the recurrence objection, which applies Poincaré's recurrence theorem" is safe.

### 3. Burbury; Stosszahlansatz; molecular chaos — CORRECTED / partly UNVERIFIABLE
**Burbury.** VERIFIED, with nuance.
- The Nature exchange was started by E. P. Culverwell (*Nature* **50**: 617, 1894, on H. W. Watson's proof), who asked "Will some one say exactly what the H theorem proves?" Burbury's notes: *Nature* **51**: 78 (1894); **51**: 320 (1895); **52**: 104–105 (1895), all titled "Boltzmann's Minimum Function". Crossref confirms the 1894 and 1895 (52) entries. Boltzmann replied in *Nature* **51**: 413–415 (1895) and **52**: 221 (1895).
- Burbury's Condition A, quoted by Brown & Myrvold from the 1894 note: "If the collision coordinates be taken at random, then the following condition holds, viz:—For any given direction of R [the relative velocity of the colliding molecules] before collision, all directions after collision are equally probable. Call this condition A."
- Brown & Myrvold: the "most significant aspect" of the debate was "the clarification by Burbury of the role of a time-asymmetric assumption in the theorem." They add that Condition A is not equivalent to the Stosszahlansatz (see P. M. C. Dias, *Arch. Hist. Exact Sci.* **46**: 341–366, 1994) and that "the connection between this assumption and the SZA was never properly clarified by Burbury."
- Suggested wording: "Burbury (1894) isolated the independence assumption the H-theorem needs, which he called Condition A, and pointed out that the proof gets nothing without it."

**Stosszahlansatz.** CORRECTED. Boltzmann never used the word. Brown & Myrvold: "Boltzmann did not use the term Stosszahlansatz; it was introduced by the Ehrenfests in 1912." The source is P. & T. Ehrenfest, "Begriffliche Grundlagen der statistischen Auffassung in der Mechanik," *Enzyklopädie der mathematischen Wissenschaften* IV, 2, II, Heft 6 (Teubner, Leipzig). Sources date it differently, 1911 or 1912, and de Oliveira (arXiv:1905.07421) gives "1907–1914" for the whole article series. Safe form: "the Ehrenfests' 1911–12 encyclopedia article." English translation: *The Conceptual Foundations of the Statistical Approach in Mechanics* (Cornell 1959; Dover 1990).

**Molecular chaos / molekular-ungeordnet.** UNVERIFIABLE as a coinage claim.
- Boltzmann's own term is attested in the secondary literature: de Oliveira (arXiv:1905.07421) says Boltzmann "stated that the two assumptions above were consequences of the state of the gas being molecularly disordered (molekular Ungeordnet)," citing *Vorlesungen über Gastheorie* (1896–98). I did not see the Boltzmann text.
- The same paper says Jeans (*The Dynamical Theory of Gases*, CUP 1904) "considered them as consequences of the assumption of molecular chaos." Two other secondary sources credit Jeans with the phrase. I found no primary-source confirmation that he coined it, and no support for 1902; the cited book is 1904.
- Complication: Brown & Myrvold say the Ehrenfests "reserve the term 'molecular chaos' for the probabilistic version of the SZA." de Oliveira says the Ehrenfests called the independence assumption "molekulare Unordnung." The two secondary sources disagree on the Ehrenfests' usage.
- Safe wording: "Boltzmann called the condition molekular-ungeordnet; the Ehrenfests named the collision-number assumption Stosszahlansatz; the English phrase 'molecular chaos' is found in Jeans (1904)." Avoid "coined".

### 4. Kac ring — CORRECTED
- Primary source for the ring: M. Kac, "Some remarks on the use of probability in classical statistical mechanics," *Bulletin de la Classe des Sciences, Académie Royale de Belgique* (5) **42**: 356–361 (1956). DOI 10.3406/barb.1956.68352. The Persée page shows §2, "The model": n equally spaced points on a circle, m of them forming a marked set S, each point holding a white or black ball. In each time step every ball moves one site counterclockwise, changing colour if it leaves a marked point. The paper calls it an artificial model like the Ehrenfests' wind-tree model. I could not read the full PDF (blocked) and did not see how the paper words the periodicity.
- The 1959 book, *Probability and Related Topics in Physical Sciences* (Interscience; Lectures in Applied Mathematics vol. 1), repeats the model. A Springer paper cites it at p. 99 *(secondary; pages not checked)*. Brown & Myrvold date the model to 1959, so they are citing the book. Cite the 1956 note as origin and the 1959 book as the fuller treatment. Gottwald & Oliver, "Boltzmann's Dilemma: An Introduction to Statistical Mechanics via the Kac Ring," *SIAM Rev.* **51**(3): 613–635 (2009), DOI 10.1137/070705799, is a good modern exposition.
- Deterministic and reversible: yes. The update is a fixed map; running it clockwise with the colour change on arrival inverts it (Wikipedia: "the system is time-reversible").
- Period: Wikipedia says "periodic, where the period is at most 2N." By direct argument: after N steps each ball has passed every mark once, so its colour is flipped by (−1)^M; after 2N steps every ball is back. So the period is 2N in general and N when M is even. Write "returns to its initial state after at most 2N steps (N if the number of marked sites is even)."

### 5. Lanford 1975 — VERIFIED
O. E. Lanford III, "Time evolution of large classical systems," in J. Moser (ed.), *Dynamical Systems, Theory and Applications*, Lecture Notes in Physics **38**, Springer, 1975, pp. 1–111. DOI 10.1007/3-540-07171-7_1 (Crossref: pp. 1–111). Gallagher–Saint-Raymond–Texier (arXiv:1208.5753) give the same reference and say the convergence time "is a fraction of the average time of first collision." The figure "about one fifth of the mean free time" is the usual secondary quotation; I did not find it in Lanford's own text. Write "for a fraction of the mean free time (about a fifth, in the usual estimate)".

### 6. Deng–Hani–Ma — VERIFIED
- arXiv:2408.07818, "Long time derivation of the Boltzmann equation from hard sphere dynamics," Y. Deng, Z. Hani, X. Ma (v1 14 Aug 2024; v3 18 Jul 2025; 192 pp.). Read the introduction and Theorem 1 in v3. Setting: hard spheres of diameter ε in **R^d**, d ≥ 2 (Definition 1.1: states in R^{2dN}), with random data from a grand canonical ensemble, in the Boltzmann–Grad scaling. Theorem 1: if the Boltzmann solution exists on [0, t_fin] with a Gaussian-weighted L^∞ bound, "Note that t_fin can be arbitrarily large," then for ε small the s-particle correlation functions converge to products of the Boltzmann solution, uniformly in t ∈ [0, t_fin] and s ≤ |log ε|. The abstract-level claim: the derivation "covers the full lifespan of the Boltzmann solution," from "any given initial data, which can also be arbitrarily large." The authors contrast Lanford and successors as "restricted to perturbative regimes, either under short-time or near-vacuum conditions or at the exact Maxwellian equilibrium."
- Status: the Annals of Mathematics page (annals.math.princeton.edu/articles/22284) lists it as accepted and forthcoming: received 2024-11-14, revised 2025-10-14, accepted 2025-10-31, "To appear in forthcoming issues," no volume or DOI at the time of the fetch.
- arXiv:2503.01800, "Hilbert's sixth problem: derivation of fluid equations via Boltzmann's kinetic theory," 48 pp., v1 only. The Boltzmann derivation is extended to the **periodic tori T^d, d = 2, 3** (Theorem 1); the compressible Euler equation (Theorem 3) and the incompressible Navier–Stokes–Fourier system near global equilibrium (Theorem 2) follow by combining it with existing hydrodynamic-limit results, in an iterated limit (first N → ∞, ε → 0 with Nε^{d−1} = α fixed, then α → ∞). No journal reference was listed on arXiv.
- Wording caution: say "resolves Hilbert's sixth problem as it pertains to the program of deriving fluid equations from Newton's laws via Boltzmann's theory," which is the authors' phrase, not "completes Hilbert's sixth problem".

### 7. Jaynes — VERIFIED
- E. T. Jaynes, "Gibbs vs Boltzmann Entropies," *Am. J. Phys.* **33**(5): 391–398 (1965). DOI 10.1119/1.1971557. Read from the OCR of the Jaynes archive scan.
- Setup: Gibbs H_G = ∫W_N log W_N; Boltzmann H_B = N∫w_1 log w_1, with w_1 the single-particle marginal. Theorem 1: the two satisfy the inequality S_G ≤ S_B (in his H notation the OCR is garbled; the proof uses log x ≤ x − 1 on the ratio of the product of marginals to W_N), "with equality if and only if W_N factors 'almost everywhere' into a product of single-particle functions."
- Abstract points: "(2) the Boltzmann H yields an 'entropy' that is in error by a nonnegligible amount whenever interparticle forces affect thermodynamic properties; ... (4) the Boltzmann H theorem does not constitute a demonstration of the second law for dilute gases; (5) the dynamical invariance of the Gibbs H gives a simple proof of the second law."
- Your phrasing "counts only single-particle marginals and ignores correlations" is accurate. Add that the discrepancy matters when interparticle forces matter.
- E. T. Jaynes, "Information Theory and Statistical Mechanics," *Phys. Rev.* **106**(4): 620–630 (1957). DOI 10.1103/PhysRev.106.620. Bibliographic data verified (Crossref).

### 8. Cover 1994; Villani 2002 — Cover VERIFIED; Villani details UNVERIFIABLE
- T. M. Cover, "Which processes satisfy the second law?", Chapter 5 in J. J. Halliwell, J. Pérez-Mercader & W. H. Zurek (eds.), *Physical Origins of Time Asymmetry*, Cambridge University Press, 1994, pp. 98–107. Read the author's PDF (10 pp., page headers 98 and 99, chapter number 5). The editors' names and year are from the book catalogue and memory; only Halliwell was seen confirmed.
- Theorem 4: for two distributions μ_n, μ'_n on a finite-state Markov chain, "D(μ_n‖μ'_n) is monotonically decreasing"; with μ the unique stationary distribution, D(μ_n‖μ) is monotonically non-increasing and tends to 0. Theorem 5: "H(X_n) ↑ for any initial distribution on X_0 if and only if the Markov transition matrix is doubly stochastic, i.e., if and only if the stationary distribution for the Markov chain is uniform." For a non-uniform stationary distribution, starting from the uniform distribution, the entropy must decrease at some time.
- Wording: "entropy need not rise unless the stationary distribution is uniform" should be "H(X_n) is non-decreasing for every initial distribution if and only if the stationary distribution is uniform." The result is for discrete-time, finite-state chains. Cover's own substitute statement: "relative entropy (of the current distribution with respect to the stationary distribution) decreases."
- C. Villani, "A review of mathematical topics in collisional kinetic theory," in S. Friedlander & D. Serre (eds.), *Handbook of Mathematical Fluid Dynamics*, vol. I, North-Holland, 2002. DOI 10.1016/S1874-5792(02)80004-0. Crossref gives pages 71–74 for this chapter record, which looks like a truncation; the chapter is usually cited as pp. 71–305 *(memory)*. I did not read the review, so that it treats the H-theorem for hard spheres is plausible (Villani's own lecture notes refer readers to it for the theory of the Boltzmann equation) but not checked.

---

## Free energy and exponential families in learning

### 9. Wainwright & Jordan — VERIFIED
M. J. Wainwright & M. I. Jordan, "Graphical Models, Exponential Families, and Variational Inference," *Foundations and Trends in Machine Learning* **1**(1–2): 1–305 (2008). DOI 10.1561/2200000001. Read from the Princeton course copy of the monograph.
- Proposition 2 (eq. 3.41a,b): A(θ) = log ∫ exp⟨θ, φ(x)⟩ ν(dx) has ∂A/∂θ_α = E_θ[φ_α(X)] and ∂²A/∂θ_α∂θ_β = cov{φ_α, φ_β}; "the full Hessian ∇²A(θ) is the covariance matrix of the random vector φ(X)." A is convex, strictly so for a minimal representation.
- Theorem 2 (§3.6): the conjugate dual A* satisfies A*(μ) = −H(p_{θ(μ)}) for μ in the interior M° of the marginal polytope, where θ(μ) is the unique canonical parameter with mean parameters μ. Qualify "conjugate dual = negative entropy" with "on the interior of the mean-parameter set".
- The numbering is that of the published monograph, which differs from the numbering you may remember.

### 10. Boltzmann machines, contrastive divergence, distillation — VERIFIED
- D. H. Ackley, G. E. Hinton & T. J. Sejnowski, "A learning algorithm for Boltzmann machines," *Cognitive Science* **9**(1): 147–169 (1985). DOI 10.1016/S0364-0213(85)80012-4. Read the Toronto PDF. They derive ∂G/∂w_ij = −(1/T)[p_ij − p′_ij], where G is the information gain (KL divergence) of the free-running distribution over the visible units relative to the clamped one, p_ij is the co-occurrence probability with the visible units clamped, and p′_ij is the co-occurrence probability when free-running. Their remark that "the probability of a hidden state given some visible state must be the same in equilibrium whether the visible units were clamped in that state or arrived there by free-running" is the step that gives a two-term rule.
- G. E. Hinton, "Training products of experts by minimizing contrastive divergence," *Neural Computation* **14**(8): 1771–1800 (2002). DOI 10.1162/089976602760128018. Bibliographic data verified.
- G. Hinton, O. Vinyals & J. Dean, "Distilling the Knowledge in a Neural Network," arXiv:1503.02531 (NIPS 2014 Deep Learning Workshop, per the arXiv comment). Eq. 1: q_i = exp(z_i/T)/Σ_j exp(z_j/T), "where T is a temperature that is normally set to 1. Using a higher value for T produces a softer probability distribution over classes." Note the title differs from the one you cited by describing the paper's actual subject.

### 11. Neal–Hinton; "Feynman–Bogoliubov" — CORRECTED (attribution)
- R. M. Neal & G. E. Hinton, "A view of the EM algorithm that justifies incremental, sparse, and other variants," in M. I. Jordan (ed.), *Learning in Graphical Models*, Kluwer, 1998, pp. 355–368. DOI 10.1007/978-94-011-5014-9_12 (Crossref). Read the author's PDF (technical report version, 1993). Abstract: "We present a function that resembles negative free energy and show that the M step maximizes this function with respect to the model parameters and the E step maximizes it with respect to the distribution over the unobserved variables." So the right statement is alternating (coordinate) *ascent* on F = −(variational free energy), equivalently descent on the free energy. The paper adds: "Apart from a change of sign, the function F is analogous to the 'variational free energy' of statistical physics," and F(P̃, θ) = −D(P̃‖P_θ) + L(θ).
- Neal & Hinton do not cite Feynman, Bogoliubov or Peierls. Their reference list begins with Csiszár & Tusnády (1984) on alternating minimisation and Dempster, Laird & Rubin (1977). Do not attribute the paper's free-energy view to a Feynman citation.
- The inequality F ≤ F_0 + ⟨H − H_0⟩_0 is usually called the **Gibbs–Bogoliubov** (or **Peierls–Bogoliubov**) inequality; "Gibbs–Bogoliubov–Feynman" occurs in the literature. "Feynman–Bogoliubov" is not a standard name. References: R. Peierls, "On a minimum property of the free energy," *Phys. Rev.* **54**(11): 918–919 (1938), DOI 10.1103/PhysRev.54.918 (Crossref-verified); N. N. Bogoliubov's reference (circa 1958) was not located; R. P. Feynman, *Statistical Mechanics: A Set of Lectures*, W. A. Benjamin, Reading MA, 1972 (the book exists and was reviewed in *Physics Today* 26(10), 1973; the section number was not checked). Secondary sources credit Gibbs with the classical form and Bogoliubov and Feynman with quantum extensions.

### 12. Yedidia–Freeman–Weiss; Mézard–Montanari — VERIFIED; the Stosszahlansatz link has no source
- J. S. Yedidia, W. T. Freeman & Y. Weiss, "Constructing free-energy approximations and generalized belief propagation algorithms," *IEEE Trans. Inf. Theory* **51**(7): 2282–2312 (2005). DOI 10.1109/TIT.2005.850085. Read the MERL technical report TR2004-040. Abstract: "We show that BP fixed points correspond to the stationary points of the Bethe approximation of the free energy for a factor graph." The text refines this: the stationary points of the constrained Bethe free energy with positive beliefs are BP fixed points, and conversely. BP is "exact when the factor graph is a tree, but only approximate when the factor graph has cycles."
- M. Mézard & A. Montanari, *Information, Physics, and Computation*, Oxford University Press, 2009. DOI 10.1093/acprof:oso/9780198570837.001.0001. Chapter 14 is "Belief propagation." I did not read the book. A cavity-method lecture-note source by Mézard and coauthors (Del Ferraro, Wang, Martí, Mézard, arXiv:1409.3048) states the assumption: "The RS cavity independent assumption postulates that, when removing a node i and its neighbor factor a ∈ ∂i, the partition function of the cavity system with fixed cavity variable ... can be factorized" into a product of single-message factors.
- **Comparison with the Stosszahlansatz: none found.** Searches of the web turned up no source that compares cavity or BP independence to the Stosszahlansatz or molecular chaos. I grepped the full text of Zdeborová & Krzakala (arXiv:1511.02476) and of arXiv:1409.3048 for "Stosszahl", "molecular chaos" and "Boltzmann equation": zero hits. The comparison is the page author's own, and should be signposted as such. The mathematical cousin in the kinetic literature is propagation of chaos (Kac), not a BP paper.

### 13. Hopfield; Amit–Gutfreund–Sompolinsky; Zdeborová–Krzakala — VERIFIED
- J. J. Hopfield, "Neural networks and physical systems with emergent collective computational abilities," *PNAS* **79**(8): 2554–2558 (1982). DOI 10.1073/pnas.79.8.2554.
- D. J. Amit, H. Gutfreund & H. Sompolinsky, "Storing infinite numbers of patterns in a spin-glass model of neural networks," *Phys. Rev. Lett.* **55**(14): 1530–1533 (1985). DOI 10.1103/PhysRevLett.55.1530. Read the scan (gwern copy): "For a > a_c = 0.138, there is no solution with m_0." Here α = p/N, so the capacity is about 0.138 N patterns. It is the **replica-symmetric** value. Later work revised it: Crisanti–Amit–Gutfreund (1986) reported 0.144 with one-step RSB, which Steffan & Kühn (1994) did not confirm (about 0.1382); a Monte Carlo estimate of 0.141 ± 0.0015 is by Stiefvater et al. (1996) *(secondary)*.
- L. Zdeborová & F. Krzakala, "Statistical physics of inference: thresholds and algorithms," *Adv. Phys.* **65**(5): 453–552 (2016). DOI 10.1080/00018732.2016.1211393; arXiv:1511.02476. Do not cite it for the 0.138 capacity: the paper mentions the Hopfield model only to contrast associative memory with inference of patterns from the couplings.

---

## Width, noise and temperature

### 14. Flat minima, sharp minima, Entropy-SGD, BIC, Occam factor — VERIFIED
- S. Hochreiter & J. Schmidhuber, "Flat minima," *Neural Computation* **9**(1): 1–42 (1997). DOI 10.1162/neco.1997.9.1.1.
- L. Dinh, R. Pascanu, S. Bengio & Y. Bengio, "Sharp minima can generalize for deep nets," arXiv:1703.04933; ICML 2017 *(venue and pages from memory: PMLR 70:1019–1028)*. Abstract: "most notions of flatness are problematic for deep models and can not be directly applied to explain generalization"; for rectifier networks one can "build equivalent models corresponding to arbitrarily sharper minima." §5: "if we are allowed to change the parametrization of some function f, we can obtain arbitrarily different geometries without affecting how the function evaluates on unseen data."
- P. Chaudhari, A. Choromanska, S. Soatto, Y. LeCun, C. Baldassi, C. Borgs, et al., "Entropy-SGD: Biasing gradient descent into wide valleys," arXiv:1611.01838; ICLR 2017 (arXiv comment: "ICLR '17"); journal version *J. Stat. Mech.* (2019) 124018, DOI 10.1088/1742-5468/ab39d9 (Crossref).
- G. Schwarz, "Estimating the dimension of a model," *Ann. Statist.* **6**(2): 461–464 (1978). DOI 10.1214/aos/1176344136.
- D. J. C. MacKay, *Information Theory, Inference, and Learning Algorithms*, Cambridge University Press, 2003. Chapter 28 is "Model Comparison and Occam's Razor" (checked in the online PDF); its section "The mechanism of the Bayesian razor: the evidence and the Occam factor" defines the Occam factor. An earlier chapter on parameter estimation points forward to it ("We will discuss Occam factors more in Chapter 28"). Page numbers were not extracted.

### 15. SGD noise — VERIFIED (caveat)
- S. Mandt, M. D. Hoffman & D. M. Blei, "Stochastic gradient descent as approximate Bayesian inference," *JMLR* **18**(134): 1–35 (2017) (arXiv journal-ref). arXiv:1704.04289.
- S. L. Smith & Q. V. Le, "A Bayesian perspective on generalization and stochastic gradient descent," ICLR 2018 (arXiv comment), arXiv:1710.06451. Abstract: "we identify the 'noise scale' g = ε(N/B − 1) ≈ εN/B, where ε is the learning rate, N the training set size and B the batch size." Your formulation is right. Caveat from their Appendix: "if the gradient covariances F(ω) were stationary and proportional to the identity, then the SGD would integrate an overdamped Langevin equation with temperature proportional to the SGD noise scale g. As t → ∞, the probability of sampling any particular parameter vector ω ... ∝ e^{−C/T}." Keep this conditional.
- S. Yaida, "Fluctuation-dissipation relations for stochastic gradient descent," ICLR 2019, arXiv:1810.00004. Abstract: the relations "hold exactly for any stationary state," so no equilibrium or Gibbs assumption is needed.
- M. Welling & Y. W. Teh, "Bayesian learning via stochastic gradient Langevin dynamics," ICML 2011, pp. 681–688 *(memory)*.

### 16. Einstein relation — VERIFIED
- A. Einstein, "Über die von der molekularkinetischen Theorie der Wärme geforderte Bewegung von in ruhenden Flüssigkeiten suspendierten Teilchen," *Ann. Phys.* **17** (= 322)(8): 549–560 (1905). DOI 10.1002/andp.19053220806.
- W. Sutherland, "A dynamical theory of diffusion for non-electrolytes and the molecular mass of albumin," *Phil. Mag.* (6) **9**(54): 781–785 (June 1905). DOI 10.1080/14786440509463331. The Einstein Papers Project note says Eq. (2) was "derived independently, in somewhat more general form, by Sutherland in 1905" *(secondary)*. A 1904 congress version (ANZAAS, Dunedin) had a misprint omitting Avogadro's constant *(secondary)*. The 1905 formulas are for Stokes friction: D = kT/(6πηa), which is the special case γ = 6πηa of D = kT/γ.
- R. Kubo, "The fluctuation-dissipation theorem," *Rep. Prog. Phys.* **29**(1): 255–284 (1966). DOI 10.1088/0034-4885/29/1/306.

---

## Sampling and annealing

### 17. Metropolis, Hastings, Kirkpatrick — VERIFIED
- N. Metropolis, A. W. Rosenbluth, M. N. Rosenbluth, A. H. Teller & E. Teller, *J. Chem. Phys.* **21**(6): 1087–1092 (1953). DOI 10.1063/1.1699114.
- W. K. Hastings, *Biometrika* **57**(1): 97–109 (1970). DOI 10.1093/biomet/57.1.97.
- S. Kirkpatrick, C. D. Gelatt Jr. & M. P. Vecchi, "Optimization by simulated annealing," *Science* **220**(4598): 671–680 (1983). DOI 10.1126/science.220.4598.671.

### 18. Jarzynski, Crooks, Neal — VERIFIED
- C. Jarzynski, "Nonequilibrium equality for free energy differences," *Phys. Rev. Lett.* **78**(14): 2690–2693 (1997). Companion: *Phys. Rev. E* **56**: 5018–5035 (1997).
- G. E. Crooks, *Phys. Rev. E* **60**(3): 2721–2726 (1999). DOI 10.1103/PhysRevE.60.2721.
- R. M. Neal, "Annealed importance sampling," *Statistics and Computing* **11**(2): 125–139 (2001). DOI 10.1023/A:1008923215028.
- **Neal does cite Jarzynski.** Read in the technical-report version (Univ. of Toronto Dept. of Statistics TR 9805, arXiv:physics/9803008v2): "In statistical physics, minus the log of the normalizing constant for a canonical distribution is known as the 'free energy,' and its estimation is a long-standing problem. In independent work, Jarzynski (1997a,b) has described a method primarily aimed at free energy estimation that is essentially the same as the annealed importance sampling method described here." The 2001 journal version was not read; check the sentence there before quoting it as the published text. The abstract of the report also says AIS is "related to thermodynamic integration methods for estimating ratios of normalizing constants."

### 19. IWAE, TVO, path sampling — VERIFIED
- Y. Burda, R. Grosse & R. Salakhutdinov, "Importance weighted autoencoders," arXiv:1509.00519; ICLR 2016 (the PDF reads "Under review as a conference paper at ICLR 2016"; the arXiv comment on v1 says ICLR 2015, which is out of date).
- V. Masrani, T. A. Le & F. Wood, "The thermodynamic variational objective," NeurIPS 2019 (the PDF reads "33rd Conference on Neural Information Processing Systems (NeurIPS 2019)"), arXiv:1907.00031. Abstract: "a key connection between variational inference and thermodynamic integration." Their statement: the ELBO "as a single-term left Riemann sum of the TVI"; the log evidence is a 1D integral of the "instantaneous ELBO" along a geometric path between the model and the inference network; the TVO is a multi-term left Riemann sum, a lower bound that tightens as terms are added; IWAE is the comparison point they say TVO is "an alternative to." They credit Neal and Gelman–Meng with bringing thermodynamic integration into statistics.
- A. Gelman & X.-L. Meng, "Simulating normalizing constants: from importance sampling to bridge sampling to path sampling," *Statistical Science* **13**(2): 163–185 (1998). DOI 10.1214/ss/1028905934.

### 20. Thermodynamic length; tempering as mirror descent — CORRECTED
- P. Salamon & R. S. Berry, "Thermodynamic length and dissipated availability," *Phys. Rev. Lett.* **51**(13): 1127–1130 (1983). G. E. Crooks, "Measuring thermodynamic length," *Phys. Rev. Lett.* **99**: 100602 (2007). D. A. Sivak & G. E. Crooks, "Thermodynamic metrics and optimal paths," *Phys. Rev. Lett.* **108**: 190602 (2012), arXiv:1201.4166. All bibliographic data verified by Crossref. Read the Sivak–Crooks arXiv text.
- What Sivak–Crooks derive: for control-parameter velocities that change slowly compared with the relaxation time of the force fluctuations, the excess power is a quadratic form in the velocity with the **friction tensor** ζ, the time integral of the force autocovariance (Kirkwood). Thermodynamic length L = ∫dt √P_ex(t), and "For a fixed control parameter path, the corresponding thermodynamic length is independent of the time interval Δt ... and places a lower bound on the excess work, W_ex ≥ L²/Δt. By the Cauchy–Schwarz inequality, this bound is only realized for a protocol with a constant excess power."
- The friction tensor is the Hadamard product of the integral relaxation-time matrix τ and the Fisher information matrix I, scaled by k_BT. Quote: "When the relaxation time does not vary with the control parameter, the Riemannian metric reduces to the Fisher information metric."
- Corrections to your wording: (i) the L²/Δt bound is a slow-driving (linear-response) result, with L measured in the friction metric; (ii) the metric equals the Fisher metric only when the relaxation time is constant over the path, and carries factors k_BT and τ, otherwise it is τ∘I.
- N. Chopin, F. R. Crucinio & A. Korba, "A connection between tempering and entropic mirror descent," arXiv:2310.11914; ICML 2024, PMLR **235**: 8782–8800. Exact claim (read in the arXiv full text): "algorithms which sample from the tempering sequence (such as SMC) can be seen as numerical approximations to entropic mirror descent applied to the KL divergence, i.e. a time-discretization of the KL gradient flow in the Fisher–Rao geometry," in parallel to the Jordan–Kinderlehrer–Otto / Wibisono result that Langevin is gradient flow of KL in Wasserstein-2. For F(μ) = KL(μ‖π) the update is μ_{n+1} ∝ μ_n^{1−γ_{n+1}} π^{γ_{n+1}} (their eq. 7), i.e. the geometric tempering path, with the tempering increments as step sizes. They get convergence rates for the tempering iterates (adapting Aubin-Frankowski et al.) and use the view to derive adaptive tempering rules. It does not claim SMC *is* mirror descent, only that tempering is a discretisation of it. Do not equate this Fisher–Rao view with Salamon–Berry's thermodynamic length without saying so: they are different geometries on the same path.

---

## Reversal and diffusion models

### 21. Reverse-time diffusion, score matching — VERIFIED
- B. D. O. Anderson, "Reverse-time diffusion equation models," *Stoch. Proc. Appl.* **12**(3): 313–326 (1982). DOI 10.1016/0304-4149(82)90051-5.
- J. Sohl-Dickstein, E. A. Weiss, N. Maheswaranathan & S. Ganguli, "Deep unsupervised learning using nonequilibrium thermodynamics," arXiv:1503.03585 (ICML 2015, PMLR 37 *(memory)*).
- J. Ho, A. Jain & P. Abbeel, "Denoising diffusion probabilistic models," arXiv:2006.11239 (NeurIPS 2020 *(memory)*).
- Y. Song, J. Sohl-Dickstein, D. P. Kingma, A. Kumar, S. Ermon & B. Poole, "Score-based generative modeling through stochastic differential equations," arXiv:2011.13456; ICLR 2021 (Oral) per the arXiv comment.
- A. Hyvärinen, "Estimation of non-normalized statistical models by score matching," *JMLR* **6**(24): 695–709 (2005) (jmlr.org).
- P. Vincent, "A connection between score matching and denoising autoencoders," *Neural Computation* **23**(7): 1661–1674 (2011). DOI 10.1162/NECO_a_00142.

### 22. Premkumar; Ikeda et al. — CORRECTED
- A. Premkumar, "Neural entropy," arXiv:2409.03817 (v3, 3 Nov 2025). The v3 PDF reads "39th Conference on Neural Information Processing Systems (NeurIPS 2025)" and the arXiv comment says "Camera-ready version from NeurIPS 2025." **It is NeurIPS 2025, not 2024.** Single author (Yale; work done at Chicago).
  - Exact content: the total entropy produced when p_d is diffused to p_eq is S_tot = (σ²/2)∫₀^T dt E_{p(·,t)}‖∂ₓ log p_eq − ∂ₓ log p‖² (Eq. 7), which equals a KL divergence between path measures of two SDEs (up to a vanishing boundary term). Eq. 11 *defines* the ideal neural entropy as Ŝ_NN := S_tot, "the information retained by the network under perfect training." The paper says a perfectly trained network "stores at least the same amount of information as we would learn from observing p_eq fluctuate to p_d," and that a well-trained diffusion model retains nearly all of it, S_NN ≈ S_tot; the training loss upper-bounds it (Eq. 17). Measured on a few small image diffusion models, the networks look "extremely efficient at compressing large ensembles of structured data."
  - Limits the paper states: it is not the entropy of the network's internal microstates; it applies to continuous diffusion models; real training is imperfect.
  - Safe wording: "Premkumar defines neural entropy as the entropy produced by the forward diffusion and argues a perfectly trained model must carry that much information; measured values suggest trained models come close." Do not say it is proved that every diffusion model must store exactly the entropy production.
- K. Ikeda, T. Uda, D. Okanohara & S. Ito, arXiv:2407.04495. **Published:** *Phys. Rev. X* **15**, 031031 (2025), DOI 10.1103/x5vj-8jq9 (arXiv journal-ref). **The title changed** from "Speed-accuracy trade-off for the diffusion models: wisdom from nonequilibrium thermodynamics and optimal transport" to "Speed-accuracy relations for diffusion models: Wisdom from nonequilibrium thermodynamics and optimal transport."
  - Exact claim (v6 text, Eq. 77), when the velocity field of the forward process is exactly reconstructed: (1/τ)(ΔW₁)²/D₀ ≤ ∫₀^τ dt T_t Ṡ_t^tot, where ΔW₁ is the change of the 1-Wasserstein distance between the true and estimated reverse processes, D₀ is the Pearson χ² divergence between their initial conditions, Ṡ^tot is the entropy production rate of the forward process and T_t the temperature (as printed in the arXiv text; I did not recompute dimensions). It is an upper bound on the *error* of data generation, with the speed given by the entropy production. The optimal protocol is the geodesic in the 2-Wasserstein space. It is analogous to the thermodynamic speed limit and thermodynamic uncertainty relation. It is not a claim about information storage. Do not conflate with Premkumar.

### 23. Langevin and KL — VERIFIED
- S. Vempala & A. Wibisono, "Rapid convergence of the unadjusted Langevin algorithm: isoperimetry suffices," NeurIPS 2019 (*Advances in NIPS* 32, pp. 8094–8106 *(page numbers from a search listing)*), arXiv:1903.08568. Read in full text. For the Langevin dynamics dX = −∇f dt + √2 dW with stationary law ν ∝ e^{−f}: Lemma 2: "d/dt H_ν(ρ_t) = −J_ν(ρ_t)," where H_ν is KL(ρ‖ν) and J_ν(ρ) = ∫ρ|∇log(ρ/ν)|² is the relative Fisher information. Theorem 4: if ν satisfies LSI with constant α, "H_ν(ρ_t) ≤ e^{−2αt} H_ν(ρ_0)," and W₂(ρ_t, ν) ≤ √(2/α · H_ν(ρ_0)) e^{−αt}. Their LSI normalisation is H_ν(ρ) ≤ J_ν(ρ)/(2α).
- F. Otto & C. Villani, "Generalization of an inequality by Talagrand and links with the logarithmic Sobolev inequality," *J. Funct. Anal.* **173**(2): 361–400 (2000). DOI 10.1006/jfan.1999.3557. Their result is that LSI implies Talagrand's transport inequality T₂; they also introduce the formal Riemannian (Otto calculus) picture in which the relative Fisher information is the squared norm of the gradient of KL. Vempala–Wibisono cite them for exactly that. The exponential-decay-under-LSI statement is the older Bakry–Émery / Gross circle of ideas *(memory)*, and the decay identity is a Fokker–Planck computation, so do not attribute either to Otto–Villani.
- Temperature-scaled identity (my derivation, not a quotation): for dX = −∇f dt + √(2T) dW with stationary law π ∝ e^{−f/T}, the Fokker–Planck equation is ∂ₜρ = T∇·(ρ∇log(ρ/π)), so d/dt KL(ρ_t‖π) = −T ∫ρ|∇log(ρ/π)|² = −T J_π(ρ_t). It reduces to the Vempala–Wibisono form at T = 1.

---

## Information as work

### 24. Esposito–Van den Broeck; Parrondo–Horowitz–Sagawa; Sagawa–Ueda — VERIFIED
- M. Esposito & C. Van den Broeck, "Second law and Landauer principle far from equilibrium," *EPL* **95**(4): 40004 (2011). DOI 10.1209/0295-5075/95/40004; arXiv:1104.5165. Read in full text (units k_B = 1). Eq. 11: "F(t) − F^eq(t) = T I(t) ≡ T D[ρ(t)‖ρ^eq(t)] ≥ 0." Eq. 7: "the work that can be derived, −W, is at most equal to the decrease in nonequilibrium free energy −ΔF." Eq. 2: W_irr ≡ W − ΔF^eq ≥ TΔI. So the most work obtainable from a nonequilibrium state ρ by relaxing it to equilibrium at the bath temperature is T·D(ρ‖ρ_eq). Here ρ_eq is the Gibbs state of the instantaneous Hamiltonian, and F^eq is its free energy.
- J. M. R. Parrondo, J. M. Horowitz & T. Sagawa, "Thermodynamics of information," *Nature Physics* **11**(2): 131–139 (2015). DOI 10.1038/nphys3230. Bibliographic data verified.
- T. Sagawa & M. Ueda, "Second law of thermodynamics with discrete quantum feedback control," *Phys. Rev. Lett.* **100**: 080403 (2008), arXiv:0710.0956. For an isothermal process with feedback: "W_ext ≤ −ΔF^S + k_BT I(ρ̂₁:X)" (the isothermal single-bath inequality, near the end of the paper). I is the QC-mutual information, "which reduces to the classical mutual information content in the case of classical measurement." The claim "work extracted with feedback is bounded by T × mutual information" is right only as "−ΔF + k_BT I": the free-energy term stays.

### 25. Vinkler–Permuter–Merhav; Kelly — CORRECTED (strength)
- D. A. Vinkler, H. H. Permuter & N. Merhav, "Analogy between gambling and measurement-based work extraction," *J. Stat. Mech.* (2016) 043403. DOI 10.1088/1742-5468/2016/04/043403 (Crossref); arXiv:1404.6788.
- J. L. Kelly Jr., "A new interpretation of information rate," *Bell Syst. Tech. J.* **35**(4): 917–926 (1956). DOI 10.1002/j.1538-7305.1956.tb03809.x. Also in *IRE Trans. Inf. Theory* **2**(3): 185–189.
- The paper's claim is an **analogy**: "to the best of our knowledge, no relation between gambling and information engines has been presented before. In this paper, we briefly review the two concepts and then demonstrate an analogy between gambling, where bits are converted into wealth, and information engines, where bits representing measurements are converted into energy." Mapping: measurements ↔ side information, control protocols ↔ betting strategies; the optimal protocol in the Szilard engine is "analogous to the Kelly strategy." The abstract opens with "mutual information characterizes the maximal gain in wealth growth rate due to knowledge of side information."
- Suggested wording: "Vinkler et al. show a formal analogy: the mutual information that sets Kelly's gain in wealth growth rate from side information also sets the maximum work a Szilard-type engine can extract from the same measurement." Avoid "Kelly's gain is Szilard work".

### 26. Callen; Zia–Redish–McKay; Maxwell — Zia and Maxwell VERIFIED; Callen UNVERIFIABLE in detail
- H. B. Callen, *Thermodynamics and an Introduction to Thermostatistics*, 2nd ed., Wiley, 1985. The 2nd edition exists (reviewed in *Am. J. Phys.* 1987; Crossref lists reviews, 55(9): 860–861 and 66(2): 164–167). I could not open the book. My recollection is that Legendre transformations are in chapter 5 ("Alternative formulations and Legendre transformations") and Maxwell relations in chapter 7, but I could not confirm any chapter number. Treat them as unchecked.
- R. K. P. Zia, E. F. Redish & S. R. McKay, "Making sense of the Legendre transform," *Am. J. Phys.* **77**(7): 614–622 (2009). DOI 10.1119/1.3119512. Bibliographic data verified.
- J. C. Maxwell, *Theory of Heat*, Longmans, Green, London, 1871 (first edition; later editions 1872 and after). Cambridge Core lists the reprint's Chapter IX, "Relations between the physical properties of a substance," pp. 163–171, as where the relations appear *(secondary; Wikipedia says 1872)*. Cite "Maxwell (1871)" with chapter IX, noting the edition. DOI of the Cambridge reprint: 10.1017/CBO9781139057943.

---

## Primary sources consulted

- Crossref API records for all DOIs and bibliographic searches above.
- arXiv API and full text: 2408.07818, 2503.01800, 1503.02531, 1703.04933, 1611.01838, 1710.06451, 1810.00004, 1509.00519, 1503.03585 (header), 1907.00031, 2310.11914, 2409.03817, 2407.04495, 1903.08568, 1104.5165, 0710.0956, 1404.6788, 1201.4166, 1208.5753, 1511.02476, 1409.3048, 0809.1304, 1905.07421, physics/9803008.
- Annals of Mathematics page: https://annals.math.princeton.edu/articles/22284
- Persée page for Kac 1956: https://www.persee.fr/doc/barb_0001-4141_1956_num_42_1_68352
- Cover 1994 PDF: https://cqi.inf.usi.ch/qic/94_Cover.pdf
- Jaynes 1965 scan (OCR): https://bayes.wustl.edu/etj/articles/gibbs.vs.boltzmann.pdf
- Ackley et al. 1985: https://www.cs.toronto.edu/~hinton/absps/cogscibm.pdf
- Neal & Hinton: https://www.cs.toronto.edu/~radford/ftp/emk.pdf
- Wainwright & Jordan: https://www.cs.princeton.edu/courses/archive/fall11/cos597C/reading/WainwrightJordan2008.pdf
- Yedidia et al., MERL TR2004-040: https://www.merl.com/publications/docs/TR2004-040.pdf
- Amit et al. 1985: https://gwern.net/doc/ai/nn/1985-amit.pdf
- MacKay's book: https://www.inference.org.uk/itprnn/book.pdf
- JMLR page for Hyvärinen 2005: https://jmlr.org/papers/v6/hyvarinen05a.html
