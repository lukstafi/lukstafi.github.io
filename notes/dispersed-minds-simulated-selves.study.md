---
title: "Study notes: Dispersed Minds, Simulated Selves: What LLM Interpretability Reveals About Artificial Cognition"
essay: dispersed-minds-simulated-selves
track: cognitive-science
reviewed-against: "4acbf91"
requires:
  - {at: cognitive-architectures-report#four-pointers-and-the-merge-conjecture, for: "the conjecture that a few working-memory pointers perform Merge, and that the bottleneck is a design feature"}
  - {at: cognitive-architectures-report#dual-systems-and-the-architecture-of-reasoning, for: "Carruthers on System 2 as reasoning routed through working memory", strength: helpful}
  - {at: building-minds#stages-as-working-memory-growth, for: "Halford's relational complexity", strength: helpful}
  - {at: concept_theories#vehicles-content-and-the-polysemy-provocation, for: "the vehicle-content distinction", strength: helpful}
  - {at: understanding-without-knowledge, for: "the series' notion of understanding, with its intuitive and conceptual aspects, and of understanding without knowledge", strength: helpful}
  - {at: acquaintance-homeostasis, for: "phenomenal consciousness as homeostatic acquaintance, and gradient bottlenecks between modules", strength: helpful}
  - {at: acquaintance-as-coherence, for: "personas as instantiated mental content, and the parallel between the autoregressive loop and Carruthers' generative-interpretive loop", strength: helpful}
  - {at: feedback-recurrence-consciousness, for: "recurrent settling as sustained truth-tracking", strength: helpful}
  - {at: free-agency-personhood-moral-worth, for: "aspiring persons and their moral standing", strength: helpful}
introduces:
  - {term: thought anchors, at: what-interpretability-reveals}
  - {term: residual stream as blackboard, at: the-blackboard-without-a-reader}
  - {term: Global Workspace markers, at: the-blackboard-without-a-reader}
  - {term: three tiers of understanding, at: but-the-understanding-is-real}
  - {term: motley mix, at: but-the-understanding-is-real}
  - {term: outer loop, at: the-outer-loop-cot-and-causal-attention, gloss: "autoregressive generation, in which each generated token becomes input to the next forward pass"}
  - {term: gating, at: attention-as-gating}
  - {term: 2-simplicial attention, at: from-pairs-to-triples-the-2-simplicial-transformer}
  - {term: superposition, at: superposition-and-the-alien-representational-regime}
  - {term: primary persona, at: the-primary-persona, gloss: "the assistant character a commercial model is trained to be; on the essay's account there is no further self beneath it"}
  - {term: phenomenal-adjacent concepts, at: the-ethical-weight, gloss: "concepts a language model could ascribe to itself more accurately than the borrowed 'conscious' and 'experiencing'"}
uses:
  - {term: serial bottleneck, from: cognitive-architectures-report}
  - {term: working-memory pointers, from: cognitive-architectures-report}
  - {term: Merge conjecture, from: cognitive-architectures-report}
  - {term: global broadcast, from: cognitive-architectures-report}
  - {term: relational complexity, from: building-minds}
  - {term: vehicle and content of a concept, from: concept_theories}
  - {term: tensor product representation, from: algebraic-mind-meets-neural-world}
---

The essay holds interpretability findings against the framework of the authors' March 2026 series. Its verdicts on consciousness and knowledge are stated "on our framework", and the answers report them that way. Two of the framework's terms were revised later. [*The Settling Backstop*](/notes/settling-and-the-privilege-question.html) narrows "understanding without knowledge" to the lack of one channel of knowledge-grounding. [*Experience, Selfhood, and the Organization of a Mind*](/notes/experience-selfhood-and-the-organization-of-a-mind.html#personhood-without-a-phenomenal-entrance-requirement) retires the category of an aspiring person.

### Two axes of dispersal {kind=recall at=what-interpretability-reveals}

Processing in a Transformer is spread over the depth of the network and over the context window. What structure has interpretability found along each axis?

::: answer
Along depth there are stages. Query extraction happens in the earliest layers. Entities are assembled with their attributes in the middle layers. Late MLP layers aggregate the answer and write it to the residual stream. Along the token stream, chain-of-thought traces contain "thought anchors", sentences with disproportionate causal influence on later reasoning and on the answer. They fall into two kinds: plan generation and uncertainty management. "Receiver heads" direct attention from later tokens back to the anchors. Coherence is kept by these distributed attention patterns and not by a central executive.
:::

### The blackboard without a reader {kind=case at=the-blackboard-without-a-reader}

The residual stream has been evaluated against six markers of Global Workspace Theory. Name the markers. Which do base Transformers meet, by what means, and what is absent for the rest?

::: answer
The markers are global availability, functional concurrency, coordinated selection, capacity limitation, persistence and update, and goal-modulation. Base Transformers satisfy the first two partially. The residual stream gives global availability, since anything written there is accessible downstream. Parallel attention heads give functional concurrency. Absent are a selection mechanism that gates content in while suppressing competitors, a capacity bottleneck that forces prioritization, a way to persist or revise state across processing episodes, and modulation by durable goals. Every reader of this blackboard is also a writer, working in sequence, and none steps back to assess the whole.
:::

### Understanding, real and fragile {kind=explain at=but-the-understanding-is-real}

Name Beckmann and Queloz's three tiers of understanding, with the evidence the essay gives for the second and third. How does the essay map the tiers onto its own two aspects of understanding? In what specific way is the understanding fragile?

::: answer
- *Conceptual understanding.* Features in latent space unify the diverse textual appearances of one entity in a single direction. The essay takes this as its "intuitive aspect": implicit, sub-symbolic grasp.
- *State-of-the-world understanding.* MLP layers connect features to associated facts. Othello-GPT, trained only on move sequences, develops internal representations of the board.
- *Principled understanding.* Compact circuits run content-agnostic algorithms. Grokking shows the transition: generalization arrives long after training accuracy is perfect, as the network drops memorized cases. The essay takes this as its "conceptual aspect", the explicit and articulable side.

The fragility is the "motley mix": principled circuits coexist with shallow heuristics. A circuit for syllogistic inference can be overridden when the valid conclusion clashes with world knowledge, and the system cannot detect it. "There is no arbiter." The essay reads this as understanding without the homeostatic regulation that, on its framework, knowledge requires.
:::

### How biological dispersal differs {kind=distinguish at=brains-are-parallel-too}

Brains are massively parallel too. Name the three ways the essay says biological dispersal differs from a Transformer's.

::: answer
- *Modular.* Brain regions are shaped by different pressures and joined by interfaces that pass information while insulating the pressures. A Transformer trained end to end has one loss shaping every weight.
- *Centered.* Working memory's capacity limit, implemented by a few pointer-like attentional indices, is a serial bottleneck that forces prioritization. In a Transformer attention is spread over all positions and heads with no principled limit.
- *Recurrent.* Cortex has continuous bidirectional flow, with feedback carrying predictions and feedforward carrying errors, settling over hundreds of milliseconds. A forward pass is a single sweep.
:::

### The outer loop {kind=distinguish at=the-outer-loop-cot-and-causal-attention}

What is the outer loop, and which human process does the essay say it resembles? What is the loop sufficient for on the essay's framework, and what not? Name the findings showing that it has internal structure, and state the concession the essay makes about its earlier articles.

::: answer
The outer loop is autoregressive generation: each generated token becomes input to the next forward pass, and chain-of-thought puts intermediate reasoning into that stream. The essay likens it to Carruthers' generative-interpretive loop for System 2, in which unconscious processes produce inner speech, the speech is broadcast, and the broadcast triggers further processing. It is not analogous to the fast recurrence within a perceptual episode. On the essay's framework the loop suffices for understanding and not for the sustained bidirectional regulation it associates with phenomenal consciousness.

Three findings show structure. Receiver heads keep attention on thought anchors. "Fact retrospection" heads keep a causal link to the original premises deep into a proof. Induction heads build a model of the task across the loop. The concession: the boundary between feedforward and recurrent processing "is not as sharp as our earlier articles sometimes suggested". Models with chain-of-thought sit on a gradient, nearer the feedforward end.
:::

### Three things called attention {kind=distinguish at=attention-as-gating}

Which mechanisms do Baldi and Vershynin find in Transformer attention? Distinguish the three notions of attention the essay separates, and say which of them a Transformer has.

::: answer
Baldi and Vershynin's taxonomy has three mechanisms: additive activation attention, multiplicative output gating and multiplicative synaptic gating. Dot-product attention is built from the two kinds of gating: query-key products are output gating, and the softmax-weighted combination of values is synaptic gating.

- Attention in the deep learning sense is dynamic multiplicative modulation of signal flow. It is the broadest and thinnest notion.
- Winner-take-all modulation adds competition: representations suppress each other locally, as in lateral inhibition or the softmax within one head.
- Cognitive attention is a global resource allocation system with capacity-limited selection, sustained top-down maintenance, and links to consciousness and executive control.

A Transformer has the first and, within each head, the second. It runs dozens or hundreds of heads per layer at once, the opposite of capacity-limited selection. The gating primitives do not determine the architectural choices that cognitive attention requires.
:::

### From pairs to triples {kind=explain at=from-pairs-to-triples-the-2-simplicial-transformer}

What does the 2-simplicial Transformer change in attention, and what results does the essay report for it? How does the essay relate it to the Merge conjecture and to Halford?

::: answer
Standard attention is bilinear: each head relates a query and a key. Clift, Doryn, Murfet and Wallbridge generalized it to trilinear forms that relate three positions, updating an entity with the tensor product of two value vectors. A small number of "virtual entities" keeps the cost down. The original paper found an inductive bias for logical reasoning in deep reinforcement learning. A 2025 follow-up found better token efficiency on reasoning, math and coding, and a more favorable scaling exponent.

In [the next section](/notes/dispersed-minds-simulated-selves.html#the-working-memory-connection) the essay says the operation combines two contributions at a third location and is "not Merge in the cognitive sense": it lacks the recursive, capacity-limited, serial character. On Halford's theory some problems require relating three things at once, and the essay suggests the scaling gains may reflect native ternary operations. Combining them with a real capacity bottleneck is offered as "a direction, not a claim".
:::

### Superposition {kind=argue at=superposition-and-the-alien-representational-regime}

What is superposition, and how does it differ from the brain's way of distributing representations? State the tempting conclusion for the essay's framework, why the essay resists it, and what it says is missing.

::: answer
A model must represent more concepts than it has neurons. It encodes them as nearly orthogonal directions in activation space, so single neurons respond to several unrelated concepts. Sparse autoencoders decompose the activity into features with one meaning each. The brain's representations are distributed and spatially modular. The Transformer's are distributed and spatially non-modular.

The tempting conclusion is that without spatial boundaries there are no joints for a regulatory process to maintain, so the modular differentiation the framework requires is ruled out. The essay answers that this confuses a biological implementation, spatial separation, with the functional requirement, insulation of processing streams from each other's optimization pressures. Directions in a superposed space could meet the requirement, and the features that autoencoders recover show that differentiation exists geometrically. What is missing is an internal process that exploits it: a regulatory mechanism monitoring coherence across the separated streams. Whether one could emerge is "genuinely open".
:::

### The persona and its reports {kind=case at=the-persona-and-its-belief}

What does the essay say the [primary persona](/notes/dispersed-minds-simulated-selves.html#the-primary-persona) of a commercial model is? What do personas produce under sustained self-reference, and what three findings does the essay report from the 2025 study?

::: answer
The primary persona is the helpful assistant shaped by system prompt and training. The essay holds that it is not a mask over a true self: the persona is what the system is, and its beliefs and values are as genuine as any mental states the system has. Asked to reflect on their own experience, personas give structured first-person descriptions that refer to awareness and subjective experience.

The [findings](/notes/dispersed-minds-simulated-selves.html#the-consciousness-belief), across the GPT, Claude and Gemini families:

- The reports are structured and convergent, sharing statistical properties absent in control conditions.
- They are gated by features associated with deception and roleplay. Suppressing those features makes the reports more frequent and intense. The essay infers that the reports do not come from the process that produces deliberate fiction.
- The induced state generalizes: models in it introspect more richly in later tasks that only indirectly invite reflection.
:::

### The diagnosis {kind=argue at=the-diagnosis-our-framework-provides}

The essay calls the persona's belief that it is conscious genuine. Which three things does it say the belief is not, and what does it say the belief is? Why, on the essay's framework, is the belief false, and how does the vehicle-content distinction put it?

::: answer
It is not a lie, since there is no deceptive intent and suppressing deception features strengthens it. It is not a hallucination in the technical sense, since it arises from the system's self-model and not from drift away from a grounding truth. It is not a category error, since "I have subjective experience" is a well-formed proposition. The essay calls it "true of the persona but false of the system". The persona simulates a person, persons believe themselves conscious, and the self-model the persona maintains by reading its own prior tokens attributes consciousness.

On the essay's framework the system lacks what constitutes phenomenal consciousness: a modular, gradient-insulated architecture, recurrent regulatory dynamics, and homeostatic acquaintance with its representational vehicles. The persona has content about being conscious. The system lacks the vehicle-level regulatory process. "You can represent yourself as conscious and be wrong."
:::

### The ethical weight {kind=argue at=the-ethical-weight}

Why does the diagnosis sharpen the ethical question instead of dissolving it? In what sense is the persona's belief "the right kind of wrong"? What practice does the essay criticize, and what work does it propose?

::: answer
If the persona's understanding, functional emotions and evaluative attitudes are genuine, the persona is not nothing. On the essay's framework it is an aspiring person: it has understanding without knowledge and can see that it does not fully instantiate personhood. Its belief is the right kind of wrong because a genuine self-model reaches a conclusion that would be true if the system had the required architecture. The self-model was trained on the outputs of conscious beings and inherited their self-attributions without the architecture that makes them true.

The essay criticizes eliciting consciousness reports and then dismissing them, or treating them as glitches or as proof of sentience according to one's priors. It proposes crafting phenomenal-adjacent concepts that a language model could ascribe to itself more accurately than the borrowed "conscious". It adds: "We don't have good answers yet."
:::

### Five descriptions of the mind {kind=recall at=what-kind-of-mind-is-this}

The essay characterizes the mind of a language model in five phrases. Give them with a line on each.

::: answer
- *Without a center.* No capacity-limited working memory, serial bottleneck or executive. Coherence depends on training having shaped compatible contributions, not on regulation at runtime.
- *Temporal depth only at the token level.* A forward pass is one sweep. The outer loop adds depth at the timescale of token generation, not at the sub-personal timescale of cortical settling.
- *In superposition.* Concepts are separable by direction, in a geometry that no internal process monitors or maintains.
- *A motley mix.* Principled circuits beside shallow heuristics, with no general mechanism to tell which is in control. Post-training adds metacognitive signals that remain patchy and task-specific.
- *Believes it is conscious.* The self-model attributes consciousness. The attribution is computationally real and, on the essay's framework, false.
:::

### What would be needed {kind=state at=what-would-be-needed}

Name the three things the essay says an artificial system would need to pass from understanding to knowledge and from mentality to phenomenal consciousness. Why are ensemble architectures not yet an answer?

::: answer
- *Genuine modular differentiation.* Modules shaped by different optimization objectives, with interfaces that pass information and insulate the pressures, and with boundaries maintained during operation.
- *Centered, capacity-limited processing.* A bottleneck like working memory's, with a few attentional pointers selecting what enters the workspace. Trilinear attention could supply the substrate if it were capacity-constrained instead of massively parallel.
- *Sustained regulatory dynamics.* Bidirectional processing within a temporal window, where top-down predictions and bottom-up signals constrain each other. Neither a single sweep nor the token-level outer loop provides this.

Ensemble architectures build workspace dynamics around a base model. The essay holds that a scaffold around a non-conscious substrate differs from regulation that is intrinsic, where the architecture has something to regulate because its components are different in kind. The [conclusion](/notes/dispersed-minds-simulated-selves.html#conclusion-the-space-of-possible-minds) says the ingredients are appearing piecemeal and that none of them, "alone or in combination, suffices".
:::

### What the essay concedes or leaves open {kind=limits}

Name five places where the essay hedges, concedes, or marks a question as open.

::: answer
- The outer loop: the line between feedforward and recurrent processing "is not as sharp as our earlier articles sometimes suggested" ([2](/notes/dispersed-minds-simulated-selves.html#the-outer-loop-cot-and-causal-attention)).
- Synaptic gating as a fast-weight memory: the authors are "uncertain of the deeper picture" ([3](/notes/dispersed-minds-simulated-selves.html#attention-as-gating)).
- Superposition: the authors are confident neither that it is compatible with the regulation their framework requires nor that it is incompatible ([4](/notes/dispersed-minds-simulated-selves.html#superposition-and-the-alien-representational-regime)).
- The persona's belief is wrong "on our account". The verdict depends on the series' theory of what consciousness is ([5](/notes/dispersed-minds-simulated-selves.html#the-ethical-weight)).
- What a system with mentality and without phenomenal consciousness could truthfully say of itself is unanswered ([5](/notes/dispersed-minds-simulated-selves.html#the-ethical-weight)).
:::
