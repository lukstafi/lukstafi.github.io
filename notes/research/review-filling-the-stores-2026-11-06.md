# Fact check of *Filling the Stores*, 6 November 2026

Draft checked: `notes/filling-the-stores.md`, as of 13:27 on 6 November. Checked against arXiv full text, Hugging Face cards, indexes and the HF API, the Z.ai, Moonshot, DeepSeek and MiniMax posts, and the MAI-Thinking-1 report. The `notes/research/training-*` reports were used only to find things; where they mislead, Section 4 says so.

Findings are numbered so that they can be cited. Within each part the most serious come first.

## 1. Definite errors

### D1. GLM-5's figures are presented as disclosures about GLM-5.3's base model

**Essay (Section 1):** "For GLM-5.3, whose own report does not exist, the cells draw on the GLM-5 and GLM-5.2 disclosures for the same base model."

**Essay (Table 1, GLM-5.3 row):** "28.5T (GLM-5) | text | Muon Split (GLM-5) | 32K, 128K, 200K (GLM-5); more 1M (GLM-5.2) | SFT (GLM-5)"

**Wrong:** Z.ai says GLM-5.3 shares a base with GLM-5.2. Nobody says GLM-5.2 shares a base with GLM-5, and the evidence points the other way.

- GLM-5 report §2.1: "a 744B parameter model". HF API for GLM-5.2 and GLM-5.3: 753,329,940,480 parameters.
- GLM-5.2 post: "GLM-5.2 is trained with IndexShare from mid-training with 128K sequence length". GLM-5 adds selection "at the end of mid-training", so the mid-training differs.
- GLM-5.2 post: "we substantially expanded 1M-context training". GLM-5 §2.3 stops at 200K.
- Your own primary note marks this cell as open: `training-primary-deepseek-glm-minimax-qwen-2026-11-06.md` line 224 has "GLM-5.2 / 5.3 | gap".

The GLM-5 token count, schedule and INT4 stage therefore describe a predecessor, not this base. Figure 1 compounds it with a single row, "GLM-5, 5.2, 5.3", showing "4-bit" at SFT. No GLM-5.2 or 5.3 source says the weights trained at 4 bits, and the two releases ship in BF16 and F8_E4M3.

**Fix:** "For GLM-5.3, whose own report does not exist, the cells give the predecessor's figures where the lab gives none. GLM-5 has 744 billion parameters and its base is not the one GLM-5.2 and 5.3 share." Better, set tokens and optimizer to "not disclosed; GLM-5: 28.5T", and split or relabel the figure row.

### D2. Z.ai did not fail to plan the cyber capability

**Essay (Section 5):** "Moonshot's removal is the rare case of a lab saying what it took out, and Z.ai says of GLM-5.3 that "cyber capability developed faster than we expected." Those two statements are the disclosures on what a run of this kind can write that its makers did not plan to write."

**Wrong:** The quotation is verbatim, but Z.ai put the capability in on purpose.

**Source:** GLM-5.3 post, "Emergent Cyber Capability": "As part of post-training, we introduced vulnerability discovery data and environments into the training mix. We expected this to make the model better at finding and reasoning about vulnerabilities. What surprised us was how quickly the capability continued to develop as training scaled."

Moonshot's case does fit: "a natural byproduct of training on broad data". Z.ai's is a surprise about rate, not about content.

**Fix:** "Z.ai, which added vulnerability data deliberately, says that the capability "developed faster than we expected." Moonshot's is the disclosure of a capability nobody set out to write; Z.ai's is of one that outran its plan."

### D3. "One sentence of process" contradicts the post and the essay itself

**Essay (Section 5):** "GLM-5.3 has open weights and one sentence of process for its release." and "GLM-5.2 and GLM-5.3 supply the checkpoints with almost no account."

**Wrong:** Section 4 of the same essay quotes the GLM-5.3 post on environments and verifiers, and Section 3 and Section 4 quote the GLM-5.2 post on IndexShare, the drafter and the anti-hack filter.

**Source:** The GLM-5.3 post names IndexShare, SAO and slime, describes synthesized environments, a judge agent, verifier checks and binary rewards, and says "It carries over the RL strategies introduced in GLM-5.2, including SAO with compaction". SAO is itself a paper, arXiv 2607.07508 (Hou, Li, Tang). The GLM-5.2 post also says "We therefore move from group-wise optimization to a critic-based PPO formulation", which is a real recipe disclosure the essay omits, and which qualifies "Most of the disclosed recipes descend from GRPO."

**Fix:** "GLM-5.3 has open weights, a post on its environments, and no token count, step count or schedule." In the closing pair: "supply the checkpoints with an account of method and few numbers." Add arXiv 2607.07508 to the sources, and name GLM-5.2's move to a critic where GRPO is introduced.

### D4. The claims drawn from Table 2 about norms and rates depend on which tensors the regexes admitted

**Essay (Section 5):** "Everything trainable moved in the three pairs that span post-training, at a similar rate across attention and shared experts, near 10 percent. Norms moved least and routers about half as much, which matches the small models and MiMo's trouble with routers."

**Wrong, three ways.** The JSON values reproduce Table 2 exactly. The sentences then generalize past them. The evidence is in your own earlier probes, in the scratchpad's `probe/k3_k31.jsonl` and `probe/glm.jsonl`.

- **"Norms moved least" holds only for `input_layernorm` and `post_attention_layernorm`.** The "norm" regex excludes other norm tensors, which moved as much as attention or more. K3 to K3.1 Pro: `self_attention_res_norm` 0.047 to 0.208, `mlp_res_norm` 0.044 to 0.143, `routed_expert_norm` 0.013 to 0.125. GLM-5.2 to 5.3: `self_attn.kv_a_layernorm` at layer 5 moved 0.186, more than any attention projection in that layer.
- **"Near 10 percent" holds only in the sampled layers.** K3 has 93 layers and the table samples 5 and 47. At layer 92, shared-expert `down_proj` moved 0.303, `up_proj` 0.343 and `o_proj` 0.223. At layer 91 the figures are 0.169, 0.155 and 0.171. No pair's sample reaches the last layers. Movement is strongly depth-dependent in the one pair where it was probed.
- **"Everything trainable moved"** is true of the sampled families. In K3, `e_score_correction_bias` and `dt_bias` are byte-unchanged (rel 0.0).

Routers at "about half as much" is also loose: K3's 0.069 is about 70 percent of its attention and shared-expert rate.

**Fix:** "In the families we sampled, attention and shared experts moved near 10 percent at the two layers we read, and input and output norms moved least. The rate is not uniform: at K3's last two layers the shared experts moved up to 0.34, and K3's residual-stream norms up to 0.21." Add a layer near the output to each pair before publishing, or state in the limits that the table skips the top of the stack.

### D5. Table 2's asterisk points at the wrong cells

**Essay (Table 2 caption):** "Cells marked \* are stored in 8 bits, so rounding inflates them."

**Essay (Section 5):** "That step moved the stored weights by about 0.2 percent, about the resolution of the format, and left the routers byte-identical. Distillation's write is some fifty times smaller than the distance between the other pairs."

**Wrong:** The caption implies that unmarked cells are free of the inflation. The unmarked MiMo column is where rounding inflates most.

- In the probe, MiMo's `o_proj` entries are bit-identical in 57 to 73 percent of cases, `lm_head` in 81 percent, and the norms in 95 to 99.7 percent. That is 1-ulp flips, not a measured displacement.
- I simulated BF16 rounding on Gaussian weights (`scratchpad/review_scripts/ex.py`). A true relative change of 0.10 percent measures as 0.19 percent, with 69 percent of entries unchanged. A true 0.05 percent measures as 0.13 percent, with 80 percent unchanged. So the true MiMo change is roughly 0.05 to 0.15 percent, and the column reads 1.4 to 2.5 times high.
- The same simulation for FP8 gives a rounding floor of 2.7 percent per side. A true 6 percent reads about 7 percent, an inflation near 1.15. The starred cells are inflated less than the unstarred MiMo ones.
- The essay itself warns of this in Section 4: "an update too small for the format is not stored."

Two further points on the same cells.

- **The V4.1 selector cell (0.266) is unmarked, yet 5 of its 10 tensors are F8_E4M3** (`wq_b`). The BF16 tensors alone give a median of 0.258, so the value barely changes, but the caption's rule is broken, and "16 to 30" takes its top from an 8-bit tensor.
- **MiMo's "Attention" cell is `o_proj` alone, two tensors.** The script skips `qkv_proj` because it stores `weight_scale_inv` rather than `.scale`. The essay never says so. Raw-byte equality on `qkv_proj` was 95 to 99 percent in the probe. MiMo's routed experts, which are most of the model, are also absent: bytes 97.7 to 99.6 percent equal in the two experts probed. That supports the size of the claim, but the table does not show it.

**"Some fifty times"** is not what the attention row gives: 0.070 to 0.094 over 0.0022 is 32 to 43. On true movement of about 0.1 percent it would be 70 to 90. The ratio mixes these. Across families it runs from about 11 (head) to about 160 (embedding).

**Fix to the caption:** "Cells marked \* are stored in 8 bits. Every cell carries a rounding floor; in the MiMo column, where most entries are bit-identical, the change is at the floor and the true movement is smaller than shown. MiMo's attention cell is the output projection alone." **Fix to the text:** "That step moved the stored weights by at most about 0.2 percent, which is near the format's resolution, so the true figure is likely lower. It left the routers byte-identical. On the output projections this is between thirty and fifty times below the other pairs."

### D6. The native model did not lose only two rows

**Essay (Section 3):** "The native model led on most retrieval, mathematics, image and video rows, and the converted one on two knowledge rows."

**Wrong:** MSA-CPT beats MSA-PT on five rows, and two of them are not knowledge rows. The native model leads every row of retrieval, mathematics, image and video, so "most" is also too weak.

**Source:** MSA paper Table 2, columns Full, MSA-PT, MSA-CPT. MMLU-Pro 38.8 against 39.1, ARC Challenge 82.5 against 82.9, TriviaQA 65.5 against 67.7, WinoGrande 60.9 against 62.0, BigCodeBench 44.0 against 45.7.

Also, "sparse from the start" means "after a 40B-token indexer warmup" (§5.1); the essay gives the 40 billion a paragraph earlier, so this is acceptable.

**Fix:** "The native model led on every retrieval, mathematics, image and video row. The converted one led on five rows of the general and code groups, among them TriviaQA, 67.7 to 65.5."

### D7. "Every disclosed recipe" of bounded staleness

**Essay (Section 4):** "So every disclosed recipe buys throughput with a bounded loss of on-policy freshness."

**Wrong:** Two of the cases do not say this, and K3's says the opposite of "bounded".

- K3 §4.1.2: "Our policy optimization algorithm inherently tolerates such an extreme off-policy regime through a per-token regularization" and "robustly handle highly stale data". No bound is given.
- The V4 report discloses no asynchrony or staleness limit. V4.1 §5.2 is the first DeepSeek account of it.
- GLM-5's reasoning RL is contrasted with the asynchronous case: "Unlike the synchronous RL training setting in Section 3".

**Fix:** "So the asynchronous recipes buy throughput with a loss of on-policy freshness. MAI, GLM-5, V4.1 and MiMo bound it; K3 tolerates it through regularization."

### D8. Selection has not been added "at every stage"

**Essay (Figure 1 caption):** "Selection has been added at every stage."

**Essay (Section 3):** "**When to add selection.** Every position in the pipeline has been tried."

**Wrong:** The cases run from the first token (V4.1) through pretraining (V4), mid-training (GLM-5.2, GLM-5's end of mid-training) to retrofits on released checkpoints (LSA, ZHA, CISA). None adds selection at SFT, RL or distillation. K3.1 Pro's stage is undisclosed. The figure's own row shows nothing in those columns.

**Fix:** "Selection has been added everywhere from the first token to the released checkpoint." In the text: "Positions from the first token to the released checkpoint have all been tried."

### D9. Two more caption claims fail on the essay's own rows

**Essay (Figure 1 caption):** "Quantization arrives before the policy is trained." and "An empty stretch of a row means that the report gives no date, not that nothing happened."

**Wrong:**

- MAI never quantizes through RL (Table 1: "none: 16-bit throughout RL"), and V4.1's expert stage is "not disclosed". The figure itself labels V4.1's chip "4-bit cache".
- GLM's row has no context chip although the essay gives dates for it: 200K at the end of mid-training (GLM-5 §2.3). MAI's row gets its 256K chip on the same evidence.
- V4 and V4.1's chips sit at x=2.22, the SFT column. V4 §5.2.1 says "during the post-training stage"; V4.1 §2.4.4 says "during post-training". The SFT placement is more precise than either source.

**Fix:** "Where experts are quantized, it happens before or during post-training." Add a 200K chip to the GLM row. Place the V4 and V4.1 chips on the boundary or span them across post-training.

### D10. Expert quantization in V4.1 is stated in one place and "not disclosed" in another

**Essay (Section 3):** "MiMo starts expert quantization in mid-training, K3 and GLM-5 at SFT, V4 and V4.1 during post-training."

**Essay (Table 1):** "post-training for the cache; experts not disclosed"

**Wrong:** Table 1 is right. V4.1 §2.4.4 puts only the main KV cache in post-training QAT. It does not date the experts.

**Fix:** "...V4 during post-training, where V4.1 also adds its cache."

### D11. The bound on the small-model studies is false

**Essay (Section 4):** "All of these studies concern short RL or fine-tuning on models of 1.5 to 70 billion parameters, mostly on mathematics."

**Wrong:** The section cites Zucchet's 44 million, Palit's small Transformer and OLMo-2 1B below the range, and DeepSeek-R1-Zero at 671 billion above it. R1-Zero also ran about 8K steps (Mukherjee: "undergoes 8K training steps"), which is not short.

**Fix:** "All of these studies concern models far below the frontier or long-finished runs, mostly on mathematics." Or: "Apart from R1-Zero, these studies run from 44 million to 70 billion parameters."

### D12. The linear-path study reaches 32 billion, not 8

**Essay (Section 4):** "Across RL runs on models up to 8 billion parameters, weights move along [a stable, nearly linear path](https://arxiv.org/abs/2601.04537), to the point that [a rank-one trajectory in each tensor](https://arxiv.org/abs/2605.21468) recovers the performance."

**Wrong:** 8 billion is Wei's maximum. Wang's is not.

**Source:** Wang et al.: "we vary model scale (from 1.5B to 32B parameters)", including the MoE Qwen3-30B-A3B. Wei et al.: Qwen2.5-Math-1.5B, Qwen3-4B-Base, Qwen3-8B-Base.

**Fix:** "Across RL runs on models up to 32 billion parameters, weights move along a stable, nearly linear path, and at up to 8 billion a rank-one trajectory in each tensor recovers most of the gain." Wei's words are "the majority of downstream performance gains", so "most of the gain" is safer than "the performance".

### D13. The 0.2 overlap belongs to one class of heads

**Essay (Section 2):** "And at 7 billion parameters on natural text, [Hakimi and colleagues](https://arxiv.org/abs/2506.03434) find attention heads turning over to the end of training, with little overlap even between the last two checkpoints."

**Wrong:** The overlap figure is for answer-specific heads only, and the quantity is role assignment in factual-recall circuits.

**Source:** "answer-specific heads demonstrate the highest turnover (even the IOU between the final model and the checkpoint just before the final model is just 0.2)". The same paper: "In the later stages of training, the model stabilizes into a configuration dominated by general heads."

Then "Routing in a real model keeps moving" rests on the narrow class.

**Fix:** "...find the heads specialized for answers still turning over at the end of training, with an overlap of 0.2 between the last two checkpoints, while the model as a whole settles on its general heads."

### D14. Moonshot did compare two of the three vision orders

**Essay (Section 2):** "Each lab reports that its order works. No lab has compared the orders on one model."

**Wrong:** K3 §2.4 and Fig. 6 are a comparison of a pretrained encoder against one trained from scratch, and the essay quotes that comparison two sentences earlier.

**Source:** "the SigLIP-initialized MoonViT-3D shows persistently higher gradient norms with frequent spikes, while MoonViT-V2 remains stable throughout training (Fig. 6)"; "we find MoonViT-V2 matches the SigLIP-initialized baseline across vision evaluations". Fig. 6's caption calls these "our pre-training ablations". The encoders differ, so it is not a clean ablation, but it is a comparison.

**Fix:** "Moonshot compared a pretrained encoder with one trained from scratch, on different encoders. No lab has compared all three orders on one model."

### D15. Table 1 says "not disclosed" for a modality the card states

**Essay (Table 1, Qwen3.8-2.4T):** Modalities: "not disclosed"

**Wrong:** The card says: "Qwen3.8-2.4T-A95B is a text-only model that requires thinking mode for all interactions. Multimodal inputs are not supported". The companion essay says so too (line 269: "The open checkpoint is the text-only counterpart of the Qwen3.8-Max service"). The essay defines the cell as "we searched the model's report, card and repository and found nothing."

A smaller slip in the same table: MiniMax-M3 reads "text and images from the first step", and the card says "across text, image, and video".

**Fix:** Qwen: "text (open checkpoint)". M3: "text, images and video from the first step".

### D16. Sources and links

- **`https://github.com/lukstafi/lukstafi.github.io/blob/main/scripts/weight_diff.py` returns 404.** The script is untracked. It will resolve once it is committed and pushed, along with `notes/research/weight-diffs-2026-11-06.json`.
- **The OLMo-2 1B sentence has no link.** It comes from Palit et al., Table 3. See J7 for its numbers.

### D17. Small numerical and wording slips

| Essay | Problem | Fix |
| --- | --- | --- |
| Example 9: "by the third the columns sum to within 0.0003 of 1" | Third round gives 0.99966 and 1.00034, a gap of 0.00034 | "within 0.0004" |
| Section 3: "Upweighting long documents and changing the mixture gave nothing measurable." | MAI App. C.1: "none of these modifications yielded meaningful improvements" | "gave no meaningful improvement" |
| Section 3: "MAI's self-distillation erased long-context behaviour unless mid-training data was mixed back in." | §3.1.4: "can forget long-context behavior", "especially when" traces come from shorter runs | "could erase" |
| Section 4: "up to 86 percent in the 671-billion-parameter DeepSeek-R1-Zero" | 86.0 is R1-Zero's value, not a maximum: the abstract's range is 70 to 95 percent unchanged ("just 5%-30% of the parameters") | "86 percent in the..." |
| Section 2: "a 44-million-parameter Transformer" | §1.4: "44M non-embedding parameters" | Add "non-embedding" once, or accept |
| Section 4: "and it pays for itself in forgetting" | The idiom means it recoups its cost, the opposite of the intended sense | "and it pays in forgetting" |
| Section 5: "Provenance is the thinnest column." | Table 1 has no provenance column | "Provenance is the thinnest disclosure." |
| Section 3: "its acceptance length rose from 4.56 to 5.10 tokens" | The ablation is on an older model: "we use the backbone and training data of GLM-5.1" | "and on GLM-5.1's backbone the acceptance length rose" |
| Section 3: "A public RL recipe for K3.1 Pro" | The miles document is titled Kimi-K3.1, and is a LoRA recipe on a frozen base | "A public LoRA recipe for Kimi-K3.1" |

## 2. Judgement calls

### J1. Quantization evidence: "finds the same" hides the paper's main result

**Essay (Section 3):** "Their conclusion was that quantization may have to happen during training, and [later work](https://arxiv.org/abs/2609.32902) finds the same at small scale."

Paudel and Sheshappanavar agree on half: post-training quantization methods "recover no measurable capacity below 4 bits". But they test the QAT conjecture and find that low-precision training also fails: "ternary models retain as little as 6% of an identically trained fp16 model's capacity", and "the schedule, not the precision, decides whether it occurs". Their subject is below 4 bits, at 2.5 to 50 million parameters. Quoting them as agreement in a section called "Precision enters before the policy" omits that entering early is not sufficient, and that the failure can be cured by a schedule.

**Suggested:** "...and [later work](...) confirms that post-training methods recover nothing below 4 bits, while training at those precisions has its own failure, which a learning-rate schedule can prevent."

### J2. The closing argument claims more than the body supports

**Essay ("What the weights keep"):** "A store records everything written to it." Section 4 says "an update too small for the format is not stored", and the MiMo column shows it.

**Essay:** "The stages exist because the stores cannot be filled in any order. Routing has to form, selection has to find its teacher, precision has to enter before the policy."

- "Each lab reports that its order works" (Section 2), and selection works from the first token to the released checkpoint.
- "Two designs drop the student altogether", so selection need not find a teacher.
- MAI never quantizes through RL, so precision need not enter at all.
- "Routing has to form" rests on a mechanism the essay itself offers "not as a measurement of the seven".

A weaker claim survives: the stages exist because some orders are known to fail and the labs cannot afford to test the rest. **Suggested:** "A store keeps what the format can hold." and "The stages exist because some orders are known to fail, and the rest are too expensive to test."

### J3. "A selector needs a teacher only if it is a separate network."

MSA Appendix B.2 trains a separate Index Branch with no teacher, through "the Index Branch output", on "LM Loss only". It learns, poorly: "performs poorly on long-context retrieval". So a separate network can do without a teacher at a cost. **Suggested:** "A separate network needs a teacher to select well."

### J4. "Distillation's write" compares unlike things

Even after D5, the ratio sets one short MiMo pass against whole post-training spans at other labs, with different learning rates and step counts. MiMo's RL ran 30 steps. The card says the stage also folds in "a short specialized-teacher run". The size may reflect the run rather than distillation. The nearer comparison is Lei Zhao et al.'s 0.025 to 0.098 percent, which the essay already cites, and that is after 200 updates. **Suggested:** present it as "one short pass at one lab".

### J5. "which matches the small models and MiMo's trouble with routers"

The essay cites no small-model measurement of router or norm distance. Its routing citation (arXiv 2609.32821) concerns input shifts under weight merging. MiMo's trouble was that a free router drifts harmfully in 20 steps, which does not predict a low median distance elsewhere. Router tensors in the table are `gate.weight` at two layers. **Suggested:** drop the clause.

### J6. Inferences stated as reports

- **"The final mid-training thus contains the failures of a trial post-training."** MiMo §4.2.6 says "In early experiments, we observed a tendency toward reward hacking in MiMo". It does not say the experiments were RL, or trial post-training. "MiMo found hacking in early RL runs" is the same inference. **Suggested:** "in early experiments".
- **"K3.1 Pro includes a rerun of mid-training."** This is stated flat in the limits. The blog supports it ("removed cyber-related data from both training stages"), while the card says "Post-trained from Kimi K3". Section 3 reasons to it correctly. **Suggested:** "K3.1 Pro appears to include".
- **"because a quantized checkpoint would lose them."** MiMo §5.1 gives its reason as "To stabilize MXFP4 training", and the state carried is "Muown's row state", not all optimizer state. **Suggested:** "carries 32-bit master weights and Muown's row state across the boundary from SFT to RL, to stabilize 4-bit training."

### J7. OLMo-2 1B figures come from different steps

**Essay (Section 4):** "took recall of old facts from 0.28 back to 0.77, at a cost in new-fact recall of 0.90 to 0.40 by the end."

Palit Table 3, synthetic individuals: step 80 old facts 0.28 to 0.77, new facts 0.03 to 0.01; step 400 old facts 0.38 to 0.70, new facts 0.90 to 0.40. "By the end" flags the shift, but the best old-fact figure is paired with the end-of-run cost. Real entities are milder: 0.73 to 0.88 at step 80. **Suggested:** "at the trough, ... from 0.28 to 0.77; by step 400 it held 0.70 against 0.38, at a cost in new-fact recall of 0.90 to 0.40."

### J8. MAI's extension result needs its conditions

**Essay (Section 3):** "Mid-training at 32K and extending to 256K for 100 billion tokens matched a full trillion tokens at 128K."

App. C.3: the progressive run also spent "1T tokens" at 32K, and the match is on code NLL evaluated at 128K context. The sentence reads as if 100 billion replaced a trillion. **Suggested:** "A trillion tokens at 32K plus 100 billion extending to 256K matched a trillion at 128K, in code loss at 128K."

A note on the 150 billion: MAI's Table 6 says 150 B, and App. C.5 says "140B tokens of 256K extension". The report is inconsistent. The essay uses the table, which is the sensible choice.

### J9. Weights "about equally at all depths"

**Essay (Section 4):** "In [Zhang and colleagues'] study of seven Qwen models, weights move about equally at all depths under full RL."

§5.2 measures this on Qwen3-1.7B-Base only ("ranging from approximately 0.5 to 0.8"). The contribution pattern is the seven-model result. **Suggested:** "...study of seven Qwen models, one of them measured for this, weights move..."

### J10. Claims of firstness or uniqueness I could not refute but would soften

- "Its ablations are the first production-scale findings on the method" is your claim, not MAI's.
- "Only one experiment holds everything else fixed." This is true of the 3T comparison. MSA's pilot ablations at 10.5 billion parameters are controlled comparisons too, at smaller scale. **Suggested:** "Only one experiment at this scale".
- "the fullest account of a training pipeline we have" and "the fullest in the reports" are defensible and unprovable.

### J11. The proposed V4-Pro pair has a format problem

**Essay (Section 5):** "A proper version would take V4-Pro-Base against V4-Pro".

HF API: V4-Pro-Base stores 1.596T as F8_E4M3; V4-Pro stores 1.573T as I8 (FP4). Experts therefore cannot be compared on the same grid, the problem the script already avoids. The linked V4-Pro repository dates from April; `DeepSeek-V4-Pro-0813` is a separate later release. Worth a clause.

### J12. Opening: token share is not cost share

**Essay:** "Post-training can be a small share of a run." The third of a percent is a share of tokens. RL at 1M context and $2.6M is not comparable to pretraining per token, and MiMo gives no pretraining cost. The sentence is defensible if read as tokens, which the next sentences specify.

## 3. Checked and correct

**Opening.** 753,329,940,480 parameters for GLM-5.2, 5.3 and 5.3-BF16 (HF API). Both GLM quotations verbatim. 66.9 and 46.2 on DeepSWE v1.1. MiMo 30T, 30 steps, 2.7B to 3.7B tokens per step, $2.6M, 58.4 to 72.6. "Under the same names" holds for the weight tensors; the main GLM-5.3 repository is F8_E4M3 with added scale tensors, which the essay handles later by naming the BF16 release.

**Table 1.** All other cells for MiMo, K3, V4-Pro, V4.1, MAI. MiniMax-M3 undisclosed cells confirmed against the card and the launch post, minimax.io/blog/minimax-m3, which your notes did not read. It adds only that M3 rebuilt its text pretraining around "interleaved data".

**Section 2.** Zucchet: 64k default, six attributes, y = 0.43x^0.81, batch 128, 11.4 and 5.2 biographies per person, "same initial parameters", plateau disappearance, "on the order of a hundred steps" (App. F, against "first few hundred steps" in §4.2). "feedforward weight learning precedes and drives attention learning" verbatim. Allen-Zhu 2 bits at 1,000 exposures, 1 at 100, int4 loss. 1.6, 0.5 to 1, 3.5 bits. Gu quotation verbatim, 6.9B. Tutorial 0.16 at d=256, warning verbatim. MAI memorization proxy, sources, 35 and 55 percent. K3, V4.1, MiMo encoder orders. Muon post's low-rank claim. V4 and V4.1 optimizer splits. MiMo's switch, "no loss spike". Muown's per-neuron gain. Qu's disruption. AttnRes, K3 drafter and MAI initialization.

**Section 3.** MSA quotations, 10.53B pilot, 40B warm-up, 79.8, 84.2, 77.2. V3.2 2.1B, GLM-5 2.8B (derived: 1000 × 14 × 202,752) and 20B, GLM-4.7-Flash 79.21, 71.35, 78.86. V4.1 "without any dense attention warmup stages", no indexer loss disclosed. LSA 352M, within 5 points, N-LSA at 0.5B. ZHA a billion tokens. CISA 2.05 points. K3.1 Pro: 120 tensors, 24 layers, five each, 178.5M, 0.006 percent, nothing removed, card's footnote, blog silent on sparse attention, 90.5 and 81.0. GLM-5 freeze and top-k quotations verbatim. mHC 12k, 3000, 20 iterations, custom backward "traverses the entire iteration", AdamW at 4096, 27B. K3's four multiplications, SiTU bound of 100 (β₁β₂), Quantile Balancing, floor of −5 with BF16 range. V4's quotations. MAI aggregation. MiMo's router figures. Long-context schedules for K3, V4-Pro, MiMo, MAI. GLM-5's 200K result. The K3, V4 and MAI precision statements. Drafter statements, including GLM-5.2's 4.56, 5.10, 5.47, measured on GLM-5.1's backbone.

**Section 4.** GRPO formula against GLM-5's restatement. MAI's 128, 0.6, 0.3, 40 steps. Goodfire 90.8, 95.2, 57.2. MiMo's hacking section, `pip index versions sphinx`, below 2 percent. GLM-5.2 filter. MiMo's grader quotation: it sits in §4.2.2 on professional tasks, and §4.3.2 confirms "An SFT-trained agentic grader" for coding, so the generalization holds. V4.1 "essentially all". GLM-5.3 month and verifiers. K3's nine policies and teacher conditioning. V4 variance argument. MOPD2. 5.2 and 8.0 percent. 2.45 to 16.25 percent. 0.025 to 0.098 percent. Ma's step 18. V4.1 teachers. GLM-5 quotation (hyphenated at a line break). MAI consolidation and all self-distillation bullets. LR tenth. Qwen Next quotations. Moonshot quotations. Du 0.013, 0.060, 80 percent, 29 of 29. Kaplan 0.010, 0.931, 0.941, 0.782. Palit 47 and 46. 114 and under 30. 61 to 73.

**Section 5 and closing.** Qwen and MiniMax disclosures. Axion quotation. K2 15.5T, 67M batch, learning rates. K3 withholding TPP. K3 appendices. MAI provenance quotations (the first spans a figure in the PDF). MAI collapse quotation.

**Table 2.** Every cell matches the JSON. Pinned revisions match the current HF shas. V4.1 and 1017 have equal parameter counts and formats. "Span post-training" for 1017 is supported by DeepSeek's release note: "uses reinforcement learning with self-feedback".

**`scripts/weight_diff.py` decoding is correct.**

- BF16: `uint16 << 16` reinterpreted as `float32` on little-endian.
- F8_E4M3: bias 7, subnormal scale 2⁻⁶, NaN at exponent 15 with mantissa 7, no infinities, maximum 448.
- F8_E8M0 block scale: 2^(e−127), matching `float8_e8m0fnu` in DeepSeek's kernel, with 32 × 32 blocks as in `v41-model.py`. Value 255 is NaN in that format and the script maps it to 2¹²⁸, which is unlikely to occur and harmless.
- `block = s // t` would be wrong if dimensions were not multiples of 32, but `np.repeat` would then fail on shape, and no run did.
- `weight_scale_inv` is not handled, which is the omission in D5.
- BF16 releases are not upcasts of 8-bit weights: on seven live tensors, mantissas are uniform over all 128 values, so the GLM and K3 columns carry no hidden FP8 grid.

**Worked examples.**

- Example 6: ζ(1.2) = 5.5916; tails 8.14 and 5.14 percent; 9.83M and 155.8M; removal 36.9 percent; 10^1.2 = 15.8. The infinite tail matches the tutorial's "Infinitely many different contexts".
- Example 7: G as stated, singular values 10 and 1, UVᵀ as stated, 0.995 and 0.0995, then 0.1975, 0.3837, 0.6868, 0.9640, 1.0005.
- Example 8: means, softmax, KL 0.2846, gradient, 0.0101, 40 percent all correct. Top-2 becomes {1,3} by step 5, and q is near p by step 10 (KL 0.0006), so "about twenty" is generous but true.
- Example 9: rounds 1 and 2, the invariant 3, a = 0.634, (10,6), 3.414¹⁰ = 215,232, (2.73, 3.27), all correct. Column then row matches the paper's T_r(T_c(·)).

**Links.** All 46 arXiv identifiers resolve to the intended papers, with first authors as named. Hugging Face, Muon post, tutorial, MAI PDF and miles links return 200. The MAI PDF has 109 pages. `who-teaches-the-weights.html#what-on-policy-training-forgets` exists, and the ambiguity passage is in that section. `every-layer-a-store.html`, `how-does-a-policy-improve.html` and `where-experience-goes.html` exist. Worked example 4 uses (2,4). "The second teaching condition" matches *Who Teaches the Weights?*. The companion's "Long context is an interference problem" is a heading there. Beyond D15, no contradiction with the companion.

## 4. Where the secondary reports mislead

- `training-primary-order-of-storage-2026-11-06.md` line 270 gives Wang's range as "1.5B–8B, Qwen3-30B-A3B"; the paper says up to 32B. This seems to be the source of D12.
- The same report at line 370 quotes the 0.2 correctly for answer-specific heads. The narrowing was lost in drafting (D13).
- `training-primary-deepseek-glm-minimax-qwen-2026-11-06.md` line 224 correctly marks GLM-5.2 and 5.3 as a gap. The draft overrode it (D1).
- The same report, line 33, says native sparse wins "most" rows without counting the converted model's rows (D6).
- The minimax.io launch post was not among the sources read for M3.

## 5. What I did not manage to check

- **Claims of absence.** "We found no published comparison of any 2026 pair", "Nobody has published the comparison under Muon at a million tokens", "nobody has run the experiment at scale", "No lab has..." beyond D14, and "We found no published measurement that resolves the 2026 frontier's own stores". I found nothing against them, but I did not run a literature search.
- **`scripts/weight_diff.py` end to end.** I checked the code by reading, the table against the JSON, and the earlier probes, with new live reads only for BF16 mantissas. I did not re-download or re-decode the FP8 tensors, or test the V4.1 cells independently.
- **The rounding figures in D5** are from a Gaussian simulation. They show the size of the effect, not exact corrections.
- **Allen-Zhu's "up to half a billion parameters"** I inferred from "N up to 20M" at about 2 bits per parameter rather than from a stated size.
- **Figures read from charts.** MiMo's hack curve and Fig. 11 axes, MAI's Fig. 22, and K3's Fig. 6 were checked through their prose, not their plotted values.
- **Abstract-level reads.** 2611.05609, 2610.11247 and 2601.11061 were read at abstract and key-result level.
- **The miles document** was read only for its indexer lines.

## 6. Summary

The essay is well sourced. Every quotation I checked is verbatim, all 46 arXiv links go to the right paper, all four worked examples recompute, and Table 2 matches its JSON. The script's decoding is correct.

The errors are mainly of scope, where a true statement about some cases is written as a statement about all. The most serious are these:

- D1: GLM-5's figures are presented as describing GLM-5.3's base, which no source says.
- D2 and D3: Z.ai's deliberate cyber data is read as unplanned, and GLM-5.3's post is called one sentence while the essay quotes it.
- D4 and D5: Table 2's prose claims hold only for the tensors sampled, with K3's last layers at up to 0.34 and other norms up to 0.21, and the rounding asterisk marks the cells least affected while leaving MiMo's unmarked.
- D6 to D14: overgeneral counts and bounds, including the five rows the converted model won, "every disclosed recipe", "every stage", and the 1.5-to-70-billion and 8-billion ranges.

Among the judgement calls, J2 matters most. The closing paragraphs state as necessity what the body reports as lab practice, and "A store records everything written to it" conflicts with Section 4's rounding point.
