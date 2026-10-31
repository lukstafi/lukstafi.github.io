# Review: *The Standard of Motion* and its mathematics companion

31 Oct 2026. Checked against Heller 2006 (all 15 pages), the three citecheck reports, the synthesis with its LifeWiki addendum, the saved LifeWiki page (`notes/private/List of spaceships - LifeWiki.html`, oldid 173798), arXiv abstracts (LHAASO, Kaloper–Mattingly, Dowker–Henson–Sorkin, Bisio et al., Bombelli–Henson–Sorkin), and the outline. The essay files were not edited. "E" means the essay (`notes/the-standard-of-motion.md`) and "C" the companion (`notes/the-standard-of-motion-mathematics.md`).

**Verified and fine:** every Heller quotation is verbatim. That covers "standard of motion", "suitably interpreted geometry…", "A body, non acted upon by any force, remains in the absolute rest", "full democracy", "misinterpreted his own first law…", "Now, it is acceleration that is absolute" and "a logic inherent in the evolutionary chain…" (from the abstract). The groupoid composition and convolution formula in C §1 match Heller p. 127–128. Rovelli, Faddeev, Bisio et al., the BHS corollary, the Wolfram 2020 §8.3, 2022, 2021 and 2024 quotes, the LHAASO "> 10 E_Pl, linear, 95% CL" figure, Kaloper–Mattingly's 10⁻⁶¹ GeV³, and the LifeWiki numbers (c/87 caterloopillar min. population 62,343; 5c/21 915,290; Simkin 2016; six soup speeds, with c/3 marked "semi-natural" from a D4 symmetric soup) all match their sources. In C, the Moyal bracket, Liouville/entropy, Carroll rescaling (K′ = c²K), the 3.3 table, the so(4)/so(3,1) sign (t > 0 gives so(4) with {L,L} = +εL), the Newton–Cartan ingredients, the BHS statement and the CA counting argument (Fact 2) are correct. Sign conventions agree across C §2, §3.1–3.3 and §4. Every URL resolves (HTTP 200) except LifeWiki, AIP and PNAS, which return 403 to scripts; CrossRef already confirmed those DOIs. The DOI with parentheses (Braun–Kivshar) renders correctly in the HTML.

---

## Severity 1: errors to fix

### 1. False physics: unaccelerated bodies do not have parallel velocities
**E, Newton paragraph:** "Two distant bodies moving without acceleration have parallel velocities, whatever frame one uses."
**Problem:** Two free bodies can move in different directions at different speeds. Heller's sentence (p. 122, "their velocities should be represented by two parallel vectors") is loose, but his point is that velocities at distant points can be *compared*: whether they are parallel is frame-independent.
**Fix:** "Whether two distant bodies have the same velocity is a fact, whatever frame one uses: velocities at distant points can be compared." Or: "Two distant bodies moving without acceleration keep a fixed relative velocity, whatever frame one uses."

### 2. Galilei-to-Lorentz deformation conflates the homogeneous and inhomogeneous algebras
**E, Faddeev paragraph:** "The Galilei algebra is not stable: the brackets {K_i, K_j}, zero in Newton's world, can be switched on as a small multiple of a rotation. Lorentz's algebra is that deformation with parameter 1/c², and, being semisimple, it is stable."
**E, contraction paragraph:** "The boosts commute with each other and the Lorentz algebra goes over to the Galilei algebra."
**Problem:** In the full Galilei algebra (with H and P), switching on [K_i, K_j] ∝ ε_ijk J_k alone breaks the Jacobi identity for (K, K, P): [[K_i,K_j],P_k] ≠ 0 while the other two terms vanish because [K,P] = 0. You must also switch on [K_i, P_j] ∝ δ_ij H, and the result is Poincaré, which is not semisimple and not stable (as the next paragraph says). Only the *homogeneous* algebra (rotations and boosts) has the single deformation to so(3,1). C §4 states this correctly. E's paragraph therefore contradicts its own next paragraph ("The Poincaré algebra … still deforms"). In the same way, the contraction c → ∞ takes Poincaré to Galilei, or Lorentz to homogeneous Galilei, not Lorentz to Galilei.
**Fix:** "The algebra of rotations and Galilean boosts is not stable: the bracket {K_i, K_j}, zero in Newton's world, can be switched on as a small multiple of a rotation. The Lorentz algebra is that deformation with parameter −1/c², and, being semisimple, it is stable." In the contraction paragraph: "the Poincaré algebra goes over to the Galilei algebra."

### 3. Not every principal bundle with a connection is parallelizable
**C §1, General relativity:** "But a principal bundle P → X with a connection is parallelizable."
**Problem:** False in general. A connection splits TP into a vertical part, which the fundamental vector fields trivialize, and a horizontal part ≅ π*TX, which need not be trivial. The frame bundle is special because its solder (canonical) form θ trivializes the horizontal part. The next sentence uses exactly that, so the fix is local.
**Fix:** "But the frame bundle of a manifold with a linear connection is parallelizable." It would also help to note that for Heller's Lorentz frame bundle the count is 4 + 6 = 10 = dim (θ plus an so(3,1)-valued ω), alongside the GL(n) count n + n².

### 4. The product in F(F(·)) is generic, not a GR rung
**E, Einstein paragraph:** "Heller then observes that a curved space-time with a connection makes the frame bundle itself parallelizable…"
**E, table:** "Newton with gravity | … | nowhere on these two levels"; "General relativity | … | the frame bundle of the frame bundle"
**C §1:** "This is Heller's observation that the product reappears two levels up."
**Problem:** F(F(X)) is a product for *every* manifold with a linear connection, flat or curved. That includes Newton–Cartan space-time (C §1 gives it a torsion-free ∇), and flat Newtonian and Minkowski space-time too. Heller's own reason (p. 125: "the frame bundle over space-time has a linear connection") applies to Newton with gravity word for word. So the table's asymmetry between rows 3 and 5 is an artifact of stopping at two levels, and "curved" in E is idle. E's gloss ("the product reappearing one level up is the trace of what stays absolute after each step") leans on that asymmetry. The attribution to Heller is accurate, but the ladder is weaker than presented.
**Fix:** In E, drop "curved" ("a space-time with a connection makes…"). In C, add one sentence: "The same holds for Newton–Cartan space-time, which also has a linear connection; Heller's ladder stops at the first level where a product appears." Optionally make the table's row 3 read "the frame bundle of the frame bundle, as in GR; absolute time remains", or soften the gloss.

### 5. "Not a product" needs the connection: frame bundles are often topologically trivial
**C §1, Newton–Cartan:** "F(N) has no global flat section: F(N) ≠ N × G." **C §1, GR:** "M is curved, so F(M) is not a product." **E:** "The frame bundle acquires curvature and stops being a product"; "General relativity curves space-time, so that frame bundle is no longer a product."
**Problem:** As principal bundles, these usually *are* products. N ≅ ℝ⁴ is contractible, so F(N) is trivial. By Geroch (1968), every noncompact space-time with a spin structure is parallelizable, so F(M) is trivial too. What fails is a product *compatible with the connection*: no global parallel frame field, nontrivial holonomy. C's own "Frame bundles" paragraph ("A principal bundle with a global section is trivial") invites the topological reading. Heller makes the same conflation, but the companion is where it should be stated exactly.
**Fix (C):** "Because ∇ is curved, its holonomy is nontrivial and there is no global parallel frame field, so F(N) is not a product *as a bundle with connection* (topologically it still is, since N ≅ ℝ⁴)." Make the same change in the GR paragraph. E can keep its wording, or add "a product along which frames are parallel" once.

### 6. Liouville: non-merging does not imply constant entropy
**E, "One bracket" section:** "Hamiltonian flow preserves phase-space volume; that is Liouville's theorem. Two different initial conditions never merge, so the entropy −∫ρ ln ρ of an evolving density stays constant."
**Problem:** Trajectories of *any* smooth flow never merge in finite time, dissipative ones included (a damped oscillator, for example), yet their densities lose differential entropy. Constant entropy follows from volume preservation (unit Jacobian), as C §2 says. The "so" draws it from the wrong premise.
**Fix:** "Liouville's theorem says that Hamiltonian flow preserves phase-space volume. A density is carried along without being compressed or spread, so its entropy −∫ρ ln ρ stays constant."

### 7. "Any such theorem can be only approximate" contradicts "the question is open"
**E, "The obstacle":** "Any such theorem can be only approximate. … Gorard has argued that his construction is compatible with the theorem…, so the question is open, not settled against him."
**Problem:** BHS is about Lorentz-equivariant maps on Poisson sprinklings. Applying it to a deterministic rewriting causal graph takes an extra step that Gorard disputes. The paragraph first asserts the conclusion flatly and then calls it open.
**Fix:** "Any such theorem may have to be approximate." Or: "Bombelli, Henson and Sorkin give a reason to expect that any such theorem will be approximate."

### 8. Bisio et al. are not "the deformed rung Faddeev's and Mendes's criterion predicts"
**E, Precedents:** "That is the deformed rung Faddeev's and Mendes's criterion predicts." Also **E, end of algebra section:** "it predicts a further rung with a fundamental length".
**Problem:** Mendes's stabilized algebra is a *Lie-algebra* deformation (isomorphic, per his abstract, to the algebra of a pseudo-Euclidean group in five dimensions). Bisio et al. have a *nonlinear* representation of the Lorentz/Poincaré group of DSR type, with de Sitter SO(1,4) for the massive walk, and it depends on a choice of function f. These are different structures. "Faddeev's and Mendes's criterion" is also not a joint criterion: Faddeev states it and Mendes applies it. "Predicts" overstates what a stability heuristic gives.
**Fix:** "It is a deformation of the kind Faddeev's criterion points to, though a nonlinear one, not Mendes's Lie-algebra deformation." In the algebra section: "…and it points to a further rung, with a fundamental length…"

### 9. "The geometry has been derived" and the Gorard sentence overstate
**E, closing:** "The geometry has been derived. The standard of motion has not."
**E, Wolfram section:** "Jonathan Gorard proved that causal invariance acts as a discrete general covariance, from which he derived a discrete Lorentz covariance and, with further assumptions, the vacuum Einstein equations".
**Problem:** The Einstein result is conditional on a continuum limit existing, plus asymptotic dimensionality preservation, weak ergodicity and global discrete hyperbolicity. The Lorentz step already needs flat hypersurfaces and a constant c fixed by the definition of edge lengths (citecheck-wolfram §8). The closing states it flatly.
**Fix:** In the closing, "The geometry has a derivation, under assumptions. The standard of motion has none." In the Gorard sentence, move "with further assumptions" so that it covers both steps: "from which, with further assumptions, he derived a discrete Lorentz covariance and the vacuum Einstein equations."

### 10. The caterloopillar "any rational speed" claim is cited to a page that does not make it
**E ¶2:** "a design called the caterloopillar can be tuned to reportedly any rational speed below c/4 ([LifeWiki, "List of spaceships"])". **C §5:** "reportedly reach every rational orthogonal speed below c/4; … (LifeWiki, "List of spaceships", revision of 30 June 2026)".
**Problem:** The addendum notes that the "List of spaceships" page lists only built instances. The "all speeds < c/4" phrase is the title of the forum thread in its footnotes (Simkin, April 2016). E also drops "orthogonal", and the caterloopillars are orthogonal only. In E, "reportedly" sits awkwardly inside the verb phrase.
**Fix:** In E, "can reportedly be tuned to any rational orthogonal speed below c/4". Cite the LifeWiki *Caterloopillar* article (https://conwaylife.com/wiki/Caterloopillar), or name the forum thread, for the "any speed" claim, and keep the list page for the cell counts. C can add "(forum thread 'Caterloopillar WIP (all speeds < c/4)')".

---

## Severity 2: attribution and quotation

### 11. "Wolfram's reply would be…" credits him with an argument he did not make
**E:** "**Wolfram's reply** would be that observers like us are what make motion possible. … The persistence of observers then selects the regions of rule space where motion works."
**Problem:** The house rule is to credit people only with what they said. The quoted Ruliad sentence supports "pure motion is consistent with how things work for us". The "selects regions of rule space" step is an extrapolation, but it reads as his. Wolfram did say something close, which can anchor the paragraph. In *On the Concept of Motion* (2022) he writes that "pure motion is in a sense an operational consequence not necessarily of an actual continuum world, but of a continuum perception of the world by an embedded observer like us."
**Fix:** Open with the 2022 quote ("Wolfram locates pure motion in the observer: …"). Then mark the selection step as the author's reading: "On this view, the persistence of observers would select…".

### 12. "Stephen Wolfram agrees that motion has to be earned" implies the author came first
**E:** The demand is stated first ("Newton's first law needs more…"), then "Stephen Wolfram agrees".
**Problem:** The synthesis (item 2) says the essay cannot present the demand as new. Wolfram said it in 2022. "Agrees" makes him a follower.
**Fix:** "Stephen Wolfram has said that motion has to be earned." Keep the passive/active distinction and the "natural class" test marked as the author's ("I call this…", "So the test is…"), as now.

### 13. "Heller reads this table as…"
**E, after the table:** "Heller reads this table as 'a logic inherent in the evolutionary chain…'. Each new first law makes relative something that was absolute, and some structure that was a fact about the world becomes a fact about the relations between viewpoints. My gloss is…"
**Problem:** Heller has figures, not a table. The middle sentence is not in Heller, but it sits between a Heller quote and "My gloss", so it reads as his.
**Fix:** "Heller reads this sequence as '…'." Then mark the middle sentence as the author's, e.g. begin the gloss there: "As I read it, each new first law makes relative something that was absolute. …"

### 14. Source of "we know less about the specifics of how particles work"
**E:** "Wolfram has written that 'we know less about the specifics of how particles work.'"
**Problem:** The quote is from *On the Concept of Motion* (2022). The nearest preceding citation is Wolfram 2024, so readers will date it 2024.
**Fix:** "Wolfram wrote in 2022 that…", or link the 2022 essay.

### 15. Ruliad quote: "this" has no referent, and the paraphrase is firmer than the source
**E:** "he writes that 'it turns out again to be consistent to view this as how things work for us': we are made of different atoms of space in different places, and still keep the same identity."
**Problem:** In Wolfram, "this" refers to "pure motion" in the preceding sentence, which E omits. He also writes "we can still imagine that in some sense we maintain the 'same identity'", which is weaker than "still keep".
**Fix:** Quote the lead-in: "At the outset, it's not obvious that there can be 'pure motion' … But it turns out again to be consistent to view this as how things work for us". Paraphrase the rest as "we can still imagine that we keep the same identity".

### 16. Wolfram's energy omits the background
**E:** "Energy is the flux of causal edges through moments of time".
**Problem:** Wolfram says energy is the flux's *excess* over the background that maintains space (synthesis item 4; 2020 announcement: "fluctuations of that flux around its background value").
**Fix:** "Energy is the flux of causal edges through moments of time, beyond the background flux that maintains space".

### 17. Mendes: "needs" two constants
**E:** "stabilizing it needs two new constants, a fundamental length and a curvature".
**Problem:** His abstract says the algebra "admits a two-parameter stabilizing deformation". The names ℓ and 1/R come from his later summary (arXiv 1111.5576), as C correctly says.
**Fix:** "and that it admits a stabilizing deformation with two new constants, which he later identified as a fundamental length and a curvature".

### 18. Heller "fixes" the geometry
**E, intro and section title:** "Michał Heller has argued that this first law fixes the geometry of space and time."
**Problem:** Heller says the first law "contains information of the space-time structure", and only "in many physical theories", when free motions are set by geometry. The body of E reports this correctly ("Heller adds that in many theories…").
**Fix (optional):** In the intro, "Heller has argued that this first law carries the geometry of space and time." The section title can stay as the author's claim.

### 19. Minor attributions
- **E, Faddeev paragraph:** "being semisimple, it is stable" is Chryssomalakos–Okon's wording. Faddeev says "the Lorentz group is stable". This is acceptable because the phrase is unquoted, but the semisimplicity reason is not Faddeev's.
- **E:** "Relic neutrinos bound the diffusion constant below 10⁻⁶¹ GeV³." Kaloper–Mattingly call it an estimate, for neutrino masses above 0.01 eV. Add "for neutrino masses above 0.01 eV", or "an estimated bound".

---

## Severity 3: claims stronger than the argument, and physics nits

### 20. The CA counting argument is stretched to all rewriting universes
**E:** "Whatever carries motion in a rewriting universe cannot be a small periodic pattern, as the glider is."
**Problem:** C §5 proves the fact for a cellular automaton: a fixed lattice, finitely many cell states and a uniform background. A hypergraph with a random-looking background has no fixed lattice, no translation by (d_x, d_y), and no finite set of configurations of a box unless the background is periodic. The conclusion is plausible, but it is not what C proves.
**Fix:** "In a cellular automaton, whatever carries a dense range of speeds cannot be a family of small periodic patterns. A rewriting universe with a regular background faces the same count." Or say in C §5 which assumptions are used.

### 21. "Time is the causal graph"
**E:** "Space is the large-scale structure of the hypergraph. Time is the causal graph of rewriting events".
**Problem:** The causal graph is space-time, or causal structure, not time. Foliations of it give time.
**Fix:** "Causal structure is the causal graph of rewriting events: …"

### 22. A Peierls–Nabarro barrier is not friction by itself
**E:** "the first law holds up to an exponentially small friction against the lattice's rest frame".
**Problem:** The PN potential is periodic and conservative. Drag comes from radiating phonons (citecheck-essayA §10(c), cite Braun–Kivshar). The image survives, but the mechanism is the barrier plus radiation.
**Fix:** "…holds up to an exponentially small barrier, and the drag of radiating into the lattice, against its rest frame".

### 23. The transformations carrying free motions to free motions form a larger group
**E:** "Its symmetry group is the set of transformations that carry free motions to free motions: rotations, translations in space and time, and changes of velocity".
**Problem:** Maps that take straight world lines to straight world lines include scalings and shears (locally the projective group). The Galilei and Poincaré groups also preserve the metric structures: lengths, durations, intervals.
**Fix:** "…carry free motions to free motions while keeping lengths and durations (in relativity, intervals)". Or leave it, as a simplification few readers would trip on.

### 24. Small items in C
- **§3.2:** "its realization on the phase space of a free particle is impossible". Say "by phase-space functions, for m ≠ 0". The group still acts symplectically.
- **§5:** The definition of a spaceship should require (d_x, d_y) ≠ (0, 0).
- **§1, Newton without gravity:** "The structure group is the Galileo group". On frames at a point it is the *homogeneous* Galilei group (rotations and boosts), since translations do not act on frames. Heller writes "Galileo group", so add "(homogeneous)".
- **Subtitle:** It omits §2 (the bracket, Moyal, Liouville, the problem of time) and §6 (BHS). Consider "…stability, moving patterns, and the Bombelli–Henson–Sorkin theorem".

---

## Severity 4: style (AGENTS.md)

- **E, intro roadmap order.** "I follow his argument first, then show that the first law also fixes an algebra, …, and that the steps … can be read as limits and deformations of that algebra. Hamiltonian mechanics adds a second thing…" The essay now puts the Hamiltonian section *before* the algebra section, so the roadmap is out of order. The sentence also makes three moves. The Aristotle-to-Newton step is an enlargement, not a limit or deformation, as the body itself says. Fix: split it, and order it as bracket, then algebra ("…can be read as an enlargement followed by deformations").
- **E, "Logic" sentence after the table.** "Each new first law makes relative something that was absolute, and some structure that was a fact about the world becomes a fact about the relations between viewpoints." Two moves; see also #13.
- **E, "The steps of Heller's ladder show up in this algebra, read in reverse."** "Read in reverse" is unanchored: the next sentences go forward (Aristotle to Newton enlarges), and only the contraction runs backward. Fix: "The steps of Heller's ladder show up in this algebra as enlargements and deformations."
- **E, "Read through the theme of this essay, a body's inertia is written into the algebra of its free motions."** A dangling modifier: inertia is not reading. Fix: "In this essay's terms, a body's inertia is written into…"
- **E, "free evolution".** The essay uses "free" for force-free motion, then "free evolution loses no information" for closed Hamiltonian evolution, which includes forces. In physics, "free evolution" usually means no interaction. Fix: "closed-system evolution" or "evolution of an isolated system". The intro's "a second thing that comes free" can keep the pun.
- **E, "General relativity strains this frame."** "Frame" collides with reference frames, used throughout. Fix: "this framework".
- **E, chained or non-parallel semicolons.**
  - "Hamiltonian flow preserves phase-space volume; that is Liouville's theorem." Fixed by #6.
  - "…instead of the Lorentz algebra; stability selects a semisimple algebra, and experiment selects the sign". Split into two sentences.
  - "It may be true; persistence does need carriers of motion." Use "It may be true, since persistence does need carriers of motion." Or use two sentences.
- **E, "Faddeev's criterion gives Heller's '…' an engine, and it predicts a further rung…"** Two moves; split them, and see #8.
- **E, Precedents: "Discrete models of motion have paid for relativity in one of two ways."** Three paragraphs later: "Quantum cellular automata give a third pattern". Fix: "in one of three ways", or "in two ways, and a third has appeared".
- **E, "companion essay" vs "companion page".** E calls the mathematics page the "companion page" and *The Demon Is a Learner* the "companion essay". Readers will mix them up. Fix: "The next essay, *The Demon Is a Learner*, …"
- **E, "a knot of non-planarity".** "Knot" suggests knot theory. Wolfram writes "lump of nonplanarity" and Gorard "nonplanar tangle". Use "tangle".
- **E ¶1, "after passing through four shapes on the way".** The glider has four phases, so it passes through three other shapes before it reappears. Fix: "cycling through four shapes".
- **E, "A deterministic rewriting rule sits between these cases. It is discrete like a lattice, and if its causal graph has a preferred slicing, its particles should feel Aristotelian friction."** Two moves; split after "lattice".
- **C §3.3, "In units where the brackets above read as follows, …"** Unanchored: there are no units here. Fix: "Writing the brackets of §3.1 abstractly (P for p, J for L), the kinematical algebras connected by contraction differ in three brackets…"
- **E, "The c/87 caterloopillar has 62,343 cells".** LifeWiki's column is "Min. population", which varies by phase. "Has at least 62,343 live cells" is exact; the current wording is acceptable.
