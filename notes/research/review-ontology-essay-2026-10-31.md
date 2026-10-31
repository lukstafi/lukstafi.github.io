# Review: "An Ontology That Pays for Itself" (draft of 31 Oct 2026)

Adversarial review of `notes/an-ontology-that-pays-for-itself.md`. I did not edit the draft. I checked the facts against `citecheck-ontology-biblio-2026-10-31.md`, `citecheck-ontology-priorart-2026-10-31.md`, the companion draft *Presumed Normal*, and three primary sources fetched for this review: the Vepštas *Sheaves* PDF (arXiv 1901.01341), the IRM PDF (cdn.aaai.org/AAAI/2006/AAAI06-061.pdf), and the McCarthy page (www-formal.stanford.edu/jmc/context.html).

## Verdict

The essay is well built and well sourced. The compression sections and the provenance section hold up. Nearly every citation matches the check reports, and the Vepštas passages I could not find in the reports are confirmed in his PDF.

The weak part is "Two primitives". Several of its sentences do not follow from the semantics the section itself gives:

- the collective-predication tuple;
- the identity of terms with the same link set;
- the Role fixed point;
- the claim about changing one side of a tuple;
- subrole implying subrelation.

Each can be repaired in a sentence or two, and none requires a change of design. Three other problems:

- The three-part code is missing its most obvious objection: a strong realization channel can absorb world knowledge.
- Two citations are misdescribed (LILO; the Dong et al. quotation, which is truncated).
- The analogy with Minimal Abnormality states MA slightly wrongly and claims more than it supports.

Findings are ordered by severity.

---

## A. Logic: statements that contradict the draft's own semantics

### 1. The collective-predication tuple is false under the two-way reading

> "Collective facts go into tuples, $\langle\textit{Human},\textit{taxon},\textit{rank},\textit{Species}\rangle$, which is how Wikidata already handles taxonomic rank."

**Problem.** The essay has just said that "When $A$ and $B$ are classes, the tuple asserts in both directions", and that there is no individual/class distinction. *Human* here is the same term as in "John IS-A Human", so it is a class. The tuple therefore says that every human stands as a taxon to some Species, so John is a taxon. It also says that every Species has some human as its taxon. Both claims are false.

Moving the collective fact into a tuple does not escape distributivity. The tuple reading is itself distributive (∀∃ both ways). Collective predication needs a *singular* term for the kind. The cited Wikidata precedent does exactly this: as I recall, "human" (Q5) and the taxon "Homo sapiens" (Q15978631) are separate items, and only the taxon item carries `taxon rank` = species. Check this before relying on it.

**Fix.** Introduce a singular kind term:

- *HomoSapiens* IS-A *Species*, which is distributive and harmless because the subject is singular;
- ⟨*HomoSapiens*, taxon, member, *Human*⟩, which is true both ways.

Then say that the collective/distributive problem is solved by giving kinds their own singular terms, not by putting kinds into tuples. This also explains the Wikidata practice correctly.

### 2. Tuple terms with the same link set behave differently when asserted

> "As a term, $\langle A,R,S,B\rangle$ denotes the set of $R$–$S$ links between members of $A$ and members of $B$. IS-A between tuple terms is inclusion between these sets … A term can occur without being asserted, as the content of someone's claim does."

**Problem.** Under this semantics, ⟨Dog,whole,part,Leg⟩ and ⟨Dog,whole,part,DogLeg⟩ denote the same set: the whole–part links between dogs and their legs. Each therefore IS-A the other. Yet one is true when asserted and the other is false. So the truth of an assertion is not a function of the term's denotation.

The same problem reaches the provenance machinery. ⟨c,Claiming,content,T⟩ cannot tell a claim of the Leg tuple from a claim of the DogLeg tuple if terms are identified by their extension. A KR reader will see this at once.

**Fix.** State that tuple terms are identified by their components $(A,R,S,B)$, not by their link sets. The link set is the term's *extension*. IS-A between tuple terms compares extensions. Assertion is evaluated on the components, as coverage of $A$ and $B$. Then add one sentence: terms with the same extension need not be interchangeable inside Prov or as the content of a claim. Also say what an IS-A term denotes, or that it has only assertion conditions. At present only tuples get a denotation, yet "Tuples and IS-A statements are terms".

### 3. ⟨Role,Role,Role,Role⟩ = Role contradicts the link-set semantics

> "$\langle\textit{Role},\textit{Role},\textit{Role},\textit{Role}\rangle=\textit{Role}$" and later "Anything that takes part in a relation IS-A some role, so *Role* is in effect the top concept."

**Problem.** As a term, the left side denotes the set of all links. *Role* denotes everything that plays a role, John included. John is not a link, so the equation fails in the semantics of "Tuples as terms".

Even the inclusion "every link IS-A Role" holds only for links that themselves fill a role in some other tuple. "Can fill" is not "does fill".

The 4-tuple also has two readings that differ. Under "a relation is identified with its pair of roles", it is the role pair (Role, Role). Under "Tuples as terms", it is the set of all links. Neither of these is *Role*.

**Fix.** Choose one of three repairs:

- weaken the equation to IS-A and add the stipulation that every link is reified as a role-player;
- present the equation as a definition of the top relation, not an identity of extensions;
- drop it.

If the "fixed point" stays, the Type:Type paragraph needs to change too (see 13).

### 4. Changing one side of a tuple does not always "break the other side"

> "Under the two-way reading, changing one side of a true tuple breaks the other side. Generalizing fails: ⟨Mammal,whole,part,Leg⟩ is false, since whales have no legs. Specializing fails too …"

**Problem.** There are three problems.

1. **Generalizing breaks its own side.** Generalizing Dog to Mammal breaks the ∀ on the Mammal side, not the other side. Only specialization breaks the opposite side.
2. **The example changes both sides.** It changes Dog→Mammal *and* DogLeg→Leg, so it does not illustrate "changing one side".
3. **"Fails" is too strong.** Specialization does not always fail. ⟨Dog,whole,part,DogFrontLeftLeg⟩ is a one-side specialization of ⟨Dog,whole,part,DogLeg⟩, and it is true. Generalization also succeeds whenever the added members have partners.

The correct statement is that neither direction is *guaranteed* to preserve truth. That is all the argument needs to motivate the image constructor.

**Fix.** Write something like:

"Under the two-way reading, IS-A on one side does not carry truth in either direction. ⟨Mammal,whole,part,DogLeg⟩ is false, since cats have no dog legs. ⟨Puppy,whole,part,DogLeg⟩ is false, since most dog legs belong to grown dogs. What always holds is the matched specialization …"

The general fact deserves one sentence. For any $A'$ IS-A $A$, the tuple ⟨$A'$,R,S,B restricted to partners of $A'$⟩ is true whenever ⟨A,R,S,B⟩ is true.

### 5. A subrole does not give a subrelation if roles are only classes of players

> "A subrelation comes from a subrole: since *mother* IS-A *parent*, every motherhood tuple is a parenthood tuple." together with "whatever plays the role $R$ IS-A $R$".

**Problem.** If a role's extension is the class of things that play it, then *mother* IS-A *parent* is inclusion of player classes. That does not imply that each mother–child link is a parent–child link.

A counterexample: if all teachers happened to be parents, *teacher* IS-A *parent* would hold extensionally, and every teacher–student link would become a parent–child link.

**Fix.** Make the order on relations primary: ⟨mother,mother,child,child⟩ IS-A ⟨parent,parent,child,child⟩, which is inclusion of link sets. Derive the inclusion of player classes from it, not the other way round. Alternatively, say that IS-A between roles is read on links.

### 6. The article/*Times* inheritance runs the wrong way

> "IS-A among sources gives inheritance between them: if an article IS-A a *Times* publication, the article's claims are the *Times*'s claims."

**Problem.** Distributive IS-A passes properties down from the class to its members. Here the claim goes *up*, from a member (the article) to something else (the *Times*). Moreover, the *Times* is not the class *TimesPublication*. If it were, Prov(T, TimesPublication) would mean that every *Times* publication asserts T. The relation between an article and the *Times* is a tuple (publication/publisher), not IS-A.

**Fix.** Write "if an article stands to the *Times* as publication to publisher, its claims may count as the *Times*'s claims". This is a rule about a relation, so it is not inheritance. Alternatively, keep IS-A among sources only for a case that really is downward, such as a rule stated for every *Times* editorial.

### 7. The objective's "final form" reverses data and model

> "The data is a set of $\mathrm{Prov}$ judgments, and everything else is model."

**Problem.** A few paragraphs earlier, $\mathrm{Prov}(T,P)$ "is the system's own judgment … made from a parse that may be wrong and graded by the parser's confidence". A parser's output is latent: it is the middle term of the code, not data. The data is the texts together with their metadata (URL, venue, date, intended audience).

**Fix.** "The data is the texts with their provenance metadata. The Prov judgments are how the model explains them, and the code decides which to adopt …"

It would also help to write the final objective once as a formula. The draft never does, though it says the objective "takes its final form". For example:

$L(\text{ontology}) + L(\text{source models}) + L(\text{world}\mid\text{ontology}) + \sum_d [L(\text{mentions}_d\mid\text{world},\text{source}_d,\text{audience}_d) + L(\text{text}_d\mid\text{mentions}_d,\text{lexicon})]$

This shows where the reporting policy and the lexicon are paid for. The three-part formula leaves the lexicon unpaid: it is conditioned on but never coded.

### 8. Singular terms and counting: the example misleads, and the distinction comes back

> "'Every John has a child among the Marys, and every Mary has a parent among the Johns' says no more than that John is Mary's parent." and "This is why the ontology can do without a distinction between individuals and classes."

**Problem.**

- **The example reads as plural.** "The Johns" naturally means people named John, so the sentence seems to say something false about naming.
- **Counting needs singular terms.** The later solution to counting, roles "each marked as taking exactly one filler", needs the semantics to count members. A front-left-leg role also needs a disjointness constraint, or four roles could share one leg. The language can then state cardinality, and singular terms are exactly the terms whose extension has one member. So the distinction is not gone; it is a definable predicate. Leśniewski's Ontology is the precedent: ε requires a singular subject.

**Fix.**

- Rephrase the example as "If *John* and *Mary* are terms with one member each, 'every member of *John* is a parent of some member of *Mary*, and conversely' says no more than …".
- Soften "can do without" to "needs no primitive distinction"; singularity is definable when needed.

### 9. A one-directional ("all–some") fact needs a stated reading

**Problem.** Every KR reader will ask how to say "every cell nucleus is part of some cell" when cells without a nucleus exist. The essay says the two-way reading is "the only reading a class-level tuple has". It does not say that all–some is still expressible.

**Fix.** Add one sentence in "Both directions" or "Inheritance forms new terms": "All–some is not lost. It is IS-A into an image: *CellNucleus* IS-A 'part of some *Cell*'." This also shows early why images are needed.

Related minor point: *PuppyLeg* is DogLeg ⊓ ∃partOf.Puppy. Both NARS and DL need an intersection as well as the image or ∃R.C. "has one, under the name image" is fine if the text adds "together with intersection".

### 10. The anti-rigidity rule has nowhere to put its qualifications

> "An IS-A derived from a tuple inherits that tuple's qualifications. If the employment is an event with a time and a context, then 'John IS-A Employee' holds only where the employment does."

**Problem.** IS-A is a binary term with no slot for time or context. Tuples get time only through reified events. Prov qualifies by source, and contexts are sources, but time is not a context. So the rule names a qualification that the representation cannot hold.

The paragraph also never names anti-rigidity or OntoClean. The prior-art report says roles are anti-rigid and dependent in OntoClean, and the essay later cites "OntoClean's analysis of roles" without explaining it.

**Fix.**

- Say where a derived IS-A lives: in the context or source of the event, as Prov(John IS-A Employee, c) with c the employment's context, or as a timed source. Alternatively, admit that time-indexed IS-A needs a context per interval.
- Name the OntoClean notion here: "OntoClean calls such roles anti-rigid".

### 11. The three-legged dog does not break any tuple stated so far

> "One three-legged dog breaks a strict 'every'."

**Problem.** Under the two-way reading, ⟨Dog,whole,part,DogLeg⟩ survives a three-legged dog, since one leg is enough. The dog breaks only the four-legs claim, which arrives two sentences later. So the order is new-before-given.

**Fix.** Put counting first ("'Four legs' is beyond the two-way reading …"), then exceptions: "One three-legged dog then breaks a strict 'every' on the front-left-leg role."

### 12. Prov polarity and negation terms both appear without a reason for having both

> "$\mathrm{Prov}$ needs a polarity, so that a denial is recorded as such. The term language needs negation and implication terms …"

**Problem.** With negation terms, a denial could be Prov(¬T,P). The essay gives no reason for also having a polarity on Prov, such as the speech-act difference between denying T and asserting ¬T. Adding full propositional connectives to the term language is also a large step to make in one sentence. It weakens the later argument that the language has "nothing to build with" (see 13).

**Fix.** Either drop polarity, or add a clause on why denial is not assertion of a negation. Note in the Type:Type paragraph that the connectives cannot form a diagonal term.

### 13. The Type:Type remark misdescribes the worry and its answer

> "a type of all types is inconsistent in type theory. Here the paradox has nothing to build with: the language has no unrestricted comprehension or abstraction …"

**Problem.**

- **Role is not a type of types.** It is a universal class that contains itself, and that is consistent in some set theories (Quine's NF has a universal set). Girard's paradox needs impredicative dependent products, which the essay's language lacks anyway.
- **"No abstraction" is too broad.** The essay does have restricted abstraction: images. It later adds negation and implication terms.

The Russell remark is correct as stated. Under reflexive IS-A the class of non-self-IS-A concepts is empty, and it IS-A itself without contradiction.

**Fix.** Write something like: "A concept that contains itself is harmless. Quine's NF has a universal set. Paradoxes need a diagonal construction, and the term language has none: images and connectives apply to given terms, and nothing can say 'the terms that are not IS-A themselves'." Keep "inconsistent in type theory" only if it is qualified (Girard's paradox in Martin-Löf's 1971 system).

---

## B. Compression: claims and missing objections

### 14. Missing objection: a strong realization channel leaves the ontology no credit

**Problem.** This is the objection that NLP and VAE readers will raise first. The draft never says what model codes $L(\text{text}\mid\text{facts},\text{lexicon})$. If it is an LLM, it already "knows" that dogs have four legs. Text about dogs then costs few bits whatever the facts say, and the ontology gets no credit for common sense. This is posterior collapse (a powerful decoder ignores the latent; Bowman et al. 2016).

The training box assumes this channel too: "sample facts and texts from the current model". Sampling texts from facts requires a generative realization model.

**Fix.** Add a short paragraph, or a bullet in "What compression cannot do". The realization channel must be weak in world knowledge, for example a grammar-plus-lexicon model or an LM restricted to paraphrase, or its own description length must be counted. Otherwise world knowledge goes to whichever component is cheapest to put it in.

### 15. Brown clustering is scored by likelihood alone, not by a two-part code

> "Scoring of this kind scales. Brown clustering is the same idea … Uszkoreit and Brants …" followed by "the likelihood term alone never stops refining … The prior is what pays for merging."

**Problem.** Brown clustering and Uszkoreit & Brants maximize likelihood alone. They stop at a class count the user sets (1,000 in Uszkoreit & Brants). No prior pays for their merges, which is exactly the failure the next paragraph describes. So "the same idea" and "Scoring of this kind" (an unanchored "this kind") claim more than they show. What scales is local scoring, not the two-part code.

**Fix.** "Local scores scale. Brown clustering merges classes by likelihood alone, down to a number of classes the user fixes, which comes to the same thing as … Uszkoreit and Brants … The locality is what lets the work be split." Brown's likelihood/mutual-information equivalence holds "in the limit" (biblio §4). That is fine to omit, but "comes to the same thing" could take "for large corpora".

### 16. The analogy with Minimal Abnormality states MA inaccurately and claims too much

> "That is the quantitative counterpart of what *Presumed Normal* describes in logical terms: Minimal Abnormality keeps a presumption wherever the premises do not force an abnormality, and the code keeps a default wherever the abnormalities do not cost too many bits."

**Problem.** There are three problems.

1. **The description of MA is wrong.** MA does not keep every presumption that the premises do not force. In *Presumed Normal*'s second example, neither $p\land\sim p$ nor $q\land\sim q$ is forced. Yet MA keeps neither presumption outright. It reasons across the minimally abnormal models and keeps what they agree on. "Not forced" is closer to the Reliability-versus-MA contrast than to MA itself.
2. **The two sides work at different levels.** MA (and ASP's `not ab(X)`) decides *per case* whether a presumption applies, and the default itself is never at risk however many exceptions there are. The code decides whether the default *exists at all*. The closest point in *Presumed Normal* is not MA. It is the logics of induction, where one counterexample withdraws a generalization, together with *pragmatic* background generalizations, which keep the instances after the generalization falls. The code's behaviour sits between those two.
3. **"The quantitative counterpart" is too strong.** Nothing shows a formal correspondence.

**Fix.** Something like: "*Presumed Normal* describes the per-case side in logical terms. Minimal Abnormality presumes each case normal as far as the premises allow. The code decides the rule-level question that the logic leaves open: whether the default is worth having at all. It keeps a default while its exceptions cost fewer bits than they save." Add a one-clause gloss of Minimal Abnormality, since the term is used here without introduction. AGENTS.md accepts the repetition when it saves the reader a lookup.

Related problems with the cross-references:

- Line 31: "Reasoning over it … is the subject of *Presumed Normal*". *Presumed Normal* never mentions ontologies. Say "The kind of reasoning it needs … is the subject of …".
- Line 144: "A class-level tuple can carry a typicality strength … and the default inference of *Presumed Normal* does the rest." The systems in *Presumed Normal* use priorities and minimal abnormality, not graded strengths. Say "the defaults of *Presumed Normal*, with strengths turned into priorities, …" or drop "does the rest".
- Line 168: "the adaptive logics of *Presumed Normal* keep them from spreading". This matches the companion essay.

### 17. "Exact effect on code length" conflicts with an approximate parser, and the cost goes unmentioned

> "Each proposal is checked by its exact effect on code length, so a high rate of bad proposals costs little."

**Problem.**

- **The change is not exact.** With an amortized, approximate parser (the box), the measured code length includes the parser's approximation gap (the KL term under bits-back). That gap varies between ontologies, so the measured change is an estimate.
- **Checking is not cheap.** Computing the change means re-parsing every sentence that touches the edited concepts with an LLM parser. "A high rate of bad proposals costs little" therefore needs support: the costly part is checking, not proposing.

**Fix.** Write "checked by its effect on code length, as measured by the parser". Add a clause on cost, for example that only the sentences whose parse uses the touched concepts need re-coding, which is the ontology analogue of USP's locality.

### 18. "A better compressor" holds only when model size is not counted

> "Large language models used as compressors beat general-purpose compressors on text by wide margins, at least when their own size is not counted. … The neural model is a better compressor and a worse ontology."

**Problem.** The hedge in the middle sentence is correct (biblio §20), but the last sentence drops it. By the essay's own two-part accounting, an LLM is not a better compressor of a gigabyte corpus once its weights are counted. Delétang's adjusted rates exceed 100% there.

**Fix.** "The neural model, at web scale or when its weights are free, is the better compressor and the worse ontology." Optionally cite Blier & Ollivier's prequential coding (already checked, biblio §21) as the fair way to count a network's size.

### 19. The table says "the middle term rewards", but two rows pay in the third term

> "The middle term rewards several kinds of structure in this way:" (table rows "A paraphrase equivalence", "A word sense")

**Problem.** Paraphrase equivalence and word-sense splitting shorten $L(\text{text}\mid\text{facts},\text{lexicon})$, the realization channel, not $L(\text{facts}\mid\text{ontology})$. "Shortens the code for both halves" is vague.

The default row's note is also muddled: "cheaper to list than the cases they spoil". The exceptions *are* the cases they spoil. The comparison should be between the default plus its exceptions and the alternatives, such as listing every case or splitting the class.

**Fix.**

- Change the lead-in to "The code rewards …", and either add a column for the term that pays or move the two lexical rows after the table.
- Rewrite the default sentence: "A default survives while the rule plus its list of exceptions is cheaper than the alternatives: listing every case, or splitting the class."

### 20. Smaller compression points

- **Canonical order.** In "or several token sequences encode the same parse and its probability is wrong", the probability is *underestimated*. The code stays valid but becomes longer. Say so: it is the same point as the best-parse remark.
- **Bits-back.** "Bits-back coding" is used without a gloss in a box aimed at general readers. Add a clause: "the encoder picks the parse using bits that the decoder recovers once it has the text". Hinton & van Camp 1993 is already checked (biblio §36).
- **USP's input parses.** USP's input parses come from a supervised parser (the Stanford parser; biblio §1). A grammar-induction reader will notice that "unsupervised" semantic parsing starts from supervised syntax. Add "from a supervised parser".
- **USP's example.** "is next to … borders" as USP's own example was not covered by the reports. I believe it is the paper's example (Utah borders Idaho), but check it.
- **The prior's effect.** "Turning its weight up yields coarse classes, the parts of speech. Turning it down yields synonym sets." This rests on Vepštas's informal observation and on Pereira et al.'s noun hierarchy. Hedge it: "should yield".

---

## C. Facts, quotations and links

### 21. LILO is misdescribed (flagged by the prior-art report)

> "In LILO, a language model proposes and documents abstractions, and the compression algorithm Stitch decides which enter the library."

**Problem.** In LILO the language model proposes *programs*. Stitch *extracts* the abstractions by compression, and the LM then documents them (AutoDoc). The prior-art report (E8b) says: "the LLM does not propose the library edits". As written, the sentence claims the very proposer–judge split that the essay presents as its own.

**Fix.** "In LILO, a language model writes programs, the compression algorithm Stitch extracts the abstractions worth adding to the library, and the language model names and documents them. Here the model would propose the edits themselves." This also keeps the novelty claim that the report supports.

### 22. The Dong et al. quotation is truncated, and the cut changes the method

> "'If two data sources provide a large number of common values', Xin Luna Dong and colleagues observe, copying is a likely explanation"

**Problem.** The full sentence (biblio §24) continues: "and many of these values are rarely provided by other sources (e.g., particular false values)". Sharing many values is what independent *accurate* sources do. Copy detection rests on shared *rare or false* values. The truncated version describes a method that would flag agreement as copying.

**Fix.** Quote the condition: "If two data sources provide a large number of common values and many of these values are rarely provided by other sources", copying is likely. Alternatively, paraphrase: shared errors are the evidence.

### 23. "Source chains are also what copy detection runs on" is not supported

**Problem.** Dong et al.'s methods run on overlaps of values across sources, not on attribution chains. Explicit chains (Smith-via-Times) declare a dependence. Copy detection infers dependences that nobody declares.

**Fix.** "Explicit chains give copy detection its easy cases. Undeclared copying has to be inferred from shared errors."

### 24. IRM wording and authors

> "Kemp and Tenenbaum's Infinite Relational Model … looking for blocks that are dense inside."

**Problem.** The PDF link works: it is the AAAI-06 paper, with title and authors confirmed. The IRM looks for sub-blocks that include "mostly 1s or mostly 0s" (Fig. 1 caption), so homogeneous blocks, not dense ones. Empty blocks are as informative as dense ones, which is also the "Low" half of Vepštas's test. The paper has five authors (Kemp, Tenenbaum, Griffiths, Yamada, Ueda).

**Fix.** "Charles Kemp, Joshua Tenenbaum and colleagues' Infinite Relational Model … looking for blocks that are uniformly dense or uniformly empty." In the next sentence, "Kemp and Joshua Tenenbaum" gives Tenenbaum's first name only at his second mention. Give it at the first.

### 25. The McCarthy link goes to an index page

**Problem.** www-formal.stanford.edu/jmc/context.html is a stub titled "Contexts (7-Jan-2001)". It links to HTML/PDF/PS versions in a `context3/` folder and to Thomason's bibliography, and it does not itself show ist(c,p). The draft's claim about McCarthy is supported by the prior-art report from the cogprints copy: no outermost context, and a regress that is infinite but harmless.

**Fix.** Link to the paper itself (the `context3/` HTML version, or https://web-archive.southampton.ac.uk/cogprints.org/418/ as the report used). Confirm that the version linked contains the "transcend the outermost context" passage.

### 26. Kit Fine's position is slightly misdescribed

> "Kit Fine argued that relations have no intrinsic argument order."

**Problem.** The sentence is true of Fine's conclusion. But Fine 2000 argues for *anti*positionalism and against positionalism, the view that relations have argument places, which is what role-labelled tuples are. One of his arguments concerns symmetric relations. The essay's coinciding roles (⟨A,sibling,sibling,B⟩) answer that objection, which is worth one clause.

**Fix.** "Kit Fine argued that relations have no intrinsic direction. He rejected the argument-place view that role-labelled tuples resemble, partly over symmetric relations, which coinciding roles handle." Alternatively, keep the sentence and cite Fine only for the "no direction" conclusion. This is from memory of Fine's paper; the prior-art report summarised it as positionalism, so check before revising.

### 27. Claims verified for this review that the reports did not cover

From the *Sheaves* PDF:

- The three-sentence example and its entries, including `walked ran drove: Mary- & home+;`.
- "It is perhaps deceptive, as it presumes that the three words … do not appear anywhere else in the sheaf."
- "Exactly what it means to be 'similar' is not defined here; this is up to the user."
- The names/actions correlation matrix, with "Mary book" and "the ran" as the rare cells. Vepštas calls this *diagonalization*; the essay might use his word.
- "gluing is parsing".

Other checks:

- **IRM link:** correct.
- **Nevill-Manning, Witten & Maulsby:** "8 to 23 percent worse than … PPMC" matches the report (23% static, 8.4% adaptive). "The precursor of Sequitur" is consistent with the report.
- **Delétang et al.:** the claim with its hedge matches biblio §20.
- **Brachman 1983, "What IS-A is and isn't":** missing. It is the classic source for the Fido-and-species confusion (prior-art E3, from memory; check the example). A KR reader will expect it next to "If both were IS-A, John would be a species."

---

## D. Structure and style (AGENTS.md)

### 28. The sheaf-vocabulary paragraph could be cut

> "One piece of the sheaf vocabulary does real work. … The restriction of a large structure to the part one sentence needs will matter again …"

**Problem.** The paragraph announces that one piece of the vocabulary does real work. It then spends most of its words on gluing and on where gluing fails. The piece that does the work, restriction, gets half a sentence.

The later use ("The slice is the restriction of the ontology to what the sentence needs, the same operation that a parser performs on a grammar") also overstates the analogy. A grammar's restriction is a lookup by word. An ontology's restriction depends on which senses and concepts the parse will use, so it is a retrieval problem.

**Fix.** Cut the paragraph. At line 176, write: "The slice is the part of the ontology the sentence needs, much as a parser needs only the lexicon entries of the sentence's words. Finding it is a retrieval problem, since which concepts a sentence needs depends on its parse."

### 29. The closing open-problems paragraph mostly recaps

> "Counting needs roles that take exactly one filler. Exceptions need the typicality strengths … Copy detection must work at web scale, coherent myths must meet sources outside text, and deductive closure must stay inside *Self* …"

**Problem.** Each clause restates a point made earlier. AGENTS.md asks for recaps to be cut.

**Fix.** Replace the paragraph with the problems not yet stated:

- the strength of the realization channel (14);
- the cost of search and of re-parsing (17);
- naming and aligning induced concepts so they can be evaluated against WordNet, Wikidata and OpenCyc. LILO's AutoDoc is the precedent.

Keep "Nothing here has been implemented" and the evaluation sentences.

### 30. Sentence-level issues

- **Line 138, "which is monotone":** says neither what is monotone nor in what. Write "Inclusion is monotone in each component: enlarging $A$ or $B$ enlarges the set."
- **Line 156, "It is valid only when asserted.":** unclear, since a judgment is asserted by definition. Cut it, or say "It has no truth value of its own; it is a record."
- **Line 120, "Since every relation can then fill a role":** "then" dangles. Write "Since a relation is a concept, it can fill a role …".
- **Line 176:** one sentence makes two moves and has a tense slip ("a model that took the ontology as input does not have to be retrained"). It also sits uneasily with the box, which does train the parser. Split it: "The ontology changes with every accepted merge or split. A parser that reads the ontology from its context needs no retraining for each edit."
- **Line 51:** "The OpenCog project's published evaluations scored … not against human treebanks, with no standard baselines, and learning from unsupervised parses reached an F1 of about 0.5" makes three moves. Split it after "treebanks". Also note that these are the ULL team's papers (Glushchenko et al.), and that Vepštas's own 2022 experiments report no quality evaluation (biblio §39).
- **Line 86, "before knowing anything about the source":** write "without knowing".
- **Line 90, "Text simplification adds exactly such content":** "exactly" overclaims. Elaborations are often definitions and background (Srikanth & Li). Write "adds content of this kind".
- **Line 80:** *DogLeg* appears before it is introduced at line 132. Either use *Leg*/*BodyPart* only here, or gloss it ("legs of dogs").
- **Line 126, "The rest of this section works through what these choices commit us to.":** a signpost that can be cut, since the bold paragraph heads do its work.
- **Line 45, "and this keeps antonyms apart":** "this" points at the prior two clauses back. Write "a prior that keeps antonyms apart".
- **Line 88 against line 162:** "A source has a context, the world it describes" and "Contexts are idealized sources" set up two relations between sources and contexts. Pick one, or say how they combine: Rowling's sentences are coded against the canon, which is itself a source.
- **Line 37:** the dense names/actions block is a *syntactic* co-occurrence, yet it "will return later as the basic unit of the ontology". The next section argues that text is not the world. A half-clause would keep this from looking like the conflation the essay warns against: "returns, one level up, as …".

---

## E. Objections a specialist would raise that the draft does not address

These are in addition to 9 and 14.

1. **The second direction is often empty.** Fine classes defined by the relation itself, as DogLeg is ("legs of dogs"), make the B→A direction true by construction. The two-way reading then says only "every dog has a leg". The second direction discriminates only when $B$ is defined independently. One sentence would show that the author has seen this.
2. **The scale of COMPOSE and MERGE search.** USP ran on about 2,000 abstracts. The jump to an ontology at web scale is asserted through Brown clustering, which has the simplest seeds and a likelihood-only score. A grammar-induction reader will want an acknowledgement that the search over ontology edits is the bottleneck, not the scoring.
3. **Identifiability.** Many ontologies will have nearly equal code lengths, differing in role naming and in where defaults sit. The essay could say that MDL picks a class of near-ties, and that evaluation against WordNet and Wikidata then needs concept alignment.
