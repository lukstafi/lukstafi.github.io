# Citation check for *The Standard of Motion* and *The Demon Is a Learner*

31 Oct 2026. Synthesis of three agent reports, which hold the quotes, DOIs and URLs:

- `citecheck-essayA-2026-10-31.md` — physics and algebra (15 items)
- `citecheck-essayB-2026-10-31.md` — information and learning (19 items)
- `citecheck-wolfram-2026-10-31.md` — Wolfram model claims and freshness (8 items)

The outline (`standard-of-motion-essay-outline.md`) has been corrected to match. This file lists what changed in the argument, not every bibliographic fix.

## Changes to the argument

### Essay A

1. **The glider opening.** The glider moves at c/4 diagonally, period 4 (found by Richard Guy, 1969); Conway proved the caps c/2 orthogonal and c/4 diagonal. But engineered spaceships exist in every rational direction and at arbitrarily slow speeds (Gemini 2010, Sir Robin 2018; Simkin's caterloopillars reportedly reach any rational speed below c/4). So "Life allows only a few speeds" is false. What survives, and is the better point: each ship has one speed, and a structure with period p and displacement d moves at d/p, so dense speeds need unbounded period and size. No pattern has boosted twins; a slower ship is a different, larger machine. LifeWiki blocked automated access, so the caterloopillar claim must be rechecked by hand before quoting.
2. **Wolfram already says pure motion must be derived.** *On the Concept of Motion* (18 Mar 2022), "How Is It That Things Can Move?": "At the outset it's not obvious that any such features should exist at all, and that pure motion should ever be possible … in our Physics Project it's something one has to explicitly derive from the underlying structure of the model". He expects it from "rather general 'topological' features of hypergraph rewriting". So A§4 cannot present the demand as new. What is ours (the user's framing, 31 Oct): the passive/active distinction, the observation that the 2020 Technical Introduction supplies only the passive reading (§8.3 "motion: possible because of causal invariance; associated with change of causal foliations"; §8.6 tilted foliations), and the demand for a natural class of rules as the test.
3. **Gorard 2020 needs more than causal invariance:** global discrete hyperbolicity, flat hypersurfaces for the Lorentz step, constancy of c by definition of edge lengths, asymptotic dimensionality preservation, weak ergodicity, and a continuum limit; it yields the vacuum Einstein equations. Geodesic motion of a "persistent nonplanar tangle" is asserted, not derived.
4. **Mass in the Wolfram model** is the timelike flux of causal edges (events that reuse hypergraph elements), not "rest-frame energy". Energy is excess flux over the background that maintains space.
5. **Time dilation as a budget** is in *On the Nature of Time* (8 Oct 2024), not the 2020 texts.
6. **Rulial motion as costly translation:** *The Concept of the Ruliad* (2021, a maximum rate ρ), *Observer Theory* (2023), and most explicitly *What Ultimately Is There?* (4 Feb 2026): "The difficulty of translation depends … on how far one is trying to go in the ruliad."
7. **Freshness:** nothing on particles, inertia, Lorentz violation or a Newtonian limit from Wolfram or Gorard since 2024; Gorard's last Wolfram-model physics paper is from March 2023. No theorem found guaranteeing dense-velocity localized structures for any class of rules.
8. **Causal-set precedents strengthen A§4.** Dowker–Henson–Sorkin "swerves" (gr-qc/0311055): on a Lorentz-invariant discrete substrate, massive particles undergo Lorentz-invariant momentum diffusion, so the first law holds only on average; Kaloper–Mattingly (astro-ph/0607485) bound the diffusion constant below 10⁻⁶¹ GeV³. Also Johnston's propagators, Aslanbeigi–Saravani–Sorkin nonlocal d'Alembertians, Arrighi–Facchini–Forets exactly Lorentz-covariant "Clock" QCA (2014), Mlodinow–Brun (arXiv 2506.20136) lattice-spacing bounds from Lorentz-violation data.
9. **Bombelli–Henson–Sorkin, precisely:** the theorem is that no measurable Lorentz-equivariant map exists from sprinklings to timelike directions; the finite-valency statement is a corollary. Gorard (arXiv 2011.12174) claims compatibility, so A§4 must engage his reply rather than present the theorem as a refutation.
10. **Lorentz-violation bounds:** Abdo et al. 2009 give E_QG,1 > 1.2 E_Planck (the conservative case); Vasileiou et al. 2013, > 7.6 E_Planck; LHAASO (PRL 133, 2024) on GRB 221009A, > 10 E_Planck linear.
11. **Stability (A§2, companion):** Faddeev, "A mathematician's view of the development of physics" (1989 talk; reprint Publ. Math. IHÉS S88, 1998): both revolutions are "deformations from unstable structures into stable ones". He calls the *Lorentz* group stable; Poincaré is not (it deforms to (anti-)de Sitter). Mendes, "Deformations, stable theories and fundamental constants", J. Phys. A 27 (1994): the relativistic quantum algebra is itself unstable, and he proposes a two-parameter stabilizing deformation. Chryssomalakos–Okon 2004 verified.
12. **"Aristotelian" in Figueroa-O'Farrill & Prohazka** (JHEP 2019, arXiv 1809.01224) means kinematics without boosts: absolute space and time, rest preferred. It says nothing about Aristotle's dynamics; the companion can use it as the algebraic rung under Heller's A = T × S.
13. **Newton–Cartan:** Trautman 1970 is the gauge-field bundle paper. Cite Trautman 1963 (C. R. Acad. Sci. 257) or the 1965–66 lectures, or Cartan 1923–24 with Malament 2012.
14. **Heller and thermal time:** Heller, Pysiak and Sasin (2005) use Tomita–Takesaki state-dependent dynamics and cite Connes–Rovelli, but expect the state dependence to disappear in realistic models.
15. **GR's H ≈ 0** holds for closed universes; with asymptotic flatness the Hamiltonian is the ADM energy.

### Essay B

1. **Rovelli** says "approximation", in fluids with *quadratic* drag (v ∝ √(W/ρ); "What Aristotle does not have is only the square root"). Aristotle's F ∝ v as Heller writes it is the linear-drag (Stokes) case. "Overdamped" and "strong friction" are our glosses; the essay credits Rovelli only with the fluid approximation.
2. **SGD is not Gibbs on the loss.** Small-step SGD is first-order and overdamped, but its noise is anisotropic and position-dependent, so its stationary state is a nonequilibrium state on a different potential (Chaudhari & Soatto, ICLR 2018). Gibbs e^(−L/T) holds only for isotropic noise; Mandt et al. (JMLR 2017) get an Ornstein–Uhlenbeck stationary state for a quadratic loss. The Aristotelian claim stands on the drift.
3. **Momentum stays Aristotelian in the limit:** Kovachki & Stuart (JMLR 2021) show fixed-momentum methods reduce to rescaled gradient flow as the step size goes to zero. Nesterov's ODE (Su–Boyd–Candès) has vanishing friction 3/t, the opposite regime; mention it as the exception.
4. **Landauer from Liouville** has a source: Bennett 2003 (Stud. Hist. Phil. Mod. Phys. 34). The demon pays at erasure in Bennett 1982, not 1973 (which is about reversible Turing machines). Bérut 2012 reaches the bound only for slow erasure.
5. **Kolchinsky–Wolpert was backwards.** The minimal heat to produce any output is O(1). On input p the heat is kT ln 2 [ℓ(p) − K(output)] for the realization reversible on random input; the irreducible cost is K(input | output), what the computation forgets about its input. This fits B§2 better than the original claim.
6. **Information distance:** max{K(x|y), K(y|x)} is the conversion program length; K(x|y) + K(y|x) is the minimum number of irreversible bit operations; the proposed thermodynamic cost is the antisymmetric K(x|y) − K(y|x) in units of kT ln 2.
7. **The logarithmic bound** is K(x_t) ≤ K(x_0) + K(dynamics) + K(t) + O(1); cite Ebtekar & Hutter, "Foundations of algorithmic thermodynamics" (Phys. Rev. E 2025, arXiv 2308.06927), Corollaries 3–4.
8. **Baez–Stay:** energy is log runtime and volume is length; Ω is the partition function at β = 0, γ = ln 2. Ω at temperature with length as energy is Calude–Stay 2006 and Tadaki 2008 (arXiv 0801.4194); Tadaki 2002 has D as a compression rate.
9. **Zurek 1989** verified (S = H + K of the record); the demon cannot win *on average*.
10. **Goldt–Seifert's** bound concerns the weights as physical degrees of freedom, not hardware dissipation.
11. **New source close to the thesis:** Boyd, Crutchfield & Gu, New J. Phys. 24 (2022) 083040: choosing the agent that extracts the most work is maximum-likelihood model selection. B§4 should lead with it.

## Addendum: LifeWiki "List of spaceships" (checked by hand, 31 Oct)

The user saved the page to `notes/private/List of spaceships - LifeWiki.html` (oldid 173798, last edited 30 June 2026). Rows are coloured by kind: from an asymmetric soup, from a symmetric soup, elementary, engineered, adjustable.

- **Glider:** c/4 diagonal, discovered by Richard K. Guy; the page gives **1970**, not 1969 as the essay-A report said.
- **Speeds that arise from random soups** (the closest Life has to "nature"): asymmetric soup, c/2 orthogonal (lightweight spaceship), c/7 orthogonal (loafer) and c/4 diagonal (glider); symmetric soup also gives 2c/5, c/3 and c/10 orthogonal. Six speeds in all.
- **Elementary ships** (not built from interacting parts) add a handful more: 3c/7, 2c/7, c/4, c/5, c/6 orthogonal; c/5, c/6, c/7, c/8, c/12 diagonal; Sir Robin (2,1)c/6.
- **Every other listed speed is engineered or adjustable.** The adjustable families, Simkin's caterloopillars (2016; forum thread "Caterloopillar WIP (all speeds < c/4)"), the Demonoids and the Gemini family, are designs whose speed is a construction parameter. The page lists the instances actually built (e.g. caterloopillars from 5c/21 down to c/87, 63k–915k cells). The "all speeds < c/4" claim is the thread title; the page itself lists only built instances.
- **For the essay:** the adjustable families are the nearest thing Life has to boosted twins, and they still are not boosts. Changing speed means building a different pattern from a recipe, not moving the same body differently. And what arises unaided from random initial conditions moves at six speeds. This sharpens A§0 and A§4: in Life, motion at a given speed is natural only at a few speeds and engineered everywhere else.

## Still unverified

Added 31 Oct with the qualitative-theory material, then checked the same day (`citecheck-qualitative-2026-10-31.md`; corrections applied to the essay and companion): Andronov & Pontryagin 1937 ("Grubye sistemy", Doklady); Peixoto 1962 (Topology 1; structurally stable flows on compact orientable surfaces = Morse–Smale); Smale 1961 ("On gradient dynamical systems", Ann. Math. 74); Palis & Smale 1970 ("Structural stability theorems", Proc. Symp. Pure Math. 14); KAM persistence statement; and for essay B, Tikhonov 1952, Fenichel 1979, Łojasiewicz 1963, Polyak 1963.

Earlier items:

Isham's page range; Faddeev's 1990 proceedings pages; Lévy-Leblond's 1965 Carroll paper; Penrose as an earlier user of "Aristotelian spacetime"; a closed-form Frenkel–Kontorova barrier; the Li–Vitányi section for E_P K = H(P) + O(K(P)); LHAASO arXiv v3 (Feb 2026) numbers; LifeWiki claims (now checked; see the addendum).
