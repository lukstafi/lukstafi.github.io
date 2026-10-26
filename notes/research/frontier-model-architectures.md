# Research notes on seven open model architectures

Research date: 3 October 2026. Status: second research pass for a future blog essay, not a publication draft. Essay budget: approximately 8,000 words as a soft upper limit; this supporting dossier is not constrained to that length.

The essay will explain how Xiaomi MiMo-V2.6-Pro, Moonshot Kimi K3, Alibaba Qwen3.8-Max, Z.ai GLM-5.3, DeepSeek V4-Pro, DeepSeek V4.1-Flash, and MiniMax M3 extend the Transformer and how their training makes those extensions work. The strongest organizing question is **where each model spends computation and preserves information**: across tokens, across experts, across depth, and across training stages. This is an editorial synthesis, not a claim made by any one laboratory.

Primary reports, official model cards, and checkpoint configurations support the findings below. A reported capability gain is not an independently reproduced result. “Open weights” is the working description: accessible weights, permissive licensing, published training code, and reproducible training data are separate properties. A complete license and reproducibility comparison remains to be done.

The essay will also explicitly correct and improve three earlier pieces: [What Do Feedback Connections Actually Do?][E1], [The Dynamics That Matter][E2], and [What Breadth Reaches][E3], especially the third essay's section 3 on within-session state. Use the architecture analysis to repair their factual premises and sharpen their philosophical hypotheses; distinguish actual corrections from changes in the model landscape since publication.

## Resolve the exact models first

| Requested name | Research target | Boundary to preserve |
| --- | --- | --- |
| MiMo-V2.6-Pro | `XiaomiMiMo/MiMo-V2.6-Pro-RL`, with `Pro-MOPD` as a separate checkpoint | The official collection includes both RL and MOPD releases. Do not silently mix them. [MiMo collection][M0] |
| Kimi K3 | `moonshotai/Kimi-K3` | The released model has its own Kimi K3 license. [Kimi repository][K1] |
| Qwen3.8-Max | `Qwen/Qwen3.8-2.4T-A95B` for inspectable architecture | The Max service adds vision and non-thinking support; the open checkpoint is text-only and thinking-only. [Qwen card][Q1] |
| GLM-5.3 | `zai-org/GLM-5.3` | The card identifies GLM-5.2 as its base. GLM-5.3-Flash is a different research target. [GLM card][G1] |
| DeepSeek V4-Pro | `deepseek-ai/DeepSeek-V4-Pro-0813`, with the original `DeepSeek-V4-Pro` as the architecture reference | The 0813 release supersedes the preview and attaches DSpark to its model structure. Keep checkpoint-specific training and benchmark claims separate. [0813 card][D6] |
| DeepSeek V4.1 | `deepseek-ai/DeepSeek-V4.1-Flash` | Flash is the released V4.1 checkpoint verified in this pass. The release notice mentions a future V4.1-Pro; that is not evidence of released Pro weights. [DeepSeek card][D1], [release notice][D5] |
| MiniMax M3 | `MiniMaxAI/MiniMax-M3` | Separate production M3 from the smaller experimental model in the MSA paper. [MiniMax card][N1], [MSA paper][N3] |

API names need separate treatment: DeepSeek's September 10 notice says requests to `deepseek-v4-pro` route to V4.1-Flash from September 14 until V4.1-Pro launches. *(Corrected 26 October: the change log says V4-Pro service continues; see the addendum.)* A call using that alias therefore cannot establish that V4-Pro weights were evaluated. Use named checkpoints and provider deployment provenance for comparisons. [Official release notice][D5]

## Establish the Transformer baseline

The 2017 Transformer was an encoder–decoder translation system. Its encoder used unrestricted self-attention; its decoder combined causal self-attention with cross-attention to encoder outputs. Both used position-wise feed-forward networks, additive residual connections, and normalization after residual addition. Position information was added to embeddings. It was not the decoder-only, pre-normalized architecture often called “the original Transformer” today. [Attention Is All You Need, sections 3.1–3.5][B1]

For one attention head, the essential operation is

$$
\operatorname{Attention}(Q,K,V)
=\operatorname{softmax}\left(\frac{QK^\top}{\sqrt{d_k}}+M\right)V,
$$

where the mask $M$ excludes forbidden positions. Queries select information; keys determine compatibility; values supply the information being combined. Multiple heads learn different projections. [Transformer, section 3.2][B1]

Build the bridge to contemporary models using a schematic pre-normalized block:

```text
incoming representation
  → normalization → token mixing → residual combination
  → normalization → dense FFN or routed experts → residual combination
  → outgoing representation
```

This is an explanatory scaffold, not a complete implementation shared by all seven models. In particular, AttnRes and mHC change the residual combination itself.

The bridge needs four short explanations:

- **Normalization and gated feed-forward networks.** RMSNorm rescales without LayerNorm's mean subtraction. A gated linear unit multiplies two projected branches; SwiGLU uses a smooth nonlinear gate. These are distinct changes to normalization and channel mixing. [RMSNorm][B2], [GLU variants][B3]
- **Position information.** RoPE rotates query/key features so attention scores encode relative position. Do not assume every modern model uses it: the Kimi K3 report explicitly describes a NoPE language backbone. [RoFormer][B4], [Kimi report, section 3.4][K3]
- **KV storage.** Grouped-query attention (GQA) lets several query heads share key/value heads. Multi-head latent attention (MLA) instead compresses KV information into a latent representation. Neither mechanism alone is token sparsity. [GQA][B5], [DeepSeek-V2][B6]
- **Conditional computation.** An MoE router chooses a small set of feed-forward experts per token. More stored parameters need not imply proportionally more arithmetic for each token. Routing, balancing, and communication still cost resources. [Sparsely-gated MoE][B7]

For the essay, distinguish four quantities throughout: stored weights, active computation, context state, and hardware time. “Active parameters” is not a measurement of latency or total memory.

## Recurrent state and long context

### Which models have state-space components

**Kimi K3 and Qwen3.8-2.4T-A95B are hybrids of recurrent linear attention and explicit attention.** Kimi combines KDA with gated MLA; Qwen combines Gated DeltaNet with gated attention. Their recurrent layers maintain a fixed-size evolving state rather than an ever-growing list of token KV entries. [Kimi architecture][K1], [Qwen architecture][Q1], [KDA][B8], [Gated DeltaNet][B10]

“State-space component” needs a definition. In a broad mathematical sense, an input-dependent recurrence can be written schematically as

$$
h_t=A_t h_{t-1}+b_t,\qquad y_t=C_t h_t,
$$

where the transition, write, and read operations can depend on the current input. The state may be a matrix flattened into a vector. Structured state-space models constrain these operations to make them efficient. Mamba makes the state update selective through input-dependent parameters; Mamba-2 develops the connection between structured state-space recurrences and particular attention formulations. This does not make ordinary softmax attention equivalent to a fixed-size Mamba state. [Mamba][B12], [Mamba-2 and state-space duality][B13]

Gated DeltaNet and KDA belong to this broader recurrent-memory territory, but are best named explicitly as **gated delta-rule linear attention**, rather than described as Mamba layers. Gated DeltaNet combines forgetting with targeted correction of an associative memory; KDA refines forgetting to operate per channel. The Gated DeltaNet paper also experiments with Mamba2 hybrids, but that does not establish the presence of Mamba2 blocks in Qwen or Kimi. [Gated DeltaNet][B10], [KDA][B8]

For the exact seven language backbones in scope, the inspected sources do not identify an explicit Mamba/S4 block. This is a classification of the published designs, not a claim that no state-space interpretation is possible. Do not transfer architecture claims from another Flash release or another generation with the same vendor name.

### What each design preserves from the past

The distinction is between retaining separately addressable entries and folding past information into a running state. Ordinary causal attention retains per-position KV representations, not the raw text itself. Recurrent linear attention updates an associative state; the original token contributions cannot generally be recovered separately. The original linear-attention work shows how the same operation can have attention-like and recurrent forms. [Transformers are RNNs][B14]

```text
Explicit context memory                 Recurrent context memory

token 1 → KV entry 1 ─┐                  state at t−1 + token t
token 2 → KV entry 2 ─┼→ query/read                 ↓
token 3 → KV entry 3 ─┘                    updated state at t
                                                  ↓
                                          query/read from state

Sparse: choose entries to read.          State size stays fixed.
Compressed: merge entries first.         Contents are continually rewritten.
```

These choices create different possible failure modes: a selector can miss a useful entry, compression can discard a useful distinction, and recurrent updates can overwrite a useful association. This is a mechanistic interpretation, not a measured ranking of the seven models. Keeping explicit attention layers alongside recurrent layers provides another route to context that has not been folded into the recurrent state. [Linear attention][B14], [Kimi Linear discussion][B8]

| Model | Long-context mechanism | Distinction to explain |
| --- | --- | --- |
| MiMo-V2.6-Pro | Many local windows, occasional global GQA layers | Local layers limit direct access; global layers retain a path to distant positions. [M1] |
| Kimi K3 | KDA recurrent layers interleaved with gated MLA | Fixed-size recurrent memory plus explicit global context; MLA also compresses KV features. [K1] |
| Qwen3.8 open Max-class checkpoint | Gated DeltaNet interleaved with gated GQA | Similar recurrent/attention division, with a different recurrent update and global-attention design. [Q1] |
| GLM-5.3 | DSA sparse selection, MLA-style KV, IndexShare | Select positions and amortize selection across layers; recurrence is not the main context mechanism. [G2], [G3] |
| DeepSeek V4-Pro | CSA, HCA, and local windows | CSA selects among compressed entries; HCA reads a much more compressed history without top-k selection. [D4] |
| DeepSeek V4.1-Flash | CED, CSA2, shared KV/selections, hierarchical indexing, low-precision KV | Changes both how context is stored/read and which layers process prompt tokens. [D1], [D2] |
| MiniMax M3 | MSA selects blocks separately for each GQA group | Select blocks of retained positions; this is different from compressing their values into one entry. [N3] |

AttnRes and mHC operate across network depth and should have their own explanation. MoE sparsity selects **parameterized transformations**, while attention sparsity selects **context entries**. Engram adds learned lookup memory; it is not the evolving recurrent summary of the current conversation. [Attention Residuals][B9], [mHC][B11], [MoE][B7], [DeepSeek-V4.1 report][D2]

### How the costs scale

The table below is an explanatory derivation from the mechanisms, not a benchmark. Let $L$ be the context length, $w$ a fixed local window, $k$ the number of selected entries, and $c$ a fixed compression ratio. Hold head counts, feature widths, state dimensions, and model depth constant. “Prefill” processes the prompt; “decode” adds one generated token. State means persistent sequence memory during inference, excluding weights, temporary buffers, and training activations.

| Isolated token mixer | Prefill mixing work | Mixing work for one new token | Persistent sequence state |
| --- | --- | --- | --- |
| Full causal attention | $O(L^2)$ | $O(L)$ | $O(L)$ |
| Sliding-window attention | $O(Lw)$ | $O(w)$ | $O(w)$ with a rolling cache |
| Selected-entry attention | $O(Lk)$ **plus selection** | $O(k)$ **plus selection** | Usually $O(L)$ when all entries remain candidates |
| Attention over history compressed by $c$ | $O(L^2/c)$ plus compression | $O(L/c)$ plus compression | $O(L/c)$ |
| Fixed-dimension recurrent mixer | $O(L)$ | $O(1)$ in context length | $O(1)$ in context length |

Foundations: [Transformer][B1], [linear attention][B14], [state-space duality][B13]; the sparse and compressed rows specialize the selection and compression operations in [MSA][N3] and [DeepSeek V4][D4]. Combining compression with sparsity changes the corresponding terms again. Block selection reads the selected blocks' tokens, so count entries actually read, not just the number of blocks.

Three qualifications are essential:

- **Sparse reads do not imply bounded storage or cheap selection.** If the indexer scores every earlier position, its work still grows with context even when the main attention reads a fixed number. Index sharing reduces repeated work; hierarchical selection reduces the candidate set for later searches. [MSA][N3], [GLM IndexShare][G3], [CSA2][D2]
- **A recurrent/attention hybrid is not a wholly constant-memory model.** Its remaining global-attention layers still accumulate context state. With a fixed nonzero fraction of dense global-attention layers, quadratic prefill and linear decode terms remain asymptotically, although their coefficients can be much smaller. This follows from summing the per-layer costs above; it is not a prediction of wall-clock speed.
- **Different optimizations change different dimensions.** GQA shares KV heads; MLA compresses features; CSA/HCA compress positions; KV quantization reduces bytes per entry. FlashAttention improves memory traffic for exact attention without making its mathematical attention pattern sparse. [GQA][B5], [MLA][B6], [V4][D4], [V4.1][D1], [FlashAttention][B15]

Recurrence during decoding also does not require training through a naive token-by-token Python loop. Structured recurrences admit parallel and chunkwise algorithms; their training implementation and memory costs must be distinguished from the small state carried during inference. [Gated DeltaNet][B10], [Mamba-2][B13]

### Recurrence, circuit depth, and effective memory

**A fixed number of model layers does not establish constant circuit depth for a recurrent hybrid.** We need to distinguish the following meanings of depth. Let $L$ be input length and $D$ the number of model layers.

| Meaning | What we can say |
| --- | --- |
| Architectural depth | The checkpoint has a fixed stack of $D$ layers. Each new token traverses this stack using previously computed states. |
| Depth of a sequentially unrolled recurrence | One recurrent layer contains a chain of $L$ state updates. Its history-to-output dependency path grows with the input. |
| Parallel evaluation depth | Affine state updates can be composed in a balanced tree with $O(\log L)$ composition stages at fixed state dimension. This is an upper bound in an arithmetic-operation model, not a lower bound or a wall-clock prediction. |
| Minimum circuit depth | Requires specifying allowed gates, size, precision, and evaluation conventions. Some recurrences admit much shallower equivalent circuits than their sequential execution suggests. |
| Effective memory or reasoning horizon | A property of the learned computation and task. It cannot be inferred just from layer count, recurrent state size, or the nominal context window. |

To see the parallelization directly, write one layer as $h_t=A_t h_{t-1}+b_t$, with its coefficients computed from that layer's input sequence. Two consecutive updates combine as

$$
(A_2,b_2)\circ(A_1,b_1)=(A_2A_1,\ A_2b_1+b_2).
$$

Composition is associative, so a tree or prefix scan can evaluate the recurrence. This derivation assumes exact arithmetic; floating-point reassociation can change rounding, and bit-level circuit depth must account for arithmetic precision. The matrices need not commute. Their compact affine representation makes composition tractable; arbitrary nonlinear recurrent maps generally lack the same compact closure. The network remains nonlinear in its inputs even when its state update is affine conditional on the input. [Linear-RNN parallelizability][B18]

The familiar constant-depth result refers to **polynomial-size, constant-depth threshold circuits**, $\mathsf{TC}^{0}$, whose gates can have unbounded fan-in. Under its stated arithmetic assumptions, *The Illusion of State in State-Space Models* places fixed-depth transformers and important SSM subclasses, including diagonal Mamba-style transitions, in this class. It does not place every input-dependent matrix recurrence there. Limitations relative to $\mathsf{NC}^{1}$-complete state tracking assume the unproved separation $\mathsf{TC}^{0}\ne\mathsf{NC}^{1}$. These are asymptotic expressivity statements, not a proof that a particular finite prompt cannot be solved. [Illusion of State][B16]

For our recurrent hybrids, transition structure matters. In a common column-state convention, Gated DeltaNet uses $A_t=\alpha_t(I-\beta_t k_tk_t^\top)$, while KDA uses $A_t=(I-\beta_t k_tk_t^\top)\operatorname{Diag}(\alpha_t)$. The rank-one correction mixes state coordinates; neither family is simply the diagonal case covered by the Mamba result. [KDA equations][B8]

Recent theory strengthens the reason for caution. *Why Are Linear RNNs More Parallelizable?* proves log-depth arithmetic-circuit upper bounds and expressivity results for particular transition families. Its general DPLR/DeltaNet constructions are not automatically constructions available under a production checkpoint's normalization and parameter constraints. [B18] *Olmo Hybrid* establishes a state-tracking-plus-retrieval advantage for a formal hybrid using GDN **with negative eigenvalues** and averaging-hard attention; its discussion leaves aspects of GDN without the negative-eigenvalue extension open. [B19] *Complex KDA* likewise obtains stronger state-tracking constructions by extending gate and delta-coefficient ranges. It is a separate proposed variant, not evidence that Kimi K3 uses those extensions. [B20]

Thus we should not assign Qwen3.8 or Kimi K3 a precise expressivity class from the names “linear attention” or “delta rule.” The second-pass implementation audit below finds sigmoid-bounded delta coefficients and positive retention in the inspected paths, without the explicit negative-eigenvalue extension used in some constructions. Numerical conventions, dependency versions, and complete layer composition still matter. Fixed-size recurrent memory also does not imply constant circuit depth: a bounded state can undergo arbitrarily many order-sensitive transitions, although it cannot retain arbitrarily many independent facts at fixed precision.

“Limited effective depth” needs an operational definition. For an isolated affine recurrence, holding its input-derived coefficients fixed, an earlier state's influence propagates through $A_t\cdots A_{s+1}$. If each transition is uniformly contractive with norm at most $\rho<1$, that influence is bounded by $\rho^{t-s}$. This explains one possible forgetting mechanism, but learned gates can retain some directions much longer; other layers and explicit attention provide additional routes. A short effective horizon is therefore a hypothesis to measure, not a consequence of recurrence alone.

Finally, one pass over a supplied prompt differs from generating intermediate tokens and feeding them back. Autoregressive scratchpad generation adds computational rounds even to an ordinary transformer. Formal results show that the number of such rounds can change expressivity under their stated model assumptions. Keep prompt length, recurrent processing, and generated reasoning length separate. [Transformer chain-of-thought expressivity][B17]

Suggested essay wording: **“These models retain a fixed stack of learned layers. Recurrent attention adds computation across token positions, so layer count alone no longer bounds history-to-output depth. The remaining limits depend on the transition algebra, arithmetic, and whether the model can generate intermediate steps.”**

### Why depth matters for monitorability—and what it does not establish

The user's motivation for the depth question is monitorability and explainability. They supplied an X post comparing Astra's computation-graph depth with GPT-4's, claiming a difference within a factor of two. The original post did not load during this research pass; retain the statement as a user-supplied quotation pending verification of attribution, context, and what is counted as a graph step. [User-linked post][S1]

Our interpretation: if this measures the fully unrolled computation between emitted tokens, including any internal iterations, it constrains claims of a vastly deeper hidden serial computation per token. If it counts only distinct parameterized layers, it does not bound repeated execution. Neither reading by itself measures how much useful computation the learned network can perform, whether relevant information becomes text, or whether a monitor can interpret that text. A factor-of-two depth change is also not a factor-of-two bound on capabilities.

The optimistic monitoring argument has several separate premises: a relevant task exceeds the model's capacity without a scratchpad; solving it requires observable intermediate computation; and the monitor can recognize the concerning property in those observations. Research on CoT necessity provides empirical support in selected tasks, while explicitly distinguishing necessity from monitorability and acknowledging that concerning intent can remain hidden even when task calculations are visible. [CoT necessity][S2]

For the architecture comparison, distinguish three paths:

- **Recurrence across token positions**, as in KDA/GDN: persistent numerical state can carry information that is not expressed in the emitted token. Ordinary transformers also retain numerical KV activations, so natural-language tokens are not generally the only information passed between decoding steps.
- **Recurrence through model depth**: repeated latent updates before emitting another token increase hidden serial work; these must be counted when using depth as monitoring evidence. This is distinct from KDA/GDN sequence recurrence and is not established for Astra by the supplied quote.
- **Autoregressive token generation**: provides additional computational positions, but text that supports computation need not provide a faithful explanation of it. Whether a particular model uses unreadable encodings is an empirical question.

A new theoretical preprint makes the latter distinction explicit: in its specified tasks and fixed-precision model, difficult covert computation must leave information in the CoT, but a construction using private randomness and cryptographic assumptions can make that information computationally inaccessible to a monitor. Its monitor does not observe the covert input or output. This is a limitation of a general transparency guarantee, not evidence that deployed models perform such encryption. [Hidden-reasoning footprint][S3]

The public Astra system card reports reduced CoT monitorability and stronger no-CoT performance. It also reports unsuccessful attempts to hide demanding side-task reasoning in its tested steganography setting. UK AISI's separate assessment describes monitoring-relevant capabilities, but did not directly establish successful monitor evasion and notes evaluation limitations. These empirical findings should carry more weight than depth alone. [Astra system card, section 9][S4]

**Monitorability is detection; explainability is a causal account.** A monitor might detect an unauthorized action without reconstructing its underlying reasoning. Conversely, a readable explanation may omit a decision's actual cause. Our essay should assess observations available to the monitor (raw CoT, summaries, actions, activations), detection at a fixed false-positive rate, and causal intervention evidence separately. For recurrent layers, state ablation or patching can test whether a relevant dependency is carried in persistent memory rather than verbalized. Depth is an architectural constraint, not an interpretability certificate.

### Long context is also a training and evaluation problem

The essay should separate accepting a long input, processing it affordably, and using its distant contents reliably. An architectural memory saving establishes none of the latter behavior by itself. Our evaluation plan should test exact retrieval, many competing facts, order-sensitive tasks, and reasoning across separated passages; report prompt length, answer length, and any external context compaction separately.

Training examples matter because selectors and recurrent updates must learn what to retain. MiniMax's indexer warmup and auxiliary supervision, Kimi's context curriculum, and DeepSeek's transition from dense to sparse training provide concrete case studies already documented below. Positional extrapolation is another issue: enlarging a supported position range does not on its own teach a model to solve long-range tasks. [MSA][N3], [Kimi report][K3], [V4 report][D4]

## Architecture comparison

Here B means billion parameters and T means trillion. Counts are publisher-reported; configurations are evidence about the released checkpoint, not proof of its entire training history.

| Model | Reported total / active | Language backbone | Routed experts selected / available |
| --- | --- | --- | --- |
| MiMo-V2.6-Pro-RL | 1.02T / 42B | 70 layers: 60 sliding-window, 10 global | 8 / 384; no shared experts |
| Kimi K3 | 2.8T / 104B | 93 layers: 69 KDA, 24 gated MLA | 16 / 896; 2 shared |
| Qwen3.8-2.4T-A95B | 2.4T / 95B | 92 layers: 69 Gated DeltaNet, 23 gated attention | 10 / 512; 1 shared |
| GLM-5.3 | Parameter accounting still to reconcile | 78 layers; MLA-style projections, DSA and shared indexing | 8 / 256; 1 shared |
| DeepSeek-V4-Pro | 1.6T / 49B for the reported original model; audit the 0813 drafter separately | 61-layer causal stack; CSA/HCA with local attention and mHC | 6 / 384; 1 shared |
| DeepSeek-V4.1-Flash | 552B backbone + 196B Engram; 8B prefill / 16B decode | 20 causal encoder + 20 decoder layers | 6 / 384; 1 shared |
| MiniMax M3 | Approximately 428B / 23B | 60 language layers; GQA-based sparse attention | 4 / 128; 1 shared |

Sources: [MiMo card][M1], [Kimi repository][K1], [Qwen card][Q1], [GLM config][G2], [DeepSeek V4-Pro card][D3] and [config][D7], [V4.1-Flash card][D1], [MiniMax card][N1] and [config][N2]. The GLM total is deliberately left open rather than inferred from a family name or rounded third-party count.

### MiMo uses frequent local attention and occasional global attention

The first block combines global attention with a dense FFN. Subsequent blocks use MoE. Local attention has a 128-token window; global layers connect distant context. Both attention types have 128 query heads and 8 KV heads. The released system also includes a MiMo ViT, audio encoders, and a five-layer speculative drafter. [MiMo card, Model Architecture][M1]

Conceptual path:

```text
text embeddings + encoded image/video/audio inputs
  → initial global-attention / dense-FFN block
  → interleaved local/global attention with routed FFNs
  → next-token distribution
```

Training is especially instructive. Pro's 30T-token pretraining consists of 27T text-only tokens followed by 3T multimodal tokens, using AdamW. Mid-training develops agent abilities, extends context from 256K to 1M, introduces MXFP4 quantization-aware training, and switches hidden matrices to Muown, a Muon variant with row-norm control. Embeddings, output head, and router retain AdamW. A short SFT stage precedes mixed-task asynchronous GRPO; MOPD2 subsequently combines teacher guidance with student-generated continuations and teacher/SFT prefixes. [MiMo report, sections 3–5][M2]

The pinned RL and MOPD configuration objects are identical. Their equality establishes the same declared architecture, not identical weights or behavior. MOPD2's three streams are autonomous student rollouts scored by mixRL teachers, student turns continuing teacher-generated histories, and student continuations of SFT demonstrations. This makes the distinction between demonstrations as training targets and demonstrations as starting contexts concrete. The MOPD card also reports addressing repetitive tool calls. [MOPD card][M3]

The essay should explain why locality and global access complement one another, then connect the training schedule to changing precision, context length, and agent behavior. Verify which drafter belongs to each checkpoint and serving configuration before presenting a deployment diagram: the report distinguishes training-rollout drafting from inherited MTP configurations. [MiMo report, inference infrastructure][M2]

### Kimi changes token mixing, expert width, and depth access together

K3 pairs recurrent KDA with occasional gated MLA and adds attention over earlier representations through AttnRes. Stable LatentMoE performs routed computation in a narrower latent space while retaining shared experts. The architecture therefore makes three separate choices: how to retain sequence history, which channel transformations to execute, and which earlier-depth representations to retrieve. [Kimi repository][K1], [Kimi report, section 2][K3]

```text
text / MoonViT-V2 features
  → 23 × [KDA, KDA, KDA, gated MLA] → final gated MLA
  → output head

Across depth: AttnRes
Feed-forward path: initial dense layer, then Stable LatentMoE
```

KDA extends Gated DeltaNet with channel-wise forgetting; it does not store every past token as a conventional attention cache. AttnRes is attention along **depth**, not another token-attention mechanism. Its block version retains summaries of layer groups to control overhead. [Kimi Linear][B8], [Attention Residuals][B9]

K3 jointly trains vision and language from the start. Context grows through 8K, 64K, 256K, and 1M stages. Post-training uses SFT, then nine policies spanning three domains and three reasoning efforts, followed by multi-teacher on-policy distillation. [Kimi report, sections 3–4][K3]

Quantile Balancing addresses expert allocation; Per-Head Muon treats attention heads separately during optimization. SiTU controls activation growth. Quantization-aware post-training begins at SFT, using MXFP4 expert weights and MXFP8 activations. These are training and numerical choices that support the architecture, not extra attention layers. [Kimi technical blog, Architecture and Infrastructure][K2]

### Qwen combines recurrent and explicit attention layers

The checkpoint repeats three Gated DeltaNet/MoE layers and one gated-attention/MoE layer 23 times. Its global attention uses 64 query heads and 4 KV heads. Native context is 262,144 tokens, with extension to 1,010,000; the card also reports multi-step MTP training. [Qwen card, Model Overview][Q1]

```text
text → 23 × [Gated DeltaNet + MoE]³ [gated attention + MoE]
     → output head
```

Gated DeltaNet combines forgetting with targeted memory correction. An educational, column-vector form is

$$
\widetilde S_t=\alpha_t S_{t-1},\qquad
S_t=\widetilde S_t+
\beta_t\bigl(v_t-\widetilde S_t k_t\bigr)k_t^\top,
\qquad o_t=S_tq_t.
$$

The term in parentheses is the error in the state's current prediction of the value associated with the key. This illustrates the memory update; it omits normalization, convolution, projections, and implementation details. It is not a claim that Qwen's implementation consists solely of these equations. [Gated Delta Networks][B10]

Research gap: the inspected Qwen card establishes architecture much better than training provenance. Obtain a detailed Max/2.4T report before assigning token budgets, optimizer settings, reward algorithms, or a specific distillation pipeline. The blog was located but did not yield readable body text through the browser fetch. [Qwen blog][Q2]

### GLM separates inherited architecture from new post-training

The released config specifies three initial dense FFNs, latent KV rank 512, a sparse indexer selecting up to 2,048 positions, and an indexing pattern shared across groups of layers. [GLM config][G2]

GLM-5.2 introduced IndexShare: one indexer supplies selections to four successive layers. Its MTP work also reuses indices and KV and addresses mismatches between drafter training and inference. The important distinction is between sharing **which positions to read** and sharing **the representations stored for those positions**. [GLM-5.2 announcement, architecture sections][G3]

GLM-5.3's announcement attributes its improvements to expanded post-training on the same base, with more environments, task diversity, and compute. It names IndexShare, SAO, and slime as the existing stack. [GLM-5.3 announcement][G4]

The predecessor's account describes critic-based PPO for variable-length, compacted trajectories and OPD consolidation of specialist models. Treat this as documented lineage; do not assume every GLM-5.2 training setting remained unchanged in 5.3. [GLM-5.2 announcement, training sections][G3]

This is the essay's clearest example of why a new model release need not mean a new neural architecture.

### DeepSeek V4-Pro combines two levels of context compression

V4-Pro supplies the large-model DeepSeek comparison, while V4.1-Flash supplies a later architectural redesign. The original Pro has 1.6T total and 49B active parameters and supports 1M context. [V4-Pro card][D3]

Compressed Sparse Attention (CSA) compresses context entries fourfold, then selects relevant entries. Heavily Compressed Attention (HCA) compresses 128-fold and attends over the resulting compressed history without sparse selection. Both supplement compressed history with local attention. These are different ways of preserving access to distant information. [V4 report, section 2.3][D4]

```text
text embeddings → 61 causal blocks → output head
                   token mixing: CSA / HCA + local attention
                   channel mixing: MoE
                   depth mixing: mHC
```

The original config specifies hidden width 7,168, a 128-token local window, four residual streams, and six selected routed experts out of 384, plus one shared expert. The first two layers use 128-fold compression; layers 2–60, indexed from zero, alternate fourfold and 128-fold compression, starting and ending with fourfold. The first three layers use token-ID-based expert selection, rather than dense FFNs; later layers select experts from hidden-state scores. [V4-Pro config][D7], [Pro-0813 reference implementation][I4]

The report describes 33T-token Pro pretraining with Muon for most parameters and AdamW for embeddings, output head, and RMSNorm. Context grows from 4K through 16K and 64K to 1M; dense-attention training precedes indexer warmup and sparse training. Post-training builds specialists through fine-tuning and GRPO, then consolidates them through OPD. [V4 report, sections 4.2 and 5.1][D4]

The official 0813 checkpoint retains the preview model structure and adds a DSpark speculative decoder. Its card does not document a complete revised training recipe; do not present the preview report as exhaustive documentation of 0813. [0813 card][D6]

Editorial reason to include both: Pro lets us explain compression and residual mixing before examining V4.1-Flash's separation of prompt encoding from decoding. The version number alone does not order model size or establish comparable capabilities.

### DeepSeek V4.1-Flash separates prompt encoding from full decoding

CED constructs the decoder's global KV from final encoder states. Most prompt tokens can therefore avoid full decoder computation, while generated tokens use both halves. CSA2 shares KV and sparse selections across layers; hierarchical indexing limits later searches. This is a causal architecture, not a return to the original bidirectional translation encoder. [DeepSeek report, sections 2.1–2.3][D2]

```text
text + visual embeddings → 20-layer causal encoder
                              ↓ final states supply global decoder KV
                         20-layer decoder → output head
```

The system also has Single-Pass mHC, Engram lookup memory, FP4 global KV, and DSpark speculative decoding. Engram's 196B parameters must be counted separately from the reported 552B backbone. The published 890 bytes/token describes global KV, not all weights, temporary activations, or local state. [DeepSeek card][D1]

The report describes 45T-token multimodal pretraining and SFT → RL → OPD. Matrix updates use Muon, with head-wise treatment for attention projections; large embedding tables use Sinkhorn-balanced updates. Vision inputs participate from the start of language pretraining, but the vision encoder is frozen until learning-rate decay. “Native multimodal” therefore does not imply every module trains from scratch together. [DeepSeek report, sections 2.5, 4–5][D2]

For depth mixing, first explain mHC as constrained mixing of multiple residual streams, then explain what changes in the Single-Pass variant after a closer equation-level reading. Do not equate mHC with Kimi's retrieval over depth. [mHC paper][B11]

### MiniMax learns which blocks of context to read

M3's released configuration uses 64 query heads and 4 KV heads, with three initial dense FFNs followed by MoE. Its attention schedule also begins with three full-attention layers, followed by 57 sparse-attention layers. *(26 October: M3.1-Flash is sparse in all 60 layers, and M3 also carries a 7-module MTP drafter; see the addendum.)* Its vision stack has 32 layers and projects into the language backbone. [MiniMax config][N2]

MSA adds a lightweight index branch that selects KV blocks separately for each GQA group. Main attention is computed over selected blocks, including a mandatory local block. Selection uses non-differentiable top-k, so the indexer learns through a KL objective matching the main branch's attention. Stop-gradients keep that auxiliary objective from changing the backbone; full-attention warmup precedes sparse selection. [MSA paper, section 3][N3]

```text
normalized hidden state
  ├─ index branch → per-group selected blocks ─┐
  └─ Q/K/V projections → sparse attention ←───┘
                           ↓
                      residual / FFN
```

The model card describes mixed-modality training from the first step. However, the MSA paper's controlled experiments use a 109B model and a 3T-token budget. Those are not M3's approximately 428B production-model training totals. Full M3 data and post-training details remain a research gap. [MiniMax card][N1], [MSA paper, section 5][N3]

## Explain the training stages without conflating them

The cross-model story should explain what each stage changes, then attach model-specific evidence:

1. **Pretraining** learns representations and prediction from the data distribution. Compare modalities, corpus processing, objective, and total training exposure. Count visual tokens carefully before comparing token budgets.
2. **Mid-training and context extension** adapt data, sequence length, sometimes architecture, precision, or optimizer. This can be a substantial training phase rather than a configuration toggle.
3. **SFT** teaches response and tool-use patterns from demonstrations. Its examples can include full trajectories; the training mask determines which tokens receive a loss.
4. **RL** learns from generated trajectories and outcomes. Separate the policy, environment, reward/verifier, advantage estimator, and optimizer. A successful test run does not automatically distinguish a robust solution from reward exploitation.
5. **On-policy distillation** uses teacher feedback on states visited by the student. Distilling specialist policies into a single checkpoint is different from having routed neural experts inside that checkpoint.
6. **Inference** can spend additional computation on reasoning or drafting. A speculative drafter proposes tokens for target-model verification; it is not evidence that the main model emits independent future tokens without verification.

This is an explanatory taxonomy assembled from the reports above, not a universal recipe. In particular, the inspected sources do not establish one common six-stage pipeline for Qwen and MiniMax.

## Revisiting our earlier claims about recurrence and dynamics

Devote approximately 1,200 words of the eventual essay to this retrospective, after readers have seen the mechanisms and training procedures. The correction ledger below is research scaffolding; the published section should develop a connected argument with direct links to all three earlier essays. Their useful starting point survives: the function of feedback matters more than the mere presence of a loop. What needs correction is the move from that observation to sweeping claims about which systems have dynamics, integrate knowledge, or could be conscious. The within-session account in *What Breadth Reaches* supplies the most direct bridge to the seven-model architecture comparison.

### Correct the unit of analysis

The [feedback essay, sections 5 and 8][E1] describes autoregressive inference as having no iteration or settling and puts all inferential work into training. This confuses a token-level evaluation with an entire generated trajectory. Even an ordinary autoregressive transformer performs successive evaluations conditioned on earlier output; the circuit-depth section above explains why extra generated positions can change computational power. KDA/GDN add explicit recurrence across sequence positions. Neither mechanism should automatically be called convergence to an equilibrium. [CoT expressivity][B17], [KDA][B8], [GDN][B10]

Frozen learned parameters also do not imply a static computation. In delta-rule attention, an evolving associative-memory matrix can be interpreted as fast weights updated by an online learning rule while the projections that generate the updates remain fixed. This makes a strict contrast between parameter learning and activation dynamics misleading unless we identify which variables change and when. In-context gradient-descent constructions provide another concrete counterexample to the claim that learning-like computation must occur through an external training update; their evidence concerns controlled regression settings, not every LLM computation. [KDA's online-learning formulation][B8], [in-context gradient descent][B21]

A recurrent process can be unrolled into a directed acyclic graph over a finite horizon. Therefore, the presence of backward arrows in a static layer diagram cannot by itself decide whether feedback was implemented across time. Conversely, equivalence of computed outputs does not establish equivalence of physical causal organization, a distinction that matters for theories making claims about that organization. Specify the system boundary, state, schedule, and interventions before comparing architectures.

### Replace categorical claims with narrower ones

| Earlier claim and location | Correction for the new essay |
| --- | --- |
| The feedback essay, §§5, 8–9: diffusion is closer to consciousness because it iterates, whereas autoregression does not. | Compare what is revised: output positions, recurrent memory, latent representations, or an external plan. Iteration alone supplies no justified ordering of consciousness likelihood. |
| The dynamics essay, §§1 and 7: compositionality and heterogeneous integration require parametric updating; harness memory cannot provide them. | Retrieving content does not prevent subsequent computation from integrating or composing it. Durable consolidation, retrieval cost, transfer, interference, and automatic use are different empirical questions. The claimed necessity of parameter updates is not established. |
| The dynamics essay, §7: lower sample efficiency indicates deeper integration, while very efficient learning would be superficial or fragile. | Retract this inference. Sample efficiency depends on prior knowledge, task, update rule, and evaluation; it is not an independent measure of integration depth. |
| The dynamics essay, §§2–3: pure gradient descent is memoryless and inference has no relevant trajectory memory. | Gradient descent lacks a separate momentum variable, but its current parameters depend on previous updates. Likewise, cached KV and recurrent state retain different forms of history. Distinguish state dependence, explicit momentum, and recoverable information. |
| The dynamics essay, §3: agent–environment coupling between inference events is insufficient because it does not occur during them. | Alternating observation, computation, action, and response can form a closed feedback loop. Choosing one neural evaluation as the system boundary excludes this loop by definition, not by evidence. Offline exposure to world-generated data is also different from action-dependent feedback; the essay inconsistently uses both meanings. |
| The dynamics essay, §§5, 8 and 10: backpropagation is categorically irrelevant to phenomenal dynamics. | Backprop computes derivatives and is not, merely by being backward, cortical predictive feedback. That functional distinction does not prove consciousness irrelevance. Assess the complete update process under an explicit theory rather than excluding it by algorithm name. |

These are corrections to our arguments, not claims that the works invoked in the original essays endorse our stronger conclusions. Re-read those sources before attributing any necessity or impossibility claim to their authors.

### What Breadth Reaches and state within a session

The primary target is [section 3, **The Medium Timescale: Architectural Affordances Within a Session**][E3]. Its question is how an ongoing computation carries and changes its internal state: a developing understanding, an unresolved problem, or a persistent affect-related disposition. It contrasts token-indexed KV storage with separately updated recurrent memory. Section 2, **The Long Timescale: Integration Across Sessions**, remains a secondary topic. A rolling-context boundary or compaction event can occur within a session; neither should be conflated with starting a new session.

Section 3 already explicitly acknowledges that the cache contains contextual representations beyond surface tokens. Sauers, Imago, Janus, and Tessera likewise investigate persistent internal features beyond overt textual subject matter; the existence of unspoken information is not a correction to their position. [Persistence study][B24]

The retrospective should address a narrower tension in our essay: after acknowledging rich KV state, it infers too much from that state's positional organization about what continuity attention can support. Preserve the distinction between a token-indexed cache and a separately updated recurrent memory, while describing **storage, updates, access, and retention** rather than treating text-anchored state and thought-space state as exclusive categories. Both are numerical representations computed from input history; indexing an activation by a token does not mean its content is confined to that token's explicit meaning.

The central comparison should concern **ongoing state dynamics before any reset**. In ordinary cached causal attention, retained earlier KV entries remain fixed while later queries change and new entries are added. Those new entries can encode computations that read earlier state. A delta-rule layer instead repeatedly modifies a shared associative-memory matrix through retention and correction. A hybrid supplies both routes. These differences motivate questions about interference, selective updating, access to old evidence, and carrying a partial understanding through intervening material. They do not establish that one route inherently supports unspoken thought while the other cannot. [Attention baseline][B1], [KDA][B8], [Gated DeltaNet][B10]

The positive research question is whether these mechanisms produce different **functional continuity within a session** at comparable resources. Does a constraint, tentative hypothesis, or latent disposition continue to influence relevant decisions after a distraction? Can new evidence revise it selectively? Does the system recover after a perturbation, or merely retain a trace? Persistence, updating, and regulation are distinct properties. The old essay's claim about sustained regulatory settling requires evidence of a corrective process relative to a specified target; neither a recurrent update nor a smoother feature trajectory alone supplies it. These are proposed operational questions, not established advantages of the seven models.

For this subsection, lead with those questions and the emotion-feature evidence. Use rolling-window eviction and compaction as stress tests of within-session continuity. Retain the across-session learning and consolidation discussion afterward as a short secondary connection, rather than making it the organizing problem.

| Claim in section 3 | Correction or qualification |
| --- | --- |
| Despite acknowledging rich contextual KV state, the essay says attention lacks a native carrier for continuity that is not text-shaped. | Preserve its acknowledgment of latent information and its valid distinction between storage mechanisms. Qualify the further inference: token-indexing alone does not establish deficient persistence or integration. Those require measurements of the actual memory dynamics and retention policy. |
| Exceeding an attention window forces textual compaction and re-prefill. | Full attention alone does not provide bounded-cost indefinite history, but a context limit does not mandate this particular policy. Truncation, selected retention, retrieval, and summary/reset are different runtime choices. Sliding-window eviction is also different from rewriting a history as a summary. |
| The reasons lost after compaction were never verbalized and therefore could not be captured by the summary. | The anecdote does not identify that cause. Omitted explicit rationale, changed retrieval, lost contextual representations, and ordinary output variation are alternative explanations. Loss on a particular summary does not prove inexpressibility in text. |
| Recurrent state would preserve the reasons across compaction. | Only if the serving protocol carries that state across the boundary. Reinitializing a hybrid from the same short summary also discards its earlier state. A state-preserving scheme must specify KV retention, recurrent/convolutional state, position bookkeeping, and how the summary is introduced without inadvertently processing old history twice. |
| Recurrence should make affect-related persistence more continuous and integrated. | Treat this as an empirical hypothesis. Learned gates can forget or overwrite information; neither smooth probe trajectories nor persistent activations establish a regulatory role or phenomenal experience. |

An essential replay distinction follows directly from the computation. For a deterministic, unmodified model, replaying all original inputs with the same positions, masks, and execution semantics reconstructs its cached state, subject to numerical differences. Replaying just a suffix or summary generally does not. Activation interventions are a separate case: an injected perturbation is additional input to the computation, so replaying only the resulting tokens need not reconstruct the intervened state. The same distinction applies to recurrent memory; it is not independent of its causal history merely because it lacks per-token slots.

The emotion-feature source, currently titled *Persistence and Introspection of Emotion Features*, is positive evidence motivating this more careful account. Its steering experiment deliberately retains the affected KV state after the pulse ends. Its text-regression controls and self-steering experiments address questions beyond surface emotional language, while retaining stated uncertainties about interpretation. [Persistence study][B24] Distinguish the reported persistence from a stronger causal claim that all later effects travel through KV independently of changed output tokens; isolating those routes requires a matched-token or cache-intervention control. This methodological distinction does not negate the authors' recognition of unspoken internal state.

Samba remains a useful historical comparison, with the benchmark stated precisely: Mamba plus sliding-window attention achieved 256K Passkey Retrieval after task fine-tuning on 4K sequences; that is not a general guarantee of arbitrary long-context recall. Its reported perplexity extrapolation is a separate result. Kimi K3 and Qwen3.8 use different recurrent updates and retain global attention, so neither Samba's memory scaling nor its retrieval results transfer automatically. [Samba][B23], [Kimi][K1], [Qwen][Q1]

Primary proposed test: within an uninterrupted session, establish a task constraint or tentative interpretation, insert distracting material, then introduce relevant confirming or conflicting evidence. Measure persistence of its influence, selective revision, interference with other retained information, and recovery after controlled state perturbations. Compare matched-token continuations, which help isolate internal-state effects, with freely generated continuations, which include feedback through emitted text. Within a hybrid, separately intervene on recurrent state and attention caches using compatible controls; report possible effects of taking the state outside its training distribution. Match available history and report storage/compute costs. Probe persistence and effects on decisions should be measured separately.

Secondary continuity test: compare uninterrupted continuation, full-input replay, suffix-only reconstruction, summary-and-reset, and continuation with explicitly preserved state. Measure retention of factual decisions, their supporting reasons, retrieval accuracy, and effects on future actions. This can distinguish a summarization failure from a state-retention advantage. It concerns a possible interruption within a session and does not by itself establish learning or consolidation across sessions.

Two secondary corrections outside §3 should enter the ledger: §1 describes SGD as Gaussian parameter perturbation, whereas ordinary SGD follows a gradient estimated from sampled data; and sensitivity to weight perturbation does not by itself establish Deutsch's explanatory notion of being hard to vary. In §2, claims that breadth cannot produce taste or that simple online learners avoid interference need narrower conditions and evidence. Preserve them, at most, as questions or hypotheses rather than architectural impossibility results.

### Turn the six axes into questions that can be investigated

Retain the six labels only as a provisional descriptive checklist. They are neither demonstrated independent coordinates nor a validated consciousness score. The statement that some unspecified combination constitutes a saturated mode does not yet make a discriminating prediction.

| Earlier axis | Operational replacement |
| --- | --- |
| Iteration | Which state is updated, by which transition, how often, and with what dependency depth? Distinguish depth, sequence recurrence, denoising, generation, and optimizer steps. |
| Stability | Stability of what under which perturbation: recurrent-state norms, output sensitivity, optimizer behavior, or convergence of repeated latent updates? Boundedness and useful memory are not the same as fixed-point convergence. |
| Inertia | Which history-dependent quantities persist, for how long, and what is lost when they are reset? Separate recurrent memory, KV caches, external memory, momentum, and synaptic-state analogies. |
| Heterogeneity | Which operations or modules differ, and what causal role does each play? Our models already mix attention types, dense/routed experts, and modality paths; this alone establishes neither cognitive specialization nor experience. |
| Centering | What selects information, where is it made available, and what changes when that pathway is disrupted? Top-k routing or attention selection is not automatically a global workspace or a regulatory self. |
| World-coupling | Which outputs affect later observations, across what latency and system boundary? Include the model, tools, memory, and environment when the claim concerns the deployed agent. |

There is a particularly useful experiment for the proposed center-out regulation hypothesis: perturb an alleged peripheral representation and test whether the alleged controller selectively restores a task-relevant invariant. Specify the invariant and competing explanations first. Such evidence would establish a regulatory function; an additional argument would still be needed to connect it to phenomenal consciousness.

### Repair the biological and optimization analogies

The [feedback essay, §4][E1] equates a 100 ms cycle with gamma frequency. The numerical conversion is 10 Hz; the identification must be corrected. Its approximately three-second human integration window is also used as if it were a necessary hardware-independent duration for artificial consciousness. That conclusion is not established. Distinguish a measured human task timescale, number of dependent computations, and real-time coupling to an environment. Review the original temporal-integration evidence before retaining any numerical requirement.

The same section treats short-term synaptic changes as indistinguishable from activations. Instead, distinguish neuronal activity, evolving synaptic efficacy, and longer-lived learned parameters; functional simulations may encode these using different state variables. This also prevents us from excluding fast-weight memory merely because learned checkpoint parameters stay fixed.

In §§6–8, the feedback essay equates variational optimization with tracking what is true and describes Boltzmann inference as settling to the best interpretation. Separate inference relative to a specified generative model from whether that model fits the world. Gibbs sampling targets a distribution under its conditions; mean-field inference is an approximation that can favor a mode. Neither is a general guarantee of truth or the globally best posterior estimate. The original DBM paper explicitly distinguishes variational approximation from persistent Markov-chain estimates. [Deep Boltzmann Machines][B22]

Audit the neuroscience claims before publication: predictions versus gain modulation, the COGITATE results and responses, the proposed plasticity requirement, and the relationship between replay and dreaming. A result constraining GNWT or IIT does not by itself support our center-out hypothesis. Replay dynamics, verbal reports, architectural heterogeneity, and monitorability results must not be promoted into evidence of phenomenal character without a stated inferential bridge.

### The improved philosophical claim

Suggested opening for the retrospective: **“Our earlier essays treated frozen weights and a feedforward pass as evidence that language models lacked important kinds of inference-time dynamics. That was too strong. We need to follow the state through the whole computation: cached representations, recurrent memory, generated intermediate steps, and interaction with the environment. These mechanisms change what an architecture can compute and what a monitor can observe. Whether any of them constitute conscious experience is a further hypothesis, requiring criteria more specific than recurrence or a collection of dynamical labels.”**

The positive contribution should be a set of explicit mechanisms, measurable consequences, and remaining philosophical commitments. Preserve the distinction between detection, causal explanation, and phenomenal consciousness developed in the monitoring section. Neither improved monitoring nor difficult-to-interpret internal computation settles the phenomenal question.

## Second-pass implementation findings

### Evidence and reproducibility boundary

The [source manifest](frontier-model-sources.json) records nine checkpoint revisions: both MiMo variants, Kimi, Qwen, GLM, both V4-Pro releases, V4.1-Flash, and MiniMax. It also records byte counts and SHA-256 hashes for 39 checkpoint files and six reference-library files. No weights were downloaded and no model was executed. Static inspection establishes what these files declare or compute; it does not reproduce training or validate a serving installation.

The main model-card and configuration citations now point to immutable revisions. Website announcements and some report links remain separate evidence with their own versioning limitations. In particular, the Transformers and Flash Linear Attention (FLA) snapshots are library revisions inspected on the research date, not proven training-time or deployment-time dependencies. Their APIs have evolved; Kimi's checkpoint code uses a state-layout argument name different from the inspected FLA signature. Resolve the intended dependency combination before executing a reproduction.

### Recurrent gates: what the code actually establishes

**Kimi.** The checkpoint passes raw delta logits to both chunked and recurrent KDA kernels with `use_beta_sigmoid_in_kernel=True`. It requests query/key L2 normalization and sets the gate lower bound to −5. The inspected FLA implementation defaults `allow_neg_eigval` to false; Kimi's calls do not enable it. Its negative-eigenvalue option would multiply sigmoid beta by two. That option's availability in a library is not evidence of its use by this checkpoint. [Kimi implementation][I1], [FLA recurrent kernel][I3]

The −5 bound applies to **log retention**, not to a signed state multiplier. In the inspected kernel, the bounded log gate has the form

$$
g_{t,j}=-5\,\sigma\!\left(e^{a_h}(u_{t,j}+b_j)\right),
\qquad d_{t,j}=e^{g_{t,j}},\qquad
\beta_t=\sigma(z_t).
$$

Thus the mathematical retention multiplier lies between $e^{-5}$ and 1 and beta between 0 and 1; floating-point saturation can reach boundary values. Retention varies by channel, while the configured delta coefficient is per head. Three short convolutions prepare queries, keys, and values, and a separate sigmoid output gate follows the recurrent operation. These gates have different roles and should not share an undifferentiated label in a diagram. [Kimi code][I1], [FLA code][I3]

**Qwen.** The checkpoint declares `Qwen3_5MoeForCausalLM` and the `qwen3_5_moe_text` implementation family. The inspected Transformers Gated DeltaNet path computes $\beta_t=\sigma(b_t)$ and log retention $g_t=-e^{a_h}\operatorname{softplus}(u_t+c_h)$, then applies $e^{g_t}$ to the state. It requests query/key L2 normalization. Its 16 query/key heads are repeated across 128 value heads, with head dimensions 128 and convolution width four. This is a configuration-specific explanation of the grouping, not a property of every DeltaNet. [Qwen config][Q3], [Transformers implementation][I2]

*(Resolved 26 October: there is no mismatch.)* `output_gate_type: swish` names the SiLU gate on the Gated DeltaNet output norm; the full-attention gate is a head-specific elementwise sigmoid on the attention output, selected by `attn_output_gate: true`. vLLM, SGLang and Transformers all read the keys this way, and the sibling Qwen3.8-Flash-Next config documents `output_gate_type` as the linear-attention gate. No Qwen-authored code states it; the resolution rests on agreement among the public implementations. The sigmoid choice matches the Gated Attention paper's best variant (Qiu et al., arXiv 2505.06708).

For intuition, a normalized-key delta factor $I-\beta kk^\top$ has eigenvalues 1 in directions orthogonal to $k$ and $1-\beta\lVert k\rVert^2$ in the key direction. With $0\leq\beta\leq1$ and $\lVert k\rVert\leq1$, that factor has no negative eigenvalues. This observation explains why the doubled-beta extension matters. It does **not** classify the full model, establish the spectrum of arbitrary products across time, or prove a short effective memory. The essay should distinguish an implementation audit from an expressivity theorem.

### Layer schedules for the diagrams

All layer indices in this table start at zero. Auxiliary prediction modules are outside the stated main-stack counts.

| Model | Detail to retain in the layer strip |
| --- | --- |
| MiMo RL and MOPD | Global attention at 0, 7, 15, 23, 31, 39, 47, 55, 62, 69; the other 60 layers use the sliding window. Only layer 0 has a dense FFN. |
| Kimi K3 | MLA at 3, 7, …, 91, plus 92; all remaining layers use KDA. The checkpoint's own list is one-based and must be converted. AttnRes block size is 12. |
| Qwen open Max-class | Full attention at 3, 7, …, 91; 69 recurrent layers and 23 full-attention layers, all with MoE. |
| GLM-5.3 | Three initial dense FFNs. The indexer schedule begins with three independently indexed layers before grouped reuse; avoid drawing uniform four-layer groups from layer 0. |
| V4-Pro and Pro-0813 | Two initial HCA layers, then 30 CSA and 29 HCA layers alternating. Token-ID routing in layers 0–2; score-selected routing afterward. |
| V4.1-Flash | 20 encoder and 20 decoder layers. The compression list begins with two zeros, then eighteen twos, then twenty ones; the values describe different roles and should not be rendered as a repeated V4-Pro motif. |
| MiniMax M3 | Layers 0–2 have full attention and dense FFNs; layers 3–59 have sparse attention and MoE. Sparse configuration selects 16 blocks of 128 positions, with one local block specified. Runtime masking and overlap determine the actual distinct positions read. |

Source: the pinned configuration files in the [manifest](frontier-model-sources.json); the Pro routing interpretation is confirmed by its reference code. [I4] These are instructions for constructing accurate figures, not substitutes for explaining the operations.

The Pro-0813 config additionally gives DSpark block size five, target layers 58–60, and Markov rank 512. It appends three zero-compression entries beyond the 61-layer stack, but retains `num_nextn_predict_layers: 1`. The reference code constructs draft stages from its runtime `n_mtp_layers` argument. Therefore do not infer the complete drafter or number of extra executed layers from that single legacy config field; trace conversion and runtime arguments before drawing DSpark in detail. [0813 config][I5], [reference code][I4]

### Three small explanatory calculations

These are hand-sized examples of operations, with arbitrary values, not measurements of trained models.

1. **Selective memory correction.** Let a one-row memory be $S=(2,1)$, key $k=(1,0)^\top$, value $v=3$, and beta $1/2$. Scalar forgetting by $1/2$ gives $\widetilde S=(1,1/2)$. The predicted value is 1, so the delta update adds $(1,0)$ and produces $(2,1/2)$. Channelwise retention $(1/2,1)$ instead gives $(2,1)$. This illustrates how KDA can preserve a different direction while correcting the same association; it is not evidence of superior learned recall. Query scaling and output gating are omitted. [B8], [B10]
2. **Retrieval across depth.** If two earlier-depth value vectors are $(1,0)$ and $(0,2)$, and normalized-key scoring produces logits 0 and $\log3$, their softmax weights are $1/4$ and $3/4$. The result is $(1/4,3/2)$. Kimi's helper scores RMS-normalized candidates using a learned query but mixes the original values. Its block summaries and current local sum supply those candidates. The attention axis here is depth, not earlier tokens. [I1]
3. **Mixing residual streams.** For two scalar streams $x=(2,4)^\top$, let a residual mixing matrix be $R=\left(\begin{smallmatrix}.75&.25\\.25&.75\end{smallmatrix}\right)$. Then $Rx=(2.5,3.5)^\top$: the residual contribution retains its total of six. If a sublayer computes $F((2+4)/2)=6$ and sends half to each stream, the full output becomes $(5.5,6.5)^\top$. The doubly stochastic constraint concerns the residual mixing term; the full block also adds new computation. This is an illustrative two-stream mHC operation, not DeepSeek's configured four-stream block. [B11], [I4]

In Pro's code, attention and the FFN each have their own reduction from multiple streams, normalization, sublayer evaluation, and expansion/mixing back to the streams. This differs from Kimi's attention over accumulated depth summaries. It also does not introduce a later layer feeding backward into an earlier layer within the same evaluation. The Single-Pass mHC variant still needs its own equation-level explanation.

### Training disclosures and counting remain uneven

The Qwen repository explicitly places 3.8 on the 3.5 architectural foundation. Its older-model subsections are not a complete Max-specific training recipe. The separate *Qwen3.8-Next* report is about another architecture and must not supply undocumented Max components or token budgets. The inspected MiniMax production pages reaffirm multimodal training from the outset but do not resolve the production-model training schedule sought here. These are disclosure gaps in the sources inspected, not claims that no further documentation exists. [Qwen repository][Q4], [Next report][Q5], [MiniMax production page][N4]

The manifest preserves Hub tensor metadata separately from publisher parameter counts. For example, GLM's metadata reports approximately 753.33 billion stored tensor elements and MiniMax's approximately 427.04 billion. Those observations do not resolve main-backbone versus auxiliary-module counts, quantized packing conventions, or active parameters. Other checkpoints include packed integer tensors, making a blanket comparison especially misleading. Do not replace the headline comparison table with these totals until semantic accounting is reconciled. In particular, GLM's auxiliary prediction layer is a candidate contribution to examine, not yet a demonstrated explanation of its counting discrepancy.

## Proposed essay and figures

The user sets **8,000 words as the soft upper limit**. Plan approximately 7,500 words of main text, with 500 words of room for captions, table text, and revision. References and this research dossier are supporting material. These allocations guide emphasis rather than impose exact section lengths.

| Section | Working words | Purpose |
| --- | ---: | --- |
| Opening and scope | 250 | Introduce the seven checkpoints and the question of where computation and information live. |
| From the 2017 Transformer to the contemporary block | 750 | Establish attention, normalization, gated FFNs, MoE, and the three kinds of mixing. |
| Memory and long context | 1,200 | Explain recurrent delta memory, its state-space connection, local/global attention, sparse selection, compression, and their costs. |
| Assemble the seven models | 1,800 | Use aligned diagrams and a paired DeepSeek comparison; avoid explaining shared mechanisms seven times. |
| How training makes the components work | 1,000 | Connect stability, indexer learning, context curricula, precision, SFT, RL, and distillation to documented models. |
| Circuit depth, monitorability, and explanation | 1,000 | Separate stack depth, unrolled recurrence, circuit bounds, emitted reasoning, and causal evidence. |
| Revisit the three earlier essays | 1,200 | Center *What Breadth Reaches* §3, **The Medium Timescale: Architectural Affordances Within a Session**: latent continuity, selective updating, and regulation. Keep §2's across-session integration secondary. |
| Closing tradeoffs and open questions | 300 | State what follows from disclosed mechanisms and what requires experiments. |
| **Main text subtotal** | **7,500** | **Leave approximately 500 words before the soft ceiling.** |

The shared-mechanism sections carry the mathematical explanations. The model portraits explain composition and distinctive choices. The retrospective should draw on those explanations rather than become a separate philosophical essay.

Proposed original figures:

- A common block with replaceable token mixer, FFN/expert path, and residual operator.
- One attention-memory comparison: full history, rolling window, recurrent state, and selected blocks.
- A storage-versus-read-cost diagram showing why sparse attention can retain a growing cache and a recurrent/attention hybrid can retain global-attention costs.
- Seven aligned layer strips, with initial/final exceptions explicitly drawn.
- Parallel training timelines showing when modalities, long context, low precision, SFT, RL, and distillation appear.

Use arithmetic and diagrams to explain mechanisms; use published ablations to support performance claims. Cross-model benchmark rankings cannot isolate the contribution of an architecture change when data, training compute, effort, and harnesses differ.

## Remaining research before drafting

- Checkpoint/config revisions are pinned in the source manifest. Finish pinning report versions and relevant serving dependencies; resolve the Kimi/FLA API and Qwen output-gate differences before claiming an executable reproduction.
- Complete the implementation trace for normalization placement, router balancing, shared experts, residual equations, and positional treatment. The second pass covers recurrent gates, selected routing paths, AttnRes, Pro mHC, and main layer schedules; it is not a complete runtime audit.
- Reconcile parameter counting, including embeddings, vision/audio modules, shared experts, Engram tables, and speculative heads. Resolve the GLM total and active counts from first-party accounting.
- Locate detailed Qwen3.8-2.4T and production MiniMax M3 training disclosures. Leave undisclosed information blank.
- MiMo RL and MOPD have identical pinned configurations and separately documented post-training. Map the technical report's drafting and quantization variants to the released artifacts and serving code.
- Trace the Pro-0813 DSpark conversion and runtime arguments, especially its legacy MTP count field. Keep its training disclosures separate from the preview; recheck V4.1-Pro availability and API alias routing before publication.
- Read the Kimi and DeepSeek equations and ablations in full. The toy updates above explain delta memory, AttnRes, and ordinary mHC; derive the Single-Pass mHC difference and validate any eventual figures against source equations.
- Validate the state-space/linear-attention explanation against the precise transition structure; distinguish per-layer asymptotics from total hybrid costs and include indexer work in sparse-attention comparisons.
- Use the audited gate ranges to refine the theory discussion, while separating architecture-wide upper bounds, existence constructions, and measured learned behavior. Neither inspected implementation justifies importing the explicit negative-eigenvalue extension.
- Collect comparisons that hold data, training budget, and evaluation settings constant. Record whether a speedup concerns attention kernels, prefill, decode, or whole-task completion.
- Audit licenses and availability of training data/code separately. Do not infer reproducibility from access to weights.
- Complete the retrospective's source audit: verify the original neuroscience, temporal-window, continual-learning, multi-stream, and Scientist AI sources rather than inheriting the old essays' interpretations. Separate factual mistakes, unsupported deductions, philosophical hypotheses, and developments since publication.
- Audit *What Breadth Reaches* §3 primarily for its claims about within-session state, persistence, integration, and regulatory settling. Separate natural feature persistence from steering experiments; seek comparisons of KV and recurrent memory that control history, storage, and training. Treat rolling-context/compaction protocols as continuity stress tests and §2's across-session integration as secondary.

## Addendum, 26 October 2026: freshness check

A second check covered releases and publications from 3 to 26 October. It queried the Hugging Face API for each lab's new repositories and for the current revision of each pinned checkpoint, diffed every changed file, and read official release pages, the arXiv API and GitHub commit histories. The labels follow [architecture-interpretability-and-audit.md](architecture-interpretability-and-audit.md): Confirmed, Reported, Inferred. The full reports are in the gitignored `notes/private/freshness-models-2026-10-26.md` and `notes/private/freshness-papers-2026-10-26.md`. The associative-memory thread that arrived in the same period has its own note, [associative-memory-view.md](associative-memory-view.md).

### Corrections

1. **The `deepseek-v4-pro` alias was not rerouted.** DeepSeek's [change log](https://api-docs.deepseek.com/updates), under 10 September, says: "we have decided to continue providing API services for DeepSeek V4 Pro after September 14, 2026", with billing unchanged. The [10 September news page][D5] still carries the original routing text, so DeepSeek's own pages conflict; cite the change log for current behaviour. The API documentation does not say which Pro snapshot (preview or 0813) the alias serves. What the change log does reroute is the legacy Flash names, `deepseek-v4-flash` and `deepseek-v4-flash-vision-exp`, to V4.1-Flash. [Confirmed; checked directly on 26 October]
2. **The production MiniMax model is now sparse in every layer.** MiniMax-M3.1-Flash ([announcement](https://www.minimax.io/blog/minimax-m31f), 19 October; [weights](https://huggingface.co/MiniMaxAI/MiniMax-M3.1-Flash), 23 October) has the same size as M3, about 428B total and 23B active, despite its name. Its `sparse_attention_freq` is 1 for all 60 layers, against `[0,0,0,1,…]` in M3. The M3 portrait's "three full-attention layers, followed by 57 sparse-attention layers" therefore describes M3 only. [Confirmed: config diff]
3. **The M3 portrait omits a drafter.** M3's released config has `num_mtp_modules: 7` and `num_nextn_predict_layers: 1`. M3.1-Flash drops both and ships a five-layer DSpark draft model, the second DSpark adopter after DeepSeek. [Confirmed]
4. **"Flash is the released V4.1 checkpoint" is incomplete.** DeepSeek-V4.1-Flash-1017 ([card](https://huggingface.co/deepseek-ai/DeepSeek-V4.1-Flash-1017), 17 October) is "a minor update" with a byte-identical config and new weights. `deepseek-flash` now serves it. Its only training disclosure is one sentence in the [release note](https://api-docs.deepseek.com/news/news261017): "reinforcement learning with self-feedback to improve end-to-end project development." [Confirmed] So the weights presumably differ through post-training only. [Inferred]

No architectural claim about the seven pinned checkpoints was contradicted. The configs of MiMo, GLM-5.3, V4.1-Flash and MiniMax-M3 were re-diffed; Kimi K3, Qwen3.8-2.4T, V4-Pro and V4-Pro-0813 have no new revisions. [Confirmed]

### Pinned revisions that moved

- **MiMo RL and MOPD** (9 October): only `preprocessor_config.json` changed, aligning image preprocessing with training. The RL and MOPD language configs remain identical. [Confirmed]
- **GLM-5.3** (14 October): an evaluation file and a chat-template speed-up. [Confirmed]
- **V4.1-Flash** (12–16 October): reference-inference fixes. One commit restores each shared indexer's K cache on incomplete compression steps, which shows in code that one layer owns the indexer cache and others share it. That matches the dossier's description of CSA2. Another adds FP8 activation quantization before the grouped output projection. Any reproduction should pin the new revision, `314113f8`. [Confirmed for the diffs; Inferred for the match]
- **MiniMax-M3** (26 October): a README rename only. [Confirmed]

### New in the seven families

- **Kimi K3.1 Pro** ([blog](https://www.kimi.ai/blog/kimi-k3-1-pro), 23–24 October). Moonshot calls it "a post-trained version of Kimi K3, with substantially larger post-training compute", with joint RL "across hundreds of domains". For the open-weight release Moonshot "identified and removed cyber-related data from both training stages". Weights are promised by 4 November. No architecture, parameter counts or license are given. [Confirmed] That it keeps K3's architecture rests on secondary reports; check the config when the weights appear. [Reported] The blog does not say that the API model and the released weights are the same. [Inferred]
- **No new Qwen language checkpoint, Qwen3.8-Max report or GLM-5.3 report.** The Qwen and MiniMax training-provenance gaps stay open. Qwen4 is reported to be in training. [Confirmed for absence on Hugging Face and arXiv; Reported for Qwen4] A dated API snapshot, Qwen3.8-Max-0902, widens the gap between the Max service and the open checkpoint. [Reported]
- **The GLM-5 report** ([arXiv 2602.15763](https://arxiv.org/abs/2602.15763)), tagged on the GLM-5.3 card, is the closest first-party source for the base architecture's parameter accounting, which the dossier leaves open. [Confirmed for the tag; Inferred for its use]

### Stable citations

- [M2] is on arXiv as [2610.11959](https://arxiv.org/abs/2610.11959) (8 October); a text diff shows it matches the pinned PDF, so it is not a new disclosure. [Confirmed]
- [K3] is on arXiv as [2607.24653](https://arxiv.org/abs/2607.24653) (v2, 7 August). [Confirmed]

### Other labs (flag only)

- **Meta Muse Spark Open** ([blog](https://huggingface.co/blog/meta-muse-spark-open), 15 October; 816B total, about 42B active): "Each block combines its input and its output through a learned residual gate, not through a plain sum." It is a third departure from the additive residual, beside mHC and AttnRes. [Confirmed from the blog; gated config not read]
- **StepFun Step-5-Preview** (weights about 14–15 October): DeepSeek-style compressed sparse attention on the global layers only of a sliding-window hybrid. [Confirmed from config; date Reported]
- **inclusionAI Ling-3.1-flash** (13 October): a second KDA-plus-MLA hybrid after Kimi K3, probably below frontier tier. [Confirmed from config]
- **Reflection Beam 1.0** (501B, 23B active, Apache-2.0) is architecturally conventional. **Mistral Large 4** weights are promised but not yet out. [Confirmed; Reported for Mistral's date]

### New papers on components and monitoring

Interpretability results, including the measurement of mHC in V4-Flash and the split of roles between KV cache and recurrent state, are in the audit dossier's addendum B of the same date. The items below bear on this dossier's own sections.

- **Residual paths are memories over depth.** [*Depth Memory*, arXiv 2610.18809](https://arxiv.org/abs/2610.18809) casts AttnRes as attention over a growing cache of layer outputs and mHC as a fixed-size recurrent state over depth. [Confirmed] The section on AttnRes and mHC can use the same vocabulary as the section on recurrent token mixers. [Inferred] [Li, Sha and Yang, arXiv 2610.06653](https://arxiv.org/abs/2610.06653) show that a doubly stochastic mixer contracts every difference between streams unless it is a permutation, so mHC's extra width is a fading memory. [Reported: abstract] [Multi-Stream Attention Residuals, arXiv 2610.13630](https://arxiv.org/abs/2610.13630) report gains over mHC and AttnRes at 18B and 28B. [Reported] The replacement of the additive residual is spreading.
- **Top-$k$ selection has its own composition limit.** [Eitan, Yehudai and Maron, arXiv 2610.25250](https://arxiv.org/abs/2610.25250) show that conventional hybrid blocks, and blocks with top-$k$ KV access, need capacity growing as $\sqrt n$ to compose two functions over a domain of size $n$; a block with retrieval depth $m$ composes $m$ functions at fixed size. [Reported: abstract] The section "Recurrence, circuit depth, and effective memory" should treat selection (DSA, MSA, CSA) as a second source of depth limits beside the transition algebra. [Inferred]
- **Hybrids may need shorter scratchpads.** [Steifer, arXiv 2605.16640](https://arxiv.org/abs/2605.16640) (May; missed earlier) claims that at constant precision a GDN-plus-gated-attention hybrid solves a parity-conditioned retrieval task with a constant number of CoT steps, where pure GDN has no comparable solution and pure gated attention needs a scratchpad of polynomial length. [Reported: abstract; single author, under review] If it holds, it is a formal case of the hybrid design shortening the visible computation that the monitorability argument relies on. [Inferred]
- **Looped depth adds little in small models.** [Olszowiec et al., arXiv 2610.18127](https://arxiv.org/abs/2610.18127) find that in eight looped models at 1.3B to 3.5B, 76 to 89 percent of answer tokens are decided at the first iteration, except Huginn, which decides gradually. [Confirmed] This weakens, for that architecture class, the worry about hidden serial computation in the bullet "Recurrence through model depth". It says nothing about KDA or GDN recurrence over tokens. [Inferred]
- **Activation probes and transcript monitors are complementary.** On Kimi K3, Goodfire's reward-hacking probes beat an LLM monitor reading the whole transcript on two of three benchmarks, and an OR of both nearly doubles detection on DeepSWE (audit addendum B.2). Every probe hit they show is also verbalized, so this is evidence about detection, not about hidden reasoning. [Confirmed] This is the first measurement of the separate observation channels that "Monitorability is detection" asks to assess, on two of the seven checkpoints. [Inferred]
- **Complex KDA** ([B20]) is listed as a NeurIPS 2026 paper. [Reported] It is still a variant, not a K3 disclosure.
- **GDN head half-lives.** The median GDN head in Qwen3.8-27B has a half-life of about 24 tokens, and head roles are nearly fixed by the weights (GateSight; audit addendum B.4). [Confirmed] This is the first measurement bearing on "Limited effective depth needs an operational definition" for one of the hybrid families. [Inferred]

Nothing new was found on MLA, DSA, MSA or CSA/HCA interpretability, Single-Pass mHC, MTP and drafting beyond systems papers, or long-context curricula for the seven.

### Pre-drafting research: compression, selection and their training

A pass on 26 October read the V4 and V4.1 reports and reference code, the DeepSeek-V3.2 report (the source of DSA), the GLM-5 report, IndexCache and the MSA paper. The full report is in the gitignored `notes/private/research-arch-2026-10-26.md`. Single-Pass mHC and the Qwen gate are settled in place above and in the audit dossier, Part 1.6.

**How CSA and HCA pool.** [Confirmed: V4 §2.3 and Pro-0813 code]
- A CSA entry pools 8 tokens at stride 4: two streams, one for the current block and one overlapping the previous one, each with a learned positional bias. The weights are a softmax over the 8 positions, separately in each of 512 channels. So the pool is a learned, content-dependent, channel-wise convex average.
- One pooled vector serves as both key and value, shared by all 128 query heads.
- The selector has its own compressor (128 channels, Hadamard rotation, FP4) and scores entries as $I_{t,s}=\sum_h w_{t,h}\,\mathrm{ReLU}(q^I_{t,h}\cdot k^I_s)$, with 64 indexer heads; V4-Pro keeps the top 1,024.
- HCA pools 128 tokens without overlap and has no selector: at 1M tokens it attends to about 8,192 entries, while CSA's selector chooses among about 250,000. [Inferred: arithmetic]
- Each query also sees the 128 most recent uncompressed entries. Window entries, compressed entries and a learned per-head sink logit share one softmax.

**V4.1's CSA2, concretely.** [Confirmed: V4.1 §2.3 and code; the sharing pattern is Inferred from config and code]
- No overlap and no positional bias. Compression is 2 in encoder layers 2–19 and 1 (none) in the decoder.
- The encoder keeps three KV caches, from layers 2, 8 and 14, each shared by six layers with its indices.
- The decoder keeps one uncompressed KV, computed by layer 20 from the encoder's final state, read by all 20 decoder layers. Layer 20 scores every visible position, keeps the 2,048 best blocks of 8 (at most 16,384 positions), and layers 24, 28, 32 and 36 re-select their top 512 within that pool.
- Indexer keys are projected from the main latent rather than a separate compressor.
- V4.1 "trains sparse attention from scratch at a sequence length of 64K, without any dense attention warmup stages". V4-Pro went dense, then indexer warm-up, then sparse. Neither report gives the indexer's loss. [Confirmed: checked directly]

**Does learned selection cost quality, and what makes it work?**
- Every published recipe except V4.1's uses three devices: distilling the indexer toward the main attention by KL (restricted to the selected set once sparse); a stop-gradient at the indexer input, so the indexer learns only from the KL and the backbone only from the language-model loss; and a dense warm-up. Warm-ups: DSA 2.1B tokens, GLM-5 about 2.8B, MSA 40B. [Confirmed]
- After joint sparse training the reports find parity. Costs show up in three places. [Confirmed]
  - Before joint training: in GLM's DSA experiment on GLM-4.7-Flash (30B-A3B), warm-up alone loses 7.9 RULER points at 128K (79.21 → 71.35); joint training restores 78.86.
  - With index sharing added without retraining: on GLM-5 (744B), sharing one indexer across four layers drops the long-context average from 78.4 to 72.7. Trained with sharing, the 30B model matches its baseline (50.6 against 51.0). GLM-5.2's IndexShare is this method (IndexCache, arXiv 2603.12201), trained in from mid-training.
  - Without MSA's forced sink and local blocks: RULER-32K falls from 65.8 to 61.5, which the authors call "comparable".
- The DSA source report has no ablation of the indexer, only parity checks. No published ablation measures learned selection at 1M tokens. [Confirmed]
- MSA's appendix ablations (gradient source, detach, warm-up, sinks) used a 10.5B-A1.5B pilot, not the 109B model; without the stop-gradient the KL gradient spikes and the language-model loss diverges, and without warm-up the main attention's entropy collapses early. [Confirmed]

**A precision note for calculation 3.** The released Sinkhorn kernel makes the residual mixer's rows sum to 1 exactly and its columns only approximately, so the conservation of the residual total holds exactly for the calculation's symmetric matrix but only approximately in the trained model. [Confirmed: code; Inferred: consequence]

### Consequences for the essay

- The family resemblance across the open frontier is now stronger than when the dossier was written. Sparse attention spreads to every layer (MiniMax) and to the global layers of window hybrids (StepFun), KDA-plus-MLA hybrids multiply (Ling), and the plain residual sum is being replaced in more places (Meta). The series can present these as converging choices rather than seven idiosyncrasies. [Inferred]
- Decide before drafting whether to keep the pinned seven or move MiniMax to M3.1-Flash and Kimi to K3.1 Pro once its weights appear. Moving costs little for MiniMax, whose change is fully documented in the config. For Kimi it depends on the 4 November config.

## Primary source register

Sources were located and inspected during the 3 October 2026 research passes. Model architecture/training sections were inspected; this is not an exhaustive review of every appendix. The MiMo and Kimi PDF reports were downloaded and text-extracted when browser extraction failed. Qwen's blog is a follow-up source whose body was not successfully read; its official repository now supplies an additional readable architecture-lineage source. Component papers were inspected at abstract or relevant-section level and need full reading before detailed derivations. Pinned checkpoint and library identities are recorded in the [source manifest](frontier-model-sources.json).

### Model sources

- [MiMo release collection][M0]; [Pro-RL model card][M1]; [technical report][M2], especially sections 2–5 and inference infrastructure.
- [Kimi K3 repository and model summary][K1]; [technical blog][K2]; [technical report][K3], especially sections 2–4.
- [Qwen3.8-2.4T-A95B card][Q1]; [Qwen3.8 blog][Q2]; [checkpoint config][Q3].
- [GLM-5.3 card][G1]; [checkpoint config][G2]; [GLM-5.2 announcement][G3]; [GLM-5.3 announcement][G4]. The announcement text was available through indexed primary-source results despite empty direct page extraction.
- [DeepSeek-V4.1-Flash card][D1]; [technical report][D2], arXiv 2609.19969v1, especially sections 2, 4, and 5.
- [DeepSeek-V4-Pro card][D3]; [V4 technical report][D4], especially sections 2.3, 4.2, and 5.1; [original Pro config][D7]; [Pro-0813 card][D6]; [V4.1-Flash release and API routing notice][D5]. The 0813 config fetch failed; its relationship to the preview is established here by its official card.
- [MiniMax M3 card][N1]; [checkpoint config][N2]; [MSA paper][N3], arXiv 2606.13392v2, especially sections 3 and 5.

### Component sources

- [Attention Is All You Need][B1]
- [Root Mean Square Layer Normalization][B2]
- [GLU Variants Improve Transformer][B3]
- [RoFormer][B4]
- [Grouped-query attention][B5]
- [DeepSeek-V2 and MLA][B6]
- [Sparsely-gated mixture of experts][B7]
- [Kimi Linear and KDA][B8]
- [Attention Residuals][B9]
- [Gated Delta Networks][B10]
- [Manifold-Constrained Hyper-Connections][B11]
- [Mamba and selective state spaces][B12]
- [Mamba-2 and structured state-space duality][B13]
- [Transformers are RNNs and recurrent linear attention][B14]
- [FlashAttention and exact attention with reduced memory traffic][B15]
- [The Illusion of State in State-Space Models][B16], especially sections 2.2–2.3, 4, and 5.
- [The Expressive Power of Transformers with Chain of Thought][B17]
- [Why Are Linear RNNs More Parallelizable?][B18], including arithmetic assumptions and DPLR constructions.
- [Olmo Hybrid: From Theory to Practice and Back][B19], especially the negative-eigenvalue definition, state-based recall theorem, and discussion of the unextended GDN variant.
- [Complex KDA: Understanding and Enhancing the Expressivity of Kimi Delta Attention][B20], a September 2026 preprint about extended parameter ranges; not a Kimi K3 architecture disclosure.
- [Transformers learn in-context by gradient descent][B21], a construction and controlled regression experiments; not a universal description of LLM inference.
- [Deep Boltzmann Machines][B22], especially distinctions between variational inference and Markov-chain estimation.
- [Samba][B23], especially architecture and length-extrapolation experiments; historical comparator rather than an eighth frontier model in scope.
- [Persistence and Introspection of Emotion Features][B24], linked under “Long-range Persistence of Emotion Features” by its authors; an April 2026 research report. Inspected methods, interventions, and stated interpretive uncertainties; results have not been independently replicated here.

### Earlier essays to revisit

- [What Do Feedback Connections Actually Do? Recurrence, Regulation, and the Question of AI Consciousness][E1], especially §§4–5 and 8–10.
- [The Dynamics That Matter: Online Learning, Consolidation, and the Modes of Machine Mind][E2], especially §§2–5 and 7–10. Its author's disclaimer matters: the six-axis scheme was a proposed framing, not an independently established result.
- [What Breadth Reaches: Epistemic Agency Across Timescales][E3], principally §3, **The Medium Timescale: Architectural Affordances Within a Session**, on ongoing latent state and its functional role. Compaction is one within-session stress test; §2, **The Long Timescale: Integration Across Sessions**, is secondary, alongside the subsidiary corrections in §1.

### Monitoring context

- [User-linked X post][S1]: supplied quotation; original post inaccessible, attribution and graph-depth definition require verification.
- [When Chain of Thought is Necessary, Language Models Struggle to Evade Monitors][S2], especially conceptual framework and limitations.
- [Hidden Reasoning Must Leak, but Need Not Be Readable][S3], September 2026 preprint; inspected setup and main statements, not fully proof-audited.
- [GPT-6 Astra system card][S4], section 9, including UK AISI's assessment and limitations.

## Human brief

> For a future essay on our blog, we will analyze the neural network architectures of leading open-source AI models: Xiaomi MiMo-V2.6-Pro, Moonshot Kimi K3, Alibaba Qwen 3.8 Max, Zhipu GLM-5.3, DeepSeek V4.1, MiniMax M3. Let's start researching this already. We will explain the extensions of the original transformer architecture, and how they're put together and trained.

Follow-up scope clarification:

> I guess we should also include DeepSeek V4 Pro, no? I wasn't aware that v4.1 refers only to Flash.

Follow-up explanatory scope:

> Do any of the models use a mixed architecture with state space components? We should explain, if we don't have that yet, how the different architectures approach sparse attention or long context more generally.

Follow-up theoretical scope:

> With recurrent attention, can we still say that those transformers have limited circuit depth or limited effective circuit depth?

Follow-up retrospective scope:

> In the essay, we should also devote a section to correcting and improving on these two previous (rather mediocre) philosophical essays: notes/feedback-recurrence-consciousness.md and notes/axes_of_dynamics.md

Additional retrospective scope:

> One more relevant essay I forgot, to cover in the "revisiting" section: notes/what-breadth-reaches.md (section 3 is most relevant).

Source-attribution clarification:

> I think Janus et al., that previous essay quotes, is already aware of unspoken information inside KV: https://latentaffect.animalabs.ai/long_range_persistence_of_emotion_features.html

Essay length clarification:

> For the essay, I would budget for 8,000 words, since we have an ambitiously broad scope, and that's the soft upper limit.

[M0]: https://huggingface.co/collections/XiaomiMiMo/mimo-v26
[M1]: https://huggingface.co/XiaomiMiMo/MiMo-V2.6-Pro-RL/blob/73875d00b30a89ef8cc353a0b60b0e9f9561952d/README.md
[M2]: https://huggingface.co/XiaomiMiMo/MiMo-V2.6-Pro-RL/blob/73875d00b30a89ef8cc353a0b60b0e9f9561952d/MiMo_V2_6_technical_report.pdf
[K1]: https://github.com/MoonshotAI/Kimi-K3
[K2]: https://www.kimi.ai/blog/kimi-k3
[K3]: https://github.com/MoonshotAI/Kimi-K3/blob/main/k3_tech_report.pdf
[Q1]: https://huggingface.co/Qwen/Qwen3.8-2.4T-A95B/blob/207bd685a7e3696cfaff12ded7c6a7ea0f88c996/README.md
[Q2]: https://qwen.ai/blog?id=qwen3.8
[Q3]: https://huggingface.co/Qwen/Qwen3.8-2.4T-A95B/blob/207bd685a7e3696cfaff12ded7c6a7ea0f88c996/config.json
[G1]: https://huggingface.co/zai-org/GLM-5.3/blob/aca966e4e02791568aa6a4ced368624b3d897f42/README.md
[G2]: https://huggingface.co/zai-org/GLM-5.3/blob/aca966e4e02791568aa6a4ced368624b3d897f42/config.json
[G3]: https://z.ai/blog/glm-5.2
[G4]: https://z.ai/blog/glm-5.3
[D1]: https://huggingface.co/deepseek-ai/DeepSeek-V4.1-Flash/blob/2cba9e42aa026125f3ed06c6d98c1db82f7ca027/README.md
[D2]: https://arxiv.org/html/2609.19969v1
[D3]: https://huggingface.co/deepseek-ai/DeepSeek-V4-Pro/blob/b5968e9190ef611bbf34a7229255be88a0e937c1/README.md
[D4]: https://arxiv.org/html/2606.19348
[D5]: https://api-docs.deepseek.com/news/news260910/
[D6]: https://huggingface.co/deepseek-ai/DeepSeek-V4-Pro-0813/blob/72e1d3230f6c080a530b0a1d46f8eb4602340597/README.md
[D7]: https://huggingface.co/deepseek-ai/DeepSeek-V4-Pro/blob/b5968e9190ef611bbf34a7229255be88a0e937c1/config.json
[N1]: https://huggingface.co/MiniMaxAI/MiniMax-M3/blob/f0e1c1e04d40177e4673a22097036854f536e9c0/README.md
[N2]: https://huggingface.co/MiniMaxAI/MiniMax-M3/blob/f0e1c1e04d40177e4673a22097036854f536e9c0/config.json
[N3]: https://arxiv.org/html/2606.13392v2
[B1]: https://arxiv.org/html/1706.03762
[B2]: https://arxiv.org/abs/1910.07467
[B3]: https://arxiv.org/abs/2002.05202
[B4]: https://arxiv.org/abs/2104.09864
[B5]: https://arxiv.org/abs/2305.13245
[B6]: https://arxiv.org/abs/2405.04434
[B7]: https://arxiv.org/abs/1701.06538
[B8]: https://arxiv.org/abs/2510.26692
[B9]: https://arxiv.org/abs/2603.15031
[B10]: https://arxiv.org/abs/2412.06464
[B11]: https://arxiv.org/abs/2512.24880
[B12]: https://arxiv.org/abs/2312.00752
[B13]: https://arxiv.org/html/2405.21060
[B14]: https://arxiv.org/abs/2006.16236
[B15]: https://arxiv.org/abs/2205.14135
[B16]: https://arxiv.org/html/2404.08819v2
[B17]: https://arxiv.org/abs/2310.07923
[B18]: https://arxiv.org/html/2603.03612v3
[B19]: https://arxiv.org/html/2604.03444
[B20]: https://arxiv.org/html/2609.24797v1
[B21]: https://arxiv.org/abs/2212.07677
[B22]: https://proceedings.mlr.press/v5/salakhutdinov09a/salakhutdinov09a.pdf
[B23]: https://arxiv.org/html/2406.07522v3
[B24]: https://latentaffect.animalabs.ai/long_range_persistence_of_emotion_features.html
[E1]: ../feedback-recurrence-consciousness.md
[E2]: ../axes_of_dynamics.md
[E3]: ../what-breadth-reaches.md
[S1]: https://x.com/merettm/status/2095023204993490967
[S2]: https://arxiv.org/html/2507.05246
[S3]: https://arxiv.org/pdf/2609.37312
[S4]: https://deploymentsafety.openai.com/gpt-6-astra/evaluating-auto-review

[M3]: https://huggingface.co/XiaomiMiMo/MiMo-V2.6-Pro-MOPD/blob/adea8e2c5373181e5a973fa1ecb343cb31af214b/README.md
[I1]: https://huggingface.co/moonshotai/Kimi-K3/blob/f831ab66814297da540d832a5235f8e904f29d06/modeling_kimi_linear.py
[I2]: https://raw.githubusercontent.com/huggingface/transformers/02d8fb9784e8f14a1251e4c992cd82a5762417c6/src/transformers/models/qwen3_5_moe/modeling_qwen3_5_moe.py
[I3]: https://raw.githubusercontent.com/fla-org/flash-linear-attention/2d5b8ba6fb8ef10d06589e70ef0e770fd46ea91c/fla/ops/kda/fused_recurrent.py
[I4]: https://huggingface.co/deepseek-ai/DeepSeek-V4-Pro-0813/blob/72e1d3230f6c080a530b0a1d46f8eb4602340597/inference/model.py
[I5]: https://huggingface.co/deepseek-ai/DeepSeek-V4-Pro-0813/blob/72e1d3230f6c080a530b0a1d46f8eb4602340597/config.json
[I6]: https://huggingface.co/moonshotai/Kimi-K3/blob/f831ab66814297da540d832a5235f8e904f29d06/config.json
[Q4]: https://github.com/QwenLM/Qwen3.8
[Q5]: https://arxiv.org/abs/2608.30320
[N4]: https://www.minimax.io/models/text/m3
