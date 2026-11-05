# Editorial pass: *The Standard of Motion* (5 Nov 2026)

Final line-level pass on `notes/the-standard-of-motion.md`. No claims, numbers, quotations, citations, links, math or section structure changed. HTML rebuilt with `scripts/build_notes_html.sh` (no errors).

## Edits

### Opening and Heller section

- Opening, para 3: "nothing is carried along; a body that moves has to be rebuilt…" → "nothing is carried along. A body that moves has to be rebuilt…" (semicolon chained a claim and its elaboration; not a parallel pair).
- Intro roadmap: "carries the symmetries of a first law, and the steps from Aristotle to Einstein can be read as…" → "carries the symmetries of a first law. The steps from Aristotle to Einstein can be read as…" (two moves).
- **Aristotle**: "force is proportional to the velocity it produces, so a body with no force on it has zero velocity relative to absolute space: it is at rest." → "force is proportional to the velocity it produces. A body with no force on it therefore has zero velocity relative to absolute space: it is at rest." (two moves, two colons in one sentence).
- **Aristotle**: "…not of force and mass, and the operational concepts took a long evolution…" → "…not of force and mass. The operational concepts took a long evolution…" (two moves).
- **Newton**: "Each inertial observer means something different by being at rest, and the law, in Heller's words, …" → "…by being at rest. The law, in Heller's words, …" (two moves).
- **Newton with gravity**: "Parallel transport then depends on the path, and teleparallelism is lost: no field…" → "Parallel transport then depends on the path. Teleparallelism is lost: no field…" (two moves).
- **Einstein**: moved the sentence "The mathematics page opens with a short primer … says in what sense "product" is meant." from before "Heller notes this for general relativity. The same holds for Newton with gravity…" to after it (the insertion separated "Heller notes this" from the construction "this" refers to; the pointer now closes the paragraph). Link and anchor `#bundles-and-connections-in-brief` unchanged.
- Rovelli paragraph: "Aristotle's claims about such motion hold up; "What Aristotle does not have…"" → "…hold up. In Rovelli's words, "What Aristotle does not have…"" (semicolon before a quotation is not a parallel pair; attribution added so the free-standing quotation has a speaker). Quotation verbatim.

### One bracket, three mechanics

- Momentum as multiplier: "…to enforce "velocity is the rate of change of position," and that multiplier is the momentum: …" → "…to enforce "velocity is the rate of change of position." That multiplier is the momentum: …" (two moves; the quoted phrase is the author's own gloss, not a source quotation, so only its trailing comma became a period).
- "The Hamiltonian is what remains of the Lagrangian once the price is paid, and the pairing of each position with its price is where the bracket comes from." → two sentences (two moves).
- "The mathematics page defines it, derives Hamilton's equations…" → "…defines the Hamiltonian, derives Hamilton's equations…" (dangling "it": nearest antecedent was "the bracket", which the essay itself has already defined; the companion's section 2 opens by defining the Hamiltonian).
- Problem of time: "its Hamiltonian is a constraint, $H\approx 0$, and the generator of time evolution generates nothing observable: …" → "…$H\approx 0$. The generator of time evolution then generates nothing observable: …" (two moves).

### The algebra of free motions

- "A generator is a motion taken in an instant, and the Lie algebra records how two such motions fail to commute: …" → "A generator is a motion taken in an instant. The Lie algebra records…" (two moves).
- "In theirs as in Heller's, rest is absolute." → "In their Aristotelian space-times, as in Heller's, rest is absolute." (unclear referent of "theirs").
- Bargmann: "The Galilei group proper has these two commuting; mass enters as a central extension…" → "…commuting. Mass enters as a central extension…" (chained semicolon).
- Faddeev: "In Newton's world the boosts commute, and that algebra is not stable: …" → "In Newton's world the boosts commute. That algebra is not stable: …" (two moves).
- Semisimple gloss: "it has no set of generators that commute among themselves and that the rest of the algebra maps back into that set, as Newton's commuting boosts are mapped among themselves by rotations." → "it has no set of mutually commuting generators that the rest of the algebra maps back into the set, as rotations map Newton's commuting boosts among themselves." (stacked relative clauses; passive → active). Definition unchanged.
- "Classical mechanics is not stable either, and quantum mechanics deforms it with parameter $\hbar$." → two sentences (two moves).
- Chryssomalakos–Okon: "…instead of the Lorentz algebra; stability selects a semisimple algebra, and experiment selects the sign" → "…instead of the Lorentz algebra. Stability selects…" (chained semicolon; the "and" pair inside the new sentence is the true parallel).
- "Faddeev's criterion gives Heller's "logic…" an engine, and it points to a further rung…" → "…an engine. It also points to a further rung…" (two moves).
- KAM/dissipation: "…cannot keep tori that fill a region, and at most a few survive, as attractors." → "…cannot keep tori that fill a region. At most a few survive, as attractors." (two moves).

### A computational physics must earn its first law

- Active invariance: "…a pattern that the rule rebuilds at each new place, and nothing guarantees that such a pattern exists at each speed." → two sentences (two moves).
- Same paragraph: "Quantized speeds are not Life's problem, since a quantized space should have them. Its problem is the gaps. The glider has no slightly faster or slightly slower twin. The ships nearest to it in speed…" → "Life's problem is not that its speeds are quantized but that they have gaps. The ships nearest to the glider in speed…" (redundancy: "since a quantized space should have them" restated "Speeds may come in steps when space does" three sentences earlier; "The glider has no slightly faster or slightly slower twin" was restated by the paragraph's own "A small boost of a glider is not a slightly faster glider but no glider at all", which is kept).
- Wolfram's mass reading: "…a background flux that maintains space, and rest mass is the part of that flux…" → "…maintains space. Rest mass is the part of that flux…" (two moves).
- "…live on one-dimensional or grid-like backgrounds, and in 2022 Wolfram wrote that…" → "…backgrounds. In 2022 Wolfram wrote that…" (two moves).
- The test: "…across the range of speeds below $c$, with no gaps: neighboring speeds carried by nearly the same body." → "…below $c$, with no gaps, so that neighboring speeds are carried by nearly the same body." (two colons in one sentence).
- **Which speed is $c$?**: "…since that is how $c$ is defined, and the definition is statistical: …" → "…since that is how $c$ is defined. The definition is statistical: …" (two moves).
- Same: "…signals can run at one cell per generation; the first such "lightspeed wire" was found in 2002" → "…one cell per generation. The first such…" (chained semicolon).
- Emergent-$c$ condition: "…its caps are fixed in the lattice's frame, and velocities add as Galileo said they do." → "…fixed in the lattice's frame. Velocities therefore add as Galileo said they do." (two moves; "therefore" keeps the causal link the "because" clause had carried).
- Same: "Light in glass is slower, and although phase velocities can exceed $c$, signal velocities never do, as…" → "Light in glass is slower. Phase velocities can exceed $c$, but signal velocities never do, as…" (two moves).
- Same: "…of exactly the kind the condition forbids, and his answer takes the second option. As he puts it, …" → "…the condition forbids. His answer takes the second option: the faster channel stays unusable. As he puts it, …" (two moves; "the second option" pointed back eleven sentences to the condition's "or" clause, so its content is restated in five words to save the reader the lookup).
- Active vacuum: "…resembles an agar more than Life's empty grid, and our own vacuum, with its quantum fluctuations, is active too." → "…Life's empty grid. Our own vacuum, with its quantum fluctuations, is active too." (two moves).
- **The obstacle**: "…since a boost does not map a grid onto itself; Tommaso Bolognesi and Alexander Lamb…" → "…onto itself. Tommaso Bolognesi and Alexander Lamb…" (chained semicolon).
- Same: "…so the coarse-graining starts from a frame, and the paper does not show that the result is the same for every choice." → "…starts from a frame. The paper does not show…" (two moves).
- **Precedents**: "…have kept relativity at a price, and the precedents show three kinds of price. A substrate with a lattice has a rest frame, and it shows the generic outcome." → "…have kept relativity at a price. The precedents show three kinds of price. A substrate with a lattice has a rest frame and shows the generic outcome." (two moves; redundant "it").
- Deterministic rule: "It is discrete like a lattice, and if its causal graph has a preferred slicing, its particles should feel Aristotelian friction." → "It is discrete like a lattice. If its causal graph has a preferred slicing, …" (two moves).
- Heller's groupoid: "Its dynamics comes from the Tomita–Takesaki theorem and depends on the state, the device Alain Connes and Rovelli used for their thermal time hypothesis, though Heller…" → "Its dynamics comes from the Tomita–Takesaki theorem, the device Alain Connes and Rovelli used for their thermal time hypothesis. That dynamics depends on the state, though Heller…" (the apposition "the device…" could attach to "the state"; split puts it next to the theorem it names).

## Checked, no change needed

- Companion anchors in the essay: `#bundles-and-connections-in-brief`, `#one-bracket-three-mechanics`, `#kinematical-lie-algebras` all match headings in the companion (pandoc strips the leading section numbers). `#hellers-ladder-in-frame-bundle-terms` no longer appears in the essay: the author's uncommitted edit today replaced it with `#bundles-and-connections-in-brief` in the Einstein paragraph. The anchor still exists in the companion if the author wants a second pointer.
- "The qualitative theory returns in the next section" (bracket section) correctly points to *The algebra of free motions*.
- Spelling: no British forms found ("center", "neighboring", "catalogs" consistent).
- Remaining semicolons are true parallel pairs ("The first law said…; Liouville's theorem says…"; "A wide defect moves almost freely; a narrow one is pinned"), inside citations or quotations, or in the table.

## Noticed but left alone (author to decide)

- **"the glider's speed, not Life's $c$"** (end of *Which speed is $c$?*): in empty space the orthogonal cap is $c/2$, and the glider's $c/4$ is only the diagonal cap, as the next-but-one paragraph says. "The fastest ship's speed" or "the ships' cap" would be more accurate, but it changes the example.
- **Mass stated three times in a row** (Bargmann paragraph): "the bracket of a boost with a translation is the body's mass" / "A body's inertia is thus written into the algebra of its free motions" / "Mass measures how much a change of velocity fails to commute with a change of place." The third restates the first in words. Each has a distinct angle (formula, thesis, plain reading), so I kept all three.
- **"Lie algebra" introduced twice**: first formally in the bracket section ("The bracket makes the observables a Lie algebra"), then intuitively in the next section ("A generator is a motion taken in an instant…"). Moving the intuitive gloss earlier would restructure; the current placement is next to the kinematical generators where it is used.
- **Energy/momentum detour** in the bracket paragraph sits between "H generates time evolution" and "The three mechanics differ in what $H$ moves." It reads fine but makes that paragraph long; a paragraph break before "Energy can be pictured…" (and back before "The three mechanics differ…") would help, at the cost of altering paragraphing.
- **Noether stated twice**: energy/time and momentum/place in the bracket section, and translation symmetry → momentum by Noether at the end of *The algebra of free motions*. Distant enough to keep.
- **"Newton's first law, and Liouville's theorem with it, holds where a symmetry protects it: invariance under spatial translations"**: Liouville's theorem holds for any Hamiltonian flow, translation-invariant or not; what friction breaks is the Hamiltonian form. Possibly intended as "the conservative regime"; content question.
- **The obstacle** paragraph (~330 words) could be split at "Gorard addresses the theorem directly", but paragraphing was left as is.
- *The Demon Is a Learner* is introduced as "the sequel" twice (Rovelli paragraph and end of the emergent-$c$ paragraph). Distant; kept.
