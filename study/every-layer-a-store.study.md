---
title: "Study notes: Every Layer a Store"
essay: every-layer-a-store
track: keeps-learning
reviewed-against: "fd70cfb"
requires:
  - {at: where-experience-goes#a-ladder-of-stores, for: "the ladder of stores, and the delta rule overwriting a redefined word", strength: helpful}
introduces:
  - {term: mixture of experts, at: from-the-2017-transformer-to-todays-layer}
  - {term: four questions of a store, at: every-layer-is-a-store, gloss: "what writes the store, when, how much it holds before its entries interfere, and what reading it costs"}
  - {term: outer-product store, at: the-outer-product-store}
  - {term: interference between stored keys, at: the-outer-product-store}
  - {term: stores written in training and stores written while reading, at: softmax-attention-uses-every-power, gloss: "the feed-forward layer holds what the model knows; the attention cache holds what the model has been told"}
  - {term: clean recall and picking the right answer, at: what-counts-as-remembering}
  - {term: five ways to keep the past of a context, at: memory-along-the-context, gloss: "full history, a rolling window, selected entries, compressed entries, a recurrent state"}
  - {term: selector, at: selection-is-learned-retrieval, gloss: "a second, cheaper store in front of the cache; it scores keys and the main attention reads only the winners"}
  - {term: Gated DeltaNet and Kimi Delta Attention, at: the-recurrent-state-learns-while-it-reads}
  - {term: store over depth, at: memory-along-depth, gloss: "a memory written and read by the layers of one token's pass"}
  - {term: Manifold-Constrained Hyper-Connections, at: several-streams-mixed}
  - {term: Attention Residuals, at: attention-over-depth}
  - {term: five meanings of depth, at: depth-recurrence-and-what-a-monitor-can-see}
uses:
  - {term: delta-rule memory, from: where-experience-goes}
---

### The outer-product store {kind=derive at=the-outer-product-store}

Store pairs of vectors in one matrix, $W=\sum_i v_i k_i^\top$, and recall with the key $k_j$. Which part of $Wk_j$ is signal and which is interference? With random unit keys in $d$ dimensions, how many pairs can be stored before the interference matches the signal?

::: answer
$Wk_j=v_j\,(k_j^\top k_j)+\sum_{i\neq j}v_i\,(k_i^\top k_j)$. With unit-length keys the first term is the stored value. The sum is interference: every other value, weighted by the overlap of its key with the query. Each overlap is about $\pm d^{-1/2}$, and the $M-1$ terms add up like a random walk, so the interference grows as $(M/d)^{1/2}$ relative to the signal. It matches the signal at about $M=d$. The least-squares store recalls exactly up to $d$ pairs and reaches the same ratio at about $2d$.
:::

### What a nonlinearity buys {kind=compute at=nonlinearity-suppresses-interference}

A feed-forward network computes $f(x)=\sum_i v_i\,\sigma(k_i^\top x)$. What does a ReLU buy over the linear store? Squaring after the ReLU gives a capacity of about $2d^2/3$: evaluate it at $d=64$ and say why squaring helps. What does the power $p$ give?

::: answer
A ReLU zeroes the negative overlaps, so about half the interfering terms vanish: a factor of two. Squaring makes small overlaps very small while the stored key's overlap of 1 stays 1. At $d=64$ the capacity is $2\times64^2/3\approx2{,}700$ pairs. Raising the overlap to the power $p$ gives capacity of order $d^p$.
:::

### Attention as a store {kind=compute at=softmax-attention-uses-every-power}

Why does weighting each value by $e^{\beta s}$ suppress interference more than any single power of the overlap $s$? Wang's estimate of the capacity for random keys is $e^{2\beta(1-\beta/d)}$: evaluate it at $d=64$ with $\beta=d^{1/2}$. In what way is attention a different kind of store from the feed-forward layer?

::: answer
The exponential is a sum of all the powers, $e^{\beta s}=\sum_p(\beta s)^p/p!$. With $\beta=8$ the exponent is $2\times8\times(1-1/8)=14$, and $e^{14}\approx1.2$ million pairs. Nothing is trained into attention. Its keys and values are computed from the context while the model reads, and its $M$ is the number of positions it sees. The feed-forward layer is written by training and holds what the model knows; the attention cache is written by reading and holds what the model has been told.
:::

### One head, two criteria {kind=compute at=what-counts-as-remembering}

Take a store with 128-dimensional keys and values. How many random associations does it recall as clean vectors, written as outer products and written to the least-squares solution? Under the criterion that the right answer wins among the stored values, the outer-product map succeeds while $d^2/(n\ln n)$ stays above 8, and the best linear map while it stays above 2. Check that $n\approx350$ and $n\approx1{,}160$ sit at those thresholds. Why does the second criterion matter?

::: answer
As clean vectors: about 128 and about 256. With $d^2=16{,}384$ the thresholds are $n\ln n=2{,}048$ and $n\ln n=8{,}192$, and $350\ln350\approx2{,}050$, $1{,}160\ln1{,}160\approx8{,}185$. Language models do not need clean recall. They need the right answer to win among a vocabulary of candidates, and under that criterion a linear store holds many more pairs. The counts are asymptotic, and "order $d^2$" hides a logarithm that costs about a factor of ten.
:::

### A million tokens, five ways {kind=compute at=memory-along-the-context}

Name the five ways the seven models keep the past of a context. Then, for a 1,000,000-token prompt, count what one layer keeps and what the next token reads when the layer (a) is full attention, (b) has a 128-token window, (c) reads 16 blocks of 128 tokens for each group of heads, (d) keeps one entry per 4 tokens and reads the 1,024 an indexer selects, (e) keeps one entry per 128 tokens and reads them all, (f) is recurrent.

::: answer
Full history, a rolling window, selected entries, compressed entries, a recurrent state.

- (a) keeps 1,000,000 entries and reads all of them.
- (b) keeps 128 and reads 128 (MiMo's window layers).
- (c) keeps all 1,000,000 and reads $16\times128=2{,}048$ positions per group of heads (MiniMax-M3).
- (d) keeps about 250,000 and reads 1,024, plus the 128 most recent tokens uncompressed (DeepSeek-V4-Pro's compressed sparse layers).
- (e) keeps about 7,800 and reads them all (the same model's heavily compressed layers).
- (f) keeps a matrix per head whose size does not depend on the prompt's length, and reads that (Kimi K3).
:::

### A selector is a store {kind=explain at=selection-is-learned-retrieval}

In what sense is a selector a store? Why can it not learn from the task loss, and what does it learn from? What new failure does selection bring?

::: answer
A selector is a second, cheaper store placed in front of the first. It scores keys, and the main attention reads only the winners. The choice is a hard top-$k$, so no gradient flows through it, and the indexers learn by imitating the main attention's distribution. The new failure is the miss: an entry the indexer did not choose cannot be read, however relevant it was.
:::

### Per-channel forgetting {kind=compute at=the-recurrent-state-learns-while-it-reads}

A recurrent layer decays its state and then writes $S_t=S_{t-1}+\beta_t\,(v_t-S_{t-1}k_t)\,k_t^\top$. Let one row of the memory be $(2,1)$, and write the value 3 under the key $(1,0)$ with $\beta=1/2$. Compute the result when the whole row first decays by $1/2$ (Gated DeltaNet), and when the two channels are retained at $(1/2,1)$ (KDA). What does the delta rule buy over purely additive linear attention?

::: answer
Gated DeltaNet: the row decays to $(1,1/2)$, the prediction for the key is 1, the error is 2, and the write adds $1/2\times2=1$ to the first coordinate, giving $(2,1/2)$. KDA: the row decays to $(1,1)$, the write again adds 1, and the result is $(2,1)$. The same association was corrected, and the second channel's content survived. The delta rule buys the ability to overwrite, not capacity. Repeated writes approach the least-squares store, whose advantage is about a factor of two.
:::

### Content in the cache, settings in the state {kind=explain at=what-the-trained-hybrids-do-with-their-stores}

What do the measurements on trained hybrids say the attention cache holds, and what the recurrent state holds? Which experiment shows the two can be separated? Why does capacity not explain the division?

::: answer
The cache is the store that grows with the context, and it holds the content: values, names, the facts a later question will need. The recurrent state is the store that every token reads, and it holds a few settings that condition everything the model writes: which language, which voice. When one prompt's cache was paired with another prompt's state, the answer took its content from the first and its language from the second. The dictionaries in these tests held 15 to 30 entries, well within what a 128-dimensional state can hold, and recall through the state failed even in minimal versions of the tasks. The division is learned.
:::

### Long context is an interference problem {kind=explain at=long-context-is-an-interference-problem}

Why does a longer context make recall harder for softmax attention? What remedy works against random competitors, and why does it not settle real contexts?

::: answer
As a context grows, so does the number of keys that compete with the right one. Softmax attention suppresses random competitors exponentially, but its capacity is finite at a fixed sharpness. The remedy is to sharpen the softmax as the context grows, multiplying $\beta$ by a factor that grows with the logarithm of the context length. Real contexts are not random: they repeat entities, templates and phrasings, and no sharpening separates near-duplicate keys. A model whose architecture accepts a million tokens may therefore still fail to use them, which is why the second essay treats long context as a training problem.
:::

### Two stores over depth {kind=compute at=memory-along-depth}

(a) Two scalar residual streams hold $(2,4)$. A doubly stochastic mix has rows $(3/4,1/4)$ and $(1/4,3/4)$. The block reads the average of the streams, computes 6, and sends half to each stream. What are the streams afterwards? (b) A layer's query scores two earlier representations, $(1,0)$ and $(0,2)$, at 0 and $\ln 3$. What is the layer's input? Which design is an explicit store over depth and which an implicit one, and how long does either last?

::: answer
(a) The mixed residual is $(2.5,3.5)$, and its total is still 6. The block reads 3 and adds 3 to each stream: $(5.5,6.5)$. The mixing conserved the old total, and the block added new content on top. (b) The softmax weights are $1/4$ and $3/4$, and the input is $(1/4,3/2)$. AttnRes is the explicit store: a growing cache of layer outputs, read by attention. mHC is the implicit one: a fixed-size state, written by outer products, whose stream differences contract at every layer. A store over depth lives only for the duration of one token's computation.
:::

### What each store gives up {kind=state at=the-seven-assembled}

The summary table adds a fifth column to the four questions: how each store forgets. When do the stores written in training lose their contents? What does each store written while reading give up: the window, compressed entries, selected entries, the recurrent state and the full cache?

::: answer
The stores written in training lose contents only when training writes over them. The window gives up the old. Compression gives up detail: distinctions within a pool. Selection gives up whatever its indexer misses. The recurrent state gives up what decays and what is overwritten. The full cache gives up nothing, and it pays with a reading cost that grows with the context.
:::

### Five ideas behind seven releases {kind=recall at=the-seven-assembled}

The essay finds about five ideas behind the seven releases. Name them. To what one question are most of them answers?

::: answer
- Recurrent layers with a delta-rule write, mixed with attention.
- Learned selection of what to read.
- Learned compression of what is kept.
- A split between reading a prompt and writing an answer.
- Replacements for the plain residual sum.

Most of them are answers to one question: what a memory should be allowed to forget.
:::

### Depth and the monitor {kind=distinguish at=depth-recurrence-and-what-a-monitor-can-see}

How does a model's depth support the case for watching its reasoning? A recurrent layer applies one update per token, and the updates are affine in the state. In about how many rounds can a million of them be combined, and why? Name the three paths from one token to the next.

::: answer
A Transformer with a fixed number of layers can do only a bounded amount of sequential computation for each token it emits. A task that needs more has to be done in steps, and the steps appear in the text, where a monitor can read them. Two affine updates compose into one, $(A_2,b_2)\circ(A_1,b_1)=(A_2A_1,\,A_2b_1+b_2)$, and composition is associative, so $L$ updates combine in a balanced tree of about $\log L$ rounds: $\log_2 10^6\approx20$. The three paths:

- Recurrence across positions: a numerical state carries information that the emitted text need not express. Ordinary Transformers have this path too, through their caches.
- Recurrence through depth: repeated passes through the same layers before a token is emitted. None of the seven does this.
- Generated text, which adds steps of computation but need not explain them faithfully.
:::

### Where the numbers stop {kind=limits}

Name the limits the essay sets on (a) its capacity counts, (b) the measurements on trained hybrids, (c) what recurrence and probes mean for monitoring.

::: answer
(a) The counts are per key dimension, not per parameter, and measured per parameter architectures differ less than the counts suggest. They also assume random keys. Real keys share structure, which raises interference beyond what any count predicts.

(b) The models were far smaller than the seven, the answers short, and the results for the largest models came from a single run. Discarding one store also leaves the model in a state it never met in training.

(c) Whether the delta-rule layers escape $\mathrm{TC}^0$ depends on their transition matrices, and the released code keeps the write step between 0 and 1, so names like "linear attention" or "delta rule" do not settle where these models sit. Every catch the probe paper shows was also visible in the text, so the probes added detection, not access to hidden reasoning. Depth bounds what a model can do between tokens, but it does not certify what the model did.
:::
