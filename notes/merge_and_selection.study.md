---
title: "Study notes: Merge and Selection"
essay: merge_and_selection
track: structure-in-networks
reviewed-against: "4683b65"
requires:
  - {at: algebraic-mind-meets-neural-world#technical-sidebar-smolenskys-tensor-product-representations, for: "fillers, roles, binding by tensor product and unbinding by inner product"}
  - {at: algebraic-mind-meets-neural-world#attention-as-approximate-tpr-unbinding, for: "attention read as approximate unbinding, and Smolensky's complaint that the attention graph is used within a layer and not encoded"}
  - {at: the-given-and-the-found, for: "looped and equilibrium models, which this essay calls the architecturally interesting case", strength: helpful}
introduces:
  - {term: monotone merge, at: the-residual-stream-is-a-join-not-a-rewrite, gloss: "the residual stream only adds, so it builds structure as a constraint grammar joins descriptions, not as a rewrite grammar replaces symbols", related: ["Merge-without-Move", "residual stream as blackboard", "override as additive cancellation"]}
  - {term: "target directs, sources supply, MLP assembles", at: the-residual-stream-is-a-join-not-a-rewrite, gloss: "the three-way split of what unification does in one structure-driven step", related: ["un-bundling", "the selector is not in the value space"]}
  - {term: query as valence specification, at: two-analogues-the-query-selects-the-stream-merges, gloss: "the query says what a position seeks, as a head's valence list says what it must combine with", related: ["un-bundling"]}
  - {term: Harmony and scheduled quantization, at: tensor-product-representations-and-gradient-symbolic-computation, related: ["Gibbs state", "depth and breadth", "limit cycle as terminal behavior"]}
  - {term: gradient blend, at: tensor-product-representations-and-gradient-symbolic-computation, gloss: "a single continuous state superposing partial structures, not a probability distribution over parses", related: ["grammar as process", "collapse of strata"]}
  - {term: binding problem of stacked attention, at: the-explicit-binding-program, related: ["missing selection relation and bag problem"]}
  - {term: the selector is not in the value space, at: why-the-two-analogues-cannot-be-reconciled, gloss: "the query drives each combination and is never among the vectors the merge sums"}
  - {term: missing selection relation and bag problem, at: why-the-two-analogues-cannot-be-reconciled, gloss: "the two manifestations of the selector's exclusion: no record of which position governed, and no record of which daughter paired with which"}
uses:
  - {term: tensor product representation, from: algebraic-mind-meets-neural-world}
  - {term: attention as approximate unbinding, from: algebraic-mind-meets-neural-world}
  - {term: generations of neurocompositional computing, from: algebraic-mind-meets-neural-world}
---

The answers state what the essay argues. It separates what it takes from prior work from what it adds, and it offers the additions as conjectures. The last question asks where it says so.

### Present or built {kind=distinguish at=introduction}

A probe recovers a parse tree from the hidden states at layer eight. What does that establish, and what does it leave open? Which question does the essay ask instead, and which fact about the architecture does it call the most determining?

::: answer
The probe establishes that the information is present at layer eight. It does not establish that any layer built the tree by an operation a syntactician would recognize, any more than recovering a temperature from a column of mercury means the mercury computed one. The essay asks whether the core update, attention plus residual addition iterated over layers, is itself a grammatical operation, apart from whether the trained weights have absorbed syntax. The determining fact is that the residual stream is never overwritten, only added to.
:::

### HPSG's two principles {kind=state at=hpsg-in-one-page}

Give the three commitments of HPSG the essay uses. Which two principles are load-bearing, what job does each do, and why do they coexist without tension in HPSG?

::: answer
HPSG is lexicalized: a few schemata combine with a rich lexicon whose entries say what each word requires. Its objects are feature structures combined by unification, which yields the least structure consistent with both inputs and fails on contradictory values. Its Head Feature Principle makes a headed phrase share its head value with its head daughter, and the head selects its arguments through a valence list. Unification says how parts combine. The Head Feature Principle says which part governs. They coexist because headedness is a property of a combination: when daughters combine, exactly one is the head, fixed by the schema and the lexical entries. A Transformer has no notion of "the combination", only positions that all merge at once.
:::

### What headedness costs {kind=compute at=the-neural-hpsg-parser-and-what-its-cost-reveals}

Decoding one tree form alone is $O(n^3)$. Joint decoding that respects the Head Feature Principle is $O(n^5)$. By what factor does each grow when a sentence doubles in length? What brings the joint cost back to $O(n^3)$, and what does the essay take from this?

::: answer
$2^3=8$ and $2^5=32$. A dedicated head scorer brings the cost back, because headedness need no longer be recomputed combinatorially at every span. The essay's lesson is not about efficiency. Headedness is expensive because it is a choice made per combination: for each way of splitting a span, the grammar must decide which sub-span projects. It is also relational and directional. The head of a phrase is a dependency modifier for words outside the span and a dependency head for words inside it.
:::

### Two regimes of one dynamics {kind=compute at=tensor-product-representations-and-gradient-symbolic-computation}

Total Harmony is $\mathcal H_q=H+qQ$. Say what $H$ and $Q$ are, and why adding $qQ$ leaves the ranking of discrete candidates alone. Two discrete structures have $H=2$ and $H=0$. What does the optimization regime return? With what probabilities does the sampling regime return each at $T=1$ and at $T=0.5$? Is a blend a distribution of this kind?

::: answer
$H$ is the grammatical Harmony, a sum of weighted soft-constraint satisfactions, whose maximum is in general a blend. $Q$ is the quantization Harmony: zero on the grid of fully discrete states and negative off it, so it penalizes every non-discrete state and leaves the discrete candidates' relative Harmony unchanged. In the optimization regime $q$ is held and $T$ is cooled to zero, and the dynamics converge to the global maximum, here the structure with $H=2$. In the sampling regime $T$ is held and $q$ goes to infinity, and the grid points are sampled with probability proportional to $e^{H/T}$: about $0.88$ and $0.12$ at $T=1$, about $0.98$ and $0.02$ at $T=0.5$. A blend is not such a distribution. It is one point in the continuous space, the instantaneous state of a single run. The Boltzmann distribution describes the discrete outputs across runs.
:::

### The bag of fillers {kind=derive at=the-explicit-binding-program}

In one layer cell $a$ attends to $b$ and cell $c$ attends to $d$. A higher cell attends to both. Show that the residual sum cannot tell $(a/b)/(c/d)$ from $(a/d)/(c/b)$, and say why a value carries no trace of its pairing. In which architecture is the collapse exact?

::: answer
The sum is $z_a+z_c+o(v(z_b))+o(v(z_d))$. Swapping $b$ and $d$ between the two attending cells yields the same four summands, so the same vector. The value $v_j=W_Vx_j$ is a function of the source alone and carries no trace of the key it matched. The weighted sum scales each value and discards the routing, which leaves a bag of fillers. The collapse requires that the swapped fillers pass through identical maps. In a stacked Transformer each layer has its own projections, so the depth at which a filler was merged acts as an implicit timestamp, a crude positional role that partly breaks the symmetry. In a looped or weight-tied Transformer every iteration applies the same projections, and the collapse is exact.
:::

### A join, not a rewrite {kind=argue at=the-residual-stream-is-a-join-not-a-rewrite}

From the update $h_i^{\ell+1}=h_i^{\ell}+\mathrm{Attn}_i(h^{\ell})+\mathrm{MLP}(\dots)$, argue that the Transformer belongs with the constraint grammars. Does the essay claim HPSG is the closest grammar? Give the three features that make HPSG the exemplar to start from.

::: answer
The leading $h_i^\ell$ means the stream is never overwritten. A rewrite rule $A\to B\,C$ consumes $A$, so rewriting destroys its input, and the stream cannot work that way. Monotonicity therefore excludes the rewrite tradition and places the architecture in the constraint-grammar family, which builds a structure by adding constraints that never retract. That is a claim about a family, which includes HPSG, LFG and Word Grammar. The essay does not claim HPSG is closest. It starts from the most prominent member, with a sharp two-principle structure, so that the place where it fails to fit is diagnostic. Three features recommend it: a residual vector is a bundle of features and not an atomic category label; one schema applies everywhere and the content sits in learned per-token representations; and combination is non-local.
:::

### Product without engine {kind=distinguish at=the-residual-stream-is-a-join-not-a-rewrite}

The residual merge falls short of unification in two ways. Name each, and say which one Gradient Symbolic Computation repairs.

::: answer
First, unification is exact and can clash: `[NUM: sg]` with `[NUM: pl]` fails. Attention returns a convex combination of values, always defined. GSC repairs this by replacing hard constraints with weighted soft ones, so that a clash becomes a state of low Harmony, dispreferred and still defined. The blend is then the design, and the Transformer reads as a Harmonic Grammar parser with learned constraints. Second, in unification the structures drive their own combination and constitute its result. The Transformer splits this into three. The target's query directs the gather and does not enter the sum. The sources supply the material. The MLP assembles the structure from what was gathered. GSC does not dissolve this: the Transformer has unification's product without its engine.
:::

### The query as valence {kind=state at=two-analogues-the-query-selects-the-stream-merges}

State the selection analogue as a mapping from HPSG onto queries, keys and values. What grounds it independently of the merge analogue? Then put the two analogues side by side.

::: answer
The query is a valence specification: as a head's `ARG-ST` list says what it must combine with, the query says what the position seeks. Attention is the head selecting its arguments and binding to them in proportion to fit. The key advertises what kind of thing a position is for selection purposes, and the value carries the content it contributes once selected. Two groundings are cited. The TP-Transformer's authors read attention as a subject querying for an object. The neural HPSG parser's biaffine scorer scores head-modifier pairs with the same bilinear form that attention uses. Side by side: the residual write is the merge, HPSG's unification principle; the query/key inner product is the selection, HPSG's head-projection principle.
:::

### Where the fracture is not {kind=object at=why-the-two-analogues-cannot-be-reconciled}

Parallelism, the softness of attention and the additive merge each look like the reason the two analogues cannot be one. Why is none of them the fracture? Does causal masking supply the unique head?

::: answer
Parallelism reconciles: a chart parser builds at each stage every edge it can from the edges present, so a layer is a stage of parallel parsing and depth is the succession of stages. Softness is remediable: a soft mixture of candidate daughters is a blend before quantization, which the GSC machinery resolves as the effective $q$ rises. Addition is not the culprit either. A sum can carry a binding if its summands are tagged, and with the selector among the summed values the directional asymmetry of query-key strengths would come through. Causal masking helps at one point: the final position of a decoder is a privileged merge destination, and there the selection reading recovers a unique head. The other $n-1$ positions each remain head and dependent in superposition. In the essay's words, "The asymmetry gives a root, not a tree."
:::

### One exclusion, two faces {kind=explain at=why-the-two-analogues-cannot-be-reconciled}

State the single source of the fracture and its two manifestations. What exactly does the essay claim is irrecoverable, and which stronger claim does it decline to make about the actual architecture?

::: answer
The selector is not part of the value space: the query that drives each combination is never among the value vectors that are summed. The first manifestation is the missing selection relation. The query that made position $i$ the governor is consumed in forming the attention weights and written into no representation. The second is the bag problem. Among the daughters the sum does deposit, the pairing is lost, and distinct structures collapse to one vector. The essay declines to say that the head is unrecoverable. That would hold only in a variant without the MLP skip. In the actual block the head's content rides the residual path forward. The narrow claim is that the query does not participate in what is built. What is irrecoverable is the head's relation to this combination, not its content.
:::

### The cure left on the shelf {kind=argue at=why-the-two-analogues-cannot-be-reconciled}

What does the TP-Transformer's fix do, and which manifestation does it reach? What remedy does the essay conjecture for the other? What does the essay infer from the mainstream architecture declining the explicit-binding fix?

::: answer
The TP-Transformer binds a target-based role onto a source-based value: per head, the blended value is bound to a role vector computed from the target. Each gathered dependent is tagged with the position that gathered it, which restores the pairing and repairs the bag. It reaches the selection relation only obliquely, because the target's own content still enters the next layer as unmarked skip carry-over. The essay's remedy, which it calls "ours, and conjectural", is to write the query $q_i$ into the value space in a head-typed direction, a marked summand recording $i$ as governor at no cost in trainable parameters. It does not claim the architecture should have either fix. From the field leaving the cure unused while standard attention scaled, it infers that a Transformer does not need committed bindings. A later query can usually recover the pairing from context.
:::

### Depth as the schedule {kind=explain at=the-blend-is-the-object}

Read the layer stack as a GSC incremental parser. What corresponds to the blend state, to $q$, and to the schedule? What can quantization deliver, and what can it not?

::: answer
Early layers occupy a high-entropy blend, with many candidate daughters superposed at each position: a vector superposition, not yet a distribution over trees. The analogue of $q$ is how strongly and how early the learned dynamics penalize non-discrete states. Depth, or iteration count in a looped model, is the schedule variable, the budget over which an effective $q$ can rise. Quantization sharpens which daughters a position gathers. It cannot record the head's governance, because the query was consumed in forming the gather and never written into the sum to be sharpened. The sharpest reachable structure is a definite combination of definite daughters that is still headless. Headlessness is orthogonal to the schedule, which is why the essay counts it a structural finding and not an artifact of incomplete settling.
:::

### What the reframing does {kind=recall at=the-blend-is-the-object}

The essay says that reading the fracture through the gradient blend does three things. Name them.

::: answer
- It dissolves the soft half of the incompatibility without choosing a side. Selection is the grammatical Harmony, the soft constraints that prefer certain head-argument bindings. Merge is the substrate on which Harmony is maximized. The headless half is untouched: no setting of $q$ promotes the selector into the structure.
- It makes the hybrid-roles finding a prediction. Roles induced without supervision came out as a mixture of positional and syntactic or semantic types, as a gradient feature structure under soft constraints would have them.
- It says which experiments to run. A model whose effective $q$ is too strong should show early, confident, hard-to-revise misparses on locally ambiguous input. One whose $q$ is too weak should carry blends to the output and produce fluent but structurally noncommittal continuations.
:::

### What is not reconciled, and what is conjecture {kind=limits at=conclusion}

Which two readings does the essay fail to reconcile, and what does it offer in place of a reconciliation? Name four places where it marks a claim as conjectural, untested, or unsettled.

::: answer
The two readings are selection (the query/key mechanism as HPSG's head-projection principle) and merge (the residual write as its unification principle). They cannot be one headed operation, because the selector stays outside the structure the merge builds. The essay proposes to stop demanding that they be one: selection supplies the soft constraints and merge the substrate, and even the sharpest result is "a tree without its heads".

- The layerwise garden-path experiments are proposed and not run.
- The query-deposit remedy is conjectural, and so, the closing note says, are the essay's other additions.
- On output gradience "the architecture settles nothing": the final softmax over the vocabulary is itself a quantization step.
- Whether headlessness is a limitation, or a discovery that language processing may not require head-projected structure, is left open.
:::
