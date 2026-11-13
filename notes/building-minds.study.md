---
title: "Study notes: Building Minds: Developmental Psychology and the Architecture of Learning"
essay: building-minds
track: cognitive-science
reviewed-against: "dff1247"
requires:
  - {at: cognitive-architectures-report#the-serial-bottleneck, for: "the serial bottleneck between procedural memory and working memory, which section 4.3 ties to executive function"}
  - {at: cognitive-architectures-report#the-xaps-prelude-and-the-power-law-of-practice, for: "chunking, the compiling of practiced steps into one, which the essay identifies with Case's efficiency mechanism"}
  - {at: cognitive-architectures-report#hippocampal-systems-and-complementary-learning, for: "Complementary Learning Systems: fast hippocampal and slow neocortical learning, and the 2016 update"}
  - {at: cognitive-architectures-report#four-pointers-and-the-merge-conjecture, for: "working-memory pointers and the Merge conjecture, used for schemes, fast mapping and the limits of Drescher's system"}
  - {at: concept_theories#vehicles-content-and-the-polysemy-provocation, for: "the vehicle-content distinction, used to answer the circularity challenge", strength: helpful}
  - {at: concept_theories#careys-core-knowledge, for: "a first statement of core knowledge and Quinean bootstrapping", strength: helpful}
introduces:
  - {term: assimilation and accommodation, at: the-core-idea, related: ["schema mechanism"]}
  - {term: equilibration, at: the-core-idea}
  - {term: violation of expectation, at: the-violation-of-expectation-revolution, related: ["synthetic item"]}
  - {term: composition problem, at: the-composition-problem, gloss: "how modular core knowledge systems come to exchange information", related: ["shared intentionality"]}
  - {term: placeholder symbols, at: quinean-bootstrapping, related: ["vehicle and content of a concept"]}
  - {term: executive function, at: executive-function-and-conceptual-change}
  - {term: M-capacity, at: executive-function-and-conceptual-change}
  - {term: relational complexity, at: stages-as-working-memory-growth, related: ["2-simplicial attention"]}
  - {term: schema mechanism, at: the-radical-constructivist-wager, related: ["theory-theory", "general value function", "GQ(λ)"]}
  - {term: marginal attribution, at: how-the-schema-mechanism-works}
  - {term: synthetic item, at: how-the-schema-mechanism-works, related: ["belief state"]}
  - {term: nativist kernel, at: counterfactuals-and-non-naive-induction, gloss: "the domain-general learning biases that even a constructivist learner must have built in"}
  - {term: zone of proximal development, at: the-zone-of-proximal-development, related: ["two conditions on a teacher", "self-distillation with privileged context"]}
  - {term: fast mapping, at: fast-mapping-and-the-tomasello-bridge}
  - {term: shared intentionality, at: fast-mapping-and-the-tomasello-bridge, related: ["secondhand inheritance"]}
  - {term: secondhand inheritance, at: the-developmental-desideratum, gloss: "a learner trained on text receives the structure that development put into the text, without undergoing the development", related: ["primary persona"]}
uses:
  - {term: core knowledge, from: concept_theories}
  - {term: Quinean bootstrapping, from: concept_theories}
  - {term: vehicle and content of a concept, from: concept_theories}
  - {term: serial bottleneck, from: cognitive-architectures-report}
  - {term: chunking, from: cognitive-architectures-report}
  - {term: Common Model of Cognition, from: cognitive-architectures-report}
  - {term: Complementary Learning Systems, from: cognitive-architectures-report}
  - {term: catastrophic interference, from: cognitive-architectures-report}
  - {term: working-memory pointers, from: cognitive-architectures-report}
  - {term: Merge conjecture, from: cognitive-architectures-report}
---

The essay reports developmental theories and reads them through the architectures essay. The answers mark which readings are the essay's own.

### Piaget's mechanism and stages {kind=state at=piagets-framework-the-constructivist-vision}

For Piaget the mind is neither furnished by experience nor pre-stocked by evolution. What builds it? Define the two processes of construction and their balance. Name the four stages with the kind of thinking that marks each.

::: answer
The child's own activity builds it. *Assimilation* interprets new experience through existing schemes. *Accommodation* modifies a scheme when it fails. *Equilibration* is their balance, disrupted by novelty and re-established at a higher level of organization.

- Sensorimotor: practical intelligence, the coordination of perception and action without internal representation.
- Preoperational: symbolic representation, with systematic errors such as the failure of conservation.
- Concrete operational: conservation, classification and serial ordering, for concrete objects only.
- Formal operational: abstract, hypothetical and systematic reasoning.
:::

### What looking time showed {kind=case at=the-violation-of-expectation-revolution}

Piaget tested object permanence by whether infants search. Why did Baillargeon think search underestimates them, and what did she measure? What did Stahl and Feigenson add? Which part of Piaget's theory does the evidence overturn, and which does it support?

::: answer
Search needs motor planning, means-ends reasoning and inhibitory control, which a young infant may lack for reasons unrelated to its understanding of objects. Baillargeon showed infants events that respect or violate physical expectations and measured how long they looked. They looked longer at impossible events months before the age at which Piaget placed object permanence. Stahl and Feigenson showed that infants who saw an object violate an expectation explored that object over others and tested it in a way aimed at the violation: banging the one that seemed to pass through a wall, dropping the one that seemed to hover. Prediction failure tells the infant where learning is needed. The evidence overturns Piaget's timeline. It gives equilibration what the essay calls its "sharpest empirical vindication".
:::

### Core knowledge and the composition problem {kind=object at=the-composition-problem}

Spelke's [core knowledge systems](/notes/building-minds.html#core-knowledge-spelkes-proposal) are modular. Name them. What problem does modularity create, and what is her solution? State the objection from corvids and the essay's conclusion.

::: answer
The systems represent objects, actions, number, geometry, social partners, and possibly social groups. Each operates over its own domain and cannot freely exchange information with the others, yet adult thought combines them, as in "three agents behind the wall". Spelke proposes that natural language is the compositional mechanism, which is why only humans go beyond core knowledge. If so, animals without language should be confined to single domains. Western scrub-jays re-cache food they were seen hiding, which integrates what was cached, where, when, and who was watching. They do it with no compositional syntax. The essay concludes that language is one mechanism for cross-domain integration, perhaps the most powerful, and not the only one.
:::

### Quinean bootstrapping {kind=explain at=quinean-bootstrapping}

What does Carey accept from Spelke and deny to Fodor? Describe bootstrapping with the case of number, and say why its result counts as new.

::: answer
Carey accepts that infants start with innate core knowledge. Against Fodor's nativism she holds that new concepts can be learned, with expressive power beyond any logical combination of innate primitives. The learner creates placeholder symbols, whose first meaning is exhausted by their relations to other symbols and to observable regularities, and fills them with content gradually. Children learn the count list before the words mean anything numerical: a word is its position in the list. They then work out "one", "two" and "three" in turn, and finally grasp the counting principle, that the last word of a count says how many there are. Exact cardinal number is new because neither starting system can express it. The core number system represents approximate magnitudes, and parallel individuation handles only very small sets.
:::

### The circularity challenge {kind=object at=the-circularity-challenge}

State the circularity challenge to bootstrapping and Beck's reply. How does the essay use the vehicle-content distinction to make bootstrapping less mysterious?

::: answer
The challenge: learning a concept requires testing hypotheses, and formulating the hypotheses requires the concept already. This is Fodor's argument against concept learning, aimed at Carey. Beck replies that computational constraints guide the interpretation of placeholders without presupposing their eventual content. Some are internal (innate learning biases, attentional mechanisms) and some external (linguistic structure, cultural scaffolding). The essay adds that a placeholder has vehicle properties, its syntactic position and inferential relations, before it has determinate content. If Quilty-Dunn is right that vehicles do the causal work, the thing to explain is how a new computational role is built from existing ones, not how a new meaning appears.
:::

### Schemes, chunks and conservation {kind=explain at=executive-function-and-conceptual-change}

Which three executive capacities does conceptual change draw on, and what is each for? How does the essay translate Pascual-Leone's scheme into the terms of the architectures essay? Why does conservation defeat a preoperational child, and what does Case's efficiency add?

::: answer
Working memory holds the elements to be compared. Inhibitory control suppresses the prepotent response of the old system, such as the judgment that the taller glass has more water. Cognitive flexibility shifts between the old and new frameworks.

Each scheme that must be active for a task occupies one unit of M-capacity. The essay therefore equates a scheme with a chunk, the unit that fills one working-memory slot, and with one pointer of the Merge conjecture. Conservation needs four schemes at once: the two dimensions, their compensatory relation, and an executive scheme inhibiting the single-dimension response. A preoperational child has two or three units. On Case's account practiced operations are compiled into single chunks, which frees pointers for novel elements: "the child gets more done per pointer."
:::

### The neo-Piagetians {kind=distinguish at=the-neo-piagetians-architecture-meets-development}

How do the neo-Piagetians redescribe Piaget's stages? State Halford's version. On what question do they split, and what is the essay's verdict?

::: answer
They redescribe the stages by the computational resources available at each age. A stage transition is an increase in the number of relational elements the child can represent and coordinate at once. In Halford's relational complexity theory a unary relation needs one working-memory slot, a binary relation two, and so on. Four is the most an adult can process without decomposing the relation, which matches Cowan's capacity limit.

They split on what makes working memory grow. For the constructivist-learning camp, including the later Case, practice makes operations faster and more automatic, which the essay identifies with chunking. For the maturational-attention camp, including Pascual-Leone, the attentional resource itself grows on a biological schedule, so no amount of practice brings a three-year-old to a seven-year-old's reasoning. The essay holds that both are involved: maturation sets an upper bound, and efficiency decides how much of it is available for novel reasoning.
:::

### How the schema mechanism learns {kind=explain at=how-the-schema-mechanism-works}

What are items and schemas in Drescher's system? How does marginal attribution produce a schema, and when is a synthetic item created? Use the ball.

::: answer
Primitive items are binary sensory states. A schema is a triple of precondition, action and postcondition, predicting what an action does in a context. Marginal attribution tracks, for each action, which state transitions follow it more often than their baseline rate. A reliable transition becomes a new schema, and the system then looks for context conditions that make it more reliable.

A synthetic item is created when a schema is locally consistent and not globally reliable: it works for a while, stops, and works again. The item is an inferred hidden variable that explains the inconsistency. "If I probe here, I see the ball" holds only while the ball is there. The system creates an item, "ball-is-here", that makes the schema reliable when added to its context, and gives it verification conditions. The persisting object is then a hypothesis the system invents to improve its own predictions, which implements Piaget's claim that the infant constructs it.
:::

### The nativist kernel {kind=argue at=counterfactuals-and-non-naive-induction}

Drescher wagers that almost all structure of the world can be learned by a domain-general mechanism. What does he say must still be built in, and of what kind is it? What does the essay conclude, and with whose notion?

::: answer
Drescher holds that naive induction, the tracking of correlations, is not enough. Three things must be built in:

- mechanisms for counterfactuals, which track what would have happened through transitions no existing schema explains
- a preference for schemas with inverse effects, as a heuristic for controllable variables
- marginal attribution, which attends to unexplained correlations and not total ones.

These are domain-general learning biases and not domain-specific knowledge, but they concede to the nativist that some structure comes first. The essay puts it through Deutsch's notion of universal reach: the learning algorithm must be able to discover any regularity in any domain, and Drescher accepts that this capacity cannot itself be learned. "Even the most radical constructivism, it turns out, requires a nativist kernel."
:::

### Where the schema mechanism stops {kind=recall at=what-the-schema-mechanism-achieves-and-where-it-fails}

What did the schema mechanism rediscover, and which infant error did it reproduce? Name its four limitations. The essay says something more is needed: what are the three candidate answers?

::: answer
It rediscovered object permanence (through synthetic items), means-ends reasoning (through composite actions built from chains of schemas), and a primitive imitation. It reproduced the infant's early failure to integrate tactile and visual representations of an object.

Its limitations:

- no object identity across sensory modalities
- a "subactivation" mechanism for simulating actions mentally that never worked
- variable-matching for generalizations excluded by design
- no hierarchical abstraction.

The candidates for what is missing:

- richer innate structure waiting to be activated (Spelke)
- growth at the high level, in new conceptual primitives and compositional structures (Carey)
- growth at the low level, in how many relational roles can be bound at once (the neo-Piagetians).

The essay says the last two are not mutually exclusive.
:::

### Two speeds of learning {kind=explain at=complementary-learning-systems-and-the-pace-of-development}

A toddler learns a word from one exposure and takes years over conservation and number. How does Complementary Learning Systems theory explain the asymmetry? Why is bootstrapping slow? What would a more faithful schema mechanism need?

::: answer
The hippocampal system learns single episodes quickly, and the neocortex learns slowly from interleaved exposure. The 2016 update adds that neocortical learning is fast when new information fits existing schemas. A new word for a familiar category fits and is learned at once. A framework that contradicts an existing one needs prolonged experience. On this reading conservation is hard because it contradicts the entrenched schema "more height means more stuff", not because it is logically complex. Bootstrapping is slow for the same reason: exact number is discontinuous with the approximate magnitude system, so it must be built through long hippocampal-to-neocortical consolidation. Drescher's mechanism has one learning speed. A more faithful version would pair one-shot formation of schemas with slow, interleaved consolidation across episodes.
:::

### The social dimension {kind=explain at=vygotskys-social-dimension-and-why-architecture-needs-it}

How does Vygotsky's child differ from Piaget's? How does scaffolding change the learning problem that Drescher's mechanism faces? What does Tomasello add, and how does the essay describe fast mapping in architectural terms?

::: answer
Piaget's child is a solitary explorer. Vygotsky's is a participant in cultural practices, guided by more knowledgeable partners through the zone of proximal development, the gap between what the child can do alone and with guidance. Drescher's mechanism must discover every regularity itself. A child's parents make regularities salient, label objects and demonstrate actions, and the culture supplies external symbols such as the counting words. The child has to discover what the counting system means, not invent it.

Tomasello holds that shared intentionality, joint attention in particular, lets the infant work out what a speaker is referring to, and that it underlies cumulative culture. The essay describes fast mapping as a free working-memory slot for the new symbol, a pointer to the referent sustained by joint attention, inhibition of alternative interpretations, and a binding of the two. That is a Merge-like operation over pointers. Joint attention selects the referent and the architecture performs the binding.
:::

### What Drescher's system teaches {kind=argue at=what-dreschers-system-teaches}

In what respect does the essay judge the schema mechanism more right than it seemed in 1991? Name the three things it lacks, and explain the first as a gap in working memory.

::: answer
Its core idea has gained support: a concept such as object permanence is an inferred theoretical entity, created to explain regularities in experience. The essay says the Bayesian turn in developmental psychology formalizes this, with concepts as generative models learned by inference.

It lacks structured composition, a social channel, and a dual-speed learning system. On the first: synthetic items are flat. Each reifies the validity conditions of one schema and cannot bind with other items in compositions that carry variables. The system can register "object-here is Off and object-there is On" and cannot express that the same object moved. The essay calls this the working memory gap. The Common Model has a hub where several representations are held, compared and composed, on the essay's conjecture by Merge-like pointer operations. Without a hub the mechanism cannot hold placeholder symbols and existing representations together and map between them, as bootstrapping requires.
:::

### Is secondhand inheritance enough? {kind=limits at=the-developmental-desideratum}

State the question the essay puts to AI. Give its case that text may suffice and its three reasons for caution. How does it leave the matter?

::: answer
The question is how much of the structure of thought falls out of the statistical structure of human text, and how much needs developmental scaffolding. The case for text: it was produced by minds that developed, so the developmental structure is implicit in it, and a learner inherits that structure secondhand. Text may be a rich enough signal for a powerful learner, as a student can sometimes learn physics from a textbook without doing the experiments. The essay calls this "genuinely possible".

The reasons for caution come from three sources. Drescher shows that even object permanence from scratch needs architectural commitments. The neo-Piagetians show that relational complexity is gated by a working-memory capacity that matures on a schedule. Carey shows that some transitions create new primitives. These are claims about the process of learning. Skipping the process may leave representations "subtly different in ways that matter under pressure". The essay leaves it as an empirical question that AI systems are now testing at scale.
:::
