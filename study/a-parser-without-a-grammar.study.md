---
title: "Study notes: A Parser Without a Grammar"
essay: a-parser-without-a-grammar
track: structure-in-networks
reviewed-against: "4683b65"
requires:
  - {at: merge_and_selection#the-residual-stream-is-a-join-not-a-rewrite, for: "the residual stream as a monotone merge, and the split into target, sources and MLP"}
  - {at: merge_and_selection#why-the-two-analogues-cannot-be-reconciled, for: "the fracture: the selector is not in the value space"}
  - {at: merge_and_selection#tensor-product-representations-and-gradient-symbolic-computation, for: "Harmony, the quantization weight q and the temperature T"}
  - {at: the-given-and-the-found#depth-and-breadth-are-two-knobs-not-one, for: "depth and breadth as separate instruments of test-time computation, and the limit cycle"}
  - {at: the-given-and-the-found#the-boundary-amortizing-search-versus-amortizing-discovery, for: "the line between amortizing search under a given condition and discovering the condition"}
introduces:
  - {term: formalisms as coordinates, at: the-wrong-question, gloss: "each grammatical tradition fixes one axis of design, and the architecture's position on each axis is read off; none is a candidate for being the Transformer's grammar"}
  - {term: Merge-without-Move, at: monotonicity-hpsg-and-the-rewrite-grammar-at-the-far-pole, gloss: "combination that only adds, with no operation that relocates or deletes"}
  - {term: un-bundling, at: directionality-ccg-and-the-head-the-join-throws-away, gloss: "the architecture runs as separate mechanisms the design choices that a formalism's single combinatory operation fuses"}
  - {term: collapse of strata, at: strata-lfg-and-the-conflation-of-position-with-function, gloss: "positional and functional information superimposed in one residual stream"}
  - {term: grammar as process, at: time-dynamic-syntax-and-the-grammar-that-is-a-parser}
  - {term: lexicon-grammar continuum as feature continuum, at: inventory-construction-grammar-and-what-lives-in-the-weights}
  - {term: operator/operand split, at: topology-word-grammar-and-the-grammar-that-is-an-activation-network, gloss: "abstractions live in the weights, which act on the activations and carry none; activation rides only token positions"}
  - {term: override as additive cancellation, at: topology-word-grammar-and-the-grammar-that-is-an-activation-network}
  - {term: parser without a grammar, at: the-shape-of-the-answer, gloss: "structure without a discrete, stored, declarative grammar object"}
uses:
  - {term: monotone merge, from: merge_and_selection}
  - {term: query as valence specification, from: merge_and_selection}
  - {term: the selector is not in the value space, from: merge_and_selection}
  - {term: gradient blend, from: merge_and_selection}
  - {term: Harmony and scheduled quantization, from: merge_and_selection}
  - {term: depth and breadth, from: the-given-and-the-found}
  - {term: limit cycle as terminal behavior, from: the-given-and-the-found}
  - {term: correctness condition, from: the-given-and-the-found}
  - {term: amortizing search versus amortizing discovery, from: the-given-and-the-found}
---

The answers state what the essay argues. Several mappings are the essay's own and are marked so; the last question asks what it says it has not shown.

### The wrong question {kind=explain at=the-wrong-question}

Which question about Transformers and grammar does the essay retire, and what does it ask instead? What does the audiobook study of Stanojević and colleagues add to the case?

::: answer
The retired question is which grammatical formalism the Transformer secretly implements. Probing shows that structure is recoverable from hidden states, and is silent on what operation produced it. Stanojević and colleagues found that structure-building metrics from a CCG parser explain brain activity over and above the next-word predictability estimated by a Transformer, and that the two effects sit in different places. The lesson the essay takes is that structure-building and predictability are different functions, so a model can excel at the second while the first stays a separate question. In place of the retired question, the formalisms are read as a coordinate system. They disagree along identifiable axes, each disagreement is a design decision, and the architecture comes down somewhere on each. No single formalism shares all its coordinates, because each bundles choices the architecture pulls apart.
:::

### Merge without Move {kind=distinguish at=monotonicity-hpsg-and-the-rewrite-grammar-at-the-far-pole}

Transformational grammar anchors the far pole of the monotonicity axis. Why would it be wrong to say that Merge puts it there? How does a Transformer achieve what movement achieves?

::: answer
Bare Merge is monotone set-formation: it takes two objects and forms the set containing them, adding structure and removing none. It sits near the residual stream's pole. The destructive end is anchored by Internal Merge, that is movement, together with deletion and trace: the operations that displace and erase. The architecture's monotonicity is "a vote for Merge-without-Move". Where a transformational grammar would move a constituent and leave a gap, the Transformer can only write another vector into the stream. Displacement is achieved by addition, not relocation.
:::

### Application consumes the functor {kind=derive at=directionality-ccg-and-the-head-the-join-throws-away}

A transitive verb has the category `(S\NP)/NP`. Combine it with its object and then with its subject. What happens to the functor at each step? Map functor, argument and slash onto attention, and say whose reading this is.

::: answer
Given an `NP` to its right the verb yields `S\NP`. Given an `NP` to its left that yields `S`. At each step the functor is consumed: `(S\NP)/NP` is gone, discharged into the result, which is what it means for the slash to cancel. On the attention side, the query is a function seeking an argument of a certain type. The key advertises the type of argument a position can serve as. Attention is the application of one to the other. The slash direction is the directional signature that attention has and a symmetric join lacks. The TP-Transformer's authors already read an attending cell as a subject querying for an object. The sharpening through CCG, with application's non-monotonicity, is the essay's own mapping.
:::

### Why one operation must bundle {kind=argue at=directionality-ccg-and-the-head-the-join-throws-away}

CCG repairs HPSG's defect and incurs the opposite one. State both defects. Then reconstruct why a discrete operation that builds a constituent must bundle the two choices, and why the Transformer need not. Which formalism escapes, and at what price?

::: answer
HPSG's join is commutative, $A\sqcup B=B\sqcup A$. It merges descriptions without governance, so it is monotone and headless. CCG's application is directional and not monotone: it wins directionality and loses accumulation. A discrete operation that builds a constituent takes its step at one point and cannot be two things there. Its single `combine` is either symmetric and monotone or directional and consuming. In the Transformer the two are different mechanisms at different sites: the query/key inner product is directional, and the residual write is monotone. Each formalism therefore matches the architecture on one axis and misses on the other. Word Grammar escapes by drawing relations instead of building constituents, and pays by having no constituents at all.
:::

### One stream, two strata {kind=explain at=strata-lfg-and-the-conflation-of-position-with-function}

What are LFG's two structures, and why does it keep them apart? What is the Transformer's coordinate on this axis, what does the essay read as evidence, and how does this case run the other way from the CCG case?

::: answer
C-structure is a constituency tree encoding precedence and dominance. F-structure is an attribute-value matrix of grammatical functions, monotone and unification-based. A correspondence $\phi$ says which tree nodes project which parts of the functional structure. LFG keeps them apart because position and function need not line up within one sentence: a fronted *which book* sits high in the tree and bears the object function of an embedded verb, and a dropped subject is a function with no tree position. The Transformer has one residual stream, so its coordinate is collapse. The essay reads the hybrid roles induced by the Tensor Product Generation Network, neither purely positional nor purely grammatical, as the two strata superimposed on one vector. Here the architecture bundles what a formalism keeps separate. It is not uniformly a splitter: "fusing where the formalisms split and splitting where they fuse".
:::

### Incremental in two senses {kind=distinguish at=time-dynamic-syntax-and-the-grammar-that-is-a-parser}

CCG and Dynamic Syntax are both incremental. What does Dynamic Syntax do that CCG does not? What corresponds to it in a causal Transformer, and which bundled pair comes apart?

::: answer
CCG remains a competence grammar with a separate notion of what is well-formed. Its incrementality is a property of how its derivations can be ordered. Dynamic Syntax has no competence/performance split to be incremental within. The grammar is the procedure for building an interpretation word by word, strictly left to right, driven by requirements that later words discharge, and the state of the parse is in general underspecified. A causal Transformer also works left to right and cannot attend to the future. Its residual state is a blend of partial commitments, sharpened as computation proceeds. It stores no declarative grammar apart from the parser: the weights are the procedure. The pair that comes apart is "what is well-formed" and "the system has a stored characterization of well-formedness". The Transformer has the first without the second.
:::

### What lives in the weights {kind=state at=inventory-construction-grammar-and-what-lives-in-the-weights}

Construction Grammar's axis sits at a different level from the first four. Which level? State the two mappings the essay draws, the bundled pair that comes apart, and what the formalism and the mechanism agree about.

::: answer
The first four axes describe what a layer does to a representation as it passes through. This one describes what is stored in the parameters. For Construction Grammar the basic unit is the construction, a learned pairing of form and meaning at every granularity, and there is no separate rule component, only a continuum from the idiosyncratic to the schematic. The first mapping: the MLP layers, read in the interpretability literature as a key-value memory, store pairs of a pattern and a vector written in response, and such a pair is functionally a construction. The second: feature superposition admits every degree of specificity without a sortal boundary, so the lexicon-grammar continuum is the feature continuum. The generative tradition fuses productive combination with a rule component distinct from the listed lexicon; the Transformer has the first without the second. Formalism and mechanism agree about epistemology: grammatical knowledge is generalization over experienced instances.
:::

### Closest in form {kind=distinguish at=topology-word-grammar-and-the-grammar-that-is-an-activation-network}

Word Grammar's primitive object is the closest in form to the Transformer's. What is shared? Name the two independent differences.

::: answer
Both are activation networks over a weighted directed graph. An attention matrix is such a graph over positions, neither has phrase nodes, and both grow only by adding. Word Grammar holds that language is one network, processed by spreading activation.

*What bears the activation.* In Word Grammar the abstractions, such as the relation `subject` or the lexeme `BOOK`, are nodes that become active and fire into their neighbours. The store of knowledge and the medium of processing are one graph. In the Transformer activation rides only particulars, token positions. The abstractions live in the weights, an operator applied to the activations.

*What the substrate is made of.* Word Grammar's nodes are individuated and addressable, and each link carries its type. The architecture's are superposed directions, and an attention weight is a bare scalar with no label, something like the pre-quantized form of a typed dependency.
:::

### Inheritance without a hierarchy to consult {kind=explain at=topology-word-grammar-and-the-grammar-that-is-an-activation-network}

Default inheritance does two jobs. How does each cross into the architecture? How does the architecture's override differ from Hudson's, and what does that have to do with the monotonicity axis?

::: answer
Subsumption becomes geometry. Park and colleagues define the subordinate relation by token-set inclusion and prove that containment forces orthogonality: the parent feature's vector is orthogonal to the differences that distinguish its children, so inherited content lies in a shared parent direction. Word Grammar consults a hierarchy and copies a value down; the architecture arranges directions. Override becomes additive cancellation, which the essay reads into negative name-mover heads and suppression neurons. Hudson's inheritance is monotonic: the more specific value is simply the one inherited, so the default is never laid down and never retracted. The architecture writes the default and a cancelling term and forwards the sum, with the suppression clustered in the last layers. A strictly additive stream cannot retract. The non-monotonicity that exceptions need is bought by writing a vector that points the other way.
:::

### Two temptations {kind=object at=the-substrate-three-things-at-once-in-one-medium}

It is tempting to credit the continuous medium with un-bundling, and with holding incompatible structures at once. Why is each credit misplaced? What does the essay say is beyond the discrete side?

::: answer
Un-bundling is a factorization, not a blurring. Directionality lives in the query/key inner product and monotonicity in the residual write, two mechanisms at two sites, and that has nothing to do with continuity. A wholly discrete architecture running selection and accumulation as separate steps would un-bundle them too, and Word Grammar already does. The blend also has symbolic precedent: Dynamic Syntax holds a node's value open, chart parsers carry packed forests, and disjunctive feature structures hold alternatives in one description. What the discrete side lacks is the conjunction in one homogeneous medium. The axes are factored apart, each is held at a graded value, and the alternatives are superposed, all by a single repeated operation. Gradient Symbolic Computation is the theory of that medium, not a seventh formalism.
:::

### What blends and what un-bundles {kind=distinguish at=the-substrate-three-things-at-once-in-one-medium}

Is the blend a superposition of structures or of formalisms? Which two of the six coordinates are superpositions in the strict sense? What does the gradient blend have that Dynamic Syntax's underspecification lacks?

::: answer
Structures. The blend is a point in a representation space, and points can be convexly combined; no vector is half application and half unification. Two coordinates are superpositions in the structural sense. Word Grammar's unlabelled gradient link is a binding held at low $q$, not yet quantized to a typed dependency. LFG's collapsed strata are c-structure and f-structure superposed in one state. The axes coming apart is a different, non-metric fact about separate mechanisms: "What blends is parses under a fixed scheme; what un-bundles is the machinery." Dynamic Syntax's underspecification is a partial description over an enumerated set of completions, and the parse must end as one of them. The gradient blend answers to no discrete alternative and need never resolve.
:::

### Depth and breadth as schedules {kind=connect at=the-substrate-three-things-at-once-in-one-medium}

*The Given and the Found* separated depth from breadth as instruments of test-time computation. Map each onto a $(q,T)$ schedule of Gradient Symbolic Computation. Where does the limit cycle fall, and which part of the claim belongs to which source?

::: answer
Depth is iteration along a single trajectory, which entrenches whatever attractor has the state. It is the optimization regime: $T$ is driven to zero and the dynamics converge on the single maximum-Harmony structure. Breadth is restarts from many initializations, which keep several attractors alive. It is the sampling regime: $T$ is held and the result is a distribution over high-Harmony structures. The limit cycle, a trajectory that visits the valid readings in turn and commits to none, is the sampling regime realized in time instead of across restarts. So depth and breadth are one selection-plus-merge dynamics under two schedules, not two networks. The empirical separation of the knobs is the companion essay's; the single dynamics is GSC's.
:::

### Six corners and an interior {kind=recall at=the-shape-of-the-answer}

For each of the six axes, name the exemplar formalism and the Transformer's coordinate. What pattern runs across them, and what sense does it give the title?

::: answer
- Monotonicity: HPSG, with transformational grammar at the far pole. The stream only adds.
- Directionality: CCG. The query/key asymmetry, run as a mechanism separate from the monotone merge.
- Strata: LFG. One stream carrying position and function together.
- Time: Dynamic Syntax. Grammar as process, with no stored grammar.
- Inventory: Construction Grammar. A continuum of stored units, with no rule component.
- Topology: Word Grammar. A network and not a tree, without discrete typed links or reified abstractions.

Each formalism stakes out a corner by bundling choices, and the architecture's coordinates cut across every bundle, so it sits in the interior. A parser without a grammar is not a parser that lacks structure. It has no discrete, stored, declarative grammar object, only soft constraints learned into the weights. "The structure is real. What is missing is the commitment."
:::

### What this does not show {kind=limits at=what-this-does-not-show}

Name the four limits the essay sets on its own argument.

::: answer
- *Recoverability is not computation.* Every coordinate is a claim about what is represented in the stream, one step removed from what operation a layer performs. The hierarchy geometry is a theorem about the unembedding, and the inference to "the layers compute by inheritance" is one "we have not earned and do not claim".
- *Scope.* That geometry is demonstrated for lexical-semantic taxonomy and only conjectured to extend to grammatical categories.
- *Mappings of the essay's own.* CCG application as attention, Dynamic Syntax as causal decoding and suppression as override are offered as readings. A reader may reject any one and keep the thesis, which is the pattern of un-bundling.
- *A debt.* The coordinate system cannot locate where the correctness condition comes from. Every formalism, and GSC beneath them, presupposes a grammar that is given. Construction Grammar and Word Grammar name the outcome of learning and not the discovery. This is the boundary *The Given and the Found* drew between amortizing search over a given condition and amortizing the discovery of one.
:::
