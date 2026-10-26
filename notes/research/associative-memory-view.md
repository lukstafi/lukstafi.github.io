# Every layer a store: the associative-memory view for the architecture series

Research date: 26 October 2026. Status: a research note for the architecture series, not a publication draft. It folds the X discussion saved in the gitignored `notes/private/LLM_memory-discussion_X.txt` into [frontier-model-architectures.md](frontier-model-architectures.md), and it uses the evidence labels of [architecture-interpretability-and-audit.md](architecture-interpretability-and-audit.md) (Confirmed, Reported, Inferred). The full source digest, with equations and per-paper numbers, is in the gitignored `notes/private/associative-memory-sources.md`; this note keeps what the series needs.

The discussion has two heads. [Alex Wang's post](https://alexwang.ai/posts/associative-memory/) (dated 15 October 2026; [thread](https://x.com/heyyalexwang/status/2111158818730397932) 16 October) derives each Transformer layer as a key–value store and estimates its capacity from how much interference it suppresses. [Nicolas Zucchet's thread](https://x.com/NicolasZucchet/status/2112409382210425127) (20 October) points to five papers and a tutorial that use the same view to study how models learn, forget and distil facts.

## Already used in the continual-learning series

On 25 October the thread entered three essays (commit 98488f4). The architecture series should link to these passages rather than repeat them.

- *Where Experience Goes*, the paragraph after worked example G: Wang's capacities for outer-product, least-squares and softmax stores, and the Qwen3.5 recall result read as a capacity prediction.
- *Where Experience Goes*, the M-step paragraph and the benchmark section: Zucchet and Linderman on divergence and entropy; spurious forgetting (Palit et al.) as a caveat on the performance matrix.
- *Who Teaches the Weights?*: the curse of ambiguity (Zucchet, Lee and Linderman) as a capacity reason why collapse onto one strategy is cheap.

## Findings

### 1. The capacity numbers depend on the recall criterion

Wang's numbers are heuristics checked by simulation at $d_k=64$. None is a theorem, and the post says so. [Confirmed] The setting is random unit keys, a query equal to a stored key, and "capacity" defined as the number of pairs at which interference equals signal for recall of a clean value vector. [Confirmed]

| Store | Form | Capacity (vector recall) | At $d_k=64$ |
| --- | --- | --- | --- |
| Outer-product (Hebbian), as in additive linear attention | $W=\sum_i v_ik_i^\top$ | $\approx d_k$ | 64 |
| Least-squares (whitened) | $W=V^\top K(K^\top K)^{-1}$ | $\approx 2d_k$ | 128 |
| ReLU MLP | $V^\top\mathrm{ReLU}(Kx)$ | $\approx 2d_k$ | 128 |
| Squared ReLU, or GLU with tied gate | $V^\top\mathrm{ReLU}(Kx)^2$ | $\approx 2d_k^2/3$ | about 2,700 |
| Softmax attention, $\beta=\sqrt{d_k}$ | $V^\top\mathrm{softmax}(\beta Kx)$ | $\approx e^{2\sqrt{d_k}-2}$ | about 1.2 million |

[Confirmed: read in the post] The thread's claim that a ReLU MLP reaches $O(d^2)$ overstates the post; squaring is needed. [Confirmed]

Three qualifications decide how the table may be used.

- **A discrete readout changes the exponent.** If the recalled vector only has to rank the right answer first among a fixed set, a $d\times d$ linear map holds about $d^2$ pairs up to logarithms, not $d$. [Nichani, Lee and Bietti](https://arxiv.org/abs/2412.06538) prove this for Hebbian (outer-product) weights. [Barnfield et al.](https://arxiv.org/abs/2605.05189) give the sharp thresholds: $d^2/(n\ln n)=2$ for the best possible linear map, and 8 for the outer-product store. At $d=128$ that is about 1,160 and 350 associations, so the logarithm costs more than a factor of ten at practical sizes (asymptotic figures; checked 26 October). Wang concedes the point in a footnote. [Reported for the two papers; Confirmed for the footnote] Next-token prediction is a discrete readout, so this is the regime of the language-model head. [Inferred]
- **The counts are per key dimension, not per parameter.** Wang's MLP stores $M$ memories in $M$ hidden units, so its memories per parameter fall below the linear store's. [Inferred from the construction] Parameter-normalized results give memories proportional to parameters: Zucchet's tutorial measures 0.16 memories per parameter for a trained softmax head against 0.02 for the Hebbian construction. [Allen-Zhu and Li](https://arxiv.org/abs/2404.05405) measure about 2 bits per parameter after about 1,000 exposures per fact and about 1 bit at 100 exposures. [Confirmed]
- **Real keys are not random.** Every count assumes independent random keys. Repeated entities and templated text give near-duplicate keys, and raising the softmax temperature cannot separate those. [Inferred] Zucchet's papers name "no shared structure across contexts" as the assumption most likely to fail, and the spurious-forgetting mechanism needs shared structure to occur at all (finding 4). [Confirmed]

The 1.2 million figure is retrieval from context, which is non-parametric storage. The thread's opening line about "the world's knowledge in its weights" sits next to it and invites conflating the two. [Inferred]

### 2. The seven checkpoints, read as stores

The mapping below is ours. [Inferred throughout, except where marked] It gives the architecture essay one currency for the components that the dossier explains separately: who writes each store, when, and what interferes.

| Component (models) | Store type | Written by | Interference control |
| --- | --- | --- | --- |
| Gated FFN | parametric, nonlinear | gradient, in training | the gate's nonlinearity; superposition across units |
| Routed experts (all seven) | sparse parametric | gradient, in training | the router as a coarse key match that removes most distractors before recall |
| Hash-routed early MoE layers (DeepSeek V4) | lookup keyed by token identity | gradient, in training | none needed for the key; the token ID is the address |
| Engram (V4.1-Flash, 196B) | learned lookup table | gradient, in training | addressing by lookup |
| Softmax attention: MLA, GQA, local windows | non-parametric; $M$ is the context or the window | the forward pass, at inference | exponential suppression of non-matching keys |
| Learned sparse selection: DSA, MSA, CSA's top-$k$ | non-parametric with a hard pre-filter | the forward pass; the indexer learned in training | the selector shrinks the distractor set; a miss is a new failure |
| Compressed entries: CSA, HCA | non-parametric, pooled | the forward pass | none within a pooled block; members share one entry |
| Gated delta rule: KDA (Kimi K3), GDN (Qwen3.8) | fast-weight linear store, $d_k\times d_v$ per head | one regression step per token, at inference | the delta rule's erase-before-write; gates decay old entries |
| AttnRes (Kimi K3) | non-parametric store over depth: earlier block outputs | each block, within one token's pass | softmax over a handful of sources |
| mHC (DeepSeek V4, V4.1) | fixed-size recurrent store over depth: four streams | each layer, within one token's pass | doubly stochastic mixing, which contracts differences between streams |

The two depth rows follow [*Depth Memory* (arXiv 2610.18809)](https://arxiv.org/abs/2610.18809), which casts AttnRes as an explicit and mHC as an implicit read/write memory over depth. [Confirmed] A store over depth lives only within one token's forward pass, so it belongs to the computation, not to what persists across tokens. [Inferred] For the Engram row, [*Atoms, Not Knowledge* (arXiv 2610.25317)](https://arxiv.org/abs/2610.25317) reports that single facts written into hashed n-gram memory are retrievable but not composable. [Reported: abstract only]

Two of these readings sharpen claims the dossier makes in prose.

- **The delta rule buys editing, not capacity.** Its batch fixed point is the least-squares store, which gains about a factor of two over the outer-product store in Wang's metric; exact recall stays bounded by the rank, $d_k$. [Inferred] [Schlag, Irie and Schmidhuber](https://arxiv.org/abs/2102.11174) motivated the delta rule by the need to overwrite stale bindings, not by capacity. [Confirmed] No published theorem gives the capacity of the online, per-token delta-rule update. The closest classical result is [Diederich and Opper (1987)](https://doi.org/10.1103/PhysRevLett.58.949): an iterative local rule that converges to the projection rule. [Reported] This fits the dossier's failure-mode list ("recurrent updates can overwrite a useful association") and gives it a size.
- **MoE costs little capacity.** In Allen-Zhu and Li's Result 9, a 32-expert GPT-2 MoE stores knowledge at 1.3 times less per total parameter than its dense counterpart (1.5 times at 100 exposures), even with top-1 routing, while using 8.8 percent of its parameters per token. [Confirmed] So an MoE's total parameter count, not its active count, is the better guide to what it can store. [Inferred] This supports the dossier's instruction to keep stored weights, active computation, context state and hardware time apart.

**The hybrids split the work in a way capacity is compatible with.** In [Afendulev et al. (arXiv 2609.04434)](https://arxiv.org/abs/2609.04434), Qwen3.5 hybrids at 4B to 27B keep exact key–value retrieval only through the KV cache (0.89 against 0.00 on Qwen3.5-4B). Output language and persona survive mainly through the recurrent state (0.70 against 0.01 for language). A state-swap takes the answer's value from one store and its language from the other, and Kimi-Linear-48B shows the same split. [Confirmed] A store of a few hundred clean associations per head (under vector recall, at $d_k=128$) cannot hold an arbitrary list of facts. It can hold a few settings that change slowly and condition everything generated, and those are what it holds. [Inferred] Capacity does not explain the split, though: the dictionaries had 15–30 entries, which a discrete readout could hold, and the authors report that the recurrent-only collapse persists in minimal tasks. In Lee et al., recall degrades from 8–16 bindings, far below the 256-dimensional keys. The routing is learned. [Confirmed for the facts, 26 October full read; Inferred for the conclusion] [GateSight (arXiv 2610.14754)](https://arxiv.org/abs/2610.14754) adds that most GDN heads in Qwen3.8-27B forget fast (median half-life about 24 tokens), with roles fixed by the weights. [Confirmed] So the long-lived settings must sit in the few slow heads, or be rewritten continually from context. [Inferred]

[Zhong et al.](https://arxiv.org/abs/2505.19488), the source of Wang's signal-to-noise estimates, already treat MoE as sparsity in FFN memory and DeltaNet as a regression memory with decay $I-kk^\top$, without a capacity number for either. [Confirmed]

### 3. Long context: temperature against near-duplicates

Raising the softmax temperature with the logarithm of the context length keeps suppression up as $M$ grows. Wang's simulations show near-unbounded recall with this rule: Su's entropy-invariant scaling, [Scalable-Softmax](https://arxiv.org/abs/2501.19399), Qwen's [LogN scaling](https://arxiv.org/abs/2309.16609) and the YaRN factor of [Qwen2.5-1M](https://arxiv.org/abs/2501.15383). [Confirmed for the post] The result holds for random distractors only. [Confirmed] It adds a mechanism to the dossier's section "Long context is also a training and evaluation problem": accepting a long input is limited by near-duplicate keys, not by the number of random ones, which is why the evaluation plan's "many competing facts" test matters. [Inferred] For Kimi K3, whose MLA layers use no positional encoding and whose KDA gates carry recency, the analogue of temperature scaling would have to be learned. [Inferred; NoPE in K3 is Confirmed in the dossier]

### 4. Training writes the stores in an order

Zucchet's papers turn the training-stage taxonomy of the dossier into a question about stores.

- **Knowledge waits for attention circuits.** In [Zucchet et al. (2503.21676)](https://arxiv.org/abs/2503.21676), 44M to 400M models learning synthetic biographies sit on a plateau before facts appear. The plateau grows almost linearly with the number of individuals. Patching in the attention patterns of a post-plateau checkpoint removes it, so the name-to-attribute circuits must form before the FFN stores can be used. [Confirmed] Hallucinations emerge together with knowledge. [Confirmed]
- **New facts collapse old ones fast, and the damage sits in the FFN.** Fine-tuning on new individuals collapses old-fact recall within about a hundred steps while attention patterns stay stable, so the authors place the corruption in the FFN key–value memories. Replay mitigates the final drop but not the initial decline. [Confirmed] This is the toy version of the SFT and mid-training risk that the dossier's stage list leaves implicit.
- **Repetition speeds the circuits.** [Zucchet et al. (2505.17863)](https://arxiv.org/abs/2505.17863) derive when sparse attention emerges in a toy model; the theoretical exponents do not carry over to a two-layer Transformer, and the fitted ones depend on the optimizer. In-context repetition speeds the emergence of an induction head about fourfold and cross-sample repetition about twofold. [Confirmed] There is no capacity result here.
- **Ambiguity divides capacity.** [Zucchet, Lee and Linderman (2608.15448)](https://arxiv.org/abs/2608.15448) prove that a linear-softmax head stores on the order of $hd/k$ contexts when each has $k$ plausible next tokens, with matching upper and lower bounds up to logarithms. [Confirmed] In the vocabulary of finding 1 this is a linear store under a discrete readout, and ambiguity divides its capacity by $k$. [Inferred]
- **Forgetting can be a shared shift, not erasure.** In [Palit et al. (2610.08718)](https://arxiv.org/abs/2610.08718), old facts look forgotten because gradient writes move every old hidden state along a common direction. Three ingredients are required: keys with a shared component, new values concentrated in part of the vocabulary, and normalization. In OLMo-2 1B, removing the top singular direction of each weight update restores old-fact recall from 0.28 to 0.77 at the trough. [Confirmed] The mechanism needs the key structure that the capacity counts assume away. [Inferred]
- **Scaling laws from storage.** Zucchet's [tutorial](https://nicolaszucchet.github.io/Tutorial-scaling-laws) derives compute-optimal scaling from a Zipf-distributed set of memories and concludes that the data, not the parameters, is the bottleneck. It says plainly that it cannot tell whether this mechanism limits real models. [Confirmed]

The fifth paper, [Zucchet and Linderman (2610.03529)](https://arxiv.org/abs/2610.03529), mentions the memory view once and does not depend on it; the "post-training as slight memory modification" framing is in the thread, not the paper. [Confirmed] Its entropy identity is already in *Who Teaches the Weights?*.

### 5. The interpretability debate is a debate about stores

The audit dossier's addendum records the Cammarata–Nanda exchange. Nanda's first crux, that facts form an unstructured key–value store best packed across neurons, is the associative-memory view applied to the MLP. [Inferred] Wang's post cites [Garcia et al., "MLPs are Hebbians"](https://arxiv.org/abs/2607.10034) for MLPs storing facts in superposition (not read here). The audit's thesis 2 asks for a sharper test: bind two existing entities arbitrarily and see whether the binding sits near both. Palit et al.'s shared key component suggests a second test: when new facts shift old ones along a common direction, does a neuron-level account show the shift as many small changes or as one? [Inferred]

## Consequences

**For the architecture series.**

- **Part 1 gets a spine.** The dossier's organizing question, "where each model spends computation and preserves information", becomes: which stores each model has, what writes them and when, and how each controls interference. Section 2's table is a draft of the comparison. It extends the "ladder of stores" in *Where Experience Goes* inward, from the stores around a model to the stores inside one, and can reuse its columns. [Inferred]
- **Capacity numbers need their criterion stated every time.** Quote vector-recall figures as Wang's, with his assumptions, and give the discrete-readout figure beside them where the readout is a choice among tokens.
- **The training section can be built on the order in which stores become usable**: attention circuits, then FFN facts; then the fragility of those facts under later stages (finding 4). Zucchet's results are at 44M to 1B parameters and on synthetic data, so the essay can offer them as mechanisms, not as measurements of the seven.

**For published and scheduled essays.** *(Applied 26 October: both essays now report Afendulev et al. and state the recall criterion. A full read of Lee et al. found four bindings in the development layout and degradation from 8–16 bindings, far below the key dimension; the number for the hybrid conditions is not stated. The essays call that routing learned rather than forced by capacity, which the full read supports.)*

- ***What Breadth Reaches* §3 (published; revised 25 October)** ends its recall paragraph with: "Recall of an explicit association is not the continuity at issue here, though, which is a standing background, a tone or an unworded partial understanding. No study we know of has tested that." Afendulev et al. (3 September) test the nearest measurable cases, output language and persona, and find them carried by the recurrent state. That is evidence for the "stronger hope" the paragraph counsels caution about, at 4B to 27B and for 48-token generations. The section's "capacity predicts as much" should also give its criterion (next item).
- ***Where Experience Goes* (scheduled for 2 November).** The paragraph on the Qwen3.5 recall study says "the recurrent layers did something else"; Afendulev et al. say what. The capacity paragraph after worked example G gives "about $d_k$" for outer products and "about $2d_k$" for least squares without naming the criterion. Under a discrete readout a $d_k\times d_v$ state holds on the order of $d_k d_v$ associations up to logarithms. So "Capacity predicts as much for any task with more associations than the state has dimensions" holds only under vector recall. Check the number of associations in the recall task of [Lee et al.](https://arxiv.org/abs/2609.33093) before relying on capacity to explain that result.
- The sentence "An MLP's nonlinearity suppresses interference, so the core weights hold far more than their width suggests" is right per key dimension. Per parameter, the advantage is not there (finding 1). "Width" should name the residual width if the sentence stays.

## Open work

- Read the papers that this note cites from Wang's reading list without having opened: Garcia et al. (2607.10034), Dugan et al. (2512.00207), the Engram paper (2601.07372), MesaNet (2506.05233) and test-time regression (2501.12352). The last two bear on what the delta rule approximates.
- Read Nichani et al. and Barnfield et al. in full for the discrete-readout constants.
- Check whether any of the seven models' FFN activation is a gated form whose capacity Wang's tied-gate estimate covers; untied SwiGLU is not analysed in the post.
- Work out what pooling does to capacity in CSA and HCA from the V4 report's equations, rather than from the table's reading.
