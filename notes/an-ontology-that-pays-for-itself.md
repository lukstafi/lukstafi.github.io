---
title: "An Ontology That Pays for Itself"
subtitle: "Inducing a Cyc-like ontology by compression, with provenance as the only judgment"
author: "Łukasz Stafiniak and Claude (Opus 5.5)"
date: 2026-10-31
header-includes:
  - |
    <style>
    .katex-display { overflow-x: auto; overflow-y: hidden; padding: 0.3em 0; }
    .katex-display > .katex { width: max-content; min-width: 100%; }
    article table { display: block; max-width: 100%; overflow-x: auto; }
    </style>
---

Here is a corpus of three sentences: "Mary walked home", "Mary ran home", "Mary drove home". Link the words of each sentence by their dependencies, then cut every link in half. Each verb comes out with the same shape: a half-link reaching left to *Mary* and a half-link reaching right to *home*. In the notation of Link Grammar:

```
walked: Mary- & home+;
ran:    Mary- & home+;
drove:  Mary- & home+;
```

The three entries beg to be merged into one:

```
walked ran drove: Mary- & home+;
```

The example comes from Linas Vepštas's ["Sheaves: A Topological Approach to Big Data"](https://arxiv.org/abs/1901.01341), a long draft written for the OpenCog project's attempt to learn language without supervision. Vepštas notes that the merge looks like an application of the distributive law, and that the appearance deceives. The merge is safe only if the three verbs occur nowhere else. In a real corpus they do: people run companies and drive nails. Whether the merge is right depends on everything else the corpus says. Vepštas leaves the decision to whatever similarity measure the user supplies.

This essay leaves it to compression. A merge is right when it shortens the description of the data. Taken seriously, that criterion reaches well beyond word classes. It can decide which concepts, relations and rules an ontology contains, and the ontology it builds resembles Cyc, the decades-long effort to write down common sense by hand. We work out what such an ontology needs: a code in three parts, a model of who is speaking, a representation with two primitives, and a single form of judgment. Reasoning over it, with contradictions kept local and defaults that tolerate exceptions, is the subject of [*Presumed Normal*](https://lukstafi.github.io/notes/presumed-normal.html), which can be read before this essay or alongside it.

## Merges that pay

Vepštas's pipeline has three steps. First, parse a large corpus without supervision, linking the words of each sentence into the spanning tree of highest total mutual information, following [Deniz Yuret's](https://arxiv.org/abs/cmp-lg/9805009) "lexical attraction". Second, cut each parse into *seeds*: a word together with its half-links, which Link Grammar calls a *disjunct*. Third, collect all of a word's seeds into what Vepštas calls its *stalk*, and merge words whose stalks are similar. A stalk is a feature vector, and the merging is clustering.

Vepštas also has a test for structure that goes beyond word classes. Suppose clustering has found a class of names, {Adam, Mary}, and a class of actions, {walked, ran}. The corpus contains "Mary walked" and "Adam ran" but not "Mary ran". We still want to conclude that any name can combine with any action. The evidence is a pattern in the co-occurrence table: names occur often with actions, while names with non-actions ("Mary book") and non-names with actions ("the ran") are rare. The block where names meet actions is dense, and the cells around it are nearly empty. The same pattern will return one level up, among facts instead of words, as the basic unit of the ontology.

What the pipeline lacks is a score. [Hoifung Poon and Pedro Domingos's](https://aclanthology.org/D09-1001/) Unsupervised Semantic Parsing (USP) supplies one. USP starts from dependency parses made by a supervised parser, converts them into fragments of logical form, and clusters the fragments. A MERGE operation joins two clusters. A COMPOSE operation joins fragments into a larger unit, so that "is next to" can be clustered with "borders". USP writes its fragments as lambda terms, but the notation does no work. What matters is that every operation is scored by

$$
\log P(\text{corpus}\mid H)+\log P(H),
$$

and the search keeps an operation only when the score rises (by more than 10, in their implementation). The score is minus a *two-part code length*: the bits needed to describe the hypothesis $H$, plus the bits needed to describe the corpus once $H$ is known. USP's weights are log relative frequencies, computed in closed form from counts, so a merge changes the score only through the clusters it touches. Its prior is exponential in the number of parameters. "X and Y" usually names two different things, so a second prior discourages putting the two halves of a conjunction into one cluster, which keeps antonyms apart. [OntoUSP](https://aclanthology.org/P10-1031/) adds IS-A and IS-PART hierarchies over the clusters.

Scoring of this kind scales. [Brown clustering](https://aclanthology.org/J92-4003/) is the same idea with the simplest possible seeds, a word and its neighbours. It merges word classes greedily to maximize the likelihood of a class-bigram model, which comes to the same thing as maximizing the mutual information between adjacent classes. [Jakob Uszkoreit and Thorsten Brants](https://aclanthology.org/P08-1086/) ran a distributed exchange algorithm for a related class model on up to 31 billion tokens. The locality of the score is what lets the work be split across machines.

Two details keep the accounting honest. Coding each sentence with its single best parse is still a valid code. The encoder sends the parse and then the words given the parse, which costs $-\log P(x,t^*)$ bits, and the decoder recovers the sentence without needing to know that the parse was the best one. Since $P(x,t^*)$ is one term of the sum $P(x)$ over all parses, this code is longer than the best the grammar allows, by $-\log P(t^*\mid x)$: the bits spent naming a parse the decoder never needed. Hard parses are therefore allowed, at a cost that stays small wherever the grammar is nearly unambiguous. And the likelihood term alone never asks for merging, since finer classes always fit the data better. Brown clustering sidesteps the question by fixing the number of classes in advance. A two-part code answers it: the prior is what pays for merging. Turning its weight up should yield coarse classes, the parts of speech. Turning it down should yield synonym sets, where *plate* goes with *dish* but not with *cup*. Vepštas observed the same thing informally: "the amount of compression applied can reveal different kinds of structures". [Fernando Pereira, Naftali Tishby and Lillian Lee](https://aclanthology.org/P93-1024/) obtained such a hierarchy of word classes in 1993 by annealing a temperature. Behind all of this stand [Andreas Stolcke and Stephen Omohundro's](https://doi.org/10.1007/3-540-58473-0_141) Bayesian model merging, Peter Grünwald's and Carl de Marcken's MDL grammar induction, and [Gerard Wolff's](https://doi.org/10.3390/info4030283) long program of learning as compression.

Vepštas was moving in this direction himself. [Vepštas and Ben Goertzel](https://arxiv.org/abs/1401.3372) proposed in 2014 that "the sum of the (logarithm of) the number of rules, and the (logarithmic) complexity" should serve as "an 'Occam's razor'" for the learned grammar. They also took a step toward ontology: that books do not bark "suggests that perhaps books and dogs differ, and can be sub-classified as inanimate and animate objects". The pipeline's record is weak, though. The OpenCog language-learning team's [published evaluations](https://doi.org/10.1007/978-3-030-27005-6_11) scored learned grammars against the output of the hand-written Link Grammar parser, not against human treebanks. They compared with no standard baselines, and grammars learned from unsupervised parses reached an F1 of about 0.5. Vepštas's own 2022 experiments report no evaluation of grammar quality. We take his representation and his diagnosis, not his results.

## Text is not the world

Grammar induction compresses talk. An ontology has to compress what the talk is about. These come apart: "things that take a determiner" is a fine class for a grammar and a poor concept for an ontology, while "physical object" is the reverse. So the code needs three parts:

$$
L(\text{ontology})+L(\text{facts}\mid\text{ontology})+L(\text{text}\mid\text{facts},\ \text{lexicon}).
$$

The last part is the *realization channel*: syntax, word choice, paraphrase. Grammar induction lives there. The middle part is where the ontology earns its keep, because a concept is worth having when it shortens the description of the facts. The first part keeps the ontology from growing a concept for every fact.

The realization channel has to be kept weak in the right way. If it were a large language model, it would already know that dogs have four legs, text about dogs would cost few bits whatever the facts said, and the ontology would get no credit for common sense. Variational autoencoders fail the same way when a powerful decoder learns to ignore the latent code. World knowledge goes to whichever component can hold it most cheaply. So the channel should know grammar, word choice and paraphrase, and nothing about the world, and its own description length belongs in the code.

*Mammal* is worth having because it lets a thousand facts about dogs, whales and bats be stated once. The code rewards several kinds of structure in this way, most of them in the middle term and two in the realization channel:

| Element of the ontology | Why it shortens the code | Term that pays |
|:---|:---|:---|
| A concept | its members share many facts | facts |
| A place in the IS-A hierarchy | a property is stated once at the parent, not at every child | facts |
| A typed argument slot | arguments become predictable from the type | facts |
| Disjointness | combinations that never occur need no code | facts |
| A default with exceptions | a rule plus a list of its exceptions beats listing every case | facts |
| A context | a mixture of codes, one per subcorpus, beats a single global code | facts |
| A paraphrase equivalence | several forms map to one predicate, as *is next to* and *borders* do in USP | text |
| A word sense | "fly" the insect and "fly" the verb each become predictable from their contexts | text |

Two rows deserve a note. A default survives while the rule plus its list of exceptions is cheaper than the alternatives, such as listing every case or splitting the class. Whether a default exists at all is thus a question for the code. Whether it applies to a given dog is a separate question, for inference, and *Presumed Normal* describes logics that presume normality case by case unless the premises rule it out. Contexts are Cyc's *microtheories*, and here they are induced, not curated.

The middle term has precedents. [Hang Li and Naoki Abe](https://aclanthology.org/J98-2002.pdf) used MDL in 1998 to choose, for each argument slot of a verb, the level of a thesaurus at which its arguments should be typed. That is the earliest case we know of letting code length choose between typing the object of *break* as, say, *Bone* or *BodyPart*. [Yarden Katz, Charles Kemp and colleagues](https://cocolab.stanford.edu/papers/KatzEtAl2008-Cogsci.pdf) model theories as compressive: they express data "as samples from the logical consequences of a theory's underlying laws plus a small number of core facts". The [Infinite Relational Model](https://cdn.aaai.org/AAAI/2006/AAAI06-061.pdf) of Kemp, Joshua Tenenbaum and colleagues clusters the entities of a relational table, and can cluster the relations too, looking for blocks that are uniformly dense or uniformly empty. That is Vepštas's block test, both halves of it, with a principled prior. [KGist](https://arxiv.org/abs/2003.10412) selects the rules that best compress a knowledge graph and reads rule violations as errors, exceptions or missing facts. And [Kemp and Tenenbaum](https://doi.org/10.1073/pnas.0802631105) score which *kind* of structure suits a domain (a tree, a chain, a ring, a grid), a reminder that not everything is a taxonomy.

## Who says so

Cyc began from an observation: the knowledge an intelligent system most needs is what nobody writes down. Compression of text runs straight into it. [Jonathan Gordon and Benjamin Van Durme](https://doi.org/10.1145/2509558.2509563) call the effect *reporting bias*: "murder is mentioned in text many more times than more quotidian actions like hugging or constant activities like breathing." People seldom write that they have two hands. A model of the corpus learns what gets said, and what gets said is a poor sample of what is true.

Large language models suggest a way around this. Do not model the probability of the corpus. Model the probability of each text given where it came from. Pretraining learns something about a document's origin implicitly: on [one account](https://arxiv.org/abs/2111.02080), in-context learning is inference about a latent concept that generated the document. Making the source explicit helps. [MeCo](https://arxiv.org/abs/2501.01956) prepends only the domain name of each document's URL during most of pretraining, and a 1.6-billion-parameter model matches its baseline with a third less data. In MeCo's most telling result, hashed URLs work as well as real ones. The gain comes from knowing *which* documents share a source, without knowing anything about the source.

For an ontology, conditioning on provenance splits the description into a shared world and a model of each source. A source writes about some world: the actual one, a novel's, a jurisdiction's. (The section on judgment treats these worlds as sources in their own right.) It also has a *reporting policy*: the probability that it mentions a fact, given the fact, the source and the audience it writes for. The text is then coded given the facts the source chose to mention.

Audience is where this pays most. Writers follow Grice and omit what their readers already know. A children's book about dogs says that a dog has four legs. A veterinary paper never does, because its readers know. So the facts stated for novices and omitted for experts on the same topic are an estimate of the *common ground*, the very knowledge Cyc set out to write by hand. The ingredients exist. [Julien Romero and Simon Razniewski](https://arxiv.org/abs/2210.04530) found that children's texts "contain much more, and more typical commonsense assertions". [Text simplification adds content of this kind](https://aclanthology.org/2021.findings-acl.455) when it rewrites for novices. And the consumer and professional versions of the Merck Manuals, which [Yixin Cao and colleagues](https://arxiv.org/abs/2005.00701) assembled into a corpus, cover the same topics for the two audiences. We have not found the contrast itself used as a measurement.

Conditioning on provenance has three further consequences.

**Consensus as compression.** A claim made by one source is cheapest to code as that source's belief. Once enough independent sources state it, coding it once in the shared world becomes cheaper than repeating it per source. The objective decides when a claim becomes a fact.

**Reliability in the same code.** Truth discovery has long modelled sources this way: [A. P. Dawid and A. M. Skene](https://doi.org/10.2307/2346806) estimated observers' error rates, and the [Latent Truth Model](https://arxiv.org/abs/1203.0058) gives each source a rate of false claims and a rate of omissions. The omission rate is the reporting policy without the audience. Here reliability enters the same code as the ontology, and an unreliable source pays for its errors in bits.

**Copying.** Mirrors and syndication manufacture consensus. Shared errors give copying away: "If two data sources provide a large number of common values and many of these values are rarely provided by other sources (e.g., particular false values), it is very likely that one copies from the other," as [Xin Luna Dong and colleagues](https://doi.org/10.14778/1687627.1687690) put it. Detecting copies is a prerequisite for counting sources as independent.

Two limits should be stated plainly. Compression rewards mutual consistency, not truth: a [recent study of language-model training](https://arxiv.org/abs/2603.11749) argues that gradient descent "favors the most compressible answer cluster, not truth per se". A coherent myth told by many independent sources will be promoted to the shared world, and only sources outside text, such as measurement and action, can break it. And a fact that no source states remains out of reach. Conditioning on provenance makes the reporting channel identifiable, but it does not create evidence.

## Two primitives

Now the representation. It has two primitives that form terms. The first is IS-A, which has a direction. The second is a tuple of four concepts,

$$
\langle A,R,S,B\rangle\equiv\langle B,S,R,A\rangle,
$$

read "$A$ plays role $R$ toward $B$, which plays role $S$". So $\langle\textit{John},\textit{parent},\textit{child},\textit{Mary}\rangle$ and $\langle\textit{Mary},\textit{child},\textit{parent},\textit{John}\rangle$ are the same fact. The tuple is Vepštas's link with both ends labelled: two seeds joined by a pair of typed half-links. It is also the shape that USP's argument slots and the dense blocks of the previous sections produce.

Several conventions disappear. A relation has no argument order, so no relation needs a separately named converse. Cyc's binary predicates order their arguments, and relating a predicate to its converse takes extra vocabulary. A symmetric relation is simply one whose roles coincide: $\langle A,\textit{sibling},\textit{sibling},B\rangle$. A subrelation comes from a subrole: since *mother* IS-A *parent*, every motherhood tuple IS-A a parenthood tuple, for a reason given below.

Roles and relations are concepts too. A relation is identified with its pair of roles, written as the tuple $\langle R,R,S,S\rangle$, and every instance of the relation stands under it:

$$
\langle A,R,S,B\rangle\ \text{IS-A}\ \langle R,R,S,S\rangle.
$$

That gives domains and ranges for free, as ordinary IS-A: whatever plays the role $R$ IS-A $R$. A relation is a concept, so it can fill a role in another tuple. So can a single link, treated, in the manner of Donald Davidson, as a state that can be talked about. The design treats every link as something that can play a role, so the most general relation falls under the most general role:

$$
\langle\textit{Role},\textit{Role},\textit{Role},\textit{Role}\rangle\ \text{IS-A}\ \textit{Role}.
$$

Every relation then falls under *Role*, and reification is uniform.

**Events.** Every tuple has exactly two fillers, so a fact with more participants is reified as an event, again in Davidson's style. "John gave Mary a book" becomes $\langle g,\textit{Giving},\textit{giver},\textit{John}\rangle$, $\langle g,\textit{Giving},\textit{recipient},\textit{Mary}\rangle$ and $\langle g,\textit{Giving},\textit{gift},b\rangle$, with the event's class serving as the event's role.

**Fine-grained roles.** Since a relation *is* its pair of roles, two relations with the same roles would collapse into one. Spatial parthood, temporal parthood and membership need distinct roles, organized by IS-A under a general *part*. Role names need sense splitting just as words do: the *child* of a parent is not the *child* of an age group.

**Tuples as terms.** A tuple term denotes a type of link. Its extension is the set of all

$$
\{(r,a),(s,b)\}\qquad r\in R,\ a\in A,\ s\in S,\ b\in B:
$$

unordered pairs of ordered pairs, each ordered pair joining a role to a filler. The outer pair is unordered, so $\langle A,R,S,B\rangle$ and $\langle B,S,R,A\rangle$ denote the same set. The inner pairs are ordered, so a role never trades places with its filler. Roles are quantified like fillers, and that is what makes a subrole give a subrelation: since *mother* IS-A *parent*, the motherhood links form part of the parenthood links. The extension contains every combination of its components, linked or not, so it presupposes no prior universe of relationships. IS-A between tuple terms is inclusion of these sets, and it behaves like IS-A anywhere. It is transitive, and whatever holds of every link of a type holds of every link of its subtypes. In this sense every instance tuple IS-A its relation, and every tuple IS-A $\langle\textit{Role},\textit{Role},\textit{Role},\textit{Role}\rangle$. A term can occur without being asserted, as the content of someone's claim does. Assertion therefore needs its own form, which the next section supplies.

**Both directions.** Asserting a tuple claims something else: that the actual links of its type cover all of $A$ and all of $B$. When $A$ and $B$ are classes, every $A$ stands in the relation to some $B$, *and* every $B$ stands in it to some $A$. So $\langle\textit{Dog},\textit{whole},\textit{part},\textit{DogLeg}\rangle$ holds, and $\langle\textit{Dog},\textit{whole},\textit{part},\textit{Leg}\rangle$ does not, because tables have legs too. The construction is known. [Barry Smith and colleagues](https://pmc.ncbi.nlm.nih.gov/articles/PMC1175958/) define `integral_part_of` as part-of in one direction together with has-part in the other, and their example shows the asymmetry it repairs: "cell nucleus part_of cell, but not cell has_part cell nucleus". They offer it beside the one-directional relations. Here this *two-way reading* is the only reading an asserted class-level tuple has. The second direction is not always news. *DogLeg* is defined as the legs of dogs, so every dog leg belongs to some dog by definition, and the tuple adds only that every dog has a leg. The second direction says something when $B$ has an identity of its own: $\langle\textit{Car},\textit{whole},\textit{part},\textit{Engine}\rangle$ claims, beyond every car having an engine, that every engine sits in some car, and boat engines refute it. The ontology fills up with fine-grained classes like *DogLeg*, and the induction is what supplies them: a block of facts that is dense in both directions is approximately a true tuple of this kind.

Coverage is a property of the links taken together, not of any one link. Asserting a class-level tuple is therefore a *collective* claim. Collective claims do not pass down IS-A. $\langle\textit{Puppy},\textit{whole},\textit{part},\textit{DogLeg}\rangle$ is a subtype of a true tuple, and it is false, because most dog legs belong to grown dogs. The claim does split into two claims that pass down. Write "whole of some *DogLeg*" for the things that stand as whole to some dog leg. Pei Wang's *Non-Axiomatic Logic* (2013) calls such a term an *image*, and description logics write it $\exists\textit{hasPart}.\textit{DogLeg}$. Then

$$
\langle\textit{Dog},\textit{whole},\textit{part},\textit{DogLeg}\rangle\iff\textit{Dog}\ \text{IS-A}\ (\text{whole of some }\textit{DogLeg})\ \land\ \textit{DogLeg}\ \text{IS-A}\ (\text{part of some }\textit{Dog}).
$$

The "every" comes from IS-A and the "some" from the image, once in each direction. A one-directional fact is one of the two conjuncts on its own: *CellNucleus* IS-A (part of some *Cell*).

**Inheritance runs through images.** The two conjuncts are ordinary IS-A statements and are inherited as such. *Puppy* IS-A *Dog* gives *Puppy* IS-A (whole of some *DogLeg*): every puppy has a dog leg. The other conjunct is what fails, since *DogLeg* IS-A (part of some *Puppy*) is false. The true tuple about puppies is the matched one, $\langle\textit{Puppy},\textit{whole},\textit{part},\textit{PuppyLeg}\rangle$, where *PuppyLeg* is the dog legs that are part of some puppy: the intersection of *DogLeg* with an image, $\textit{DogLeg}\sqcap\exists\textit{partOf}.\textit{Puppy}$ in description logic. Generalizing a role is always safe. Roles stand only under "some" in both conjuncts, so images only grow: $\langle A,\textit{mother},\textit{child},B\rangle$ implies $\langle A,\textit{parent},\textit{child},B\rangle$. Changing a filler is not safe in general, because each filler stands under "every" in one conjunct and under "some" in the other. The step from a tuple to its relation is safe for its own reason: $R$ and $S$ are exactly the things playing those roles, so $\langle R,R,S,S\rangle$ is true by definition.

**Singular terms.** Take *John* and *Mary* as terms with one member each. "Every member of *John* is a parent of some member of *Mary*, and every member of *Mary* is a child of some member of *John*" says no more than that John is Mary's parent. In the term logic of Fred Sommers and George Englebretsen, singular terms have *wild quantity*: for them, "every" and "some" agree. This is why the ontology needs no primitive distinction between individuals and classes. A tuple over individuals is a plain fact, read by the same semantics as a tuple over classes. Being singular, having exactly one member, can still be defined where counting needs it.

**No individuals, no classes.** Dropping the distinction is in the spirit of term logic, and we accept that contradictions may arise. The danger is collective predication. "Dogs are mammals" says something of every dog. "Humans are a species" says something of the kind. If both were IS-A, John would be a species. So IS-A is *distributive*: it says only what holds of every member. The same rule keeps asserted class-level tuples, which are collective claims about links, from passing down. A collective fact is about a kind, and the kind gets a singular term of its own, distinct from the class of its members: $\langle\textit{HomoSapiens},\textit{taxon},\textit{rank},\textit{SpeciesRank}\rangle$, together with $\langle\textit{Human},\textit{member},\textit{taxon},\textit{HomoSapiens}\rangle$. Membership in a kind is a tuple, not an IS-A: every human is a member of the taxon, and the taxon has human members, but nothing said of the kind passes down to its members. Wikidata likewise records taxonomic rank as a property of the taxon.

**A top concept without paradox.** *Role* covers everything that takes part in a relation, including relations and their links, so it is the top concept, and it falls under itself. That alone is harmless: Quine's New Foundations has a universal set. Paradoxes need a diagonal construction, a term for "the concepts that do not fall under themselves". The term language cannot form one. Images are taken over tuples, and IS-A is not a tuple, so no image can collect the concepts that are not IS-A themselves.

**Roles that lapse.** Some roles hold only for a while. OntoClean, the method of Nicola Guarino and Christopher Welty, calls such roles *anti-rigid*: John can stop being an employee without ceasing to be John. One rule handles this. An IS-A derived from a tuple is asserted where the tuple is asserted. If the employment is an event with its own time and context, then *John* IS-A *Employee* holds in that context, not in the timeless shared world.

**Counting and exceptions.** "Four legs" is beyond the two-way reading. It needs fine-grained roles, such as *front-left-leg*, each marked as taking exactly one filler and as distinct from the others. One three-legged dog then breaks a strict "every" on one of those roles. A class-level tuple can carry a typicality strength, stated in a further tuple about the tuple, and the default inference of *Presumed Normal* does the rest.

None of these primitives is new on its own. Unordered tuples with named roles go back to [Edgar Codd's](https://www.seas.upenn.edu/~zives/03f/cis550/codd.pdf) relational model and are central to Object-Role Modeling. [Kit Fine](https://sites.pitt.edu/~rbrandom/Courses/2024%20Philosophy%20of%20Language/Texts/Fine%20Neutral%20Relations.pdf) argued that relations have no intrinsic argument order. John Sowa's conceptual graphs, Leśniewski's Ontology and OntoClean's analysis of roles each cover part of the ground. The closest system overall is NARS, the Non-Axiomatic Reasoning System that Wang built on his logic, in which inheritance is the only basic relation, instance is derived from inheritance, a relation is a product term inheriting from a relation term, and images are compound terms. NARS differs in its ordered products and its evidential truth values. What the design here adds is the combination: the two-way reading as the only class-level semantics, the relation as a tuple of its own roles, and the provenance judgment of the next section.

## One judgment

Tuples and IS-A statements are terms, and nothing inside a term asserts anything. The only form of judgment is

$$
\mathrm{Prov}(T,P):\quad\text{source }P\text{ asserts }T.
$$

$\mathrm{Prov}$ is never itself a term and never occurs inside one, so there is no unasserted $\mathrm{Prov}$ to account for. Everything else follows from asking who makes a $\mathrm{Prov}$ judgment.

**The regress stops at the system.** $\mathrm{Prov}(T,P)$ is the system's own judgment that $P$ asserted $T$, made from a parse that may be wrong and graded by the parser's confidence. The system is itself a source, *Self*. The shared world of the previous sections is $\mathrm{Prov}(T,\textit{Self})$. A fact inferred by the system also has *Self* as its source, with the derivation recorded as its provenance. Ingestion and inference use one format.

**Flat judgments, composed sources.** Reported speech seems to need nesting: the *Times* reports that Smith claims $T$. Nesting would put a $\mathrm{Prov}$ inside a term. The nesting goes into the source instead, $\mathrm{Prov}(T,\textit{Smith-via-Times})$. [Martín Abadi, Michael Burrows, Butler Lampson and Gordon Plotkin's](https://www.bwlampson.site/44-CalculusAccessControl/44-CalculusAccessControlOCR.htm) calculus for access control has exactly this quoting principal, and the [MPQA](https://mpqa.cs.pitt.edu/) annotations of opinion record such chains of sources. Explicit chains give copy detection its easy cases. Undeclared copying still has to be inferred from shared errors. A source can also speak for another. If an article stands to the *Times* as publication to publisher, its claims may count as the *Times*'s claims, and whether that holds for an opinion piece is something to model, not assume.

**Contexts are idealized sources.** A context records where a claim holds, not who makes it: a novel's canon, a country's law, a hypothetical. It can still be treated as a source. $\mathrm{Prov}(T,\textit{HarryPotterCanon})$ places $T$ in a fiction, and the system learns how real sources map onto such contexts. A novel's sentences are coded against its canon, not against *Self*. The derived IS-A of the previous section, *John* IS-A *Employee*, is likewise asserted with the employment's context as its source. Only idealized sources and *Self* are closed under inference. Smith does not believe every consequence of what Smith says, so nothing is derived inside Smith's record. Claims from different sources are combined only in *Self*, after *Self* has adopted them.

**Claims become events.** Keeping $\mathrm{Prov}$ out of the term language has a cost: the ontology could not speak about claims, and a Cyc must be able to say that a claim was retracted, disputed or debunked. Davidsonian events supply the fix. Each judgment $\mathrm{Prov}(T,P)$ licenses *Self* to assert that a claiming event $c$ occurred: $\mathrm{Prov}(\langle c,\textit{Claiming},\textit{content},T\rangle,\textit{Self})$ and $\mathrm{Prov}(\langle c,\textit{Claiming},\textit{claimant},P\rangle,\textit{Self})$. The event is a term like any other, and it can carry a time, which retraction needs.

**Denials and conditionals.** Sources deny, ask and suppose. A denial is recorded as the assertion of a negation term, and a question asserts nothing. A conditional needs an implication term, so that a source saying "if $T_1$ then $T_2$" asserts neither $T_1$ nor $T_2$. Negation and implication are connectives over terms, beside the two primitives.

The objective can now be written out in full. The data is the texts with their metadata: URL, venue, date, intended audience. The $\mathrm{Prov}$ judgments are how the system explains the texts, and the code pays for every part of the explanation:

$$
L(\text{ontology})+L(\text{lexicon})+L(\text{sources})+L(\text{world}\mid\text{ontology})+\sum_d\Bigl[L(\mathrm{Prov}_d\mid\text{world},\text{source}_d)+L(\text{text}_d\mid\mathrm{Prov}_d,\text{lexicon})\Bigr].
$$

Here $d$ ranges over documents, $\mathrm{Prov}_d$ is what document $d$ is judged to assert, and the source models hold the contexts and reporting policies. Two sources that disagree do not make the knowledge base inconsistent. They are two records, and the code decides whether to adopt one of them, both in different contexts, or neither. Contradictions can still arise inside *Self*, and there the adaptive logics of *Presumed Normal* keep them from spreading.

The relatives of this design are well known. [John McCarthy's](https://web-archive.southampton.ac.uk/cogprints.org/418/) $\mathit{ist}(c,p)$ says that $p$ is true in context $c$, and Cyc puts every assertion in a microtheory. McCarthy's contexts nest without end and have no outermost context, which is the opposite choice from a flat $\mathrm{Prov}$ with *Self* as the last judge. [Named graphs](https://doi.org/10.1145/1060745.1060835) and [nanopublications](https://doi.org/10.3233/ISU-2010-0613) attach provenance to sets of statements on the Semantic Web, and NARS tracks the evidence behind each judgment.

## What the language model is for

[Douglas Lenat and Gary Marcus](https://arxiv.org/abs/2308.04445) proposed a neurosymbolic Cyc in 2023: ask a language model to translate sentences into Cyc's language, let Cyc repair and contextualize the result, and ask "Can you already prove this? Can you already disprove this?" Their judge is proof. Ours is code length. In the design here, a language model does three jobs, and judging is not among them.

**It parses into the current vocabulary.** The code needs, for each document, what it asserts in the ontology's terms: its judgments $\mathrm{Prov}_d$. A model given the sentence and the relevant slice of the ontology in its prompt can produce them. The slice is the restriction of the ontology to what the sentence needs, as a parser restricts a grammar to the entries for one sentence's words. The ontology changes with every accepted merge or split. A parser that reads the ontology from its prompt needs no retraining for each edit.

> **Keeping the parser honest.** For the parser's output to count as a code length, the model must define a proper probability distribution over valid parses. Each parse needs one canonical output order. Otherwise several token sequences encode the same parse, its probability is underestimated, and the code grows longer. Decoding must be constrained to parses the ontology allows, with the masked probabilities renormalized. A base model is preferable to an instruction-tuned one, whose probabilities are poorly calibrated. Training can alternate two phases. In the first, sample facts and texts from the current model, across many perturbed versions of the ontology, and train the parser on these pairs. In the second, train the parser toward the posterior on real text, for instance with the GFlowNet objectives that [Edward Hu and colleagues](https://arxiv.org/abs/2310.04363) used to fine-tune language models for intractable inference. A parser that only approximates the posterior still yields a valid code through *bits-back coding*, in which the encoder chooses a parse using bits that the decoder recovers once it has the text. Those recovered bits correspond to the overhead that the best-parse code of "Merges that pay" spent naming its parse. The cost of the approximation is then measured in bits.

**It proposes edits.** Shown a batch of parsed sentences with the concepts they use, a model can propose merges, splits, new roles, rules and context boundaries. Each proposal is checked by re-scoring the data it touches, so a high rate of bad proposals costs compute but not quality. The division of labour has a precedent in program search. In [AlphaEvolve](https://arxiv.org/html/2506.13131v1), a language model proposes edits to programs and automated evaluators decide which survive. [*What Should a Program Inherit?*](https://lukstafi.github.io/notes/what-should-a-program-inherit.html#alphaevolve-variation-selection-and-what-survives) discusses the arrangement as a cooperation of "heuristic exploration and rigorous acceptance". Library learning supplies the case where acceptance is compression. [Stitch](https://arxiv.org/abs/2211.16605) and [babble](https://lukstafi.github.io/notes/what-should-a-program-inherit.html#babble-when-a-common-pattern-becomes-a-useful-function), which that essay also discusses, add an abstraction to a library when it shortens the corpus of programs. In [LILO](https://arxiv.org/abs/2310.19791), a language model writes the programs, Stitch extracts the abstractions, and the model names and documents them. COMPOSE, the operation that forms larger units, is where proposals help most, because its candidates multiply combinatorially.

**It is one more source.** "A language model asked to explain dogs to a child" is a provenance like any other, with its own reliability and reporting policy. Its answers draw on implicatures that no single text states, which makes it valuable for the common ground. It also confabulates, and its reliability is estimated against the other sources in the same code. It gets no special trust.

One risk is worth naming. A model pretrained on human language will propose the structures that human linguistics and folk taxonomy already contain. The code length cannot make a bad ontology score well, but the proposer decides what gets considered, so the search's local optima will lean toward the familiar. A control with a proposer that has no linguistic pretraining, or a domain without a human prior, such as biochemical pathways, would show how much.

## What compression cannot do

The induced ontology will not be the best compressor of its corpus. Compressors that work by inducing grammars already lose to statistical ones on text. [Craig Nevill-Manning, Ian Witten and David Maulsby's](https://doi.org/10.1109/DCC.1994.305932) grammar-inducing compressor, the precursor of Sequitur, did 8 to 23 percent worse than the statistical compressor PPMC on the Calgary corpus, depending on how the grammar was transmitted. Large language models used as compressors [beat general-purpose compressors](https://arxiv.org/abs/2309.10668) on text by wide margins, at least when their own size is not counted. Code length here is the criterion for choosing structure, not a contest that the structure wins. By the measure that leaves model size out, the neural model is the better compressor, and it gives no ontology at all.

The search is the bottleneck, not the scoring. USP ran on about two thousand biomedical abstracts, and Brown clustering scales because its seeds are the simplest possible. Proposals from a language model may make the search over merges, splits and compositions feasible at scale, but nothing yet shows that they do. The criterion is also unlikely to single out one ontology. Many ontologies will come within a few bits of each other, differing in how roles are named and where defaults sit, so compression picks a family of near-ties. Nothing here has been implemented, so there are no results. An implementation should be evaluated against WordNet, Wikidata and OpenCyc, after aligning its concepts with theirs, and never trained toward them. The one thing compression offers is concepts justified by the data, not by curators, and training toward a curated ontology would give that away.

Return to Mary. Whether *walked*, *ran* and *drove* belong together is settled by the bits the merge saves across everything else the corpus says about walking, running and driving. Whether *Mammal* belongs in the ontology is settled the same way, one level up. And who says that Mary drove home, to whom, and in which world, is recorded by the one form of judgment the system makes.
