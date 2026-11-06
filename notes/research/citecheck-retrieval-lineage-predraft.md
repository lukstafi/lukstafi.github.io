# Pre-draft research: retrieval lineage outline (6 Nov 2026)

For `retrieval-attention-lineage-essay-outline.md`. Date from `date`: Fri 6 Nov 2026. Items covered by `citecheck-retrieval-lineage-2026-11-03.md` are not redone.

Sources: arXiv PDFs converted with `pdftotext`, the arXiv API (abstract search), the GitHub and Hugging Face APIs, PubMed eutils, and project READMEs and configs. Quotes are verbatim from those copies, with line breaks and PDF hyphenation joined. Search limits are at the end.

## What the outline needs to change

Most important first.

1. **§9's novelty note is out of date.** The problem has been stated, for KV caches under continually updated weights, in CacheReforge (arXiv 2609.30884, 25 Sep 2026). Earlier statements exist outside language models. All four remedies have precedents. Remedy 3 ("Speculative; say so") is not speculative as a general idea. See B.
2. **§6's latency caveat is wrong as written.** The table measures the read as flat, not as growing. See C3.
3. **LSA is at v2 (3 Nov).** No number changed. New citations bear on §5 and §8. See A1.
4. **Memorilla has public code.** The outline's "no code repository was found" is wrong. See A3.
5. **10M is not the largest scale.** LSA's own Table 1 lists 16M accuracy for HSA-UltraLong. Memory Sparse Attention (Evermind/Shanda, March) reports 100M, and it keeps a persistent latent store, which complicates "2026 ends with two ways". See A4.
6. **The third placement is no longer only hypothetical.** Several 2026 papers write context or experience into weights at deployment. See A4.
7. **Three small quote errors in the thesis and §6.** The first two are LSA quotes that are not verbatim; the third is Memorilla capitalization. See C5.
8. **"Tie the memory to one model" does not criticize the lineage directly,** and PV4's "combining" failures are partly built into the benchmark. See C3.

## A. Freshness

### A1. LSA

**arXiv: v2 exists.** v1 30 Oct 2026, v2 3 Nov 2026, 12:37 UTC. A word-level diff of the two PDFs shows no changed numbers. The only numeric differences are the date and the new bibliography entries. Changes:

- "All keys of the selected blocks are sent to the attention" became "... are attended to" (same for clusters).
- "distilled from a pre-trained model" now reads "distilled from a pre-trained model (Schmidhuber, 1992b)", the history-compression paper. The paper now ties its own indexer distillation to 1992, which helps §5's teacher-student reading.
- Gated DeltaNet layers are now "a form of linear attention (Schmidhuber, 1992a; Schlag et al., 2021)". 1992a is *Learning to control fast-weight memories*; Schlag et al. is *Linear transformers are secretly fast weight programmers*. This bears on §8's fast-weights paragraph: the LSA authors now draw that link themselves.
- Acknowledgements gain "thank Tri Dao for his valuable feedback and support".

The outline's reading (scratchpad `lsa/lsa.txt`) is v1. Its statement that the bibliography cites none of Memorizing Transformers, kNN-LM, Landmark, Focused Transformer, Hopfield or Whittington still holds for v2 (grep of the v2 text).

**Repository** (`Prefrontal-AI/latent-sparse-attention`, Apache-2.0): 417 stars, 47 forks, last push 4 Nov. Commit dates differ from the outline's picture: repo created 27 Oct, "Initial release" commit 2 Nov, then newcomer and reproducibility fixes on 3–4 Nov (PRs #2–#6). Open issues: #7, a third-party audit of v1; #8–#9, internal cleanups; #10, a request for `qwen38_flash_next`. The fork `Prefrontal-AI/sglang` has 3 stars and a last push on 2 Nov. The README says "LSA is an SGLang plugin" that "runs in the serving image of our SGLang fork".

Issue #7 is worth one look. It asks why accuracy runs give Qwen k = 4,096 and GLM k = 2,048. The paper does state this: on GLM, "D-LSA (Flat) selects k = 2048 long-range keys for queries before position 1M and k = 4096 beyond". The outline's numbers are unaffected. The issue also points out that the headline figures pair each model with a different baseline, which the outline already handles by giving both.

**Adoption: none upstream or in any first-party model.**

- vLLM and SGLang upstream: title searches for LSA or "latent sparse" return 0 items. Body searches return DSA and MLA work only.
- No model card from a model lab uses it. Kimi K3.1 Pro uses DSA (A2).
- Community work moved quickly, within a week:
  - Merged ports: `syv-ai/HyperQwen` #431 (vLLM fork, opt-in D-LSA flat on Qwen3.8-27B, 3 Nov), `Oaklight/sglang-restomod` #182 (SM70 serving path, 4 Nov), `JonathanBerhe/mini-infer` #92 (5 Nov).
  - Hugging Face tag `latent-sparse-attention`: `ChiTako/llm-jp-4.1-8b-thinking-lsa`, which adds LSA indexers to a Japanese 8B model without changing its weights, and four `qwegnai` packs for an Apple Silicon runtime, whose card reports prefill held "near 850 tok/s from 64K to 1M tokens".

Suggested wording: "No model lab has adopted it yet; within a week hobbyist ports reached a vLLM fork, an SGLang fork and an Apple Silicon runtime." These are community claims, not checked.

### A2. Kimi K3.1 Pro

**Weights are out.** `moonshotai/Kimi-K3.1-Pro`: repo created 2 Nov, head 5 Nov (`encoding_k3.py` only), 18,432 downloads. Secondary sources date the public release to 4 Nov. `training-freshness-2026-11-06.md` already covers the release in depth.

**Config.** `model_type` is `kimi_k31` and the text config is `kimi_linear`, 93 layers. `dsa_config`:
- `dsa_layers` = 4, 8, …, 92, 93 (24 layers), which are the same 24 positions as `full_attn_layers`.
- `index_topk` 2048, `index_head_dim` 128, `index_num_heads` 32, `index_k_norm_type` layernorm, `index_topk_freq` 1, `index_skip_topk_offset` 1.
- `max_position_embeddings` 1,048,576. `kv_lora_rank` 512.

Card: "69 KDA + 24 Gated DSA", and "Compared with Kimi K3, we replace the full-attention Gated MLA layers with Gated DeepSeek Sparse Attention (Gated DSA) layers for more efficient long-context modeling." There is no LSA and no clustering or tree field.

**Bearing on the essay.** Small. It confirms *Every Layer a Store* §5 ("the 24 attention layers ... selects 2,048 of them") and closes that pending check. It adds one point to §3: a 3T-class open model moved to learned selection, but with a scan-every-key indexer at 1M, the kind LSA says dominates cost at 10M. That is the frontier one step behind LSA, not a sign of its adoption.

### A3. Memorilla

- **arXiv:** still v3 (v1 15 Oct, v2 27 Oct, v3 3 Nov).
- **Code exists.** `memory.stanford.edu` links [snap-stanford/memorilla](https://github.com/snap-stanford/memorilla): Apache-2.0, 133 stars, 15 forks, last push 6 Nov ("update README"), repo created 23 Jun. Hugging Face org `memorilla`: checkpoint `memorilla/Memorilla-Qwen3-8B` and dataset `memorilla/PersonalizationV4`. Fix the outline's line 211.
- The site also links two OpenReview forum IDs. I did not establish the venue, so don't state one.

### A4. Papers bearing on the thesis

All read at least to the abstract. Those marked * were read in the relevant passages too.

**Sparse attention at or beyond the outline's scale**

- **Memory Sparse Attention*** (Chen et al., Evermind / Shanda Group / Peking, [2603.23516](https://arxiv.org/abs/2603.23516), March, v2 13 Apr). The closest existing thing to "LSA's exactness joined to Memorilla's persistence", though lossy by mean pooling.
  - "Stage 1: Global Memory Encoding (Offline). This stage is a one-time, offline pre-computation over the entire document corpus." K, V and routing keys "are partitioned into chunks and compressed via mean pooling" and "cached in the memory bank. This stage converts the raw text corpus into a structured, retrievable latent store."
  - It reports "less than 9% degradation when scaling from 16K to 100M tokens", on MS MARCO, with a 4B model, by selecting top-k documents.
  - The store is written by the model's own forward pass, so it is exactly the store §9's staleness threatens. LSA does not cite it.
  - **Name collision:** "MSA" means MiniMax Sparse Attention in *Filling the Stores* and in ZHA. Spell it out.
- **HSA-UltraLong** (Hu et al. 2026b): LSA's Table 1 lists accuracy at 16M and performance at 256K. I read only that table entry and the bibliography title ("Every token counts: Generalizing 16M ultra-long context ..."). Check before using it. LSA's own 100M figure is an extrapolation: "at 100M tokens it is predicted to be more than 90× faster than baseline sparse attention".
- **Zyphra Hierarchical Attention (ZHA)*** ([2610.42112](https://arxiv.org/abs/2610.42112), 30 Oct, the same day as LSA; v2 2 Nov). A tree of summarized keys, short KL distillation (a billion tokens), claims "the potential to extend effective context windows to the hundreds of millions or billions of tokens". That is a performance model: the paper says "we only investigated data up to 256K context". A same-day sibling of LSA, and neither cites the other.
- **Recursive Sparse Attention (RecSA)*** ([2611.07232](https://arxiv.org/abs/2611.07232), 4 Nov). The newest in the line, and it does not cite LSA or ZHA. "the summaries of unselected candidates share one softmax with the exact tokens", so a read mixes exact keys with gist-like summaries inside attention. RULER 60.5 at 1M. Tested to 2M. It distills from dense attention and trains at 32K.
- **Stratified Sparse Attention** ([2610.28441](https://arxiv.org/abs/2610.28441), 20 Oct) samples the residual attention mass with inclusion-probability correction. Not the "SSA" (Mao et al.) in LSA's list.

**The name "LSA".** Three papers use it: Latent, LongCat, and Lookahead Sparse Attention (FlashMemory-DeepSeek-V4, [2606.09079](https://arxiv.org/abs/2606.09079)). The outline's plan to spell it out should cover the third too.

**Selection cannot compose** (bears on §6's "combining, not finding")

- **MuRA** (Eitan, Yehudai & Maron, [2610.25250](https://arxiv.org/abs/2610.25250), abstract only): hybrid blocks with top-κ KV access "require Ω(√n) capacity to compute even two-function composition", and an m-hop retrieval block computes m-function composition. A theoretical partner to PV4's finding: a single read cannot do the combining. Worth a clause in §6.

**Persistent stores and trained readers**

- **RPMem*** (Zhao et al., [2609.23466](https://arxiv.org/abs/2609.23466), 20 Sep). "compiles each session into a model-independent latent memory", integrated by a recurrent gate, then "mapped to backbone-specific low-rank adaptation (LoRA) parameters". At deployment "all modules are frozen", and "Backbone replacement preserves the accumulated memory". The closest paper to Memorilla's counter-move, and it delivers through weights instead of tokens. It bears on thesis point 6 too.
- **Survey:** *Learning to Remember* ([2610.35089](https://arxiv.org/abs/2610.35089), 26 Oct) splits nonparametric from parametric memory. Possibly useful for orientation.

**Consolidation from a context or KV store into weights**

The outline's "the lineage never built the third placement" still holds, since these are not in the lineage. But "Suppose the third placement is added" (§9) and "the model itself still learns nothing" (closing) now need a qualifier: other groups are building it.

- **PatchKV*** (Lee et al., [2609.39329](https://arxiv.org/abs/2609.39329), v3 4 Nov). The nearest to a literal cache-to-weights write. A "context-specific weight patch" is "computed once at context-loading time" in closed form by ridge regression, aligned to full-cache activations, and merged into the weights, so that a compressed cache can stand in for the full one. Per-context, not lasting. Also see B.
- **Dennis et al.** ([2605.24657](https://arxiv.org/abs/2605.24657), May). Nightly LoRA consolidation on one consumer GPU: consolidation retains 80.4% of knowledge against 36.8% for three cycles of cascading compaction (n = 10 conversations). "Persistent personalization requires moving beyond inference-only deployment". Small study. It favours weights over compaction, not over context: full context scores 90.1%, above consolidation. So it fits §7 twice: compaction is costly, and consolidated facts trail facts in context.
- **SCoL** (Wang et al., [2605.07076](https://arxiv.org/abs/2605.07076), May). "writing current context into model weights while limiting interference".
- **ASCENT** ([2610.05303](https://arxiv.org/abs/2610.05303), 4 Oct). Self-distills verified trajectories into "persistent LoRA fast weights", "without a separate training phase or memory retrieval".
- **Baseten** ([post](https://labs.baseten.co/articles/towards-infinite-context-windows-neural-kv-cache-compaction), Apr 2026). A proposed hypernetwork from compressed KV cache to LoRA, which the post calls its most speculative piece. WebFetch summary, not read directly.

**On the word "place".** *Positions Are Not Facts: The Mismatch Between KV Caches and Memory* (Zhou et al., [2609.33759](https://arxiv.org/abs/2609.33759), 27 Sep; abstract only) asks how to update a cached fact. Its title states the outline's "by position" problem from the other side.

## B. Prior art for §9

### Verdict

**Do not call the problem new.** It has been stated for KV caches under continual adapter updates, with measurements, about six weeks before this check. In replay, with stored model states and an older network, it has been stated since 2019. The essay should credit precedent.

**What I did not find anywhere, and what the essay can present as its own reading:**

1. The off-policy reading of KV-cache staleness, including the disanalogy that a stale key has no importance ratio. arXiv abstract search for "KV cache" with "off-policy" returned only papers on rollout memory.
2. The extension to a fixed content index: bucket staleness under weight updates. CacheReforge has no sparse index. Our inference, not stated anywhere: D-LSA's projections are distilled from a frozen teacher, so an update stales the index space as well as the keys, while the training-free PCA variant can be refit cheaply.
3. The claim that consolidation and an indexed context interfere as a structural matter, read as the two ways out of the context store.

Suggested wording: "This problem has been named. CacheReforge shows that when an adapter updates, stale KV caches can erase most of what the update gained, and replay and contrastive learning met the same thing years ago. What the off-policy reading adds is why it resists the usual correction: a stale key has no ratio."

### Closest statements

**Deployment-time KV caches**

- **CacheReforge** (Cao, Mu, Fang & Chen, Nanjing, [2609.30884](https://arxiv.org/abs/2609.30884) v1, 25 Sep 2026). The closest. It says of serving systems: "These systems assume consistent model parameters across cache creation and reuse, but adapter evolution breaks this assumption." Abstract: "As lightweight adapters evolve, cached states reflect earlier versions, so stale reuse distorts current model outputs". RQ1: "Output divergence and losses in task quality generally increase with the version gap, and stale reuse can erase most gains from adaptation." Related work: existing cache systems "generally assume fixed model parameters and do not address invalidation caused by adapter evolution." Scope: Qwen2.5-1.5B and 7B, rank-8 LoRA, 4K and 16K workloads. "recomputing only 5.44% of layers" and "reduces mean KL divergence by 92.4% relative to stale reuse". Adapters over a frozen base, not full weight updates; no off-policy framing; no index.
- **KV-Cache Patching** (Loos & Eberle, [2610.41480](https://arxiv.org/abs/2610.41480), 30 Oct). Evidence that a cache carries the behaviour of the weights that wrote it: "patching the KV cache can indeed transfer them from the fine-tuned to the base model", and "patching the KV cache from base to fine-tune can partially or fully remove fine-tuned behavior". The strongest evidence for §9's "The two ways out of the context store interfere": a stale cache can undo a consolidation.
- **PReCache** (Jeon, Ha & Kim, [2609.34054](https://arxiv.org/abs/2609.34054) v2). The multi-agent version: "naively reusing KV caches generated under different adapter weights causes substantial accuracy degradation".
- **Serving practice.** The outline's sentence holds. vLLM's prefix-caching docs list "Other values required to make this block unique, such as LoRA IDs" in the block hash, and say nothing on model updates or invalidation (WebFetch summary). CacheReforge says the same of the field: validity is judged "from token and context identity or stable adapter identities".

**Language-model memory, in training**

- **LongMem** (Wang, Dong, Cheng, Liu, Yan, Gao & Wei, UCSB and Microsoft, [2306.07174](https://arxiv.org/abs/2306.07174), Jun 2023). It reads Memorizing Transformers exactly as §9 does and is the precedent for remedy 4: "MemTRM faces the memory staleness challenge during training due to its coupled memory design, which uses a single model for encoding memory and fusing memory for language modeling. In other words, as the model parameters are updated, cached older representations in memory may have distributional shifts from those from the latest model". Its fix: "the original backbone LLM frozen as a memory encoder and an adaptive residual side-network as a memory retriever and reader", which "effectively resolves the issue of memory staleness". Memorilla names LongMem among the methods that "tie the memory to one model". So LongMem took remedy 4 three years before Memorilla, while its store remains in the frozen model's own KV space.

**Replay in RL**

- **R2D2** (Kapturowski et al., ICLR 2019; quotes from the review PDF on OpenReview, so compare with the final version before printing). The closest off-policy precedent, because replay is off-policy and the object is a stored model state, not a sample. Abstract: "We study the effects of parameter lag resulting in representational drift and recurrent state staleness". On storing states: "it may suffer from the effect of 'representational drift' leading to 'recurrent state staleness', as the stored recurrent state generated by a sufficiently old network could differ significantly from a typical state produced by a more recent version." Its remedy is "Burn-in", "using a portion of the replay sequence only for unrolling the network and producing a start state", which is partial re-encoding. This also means the outline's distinction has a name in the literature: *representational drift*.
- **MuZero Reanalyse** (Schrittwieser et al., [2104.06294](https://arxiv.org/abs/2104.06294)): computes "new improved training targets on existing data points". A parallel for re-encoding, with targets instead of keys. Optional.

**Contrastive memory banks, in training**

- **Wu et al. 2018** ([1805.01978](https://arxiv.org/abs/1805.01978)). **Correction to the brief:** this paper does not discuss inconsistent keys from older encoders. It stores features "at previous iteration" (§3.3), and its concern is that "the learning process oscillates a lot from random sampling fluctuation". Its fix is a proximal term that "encourage[s] the smoothness of the training dynamics". The inconsistency reading comes from MoCo. Credit Wu for the memory bank and MoCo for naming the problem.
- **MoCo** (He et al., [1911.05722](https://arxiv.org/abs/1911.05722)), §3.2.
  - "the keys in the dictionary should be represented by the same or similar encoder so that their comparisons to the query are consistent" (§1).
  - Memory bank: "the representation of a sample in the memory bank was updated when it was last seen, so the sampled keys are essentially about the encoders at multiple different steps all over the past epoch and thus are less consistent." (The PDF's text flow splits this sentence around Algorithm 1.)
  - Queue: "its encoded keys are the most outdated and thus the least consistent with the newest ones."
  - Copying the query encoder fails: "We hypothesize that such failure is caused by the rapidly changing encoder that reduces the key representations' consistency."
- **XBM** (Wang, Zhang, Huang & Scott, [1912.06798](https://arxiv.org/abs/1912.06798)). Memorizing Transformers §3.2 cites this one directly: "Similar observations have been made for CrossBatch memory (Wang et al., 2020c) in the vision domain." So the bridge from vision is in the paper the essay opens with. "we identify a 'slow drift' phenomena by observing that the embedding features drift exceptionally slow even as the model parameters are updating throughout the training process."

**Deployed embeddings**

- **BCT** (Shen, Xiong, Xia & Soatto, [2003.11942](https://arxiv.org/abs/2003.11942)). "backward-compatible training". Names the cost: "computing new features for all previously seen images when updating the embedding models, a process known as backfilling."
- **Hu, Bansal, Cao, Rao, Subbian & Leskovec** ([2206.03040](https://arxiv.org/abs/2206.03040), KDD 2022). "as the embedding model gets updated and retrained to improve performance on the intended task, the newly-generated embeddings are no longer compatible with the existing consumer models." Leskovec is Memorilla's senior author, which makes a good aside: he has worked on this problem before.
- **GNNAutoScale** (Fey, Lenssen, Weichert & Leskovec, [2106.05609](https://arxiv.org/abs/2106.05609)). "approximation errors induced by historical information are solely caused by the staleness of the history and the Lipschitz continuity of the learned function". Bounds the error instead of removing it, which is a formal version of "tolerate".
- **Vector databases.** Practice is to record the embedding model per row and backfill. The sources found are vendor FAQs and blogs (Zilliz, Twig), so cite Drift-Adapter instead.

### The remedies with their precedents

| Remedy in the outline | Precedent | Note |
|---|---|---|
| 1. Re-encode | BCT's "backfilling"; R2D2's burn-in (partial); CacheReforge's bounded recomputation (partial); Contiguity paper's edit-local repair ([2609.17983](https://arxiv.org/abs/2609.17983), for edits, not weights) | Add the partial form: you need not re-encode everything. Scale of the full form: LSA's Table 3 gives 4,582 s to first token for Qwen at 10M at baseline, so 9.21× still leaves about 500 s (our arithmetic). |
| 2. Tolerate | Memorizing Transformers' normalization; XBM's slow drift; GNNAutoScale's bound | XBM adds a useful fact: drift can be slow after the early phase of training. |
| 3. Learn a map | Iscen et al. ([2004.00713](https://arxiv.org/abs/2004.00713)); SDC (Yu et al., [2004.00440](https://arxiv.org/abs/2004.00440)); Drift-Adapter ([2509.23471](https://arxiv.org/abs/2509.23471)); Hu et al.; Heo et al. ([2608.03893](https://arxiv.org/abs/2608.03893)); SwaT ([2610.15095](https://arxiv.org/abs/2610.15095)) | **Not speculative as a family.** Untested for one model's weight update over a KV cache, which is the only part to mark speculative. |
| 4. Keys the model did not compute | LongMem (frozen backbone); PReCache's ReBaseShared; RPMem; Memorilla | Earliest for language models found: LongMem, 2023. |

Remedy 3 in detail:

- Iscen et al., for continual learning: "as the model is trained with more classes, the feature extractor changes, making the preserved feature descriptors from previous feature extractors obsolete." Their fix is "a feature adaptation method that learns a mapping between two feature spaces", trained on pairs from old and new networks.
- Drift-Adapter does it for vector databases in the opposite direction, "mapping new queries into the legacy embedding space", and reports "95–99% of the retrieval recall" of a full re-embedding. An essay point: map the keys forward or the queries backward. The second leaves the store untouched.
- Heo et al. (NVIDIA) fit a closed-form ridge map between KV caches of different models in one family: "retains 73–98% of the receiver's standalone-prefill accuracy on four pairs, while two degrade sharply."
- **The counter-argument, which the essay should state.** CacheReforge: "Directly correcting historical K/V states from the adapter update is generally insufficient because downstream states also depend on update-altered hidden representations. Accurately reconstructing these effects would largely repeat the affected forward computation and erase the intended computational advantage". So a per-token map faces a problem an embedding map doesn't: keys are computed in context, and one token's drift depends on what came before.

**A fifth remedy the outline lacks: constrain the update so that old keys stay valid.** BCT trains the new model to be compatible with old embeddings. MoCo keeps a slowly moving key encoder. PatchKV is a language-model instance by construction: its weight patch is fit to behave correctly given the existing compressed cache, so the cache never goes stale relative to the patch (our reading, not the paper's). The off-policy analogue is keeping the target near the behaviour policy (ours too). Whether to add it is the user's call, since "four remedies" is the outline's shape.

### Two corrections to §9's text

- **"Remedy 2" wording:** see C1.
- **"the drift is in representation, not distribution".** Memorizing Transformers' own section is titled "Distributional Shift" ("there is a distributional shift in the keys and values that are stored in external memory"), and LongMem repeats "distributional shifts". The outline's distinction is defensible, and R2D2's "representational drift" supports it, but the essay should acknowledge that the source uses the other word. Suggested: "Memorizing Transformers calls this a distributional shift. It is closer to a change of coordinates: ..." For that phrase, note *The Coordinate System Problem in Persistent Structural Memory* ([2603.22858](https://arxiv.org/abs/2603.22858), single author, a small study): "Persistent structural memory that transfers across tasks requires a coordinate system". Not needed as a citation.

### Links for §9

*Filling the Stores* has a "Stale rollouts" passage (l. 184), which answers "Before drafting" item (b): link it. It also uses D-LSA's distillation (l. 120), which answers item (a).

## C. Citation checks

### C1. Memorizing Transformers staleness (arXiv 2203.08913): verdict, the outline's wording is not in the paper

§3.2, "Distributional Shift". Full passage:

"Because each long document is processed over multiple training steps, there is a distributional shift in the keys and values that are stored in external memory. The model parameters that produce the queries change over time, and will thus have shifted since the keys and values were stored. For very large memories, older records may become "stale." Similar observations have been made for CrossBatch memory (Wang et al., 2020c) in the vision domain."

"To reduce the effects of staleness, we normalize keys and queries (Henry et al., 2020). Normalization does not eliminate staleness, but it at least ensures that older keys and newer keys do not differ in magnitude."

"This training instability could be due to staleness. However, models seem to be able to cope with a limited degree of staleness (with the small memory) by adjusting their queries accordingly."

Replace "can tolerate a limited amount" with: "models seem to be able to cope with a limited degree of staleness (with the small memory) by adjusting their queries accordingly". Keep "seem", and note the parenthesis: the evidence is the 8K memory. "Remedy 2" should say normalization limits magnitude, not direction.

### C2. LongCat Sparse Attention (arXiv 2608.01662): confirmed, † can be removed

- **Authors:** Wen Zan, Jiaqi Zhang, Jianchao Tan, Hong Liu, Cunguang Wang, Xiang Li, Duyue Ma, Guanyu Wu, Yifan Lu, Fengcun Li, Yerui Sun, Peng Pei, Yuchen Xie, Xunliang Cai.
- **Affiliation:** "Meituan LongCat Team". v2, 4 Aug 2026.
- **Built on DSA: yes.** The abstract opens with DSA and its Lightning Indexer, and names its "expensive O(L²) scoring overhead"; the contents has a section "Sparse Attention and the DSA Baseline". It adds streaming-aware indexing, cross-layer indexing and hierarchical indexing.
- **Context length: 1M.** "LSA supports native training with context lengths of up to one million tokens and underpins the development of LongCat-2.0 (1.6T-A48B)". Its open model LongCat-Flash-Lite-Sparse extends "the native context length from 128K to 1M". LSA's Table 1 lists it as 1M/1M.
- **Abbreviation: yes.** "LongCat Sparse Attention (LSA)" throughout. Latent LSA's own table disambiguates as "LongCat LSA".

### C3. Memorilla (arXiv 2610.21375 v3)

**All 13 quoted strings in the outline were found in the PDF.** All numbers in §6, the thesis, §8 and §9 match except as noted here. Checked: 194.1M (194,123,776), K = 16, +4.91, +7.02, −3.45, −2.93, 78.73→51.75, 80–89, 73.5%, 80.43/84.33, 20 of 21, 5.93, 32,768 and YaRN, K = 8, 0.186/0.242, 0.250/0.375, 0.153/0.225, and the K = 128 result.

**TextWorld sample: † resolved.**

- **Test size.** "We train on 800 prompts and evaluate on held-out validation and test splits of 40 games each (30 distinct, since the five medium and five hard games appear twice)." Evaluation: "3 samples/held-out game at temperature 0.6". So 40 test prompts, 30 distinct games, 120 rollouts per evaluation.
- **Split.** By game within tier. Repo `rl/README.md`: "Each tier is split by game: 5 games (`--held_out`) go to test, 5 to validation and the rest to training." Six tiers (medium, hard, long, mega, huge, extreme), so 30 distinct test games. Compiled medium and hard games become two prompts each, and the four longer tiers one each.
- **Training mix differs from test.** Training prompts are "202 medium, 558 hard and 10 from each longer tier", so 95% medium or hard, against 50% in test.
- **"5 of 40 rollouts" is not the sample.** It describes trajectory length in medium and hard games. Drop it.
- **The headline gain in counts (our arithmetic).** pass@3 is a fraction of 40 prompts: 15/40 against 10/40, five prompts, with duplicated games among them. Wilson 95% intervals: 0.24–0.53 and 0.14–0.40. avg@3: 0.242 fits 29/120.
- **Unequal baselines.** The repo's script runs the trained checkpoint once but averages the untrained and no-memory baselines over seeds 0, 1 and 2. The reported values fit this: 67/360 = 0.186, 55/360 = 0.153, 81/360 = 0.225. Inferred from the script and the arithmetic; the paper does not say so.
- **Metrics.** `avg@k`: "fraction of rollouts solved". `pass@k`: "fraction of prompts solved by at least one of their rollouts".

Suggested wording for §6: "On 40 held-out prompts (30 distinct games, three rollouts each), the trained reader solves 15 prompts at least once against 10 for full history."

**The store in TextWorld lasts one rollout, and nothing learns at test time.** The store is that rollout's own turns: "M EMORILLA stores the completed turn as a new document". In the 20 longer test games it keeps only "the last four documents", one per five turns. The eval config sets `eval_only: true`. Neither paper nor README describes carrying a store between games. So "continual learning" here means a reader trained in advance. The outline's "generous label" can be firmer: nothing persists across games and nothing updates at test. The paper's phrase is "training only the memory module teaches an agent a new environment without overwriting prior knowledge" (Discussion).

**Which two benchmarks get extra fine-tuning:** PersonaMem-v2 and PersonalizationV4. "PersonaMem-v2 and PersonalizationV4 receive additional benchmark-specific fine-tuning because their validation losses required more epochs to plateau, while the other benchmarks plateaued or began to overfit earlier." (§2.6)

**Per-user fine-tuning: no.** App. B.2: "Train and test users are disjoint on both, so one module serves every user and enrolling a new one requires only embedding their chats." ("Both" is PV4 and PMv2.) §7: "Since each user's memory is a separate store, it can be kept on device or deleted on request". This is good support for §6's "the reader is trained generically". The stores themselves are never trained: "Each chunk di is embedded once by the frozen encoder". LaMP is not covered by the "both" sentence, so don't extend it there.

**Corrections.**

1. **§6 latency caveat.** The outline says the module's forward pass is about 2 ms at N = 512 and "its cost should grow linearly with the store". Table 14 shows the forward pass is 2.01 ms at N = 1 and 1.96 ms at N = 512. The text: "Growing the collection by 512× decreases the memory-module forward time by 0.06 ms". The authors conclude "a serving cost that stays flat as collections grow". Suggested: "Table 14 measures the read as flat from 1 to 512 documents (2.01 and 1.96 ms). A soft read over every stored document must grow with the store eventually; that is our inference, and the table stops before it shows." The complementarity argument with LSA survives, but only past N = 512. The paper's table conditions also matter: batch size 1, 250-token documents, one H100.
2. **§6 "criticizes the lineage's choice directly".** The sentence names other papers: "Methods that store model-specific hidden or key–value states, such as LongMem (Wang et al., 2023), MemoryLLM (Wang et al., 2024b), M+ (Wang et al., 2025), and Cartridges (Eyuboglu et al., 2026), tie the memory to one model and require training the LLM, a side network, or a separate cache for each corpus." Say the criticism applies to the lineage, not that it is aimed at it. The second half doesn't fit LSA, which needs nothing per corpus.
3. **Thesis point 2, "failures of combining, not of finding".** The paper hedges ("many of these", "suggests"), and the benchmark is built that way: each PV4 question "requires combining at least two persona facts" (App. D), and the dataset card says each one is "written to require combining at least two facts about the user". So a combining failure is partly expected on PV4. Keep the authors' hedge and say this. The same paragraph reports that on FactKG both methods lean toward judging claims false, a separate kind of failure.
4. **§6 "the union with RAG exceeds either alone".** Add the paper's qualifier: "(which is an oracle upper bound)". It needs a per-question oracle, so it shows complementarity, not a working hybrid.
5. **"Any improvement reflects..."** The source is mid-sentence and lowercase: "so any improvement reflects what the memory learns to extract, not access to additional information." Write "[a]ny" or quote from "any".
6. **§8 capacity result:** correct, but it comes from a 4B decoder trained from scratch at each K (App. E.2), so add "on the 4B decoder".

**Confirmed claims in brief.** Authors and affiliations (Stanford, Toronto, Vector, Penn, MIT). No citation of Memorizing Transformers, sparse attention or LSA (grep). Only added or changed documents are re-encoded. One-family pairing: "Our experiments pair a Qwen encoder with a Qwen decoder, and testing how well the memory mechanism transfers across model families is also an interesting future area of research." The §9 quote is at App. E.4.

### C4. Hippocampal gist: citations verified on PubMed, with a better one than requested

- **Spens & Burgess 2024:** "A generative model of memory construction and consolidation", *Nat. Hum. Behav.* 8(3), 526–543, doi:10.1038/s41562-023-01799-z, PMID 38242925. Verified. Abstract: "hippocampal replay (from an autoassociative network) trains generative models (variational autoencoders) to (re)create sensory experiences from latent variable representations", and memories "show schema-based distortions that increase with consolidation". The abstract does not use the word "gist". It supports the idea through schema-based reconstruction and "optimizing the use of limited hippocampal storage for new and unusual information".
- **Spens & Burgess 2026, the better citation:** "Hippocampo-neocortical interaction as compressive retrieval-augmented generation", *Nat. Commun.* 17(1), 7971, doi:10.1038/s41467-026-74357-6, PMID 42350398. Abstract: "sequential experiences are encoded in hippocampus in compressed form and replayed to train a neocortical generative network. This network captures the gist of specific episodes and extracts statistical patterns that generalise to new situations". And: "We simulate this interaction as 'retrieval-augmented generation', with the addition of mechanisms to compress episodic memories into hippocampus and to consolidate them into neocortex."

Suggested sentence for §8: "In Spens and Burgess's model, replayed episodes train a neocortical generative network that 'captures the gist of specific episodes' and generalizes to new situations." It is a computational model, so write "in their model", not "the brain does". The title's "retrieval-augmented generation" also gives §8 a neuroscience paper using the machine-learning term, which suits the comparison. I read the abstracts only.

Note for the essay: this bears on "Explicit is under strain" (§6), but in the opposite way from the outline's use. Memorilla is called gist-like because of a lossy read of a retained store; in Spens and Burgess gist is what consolidation stores in the network. Don't let the word imply that Memorilla consolidates.

### C5. LSA quotes in the outline (found while checking; not in the brief)

Both fail exact match in v1 and v2.

- Thesis l. 35: "LSA reduces the cost of finding keys, not of storing them". The paper (§5): "LSA reduces the cost of finding the keys, but not of storing them, and the KV cache still grows linearly with the context."
- Thesis l. 41: "never change once built". The paper (§3): "Once a cluster block is clustered, its buckets never change."

The unquoted paraphrase at §4 is fine.

## Limits

- arXiv search used the API on abstracts and titles, so a statement inside a full text could be missed. In particular, "not found" for the off-policy framing means not in abstracts, the papers read here, or web search.
- Semantic Scholar returned no citing papers for LSA or Memorilla, likely from indexing lag. Citing work may exist.
- Read in full or in the relevant passages: CacheReforge, MoCo, Wu 2018, R2D2 (review PDF), LongMem, Memorilla, LongCat, Memory Sparse Attention, plus Memorizing Transformers §3.2. Read by targeted extraction only: PReCache, KV-Cache Patching, RPMem, BCT, Hu et al., GNNAutoScale, Drift-Adapter, Iscen et al., SDC, XBM, Heo et al., PatchKV, ZHA, RecSA. Abstract only: the remaining 2026 papers.
- All 2026 preprints here are unreviewed unless stated. The vLLM and Baseten quotes came through a page-summarizing fetch, so recheck before printing.
- Not checked: the numbers in community LSA ports, and whether any lab has unreleased LSA work.
