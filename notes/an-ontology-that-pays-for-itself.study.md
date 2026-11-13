---
title: "Study notes: An Ontology That Pays for Itself"
essay: an-ontology-that-pays-for-itself
track: learners-and-uncertainty
reviewed-against: "e99f820"
requires:
  - {at: presumed-normal, for: "reasoning over the ontology, with defaults that tolerate exceptions and contradictions kept local", strength: helpful}
  - {at: the-bookmaker-is-a-learner#the-bookmaker-is-a-learner, for: "bandits and exploration, the terms in which the essay states the risk of a proposer with a prior", strength: helpful}
  - {at: what-should-a-program-inherit#alphaevolve-variation-selection-and-what-survives, for: "search in which a language model proposes edits and an automated evaluator decides which survive", strength: helpful}
  - {at: what-should-a-program-inherit#babble-when-a-common-pattern-becomes-a-useful-function, for: "library learning, the case where acceptance is compression", strength: helpful}
introduces:
  - {term: seed and stalk, at: merges-that-pay, related: ["role tuple"]}
  - {term: two-part code, at: merges-that-pay, related: ["library learning"]}
  - {term: best-parse code, at: merges-that-pay, gloss: "coding a sentence by its single best parse and then the words given the parse, at a cost of $-\\log P(t^*\\mid x)$ bits above the best the grammar allows"}
  - {term: three-part code and realization channel, at: text-is-not-the-world, gloss: "ontology, facts given the ontology, and text given the facts and a lexicon; the last part is the channel, which should know syntax, word choice and paraphrase and nothing about the world"}
  - {term: reporting policy, at: who-says-so, gloss: "the probability that a source mentions a fact, given the fact, the source and the audience it writes for", related: ["provenance judgment"]}
  - {term: common ground, at: who-says-so}
  - {term: role tuple, at: two-primitives, gloss: "$\\langle A,R,S,B\\rangle\\equiv\\langle B,S,R,A\\rangle$: $A$ plays role $R$ toward $B$, which plays role $S$"}
  - {term: two-way reading, at: two-primitives, gloss: "an asserted class-level tuple claims that every $A$ stands in the relation to some $B$ and every $B$ stands in it to some $A$"}
  - {term: image, at: two-primitives}
  - {term: distributive IS-A, at: two-primitives, gloss: "IS-A says only what holds of every member, so a fact about a kind needs a singular term for the kind"}
  - {term: provenance judgment, at: one-judgment, gloss: "$\\mathrm{Prov}(T,P)$, source $P$ asserts $T$: the only form of judgment, never itself a term", related: ["table of adversaries"]}
  - {term: Self and idealized sources, at: one-judgment, gloss: "the system as the last judge, and contexts such as a novel's canon treated as sources; only these are closed under inference", related: ["gaps and gluts"]}
uses:
  - {term: adaptive logic, from: presumed-normal}
  - {term: bandit and exploration, from: the-bookmaker-is-a-learner}
  - {term: library learning, from: what-should-a-program-inherit}
---

The answers state what the essay proposes. Nothing in it has been implemented, and the last question asks where it says so.

### The merge that begs to be made {kind=explain}

"Mary walked home", "Mary ran home", "Mary drove home": cutting the dependency links in half gives each verb the same entry, `Mary- & home+`. Why is merging the three entries not an application of the distributive law? What decides the merge in Vepštas's draft, and what decides it in the essay?

::: answer
The merge is safe only if the three verbs occur nowhere else. In a real corpus they do: people run companies and drive nails. Whether the merge is right depends on everything else the corpus says. Vepštas leaves the decision to whatever similarity measure the user supplies. The essay leaves it to compression: a merge is right when it shortens the description of the data.
:::

### What pays for merging {kind=explain at=merges-that-pay}

Unsupervised Semantic Parsing keeps an operation only when $\log P(\text{corpus}\mid H)+\log P(H)$ rises. Read the score as a code length. Why does the likelihood term alone never ask for a merge? What should turning the weight of the prior up or down yield?

::: answer
The score is minus a two-part code length: the bits needed to describe the hypothesis $H$, plus the bits needed to describe the corpus once $H$ is known. Finer classes always fit the data better, so the likelihood term alone never asks for merging. Brown clustering sidesteps the question by fixing the number of classes in advance. In a two-part code the prior is what pays for merging. Turning its weight up should yield coarse classes, the parts of speech. Turning it down should yield synonym sets, where *plate* goes with *dish* but not with *cup*.
:::

### The cost of a single parse {kind=compute at=merges-that-pay}

A grammar gives a sentence $x$ two parses, with $P(x,t_1)=0.03$ and $P(x,t_2)=0.01$. How many bits does the best-parse code spend on $x$? How many would the best code the grammar allows spend? Write the difference as a probability and say what it pays for. Why is the best-parse code still a valid code?

::: answer
The best-parse code spends $-\log_2P(x,t_1)=-\log_20.03\approx5.06$ bits. The best the grammar allows spends $-\log_2P(x)=-\log_20.04\approx4.64$ bits. The difference is $-\log_2P(t_1\mid x)=-\log_20.75\approx0.42$ bits: the bits spent naming a parse the decoder never needed. The code is valid because the encoder sends the parse and then the words given the parse, and the decoder recovers the sentence without needing to know that the parse was the best one. The overhead stays small wherever the grammar is nearly unambiguous.
:::

### Three parts of the code {kind=state at=text-is-not-the-world}

Grammar induction compresses talk. What must an ontology compress instead? Write the three-part code and say what each part does. Why must the last part be kept weak?

::: answer
An ontology has to compress what the talk is about. "Things that take a determiner" is a fine class for a grammar and a poor concept for an ontology, and "physical object" is the reverse. The code is

$$
L(\text{ontology})+L(\text{facts}\mid\text{ontology})+L(\text{text}\mid\text{facts},\ \text{lexicon}).
$$

The first part keeps the ontology from growing a concept for every fact. The middle part is where the ontology earns its keep: a concept is worth having when it shortens the description of the facts. The last part is the realization channel: syntax, word choice, paraphrase. If the channel were a large language model, it would already know that dogs have four legs, and text about dogs would cost few bits whatever the facts said. World knowledge goes to whichever component can hold it most cheaply, so the channel should know nothing about the world.
:::

### Which term pays {kind=recall at=text-is-not-the-world}

For each element say why it shortens the code and which term pays: a concept, a place in the IS-A hierarchy, a typed argument slot, a default with exceptions, a paraphrase equivalence, a word sense. For a default, which question does the code answer and which does it leave to inference?

::: answer
- A concept: its members share many facts. Facts.
- A place in the IS-A hierarchy: a property is stated once at the parent, not at every child. Facts.
- A typed argument slot: arguments become predictable from the type. Facts.
- A default with exceptions: a rule plus a list of its exceptions beats listing every case. Facts.
- A paraphrase equivalence: several forms map to one predicate. Text.
- A word sense: each sense becomes predictable from its contexts. Text.

The code decides whether a default exists at all: it survives while the rule plus its list of exceptions is cheaper than the alternatives, such as listing every case or splitting the class. Whether it applies to a given dog is a separate question, for inference.
:::

### The reporting policy and the audience {kind=explain at=who-says-so}

Why does compressing text miss the knowledge Cyc set out to write down? What does conditioning on provenance split the description into? How does a contrast between audiences estimate the common ground?

::: answer
The knowledge an intelligent system most needs is what nobody writes down: people seldom write that they have two hands. A model of the corpus learns what gets said, and what gets said is a poor sample of what is true. Conditioning on provenance splits the description into a shared world and a model of each source. A source has a reporting policy: the probability that it mentions a fact, given the fact, the source and the audience it writes for. Writers omit what their readers already know. A children's book about dogs says that a dog has four legs, and a veterinary paper never does. So the facts stated for novices and omitted for experts on the same topic are an estimate of the common ground.
:::

### Three consequences of provenance {kind=recall at=who-says-so}

Conditioning on provenance has three further consequences: for consensus, for reliability and for copying. State each.

::: answer
- *Consensus as compression.* A claim made by one source is cheapest to code as that source's belief. Once enough independent sources state it, coding it once in the shared world becomes cheaper than repeating it per source. The objective decides when a claim becomes a fact.
- *Reliability in the same code.* Each source has a rate of false claims and a rate of omissions, and an unreliable source pays for its errors in bits.
- *Copying.* Mirrors and syndication manufacture consensus. Shared errors give copying away, and detecting copies is a prerequisite for counting sources as independent.
:::

### The tuple {kind=state at=two-primitives}

Name the two primitives that form terms. How is $\langle A,R,S,B\rangle$ read, and which tuple is it identical to? What becomes of converses, symmetric relations and subrelations? How is a relation itself written?

::: answer
IS-A, which has a direction, and a tuple of four concepts, $\langle A,R,S,B\rangle\equiv\langle B,S,R,A\rangle$, read "$A$ plays role $R$ toward $B$, which plays role $S$". A relation has no argument order, so no relation needs a separately named converse: $\langle\textit{John},\textit{parent},\textit{child},\textit{Mary}\rangle$ and $\langle\textit{Mary},\textit{child},\textit{parent},\textit{John}\rangle$ are the same fact. A symmetric relation is one whose roles coincide, as in $\langle A,\textit{sibling},\textit{sibling},B\rangle$. A subrelation comes from a subrole: since *mother* IS-A *parent*, every motherhood tuple IS-A a parenthood tuple. A relation is identified with its pair of roles and written $\langle R,R,S,S\rangle$. Every instance stands under it, which gives domains and ranges as ordinary IS-A.
:::

### The two-way reading {kind=case at=two-primitives}

What does asserting a class-level tuple claim? Judge each of these: $\langle\textit{Dog},\textit{whole},\textit{part},\textit{DogLeg}\rangle$, $\langle\textit{Dog},\textit{whole},\textit{part},\textit{Leg}\rangle$, $\langle\textit{Car},\textit{whole},\textit{part},\textit{Engine}\rangle$, $\langle\textit{Puppy},\textit{whole},\textit{part},\textit{DogLeg}\rangle$.

::: answer
It claims that the actual links of its type cover all of $A$ and all of $B$: every $A$ stands in the relation to some $B$, and every $B$ stands in it to some $A$.

- *Dog* and *DogLeg*: holds. Every dog leg belongs to some dog by definition, and the tuple adds that every dog has a leg.
- *Dog* and *Leg*: does not hold, because tables have legs too.
- *Car* and *Engine*: refuted by boat engines, which sit in no car.
- *Puppy* and *DogLeg*: false, although it is a subtype of a true tuple, because most dog legs belong to grown dogs.
:::

### Inheritance runs through images {kind=derive at=two-primitives}

Split $\langle\textit{Dog},\textit{whole},\textit{part},\textit{DogLeg}\rangle$ into two IS-A statements. Use the split to show what *Puppy* inherits and what fails, and give the true tuple about puppies. Why is generalizing a role always safe when changing a filler is not?

::: answer
The tuple holds iff *Dog* IS-A (whole of some *DogLeg*) and *DogLeg* IS-A (part of some *Dog*). The "every" comes from IS-A and the "some" from the image, once in each direction. The two conjuncts are ordinary IS-A statements and are inherited as such. *Puppy* IS-A *Dog* gives *Puppy* IS-A (whole of some *DogLeg*): every puppy has a dog leg. The other conjunct fails, since *DogLeg* IS-A (part of some *Puppy*) is false. The true tuple is the matched one, $\langle\textit{Puppy},\textit{whole},\textit{part},\textit{PuppyLeg}\rangle$, where *PuppyLeg* is the dog legs that are part of some puppy.

Roles stand only under "some" in both conjuncts, so generalizing a role only makes the images grow. Each filler stands under "every" in one conjunct and under "some" in the other, so changing a filler is not safe in general.
:::

### No individuals, no classes {kind=explain at=two-primitives}

Why does the ontology need no primitive distinction between individuals and classes? What danger does dropping the distinction bring, and how does the essay meet it?

::: answer
Take *John* and *Mary* as terms with one member each. For singular terms "every" and "some" agree, so a tuple over individuals is a plain fact, read by the same semantics as a tuple over classes. The danger is collective predication. "Dogs are mammals" says something of every dog, and "Humans are a species" says something of the kind. If both were IS-A, John would be a species. So IS-A is distributive: it says only what holds of every member. A collective fact is about a kind, and the kind gets a singular term of its own: $\langle\textit{HomoSapiens},\textit{taxon},\textit{rank},\textit{SpeciesRank}\rangle$. Membership in the kind is a tuple, $\langle\textit{Human},\textit{member},\textit{taxon},\textit{HomoSapiens}\rangle$, and not an IS-A, so nothing said of the kind passes down to its members.
:::

### One judgment {kind=state at=one-judgment}

State the only form of judgment. Who makes it, and where does the regress stop? How are reported speech and contexts handled without nesting? Which sources are closed under inference?

::: answer
$\mathrm{Prov}(T,P)$: source $P$ asserts $T$. $\mathrm{Prov}$ is never itself a term and never occurs inside one. It is the system's own judgment, made from a parse that may be wrong. The system is itself a source, *Self*, and the shared world is $\mathrm{Prov}(T,\textit{Self})$. For reported speech the nesting goes into the source: $\mathrm{Prov}(T,\textit{Smith-via-Times})$. A context, such as a novel's canon or a country's law, is treated as an idealized source: $\mathrm{Prov}(T,\textit{HarryPotterCanon})$. Only idealized sources and *Self* are closed under inference, since Smith does not believe every consequence of what Smith says. Claims from different sources are combined only in *Self*, after *Self* has adopted them.
:::

### Three jobs, and judging is not one {kind=recall at=what-the-language-model-is-for}

Lenat and Marcus's neurosymbolic Cyc judges by proof. What judges in the essay's design? Name the three jobs the language model does, and say for each what keeps it from needing special trust. Which risk does the essay name?

::: answer
The judge is code length.

- The model parses into the current vocabulary. Given a sentence and the relevant slice of the ontology in its prompt, it produces the judgments $\mathrm{Prov}_d$, and it needs no retraining when the ontology is edited.
- It proposes edits: merges, splits, new roles, rules and context boundaries. Each proposal is checked by re-scoring the data it touches, so a high rate of bad proposals costs compute but not quality.
- It is one more source, with its own reliability and reporting policy, estimated against the other sources in the same code. Several prompts to one model do not count as several sources.

The risk: a model pretrained on human language will propose the structures that human linguistics and folk taxonomy already contain. The code length cannot make a bad ontology score well, but the proposer decides what gets considered, so the search's local optima will lean toward the familiar.
:::

### What compression cannot do {kind=limits at=what-compression-cannot-do}

Give the two limits the essay states for conditioning on provenance, and four things its closing section concedes about the proposal as a whole.

::: answer
Limits of provenance ([Who says so](/notes/an-ontology-that-pays-for-itself.html#who-says-so)):

- Compression rewards mutual consistency, not truth. A coherent myth told by many independent sources will be promoted to the shared world, and only sources outside text, such as measurement and action, can break it.
- A fact that no source states remains out of reach.

Conceded in closing:

- The induced ontology will not be the best compressor of its corpus. Code length is the criterion for choosing structure, not a contest that the structure wins.
- The search is the bottleneck, not the scoring. Nothing yet shows that proposals from a language model make it feasible at scale.
- The criterion is unlikely to single out one ontology: compression picks a family of near-ties.
- Nothing has been implemented, so there are no results. An implementation should be evaluated against WordNet, Wikidata and OpenCyc and never trained toward them.
:::
