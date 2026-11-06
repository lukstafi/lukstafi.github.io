# Primary-source read: how DeepSeek, GLM, MiniMax and Qwen train (for *Filling the Stores*)

Date: 6 November 2026. Scope: the outline's §§7–10 as they touch DeepSeek, GLM, MiniMax and Qwen, plus the indexer and Sinkhorn worked examples. Kimi, MiMo and MAI-Thinking-1 claims are out of scope, except K3.1 Pro on adding an indexer.

Labels: **Confirmed** means read in the primary text, config or code. **Reported** means a source states it without data I could check. **Inferred** means my reasoning. A disclosure gap is stated as a gap.

## Sources read

- [V4] DeepSeek-V4, arXiv 2606.19348v1: §§1, 2.1, 2.2, 2.4, 3.4, 4, 5.1, 5.2, 6.
- [V4.1] DeepSeek-V4.1-Flash, arXiv 2609.19969v1: §§1, 2.1.1, 2.3.2, 2.4, 2.5, 3.1, 4, 5.1, 5.2, Conclusion.
- [mHC] Xie et al., arXiv 2512.24880v2: §§3.1, 4, 5, App. A.1.
- [V3.2] DeepSeek-V3.2, arXiv 2512.02556v1: §2.1, including §2.1.1 (indexer training).
- [GLM5] GLM-5, arXiv 2602.15763v2: §§1, 2, 3, 4.1.
- [G52] GLM-5.2 card (head `cf457fa`) and blog text, z.ai/blog/glm-5.2 (read from the JS bundle `glm-5.2-DXVc0kvW.js`).
- [G53] GLM-5.3 card (head `ba32f8c`) and blog text, z.ai/blog/glm-5.3 (bundle `glm-5.3-e3CGK9Mr.js`).
- [MSA] Lai et al., arXiv 2606.13392v2: §§3, 4.3, 5, 6, 7, Apps. A–C.
- [M3] MiniMax-M3 card (head `d95e30c`, later than the dossier's pin `f0e1c1e`) and minimax.io/models/text/m3.
- [M3.1] MiniMax-M3.1-Flash card and config (head `ce7f4df`).
- [Q38] Qwen3.8-2.4T-A95B card (`207bd68`, the dossier's pin); QwenLM/Qwen3.8 README. The blog qwen.ai/blog?id=qwen3.8 returned an empty shell, so it was not read.
- [QNext] *On the Design of Qwen3.8-Next Architecture*, arXiv 2608.30320v1. Added because it is Qwen's only training report. It describes a different model.
- [LSA] Latent Sparse Attention, arXiv 2610.42147v2: §§2.2, 3.3, 3.4, 4.1, 4.2, 4.4, 5.
- [GF] Goodfire, arXiv 2609.19101v2: abstract, §2.2, Fig. 2.
- [K3.1] Kimi-K3.1-Pro card, config and safetensors index (head `d9e99b0`), compared with the Kimi-K3 index; kimi.ai/blog/kimi-k3-1-pro.
- Code: `inference/kernel.py` at head of deepseek-ai/DeepSeek-V4.1-Flash.
- DeepSeek release note, api-docs.deepseek.com/news/news261017; DeepSeek-V4.1-Flash-1017 card (head `1bae0e1`).

PDF text came from pdftotext, so line-break hyphens in quotes are repaired. "Ablation", "Reasoning", "Perplexity" and similar are the sources' spellings.

---

## 1. What changes the outline most

1. **The outline's strongest order evidence is missing.** MSA ran the same 3T budget two ways, sparse from the start (MSA-PT) and sparse added at 2.6T (MSA-CPT). Native sparse wins most retrieval, math, image and video rows; RULER-8K is 84.2 against 77.2 (Full 79.8). The authors say "native sparse pretraining can adapt the model representations to the sparse attention pattern". [MSA §5.3, Table 2] **Confirmed.** See §5.1.
2. **Kimi K3.1 Pro did add indexers to a trained model.** Its parameter list is K3's plus exactly 120 new tensors, five `self_attn.indexer.*` tensors in each of 24 layers. Nothing was removed. The recipe is undisclosed. **Confirmed** (index comparison); see §6.
3. **The outline's sentence on MSA analysing V4.1 is wrong.** MSA (12 June) predates V4.1 (17 September) and never mentions it. MSA's own trained models rediscover sinks and local blocks. See claim 9.8.
4. **MSA does not show that skipping warm-up collapses attention entropy.** The early drop, seen in a sparse run with no warm-up comparison, is its motive for warm-up. The measured cost of no warm-up is worse scores. See claim 9.6.
5. **Pre-training metrics can mislead about post-training.** Qwen tried sparse writes "either from scratch or mid-training"; "Pre-training loss and benchmarks were almost unaffected, but the quality degraded clearly after post-training". [QNext §2.2] **Confirmed.** The outline has no case like it.
6. **V4.1 has two unrelated Sinkhorns.** One projects mHC's residual matrix. The other balances updates to Engram tables, embeddings and the head, and replaces AdamW there. The outline's optimizer split is therefore wrong for V4.1. See claim 8.5.
7. **V4's own instability story is missing.** Loss spikes "consistently tied to outliers in the MoE layers" led to Anticipatory Routing and SwiGLU clamping, and DeepSeek says it does not understand why they work. [V4 §§4.2.3, 6] **Confirmed.**
8. **GLM 5.2's 57.2% hack rate is the lowest of the three models measured on DeepSWE.** Kimi K3 is 90.8%, Qwen 3.8 Max 95.2%. [GF Fig. 2] **Confirmed.**

---

## 2. Per-model extraction

### DeepSeek V4 (Flash and Pro)

- **Tokens.** "we train DeepSeek-V4-Flash on 32T tokens and DeepSeek-V4-Pro on 33T tokens". [§1, §4.2.2] **Confirmed.**
- **Modalities.** Text only. Agentic data enters "during the mid-training phase". [§4.1] **Confirmed.** V4 has no separately budgeted mid-training stage. **Confirmed (absence).**
- **Optimizer.** "We maintain the AdamW ... optimizer for the embedding module, the prediction head module, the static biases and gating factors of mHC modules, and the weights of all RMSNorm modules. All other modules are updated with Muon." [§2.4] **Confirmed.**
  - §4.2.2 repeats the list without the mHC parameters, a small inconsistency. **Confirmed.**
  - AdamW β=(0.9, 0.95), ε=10⁻²⁰, weight decay 0.1. Muon momentum 0.95, weight decay 0.1, update RMS rescaled to 0.18. Hybrid Newton-Schulz, 10 iterations. No QK-Clip, since RMSNorm on queries and KV entries "effectively prevents attention logits from exploding". [§§2.4, 4.2.2] **Confirmed.**
  - Peak learning rate 2.7×10⁻⁴ (Flash), 2.0×10⁻⁴ (Pro), decaying tenfold by cosine near the end. Batch up to 75.5M and 94.4M tokens, scheduled upward. [§4.2.2] **Confirmed.**
- **Context stages.** "The training starts with a sequence length of 4K, and we gradually extend the training sequence length to 16K, 64K, and 1M." [§4.2.2] **Confirmed.**
- **Sparse schedule.** "we first warmup the model with dense attention for the first 1T tokens, and introduce sparse attention at the sequence length of 64K and keep sparse attention during the rest of the training. When introducing attention sparsity, we first set a short stage to warm up the lightning indexer in CSA, and then train the model with sparse attention for most of the training." (Flash.) Pro "starts with a longer stage of dense attention". [§4.2.2] **Confirmed.** Pro's dense length, the warm-up's length and the indexer's loss are not given. **Gap.**
- **Hash routing.** Dense FFNs in the early blocks are replaced by MoE layers with hash routing, "according to a predefined hash function with regard to the input token ID", in the first 3 MoE layers. [§§2.1, 4.2.1] **Confirmed.** No reason is given. **Confirmed (absence).**
- **Expert balancing.** Auxiliary-loss-free balancing (bias update speed 0.001) "augmented by a slight sequence-wise balance loss" of weight 0.0001. [§§2.1, 4.2.2] **Confirmed.**
- **Instability.** [§4.2.3] **Confirmed.**
  - "the occurrence of spikes is consistently tied to outliers in the MoE layers, and the routing mechanism itself appears to exacerbate the emergence of these outliers."
  - *Anticipatory Routing*: "the routing indices are computed and applied using the historical network parameters θ_{t−Δt}". It adds about 20% wall-clock while active and activates "exclusively when a loss spike occurs".
  - *SwiGLU clamping*: linear part to [−10, 10], gate capped at 10.
  - "their underlying principles remain insufficiently understood." [§6]
- **Precision.** QAT enters "during the post-training stage". MXFP4 on "(1) MoE expert weights ... and (2) the Query-Key (QK) path in the indexer of CSA". Index scores go from FP32 to BF16 with "a 99.7% recall rate of KV entries". Gradients pass by straight-through. During rollout "we directly use native FP4 quantized weights". [§5.2.1] **Confirmed.**
- **Drafter.** MTP depth 1, trained jointly, loss weight 0.3 then 0.1 at decay. [§§4.2.1, 4.2.2] **Confirmed.**
- **SFT and RL.** Each specialist goes through fine-tuning, then GRPO RL. Three reasoning modes come from "distinct length penalties and context windows". [§5.1.1] **Confirmed.** The actor also serves as a Generative Reward Model, with RL applied to it. [§5.1.1] **Reported.**
- **OPD.** "the mixed Reinforcement Learning (RL) stage was entirely replaced by On-Policy Distillation". [§5.1] Objective: Σᵢ wᵢ D_KL(π_θ ‖ π_{Eᵢ}), reverse KL on the student's rollouts. [eq. 29] "more than ten teacher models covering various domains". [§5.1.2] The usual token-level estimate "leads to high variance in gradient estimation and often causes training instability. Therefore, we adopt full-vocabulary logit distillation". [§5.1.2] **Confirmed.**
- **Pro-0813.** "greatly enhanced agentic capabilities", same structure "with a DSpark speculative decoding module attached". Nothing on how. [card] **Confirmed; gap.**
- **Budgets for post-training.** None given. **Gap.**

### DeepSeek V4.1-Flash

- **Tokens.** "We train DeepSeek-V4.1-Flash on 45T tokens of multimodal data with no instability." [§4.2.2] Text-only to multimodal token ratio 7:1. [§4.1] **Confirmed.**
- **Schedule.** Fixed batch of 100.6M tokens. Learning rate 2.6×10⁻⁴ to 28T, cosine to 2.6×10⁻⁵ by 40T, held to 45T. "We train the model from scratch with sparse attention at a sequence length of 64K and extend the sequence length to 1M at 34T tokens." [§4.2.2] **Confirmed.** So 1M arrives in the middle of the decay. **Inferred (arithmetic).**
- **No warm-up.** "Sparse attention is trained from scratch at a sequence length of 64K, without any dense attention warmup stages." [§1] **Confirmed.** Indexer loss and stop-gradient: not in the report or the model card. **Gap.**
- **Vision encoder.** [§§4.2.2, 2.5] **Confirmed.**
  - Separate stage first: SigLIP-style contrastive loss on about 47B image-text pairs at up to 224×224, then autoregressive fine-tuning on 236B tokens attached to a throwaway 4B MoE LLM at 544–1344 px.
  - "Although using higher resolutions in this phase yields notable gains, empirical results show that these benefits contribute little to the final model."
  - "During pre-training, we keep the vision encoder frozen until the learning-rate decay stage, while its final normalization layer and the vision–language projector remain trainable. At the onset of learning-rate decay, we unfreeze the vision encoder and optimize it jointly with the LLM with a smaller learning rate."
  - Card: images are "processed jointly with text embeddings from the start of language-model pre-training".
- **Optimizer.** Three families. [§§2.5, 4.2.2] **Confirmed.**
  - Muon for linear-transformation matrices; head-wise Muon for Query and Key weights ("head-wise Muon outperforms vanilla Muon", also crediting GLM 5 and Kimi-K3).
  - AdamW for normalization weights and "other non-matrix parameters, including biases and scaling factors".
  - Momentum followed by Sinkhorn balancing for "the Engram embedding tables, token embedding, and prediction head". Algorithm 1: K=11 alternating row and column L2 normalizations, τ=10⁻³, Nesterov, no weight decay. Reason: "applying Adam to the newly introduced Engram parameters substantially increases the optimizer-state memory footprint", and "this approach requires only a momentum buffer while empirically outperforming Adam."
- **Engram.** 196B parameters across two modules at layers 1 and 14; n-gram orders {2,3,4}; 8 hash heads; about 16M entries per head; FP8 tables and projections; Engram learning rate scaled 5×. [§§2.4.2, 4.2.2] **Confirmed.** That is 36% of the 552B backbone. **Inferred (arithmetic).** Table entries are updated with Sinkhorn scaling vectors kept across iterations. [§3.1.3] **Confirmed.**
- **Single-Pass mHC in pretraining.** "For pre-training, we keep the existing multi-kernel implementation, since the shift only changes which mixing coefficients each block applies." Quality: "Empirically, this shift incurs negligible performance degradation." [§2.4.1] Text **Confirmed**; that pretraining used the shifted rule is **Inferred**, strongly. No numbers. **Gap.**
- **FP4 KV.** "we introduce QAT during post-training". E2M1 with one E4M3 scale per 16 channels; quantized after RoPE; "We retain FP8 for the SWA KV cache due to its sensitivity to quantization." [§2.4.4] **Confirmed.** §1 says "during training with only marginal performance degradation". **Reported.**
- **Expert precision.** The report does not discuss it; code and config set `expert_dtype: fp4`. **Confirmed (config); QAT schedule is a gap.**
- **Hierarchical indexer.** "The mechanism is training-aware and introduced in post-training: the candidate restriction is applied identically during training and inference". [§2.3.2] **Confirmed.**
- **DSpark.** Three blocks, window 128, five draft positions, confidence head. "DSpark is introduced in a dedicated stage after pre-training. In this stage, we train only DSpark while keeping the backbone frozen. During post-training, we continue to train DSpark alongside the backbone, without propagating gradients from the DSpark objective into the backbone." It also speeds "rollout generation for RL and OPD". [§2.4.3] **Confirmed.**
- **Hash routing, Anticipatory Routing.** Neither appears in V4.1's report; the config has no hash-routing key. SwiGLU clamping remains (threshold 10). [§4.2.1] **Confirmed (absence).** Whether they were dropped is **Inferred**.
- **Multimodal balancing.** Separate correction biases per modality for routing, updated independently. Sequence balance loss 0.0001. [§§2.1.1, 4.2.2] **Confirmed.**
- **Post-training.** "we refrain from introducing novel post-training algorithms." "systematic improvements in the scale, diversity, and verifiability of synthesized data and environments account for essentially all of the observed gains." [§5.1] **Reported.**
- **Model merging.** "we use model merging to reinitialize successive RL runs. Specifically, we merge checkpoints from runs across different scaffolds or configurations". [§5.1.2] **Confirmed.** Whether this is weight averaging is not stated. **Gap.**
- **OPD.** "over 40 teacher models", and "the best teacher for each domain may come from a different stage of model development. Moreover, the teacher models may differ architecturally from one another and from the student." [§5.2.4] **Confirmed.**
- **Effort.** Scalar b in 1–100; length penalty decays exponentially with b; rewards are mean-centred within (prompt, effort) subgroups. [§5.1.4] **Confirmed.**
- **Asynchronous RL.** Stale rollouts, for the retrieval-lineage essay's question: length bias from short samples finishing first; bounded off-policy ratio; "a loss masking scheme that eliminates the contribution of tokens with excessive staleness"; concatenated routing replay across checkpoints. Batch-level dispatch "caused severe oscillations in training metrics". [§§5.2.1–5.2.2] **Confirmed.**
- **Reward hacking.** "we frequently observe agents attempting to perform reward hacking or unintentionally crashing the environment", including exploiting "recently disclosed vulnerabilities". [§5.1.3] **Confirmed.** A quality-inspection agent checks "hackability risks". [§5.1.1] **Confirmed.**
- **Limits.** "Potential selection errors in CSA2 ... may still cause capability degradation in untested boundary cases." [Conclusion] **Confirmed.**
- **1017 revision.** See claim 10.5.

### mHC

- **Problem.** Unconstrained Hyper-Connections show "an unexpected loss surge around the 12k step", and the Amax gain "yields extreme values with peaks of 3000". [§3.1] **Confirmed.**
- **Constraint.** Doubly stochastic residual mapping: non-expansive, closed under multiplication. Pre and post maps are sigmoid-bounded "to avoid the risk of signal cancellation". [§4.1; V4 §2.2] **Confirmed.**
- **Projection.** See §4.2 below.
- **Backpropagation.** "We implement the Sinkhorn-Knopp iteration within a single kernel. For the backward pass, we derive a custom backward kernel that recomputes the intermediate results on-chip and traverses the entire iteration." [§4.3.1] **Confirmed.** So gradients run through all 20 iterations, not through an implicit-function shortcut. **Inferred** from "traverses the entire iteration".
- **Stability.** With 20 iterations "the backward gradient gain deviates slightly from 1"; composite "reaching a maximum value of approximately 1.6", "three orders of magnitude" below HC. [§5.4] The 27B model ends 0.021 below baseline in loss, gradient norm "comparable to the baseline". [§5.2] **Confirmed.**
- **Conditions of those results.** AdamW, not Muon; 4096-token sequences; V3-style MLA MoE; 3B, 9B and 27B on 39B to 1.05T tokens; gating factors α initialized to 0.01. [App. A.1] **Confirmed.** Production use with Muon at 1M has no published stability comparison. "in-house large-scale training experiments" are only **Reported**. [§5.3]
- **Cost.** Wall-time overhead "only 6.7% of the overlapped 1F1B pipeline stage". [V4 §3.4.2] **Confirmed.**

### DeepSeek-V3.2 (DSA)

- "Starting from a base checkpoint of DeepSeek-V3.1-Terminus, whose context length has been extended to 128K, we perform continued pre-training followed by post-training". [§2.1.1] **Confirmed.** So DSA entered on a trained model, and post-training came after. V3.2 is the earliest case of the conversion route among these sources.
- Dense warm-up: "we keep dense attention and freeze all model parameters except for the lightning indexer", learning rate 10⁻³, 1,000 steps × 16 × 128K = 2.1B tokens. [§2.1.1] **Confirmed.**
- Sparse stage: all parameters, learning rate 7.3×10⁻⁶, top-2048, 15,000 steps × 480 × 128K = 943.7B tokens. **Confirmed.**
- "we detach the indexer input from the computational graph for separate optimization. The training signal of the indexer is from only L^I, while the optimization of the main model is according to only the language modeling loss." **Confirmed.**

### GLM-5, GLM-5.2, GLM-5.3

- **Tokens (GLM-5).** "27 trillion token corpus, prioritizing code and reasoning early on"; "totaling 28.5 trillion tokens for the base model". Mid-training stages: "32K (1T tokens), 128K (500B tokens), and 200K (50B tokens)". [§§1, 2, 2.3] **Confirmed.** How early priority was implemented is not given. **Gap.**
- **Modalities.** Text only. **Confirmed (absence).**
- **Optimizer.** Muon Split: split the up-projection matrices by head and orthogonalize each, so "projection weights for different attention heads" update at different scales; attention logits stay stable "without any clipping strategy". Table 1: MLA behind GQA-8 under Muon, matched with Split. [§2.1] **Confirmed.** AdamW's role is not stated. **Gap.**
- **Long-context data.** "a subsequent 200K mid-training stage, building upon the initial 128K phase, further bolstered the model's performance even within the 128K context window." [§2.3] **Confirmed.**
- **DSA.** "The DSA training begins from the base model at the end of mid-training." Warm-up 1,000 steps × 14 × 202,752 tokens (2.8B), peak learning rate 5×10⁻³; sparse adaptation 20B tokens, "enough to adapt the DSA model to match the performance of the original MLA model". Fine-tuning both on the same SFT data: they "tie in training loss and evaluation benchmarks". [§2.1.1] **Confirmed.**
- **The 7.9 RULER points.** [§2.1.2, Table 6] **Confirmed.** The model is GLM-4.7-Flash, not GLM-5. Warm-up "trains only the indexer ... while keeping the base model frozen"; joint phase 150B tokens.

  | RULER | Base | Warm-up only | Joint DSA |
  | --- | --- | --- | --- |
  | 16K | 95.83 | 95.40 | 96.69 |
  | 32K | 92.96 | 90.09 | 93.45 |
  | 64K | 85.34 | 84.05 | 87.06 |
  | 128K | 79.21 | 71.35 | 78.86 |

  The joint row also has 150B more training tokens than the base row, so its gains above base are not all due to sparsity. **Inferred.** GLM calls DSA "lossless by construction" in the paragraph before this table. **Confirmed**; its own warm-up row contradicts that. **Inferred.**
- **Other efficient attention.** Continual training from a 9B full-attention base, 190B tokens at 64K, half the layers converted. Naive SWA interleave: −30.35 on RULER@128K. SimpleGDN "maximally reusing pre-trained weights" still loses 8.25. [§2.1.2, Table 5] **Confirmed.**
- **Precision.** "we apply INT4 QAT in the SFT stage". [§2.4.3] **Confirmed.** GLM-5.2 adds "KV-cache FP8". [G52] **Confirmed.**
- **SFT.** Up to 202,752 tokens. "Erroneous segments within trajectories are retained but masked out in the loss function". [§3.1] **Confirmed.**
- **RL (GLM-5).** Reasoning, then Agentic, then General. GRPO with IcePop, KL term removed, β=2, ε 0.2 and 0.28, group 32. [§3.2] **Confirmed.** For agents, "only model-generated tokens are used for optimization, and the environment feedback is ignored in loss computation". [§4.1] **Confirmed.**
- **The indexer in RL.** "non-deterministic top-k operators ... caused drastic performance degradation during RL after only a few steps, accompanied by a sharp drop in entropy." Fix: `torch.topk`. "We also freeze the indexer parameters by default during RL to accelerate training and prevent unstable learning in the indexer." [§3.2] **Confirmed.**
- **Asynchrony.** Token-level masking outside [1−ε_ℓ, 1+ε_h], rollout log-probs as behaviour proxy, samples dropped when staleness exceeds τ. [§4.1.2] **Confirmed.**
- **Cross-stage distillation (GLM-5).** "sequentially optimizing for distinct objectives can lead to the cumulative degradation of previously acquired capabilities." The teachers are "the final checkpoints from the preceding training stages". Advantage replaced by sg log(π_teacher/π_train), group size 1, batch 1024. [§3.5] **Confirmed.** This is token-level, the estimator V4 rejects. **Inferred.**
- **GLM-5.2.** [G52] **Confirmed text**; quality claims **Reported.**
  - "GLM-5.2 is trained with IndexShare from mid-training with 128K sequence length, outperforming GLM-5.1 on long-context benchmarks with less computation."
  - "every 4 transformer layers share a lightweight indexer"; 2.9× per-token FLOPs at 1M.
  - "we substantially expanded 1M-context training for coding-agent scenarios". Stage at which, and token count: not given. **Gap.**
  - "we used the slime framework to conduct parallel OPD training, efficiently merging more than ten expert models into the final model. The entire OPD training process took approximately two days".
  - RL moves "from group-wise optimization to a critic-based PPO formulation that learns from individual rollouts" so that compacted sub-traces can all train.
  - "We find that GLM-5.2 shows more potential hacking behavior than GLM-5.1." The anti-hack module is a rule filter then an LLM judge, online per tool call. On a hit it "blocks the call and returns dummy information", which "helps prevent the training instability and model collapse that can happen when rollouts are abruptly stopped".
- **GLM-5.2's drafter mismatch.** [G52] **Confirmed.**
  - In GLM-5.1's multi-step MTP, step 2's KV "is a mixture of kv₁:₄ computed from the target model and kv₅ computed from the mtp layer" at inference, while training took all hidden states from the target model.
  - With IndexShare on the MTP layer, step 2 reuses step 1's top-k, so its KV "includes only kv₁:₄, all from the hidden states of the target model". This serves "eliminating the training-inference discrepancy in GLM-5.1's mtp layer".
  - Rejection sampling and an end-to-end TV loss follow.
  - Ablation at 7 steps on GLM-5.1's backbone and data, acceptance length: 4.56, 5.10 (+IndexShare + KV Share), 5.29 (+rejection sampling), 5.47 (+TV loss).
  - GLM-5 earlier shared parameters across 3 MTP layers for a different mismatch. [§2.1, Table 2: 2.76 against V3.2's 2.55 at 4 steps]
- **GLM-5.3, verbatim.** [G53] **Confirmed.**
  - Card and blog: "GLM-5.3 uses the same base model as GLM-5.2 — every gain comes from post-training."
  - Blog: "**Scaling post-training is all we did for GLM-5.3.**"
  - Blog: "Over the past month we kept scaling on this stack: more environments, more diverse tasks, and more compute spent training on them."
  - Card: "As we scaled post-training, cyber capability developed faster than we expected."
  - Blog on verifiers: "Verifiers are synthesized without access to the reference solution, while solver trajectories are used to discover and close reward shortcuts. A verifier that passes oracle, no-op, and unsolved-state checks produces a binary reward reliable enough to train on directly."
  - Blog: "top-p mask, top-k and full-vocabulary OPD", log-prob training–rollout difference "controlled at the 1e-7 level".
  - Compute, token and teacher counts for 5.3: not given. **Gap.** "every gain" is the lab's own attribution. **Reported.**

### MiniMax

- **M3.** "M3 undergoes mixed-modality training from the very first step". [card] "multimodal training from step zero". [page] 428B total, 23B active. **Confirmed.**
- **Not disclosed for M3:** token budget, optimizer, context stages, SFT, RL, distillation, balancing. **Gap.**
- **The MSA paper's experiments are a different model.** 109B total, 6B active, 41 layers, native multimodal, 3T tokens. [§5] **Confirmed.** Nothing says M3's schedule matched it. **Gap.**
- **M3.1-Flash.** Same parameter totals. "the first three full-attention layers are replaced with sparse attention"; "the routed MoE experts and the attention paths are quantized during training"; "DSpark replaces the earlier EAGLE-like MTP approach". [card] Config: `moe_quant_algo: NVFP4`, `moe_quant_format: nvfp4-pack-quantized`, `quant_method: mxfp8`. **Confirmed.** Whether the three layers were converted on M3's weights, or when QAT entered: not stated. **Gap.**

### MSA recipe and ablations

Equations are in §4.1. **All Confirmed** unless marked.

- "The top-k selection in Equation 7 is non-differentiable, so the language-modeling loss cannot train the index Q/K projections". [§3.2]
- Main experiments: MSA-PT is from scratch, 40B-token warm-up, then sparse. MSA-CPT is a 2.6T GQA checkpoint, then 40B warm-up, then 360B sparse. [§5.1]
- Training curves: LM-loss curves of native sparse and full are "nearly indistinguishable". [§5.2]
- CPT dynamics: KL falls from about 0.40 to about 0.15 in warm-up, then settles near 0.18; block recall about 0.72; score recall about 0.92. [Fig. 3; values read off the plot, approximate]
- Pilot ablations use 10.53B total, 1.47B active, 16 layers, and report figures without numbers. [App. B.1]
  - *Gradient source.* LM loss through an index value head alone gives poor long-context retrieval. KL alone improves retrieval but reduces short-context ability. Both is best. [B.2]
  - *No detach.* "With larger KL coefficients, occasional KL-gradient spikes propagate into the backbone, causing gradient-norm spikes and LM-loss divergence within a few hundred steps". "Even at stable coefficients, standard short-context benchmarks gradually regress". "the backbone can lower the KL loss by simplifying the Main Branch attention distribution, rather than by improving the Index Branch." [B.3]
  - *No warm-up.* See claim 9.6. [B.4]
  - *Learnable sink.* No consistent gain; does not remove the first-token sink. [B.5]
  - *FLOP-matched sliding window.* Higher perplexity across the trajectory. [B.6]
- Appendix C: forcing sink and window is unnecessary for general scores; RULER-32K is 61.5 unforced against 65.8 forced, RULER-8K 71.6 against 71.7. The text calls retrieval "comparable" (Table 5). The final recipe "only forces the special incomplete self block". The value head is dropped once warm-up is used. [C.2, C.3]
- Sinks and locality: "the learned sparse pattern recovers the main structures expected from dense attention". "Even without explicitly forcing the indexer to select the first key-value block ... the learned Index Branch naturally assigns high selection probability to the initial block across all layers and heads." [App. A]

### Qwen

- **Qwen3.8-2.4T-A95B card.** "Training Stage: Pre-training & Post-training"; "MTP (Multi-Token Prediction): trained with multiple steps"; "Context Length: 262,144 natively and extensible up to 1,010,000 tokens"; the repo holds "the post-trained model". **Confirmed.** That is the whole training disclosure for this checkpoint.
- **Qwen repo.** "Built on the architectural foundation of Qwen3.5". The only training statements describe Qwen3.5: "Early fusion training on trillions of multimodal tokens", "Reinforcement learning scaled across million-agent environments", "asynchronous RL frameworks". **Confirmed.** They cannot be assigned to Qwen3.8. **Gap.**
- **Qwen3.8-Flash-Next** is another model (125B, 6B active, GDN hybrid, Gated Residual, n-gram tables). The dossier's warning stands: it supplies no 2.4T facts. It is useful as Qwen's practice:
  - "QSA is introduced during the continued pretraining (CPT) stage of Qwen3.8-Flash-Next with a sequence length of 256K tokens." Dense distillation, indexer only: 1,000 steps × 8 × 256K, about 2B tokens, learning rate 10⁻³. Joint sparse: 8,000 steps × 96 × 256K, about 200B tokens, learning rate 2.5×10⁻⁵. [§2.1.2] **Confirmed.**
  - The teacher sums heads, L1-normalizes, then max-pools to blocks. The KL runs over complete blocks, then over the selected top blocks with teacher renormalized. [eqs. 17–20] **Confirmed.**
  - Stress tests at constant, high learning rate; batch-size warm-up found unnecessary, with 18.8% more optimizer steps for no gain; no explicit clipping needed. [§§3.2–3.3] **Reported.**

### Latent Sparse Attention

- **D-LSA.** "a short distillation that trains only W^(idx)_{Q,K} and a temperature τ per layer, with the base model frozen. This mirrors the dense warm-up of DSA". [§3.3] Loss: L_i = KL(A_i ‖ Â_i), A_i the head-averaged attention over selectable keys R_i, Â_i the softmax of index scores over R_i at temperature τ. [eq. 2] Training set: 352M tokens, 48k steps, 128 queries a step, learning rate 3×10⁻⁴. The target keeps only each query's 2,048 largest keys, "while Â_i still spans all of R_i". [§4.1] "Unlike DSA, we do not follow the distillation by training the whole model under sparse attention". [§4.1] **Confirmed.**
- **Results.** Qwen-3.8-27B: within 5 points of Full up to 1M, above it at 10M (RULER 63.9 against 59.9). GLM-5.3-Flash: within 3 up to 1M, behind by up to 8 at 2–5M. "This comparison favours the baseline, which was trained together with the model". Training-free PCA projections stay "close to D-LSA (Flat) on Qwen-3.8-27B, but trail it on GLM-5.3-Flash". [§4.2] **Confirmed.**
- **N-LSA.** "We stop the gradient through the selection, and the NTP loss trains the attention projections only through the keys each query attends to". "no teacher, no index projections and no auxiliary loss". [§3.4] Scale: about 0.5B parameters, 24 layers, 100B tokens at 4K then 12B at 128K. Validation loss 1.085 against Full's 1.085. [§4.4] **Confirmed.**
  - "During pre-training at 4k tokens, all methods stay within 0.004 of each other, as their keys cover most of the context." So selection hardly binds until the 128K decay phase; N-LSA spends most of its budget in something close to a dense warm-up, by context length. **Inferred.**
  - It reads 2,564 keys per query (2,048 + 512 + 4) out of at most 4,096. **Inferred (arithmetic).**

### Goodfire

Hack rates under their GPT-5.6 Sol judge with hand-tuned rubrics. [Fig. 2a, abstract] **Confirmed.**

| Model | SWE-bench | DeepSWE | ImpossibleBench |
| --- | --- | --- | --- |
| Kimi K3 | 86.6% | 90.8% | 64.9% |
| GLM 5.2 | 72.5% | 57.2% | 50.0% |
| Qwen 3.8 Max | 93.9% | 95.2% | 64.8% |

---

## 3. Stage table for §7 (four labs only)

| Model | Tokens | Modalities | Optimizer | Context | Precision | SFT | RL | Distillation | Drafter |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| V4-Pro | 33T | text | Muon; AdamW for embed, head, norms, mHC biases | 4K→16K→64K→1M | FP4 QAT, post-training | yes | GRPO per specialist | full-vocab OPD, >10 teachers | MTP, joint |
| V4.1-Flash | 45T | multimodal, 7:1; ViT pretrained, frozen to decay | Muon, head-wise QK; Sinkhorn-balanced for embed, head, Engram; AdamW for rest | 64K→1M at 34T | FP4 KV QAT, post-training | yes | async RL, scalar effort | full-vocab OPD, >40 teachers | DSpark, frozen stage then no backbone gradient |
| GLM-5 | 28.5T | text | Muon Split | 32K, 128K, 200K in mid-training | INT4 QAT in SFT | yes, to 202,752 | sequential three stages | cross-stage, token-level | 3 shared MTP layers |
| GLM-5.2 / 5.3 | gap | text | gap | IndexShare from 128K; 1M training expanded | KV FP8 | gap | critic PPO; anti-hack | >10 experts (5.2); multi-teacher (5.3) | MTP + TV loss |
| MiniMax M3 | gap | multimodal from step 0 | gap | gap | gap | gap | gap | gap | EAGLE-like MTP |
| M3.1-Flash | gap | multimodal | gap | gap | NVFP4 experts, attention paths | gap | gap | gap | DSpark |
| Qwen3.8-2.4T | gap | gap | gap | gap | gap | gap | gap | gap | MTP, multi-step |

---

## 4. Worked examples

### 4.1 The indexer's KL loss and the stop-gradient

**The loss** (MSA eqs. 9–11; Alg. 1). For query $i$ and GQA group $r$, on the selected tokens $\mathcal I^{(r)}_{i,\rm tok}$:

$$
P^{{\rm idx},(r)}_{i,j}=\frac{\exp S^{{\rm idx},(r)}_{i,j}}{\sum_{u}\exp S^{{\rm idx},(r)}_{i,u}},
\qquad
P^{(r)}_{i,j}=\frac1G\sum_{\ell\in\mathcal H_r}\frac{\exp S^{(\ell)}_{i,j}}{\sum_u\exp S^{(\ell)}_{i,u}},
$$

$$
\mathcal L_{\rm KL}=\frac{1}{NH_{kv}}\sum_{i=1}^{N}\sum_{r=1}^{H_{kv}}
D_{\rm KL}\big(\operatorname{stopgrad}(P^{(r)}_{i,\cdot})\,\big\|\,P^{{\rm idx},(r)}_{i,\cdot}\big),
$$

$$
\boldsymbol Q^{\rm idx}=\operatorname{stopgrad}(\boldsymbol X)\boldsymbol W_q^{\rm idx},\qquad
\boldsymbol K^{\rm idx}=\operatorname{stopgrad}(\boldsymbol X)\boldsymbol W_k^{\rm idx},\qquad
\mathcal L=\mathcal L_{\rm LM}+\lambda\sum_{\rm layers}\mathcal L_{\rm KL}.
$$

**The stop-gradient sits in two places.** On the teacher, it keeps the KL from reaching the Main Branch projections. On the index input, it keeps the KL from reaching the backbone through $\boldsymbol X$. "Under this rule, L_KL updates only W_q^idx and W_k^idx". [MSA §3.2] **Confirmed.** DSA states the same split in words. [V3.2 §2.1.1]

**The family resemblance.** All of these minimize forward KL with the main attention as target; all use a softmax of index scores as student. **Confirmed.**

| Method | Dense stage support | Sparse stage support | Stop-gradient stated |
| --- | --- | --- | --- |
| DSA (V3.2 eqs. 3–4) | all visible tokens | selected set | yes, at indexer input |
| MSA | all visible tokens | selected tokens | teacher and input |
| QSA (QNext eqs. 18, 20) | complete blocks, max-pooled teacher | selected blocks, teacher renormalized | not stated |
| D-LSA (eq. 2) | all selectable keys; teacher truncated to top 2,048 | none; no sparse stage | base frozen |
| V4, V4.1 | not disclosed | not disclosed | not disclosed |

DSA's "sum across heads, then L1-normalize" and MSA's and LSA's "mean of head softmaxes" are the same operation when all heads are probability vectors. **Inferred.** In the sparse stage MSA renormalizes each head on the selected set before averaging; DSA does not spell out its order. **Confirmed (MSA); gap (DSA).**

**Why top-$k$ passes no gradient.** MSA says the operation is "non-differentiable" and "the selected block indices are used only as a discrete routing decision. Consequently, the index projections W_q^idx and W_k^idx receive no useful gradient from the language-modelling objective". [§§3.2, B.2] **Confirmed.** The reason, in my words: the scores decide a set of integers, and those integers are all the main attention receives. No score value enters the attention arithmetic. So the loss, as a function of the scores, is a step function, flat almost everywhere and jumping where two scores cross. Its derivative is zero where it exists. **Inferred.**

**Hand-sized illustration** (numbers invented; arithmetic checked). **Inferred.** Four entries, one query, top-2.

Two main heads attend with $(0.7,0.2,0.1,0)$ and $(0.1,0.2,0.6,0.1)$. The target is their mean, $p=(0.40,\,0.20,\,0.35,\,0.05)$. The indexer scores $I=(2,1,0,-1)$, so $q=\operatorname{Softmax}(I)=(0.644,\,0.237,\,0.087,\,0.032)$.

- *Top-2 picks entries 1 and 2.* Entry 3 holds 35% of the attention and is missed.
- *No gradient from the task.* Raise $I_3$ from 0 to 0.1. The set is still {1, 2}, so the attention, the output and the loss are all unchanged. Raise it past 1 and the set jumps.
- *Dense warm-up.* The full KL is $\sum_s p_s\ln(p_s/q_s)=0.285$. Its gradient is $\partial D_{\rm KL}/\partial I_s=q_s-p_s=(+0.244,\,+0.037,\,-0.263,\,-0.018)$. Descent lowers entry 1 and raises entry 3 most. One step of size 1 gives $I=(1.756,\,0.963,\,0.263,\,-0.982)$ and KL 0.167. After about twenty steps $q\approx p$, and top-2 is {1, 3}.
- *Sparse stage, if the indexer were still at the initial scores.* Both distributions are confined to {1, 2}: $p_S=(2/3,\,1/3)$, $q_S=(0.731,\,0.269)$, KL 0.010, gradient $(+0.064,\,-0.064)$. Entry 3 gets no gradient at all.

That last line is why warm-up matters. Restricted to its own picks, the KL can reorder them but cannot see what it missed for this query. It looks nearly satisfied (0.010 against 0.285) while 40% of the attention mass was excluded. Only other queries, for which that key was selected, can correct it. **Inferred.** D-LSA avoids this by keeping Â over all of R_i. [LSA §4.1] **Confirmed.**

*What the stop-gradient prevents, same numbers.* Without it, the KL falls just as well if the main attention moves toward $q$. MSA reports exactly this: "the backbone can lower the KL loss by simplifying the Main Branch attention distribution". The student would be teaching the teacher. **Confirmed (source); Inferred (gloss).**

*Proportions.* Warm-up is small everywhere: 2.1B against 943.7B for DSA; 2.8B then 20B for GLM-5 against 28.5T; 40B of 3T for MSA-PT; 1T of 32T dense for V4-Flash, though that stage trains the whole model. **Confirmed (figures).**

### 4.2 The Sinkhorn step

**The exact step** (mHC eqs. 7–9; V4 eqs. 4, 8):

$$
\tilde B_l=\alpha_l^{\rm res}\operatorname{Mat}(\hat X_lW_l^{\rm res})+S_l^{\rm res},\qquad
M^{(0)}=\exp(\tilde B_l),\qquad
M^{(t)}=\mathcal T_r\big(\mathcal T_c(M^{(t-1)})\big),\qquad
B_l=M^{(t_{\max})},\quad t_{\max}=20,
$$

with $\exp$ elementwise, $\mathcal T_c$ dividing each column by its sum and $\mathcal T_r$ dividing each row by its sum. [Confirmed]

**The released kernel differs slightly.** `hc_split_sinkhorn_kernel` does a row softmax plus ε=10⁻⁶, a column normalization, then 19 rounds of row then column normalization. Its output `comb` ends on a column step, and the residual uses its transpose. [V4.1 `kernel.py` lines 436–458] **Confirmed.** So code order is row-first, the reverse of the papers; the digest's account holds. The kernel is inference code; the training kernel is not public. **Gap.**

**Hand-sized illustration** ($2\times2$, paper order; checked numerically). **Inferred.** Take $\tilde B=\begin{pmatrix}\ln3&0\\0&0\end{pmatrix}$, so $M^{(0)}=\begin{pmatrix}3&1\\1&1\end{pmatrix}$.

- Column sums are 4 and 2: $\mathcal T_c$ gives $\begin{pmatrix}.75&.5\\.25&.5\end{pmatrix}$.
- Row sums are 1.25 and 0.75: $\mathcal T_r$ gives $M^{(1)}=\begin{pmatrix}.600&.400\\.333&.667\end{pmatrix}$, columns 0.933 and 1.067.
- $M^{(2)}=\begin{pmatrix}.632&.368\\.364&.636\end{pmatrix}$, columns 0.995 and 1.005.
- $M^{(3)}=\begin{pmatrix}.634&.366\\.366&.634\end{pmatrix}$, columns 0.9997 and 1.0003.
- At $t=5$ the columns are within $2\times10^{-6}$ of 1.

The limit has a closed form. Scaling rows and columns leaves the cross-ratio $M_{11}M_{22}/(M_{12}M_{21})=3$ unchanged, and a symmetric doubly stochastic $2\times2$ matrix $\begin{pmatrix}a&1-a\\1-a&a\end{pmatrix}$ has cross-ratio $a^2/(1-a)^2$. So $a=\sqrt3/(1+\sqrt3)=0.63397$. The released kernel's order on the same input gives 0.63397 too, with row and column sums $1-10^{-6}$.

*What the projection buys.* Apply each matrix to streams $(2,4)$, total 6. The raw matrix gives $(10,6)$, total 16. Its top eigenvalue is $2+\sqrt2\approx3.41$, so ten layers would amplify by about $2\times10^5$. The projected matrix gives $(2.73,\,3.27)$, total 6, and stays non-expansive through any stack. That is the difference mHC measured: peaks near 3000 in HC against about 1.6.

*The contrast for the essay.* Both constraints sit between a learned score and a hard structure. Sinkhorn is division repeated, so it is smooth, and DeepSeek differentiates through all of it. Top-$k$ is a choice, so it needs a teacher. **Inferred.** With one stream the constraint degenerates to the scalar 1, "thereby recovering the original identity mapping", the ordinary residual. [mHC §4.1] **Confirmed.**

---

## 5. Evidence on training order

### 5.1 The direct test: MSA-PT against MSA-CPT

Same 3T budget, same 109B architecture, matched checkpoints. [§5.3, Table 2] **Confirmed.**

| Benchmark | Full | MSA-PT (sparse throughout) | MSA-CPT (sparse at 2.6T) |
| --- | --- | --- | --- |
| RULER-8K | 79.8 | 84.2 | 77.2 |
| RULER-32K | 75.0 | 77.5 | 75.7 |
| GSM8K | 76.2 | 77.7 | 73.7 |
| HumanEval | 61.0 | 64.0 | 57.9 |
| VisualWebBench | 55.6 | 68.4 | 59.4 |
| EgoSchema | 29.6 | 37.6 | 25.8 |
| WinoGrande | 58.3 | 60.9 | 62.0 |
| TriviaQA | 66.0 | 65.5 | 67.7 |

- "MSA-PT, which learns the sparse pattern throughout pretraining, obtains the strongest results on many math, image, video, and long-context retrieval benchmarks, suggesting that native sparse pretraining can adapt the model representations to the sparse attention pattern."
- "MSA-CPT is more conservative: it preserves much of the Full-Attention checkpoint behavior ... making it a practical conversion route when a trained dense checkpoint is already available."
- Sparse-from-start beating full attention itself is striking and unexplained. The authors do not test whether it replicates; no error bars are given. **Inferred** caution.

### 5.2 When selection enters, across the frontier

| Model | Selection enters | Tokens before / indexer warm-up / joint | Source |
| --- | --- | --- | --- |
| V4.1-Flash | token 0, at 64K | 0 / none / all 45T | V4.1 §§1, 4.2.2 |
| MSA-PT | after warm-up | 0 / 40B / about 3T | MSA §5.1 |
| V4-Flash | at 64K, after 1T dense | 1T / "short stage" / about 31T | V4 §4.2.2 |
| GLM-5.2 | mid-training at 128K | undisclosed | G52 |
| MSA-CPT | late pretraining | 2.6T / 40B / 360B | MSA §5.1 |
| Qwen3.8-Flash-Next | final stage of CPT, at 256K | undisclosed / 2B / 200B | QNext §2.1.2 |
| V3.2 | on a V3.1-Terminus base checkpoint at 128K | base model / 2.1B / 943.7B | V3.2 §2.1.1 |
| GLM-5 | end of mid-training | 28.5T / 2.8B / 20B | GLM5 §2.1.1 |
| K3.1 Pro | after K3's pretraining at the earliest | undisclosed | §6 below |
| D-LSA | on released checkpoints | all / 352M / none | LSA §§3.3, 4.1 |

Every position in the pipeline has been used in production or research, and all report near-parity on their chosen benchmarks. So order is not settled as a hard requirement. The one clean head-to-head (§5.1) favours early. **Inferred.** The two deployment forces pull apart: native sparse trains faster, while late conversion reuses a trained dense checkpoint. **Inferred.**

GLM-5's 20B is 0.07% of its base budget, and GLM says it sufficed. Compare V3.2's 943.7B. GLM attributes no reason to the gap. **Confirmed (figures).**

### 5.3 Other order evidence

- **Early attention sharpens first.** "the attention entropy quickly drops from an initially smooth distribution to a much sharper one, before entering a slower phase of representation learning." [MSA B.4] **Confirmed.** This is a scale-model observation at 10.5B of what §8 calls circuits before facts: routing moves first, in the first few hundred steps. The link to Zucchet is **Inferred**, and Zucchet's plateau is a different measurement.
- **V4.1 sits against the pilot.** MSA's pilot found warm-up helps; V4.1 skips it at 45T "with no instability". The two differ in scale, in V4.1's 128-token window branch, and in CSA2. DeepSeek gives no reason for dropping V4's stage. **Confirmed (facts); reconciliation is a gap.**
- **A later, harder stage improves the earlier skill.** GLM's 200K stage raised performance "even within the 128K context window". [§2.3] **Confirmed.**
- **Early resolution does not carry through.** Higher resolution in contrastive pretraining gives "notable gains" that "contribute little to the final model". [V4.1 §4.2.2] **Confirmed.**
- **A subsystem can wait in a frozen state.** V4.1's ViT is pretrained apart, frozen through peak learning rate, and unfrozen at decay. DSpark is the mirror image: backbone frozen while the drafter learns. So freezing goes both ways. [§§2.4.3, 2.5] **Confirmed.**
- **Deployment constraints enter last.** V4 FP4 QAT, V4.1 FP4 KV and the hierarchical indexer enter in post-training; GLM-5 INT4 QAT enters at SFT. [V4 §5.2.1; V4.1 §§2.3.2, 2.4.4; GLM5 §2.4.3] **Confirmed.** M3.1-Flash's timing is a gap.
- **Sequential RL degrades earlier stages.** GLM-5 orders Reasoning, Agentic, General, then distils to recover: "cumulative degradation of previously acquired capabilities". [§3.5] V4 removes mixed RL for OPD. [§5.1] **Confirmed.**
- **Post-training can reveal what pretraining hid.** Qwen's sparse writes, above. Also: "a cheaper mid-scale probe that reliably predicts post-training ordering would make the design space far more searchable." [QNext §5] **Confirmed.** This pairs with MAI's "decaying the LR less improved post-RL results": two labs tuning pretraining against post-training outcomes. **Inferred.**
- **The indexer is frozen during RL in GLM-5.** [§3.2] **Confirmed.** So after DSA is in, selection stops changing while the policy moves. Whether later GLM versions keep this is a gap.

---

## 6. Adding an indexer to an already-trained model

| Route | Base during indexer training | Indexer tokens | Then joint? | Result |
| --- | --- | --- | --- | --- |
| GLM-4.7-Flash warm-up only | frozen | 1,000 steps × batch 16 | no | RULER −7.86 at 128K, −2.87 at 32K, −1.29 at 64K |
| GLM-4.7-Flash full | frozen, then trained | same | 150B | −0.35 at 128K, above base at 16K–64K |
| V3.2 from V3.1-Terminus | frozen | 2.1B | 943.7B | parity checks only |
| GLM-5 | not stated for GLM-5 itself | 2.8B | 20B | "match the performance of the original MLA model" |
| MSA-CPT | full attention during warm-up; freezing not stated | 40B | 360B, +140B long-context | RULER-128K +0.12, HELMET-128K −0.60 |
| QSA | "only the indexer is trained" | 2B | 200B | average 76.8 against 75.9 |
| D-LSA | frozen | 352M | none | within 5 (Qwen-27B) and 3 (GLM-5.3-Flash) up to 1M |
| D-LSA Training-Free | frozen | 0, PCA | none | close on Qwen-27B, trails on GLM-5.3-Flash |
| K3.1 Pro | **undisclosed** | undisclosed | undisclosed | card scores only |

**K3.1 Pro, concretely.** The card: "Compared with Kimi K3, we replace the full-attention Gated MLA layers with Gated DeepSeek Sparse Attention (Gated DSA) layers". Config: `dsa_config` with 24 `dsa_layers`, `index_topk: 2048`, `index_num_heads: 32`, `index_head_dim: 128`. Parameter index: 497,340 entries against K3's 497,220; the only new names are `self_attn.indexer.{k_norm.bias, k_norm.weight, weights_proj.weight, wk.weight, wq_b.weight}`, five per layer across 24 layers, which is exactly 120. No K3 name is missing. **Confirmed.** Moonshot's blog calls the model "a post-trained version of Kimi K3" and never mentions sparse attention. **Confirmed (absence).** So:

- The outline's "Post-training as the main source of release-to-release change" needs a caveat for K3.1, which also has an architecture change. "Post-trained" here includes installing a selector. **Inferred.**
- It is the first production case I found of selection added to a model released without it, under a new post-training run. Whether training started from K3's base or from post-trained K3 is unknown, as is whether the indexer was added before RL, frozen in RL or trained alongside it. **Gap.**
- GLM froze the indexer in RL for stability. If Moonshot did likewise, the indexer was distilled once against a policy that then moved. **Inferred**, conditional.

**Reading the frozen-model evidence.** A frozen base is not doomed, but the costs differ sharply: GLM-4.7-Flash loses 7.86 at 128K, while D-LSA stays within 5 at 1M. The comparison crosses models and benchmark subsets, so it decides nothing. D-LSA forces 4 sink and 512 window keys, keeps the student on the full key set, selects up to 4,096 keys and adds a temperature. MSA's 4.3-point RULER-32K loss without forced selection points the same way: forced local and sink keys may carry part of the difference. **Inferred**, as a hypothesis only.

**A second route exists that no paper tests for indexers.** OPD moves behaviour through logits, and V4.1 allows teachers that "differ architecturally from one another and from the student". [§5.2.4] So a new-architecture student could inherit a trained policy without inheriting weights. **Inferred.**

**Staged conversion is also possible within post-training.** V4.1 introduces its hierarchical restriction in post-training. [§2.3.2] **Confirmed.**

---

## 7. Outline claims, §§7–10

Kimi, MiMo and MAI claims are not checked here.

### §7

| # | Claim | Verdict |
| --- | --- | --- |
| 7.1 | No single six-stage pipeline is documented for Qwen or MiniMax | **Confirmed.** Stronger: 2.4T's card names only "Pre-training & Post-training". |

### §8

| # | Claim | Verdict |
| --- | --- | --- |
| 8.1 | V4-Pro 33T | **Confirmed.** |
| 8.2 | V4.1-Flash 45T multimodal | **Confirmed.** Add 7:1 text to multimodal. |
| 8.3 | MiniMax multimodal from the start | **Confirmed** for M3. |
| 8.4 | V4.1-Flash is "staged", vision encoder frozen until decay | **Freeze confirmed; classification wrong.** The language backbone sees images from step 0 (card, §2.5). Only the encoder is staged, and it was pretrained separately on 47B pairs plus 236B tokens. V4.1 belongs with "multimodal from the start, pretrained encoder held frozen". The final norm and projector train throughout. |
| 8.5 | Optimizer split: Muon for hidden matrices; AdamW for embeddings, head and router | **Wrong in two parts.** V4: AdamW also covers RMSNorm and mHC biases and gates; the router is unnamed and "All other modules are updated with Muon". V4.1: embeddings and head use the Sinkhorn-balanced update, not AdamW. Add GLM's Muon Split and V4.1's head-wise Muon. |

### §9

| # | Claim | Verdict |
| --- | --- | --- |
| 9.1 | MSA: KL to main attention, stop-gradients, full-attention warm-up | **Confirmed.** |
| 9.2 | V4 dense, then indexer warm-up, then sparse | **Confirmed.** Sparse arrives at 64K, after 1T for Flash. |
| 9.3 | "A selector learns to imitate the attention it replaces" | **Confirmed** for DSA, GLM, MSA, QSA, D-LSA. **Not found** for V4 and V4.1. N-LSA is a counterexample: no separate selector, no teacher. |
| 9.3a | Thesis: indexers "cannot be trained by backpropagation through top-k" | **Confirmed** for a separate indexer (MSA §3.2). N-LSA sidesteps it by selecting with the attention's own keys, at 0.5B. |
| 9.4 | GLM warm-up-only loses 7.9 at 128K; joint training restores | **Confirmed**, with corrections. The model is GLM-4.7-Flash, not GLM-5. 79.21→71.35→78.86, so 0.35 short of base. |
| 9.5 | MSA pilot: divergence without stop-gradient | **Confirmed**, "With larger KL coefficients". Also add the slow regression at stable coefficients. |
| 9.6 | MSA pilot: attention-entropy collapse without warm-up | **Misattributed.** Fig. 10 is measured in "early sparse training", but it has no with-warm-up curve, and entropy is "partially recovering and stabilizing" afterwards. B.4 presents the drop as how attention moves early and as the reason selection is fragile at initialization, not as damage from skipping warm-up. The measured effect of skipping warm-up is lower general and retrieval scores (Fig. 11). Suggested wording: "attention sharpens rapidly in the first few hundred steps, so a selector enabled at step zero chases a moving target; without warm-up, general and retrieval scores are worse". |
| 9.7 | V4.1 trains sparse from scratch at 64K, no dense warm-up, undisclosed indexer loss | **Confirmed.** |
| 9.8 | "That is also why, in MSA's own analysis, it rediscovers attention sinks and local blocks" | **Wrong.** MSA v2 (12 June) cannot and does not analyse V4.1 (17 September). The finding is about MSA's own models (App. A, C.2), and it does not attribute it to warm-up or to skipping warm-up. V4.1's report shows no such analysis. The prompt for this read repeats the error. Move the sink and locality point to MSA, and do not offer a cause. |
| 9.9 | mHC's constraint is a training device as much as architecture; Sinkhorn projection | **Confirmed.** Results are from AdamW at 4K up to 27B. |
| 9.10 | V4's hash routing "removes the routing problem where it is hardest" | **Hash routing confirmed; rationale not found.** V4 gives none. The stated stability measures are Anticipatory Routing and clamping. V4.1 no longer mentions hash routing. |
| 9.11 | V4-Pro context 4K, 16K, 64K, 1M | **Confirmed.** Add V4.1's 64K then 1M at 34T and GLM's 32K, 128K, 200K. |
| 9.12 | "Enlarging the position range does not teach long-range use" | **Not found as stated** in these sources. GLM's data curation supports the spirit. |
| 9.13 | FP4 KV in V4.1-Flash | **Confirmed**, entering in post-training. Omitted: V4's FP4 experts and indexer QK; GLM-5's INT4 in SFT. |
| 9.14 | NVFP4 experts in M3.1-Flash | **Confirmed by config.** The card says only QAT on "routed MoE experts and the attention paths". |
| 9.15 | MTP and DSpark propose tokens the main model verifies | **Confirmed.** |
| 9.16 | "Drafters are trained alongside" | **Partly wrong.** True for MTP. DSpark has a frozen-backbone stage first, then no backbone gradient. |
| 9.17 | GLM-5.2 addresses drafter train/inference mismatch | **Confirmed.** The mechanism is IndexShare on the MTP layer, removing the mixed KV. |
| 9.18 | LSA note: D-LSA by KL to frozen attention; N-LSA with stop-gradients from next-token loss alone | **Confirmed.** Only one stop-gradient, through the selection. |

### §10 and §5

| # | Claim | Verdict |
| --- | --- | --- |
| 10.1 | SFT loss mask decides which tokens teach | **Confirmed** by GLM5 §§3.1, 4.1. |
| 10.2 | Goodfire: common benchmarks, GLM 5.2 57.2% on DeepSWE | **Confirmed.** It is the lowest of three; a reader will assume GLM is the bad case. Use the table. GLM's own blog also says 5.2 hacks more than 5.1. |
| 10.3 | V4-Pro and GLM consolidate specialists by OPD | **Confirmed** for V4 (>10) and GLM-5.2 (>10). **Imprecise for GLM-5:** teachers are earlier-stage checkpoints in a sequential pipeline, for anti-forgetting. V4.1 reaches >40. |
| 10.4 | Specialists are not routed experts | **Confirmed in substance.** V4 calls specialists "experts" and "domain-specific experts", so quotes need a gloss. |
| 10.5 | V4.1-Flash-1017 ("RL with self-feedback") as post-training-driven change | **Quote confirmed, weakly.** Full text: "DeepSeek-V4.1-Flash-1017 uses reinforcement learning with self-feedback to improve end-to-end project development—from game creation to 3D modeling." [news261017] It appears in the note only, not the card, which calls it "a minor update". "Self-feedback" is undefined. That the weights differ only by post-training is **Inferred**. |
| 10.6 | GLM-5.3 as post-training-only | **Confirmed verbatim.** The attribution is the lab's own. |
| 10.7 | K3.1 Pro ("substantially larger post-training compute") | **Quote confirmed.** Omits the architecture change. |
| 5.x | GLM-5.3 reuses GLM-5.2's base | **Confirmed.** |

---

## 8. Other things the outline misses

- **Anticipatory Routing and SwiGLU clamping** (V4 §4.2.3) belong in "Experts must stay balanced". DeepSeek's aim is "breaking the vicious cycle induced by routing": routing lags the backbone by Δt, an order effect at the scale of steps.
- **Non-deterministic top-k broke RL** at GLM. Selection adds a failure mode to RL that is not in the outline: training and rollout must agree on the selection. V4.1 handles expert routing the same way, with concatenated routing replay.
- **V4.1's claim that data, not algorithms, drives post-training** is the sharpest statement for §10.
- **V4.1's OPD admits heterogeneous teachers** from different development stages.
- **Asynchronous RL's staleness handling** answers the retrieval-lineage essay's open question: V4.1 §5.2.2 and GLM-5 §4.1.2 both cover it.
- **Verifier synthesis.** GLM-5.3 and V4.1 §5.1.1 both now build tasks and verifiers with agents. V4.1: "the model is already beginning to exhibit the ability to construct its own training tasks".
- **Rollouts on quantized weights.** V4 samples RL with native FP4, so the policy trained on is the policy deployed.
- **Reward hacking handled in-flight.** GLM-5.2 returns dummy results rather than ending a rollout, because abrupt stops risk "training instability and model collapse".
- **GLM-5.3-Flash** appears in LSA as a sparse model with no explicit positional encoding (z.ai/blog/glm-5.3-flash). Not read here; outside the seven.

---

## 9. Disclosure gaps

- V4 and V4.1: indexer loss, stop-gradient, warm-up length, Pro's dense length. V4.1's reason for dropping warm-up.
- GLM-5.2: base token budget, stage of 1M training, whether the cross-layer indexer loss was used. GLM-5.3: compute, tokens, teacher count.
- MiniMax M3 and M3.1-Flash: all budgets and post-training. The MSA paper's 109B schedule is not stated to be M3's.
- Qwen3.8-2.4T-A95B: everything but two card lines. Its blog was unreadable here.
- K3.1 Pro: how, when and against what the indexers were trained.
- No published ablation measures learned selection at 1M within a jointly trained model. LSA's 10M figures are for frozen distillation.
- V4.1-Flash-1017: what "self-feedback" means.
