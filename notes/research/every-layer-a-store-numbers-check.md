# Numbers check: *Every Layer a Store* (checked 2026-10-28)

Four parallel checks against primary sources: pinned configs and model cards, reference code, arXiv reports and papers, and scans of the classical papers. Line numbers in the sections below refer to the draft as of commit e8a8cfd, before the corrections.

## Outcome

Three claims were wrong, and about twenty were imprecise. All are corrected in the essay except those listed under "Left as is".

**Wrong, corrected:**
- Worked example 1: finite-size transitions sit *higher* than the asymptotic count, not lower (Barnfield et al. §2.4: about 1,830 at d = 128 by their finite-size formula). "More than a factor of ten" became "about a factor of ten".
- LogN scaling *sharpens* the softmax (raises β, lowers the temperature). β is now introduced as the sharpness, not called the temperature.
- "KDA-plus-MLA hybrids appeared beyond Moonshot" in October: inclusionAI had shipped them in August (Ling-3.0-flash, Ling-3.0-tiny). Ling-3.1-flash (13 Oct) is the 560B one. The dossier's "second hybrid after K3" is corrected too.

**Imprecise, corrected:** the opening's "three" models with a 1M context (all seven take about 1M, GLM-5.3 included); V4.1-Flash's decoder also replays the prompt's last 128 tokens; Kohonen–Ruohonen "if and only if"; FFN-as-attention priority (AIAYN v2 appendix before Sukhbaatar); Nichani "up to logarithmic factors"; Allen-Zhu and Li hold "architecture doesn't matter" only at 1,000 exposures; the MoE penalty is 1.5× at 100 exposures; Engram is two modules of hashed tables; four of the seven select, not three; the MiniMax sink analysis is on the 109B research models and the indexer picks the first *block*; Afendulev's single-seed results are for the largest models; DASC's 98% is a weight-based estimate with a 10⁻³ horizon; Li–Sha–Yang (only a permutation preserves all differences); Single-Pass mHC halves traffic only together with the fused kernel; Qwen3.8's gate is elementwise per head; GLM-5.3 shares GLM-5.2's base; V4.1's hierarchical indexer; FP4 only for the global cache; β in [0,1] holds for K3's code and the Transformers implementation used by Qwen3.8; Eitan et al. *prove* the √n bound, for conventional and top-k hybrid blocks alike (the paragraph now opens "Hybrids have a limit of their own"); Olszowiec, six of eight models; Wang's LogN simulations reach two million entries; StepFun's model named (Step-5-Preview).

**Left as is:**
- Shazeer 2017 MoE sat between LSTM layers. The link names the origin of sparsely gated MoE, which is all the sentence needs.
- MLA also caches a small decoupled RoPE key. Too fine for §1.
- Goodfire calls its Qwen model "Qwen3.8 Max" in the text, but its contrast table labels it "Qwen3.8-2.4T", the open checkpoint, so "Qwen3.8" stands.
- Barnfield's constant 8 for the outer-product map is proved sufficient; sharpness is asserted ("one can show"), not proved.
- Step-5-Preview's public release date is unverified: the repo was created 20 Sep and the README updated 13 Oct. The essay no longer dates it.
- K3's extra final MLA layer (69 KDA + 24 MLA is not exactly 3:1) and KDA's short-convolution state are below the essay's level of detail.

---

## Fact-check A: MiMo, Kimi K3, Qwen3.8, MiniMax-M3, StepFun, KDA hybrids

Essay: notes/every-layer-a-store.md. Primary sources fetched 2026-10-28. Configs at pinned SHAs from frontier-model-sources.json (MiMo 73875d0, K3 f831ab6, Qwen 207bd68, M3 f0e1c1e; the current M3 main d95e30c differs only in README badge text).

### WRONG

- **L253 (§5 last para)**: "The October releases spread them further. … KDA-plus-MLA hybrids appeared beyond Moonshot". WRONG on timing. The October instance is inclusionAI **Ling-3.1-flash** (repo created 2026-10-13; README: "Total 560B, Activated 25B", "63 KDA + 9 Gated MLA (7:1)"; config `model_type: bailing_hybrid`, `layer_group_size: 8`). But inclusionAI had already shipped KDA+MLA hybrids in **August**: Ling-3.0-flash (created 2026-08-02; README: "5:1 alternating stacking of Kimi Delta Attention (KDA) and MLA", "35 KDA + 7 Gated MLA", 124B/5.1B) and Ling-3.0-tiny (2026-08-10; "3:1 KDA–MLA", 7.9B/1.3B). The dossier's "second KDA-plus-MLA hybrid after Kimi K3" is also wrong. Sources: https://huggingface.co/inclusionAI/Ling-3.1-flash/raw/main/README.md , https://huggingface.co/inclusionAI/Ling-3.0-flash/raw/main/README.md , https://huggingface.co/inclusionAI/Ling-3.0-tiny/raw/main/README.md . Proposed: "KDA-plus-MLA hybrids, which inclusionAI had adopted in August, reached 560 billion parameters in its Ling-3.1-flash, and Meta replaced the residual sum."

### IMPRECISE

- **L155 (§3 Selection)**: "In MiniMax's own analysis, its indexer selects the first position of the sequence, the "attention sink" …, and the block next to the query, without being told to." Three problems. (1) The analysis is of MiniMax's 109B MSA research models (and a 10B pilot), not of MiniMax-M3 itself (arXiv 2606.13392 §5: "All models use the same 41-layer MoE backbone, with approximately 109B total parameters"; App. A visualizes those). (2) The indexer selects *blocks*: "Even without explicitly forcing the indexer to select the first key-value block, we observe that the learned Index Branch naturally assigns high selection probability to the initial block across all layers and heads." (3) Only the sink is reported as unforced. The local block is forced ("the local block containing i is always selected … during both training and inference"), and the paper says only that heads "place high probability on the local diagonal"; it does not single out the adjacent block. (M3 config agrees: `sparse_init_block: 0`, `sparse_local_block: 1`.) Proposed: "In MiniMax's analysis of its sparse-attention models, the indexer, though never forced to, selects the first block of the sequence, which holds the "attention sink" that many heads use as a default, and concentrates its other choices near the query."

- **L241 (Qwen3.8 portrait)**: "Its attention layers apply a sigmoid gate to their output, head by head." The gate is elementwise, not one scalar per head. transformers `qwen3_5_moe` (the class named in config, `Qwen3_5MoeForCausalLM`; the repo ships no modeling code): `q_proj` outputs `num_attention_heads * head_dim * 2`, split into query and gate of shape heads×head_dim, then `attn_output = attn_output * torch.sigmoid(gate)`. SGLang qwen3_5.py: `fused_sigmoid_mul(attn_output, gate)`. The config's `output_gate_type: "swish"` applies to the Gated DeltaNet output norm (SGLang `RMSNormGated(..., activation=self.output_gate_type)`), not to attention. Source: https://raw.githubusercontent.com/huggingface/transformers/main/src/transformers/models/qwen3_5_moe/modeling_qwen3_5_moe.py (L809). Proposed: "Its attention layers multiply each head's output, channel by channel, by a sigmoid gate computed from the token."

- **L17 (opening)**: "Three of this year's open models accept a prompt that long". Reads as "exactly three", but five of the essay's own seven accept 1M (L247; configs: MiMo `max_position_embeddings: 1048576`, K3 1048576, MiniMax-M3 1048576, DeepSeek-V4-Pro 1048576, V4.1-Flash 1048576), and Qwen3.8 extends to 1,010,000. Proposed: "Most of this year's leading open models accept a prompt that long, and none of them works that way. Take three."

- **L183 (§3)**: "The released code of Kimi K3 and Qwen3.8 does not: the write step stays between 0 and 1." True for K3 (repo `modeling_kimi_linear.py`: `use_beta_sigmoid_in_kernel=True`, no `allow_neg_eigval`). The Qwen3.8 repo ships no code (files: LICENSE, README, config, generation_config, index, tokenizer); the reference implementation is transformers `qwen3_5_moe` (`beta = b.sigmoid()`). Proposed: "The released code of Kimi K3 and the reference implementation that Qwen3.8's checkpoint loads into do not". (Minor.)

### Minor nits (accurate per publisher; optional)

- **L165 / L239**: "three of every four positions"; "three KDA layers for every gated MLA layer". K3 is 23×[KDA,KDA,KDA,MLA] plus one extra final MLA (config `full_attn_layers` 1-indexed = 4,8,…,92,93; report 2607.24653 §2.1: "Each block contains 3 KDA layers followed by 1 Gated MLA layer, giving a 3:1 mixing ratio… An additional Gated MLA layer is placed at the end"). 69/93 = 74%. Fine as written; Qwen is exactly 3:1 (69/23).
- **L21**: "Sixty-nine of them keep no per-token record at all." KDA layers also keep a short-convolution state over the last 3 tokens (`short_conv_kernel_size: 4`). Fixed size, so the point stands.
- **L153 (outside my models, but adjacent)**: "Three of the seven choose which entries to read" (GLM-5.3, V4-Pro, M3). DeepSeek-V4.1-Flash also selects (config `index_topk: 512`, `candidate_topk_blocks: 2048`; essay L249 describes its hierarchical indexer). Looks like four. Check with the DeepSeek checker.

### CONFIRMED

MiMo-V2.6-Pro (config https://huggingface.co/XiaomiMiMo/MiMo-V2.6-Pro-RL/raw/73875d00b30a89ef8cc353a0b60b0e9f9561952d/config.json ; README same rev; arXiv 2610.11959)
- L19, L233, L289: 70 layers; 60 window, 10 global. `num_hidden_layers: 70`; `hybrid_layer_pattern` 60×1, 10×0; README "Layers (Total / SWA / GA) | 70 / 60 / 10".
- L19, L147, L237: window 128. `sliding_window: 128`; report: "The sliding window size W used in MiMo-V2.6 is 128."
- L237: global positions (0, 7, 15, 23, …), irregular. Zeros at [0, 7, 15, 23, 31, 39, 47, 55, 62, 69] (gaps 6–7).
- L233: 1.02T / 42B. README "1.02T total / 42B activated"; safetensors total 1,024,216,603,392 stored elements.
- L233: 8 / 384. `n_routed_experts: 384`, `num_experts_per_tok: 8`; README "384 / 8", "without shared experts".
- L247: 1M. README "Context Length: 1M tokens"; `max_position_embeddings: 1048576`.

Kimi K3 (config https://huggingface.co/moonshotai/Kimi-K3/raw/f831ab66814297da540d832a5235f8e904f29d06/config.json ; README, modeling_kimi_linear.py same rev; arXiv 2607.24653)
- L21, L39, L234: 93 layers, 69 KDA + 24 gated MLA. `num_hidden_layers: 93`; `kda_layers` 69 entries, `full_attn_layers` 24; README "69 KDA + 24 Gated MLA". "Gated": `mla_use_output_gate: true`, code `g = self.g_proj(hidden_states).sigmoid()`.
- L54, L239: MLA uses no positional encoding. `mla_use_nope: true`; code `assert self.use_nope`, `self.rotary_emb = None`; report: "Kimi K3 uses no explicit positional embedding (NoPE), and instead encodes positional information implicitly through the recurrent gating and decay mechanism of KDA."
- L57, L234: 2.8T / 104B. README "Total Parameters 2.8T", "Activated Parameters 104B".
- L234: 16 / 896 plus 2 shared. `num_experts: 896`, `num_experts_per_token: 16`, `num_shared_experts: 2`.
- L239: Stable LatentMoE, experts in narrower latent space. README "Stable LatentMoE framework that activates 16 out of 896 experts"; "Latent MoE Dimension 3584" vs hidden 7168; report: "specialized routed experts operate in a compact latent space of width ℓ" (shared experts stay full width).
- L234, L239: AttnRes. `attn_res_block_size: 12`; README "built on Kimi Delta Attention (KDA) and Attention Residuals (AttnRes)". (It is Block AttnRes.)
- L171: per-channel decay. Code: `f_b_proj` → `projection_size` (heads×head_dim); report: "KDA applies channel-wise decay … αt ∈ (0, 1)^dk is the channel-wise one-step retention factor, and βt ∈ (0, 1)".
- L171, L175, L183: β in (0,1); decay bounded. `use_beta_sigmoid_in_kernel=True`; `gate_lower_bound: -5.0` → FLA `g = lower_bound * sigmoid(...)`, so retention in (e^-5, 1).
- L247: 1M. README "1-million-token context window"; `max_position_embeddings: 1048576`.
- L179: Kimi Linear as Moonshot's smaller relative. K3's text model is `KimiLinearForCausalLM` in `modeling_kimi_linear.py`; Kimi Linear (arXiv 2510.26692) is Moonshot's 48B KDA+MLA model.

Qwen3.8-2.4T-A95B (config/README https://huggingface.co/Qwen/Qwen3.8-2.4T-A95B/raw/207bd685a7e3696cfaff12ded7c6a7ea0f88c996/)
- L235: 92 layers; 69 Gated DeltaNet + 23 gated attention. `layer_types` 69 linear_attention + 23 full_attention (at 3,7,…,91); README "23 × (3 × (Gated DeltaNet → MoE) → 1 × (Gated Attention → MoE))"; `attn_output_gate: true`.
- L235: 2.4T / 95B. README "2.4T in total and 95B activated".
- L235: 10 / 512 plus 1 shared. README "Number of Experts: 512", "10 Routed + 1 Shared".
- L247: extends to about 1M. README "262,144 natively and extensible up to 1,010,000 tokens."
- L241: text-only counterpart of Qwen3.8-Max, which reads images. README: "Qwen3.8-Max is the official version based on Qwen3.8-2.4T-A95B with more features, such as vision input & non-thinking support, 1M context length by default"; "Qwen3.8-2.4T-A95B is a text-only model".
- L171: GDN decay one number per head and token. transformers: `g = -self.A_log.float().exp() * F.softplus(a.float() + self.dt_bias)`, `A_log` and `dt_bias` of size `num_v_heads`.
- L171, L183: β in (0,1). `beta = b.sigmoid()`.

MiniMax-M3 / M3.1-Flash (config https://huggingface.co/MiniMaxAI/MiniMax-M3/raw/f0e1c1e04d40177e4673a22097036854f536e9c0/config.json ; M3.1-Flash main config + README; arXiv 2606.13392)
- L238: about 428B / 23B. README "~428B parameters and ~23B activated parameters"; safetensors 427,040,140,160.
- L238, L251: 60 layers, 3 full + 57 block-sparse, full layers at the start. `num_hidden_layers: 60`; `sparse_attention_freq` zeros at [0, 1, 2]; M3.1-Flash README: "the first three full-attention layers are replaced with sparse attention".
- L238: 4 / 128 plus 1 shared. `num_local_experts: 128`, `num_experts_per_tok: 4`, `n_shared_experts: 1`. (Layers 0–2 have dense FFNs, `moe_layer_freq` zeros at [0,1,2].)
- L147, L153: blocks of 128; 16 blocks = 2,048 positions per KV group; four groups; includes query's block. `sparse_block_size: 128`, `sparse_topk_blocks: 16`, `num_key_value_heads: 4` (64 query heads), `sparse_local_block: 1`; paper: "keep k = 16 key-value blocks per query and GQA group", "16 × 128 = 2,048", "the local block is always included regardless of its score".
- L251: M3.1-Flash same size, all 60 layers sparse, October. README "Approximately 428B total; 23B activated per token", "MSA throughout the model"; config `sparse_attention_freq` 60×1; repo created 2026-10-17.

Other
- L57: "All seven models are MoE models." MiMo 384 experts; K3 896; Qwen 512; GLM-5.3 `n_routed_experts: 256`, top-8, 1 shared, 78 layers; DeepSeek-V4-Pro 384, top-6, 1 shared, 61 layers; V4.1-Flash 384, top-6, 1 shared; MiniMax-M3 128.
- L253: "the global layers of StepFun's window design" got selection. StepFun **Step-5-Preview** (README "600B total parameters · 27B active parameters · Up to 1M context"). Config: 92 text layers (plus 3 MTP in `layer_types`), 69 `sliding_attention` + 23 `full_attention` (3,7,…,91), `sliding_window: 512`; `sparse_config`: `"compression_method": "csa_block_compress"`, `"topk": 512`, `"apply_to_layer_types": ["full_attention"]`. Source: https://huggingface.co/stepfun-ai/Step-5-Preview/raw/main/config.json . Date UNVERIFIED as October public release: repo created 2026-09-20 (weights uploaded that day, possibly private); README updated 2026-10-13; NVFP4 repo created 2026-10-14. Note the selection is over compressed (CSA-style) entries, so the design combines selection with compression.

---

## Fact-check B: DeepSeek-V4-Pro, V4.1-Flash, mHC, GLM-5.3, Muse Spark Open, Kimi K3 AttnRes

Essay: notes/every-layer-a-store.md. Sources fetched 2026-10-28 at the manifest's pinned revisions:
- V4-Pro `b5968e9…` config.json, inference/model.py, inference/kernel.py, README.md
- V4.1-Flash `2cba9e4…` config.json, inference/config.json, inference/model.py, README.md
- GLM-5.3 `aca966e…` config.json, README.md
- Kimi-K3 `f831ab6…` config.json, modeling_kimi_linear.py
- arXiv HTML: 2606.19348 (V4), 2609.19969 (V4.1), 2512.24880 (mHC), 2602.15763 (GLM-5), 2607.24653 (K3), abstracts of 2603.15031 and 2601.07372
- https://huggingface.co/blog/meta-muse-spark-open

### WRONG / IMPRECISE

1. **L241**: "MiMo, Kimi K3, both DeepSeek models and MiniMax-M3 accept a million tokens". **IMPRECISE (omission).** GLM-5.3 also accepts 1M tokens. Its config has `"max_position_embeddings": 1048576`, and the card evaluates NL2Repo "under 1M context" and PostTrainBench/SWE-Marathon with "a 1M-token context window" (https://huggingface.co/zai-org/GLM-5.3/blob/aca966e4e02791568aa6a4ced368624b3d897f42/README.md). Fix: "MiMo, Kimi K3, GLM-5.3, both DeepSeek models and MiniMax-M3 accept a million tokens, and Qwen3.8 extends to about the same."

2. **L17**: "Three of this year's open models accept a prompt that long". **IMPRECISE.** Read literally, it says only three do, but at least six of the seven do (see item 1, and the essay's own L241). Fix: "Several of this year's open models accept a prompt that long. Take three; none of them works that way."

3. **L23**: "only the tokens the model generates pass through all 40 layers". **IMPRECISE.** The last n_win = 128 prompt tokens are also run through the decoder to rebuild its sliding-window caches. V4.1 report §2.2: "we introduce Decoder SWA Bounded Replay, which only prefills the last n_win tokens of the prompt for the SWA computation" (https://arxiv.org/html/2609.19969). Fix: "only the prompt's last 128 tokens and the tokens the model generates pass through all 40 layers."

4. **L131** (also L291, "Engram's table"): "Engram, a 196-billion-parameter table looked up by short sequences of tokens". **IMPRECISE.** The 196B is split over two modules, and each module has many hashed tables. V4.1 report §2.4.2: "We allocate 196B Engram parameters evenly across two modules. Each module uses N-gram orders {2,3,4}, with 8 hash heads … Each head indexes a table of approximately 16M entries … placed at layers 1 and 14". Config: `"engram_layer_ids": [1, 14]`. Fix: "Engram, 196 billion parameters of lookup tables in two layers, addressed by hashes of the last two to four tokens." At L291: "Engram's tables".

5. **L251**: "Its model card names GLM-5.2 as its base". **IMPRECISE.** The card says the two models share a base model. It does not say GLM-5.2 is the base. Card L13: "GLM-5.3 uses the same base model as GLM-5.2 — every gain comes from post-training." Fix: "Its model card says it shares GLM-5.2's base model and that every gain comes from post-training."

6. **L255**: "the first decoder layer picks up to 16,384 candidate positions, and every fourth layer after it chooses 512 within them". **IMPRECISE (minor).** The first decoder layer also chooses its own 512, from the full context, and layers 21–23 reuse that choice. V4.1 report Fig. 5: "The decoder's first CSA2 layer in Full mode selects its own Top-512 indices and builds a shared candidate pool … CSA2 layers in Reindex mode then select their Top-512 indices from this pool." Config: `candidate_topk_blocks: 2048`, `candidate_block_size: 8`, `index_source_layers: [2, 8, 14, 20, 24, 28, 32, 36]`, `index_topk: 512`. Fix: "the first decoder layer chooses its own 512 positions and also a pool of up to 16,384 candidates, and every fourth layer after it chooses a fresh 512 within that pool."

7. **L211**: "That lets the hardware read each tile of the streams once instead of twice, halving the memory traffic of the original implementation." **IMPRECISE (minor).** The halving needs the fused Mega-mHC kernel together with the shift. With the fused kernel, the shift alone cuts traffic from (3n+2)d to (2n+2)d, which is 14d to 10d at n = 4. Report §2.4.1: the original four-kernel version costs "(4n+4)d"; "The kernel implements mHC with (3n+2)d … and Single-Pass mHC with (2n+2)d … halving the activation memory traffic of our original implementation." Fix: "That lets a single fused kernel read each tile of the streams once, and with it the memory traffic is half that of the original implementation."

8. **L255**: "4-bit cache entries". **IMPRECISE (minor).** Only the global (main) KV is 4-bit. The window cache stays FP8. Report §2.4.4: "We retain FP8 for the SWA KV cache due to its sensitivity to quantization." Fix: "4-bit global cache entries".

### CONFIRMED

- **L23, L238, L255, CED.** "projected from the encoder's final states". Report §2.2: KV for l > L/2 "projected directly from the hidden state of the (L/2)-th layer". Card: "decoder's global KV cache is projected from the final encoder hidden states". "Most of the prompt passes only through the encoder": report: "allowing most prompt tokens to bypass full decoder computation".
- **L238 / L255, V4.1-Flash.** 40 layers = 20 + 20 (`n_layers: 40`; card: "20-layer causal encoder followed by a 20-layer decoder"). 552B + 196B Engram, 8B prefill / 16B decode (report §2.1: "552B backbone parameters and 196B Engram parameters, activating 8B parameters per token during prefill and 16B during decode"). 6/384 + 1 shared (`n_activated_experts: 6`, `n_routed_experts: 384`, `n_shared_experts: 1`). 1M context (`max_position_embeddings: 1048576`).
- **L255, encoder caches.** Three caches at compression 2, each shared by six layers: `compress_ratios` gives 0 for layers 0–1 (SWA only: "except for the first two layers, which use SWA only"), 2 for layers 2–19, and 1 for layers 20–39; `kv_source_layers: [2, 8, 14, 20]`. The decoder cache is uncompressed, computed by layer 20 and read by layers 20–39 (report §2.3.1: "the decoder layer assigned to Full Mode computes its own global KV from the hidden state of the (L/2)-th layer").
- **L149.** 890 bytes of global cache per token. Card: "reduce the global KV cache footprint to **890 bytes per token**".
- **L211, Single-Pass mHC.** Equation: "X_{l+1}=B_l X_l + C_l F_l(A_{l-1} X_l)". "Empirically, this shift incurs negligible performance degradation." Used in pretraining: "For pre-training, we keep the existing multi-kernel implementation, since the shift only changes which mixing coefficients each block applies" (the shifted rule is implied).
- **L131.** Engram citation: arXiv 2601.07372 is "Conditional Memory via Scalable Lookup …" (Engram). Report: "Engram lookup indices depend solely on the input token sequence."
- **L237 / L253, V4-Pro.** `num_hidden_layers: 61`. 1.6T/49B and 1M (card). 6/384 + 1 shared. `compress_ratios` = [128,128, then 4/128 alternating ×59, then 0 for MTP]. V4 report §4.2.1: "For the first two layers, we use HCA. For the subsequent layers, CSA and HCA are used in an interleaved manner." Window 128 in all layers (`sliding_window: 128`; "supplementary attention branch to both CSA and HCA"). `hc_mult: 4`.
- **L131.** Hash routing in the first three layers: `num_hash_layers: 3`; code `indices = self.tid2eid[input_ids]`; report: "Hash routing strategy determines the target experts of each token according to a predefined hash function with regard to the input token ID … for the first 3 MoE layers".
- **L147 / L159, CSA and HCA.** Softmax over 8 tokens per channel, 512 channels (`head_dim: 512`; Compressor `wkv` width 2×head_dim, `kv * score.softmax(dim=2)` over 2m = 8 positions). Overlap by 4 tokens at stride 4 (`self.overlap = compress_ratio == 4`). One vector is both K and V, shared by 128 heads (`num_key_value_heads: 1`, `num_attention_heads: 128`, single `wkv`). Top-1024 (`index_topk: 1024`). 128-token window in the same softmax (`topk_idxs = cat([window, compress])` → one `sparse_attn` call). HCA: 128 tokens per entry, no overlap, no indexer (`indexer = Indexer(...) if compress_ratio == 4 else None`).
- **L147, worked example 2.** 1,000,000/4 = 250,000. 1,000,000/128 = 7,812.5, which matches "about 7,800". L149: the indexer scores all compressed candidates (`index_score.topk(min(index_topk, end_pos // ratio))` over all of them).
- **L199–205, mHC.** Equation form matches V4 eq. 1 and mHC eq. 7–8 (mHC: H_res, H_post^T, H_pre). The coefficients are input-dependent: mHC "dynamic mappings" plus static biases; code `mixes = F.linear(x, hc_fn) * rsqrt`. t_max = 20 (mHC §4.2: "We choose t_max = 20"; `hc_sinkhorn_iters: 20`).
- **L207, "rows … exactly, columns only approximately".** CONFIRMED for the essay's B_l, with streams as rows of X_l. The mHC paper iterates M^(t) = T_r(T_c(M^(t-1))), so it ends on a row normalization of H_res, and x_{l+1} = H_res x_l. The kernel (`hc_split_sinkhorn`, kernel.py L401–423) runs a row softmax, then a column normalization, then 19 more row-then-column rounds, so it ends on a column normalization of `comb`. `hc_post` computes y_k = Σ_j comb[j,k] x_j, so B = comb^T, and the rows of B sum to 1. "Exactly" means up to ε = 1e-6, since each normalization divides by sum + ε. Rows exact means each new stream is a convex mix; conservation needs column sums, which are approximate. So "the conservation is approximate" is right.
- **L153 / L236 / L251, GLM-5.3.** `num_hidden_layers: 78`. MLA-style cache (`kv_lora_rank: 512`, `qk_rope_head_dim: 64`). DSA (`architectures: GlmMoeDsaForCausalLM`), `index_topk: 2048`. IndexShare: `indexer_types` = F,F, then (F,s,s,s)×19, which is groups of four starting at layer 2; layers 0–1 index on their own. 8/256 + 1 shared (`num_experts_per_tok: 8`, `n_routed_experts: 256`, `n_shared_experts: 1`).
- **L236 / L241, GLM parameters "not reconciled".** Defensible. GLM-5 report Table 10 gives 744B / 40B, captioned "we include the parameters of MTP layers but not word embeddings and the output layer". My count from the config gives about 742B for the 78 layers, about 1.9B for embedding + head, and about 9.9B for one MTP layer. Hub total: 753.33B. So 744B fits "backbone + embeddings, no MTP", not the caption's rule; the report's own text also says "layer count to 80". If the author wants a number: the Hub total is about 753B including MTP and embeddings, and the first-party figure is 744B/40B (GLM-5 report).
- **L225 / L259, Muse Spark Open.** Blog "Published October 15, 2026": "Each block combines its input and its output through a learned residual gate, not through a plain sum."
- **L215–221, AttnRes in K3.** `attn_res_block_size: 12`, `num_hidden_layers: 93`. Code (modeling_kimi_linear.py `_forward_attn_residual`): at layer_idx % 12 == 0 the running sum is appended (layer 0 appends the embedding), so the candidates are embedding + completed block sums + the current partial sum. At layer 92 there are 8 stored entries (embedding + 7 blocks: 0–11 … 72–83) plus the partial sum over 84–91, which makes 9 sources. Weights: `k = RMSnorm(v)`, `scores = (k * norm.weight * proj.weight).sum(-1)`, `softmax`, i.e. a learned query against normalized candidates. Note: each layer has two such queries, one before attention and one before the MLP, plus one at the output. "for layer l" is acceptable. The AttnRes abstract: "Block AttnRes, which partitions layers into blocks". The K3 report also uses "blocks" ("Block AttnRes", "AttnRes blocks"), so "(The AttnRes paper calls these groups blocks.)" is true but understates it.
- **L291.** "four caches: three compressed ones shared within the encoder, and one uncompressed one". Confirmed for the global caches. The fourth is written by decoder layer 20's projection of the encoder output, so "the encoder … wrote" is loose but acceptable. Every layer also keeps its own window cache.

---

## Fact-check: every-layer-a-store.md §1, §2, line 191


### WRONG

**L121** "They are asymptotic, and at this size the measured transitions sit somewhat lower." — WRONG (direction).
Barnfield et al. 2605.05189 §2.4, the only measurements: the transition for the best (cross-entropy-learned) map at d = 300–1200 sits at load c = n log n/d² ≈ 0.70–0.85, against the asymptotic 1/2. So at finite d the map holds *more* pairs than the asymptotic count. Quote: "we find that ĉ(d) lies above 1/2 and drifts only slowly toward it as d increases… the simulations exhibit a substantial finite-size correction." Their Conjecture 1 (fitted slope −2.97 vs predicted −3) gives d² = n(2 log n − 3 log log n). At d = 128 that is n ≈ 1,830, not 1,160. They report no measurement for the outer-product map.
Knock-on: the closing "a logarithm that here costs more than a factor of ten" holds for the asymptotic figure (16,384/1,160 ≈ 14). With the finite-size estimate it is ≈ 9 (16,384/1,830).
Proposed: "They are asymptotic. In Barnfield and colleagues' simulations the best map's transition comes later at finite size: their finite-size formula gives about 1,800 at d = 128. Either way, 'order d²' hides a logarithm that here costs close to a factor of ten."

**L191** "One remedy raises the temperature with the logarithm of the context length" — WRONG (inverted).
LogN scaling multiplies the logits by a factor ≥ 1, which raises β (the inverse temperature) and so *lowers* the temperature. Qwen report 2309.16609 §3: "LogN-Scaling rescales the dot product of the query and value by a factor that depends on the ratio of the context length to the training length, ensuring that the entropy of the attention value remains stable". Wang: "we can increase β as the number of key-value pairs increases… Qwen LogN-Scaling: beta = 8 max(1, log M / log 1024)".
Proposed: "One remedy sharpens the softmax, scaling the logits by the logarithm of the context length".

### IMPRECISE

**L111 / L115 / L191** β is called "temperature" ("With the usual temperature, β=d^{1/2}"; "the temperature is suitable"; "finite at a fixed temperature"). β multiplies the logits, so it is the *inverse* temperature (Wang calls it "sharpness"). L115 and the L191 "fixed temperature" are harmless. L111 is a misnomer that sets up the L191 inversion.
Proposed L111: "With the usual sharpness, β=d^{1/2}," or "inverse temperature".

**L97** "Sukhbaatar and colleagues replaced a Transformer's feed-forward layers with attention over a set of learned key–value pairs and kept the model's performance." — IMPRECISE (priority and mechanism).
(a) *Attention Is All You Need* v2/v3 (arXiv 1706.03762v2, appendix) already did exactly this: "we experimented with replacing the position-wise feed-forward networks with attention layers… the 'keys' and 'values' inputs to each attention head are trainable model parameters". The results were "slightly worse" in one experiment and "slightly better" in the other (BLEU 25.5 / 25.9 vs 25.8). The passage is gone from later versions. Wang notes this.
(b) Sukhbaatar 1907.01470 did not use a separate attention over learned pairs. They added persistent vectors to the context keys and values inside one self-attention layer: "we augment the self-attention layers with persistent memory vectors that play a similar role as the feed-forward layer. Thanks to these vectors, we can remove the feed-forward layer without degrading the performance".
Proposed: "A version of *Attention Is All You Need* already replaced the feed-forward layers with attention over learned key–value pairs, at about the same translation quality. Sukhbaatar and colleagues later folded such learned pairs into self-attention itself and dropped the feed-forward layer without loss."

**L123** "Measured per parameter, stores hold about the same amount whatever their nonlinearity" — IMPRECISE.
Allen-Zhu & Li 2404.05405 compare architectures, not nonlinearities as such: GPT2 with a GELU MLP, LLaMA/Mistral with a gated SiLU MLP, and models with no MLP. The claim holds at 1000 exposures. Result 5: "In the 1000-exposure setting, architectures do not matter much… eliminating all MLP layers does not affect its capacity ratio". It fails at 100 exposures. Result 6: "LLaMA architecture's capacity ratio can be 1.3x worse than GPT2… Removing MLPs decreases the capacity ratio by more than 1.5x". Result 7: "Using gated MLP reduces the model's capacity ratio". Abstract: "GatedMLP doesn't affect frequently encountered knowledge (with 1000 exposures) but does impact moderately rare knowledge (with 100 exposures)."
The 2-bit and 1-bit figures are CONFIRMED: "Result 4: With 100 exposures… falls to 1bit/param"; Fig. 1 shows "peak R(F) ≥ 2 (resp. ≥ 1)".
Proposed: "Measured per parameter, architectures differ less than these counts suggest. … about 2 bits of knowledge per parameter when each fact has been seen about a thousand times, with or without a gated or any MLP, and about 1 bit when it has been seen a hundred times, where gated MLPs stored 1.3 times less."

**L127** "a model with 32 experts stored 1.3 times less knowledge per parameter than a dense model, even when each token went to a single expert and used 8.8 percent of the parameters" — IMPRECISE (half the result).
Result 9: "in the 1000-exposure settings, the peak capacity ratio decreases by 1.3x; and in the 100-exposure settings… by 1.5x". Remark 9.1: "holds even in the 'sparsest' setting where topk = 1 and cap factor = 2". The 8.8% figure is CONFIRMED (11.3× ratio).
Proposed: add "(1.5 times when each fact was seen only a hundred times)".

**L119** "Nichani, Lee and Bietti proved … on the order of d² answers, up to a logarithmic factor." — IMPRECISE.
Their Theorem 1 needs "d² ≳ N poly log N". The proof uses log⁴ (Barnfield: "Nichani et al. [2024, Theorem 1] proved that CMM succeeds… when d² ≥ Cn(log n)⁴").
Proposed: "up to logarithmic factors".
Barnfield constants: CONFIRMED. "the critical value of d²/(n log n) is 2" holds for any linear map, both ways. For the outer-product map, Proposition 1 proves "lim inf d²/(n log n) > 8 ⟹ success", and the authors add "one can show that this is unimprovable for CMM". "Sharp" is therefore asserted but not proved in the paper. Acceptable.

**L191** "In Wang's simulations with random competitors, this keeps recall nearly perfect at any length." — IMPRECISE (minor).
The simulations run to about 2 million memories; Wang extrapolates. Quote: "Qwen's rule and Su's rule… the interference-to-signal ratio falls as the store grows, to about 0.004 at 2 million memories… scaling β with log M allows for essentially an unbounded number of memories". Table: "not reached in our experiments, more than 2 million".
Proposed: "at every length he tried, up to two million".
"Qwen's LogN scaling is an early instance" — Qwen itself credits "Chiang & Cholak, 2022; Su, 2023a", and Wang cites Su (2021). "an early instance" is defensible, but "a widely used instance" is safer.

**L83** "That map recalls every stored value exactly if and only if the keys are linearly independent" — IMPRECISE (minor).
Kohonen & Ruohonen 1973 abstract: "If the number of pairs does not exceed the dimension of the cue and all cue vectors are linearly independent, then the recollections are perfect replicas… and there will be no crosstalk". They also write "if the columns of Q are linearly independent, the recollections are perfect". The paper states "if" only. "Only if" holds only for arbitrary values: dependent keys can still be recalled exactly if the values obey the same dependency.
Proposed: "recalls every stored value exactly whenever the keys are linearly independent" (or "for any values, exactly when…").

**L57** MoE link to 1701.06538 — IMPRECISE (minor).
Shazeer et al.'s MoE "is applied convolutionally between stacked LSTM layers"; it did not replace a Transformer feed-forward network. That came with GShard and Switch. The general description is fine; the link names the origin of sparsely gated MoE. Optional fix: none needed, or "introduced for LSTMs".

**L55** MLA "stores a compressed latent from which keys and values are reconstructed" — IMPRECISE (minor).
DeepSeek-V2 2405.04434 §2.1.3: "During inference, the decoupled key should also be cached. Therefore, DeepSeek-V2 requires a total KV cache containing (d_c + d_h^R) l elements." So a small decoupled RoPE key is cached beside the latent. Fine to leave as is at this level of detail.

### CONFIRMED

- L29 post-LN, additive positions. 1706.03762 §3.1: "LayerNorm(x + Sublayer(x))"; §3.5: "we add 'positional encodings' to the input embeddings at the bottoms of the encoder and decoder stacks".
- L37 NTM heads. 1410.5401: "reads to and writes from a memory matrix via a set of parallel read and write heads"; "attentional 'focus' mechanism". AIAYN only says "h = 8 parallel attention layers, or heads", with no explanation (checked v7 and v2).
- L52 RMSNorm drops re-centering (1910.07467). L53 SwiGLU = Swish(xW) ⊗ (xV) (2002.05202). L54 RoPE. L55 GQA. L55 MLA "compressed latent vector for keys and values" (2405.04434; see minor note above).
- L65 Wang building on Zhong. Wang: "Zhong et al. which inspired the interference-to-signal ratio estimates here". 2505.19488 is "Understanding Transformer from the Perspective of Associative Memory" (ByteDance Seed).
- L81 Wang: "each similarity k_iᵀk_j is about ±1/√d_k… add up like a random walk… ‖interference‖/‖signal‖ ~ √(M/d_k). Setting this ratio to 1 gives a capacity of M ≈ d_k".
- L85 Wang: least squares "recalls with no interference at all" for M ≤ d_k (linearly independent keys); ratio √(M/d_k − 1) "equals 1 at M = 2d_k".
- L95 Wang. "ReLU: zeroing the negative similarities shrinks the interference by √2, so the capacity grows to M ≈ 2d_k". "Squared ReLU: … M ≈ 2d_k²/3 ≈ 2700". "A squared ReLU MLP is a GLU MLP whose gate and input projection share weights"; tied-gate SwiGLU "capacity nearly matches the squared ReLU's". ReLU^p: "capacity is about M ≈ d_k^p".
- L111 Wang: "M ≈ e^{2β(1−β/d_k)}… With β = √d_k = 8, the capacity is about e^{14} ≈ 1.2 million" (e^14 = 1,202,604).
- L97 Geva 2012.14913. "a 16-layer" model (Baevski & Auli); "the vast majority of retrieved prefixes (65%-80%) were associated with at least one identified pattern"; "lower layers (layers 1-9) are dominated by shallow patterns, often with prefixes that share the last word… upper layers (layers 10-16) are characterized by more semantic patterns". The annotators were NLP graduate students.
- L83 Kohonen 1972 (scan): orthogonal keys → output "directly proportional to x(r)"; "The nonorthogonality of key vectors gives rise to crosstalk". Anderson 1972: "(S/N)o would drop off rapidly as K became very large". Neither gives a capacity threshold (agrees with the lead file; texts skimmed). K&R 1973: pseudo-inverse, "best approximation… in the sense of least squares".
- L83 Widrow & Hoff 1960 (OCR of Stanford scan): "method of steepest descent… requires an extremely small sample size per iteration cycle, namely one pattern"; "the derivatives are simply related to the measured error".
- L99 Hopfield 1982 (PNAS PDF). "About 0.15 N states can be simultaneously remembered before error in recall is severe"; simulations "for N = 30 and N = 100"; "For n = 15 [N = 100], about half of the nominally remembered states evolved to stable states with less than 5 errors, but the rest evolved to states quite different"; "half the memories being well retained at n = 0.15 N and the rest badly retained". (The original capitalises "About"; harmless.)
- L99 AGS 1985 (scan): "For α > α_c = 0.138, there is no solution with m≠0"; "at α=α_c, where m=0.967, implying a 1.5% error".
- L99 McEliece 1987 (paywalled; secondary: Demircigil 1702.01929 §1): "can store M = C N/log N patterns with C < 1/2, if we require that a fixed (but arbitrary) pattern is stable, and C < 1/4 if we ask for stability of all patterns simultaneously".
- L99 Gardner 2N; perceptron rules reach it (Mézard 1989 J. Phys. A 22, p. 2182–3): "Gardner (1987, 1988)… one can compute the capacity of the best possible network"; "For the spherical model… the capacity is equal to 2N… good algorithms can reach the limit of optimality (Rosenblatt 1962, Minsky and Papert 1969, Gardner et al 1987, …)". "Hebb does not" follows from AGS 0.138N. Note: 2N assumes continuous (spherical) couplings, unbiased patterns, zero stability margin.
- L101 Krotov & Hopfield 1606.01164: "K_max = α_n N^{n−1}… threshold 0.5%… n = 2 … gives the well known result K = 0.14N". p = n−1 is consistent with Wang's ReLU^p (K–H's update weights overlaps by F′ ∝ x^{n−1}).
- L101 Demircigil 1702.01929: F(x)=eˣ, "M = exp(αN)+1" with "0 < α < log(2)/2"; Remark 1.4: "all the patterns are fixed points… we can even take α < I(1)/2" (= log 2 / 2). So up to just under 2^{N/2}.
- L101 Ramsauer 2008.02217: "modern Hopfield network with continuous states… update rule… equivalent to the attention mechanism".
- L115 Kanerva RIACS TR 92.10: "M = 1,000,000"; "(e.g., N = U = 1,000)"; write "w is stored in each of the locations activated by x"; read "contents are accumulated… This pooling constitutes a majority rule"; "Doubling the hardware doubles the number of words… whereas the capacity of the Hopfield net is limited by the word size"; "the number of stored words should be from 1 to 5 percent of memory size (the number of hard locations)".
- L115 Bricken & Pehlevan 2111.05498: "Attention closely approximates the SDM update rule when it uses L2 normed continuous vectors and a correctly chosen β".
- L115 Bricken et al. 2303.11934 (SDMLP: Top-K, L2-norm, non-negativity, learned addresses). Fig. 23: "SDM Neurons are specialized… the entropy of each neuron (the distribution of data classes that the neuron is activated by)"; "more specialized, interpretable neurons".
- L119 Barnfield (see the note under L119 above).
- L121 arithmetic: n ln n = 8192 gives n = 1,161; n ln n = 2048 gives n = 350. CONFIRMED (the "lower" sentence is WRONG, above).
- L127 8.8% and top-1: CONFIRMED (see note above).
- L133 Schmidhuber 1992 (secondary: Schlag et al. 2102.11174): "FWPs from the early '90s… program the 'fast weights' of another net through… additive outer products of self-invented activation patterns", citing Neural Computation 4(1):131–139, 1992. Katharopoulos 2006.16236: "Transformers are RNNs". Schlag: "storing more than d_dot associations will result in a retrieval error"; delta rule "to correct the current mapping from keys to values".
- L191 Qwen LogN-Scaling in 2309.16609 §3: present (quoted above).

---

## Fact-check: every-layer-a-store.md, §3 (163-191), §4 (193-227), §6 (261-287)


### WRONG / IMPRECISE

**L283 — "in eight small looped models most answer tokens are decided at the first iteration"** — IMPRECISE.
2610.18127: "In six out of the eight models, 76-89% of the generated tokens already settle on their final top-1 token in the first iteration." Exceptions: "LoopUS has reached a decision only 33% of the time at iteration 1 but 96% ... by iteration 2"; "Huginn is the only model that decides gradually: 33% at iteration 1 and 90% only by iteration 8-11 of 16." (Models at "the 1-3.5B scale".)
Fix: "in six of eight small looped models, most answer tokens are decided at the first iteration".

**L209 — "every difference between the streams shrinks at each layer unless the matrix is a permutation"** — IMPRECISE (too strong for general doubly stochastic matrices).
2610.06653 abstract: difference channel "which each layer contracts by its second singular value σ2 ≤ 1 − n min_ij H_ij ... among nonnegative mixers only the permutations do not collapse." "Collapse-free" = ‖Ax‖=‖x‖ for all x ⊥ 1 (Prop. 3.4). A block-diagonal non-permutation (e.g. identity on two streams, averaging on the other two) preserves some differences; σ2<1 strictly holds for mHC's strictly positive Sinkhorn outputs (Thm 3.2(d): σ2 ≤ 1 − e^{−4M}). Also: the paper notes Guo et al. (2026) observed the decomposition and one-layer contraction concurrently; "our new content is the rate".
Fix: "Its average channel is an ordinary residual update, and the differences between the streams contract at every layer; only a permutation preserves them all, as Li, Sha and Yang show." (Mean-channel claim CONFIRMED: "on which mHC is exactly a residual network".)

**L185 — K3: "channels that keep their contents for long with channels that forget them within 64 tokens"** — IMPRECISE.
2608.30386 §3.3: "at a 64-token cutoff, the corresponding fraction is 98.3% for Kimi-K3" (layer–head pairs containing both retained and omitted channels). Horizon = ln ε / g_s with ε = 10^-3, computed from weights with a fixed representative gate input (a_s = 0.8), not measured per input. "Retained" means horizon > 64 tokens, not necessarily long; median K3 channel one-step α = 0.942 (≈115-token horizon to 10^-3).
Fix: "In Kimi K3, by an estimate from the weights, 98 percent of recurrent heads mix channels that fade to a thousandth within 64 tokens with channels that last longer."

**L183 — "the largest results came from a single run"** — IMPRECISE (ambiguous; reads as "the largest effects").
2609.04434 Table 2: Qwen3.5-4B, 9B, Falcon-H1-3B/7B rows are "means over 3 seeds with 95% hierarchical bootstrap CIs"; "‡ Single-seed extension (seed 42 only)" = Qwen3.5-27B, Falcon-H1-34B; "∗ Additional architectures; point estimates only" = Kimi-Linear-48B, Olmo-Hybrid-7B, Jamba2-3B. The quoted 89/0, 70/1, 49/14 numbers are 3-seed means.
Fix: "the results for the largest models came from a single seed, and those for Kimi Linear are point estimates." (Also: "The models were small" — tested up to Qwen3.5-27B, Falcon-H1-34B, Kimi-Linear-48B-A3B; small relative to the seven, so acceptable.)

**L281 — Eitan, Yehudai, Maron "argue that hybrid layers with top-k access ... need capacity growing as the square root of the domain size"** — IMPRECISE (minor).
2610.25250 abstract: "We first establish that both conventional hybrid blocks and those with top-κ KV-cache access require Ω(√n) capacity to compute even two-function composition over a domain of size n." It is a proved lower bound, per single hybrid block, and it covers conventional hybrid blocks too. Remedy: MuRA multi-hop retrieval ("a single fixed size m-hop MuRA block can compute m-function composition").
Fix: "prove that a hybrid block, with or without top-k access to the cache, needs capacity of at least the square root of the domain size to compose two lookups, unless it repeats retrieval within the block."

**L285 — "activations of Kimi K3, GLM-5.2 and Qwen3.8"** — IMPRECISE (naming, minor).
2609.19101: "Kimi K3 (Team et al., 2026), GLM 5.2 (Zeng et al., 2026), and Qwen3.8 Max (Qwen Team, 2026)" (a contrast table labels it "Qwen3.8-2.4T"). Fix: "Qwen3.8-Max" or "the 2.4T Qwen3.8".

### CONFIRMED

**L167-171 — delta rule = gradient step on ‖Sk−v‖²/2; decay before write; GDN one scalar per head/token; KDA per channel.** CONFIRMED.
∇_S ½‖Sk−v‖² = (Sk−v)kᵀ, so S − β(Sk−v)kᵀ is the stated update. 2412.06464: "S_t = S_{t−1}(α_t(I − β_t k_t k_tᵀ)) + β_t v_t k_tᵀ", "α_t ∈ (0, 1) is a data-dependent scalar-valued decay term" (prediction uses the decayed state = decay before write; Worked Example 3 consistent); β_t ∈ (0,1). 2510.26692: "While GDN ... employs a coarse head-wise forget gate, KDA introduces a channel-wise variant"; "β_t = Sigmoid(...) ∈ [0, 1]".

**L175 — "Repeated writes approach the least-squares store."** CONFIRMED with caveat (standard LMS/Kaczmarz theory, not from a cited paper): exact convergence to the LS solution needs a consistent system or diminishing β; with fixed β and more pairs than dimensions it hovers near it; decay tilts it toward recent writes. "Approach" covers this.

**L175 — gates bounded.** Partly CONFIRMED: K3 decay uses a "bounded safe gate ... ℓ = −5 is Kimi-K3's safe-gate lower bound" (2608.30386 eq. 2), i.e. α ≥ e^-5 ≈ 0.007 ("near-erasure"). β ∈ (0,1) for GDN/KDA in the original papers. Released K3/Qwen3.8 code not checked (UNVERIFIED; see L279).

**L181 — Lee et al. 2609.33093.** CONFIRMED. "the hybrid Qwen3.5-4B and Qwen3.5-9B"; key–value associations in WikiText context, donor/recipient pairs differing in the target value; "The same separation holds across the three Qwen3.5-4B conditions (retrieval, latest-value, and integration), with 0.2–3.6% recovered by recurrent interventions versus 96–100% by KV interventions". Recurrent replacement includes the conv "local cache". Checkpoint is Qwen3.5-4B-Base.

**L183 — Afendulev et al. 2609.04434.** CONFIRMED numbers. Table 1 Qwen3.5-4B (REC / KV): KV retrieve 0.00 / 0.89; Lang. follow 0.70 / 0.01; Persona 0.49 / 0.14. State-swap: "the answer takes its value from the KV side and its language from the recurrent side" (Qwen3.5-4B both-correct 1.00). Kimi-Linear-48B (point estimates): KV retrieve REC 0.00 / KV 0.94; Lang 0.77 / 0.00; Persona 0.80 / 0.14; swap both-correct 1.00 / 0.98. OOD caveat matches their Limitations ("partly out-of-distribution combination ... State-swap addresses this concern"). Second model in main text is Falcon-H1-3B (Mamba), not mentioned in essay — fine.

**L187 — dictionaries 15–30 entries; recall via state fails even in minimal versions; 128-dim state.** CONFIRMED. 2609.04434 App.: "KV retrieve. A dictionary with 15–30 entries"; "The collapse persists in minimal versions of the task (short dictionaries, short lists), ruling out a state-too-small explanation". Qwen3.5-4B dk = dv = 128 (2609.33093 App. A table).

**L185 — GateSight 2610.14754.** CONFIRMED; model is Qwen3.8-27B ("Qwen3.8-27B, our main model, has 64 layers: 48 are GDN layers"). "Across heads the median is about 24 tokens" (half-life ln 0.5/ḡ); "the ordering of the 2,304 heads by half-life agrees at Spearman 0.99 to 0.997"; "The weights alone predict this ordering: ... Spearman 0.942".

**L209 — Zhao et al. 2609.05309.** CONFIRMED. 43-layer DeepSeek-V4-Flash; "a typical attention or FFN site effectively uses about two of the four streams" (load-effective counts read 1.998, write 1.775). Late = layers 22–42, early = 0–21 (boundary after layer 21; dossier correct). "Replacing the mixers in layers 22–42 by exact identity maps increases C4 perplexity by only 1.9%"; "applying the same replacement to layers 0–21 raises perplexity by 41.4%"; "Fixing each early mixer to its C4 diagnostic mean raises perplexity by only 0.2%". (Style note: "the mixing matters, at 41.4 percent" — say "replacing it raised perplexity by 41.4 percent".)

**L225 — González-Martínez et al. 2610.18809.** CONFIRMED. "For AttnRes, this memory stream is a growing cache of explicit layer representations. For mHC, it is an expanded residual stream." "we refer to it as an explicit depth mixer" (AttnRes); mHC "has a fixed size ... We thus refer to it as an implicit" depth mixer; "the layer output is written to the expanded residual stream through an outer product update."

**L279 — Merrill, Petty, Sabharwal 2404.08819.** CONFIRMED. Log-precision assumption; "Diagonal SSMs are in TC0" (Thm 4.4; also non-gated SSMs, Thm 4.2); Mamba's S6 transition is diagonal; NC1-hard state tracking excluded "assum[ing] the widely held conjecture TC0 ≠ NC1". (Transformers-in-TC0 is restated from Merrill & Sabharwal 2023.)

**L279 — GDN transition α_t(I − β_t k_t k_tᵀ).** CONFIRMED (2412.06464, above).

**L279 — Olmo Hybrid 2604.03444 and Complex KDA 2609.24797 widen gate ranges.** CONFIRMED.
Olmo Hybrid: "each GDN head uses GDN ... extended with negative eigenvalues (Grazzi et al., 2025)": S_t = S_{t−1} α_t (I − 2β_t k_t k_tᵀ) + v_t k_tᵀ, β_t ∈ (0,1), so the write step is in (0,2); "in contrast to the GDN architecture used by Qwen-3-Next ..., Kimi Linear ..., and Qwen 3.5". (Construction is Grazzi et al.'s, adopted by Olmo Hybrid.)
CKDA: "extending the parameter ranges of KDA by combining two existing range extensions: allowing gates in [−1, 1] and the delta-rule coefficient β in [0, 2]".

**L279 — "released code of Kimi K3 and Qwen3.8 ... write step stays between 0 and 1."** UNVERIFIED (code not inspected). Indirect support: Olmo Hybrid says Qwen3.5/Qwen3-Next/Kimi Linear lack the extension; DASC gives K3's bounded decay gate.

**L285 — Goodfire / Bergen et al. 2609.19101 (v2).** CONFIRMED.
Probes are difference-of-means vectors; monitor gets "the entire transcript of the agent's interactions with its environment in context". "For Kimi K3, at matched FPR to the monitor, probes catch 3.0 and 33.1 percentage points more hacks on DeepSWE and ImpossibleBench respectively, and miss only 6.6 points more on SWEBench." OR: "with only a 1% absolute increase in FPR, adding the probe to the monitor increases TPR from 41.1% to 80.2% on DeepSWE for Kimi K3." Resampling (Fig. 10, read from layout positions): Kimi K3 28.6% probe-selected vs 1.1% matched controls; GLM 5.2 14.1% vs 1.5%. "Every catch shown also visible in text": all shown judge-miss examples (Fig. 12) are verbalized CoT deliberations — consistent (essay's interpretation). Note the abstract's "7.9% fewer hacks in GLM 5.2 on DeepSWE" is a different figure from the essay's "missed 7 more" (K3 SWEBench, 6.6) — essay uses the right one.

---

