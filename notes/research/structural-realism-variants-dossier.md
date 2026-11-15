# Dossier: structural realism, its variants and its rivals

Status: research pass, 14 Nov 2026, for the planned essay on ontic structural realism (the one that follows the mindedness essay). Nothing here is essay prose. No essay is drafted. On 15 Nov the author answered all twelve open questions; the answers are under "Answers so far" in §8. Where §1.5, §5.5, §6.2 or §6.3 differ from those answers, the answers govern. The main changes: causation is primitive at bases and modality belongs to descriptions; no base is singled out; the plan is now two essays, with Alter in the second.

Scope: the variants of structural realism; the standing objections; the alternatives; Torin Alter's structure-and-dynamics argument; the blog's two reality criteria; what a change of foundation would cost. It supersedes `ontic_structural_realism_progress-GPT6_Pro.md` as the source of record: Appendix A checks that report's leads one by one.

## Evidence labels

Every claim about a source carries one of these.

- **[P]** read in the primary text during this pass. The text was opened (PDF, HTML, or an open-access copy) and the passage read; a quotation or a location is given.
- **[P\*]** opened, but the quotation came back through a summarizing fetch and was not checked against the raw text. Recheck the wording before quoting.
- **[A]** abstract or publisher page only. The work exists as cited; what it argues is known only from its abstract.
- **[C]** citation only. The bibliographic record was confirmed; nothing of the content was read.
- **[S: source]** second-hand: reported by the named source (SEP, a review, another paper), which was read.
- **[I]** inferred: this dossier's own reasoning, not a claim found in a source.
- **[U]** unverified: from memory, or from the GPT report, and not confirmed in this pass.

A DOI or URL follows each source. "Crossref" after a citation means the bibliographic data (title, journal, volume, pages, date) was checked against the Crossref record for that DOI. Appendix B says who did the reading and which quotations were rechecked.

SEP-SR = Ladyman's SEP entry "Structural Realism"; SEP-RM = Alter and Pereboom's SEP entry "Russellian Monism"; F&V = Frigg and Votsis 2011. Full references are at first use in §1 and §3.3.

## Legend for the blog's essays

CCI = *Causation, Computation, Indexicality*; GRAIN = *The Grain of the Hard Problem*; P&A = *Presence and Actuality*; MbD = *Minds by Degrees* v2; MON = *Is the Monastery Minded?*; v1 = `theory-overhaul-proposal.md`; v2 = `theory-overhaul-proposal-v2.md`; AUDIT = `overhaul-proposal-audit.md`; IITFW = `iit-free-will-intrinsic-powers.md`; OUTLINE = `mindedness-essay-outline.md`. Numbers after a colon are line numbers in the `.md` source.

ETMG = Ladyman and Ross, with Spurrett and Collier, *Every Thing Must Go* (OUP, 2007). RP volume = Millhouse, Petersen and Ross (eds.), *Dennett's Real Patterns in Science and Nature* (MIT Press, 2026).

---

## 0. What the blog is committed to now

These are the claims the essay has to defend, modify, or give up. All are [P] in the blog's own files.

1. **Structuralism without natures.** "Ontic structuralism holds that relata are individuated by the relations they stand in, with no natures beneath them" (GRAIN:85). "On a structuralist reading there are no categorical natures beneath structure for experience to draw on" (P&A:123). The only source cited for this is ETMG and the SEP entry (GRAIN:209).
2. **The morphism criterion.** "A pattern is genuinely realised in a physical system when the realization relation is such a morphism", that is, a structure-preserving map that keeps "the modal and counterfactual structure of the higher-level description in the lower-level dynamics" (CCI:35). It was introduced against Putnam's triviality argument: "A computation is real in a physical system when and only when the grounding relation is structure-preserving" (CCI:43). The dust man fails it because his mapping is "an arbitrary lookup table" (CCI:39).
3. **The intervention criterion.** "A coarse variable earns reality when interventions and interactions repeatedly respect it" (GRAIN:125, quoting the interlocutor Thomas, and applied at GRAIN:131 to fix the grain of experience). Coarse-grainings are "relative to families of interactions, not to observers" (GRAIN:125).
4. **Identification suffices for existence.** "Correctly identifying a pattern in reality already establishes its existence" (P&A:85).
5. **No added productive power.** Real patterns cause "in the ordinary sense", but the causation "does not add productive power to the generative primitive" (CCI:45). Against Merricks: "The redundancy is then between two descriptions of one causal pattern rather than between two causes" (P&A:93).
6. **A generative base.** CCI has four layers, and Layer 0 is a generative principle to which causation is primitive (CCI:11, CCI:51). Claim 5 leans on it. This sits uneasily with "no privileged micro level"; §6 returns to it.
7. **Mental kinds as structure.** "The mental kinds are the structural invariants of successful psychology"; success is "our *evidence* for the kind, not what constitutes it" (MbD:39, MbD:43). The mindedness outline restates this as: a mental state exists where the mechanism runs, and the intervention criterion decides whether the mechanism's parts are real (OUTLINE §1).
8. **Actuality: an account withdrawn.** CCI held that actuality is indexical: "Without a mind … there is no fact of the matter whether a universe is real or merely mathematical"; the gap between physics and mathematics "is purely indexical — contributed by the representer" (CCI:77–79). P&A withdraws this: "I withdraw the account of indexical actuality without proposing another account of actuality as a separate ontological status. The questions concern what exists, how it is organized, and what measure it has" (P&A:117). P&A also moves from "an abstract algorithmic organization across its realizations" to "concrete organized occurrences" (P&A:119), and names its new direction as "finitude and constructibility: an infinite reality containing finite concrete occurrences" (P&A:121). CCI's "description is not generation" (CCI:15) still stands. §2.3 takes these up.
9. **Against IIT's dichotomy.** IIT offers intrinsic powers or a "substrate+" ontology with micro primacy. The blog claims a third option: real patterns at many grains with no privileged level (IITFW §2). The supporting step, "which grain does the causing is settled the interventionist way: by proportionality to the question", is marked inferred there.

The unreconciled item, N6: v1:151 proposed one criterion, "A pattern is real when interventions identify it up to a symmetry, and any remaining symmetry is broken by the system's own dynamics rather than by the observer's choice", with Zhou and Klindt's identifiability result as the model case (v1:153). AUDIT:96 objected that the morphism and intervention criteria "are different kinds of criterion: one is about which coarse variables are real, the other about which computations a physical system realizes." v2:276 deferred the matter to this essay. §5 below takes it up.

---

## 1. The variants and what separates them

Two sources serve as the spine and were read in the primary text:

- Ladyman, "Structural Realism", *Stanford Encyclopedia of Philosophy*, first published 2007, revised 18 May 2023, <https://plato.stanford.edu/entries/structural-realism/> [P, §§2–5]. Cited as SEP-SR.
- Frigg and Votsis, "Everything You Always Wanted to Know about Structural Realism but Were Afraid to Ask", *European Journal for Philosophy of Science* 1 (2011): 227–276, [doi:10.1007/s13194-011-0025-7](https://doi.org/10.1007/s13194-011-0025-7), open copy <https://nul.repository.guildhe.ac.uk/id/eprint/457/1/Frigg_Votsis_Everything.PDF> [P, §§3.3–3.4, 4.1–4.2]. Cited as F&V.

### 1.1 Epistemic structural realism

- Worrall, "Structural Realism: The Best of Both Worlds?", *Dialectica* 43 (1989): 99–124, [doi:10.1111/j.1746-8361.1989.tb00933.x](https://doi.org/10.1111/j.1746-8361.1989.tb00933.x) [P, course-site scan].
  - The argument keeps the no-miracles argument and concedes the pessimistic induction by restricting commitment to what survives theory change. On Fresnel to Maxwell: "There was continuity or accumulation in the shift, but the continuity is one of form or structure, not of content" (p. 117).
  - "Fresnel completely misidentified the nature of light, but nonetheless it is no miracle that his theory enjoyed the empirical predictive success that it did" (p. 117).
- SEP-SR §3 grades the epistemic view by what it says we cannot know: the individuals; the individuals and their intrinsic properties; or anything but "the second-order structure of their relational properties". The third grade is the Ramsey-sentence version, and it is the one Newman's problem hits (§2.2). [P]
- SEP-SR §4 notes that Worrall's paper "is not explicitly epistemic". His sentence "what Newton really discovered are the relationships between phenomena" invites the ontic reading. [P]
- Neighbours of the epistemic view: Langton's *Kantian Humility* (OUP, 1998), [doi:10.1093/0199243174.001.0001](https://doi.org/10.1093/0199243174.001.0001), and Lewis's "Ramseyan Humility" (2009), [doi:10.7551/mitpress/7507.003.0012](https://doi.org/10.7551/mitpress/7507.003.0012) [S: SEP-SR §3.1; neither opened]. These matter in §3.3, since the Russellian monist accepts the humility and fills the unknown with quiddities.

MbD:37 uses the Worrall argument for psychology: "what survives succession is, characteristically, *structure*". That passage commits the blog only to the epistemic argument. The ontic claim comes from GRAIN:85.

### 1.2 Ontic structural realism, eliminative and moderate

**Defining texts.**

- Ladyman, "What Is Structural Realism?", *Studies in History and Philosophy of Science* 29 (1998): 409–424, [doi:10.1016/S0039-3681(98)80129-5](https://doi.org/10.1016/S0039-3681%2898%2980129-5). Not opened. [S: SEP-SR §§3.2, 4] Ramsey-sentence realism "picks out exactly the same entities as the original theory", so structural realism "should be thought of as metaphysically rather than merely epistemically revisionary", with success explained by "the representation of modal relations among phenomena".
- French and Ladyman, "Remodelling Structural Realism: Quantum Physics and the Metaphysics of Structure", *Synthese* 136 (2003): 31–56, [doi:10.1023/A:1024156116636](https://doi.org/10.1023/A:1024156116636) [A]: "by reconceptualising objects in structural terms it offers the best hope for the realist in the context of modern physics."
- ETMG, [doi:10.1093/acprof:oso/9780199276196.001.0001](https://doi.org/10.1093/acprof:oso/9780199276196.001.0001) [C]. **The book was not opened in this pass. Every ETMG quotation in this dossier is second-hand and needs checking against the book before the essay quotes it.**
  - "There are no things. Structure is all there is" and the view that "the world has an objective modal structure that is ontologically fundamental, in the sense of not supervening on the intrinsic properties of a set of individuals" (p. 130). [S: Konstantinou, course handout, <https://sites.pitt.edu/~jdnorton/teaching/Phil_Sci_Core/Phil_Sci_Core_2022/handouts/Konstantinou%20Structural%20Realism%20Handout.pdf>]
  - Things are "locally focused abstractions from modal structure" (p. 153). [S: same handout]
  - The sentence the GPT report relies on, that treating relata as abstractions from relations "does not imply that there are no relata; rather the opposite", is [U]. It is remembered as ch. 3, around pp. 154–155, and was not found quoted anywhere reachable. Ladyman's own later gloss does the same work: "The relata of a given relation always turn out to be relational structures themselves on further analysis" [P: SEP-SR §4].
- French, *The Structure of the World: Metaphysics and Representation* (OUP, 2014), [doi:10.1093/acprof:oso/9780199684847.001.0001](https://doi.org/10.1093/acprof:oso/9780199684847.001.0001). Not opened. The view "maintains that the fundamental ontology of the world is one of structures and that objects, as commonly conceived, are at best derivative, at worst eliminable" (2014, v) [S: McKenzie 2024, p. 5]. Structure is laws and symmetries, presented group-theoretically [S: Ney's review, *Notre Dame Philosophical Reviews*, 9 Dec 2014, <https://ndpr.nd.edu/reviews/the-structure-of-the-world-metaphysics-and-representation/>, P*].

**How the field is carved.** SEP-SR §4 lists seven theses "advocated by some defenders of OSR at some time" [P]:

1. Eliminativism: there are no individuals, only relational structure (French).
2. There are relations that do not supervene on the intrinsic and spatiotemporal properties of their relata (entanglement).
3. Individual objects have no intrinsic natures.
4. There are individual objects, and they have no irreducibly intrinsic properties (Esfeld 2004).
5. Facts about identity and diversity depend on relational structure (Saunders; Ladyman and Ross; Stachel).
6. There are no self-subsistent objects; relational structure is what subsists.
7. Individual objects are constructs: "Ladyman and Ross (2007) argue that objects are pragmatic devices used by agents to orient themselves in regions of spacetime, and to construct approximate representations of the world."

F&V §4.1 sort the same field as radical (structure with no carriers and extensional relations: "In the eyes of most if not all commentators ROSR is downright unintelligible", p. 261), eliminative (French, Ladyman: relations with intensions, objects as places in a structure), attenuated eliminative (objects that are not individuals), moderate (Esfeld) and intermediate (Lyre). [P]

**The eliminative pole.** French, "Defending Eliminative Structuralism and a Whole Lot More (or Less)", *Studies in History and Philosophy of Science* 74 (2019): 22–29, [doi:10.1016/j.shpsa.2018.12.007](https://doi.org/10.1016/j.shpsa.2018.12.007), accepted manuscript <https://eprints.whiterose.ac.uk/145549/3/Defending%20eliminative%20structuralism.pdf> [P]. Objects "at both the fundamental and 'everyday' levels, should be eliminated" (abstract). The moderate view's thin objects "are not so much 'thin' as utterly empty, at least from a metaphysical perspective" (ms p. 13). Object-talk is a "heuristic device, or a form of 'Wittgenstein's ladder'" (ms p. 11).

**The moderate pole.**

- Esfeld, "Quantum Entanglement and a Metaphysics of Relations", *Studies in History and Philosophy of Modern Physics* 35 (2004): 601–617, [doi:10.1016/j.shpsb.2004.04.008](https://doi.org/10.1016/j.shpsb.2004.04.008) [S: SEP-SR §4]. He accepts that "relations require relata" and denies that "these relata must have intrinsic properties over and above the relations in which they stand".
- Esfeld and Lam, "Moderate Structural Realism about Space-Time", *Synthese* 160 (2008): 27–46, [doi:10.1007/s11229-006-9076-2](https://doi.org/10.1007/s11229-006-9076-2) [A]: "objects and relations (structure) are on the same ontological footing, with the objects being characterized only by the relations in which they stand."
- Esfeld and Lam, "Ontic Structural Realism as a Metaphysics of Objects", in Bokulich and Bokulich (eds.), *Scientific Structuralism* (Springer, 2011), 143–159, [doi:10.1007/978-90-481-9597-8_8](https://doi.org/10.1007/978-90-481-9597-8_8) [A]: fundamental objects "do not have any existence – and in particular not any identity – independently of the structure they are part of".
- Ainsworth, "What Is Ontic Structural Realism?", *Studies in History and Philosophy of Modern Physics* 41 (2010): 50–57, [doi:10.1016/j.shpsb.2009.11.001](https://doi.org/10.1016/j.shpsb.2009.11.001) [S: SEP-SR §4 and a search-relayed abstract]. Three versions by what is primitive: relations only; objects and relations; properties and relations. He argues that physics undermines the first two.

**Where Ladyman and Ross sit.** Critics read them both ways. "Ladyman and Ross are clear that their position is a form of eliminative OSR, endorsing the thesis that 'there are only relations, and no relata' (e.g. pp. 151–152). As we shall see, however, they sometimes appear to endorse non-eliminative OSR." [P] Chakravartty, "Ontological Priority: The Conceptual Basis of Non-eliminative, Ontic Structural Realism", in Landry and Rickles (eds.), *Structural Realism* (Springer, 2012), 187–206, n. 3, [doi:10.1007/978-94-007-2579-9_10](https://doi.org/10.1007/978-94-007-2579-9_10), <https://anjanchakravartty.com/wp-content/uploads/2017/06/landry-rickles-book.pdf>. SEP-SR places them under theses 5 and 7. The essay should say that the book's slogan is eliminative and its worked position is not, and cite the pages (130 against 151–155) after checking them. [I]

GRAIN:85's wording, "relata are individuated by the relations they stand in, with no natures beneath them", is thesis 3 or 4 with thesis 5. It is the moderate position, close to Esfeld 2004, and not French's. [I]

**What separates the variants.** [I, from the above]

| Axis | Options | Who |
|---|---|---|
| Do objects exist? | no; yes but derivative; yes, on a par with relations | French; Ladyman and Ross; Esfeld and Lam |
| Is the priority asymmetric? | relations first; neither first | French, Ladyman; Esfeld and Lam |
| May relata have intrinsic properties? | none; none irreducibly; some | theses 3, 4; Chakravartty's semirealism |
| Scope | fundamental physics only; every science at its scale | French, Esfeld; Ladyman and Ross |
| What the modality is | primitive modal structure; causal powers; Humean summary | Ladyman, French; Esfeld 2009; Lyre, later Esfeld |
| Is there a fundamental level? | yes (structure is it); no | French, Esfeld; Ladyman and Ross |

One flag for whoever cites Esfeld: SEP-SR §4 says "Esfeld (2009) develops a Humean take on structural realism", but the only Esfeld 2009 in its bibliography is "The Modal Nature of Structures in Ontic Structural Realism", *International Studies in the Philosophy of Science* 23 (2009): 179–194, [doi:10.1080/02698590903006917](https://doi.org/10.1080/02698590903006917), whose abstract says "the fundamental physical structures possess a causal essence, being powers" [A]. The Humean turn is Esfeld 2014 (§3.2). This looks like a slip in the SEP.

### 1.3 Effective structural realism

- Ladyman and Lorenzetti, "Effective Ontic Structural Realism", *British Journal for the Philosophy of Science*, [doi:10.1086/729061](https://doi.org/10.1086/729061). Crossref: online 13 Dec 2023, no volume or pages assigned; the journal's own page lists volume 78 (2027). Cite as online-first. [A]: "This paper argues for the unification of these proposals based on realism about modal structure and the idea of scale relativity of ontology developed by ontic structural realists." The proposals unified are realism about the common core of quantum interpretations (Fraser and Vickers), realism about effective quantum field theories (Williams; Fraser), and realism about what superseded theories got right (Robertson and Wilson).
- The authors' summary for a general reader: "structural realism provides an ontology for effective realists"; "real patterns are entities that feature (non-redundantly) in projectable regularities". [P*] Ladyman and Lorenzetti, "What Do Newtonian Forces Have to Do with the Standard Model?", BJPS Short Reads, <https://www.thebsps.org/short-reads/standard-model-ladyman-lorenzetti/>.
- Williams, "Scientific Realism Made Effective", *BJPS* 70 (2019): 209–237, [doi:10.1093/bjps/axx043](https://doi.org/10.1093/bjps/axx043) (Crossref). Read in the dissertation chapter of the same title, <https://academiccommons.columbia.edu/doi/10.7916/D85T3T72/download> [P for the chapter; the journal version was not opened]. Criterion, after Wimsatt: "one should include in one's ontology those entities, properties, or relationships which are robust". Payoff: "the 'higher-level' entities to which the theory does justify ontological commitment are precisely those that are likely to be preserved in the face of future theory change". Williams does not call this structural realism.
- SEP-SR §4.4: "in all of science except perhaps the ultimate physics, ontology is required only to be 'effective'"; "if there is not, or might not be, a fundamental level of reality, nor ultimate individuals of which everything else is made, then all real patterns are on a par." [P]

This is the variant closest to the blog's claims: scope set to every scale, and the fundamentality claim dropped instead of asserted of structure. [I]

### 1.4 Real patterns and rainforest realism

**Dennett.** "Real Patterns", *Journal of Philosophy* 88 (1991): 27–51, [doi:10.2307/2027085](https://doi.org/10.2307/2027085) [P, scanned copy with journal pagination].

- The criterion: "A pattern exists in some data—is real—if there is a description of the data that is more efficient than the bit map, whether or not anyone can concoct it" (p. 34).
- The link to observers is admitted: "in the root case a pattern is 'by definition' a candidate for pattern recognition. (It is this loose but unbreakable link to observers or perspectives, of course, that makes 'pattern' an attractive term…)" (pp. 31–32).
- Noise: "our interests often favor a somewhat different goal: transmitting inexact copies that nevertheless preserve 'the' pattern that is important to us" (p. 35).
- Rival patterns: "If Jones sees pattern α (with n% noise) and Brown sees pattern β (with m% noise) there may be no ground for determining that one of them is right and the other wrong." Both bet on the next datum; "If both patterns are real, they will both get rich" (pp. 35–36).
- The trade-off between compactness and noise is settled by "design decisions … incorporated into the design of our sense organs by genetic evolution, and into our culture by cultural evolution" (p. 36).
- On the label: "is the view I am defending here a sort of instrumentalism or a sort of realism? I think that the view itself is clearer than either of the labels" (p. 51).

So Dennett's text supplies both halves of the observer-relativity charge. Whether a compressing description exists does not depend on observers. Which decomposition into pattern and noise one adopts depends on interests and resources. His test that both are real is that both bettors get rich. It is a success test and does not select one pattern. [I]

**Ross and ETMG.** Ross, "Rainforest Realism: A Dennettian Theory of Existence", in Ross, Brook and Thompson (eds.), *Dennett's Philosophy: A Comprehensive Assessment* (MIT Press, 2000), 147–168, [doi:10.7551/mitpress/2335.003.0010](https://doi.org/10.7551/mitpress/2335.003.0010). Not reached [C].

ETMG ch. 4, "Rainforest Realism and the Unity of Science", pp. 190–257, [doi:10.1093/acprof:oso/9780199276196.003.0004](https://doi.org/10.1093/acprof:oso/9780199276196.003.0004) [C]. Not reached. The following are verbatim as quoted in McAllister's 2026 chapter, which was read:

- The definition (ETMG p. 233): a pattern is real just if "(i) it is projectible; and (ii) it has a model that carries information about at least one pattern P in an encoding that has logical depth less than the bit-map encoding of P, and where P … is not projectible by a physically possible device computing information about another real pattern of lower logical depth than [the candidate pattern]." McAllister reads this as three criteria: projectibility, economical encoding, non-redundancy. [S: McAllister 2026, p. 146]
- "A pattern, to be real, must be projectible from a perspective that physics tells us could be physically occupied" (ETMG p. 236). [S: same]
- "We want to associate the distinction between projectible and non-projectible patterns with the distinction between what's real and what isn't" (ETMG p. 228). [S: same, p. 147]
- Ladyman and Ross wanted to block two things Dennett allowed: an explosion in the number of real patterns, and relativity to an observer's noise tolerance (ETMG p. 206). [S: same, p. 146]
- The Primacy of Physics Constraint (ETMG p. 44): "Special science hypotheses that conflict with fundamental physics, or such consensus as there is in fundamental physics, should be rejected for that reason alone. Fundamental physical hypotheses are not symmetrically hostage to the conclusions of the special sciences". [S: Ladyman, "Structural Realism and the Relationship between the Special Sciences and Physics", *Philosophy of Science* 75 (2008): 744–755, pp. 745–746, [doi:10.1086/594520](https://doi.org/10.1086/594520), P]
- Why the definition uses Bennett's logical depth in place of description length could not be checked. [U]

Ladyman's later glosses, read in the primary text:

- "Real patterns are entities of whatever ontological category that feature non-redundantly in projectable regularities"; "The precise definition of real patterns is a matter of debate"; "All agree that real patterns must be projectable in the sense of supporting prediction and explanation and hence modal." [P: SEP-SR §4.4]
- "Ontology is scale-relative, in the sense that different energy levels and regimes, as well as different length and time scales, feature different emergent structures of causation and law, and that we should not assume that there is a fundamental level". [P: SEP-SR]

**The RP volume.** Millhouse, Petersen and Ross (eds.), *Dennett's Real Patterns in Science and Nature* (MIT Press, 2026), [doi:10.7551/mitpress/15550.001.0001](https://doi.org/10.7551/mitpress/15550.001.0001). ISBN 9780262052030 (paperback), 9780262052047 (PDF). Open access under CC BY-NC-ND. Crossref dates it 31 March 2026; a retailer lists 28 April. [P: copyright page bound into the Leiden copy of ch. 7; Crossref] The publisher's open-access site refused automated requests, so most chapters were not read. The user can open them in a browser.

| Ch. | Author | Title | Pages | Label |
|---|---|---|---|---|
| 1 | Millhouse, Petersen, Ross | An Introduction to Real Patterns | 1–32 | [C] |
| 2 | Dennett | Real Patterns (reprint) | 33–58 | [P, 1991 text] |
| 3 | Ladyman | Patterns All the Way Up: Prolegomena to a Future Naturalized Metaphysics | 59–76 | [C] |
| 4 | Petersen | Abstractions by Patterns | 77–92 | [C] |
| 5 | Millhouse | The Problem of Platonic Codes | 93–112 | [C] |
| 6 | Carroll, Parola | What Emergence Can Possibly Mean | 113–136 | [P, preprint] |
| 7 | McAllister | Is Any Pattern Nonreal? | 137–154 | [P] |
| 8 | Wallace | Real Patterns in Physics and Beyond | 155–176 | [A] |
| 9 | Hermida | Disinterested Taxonomic Pluralism: Biological Classifications Track Real Patterns | 177–196 | [C] |
| 10 | Alexseev, Harrison, Lau, Ross | Deciphering the Noise: Real Patterns in Welfare from Incentivized Choice | 197–234 | [C] |
| 11 | Kincaid, Nefdt | Real Patterns Analysis and Causality Neutrality | 235–256 | [C] |
| 12 | Cao | The Scientist in the Machine | 257–280 | [C] |

Titles, authors and pages are from Crossref chapter records 10.7551/mitpress/15550.003.0002–0016. Chapter numbers other than 7 are inferred from the order. There is no chapter by Woodward. That chapter 12 is the one on neural networks is inferred from the blurb.

- **Ch. 7, McAllister** is the volume's case against every criterion; see §2.5. [P: publisher's version, <https://hdl.handle.net/1887/4300798>]
- **Ch. 6, Carroll and Parola.** A taxonomy of emergence. The weakest type is a many-to-one map from micro to macro that commutes with time evolution: "exhibiting efficacious dynamical laws even when microscopic information is discarded… This is the essence of a real pattern." They split local emergence by whether the map itself is compressible. "It is crucial that we coarse-grain in the right way; throwing away arbitrary subsets of the micro data would leave us completely unable to make reliable predictions." [P: preprint, [arXiv:2410.15468](https://arxiv.org/abs/2410.15468), which says it was submitted to this volume] Their weakest type is the morphism criterion of §5, and their split by compressibility of the map is Millhouse's variable.
- **Ch. 8, Wallace.** Real patterns "provide part but not all of the answer" to how ontologies at different scales relate; the rest is "the structural-realist idea that ontology in general is secondary to (mathematically-presented) structure". [A: abstract of the preprint, PhilSci-Archive 23307]
- **Ch. 3, Ladyman.** Not read. A preprint snippet says "the idea of real patterns implicitly involves scale-relativity, because the ontology of gliders and eaters is only applicable when more than a few cells over a few iterations is considered" [S: search snippet of PhilSci-Archive 24008]. The GPT report's claims about this chapter (triangulation; modal organization between domains; no single hierarchy) are [U].
- **Ch. 11, Kincaid and Nefdt.** Not read. A snippet says the authors argue that the insights of a faithful real-patterns analysis are "causality neutral" [S: search snippet]. If so, this chapter bears directly on §5: it would say that real-pattern status does not wait on causal or interventionist structure.

**Millhouse.** Three papers move the weight from the compressed description to the mapping. All [A].

- "A Simplicity Criterion for Physical Computation", *BJPS* 70 (2019): 153–178, [doi:10.1093/bjps/axx046](https://doi.org/10.1093/bjps/axx046) [A]. Quoted in §5.2.
- "Compressibility and the Reality of Patterns", *Philosophy of Science* 88 (2021): 22–43, [doi:10.1086/710027](https://doi.org/10.1086/710027) (Crossref). Dennett "interprets high-level models as compressed representations of the fine-grained behavior of their target system… Unfortunately, data scientific practice complicates Dennett's interpretation, undermining the traditional justification for real patterns and suggesting a revised research program". Ladyman's gloss: he "argues that compressibility is not apt for capturing real patterns that are coarse-grained with respect to the underlying ontology" [P: SEP-SR].
- "Really Real Patterns", *Australasian Journal of Philosophy* 100 (2022): 664–678, [doi:10.1080/00048402.2021.1941153](https://doi.org/10.1080/00048402.2021.1941153) (Crossref; online 28 June 2021). "I propose an alternative criterion of pattern instantiation, one that assesses the difficultly [sic] of faithfully interpreting a physical system as instantiating a particular pattern. Drawing on formal measures of simplicity and similarity, I argue that, for well-instantiated patterns, our interpretation will be computable by using a short program." A press summary: "the more complex the interpretation required, the less real the pattern is likely to be" [S: Santa Fe Institute research brief, <https://www.santafe.edu/news-center/news/research-brief-really-real-patterns>].

**Other work on the criterion.**

- Suñé and Martínez, "Real Patterns and Indispensability", *Synthese* 198 (2021): 4315–4330, [doi:10.1007/s11229-019-02343-1](https://doi.org/10.1007/s11229-019-02343-1) [A]: a criterion "from the notion of conditional Kolmogorov complexity" that "successfully enforces a non-redundancy principle, suggested by Ladyman and Ross… and which their own account fails to enforce."
- Petersen, "Composition as Pattern", *Philosophical Studies* 176 (2019): 1119–1139, [doi:10.1007/s11098-018-1050-6](https://doi.org/10.1007/s11098-018-1050-6) [A]: "some things compose a whole whenever together they form a 'real pattern'". This answers the Special Composition Question that P&A:87 raises.
- Wallace's formulation: "A macro-object is a pattern, and the existence of a pattern as a real thing depends on the usefulness—in particular, the explanatory power and predictive reliability—of theories which admit that pattern in their ontology." [P] Wallace, "Decoherence and Ontology", [arXiv:1111.2189](https://arxiv.org/abs/1111.2189). That *The Emergent Multiverse* (OUP, 2012, [doi:10.1093/acprof:oso/9780199546961.001.0001](https://doi.org/10.1093/acprof:oso/9780199546961.001.0001)), ch. 2, repeats it verbatim is [U].
- Ladyman and Nefdt, "Are AI Language Models Scientific Models of Language?", *European Journal for Philosophy of Science* 16 (2026), article 63, [doi:10.1007/s13194-026-00770-9](https://doi.org/10.1007/s13194-026-00770-9), open access [P]. "Modal structure is understood as a general term that subsumes causal structure, mechanisms, nomological structure, probabilistic and statistical structures and so on." Models "can be taken to represent modal structure accurately in so far as they are projectible". The notion is graded "from the most minimal sense in which data models can encode projectible regularities in measureable quantities, to the thick sense of representation of a causal mechanism in great detail." And: "In causal modelling successful intervention and manipulation of target systems is taken to be indicative of the model representing causal structure." This is the most recent statement by Ladyman of how projectibility, modal structure and intervention relate. On it, the intervention criterion sits at the thick end of a scale whose thin end is bare projectibility. [I]

### 1.5 Where the blog stands on this map

[I] The blog's claims in §0 pick out a position that no single author holds as stated:

- Moderate on objects (GRAIN:85), like Esfeld 2004.
- Scale-general and without a privileged micro level, like Ladyman and Ross and like effective structural realism.
- Causal at the base (CCI:11 makes causation primitive), like Esfeld 2009 and unlike Ladyman and Ross, for whom causation is a special-science notion (§3.6).
- With a generative base layer (CCI:51), which Ladyman and Ross do not have and which French and Esfeld do, in their own way.
- With no current account of what makes structure actual. CCI's indexical account (CCI:77–79) was withdrawn at P&A:117, which declines to treat actuality as a separate status. That is now close to Ladyman and Ross's refusal (§2.3).

The essay has to decide whether this combination is one view. The two places where it strains are the base layer against "no privileged level" (§6, question 2 in §8) and primitive causation against a structuralism in which causation is derivative (question 3).

---

## 2. The main objections

### 2.1 Relations without relata

**The objection at full strength.** A relation is a way things stand to one another. Take away the things and nothing stands any way, so a world of relations alone is no ontology at all. "One cannot intelligibly subscribe to the reality of relations unless one is also committed to the fact that some things are related" (Chakravartty 1998, p. 399) [S: SEP-SR §4]. "A relation might take anything as its relata, but it always takes something" (Busch 2003, p. 213) [S: F&V p. 262].

The retreat to "there are relata, and they are nothing over and above their relations" meets a dilemma. If the relata have any intrinsic features, those features can fix their identity, and the priority of relations fails. If they have none, then "an object with no intrinsic features at all, whether knowable or unknowable in principle, is not an object at all", and "we have crashed with a bang into the limit of eliminativism" [P: Chakravartty 2012, p. 197]. Weak discernibility does not supply the relata, since an irreflexive relation holds only between things already distinct: "relations presuppose numerical diversity and so cannot account for it" [P: SEP-SR §4, reporting the standard complaint]. The answer "structures all the way down" buys coherence with a regress: "If we stop at some level, then the incoherence objection can be made again" [P: F&V p. 262].

Sources not opened beyond abstracts: Chakravartty, "Semirealism", *Studies in History and Philosophy of Science* 29 (1998): 391–408, [doi:10.1016/S0039-3681(98)00013-2](https://doi.org/10.1016/S0039-3681%2898%2900013-2); Chakravartty, "The Structuralist Conception of Objects", *Philosophy of Science* 70 (2003): 867–878, [doi:10.1086/377373](https://doi.org/10.1086/377373) [A]; Psillos, "Is Structural Realism Possible?", *Philosophy of Science* 68 (2001): S13–S24, [doi:10.1086/392894](https://doi.org/10.1086/392894) [A]; Cao, "Can We Dissolve Physical Entities into Mathematical Structures?", *Synthese* 136 (2003): 57–71, [doi:10.1023/A:1024112417545](https://doi.org/10.1023/A:1024112417545) [C]; Busch, "What Structures Could Not Be", *International Studies in the Philosophy of Science* 17 (2003): 211–225, [doi:10.1080/0269859032000169433](https://doi.org/10.1080/0269859032000169433) [A].

**Best replies.**

1. Relata exist and are themselves structures (Ladyman and Ross). The regress is harmless only if there is no fundamental level. F&V grant the move and name its price: "There is therefore at least a question about whether a conception of reality with no fundamental level can be given" (p. 263) [P].
2. Relata need not be individuals: "OSR does not require that there be no relata, just that the relata not be individuals" [P: SEP-SR].
3. Identity can be contextual. Fermions are discerned "by means of physically meaningful, permutation-invariant categorical relations" [A] (Muller and Saunders, "Discerning Fermions", *BJPS* 59 (2008): 499–548, [doi:10.1093/bjps/axn027](https://doi.org/10.1093/bjps/axn027); Saunders, "Are Quantum Particles Objects?", *Analysis* 66 (2006): 52–63, [doi:10.1093/analys/66.1.52](https://doi.org/10.1093/analys/66.1.52) [A]). This is contested: the argument "uses a silent premise that is not justified in the quantum case" [P, abstract and §1] (Dieks and Versteegh, "Identical Quantum Particles and Weak Discernibility", *Foundations of Physics* 38 (2008): 923–934, [arXiv:quant-ph/0703021](https://arxiv.org/abs/quant-ph/0703021)).
4. Symmetric dependence (Esfeld and Lam): neither objects nor relations come first, so nothing has to be left once relations are removed.
5. Once relations are taken with intensions, the eliminative view "becomes almost equivalent to the so-called bundle theory of objects", whose problems are "serious metaphysical issues" that "arguably don't add up to an incoherency" [P: F&V p. 263].

**Where it stands.** The incoherence charge lands only on the radical, extensional reading, which F&V say no proponent holds. Against a view that keeps relata, the live objection is Chakravartty's dilemma. It rests on the premise that being something requires an intrinsic feature, and that premise is the point in dispute. The exchange is a stand-off. [I]

**What it means for the blog.** Three debts. [I]

- Say what individuates a relatum at a given scale. "A real pattern at another grain" is an answer. The neuron case in §5.3 is a worked instance: the axes are real as an unordered set, and no axis has an identity beyond its place.
- Defend the absence of a bottom level on grounds other than convenience (§2.4), or admit a bottom level and say why the regress stops harmlessly there.
- Block the slide from "abstraction" to "mind-dependent". SEP-SR's thesis 7 calls objects "pragmatic devices used by agents". Busch's verdict is that the import Ladyman gives to structure "is rather epistemological import properly understood" [A]. The projectibility or intervention criterion has to carry the objectivity (§2.5).

### 2.2 Newman's problem

**The objection at full strength.** If all we know of the unobservable is its structure, and a structure is an isomorphism class of extensionally defined relations, we know almost nothing. "Any collection of things can be organised so as to have structure W, provided there are the right number of them" (Newman 1928, p. 144) [S: F&V p. 250]. Over any domain of the right size set theory supplies relations with any structure one likes. Applied to Ramsey sentences: the Ramsey sentence of a theory "is true just in case Θ possesses a full model which is empirically correct and satisfies a certain cardinality condition on its theoretical domain" [A] (Ketland, "Empirical Adequacy and Ramsification", *BJPS* 55 (2004): 287–300, [doi:10.1093/bjps/55.2.287](https://doi.org/10.1093/bjps/55.2.287)). So "Russell's realism collapses into a version of phenomenalism or strict empiricism after all: all theories with the same observational consequences will be equally true" (Demopoulos and Friedman 1985, p. 635) [S: SEP-SR §3.2].

The extension to the ontic view: a metaphysics on which the world *is* the structure its mathematics describes inherits the problem unless it says which relations are the real ones. Appeal to the semantic view of theories does not do that: "At no point … do French and Ladyman really elaborate how the Newman Problem can be obviated with the adoption of the semantic approach" [P: F&V p. 255]. Newman's argument never depended on a linguistic formulation (Ainsworth 2009, pp. 150–152) [S: F&V p. 256].

Sources: Newman, "Mr. Russell's 'Causal Theory of Perception'", *Mind* 37 (1928): 137–148, [doi:10.1093/mind/XXXVII.146.137](https://doi.org/10.1093/mind/XXXVII.146.137); Demopoulos and Friedman, "Critical Notice: Bertrand Russell's *The Analysis of Matter*", *Philosophy of Science* 52 (1985): 621–639, [doi:10.1086/289281](https://doi.org/10.1086/289281); Ainsworth, "Newman's Objection", *BJPS* 60 (2009): 135–171, [doi:10.1093/bjps/axn051](https://doi.org/10.1093/bjps/axn051) [A]: "none of these suggestions is an adequate response to Newman's objection, which therefore remains a serious problem for ESRists."

**Best reply.** The ontic view denies that relations are extensional. "Ladyman (1998) and Ladyman and Ross (2007) argue that the Newman problem does not arise for ontic structural realism because it eschews an extensional understanding of relations" [P: SEP-SR §3.2]. F&V concede it: "Ladyman and Ross are correct in pointing out that shifting to a substantive understanding of relations at least prima facie undercuts the proof of Newman's Theorem … In fact, reverting to a substantive understanding of relations was Newman's own solution" (p. 265) [P]. The modal version: the structure a theory attributes is a pattern of lawlike, counterfactual-supporting relations, and a gerrymandered set of tuples supports no counterfactuals. The formal analogue is Ramsey sentences with intensional operators [A] (Melia and Saatsi, "Ramseyfication and Theoretical Content", *BJPS* 57 (2006): 561–585, [doi:10.1093/bjps/axl020](https://doi.org/10.1093/bjps/axl020)), which F&V say "seems to require the treatment of the extra modal operators as logical primitives" (p. 252) [P].

**Where it stands.** Against the Ramsey-sentence epistemic view the objection is widely taken to succeed. Against the ontic view it fails as a proof and survives as a demand: the escape works only as far as "modal structure" is a real and specifiable constraint. The escape also has a price. Interpreted relations mark "a radical departure from the original ideas of structural realism, which were squarely based on an extensional understanding of structures" [P: F&V p. 262], which reopens the charge that the view is ordinary realism under another name.

**What it means for the blog.** [I]

- The modal commitment is the premise that blocks Newman. It cannot be presented as optional.
- Newman's problem, Putnam's triviality argument and the vacuity theorem for causal abstraction are one problem met three times (§5.2c, §5.4). In each the cure is a restriction on which relations or maps count. The blog's answer to Putnam (CCI:39–43) is therefore also its answer to Newman, and the essay can say so.
- Chalmers makes the same repair from the other side: to escape Newman one adds "nomic and causal expressions such as 'law' and 'cause', capturing the idea that theories are not just capturing mathematical structure but nomic and causal structure" [P] (Chalmers, "Structuralism as a Response to Skepticism", *Journal of Philosophy* 115 (2018): 625–660, §3, <https://consc.net/papers/structuralism.pdf>). This matters in §4: Alter's notion of structure already includes the modal part.

### 2.3 The collapse of physical into mathematical structure, and what "modal structure" adds

**The objection at full strength.** The ontic view is motivated by the thought that physics describes its domain only up to isomorphism. Then say that the structure so described is all there is. "What has looked like the structure of something with unknown qualitative features is actually all there is to nature. But with this, the contrast between structure and what is not structure has disappeared"; "if there is no non-structure, there is no structure either" [P: van Fraassen 2006, pp. 292–293]. The sharper point concerns instantiation. Statements about a structure's formal properties would be true had nothing concrete existed, and "X is multiply instantiated" would not. So "if structure is not just there as mathematical or abstract entity, then it is not true that structure is all there is", and the view "seems to me to lead right back to reification: the whatever it is that bears this structure may be denied other properties perhaps, but not existence" (p. 294) [P]. Either the world is a mathematical object or there is a non-structural bearer.

- van Fraassen, "Structure: Its Shadow and Substance", *BJPS* 57 (2006): 275–307, [doi:10.1093/bjps/axl002](https://doi.org/10.1093/bjps/axl002), <https://swh.princeton.edu/~fraassen/articles/pdfs/Structure%20Shadow%20and%20Substance%20publ.pdf> [P, §3.2].
- The first horn has a defender. The external reality hypothesis "implies the Mathematical Universe Hypothesis (MUH) that our physical world is an abstract mathematical structure" [P] (Tegmark, "The Mathematical Universe", *Foundations of Physics* 38 (2008): 101–150, [arXiv:0704.0646](https://arxiv.org/abs/0704.0646)). Chakravartty says the Pythagorean option "presents itself as a reductio" [P: 2012, p. 198].
- A second objection, from a sympathetic critic: "there is no unequivocal notion of 'structure' that can do all the jobs they want and need it to do", namely to replace objects in fundamental physics, to be what survives theory change, and to explain predictive success. And to say that theories describe modal structure "is simply to redescribe or restate and not to explain the fact that they enjoy novel predictive success". [P: Stanford, as quoted in Ladyman and Ross's reply, *Metascience* 19 (2010): 183–184]
- A third, from a reviewer: the authors' formulations do not "adequately discriminate" between very different positions [P*] (Dorr, review of ETMG, *Notre Dame Philosophical Reviews*, 16 June 2010, <https://ndpr.nd.edu/reviews/every-thing-must-go-metaphysics-naturalized>).

**What Ladyman and Ross say.**

- ETMG p. 158: "the difference between mathematical (uninstantiated) structure and physical (instantiated) structure cannot itself be explained in purely structural terms" [S: Konstantinou handout]; "What makes the structure physical and not mathematical? That is a question that we refuse to answer" [S: Chakravartty 2012, n. 6, citing p. 158]. The continuation the GPT report paraphrases is [U].
- In reply to Humphreys they explain the refusal: "we simply see no plausible reason to believe that someone will one day come along with a good empirical motivation for identifying a clear boundary between the domain of non-physical mathematics and the domain of fundamental physics. … That point doesn't bring us closer to saying what structures are, but it explains why we don't think it's helpful to try to come down hard on one side of a debate over whether they're mathematical or physical." [P] Stanford, Humphreys, Hawley, Ladyman and Ross, "Protecting Rainforest Realism", *Metascience* 19 (2010): 161–185, pp. 182–183, [doi:10.1007/s11016-010-9323-5](https://doi.org/10.1007/s11016-010-9323-5), open copy <https://escholarship.org/uc/item/2vs0q1gr> (read by the main pass).
- In reply to Stanford's "redescription" charge: commitment to modal structure "has methodological implications for the practice of science", since scientists who hold it "have a motivation that a pure empiricist lacks for seeking to recover those theoretical laws as limits or approximations of successor theories", as Einstein kept the Poisson equation as a limit. On the single notion of structure: "We think that this challenge can be met … but we cannot adequately respond to it here." [P: same, pp. 183–184]

**Other replies.**

1. Represented against representation. "If OSR is characterised in terms of modal structure then the mathematical structure of a scientific theory is understood as representing the modal structure of its domain, not as being identical with it." [P: SEP-SR §5]
2. Physical structure is causal. French 2014 calls it an "active principle" [S: Ney's review]; Esfeld 2009 makes structures powers [A]. French later weakens this: "at best, it seems, physics supports only a 'thin' notion of causation understood in terms of certain dependencies", and "Perhaps ultimately we may be able to do no more than point out that only certain of these mathematical structures get 'hooked up', via various interpretational devices, to empirical observation" [P: French 2019, ms p. 3].
3. Any realist owes natural necessity: Humean accounts fail, so "the scientific realist must embrace natural necessity" [A] (Berenstain and Ladyman, "Ontic Structural Realism and Modality", in Landry and Rickles (eds.), *Structural Realism* (2012), 149–168, [doi:10.1007/978-94-007-2579-9_8](https://doi.org/10.1007/978-94-007-2579-9_8)).
4. Types can separate what isomorphism identifies. In univalent foundations a physical type and a mathematical type need not be identified. The author is candid about the limit: "from the point of view of structuralists, the distinction had better not be primitive but based on structural differences", and that "the primitive notion of 'being instantiated' or 'obtain' is not sufficiently structural" is "a separate worry". [P] Chen, "Univalence and Ontic Structuralism", *Foundations of Physics* 54 (2024), article 38, §4.3 and n. 31, [doi:10.1007/s10701-024-00768-4](https://doi.org/10.1007/s10701-024-00768-4), [arXiv:2407.14238](https://arxiv.org/abs/2407.14238).

**What "modal structure" is said to add.** It "is an abstraction of causal structure and nomological structure, that is intended to also include symmetry principles and perhaps more" [P: SEP-SR §4]. It is asked to do three jobs: to be what theories get right and keep across revolutions; to block Newman; and to mark the physical off from the merely formal. Critics accept the first two more readily than the third. Van Fraassen declines "realism about modality" outright (n. 18) [P]. Psillos argues the notion must be "abstract enough to be independent of concrete physical systems and concrete enough to be part of the causal identity of physical systems" [A] (Psillos, "Adding Modality to Ontic Structuralism: An Exploration and Critique", in Landry and Rickles (eds.), 169–185, [doi:10.1007/978-94-007-2579-9_9](https://doi.org/10.1007/978-94-007-2579-9_9)). Esfeld says a complete realism "has to answer the question how the structure of a given theory is implemented, instantiated or realized" [A] (Esfeld, "Ontic Structural Realism and the Interpretation of Quantum Mechanics", *European Journal for Philosophy of Science* 3 (2013): 19–32, [doi:10.1007/s13194-012-0054-x](https://doi.org/10.1007/s13194-012-0054-x)).

**Where it stands.** Unresolved. The modal reply relocates the question, since mathematical structures have possibility spaces too. What makes a modal structure physical is its tie to actual phenomena. French's "hooked up … to empirical observation" and Chen's "singling out what actually obtains" both rest on an anchoring that is indexical and not structural. [I]

**What it means for the blog.** [I]

- The blog took a position here and then withdrew it. CCI said the gap between physics and mathematics "is purely indexical — contributed by the representer" (CCI:77–79), which is the first horn with an indexical clause, and matches where French and Chen end up. P&A:117 withdraws the indexical account "without proposing another account of actuality as a separate ontological status". The current position is therefore a refusal, and it converges on Ladyman and Ross's: "we don't think it's helpful to try to come down hard on one side".
- A refusal has to be squared with two things the blog still says. CCI:15–17 says "description is not generation" and that beneath physics lies "the actual producing of the next state from the current one". P&A:119 locates experience in "concrete organized occurrences" and no longer in "an abstract algorithmic organization across its realizations". Both draw a line between the concrete and the abstract, which is van Fraassen's instantiation question. If nothing structural marks the line, the blog has a non-structural primitive (generation, or occurrence) and takes his second horn: a bearer that is denied other properties but not existence. If something structural marks it, the candidates on the table are P&A:121's finitude and constructibility. The essay has to say which.
- Van Fraassen's dilemma is fatal only to the eliminative variant. A moderate view can take the second horn as stated and then owes an answer to Chakravartty's dilemma (§2.1).
- The essay should not say that modal structure solves the collapse. It should say what modal structure is for (Newman; theory change) and treat the physical–mathematical difference separately.

### 2.4 McKenzie on fundamentality

**Sources.**

- McKenzie, "Priority and Particle Physics: Ontic Structural Realism as a Fundamentality Thesis", *BJPS* 65 (2014): 353–380, [doi:10.1093/bjps/axt017](https://doi.org/10.1093/bjps/axt017) [A].
- McKenzie, "Structuralism in the Idiom of Determination", *BJPS* 71 (2020): 497–522, [doi:10.1093/bjps/axx061](https://doi.org/10.1093/bjps/axx061) (Crossref; online 2017) [A], with her own restatement in the 2024 paper [P].
- McKenzie, "Structuralism as a Stance", *Philosophy of Physics* 2 (2024), [doi:10.31389/pop.77](https://doi.org/10.31389/pop.77), open access [P, §§1, 3–6].
- McKenzie, *Physics Without Fundamentality*, PhD thesis, University of Leeds (2012), <https://etheses.whiterose.ac.uk/4052/1/uk_bl_ethos_567586.pdf> [P, abstract, §4.4, ch. 7 opening]. The article version is "Arguing against Fundamentality", *Studies in History and Philosophy of Modern Physics* 42 (2011): 244–255, [doi:10.1016/j.shpsb.2011.09.002](https://doi.org/10.1016/j.shpsb.2011.09.002) [C].
- McKenzie, *Fundamentality and Grounding* (Cambridge Elements, 2022), [doi:10.1017/9781108657617](https://doi.org/10.1017/9781108657617) [A]. Arguments not seen.

**What she argues, in order.**

1. *Against easy anti-fundamentalism (2011–12).* Physics can be used to deny a fundamental level only by arguments framed within an existing theory, such as the tower of effective field theories. Such arguments have a ceiling: "the internal approach can only ever present us with a sort of 'half-way house' form of anti-fundamentalism in which the principles governing the physics of a world must stay the same even as its levels unfurl without end" [P: thesis, pp. 166–167].
2. *Priority as dependence (2014).* The case studies have "largely negative implications for the radical structuralism of French and Ladyman (including their 'eliminativist' interpretation of it), largely positive implications for the moderate structuralism primarily advocated by Esfeld and Lam" [A].
3. *Priority as determination (2020).* She withdraws the 2014 framing and tests priority as determination. Priority-based structuralism "has yet to be vindicated by our best physical theories, owing to the failure of symmetry structures to determine the world's inventory of fundamental kinds" [A]. In 2024 she states the failures: "The symmetries of our theories do not determine how many particles there are in nature" and "do not determine the magnitude of many of the properties definitive of the fundamental particle kinds" (p. 9); these facts "completely undermine the basis for taking structuralism to be the correct metaphysics of physics, insofar as that metaphysics is supposed to be supported by physics 'as we now find it'" (p. 9) [P].
4. *Stance (2024).* The view "is best understood not as a thesis or doctrine concerning how the world fundamentally is, but rather as a 'stance'" (abstract). Her evidence is that structuralists disagree over whether quantum fields are objects or structures and do not treat the disagreement as urgent. She cites a worry about any "naturalistic project purporting to have insight into fundamental reality prior to the emergence of a truly fundamental theory" (p. 6). The stance she proposes is "the injunction to foreground, when doing metaphysics, that the language of physics is mathematics" [P].

**What the view would have to show.** [I] If the thesis is that structure is fundamental, it needs a determinate extension for "structure", an asymmetric priority relation, and a demonstration that structure fixes the object-level facts, free parameters included. McKenzie's finding is that the third fails for symmetries.

**Replies found.**

- French 2019 answers a parallel dependence argument (Wolff's) and not the determination argument: "there is nothing to quantum entities, like electrons, that is not cashed out in terms of the structure" (ms p. 12) [P].
- SEP-SR records McKenzie 2014 and 2020 and replies to her charge of under-articulation only that "The wealth of work referred to above makes these charges harder to sustain now" [P]. It does not engage the determination failure or the stance proposal.
- One recent paper weakens the demand instead of meeting it: symmetries "constrain spin values … but do not exactly specify them", which the author calls "determination by constraint" [P, abstract, §§1–2 and the spin section] (Meyer, "Defending Ontic Structural Realism in Quantum Field Theory", *Philosophical Studies*, online 2026, [doi:10.1007/s11098-026-02650-7](https://doi.org/10.1007/s11098-026-02650-7)).
- No published reply by Ladyman or French to the 2020 or 2024 papers was found [U as an absence; one search]. McKenzie invites one: "My argument as stated could therefore be refuted given the right sort of input from structuralists about why they do what they do" (2024, p. 20) [P].

**Where it stands, and what it means for the blog.** [I] This is the objection the essay can least afford to skip, because it comes from inside and attacks the form of the thesis. A real-patterns view can decline the framing: it asserts no fundamental level, so it owes no claim that symmetry determines particle kinds. It then owes three other things.

- *What it rules out.* Otherwise the stance reading wins by default. Candidates: categorical intrinsic natures; primitive identity; free recombination; a privileged micro level. McKenzie grants that the argument from extrinsic properties "still works as well as it did to undermine the principle of free recombination" (2024, p. 19) [P]. §4 and §6 show that the first exclusion does real work: it is what separates the blog from Russellian monism.
- *An answer to the half-way house.* The denial of a bottom level leans on reasoning whose own principles are held fixed across scales. "No privileged level" may not extend to "no privileged principles". The blog's Layer 0 (CCI:51) is a set of privileged principles in exactly this sense. The half-way house may be where the blog already lives, and the essay could say so.
- *An answer to unfinished physics.* Effective realism is the natural one, since its commitments are indexed to regimes and chosen for robustness. McKenzie lists a forthcoming paper "On the Prospects of an Effective Metaphysics" in her 2024 references; its content was not seen [U].

### 2.5 Are real patterns observer-relative?

**The objection at full strength.** Six strands.

1. *Language.* "More efficient than the bit map" presupposes a description language or a universal machine. With a suitable machine any finite string is short. [I]
2. *Coarse-graining.* The bit map itself presupposes a choice of elements, and compressibility of coarse data may be manufactured by the map (Millhouse 2021 [A]; Carroll and Parola's split by compressibility of the map [P]).
3. *Interest and noise.* Dennett concedes it: Jones and Brown differ with "no ground for determining that one of them is right" (p. 35) [P]. McAllister: "A conventional threshold cannot serve as a guide to ontology" (2026, p. 144) [P].
4. *Plenitude.* "Any empirical dataset of length L can be decomposed into any one of all patterns of length L and the associated noise term" (2026, pp. 140–141). So "there is no means available to partition the infinite number of patterns that we can discern in empirical data into these two classes… if any pattern is real, then all patterns must be" (p. 138). Against projectibility: every pattern is exhibited in new data at some noise level, so making projectibility decisive "amounts to tying reality of patterns to an arbitrary noise threshold" (pp. 147–148). Against economy: which pattern compresses best "depends on the overall value of a dataset, and thus on the amount of noise that it contains" (p. 149). Against non-redundancy: its effect is "that no more than one pattern in any given dataset counts as real", which is "a purely pragmatic choice" (pp. 146–147). [P] McAllister, "Is Any Pattern Nonreal?", RP volume ch. 7, <https://hdl.handle.net/1887/4300798>. Earlier versions: "Phenomena and Patterns in Data Sets", *Erkenntnis* 47 (1997): 217–228, [doi:10.1023/A:1005387021520](https://doi.org/10.1023/A:1005387021520) [P]; "The Ontology of Patterns in Empirical Data", *Philosophy of Science* 77 (2010): 804–814, [doi:10.1086/656555](https://doi.org/10.1086/656555) [A].
5. *Circularity.* The appeal to a "physically possible" perspective imports current physics' ontology (McAllister 2026, p. 146) [P].
6. *The carvers.* "Assuming an agent-relative conception of real patterns dramatically reduces the interest of scale-dependent RR"; what is the status "of the agents or minds whose pragmatic interests are said to carve the world"? [P, author manuscript] Cordovil, Santos and Symons, "Reconciling Ontic Structural Realism and Ontological Emergence", <https://www.johnsymons.net/wp-content/uploads/2021/12/Reconciling-Ontic-Structural-Realism-and-Ontological-EmergenceFFinal.pdf> (journal details not confirmed).

A neighbouring worry from the Humean literature: best-system laws are charged with being "inappropriately mind-dependent in virtue of the account's appeal to the concepts of simplicity, strength and best balance" [P: SEP "Laws of Nature", <https://plato.stanford.edu/entries/laws-of-nature/>]. A compression criterion for reality inherits the charge (§3.2).

**Best replies.**

- *Existence, not concoction.* Dennett's "whether or not anyone can concoct it" and ETMG's "a perspective that physics tells us could be physically occupied" quantify over possible perspectives. The relativity is to physics and not to minds. A clean statement of the two layers: the reality of patterns "is grounded in the objectivity of mathematical facts regarding K-C complexity, as it is not 'up to the observer' whether… a program accurately describes a lower-level regularity", after which Dennett brings in "more observer-dependent, epistemic and pragmatic considerations" [P] (Gładziejewski, "Real Patterns, the Predictive Mind, and the Cognitive Construction of the Manifest Image", *Synthese* 206 (2025), article 225, [doi:10.1007/s11229-025-05311-0](https://doi.org/10.1007/s11229-025-05311-0)).
- *Invariance.* Kolmogorov complexity changes by at most an additive constant between universal machines [U: textbook result, not re-read]. The constant can exceed the size of any finite dataset, so the theorem does not settle particular cases. [I]
- *Interpretation cost.* Millhouse 2019 and 2022 rank mappings by their complexity and require them to carry counterfactuals and interventions [A]. This answers strand 2 and inherits strand 1.
- *Projectibility as robustness under intervention.* McAllister reads projectibility as recurrence in a further passively collected dataset. A reading on which the pattern must hold under interventions and varied background conditions is not touched by his additive-decomposition argument. His own thought experiment on p. 149, in which rearranging the other causal factors makes a bogus pattern the best compressor, is an appeal to intervention: the real pattern is the one that persists through the rearrangement. [I] This is the strongest reason to prefer the intervention criterion to bare compression, and it is where §5 and this section meet.
- *Rival patterns are not rival ontologies.* Dennett's bettors both get rich, and McAllister's own oceanography cases show scientists accepting several superposed patterns. Rainforest realism needs a bar that most decompositions fail. It does not need uniqueness. [I]
- *The observer is one more pattern.* GRAIN:129 treats an observer as "a bounded system embedded in the Ruliad, able to enter only certain interactions with the rest of it", so that relativity to observers becomes relativity to families of interactions. This answers strand 6 if observers pass the same test as what they observe. Dasgupta's point that symmetry-to-reality inferences run through "our powers of detection" [A] shows the reply is not free (§5.5, cost 4).
- *Triangulation.* What is real is what is accessible by several independent means (Wimsatt) [U]. McAllister says he rejected consilience as a criterion in 2010 and 2011 (2026, p. 150); those arguments were not read.

**No published reply by Ladyman and Ross to McAllister was found** [U as an absence]. The editors placed his chapter in their volume.

**Where it stands, and what it means for the blog.** [I]

- The compression criterion alone does not survive McAllister. The essay should not rest on it.
- The intervention criterion does better, at the price of the variables problem (§3.6) and of the admissibility question (§5.2c). The three objections converge: observer-relativity, the variables problem and triviality all ask what restricts the admissible descriptions.
- McAllister's own conclusion is a "radically polymorphous" world with as many structures as patterns. On the Wolfram picture the blog uses, that is close to a description of the base: everything computable is there, and selectivity enters with the bounded observer. The essay could accept plenitude at the base and locate realism about particular patterns in the interaction family. Whether that is still realism is question 9 in §8.

---

## 3. The alternatives

Each alternative is tested against five of the blog's claims from §0:

- **(a) Grains.** Patterns at many grains are real, by the intervention criterion.
- **(b) Levels.** No micro level is privileged.
- **(c) Natures.** There are no categorical or intrinsic natures beneath structure.
- **(d) Mental kinds.** Mental kinds are real patterns.
- **(e) Causation.** Higher-level patterns cause without adding productive power; the redundancy is between two descriptions of one causal pattern.

### 3.1 Dispositional essentialism and powers ontologies

**The view.** All sparse fundamental properties have dispositional essences, and laws flow from those essences.

- Bird, *Nature's Metaphysics: Laws and Properties* (OUP, 2007), [doi:10.1093/acprof:oso/9780199227013.001.0001](https://doi.org/10.1093/acprof:oso/9780199227013.001.0001) [C; content U].
- Mumford, *Laws in Nature* (Routledge, 2004), [doi:10.4324/9780203458426](https://doi.org/10.4324/9780203458426) [C]. Mumford and Anjum, *Getting Causes from Powers* (OUP, 2011), [doi:10.1093/acprof:oso/9780199695614.001.0001](https://doi.org/10.1093/acprof:oso/9780199695614.001.0001) [A].
- Shoemaker, "Causality and Properties" (1980), [doi:10.1007/978-94-017-3528-5_7](https://doi.org/10.1007/978-94-017-3528-5_7) [C]. Powerful qualities (Martin; Heil): "every property is in some sense both dispositional and qualitative" [P*: SEP "Dispositions" §3, <https://plato.stanford.edu/entries/dispositions/>].
- The regress objection and Bird's reply. If a power's identity is fixed by its relations to other powers, "either there is an infinity of properties or there is circularity in this relationship of identities" (p. 524) [S: Sider, seminar handout, <https://tedsider.org/teaching/structuralism_18/HO_Bird.pdf>]. Bird: "The most pressing interpretation is that the theory fails to make the identities of powers determinate. I demonstrate that this objection is in error. It does, however, put certain constraints on what the structure of fundamental properties is like." [A] Bird, "The Regress of Pure Powers?", *Philosophical Quarterly* 57 (2007): 513–534, [doi:10.1111/j.1467-9213.2007.507.x](https://doi.org/10.1111/j.1467-9213.2007.507.x). That the reply needs the graph of powers to have no non-trivial symmetries is [U beyond a search snippet].

**Relation to structural realism.**

- Esfeld brings the two together: "the fundamental physical structures possess a causal essence, being powers. … the standard argument against categorical and for causal properties holds for structures as well." [A: Esfeld 2009, cited in §1.2] Esfeld and Sachse then reduce the special sciences: "all properties that there are in the world, including the physical ones, are functional properties in the sense of being causal properties", and special-science descriptions "can in principle be reduced to physical descriptions … by means of functional reduction, despite multiple realization." [A] *Conservative Reductionism* (Routledge, 2011), [doi:10.4324/9780203817346](https://doi.org/10.4324/9780203817346).
- A pure-powers view is already structuralist about properties. Canonical dispositional essentialism "comprises a structuralist metaphysics of properties and an account of laws as relations in the property structure"; a property "has its identity fixed by its place in the structure". The author compares this to relations-without-relata and objects that the resulting explanation of laws "is circular". [A, P*] Kimpton-Nye, "Reconsidering the Dispositional Essentialist Canon", *Philosophical Studies* 178 (2021): 3421–3441, [doi:10.1007/s11098-021-01607-2](https://doi.org/10.1007/s11098-021-01607-2).
- French rejects dispositions. The "fundamental obstacle" is "the role of symmetries as constraints on the fundamental laws in physics". The dispositionalist "will have to ascribe her dispositions to objects that are metaphysically very 'thin' … and also give up the standard Stimulus and Manifestation account". His alternative seat of possibility "is the physical structure, with no relevant stimuli, no S&M analysis and thus no subjunctive conditionals". [P] French, "Doing Away with Dispositions: Powers in the Context of Modern Physics", in Meincke (ed.), *Dispositionalism* (Springer, 2020), 189–212, [doi:10.1007/978-3-030-28722-1_12](https://doi.org/10.1007/978-3-030-28722-1_12), accepted manuscript <https://eprints.whiterose.ac.uk/94650/>.
- Semirealism "is a realism about properties in the first instance. Talk of objects, events, and processes … can be constructed after that". The two accounts of modality "stem from different stances regarding how to theorize about scientific ontology". [P] Chakravartty, "Physics, Metaphysics, Dispositions, and Symmetries – À la French", *Studies in History and Philosophy of Science* 74 (2019): 10–15, <https://anjanchakravartty.com/wp-content/uploads/2019/05/french-symposium-1.pdf>.
- SEP-SR says dispositions give a "more restrictive" idea of modal structure and are "too restrictive for most ontic structural realists" [P].
- A categorical, Humean structural realism also exists: structural properties as primitives, given "a Humean shape by treating structures as categorical and global" [S: search-relayed abstract] (Lyre, "Structural Invariants, Structural Kinds, Structural Laws", 2012, [doi:10.1007/978-94-007-3030-4_12](https://doi.org/10.1007/978-94-007-3030-4_12)).

**Is a pure-powers ontology structural realism under another name?** Nearly, on property identity. Four differences remain. [I] Powers are properties of objects, so bearers return. Dispositions are a narrower modality than symmetry principles. Dependence runs from properties to laws for the dispositionalist and from laws and symmetries to properties for French. And dispositional essentialism is usually stated for a fundamental level.

**What adopting it changes.** [I]

- (a) The test for reality becomes Eleatic: a coarse variable is real if it confers causal powers. "Interventions respect it" survives as evidence of a power.
- (b) A privileged level tends to return, as fundamental powers.
- (c) Kept on pure-powers views; dropped on powerful-qualities views.
- (d) Mental kinds are real if they confer powers; on Esfeld and Sachse they are real and functionally reducible.
- (e) Under strain. Powers theories make causation productive. That is the conception Ladyman 2008 blames for the exclusion problem (§3.6). "One causal pattern, two descriptions" would have to become token identity of powers, or reduction.

**Best argument that it beats structural realism.** Unless structures are powers, the modality of "modal structure" is unexplained (Esfeld 2009). Experimental practice, "changing the magnitudes of properties so as to affect the behaviors of entities", motivates a dispositional reading [P: Chakravartty 2019]. This fits the blog better than it fits Ladyman and Ross, because the intervention criterion is a criterion about what manipulation does.

**Best reply.** Symmetries, conservation laws and permutation invariance do not fit stimulus and manifestation, so the powers theorist either denies them or ends with structure as the seat of possibility (French). "Causation is very often the pragmatically indispensable proxy for modal structure in the sciences" [P: SEP-SR, attributed to ETMG].

### 3.2 Humean supervenience

**The view.** "All there is to the world is a vast mosaic of local matters of particular fact, just one little thing and then another … And at these points we have local qualities: perfectly natural intrinsic properties … All else supervenes on that" (Lewis 1986) [S: SEP-SR; the SEP entries disagree on whether the page is ix or x]. Laws "belong to all the true deductive systems with a best combination of simplicity and strength" (Lewis 1973, p. 73) [S: SEP "Laws of Nature", P].

- Lewis, "Humean Supervenience Debugged", *Mind* 103 (1994): 473–490, [doi:10.1093/mind/103.412.473](https://doi.org/10.1093/mind/103.412.473) [C]. Loewer, "Humean Supervenience", *Philosophical Topics* 24 (1996): 101–127, [doi:10.5840/philtopics199624112](https://doi.org/10.5840/philtopics199624112) [C]; Loewer, "The Package Deal Account of Laws and Properties", *Synthese* 199 (2021): 1065–1089, [doi:10.1007/s11229-020-02765-2](https://doi.org/10.1007/s11229-020-02765-2) [C].
- Against it from physics: "Tim Maudlin argues against this on the basis of quantum entanglement and argues that this means the end of ontological reductionism" [P: SEP-SR] (Maudlin, *The Metaphysics Within Physics*, OUP, 2007, [doi:10.1093/acprof:oso/9780199218219.001.0001](https://doi.org/10.1093/acprof:oso/9780199218219.001.0001), not opened). Humphreys says flatly: "Humean Supervenience is factually false. It has long been empirically established that entangled states in quantum mechanics exist and do not supervene on what would in classical cases be called the states of the components." [P: *Metascience* 19 (2010): 168]
- The Humean reply, which is also a structural realism. Humean supervenience "can be literally true even in the light of quantum entanglement"; it "requires a commitment to matter as primitive stuff, but no commitment to natural properties", so "the stock metaphysical objections against Humeanism from quidditism and humility no longer apply." [A] Esfeld, "Quantum Humeanism, or: Physicalism without Properties", *Philosophical Quarterly* 64 (2014): 453–470, [doi:10.1093/pq/pqu030](https://doi.org/10.1093/pq/pqu030). In the developed version "there are only matter points that are individuated by the distance relations among them"; "the fundamental objects do not have an intrinsic nature, but a relational one"; "Everything else supervenes on that mosaic." The authors classify the view as moderate ontic structural realism. [P] Vassallo, Deckert and Esfeld, "Relationalism about Mechanics Based on a Minimalist Ontology of Matter", *European Journal for Philosophy of Science* 7 (2017), [arXiv:1609.00277](https://arxiv.org/abs/1609.00277). The reconciliations with entanglement are disputed: one review finds "them wanting" [A] (Dewar, "What the Humean Cannot Say about Entanglement", PhilSci-Archive 12046).
- The special sciences. An acceptable best-system account should "(i) avoid inter-system comparisons of simplicity, strength, and balance, (ii) make lawhood epistemically accessible, and (iii) allow for laws in the special sciences." Lawhood is relative to a set of kinds; the world "permits possibly infinitely many distinct carvings up into kinds", "each equally good from the perspective of nature itself". [A, P*] Cohen and Callender, "A Better Best System Account of Lawhood", *Philosophical Studies* 145 (2009): 1–34, [doi:10.1007/s11098-009-9389-3](https://doi.org/10.1007/s11098-009-9389-3).
- ETMG's own critique of Humean supervenience was not reached [U]. In the 2010 reply Ladyman and Ross grant that they "overstate the agreement among metaphysicians" about it and maintain that "even those who disagree with it take it far more seriously than is warranted" [P: *Metascience* 19: 180].

**How it differs.** Both views deny governing laws over and above pattern. Lewis's version has what the blog denies: local intrinsic qualities (against c) and a privileged base (against b). It lacks primitive modal structure. Super-Humeanism drops intrinsic properties and calls itself moderate structural realism, and it keeps one fundamental level and makes all modality a feature of the best summary. [I]

**The affinity with real patterns.** Best-system lawhood is compression of the mosaic under simplicity and strength. A real pattern is "something that makes for a simplified description relative to some background ontology" [P: SEP-SR §4.4]. The difference is what the compression buys. For the Humean the pattern is a fact about one actual mosaic, and the summary confers the counterfactual force. For Ladyman and Ross the pattern is itself modal. On the Better Best System every vocabulary has its own best system and none is privileged, so higher-level patterns are equally real as summaries. [I] This is the alternative that would change the blog's claims least while changing their meaning most.

**What adopting it changes.** [I]

- (a) Survives, deflated. "Interventions respect it" becomes a counterfactual whose truth is fixed by the best system for the relevant kinds.
- (b) Fails: the mosaic is the privileged level.
- (c) Fails on Lewis, who accepts quidditism and humility; holds on Super-Humeanism.
- (d) Mental kinds are lawful relative to a set of kinds.
- (e) Becomes cheap. Kim's exclusion argument "depends on his commitment to a 'thick' metaphysical conception of generative or productive causation rather than a 'thin' notion of Humean" causation [P: Ladyman 2008, p. 751, reporting Loewer]. No level adds productive power because none has any. This contradicts CCI:11, which makes productive causation primitive.

**Best argument that it beats structural realism.** Parsimony without primitive modality, plus the charge that "modal structure" is under-specified (Dorr; Stanford; §2.3).

**Best reply.** The arguments for realism already presuppose natural necessity (Berenstain and Ladyman, §2.3). And the mind-dependence worry about "best" is one a real-patterns theorist must answer anyway (§2.5).

### 3.3 Russellian monism and other views with categorical natures

**The view.** Three theses: "structuralism about physics, which states roughly that physics … describes the world only in terms of its spatiotemporal structure and dynamics; realism about quiddities, which states that there are quiddities, that is, properties that underlie the structure and dynamics physics describes; and quidditism about consciousness". [P] Alter and Pereboom, "Russellian Monism", SEP, first published 2019, revised 4 July 2023, <https://plato.stanford.edu/entries/russellian-monism/>. Cited as SEP-RM.

- "There are respectable structuralist or dispositionalist views of physics on which physics involves just structure or dispositions all the way down. Still, many find these views objectionable, because they seem to yield a world devoid of substance or qualities". [P] Chalmers, "Panpsychism and Panprotopsychism", Amherst Lecture in Philosophy 8 (2013), <https://consc.net/papers/panpsychism.pdf>.
- Goff, *Consciousness and Fundamental Reality* (OUP, 2017), [doi:10.1093/oso/9780190677015.001.0001](https://doi.org/10.1093/oso/9780190677015.001.0001) [A]: physics "tells us nothing about the concrete, categorical nature of material entities", and that hidden nature "explains human and animal consciousness"; the book defends a cosmopsychist form.
- Alter and Nagasawa (eds.), *Consciousness in the Physical World* (OUP, 2015), cited at GRAIN:207. Not reached, and no DOI was confirmed; its chapters are known here only through SEP-RM [S: SEP-RM].

**The argument from intrinsic natures.** Relations need relata with natures of their own, and physics gives only structure, so something categorical underlies it. Newman's problem supplies a second route (§2.2).

**Objections to it, from SEP-RM** [P for the entry; the papers were not opened]:

- The combination problem: "how do (proto)phenomenal quiddities … combine to constitute macrophenomenal properties".
- Mental causation: because the grounding of dispositions in quiddities is contingent, quiddities are "just along for the causal ride" (Howell 2015, p. 34). "The best it can hope for is that phenomenal properties are causally relevant, but not in virtue of their phenomenality." [A] Howell, "The Russellian Monist's Problems with Mental Causation", *Philosophical Quarterly* 65 (2015): 22–39, [doi:10.1093/pq/pqu058](https://doi.org/10.1093/pq/pqu058).
- The view leaves us "essentially back where we started" (Kind 2015, p. 420).
- Shape and locality are intrinsic and figure in physics, so "structural" cannot simply mean "relational" (Stoljar 2015; Ney 2015). SEP-RM lists ETMG and Ney 2015 as holders of the structure-all-the-way-down option.
- If quiddities are powers, "Wouldn't Mary be in a position to fully understand such powers while she is still in the room?" (Pereboom, *Consciousness and the Prospects of Physicalism*, OUP, 2011, pp. 113–114, [doi:10.1093/acprof:oso/9780199764037.001.0001](https://doi.org/10.1093/acprof:oso/9780199764037.001.0001)) [S: SEP-RM §4.3, which was read]. So the Russellian needs quiddities that are not powers. A modal structural realism gains nothing against the knowledge argument by being modal (§4.5).

**What adopting it changes.** [I]

- (a) Higher-level patterns become derivative of quiddities plus structure. On constitutive versions macro-experience is built from micro-quiddities, hence the combination problem.
- (b) A privileged level returns: micro on standard versions, the cosmos on Goff's.
- (c) Negated outright.
- (d) Mental kinds split. Their functional profile can stay a real pattern. Phenomenal character is grounded in quiddities and is not a pattern at any grain.
- (e) The view is advertised as rescuing mental causation; Howell argues it does not.

**Best argument that it beats structural realism.** It says what the structure is the structure of, and so places consciousness in nature without epiphenomenalism or interactionism.

**Best replies.** Relations can individuate relata: "structures in this sense can do exactly the same what properties are supposed to do" [P: Vassallo, Deckert and Esfeld]. Quiddities are an idle wheel: unknowable by the humility arguments and causally inert by Howell's. And GRAIN:85 adds a debunking explanation of why intrinsic natures seem conceivable at all. §4 tests whether that explanation survives Alter.

### 3.4 Neo-Aristotelian hylomorphism

**The view.** "Hylomorphism claims that structure is a basic ontological and explanatory principle"; "Hylomorphic structure carves out distinctive individuals from the otherwise undifferentiated sea of matter and energy described by our best physics, and it confers on those individuals distinctive powers". [A] Jaworski, *Structure and the Metaphysics of Mind* (OUP, 2016), [doi:10.1093/acprof:oso/9780198749561.001.0001](https://doi.org/10.1093/acprof:oso/9780198749561.001.0001).

- Koslicki, *Form, Matter, Substance* (OUP, 2018), [doi:10.1093/oso/9780198823803.001.0001](https://doi.org/10.1093/oso/9780198823803.001.0001) [A]: "matter–form compounds, despite their metaphysical complexity, emerge as occupying the privileged ontological status traditionally associated with substances, due in particular to their high degree of unity." P&A:89 already cites this book.
- The staunch version: "a substantial form is not merely some structural property of a set of elements—it is rather a power conferred on those elements by that structure, a power that is the cause of the generation (by fusion) and persistence of a composite whole through time." [A] Koons, "Staunch vs. Faint-hearted Hylomorphism", *Res Philosophica* 91 (2014): 151–177, [doi:10.11612/resphil.2014.91.2.1](https://doi.org/10.11612/resphil.2014.91.2.1).
- Applied to physics: "Substances constitute the uniquely fundamental level of reality"; "no two substances overlap"; "artifacts, groups, elementary particles, and the cosmos as a whole cannot" be substances; "the 'fundamental' particles of contemporary physics are merely virtual parts of larger substances." [A, P*] Koons, "Thermal Substances: A Neo-Aristotelian Ontology of the Quantum World", *Synthese* 198 (2021): 2751–2772, [doi:10.1007/s11229-019-02318-2](https://doi.org/10.1007/s11229-019-02318-2). A cosmic variant: "the cosmos is a hylomorphic substance with an intrinsic power to choreograph the trajectories of the particles" [A] (Simpson, "Cosmic Hylomorphism", *European Journal for Philosophy of Science* 11 (2021), article 28, [doi:10.1007/s13194-020-00342-5](https://doi.org/10.1007/s13194-020-00342-5)).
- Fine, "Things and Their Parts", *Midwest Studies in Philosophy* 23 (1999): 61–74, [doi:10.1111/1475-4975.00004](https://doi.org/10.1111/1475-4975.00004) [C]. Simpson, Koons and Teh (eds.), *Neo-Aristotelian Perspectives on Contemporary Science* (Routledge, 2017), [doi:10.4324/9781315211626](https://doi.org/10.4324/9781315211626) [C].

**Explicit comparisons with structural realism.**

- A special issue sets a hylomorphic account of entanglement "in opposition to that provided by Ontic Structural Realism", claiming hylomorphism "is able to preserve both objects and their monadic properties"; another paper in it argues that a relational substance ontology can be hylomorphic. [P*] Marmodoro and Paolini Paoletti, "Introduction to the Special Issue on Form, Structure and Hylomorphism", *Synthese* 198 (2021): 2647–2656, [doi:10.1007/s11229-019-02441-0](https://doi.org/10.1007/s11229-019-02441-0).
- "The basic commitments of Thomism allow for some surprising convergences with ontic structural realism, while Scotism does not." [A] Dumsday, "Thomist vs. Scotist Perspectives on Ontic Structural Realism", *International Philosophical Quarterly* 60 (2020): 323–337, [doi:10.5840/ipq2020716154](https://doi.org/10.5840/ipq2020716154). This is the paper to read before the next exchange with the Thomist interlocutor of GRAIN and P&A.

**How it differs.** "Structure" means different things. In structural realism it is the modal relational pattern, with relata derivative. In faint-hearted hylomorphism it is a constituent of an individual. In staunch hylomorphism it is a power that makes the many one. Hylomorphism adds a distinction the real-patterns view lacks: substance against aggregate. [I]

**What adopting it changes.** [I]

- (a) Patterns at many grains are no longer on a par. Some are substances; the rest are heaps, artifacts or virtual parts. "Interventions respect it" is no longer sufficient for full reality.
- (b) Agreement that the micro level is not privileged, for the opposite reason: privilege moves to the level of substances. Koons's no-overlap condition rules out cross-cutting patterns, which GRAIN:125–127 wants to allow.
- (c) Form is not a quiddity, and it is something over and above relational pattern.
- (d) Friendly in spirit: mental powers are powers of structured individuals. They belong to substances and not to patterns as such.
- (e) Rejected on staunch versions, where the form confers powers the parts lack. Compare P&A:95, which holds that whatever causal integration constitutes a person already belongs to the organizational account.

**Best argument that it beats structural realism.** A real-patterns view has no principled line between an organism and a heap, and that line does work in biology and in the metaphysics of persons. Koons adds that thermodynamic and chemical properties are not derivable from microphysics.

**Best reply.** Unity comes in degrees, and a real-patterns view can grade it without a categorical line; Petersen's "composition as pattern" (§1.4) is the published version. A no-overlap tiling contradicts scale-relative ontology. Koons's tiling and IIT's exclusion postulate make the same demand for a unique carving. [I]

### 3.5 IIT's intrinsic-existence ontology

IITFW covers the free-will paper. This section adds the ontology's own statements and its critics.

**The view.**

- "The principle of being states that to be is to have cause–effect power"; "The principle of maximal existence states that, when it comes to a requirement for existence, what exists is what exists the most"; "candidate complexes that overlap over the same substrate but have a lower value of φs are excluded from existence." On grain: "across the possible micro- and macroscopic levels, the 'winning' grain is the one that ensures maximally irreducible existence". On natures: cause–effect power "all the way down … Eventually, this would leave neither room nor need to assume intrinsic properties or laws." [P] Albantakis et al., "Integrated Information Theory (IIT) 4.0", *PLoS Computational Biology* 19 (2023): e1011465, Boxes 1–2, [doi:10.1371/journal.pcbi.1011465](https://doi.org/10.1371/journal.pcbi.1011465).
- "Many objects of study in the special sciences, such as molecules, organelles, cells, organs … which have proven to be good ways of carving nature at its joints, are also likely to correspond to relative maxima of φs. … They only exist vicariously, from the perspective of some intrinsic entity, and so they do not properly exist." Extrinsic ontologies "are extrinsic because any convenient set of units, at any convenient grain, are considered to exist (although the 'microphysical' level is typically considered more fundamental)". "No subsets, supersets, or parasets of that complex also exist, just as no other grains also exist". [P] Tononi et al., "Only What Exists Can Cause", [arXiv:2206.02069](https://arxiv.org/abs/2206.02069) v5, §§3.6–3.7.
- Critics read the ontology as "a specific combination of phenomenal primitivism, reductionism regarding Φ-structures and complexes, and eliminativism about non-conscious physical entities"; "all non-conscious physical entities like bodies and planets are like the phlogiston". [P] Cea, Negro and Signorelli, "The Fundamental Tension in Integrated Information Theory 4.0's Realist Idealism", *Entropy* 25 (2023): 1453, [doi:10.3390/e25101453](https://doi.org/10.3390/e25101453).
- On the axioms: "none of the five alleged axioms is able to play the role that is required of it". [P] Bayne, "On the Axiomatic Foundations of the Integrated Information Theory of Consciousness", *Neuroscience of Consciousness* 2018: niy007, [doi:10.1093/nc/niy007](https://doi.org/10.1093/nc/niy007).
- On macro-scale causation: "although the macro level supervenes upon the micro, it can supersede it causally" [P] (Hoel, Albantakis and Tononi, "Quantifying Causal Emergence Shows That Macro Can Beat Micro", *PNAS* 110 (2013): 19790–19795, [doi:10.1073/pnas.1314922110](https://doi.org/10.1073/pnas.1314922110)). Critics: effective information "supports only an epistemic form of causal emergence" [A] (Dewhurst, *Thought* 10 (2021): 158–168, [doi:10.1002/tht3.489](https://doi.org/10.1002/tht3.489)); the macro variables "result in interventions with significant ambiguity", owing to "a maximum entropy distribution that is extraneous to the system" [A] (Eberhardt and Lee, "Causal Emergence: When Distortions in a Map Obscure the Territory", *Philosophies* 7 (2022): 30, [doi:10.3390/philosophies7020030](https://doi.org/10.3390/philosophies7020030)).

**Is it a powers ontology with an exclusion rule?** Yes, by its own description, with two additions: intrinsicality (power over itself) and maximality (one border and one grain per substrate). [I]

**What adopting it changes.** [I]

- (a) Denied. Only maxima exist absolutely. The blog's criterion describes, in IIT's terms, existence relative to an observer.
- (b) Half-agreement. IIT also denies that the micro substrate is bedrock and replaces it with one privileged grain per complex. This confirms IITFW §2's point that the blog is neither of the paper's two options, since "substrate+" presumes a microphysical bedrock.
- (c) Half-agreement: no intrinsic properties such as mass and charge. But experience as intrinsic existence is the absolute.
- (d) Functionally individuated mental kinds have only extrinsic existence.
- (e) Rejected from the other side. IIT accepts exclusion reasoning and resolves it by eliminating the lower level.

**Best argument that it beats structural realism.** It gives an observer-independent answer to the question that real patterns and interventionism both leave open: which borders and which grain. It asks "pattern for whom?" and has an answer.

**Best reply.** Exclusion and maximality rest on axioms that are not self-evident (Bayne). The price is eliminativism about bodies and planets (Cea et al.). The authors concede that the excluded entities are the "good ways of carving nature at its joints". And the macro-beats-micro results depend on an imposed intervention distribution (Eberhardt and Lee), which is the admissibility problem of §5 again.

### 3.6 Interventionism about higher-level causation

**Is it a rival ontology?** Woodward says it is a methodology.

- "This paper defends an interventionist account of causation by construing this account as a contribution to methodology, rather than as a set of theses about the ontology or metaphysics of causation. … issues about the ontology of causation often can be fruitfully reconstrued as methodological proposals." [P*] Woodward, "Methodology, Ontology, and Interventionism", *Synthese* 192 (2015): 3577–3599, [doi:10.1007/s11229-014-0479-1](https://doi.org/10.1007/s11229-014-0479-1).
- On levels: "I favor a very deflationary reading: talk of levels is just a way of expressing (local) claims". [P*] Woodward, "Explanatory Autonomy: The Role of Proportionality, Stability, and Conditional Irrelevance", *Synthese* 198 (2021): 237–265, n. 1, [doi:10.1007/s11229-018-01998-6](https://doi.org/10.1007/s11229-018-01998-6).
- Variables need not be anything "metaphysically portentous" [S: Franklin-Hall 2016, p. 557, quoting Woodward 2008].
- Woodward, *Making Things Happen* (OUP, 2003), [doi:10.1093/0195155270.001.0001](https://doi.org/10.1093/0195155270.001.0001), and *Causation with a Human Face* (OUP, 2021), [doi:10.1093/oso/9780197585412.001.0001](https://doi.org/10.1093/oso/9780197585412.001.0001) [C]. Neither was read.

**Exclusion.**

- "Standard arguments for causal exclusion involve mistaken assumptions about what it is appropriate to control for or hold fixed"; the framework captures "the idea that properties that supervene on but that are not identical with realizing properties can be causally efficacious." [A] Woodward, "Interventionism and Causal Exclusion", *Philosophy and Phenomenological Research* 91 (2015): 303–347, [doi:10.1111/phpr.12095](https://doi.org/10.1111/phpr.12095).
- A stronger result: the exclusion principle's truth "is a contingent matter"; "downwards exclusion … occurs when there exists a supervenient difference-making cause that excludes a subvenient one"; where a relation is "realization-insensitive", "we have good reason to believe in the causal autonomy of higher-level properties." [P] List and Menzies, "Nonreductive Physicalism and the Limits of the Exclusion Principle", *Journal of Philosophy* 106 (2009): 475–502, [doi:10.5840/jphil2009106936](https://doi.org/10.5840/jphil2009106936). Woodward does not follow them: he does not hold that an upper-level causal claim excludes the lower-level one [P*: Woodward 2021, n. 23].
- The objection: Woodward's theory "excludes supervening macro properties from having a causal influence on effects of their micro supervenience bases", on "weaker premises than classical exclusion arguments"; the amended definition of an intervention makes the favourable verdict a matter of definition. [A] Baumgartner, "Interventionist Causal Exclusion and Non-reductive Physicalism", *International Studies in the Philosophy of Science* 23 (2009): 161–178, [doi:10.1080/02698590903006909](https://doi.org/10.1080/02698590903006909); "Rendering Interventionism and Non-Reductive Physicalism Compatible", *Dialectica* 67 (2013): 1–27, [doi:10.1111/1746-8361.12008](https://doi.org/10.1111/1746-8361.12008) [A].

**Proportionality: one real grain, or a grain relative to a question?**

- Proportionality is "a matter of degree"; irrelevance is always relative to an explanandum; the criteria "are meant to apply only to explanations that are actually produced or exhibited". [P*: Woodward 2021, nn. 11, 22, Appendix 1] The term comes from Yablo, "Mental Causation", *Philosophical Review* 101 (1992): 245–280, [doi:10.2307/2185535](https://doi.org/10.2307/2185535) [C].
- "Some choices of variables are superior to other choices for the purpose of causal analysis"; once goals are fixed, whether a choice serves them is "an 'objective' matter". [P*] Woodward, "The Problem of Variable Choice", *Synthese* 193 (2016): 1047–1072, [doi:10.1007/s11229-015-0810-5](https://doi.org/10.1007/s11229-015-0810-5).
- Stability "has to do with whether a causal relationship continues to hold under changes in background conditions." [P*] Woodward, "Causation in Biology: Stability, Specificity, and the Choice of Levels of Explanation", *Biology and Philosophy* 25 (2010): 287–318, [doi:10.1007/s10539-010-9200-z](https://doi.org/10.1007/s10539-010-9200-z).
- A decision-theoretic version: the thesis that proportionality gives depth "is not generally true of probabilistic causal relationships"; the best granularity is relative to "a given explanandum, agent, and decision problem." [A] Kinney, "On the Explanatory Depth and Pragmatic Value of Coarse-Grained, Probabilistic, Causal Explanations", *Philosophy of Science* 86 (2019): 145–167, [doi:10.1086/701072](https://doi.org/10.1086/701072).

So on Woodward's own account proportionality is graded and relative to the effect and contrast in question. It ranks variables for a given explanandum. It does not pick out a uniquely real grain, and he does not let it exclude the lower level. [I] IITFW §2's sentence, "which grain does the causing is settled the interventionist way: by proportionality to the question", is Woodward's view only with the last three words stressed.

**The variables problem at full strength.** Interventionism "remains maximally open about what sorts of things might be related as cause and effect"; variables are "simply anything … that can vary". The letter of proportionality is "impotent to choose between levels". Adding exhaustivity "recommends maximally disjunctive accounts". Balancing exhaustivity against stability is met by a "disjunction of conjunctions". The standards "do not suffice, individually or in combination". The exits are metaphysical naturalness, "some instrument—however mysterious … is required to locate the explanatorily apt variables in the bottomless interventionist pit", or a pragmatic limit, which is "too deeply anthropocentric". The problem "is not actually one for interventionists alone". [P] Franklin-Hall, "High-Level Explanation and the Interventionist's 'Variables Problem'", *BJPS* 67 (2016): 553–577, [doi:10.1093/bjps/axu040](https://doi.org/10.1093/bjps/axu040), <https://bpb-us-e1.wpmucdn.com/wp.nyu.edu/dist/f/14758/files/2019/06/Franklin-Hall-2016-High-Level-Explanation-and-the-Interventionists-Variables-Problem.pdf>. One reply: moderately abstract explanations "optimally subserve what interventionists regard as the goal of explanation" [A] (Blanchard, "Explanatory Abstraction and the Goldilocks Problem", *BJPS* 71 (2020): 633–663, [doi:10.1093/bjps/axy030](https://doi.org/10.1093/bjps/axy030)).

**Relation to Ladyman and Ross.** The exclusion argument conflicts "with a particular metaphysical conception of cause rather than either Humean causes, or the operational idea of causation associated with everyday and scientific explanation and prediction"; "the distinction between Humeanism and a thick notion of causation that is based on an outdated model of the physical world is not exhaustive. Ladyman and Ross (2007, Chapter 5) and Ross and Spurrett (2007) advocate a nonHumean naturalist view of causation". [P: Ladyman 2008, pp. 751, 754] ETMG ch. 5 itself was not reached; the common report that it treats causation as a notion of the special sciences, absent from fundamental physics, is [U].

**Verdict.** [I] Interventionism is not a rival ontology. It is the methodology that claim (a) already leans on: "interventions … repeatedly respect it" is stability plus conditional irrelevance. Adopting it wholesale changes two things.

1. Claim (a) inherits the variables problem. Interventionist criteria alone do not fix the grain. The essay must say what does: compression or projectibility (which Franklin-Hall would call naturalness in disguise), relativity to an explanandum and a goal (Woodward, Kinney), or an intrinsic maximum (IIT). §5.5 proposes admissibility of the map as the place to put the answer.
2. Claim (e) gets a sharper form and a live objection. The blog has used three formulations that are not the same. P&A:93 says one causal pattern under two descriptions, which is an identity claim. IITFW §2 says the grain that causes is fixed by proportionality, which is List and Menzies' downward exclusion if read strongly. Woodward's own position is that neither level excludes the other. The essay must pick one, and Baumgartner's objection applies to the second and third.

Claims (b), (c) and (d) are untouched, and Woodward's deflationary reading of levels suits (b).

---

## 4. Alter's structure-and-dynamics argument

### 4.1 The book

Alter, *The Matter of Consciousness: From the Knowledge Argument to Russellian Monism* (OUP, 2023), [doi:10.1093/oso/9780198840459.001.0001](https://doi.org/10.1093/oso/9780198840459.001.0001), <https://academic.oup.com/book/45669>. All chapters are paywalled. **Only abstracts, keywords and section headings were read.** Every statement below about what the book argues is [A] unless marked otherwise.

- Sixteen chapters in three parts (Crossref). Part I, the epistemic gap: 1 Introduction; 2 The Significance of Structure (pp. 26–37); 3 Structure, Physical Knowledge, and Ignorance (38–54); 4 Phenomenal Knowledge without Experience; 5 Non-Propositional Phenomenal Knowledge; 6 Phenomenal Representation. Part II, the modal gap: 7–11. Part III, the ontological gap: 12 The Supervenience Requirement on Physicalism; 13 Two Final Objections; 14 Consciousness and Fundamentality; 15 The Knowledge Argument, Russellian Monism, and Causal Integration (225–240); 16 Conclusion.
- "This book defends Frank Jackson's knowledge argument against physicalism." The argument has three steps: "the Mary case is used to establish a physical-phenomenal epistemic gap", then a modal gap, then an ontological gap. Ch. 15 "argues that, given plausible assumptions, the knowledge argument leads to Russellian monism."
- The conclusion is disjunctive: Alter "thinks that the correct conclusion of the knowledge argument is not simply that physicalism is false, but rather that either physicalism is false or Russellian monism is true" [S: Montero 2024, p. 238].
- His précis: Alter, "Précis of *The Matter of Consciousness*", *Philosophia* 52 (2024): 203–210, [doi:10.1007/s11406-024-00730-8](https://doi.org/10.1007/s11406-024-00730-8) [A; one footnote P]: "That gloss on 'structure,' which is rough, is based on Chalmers's (2010). For refinements, see TMOC, ch. 2. There I also discuss an alternative, more metaphysically oriented notion of structure, based on work by Pereboom".

### 4.2 The argument

**Chalmers's original.** "First: Physical descriptions of the world characterize the world in terms of structure and dynamics. Second: From truths about structure and dynamics, one can deduce only further truths about structure and dynamics." "And third: truths about consciousness are not truths about structure and dynamics." [P] Chalmers, "Consciousness and Its Place in Nature" (2003), §7, [doi:10.1002/9780470998762.ch5](https://doi.org/10.1002/9780470998762.ch5), <https://consc.net/papers/nature.html>.

- Causal role is inside "structure" from the start: structural properties include those "defined in terms of spaces of states that have a certain abstract structure ... such that the states play a certain causal role with respect to other states." [P]
- On whether the argument proves too much (life, chemistry): "the complex properties that are entailed are nevertheless structural and dynamic: they describe complex spatiotemporal structures and complex dynamic patterns of behavior over those structures." Life is entailed because "broadly functional notions provide the conceptual hook"; for consciousness "no such conceptual hook is available". [P]
- Step three rests on Mary: she "could know from her black-and-white room all about the spatiotemporal structure and dynamics of the world at all levels, but this will not tell her what it is like to see red." Denying it: "The only remotely tenable way to do this would be to embrace type-A materialism". [P]
- On phenomenal structure: "this structure is a distinctively phenomenal structure, quite different in kind from the spatiotemporal and formal structure present in physics." [P]
- The later statement: "the really fundamental gap is not the gap between physical and phenomenal truths but the gap between structural and phenomenal truths". Structural truths are "those involving logical, mathematical, causal, nomic expressions and perhaps a few more topic-neutral expressions (but not phenomenal expressions)." "No structural claim ever a priori entails a positive phenomenal claim." And on the present topic: "Many contemporary structural realists accept precisely that physical descriptions are topic-neutral." [P] Chalmers, "Spatiotemporal Functionalism v. the Conceivability of Zombies", *Noûs* 54 (2020): 488–497, §4, [doi:10.1111/nous.12331](https://doi.org/10.1111/nous.12331), <https://consc.net/papers/stoljar.pdf>. A footnote there: "Alter 2016 gives a thorough exposition, analysis, and defense."

**Alter 2016.** "The Structure and Dynamics Argument against Materialism", *Noûs* 50 (2016): 794–815, [doi:10.1111/nous.12134](https://doi.org/10.1111/nous.12134). **Not reached.** The premises as quoted from p. 795 by a later paper [S: Mărăşoiu 2020]:

1. "All physical truths are purely structural."
2. "From purely structural truths, one can deduce only further purely structural truths."
3. "Some truths about consciousness are not purely structural."
4. "Therefore, there are truths about consciousness that cannot be deduced from (i.e., are not a priori entailed by) the complete physical truth."

So the 2016 argument ends at the epistemic gap. The modal and ontological steps are separate; in the book they are Parts II and III. [I] How Alter 2016 argues for premise 3 is [U].

**How "structural" is defined.**

- Chalmers's formal version: "a structural-dynamical description is one that is equivalent to a Ramsey sentence whose O-terms include at most spatiotemporal expressions, nomic expressions, and logical and mathematical expressions" [S: Stoljar 2014, quoting Chalmers, *The Character of Consciousness*, OUP, 2010, [doi:10.1093/acprof:oso/9780195311105.001.0001](https://doi.org/10.1093/acprof:oso/9780195311105.001.0001)].
- Alter adopts "a modified version" of "Chalmers's linguistically oriented characterization, on which structural descriptions are those that involve only mathematical, logical, nomic/causal, and perhaps spatiotemporal terms", and also discusses "a metaphysically oriented characterization, based on Derk Pereboom's ideas" [A: ch. 2 abstract]. The "perhaps" is there "to exclude the temporal properties of the Cartesian mind and other fundamentally mental phenomena" (Alter, p. 33) [S: Montero 2024, p. 238].
- Pereboom's notion: "P is an absolutely intrinsic property of X just in case P is an intrinsic property of X and P is not grounded in extrinsic properties of either X or parts of X." [P: SEP-RM] It was introduced to answer Stoljar's counterexample that an intrinsic property can be derived from a relational one "just by shifting what thing you are talking about". Alter's reply was that "the property being married is purely structural/dynamic despite being intrinsic to the Spratts" [S: Pereboom, draft of his chapter in Alter and Nagasawa 2015, <https://derkpereboom.philosophy.cornell.edu/files/2021/04/RM_AN4.pdf>, P for the draft].

**What supports premise 3 in the book.** The Mary case. Ch. 2 "begins by developing a structural explanation of Mary's post-release epistemic progress": what she learns from lectures "is structural, and the truths she learns from seeing colors for herself cannot be deduced from structural truths." [A] It is not an inverted-spectrum argument, and it is not an appeal to acquaintance, since ch. 5 argues against the acquaintance-only reading. [I, from abstracts]

**The argument without structuralism about physics.** Russellian monism supports only a conditional: "if structuralism about physics is true, then there is more to consciousness and to the rest of concrete reality than physics describes." The argument "can be reformulated without relying on structuralism about physics." A footnote gives the reformulation: "1. There are phenomenal truths that cannot be deduced from structural truths. 2. If [so], then there are phenomenal truths that are over and above structural truths. 3. On all non-Russellian physicalist theories, there are no phenomenal truths that are over and above structural truths." [A; footnotes P] Alter and Pereboom, "Russellian Monism and Structuralism About Physics", *Erkenntnis* 88 (2023): 1409–1428, [doi:10.1007/s10670-021-00408-7](https://doi.org/10.1007/s10670-021-00408-7).

After this paper premise 1 is optional. The whole load sits on the non-deducibility of phenomenal truths from structural truths. A structural realist who agrees that physics is structural has conceded nothing Alter needs, and has disagreed with nothing he needs either. [I]

### 4.3 What Alter says about structural realism and about illusionism

- "Structuralism about consciousness" as a target is not Ladyman-style realism and not the consciousness-science programme. It is any view on which structural truths a priori entail all phenomenal truths. SEP-RM names analytic functionalism as the view that "conflicts with the Russellian monist's denial that structural truths alone a priori entail all phenomenal truths" [P]. Chalmers calls the denial of step three type-A materialism. [I for the identification]
- Whether the book mentions Ladyman, Ross or French is not confirmed. No chapter abstract or keyword list that was read mentions them, and the index was not reachable. [A]
- What Alter says in print: on some respectable views physics involves "just structure or dispositions all the way down" "(e.g., Ladyman and Ross, with Spurrett and Collier 2007; Ney 2015 ...)". "But Russellian monists and others (e.g., Lewis 2009) regard such structuralist or dispositionalist views as implausible", because they "seem to yield a world devoid of substance or qualities". "A world devoid of substance or qualities might or might not be possible. But according to realism about quiddities, the actual world is not like that." [P: SEP-RM §1.1] No further argument against ontic structural realism is given there. Elsewhere the entry uses Ladyman and Ross constructively: "physical theory itself is neutral between a Russellian monist interpretation ... and a structuralist interpretation according to which such terms do not refer to quiddities" [P: SEP-RM §4.1].
- On illusionism the book has two relevant places. Ch. 4 answers Dennett and Mandik: to think the intuition about Mary rests on "experience is necessary" "is to miss the key role of a priori deducibility in the knowledge argument." Ch. 6 §6.4, "Introspective Misrepresentation", answers Pereboom: "there is insufficient evidence for a sort of introspective misrepresentation" of the kind needed. [A; the second partly paraphrased by the fetch] Frankish and Kammerer appear in no abstract or keyword list seen.

### 4.4 Published replies

**Stoljar's trilemma** is the sharpest. "If a philosopher mentions 'structure' in the course of developing an argument or objection, the first thing you should do is ask what precisely is meant."

- Mathematical structure: premise 1 fails, since such characterizations "are mathematical rather than empirical" (Newman again).
- Relations: all three premises fail. "It is false that from truths about relations you can only derive more truths about relations"; physics describes one-place properties; "some truths about consciousness are themselves relational."
- Pereboom's absolutely intrinsic properties: premise 2 becomes "analytic", and premise 3 loses its support, since whether phenomenal truths concern absolutely intrinsic properties "seems to me something that is left open by anything we know or believe about consciousness, either as a matter of theory or as a matter of introspection."
- Chalmers's nomic and spatiotemporal reading: either the properties that cause experience count as physical, and then "we are in no position to assert that no truth about consciousness is a truth about them", or physics tells us only about role-fillers, and premise 1 is denied.

[P] Stoljar, "Four Kinds of Russellian Monism", in Kriegel (ed.), *Current Controversies in Philosophy of Mind* (Routledge, 2014), 17–39, [doi:10.4324/9780203116623-1](https://doi.org/10.4324/9780203116623-1), draft <https://openresearch-repository.anu.edu.au/bitstreams/8c66fb64-07b6-40cf-9f58-874a259b97da/download>, pp. 20–22. Related: Stoljar, *Ignorance and Imagination* (OUP, 2006), [doi:10.1093/0195306589.001.0001](https://doi.org/10.1093/0195306589.001.0001) [C]; "Chalmers v Chalmers", *Noûs* 54 (2020): 469–487, [doi:10.1111/nous.12334](https://doi.org/10.1111/nous.12334) [A]. No direct reply by Stoljar to Alter 2016 was found.

**Is the argument question-begging?** On Pereboom's notion, "A core premise in the structure and dynamics argument is epistemological – that we know via introspection and various forms of a priori reasoning that our phenomenal properties are non-structural." [P] Mendelow, PhD thesis, ANU (2026), ch. 2, <https://openresearch-repository.anu.edu.au/bitstreams/4ef31879-7557-4127-a88e-0528a81d759a/download>; article version "Russellian Monism and Ignorance of Non-structural Properties", *Australasian Journal of Philosophy* 102 (2024): 372–388, [doi:10.1080/00048402.2023.2243622](https://doi.org/10.1080/00048402.2023.2243622) [A]. Reply: Alter and Pereboom, "Mendelow on Russellian Monism and Absolutely Intrinsic Properties", *AJP* (2026), [doi:10.1080/00048402.2026.2669939](https://doi.org/10.1080/00048402.2026.2669939) [A].

**Which materialists does it reach?** Type-A materialists "would deny (3)", so the argument "couldn't target them without begging the question on (3)"; type-B materialists accept the conclusion. Only the type-C view is a proper target. [P] Mărăşoiu, "The Structure and Dynamics Argument against Materialism Revisited", *Problemos* 98 (2020): 136–140, [doi:10.15388/Problemos.98.12](https://doi.org/10.15388/Problemos.98.12).

**The *Philosophia* symposium** (vol. 52, no. 2, 2024; Crossref issue listing).

- Montero is the only contributor who attacks the structural premise. A structural gloss on the physical "devolves into a via negativa account of the physical as the fundamentally not mental" (p. 238). On premise 2's positive side: "I don't have much confidence that these higher-level facts could be logically deduced from purely structural facts" (p. 239). [P] Montero, "The Gap in the Knowledge Argument", *Philosophia* 52 (2024): 235–244, [doi:10.1007/s11406-024-00732-6](https://doi.org/10.1007/s11406-024-00732-6).
- Kind, "What Counts as Cheating? Deducibility, Imagination, and the Mary Case", 211–220, [doi:10.1007/s11406-024-00717-5](https://doi.org/10.1007/s11406-024-00717-5) [P, abstract and text search]: probes the deducibility standard; does not discuss structure.
- Jackson, "Does Representationalism Offer a Reply to the Knowledge Argument?", 221–228, [doi:10.1007/s11406-023-00703-3](https://doi.org/10.1007/s11406-023-00703-3) [A]: "I agree with Torin Alter that physicalists should be a priori physicalists."
- Howell, "Introspection, Consciousness and the Mind-Body Problem", 229–234, [doi:10.1007/s11406-024-00748-y](https://doi.org/10.1007/s11406-024-00748-y) [A].
- Alter, "Replies to Howell, Jackson, Kind, and Montero", 245–255, [doi:10.1007/s11406-024-00745-1](https://doi.org/10.1007/s11406-024-00745-1) [P, footnotes only; the body was not reached]. To Montero he points to "TMOC, p. 225 and chs. 1.5, 2" and "TMOC, pp. 50–54 and ch. 10".

**Reviews.** Coleman, *Australasian Journal of Philosophy* 103 (2025): 282–287, [doi:10.1080/00048402.2024.2415133](https://doi.org/10.1080/00048402.2024.2415133) [A, first line only]. Morris, "Acquaintance and Mary's Revelation: A Response to Alter", *Philosophia* 53 (2025): 1513–1528, [doi:10.1007/s11406-025-00930-w](https://doi.org/10.1007/s11406-025-00930-w) [A]. No review was found in *Notre Dame Philosophical Reviews*, *Mind*, *Philosophical Review*, *Analysis*, *Philosophical Quarterly*, the *Journal of Consciousness Studies* or *Dialectica*. PhilPapers' own list of reviews could not be opened.

**Structuralists about consciousness.** None of them claims what the blog needs.

- "Any phenomenal experience is fully individuated by its place in a Q-structure." But on inversion of quiddities: "As a metaphysical possibility, I fear, this cannot be ruled out. And it certainly cannot be captured by any structuralist conception. If this is the core difficulty about qualia, then the hard problem cannot be solved structurally." The rejoinder is that positing primitive qualia "just repeats its very statement in terms of mysterious and excessive metaphysics." [P] Lyre, "Neurophenomenal Structuralism", *Neuroscience of Consciousness* 2022: niac012, [doi:10.1093/nc/niac012](https://doi.org/10.1093/nc/niac012).
- "If ontic phenomenal structuralism is true, then there are no intrinsic phenomenal properties, and no genuinely private properties. Ontic structural realism implies that there are no qualia as conventionally understood (Dennett, 1988)." But mathematical-structure methods "do not in themselves have metaphysical premises". [P] Kleiner, "Towards a Structural Turn in Consciousness Science", *Consciousness and Cognition* 119 (2024): 103653, [doi:10.1016/j.concog.2024.103653](https://doi.org/10.1016/j.concog.2024.103653).
- "Structural facts are objective. Yet there still remains an explanatory gap between physical facts and structural facts about experience." [P] Lee, "Objective Phenomenology", *Erkenntnis* 89 (2024): 1197–1216, §5.5, [doi:10.1007/s10670-022-00576-0](https://doi.org/10.1007/s10670-022-00576-0).
- Only one paper denies the step outright: "the objects of physics and other natural sciences can be indeed fully analyzed in structural terms, but that so can be consciousness." Consciousness is "a complex neural pattern that misperceives some of its own highly complex structural properties as monadic and qualitative." [P] Loorits, "Structural Qualia: A Solution to the Hard Problem of Consciousness", *Frontiers in Psychology* 5 (2014): 237, [doi:10.3389/fpsyg.2014.00237](https://doi.org/10.3389/fpsyg.2014.00237). This is the nearest published relative of GRAIN:85.
- Others: Fink, Kob and Lyre, "A Structural Constraint on Neural Correlates of Consciousness", *Philosophy and the Mind Sciences* 2 (2021), [doi:10.33735/phimisci.2021.79](https://doi.org/10.33735/phimisci.2021.79) [P, abstract and p. 3]; Kob, "Exploring the Role of Structuralist Methodology in the Neuroscience of Consciousness", *Neuroscience of Consciousness* 2023: niad011, [doi:10.1093/nc/niad011](https://doi.org/10.1093/nc/niad011) [A]; Isaac, "Structural Realism for Secondary Qualities", *Erkenntnis* 79 (2014): 481–510, [doi:10.1007/s10670-013-9519-3](https://doi.org/10.1007/s10670-013-9519-3) [A]; Tsuchiya and Saigo, "A Relational Approach to Consciousness", *Neuroscience of Consciousness* 2021: niab034, [doi:10.1093/nc/niab034](https://doi.org/10.1093/nc/niab034) [A]; Mindt, "Not All Structure and Dynamics Are Equal", *Entropy* 23 (2021): 1226, [doi:10.3390/e23091226](https://doi.org/10.3390/e23091226) [P, abstract and §1].

**Ladyman on consciousness.** "Our metaphysics should be structuralist so that reality is to be thought of as structure and relations rather than in terms of fundamental individuals. I am not sure what implications this has for debates about consciousness." "In general I think positing extra physical properties solely to account for emergent phenomena is not fecund in science." [P] Interview, *Interalia Magazine*, 18 Nov 2015, <https://www.interaliamag.org/interviews/james-ladyman/>. No published reply by Ladyman, Ross or French to the structure-and-dynamics argument was found [U as an absence]. No passage of ETMG on qualia was located.

### 4.5 Assessment

All [I].

1. **Which premise the blog must deny.** Not premise 1: the blog asserts a stronger, ontological version of it. Not premise 2 by appeal to modality: Chalmers's and Alter's "structural" vocabulary includes nomic and causal terms, so modal structure is already inside the structural, and Pereboom's remark that Mary could learn powers in the room says the same from the Russellian side. No paper was found arguing that premise 2 presupposes a non-modal notion of structure, and the objection would misfire. The blog must deny premise 3: every truth about consciousness is a structural truth, or is fixed by structural truths.
2. **Two ways to deny it.** Type-A: phenomenal truths are a priori entailed by structural truths, and the appearance otherwise is a structural fact to be explained. Type-B: grant the epistemic gap and block the step to a modal gap. GRAIN:85's account, "the paradigm of an intrinsic nature is structure below the grain of recognition", is on its face a type-A explanation of why Mary cannot deduce what she later recognizes. It could be read as type-B. The essay has to say which, because Alter has a different answer ready for each.
3. **What Alter says back.** Against type-A: the datum is about a priori deducibility and not about whether experience is the only route to the knowledge (ch. 4); and the introspective-error story needs evidence of a specific misrepresentation, which he says is lacking (ch. 6.4). Against type-B: Part II, on which a posteriori physicalism needs primitive a posteriori necessities and the phenomenal-concept strategy fails Chalmers's dilemma. Against structural realism as metaphysics: only the SEP sentence that such views are "implausible" because they "seem to yield a world devoid of substance or qualities". That is an intuition, and GRAIN:85 is a debunking explanation of exactly that intuition.
4. **Where the blog's reply is strongest.** At ch. 6.4. Alter asks for evidence of a specific introspective misrepresentation. The grain account names one: recognition is coarser than presence, so a structured occurrence is recognized without its structure, and the recognition adds "and that is all". Whether that counts as the evidence Alter asks for can only be judged after reading §6.4.
5. **Where Alter is weakest on his own ground.** Stoljar and Mendelow: on every available reading of "structure", premise 1 or premise 3 lacks support, and on Pereboom's reading premise 2 is analytic while premise 3 is "left open by anything we know". The essay can use this, with one caution. Stoljar's own exit is ignorance of a further kind of physical property, which a structuralist without natures cannot take.
6. **Where the debate stands.** There is no direct exchange. Alter has not argued against ontic structural realism beyond the SEP sentence, and Ladyman declines to draw consequences for consciousness. The structural realist denies premise 3 and owes an account of the Mary intuition. Alter asserts premise 3 on the strength of Mary and owes a characterization of "non-structural" that does not beg the question. Neither debt has been paid in print against the other party. An essay that pays the first would be new.

---

## 5. The two criteria: morphism and intervention

Short answer: the literature does not treat them as equivalent or as rivals. It treats them as two components of one definition, read in two directions. Neither component blocks triviality without a third ingredient, a restriction on which maps or which interventions are admissible, and the blog already uses that ingredient without naming it.

### 5.1 What each criterion is called in the literature

**The morphism criterion is a restricted mapping account of computational implementation.** The SEP entry sorts accounts of implementation into the simple mapping account, which only asks that physical transitions mirror computational ones, and restricted mapping accounts, which strengthen the mirror. On the counterfactual version, "the counterfactual relations between the physical states [must] be isomorphic to the counterfactual relations between the computational states"; on the causal version, "concrete computation is the causal structure of a physical process." Triviality arguments "rely either implicitly or explicitly on the simple mapping account." [P] Piccinini and Maley, "Computation in Physical Systems", SEP, rev. 20 Aug 2025, §§2.1–2.2, 3, <https://plato.stanford.edu/entries/computation-physicalsystems/>.

- Chalmers's wording is close to CCI:35: "the relation between an implemented computation and an implementing system is one of isomorphism between the formal structure of the former and the causal structure of the latter." [P] Chalmers, "A Computational Foundation for the Study of Cognition" (written 1993, *Journal of Cognitive Science* 2012), §2.2, <https://consc.net/papers/computation.html>. Its §2 was published as "On Implementing a Computation", *Minds and Machines* 4 (1994): 391–402, [doi:10.1007/bf00974166](https://doi.org/10.1007/bf00974166) [S: the companion paper's header].
- The conditionals "have modal force, and in particular are required to support counterfactuals." Counterfactuals alone do not suffice: a system with a clock and a dial still implements every inputless automaton. Chalmers adds combinatorial structure: "What does the work is precisely the combinatorial nature of the states, through the requirement that the parts of an internal state are independently variable." [P] Chalmers, "Does a Rock Implement Every Finite-State Automaton?", *Synthese* 108 (1996): 309–333, <https://consc.net/papers/rock.html>.
- Rescorla names the view "structuralism about computational implementation" and grants that mirroring is necessary but "does not generally suffice". His footnote 6 draws the connection this essay needs: "There are affinities between structuralism about computational implementation and broadly 'structuralist' views within philosophy of science more generally", with the caution that a further premise is needed. [P] Rescorla, "A Theory of Computational Implementation", *Synthese* 191 (2014): 1277–1307, [doi:10.1007/s11229-013-0324-y](https://doi.org/10.1007/s11229-013-0324-y), author PDF <https://philosophy.ucla.edu/wp-content/uploads/2016/08/Computational-Implementation.pdf>.
- Putnam's and Searle's own texts were not opened (Putnam, *Representation and Reality*, MIT Press, 1988, [doi:10.7551/mitpress/5891.001.0001](https://doi.org/10.7551/mitpress/5891.001.0001); Searle, *The Rediscovery of the Mind*, MIT Press, 1992, [doi:10.7551/mitpress/5834.001.0001](https://doi.org/10.7551/mitpress/5834.001.0001)). [S: SEP §3; Sprevak 2018] Putnam "argues that every ordinary open system implements every abstract finite state automaton (without inputs and outputs)". Sprevak, "Triviality Arguments about Computational Implementation", in *Routledge Handbook of the Computational Mind* (2018), 175–191, [doi:10.4324/9781315643670-14](https://doi.org/10.4324/9781315643670-14) [P, author PDF].

**The intervention criterion is interventionist individuation of variables.** Its purest statement is the fundamental causal partition: "two elements of I belong to the same causal class if they have the same causal effect on J." The macro-variable is the quotient of micro-states by sameness under manipulation, and no high-level model is supplied in advance. [P] Chalupka, Eberhardt and Perona, "Multi-Level Cause-Effect Systems", [arXiv:1512.07942](https://arxiv.org/abs/1512.07942) (AISTATS 2016, venue not confirmed from the text).

- When a coarse model is an exact transformation of a fine one, "we can view the Y-variables as causal entities, rather than only functions of underlying 'truly' causal entities." This is GRAIN:125's "earns reality" in the vocabulary of structural equation models. [P] Rubenstein et al., "Causal Consistency of Structural Equation Models", UAI 2017, [arXiv:1707.00819](https://arxiv.org/abs/1707.00819) (quotations rechecked in the arXiv text by the main pass).
- Exactness is relative to the family of interventions: "If we were to allow larger sets of interventions … the transformations given would not be exact." [P] same paper. This is GRAIN:125's "relative to families of interactions", proved.

### 5.2 Verdict: one definition with two arguments

**(a) Formally, the two are halves of one definition.** In the causal-abstraction literature a high-level model abstracts a low-level one when there is a pair of maps, τ on states and ω on interventions, such that intervening and then abstracting equals abstracting and then intervening.

- Rubenstein et al., Definition 3: an exact τ-transformation requires "a surjective order-preserving map ω" on interventions with the push-forward of each intervened low-level distribution equal to the high-level distribution under the mapped intervention. [P]
- Beckers and Halpern tighten this in steps, to a uniform version that "does not allow differences to be hidden by the 'right' choice of distribution", then to τ-abstraction, where "the mapping ω is determined by τ". [P] Beckers and Halpern, "Abstracting Causal Models", AAAI 2019, [arXiv:1812.03789](https://arxiv.org/abs/1812.03789).
- Geiger et al., Definition 25: "M∗ is an exact transformation of M under (τ, ω) if for all I ∈ Domain(ω), the following diagram commutes." [P] Geiger et al., "Causal Abstraction: A Theoretical Foundation for Mechanistic Interpretability", *JMLR* 26 (2025), [arXiv:2301.04709](https://arxiv.org/abs/2301.04709).
- Category-theoretic versions exist, so "morphism" is literal. An abstraction is a natural transformation between functors, and interventions translate consistently. [P] Otsuka and Saigo, "On the Equivalence of Causal Models: A Category-Theoretic Approach", CLeaR 2022, [arXiv:2201.06981](https://arxiv.org/abs/2201.06981). "We introduce a category of finite interventional causal models." [P, introduction and definitions] Rischel and Weichwald, UAI 2021, [arXiv:2103.15758](https://arxiv.org/abs/2103.15758). A review states the shared requirement as "a map that would commute (or approximately commute) with respect to interventions". [P] Zennaro, [arXiv:2207.08603](https://arxiv.org/abs/2207.08603).
- The implementation literature reaches the same shape. Millhouse "construes a 'computational interpretation' as an ordered pair of functions mapping (i) states of a physical system to states of an abstract machine, and (ii) inputs to this machine to interventions in this physical system." [A] Millhouse, "A Simplicity Criterion for Physical Computation", *BJPS* 70 (2019): 153–178, [doi:10.1093/bjps/axx046](https://doi.org/10.1093/bjps/axx046).
- One paper states the identification outright: "Implementation as Abstraction-Under-Translation: Given a computational model H, another system L implements H just if H is an abstraction-under-translation of L (relative to a suitable class C of translations)." The authors say this "captures the spirit of claims in the literature that implementing is a matter of mirroring causal structure". [P] Geiger, Harding and Icard, "How Causal Abstraction Underpins Computational Explanation", [arXiv:2508.11214](https://arxiv.org/abs/2508.11214) v2, 9 Jul 2026, to appear in *Philosophy and the Mind Sciences* (quotations rechecked by the main pass).

So the structure that a causal-abstraction morphism preserves is interventional structure. CCI:35 already says this in one sentence, "Intervene on the pattern and you intervene on the physics", without noticing that it is the intervention criterion. [I]

**(b) The audit is still right that they answer different questions.** The difference is direction of fit. [I]

- The implementation question fixes the high-level model and asks whether some admissible τ exists. It is existential over maps. This is CCI:43's question.
- The variable question fixes a family of interventions and asks which quotient it induces. This is GRAIN:125's question, and Chalupka's partition is its answer.
- The two can come apart, and one theorem says how. Rosas et al. define three kinds of closure for a coarse-grained process. Information closure: the macro-history predicts the macro-future as well as the micro-history does. Causal closure: "interventions at a set of macroscopic … variables are sufficient to guarantee specific outcomes on other macroscopic variables", formalized as agreement between two predictive machines. Computational closure: the macro-level machine is a coarse-graining of the micro-level machine, so that a diagram commutes. Theorem 1: causal closure and information closure are equivalent. Theorem 2: for spatial coarse-grainings, "information closure implies computational closure". The converse fails, because "whereas the former is based on sufficiency, the latter also requires necessity". [P] Rosas et al., "Software in the Natural World", [arXiv:2402.09090](https://arxiv.org/abs/2402.09090) v2 (read in the arXiv HTML by the main pass).
- Read in the blog's terms: computational closure is the morphism criterion, causal closure is the intervention criterion, and the intervention criterion is the stronger one. A coarse-graining can commute with the dynamics and still be too coarse to be the variable that control acts on. [I] Two caveats from the paper: the result is for macro-variables that are functions of the present micro-state, and causal closure "only provides counterfactual guarantees if the system described by X is fully observed" [P, the second via the agent's reading].
- A related result runs from a morphism-type condition to closure. "Dynamical processes that are equivariant with respect to a symmetry group give rise to emergent macroscopic levels organised into a hierarchy determined by the subgroups of the symmetry", and the induced variables are "informationally self-contained". Equivariance "is sufficient for emergence, but not necessary. A necessary condition is given by Markov lumpability". [P, abstract, introduction and note 22] Rosas, "Symmetries at the Origin of Hierarchical Emergence", [arXiv:2512.00984](https://arxiv.org/abs/2512.00984), published as "Symmetry as a Common Origin of Hierarchical Emergence and Abstraction", *Science Advances* 12(46), 13 Nov 2026, [doi:10.1126/sciadv.aeh0773](https://doi.org/10.1126/sciadv.aeh0773) [A, Crossref, for the published version].

**(c) Neither criterion blocks triviality alone, and the same third ingredient rescues both.**

- Against the bare map: Putnam, and Chalmers's clock-and-dial strengthening (§5.1).
- Against bare interventionism: "Due to a lack of effective constraints on the causal variables at the heart of the interventionist causal–explanatory scheme, as presently formulated it is either unable to prefer high-level explanations to low, or systematically overshoots". [A] Franklin-Hall, "High-Level Explanation and the Interventionist's 'Variables Problem'", *BJPS* 67 (2016): 553–577, [doi:10.1093/bjps/axu040](https://doi.org/10.1093/bjps/axu040). See §3.6.
- Against the two combined: "Theorem 1. Given any algorithm A and any neural network N such that Assumps. 1 to 5 hold, we can show that A is an input-restricted distributed abstraction of N." The authors conclude that this "renders causal abstraction vacuous when used without constraints. If we restrict alignment maps to only consider, e.g., linear functions, this problem does not arise". On randomly initialised language models their maps "reach 100% interchange-intervention accuracy". [P] Sutter, Minder, Hofmann and Pimentel, "The Non-Linear Representation Dilemma", NeurIPS 2025, [arXiv:2507.08802](https://arxiv.org/abs/2507.08802) (theorem rechecked by the main pass). The paper does not cite Putnam. Geiger, Harding and Icard draw the parallel: it "essentially presents an even stronger triviality argument", since "provided we allow C to be completely unconstrained, every neural network implements every algorithm." [P]
- What survives in each debate is a restriction on the admissible maps or interventions:

| Proposal | What is restricted | Source and label |
|---|---|---|
| Combinatorial states | components must vary independently | Chalmers 1996 [P] |
| Causal similarity | micro-states grouped under one formal state must be physically alike; "a gradient distinction between better and worse realizations" | Godfrey-Smith, "Triviality Arguments against Functionalism", *Phil. Studies* 145 (2009): 273–295, [doi:10.1007/s11098-008-9231-3](https://doi.org/10.1007/s11098-008-9231-3) [P, author preprint] |
| Simplicity | "the Kolmogorov complexity of the interpretation"; "draws on earlier work on real patterns" | Millhouse 2019 [A] |
| Informational equivalence | physical states "bear neither more nor less information about the evolving computation than do the computational states they map onto" | Anderson and Piccinini, *The Physical Signature of Computation* (OUP, 2024), [doi:10.1093/9780191872075.001.0001](https://doi.org/10.1093/9780191872075.001.0001) [A; S: SEP §2.2] |
| No post-hoc labelling | "If a computational description of a physical evolution can only be applied post-hoc, then the system has not acted as a computer" | Horsman et al., "When Does a Physical System Compute?", *Proc. R. Soc. A* 470 (2014), [arXiv:1309.7979](https://arxiv.org/abs/1309.7979) [P] |
| Linearity | alignment maps restricted to linear or orthogonal | Sutter et al. [P]; Geiger et al. 2025 decline to assume it: "The ideal theoretical framework won't bake in an assumption like the linear representation hypothesis" [P] |
| Generalization | "not just any mapping from system to algorithm will do": the mapping must keep working on new inputs | Geiger, Harding and Icard [P] |
| Representational content | some models carry content the realizer must respect | Rescorla 2014 [P] |
| A user who encodes and decodes | "Without the encode and decode steps, there is no computation" | Horsman et al. [P]. This one reintroduces an observer. |

The blog's dust-man answer, that the mapping is "an arbitrary lookup table — a gerrymandered mapping that preserves nothing" (CCI:39), is an admissibility restriction of the simplicity or similarity kind. It is not delivered by the morphism clause, since Sutter et al.'s maps are morphisms that commute with every intervention considered. The clause "relative to families of interactions" (GRAIN:125) is the matching restriction on ω's domain. So the blog has all three ingredients, in three essays, under two names. [I]

### 5.3 The test case: which basis of a network is real

The case v1:153 cites is Zhou and Klindt. Read in the PDF by the main pass:

- Theorem 4.1 (linear identifiability): with enough width, "every global minimizer (U, h) of the cross-entropy satisfies h(z) = Az + ν(z)". The authors' gloss: "the best it can do for supervised classification is recover the latent variables up to linear mixing." The task fixes the representation up to a linear map and no further.
- Theorem 4.3 (axis-aligned neurons): among those minimizers, the one of least activation energy, with non-negative activations and exact capacity, satisfies h(z) = DP_σ z: "the representation is identifiable up to permutation and component-wise positive scaling."
- Theorem 4.4: with sparse latents and a spark condition, individual latents are recoverable by sparse decoding, "an explanation for why sparse autoencoders work."
- Theorem 4.2: with too little width, "identifiability fails generically".
- Limits they state: signed latents fall outside Theorem 4.3; the assumptions "rarely hold exactly in real data".

[P] Zhou and Klindt, "Complete or Sparse: A Tale of Two Identifiabilities", [arXiv:2610.20851](https://arxiv.org/abs/2610.20851) v2, 19 Oct 2026. The blog's earlier record of it is in `architecture-interpretability-and-audit.md`:519.

Neighbouring results, which turn the single case into a pattern:

- The function alone leaves a full linear symmetry. "We could transform the residual stream by an arbitrary full-rank linear transformation, and then also multiply the same transformation into every other matrix … and arrive at an identical function with completely different coordinates." [P] Elhage, Lasenby and Olah, "Privileged Bases in the Transformer Residual Stream" (2023), <https://transformer-circuits.pub/2023/privileged-basis/index.html>. "A large family of discriminative models are in fact identifiable in function space, up to a linear indeterminacy." [P] Roeder, Metz and Kingma, [arXiv:2007.00810](https://arxiv.org/abs/2007.00810).
- An elementwise nonlinearity cuts the symmetry down. The group of linear maps that commute with ReLU up to another linear map "is precisely the stabilizer of the set of rays" along the axes; every element is a permutation times a positive diagonal scaling. [P] Godfrey et al., "On the Symmetries of Deep Learning Models and their Internal Representations", NeurIPS 2022, Theorem 3.3, [arXiv:2205.14258](https://arxiv.org/abs/2205.14258). The term comes from Elhage et al.: an activation function "'breaks the symmetry', making those directions special", though "having a privileged basis doesn't guarantee that features will be basis-aligned". [P] "Toy Models of Superposition" (2022), <https://transformer-circuits.pub/2022/toy_model/index.html>.
- The optimizer can break a symmetry the forward function keeps. "The Adam optimizer tracks moments and normalizes the gradient update in a pointwise manner, and thus privileges the basis that the weights are stored in", hedged by "we cannot claim to have conclusively put the blame on Adam". The same paper finds that "Transformers do not rely on a privileged basis to train and function properly … that effect seems to be a side effect more than it is necessary." [P] Elhage, Lasenby and Olah 2023 (both quotations rechecked by the main pass).
- A family of interventions can fix geometry that the function leaves open. Because the loss sees only output probabilities, a representation "is identified (at best) only up to some invertible affine transformation"; a "causal inner product" is then defined as the one that makes causally separable concepts orthogonal. [P] Park, Choe and Veitch, "The Linear Representation Hypothesis and the Geometry of Large Language Models", ICML 2024, [arXiv:2311.03658](https://arxiv.org/abs/2311.03658).
- A permutation symmetry is never broken. Solutions "will likely have no barrier in the linear interpolation between them" once permutations are accounted for. [A] Entezari et al., ICLR 2022, [arXiv:2110.06296](https://arxiv.org/abs/2110.06296); Ainsworth, Hayase and Srinivasa, "Git Re-Basin", ICLR 2023, [arXiv:2209.04836](https://arxiv.org/abs/2209.04836) [A].
- Identifiability of interpretations fails in practice too: "multiple circuits can replicate behavior, a circuit can have multiple interpretations, several algorithms can align with the network, and one algorithm can align with different subspaces." [P] Méloux et al., "Everything, Everywhere, All at Once: Is Mechanistic Interpretability Identifiable?", ICLR 2025, [arXiv:2502.20914](https://arxiv.org/abs/2502.20914).

What the case shows, all [I]:

1. The mapping criterion applied to input–output function fixes structure up to a group. On the group-theoretic reading of structural realism, where "objects are picked out by the identification of invariants with respect to the transformations relevant to the context" ([P] Ladyman, SEP "Structural Realism", §4.1, <https://plato.stanford.edu/entries/structural-realism/>), a residual-stream "neuron" is surplus structure and the subspace is real.
2. What reduces the group is never the input–output map. It is the nonlinearity, an energy cost, the optimizer, sparsity in the data, or a chosen family of concept interventions. These are not all of one kind, and v1:151's phrase "broken by the system's own dynamics rather than by the observer's choice" has to sort them. The nonlinearity and the energy cost belong to the system's operation. The optimizer belongs to its history. The sparsity penalty of a sparse autoencoder belongs to the analyst, and is vindicated only if the latents are in fact sparse (Theorem 4.4's condition is on the data). Park's inner product depends on which concept interventions one admits.
3. The Adam result is a counterexample to the unqualified slogan. There the system's own dynamics do break the symmetry, the basis is detectable, and it does no work: the model trains as well without it. Being selected by the dynamics is not enough. The basis must also be one that interventions respect, which returns us to the intervention criterion. So the two clauses of v1:151 are not redundant, and their order matters: interventions identify the pattern, and the dynamics matter only where they change what interventions find.
4. Individual neuron identity stays conventional even when the basis is real, because the permutation symmetry is exact. What is real is the set of axes, an unordered structure. This is a clean instance of the claim that relata are "abstractions from relations" without the claim that there are none.
5. Sutter et al. give the converse. Drop the admissibility restriction and the intervention-commuting map identifies nothing. Admissibility has to be argued for, and linearity is itself an empirical hypothesis.

### 5.4 Which variant of structural realism each criterion fits

All [I], drawing on §1.

- **Morphism** fits the semantic-view strand of ontic structural realism (French, Bueno, da Costa: theories as families of models related by partial isomorphisms; §1.2). It inherits that strand's exposure to Newman's problem (§2.2): a bare structure-preserving map is cheap unless the relations it preserves are fixed independently. The implementation literature rediscovered this as Putnam's problem, and Sutter et al. rediscovered it a third time.
- **Intervention** fits the causal reading of structure: Esfeld's moderate realism with causal structures (§1.2, §3.1), and Woodward (§3.6). Among the blog's sources it is closest to the projectibility clause in the real-pattern definition (§1.4).
- **Ladyman and Ross's modal structure** covers both. "Modal structure" is "an abstraction of causal structure and nomological structure, that is intended to also include symmetry principles" ([P] SEP "Structural Realism"). Causal abstraction can be offered as a formalization of "preserving modal structure" in which the modality is interventional. Whether Ladyman and Ross would accept an interventionist reading of modal structure is not settled by anything read here. Their chapter on causation is commonly reported to treat it as a special-science notion; that report is unverified (§3.6).
- **Effective structural realism** (§1.3) supplies the relativity: a theory is true within a domain, and exactness of an abstraction is relative to a family of interventions. These are the same restriction stated for theories and for models.

### 5.5 A candidate reconciliation

A proposal for the author to accept or reject, not a finding. [I]

> A pattern is real in a system, relative to a family of interventions, when a model of the pattern is a causal abstraction of the system over that family under an admissible map.

- The morphism is the form of the relation.
- The intervention family says what the morphism must preserve, and makes reality interaction-relative in GRAIN:125's sense.
- Admissibility is the anti-gerrymandering clause. CCI:39 needs it for the dust man, and §2.5 needs it against observer-relativity.
- The two questions of AUDIT:96 become two uses of one relation. "Which coarse variables are real?" asks which quotients the family induces. "Which computations does the system realize?" asks which given models stand in the relation.

Costs to weigh:

1. Everything now rests on admissibility, and the literature has no agreed account of it (table above). The options with the best fit to a real-patterns view are Millhouse's complexity bound and the generalization requirement.
2. Interventionist semantics presupposes causal structure at the lower level. That suits CCI:11, where causation is primitive. It does not suit *Every Thing Must Go* if, as commonly reported, causation there is not part of fundamental physics (§3.6; unverified). The essay must say which it holds.
3. Exact abstraction is rare. Approximate abstraction needs an error tolerance ([A] Beckers, Eberhardt and Halpern, "Approximate Causal Abstraction", UAI 2019, [arXiv:1906.11583](https://arxiv.org/abs/1906.11583)), which is Dennett's noise threshold again and reopens the question of who sets it (§2.5).
4. "Relative to a family of interventions" must be shown to differ from "relative to an observer". Dasgupta argues that inferences from symmetry to reality run through "our powers of detection" ([A] "Symmetry as an Epistemic Notion (Twice Over)", *BJPS* 67 (2016): 837–878, [doi:10.1093/bjps/axu049](https://doi.org/10.1093/bjps/axu049)). GRAIN:129 answers by making the observer one more embedded system with a limited repertoire of interactions. That answer has to carry more weight than it does now.

---

## 6. What a shift of foundation would cost

All of this section is [I]. It applies §3 to the five claims (a)–(e) defined there.

### 6.1 The alternatives

| Alternative | (a) many grains real | (b) no privileged micro level | (c) no natures | (d) mental kinds as real patterns | (e) no added productive power |
|---|---|---|---|---|---|
| Pure powers (Bird; Esfeld 2009) | survives, re-grounded: real is what confers powers | at risk: fundamental powers | survives | survives if kinds confer powers; reducible on Esfeld and Sachse | strained: becomes identity of powers, or reduction |
| Powerful qualities (Heil, Martin) | as above | at risk | fails | as above | strained |
| Lewis's Humean supervenience | deflated: real as a summary | fails: the mosaic | fails | deflated | holds trivially, and contradicts CCI:11 |
| Better best systems; Super-Humeanism | deflated, with every vocabulary on a par | fails: matter points | survives | deflated | holds trivially |
| Russellian monism | derivative of quiddities plus structure | fails: micro or cosmic | fails | splits: function is a pattern, phenomenal character is not | contested (Howell) |
| Staunch hylomorphism (Koons) | fails: substances against heaps | survives for another reason; no overlap allowed | partly: form is not pattern | only for substances | fails: forms add powers |
| IIT | fails: one maximum per substrate | partly: one privileged grain per complex | partly | fails for functionally individuated kinds | fails: the lower level is eliminated |
| Interventionism (Woodward) | survives; it is the criterion. Inherits the variables problem | survives | untouched | survives | sharpened; three formulations to choose among |

Reading the table:

- **Only interventionism keeps all five**, and it does so because it is a methodology and not an ontology. Adopting it is not a shift. It is a commitment to pay the variables problem.
- **Pure powers keeps the most among real ontologies**, and it fits CCI:11's primitive causation better than Ladyman and Ross do. Its cost is the return of bearers and of a fundamental level. Esfeld shows it can be held inside structural realism, so this would be a move within the family (§6.2).
- **The Humean options keep the letter of the claims and change their force.** Patterns stay real as summaries, exclusion vanishes, and modality is conferred by the best system. The blog would lose the answer to Newman (§2.2), which needs modality in the world, and would have to give up primitive causation.
- **Russellian monism, staunch hylomorphism and IIT are changes of foundation.** Each denies (a) or (c). Each offers something the blog lacks: an account of what structure is the structure of; a line between a unity and a heap; an observer-independent grain. The essay should say what it offers in place of each. For the first, the grain account of GRAIN:85. For the second, graded unity (the mindedness essay's "one mind" conditions do this work for minds). For the third, the intervention family.

### 6.2 Moves within the family

| Move | What it gains | What it costs |
|---|---|---|
| Stay with Ladyman and Ross as written | the rainforest; scale relativity; the real-pattern definition | causation is not primitive, against CCI:11; no base layer, against CCI:51; the measurement problem is declared dissolved, which Egg disputes (Appendix A) |
| Effective structural realism (Ladyman and Lorenzetti) | commitments indexed to domains; an answer to unfinished physics; "all real patterns are on a par" | no claims about the base at all; the Ruliad picture becomes an optional extra |
| Moderate causal structural realism (Esfeld 2009; Esfeld and Sachse) | primitive causation; relata kept; a clear account of what modal structure is | a fundamental level; special sciences conservatively reduced; French's symmetry objection |
| Eliminative structural realism (French) | the cleanest reply to natures | van Fraassen's dilemma in full; laws and symmetries as the only structure, which says little about patterns at coarse grains |
| Super-Humean structural realism (later Esfeld) | parsimony; no natures | no modality in the world; a fundamental level |

The blog's own essays already pull in two directions on this table. CCI:45 says pattern-level causation "is entirely constituted by that primitive" and adds no productive power: that is close to Esfeld and Sachse's conservative reduction, with Layer 0 as the fundamental level. IITFW §2 says "no level exists 'as such' more than another": that is effective structural realism. The first has a base and reduces to it. The second has none. Claim (b) as usually stated, "no privileged micro level", is true on both only if "micro" means the physics of particles and not Layer 0. The essay should state (b) in that restricted form or give up the base.

### 6.3 Where the survey points

A reading for the author to accept or reject.

- Nothing in the survey warrants leaving structural realism. The three views that would require it each rest on a premise the blog has an argument against: quiddities (GRAIN:85), a categorical line for unity (P&A:95), exclusion by maximality (IITFW §2).
- The survey does warrant a change within it. The position that fits the blog's commitments is moderate on objects, effective in scope, and causal in its reading of modal structure, with the reality criterion of §5.5. That combination is not held by any one author, and its two joints (a base layer with no privileged level; primitive causation in a structuralism) are where the essay would be doing original work.
- The strongest pressure for a real shift comes from the powers side, because the intervention criterion is already a criterion about what manipulation does and CCI:11 already makes causation primitive. The honest statement may be that the blog is a causal structuralist in Esfeld's sense who rejects his reductionism about the special sciences.
- The real-patterns criterion by compression alone should be retired as the blog's stated basis. It does not survive McAllister (§2.5), and Ladyman's own recent wording replaces it with projectibility and non-redundancy.

---

## 7. What to read in full before drafting

Ranked by how much the essay depends on it and how little of it was read here.

1. **ETMG, chapters 3, 4 and 5**, with page checks at 44, 130, 151–158, 206, 226–236. Every quotation from the book in this dossier is second-hand. The essay cites the book as its source and should not quote it through McAllister or a course handout. Chapter 5 settles what Ladyman and Ross hold about causation (§3.6, §5.4).
2. **Alter, *The Matter of Consciousness***: chapters 1–3, §6.4 and chapter 15. Then **Alter 2016**, pp. 795 and 804–809, and **Alter and Pereboom 2023**. Only abstracts were read. The essay's chosen critic has to be answered from his text.
3. **Stoljar 2014**, "Four Kinds of Russellian Monism" (the draft is open), with **Chalmers 2020**, "Spatiotemporal Functionalism v. the Conceivability of Zombies". These are the best statement of what "structure" can mean in Alter's argument.
4. **McKenzie 2024**, "Structuralism as a Stance" (open access), and her 2020 paper. The essay needs a reply.
5. **The RP volume** (open access; opens in a browser): Ladyman's chapter 3, McAllister's chapter 7, Millhouse's chapter 5, Kincaid and Nefdt's chapter 11, Cao's chapter 12, the editors' introduction. Chapters 3, 5, 11 and 12 bear directly on §5 and were not read.
6. **Millhouse 2019 and 2022** in full. The admissibility clause of §5.5 is his idea.
7. **Geiger, Harding and Icard 2025**, **Sutter et al. 2025**, **Rosas et al. 2024** and **Rosas 2025/2026**. These carry §5. The first is a philosophy paper and the closest prior art for the reconciliation.
8. **Ladyman and Lorenzetti**, "Effective Ontic Structural Realism", in full, and **Williams 2019**.
9. **Franklin-Hall 2016** (read) and **Woodward 2021**, "Explanatory Autonomy", with **Woodward 2015**, "Methodology, Ontology, and Interventionism", and **List and Menzies 2009**. The Woodward papers were read only through a summarizing fetch.
10. **van Fraassen 2006**, §3; **Chakravartty 2012**; **French 2019**. The collapse objection and the dilemma for relata.
11. **Frigg and Votsis 2011**, §§3.3–4.2, on Newman.
12. **Ladyman 2008**, on the special sciences and exclusion, and **Ladyman and Nefdt 2026**, for his current account of modal structure.
13. **Esfeld 2009**, **Esfeld and Sachse 2011** (introduction), **French 2020** on dispositions. Needed if §6.3 is accepted.
14. **Lyre 2022**, **Loorits 2014**, **Lee 2024**, **Kleiner 2024**. The structuralist literature on consciousness, to place GRAIN:85 against it.
15. **Tononi et al. v5**, §§3.6–3.7 and 4.5–4.6, and **Cea, Negro and Signorelli 2023**. Mostly covered by IITFW.
16. **Koons 2021**, "Thermal Substances", and **Dumsday 2020**. For the Thomist interlocutor.
17. **The 2010 *Metascience* symposium** (read). Short, and it has Ladyman and Ross's most direct statements on three of the objections.

---

## 8. Open questions for the author

1. **Which variant?** GRAIN:85 states the moderate view (relata individuated by relations). ETMG's slogan is eliminative. Does the essay defend the moderate view outright and say that it departs from the slogan?
2. **Is there a base?** CCI:51 has a generative Layer 0. IITFW §2 says no level exists "as such" more than another. Is Layer 0 a level? If it is, "no privileged micro level" has to be restricted to particle physics, and McKenzie's half-way house (§2.4) is the blog's home. If it is not, what is it?
3. **Is causation primitive?** CCI:11 says yes. Ladyman and Ross say it is a special-science notion. The reconciliation in §5.5 needs causal structure at the lower level. Does the essay keep CCI:11 and part company with them here?
4. **Generation, occurrence and structure.** CCI:15–17 distinguishes generation from description. P&A:117 withdraws the indexical account of actuality and declines to treat actuality as a separate status; P&A:119 still distinguishes concrete occurrences from abstract organization. What marks a concrete occurrence off from an abstract structure? If the mark is structural (finitude, constructibility), say what it is. If it is not, the blog has a non-structural primitive and van Fraassen's second horn (§2.3).
5. **Does the essay accept §5.5?** The proposal is that a pattern is real, relative to a family of interventions, when a model of it is a causal abstraction of the system under an admissible map. If yes, which admissibility constraint: complexity of the map, generalization to new inputs, or similarity of the grouped states?
6. **What does "the system's own dynamics" cover?** In the neuron case the nonlinearity, the energy cost and the optimizer all break the symmetry, the optimizer's basis does no work, and a sparse autoencoder's prior is the analyst's. Should v1:151's second clause be dropped in favour of "what interventions respect", or kept with these cases sorted?
7. **Against Alter: type-A or type-B?** Is the claim that phenomenal truths are a priori entailed by structural truths, with the Mary intuition explained by the grain account? Or is the epistemic gap granted and the modal step blocked? GRAIN:85 reads as the first.
8. **Which account of exclusion?** P&A:93 (one causal pattern, two descriptions), IITFW §2 (the grain that causes is fixed by proportionality), and Woodward (neither level excludes the other) are three positions. Which one?
9. **Plenitude.** McAllister concludes that all patterns are real. On the Ruliad picture that may be true of the base. Is the essay willing to say that selectivity enters only with a family of interactions, and that this is realism enough?
10. **Thesis or stance?** McKenzie argues that ontic structural realism is a stance. What does the blog's version rule out? Candidates: categorical natures, primitive identity, a privileged particle level, exclusion by maximality.
11. **Unity.** Hylomorphism and IIT both insist on a line between a unity and a heap. Is graded unity the answer for everything, or only for minds?
12. **Scope of the essay.** Sections 2 and 4 together are already an essay's worth. Should Alter have his own essay, with this one confined to variants, objections, the criterion and the alternatives? The memory note on essay length suggests a split when the parts do not cohere.


### Answers so far

Recorded 15 Nov 2026. "Author" marks the author's own words or a close paraphrase. "Reading" marks this dossier's interpretation, which the author has not confirmed. SoM = *The Standard of Motion*.

**Question 3, causation.**

- Author: causation is primitive. To say that modality is primitive "would be privileging the description (a Platonist position)". Special-science causation is not primitive. At the level of real patterns "modality is primary because it fixes the level individuating the patterns".
- Author, correcting the first reading: modal structure belongs to descriptions analytically. "You cannot have counterfactuals without descriptions. That's why at the base we need causation."
- Reading, revised: this is a regress argument. A counterfactual needs a typing, something under which an alternative counts as an alternative of the same thing. A typing is a description. If the base had modal structure it would be a description of something further, and so on, or it would be a description with nothing described, which is the Platonism the author rejects. Causation is what a description answers to, and it stops the regress. Modality is then primary for patterns because patterns are individuated by descriptions, and it is absent at the base because the base is not one.
- Reading: this rejects Ladyman and Ross's claim that modal structure is "ontologically fundamental" (§1.2) and their relata-as-structures all the way down. It agrees with them that special-science causation derives from modal structure, subject to the check of their chapter 5. It agrees with Esfeld 2009 that the base is causal and rejects Esfeld and Sachse's reduction above it.
- Reading: "description" has to mean a level fixed by a family of interactions, and not something only a mind produces. Otherwise real patterns become mind-dependent, against GRAIN:125. A system whose parts are sensitive only to certain distinctions in one another carries its own typing.
- Reading: the reply to Newman (§2.2) survives the change. What it needs is relations that are not extensional. At the base those are the generating relations. Above it they are the modal structure that an admissible abstraction preserves.
- Reading: "modality fixes the level" is the intervention family of §5.5 under another name. A pattern is individuated by the variations it is stable under, which is GRAIN:125's "relative to families of interactions".

**Questions 2 and 1, the base and the variant.**

- Author: the answer to question 3 implies keeping a base, and that implies the moderate position "because of the structure of the base". "But the true answers are more in-between", for two reasons. (A) There is the Ruliad, and no singled-out "real" base. (B) Correspondingly, the layer of physics must be stable under a shift of base. "On the weak side, we challenged Wolfram in *The Standard of Motion*."
- Reading: "the base" is then a role and not an entity. Everything is located in some lower level, and no lower level is the one God picked.
- Reading: a shift of base is a gauge freedom of the kind §5.3 describes. What is real at the layer of physics is what is invariant under it. The neuron-basis case and the base have the same shape.
- Reading: requirement (B) is the robustness criterion of effective realism (Williams, §1.3) applied downward, and List and Menzies' "realization-insensitive" (§3.6). The position is effective structural realism from physics upward, over a base that is primitive and not singled out.
- Reading: McKenzie's half-way house (§2.4) shrinks. The principles held fixed are no longer one rule. They are computation as such, which is how CCI:51 already describes Layer 0.
- Reading: requirement (B) is a requirement and not a result. SoM distinguishes passive invariance, "the description does not depend on the observer's frame" (SoM:105), from active invariance, the existence of a moving twin (SoM:107), says "the test is a theorem" (SoM:115), and concludes of the two possible outcomes that "Neither has been derived" (SoM:131). The same distinction applies to a shift of base. That any rule can emulate any other is passive. That the layer of physics exists as the same pattern over each base is active, and it is what (B) asks for. The essay should state (B) with that status.
- Reading: under (A) the relata of the base are relative to a base too. That moves the moderate position toward what Ladyman and Ross actually work out, relata as abstractions, which may be what "in-between" comes to for question 1.

**Question 4, concreteness.**

- Author: yes, "concreteness is a matter of location in the lower level". The whole structure "is not concrete in the sense that there's no God's pick of the base; and it's not abstract in that it's not epistemically accessible".
- Reading: concreteness is indexed to a lower level, and abstractness is tied to description, in line with the answer to question 3. This declines both of van Fraassen's horns (§2.3): the whole is not a mathematical object in the sense of something a description gives us, and it is not a bearer with existence and nothing else.
- Reading: a critic will say that abstractness is not an epistemic notion, and will point to Wolfram's own presentation of the Ruliad as an abstract necessity. The essay needs the difference between being defined and being accessible.

**Follow-up: what about primitive causation is invariant under a shift of base?**

- Author: nothing. "Primitive causation is not invariant under a shift of base, it is just that all bases are real and physics is what emerges in this region of the Ruliad."
- Reading: bases are then real generative processes, and not reference frames on one process. This matters. Wolfram treats a choice of rule as a frame, which is a description. If a base were a description, its causation would fall on the modal side by the author's own argument, and the regress would not stop. "All bases are real" is the wording that avoids this.
- Reading: requirement (B) becomes local. An observer spans a region and cannot tell which base in that region underlies it. Physics has to be the same pattern across the bases of the region. It need not be the same across the whole Ruliad. This is the admissibility clause agreed for question 5, applied to physics.
- Reading: each base can be emulated in another, where it appears as a pattern. So one process is generative in itself and a pattern, with modal structure, relative to another base. On P&A:119's terms these are two concrete occurrences of one abstract organization. Production is absolute in each base; which base something is located in is relative.
- Reading: at the last step of the criterion there are no interventions on a base, since a base has no counterfactuals. Their place is taken by actual variation across the Ruliad. This commits the essay to plenitude at the base (question 9).
- Reading: there are two senses of "cause". Production belongs to bases. Difference-making belongs to patterns, and it is what the interventionist account describes. Particle physics is a pattern, so its causation is difference-making too. This bears on question 8.

**Question 5, the criterion.**

- Author: agreed. A pattern is real, relative to a family of interventions, when a model of it is a causal abstraction of the system under an admissible map, and a map is admissible when it is stable under any shift of the lower level that the family cannot detect.


**Question 6, "the system's own dynamics".**

- Author: replace the clause. The criterion of question 5 is already relative to a family of interventions, and "the system's own dynamics" names one such family: the interactions among the system's own parts while it operates.
- Reading: on this wording the four symmetry-breakers of §5.3 sort without exceptions. The nonlinearity and the energy cost count for the computation. The optimizer's basis counts for the training process only. A sparse autoencoder's directions count when the network's own operation respects them. Which neuron is which stays conventional, since the permutation symmetry is exact.


**Questions 7 to 9.** For these three the dossier proposed an answer and the author accepted it. The wording below is the proposal's.

**Question 7, against Alter.**

- Accepted: type-A. Phenomenal truths are entailed a priori by structural truths, and the intuition about Mary is to be explained.
- Accepted reason: type-B needs necessities that hold without being knowable a priori from a complete description. If modality belongs to descriptions analytically (question 3), there are none.
- Accepted: the explanation of the intuition is the grain account of GRAIN:85. What Mary gains is an occurrence, located in her, and a recognitional typing of it. This yields an indexical truth and no non-structural one.
- Costs noted: the position is in Dennett's camp, and Alter's chapter 4 and §6.4 are his direct answers; neither has been read. Chalmers has a standing rejoinder to purely indexical replies. "Descriptions do not capture occurrence" must not be heard as the Russellian's non-structural something: concreteness is location in a lower level, which is relational, and the same holds of a rock.

**Question 8, exclusion.**

- Accepted: Woodward's position for patterns, with production reserved for bases. Exclusion arguments concern production. Patterns make differences and do not produce, so they compete neither with one another nor with the base.
- Accepted rewording: P&A:93 becomes one production and several difference-making descriptions that answer to it. IITFW §2's sentence on proportionality is read weakly: proportionality picks the apt description for a question, and not the grain that really causes.
- Conceded to Merricks and to IIT: patterns have no productive power of their own (CCI:45). Existence is earned by the criterion of question 5.
- Source for the two senses of cause: Hall, "Two Concepts of Causation", in Collins, Hall and Paul (eds.), *Causation and Counterfactuals* (MIT Press, 2004), 225–276, [doi:10.7551/mitpress/1752.003.0010](https://doi.org/10.7551/mitpress/1752.003.0010) [C].

**Question 9, plenitude.**

- Accepted: plenitude holds at the base, and selectivity enters with a family of interactions. This is realism enough, because given a family, which patterns pass is not up to anyone.
- Left open: the measure over occurrences, which P&A:155 raises for suffering. It belongs to the ethics essay.


**Question 10, thesis or stance.**

- Accepted (the dossier's proposal): thesis. The view rules out six things: categorical natures beneath structure; modal structure as fundamental; a singled-out base, including a privileged particle level; productive power at the level of patterns; exclusion by maximality; necessities not knowable from a complete description. It has one hostage: requirement (B) in its local form, which SoM states as an unproved theorem.
- Accepted: McKenzie's determination argument does not apply, since the view does not claim that symmetries determine particle kinds. Her half-way house applies weakly: what is held fixed is computation as such.

**Question 12, scope.**

- Accepted (the dossier's proposal): two essays. The first covers the variant, the criterion, the objections (Newman, van Fraassen, McKenzie, McAllister), the alternatives and their cost, with McKenzie as its critic. The second covers Alter: his argument, the type-A reply from the account of modality, and the grain account against his §6.4. The first is gated by ETMG and the second by Alter's book.

**Question 11, unity.**

- Author: the proposed measure "resonates with the argument about esse we had with MRW. Non-exclusive-modified IIT gives graded unity, but maybe we need more nuance."
- Background in the blog. MbD:59 drops IIT's exclusion postulate, so that integration becomes "grain-plural". MON:158 defines residual integration: cut a level's parts from one another "along whichever boundaries lose least" and ask how much of the level's organization is lost. P&A:79 reports three tiers from the exchange with Michał Wójcik: descriptive coarse-graining, operational individuation, and individuation as a being possessing esse. P&A:95 argues that the third adds nothing once every constitutive condition is in the second. P&A:77 reports his demand that computation be "physically legible to mindless nature herself".
- Adopted by the author (the dossier's proposal): unity has three dimensions, and each is a claim about which cut the interactions cross.
  1. *Integration*: the parts are not closed off from one another. This is residual integration, and it is what IIT without exclusion measures. It says the thing is one and not several, at a level.
  2. *Autonomy*: the whole is closed off from its surroundings. Its boundary is kept by its own interactions and not by what handles it. This is van Inwagen's life (P&A:91).
  3. *Closure*: the level is closed off from the level below. Its own typing suffices for its own dynamics. This is the clause adopted for question 6 and Rosas et al.'s causal closure (§5.2).
- Adopted: the three dissociate. A nation has some autonomy and thin integration (MON:164). A trained network on a GPU has integration at the computational grain (MbD:59) and closure, and little autonomy. An organism has all three. A heap has none. "Substantial unity" is being high on all three; an "aggregate" fails at least one.
- Adopted: the third dimension is the one the esse argument is about. A level that is perfectly closed is a base when taken in itself (see the follow-up to questions 2 and 1: a base emulated in another appears there as a pattern). So a pattern has its own production in the limit of closure, and by degrees short of it. This gives the third tier of P&A:79 a content without leaving the organizational account: P&A:95 stands, and the constitutive condition that does the work is named. It also gives "legible to nature herself" a reading: the system's own interactions carry the typing.
- Costs noted: closure of an open system is never exact. Whether the three dimensions reduce to one measure is unknown. A Thomist will say that a degree of closure is still a description of what a thing is. Some facts about unity are not matters of degree at all: whether a broadcast returns, and how many fields an economy holds (OUTLINE §4).
- Source for the second dimension as a formal notion: Bertschinger, Olbrich, Ay and Jost, "Information and Closure in Systems Theory" (2006), cited by Rosas et al. as their reference 48. That it defines closure of a system against its environment is [U]; the paper was not opened.


**Three readings confirmed.** The author confirmed on 15 Nov, after the outline was written: bases are real generative processes and not reference frames; "description" means a level fixed by a family of interactions; requirement (B) is local to a region. The other items marked "Reading" above remain unconfirmed. The outline for the first essay is [`structural-realism-essay-outline.md`](structural-realism-essay-outline.md).

---

## Appendix A. The GPT report's leads, checked

The report is `ontic_structural_realism_progress-GPT6_Pro.md`. "Crossref" means the bibliographic record was checked. Content labels are as in the legend.

| Lead | Status |
|---|---|
| Ladyman and Lorenzetti, "Effective Ontic Structural Realism" | Exists: *BJPS*, [doi:10.1086/729061](https://doi.org/10.1086/729061), online 13 Dec 2023 (Crossref). The report's account of what it unifies matches the abstract and the authors' short read [A, P*]. Body not read. |
| Williams, "Scientific Realism Made Effective" (2019) | Exists: *BJPS* 70: 209–237, [doi:10.1093/bjps/axx043](https://doi.org/10.1093/bjps/axx043) (Crossref). Claims match the dissertation chapter [P]. |
| French, *The Structure of the World* (2014) | Exists (Crossref). The report's summary (laws and symmetries, read modally) matches Ney's review [S]. Book not read. |
| McKenzie, "Structuralism in the Idiom of Determination" | Exists: *BJPS* 71: 497–522 (Crossref). The report's summary matches the abstract and her 2024 restatement [A, P]. |
| McKenzie, "Structuralism as a Stance" (2024) | Exists, open access. Confirmed in the text [P]. |
| Bain on category theory | Exists: "Category-theoretic Structure and Radical Ontic Structural Realism", *Synthese* 190 (2013): 1621–1635, [doi:10.1007/s11229-011-9896-6](https://doi.org/10.1007/s11229-011-9896-6) (Crossref; online 2011) [C]. |
| Lam and Wüthrich against Bain | Exists: "No Categorial Support for Radical Ontic Structural Realism", *BJPS* 66 (2015): 605–634, [doi:10.1093/bjps/axt053](https://doi.org/10.1093/bjps/axt053), [arXiv:1306.2726](https://arxiv.org/abs/1306.2726). Abstract read in the PDF: "category theory offers little if any comfort to ROSR" [P, abstract]. |
| Eva, "Category Theory and Physical Structuralism" (2016) | Exists: *European Journal for Philosophy of Science* 6: 231–246, [doi:10.1007/s13194-015-0129-6](https://doi.org/10.1007/s13194-015-0129-6) (Crossref) [C]. That it defends parts of Bain's proposal is [U]. |
| Ladyman and Presnell, "The Hole Argument in Homotopy Type Theory" | Exists: *Foundations of Physics* 50 (2020): 319–329, [doi:10.1007/s10701-019-00293-9](https://doi.org/10.1007/s10701-019-00293-9), online 4 Oct 2019, CC BY. The abstract says the framework "provides a natural resolution of the Hole Argument" and that "the role of the Univalence Axiom … is clarified" [A]. The report's stronger claim, that univalence alone does not settle the argument, is [U]. |
| Chen, "Univalence and Ontic Structuralism" (2024) | Exists; confirmed in the text, including the candour about limits [P]. See §2.3. |
| Lam and Wüthrich, "Spacetime Is as Spacetime Does" (2018) | Exists: *Studies in History and Philosophy of Modern Physics* 64: 39–51, [doi:10.1016/j.shpsb.2018.04.003](https://doi.org/10.1016/j.shpsb.2018.04.003), [arXiv:1803.04374](https://arxiv.org/abs/1803.04374). The report's summary matches the abstract [P, abstract]. |
| De Haro and Cinti, *Dualities in Physics* (2026) | Exists: Cambridge Elements, [doi:10.1017/9781009203845](https://doi.org/10.1017/9781009203845), online 5 May 2026; [arXiv:2509.15866](https://arxiv.org/abs/2509.15866). Confirmed in the text: "Do dualities favour structural realism or anti-realism? Answer: No, they do not"; the common-core strategy "can be seen as congenial to structural realism", but "an additional step is required" [P, FAQ 5]. |
| The RP volume | Exists (§1.4). The report's link gives the paperback ISBN. |
| Ladyman, "Patterns All the Way Up" | Exists: pp. 59–76, [doi:10.7551/mitpress/15550.003.0006](https://doi.org/10.7551/mitpress/15550.003.0006). The report's account of its content (triangulation; no single hierarchy) is [U]: the chapter could not be opened. |
| Millhouse 2021 and 2022 | Exist (§1.4). The report's summaries match the abstracts [A]. |
| Ladyman and Nefdt (2026) | Exists; confirmed in the text [P]. See §1.4. |
| Egg, "Dissolving the Measurement Problem Is Not an Option for the Realist" | Exists: *Studies in History and Philosophy of Modern Physics* 66 (2019): 62–68, [doi:10.1016/j.shpsb.2018.12.002](https://doi.org/10.1016/j.shpsb.2018.12.002) (Crossref). The report's summary matches the abstract as relayed by a search of PhilSci-Archive 15423 [S]. |
| Rosas et al., "Software in the Natural World" | Exists; read [P]. **The report's gloss needs correcting.** It says predictive closure "should not automatically be identified with interventionist causal autonomy". Within the paper, Theorem 1 proves information closure and causal closure equivalent. The caution holds only outside the paper's assumption that the micro process is fully observed. See §5.2. |
| Elshatlawy, Rickles and Arsiwalla, "Towards a Generalized Theory of Observers" | Exists: [arXiv:2504.16225](https://arxiv.org/abs/2504.16225), v3 of 7 Jan 2026. **The report overstates.** Structural realism appears once, in a survey paragraph: the framework "suggests potential alignments with neo-Kantian approaches and contemporary structural realism", citing ETMG [P, full-text search of the PDF]. It does not engage it. |
| Arsiwalla and Gorard, "Pregeometric Spaces from Wolfram Model Rewriting Systems as Homotopy Types" | Exists: *International Journal of Theoretical Physics* 63 (2024), [doi:10.1007/s10773-024-05576-0](https://doi.org/10.1007/s10773-024-05576-0), [arXiv:2111.03460](https://arxiv.org/abs/2111.03460). It has a section on "Role of Voevodsky's Univalence Axiom in the Topos of Rulial Multiway Systems" [P, table of contents and §5.3 located]. |
| Wolfram, "What Ultimately Is There? Metaphysics and the Ruliad" (2026) | Exists: <https://writings.stephenwolfram.com/2026/02/what-ultimately-is-there-metaphysics-and-the-ruliad/>. Confirmed: emes "have no structure of their own. And indeed the only intrinsic thing one can say about them is that they are distinct: in a sense they are elementary units of identity", and it is "convenient to imagine" things as relations between them [P]. |
| Wolfram, "Observer Theory" (2023) | The page exists at the report's URL. Content not checked [C]. |
| Ross, Ladyman and Kincaid (eds.), *Scientific Metaphysics* (2013) | Exists: OUP, [doi:10.1093/acprof:oso/9780199696499.001.0001](https://doi.org/10.1093/acprof:oso/9780199696499.001.0001); Ladyman and Ross, "The World in the Data", pp. 108–150 (Crossref) [C]. |
| Quantum discernibility (the report's RePub link) | The link resolves to "Discerning Fermions" (Muller and Saunders 2008). See §2.1. |
| The report's statements about what ETMG "already says" | [U]. The report cites an uploaded copy of the book that is not in this repository. Its claims about logical depth, physically possible perspectives and the "relata" sentence agree with what was found second-hand (§1.2, §1.4). None was checked against the book. |
| The Santa Fe research brief and a ResearchGate preprint of Ladyman's chapter | The brief exists and was used in §1.4 [S]. The preprint link was not opened. |

**Net.** No citation in the report was found to be invented. Two glosses are wrong or overstated (Rosas et al.; Elshatlawy et al.). Three content claims could not be verified (Ladyman's chapter; Ladyman and Presnell's caution; Eva's defence of Bain). The report's own synthesis in its second half, on Wolfram physics, is marked there as the model's proposal and was not assessed here.

One find the report did not have: Rosas's symmetry paper, published the day before this pass (§5.2).

## Appendix B. Not reached, and how the reading was done

**Method.** Five research passes ran in parallel (variants and objections; real patterns; alternatives; Alter; the two criteria), each instructed to label what it read. The main pass checked the GPT report's leads, read Rosas et al. 2024, Rosas 2025, Zhou and Klindt, the *Metascience* symposium and the blog's essays, and rechecked a sample of the other passes' quotations against the source texts: Geiger, Harding and Icard; Sutter et al.; Rubenstein et al.; Elhage et al. 2023; and twelve quotations from van Fraassen 2006, McKenzie 2024, Stoljar 2014 and SEP-RM. All matched. A [P] label on anything else means that a research pass opened the text and reported the quotation; it was not independently rechecked. [P*] marks quotations that came back through a summarizing fetch.

**Hosts that refused automated requests.** PhilSci-Archive, PhilPapers and PhilArchive, the MIT Press open-access site, Oxford Academic chapter pages, University of Chicago journals, Wiley, ScienceDirect, and Springer for non-open articles. Nothing was done to get round a refusal; the item was left as an abstract or a citation.

**Books not opened.** ETMG; French 2014; Alter 2023; Bird 2007; Mumford 2004; Woodward 2003 and 2021; Maudlin 2007; Koslicki 2018; Jaworski 2016; Goff 2017; Chalmers 2010; Stoljar 2006; Pereboom 2011; Putnam 1988; Searle 1992; Anderson and Piccinini 2024; Wallace 2012. Links are at first mention. Four more are named in the text or in second-hand reports and have no link above: Koslicki, *The Structure of Objects* (OUP, 2008), [doi:10.1093/acprof:oso/9780199539895.001.0001](https://doi.org/10.1093/acprof:oso/9780199539895.001.0001) [C]; Piccinini, *Physical Computation: A Mechanistic Account* (OUP, 2015), [doi:10.1093/acprof:oso/9780199658855.001.0001](https://doi.org/10.1093/acprof:oso/9780199658855.001.0001) [C]; Chalmers, *Constructing the World* (OUP, 2012), no DOI confirmed [U]; Alter and Nagasawa (eds.), *Consciousness in the Physical World* (OUP, 2015), no DOI confirmed [U].

**Articles known only by abstract or citation, where the essay may lean on them.** Alter 2016; Alter and Pereboom 2023; Ladyman and Lorenzetti; Millhouse 2019, 2021, 2022; McKenzie 2014 and 2020; Esfeld 2004, 2009, 2014; Esfeld and Lam 2008, 2011; Ladyman 1998; French and Ladyman 2003; Woodward 2015 (both), 2016, 2021 (through a summarizing fetch); Baumgartner 2009, 2013; Howell 2015; Kind 2015; Ney 2015; Stoljar 2015; RP volume chapters 1, 3, 4, 5, 8–12.

**Absences that rest on searches and not on proof.** A reply by Ladyman, Ross or French to McKenzie 2020 or 2024; a reply by Ladyman and Ross to McAllister; a reply by any ontic structural realist to the structure-and-dynamics argument; a discussion of ontic structural realism in Alter's book; reviews of Alter's book outside *Philosophia* and the *Australasian Journal of Philosophy*.

**Small corrections to common citations, found on the way.**

- Woodward 2010 is titled "…Stability, Specificity, and the Choice of Levels of Explanation".
- "Symmetry as a Guide to Superfluous Theoretical Structure" is Ismael and van Fraassen (2003), [doi:10.1017/cbo9780511535369.024](https://doi.org/10.1017/cbo9780511535369.024) [A]. Dasgupta's 2016 paper is "Symmetry as an Epistemic Notion (Twice Over)".
- "The great divide of being" is §3.6 of Tononi et al., not a separate paper.
- SEP-SR's "Esfeld (2009) develops a Humean take" conflicts with that paper's abstract.
- Chalmers's "On Implementing a Computation" is dated 1994 by Crossref and cited as 1995 by the SEP and by Rescorla.
- Lam and Wüthrich's BJPS paper is in the 2015 volume; the arXiv listing says 2014.
