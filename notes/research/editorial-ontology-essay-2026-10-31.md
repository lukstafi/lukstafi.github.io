# Editorial pass: "An Ontology That Pays for Itself" (pre-release, 31 Oct 2026)

Final editorial pass on `notes/an-ontology-that-pays-for-itself.md` at commit 550c4d7. The essay itself was not edited. The house style is the one in `AGENTS.md`. The settled design was not questioned. Findings flag only places where the text states the design inconsistently, along with prose, reference, notation and rendering problems. They are ordered by importance. Each quotes the passage verbatim and gives replacement text.

---

## A. The semantics stated inconsistently

### 1. IS-A is called "asymmetric", but the essay makes it reflexive

> "The first is IS-A, which is asymmetric."

**Problem.** Later the text has "With a reflexive IS-A, …" and says that *Role* "falls under itself". A relation that is reflexive cannot be asymmetric, since asymmetry rules out *x* IS-A *x*. A KR reader will notice. What the sentence means is that IS-A has a direction, in contrast with the unordered tuple.

**Replacement.**

> "The first is IS-A, which has a direction."

### 2. "Role is the top concept" is said twice in consecutive paragraphs, and the second lead repeats an earlier one

> "**Roles are concepts like any other.** Anything that takes part in a relation IS-A some role, so *Role* is the top concept. Some roles hold only for a while."

**Problem.** The paragraph just before this one ends its first sentence with "so it is the top concept, and it falls under itself". The lead "Roles are concepts like any other" also repeats "Roles and relations are concepts too" from the start of the section. What this paragraph actually adds is anti-rigid roles.

**Replacement.**

> "**Roles that lapse.** Some roles hold only for a while."

### 3. Russell's paradox gets two different answers in two paragraphs

> "The danger is not Russell's paradox. With a reflexive IS-A, the concepts that are not IS-A themselves form an empty class, and the empty class IS-A itself without contradiction. The danger is collective predication."

and, two paragraphs later (the only paragraph in that run without a bold lead):

> "*Role* covers everything that takes part in a relation, including relations and their links, so it is the top concept, and it falls under itself. That alone is harmless: Quine's New Foundations has a universal set. Paradoxes need a diagonal construction, a term for "the concepts that do not fall under themselves". The term language cannot form one."

**Problem.** The first passage says the Russell class exists and is empty. The second says the term language cannot form it. The two arguments sit in separate paragraphs with the collective-predication material between them. The reader meets the paradox, leaves it, and comes back to it with a different answer. Keep the second argument, which is the stronger one and the one the design relies on, and put all of it in one place.

**Replacement.** In the "No individuals, no classes" paragraph:

> "Dropping the distinction is in the spirit of term logic, and we accept that contradictions may arise. The danger is collective predication."

Then open the following paragraph with a bold lead, matching its neighbours:

> "**A top concept without paradox.** *Role* covers everything that takes part in a relation, including relations and their links, so it is the top concept, and it falls under itself."

The rest of that paragraph stays as it is. If the author wants to keep the empty-class point, it fits after "The term language cannot form one." as: "Even if it could, with a reflexive IS-A that class would be empty."

### 4. "Two-way reading" is used but never introduced

> ""Four legs" is beyond the two-way reading."

> "the two-way reading as the only class-level semantics"

**Problem.** After the rewrites, the phrase "two-way reading" appears nowhere before these two uses. The "Both directions" paragraph only says "Here it is the only reading an asserted class-level tuple has."

**Replacement** (in "Both directions"):

> "Here this *two-way reading* is the only reading an asserted class-level tuple has."

### 5. "A role is never matched with a filler" says the opposite of what is meant

> "The inner pairs are ordered, so a role is never matched with a filler."

**Problem.** The sentence just before it says that each ordered pair *joins* a role to a filler. The point is that a role and its filler cannot swap places. That matters here because roles are concepts and can themselves be fillers.

**Replacement.**

> "The inner pairs are ordered, so a role never trades places with its filler."

### 6. The closing paragraph gives the judgment to the ontology instead of the system

> "And who says that Mary drove home, to whom, and in which world, is recorded by the one judgment the ontology makes."

**Problem.** "One judgment" defines $\mathrm{Prov}(T,P)$ as "the system's own judgment". The ontology holds terms, "and nothing inside a term asserts anything".

**Replacement.**

> "And who says that Mary drove home, to whom, and in which world, is recorded by the one form of judgment the system makes."

### 7. "The system's judgment that a claiming event occurred" is not a Prov

> "Each judgment $\mathrm{Prov}(T,P)$ licenses the system's judgment that a claiming event $c$ occurred, with $\langle c,\textit{Claiming},\textit{content},T\rangle$ and $\langle c,\textit{Claiming},\textit{claimant},P\rangle$."

**Problem.** Prov is the only judgment, so the licensed judgment has to be a Prov with *Self* as its source. As written, the sentence reads like a second kind of judgment.

**Replacement.**

> "Each judgment $\mathrm{Prov}(T,P)$ licenses *Self* to assert that a claiming event $c$ occurred: $\mathrm{Prov}(\langle c,\textit{Claiming},\textit{content},T\rangle,\textit{Self})$ and $\mathrm{Prov}(\langle c,\textit{Claiming},\textit{claimant},P\rangle,\textit{Self})$."

### 8. A pointer sentence on assertion sits in the wrong paragraph

> "A term can also occur without being asserted, as the content of someone's claim does. Assertion therefore needs its own form, which the next section supplies."

**Problem.** These two sentences close the "Inheritance runs through images" paragraph, but they have nothing to do with inheritance. The "also" has no anchor. "The next section" is five paragraphs away. The term/assertion contrast belongs where assertion first appears, which is the start of "Both directions" ("Asserting a tuple claims something else").

**Replacement.** Delete the two sentences from "Inheritance runs through images". Append them, without "also", to the end of the "Tuples as terms" paragraph, after "…and every tuple IS-A $\langle\textit{Role},\textit{Role},\textit{Role},\textit{Role}\rangle$.":

> "A term can occur without being asserted, as the content of someone's claim does. Assertion therefore needs its own form, which the next section supplies."

### 9. "Only binary tuples exist" follows a "tuple of four concepts"

> "Only binary tuples exist, so a fact with more participants is reified as an event, in Donald Davidson's style."

**Problem.** The reader has just been told that a tuple has four components, so "binary" stalls them for a moment. What is binary is the number of fillers.

**Replacement** (coordinate with finding 15):

> "Every tuple has exactly two fillers, so a fact with more participants is reified as an event, in Donald Davidson's style."

### 10. Non sequitur on closure under inference

> "Only idealized sources and *Self* are closed under inference. Smith does not believe every consequence of what Smith says, so combining claims from different sources happens only in *Self*, after *Self* has adopted them."

**Problem.** Smith's lack of closure is a fact about one source. It explains why nothing is derived inside Smith's record. It does not explain why claims from *different* sources are combined only in *Self*. The sentence makes two moves, and the "so" links the wrong pair.

**Replacement.**

> "Only idealized sources and *Self* are closed under inference. Smith does not believe every consequence of what Smith says, so nothing is derived inside Smith's record. Claims from different sources are combined only in *Self*, after *Self* has adopted them."

### 11. The list of contexts attaches to "source"

> "A context records where a claim holds, not who makes it, and it can still be treated as a source: a novel's canon, a country's law, a hypothetical."

**Problem.** The sentence makes two moves, and the examples after the colon are examples of contexts. They land on "a source".

**Replacement.**

> "A context records where a claim holds, not who makes it: a novel's canon, a country's law, a hypothetical. It can still be treated as a source."

### 12. Negation and implication terms go beyond the "two primitives that form terms"

> "A denial is recorded as the assertion of a negation term, and a question asserts nothing. A conditional needs an implication term, so that a source saying "if $T_1$ then $T_2$" asserts neither $T_1$ nor $T_2$."

**Problem.** "Two primitives" opens with "It has two primitives that form terms." Images and intersections are built from those primitives, but negation and implication are new term formers that appear here without comment. One clause is enough to keep the claim of two primitives accurate.

**Replacement** (add after the passage):

> "Negation and implication are connectives over terms, beside the two primitives."

---

## B. References that no longer resolve, and terms used before they are introduced

### 13. "The middle term of the code" no longer has one referent

> "The middle term of the code needs, for each sentence, its facts in the ontology's terms."

**Problem.** In the section just before, the three-part code was replaced by the full objective, which has six summands. "The middle term" now points back two sections, past a formula where it has no clear referent. What the parser produces is $\mathrm{Prov}_d$.

**Replacement.**

> "The code needs, for each sentence, what it asserts in the ontology's terms: its share of $\mathrm{Prov}_d$."

### 14. "In its context" collides with the essay's technical sense of *context*

> "A model given the sentence and the relevant slice of the ontology in its context can produce them."

> "A parser that reads the ontology from its context needs no retraining for each edit."

**Problem.** The essay uses *context* for Cyc's microtheories and for idealized sources, and the next paragraph lists "context boundaries" among the edits. Here the word means the model's prompt.

**Replacement.** Change "in its context" to "in its prompt" and "from its context" to "from its prompt".

### 15. "Davidsonian" comes before Davidson is introduced

> "So can a single link, which a Davidsonian reading treats as a state that can be talked about."

**Problem.** Donald Davidson is first named eight lines later, in "**Events.**"

**Replacement.**

> "So can a single link, treated, in the manner of Donald Davidson, as a state that can be talked about."

Then, in "**Events.**", change "in Donald Davidson's style" to "again in Davidson's style".

### 16. NARS is never expanded

> "The closest system overall is Wang's NARS, in which inheritance is the only basic relation"

**Problem.** The earlier mention is "Pei Wang's *Non-Axiomatic Logic* (2013)", and the acronym NARS is never defined. It is also used later in "One judgment".

**Replacement.**

> "The closest system overall is NARS, the Non-Axiomatic Reasoning System that Wang built on his logic, in which inheritance is the only basic relation"

### 17. "The relation's schema" is a new name for $\langle R,R,S,S\rangle$

> "The step to the relation's schema is safe for its own reason:"

**Problem.** Everywhere else, $\langle R,R,S,S\rangle$ is "the relation" or "its relation". "Schema" appears only here.

**Replacement.**

> "The step from a tuple to its relation is safe for its own reason:"

### 18. Bits-back: "exactly" overstates, and "the first section" is ambiguous

> "Those recovered bits are exactly the overhead of the best-parse code from the first section."

**Problem.** Bits-back recovers $-\log q(t\mid x)$ for the sampled parse. That equals the best-parse overhead $-\log P(t^*\mid x)$ only when the parser is the exact posterior and the parse is $t^*$, but the sentences around it are about a parser that only approximates the posterior. "The first section" could also be read as the untitled introduction.

**Replacement.**

> "Those recovered bits are the bits that the best-parse code of "Merges that pay" spent naming its parse."

### 19. A recap inside "No individuals, no classes"

> "Asserted class-level tuples, as we saw, are collective claims about links, and the same rule keeps them from passing down. "

**Problem.** This restates the "Coverage is a property of the links taken together" paragraph, and "as we saw" flags it as a recap. The paragraph's argument (IS-A is distributive, so a kind gets a singular term) reads without it.

**Replacement.** Delete the sentence.

### 20. "A term again": Prov was never a term

> "Nesting would make $\mathrm{Prov}$ a term again."

**Replacement.**

> "Nesting would put a $\mathrm{Prov}$ inside a term."

---

## C. Sentences making two moves, and unanchored words

### 21. The AlphaEvolve appositive dangles

> "In [AlphaEvolve](https://arxiv.org/html/2506.13131v1), a language model proposes edits to programs and automated evaluators decide which survive, the cooperation of "heuristic exploration and rigorous acceptance" discussed in [*What Should a Program Inherit?*](https://lukstafi.github.io/notes/what-should-a-program-inherit.html#alphaevolve-variation-selection-and-what-survives)."

**Problem.** The appositive "the cooperation of …" attaches to "which survive", so it reads as though the surviving programs are the cooperation. The sentence makes two moves. The quoted phrase does occur in the target essay ("Heuristic exploration and rigorous acceptance can cooperate"), and the anchor resolves.

**Replacement.**

> "In [AlphaEvolve](https://arxiv.org/html/2506.13131v1), a language model proposes edits to programs and automated evaluators decide which survive. [*What Should a Program Inherit?*](https://lukstafi.github.io/notes/what-should-a-program-inherit.html#alphaevolve-variation-selection-and-what-survives) discusses the arrangement as a cooperation of "heuristic exploration and rigorous acceptance"."

### 22. A sentence begins with lowercase "babble"

> "[babble](https://lukstafi.github.io/notes/what-should-a-program-inherit.html#babble-when-a-common-pattern-becomes-a-useful-function), which that essay also discusses, and [Stitch](https://arxiv.org/abs/2211.16605) add an abstraction to a library when it shortens the corpus of programs."

**Problem.** Rendered, the sentence opens with a lowercase word and looks like a typo. Putting Stitch first also places "which that essay also discusses" directly after the tool it describes.

**Replacement.**

> "[Stitch](https://arxiv.org/abs/2211.16605) and [babble](https://lukstafi.github.io/notes/what-should-a-program-inherit.html#babble-when-a-common-pattern-becomes-a-useful-function), which that essay also discusses, add an abstraction to a library when it shortens the corpus of programs."

### 23. The key claim about collective assertion is the second half of a joined sentence

> "Asserting a class-level tuple is therefore a *collective* claim, and collective claims do not pass down IS-A."

**Problem.** The sentence makes two moves. The second is the new claim that the Puppy example then tests.

**Replacement.**

> "Asserting a class-level tuple is therefore a *collective* claim. Collective claims do not pass down IS-A."

### 24. "Both" has no clear antecedent

> "A tuple over individuals is a plain fact, and the same semantics covers both."

**Replacement.**

> "A tuple over individuals is a plain fact, read by the same semantics as a tuple over classes."

### 25. *Self* appears without a gloss

> "The shared world of the previous sections is $\mathrm{Prov}(T,\textit{Self})$."

**Problem.** The bold lead says "the system", and *Self* then appears as a source name that the reader has to infer.

**Replacement.**

> "The system is itself a source, *Self*. The shared world of the previous sections is $\mathrm{Prov}(T,\textit{Self})$."

---

## D. Notation and metadata

### 26. Concept names not in italics

- "Mammal is worth having because it lets a thousand facts about dogs, whales and bats be stated once." Change to "*Mammal* is worth having …".
- "Whether Mammal belongs in the ontology is settled the same way, one level up." Change to "Whether *Mammal* belongs …".
- "If the employment is an event with its own time and context, then "John IS-A Employee" holds in that context, not in the timeless shared world." Change to "… then *John* IS-A *Employee* holds in that context …", matching "*Puppy* IS-A *Dog*" elsewhere.
- "The derived IS-A of the previous section, "John IS-A Employee", is likewise asserted" Change to "The derived IS-A of the previous section, *John* IS-A *Employee*, is likewise asserted".
- Optional: "[OntoUSP](https://aclanthology.org/P10-1031/) adds ISA and IS-PART hierarchies" is the only "ISA" in the essay. It is OntoUSP's own spelling. Keep it, or write "IS-A and IS-PART" for consistency.

### 27. The index description calls the tuples "symmetric"

`index.html` (not the essay; listed here because the index title and description become the Substack title and subtitle):

> "provenance-conditioned compression, symmetric role tuples, and one form of judgment."

**Problem.** In the essay, a *symmetric* relation is "one whose roles coincide". The tuples themselves are unordered, not symmetric.

**Replacement.**

> "provenance-conditioned compression, unordered role tuples, and one form of judgment."

The YAML front matter is fine. The title and subtitle match the index entry, and the subtitle matches the essay ("provenance as the only judgment", "a single form of judgment").

---

## Cross-links checked

| Link in essay | Target | Status |
|:---|:---|:---|
| `https://lukstafi.github.io/notes/presumed-normal.html` (intro, the only link to it; three later mentions of *Presumed Normal* are unlinked) | `notes/presumed-normal.html` / `.md` | Not present; expected to land separately |
| `https://lukstafi.github.io/notes/what-should-a-program-inherit.html#alphaevolve-variation-selection-and-what-survives` | `notes/what-should-a-program-inherit.html` | File exists; anchor `id="alphaevolve-variation-selection-and-what-survives"` exists |
| `https://lukstafi.github.io/notes/what-should-a-program-inherit.html#babble-when-a-common-pattern-becomes-a-useful-function` | same | File exists; anchor `id="babble-when-a-common-pattern-becomes-a-useful-function"` exists |

## Rendering

No KaTeX problems found. All macros used (`\textit`, `\mathit`, `\sqcap`, `\exists`, `\iff`, `\Bigl[`/`\Bigr]`, `\langle`/`\rangle`) are supported, and the long displays are covered by the `overflow-x` style in the front matter. Three paragraphs continue a sentence after display math and so open in lowercase ("and the search keeps …", "read "$A$ plays role …"", "unordered pairs of ordered pairs …"). Other essays on the site do the same, so I left them unflagged.
