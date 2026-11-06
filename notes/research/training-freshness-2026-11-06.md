# Training freshness check, 26 October to 6 November 2026

For the essay *Filling the Stores*. This extends the addendum of 26 October in [frontier-model-architectures.md](frontier-model-architectures.md).

Labels: **Confirmed** (read in the primary source), **Reported** (secondary source), **Inferred** (my reasoning). For papers, "abstract" means I read only the abstract; "text" means I read the relevant passages. Hugging Face repositories were read through the API, raw files and safetensors headers. Section 5 reports weight diffs I ran for this check, which are new measurements, not literature.

## 1. Kimi K3.1 Pro

### What Moonshot says

**No first-party source says how DSA was trained onto K3.** [Confirmed for the blog, card, config, license and repository file list; absence checked by full-text search of the blog extract and the README.] The words DSA, sparse, indexer, quantization and MLA do not occur in the [tech blog](https://www.kimi.ai/blog/kimi-k3-1-pro). The [card](https://huggingface.co/moonshotai/Kimi-K3.1-Pro) gives the replacement and the index parameters and nothing about training them:

> "Compared with Kimi K3, we replace the full-attention Gated MLA layers with Gated DeepSeek Sparse Attention (Gated DSA) layers for more efficient long-context modeling."

The blog's training statements, all verbatim from the page text [Confirmed]:

> "Kimi K3.1 Pro is a post-trained version of Kimi K3, with substantially larger post-training compute. To enable large-scale joint RL across hundreds of downstream domains, we optimized every layer of the stack — the RL framework, long-context inference, training efficiency, sandbox infrastructure, rollout scheduling, and a shared platform for environment quality checks — so that each increment of RL compute delivers stable, predictable returns."

> "During development, we observed vulnerability research performance improving steadily as post-training scaled. Tracing the source of this trend, we found that cyber-related content was embedded within the general mid-training corpus, and cyber-related tasks were present in the RL environment mix — a natural byproduct of training on broad data. In preliminary experiments on internal models, we found that without data removal at either the mid-training or the RL stage, downstream cyber capability would increase substantially."

> "For the open-weight release of K3.1 Pro, we identified and removed cyber-related data from both training stages, while retaining the general-purpose coding tasks needed for model usefulness."

> "On xdev-bench-hard, the checkpoint without these risk-reduction measures — no cyber-related data removal at mid-training and no cyber-related RL environment filtering — solves 90.5% of problems at pass@3; the final K3.1 Pro reaches 81.0%."

> "K3.1 Pro's offensive cyber capability is, by design, below what our pipeline can produce, and remains behind that of frontier proprietary models."

- **Data removal reaches mid-training.** So the released K3.1 Pro was not made only by further post-training on the published K3 checkpoint, unless the phrase "mid-training" covers a stage added after K3. The sentence "a post-trained version of Kimi K3" and the sentence about removing data from mid-training are in some tension. The likeliest reading is that the K3.1 line branched at or before K3's mid-training. [Inferred. No source states the branch point.] The addendum of 26 October and the outline quote the first sentence alone; the second changes what it can mean.
- **Compute.** No figure for post-training compute. "Substantially larger" is all that is given. [Confirmed]
- **Domains.** "Hundreds of downstream domains" is not itemized. No RL algorithm, optimizer, loss, reward or distillation stage is named. [Confirmed]
- **API versus weights.** No source says that the API model and the released weights are the same. The blog's "For the open-weight release" leaves room for a difference, and "the final K3.1 Pro" is not tied to a channel. The card only gives the API model name `kimi-k3.1-pro`. [Confirmed for absence]
- **License.** "Kimi K3.1-Pro License", a modified MIT form. Section 2 requires a separate agreement for Model-as-a-Service businesses with over USD 20M revenue in 12 months; section 3 requires attribution above 100M monthly users or USD 20M monthly revenue. It differs from K3's license only in the model's name (diff). [Confirmed]
- **Quantization.** The card row "MXFP4 weights / MXFP8 activations (quantization-aware training)" is identical to K3's. K3's card adds: "Kimi K3 applies quantization-aware training from the SFT stage onward". The K3.1 card has no such sentence. [Confirmed] Note for the outline: §9 says "K3's post-training", and SFT onward is the first-party wording.
- **Technical report.** None linked; none on arXiv under "K3.1" as of 6 November. [Confirmed]

### What the repository shows

Repository `moonshotai/Kimi-K3.1-Pro`: created 2 November, head `d9e99b07` (5 November, `encoding_k3.py` only). [Confirmed]

- **The repository ships no modeling code.** `auto_map` has only `AutoConfig`; K3's `modeling_*.py` files have no counterpart. The indexer's forward pass is visible only in third-party code (below). [Confirmed]
- **The checkpoint is K3 plus indexers.** K3 has 497,220 tensors and K3.1 has 497,340. All K3 names are retained, including the MLA projections (`kv_a_proj_with_mqa`, `kv_b_proj`, `q_a_proj`, `q_b_proj`). The 120 new tensors are exactly `self_attn.indexer.{k_norm.bias, k_norm.weight, weights_proj, wk, wq_b}` on 24 layers (0-based 3, 7, …, 91, 92). [Confirmed: `model.safetensors.index.json`]
- **Indexer size.** From the safetensors header, in BF16: `wq_b` 4096×1536, `wk` 128×7168, `weights_proj` 32×7168, two 128-vectors for `k_norm`. That is 7,438,592 parameters per layer, 178,526,208 in all, which equals the difference of the two repositories' total parameter counts exactly. [Confirmed] So "2.8T" is unchanged, and the indexers are 0.006% of the model.
- **Config.** `dsa_config` as already known, plus `index_rope_dim: 0`, `index_k_norm_type: layernorm`, `index_topk_freq: 1`, `index_skip_topk_offset: 1`. `linear_attn_config.full_attn_layers` is unchanged. [Confirmed]

Third-party implementers read it the same way. The [vLLM PR #66030](https://github.com/vllm-project/vllm/pull/66030) says "Kimi-K3 with DSA (DeepSeek sparse attention) on every MLA layer". The [llama.cpp PR #31779](https://github.com/ggml-org/llama.cpp/pull/31779) says "K3.1 reuses most of K3, but replaces the full-attention MLA layers with DSA." [Reported: neither is Moonshot]

### Third-party RL on K3.1 freezes the indexer

RadixArk's [Miles recipe](https://github.com/radixark/miles/blob/main/docs/models/kimi/kimi-k31.md) (PR #4666, 4 November) is an RL LoRA recipe for K3.1: "The indexer stays frozen." The PR adds: "a trainer that attends densely would not match an SGLang rollout that attends to the indexer's top-k." [Confirmed as a third-party recipe. It says nothing about how Moonshot trained.] It is evidence of one thing the essay can use: after adding a selector, RL has to run through the selector, because rollouts do.

## 2. New reports and card statements from the labs

| Lab | New since 26 Oct | Status |
|---|---|---|
| Moonshot | K3.1 Pro weights (section 1) | Confirmed |
| Xiaomi | MiMo-V2.6-Pro RL and MOPD cards: 28 Oct commits add a "Use Restrictions" section. Nothing on training. arXiv 2610.11959 still v1. | Confirmed |
| Alibaba | No new language checkpoint on Hugging Face since Qwen3.8-Flash-Next (24 Aug). No Qwen3.8-Max report. No Qwen4 repository or paper. The only Qwen4 page found is an unofficial `stealth-model` repository. | Confirmed for absence; the stealth page is not evidence |
| Z.ai | No GLM-5.3 report. The card still cites arXiv 2602.15763 (v2, 24 Feb). `z.ai/blog/glm-5.3` returned no text to my fetcher. | Confirmed for the card and arXiv |
| DeepSeek | No new repository since V4.1-Flash-1017. Change log has no November entry. arXiv 2609.19969 still v1. | Confirmed |
| MiniMax | M3.1-Flash: evaluation commits only (26 Oct, 30 Oct, 5 Nov; read by title). No M3 training report. arXiv 2606.13392 is the architecture paper, v2 of 12 June. | Confirmed |

**"RL with self-feedback" is still one sentence.** The [release note](https://api-docs.deepseek.com/news/news261017): "DeepSeek-V4.1-Flash-1017 uses reinforcement learning with self-feedback to improve end-to-end project development—from game creation to 3D modeling." The [card](https://huggingface.co/deepseek-ai/DeepSeek-V4.1-Flash-1017) calls it "a minor update" and has no training statement. Its report link goes to the base V4.1-Flash PDF. "Self-feedback" is undefined. [Confirmed]

**GLM-5.3's card gives the cleanest post-training statement of any pair.** "GLM-5.3 uses the same base model as GLM-5.2 — every gain comes from post-training." [Confirmed]

**One Qwen fact from outside Alibaba.** FlashNext-RL ([arXiv 2610.28998](https://arxiv.org/abs/2610.28998), Snowflake, 20 Oct) reports RL on the open Qwen3.8-Flash-Next. "We train the full 48-layer model, but freeze the first two layers, the n-gram table, the QSA indexer and the MTP head; this is not an update of every model parameter." It uses Muon for matrices and AdamW for the remaining groups, and reports 22.4-minute iterations for 1,024 rollouts at 131K tokens on one B200 trainer node plus three inference nodes. The model has a 51B frozen n-gram table. [Confirmed: text] This is a third-party recipe on an adjacent model, not Qwen's own and not on the 2.4T checkpoint.

## 3. New papers

### Indexers

- **Retrofit by KL is now a repeated recipe, and cheap.** All of these freeze the base model and fit the selector to its attention. [Confirmed: text]
  - ZHA ([2610.42112](https://arxiv.org/abs/2610.42112), Zyphra): "a short KL warmup of only a billion tokens" on Qwen3.6-35B-A3B and Nemotron-3.5-Lightning-30B-A3B at 32K. For comparison, they trained MSA's indexer on 40B tokens with the backbone frozen.
  - D-LSA ([2610.42147](https://arxiv.org/abs/2610.42147)): "a short distillation that trains only W_Q, K(idx) and a temperature τ per layer, with the base model frozen", on GLM-5.3-Flash and Qwen3.8-27B. The paper says this "mirrors the dense warm-up of DSA".
  - RecSA ([2611.07232](https://arxiv.org/abs/2611.07232)): two stages, freeze the backbone and fit the pooler by KL, then freeze the pooler and train the backbone. 0.62B tokens on Qwen3-4B.
  - N-LSA, same LSA paper: stop-gradients and next-token loss alone. Already noted in the outline.
- **Retrofit with no gradient updates at all.** CISA ([2611.03200](https://arxiv.org/abs/2611.03200), NVIDIA, 2 Nov): "retrofits pretrained dense attention models without gradient updates", within about 2 RULER points at 1M on Nemotron 3 Ultra. [Confirmed: abstract] It is a counterpoint to "selectors must be trained": selectors built from existing keys can suffice.
- **Selection without its own indexer pass.** MLI ([2611.03768](https://arxiv.org/abs/2611.03768), 2 Nov): "needs no retraining and no new weights", because adjacent layers select nearly the same tokens. [Confirmed: abstract] Bears on IndexShare, not on training.
- **Scale of indexer training.** HyScale ([2610.32057](https://arxiv.org/abs/2610.32057)): selection dominates long-context training; "the output of selection is not an activation, but rather a set of indices", so selection is replayed in recomputation. 2.07× on GLM-5.1 at 1M tokens on 512 H20s. [Confirmed: abstract]

None of these describes K3.1. They show that adding an indexer to a finished model by frozen-backbone KL is a known and cheap route, which is a reason K3.1's silence cannot be filled in by analogy. [Inferred]

### On-policy distillation

- **OPD versus GRPO on cost.** [2611.08453](https://arxiv.org/abs/2611.08453) (5 Nov): with an external teacher, OPD "generally loses to GRPO in accuracy per training FLOP". With the student's own GRPO checkpoint as teacher it recovers that accuracy "with 50× fewer distillation FLOPs". Multi-teacher consolidation of per-domain experts costs 5.2% to 8.0% of specialist FLOPs, and the whole pipeline reaches joint GRPO's 2-domain performance "with 42.0% fewer total FLOPs". [Confirmed: abstract] This is the most direct quantitative support so far for "specialists, then distillation".
- **Consolidation loses out-of-distribution ability.** [2611.05609](https://arxiv.org/abs/2611.05609) (3 Nov), on Qwen3: OPD and MOPD reach 96.04–102.73% of teachers' in-distribution scores, yet OOD scores stay 2.45–16.25% below the base model. Compositional OOD stays 18.19–24.34% below the best teachers. [Confirmed: abstract]
- **Why the student barely changes.** [2610.11247](https://arxiv.org/abs/2610.11247): "small relative parameter changes (0.025-0.098%) and high similarity between the student's representations before and after OPD (linear CKA >0.98 across layers)". [Confirmed: abstract] [2611.08016](https://arxiv.org/abs/2611.08016) (5 Nov) studies the feedback loop from signal to parameter update to rollout distribution. [Confirmed: abstract]
- **OPD then RL beats joint.** [2609.04108](https://arxiv.org/abs/2609.04108) and, for rubrics, [2610.02781](https://arxiv.org/abs/2610.02781). [Confirmed: abstract]

None reports a frontier-scale model in its abstract. The named models run from 0.6B to about 4B. [Confirmed for the abstracts]

### RL recipes

- **Axion 1.0** ([2611.03233](https://arxiv.org/abs/2611.03233), [code](https://github.com/bytedance/axion1_0), ByteDance and universities, 2 Nov): "open beyond model weights: we release the complete recipe, including data construction, generation, filtering, verification, prompts, and training code". Two SFT stages then RL, "without dedicated mid-training, direct preference optimization (DPO), or on-policy distillation (OPD)". Sizes 35B and 122B. [Confirmed: abstract and front matter] This is a new contrast for §11: a third case beside the open-weights-closed-training seven and MAI's closed-weights-open-training. I did not read the recipe.
- **RL at low precision.** MoEResQ ([2611.04376](https://arxiv.org/abs/2611.04376), Nov), TRACE ([2610.07767](https://arxiv.org/abs/2610.07767)) and QUADS ([2607.15810](https://arxiv.org/abs/2607.15810)) all treat FP4 RL on MoE. The MoE-specific finding: the router's discrete choice makes alignment between training and inference sensitive to asymmetric correction, and QUADS finds activation error, not weight error, the main source of instability. [Confirmed: abstract] These are the closest public explanations of why QAT runs through RL.
- **A hidden lag in every RL pipeline.** [2610.41073](https://arxiv.org/abs/2610.41073) (29 Oct): RL keeps FP32 master weights and serves a BF16 copy, and "on Qwen3-1.7B only 0.4-0.5% of served weights change per step, and the policy that generates the training data lags the optimizer by 50-150 steps." [Confirmed: abstract] It is a concrete, store-level fact about RL: most small writes are lost at the store's own precision until they accumulate.

### Measurements of what RL changes: the essay's claim fails as stated

**The claim that nobody has measured what RL changes in a model's stores does not hold.** There is a literature, from May 2025 onward, with parameter-level, layer-level and module-level results. What survives is narrower. See "What is still unmeasured" below.

**Which weights move.**

- **[Mukherjee et al.](https://arxiv.org/abs/2505.11711)** (NeurIPS 2025). Across 7 algorithms and 10 models: "We find that the updates of RL finetuning do not concentrate in specific layers or components of the transformer. Instead, nearly all parameter matrices receive similarly sparse updates (§ 3). An exception is the layer normalization layers, which receives little to no updates." The abstract gives 5–30% of parameters updated. [Confirmed: text; the abstract figure via search result]
- **[Zhu et al.](https://arxiv.org/abs/2511.08567)** (Nov 2025) revise this. With a BF16-aware probe, unchanged weights are 0.6–18.8% under SFT and 36–92% under RL. They attribute apparent sparsity largely to rounding: "Gate III (Precision) hides micro-updates in non-preferred regions". RL "learns off principal directions in weight space", and SFT "targets principal weights, distorts the spectrum". Update locations are stable across runs for Q, K, V, O and all three MLP projections alike (Jaccard 0.55–0.60 against baselines 0.37–0.47). The largest model in their table is UloRL-A3B on Qwen3-30B-A3B, an MoE, at 91.7%. [Confirmed: text]
- **[Ghosh et al.](https://arxiv.org/abs/2609.39321)** (Sep 2026), 1.5B–7B, per-tensor relative Frobenius change: "Across all models, the largest changes are concentrated in attention and MLP projection matrices, while layer-normalization parameters exhibit comparatively small movement." Hidden-state shift "is small and roughly flat through the bulk of the network and grows sharply in the last 2–3 layers". Note this run uses LoRA adaptation. [Confirmed: text]
- **[Gao and Gao](https://arxiv.org/abs/2610.41073)**, above, is the per-step version.

**Which layers matter.**

- **[Zhang et al., *Is One Layer Enough?*](https://arxiv.org/abs/2607.01232)** (Jul 2026), seven Qwen models, three RL algorithms. Training one layer alone recovers up to 114% of full RL's gain, and the weakest under 30%. High-contribution layers sit in the middle of the stack. Under full training the weights move about equally everywhere: "layer contribution is not explained by how much a layer's parameters change during training, as middle layers do not change more than other layers in full training, yet they contribute far more when trained in isolation." [Confirmed: text] This is the sharpest published result for the essay: how much a store moves and how much it matters come apart.
- **[Nagar and Tan](https://arxiv.org/abs/2610.39182)** (29 Oct), Qwen2.5-1.5B on tic-tac-toe, SAE features across GRPO. "RL post-training neither adds nor removes concept information but reorganizes which features dominate the representation", most in middle layers, with the decision itself in late layers. [Confirmed: text] New in the window.
- **[Zhou, *The Convergence Gap*](https://arxiv.org/abs/2605.07282)** (May 2026): six pretrained and instruction-tuned pairs. Grafting late IT MLPs into PT hosts adds 0.34 nats of late KL; swapping PT late MLPs into IT hosts removes 0.51. This is about instruction tuning in general, not RL alone. [Confirmed: text]

**FFN against attention.**

- **[Gupta, Zhang and Jin](https://arxiv.org/abs/2610.22937)** (16 Oct): swapping attention patterns in six middle layers between the DPO and final RL checkpoints of Tulu-3-8B and OLMo-2-7B moves cue-following "61% to 73% of the way to the other checkpoint's level". In OLMo the query swap alone does most of it. So RL's effect on this behaviour runs through attention. [Confirmed: text]
- **[Yan et al.](https://arxiv.org/abs/2601.11061)** (Jan 2026): under spurious-reward RLVR, "Patching the MLPs yields significantly higher accuracy recovery than patching attention heads, confirming that MLPs are the primary storage for this learned knowledge." Qwen 2.5-specific; LLaMA and OLMo controls differ. [Confirmed: text]
- **[Perturbation Probing](https://arxiv.org/abs/2604.27401)** (Apr 2026): in safety refusal "about 50 neurons, or 0.014 percent of all neurons, control the refusal template", and "Opposition circuits appear when RLHF suppresses a pre-training tendency." [Confirmed: abstract]

These results split by behaviour, so no single "RL writes to FFNs" or "RL writes to attention" sentence is safe. [Inferred]

**What kind of change.**

- **[Venhoff et al.](https://arxiv.org/abs/2510.07364)**, nine pairs: "RL primarily teaches heuristics for orchestrating pre-existing base mechanisms, whereas SFT-distillation installs new ones". [Confirmed: abstract]
- **[Wang et al.](https://arxiv.org/abs/2608.01835)** (Aug 2026): "SFT tends to rewrite behavioral geometry, whereas reward optimization primarily reweights it." [Confirmed: abstract]
- **[Yu et al.](https://arxiv.org/abs/2609.35210)** (Sep 2026): "OPD reweights existing features rather than acquiring new ones". [Confirmed: abstract]
- **Disputed.** [Zhang et al.](https://arxiv.org/abs/2509.21044) (ICLR 2026) find RL raises activation intensity and diversity. [Tan et al.](https://arxiv.org/abs/2608.08224) reproduce two of three metrics and argue that activation is not control. [Confirmed: abstract and passage]
- **Updates differ by method.** In [2611.05609](https://arxiv.org/abs/2611.05609) §7.2, OPD's update norm is 55.4% of RL's (0.154 against 0.278). Its top 64 singular directions hold 69.0% of update energy against 39.9%, and stable rank falls from 19.0 to 6.90. Authors caution: "A causal link between these geometric properties and generalization has yet to be established." [Confirmed: text] See also [On the Geometry of OPD](https://arxiv.org/abs/2606.07082).
- **Handoff.** [2606.09932](https://arxiv.org/abs/2606.09932) attributes RL's failure after excessive SFT to lost plasticity and inspects parameter changes. [Confirmed: abstract]

The pattern across these papers is close to the essay's "post-training edits what pretraining wrote": RL moves almost every matrix, keeps the concepts, and changes which of them are used and when. SFT writes more, and more destructively. [Inferred, from the small models above]

### What is still unmeasured

I found no published measurement of any of these. [Searched; see section 6]

1. What RL changed inside any of the ten checkpoints named in the brief.
2. A split of RL's change across the store types the essay cares about: routed experts, shared experts, attention projections, recurrent gates, selectors, residual mixers.
3. Anything above about 30B total. The largest weight-diff subject I found is Qwen3-30B-A3B. Most studies run at 1.5B–8B.
4. Any such measurement on a hybrid, a sparse-attention model, or RL at agentic long-horizon scale.

## 4. MAI-Thinking-1

- **Report not revised.** The [PDF](https://microsoft.ai/pdf/mai-thinking-1.pdf) has `last-modified: Mon, 08 Jun 2026`, 3,317,663 bytes, 109 pages, sha256 `a267d745…86bd`. [Confirmed] The outline calls it "a 100-page report"; 109 is the count.
- **Weights not released.** Hugging Face search for "MAI-Thinking" returns no Microsoft repository, and `microsoft`'s new repositories since 15 October include none. [Confirmed for absence] Secondary sources call it closed-weight. [Reported]
- **No arXiv listing** for "MAI-Thinking". [Confirmed]
- **Its only statement about parameters** is the one the outline already quotes: "some instabilities are already embedded in the model parameters many steps before the actual collapse occurs". A text search of the PDF finds no measurement of which layers or weights RL changed. [Confirmed by keyword search, not a full read]

## 5. Weight diffs run for this check

Prompted by the gap above. Public same-architecture pairs make the measurement cheap: safetensors can be read by HTTP range request without downloading terabytes. I did this for four pairs on sampled layers. Scripts and raw outputs are in the session scratchpad and are not preserved.

**Metric.** Relative Frobenius difference $\|B-A\|_F/\|A\|_F$ per tensor. BF16 rounding contributes about 0.2%, so it can be ignored. FP4 tensors sit on a coarse grid, which inflates their figures, so they are not comparable with BF16 rows. FP8 is in between.

| Tensor family | K3 → K3.1 Pro | V4.1-Flash → 1017 | GLM-5.2 → 5.3 | MiMo Pro-RL → Pro-MOPD |
|---|---|---|---|---|
| Selector (indexer) | new in K3.1 | **0.12–0.29** | **0.10–0.21** | none in model |
| Attention projections | 0.08–0.12 | 0.064–0.078 (FP8) | 0.06–0.13 | `o_proj` 0.002–0.003; `qkv_proj` 95% of bytes equal |
| Shared expert FFN | 0.10–0.12 | 0.096–0.104 (FP8) | 0.10–0.14 | no shared expert |
| Routed experts | 0.17 (FP4, inflated) | 0.15–0.16 (FP4, inflated) | 0.11–0.12 | 98% of bytes equal (FP4) |
| Router weights | 0.05–0.075 | 0.045–0.049 | 0.03–0.06 | **byte-identical** |
| Layer norms | 0.01–0.05 | 0.003–0.02 | 0.004–0.011 | 0.0002–0.0005 |
| Input embedding | 0.086 | 0.016 | 0.128 | 0.0008 |
| Output head | 0.059 | 0.014 | 0.068 | 0.0013 |
| Router bias | byte-identical | near zero | byte-identical | byte-identical |

Sampled: K3 layers 3, 5, 47, 49, 91, 92; V4.1 layers 10 and 30 plus all eight indexers; GLM layers 5 and 40 plus five indexers; MiMo layers 5 and 40. Interior K3 figures cover both KDA and MLA layers; the last two layers are reported separately below. [All Confirmed as measurements of the published files]

Findings:

- **MiMo gives the one clean single-stage figure, and it is tiny.** The card calls Pro-MOPD "the MOPD upgrade of the MiMo-V2.6-Pro-RL checkpoint". That step moved weights 0.1–0.3%, thirty to a hundred times less than the other three pairs. Router weights, attention-sink biases, the MTP module and the audio projection are byte-identical, so they were frozen or unwritten. This matches small-model OPD results (2610.11247 reports 0.025–0.098%). [Confirmed for the diff and the card; Inferred for frozen]
- **In the other three pairs everything trainable moved, at a similar relative rate across attention and FFN.** Interior figures sit near 0.1. This matches the small-model result that weight change is nearly uniform. Attention in V4.1 moved a little less than the FFNs.
- **Selectors move as much as anything or more.** In V4.1 → 1017 they moved about two to four times as much as attention. GLM-5.3's card says all gains come from post-training. So the first-party post-training of DeepSeek and GLM did not freeze the indexer, or at least the two released endpoints differ in it. Both third-party recipes above do freeze it. [Confirmed for the diff; Inferred for the training]
- **The router moves least among the projections**, about half the rate of the others, and not at all in MOPD. That fits MAI's report of keeping expert balance through RL, though it does not show it. [Inferred]
- **Layer norms move least**, as in the small-model papers.
- **K3.1's last layers move more on the output side.** In layers 91 and 92, `o_proj` moved 0.17 and 0.22 and shared `up_proj` 0.16 and 0.34, against about 0.10 in the interior. `g_proj` and routed projections stayed lower. This recalls Ghosh et al.'s late-layer shift, though on weights, not activations.
- **K3.1's vision tower is nearly parked**: 0.007–0.008, about a fifteenth of the language model's rate, but not byte-identical. Its projector moved 0.107.
- **K3.1 shares K3's lineage.** Cosines are 0.985 or above on interior tensors. Independent runs from random initialization would not give that. It does not tell where the branch was. [Inferred]

Limits. These are endpoint diffs on a few layers. V4.1 → 1017 is a "minor update", probably post-training only. K3 → K3.1 includes whatever mid-training rerun happened. For GLM and possibly V4.1, the two endpoints may be separate post-training runs from a shared base, so the figures need not be one run's movement. Magnitude does not measure importance, as *Is One Layer Enough?* shows. No pair isolates RL itself: the only clean single stage is MOPD. Treat this as a first look worth a proper run, not a citable finding, unless the essay presents it as the author's own measurement with these limits.

## 6. Searched and not found

- **Moonshot.** Any first-party statement on DSA training, K3.1 post-training compute, RL algorithm, or API-versus-weights identity: blog, card, config, license, repository files. K3.1 technical report on the card or arXiv.
- **GitHub.** Searches for `index_skip_topk_offset`, `kimi_k31` and K3.1 pull requests found implementers only: vLLM, SGLang, llama.cpp, Miles, MindSpeed, Fireworks. No Moonshot training code. My calls to list Moonshot's own GitHub organization failed, so that listing is unchecked.
- **Labs.** GLM-5.3 report, Qwen3.8-Max report, Qwen4 report or weights, MiniMax M3 training report, any explanation of "self-feedback", revised V4, V4.1, K3, MiMo or MSA reports (arXiv version histories checked). The z.ai GLM-5.3 blog page could not be read this time.
- **Search terms for measurements.** arXiv API, sorted by date, on combinations of: GRPO, RLVR, RLHF, post-training, model diffing, crosscoder, sparse autoencoder, mechanistic, weight change, parameter drift, update geometry, layer-wise, feed-forward, MoE, frozen, indexer; plus web search. No result names K3, K3.1, GLM-5.x, DeepSeek-V4, MiMo, Qwen3.8-2.4T or MiniMax-M3 as the subject of a weight diff. `abs:"K3.1"` and `all:"K3.1 Pro"` return nothing.
- **Search limits.** arXiv keyword queries miss papers whose abstracts use other words, and one web result had to be followed by hand to find Mukherjee et al. A counterexample at frontier scale in a blog post or an unindexed report cannot be ruled out.
- **Not read.** Full texts of most papers labelled "abstract". Axion's recipe. The Miles recipe past the sections cited.

## 7. Summary: what changes the essay's picture

1. **The measurement claim must change.** "Nobody has measured what RL changes" is false. A literature since 2025 shows that RL moves nearly every matrix except layer norms, at a nearly uniform rate across depth, while the gains concentrate in middle layers. It reorganizes existing features rather than adding them. What holds: nobody has published this for any frontier checkpoint, above about 30B, or split by store type. A safe form is "measured in small models, unmeasured in the open frontier".
2. **Movement is not importance.** *Is One Layer Enough?* gives §10 a better point than the old claim: the stores all move about equally, and only some of the movement matters.
3. **K3.1's DSA story stays undisclosed, and is odder than the addendum implied.** Moonshot says nothing on training the indexer. The checkpoint is K3 with 120 added tensors and every MLA tensor kept. And data removal "from both training stages" means K3.1 is not simply K3 plus more RL.
4. **Selectors are trained during first-party post-training, or at least change.** In V4.1 → 1017 and GLM-5.2 → 5.3 the indexers moved as much as or more than attention, while third-party RL recipes freeze them. This adds a line to §9. It is from my own diff, so it needs the caveats in section 5.
5. **Public pairs make the missing measurement cheap.** Range reads compared four pairs within this one session. MiMo's RL-to-MOPD step moved weights only 0.1–0.3% with the router untouched, against about 10% across K3.1, V4.1-1017 and GLM-5.3. The essay can say the data are public, or use the table as the author's own first look.
6. **§11 gets a third case.** Axion 1.0 (ByteDance) is open in weights and recipe, with no mid-training or OPD. It sits beside the seven and MAI.
7. **§10 gets numbers.** OPD with a self-teacher costs a fiftieth of GRPO's FLOPs, and consolidation's cost is 5–8% of specialist FLOPs (2611.08453). Both are small-model results. Consolidation has an OOD blind spot (2611.05609).
8. **Unchanged.** No GLM-5.3, Qwen or MiniMax training report, no explanation of "self-feedback", and the MAI report and its closed weights stand as before. Small corrections for the outline: MAI's report is 109 pages, and K3's QAT runs "from the SFT stage onward".
