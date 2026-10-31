# Prior-art check: compression-induced ontology for a "neurosymbolic Cyc" (31 Oct 2026)

This is an adversarial novelty check of design elements E1–E9 for the planned essay. Verdict scale:

- **SAME IDEA**: the element, or its core move, is already in the literature (cite it).
- **CLOSE**: the parts exist but differ in a way that matters (the difference is named).
- **NOTHING FOUND**: no matching work turned up (the searches are listed).

Notes are marked "verified" when I read the source text (PDF, arXiv abstract, or an authoritative copy) during this session. They are marked "from memory" when they are standard knowledge I did not re-fetch. Check the "from memory" items before quoting them.

## Summary table

| # | Element | Verdict | Closest prior art |
|---|---------|---------|-------------------|
| E1 | Two primitives: IS-A, plus symmetric role-labelled tuples ⟨A,R,S,B⟩≡⟨B,S,R,A⟩; relation = role pair; ⟨A,R,S,B⟩ IS-A ⟨R,R,S,S⟩; ⟨Role,Role,Role,Role⟩=Role | **CLOSE** (the unordered role-labelled tuple is SAME as Codd 1970, ORM and Fine 2000; the self-typing tuple and the Role fixed point were NOTHING FOUND) | Codd 1970 "relationships" with role names; ORM fact types; Fine 2000 positionalism; Orilia 2011 o-roles; Sowa (relation = role + Has); NARS relational terms; UFO relators |
| E2 | Class-level tuple = bi-total (∀a∃b and ∀b∃a); hence ⟨Dog,whole,part,DogLeg⟩, not Leg | **CLOSE**, bordering on SAME | Smith et al. 2005 `integral_part_of` = part_of ∧ has_part, with the "cell nucleus part_of cell, but not cell has_part cell nucleus" example; DL A⊑∃R.B ⊓ B⊑∃R⁻.A; ORM/ER mandatory or total participation on both roles; "correspondence" in Gromov–Hausdorff theory |
| E3 | No individual/class split; singular terms = wild quantity; IS-A distributive only; collective predication pushed into tuples | **CLOSE** | Sommers/Englebretsen wild quantity (source of the idea, credited); Leśniewski's Ontology; NARS (instance as derived copula); Wikidata's `taxon rank` (P105) in practice; MLT/Wikidata anti-pattern work |
| E4 | Inheritance under E2 forces term-forming images (PuppyLeg = DogLeg part-of some Puppy) | **SAME machinery**; the "forcing" observation is CLOSE | NARS extensional images (Wang, NAL-4 Def. 8.4); DL ∃R.C; SEP triplets (Schulz, Romacker & Hahn 1998) |
| E5 | Provenance as the only judgment form; non-nesting Prov(T,P); nesting moved into composed sources; Self stops the regress; idealized sources are closed; Davidsonian claim events | **CLOSE**; the composed-source move alone is **SAME** | ABLP 1993 quoting principal A\|B; MPQA/FactBank nested-source chains ⟨writer, Sue⟩; Carroll et al. 2005 named graphs with `swp:assertedBy` warrants; Cyc microtheories / McCarthy `ist`; nanopublications |
| E6 | Three-part MDL: L(ont)+L(facts\|ont)+L(text\|facts,lexicon), per-source reporting policy P(mention\|f,source,audience); consensus as compression | **CLOSE** (the pieces exist; I found no unified objective and no audience term) | Katz et al. 2008 (theories as compressive laws + core facts); Li & Abe 1998 (MDL picks class level of relation arguments); KGist (MDL over KGs); Latent Truth Model (per-source FP/FN rates); Knowledge-Based Trust (source plus extractor error); USP/OntoUSP (likelihood + exponential prior on #params) |
| E7 | Common ground = facts stated to novices and omitted to experts on the same topic | **CLOSE** (the ingredients exist; I found no contrast-based measurement) | Romero & Razniewski 2022 (children's texts state more commonsense); Srikanth & Li 2021 (elaborative simplification); Cao et al. 2020 (expert/layman Merck corpus); Gordon & Van Durme 2013 (reporting bias) |
| E8 | LLM as (a) amortized semantic parser into the ontology, (b) proposer judged by exact code-length change, (c) one more provenance-tagged source | (a) **SAME** as a proposal; (b) **CLOSE**; (c) **NOTHING FOUND** as stated | Lenat & Marcus 2023 §3 (LLM → "fractured CycL" → Cyc repairs and checks); Wong et al. 2023 (LLM → PLoT); LILO 2023 (LLM proposes, Stitch compresses); Ellis 2023 (LLM proposer, Bayesian judge); LLMs4OL / OLLM (LLM as the ontology learner) |
| E9 | Vepštas sheaf/link-grammar learning or USP framed as MDL ontology induction | **CLOSE** (both have informal or implicit MDL; neither is framed as MDL ontology induction) | Vepštas & Goertzel 2014 ("sum of the (logarithm of) the number of rules, and the (logarithmic) complexity … an 'Occam's razor'"); Vepštas 2017 sheaves (compression level separates syntactic from semantic classes); USP's "exponential prior … on the number of parameters" |

---

## E1. Representation: IS-A plus symmetric role-labelled tuples

**Verdict: CLOSE.** The unordered, role-labelled tuple is old. Relations as concepts are standard in term logic and in conceptual graphs. Two parts turned up nothing:

- treating the relation itself as the self-typed tuple ⟨R,R,S,S⟩;
- the fixed point ⟨Role,Role,Role,Role⟩ = Role.

**Unordered role-labelled tuples (SAME).**

- **Codd 1970**, "A Relational Model of Data for Large Shared Data Banks" (verified from the PDF): "we propose that users deal, not with relations which are domain-ordered, but with relationships which are their domain-unordered counterparts. … where there are two or more identical domains, we require in each case that the domain name be qualified by a distinctive role name, which serves to identify the role played by that domain in the given relation." His example uses `sub.part` and `super.part`, which is exactly ⟨A, sub, super, B⟩ ≡ ⟨B, super, sub, A⟩. https://www.seas.upenn.edu/~zives/03f/cis550/codd.pdf
- **Object-Role Modeling (Halpin).** A binary fact type is a pair of roles. The forward and inverse readings ("officially uses / is officially used by") belong to one fact type, not to two relations (verified from course slides). https://www.inf.unibz.it/montali/teaching/1516/dpm/slides/3b.orm-2.pdf
- **Fine 2000, "Neutral Relations"** (Phil. Review). Under positionalism, a relation has unordered argument positions, so a relation and its converse are the same relation. This is the metaphysics behind ⟨A,R,S,B⟩≡⟨B,S,R,A⟩, with R and S as positions. https://sites.pitt.edu/~rbrandom/Courses/2024%20Philosophy%20of%20Language/Texts/Fine%20Neutral%20Relations.pdf
- **Orilia 2011, "Relational Order and Onto-Thematic Roles"** (Metaphysica 12:1–18). Relational order is explained by o-roles, "ontological counterparts of the thematic roles" (agent, patient …). The roles are general and shared across relations, as in E1, where roles are concepts.

**Relations and roles as concepts (SAME or CLOSE).**

- **Sowa.** Thematic roles are types, and "each relation is defined in terms of the corresponding role and the primitive dyadic relation Has. Agnt, for example, is defined as HasAgnt" (verified). https://jfsowa.com/ontology/thematic.htm
- **NARS / NAL-4** (Wang, *Non-Axiomatic Logic*, §8; verified from the draft PDF). Relations are ordinary terms ("acquired relations … are indicated by terms"). A relation holds via the product term (× water salt) → dissolve. Only the copulas are privileged, so E1's "only IS-A is primitive" mirrors NARS's architecture. NARS products are ordered, however, and NARS does not identify a relation with its role pair. https://cis.temple.edu/~pwang/AGI-NARS/2022-DF/Reference/NAL-Wang-draft.pdf
- **UFO/OntoUML relators.** Material relations are derived from a reified relator and its mediation links to the role-players. This is a different decomposition: the relator is an individual, whereas E1 makes the relation the most general tuple. https://ontouml.readthedocs.io/en/latest/relationships/material/
- **GFO** (Loebe 2007, Applied Ontology). Relators connect role players through relational roles; the example is the marriage relator with wife and husband roles. https://onto-med.github.io/gfo-light/gfo-light/2025-03-17/

**Ordered relations with declared inverses (the contrast class).** These systems keep ordered predicates and add an inverse axiom:

- RDF/OWL `owl:inverseOf`;
- SUMO `inverse`;
- Cyc `genlInverse` (from memory: `(genlInverse P Q)` means P(x,y) ⇒ Q(y,x)).

E1 removes the need for these axioms by making converses identical, which Codd, ORM and Fine already do.

**⟨A,R,S,B⟩ IS-A ⟨R,R,S,S⟩ and ⟨Role⁴⟩ = Role: NOTHING FOUND.** The nearest analogues are metamodel fixed points (from memory, standard):

- `rdfs:Class rdf:type rdfs:Class`;
- `rdf:Property rdf:type rdf:Property`;
- MOF's self-describing M3 layer;
- Smalltalk metaclass loops.

Caution: Cardelli's Type:Type is inconsistent (Girard's paradox). The essay should say why the Role fixed point is harmless; the absence of an unrestricted comprehension or abstraction operator is the likely reason.

Searched:

- "ontology relations unordered role-labelled pairs";
- Fine positionalism;
- Orilia o-roles;
- ORM readings;
- Codd role names;
- Cyc genlInverse;
- UFO relators;
- GFO relational roles;
- NARS product and image.

## E2. Bi-total semantics of class-level tuples

**Verdict: CLOSE, bordering on SAME.** The two-directional class-level relation is explicitly defined in biomedical ontology. What I did not find is a proposal to make it the *only* class-level semantics.

- **Smith, Ceusters, Klagges, Köhler, Kumar, Lomax, Mungall, Neuhaus, Rector, Rosse 2005**, "Relations in biomedical ontologies", *Genome Biology* 6:R46 (verified):
  - part_of has "all-some" structure, and "from A part_of B we cannot infer that B has_part A … cell nucleus part_of cell, but not cell has_part cell nucleus."
  - Defined bi-directional relations: "C integral_part_of C₁ = [definition] C part_of C₁ and C₁ has_part C".
  - Also "C₁ co-adjacent_to C₂ = [definition] C₁ adjacent_to C₂ and C₂ adjacent_to C₁".
  - `integral_part_of` is precisely E2's ⟨C₁, whole, part, C⟩.
  - The Dog/Leg versus DogLeg consequence is the same as their nucleus/cell point, seen from the other side.
  - https://pmc.ncbi.nlm.nih.gov/articles/PMC1175958/
- **Description logic.** A ⊑ ∃R.B ⊓ B ⊑ ∃R⁻.A is a routine pair of axioms (standard; not cited to a specific paper).
- **ORM / ER.** A mandatory role constraint on both roles of a binary fact type ("Each Country officially uses some Language" plus the converse) is bi-totality. In ER it is "total participation" on both sides (from memory; Elmasri & Navathe). The difference is that these are integrity constraints over closed database populations, not assertions in an open-world KB.
- **Relation algebra and allegories** (from memory). A relation that is both *entire* (1 ⊆ RR°) and *surjective* (1 ⊆ R°R) appears in Freyd & Scedrov's *Categories, Allegories*. Wikipedia's "bitotal" naming is consistent with this.
- **Gromov–Hausdorff.** A "correspondence" is R ⊆ X×Y whose projections are both surjective (verified via arXiv 2603.26428 and Tuzhilin arXiv 1612.00728).
- **Relational syllogistic** (Pratt-Hartmann & Moss 2009, arXiv 0808.0521). It has "every A r some B", but a single sentence form that encodes both directions was not found there.

What differs: Smith et al. offer integral_part_of alongside the one-directional all-some relations. E2's claim is that *every* class-level tuple is bi-total and that the one-directional readings are not primitive. I did not find that restriction proposed. The essay should cite Smith et al. 2005 for the construction and the nucleus/cell example.

## E3. No individual/class distinction; wild quantity; distributive IS-A

**Verdict: CLOSE.** Every component exists. The specific package (term-logic terms + wild quantity for singulars + distributive-only IS-A + collective predicates moved into tuples, all in a KR system) was not found as one design.

- **Sommers / Englebretsen, term functor logic.** A singular subject has "wild quantity": it may be read as universal or particular, which goes back to Leibniz on Englebretsen's reading. "Fido is a dog" is symbolized ±F+D (secondary sources). This is the source of E3's move and should be credited, not claimed. https://revistas.ufrj.br/index.php/analytica/article/view/2173
- **Leśniewski's Ontology** (from memory). It has one category of names, singular and general alike, with ε as the copula. There is no type distinction between individuals and classes.
- **NARS.** Individuals are singleton extensional sets {Tweety}. The `instance` copula is "used only in Narsese for I/O, and translated into Inheritance for internal use" (Open-NARS javadoc). That is close, but NARS keeps a set constructor rather than wild quantity. https://cis.temple.edu/~wangp/Implementation/nars-dist/javadoc/nars/language/package-summary.html
- **HiLog** (Chen, Kifer & Warren 1993) and **OWL 2 punning** (from memory). One symbol may serve as both class and individual, but in OWL 2 the two readings are semantically unconnected. This is the contrast case, not a match.
- **Collective predication and IS-A transitivity.**
  - The "Fido is a dog; dog is a species" fallacy is folklore in KR, discussed in Brachman 1983, "What IS-A is and isn't" (from memory; check the exact example).
  - Multi-level modelling work (Brasileiro, Almeida, Carvalho & Guizzardi, WWW 2016 companion) documents Wikidata anti-patterns from mixing instance-of and subclass-of in taxonomies. https://nemo.inf.ufes.br/wp-content/papercite-data/pdf/applying_a_multi_level_modeling_theory_to_assess_taxonomic_hierarchies_in_wikidata_2016.pdf
  - Wikidata in practice already pushes rank into a property: `taxon rank` (P105) rather than instance-of Species (from memory). That is E3's "collective predication into tuples", done ad hoc.

## E4. Inheritance forces image constructors

**Verdict: SAME machinery; the forcing argument is CLOSE.**

- **NAL-4 images** (verified, Wang draft Def. 8.4): "((× T1 T2) → R) ⟺ (T1 → (/ R ◇ T2)) ⟺ (T2 → (/ R T1 ◇))", with "(/ dissolve ◇ salt) is 'whatever dissolves salt'". PuppyLeg in NARS is the intersection of DogLeg with (/ part_of ◇ Puppy).
- **Description logic**: PuppyLeg ≡ DogLeg ⊓ ∃partOf.Puppy (standard).
- **SEP triplets** (Schulz, Romacker & Hahn, AMIA 1998; still used in SNOMED CT). Every anatomical class X gets X_Structure, X_Entire and X_Part, with X_Part effectively ∃partOf.X_Entire. This is an engineered family of term-forming part classes made to get inheritance right. https://pmc.ncbi.nlm.nih.gov/articles/PMC2232338/
- NAL's class-level reading of a product statement is not bi-total, and I did not confirm its exact semantics, so state it with a hedge. So the "specialization forces a new image term" point is a consequence of E2, not of NARS or DL. That consequence is the part to present as the essay's own observation.

## E5. Provenance as the only judgment form

**Verdict: CLOSE overall. The specific move "nesting → composed source term" is SAME (ABLP; MPQA/FactBank).**

- **Abadi, Burrows, Lampson & Plotkin 1993**, "A Calculus for Access Control in Distributed Systems" (TOPLAS 15(4); verified from Lampson's site text): "B|A: B quoting A; (B|A) says s if and only if B says A says s." The essay's Smith-via-Times is ABLP's Times|Smith. Cite it. https://www.bwlampson.site/44-CalculusAccessControl/44-CalculusAccessControlOCR.htm
- **MPQA** (Wiebe, Wilson & Cardie 2005) **and FactBank** (Saurí & Pustejovsky 2009). The "nested source" is an ordered list rooted at the writer, e.g. ⟨writer, Xirao-Nima, U.S.⟩. FactBank annotates event factuality relative to such chains. This is the NLP precedent for composed sources and for a fixed root, the writer, which parallels E5's Self. https://mpqa.cs.pitt.edu/
- **Named graphs with warrants** (Carroll, Bizer, Hayes & Stickler, WWW 2005). A graph is asserted by linking it to a warrant (`swp:assertedBy`) naming an authority. The 2004 drafts float `notAssertedBy` for fiction. Hayes and Stickler debated whether publication alone is assertion. This is the closest Semantic Web analogue of "only Prov asserts". https://lists.w3.org/Archives/Public/www-archive/2004Mar/att-0215/ng.pdf
- **Nanopublications** (Groth, Gibson & Velterop 2010): separate assertion, provenance and publication-info graphs. The assertion is still a graph that someone claims, so this is close to "tuples are terms, Prov asserts".
- **McCarthy 1993 `ist(c,p)` / Cyc microtheories.**
  - Every Cyc assertion lives in a microtheory, which is close to "no context-free judgment".
  - McCarthy allows nesting, ist(c′, ist(c,p)), and says "the regress is infinite, but … harmless". He also insists one can always "transcend the outermost context".
  - E5 is the opposite design: no nesting, and Self as a fixed terminus. That contrast is worth stating.
  - https://web-archive.southampton.ac.uk/cogprints.org/418/
- **Contexts as idealized, deductively closed sources** (from memory). This is close to Cyc fiction microtheories and to Lewis 1978, "Truth in Fiction" (story operator). Konolige's deduction model and Levesque's explicit/implicit belief are the formal story for *non*-closed agents.
- **Davidsonian claim events.** MPQA "speech events" and FactBank's reporting events are annotated as events with sources. `rdf:Statement` reification is the KR version.
- **NARS stamps** (from memory) record evidential bases to prevent double counting. They are not source models, so they are not a match. Justification logic (t:F) and Wikidata references and qualifiers are further neighbours, but none treats source-relative assertion as the only judgment.

What I did not find: a system where a single, non-nesting provenance relation is the *only* judgment form, combined with ABLP-style composed sources and Self as the terminal source whose theory is the shared world.

## E6. Three-part MDL code with source-conditioned reporting

**Verdict: CLOSE.** Each term has precedent. I found no paper with the unified code, and none with an audience-conditioned reporting policy.

- **L(ontology) + L(facts | ontology).**
  - Katz, Goodman, Kersting, Kemp & Tenenbaum 2008, "Modeling semantic cognition as logical dimensionality reduction" (CogSci) treat theories as "compressive probabilistic models that try to express observed data as samples from the logical consequences of a theory's underlying laws plus a small number of core facts." https://cocolab.stanford.edu/papers/KatzEtAl2008-Cogsci.pdf
  - Kemp, Tenenbaum et al.: the IRM (AAAI 2006) and "A probabilistic model of theory formation" (Cognition 2010).
- **MDL choosing the class level of relation arguments.** Li & Abe 1998, "Generalizing Case Frames Using a Thesaurus and the MDL Principle" (CL 24(2)), picks the MDL-optimal "tree cut" of a thesaurus for each argument slot. It is the closest precedent for choosing DogLeg rather than Leg or Animal-part by code length. https://aclanthology.org/J98-2002.pdf
- **MDL over knowledge graphs.** KGist (Belth, Zheng, Vreeken & Koutra, WWW 2020) selects rules that best compress the KG. Rule violations flag errors, exceptions and missing facts. https://arxiv.org/abs/2003.10412
- **Ontology induction from text.** USP and OntoUSP (Poon & Domingos 2009, 2010) jointly induce ISA and IS-PART hierarchies of lambda-form clusters. The objective is a likelihood plus an "exponential prior … on the number of parameters", which is a two-part code in all but name.
- **Per-source reporting policy.**
  - Zhao, Rubinstein, Gemmell & Han 2012, Latent Truth Model (VLDB), model "two different aspects of source quality" (false positives and false negatives). The FN rate is P(not mention | true, source), the audience-free core of E6's reporting policy. https://arxiv.org/abs/1203.0058
  - Dong et al. 2015, Knowledge-Based Trust, separates source error from extractor error, which corresponds to E6's L(text | facts) layer. https://arxiv.org/abs/1502.03519
  - Knowledge Vault (Dong et al. 2014) fuses extractors with KB priors.
- **"Consensus as compression".** The phrase and the promotion rule (code a fact once in Self versus per source) were NOTHING FOUND. The nearest relevant paper is a caution: Krestnikov 2026, "Truth as a Compression Artifact in Language Model Training" (arXiv 2603.11749). It argues "gradient descent favors the most compressible answer cluster, not truth per se" and that "truth bias emerges only when falsehood is structurally incoherent." The essay should address this failure mode: coherent shared myths compress well.

Searched:

- MDL + truth discovery;
- MDL + multi-source KB;
- "consensus" + compression;
- MDL ontology induction;
- USP/OntoUSP priors;
- KGist;
- LTM;
- KBT.

## E7. Common ground as novice-versus-expert contrast

**Verdict: CLOSE.** The ingredients exist. I found no work that *measures* common ground as the set difference between novice-addressed and expert-addressed statements on the same topic.

- **Romero & Razniewski 2022**, "Do Children Texts Hold The Key To Commonsense Knowledge?" (EMNLP). They argue "seemingly obvious assertions may still be frequently expressed explicitly" in children's texts, and find "children's texts indeed contain much more, and more typical commonsense assertions." This is one side of E7's contrast, used for extraction rather than as a differential measure. https://arxiv.org/abs/2210.04530
- **Srikanth & Li 2021**, "Elaborative Simplification" (Findings of ACL). It is the "first data-driven study of content addition in text simplification", with 1.3K annotated elaborations in Newsela. The added content is exactly "what novices are told that experts are not". https://aclanthology.org/2021.findings-acl.455
- **Cao et al. 2020**, "Expertise Style Transfer" (ACL). The MSD corpus comes from the Merck Manuals' parallel consumer and professional versions, a ready-made same-topic expert/novice pair. https://arxiv.org/abs/2005.00701
- **Reporting bias.** Gordon & Van Durme 2013 (AKBC) and Shwartz & Choi 2020 (COLING) work on reporting bias but do not condition on audience.
- **Common ground in dialogue.**
  - The AAAI paper "Modeling Expert Effects and Common Ground Using Questions Under Discussion" finds experts presuppose more.
  - Findings of EMNLP 2023, "Finding Common Ground", annotates common-ground updates in conversation.
  - The psycholinguistic root is Isaacs & Clark 1987, experts versus novices in reference (from memory).

Searched:

- children's books + commonsense;
- Simple Wikipedia + commonsense (nothing specific);
- expert vs layman;
- elaborative simplification;
- common-ground estimation from text;
- Gricean or RSA reporting bias with audience.

## E8. The LLM's three jobs

**(a) Amortized semantic parser into the KB vocabulary: SAME as a proposal.**

- Lenat & Marcus 2023, "Getting from Generative AI to Trustworthy AI: What LLMs might learn from Cyc" (arXiv 2308.04445), §3, "LLMs as generators of candidate assertions/rules to add to symbolic systems such as Cyc" (verified). They write that "LLMs can be asked to translate natural language sentences into CycL." They propose to "ask the LLM to translate each sentence it was trained on … into CycL", then "use Cyc to … turn it into 'real' CycL and contextualize it", asking "Can you already prove this? Can you already disprove this?"
- This is the "neurosymbolic Cyc" pipeline, with logical vetting as the judge. Cite it.
- Wong et al. 2023, "From Word Models to World Models" (arXiv 2306.12672), uses an LLM as translator into a probabilistic language of thought.
- Putting the relevant ontology slice in context is standard RAG-style practice (not separately cited).

**(b) Proposer, with exact code-length change as judge: CLOSE.**

- LILO (Grand et al. 2023, arXiv 2310.19791): the LLM proposes programs, Stitch compression selects library abstractions, and the LLM documents them. Compression is the judge, but the LLM does not propose the library edits.
- Ellis 2023 (NeurIPS, arXiv 2306.02797) uses "a large language model as a proposal distribution" with a Bayesian prior × likelihood re-weighting. This is proposer-not-judge, scored by posterior rather than by exact code length.
- LLMs4OL (Babaei Giglou et al., ISWC 2023) and OLLM (Lo et al., NeurIPS 2024) use the LLM *as* the ontology learner, which is the design E8 rejects.
- I found no work where an LLM proposes ontology edits that are accepted by exact MDL change.

**(c) LLM as one more provenance-tagged source: NOTHING FOUND as stated.**

- The 2026 data-fusion work (arXiv 2606.28062) uses the LLM as the truth-discovery *resolver*, not as a source.
- The LAMA line (Petroni et al. 2019) treats LMs as KBs without source-reliability modelling.

Searched:

- LLM + MDL schema edits;
- LLM proposal + Bayesian scoring;
- LLM in truth discovery;
- LLM + Cyc.

## E9. Vepštas / OpenCog structure learning and USP as MDL ontology induction

**Verdict: CLOSE.** Both have explicit or implicit MDL-style objectives. Neither is framed as MDL *ontology* induction, and I found no third-party work that reframes either one that way.

- **Vepštas & Goertzel 2014**, "Learning Language from a Large (Unannotated) Corpus" (arXiv 1401.3372; verified):
  - "It is the sum of the (logarithm of) the number of rules, and the (logarithmic) complexity that provides the proper metric: an 'Occam's razor' to discover the least-complex and smallest set of rules possible."
  - "a shorter description is desired."
  - The same passage moves from syntax to taxonomy. The absence of "the book barked at the squirrel" "suggests that perhaps books and dogs differ, and can be sub-classified as inanimate and animate objects." That is informal MDL with ontology-flavoured subclassing. Credit it.
- **Vepštas 2017**, "Sheaves: A Topological Approach to Big Data" (arXiv 1901.01341; verified). Merging similar words compresses the graph, and "the amount of compression applied can reveal different kinds of structures": heavy compression yields parts of speech, light compression yields semantic groupings (plate/dish).
- **Vepštas's diaries** (opencog/learn) cite Grünwald's MDL tutorial and Goldsmith 2001. Part nine discusses variational free energy as "(Kolmogorov) complexity of a model minus the accuracy". There is no formal MDL code over an ontology.
- **USP** (Poon & Domingos 2009; verified): "To encourage clustering and avoid overfitting, we impose an exponential prior with weight α on the number of parameters." OntoUSP (2010) adds priors on parameter slots and on cluster/ISA creation. These are BIC/MDL-like penalised likelihoods, presented as Markov-logic MAP.
- **Titov & Klementiev 2011** (ACL) use a nonparametric Bayesian USP, which is again an Occam prior but not framed as MDL.
- Starc & Mladenić, "Joint learning of ontology and semantic parser from text" (arXiv 1601.00901), uses grammar induction with no MDL.

Searched:

- Vepštas + MDL/compression;
- the opencog/learn repo code search for "description length", MDL and Kolmogorov;
- USP + MDL;
- unsupervised semantic parsing + MDL;
- Goertzel pattern/compression.

---

## What the essay can and cannot claim

**Credit, not claim:**

- unordered role-labelled tuples (Codd 1970, ORM, Fine 2000);
- bi-total class relations (Smith et al. 2005 `integral_part_of`, with their nucleus/cell example);
- wild quantity (Sommers/Englebretsen);
- images (NARS);
- the ∃R.C construction (DL);
- composed sources (ABLP quoting; MPQA nested sources);
- per-source FN/FP rates (LTM);
- children's texts as commonsense (Romero & Razniewski);
- LLM-to-CycL with Cyc vetting (Lenat & Marcus);
- Occam over link-grammar rules (Vepštas & Goertzel).

**Defensible as new (no match found):**

- bi-totality as the *only* class-level semantics, together with its forcing of image terms;
- relation = ⟨R,R,S,S⟩ and the Role fixed point;
- provenance as the sole, non-nesting judgment form, with Self as the shared-world terminus and promotion by code length ("consensus as compression");
- an audience-conditioned reporting policy inside an MDL code;
- the novice-minus-expert contrast as a common-ground measurement;
- exact code-length change as the acceptance test for LLM-proposed ontology edits;
- the LLM as a reliability-modelled source.

Overall, the novelty is the integration, more than any single primitive.
