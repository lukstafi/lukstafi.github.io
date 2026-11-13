---
title: "Study notes: Cognitive Architectures: A Deep Dive into the Science of the Mind"
essay: cognitive-architectures-report
track: cognitive-science
reviewed-against: "34bc94d"
requires:
  - {at: concept_theories#prototypes-and-exemplars, for: "prototype and exemplar theories, which section 8 assigns to two memory systems", strength: helpful}
  - {at: concept_theories#macherys-heterogeneity-challenge, for: "Machery's claim that 'concept' covers several kinds of structure", strength: helpful}
introduces:
  - {term: cognitive architecture, at: introduction-the-question-that-drives-it-all, related: ["cog view"]}
  - {term: chunks and activation, at: human-associative-memory-and-rational-analysis, related: ["symbolic data and quantitative metadata"]}
  - {term: rational analysis, at: human-associative-memory-and-rational-analysis, related: ["bounded rationality"]}
  - {term: bounded rationality, at: the-adaptive-control-of-thought}
  - {term: sensory-based account of conscious thought, at: the-sensory-based-account-of-thought, related: ["global broadcast", "outer loop"]}
  - {term: working memory, at: working-memory-as-the-theater-of-consciousness}
  - {term: global broadcast, at: attention-as-the-mechanism-of-consciousness, related: ["Global Workspace markers", "working-memory pointers", "cognition (narrow sense)", "broadcast that returns"]}
  - {term: Standard Model of the Mind, at: why-a-standard-model, related: ["Common Model of Cognition"]}
  - {term: cognitive cycle, at: core-structure-and-processing, related: ["serial bottleneck", "dreaming phase"]}
  - {term: symbolic data and quantitative metadata, at: memory-and-content-the-hybrid-representation, related: ["Continuity and Compositionality Principles"]}
  - {term: chunking, at: the-xaps-prelude-and-the-power-law-of-practice, related: ["compiled/interpreted gap", "amortization as learning and as efficiency", "library learning", "M-capacity"]}
  - {term: functional elegance, at: sigma-grand-unification-through-graphical-models}
  - {term: appraisal variables, at: emotion-as-architectural-modulation, related: ["motley mix", "violation of expectation"]}
  - {term: Common Model of Cognition, at: the-common-model-of-cognition}
  - {term: dichotomic maps, at: dichotomic-maps-understanding-the-space-of-architectures, related: ["symbolic data and quantitative metadata", "formalisms as coordinates"]}
  - {term: serial bottleneck, at: the-serial-bottleneck, related: ["executive function", "Global Workspace markers"]}
  - {term: Complementary Learning Systems, at: hippocampal-systems-and-complementary-learning, related: ["three placements of a memory", "hippocampal indexing", "dreaming phase"]}
  - {term: catastrophic interference, at: hippocampal-systems-and-complementary-learning, related: ["ladder of stores", "interference between stored keys"]}
  - {term: working-memory pointers, at: four-pointers-and-the-merge-conjecture, related: ["fast mapping", "M-capacity", "relational complexity"]}
  - {term: Merge conjecture, at: four-pointers-and-the-merge-conjecture, gloss: "the authors' proposal that Merge over working-memory pointers is the domain-general operation behind chunking and linguistic syntax", related: ["Merge-without-Move", "fast mapping"]}
uses:
  - {term: prototype and exemplar theories, from: concept_theories}
  - {term: proxytypes, from: concept_theories}
  - {term: "Machery's heterogeneity thesis", from: concept_theories}
---

Sections 2 to 7 report four sources. Sections 8 and 9 are the authors' own extensions, and the answers mark them as such.

### What an architecture is {kind=state at=introduction-the-question-that-drives-it-all}

Which question of Newell's does the essay start from? What is a cognitive architecture, and what stays fixed in it? Say in a phrase what each of the four sources contributes.

::: answer
Newell asked how the human mind can occur in the physical universe. His answer was to come as a cognitive architecture: a specification of the fixed structures and processes that make up the mind's computational machinery. The architecture stays fixed, or varies slowly, on the timescale of normal reasoning, while the knowledge and skills it processes change quickly.

- Anderson: the detailed account of ACT-R, grounded in functional analysis and neural mapping.
- Carruthers: a philosophical analysis of how conscious thought depends on sensory-based working memory.
- Laird, Lebiere and Rosenbloom: the consensus across architectures, stated as the Standard Model of the Mind.
- Rosenbloom's memoir: the path from Soar through Sigma to the Common Model, driven by functional elegance.
:::

### ACT-R's modules and their brain regions {kind=state at=the-modular-organization}

How is ACT-R organized, and where is its bottleneck? Give Anderson's mapping of the components onto the brain, and say why the mapping matters.

::: answer
Modules run asynchronously and in parallel around a central procedural module. Each module places a single result per operation in its own buffer. The procedural module tests the buffers and moves information between them, and it fires only one production rule at a time, which makes the cognitive cycle serial.

- Procedural module: basal ganglia, with matching, selection and execution in the striatum, pallidum and thalamus.
- Goal buffer: dorsolateral prefrontal cortex.
- Retrieval buffer: ventrolateral prefrontal cortex.
- Visual module: occipital cortex and parietal regions.
- Declarative module: temporal cortex and hippocampus.
- Intentional module: anterior prefrontal cortex.

The mapping constrains the theory and yields predictions that brain imaging can test.
:::

### Rational analysis {kind=explain at=human-associative-memory-and-rational-analysis}

What determines which chunk ACT-R retrieves from declarative memory? What does Anderson's rational analysis add to that account, and how does the same method reach the procedural system?

::: answer
Chunks carry activation values. Activation combines a base level, reflecting the chunk's history of use, with an associative component, reflecting its relevance to the current context. Chunks with higher activation are retrieved faster and more often. Rational analysis derives the equation from the statistics of the environment instead of fitting it: Anderson and Schooler documented that the probability of needing a piece of information decays as a power law from its last use. The memory system is then an approximately optimal answer to real retrieval demands. In the procedural system, production rules carry utility values learned by reinforcement, a form of temporal-difference learning, so the system comes to select the strategies that have served its goals.
:::

### Carruthers on conscious thought {kind=state at=carruthers-centered-mind-consciousness-working-memory-and-the-sensory-base}

State Carruthers' thesis about conscious thought and the default assumption it rejects. What finding about working memory supports it? What is attention on his account?

::: answer
Conscious thought is always sensory-based: reflection sustains and manipulates sensory images, inner speech included, in working memory. The rejected assumption is that conscious thinking partly consists of amodal propositional attitudes. For Carruthers, beliefs, goals, decisions and intentions are never conscious. They work in the background, "pulling the strings" by selecting and manipulating the sensory contents.

The supporting finding is that working memory uses the perceptual systems of every modality, and imaging of working-memory tasks finds activity in the relevant sensory area. Working memory is then a mode of operation of the perceptual systems, sustained by top-down attention from prefrontal cortex, and not a separate store.

Attention selects which representations are globally broadcast and so become conscious. Carruthers holds that attending is a form of action, whose neural circuits overlap with those of motor control. The stream of consciousness is therefore active, mind-wandering included.
:::

### The Standard Model's parts and its cycle {kind=recall at=core-structure-and-processing}

Name the five components of the Standard Model and describe the cognitive cycle. Where do planning and language processing live? What kind of object is the model?

::: answer
Perception, working memory, declarative long-term memory, procedural long-term memory, and motor. In each cycle, procedural memory tests working memory, selects a single deliberate act, and executes it by modifying working memory. The modifications can start retrievals, motor actions, or top-down influence on perception. Planning, language processing and Theory of Mind have no module of their own: they emerge from sequences of cycles. The model is [a theoretical architecture and not an implemented one](/notes/cognitive-architectures-report.html#why-a-standard-model). It states a consensus, not unanimity, and an omission often marks where consensus is still needed.
:::

### Data and metadata {kind=distinguish at=memory-and-content-the-hybrid-representation}

In what sense are modern cognitive architectures "subsymbolic"? State the Standard Model's rule separating data from metadata, and its stance on how symbols are implemented.

::: answer
The core content is relations over symbols. Numeric metadata annotates the symbols and relations: frequency, recency, activation, utility, similarity. Metadata exists only in support of symbolic representations, relations cannot be defined over it, and its types are fixed by the architecture. The subsymbolic character comes from this annotation, which modulates storage, retrieval and selection. It does not come from replacing symbols by vectors, as in neural networks. The model is agnostic about implementation: symbols may be uninterpreted labels (Soar, ACT-R), patterns over distributed vectors (Spaun's semantic pointers), or both (Clarion, Sigma), as long as they can represent and manipulate relational structures.
:::

### Chunking and Soar {kind=state at=rosenblooms-architectural-exploration-from-soar-through-sigma}

What is chunking, and what did Rosenbloom and Newell introduce it to explain? State Soar's four "one way" commitments and Newell's maxim. Why did Rosenbloom leave Soar?

::: answer
Chunking combines several processing steps into a single compiled step. It was their explanation of the power law of practice, and in Soar it is triggered by impasses, gaps in the knowledge needed for a decision. Soar has one representation for long-term knowledge (rules), one way to decide (symbolic preferences), one way to learn (chunking), and one way to reflect on its own behavior (impasse-driven subgoaling). The maxim is to listen to the architecture: look for a new capability in the interaction of existing mechanisms before adding a module. Data chunking, a form of declarative learning, appeared this way from search and chunking. By the late 1990s Rosenbloom could not see how to extend Soar while keeping it simple. Laird went on adding memories and learning mechanisms, which made Soar more capable and more modular.
:::

### Sigma {kind=recall at=sigma-grand-unification-through-graphical-models}

What single substrate does Sigma rest on, and what does it replace in Soar? Name the four desiderata. What does Rosenbloom mean by deconstruction?

::: answer
Sigma rests on factor graphs processed by the sum-product algorithm, a substrate general enough to subsume symbolic rule-based processing and statistical or neural processing. An extension of statistical-relational factor graphs replaces Soar's rule memory, and gradient descent replaces chunking. The desiderata are grand unification (from symbolic thought to perception and motor control without separate modules), generic cognition (natural and artificial humanlike minds), functional elegance (broad capabilities from a few interacting mechanisms), and sufficient efficiency. Deconstruction reinterprets capabilities usually built as modules, such as reinforcement learning, episodic memory and mental imagery, as combinations of more basic mechanisms. Rosenbloom came to see functional elegance as a source of scientific insight and not only an aesthetic preference.
:::

### Emotion without a module {kind=explain at=emotion-as-architectural-modulation}

How does Sigma produce emotion without an affective module? Name the two appraisal variables and one consequence of each. What does the essay conclude that transformers lack?

::: answer
Emotion arises as a modulation from the same message-passing that does reasoning, retrieval and motor control. *Expectedness* measures the divergence between the architecture's predictions and incoming observations. When it is low, processing is reallocated toward the discrepant input, an analogue of attentional capture. *Desirability* tracks whether the current state moves toward or away from the agent's objectives. With controllability it biases action selection: negative desirability and low controllability favor conservative responses, and positive affect widens exploration. Emotion is then a control signal, cognition in its evaluative mode. The essay concludes that a transformer's residual stream has no architectural mechanism for computing surprise at its own predictions or tracking desirability against persistent goals. What it lacks is "the homeostatic self-regulation that emotion implements", and whether wrapping a model in goal-tracking and memory layers can supply it is left open.
:::

### Five shared commitments {kind=recall at=cross-cutting-themes}

Name the five themes on which the four works converge. For the serial bottleneck, say how each work expresses it and how it maps onto dual-process theory.

::: answer
- *The serial bottleneck.* One production fires per cycle in ACT-R, one deliberate act is selected per cycle in Soar, and the Standard Model posits the constraint. Carruthers reaches it from the capacity limits of conscious, controlled thought. The serial core is [System 2](/notes/cognitive-architectures-report.html#dual-systems-and-the-architecture-of-reasoning); the parallel processing inside modules is System 1.
- *The symbolic-subsymbolic hybrid.* Symbolic structures annotated with quantitative metadata.
- *Working memory as the hub.* The only place where information from different modules meets and procedural memory can act on it.
- *Learning as a side effect of performance.* Incremental and online, with no separate training phase, in contrast to the usual practice of machine learning.
- *Bounded rationality.* The architecture supports effective decisions under limited memory, time and knowledge. It is not built for global optimality.
:::

### The challenge from language models {kind=argue at=the-challenge-from-large-language-models}

Why are large language models a challenge to the cognitive-architecture tradition? Which of their limitations does the essay say the tradition predicted, and what resolution does it suggest?

::: answer
Language models reach remarkable generality through one mechanism, without the modular hybrid machinery. They appear to handle language and Theory of Mind, which the Standard Model expected to emerge from sequences of primitive acts. The predicted limitations are difficulty with systematic compositionality, no persistent memory or learning from experience, no grounding of language in perception and action, and no goal-directed deliberate reasoning of the kind the serial bottleneck enables. The essay suggests that the two "need each other". Language models would supply statistical knowledge and flexible language processing. Architectures would supply structured reasoning, persistent memory and grounded action.
:::

### Why two memory systems {kind=explain at=hippocampal-systems-and-complementary-learning}

Carruthers describes what the hippocampus does. What does Complementary Learning Systems theory add? State the 2016 update, and the open question of the Standard Model that the essay uses the theory to settle.

::: answer
The theory of McClelland, McNaughton and O'Reilly says why the hippocampal system is a separate component. In a network with distributed representations, rapid learning of new information overwrites the regularities extracted from earlier experience: catastrophic interference. The solution is two systems with different learning rates. The neocortex learns slowly from interleaved exposure and extracts statistical structure. The hippocampus learns single episodes quickly as sparse, pattern-separated traces and replays them to the neocortex for gradual consolidation.

Kumaran, Hassabis and McClelland added that replay can weight experience by goals, and that neocortical learning can be fast when new information is consistent with known structure. Novel information takes the slow route; schema-consistent information is integrated quickly.

The Standard Model had no consensus on whether declarative memory is one store or two. The essay's answer is two: semantic memory is the slow neocortical system and episodic memory the fast hippocampal one. They are different learning regimes, not different contents of one memory.
:::

### The Merge conjecture {kind=argue at=four-pointers-and-the-merge-conjecture}

Working memory sustains about four items. Reconstruct the authors' conjecture about what its pointers do, give the two lines of evidence they cite, and their account of why the number is four.

::: answer
The limit is read as attentional: a few pointer-like indices each latch onto a sensory representation and sustain it, and what is pointed to is globally broadcast. The authors propose that the minimal operation on pointers is Merge. It combines what two pointers reference into a new structured object, re-attaches the result to one pointer, and frees the other. This is Chomsky's Merge taken as domain-general, with syntax an exaptation of it. Chunking in Soar, in ACT-R and in the Standard Model has the same structure: several elements become one unit occupying one slot.

The evidence cited: Fujita's hypothesis that Merge originated in motor control, the hierarchical manipulation of objects, and a model of prefrontal cortex and basal ganglia from the Frank lab in which a merged chunk replaces the original item in a working-memory slot.

Four is the minimum for recursive Merge of useful depth. Two pairs can be merged independently and the results merged, which gives two levels of embedding. That matches the practical depth of center-embedding in language. The bottleneck is then a design feature and not only a resource limit.
:::

### What is left open {kind=limits}

Name five matters the essay marks as unsettled or as lying beyond the consensus, and say where each arises.

::: answer
- Whether any architecture explains consciousness or only correlates with it "remains contested". The Standard Model is silent on phenomenal consciousness ([7.1](/notes/cognitive-architectures-report.html#consciousness-and-architecture)).
- How much modularity is fixed in the architecture and how much arises from knowledge and experience. Sigma disagrees with ACT-R and Soar on this ([4.5](/notes/cognitive-architectures-report.html#the-convergence)).
- Whether working memory is unitary or modality-specific. The accounts differ, which may reflect uncertainty about how much the evidence warrants ([6.3](/notes/cognitive-architectures-report.html#working-memory-as-the-hub)).
- The space of minds beyond the humanlike ones the Common Model restricts itself to. Rosenbloom's dichotomic maps, built from the (a)symmetric, (un)controlled and (meta)data dichotomies, are offered as tools for it ([7.3](/notes/cognitive-architectures-report.html#the-space-of-all-possible-minds)).
- The authors' two extensions, the grounding of the semantic-episodic distinction in learning rates and the Merge conjecture. Whether they hold up under scrutiny is "a question for future work" ([conclusion](/notes/cognitive-architectures-report.html#conclusion)).
:::
