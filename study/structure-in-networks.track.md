---
title: "Across the track: Grammar and search inside networks"
track: structure-in-networks
---

Questions whose answers draw on more than one essay. Attempt them after the last essay of the track.

### The query, read three ways {kind=connect}

Each of the first three essays gives the attention query a different reading. State the three, and say what the later two add to the first.

::: answer
- *The Algebraic Mind Meets the Neural World* reads the query as a role address: attention is approximate tensor-product unbinding, the key advertises a role and the value is the filler retrieved ([there](/notes/algebraic-mind-meets-neural-world.html#attention-as-approximate-tpr-unbinding)).
- *Merge and Selection* reads it as a valence specification: the query says what a position seeks, as a head's valence list says what it must combine with ([there](/notes/merge_and_selection.html#two-analogues-the-query-selects-the-stream-merges)). It adds that the query is never among the summed values, so the head governs without being deposited.
- *A Parser Without a Grammar* reads it as a functor seeking an argument, with CCG's slash as the directional signature ([there](/notes/a-parser-without-a-grammar.html#directionality-ccg-and-the-head-the-join-throws-away)). It adds that application consumes its functor, so directionality and monotonicity have to be separate mechanisms.
:::

### What stays out of the activations {kind=connect}

Three essays each find something the Transformer computes with and does not write into the vectors it passes on. Name the three, and the link each later essay draws to the one before.

::: answer
- The attention graph. Smolensky's criticism of first-generation systems is that the compositional structure is used within a layer and not encoded in the activations passed on ([Algebraic Mind](/notes/algebraic-mind-meets-neural-world.html#attention-as-approximate-tpr-unbinding)).
- The selector. *Merge and Selection* calls Smolensky's complaint the same observation as the binding problem one layer up: a value carries no trace of the key it matched, and the query is consumed in forming the weights ([there](/notes/merge_and_selection.html#the-explicit-binding-program)).
- The abstractions. In Word Grammar types and relations are nodes that carry activation. In the Transformer they live in the weights, an operator applied to the stream. *A Parser Without a Grammar* calls this the same fact *Merge and Selection* located one rung down ([there](/notes/a-parser-without-a-grammar.html#topology-word-grammar-and-the-grammar-that-is-an-activation-network)).
:::

### One dynamics, two schedules {kind=connect}

*The Given and the Found* separates depth from breadth and suggests a limit cycle. *Merge and Selection* describes two regimes of Gradient Symbolic Computation. State the identification *A Parser Without a Grammar* makes, and what each source contributes to it.

::: answer
Depth entrenches one basin and breadth keeps several alive ([The Given and the Found](/notes/the-given-and-the-found.html#depth-and-breadth-are-two-knobs-not-one)). In GSC, cooling $T$ to zero converges on the single maximum-Harmony structure, and holding $T$ yields a Boltzmann distribution over structures ([Merge and Selection](/notes/merge_and_selection.html#tensor-product-representations-and-gradient-symbolic-computation)). The third essay identifies depth with the optimization regime and breadth with the sampling regime, and reads the limit cycle as the sampling regime realized in time instead of across restarts ([there](/notes/a-parser-without-a-grammar.html#the-substrate-three-things-at-once-in-one-medium)). The empirical separation of the knobs comes from the iterative reasoners. The single dynamics whose schedules they are comes from GSC. The limit cycle is also what a gradient blend can do and Dynamic Syntax's underspecification cannot: never resolve.
:::

### Weight tying, twice {kind=connect}

A weight-tied network applies the same block at every iteration. What does *The Given and the Found* report in its favor, and what does *Merge and Selection* say it loses?

::: answer
At matched inference compute and with far fewer parameters, a tied network of 2 blocks run for 21 iterations beats a 42-block feedforward network on scarce data, and an operator trained at 16 iterations extrapolates to over a thousand ([The Given and the Found](/notes/the-given-and-the-found.html#amortization-is-learning)). In a stacked Transformer each layer has its own projections, so the depth at which a filler was merged acts as an implicit timestamp and partly preserves who attended to whom. Tying removes the timestamp, and the collapse of $(a/b)/(c/d)$ into $(a/d)/(c/b)$ becomes exact ([Merge and Selection](/notes/merge_and_selection.html#the-explicit-binding-program)). *Merge and Selection* notes that these looped models are the case the other essay treats as architecturally interesting.
:::

### Where the grammar comes from {kind=connect}

*A Parser Without a Grammar* locates the Transformer among six formalisms and then names something its coordinate system cannot locate. What is it, and how does the boundary of *The Given and the Found* apply?

::: answer
It cannot locate where the correctness condition comes from. Every formalism, and the Harmony function beneath them, presupposes a grammar that is given, and the coordinates describe how the Transformer parses under a grammar it has learned ([there](/notes/a-parser-without-a-grammar.html#what-this-does-not-show)). Construction Grammar and Word Grammar say that grammar is learned from usage, which names the outcome and not the induction that selects what to posit. *The Given and the Found* draws the same line for iterative reasoners: they amortize search over a condition that is handed over, and none amortizes the discovery of the condition ([there](/notes/the-given-and-the-found.html#the-boundary-amortizing-search-versus-amortizing-discovery)). The learning of the grammar falls on the far side of that line.
:::
