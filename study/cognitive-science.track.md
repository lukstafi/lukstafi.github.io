---
title: "Across the track: Cognitive science for artificial minds"
track: cognitive-science
---

Questions whose answers draw on more than one essay. Attempt them after the last essay of the track.

### Two memory systems, three jobs {kind=connect}

Complementary Learning Systems theory enters in the architectures essay and returns in the development essay. Name three things the two essays use it to explain, one of them about the theories of concepts.

::: answer
- *One declarative memory or two.* The Standard Model had no consensus. The architectures essay answers two: semantic memory is the slow neocortical system and episodic memory the fast hippocampal one ([section 8](/notes/cognitive-architectures-report.html#hippocampal-systems-and-complementary-learning)).
- *Why the theories of concepts disagree.* The same section assigns prototype theory and the Bayesian program to slow neocortical learning, and exemplar theory and Prinz's proxytypes to hippocampal traces. Machery's heterogeneity then describes two complementary systems and not rival theories of one thing ([the survey of concepts](/notes/concept_theories.html#macherys-heterogeneity-challenge) states his thesis).
- *The pace of development.* A word is learned in one exposure because it fits existing schemas. Conservation and exact number take years because they contradict or outrun them, which is also why Carey's bootstrapping is slow. Drescher's schema mechanism has only one speed ([the development essay](/notes/building-minds.html#complementary-learning-systems-and-the-pace-of-development)).
:::

### Vehicle before content {kind=connect}

The distinction between a representation's vehicle and its content does work in three of the essays. Say what it is used for in each.

::: answer
- In the survey of concepts it comes from the polysemy experiments. An inference can run over a vehicle with no determinate referent, and Quilty-Dunn concludes that vehicle properties do the causal work ([there](/notes/concept_theories.html#vehicles-content-and-the-polysemy-provocation)).
- In the development essay it answers the circularity challenge to bootstrapping. A placeholder symbol has a syntactic position and inferential relations before it has content, so what must be explained is the building of a new computational role ([there](/notes/building-minds.html#the-circularity-challenge)).
- In the interpretability essay it frames the diagnosis of the persona's belief. The persona has content about being conscious, and the system lacks the vehicle-level regulatory process that the authors' framework takes to constitute consciousness ([there](/notes/dispersed-minds-simulated-selves.html#the-diagnosis-our-framework-provides)).
:::

### Four pointers through three essays {kind=connect}

The architectures essay conjectures that working memory is a few pointers performing Merge. Trace what the development essay and the interpretability essay each build on the conjecture.

::: answer
The [conjecture](/notes/cognitive-architectures-report.html#four-pointers-and-the-merge-conjecture): Merge combines what two pointers reference, re-attaches the result to one, and frees the other. Chunking has the same structure, and about four pointers is the minimum for useful recursion.

The development essay maps each pointer onto one Pascual-Leonean scheme or consolidated chunk. Conservation then needs four at once, and Case's efficiency is chunking that frees pointers ([4.3](/notes/building-minds.html#executive-function-and-conceptual-change)). Fast mapping is a Merge-like binding of a new symbol to a jointly attended referent ([8.3](/notes/building-minds.html#fast-mapping-and-the-tomasello-bridge)). Drescher's mechanism stalls for lack of a hub where such operations compose representations ([9.1](/notes/building-minds.html#what-dreschers-system-teaches)).

The interpretability essay finds no such bottleneck in a Transformer: attention has no capacity limit that forces prioritization ([2](/notes/dispersed-minds-simulated-selves.html#brains-are-parallel-too)). Trilinear attention is a richer primitive and not Merge, since it is neither serial nor capacity-limited ([3](/notes/dispersed-minds-simulated-selves.html#the-working-memory-connection)). Centered, capacity-limited processing is one of the three things the essay says a conscious artificial system would need ([6](/notes/dispersed-minds-simulated-selves.html#what-would-be-needed)).
:::

### What a language model is missing {kind=connect}

Each of the four essays ends by naming something language models lack and a weakness that may follow. Give the four. Which finding does the architectures essay introduce early and the interpretability essay rely on?

::: answer
- *Concepts.* A foundation of experiential and agentive primes, and perceptual calibration of processing. The truth-preserving character of abstract reasoning "may be more fragile than it appears" ([synthesis](/notes/concept_theories.html#synthesis-questions-for-artificial-minds)).
- *Architectures.* Global evaluative modulation, "the homeostatic self-regulation that emotion implements" ([5.4](/notes/cognitive-architectures-report.html#emotion-as-architectural-modulation)). Also persistent memory, grounding, and the deliberate reasoning that a serial bottleneck enables ([7.2](/notes/cognitive-architectures-report.html#the-challenge-from-large-language-models)).
- *Development.* The developmental process itself, inherited only secondhand through text. The resulting representations may be "subtly different in ways that matter under pressure" ([9.2](/notes/building-minds.html#the-developmental-desideratum)).
- *Interpretability.* A center, sustained regulatory dynamics, and modules shaped by different objectives. No process detects when a heuristic overrides a principled circuit ([6](/notes/dispersed-minds-simulated-selves.html#what-kind-of-mind-is-this)).

The shared finding is the "motley mix" of principled circuits and shallow heuristics. The architectures essay cites it when discussing Sigma's appraisals, as a point needed later. The interpretability essay gives it as the mechanism of the fragility.
:::

### Development in children and in training {kind=connect}

The interpretability essay draws on developmental psychology twice. Which idea from the development essay does it apply to attention, and which parallels does it draw for training? Where does it say the parallel stops, and how does that agree with the development essay's conclusion about architecture?

::: answer
It applies Halford's relational complexity, which the development essay uses to redescribe [Piaget's stages](/notes/building-minds.html#stages-as-working-memory-growth). Some problems need three things related at once, so an architecture with native ternary attention may outperform one that chains pairwise operations ([3](/notes/dispersed-minds-simulated-selves.html#the-working-memory-connection)).

For training it reports phase transitions: sudden jumps in capability separated by plateaus. Induction heads develop from literal pattern-matchers to more abstract heads, which the essay compares to sensorimotor schemes bootstrapping conceptual thought ([6](/notes/dispersed-minds-simulated-selves.html#developmental-interpretability-and-phase-transitions)).

The parallel stops at modularity. In biology the gene bottleneck has evolution specify the architecture while learning fills in each module, so modules stay insulated from each other's pressures. In training one loss shapes every weight: "Development happens, but within a monolithic optimization." The development essay's [conclusion](/notes/building-minds.html#conclusion-the-ship-rebuilt-at-sea) says the same of children from the other side: working-memory capacity, the bottleneck and the modular organization are what maturation builds, not what learning produces.
:::
