---
title: "Study notes: How LLMs Could Place Explicit Memories"
essay: how-llms-could-place-explicit-memories
track: keeps-learning
reviewed-against: "c3c029a"
requires:
  - {at: every-layer-a-store#selection-is-learned-retrieval, for: selectors}
  - {at: every-layer-a-store#long-context-is-an-interference-problem, for: long context as an interference problem}
  - {at: filling-the-stores#selectors-cannot-learn-through-top-k, for: why a selector needs a teacher}
  - {at: where-experience-goes#a-ladder-of-stores, for: the rungs of the ladder}
  - {at: where-experience-goes#what-survives-of-the-argument-for-parametric-memory, for: the amortization argument}
  - {at: learning-about-what-you-do-not-do#learning-off-the-policy, for: "importance ratios, and an older checkpoint as behaviour policy"}
  - {at: who-teaches-the-weights, for: "the two conditions on a teacher, and self-distillation as consolidation", strength: helpful}
  - {at: what-breadth-reaches, for: the species of integration across sessions, strength: helpful}
  - {at: algebraic-mind-meets-neural-world#attention-as-approximate-tpr-unbinding, for: attention as role and filler, strength: helpful}
  - {at: dispersed-minds-simulated-selves#from-pairs-to-triples-the-2-simplicial-transformer, for: attention over triples of positions, strength: helpful}
introduces:
  - {term: explicit memory, at: a-memory-beside-the-context, gloss: "a fact the weights do not contain, found where it was written down", related: ["stores written in training and stores written while reading"]}
  - {term: stale keys, at: a-memory-beside-the-context, gloss: "keys read by newer weights than the ones that wrote them"}
  - {term: distraction issue, at: teaching-the-memory-to-ignore-distractors, related: ["interference between stored keys"]}
  - {term: native sparse attention designs, at: the-memory-is-the-cache, gloss: "NSA, MoBA and DeepSeek Sparse Attention: selection trained into the model", related: ["selector", "compressed sparse attention"]}
  - {term: Latent Sparse Attention, at: ten-million-tokens, related: ["distilling a selector from the attention it replaces", "hippocampal indexing"]}
  - {term: Memorilla, at: memory-moves-back-out, related: ["ladder of stores", "soft tokens"]}
  - {term: soft tokens, at: memory-moves-back-out, gloss: "vectors in a model's token embedding space, read as if they were extra tokens"}
  - {term: uneven writing, at: retrieval-even-if-intelligent, gloss: "a store that keeps more where the text matters more: by merging, by events, or by eviction", related: ["compressed sparse attention"]}
  - {term: multi-hop retrieval, at: retrieval-even-if-intelligent, gloss: "reads that follow, from each entry reached, the entries that entry attended to most", related: ["composition problem", "2-simplicial attention", "tensor product representation"]}
  - {term: recursive language model, at: what-continual-learning-means-here, gloss: "a model that keeps its prompt as a variable and reads it by programs it writes", related: ["ladder of stores"]}
  - {term: break-even for consolidation, at: consolidation}
  - {term: deflationary and substantive answers about consolidation, at: consolidation, gloss: "consolidation as amortization, against consolidation as representation learning", related: ["amortization as learning and as efficiency"]}
  - {term: three placements of a memory, at: where-the-brain-places-memories, gloss: "by position, where it arrived; by content, what it resembles; into connections, what it taught", related: ["ladder of stores"]}
  - {term: hippocampal indexing, at: where-the-brain-places-memories, related: ["Complementary Learning Systems"]}
  - {term: five remedies for stale keys, at: five-remedies, related: ["Memorilla"]}
uses:
  - {term: selector, from: every-layer-a-store}
  - {term: distilling a selector from the attention it replaces, from: filling-the-stores}
  - {term: stale rollout, from: filling-the-stores}
  - {term: ladder of stores, from: where-experience-goes}
  - {term: amortization argument for weights, from: where-experience-goes}
  - {term: delta-rule memory, from: where-experience-goes}
  - {term: self-distillation with privileged context, from: who-teaches-the-weights}
  - {term: importance ratio, from: learning-about-what-you-do-not-do}
  - {term: two conditions on a teacher, from: who-teaches-the-weights}
  - {term: REINFORCE, from: how-can-a-reward-train-a-neural-network}
  - {term: tensor product representation, from: algebraic-mind-meets-neural-world}
  - {term: 2-simplicial attention, from: dispersed-minds-simulated-selves}
---

### The note and the question {kind=state}

The essay opens with a note from 2021 and a question about placement. State the two halves of the note's proposal. Name the three ways a memory can be placed.

::: answer
Train a model on text interleaved with what a retriever would have fetched, and the model starts to produce that material itself. Spare the material that helped with what came next, and the model starts to keep notes. A memory can be placed by position, where it arrived; by content, what it resembles; or into connections, what it taught.
:::

### Three choices that set the terms {kind=recall at=a-memory-beside-the-context}

Memorizing Transformers added a layer that could read a long record of the model's own past. Which three of its design choices set the terms for everything after? Where did its gains concentrate?

::: answer
- The memory was non-differentiable. Keys and values were stored as computed and never revisited.
- The memory held the model's own representations, so its retrieval was a form of attention. Earlier methods fetched text from a corpus or intervened at the output.
- The keys went stale. A long document spans many training steps, so the query that reads a key is computed by newer weights than the ones that wrote it. Normalization evens out magnitude and does not eliminate staleness.

The gains concentrated on rare tokens: names, citations, function names. To name a lemma, the model often looked up its definition from earlier in the proof. That is explicit memory: a fact the weights do not contain, found where it was written down.
:::

### From what to keep to what to read {kind=explain at=the-memory-is-the-cache}

Over two years the memory became the cache. How did the question about memory change, and what became the bottleneck?

::: answer
The store is no longer beside the context. Within the window, nothing is thrown away, so the question is what to read, and the cost of answering it became the bottleneck. The indexer still scores every key, so at ten million tokens nearly all of a sparse attention layer's prefill time goes to indexing. Sparse attention had made reading cheap and left finding expensive. CISA, a retrofit that scores chunks of the cache, measures the same cost: at a million tokens its core attention decodes 13.0 times faster than dense attention, and 3.0 times faster once scoring and selection are counted.
:::

### An index in place of a scan {kind=compute at=ten-million-tokens}

How does Latent Sparse Attention avoid scoring every key, and what makes its prefill subquadratic? An oracle at 128K tokens lets each query keep its top 512 keys, a 4-token sink and a 512-token window. What share of the keys is that, and what does the oracle's accuracy license? What does LSA leave undone?

::: answer
The keys are projected into a small latent space, normalized, pooled four at a time, and clustered bottom-up into buckets, each with a centroid and a list of key positions. A query scores centroids rather than keys and takes the best buckets. Tree search descends a hierarchy of buckets, so a query scores $O(\log T)$ centroids. The oracle reads $(512+4+512)/128{,}000\approx0.8$ percent of the keys and keeps 98 percent of full attention's accuracy: on this task, most of what attention reads, it does not need. LSA reduces the cost of finding the keys, not of storing them. The cache still grows linearly with the context, it is written in one model's key space, and it ends with the session.
:::

### Who teaches the index {kind=explain at=who-teaches-the-index}

*Who Teaches the Weights?* set two conditions on a teacher. State them, and say how the teacher of a distilled indexer meets both. What contrast in cost does the essay draw from this?

::: answer
A teacher must know more than the student, and its targets must be ones the student can absorb. Dense attention knows more, because it has looked at every key. Its target is a ranking of clusters, which 64-dimensional projections can represent. The student never has to know what any key means, only where the teacher would look. Telling a model where to look is cheap: a short distillation with nothing else in the model moving, or no training at all, as in CISA, whose chunk summaries come from keys the model already computes. Teaching a model what it read is expensive: fine-tuning on a corpus took generated text hundreds of times the corpus's length.
:::

### Two opposite trades {kind=distinguish at=memory-moves-back-out}

Memorilla makes the opposite trade from Latent Sparse Attention at almost every point. Compare them on the store, what writes it, whether it is bound to one model, how long it lasts, how it is read, and fidelity. Which rung of the ladder does each strengthen?

::: answer
In each line Latent Sparse Attention comes first and Memorilla second.

- Store: the key–value cache; an embedding matrix outside the model.
- Written by: the model's forward pass; a frozen encoder.
- Bound to one model: yes; the store no, the reader yes.
- Lasts: the session; across sessions.
- Read: sparse, hard selection in every attention layer; a soft read over every document, once, placed ahead of the prompt.
- Fidelity: exact keys and values; a compressed read that "can lose fine-grained factual details".

LSA strengthens the first rung, the context. Memorilla is a new form of the third rung, harness memory, held in latent vectors instead of text.
:::

### Three native designs {kind=recall at=the-memory-is-the-cache}

Three designs of 2025 train selection into the model. How does each choose what a query reads?

::: answer
- Native Sparse Attention runs three branches and mixes them by a learned gate: attention to compressed blocks of the context, to the original tokens of the blocks the compressed branch scored highest, and to a window of recent tokens.
- Mixture of Block Attention routes each query to blocks, as a mixture of experts routes tokens to experts. The query scores every earlier block by the mean of its keys, reads the best few, and always reads its own block. The router has no parameters of its own.
- DeepSeek Sparse Attention selects single positions with a small learned indexer.
:::

### Memorilla's reader {kind=explain at=memory-moves-back-out}

What does Memorilla store, what goes into its reader and what comes out? Why is it not retrieval-augmented generation, though both use embeddings?

::: answer
The store holds an embedding of each chunk of a document collection, one or two hundred tokens long, computed once by a frozen embedding model and independent of any language model. A reader of 194 million parameters is trained for each language model. Its inputs are the whole store and the prompt, embedded by the same frozen model. Its output is sixteen vectors in the language model's token embedding space, received ahead of the prompt as if they were sixteen extra tokens. No document text reaches the model: RAG uses embeddings to find passages and hands the model their text, while Memorilla reads the embeddings themselves. A compressed read of this kind keeps structure and loses names.
:::

### Writing unevenly {kind=explain at=retrieval-even-if-intelligent}

DeepSeek-V4's heavily compressed layers pool every 128 tokens alike. Name three ways a store can write unevenly instead. What question does uneven writing bring back, and why is a write harder to teach than a read?

::: answer
- Dynamic Memory Compression lets each attention head decide at every token whether to add an entry or merge the token into its last one.
- EM-LLM keeps every token but groups the tokens into events, cut where the model's surprise peaks.
- Eviction, as in H2O and SnapKV, writes every token and later drops those that attention has passed over.

Each brings back the question of what to keep, and with it the need for a teacher. A read has one at hand, since an indexer can imitate the attention it serves. A write is judged later, when its entry is read or not. DMC trains its choice through the language-model loss, which reaches a write only through reads within the training sequence. EM-LLM uses surprise, which needs no training. Eviction bets that past attention predicts future attention.
:::

### Two hops need two reads {kind=explain at=retrieval-even-if-intelligent}

The input lists two functions as tables, then a query $x$, and the answer is $f_1(f_2(x))$. Why can a block whose reads are all chosen from the query not find the answer cheaply? How does multi-hop retrieval get around this, and what is the second route? What does the bound not say?

::: answer
A read from the query can fetch $f_2(x)$, but the entry holding the answer can be found only after that read. When every read is chosen before any returns, the answer's position must receive enough about $f_1$ to cover every value $f_2(x)$ might take, which costs capacity of order $\sqrt n$, more than a model of fixed width can pay. Multi-hop retrieval follows links the attention layer has already laid down: the entry of $f_2$'s table at $x$ attends most to the entry of $f_1$'s table at $f_2(x)$, so each hop turns a filler into a role. With $m$ hops a fixed block composes $m$ functions, and $m+1$ again costs size growing with $n$. The second route widens a read instead: attention over triples of positions scores a query against two entries at once, and a cheaper variant built from pairwise scores composes functions in one layer. Multi-hop retrieval is the cheapest case, scoring only the chain. The bound concerns one block whose reads are fixed. A later layer can choose again, and a reasoning model can take one hop per step, so the bound says where hops must come from, not that sparse models cannot compose.
:::

### Full context is not an upper bound {kind=explain at=full-context-is-not-an-upper-bound}

Two unrelated designs reach the same finding about reading the whole context. What is it, and which earlier failure does it repeat? What caveats does the essay attach to Memorilla's side of the comparison?

::: answer
Reading everything hurts. Full context trails Memorilla on every benchmark but one, and D-LSA beat full attention on one model at ten million tokens. It is the distraction issue of 2023, and it warns against treating a longer context as a free good. The caveats: Memorilla's module is fine-tuned on the training splits of all eight evaluation benchmarks, and full context gets nothing comparable. The decoders are small, and only one model family has been tested. The read is measured as flat up to 512 documents, but a soft read over every document must grow with the store eventually, which is the essay's own inference.
:::

### What "continual learning" means here {kind=object at=what-continual-learning-means-here}

Memorilla's paper claims that it "enables continual learning". In its TextWorld experiment the model is frozen, only the memory module is trained, and the pass rate on 40 held-out prompts rises from 0.250 to 0.375. How many prompts is that? Give the three facts with which the essay limits the claim, and say what it grants.

::: answer
Ten against fifteen, with wide overlapping intervals. The store lasts one rollout and the module is frozen at evaluation, so nothing carries over between games. And training teaches a new environment "without overwriting prior knowledge" because the model never changes, which also means nothing reaches its weights. What the experiment shows is narrower: a trained reader helps a small model use a context it already has. It does not overturn the claim that in-context learning is the best learner on the ladder.
:::

### Reading by program {kind=distinguish at=what-continual-learning-means-here}

How does a recursive language model hold and read a long prompt? What does it keep that Memorilla loses, where does the combining happen, and what does it cost?

::: answer
The prompt is stored as a variable in a Python environment, and the model sees only constant-size metadata about it. It reads by writing code that slices and searches the text, and calls itself on the pieces. The store is plain text, so nothing blurs and no weight update can stale it. The combining that defeated Memorilla and RAG moves into the model's own reasoning, and the model takes as many hops as it writes calls. The price: without asynchronous calls it is slow, and models weak at coding struggle. Nothing is placed, and what the model gains from a read ends with the call.
:::

### The break-even {kind=compute at=consolidation}

Let consolidating a competence cost $c$ once. Let each use cost $r$ through the context and $w$ through the weights. After how many uses does consolidation pay? Evaluate with $c=1000$, $r=10$, $w=0$. Then let cheaper reading divide $r$ by 2.87. What does the account leave out?

::: answer
Consolidation pays after $n>c/(r-w)$ uses: here, after 100. Dividing $r$ by 2.87 gives about 3.5, and the break-even moves to about 290 uses. The units are invented, and the prefill, paid once a session, is left out. Where cheaper finding brings no speedup per output token, the bill does not change.
:::

### Two answers about consolidation {kind=distinguish at=consolidation}

The series has given two answers to what consolidation is. State the deflationary one and the substantive one. Which of them does cheap reading touch? How do they divide the ground?

::: answer
The deflationary answer: "the case for consolidation is the case for amortization". Paying once in training buys a competence that would otherwise be rebuilt from context at every use, so cheaper reading changes the bill. The substantive answer: consolidation is representation learning, in which gradient descent discovers structure not specified in advance. Retrieval substitutes for it with no important loss for facts about a user, with some loss for procedural patterns, and falls short for taste, "because the taste is the integration". Read cost does not enter that argument, so cheap reading leaves it where it stood. The deflationary answer is right about explicit memories, and the substantive one about what consolidation builds beyond them.
:::

### Rewarded and taught {kind=distinguish at=visible-reasoning}

The 2021 note kept an insert because what followed it went better. Where does training of that kind survive, and where do the 2026 systems use a teacher instead? Why?

::: answer
Rewards still train what the model writes, as they trained Quiet-STaR's rationales and train reasoning now. Where the model chooses what to read, the 2026 systems use a teacher: indexers learn by imitating dense attention. One loss per query is too weak a signal to grade a choice of about a thousand entries among a quarter of a million.
:::

### Where the brain places memories {kind=state at=where-the-brain-places-memories}

Map the three placements onto the brain as the essay does. Which two does a language model now hold within its context, and what does it lack? What disanalogy does the essay state?

::: answer
- By content: the hippocampus keeps an index of the cortical areas an event activated, and the content stays in cortex. LSA's bucket cache is an index over a store in the same sense.
- By position: prefrontal working memory holds the elements of a sequence in slots according to ordinal position. The key–value cache places content by position, as slots do.
- Into connections: replay transfers the transition structure of hippocampal memories into prefrontal connections. What moves is structure, not episodes.

A language model holds the first two within its context. Nothing writes into its connections during deployment, apart from a recurrent state that is bounded, carries settings and not content, and ends with the session. A context store with a hippocampal index and no replay is a hippocampus without sleep. The disanalogy: the brain's working memory holds a few items, and that limit is part of what forces consolidation, while the model's limit is cost. The difference touches only the deflationary case.
:::

### An off-policy problem without a ratio {kind=explain at=an-off-policy-problem-without-a-ratio}

Suppose a deployed model consolidates into its weights while it keeps a large indexed context. In what sense is its cache an off-policy problem? Why does the usual off-policy correction not apply? What does an index add, and how do its failures differ from the keys'?

::: answer
A context cache is experience recorded by an older checkpoint and read by the current one. For tokens, a language model's importance ratios are exact, so a stale rollout can be reweighted. A stale key has no ratio. It is not a sample with a probability under one policy and another. It is a vector computed by a function that no longer exists. The shift is closer to a change of coordinates, and reweighting does not change coordinates. An index adds a second thing to go stale: D-LSA's projections were distilled from a frozen teacher, so a weight update stales the index space as well as the keys. That step is the essay's inference. The two fail differently. A stale index changes only which keys are read, so it costs recall, and what it does read is still exact. A stale key changes what is read.
:::

### Five remedies {kind=recall at=five-remedies}

Name the five remedies for stale keys, with the cost or limit of each. Which key cannot go stale?

::: answer
- Re-encode: run the context again under the new weights. This is the on-policy option, and its cost is a prefill.
- Tolerate: normalize, and let the queries adapt. The evidence comes from a small memory, and normalization fixes magnitude, not direction.
- Translate: learn a map from the old key space to the new. A key at a deep layer depends on everything below it, so correcting stored keys alone is generally insufficient.
- Constrain: change the weights only in ways that keep old keys valid.
- Keep keys the model did not compute: a frozen encoder outside the model writes the store, at the cost of an encoder never optimized for compression. The staleness then moves to the reader. Text is the limiting case, and it costs a re-read, which recursive language models show need not be whole.

The only key that cannot go stale is one the model did not compute. A cache in the model's own key space is exact and fragile. A store outside it is durable and vague.
:::

### What is the essay's own step {kind=limits}

Which links and inferences does the essay mark as its own and not its sources'? What does it leave open?

::: answer
- The line is one of ideas, not of citations. Latent Sparse Attention cites none of the 2022 and 2023 papers, and the closeness of Quiet-STaR to the note is a convergence, not an influence.
- The brain comparison is the authors'. LSA makes no brain claim, and reading "learning through dynamics" as in-context learning is the essay's step.
- Several inferences are flagged: that a soft read over every document must grow with the store, that Memorilla's capacity result may trace to storing each chunk as one vector, that a weight update stales the index space, and that with an outside store the staleness moves to the reader, which is "still untested". The reading of the composition bound as saying where hops must come from, not that sparse models cannot compose, is the essay's too.
- The break-even's units are invented.

The third placement is open. The essay knows of no deployed frontier model that consolidates what it reads into its weights. The experiment it asks for is a reader, or a model, trained on one store's history over a long use and compared with the generic one.
:::
