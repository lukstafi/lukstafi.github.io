# Outline: structural realism (what makes a pattern real, and what a description answers to)

Status: outline, 15 Nov 2026. Nothing drafted. It is built from the dossier [`structural-realism-variants-dossier.md`](structural-realism-variants-dossier.md) and from the author's answers to its twelve open questions, recorded there in §8 under "Answers so far". No new literature search was run for the outline; citations marked † are from memory and unverified. Sections carry no word budget; length follows content.

Revised the same day: the author confirmed the three readings that §3 and §4 rest on (bases are processes, not frames; "description" means a level fixed by a family of interactions; the requirement on physics is local to a region).

This is the first of two essays. The second answers Torin Alter's structure-and-dynamics argument and is not outlined here (SRD §4, and question 7 in SRD §8). The critic of this one is Kerry McKenzie.

Title candidates: *What a Description Answers To*; *Patterns Without Platonism*; *No God's Pick*; *What Makes a Pattern Real*.

Attribution: items marked (user) are the author's positions, in the author's wording where quoted. Items marked (accepted) were proposed by Claude and accepted by the author on 15 Nov. Items marked (reading) are Claude's interpretations of the author's answers; three of them are marked as confirmed, and the rest are not. Items marked (proposal) are Claude's suggestions in this outline and are not adopted.

## Legend

SRD = `structural-realism-variants-dossier.md`; CCI = *Causation, Computation, Indexicality*; GRAIN = *The Grain of the Hard Problem*; P&A = *Presence and Actuality*; MbD = *Minds by Degrees* v2; MON = *Is the Monastery Minded?*; SoM = *The Standard of Motion*; v1 = `theory-overhaul-proposal.md`; v2 = `theory-overhaul-proposal-v2.md`; AUDIT = `overhaul-proposal-audit.md`; IITFW = `iit-free-will-intrinsic-powers.md`; MIND = `mindedness-essay-outline.md`. ETMG = Ladyman and Ross, *Every Thing Must Go* (2007). Numbers after a colon are line numbers in the `.md` source.

## Seeds

- The queue item: survey the variants of ontic structural realism and its alternatives, pick and defend one variant, and be open to shifting the blog's foundation.
- The unreconciled item N6. CCI:35 says a pattern is realised when the realisation relation is a structure-preserving map. GRAIN:125 says "a coarse variable earns reality when interventions and interactions repeatedly respect it". AUDIT:96 says these answer different questions. v2:276 deferred the matter to this essay.
- The hand-offs from the mindedness outline (MIND, "Hand-offs"): the existence criterion; which maps are admissible; the neuron-basis gauge; IIT's dichotomy of intrinsic powers and "substrate+".
- Michał Wójcik's demand that computation be "physically legible to mindless nature herself" (P&A:77), and the three tiers of P&A:79: descriptive coarse-graining, operational individuation, individuation as a being possessing esse.
- Michał's complaint about toy examples (MON:23). This essay owes a pair for each clause of its criterion.
- The author's answers of 15 Nov (SRD §8). Three of them are new positions and carry the essay: modality belongs to descriptions; all bases are real; concreteness is location in a lower level.

## Thesis

Structural realists say that science gets the structure of the world right, and the ontic ones say that structure is what there is. Ladyman and Ross add that the structure is modal and that it is fundamental. The essay keeps the first two claims and denies the third.

A counterfactual needs a typing: something under which an alternative counts as an alternative of the same thing. A typing is a description. So modal structure belongs to descriptions, and a world whose foundation is modal structure is a world of descriptions with nothing described. What a description answers to is causation: the producing of one state from another. Causation is primitive at a base. No base is singled out. All of them are real, each can be found as a pattern in others, and physics is what emerges in the region where we are.

Patterns are real, at many grains, and none is privileged. A pattern is real, relative to a family of interventions, when a model of it is a causal abstraction of the system under an admissible map. A map is admissible when it is stable under any shift of the lower level that the family cannot detect. For a system that maintains itself, the family that matters is the interactions among its own parts. Patterns make differences and do not produce, so no pattern competes with another or with its base.

The view rules out six things and can be refuted by one.

What makes this more than a restatement:

1. **A regress argument against fundamental modal structure** (user). It separates the blog from Ladyman and Ross at the base and agrees with them above it.
2. **One criterion where the blog had two** (accepted). The morphism criterion and the intervention criterion are the two components of a causal abstraction. The audit's point survives as a difference in direction of fit.
3. **One cure for three trivialities** (accepted). Newman's problem for structure, Putnam's for computation and Sutter et al.'s for causal abstraction are the same problem. The admissibility clause answers all three.
4. **A pair for each clause.** Each clause of the criterion is shown by two systems that differ in that feature alone.
5. **Bases without a base** (user). Causation is primitive and no level is God's pick. A base emulated in another base is a pattern there.
6. **Unity in three dimensions, and a content for esse** (accepted). Integration, autonomy and closure. A perfectly closed level is a base when taken in itself.
7. **A thesis with a hostage** (accepted). McKenzie asks what structural realism rules out. The essay lists six exclusions and one theorem it needs and does not have.

## The paired constructions

All (proposal). A running example is offered for the whole essay: Conway's Life. Its cells produce; its gliders are patterns; a counterfactual about a glider needs the typing "glider"; SoM:107 already uses the gaps between its ships' speeds; and Life can run Life, in the unit-cell constructions†, which shows a base as a pattern in another base.

| Pair | First system | Second system | Feature varied | Verdict |
|---|---|---|---|---|
| D1 | "This cell is on at step 40" | "Had the glider started one cell to the left" | Whether the claim needs a typing | An occurrence; a counterfactual, available only under the typing "glider" |
| B1 | Life running | Life run inside Life† | Which lower level the occurrence is located in | Two concrete occurrences of one abstract organization (P&A:119); each produces in itself, and the second is also a pattern in the first |
| R1 | The dust man: a lookup table from dust states to a computation (CCI:39) | A trained network, or a brain (CCI:41) | Whether the map commutes with the dynamics under variation | Not realised; realised |
| R2 | Total cholesterol as a cause of heart disease†: the effect of setting it depends on how it is made up | Temperature as a cause of pressure | Whether interventions on the coarse variable have one effect | Not a variable that interventions respect; one that they do |
| R3 | A randomly initialised network with an unrestricted alignment map (Sutter et al.) | A trained network with a map that survives retraining and perturbation | Whether the map is stable under shifts of the lower level that the interventions cannot detect | Vacuous abstraction; real pattern |
| R4 | The basis that the Adam optimizer privileges in a residual stream (Elhage et al. 2023) | The basis that a ReLU layer privileges | Whether the system's own operation respects the typing | Real for the training process only; real for the computation |
| R5 | A stipulated component that best compresses one dataset (McAllister) | The tide in sea-surface heights | Whether the pattern persists when the other causal factors are rearranged | Bogus; real |
| R6 | An arbitrary partition of the micro-states of two gas chambers | The number of particles in each chamber (Rosas et al.) | Whether the level is closed | Not a level; a level whose own state gives all the control there is |
| H1 | Life's glider: the ships nearest it in speed are different patterns (SoM:107) | A soliton in a continuum theory: a boost gives its moving twin | Whether the pattern exists across the shift | Passive invariance only; active invariance |

Cases for §9, in place of pairs: an organism, a trained network on a GPU, a nation, a heap. They differ on three dimensions at once.

## Sections

### §0 Opening

Candidates:
- (a) A glider. Is it real? Dennett asked, and Ladyman and Ross built on his answer. Then three things the standard answer leaves out: the glider is a counterfactual-supporting thing only under a description; the cells do the producing; and Life can run inside Life. (proposal, recommended)
- (b) Which direction in a network is a feature? The function fixes the answer only up to a linear map. This opens on §7's case and follows the architecture series.
- (c) McKenzie's challenge: structural realists tolerate disagreement about whether quantum fields are objects or structures, so what does the view rule out?
- (d) The dust man.

### §1 What we said, and the two criteria

One short section, since readers of the blog know the pieces.

- GRAIN:85: relata are individuated by their relations, "with no natures beneath them". P&A:85: "correctly identifying a pattern in reality already establishes its existence."
- CCI:35 and CCI:43: the morphism criterion, introduced against Putnam.
- GRAIN:125 and GRAIN:131: the intervention criterion, with coarse-grainings "relative to families of interactions, not to observers".
- The gap: AUDIT:96. The archived attempt to close it: v1:151.
- What has since been withdrawn: indexical actuality (CCI:77–79, withdrawn at P&A:117).

### §2 The variants, and the one we hold

A map, kept short. SRD §1 has the detail and the sources.

- Epistemic structural realism: Worrall's argument from theory change. MbD:37 uses it for psychology. It commits us to nothing about what there is.
- Ontic structural realism, on six axes (SRD §1.2, the table): whether objects exist; whether priority is asymmetric; whether relata may have intrinsic properties; scope; what the modality is; whether there is a fundamental level.
- Where the essay stands on each axis (user, with SRD §8):
  - *Objects:* moderate. Relata exist and are individuated by relations. The author's qualification: under a shift of base the relata are relative too, which moves the position toward Ladyman and Ross's worked view of relata as abstractions. (reading)
  - *Scope:* every scale, as in effective structural realism (Ladyman and Lorenzetti).
  - *Modality:* not fundamental. §3.
  - *Fundamental level:* bases, none singled out. §4.
- Ladyman and Ross's slogan is eliminative and their worked position is not. Say so with page references, after reading the book.
- End the section on McKenzie's challenge (SRD §2.4): her 2020 argument that symmetries do not determine the world's kinds, and her 2024 argument that the view is a stance. §11 answers it.

### §3 Modal structure belongs to descriptions

The essay's first new claim. (user)

- **The argument.** "You cannot have counterfactuals without descriptions." Pair D1. A counterfactual holds something fixed and varies something else, and both need types. If the base had modal structure it would be a description of something further, or a description with nothing described. "Saying modality is primitive would be privileging the description (a Platonist position)." So "at the base we need causation."
- **What "description" means here** (reading, confirmed by the author 15 Nov). A level fixed by a family of interactions. A system whose parts respond only to certain distinctions in one another carries its own typing. Without this reading, patterns become mind-dependent, against GRAIN:125.
- **Against whom.** Ladyman and Ross hold that "the world has an objective modal structure that is ontologically fundamental" (ETMG p. 130, second-hand; SRD §1.2), and that relata are relational structures on further analysis. On the argument above this is descriptions all the way down.
- **With whom.** Esfeld 2009 makes fundamental structures causal (SRD §3.1). The essay agrees at the base and rejects his reduction of the special sciences above it.
- **What stays right in Ladyman and Ross.** At the level of patterns "modality is primary because it fixes the level individuating the patterns" (user), and special-science causation is derived. Whether that is their view of causation depends on ETMG ch. 5, which is unread.
- **Van Fraassen's dilemma** (SRD §2.3). If structure is all there is, the contrast with non-structure is gone; if it is instantiated, something bears it. The essay takes neither horn. The whole is not a mathematical object, and no bearer is singled out (§4).
- **Newman's problem** (SRD §2.2). The reply needs relations that are not extensional. At the base those are the generating relations. Above it they are the modal structure that an admissible abstraction preserves (§6). (reading)
- **The resonance to name once** (reading). The argument has the shape of the Thomist distinction between essence and the act of being, which P&A:73 reports from Michał. Use it in §9, not here.

### §4 Bases, and where we are

The second new claim. (user)

- **All bases are real.** "Ruliad rather than a singled out 'real' base." "Primitive causation is not invariant under a shift of base, it is just that all bases are real and physics is what emerges in this region of the Ruliad."
- **Processes, not frames** (reading, confirmed by the author 15 Nov). Wolfram treats a choice of rule as something like a reference frame†. A frame is a description. If a base were a description, its causation would fall on the modal side by §3's argument, and the regress would not stop. So a base is a generative process. Each can be emulated in another, where it is a pattern with modal structure. Pair B1.
- **Concreteness** (user). "Concreteness is a matter of location in the lower level." The whole "is not concrete in the sense that there's no God's pick of the base; and it's not abstract in that it's not epistemically accessible."
- **Not indexical actuality.** P&A:117 withdrew the claim that perspective constitutes actuality. P&A:115 kept that an indexical account "can locate us within a plurality". "This region" does the second and not the first.
- **The requirement** (user). "The layer of physics is stable under base shift." In its local form (reading, confirmed by the author 15 Nov): an observer spans a region and cannot tell which base in it underlies it, so physics has to be the same pattern across the bases of the region.
- **The hostage** (user: "on the weak side, we challenged Wolfram in *The Standard of Motion*"). SoM:105 separates passive invariance, where "the description does not depend on the observer's frame", from active invariance, the existence of a moving twin (SoM:107). "The test is a theorem" (SoM:115), and "Neither has been derived" (SoM:131). For a shift of base (reading): that rules can emulate one another is passive; that physics exists as the same pattern over each base of the region is active. Pair H1. State the requirement as a requirement.
- **An objection to state.** A critic will say abstractness is not an epistemic notion, and will cite Wolfram's presentation of the Ruliad as an abstract necessity. The reply needs the difference between being defined and being accessible. (reading)

### §5 The criterion

- **Statement** (accepted). A pattern is real, relative to a family of interventions, when a model of it is a causal abstraction of the system under an admissible map.
- **Two components.** A causal abstraction is a pair of maps, one on states and one on interventions, such that intervening and then abstracting equals abstracting and then intervening (SRD §5.2a). CCI:35's map is the first. GRAIN:125's family is the domain of the second. CCI:35 already says "Intervene on the pattern and you intervene on the physics".
- **Two questions** (AUDIT:96). Which computations a system realises: the model is given and a map is sought. Which coarse variables are real: the family is given and it induces a quotient. Pairs R1 and R2.
- **The order between them.** Rosas et al. prove that a level closed under interventions is closed computationally, and that the converse fails (SRD §5.2b). So the intervention side is the stronger one. Pair R6.
- **The family is the modality.** "Modality … fixes the level individuating the patterns" (user). The family of interventions is that modal structure. (reading)
- **The last step.** A base has no counterfactuals, so there are no interventions on it. Their place is taken by actual variation across the Ruliad. (reading) This is where plenitude enters (§7).
- **Exactness.** Exact abstraction is rare. Approximate abstraction needs a tolerance, which is Dennett's noise again (SRD §5.5, cost 3). Say who sets it: the family does, since a difference the family cannot detect is no difference at that level. (proposal)

### §6 Admissibility: one cure for three trivialities

- **Newman** (1928): any collection of the right size has any structure. **Putnam** (1988): every open system implements every automaton. **Sutter et al.** (2025): with unrestricted maps every network is a causal abstraction of every algorithm, and such maps reach full accuracy on randomly initialised models (SRD §5.2c). Geiger, Harding and Icard call the last "an even stronger triviality argument".
- **The cure in each case** is a restriction on which relations or maps count. The published candidates are in SRD §5.2c's table: independent components, causal similarity, simplicity of the map, informational equivalence, linearity, generalization.
- **The clause** (accepted). A map is admissible when it is stable under any shift of the lower level that the family of interventions cannot detect. It is the author's requirement on physics (§4), generalized.
- **What it does.** The dust man's table breaks when the dust is perturbed. Sutter et al.'s maps are built for one network. Pair R3.
- **What it matches.** List and Menzies' "realization-insensitive" relations; Anderson and Piccinini's condition that physical states "bear neither more nor less information" than the computational states they map to; Millhouse's bound on the complexity of the map, taken as evidence of stability and not as the criterion.
- **Where it could fail.** Stability comes in degrees. A map can be stable for the wrong reason. Linearity, which interpretability practice uses, is an empirical hypothesis and not a consequence of the clause.

### §7 Whose family? Observers, plenitude and the neuron basis

- **The objection** (SRD §2.5). Compression is relative to a language, a coarse-graining and a tolerance for noise. McAllister: any dataset decomposes into any pattern plus a remainder, so "if any pattern is real, then all patterns must be."
- **Compression alone is retired** as the blog's stated basis (accepted, SRD §6.3). McAllister's argument is about passively collected data. A criterion stated in terms of interventions is not reached by it, and his own thought experiment appeals to rearranging causal factors. Pair R5.
- **Plenitude at the base** (accepted). All bases are real, so at the base McAllister's conclusion holds. Selectivity enters with a family of interactions. Given a family, which patterns pass is not up to anyone.
- **The observer is one more embedded system** (GRAIN:129). Relativity to observers becomes relativity to the interactions a bounded system can enter.
- **The system's own interactions** (accepted; replaces v1:151's "broken by the system's own dynamics"). For a system that operates on itself, the family is the interactions among its own parts. GRAIN:131 says this of experience: "the grain that the vehicles' own regulation respects".
- **The case** (SRD §5.3). A network's function fixes its hidden representation up to an invertible linear map (Zhou and Klindt, Theorem 4.1; Elhage et al.). Four things can reduce the symmetry: the nonlinearity, an energy cost with non-negative activations, the optimizer, and an analyst's sparsity penalty. Pair R4. The optimizer's basis is real for the training process and idle in the computation. The penalty counts when the network's own operation respects the directions it finds.
- **Relata as abstractions, shown.** The permutation symmetry is never broken. The set of axes is real and no axis has an identity beyond its place. This is the moderate position of §2 in a case one can compute.

### §8 Causation above the base

- **Two senses of cause** (accepted). Production belongs to bases. Difference-making belongs to patterns, and it is what the interventionist account describes. The distinction is Hall's (2004, SRD §8). Particle physics is a pattern, so its causation is difference-making too.
- **Exclusion.** Kim's argument concerns production (Ladyman 2008, SRD §3.6). Patterns do not produce, so they compete neither with one another nor with a base. Woodward's position, that neither level excludes the other, is the one adopted. List and Menzies' downward exclusion is not.
- **Proportionality** is graded and relative to an explanandum (SRD §3.6). It picks the apt description for a question. IITFW §2's sentence is kept in that weak reading.
- **Rewording.** P&A:93's "two descriptions of one causal pattern" becomes one production and several difference-making descriptions that answer to it. CCI:45 already says patterns add no productive power.
- **Merricks** (P&A:89–93). Existence is not earned by non-redundant production. It is earned by the criterion.
- **IIT's dichotomy** (IITFW §2; SRD §3.5). The paper offers intrinsic powers or a "substrate+" ontology with a microphysical bedrock. The essay's position is neither. It concedes that higher levels are "carried along for the ride", and adds that microphysics is too.
- **The variables problem** (Franklin-Hall, SRD §3.6). Interventionism alone does not fix the grain. The answer offered: admissibility (§6) and the system's own interactions (§7). She would call this naturalness in disguise; say what it is instead. (proposal)

### §9 Unity, and what esse comes to

- **Three dimensions** (accepted, SRD §8, question 11). *Integration*: the parts are not closed off from one another (residual integration, MON:158; IIT without exclusion, MbD:59). *Autonomy*: the whole is closed off from its surroundings by its own interactions (van Inwagen's life, P&A:91). *Closure*: the level's own typing suffices for its own dynamics (§7's clause; Rosas et al.).
- **Cases.** An organism is high on all three. A trained network on a GPU has integration at the computational grain and closure, and little autonomy. A nation has thin integration (MON:164). A heap has none. "Substantial unity" is being high on all three; an "aggregate" fails at least one.
- **Closure and esse.** A perfectly closed level is a base when taken in itself (§4, pair B1). So a pattern has its own production in the limit of closure, and by degrees short of it. This gives the third tier of P&A:79 a content inside the organizational account. P&A:95 stands, and the constitutive condition doing the work is named.
- **"Legible to nature herself"** (P&A:77): the system's own interactions carry the typing.
- **The disagreement with Michał, sharpened.** For Aquinas each finite substance has its own act of being (P&A:73). Here production belongs to bases, and a person has it to the degree that the person's level is closed.
- **Hylomorphism and IIT** (SRD §3.4, §3.5). Both insist on a line between a unity and a heap, and both want one carving: Koons's substances do not overlap, and IIT keeps one maximum per substrate. The three dimensions give the line as a matter of degree and allow overlap (GRAIN:125's "atlas of overlapping operational quotients").
- **Where it could fail.** Closure of an open system is never exact. Whether the three reduce to one measure is unknown. A Thomist will say a degree of closure still describes what a thing is. Some facts about unity are not matters of degree (MIND §4).
- **Division of labour.** MIND §4 fits the three dimensions to minds. This section states them generally and briefly.

### §10 The alternatives, and what each would cost

SRD §3 and §6 have the detail. One table, updated for the answers.

- **Powers** (Bird; Esfeld 2009). The essay now agrees that the base is causal. It differs in having no bearers and no single fundamental level, and in refusing reduction above the base.
- **Humean supervenience.** The closest neighbour after the answers, and the comparison the essay most needs. Counterfactuals made true by actual variation across the Ruliad, under a typing, resemble Lewis's modal realism with counterparts†. The differences to state (proposal): production is primitive and not a regularity; the Ruliad is one connected structure and not a set of isolated worlds; the typing is fixed by interactions and not by similarity as a speaker judges it. See open question 1.
- **Russellian monism.** Ruled out by the first exclusion. The argument is in the second essay.
- **Hylomorphism; IIT.** §9.
- **Interventionism.** Adopted as method, for patterns.

### §11 A thesis, not a stance

The answer to McKenzie (accepted).

- **Her arguments** (SRD §2.4). Dependence does not give priority. Symmetries do not determine the inventory of kinds. Structuralists tolerate disagreement about fields, so the view is a stance. No naturalistic project can speak about fundamental reality before the final theory.
- **Six exclusions.** Categorical natures beneath structure. Modal structure as fundamental. A singled-out base, including a privileged particle level. Productive power at the level of patterns. Exclusion by maximality. Necessities not knowable from a complete description.
- **One hostage.** §4's requirement, as a theorem that has not been proved.
- **Her determination argument does not apply.** The view does not claim that symmetries determine particle kinds.
- **Her half-way house applies weakly.** What is held fixed is computation as such (CCI:53), and not one rule.
- **Unfinished physics.** The scope is effective: commitments are indexed to regimes (SRD §1.3). The claims about bases are the exception, and the essay should say they are the speculative part.

### §12 What would change our minds

- For §4: a proof that physics is not the same pattern across the bases of a region, or a derivation of Aristotelian friction or of swerving with nothing to protect inertia (SoM:131).
- For §5: a variable that interventions respect and that no admissible map carries to a model, or the reverse.
- For §6: a map that is stable under undetectable shifts and still identifies a pattern we would call bogus.
- For §7: a basis that a system's own operation respects and that does no work in any intervention.
- For §3: a counterfactual that needs no typing.
- For §9: a system high on all three dimensions that nobody would call one thing, or low on one and plainly a unity.

### §13 Closing

Return to the opening case and answer it. The glider is real, relative to the interactions that respect it. It supports counterfactuals because it is described, and it occurs because cells produce it. Then the order of the remaining questions: what Alter's argument asks of a view like this, and what makes an experience lived.

## What the essay changes elsewhere

- CCI: a dated note. §3's criterion is restated in §5's wording. §5's indexical account of actuality was withdrawn in P&A. Layer 0 is a role and not one base.
- GRAIN:85 and its note: the blog parts with Ladyman and Ross on fundamental modal structure.
- P&A:93: a dated note with §8's rewording.
- IITFW §2: mark the sentence on proportionality as the weak reading. It is a research note and can be edited.
- MIND §1 and §4 already point to the criterion and to the three dimensions.
- No change to SoM. It is cited as the source of the hostage.

## Hand-offs

- **Second structural-realism essay (Alter):** the type-A reply; why the account of modality excludes the type-B reply; the grain account against his §6.4; Russellian monism; the difference between occurrence and a non-structural nature.
- **Mindedness essay:** the criterion in its accepted wording for §1; admissibility for the construct-validity test; the fit of the three dimensions to minds.
- **Personhood essay:** autonomy; counting where unities overlap.
- **The essay on observers that SoM:133 promises:** the region, the local form of the requirement, and the selection argument.
- **Ethics:** the measure over occurrences under plenitude (P&A:155).

## Before drafting

1. Read ETMG chs. 3, 4 and 5, with page checks at 44, 130, 151–158, 206, 226–236. Every quotation from the book in SRD is second-hand. Chapter 5 decides how §3 and §8 describe their view of causation.
2. Read McKenzie 2024 in full and her 2020 paper. Look for her forthcoming paper on effective metaphysics.
3. Open the 2026 MIT Press volume in a browser: Ladyman's chapter 3, Millhouse's chapter 5, McAllister's chapter 7, Kincaid and Nefdt's chapter 11, Cao's chapter 12.
4. Read in full: Millhouse 2019 and 2022; Geiger, Harding and Icard; Sutter et al.; Rosas et al. 2024 and Rosas 2025; List and Menzies 2009; Woodward 2021; Hall 2004; Franklin-Hall 2016; Esfeld 2009.
5. Verify the † items: Life run inside Life (the unit-cell constructions, and whether the emulation is exact); the total-cholesterol example (Spirtes and Scheines 2004); Wolfram's wording on rule choice and rulial space; Lewis on counterparts and modal realism.
6. Check whether French's objection to powers, that symmetries are constraints and do not fit stimulus and manifestation (SRD §3.1), touches primitive causation at a base. On the present view symmetries are features of patterns. (proposal)
7. Check the other items marked (reading) with the author as the draft reaches them: the reply to Newman in §3, the family as the modality and the last step in §5, and the passive and active forms of base shift in §4.

## Answers

The author's answers of 15 Nov 2026 to the dossier's twelve questions are in SRD §8, "Answers so far". This outline follows them. In summary: moderate on objects, with the qualification of §2; a base kept and none singled out; causation primitive at bases and modality in descriptions; concreteness as location; the criterion of §5 with the admissibility clause of §6; the system's own interactions in place of "the system's own dynamics"; type-A against Alter; production and difference-making; plenitude at the base; thesis and not stance; three dimensions of unity; two essays.

Confirmed afterwards (15 Nov): bases are processes and not frames; "description" means a level fixed by a family of interactions; the requirement on physics is local to a region.

## Open questions for the author

1. **How does the view differ from Lewis's?** §10 gives three candidate differences. Is production being primitive the one that matters, and is the resemblance welcome or a cost?
2. **Opening and title.** The glider, with Life as the running example, is the recommendation.
3. **How much survey.** The queue item asks for a survey of variants and alternatives. Recommendation: one section each (§2, §10), with tables, and the detail left in the dossier. An alternative is a companion page that carries the survey.
4. **How much depends on the Ruliad.** §§5–8 need only that there is a lower level. §§3–4, 9 and 11 lean on Wolfram's picture. Should the essay say which parts stand without it?
5. **Does §9 name the exchange with Michał,** or does it state the three dimensions and leave esse to the personhood essay?
6. **Is the neuron-basis case in the main line of §7,** or in a box, with a link to the architecture series?
7. **If the draft does not cohere.** The natural split is between the foundation (§§3–4, 9, 11) and the criterion (§§5–8, 10).
