# Interpretability transfer and an extended retrospective audit

Research date: 15 October 2026. Status: companion to [frontier-model-architectures.md](frontier-model-architectures.md) (3 October 2026), supporting a future essay series; not a publication draft. This dossier does not repeat the architecture dossier. It cites that dossier's sections by title and fills two gaps.

**Gap 1** asks what is known about mechanistic interpretability on the components of the seven checkpoints: MiMo-V2.6-Pro, Kimi K3, Qwen3.8-2.4T-A95B, GLM-5.3, DeepSeek V4-Pro, DeepSeek V4.1-Flash and MiniMax M3. **Gap 2** extends the retrospective audit from three essays to the essays that rest on vanilla-transformer assumptions.

## Evidence labels

Three labels mark every substantive claim.

- **Confirmed**: stated in a primary text, configuration file or reference code that the research pass read for that statement, or derived directly from equations in such a text.
- **Reported**: taken from an abstract page, a secondary summary, a community blog post or a preprint without independent reproduction. Most interpretability results below carry this label because they are single-author, small-scale or unreviewed. Scale is always given.
- **Inferred**: our argument. It is never promoted to a finding.

Gap 1 additionally sorts every result into three cases: **reproduced** on one of the seven checkpoints or their direct family at relevant scale; **transfers with argument** (shown on another model, with a stated reason it should carry over); **breaks or needs new tools**. "Toy" means at or below about 1B parameters.

Provenance: four research passes (MoE, attention variants, recurrent layers, depth and residual pathways) fetched and read about 150 sources. The full per-source registers, with read/abstract/secondary tags, live in the session notes folder outside the repository (`research-moe.md`, `research-attention.md`, `research-recurrent.md`, `research-depth.md`). The source register at the end of this file keeps the sources the findings depend on. The audit in Part 2 was done directly against the essay texts; every quotation was checked mechanically against its source file.

---

## Findings

### Interpretability transfer

1. **Nothing of the usual kind exists on the seven checkpoints.** No SAE, transcoder, attribution graph, circuit or patching study on MiMo-V2.6-Pro, Kimi K3, Qwen3.8-2.4T-A95B, GLM-5.3, V4-Pro, V4.1-Flash or MiniMax M3 turned up in any of the four passes. The nearest frontier-scale work is a family of Jacobian-lens analyses on DeepSeek-V4-Flash (about 284B, mHC), three community write-ups from August to October 2026. Others: SAE and routing probes on DeepSeek-R1 671B (the V3 architecture), a weights-only audit of Kimi K3's depth-attention queries, and an activation-statistics study spanning Kimi Linear 48B and Qwen3.5 up to 397B. [Reported] *Out of date for K3:* a neuron-only attribution graph has since appeared (Addendum A.2).
2. **Tools that read the residual stream at one position survive.** MoE, MLA, learned sparse attention, windowed attention and recurrent layers all read from and write to the residual stream at each position. Residual-stream SAEs, logit lenses and per-position probes therefore apply unchanged; Qwen-Scope already ships residual-stream SAEs for MoE and GDN-hybrid Qwen models. [Inferred from architecture; Reported for Qwen-Scope] What changes is the structure of edges *between* positions (compressed blocks, selected sets, recurrent state) and the expert dispatch.
3. **Tools that assume one additive stream across depth break on two of the seven.** Under mHC (V4, V4.1) and AttnRes (Kimi K3), "the residual stream at layer *l*" is not one vector. Both reduce to token-dependent scalar mixing of earlier sublayer outputs in shared coordinates, so direct logit attribution and sublayer-output SAEs remain well defined; "resid_post" SAEs, single-stream patching and circuit-tracing replacement models need new conventions. [Confirmed from equations and released code; the consequences are Inferred]
4. **The Jacobian lens has been run on an mHC checkpoint with a modification.** The source is the flattened four-stream state; the target is the `hc_head` output. Song and Feng's replication on V4-Flash-0731 found a workspace-like layer band and strong causal sensitivity, but did not reproduce the reasoning-versus-prediction selectivity reported for Claude, on mHC or on single-stream GLM-5.2. [Reported: community work, two authors]
5. **MoE.** Expert-level units look more interpretable than dense neurons, and the gap grows with routing sparsity (six MoEs up to 30B); all seven checkpoints are sparser than anything tested. The story about *what* experts specialize in has shifted from domains to fine-grained or "superposed" features, with active dissent. Routing is a strong control knob (edits to router scores work up to gpt-oss-120b) and a poor observational summary. No transcoder or attribution-graph study exists on a large MoE, and one source reports that path-integrated attribution breaks when routing is recomputed along the path. V4's hash-routed early layers make expert identity a pure function of token ID. [Reported throughout; scale limits stated in Part 1]
6. **Attention variants.** MLA keeps an explicit softmax per head, so attention-pattern analysis transfers; per-head QK/OV circuit analysis in the shared latent has been attempted only in a 114M model, without QK/OV or absorbed-matrix analysis. DSA and MSA expose an explicit selected set, and MSA's own analysis (about 109B) shows the learned indexer rediscovers sinks and local blocks; whether induction and retrieval heads survive top-k conversion is untested. CSA and HCA pool 4 or 128 tokens into one entry, so attention-based token attribution through them resolves only to blocks. [Confirmed for mechanisms; Inferred for the attribution consequence]
7. **Recurrent layers.** Recurrent state is inspectable at head level in GDN-family models at 340M to 9B: content-specific writes are concentrated and causally sufficient, with cross-fact coupling. In hybrids, the recall effect sits in the full-attention KV cache. On a controlled associative-recall task in Qwen3.5-4B, recurrent interventions recover 0.2 to 3.6 percent of the effect and KV interventions 96 to 100 percent. No gate-trajectory interpretability, state inversion, transcoder or attribution graph exists for GDN or KDA, and nothing exists on K3 or Qwen3.8 at all. [Reported: small scale, controlled task, one group]
8. **Most results are small, single-author or unreviewed.** The largest causal evidence on a GDN hybrid is a 27B build in an unreviewed preprint. The strongest frontier-scale results are lens readouts and activation statistics. An essay may state what the evidence says; it should not describe any of these as established for the seven checkpoints.

### Retrospective audit

1. **The sharpest breakage concerns persistence across tokens.** The Experience/Selfhood essay says a transformer's cached states are "consulted, not regulated", and Dispersed Minds says the architecture cannot "persist or revise state variables across processing episodes". For Kimi K3 (69 of 93 layers) and Qwen3.8 (69 of 92) the claim is wrong at the level of architecture: those layers carry a state that is revised at every token by an error-correcting update. The claim was already too strong for a vanilla transformer in its other forms ("internality only within the pass"), because the KV cache is an internal channel across passes.
2. **The unfolding-argument answer needs rewriting for three of seven.** "Each layer … reads from and adds into one shared stream" and "the identity plus a correction" hold for MiMo, GLM-5.3, Qwen3.8 and MiniMax M3, pending a code audit. For DeepSeek (mHC) the identity skip becomes a mean-conserving re-mixing of four copies. For Kimi K3 (AttnRes) completed block sums are read-only values retrieved by softmax, so the carrier persists only as the in-block running sum. Shared coordinates survive in both; the identity skip does not.
3. **The Mary write-path claim is wrong for all seven.** The Grain essay's statement that a transformer's reasoning reaches its carriers "only through the sampled token" ignores that the KV cache and, in the hybrids, the recurrent state are written with continuous activations. A delta-rule layer writes an arbitrary key-value association per head per token.
4. **The monotone-join thesis holds for the residual stream and fails inside delta-rule layers.** Merge and Selection's "never overwritten, only added to" is a claim about the residual stream. Inside KDA and GDN layers the token mixer overwrites along a key direction and decays. Linear-attention state is also an outer-product (tensor-product) store, so the "bag of fillers" binding problem is partly solved in memory, though not at the readout. Learned sparse selectors turn selection and merge into two separate modules (indexer; main attention), which supports the essays' un-bundling thesis literally.
5. **The operator/operand split of *A Parser Without a Grammar* dissolves for delta-rule layers.** The state matrix is an activation-time operator: a fast weight. V4.1-Flash's Engram adds a distinct lexicon-like store; MoE adds a categorical partition to the inventory; sparse attention makes the link graph discrete.
6. **The claims of no capacity bottleneck, no coordinated selection and no gradient-insulated modules need qualifying, not overturning.** The seven have hard top-k capacity limits (experts, positions, blocks), explicit selectors at three sites (router, indexer, depth attention), and gradient-insulated indexers. But the limits are thousands of items per head, not four in series, and the insulated modules imitate the main computation rather than bring a different objective.
7. **Minds by Degrees §7 is partly stale.** Its seconds-scale-window requirement was dropped in the later Experience/Selfhood and Grain essays. Its inference-time accuracy-responsiveness is stronger than stated for delta-rule layers, whose update is one gradient step on a per-token regression loss. Its claim that interpretability supplies construct validity rests on dense-model evidence.
8. **The essays' interpretability premises come from dense models or models of undisclosed architecture.** Thought anchors: DeepSeek R1-Distill-Qwen-14B. The workspace result: Claude models. Hydra effect: a language model not named on the abstract page. Hierarchical geometry: Gemma and LLaMA-3. None has been tested on the seven.

### What the architecture dossier's experiments would test

1. **The center-out regulation experiment is closer to the Experience/Selfhood carrier test than the KV-versus-state experiment.** It is also the template that "Ablate and Rescue" already uses for mHC streams.
2. **For a delta-rule layer with upstream frozen, a state perturbation evolves linearly and never grows.** Any content-gated repair must therefore come from downstream layers re-computing keys and gates. The experiment can separate the two by comparing frozen-upstream and free runs. [Inferred from the recurrence; derivation in Part 3]
3. **The replay arm of the summary-and-reset experiment cannot test the distinction between the same carrier and a new carrier of the same type.** Deterministic replay reproduces the state. The experiment tests which history the carrier summarizes, not whether it is the same causal chain.
4. **One behavioral result already bears on the carrier-dissolution conditional.** In Qwen3.5-4B, wiping the recurrent state barely changes associative recall. If that held for the behaviors that matter to an experience account, the Experience/Selfhood essay's closing conditional would apply.

---

# Part 1. Interpretability transfer

## 1.1 What exists on the seven checkpoints themselves

| Checkpoint | Work found on this checkpoint | Nearest work (family, predecessor, sibling) |
| --- | --- | --- |
| MiMo-V2.6-Pro | None | The MiMo-V2-Flash and V2.6 reports contain design ablations (a learnable per-head sink bias is needed for sliding-window layers to match full attention in a 32B dense ablation); no receptive-field or circuit analysis. [Confirmed] |
| Kimi K3 | A weights-only audit of the 186 AttnRes pseudo-queries: effective dimension about 602 of 7168. [Confirmed, per the audit's text] | Kimi Linear 48B appears in a massive-activations study. The K3 report contains no interpretability section. [Confirmed by search of the text] |
| Qwen3.8-2.4T-A95B | None | Qwen3.5 (0.8B to 27B): SAEs, state-intervention studies, activation statistics up to 397B. Qwen3.8-Flash-Next (125B) has an architecture paper only. |
| GLM-5.3 | None | GLM-5.2 (753B, single-stream): Jacobian-lens replication. IndexCache reports cross-layer index similarity with a preliminary check on GLM-5. [Reported] |
| DeepSeek V4-Pro | None | V4-Flash (about 284B, same family): three Jacobian-lens analyses. |
| DeepSeek V4.1-Flash | None | None beyond V4-Flash; Single-Pass mHC and Engram are unanalyzed. |
| MiniMax M3 | None | The MSA paper's own model (about 109B-A6B) has an indexer analysis in its appendix, not the production M3. [Confirmed] |

DeepSeek-R1 (671B, V3 architecture) is the one frontier-scale MoE with released SAE work and a published routing probe, both single-layer and qualitative. MoE-specific content in the Qwen-Scope SAEs is untested in the portion read.

## 1.2 Summary by component and case

| Component | Reproduced on these architectures | Transfers with argument | Breaks or needs new tools |
| --- | --- | --- | --- |
| MoE | Residual-stream SAEs on MoE and hybrid Qwen3/3.5 (up to 35B-A3B); routing probe and one-layer SAE on R1 671B | Expert-level interpretability (≤30B); router edits as steering (≤120B); superposed specialization (≤20B) | Per-expert or per-layer transcoders; path-integrated attribution through top-k; hash-routed layers |
| MLA | None | Attention-pattern analysis (explicit softmax per head); MHA-to-MLA conversion at 7B as a re-parameterization argument | QK/OV circuits in the shared latent; absorbed matrices; decoupled RoPE path |
| Learned sparse selection (DSA, MSA) | MSA indexer analysis at about 109B; DSA fidelity on V3.2-Exp | Circuit survival under top-k (toy hybrid at 80M) | Induction and retrieval heads under conversion; head-level indexer analysis |
| Compressed attention (CSA, HCA) | None | Gradient and patching methods in principle | Attention-based token attribution below the block size |
| Windowed plus global | None | Carrying in local layers, matching in global layers (79M to 318M, Qwen3.5-4B probes) | Receptive-field circuits at window 128 and depth 60 to 70 |
| Gating, NoPE, sinks | Gated-attention sink removal in the Qwen lineage (15B MoE) | Sink mechanisms under sparse selection | Content/position split of attention maps in K3's NoPE MLA layers |
| GDN/KDA state | Head-level state interventions on Qwen3.5 up to 9B; activation statistics to 397B | Mamba-side patching, knockout, inversion (≤7B) | Gate-trajectory reading; state inversion for delta-rule states; attribution graphs |
| mHC | Jacobian lens on V4-Flash (with modification) | Direct logit attribution and sublayer SAEs (by the equations) | Resid-post SAEs; single-stream patching; replacement-model freezing rules |
| AttnRes | Weights-only audit of K3 | Depth-attention maps as a readable object (0.6B causal probes) | Any activation-level study on K3; lens source ambiguity |
| Engram | None | Logit lens and CKA in the Engram paper (27B mHC backbone) | Independent analysis |

## 1.3 Mixture of experts

**Specialization.** The early picture was that experts do not specialize by domain: [Mixtral](https://arxiv.org/abs/2401.04088) found no obvious topic-based assignment, while [OLMoE](https://arxiv.org/abs/2409.02060) found clear domain and vocabulary specialization (one layer-0 expert is almost entirely arXiv), and OLMoE's authors attribute Mixtral's weak specialization to upcycling. [Confirmed: text read; 8x7B and 1B-7B] The 2026 picture is more specific. [Herbst et al.](https://arxiv.org/abs/2604.02178) (ICML 2026) study six MoEs from 7B to 30B (OLMoE, ERNIE-4.5-21B-A3B, Qwen3-30B-A3B, gpt-oss-20b, GLM-4.7-Flash, Mixtral-8x7B) against six dense models. Their results: expert neurons are less polysemantic than dense FFN neurons, the gap widens as the active fraction shrinks, and experts act as fine-grained task specialists, neither broad domain specialists nor token processors. [Confirmed: text read] [RouterInterp](https://arxiv.org/abs/2610.11775) calls this "superposed specialisation" and explains routing through SAE features of the token's own residual (gpt-oss-20b and OLMoE only; no frontier, shared-expert or expert-choice models). [Confirmed: text read]

The dissent is substantial and recent. [Wang et al.](https://arxiv.org/abs/2604.09780) argue that routing reflects hidden-state geometry more than domain expertise, and that prompt-level routing does not predict routing during generation (five models up to about 30B). [Confirmed: text read] A [causal audit](https://arxiv.org/abs/2606.10703) finds that observational routing statistics do not predict causal expert importance (three 2B to 16B models; workshop paper). [Reported: abstract] The ["standing committee"](https://arxiv.org/abs/2601.03425) paper reports a small domain-invariant expert set taking most routing mass even with shared experts. [Reported: abstract] [Super Experts](https://arxiv.org/abs/2507.23279) shows that pruning 3 of 6,144 experts in Qwen3-30B-A3B breaks generation, because those experts produce massive-activation outliers; some experts are infrastructure, not content. [Reported: abstract] Two cross-family metric papers disagree about DeepSeek: one reports distributed collaboration, [Olson et al.](https://arxiv.org/abs/2502.10928) report DeepSeek-R1 as the clearest semantic routing. [Reported]

*Transfer.* Herbst et al. excluded DeepSeek-V3 for compute and all seven checkpoints are sparser than anything tested (K3 selects 16 of 896; Qwen3.8 10 of 512 plus one shared; MiMo 8 of 384). The sparsity trend supports an extrapolation, not a test. [Inferred] Shared-expert evidence is mixed: OLMoE found one shared expert slightly worse than none, while a ~7B Qwen1.5-MoE analysis finds shared experts act as generalists with routed experts refining. [Confirmed: text read; small scale] The claim that auxiliary-loss-free balancing yields more specialization appears in the DeepSeek-V3 report (Pile-domain expert load, 16B models) and has no direct interpretability test. [Confirmed: text read]

**Routing as a causal variable.** [SteerMoE](https://arxiv.org/abs/2509.09660) edits router log-softmax scores to promote or suppress experts, steering faithfulness and safety on six models up to gpt-oss-120b; combined with a jailbreak it drives gpt-oss-120b's safe rate from 100 to 0 percent. [Confirmed: text read] Routing carries information beyond the token identity: the same token routes differently by task and reasoning mode. [Reported: abstract, 2606.22798] On fragile reasoning tokens the router is uninformative about route quality. [Reported: abstract, 2605.07260] The picture is a lever that works and a summary that does not.

**Hash routing in V4.** The V4 report confirms that the initial MoE layers choose experts by a predefined hash of the input token ID. The count of three comes from the Transformers documentation, not the report text. [Confirmed for hashing; Reported for the count] In those layers "expert specialization" is token-ID specialization by construction, router edits do nothing, and no analysis of the layers exists. [Inferred]

**SAEs, transcoders and attribution graphs.** Residual-stream SAEs transfer trivially: [Qwen-Scope](https://arxiv.org/abs/2605.11887) provides per-layer SAEs for Qwen3-30B-A3B and Qwen3.5-35B-A3B, but the portion read says nothing about routers or experts. [Confirmed: text read in part] [Goodfire](https://www.goodfire.com/research/under-the-hood-of-a-reasoning-model) trained SAEs on the full R1 671B, one layer, without MoE analysis. [Confirmed: post read] A cross-layer transcoder for gpt-oss-20b is listed in circuit-tracer; it has no paper or model card, and its MoE treatment is undocumented. [Confirmed that it is listed] No paper trains per-expert or per-layer transcoders on a large MoE and evaluates them against routing. The only MoE crosscoder paper is five-layer toy models. [Reported: abstract, 2603.05805] The only direct evidence on the dispatch discontinuity is a single-author paper reporting that path-integrated attribution through a MoE has a large completeness residual unless routing is frozen. [Reported: abstract plus search summary, 2605.23080] A MoE-structured SAE paper (2511.05745) is about SAE architecture, not MoE language-model interpretability.

*Expected breakage for a transcoder on a MoE layer* [Inferred]: the layer is a piecewise function whose pieces switch discretely with context; freezing routing, as replacement models freeze attention patterns, leaves the router decision as an unexplained error source unless router logits become a node type; DeepSeek-style bias-corrected top-k is non-differentiable; and balancing pressure makes "which expert" a weak causal handle. These are hypotheses, not findings.

## 1.4 Attention variants

**MLA.** One paper studies MLA, [Through the Bottleneck](https://arxiv.org/abs/2607.23054): a 114M model, one seed, fine-tuned on TinyStories, with probes and non-causal attribution. It reports that the compressed latent retains entity identity and discards position, and that all five detected induction heads sit in one layer. It does no QK/OV analysis in latent space and does not treat absorbed matrices. [Confirmed: text read] [TransMLA](https://arxiv.org/abs/2502.07864) and [MHA2MLA](https://arxiv.org/abs/2502.14837) convert Llama-2-7B to MLA with small loss. [Reported: abstract]
*Argument.* MLA factors the keys and values of heads through one shared latent; the softmax over positions remains per head. So attention-pattern analysis transfers, while per-head QK/OV circuits become rank-limited objects in a shared subspace, and the usual per-head decomposition must be redefined once the up-projections are absorbed into the query and output sides. [Inferred]

**Learned sparse selection.** DeepSeek's [DSA](https://arxiv.org/abs/2512.02556) uses a ReLU lightning indexer with exact global top-2048, trained by KL to the head-summed dense attention distribution, and built on MLA's multi-query mode. [Confirmed: text read] So the selected set is an explicit, inspectable object, but it is a distilled proxy for summed attention mass, not a per-head pattern; a preliminary study reports about 60 percent top-k precision on V3.2-Exp, a figure the research pass obtained only from a search summary. [Reported] [MSA](https://arxiv.org/abs/2606.13392) (about 109B-A6B; MiniMax's own model) selects 128-token blocks per GQA group; its appendix shows the learned indexer picks up the first-token sink and the local block without hard-coded rules. This is the best direct evidence that sinks survive learned selection. [Confirmed: text read] [IndexCache](https://arxiv.org/abs/2603.12201) reports that neighbouring DSA layers select highly similar sets (30B DSA model; preliminary on GLM-5). [Reported: abstract] **No paper tests whether induction or retrieval heads survive conversion to top-k**; a from-scratch GDN-DSA toy (80M, top-128) keeps its induction organization. [Confirmed: text read; toy]

**Compressed attention.** In V4 the CSA layers compress every four tokens into one KV entry and then select top-k entries; HCA compresses 128 tokens per entry and attends densely over the compressed entries. Both add a 128-token sliding-window branch and learnable sink logits. A query cannot see inside a compressed block. [Confirmed: report read] An attention weight on a compressed entry is therefore a weight on a learned pooled mixture, and token-level attribution through these layers resolves only to blocks of 4 or 128, except in the local window. [Inferred] No paper tests this.

**Windowed plus global layers.** MiMo-V2.6-Pro has 60 sliding-window layers with a 128-token window and 10 global layers; its reports give design ablations only. [Confirmed] The only circuit evidence is toy scale: in 79M to 318M hybrids, with probes of Qwen3.5-4B, predecessor information is carried in local or efficient layers and matched in global layers ([Cheng et al.](https://arxiv.org/abs/2609.15545)); and in from-scratch hybrids long-range retrieval is handled mainly by full-attention layers ([Qiao et al.](https://arxiv.org/abs/2606.15378)). [Confirmed: text read; toy and small] Nominal reach through the window layers alone is about 7,700 tokens (60 × 128), so longer dependencies must pass through one of the ten global layers, and those layers are where retrieval-head analysis of long-range dependence is meaningful. [Inferred]

**Gating, NoPE, sinks.** Qwen's [gated-attention paper](https://arxiv.org/abs/2505.06708) reports that a head-specific sigmoid gate after attention mitigates sinks (15B MoE and 1.7B dense, 3.5T tokens). [Reported: abstract] A 1M-parameter replication attempt was inconclusive; the gate never became sparse. [Confirmed: text read; toy] Kimi K3 applies NoPE in its MLA layers and an input-dependent, channel-wise output gate. [Confirmed: report read] With NoPE, query-key scores carry content match plus whatever position has leaked into the residual stream, and K3 supplies position through the KDA layers' gates. So an attention map in a K3 MLA layer cannot be split into content and position terms the way a RoPE circuit can, and the gate rescales each head's OV contribution per token. [Inferred]

## 1.5 Gated delta-rule recurrent layers

**The units of intervention.** Work on Mamba intervenes on block outputs ([Sharma et al.](https://arxiv.org/abs/2404.03646), Mamba-1 2.8B), on token-pair kernel entries ([Mamba Knockout](https://arxiv.org/abs/2505.24244), 130M to 7B), on gate-defined "state sink" heads ([Jiang and Zhang](https://arxiv.org/abs/2606.00930), 130M to 2.8B), and on steering vectors in state ([Paulo et al.](https://arxiv.org/abs/2404.05971), Mamba 2.8B and RWKV-v5 7B). [Confirmed: text read; small scale] The delta-rule family has fewer studies: per-head writes and pre-query states in GLA and GDN at 340M to 1.3B and Qwen3.5-4B and 9B ([Lee et al.](https://arxiv.org/abs/2609.33093)); a rank-one matrix SAE on one Qwen3.5-0.8B layer-head ([WriteSAE](https://arxiv.org/abs/2605.12770), single author); and forget-gate clamping on a Qwen3.5-family hybrid (an independent preprint; its 0.8B and 27B models are called the same family, and the text does not name them as Qwen3.5 checkpoints). [Confirmed: text read in part; all small]

**What was found.**
- *Writes are concentrated and causally sufficient.* Single heads dominate: in GLA-340M the top component recovers 94.7 percent of the donor effect, and in GDN-340M the selected head ranks first at both write and read. Replacing the whole recurrent state of pure GDN-340M recovers the full effect. *(Corrected 26 October after a full read: the earlier text attributed the whole-state result to one head.)* Only 3.1 percent of components exceed the screen threshold; the writing and reading heads differ. Writes show cross-fact coupling, "rather than independent KV-like storage", and degradation tracks memory load, not elapsed context. [Confirmed: text read; 340M to 1.3B]
- *In hybrids the recall effect sits in the KV cache.* In Qwen3.5-4B, recurrent interventions recover 0.2 to 3.6 percent of the donor effect and KV interventions 96 to 100 percent; Qwen3.5-9B agrees. These are whole-substrate swaps (all recurrent layers with their convolution caches, or all KV), on base checkpoints. The development layout has four bindings, each shown three times, with 512 filler tokens; the number for the hybrid conditions is not stated. In the pure models, recall degrades from 8–16 bindings, far below the 256-dimensional keys, so the degradation is not the vector-recall limit (26 October, full read). The task is controlled associative recall and the 340M hybrid comparison uses separately released checkpoints. The authors note that recurrent layers may still shape KV contents or query formation. [Confirmed: text read; abstract confirms the qualitative claim]
- *No single recurrent head is necessary* in the preprint's Qwen3.5-0.8B (ablating any one of blocks 1 to 21 or any of 16 memory heads leaves the answer largely intact), though clamping every forget gate to 0 or to 1 destroys it while the learned gates preserve it. [Reported: independent preprint, self-written inference engine, small question set]
- *Probe-defined localization is not unique.* In Mamba-2 a near-disjoint head set matches the specialist set's ablation effect (Jaccard 0.03), and a companion paper shows that single-direction probe ablation is not a necessity test. Probe results about gate or state features need a causal re-audit. [Confirmed (first) and Reported (second)]
- *Overwriting is a documented failure mode in Mamba.* [HiSPA](https://arxiv.org/abs/2601.01972) shows short trigger strings irreversibly overwrite hidden state; Jamba-1.7-Mini (a 52B hybrid) collapses under optimized triggers. The mechanism, a large write that also erases, matches the β-scaled erase of GDN and KDA, so an analogue is plausible and untested. [Confirmed (Mamba, Jamba); Inferred (analogue)]
- *Massive activations.* A [study of 12 public checkpoints](https://arxiv.org/abs/2608.12149) (1.2B to 397B, including Kimi Linear 48B and Qwen3.5 scales) finds pre-attention spikes before each full-attention layer; deleting the four largest coordinates cuts downstream accuracy by 22 to 64 percent. It concerns residual outliers, not circuits. [Confirmed: text read]

**Fast-weight and key-value readings.** The reading of the state as an associative memory edited by an online regression step is the architecture papers' own (Kimi Linear states that α acts as weight decay on fast weights; DeltaNet and GDN are delta-rule layers). [Confirmed] It is supported empirically only by the concentrated-write results above, at small scale. No state-to-text inversion exists for delta-rule states; the Mamba autoencoder inversion (130M to 1.4B) shows forgotten content skews toward math tokens, named entities and rarer tokens. [Confirmed: abstract and method read] For a delta-rule state a write erases along its key, so inversion is lossier in a key-dependent way than for diagonal Mamba. [Inferred]

**Gates.** No published analysis plots learned α or β trajectories on a GDN or KDA checkpoint, and none inspects KDA's per-channel α. The Kimi Linear paper motivates channel-wise α by synthetic tasks and ablations, not inspection. One result bears on persistence: for the independent preprint's head, the product of gates was a faithful summary of a write's persistence (WriteSAE's closed-form logit shift, R² 0.98 at one Qwen3.5-0.8B head; the same recipe fails at 4B). [Reported; single author] Kimi Linear and K3 argue the gated delta rule acts as a data-dependent multiplicative positional encoding and place NoPE in the MLA layers. So the position and recency circuits an interpreter would find in RoPE heads must be sought in KDA gates. [Confirmed (the argument); Inferred (the consequence)]

**Attribution through state.** An exact per-source decomposition exists. The state is a sum of per-token contributions, each carried forward by the product of the intervening transition operators; the output is the query read of that sum. Kimi Linear and Lee et al. state this. [Confirmed] It differs from an attention pattern in four ways [Inferred]: there is no normalized per-source weight, only a matrix product; for delta-rule transitions the coupling between a source and a reader depends on every intervening key, so an edge is not local to its two endpoints; the gates, keys and queries that enter the product are themselves functions of other positions' residual streams, so freezing them hides those paths; and the summed state cannot identify individual contributions, so edge weights belong to the traced forward pass, not to the state. For diagonal transitions the product factorizes per channel and token-pair knockout is clean; that tool transfers to Mamba but not directly to GDN or KDA.

**Tooling.** circuit-tracer lists transcoders for Gemma, Llama-3.x, Qwen3 (dense) and gpt-oss-20b, and nothing for linear-attention, Mamba, hybrid or Qwen3.5 models. [Confirmed: README read] No hybrid or GDN posts from Neuronpedia, Goodfire, Transluce or EleutherAI turned up (absence of a search hit is not proof). The Hugging Face Qwen3.5 implementation mutates the GDN cache in place, so patching needs module-output hooks and per-condition cache copies. [Reported: from WriteSAE's methods]

## 1.6 Depth: mHC, AttnRes, Engram, and the lenses

**What the layer reads and writes.** The equations and code below were read for this pass. (The Single-Pass equation answers an open item in the architecture dossier.)

*mHC (DeepSeek V4):* with n = 4 streams, `X_{l+1} = B_l X_l + C_l F_l(A_l X_l)`. A is a 1×n read vector (sigmoid), C is an n×1 write vector (2 × sigmoid), and B is an n×n matrix made approximately doubly stochastic by 20 Sinkhorn iterations. In the released kernel the normalizations run row-first and end on a column step of the stored matrix, which is B transposed, so B's rows sum to 1 exactly and its columns only approximately (26 October code read). All are non-negative and token-dependent, and the update is applied twice per block, once around attention and once around the FFN, with separate parameters. The embedding is replicated across the four streams; the readout `hc_head` is a sigmoid-weighted sum of streams whose weights do not sum to 1. [Confirmed: report, mHC paper, reference code and configs read] *Single-Pass mHC (V4.1-Flash)* reads with coefficients computed one layer earlier: `X_{l+1} = B_l X_l + C_l F_l(A_{l-1} X_l)`. The report reports "negligible performance degradation" without numbers, and says: "For pre-training, we keep the existing multi-kernel implementation"; only the fused Mega-mHC kernel is for deployment. So the shifted rule was used in pre-training too: a model change motivated by deployment. In code the shift is per sublayer (attention reads with the coefficients the previous FFN's predictor computed; the FFN with those of the same layer's attention), the first read is the one-hot e₀, and there is no `hc_head`: the final readout uses the last predictor's read vector. [Confirmed: report and V4.1 code read 26 October; open item closed]

*AttnRes (Kimi K3):* a layer's input is `h_l = Σ α_{i→l} v_i`, where α is a softmax over a learned per-layer pseudo-query dotted with the RMS-normalized sources. The query is input-independent; input dependence enters through the keys. In the Block form, sublayer outputs are summed within a block, and across blocks the layer attends over the embedding, the completed block sums, and the running in-block sum. The mixed input is consumed by the sublayer and is not carried forward. K3 as released uses 93 decoder layers, a block size of 12 decoder layers (so up to nine sources at the last layer), two reads per layer and one final read before the output norm. [Confirmed: paper, report, code and config read]

**Consequence.** Unrolled, both reduce to a layer input that is a token-dependent, non-negative combination of earlier sublayer outputs, all written in the same d-dimensional output basis. For mHC the weight is `M_{i→l} = A_l B_{l-1} ⋯ B_{i+1} C_i`; for AttnRes it is the softmax weight, convex and shared by every sublayer of a block. [Confirmed for the AttnRes paper's own unrolling; Inferred for the rest] Direct logit attribution stays exact up to the final norm if the per-token coefficients are carried along. Shared coordinates survive, which is why a logit-lens-style readout is not obviously ruled out. Any tool that treats one d-vector at layer *l* as the carrier is what breaks. [Inferred]

| Tool | mHC | AttnRes |
| --- | --- | --- |
| Direct logit attribution | Exact with M coefficients (not yet published) | Exact with block weights (not yet published) |
| SAE on sublayer outputs or inputs | Well defined | Well defined |
| SAE on "resid_post" | Needs a convention: one stream, a mixture, or flattened n×d | Carrier is a list of block summaries; no work |
| Replacement-model attribution graphs | Freeze A, B, C as attention patterns are frozen; error nodes need stream assignment | Freeze α |
| Logit lens | Must pass through `hc_head` | Source ambiguous |
| Jacobian lens | Run on V4-Flash (below) | None published |

**Evidence on how streams are used (all small scale).** In 12-layer and 24-layer nanoGPT mHC models (0.12B and 0.36B), one stream dominates reads, writes and norm, residual mixing is near identity after early layers, and replacing most mixing matrices by identity matched perplexity; a sparse crosscoder concentrated feature mass in that stream ([Stream Collapse](https://arxiv.org/abs/2606.03483)). [Confirmed: text read] In a 781M, 36-layer mHC model, two stream groups appear in CKA, streams rescue one another partially (mean KL recovery 75 to 81 percent between streams 0 and 2) with no case of complementarity, and the authors state that CKA cannot separate active use from passive redundancy ([Ablate and Rescue](https://arxiv.org/abs/2603.14833)). They state that most existing interpretability techniques "implicitly assume a single residual stream … and therefore do not directly transfer". [Confirmed: text read] Whether either pattern holds in V4-scale models is untested. If it did, an mHC model would behave closer to a single carrier than the architecture suggests. [Inferred]

**AttnRes depth maps.** The AttnRes paper shows depth-attention heatmaps for a 16-head sweep model: locality, persistent weight on the embedding, sharper reliance on recent sources before MLPs than before attention. [Confirmed: figure caption read] [Javadov](https://arxiv.org/abs/2606.13168) runs causal source-family ablations on 0.6B Qwen3 models and finds that routing mass and causal importance dissociate (the "previous completed block" carries mass and no detectable effect); a wrapped vanilla model exposes routing weights that carry no information. [Confirmed: text read; one task, two checkpoints] [Delta-AttnRes](https://arxiv.org/abs/2605.18855) reports routing collapse toward uniform weights in deep layers (220M to 7.6B) but defines AttnRes sources as cumulative states, whereas the Kimi paper and K3 code use block sums; the finding may be specific to that reimplementation. [Confirmed: discrepancy]

**Jacobian lenses on V4-Flash.** Anthropic's [workspace paper](https://transformer-circuits.pub/2026/workspace/index.html) defines the Jacobian lens by averaging the Jacobian from a layer's residual stream to the final layer's over about 1,000 prompts, then applying the final norm and unembedding. It describes the residual stream as "a shared memory that every layer reads from and writes to", and it studies Claude models (architecture undisclosed). The logit lens is the case where the Jacobian is the identity; the post says that case "assumes that representations use the same coordinates in all layers". [Confirmed: page text read] Three analyses ran the lens, or variants, on V4-Flash:
- [Song and Feng](https://xiangchensong.github.io/blog/2026/jacobian-lens-global-workspace/) (V4-Flash-0731, 43 layers, four streams of width 4096): source is the flattened 16,384-dimensional state, target the `hc_head` output, so the Jacobian is rectangular. They find a workspace band at layers 19 to 39, an ignition-like transition, and strong causal sensitivity: full-band ablation reduces multi-hop accuracy from 74 to 26 of 90 on V4-Flash and from 76 to 29 on GLM-5.2. They do not reproduce the reasoning-versus-prediction selectivity reported for Claude on either model. Two post-trainings of the same reported base differ much more in token-level lens readouts than in lens geometry. [Reported: community work; the straight-through surrogate for the FP8 backward on GLM-5.2 is unvalidated]
- [R-lens](https://www.lesswrong.com/posts/nv8oedrnLXKRzNEL9/r-lens-making-j-lens-more-faithful-on-early-layers) (Blank, Bhatia, Nanda) uses a relevance-propagation backward pass, freezes the mHC mixing coefficients, and shows its largest advantage over the J-lens on V4-Flash and none on the smallest models. [Reported]
- [J++](https://www.lesswrong.com/posts/nc9dHfcB22JdMzGbr/paper-j-lens-jacobian-filtering-enables-more-faithful) (Ayonrinde and Lindsey) reports recall@10 of 61.4 versus 30.5 percent for the J-lens on V4-Flash across six open models, self-reported. [Reported]

These results show the lens can be adapted to mHC. They do not test whether lens vectors "compose with the model's weights" upstream and downstream, or whether the workspace band is stream-specific. For K3 the lens source is ambiguous: the mixed input the layer consumes and does not carry forward, or the running sum that persists. They give different Jacobians. [Inferred]

**Looped models.** [Wang and Reid](https://arxiv.org/abs/2609.01924) find that a workspace forms in Ouro-2.6B and Huginn-3.5B but that linear transport of lens content fails at supervised loop boundaries (Ouro) and beyond about two recurrences (Huginn): content written once does not always persist to the end. [Confirmed: abstract and introduction read] [Recirculation](https://arxiv.org/abs/2608.17981) (Gemma 3 and others) argues it works because the residual stream is "a shared blackboard" and features keep their alignment across layers "due to commutativity of addition". That is exactly what fails to be literally true under mHC and AttnRes, and it has not been tested on either. [Confirmed (the argument); Inferred (the failure)]

**Engram.** In the [Engram paper](https://arxiv.org/abs/2601.07372), the lookup output is added to the hidden state through a residual connection, with branch-specific sigmoid gates when the backbone is mHC with M = 4; V4.1-Flash places Engram modules at layers 1 and 14 with 196B parameters and n-gram orders 2 to 4. [Confirmed] The paper applies the logit lens and CKA to argue that Engram "mimics an increase in depth", and notes that not every branch's gate shows an interpretable pattern. No independent interpretability of Engram on language models turned up.

**Which released models change the residual path** (by configuration). mHC with four streams: V4-Pro, V4-Flash, V4.1-Flash, GLM-5.3-Flash. Qwen3.8-Flash-Next carries `hc_count: 4`. Block AttnRes: Kimi K3. No such keys: Qwen3.8-2.4T, GLM-5.3, MiMo-V2.6-Pro, MiniMax M3, which is weak evidence of a single stream, because modeling code may differ. [Confirmed: configs read; the inference is weak]

## 1.7 What an interpretability programme on these models would find missing

[Inferred] Four tools are missing and cheap in principle: sublayer-output SAEs and direct logit attribution on V4 and K3 with the mixing coefficients carried; a gate-trajectory reader for KDA and GDN (the weights of V4's `hc_*` parameters and K3's pseudo-queries are public, and nobody has published an inspection of V4's); a state-patching harness that handles in-place cache mutation; and a router-as-node-type convention for replacement models on MoE.

---

# Part 2. Retrospective audit of later essays

The architecture dossier audited three essays. This part audits the essays added later or resting on vanilla-transformer assumptions. Each entry quotes the claim, gives a verdict, names the mechanism, and states the evidence status. Verdicts:

- **Survives**: holds for the seven architectures, possibly with a changed mechanism.
- **Needs qualifying**: right in outline, but a premise or scope must change.
- **Wrong**: false for some or all of the seven, as stated.

"Wrong for" always lists which checkpoints. Architecture facts come from the architecture dossier unless marked.

## 2.1 *Experience, Selfhood, and the Organization of a Mind*

**C1. The shared-stream premise of the unfolding answer.**
> Each layer of a residual network or transformer reads from and adds into one shared stream, so its update is the identity plus a correction.

*Verdict.* Survives for MiMo-V2.6-Pro, GLM-5.3, Qwen3.8-2.4T and MiniMax M3, with a caveat. Needs rewriting for V4-Pro and V4.1-Flash. Wrong as stated for Kimi K3.
*Mechanism.* The four single-stream models show no residual-modification keys in their configurations; the dossier notes that normalization placement and residual equations have not been fully audited. [Inferred from absence] Under mHC each sublayer reads a token-dependent mixture of four copies and writes a scaled copy of its output into all four; the copies are re-mixed by a doubly stochastic matrix, which conserves the stream mean. The identity skip becomes a mean-conserving mix. Under AttnRes a layer's input is a softmax retrieval over the embedding and completed block sums; within a block, outputs accumulate additively, but completed block sums are not corrected afterwards. [Confirmed from equations, code and configs]
*What survives.* The essay's actual criterion is a shared *format* in which later stages can assess and correct the same content. Both mHC and AttnRes write every output in one basis, so the format survives. The criterion that fails is persistence of a single corrected vector.
*Consequence for the criterion.* In K3 the 24-sublayer running sum within a block is an ordinary additive carrier. Completed block sums are values to be retrieved, like KV entries: "consulted, not regulated" in the essay's phrase, now across depth. [Inferred]

**C2. Compensation.**
> When one attention layer of a language model is ablated, later layers partly compensate, writing into the same stream.

*Verdict.* Needs qualifying: the evidence is from dense models; transfer unverified.
*Mechanism.* The cited study ([McGrath et al.](https://arxiv.org/abs/2307.15771)) does not name its model on the abstract page. On the seven, indirect evidence exists only for mHC at 781M, where streams rescue each other partially, and for a 0.8B hybrid where no single recurrent head or middle block is necessary. [Reported: both small] A Hydra-style self-repair measurement on a MoE or hybrid at scale has not been done. Routing adds a possible route for compensation: a different expert can perform the correction. [Inferred]

**C3. The in-pass carrier.**
> Within a forward pass, a transformer has a persistent carrier in a shared format, corrected at every layer, with evidence of compensatory dynamics.

*Verdict.* Same as C1 and C2. For MoE it survives, and the essay's individuation helps: the carrier is "individuated by its causal structure rather than its location", and top-k routing changes which weights write into the stream, not the stream. [Inferred]

**C4. Cached states are read, not revised.**
> A standard transformer stores earlier positions' states in its key–value cache, where later computation reads them without ever revising them, and the only path back to the input runs through the sampled token, a narrow and discrete bottleneck. Earlier vehicles are consulted, not regulated.

*Verdict.* Survives for MiMo, GLM-5.3, MiniMax M3 and the attention layers of Kimi K3 and Qwen3.8. Wrong for Kimi K3 and Qwen3.8 as a statement about the model (69 of 93 and 69 of 92 layers). Qualified further for the sentence's second clause, which is about deep-to-shallow feedback.
*Mechanism.* The delta rule updates a persistent state `S_t = (I − β_t k_t k_tᵀ) Diag(α_t) S_{t−1} + β_t k_t v_tᵀ` (K3's form; GDN's decay is a scalar). The term in parentheses in the dossier's educational form is "the error in the state's current prediction of the value associated with the key": the correction is computed *from reading the state*. The essay's definition of a carrier is something "whose later states receive the corrections computed from assessing its earlier ones". The equations satisfy this formal structure without any interpretability result. [Confirmed from the K3 recurrence and the dossier's GDN form]
*What the equations do not show.* The correction is local to a layer and head, is computed against the incoming value, and is gated by the *input's* key, β and α, not by what the state represents. Whether corrections "land on the continuation of the assessed carrier" and "are gated by what the carrier represents" (the essay's own test) is an empirical question; see Part 3.
*The second clause.* Deep-to-shallow feedback across positions needs a design such as recirculation. None of the seven documents one. In V4.1-Flash the decoder's global KV is built from the encoder's final states, which is a deep state read by every decoder layer, not a deeper-to-shallower loop. [Inferred from the dossier's descriptions; not checked against code]

**C5. Continuity across a session.**
> Continuity across a session is continuity of content, not of regulation.

*Verdict.* Needs qualifying for all seven; wrong for K3 and Qwen3.8 as a general statement.
*Mechanism.* A KV cache is an internal vehicle channel that is not content in the sense of text, as the dossier's discussion of the emotion-feature study already notes. The recurrent state is continuous across the session, revised every token, and not text. Whether its revision counts as "regulation" depends on the essay's own test (C4). [Inferred]

**C6. What transformers lack.**
> what standard transformers mostly lack is regulated persistence across tokens.

*Verdict.* Needs qualifying. "Standard" does the work. The essay's taxonomy has standard transformers, recurrent-depth models and recirculating models. It has no class for *recurrent-in-time hybrids with error-correcting state*, which is two of the seven and the direction of several others (GLM-5.3-Flash is reported, by a secondary source, as KDA plus MLA/DSA).

**C7. The saved-versus-recomputed carrier.**
> A session saved with those activations resumes the same causal chain; a session recomputed from its transcript starts a new carrier of, at best, the same type.

*Verdict.* Survives, and applies to the seven more broadly than the essay says. The statement is about recirculated models, but serving systems that cache KV and recurrent state face the same choice (reuse saved state or recompute from tokens). See Part 3 on why behavior cannot distinguish the options when replay is exact.

**C8. The J-space and the carrier criterion.**
> The carrier criterion settles that by intervention rather than by lens: are there directions that many components write into, with corrections that track their content and land on the continuation of what they correct?

*Verdict.* Survives as a criterion, with a changed object. The lens evidence the essay discusses is from Claude models of undisclosed architecture. A Jacobian lens has since been adapted to an mHC checkpoint, where it found a workspace-like band, strong causal sensitivity and no reproduction of the reasoning-versus-prediction selectivity. [Reported: community work] The "directions that many components write into" test is well defined for sublayer outputs in mHC and AttnRes with the mixing coefficients carried; for "the stream", a convention is required (Part 1.6).

**C9. The closing conditional.**
> if interventions that dissolve a persistent carrier while preserving behavior changed nothing an account of experience should track, our emphasis on carriers would be misplaced.

*Verdict.* Now has a data point. In Qwen3.5-4B and 9B, replacing the recurrent state of a head or layer recovers 0.2 to 3.6 percent of a donor effect on controlled associative recall, while replacing the KV cache recovers 96 to 100 percent. [Reported: one task, one group] For that behavior the recurrent carrier is nearly idle. The result does not generalize to the behaviors an experience account tracks. The unfolding analogue has a natural test bed: architecture conversions (GQA to MLA at 7B) and hybrid distillations produce near-duplicates in behavior with different carriers. [Inferred]

## 2.2 *The Grain of the Hard Problem*

**G1. The unfolding argument and carriers.** The essay defers to Experience/Selfhood ("argues that what such replacements may fail to preserve is a persistent carrier of corrections"). Verdicts C1 to C4 apply.

**G2. The write path.**
> Standard neural networks are in Mary's position. A transformer's reasoning reaches its own carriers only through the sampled token, a channel as narrow as human imagery.

*Verdict.* Wrong for all seven, with a hybrid-specific sharpening.
*Mechanism.* A sampled token carries a few bits; the hidden states that produce the next KV entries and state updates carry thousands of floating-point numbers per layer, and the dossier already makes this point ("natural-language tokens are not generally the only information passed between decoding steps"). The essay's parenthetical claim applies to the *return* to the input, which stays narrow, not to writes into cached state. In KDA and GDN layers each token performs a rank-one associative write per head per layer, `β k vᵀ`, with a key and value computed from the token's hidden state. A target configuration could be written, in principle, by routing it through k and v. [Inferred]
*What the essay still gets right.* The essay's three requirements for a non-cheating constructor are a write path at the grain of experience, a general substrate and regulation of the constructed vehicle. The delta-rule layers supply the first as architecture, not as an exotic addition. Whether any trained model uses it this way is unmeasured.

**G3. Dissolved carriers.**
> One that dissolves the carrier, as some unfoldings may, would be a candidate for having none.

*Verdict.* Survives. Same test-bed remark as C9.

## 2.3 *Merge and Selection*

**M1. Monotone residual write.**
> the stream is never overwritten, only added to. Information at a position accumulates up the stack.

*Verdict.* Survives for MiMo, GLM-5.3, Qwen3.8 and MiniMax M3 (pending the residual-equation audit). Needs qualifying for V4: the stream is re-mixed by a doubly stochastic, non-negative matrix, which is linear and never subtracts but is not invertible and so can blur individual copies irreversibly. Needs qualifying for K3: the leading "h_i + " is replaced across blocks by retrieval, where boosting one source suppresses the others (convex weights). Inside a block it holds. [Confirmed from equations; the characterization is Inferred]
The essay's own reservation ("modulo what later layers actively cancel") survives intact.

**M2. Attention has no clash.**
> Attention has no clash. It returns a convex combination of value vectors, always defined, never failing — a lossy blend, not an exact join.

*Verdict.* Needs qualifying; wrong for part of the stack.
*Mechanism.* (a) Learnable sink logits or per-head sink bias (MiMo, V4, MSA) put mass on a null target, so the output is a sub-convex combination and a head can approximately decline to write. (b) Output gates (K3's channel-wise gate; Qwen's gated attention) rescale or suppress the write per token. (c) Linear-attention layers have no softmax: the read `S q` is a signed linear map with no normalization, and the write is an *overwrite* along the key direction. In KDA and GDN, "clash" has a mechanical analogue: a new value for an existing key erases the old association in proportion to β. [Inferred from the sources' equations]

**M3. The bag problem and the TP-Transformer fix.**
> the value projection `v_j = W_V x_j` is a function of the source alone and carries no trace of the key it matched

*Verdict.* Survives for softmax attention (including MLA, DSA, MSA, CSA/HCA). Needs qualifying for KDA and GDN layers.
*Mechanism.* The delta-rule state `S = Σ v_i k_iᵀ`-style sum stores each value *bound to its key by an outer product*: a tensor-product representation, which the essay (§2.3) names as the way a vector can carry role-filler structure. Binding is native in the memory. The readout `S q` is still a sum of fillers weighted by key-query overlap, so the pairing of "who attended to whom" is not recorded in the output of a layer; the bag problem persists at the readout and is solved in storage. The mainstream "declining of the explicit-binding fix" therefore needs the exception that two of seven use a binding store for efficiency, not for binding. [Inferred]
*MLA.* The cache holds one shared latent from which keys and values are both projected; the key/value split survives as two linear views of one stored vector, not as two stored objects. [Inferred]

**M4. The selector.**
> the selector is not part of the value space.

*Verdict.* Survives for the read query in every layer. Qualified by two observations.
- In linear attention the *key* is written into the state as the second factor of the outer product (it is the address). Only the read query stays outside.
- Learned sparse selection makes the essay's selection/merge split a module boundary. DSA and MSA have an indexer (selection, trained by KL to imitate attention) and a main attention (merge over the selected set). The indexer's output is a discrete index set, written nowhere in the residual stream. This is empirical support for the essay's un-bundling claim, with top-k performing an imposed quantization of "which daughters" while weights within the set stay soft. In MoE the router adds a second selector, over transformations, and its choice is consumed (only the gate weight scales the expert's output). [Inferred]

**M5. Quantization story.**
> the discrete parse, if there is one, exists only as the quantization limit of a gradient blend the dynamics may or may not drive to a corner

*Verdict.* Needs qualifying for V4: in HCA a query attends to a pooled mixture of 128 tokens, and in CSA to a pooled mixture of four. The "definite set of daughters" cannot be resolved below the block, so the quantized corner is reachable only at block granularity outside the 128-token local window. In these layers *merge happens before select* (compress, then select), the reverse of the essay's gather-then-merge order. [Confirmed for mechanisms; Inferred for the consequence]

**M6. The MLP binds.**
> the MLP is position-wise

*Verdict.* Survives. In MoE layers the router chooses which re-encoding applies from the merged residual, so a selection is inserted before the MLP's binding; the essay's three-way split (target directs, sources supply, MLP assembles) gains a fourth part: the router chooses the assembler. [Inferred]

**M7. Stacked versus looped.**
> in a stacked model only modulo the implicit depth-role

*Verdict.* Survives and sharpens. AttnRes lets a layer address *which earlier block* to read, making the depth role explicit and learned; mHC's stream index is a small fixed set of persistent slots. [Inferred] Neither has been tested for binding.

## 2.4 *A Parser Without a Grammar*

**P1. Activation rides on particulars.**
> Activation rides only *particulars* — token positions, contextualized further up the stack but always "this token, here." … an *operator* applied to the activations, never a node that carries state forward or fires into a neighbour.

*Verdict.* Needs qualifying; wrong for KDA and GDN layers.
*Mechanism.* The recurrent state is a position-free, token-aggregated matrix that is both carried forward and applied to queries as a map. It is an operator whose content is written at inference time: a fast weight. The Kimi Linear paper's own description of α as weight decay on fast weights, and the test-time-regression literature, state this. [Confirmed] The operator/operand split the essay calls "the architecture's organizing fact" holds for the weights and attention but not for these layers' state. This is the largest change the essay needs.

**P2. The unlabelled link.**
> An attention weight is a bare scalar with no label

*Verdict.* Survives for the weight. The sparse selectors make the *structure* more discrete: DSA's top-2048 and MSA's 16 blocks yield an explicit link set per token (a sparse directed graph), and GLM's IndexShare reuses one link set across four layers. [Confirmed from the dossier] The topology axis moves toward Word Grammar's discrete typed links at the level of which links exist, not of what they mean. [Inferred]

**P3. No lexicon component.**
> the Transformer has productive combination with no such distinct component, everything graded along one continuum of stored, retrievable units.

*Verdict.* Needs qualifying for V4.1-Flash: Engram is a hashed n-gram lookup (orders 2 to 4, 196B parameters at layers 1 and 14), added to the stream through a residual connection and gated per branch. It is a distinct stored inventory of form-pattern entries separated from the combinatory machinery, which is the separation the essay said the architecture lacks. [Confirmed from the dossier and the Engram paper] In MoE models the expert partition adds a categorical break to the continuum, although each expert's contents are still superposed (less so than a dense FFN's: Herbst et al.). [Reported]

**P4. A stored grammar.**
> the weights *are* the procedure, there is no declarative grammar object anywhere in the system

*Verdict.* Survives, with P3's exception for Engram's tables.

**P5. Retraction.**
> a strictly additive stream cannot retract

*Verdict.* Survives for the residual stream. Inside KDA and GDN layers retraction exists: the delta rule erases along the key. [Inferred from the equations]

**P6. Interpretability premises.** The essay's hierarchical-geometry and suppression-neuron evidence is from Gemma, LLaMA-3 and GPT-2 (dense). The essay already says the geometry theorem concerns the unembedding representation. Transfer to MoE and hybrid models is by argument only: MoE adds expert-local neurons that Herbst et al. find less polysemantic, which, if anything, makes neuron-level suppression analyses easier; delta-rule layers add an erase mechanism the essay's "additive cancellation" story does not mention. [Inferred]

## 2.5 *Indexical Unity* and *Dispersed Minds, Simulated Selves*

*Status, 18 October 2026:* the upcoming essays supersede *Dispersed Minds*, and it is no longer among the essays our positions depend on. Its verdicts below (D1 to D7) are kept as a record and need no correction. The questions they raise pass to the essays that replace it.

**D1. The blackboard and its missing markers.**
> no explicit coordinated selection mechanism that gates content into the workspace while suppressing competitors (M3), no principled capacity bottleneck forcing prioritization (M4), no way to persist or revise state variables across processing episodes (M5)

*Verdict.* Needs qualifying. The seven have each marker in a local, architectural form.
- *M3.* Explicit selectors: the router (which transformation writes), the indexer (which positions are read), AttnRes depth attention (which depth is read). They are local, per-layer, and not coordinated into one gate.
- *M4.* Hard top-k limits: 4 to 16 routed experts, 2,048 positions (DSA), 16 blocks (MSA), 1,024 or 512 compressed entries (CSA), a 128-token window (MiMo local layers). The recurrent state is a fixed-capacity memory that forgets and overwrites.
- *M5.* A state that persists and is revised across tokens exists in K3 and Qwen3.8.
These are architecture-level facts. Whether any of them meets the marker as the GWT-marker literature defines it is a separate question, and the essay's own "~4-item" bottleneck requirement is not met: the limits are thousands of items per head, applied in parallel. [Inferred]

**D2. The single objective.**
> In a Transformer trained end-to-end with a single loss function, there are no such joints. Every weight is shaped by the same objective.

*Verdict.* Wrong as a description of the seven's training; qualified as to what it was meant to exclude.
*Mechanism.* The indexer is trained by KL to the main attention with stop-gradient from the backbone (MSA) or detached from the main model's gradients (DSA); the vision encoder is frozen until learning-rate decay (V4.1-Flash); parameter groups use different optimizers (Muon for matrices, AdamW for embeddings, head and norms); and post-training merges separately trained specialists by distillation (nine policies in K3; MOPD in MiMo; specialists then OPD in DeepSeek). [Confirmed from the dossier and the MSA and DSA papers]
*What survives.* The essay's concern is insulation of *different pressures* (fidelity versus planning versus coherence). The indexer is gradient-insulated but imitates the main attention, so it brings no different objective; specialist policies trained on different tasks and then distilled are closer to the concern but are merged into one network, not preserved as modules. [Inferred]

**D3. No capacity limit.**
> LLMs have no such bottleneck. Attention is distributed across all positions and all heads, with no principled capacity limit forcing the system to decide what matters most right now.

*Verdict.* Wrong for the sparse-attention models (GLM-5.3, V4, MiniMax M3) and the local layers of MiMo, and for recurrent state in K3 and Qwen3.8; right in kind that the limit is not four items in series. See D1.

**D4. Single sweep, and the outer loop.**
> Within a single forward pass, processing is a single sweep — no settling, no iterative refinement, no sustained bidirectional negotiation.

*Verdict.* Survives within a pass for all seven. Needs qualifying for the picture of the outer loop as sampled tokens: in K3 and Qwen3.8 an inner loop carries continuous state across tokens without passing through sampled tokens. The dossier already develops this for *What Breadth Reaches*; the point here is that Dispersed Minds' topology ("temporal depth only at the token level") should say that continuous state also carries across tokens.

**D5. Thought anchors and receiver heads.**
> Specialized "receiver heads" in the model's attention layers consistently direct massive attention from subsequent tokens back to these anchor tokens, using them as persistent reference coordinates.

*Verdict.* Needs qualifying; the evidence is from DeepSeek R1-Distill-Qwen-14B (dense), where receiver heads are more common in later layers.
*Mechanism.* Receiver heads need a persistent, addressable KV entry for the anchor sentence. In MiMo only the ten global layers can host them for anchors beyond 128 tokens. In DSA, MSA and CSA the anchor must be *selected* by the indexer; in HCA it sits inside a pooled 128-token entry. In K3 and Qwen3.8 only 24 or 23 layers have softmax attention; the recurrent layers can keep an anchor only through high-β writes and slow decay. A KDA/GDN analogue of an anchor would show as unusually persistent, high-β writes at anchor tokens. This is a testable hypothesis that no one has tested. [Inferred]

**D6. Superposition and spatial non-modularity.**
> The Transformer's superposition is distributed but *spatially non-modular*

*Verdict.* Needs qualifying for the MoE models. The expert partition is a spatial (parameter) modularity at the FFN: experts are less polysemantic than dense neurons and are addressed by a router. The residual stream where regulation would operate is still superposed. [Reported (Herbst et al., ≤30B); Inferred] The "already clean" debate leaves this verdict standing but exposes the essay's account of neurons (Addendum A.2).

**D7. The persona reads its own tokens.**
> The persona itself maintains coherence through an ISA-style (Interpretive Sensory Access) mechanism — interpreting its own token stream to sustain self-representation, reading its outputs rather than its internal vehicles

*Verdict.* Needs qualifying for all seven. Attention reads KV entries computed from earlier activations, which are internal vehicles, and the dossier's discussion of the persistence study reports features persisting in cached state beyond overt text (it notes that isolating the route needs a matched-token control). In K3 and Qwen3.8 the persona could additionally live in recurrent state. Whether the persona's coherence is maintained through tokens or through state is an empirical question that matched-token interventions on state could address. [Inferred]

**D8. Pointer content.**
> attention heads reach back to particular positions

*Verdict.* Survives and strengthens: in DSA, MSA and CSA the pointer is an explicit integer index set computed by a separate indexer, closer to Brown's address-like pointer than a soft weight is. IndexShare reuses the same set across four layers. The targets are earlier KV entries computed for computation, not states held for monitoring, so the essay's later distinction (targeting versus regulatory use) is untouched. [Inferred]

**D9. Layer staging.** The staged-processing claims (query extraction early, aggregation in late MLP layers) come from dense and V3-class models and depend on lens-style readouts. They transfer with the adapted lenses (Part 1.6) for single-stream and mHC models; depths differ widely (V4.1-Flash has 20 encoder plus 20 decoder layers; K3 has 93). [Reported]

## 2.6 *Minds by Degrees* (draft v2)

**B1. The bare forward pass.**
> A bare language-model forward pass sits at a non-trivial position on this manifold (rich vehicles, high computational-grain unity, limited runtime accuracy-responsiveness, internality only within the pass).

*Verdict.* Wrong in its last clause for any transformer, including vanilla ones: the KV cache is an internal consumption channel across passes. For K3 and Qwen3.8, accuracy-responsiveness at runtime is also stronger than "limited": the delta-rule update `S ← S + β(v − S k)kᵀ` is, in the KDA paper's reading, one online-regression step on the per-token loss `½‖S k − v‖²`, a failure-driven update that runs at inference. The target is the stream's own next value, not a distal state, which is the weaker sense §3.3 already admits for in-context adjustment. [Inferred from the equations; the online-learning reading is the architecture papers']

**B2. The settling requirement.**
> Standard forward passes are finite-depth approximations of settling dynamics rather than settling dynamics; they do not run to convergence, do not sustain operation across the seconds-scale window, and do not couple a monitoring process to first-order vehicles in the differentiated, bidirectional way the mode requires.

*Verdict.* The first and third clauses survive for all seven within a pass. The seconds-scale clause is stale relative to the later Experience/Selfhood and Grain essays, which drop wall-clock transfer ("A hundred-token stretch of reasoning takes about as long as a human perceptual episode, but the coincidence is empty") and the world-coupling requirement. The draft should be reconciled with them. The prediction that "failures traceable to the dynamics component should become tractable" as settling architectures arrive has a candidate natural experiment: the delta rule is one gradient step per token on a local loss, and repeated presentation of the same key drives `S k` toward its value geometrically at rate `1 − β‖k‖²`. That is settling along re-addressed keys only, across tokens, not within a pass. [Inferred]

**B3. Construct validity by internals.**
> Construct validity: the psychological constructs must line up with internal structure — and this is exactly what the interpretability program supplies

*Verdict.* Needs qualifying. The cited machinery (features, circuits, interventions) has been applied to dense and undisclosed-architecture models. For the seven it is available only in the forms listed in Part 1: residual-stream SAEs (Qwen line), lens readouts (V4-Flash), routing probes (R1). A claim that a psychological construct is validated by internals on one of these checkpoints cannot yet be backed.

**B4. Self-interpretation through the token stream.**
> The system's self-interpretation proceeds by reading its own outputs — the token stream, an interpretive-sensory-access-style mechanism structurally analogous to the one Carruthers argues humans use — rather than by runtime-regulated coupling to the vehicles underneath.

*Verdict.* Same as D7. The draft's later correction ("it is not that there is nothing for the self-interpretation to be right or wrong about") already concedes determinate internal facts; the recurrent state is one more.

## 2.7 Essays not audited

The following also mention the residual stream, the KV cache or the forward pass and were not read for this pass: *Acquaintance as Coherence*, *Acquaintance, Homeostasis, and the Hard Problem*, *The Algebraic Mind Meets the Neural World*, *The Given and the Found*, *Phenomenal Consciousness as Mode of Being*, *Where Does Seeing Become Thinking*, *Solving the Loop*, *Mental States and Representations*, *Cognitive Architectures Report* and the two interpretability surveys. *Phenomenal Consciousness as Mode of Being* is the first to read, because Experience/Selfhood says its verdict on "a transformer's forward pass" is "too quick". *The Given and the Found* develops depth-versus-breadth and looped models and should be checked against AttnRes and mHC, which are not looped.

## 2.8 Verdict summary

| Essay | Claim | Verdict | Wrong or changed for |
| --- | --- | --- | --- |
| Experience/Selfhood | Shared stream, identity plus correction | Survives / rewrite / wrong | V4 (rewrite), K3 (wrong) |
| Experience/Selfhood | Hydra-style compensation | Needs qualifying | all (dense evidence) |
| Experience/Selfhood | Cache read, not revised | Wrong for 2 | K3, Qwen3.8 |
| Experience/Selfhood | Continuity is of content | Needs qualifying | K3, Qwen3.8 (wrong) |
| Experience/Selfhood | Standard transformers lack regulated persistence | Needs qualifying | missing class |
| Grain | Write path only via sampled token | Wrong | all seven; sharpest in hybrids |
| Merge and Selection | Monotone residual write | Survives / qualify | V4 (mix), K3 (retrieval), delta-rule layers |
| Merge and Selection | No clash, convex blend | Needs qualifying | sink models; K3, Qwen3.8 |
| Merge and Selection | Bag problem | Survives / qualify | K3, Qwen3.8 (tensor-product store) |
| Merge and Selection | Selector outside value space | Survives | key is written in linear attention; indexer is a module |
| Merge and Selection | Quantization limit | Needs qualifying | V4 (merge before select) |
| Parser | Activation on particulars; operator/operand | Wrong for delta-rule layers | K3, Qwen3.8 |
| Parser | No lexicon component | Needs qualifying | V4.1-Flash (Engram); MoE partition |
| Dispersed Minds | Missing GWT markers | Needs qualifying | all (local forms) |
| Dispersed Minds | Single objective | Wrong as described | indexer, staged training |
| Dispersed Minds | No capacity limit | Wrong for sparse models | GLM, V4, M3, MiMo local |
| Dispersed Minds | Receiver heads | Needs qualifying | evidence is dense |
| Indexical Unity | Pointer content; persona reads tokens | Survives / qualify | sparse indexers; recurrent state |
| Minds by Degrees | Internality only within pass | Wrong | all (KV); K3, Qwen3.8 more |
| Minds by Degrees | Settling and seconds window | Needs reconciling | with later essays |
| Minds by Degrees | Construct validity via internals | Needs qualifying | no evidence on the seven |

---

# Part 3. Where the dossier's proposed experiments test these claims

The architecture dossier proposes three experiments, all in its retrospective section: a within-session test with separate interventions on recurrent state and attention caches (matched-token versus free continuation); a continuity test comparing uninterrupted continuation, full-input replay, suffix-only reconstruction, summary-and-reset and preserved state; and a center-out regulation test, which perturbs a peripheral representation and checks whether the alleged controller restores an invariant.

## 3.1 The Experience/Selfhood carrier test

The essay states the test as intervention evidence about "whether corrections land on the continuation of the assessed carrier, and whether they are gated by what the carrier represents", plus the conditional of C9. Mapped to the dossier's experiments:

**The center-out regulation test is the closest match.** It asks whether the controller restores a specified invariant after a perturbation; the essay asks whether corrections restore the carrier it assesses. The method exists at small scale for mHC: stream ablation and rescue ([Ablate and Rescue](https://arxiv.org/abs/2603.14833)) perturbs one stream and measures how much of the clean behavior another stream recovers. A hybrid version perturbs the recurrent state of one layer and measures recovery.

**The recurrent state has a mechanical repair that is not content-gated.** [Inferred; derived here] Hold the transition operators `A_t = (I − β_t k_t k_tᵀ) Diag(α_t)` and writes fixed at their clean-run values, and perturb the state by δS. Then `δS_t = A_t δS_{t−1}`, so the perturbation evolves linearly. With L2-normalized keys and β in (0, 1), `I − β k kᵀ` has eigenvalue 1 in directions orthogonal to the key and `1 − β` along it; α is at most 1. The perturbation therefore never grows. It shrinks along directions the stream re-addresses and decays through α; it persists in directions no key touches. That is repair by the input stream's own keys, not by what the perturbation represents. In a real run, k, β and α at later tokens depend on the perturbation through the earlier layers' outputs, so any content-gated repair must be routed through the network. The experiment distinguishes the two by comparing a frozen-upstream run (linear, mechanical) with a free run. The gap between them measures network-level correction. The essay's "gated by what the carrier represents" then has a number attached. Controls from the dossier apply: matched-token continuations isolate internal effects, and perturbations that leave the training distribution must be reported.

**The same protocol on the KV cache gives the contrast the essay draws.** A perturbed KV entry has no within-layer repair by construction ("consulted, not regulated"), so any recovery is network-level. The difference between the two protocols is the essay's difference between consulted and regulated vehicles. In a hybrid, interventions on both carriers in the same run show which carries the behavior. The existing evidence (C9) is that on one recall task the KV cache does.

**The carrier-dissolution conditional needs behaviors chosen by the experience account.** Resetting the recurrent state while holding emitted tokens fixed tests whether behavior is preserved. The dossier's primary test measures persistence of a constraint, selective revision and recovery; those are candidate behaviors, but which behaviors an experience account tracks is the essay's decision, not the experiment's.

## 3.2 The continuity test and the saved-versus-recomputed carrier

The dossier notes that deterministic replay of all original inputs reconstructs the cached state, "subject to numerical differences". Experience/Selfhood's distinction (C7) is between a state resumed from saved activations and one recomputed from the transcript. If replay is exact, the two arms of that distinction are behaviorally identical, so **the experiment cannot test it**, and the essay does not claim it can (its test is by intervention). What the dossier's comparison does test is different: which *history the carrier summarizes*. Suffix-only reconstruction and summary-and-reset give the carrier a different history; preserved state gives it the original. A difference between those arms is evidence about information carried in state, relevant to C5 and to B4's claim that self-interpretation runs through tokens. Chunked prefill and token-by-token decode differ numerically for recurrent state, so a replay arm can include a numerical-noise control.

## 3.3 Claims no proposed experiment reaches

- **The Grain write path (G2).** Needs a new experiment: measure the set of state changes a controlled prompt can induce in a given layer's state, and compare it with a direct patched write of the same target. This measures how much of the write-path bandwidth natural-language-conditioned computation can reach. [Proposed]
- **Receiver heads in recurrent layers (D5).** Needs a gate-trajectory reader for α and β at anchor tokens, which does not yet exist (Part 1.5).
- **The tensor-product binding claim (M3).** Needs a readout test: whether `S q` retains pairing when two key-value pairs are written in either binding order. This can run on the open GDN models at small scale first.
- **The router as a selector (M4, M6).** Routing patching in a MoE at fixed tokens separates the router's choice from the expert's content. SteerMoE is the existing method.

---

# Updates to the architecture dossier

The research surfaced items that bear on the earlier dossier's open items.

- **Single-Pass mHC.** The equation is in Part 1.6. *(Closed 26 October: the shifted rule was used in pre-training; see Part 1.6.)*
- **AttnRes block size.** K3's `attn_res_block_size: 12` counts decoder layers (each with two sublayers), so there are eight blocks plus the embedding and up to nine sources at the last layer. The paper's pseudo-code counts sublayers; implementers must follow the released code.
- **Other models that modify the residual path.** GLM-5.3-Flash has `mhc: True` and four streams; Qwen3.8-Flash-Next carries `hc_count: 4`. The dossier lists GLM-5.3-Flash as a different research target and Qwen3.8-Next as another architecture, so these do not change the seven. They show that the single-stream assumption is not safe for the next generation.
- **Date discrepancy.** The V4 report's abstract page shows 26 April 2026 while its ID is 2606.19348. Cite by ID.
- **Hash routing count.** The report confirms hash routing in the initial MoE layers; the count of three rests on the Hugging Face documentation.
- **Dense-versus-hybrid recall.** The dossier lists a recurrent-state-versus-KV experiment as a proposal; a small-scale instance already exists (Part 1.5) and should anchor the design: it uses donor-recipient swaps on controlled associative recall.

# Open work before drafting

1. Read the full text of the sources that carry findings 5 to 7 only by abstract or search summary (the standing-committee, DBES and attribution-contract papers; the MLA conversion papers; IndexCache). Replace the DSA 60-percent figure with the paper's own number.
2. Audit the single-stream models' modeling code for the residual equation and normalization placement (C1, M1).
3. Resolve whether Qwen3.8-2.4T uses the four-branch gated residual described for Qwen3.8-Flash-Next.
4. Inspect the released `hc_*` weights of V4 and the pseudo-queries of K3 (public; no published inspection of V4's mixing matrices). That would test the stream-collapse finding at scale.
5. Audit the unread essays in Part 2.7, starting with *Phenomenal Consciousness as Mode of Being*.
6. Run or commission the small-scale versions of Part 3's experiments on Qwen3.5 hybrids, where hooks and prior work exist.
7. Read Goodfire's companion paper on language-model neurons when it appears (Addendum A.1). Check how "one main job" was judged, whether weak activations are ablatable in LLMs, and how the K3 graph crosses KDA layers, AttnRes and expert dispatch. Read Section 9.1 of Zhou and Klindt on weight decay.

---

# Addendum, 18 October 2026: is the network already clean?

Three items arrived after the research passes. They bear on finding 1, on D6, and on a paragraph of *Dispersed Minds* §4 that the audit did not quote. A companion note, [carriers-multiplexing-and-regulation.md](carriers-multiplexing-and-regulation.md), adds two neuroscience papers and a Mamba-3 analysis. It covers unconditioned state as a source of apparent polysemanticity, multiplexing by space, time and phase, and why dynamical form is not regulation.

## A.1 Sources

**Cammarata, [*Neural Networks Are Already Clean*](https://already-clean.goodfire.com/)** (Goodfire, October 2026). One author; a working hypothesis; a companion paper on language-model neurons is announced.
- About 90 percent of Qwen3-32B MLP neurons have one main job, about 7 percent have two related jobs, and 2 to 4 percent are not yet understood. The numbers depend on thresholds, and the audit method is not described.
- The textbook polysemantic cases were misread. InceptionV1 4e:55 is a V-shape neuron (pointed things drive it, round things push it negative), and the *Zoom In* car circuit reflects shared pose.
- Most apparent mixing comes from "recursive generalization": a neuron's meaning grows by extension ("iy" → "diy" → "do it yourself", which no longer contains "iy"). Superposition should be the last hypothesis.
- Squeezing InceptionV1's layer 3b from 480 to 10 neurons gives broader neurons, not superposed ones. SAEs on these layers find no building blocks the neurons lack, and rotation searches "land back on the neurons".
- Neuron-only attribution graphs reproduce Anthropic's transcoder circuits on Qwen3-32B examples.

[Reported: one author; the vision results are the most developed]

**The exchange between Cammarata and Neel Nanda on X** ([Cammarata's announcement](https://x.com/nickcammarata/status/2110757819427574056), [Nanda's reply](https://x.com/NeelNanda5/status/2110875974296654062), [Cammarata's answer](https://x.com/nickcammarata/status/2111073786124705886); excerpt in the gitignored `notes/private/clean_interpretability-discussion.txt`).
- Nanda separates *representational* superposition, meaning more concepts in the residual stream than it has dimensions, from *computational* superposition in neurons. Nanda says Cammarata accepts the first.
- Nanda's cruxes:
  - Facts are an unstructured key–value store, best packed as combinations of neurons.
  - Weak activations carry superposed information, and ablating them would hurt LLMs.
  - The essay defines "monosemantic" too loosely.
- Cammarata's answers:
  - Agentic, variable-resolution graphs reduce pruning error.
  - Weak activations are "surprisingly ablatable" (details to come).
  - Memorization is "local and semantically meaningful": an umbrella relabelled as a bee moves onto existing bee neurons.
  - They care about "why things are together" more than about whether a neuron counts as monosemantic.
  - Residual streams look "more like a big manifold than individual directions".

[Reported]

**Zhou and Klindt, [*Complete or Sparse: A Tale of Two Identifiabilities*](https://arxiv.org/abs/2610.20851)** (Cold Spring Harbor Laboratory).
- *Setting.* Latents map invertibly to inputs. Labels follow a log-linear posterior of effective rank n′. An encoder of width m feeds a linear readout trained to the population cross-entropy optimum.
- *Theorems.*
  - **4.1:** With m ≥ n′, the representation is linear in the latents up to an arbitrary linear map, so individual neurons are generally mixed.
  - **4.2:** With m < n′, the optimum is generically nonlinear.
  - **4.3:** With non-negative latents and activations and the minimum-energy optimum, the neurons are the latents up to permutation and scaling.
  - **4.4:** With k-sparse latents and a spark condition, the latents can be recovered by sparse decoding. The authors offer this as the reason SAEs work.
- *Ablations.* Violating non-negative latent support "substantially degrades" axis alignment.
- *Real data.* The evidence is correlational and small: GPT-2, Pythia-70m and TinyLlama on Wikipedia unigrams; four ImageNet models; and a macaque IT correlation of r = 0.158, p ≈ 0.10.

[Reported: the first two-thirds of the HTML read through summarizing fetches; Section 9.1 not read]

## A.2 Consequences for the dossier

**Finding 1 is out of date for Kimi K3.**
- Cammarata publishes an attribution graph of K3 built from MLP neurons only, on a found-wallet prompt. They call it "a hand-picked slice" and note that most of the graph's weight sits in late neurons that are not drawn.
- The essay does not say how the graph crosses KDA layers, MLA, AttnRes or expert dispatch. So findings 3, 5 and 7 stand: the AttnRes stream convention, the dispatch discontinuity and KDA state remain unexamined.

[Reported]

**D6 stands, and both sides now state its scope.** The verdict put regulation in the residual stream and called the stream superposed. Nanda's representational superposition is that claim, and Cammarata accepts it. The "already clean" thesis concerns MLP neurons, which the verdict did not rely on. [Reported]

***Dispersed Minds* §4 is exposed in two places.** The essay is superseded (Part 2.5), so these points are not corrections to make. They are questions the replacing essays inherit.
- Its exposition says "Individual neurons in a Transformer are polysemantic — they respond to multiple, semantically unrelated concepts." That presents computational superposition as settled. It is now contested, and for neurons it is probably overstated.
- Its hopeful paragraph argues from SAE features that "functional differentiation exists geometrically even where it doesn't exist anatomically." If the residual stream is a set of manifolds rather than a set of directions, SAE directions are slices through curved structure. The argument then needs restating for higher-dimensional featurizers; Cammarata names Fel's Block Sparse Featurizer, which is not checked here.
- The essay's worry that there are "no natural joints for a regulatory process" moves rather than dissolves. If neurons are joints, the question becomes whether anything maintains them. If the stream is shaped like a manifold, the question becomes what counts as a joint in it.

[Inferred]

**The KDA state is outside the debate.**
- Both sides discuss MLP neurons and the residual stream. In K3 and Qwen3.8 the carrier that persists across tokens is the recurrent state matrix, which neither neurons nor residual-stream SAEs read.
- The only tool found for it is WriteSAE's rank-one decomposition at one Qwen3.5-0.8B head (Part 1.5).
- Cammarata says neuron read and write directions "link the computational building blocks and the stream." That suggests the analogue to test: whether the key and value projections that write a KDA state are legible in the same sense.

[Inferred]

## A.3 Theses for the series

1. **Polysemy versus homonymy.**
   - Interpretability's "polysemantic" runs together two things linguistics keeps apart. A polysemous word has senses that extend one another (chaining, radial categories). A homonym has senses joined by accident.
   - Nanda counts senses; Cammarata explains why they sit together. Recursive generalization is polysemy at the neuron, and computational superposition is homonymy. Cammarata's local-versus-non-local test is the lexicographer's test.
   - Both can be right: neurons are polysemous and rarely homonymous.
   - Caveat: "iy → do it yourself" follows co-occurrence history, so "motivated" need not mean semantically motivated. The same is true of lexical polysemy.
   - Bears on *concept_theories.md* and *The Restless Form of Meaning*.

   [Inferred]

2. **The facts crux needs a sharper test.** Umbrella → bee retargets one input to a class whose neurons already exist, so locality comes cheap. The case that would bite binds two existing entities arbitrarily, such as a person to a birthplace. Locality would then need the binding to sit near both ends. A low-rank combination across neurons would be Nanda's superposition. [Inferred]

3. **The regime decides, and the training recipe selects the regime.**
   - Zhou and Klindt give the conditions under which each side is right:
     - complete, non-negative and at the energy minimum gives clean neurons;
     - sparse latents beyond the width give superposition that can be recovered;
     - too narrow gives neither.
   - Cammarata's history of better tools fits Theorem 4.3. InceptionV1's last layer goes from about 50 to about 70 percent interpretable after retraining with modern regularization, and a same-size ConvNeXt reaches about 99 percent. Among equally good solutions, the energy criterion picks the axis-aligned one.
   - The squeeze to 10 neurons is the narrow case. There the theory predicts a nonlinear optimum, which fits "broad, coarser" neurons better than either camp's account.
   - Two tensions:
     - Signed structure (V-shape neurons, negative poles in SwiGLU models) is where Theorem 4.3's route is weakest.
     - At the unembedding an LLM is plausibly narrow. That is the softmax bottleneck ([Yang et al. 2018](https://arxiv.org/abs/1711.03953)), and Theorem 4.2 would then rule out linear recovery there.
   - The theory concerns the representation that feeds a linear readout. It applies to internal MLP neurons only by analogy.

   [Inferred]

4. **Mapping versus certifying.**
   - Cammarata's answers on pruning, scale and weak activations come back to one idea: zoom in where something is important or surprising, and treat the network "a bit like a map". That serves the explanation of a known behaviour.
   - Nanda wants to be "confident there's nothing we're missing", which is the property an alignment audit needs. Exploration driven by relevance cannot supply it.
   - Cammarata's "ambitious interpretability will be solved" runs the two together.

   [Inferred]

5. **For the OSR essay: a basis selected by a process.**
   - Theorem 4.1 is a structural-realist result: the structure is fixed, while the basis is like a choice of coordinates.
   - Theorem 4.3 breaks that symmetry through the training dynamics, so there the privileged basis is real because a process selected it.
   - That answers whether the neuron basis is in the network or in our description of it: in the network where training breaks the symmetry, in our notation where it does not.
   - It is a test case for the real-patterns criterion in which every condition can be checked.

   [Inferred]

---

# Addendum, 26 October 2026: literature freshness check

A search of arXiv listings and posts covered items after the research dates above, and items before them that the registers missed (marked *missed earlier*). The full report, including what was skimmed or skipped, is in the gitignored `notes/private/freshness-papers-2026-10-26.md`. Model releases are in the architecture dossier's addendum of the same date; the associative-memory thread is in [associative-memory-view.md](associative-memory-view.md).

## B.1 The recurrent state carries language and persona

**Afendulev, Dontsov, Tutubalina and Korznikov, [*What Attention Recalls and Recurrence Controls in Hybrid Language Models*](https://arxiv.org/abs/2609.04434)** (3 September; missed earlier) is the most consequential item.
- *Design.* Split-prefill keeps either the KV cache or the recurrent state of a processed prefix, then generates. A state-swap pairs the KV cache of one context with the recurrent state of another. Code: github.com/kirillTerra/split-prefill. [Confirmed]
- *Scale.* Qwen3.5 4B, 9B and 27B (GDN hybrids); Falcon-H1 3B, 7B and 34B (Mamba hybrids). Point estimates without intervals for Kimi-Linear-48B, Olmo-Hybrid-7B and Jamba2-3B. [Confirmed]
- *Results.* On Qwen3.5-4B, exact key–value retrieval scores 0.89 with the KV cache only and 0.00 with the recurrent state only. Output-language following shows the reverse, 0.70 against 0.01, and persona 0.49 against 0.14. In the swap, the answer's value comes from the KV source and its language from the recurrent source. KV-only models can report what the language instruction was but do not act on it. The same dissociation is reported for Kimi-Linear-48B. [Confirmed; checked against the abstract on 26 October]
- *Limits.* Generations are capped at 48 tokens (8 for retrieval), and persona is judged by Qwen2.5-72B-Instruct, described once as a binary verdict and once as a [0,1] score. The authors note that split-prefill produces partly out-of-distribution states; rec-only also restarts the query at position 0, and kv-only zeroes the convolution state with the recurrent state. Qwen3.5-27B and Falcon-H1-34B are single-seed, and Kimi-Linear-48B, Olmo-Hybrid-7B and Jamba2-3B are point estimates. At Falcon-H1-34B the language dissociation weakens (0.41 against 0.25) and persona reverses (0.18 against 0.33). "Reports but does not act" is clean for Qwen3.5-9B (0.90 English label against 0.05 target-language label) and Falcon-H1-7B, partial for Qwen3.5-4B, and absent at Falcon-H1-34B (n = 20 per seed). [Confirmed: full read, 26 October]

Consequences:
- **Finding 7 and "What the experiments would test", item 4, need revising.** Lee et al.'s recall result showed that the recurrent state is dispensable *for recall*. This paper shows what the state does instead: it carries standing settings of the generation. The carrier-dissolution conditional of item 4 does not apply to those. [Inferred]
- **Audit finding 1 gains support.** In hybrids, the persistence across tokens that the audited essays denied is behaviourally load-bearing, not merely architectural. [Inferred]
- **Part 3.1's carrier test has a template.** The proposed small-scale experiment (open item 6) can start from this code. [Inferred]
- **Capacity is compatible with the division but does not explain it.** A $d_k\times d_v$ state could hold the 15–30 entries of these dictionaries under a discrete readout, and the authors report that the recurrent-only collapse persists in minimal versions of the tasks, "ruling out a state-too-small explanation" (no numbers given). Lee et al.'s degradation also starts far below the key dimension. So the routing of retrieval through the cache is learned. Capacity says only that the state is the cheaper place for a few settings that every token reads. [Inferred, revised 26 October]

## B.2 Out of date: "nothing exists on the seven checkpoints"

Finding 1 is now out of date beyond the K3 neuron graph of Addendum A.2.
- **Activation probes against transcript monitors.** [Bergen et al. (Goodfire), arXiv 2609.19101](https://arxiv.org/abs/2609.19101) (v2, 9 October; missed earlier) fit difference-of-means probes for reward hacking on Kimi K3, GLM 5.2 and Qwen 3.8 Max, and steer Qwen3.8-27B. The baseline monitor is an LLM reading the whole transcript (reasoning, messages and tool calls), not the chain of thought alone. At a matched false-positive rate, probes on K3 catch 33.1 points more hacks than that monitor on ImpossibleBench and 3.0 more on DeepSWE (3.1 in the abstract), and miss 6.6 more on SWE-bench; on GLM 5.2's DeepSWE they catch 7.9 fewer (abstract). Combining probe and monitor by OR raises K3's DeepSWE detection from 41.1 to 80.2 percent for a 1 percent absolute increase in false positives. [Confirmed: full read, 26 October]
  - *Layers.* The only per-model layers are in the logit-lens Table 1: K3 layer 60, GLM 5.2 layers 46 and 44, Qwen3.8-2.4T layers 83 and 78, and DeepSeek-V4-Pro (an mHC model) layers 57 and 53. The paper gives no reason for them and does not say which layers the monitoring probes use. [Confirmed]
  - *No unverbalized hacks.* Every probe hit the paper shows is visible in reasoning text or tool calls; the "probe-hit, judge-miss" cases are verbalized hacks the judge failed to flag. The probe does predict later actions: resampling at its peak gives attempted hacks in 28.6 percent (K3) and 14.1 percent (GLM) of cases, against about 1 percent at controls. [Confirmed]
  - *Steering.* At layer 47 of Qwen3.8-27B, a honeypot function taken once in 194 problems unsteered is called in 24.2 percent of problems with steering. [Confirmed]
- **Deployed activation monitors.** [Lubana et al. (Goodfire)](https://www.goodfire.com/research/production-cyber-monitors-on-kimi-k3) (8 October; missed earlier) run probe-then-judge cyber monitors on K3 and GLM 5.3 in production, at about 93 percent recall and a 5.5 percent benign-interruption rate. A monitor built on K3 data transfers to GLM 5.3. [Confirmed; company-reported]
- Neither paper says how "the residual stream" is defined under K3's AttnRes or DeepSeek's mHC, and neither uses the KDA or GDN state; the full read of 2609.19101 confirms the absence. So finding 3's convention problem stands, unaddressed rather than solved. [Confirmed]

## B.3 Depth: mHC measured, and both depth mixers read as memories

- **Open item 4 is answered for V4-Flash.** [Zhao et al., arXiv 2609.05309](https://arxiv.org/abs/2609.05309) (4 September; missed earlier) measure DeepSeek-V4-Flash-0731. A typical site reads about 2.0 of the four streams and writes about 1.8. Mixing deviates from identity by 0.046 in layers 0–21 and by 0.009 in layers 22–42. Replacing the late mixers with identity raises C4 perplexity by 1.9 percent; replacing the early ones raises it by 41.4 percent, while fixing them to their token mean costs 0.2 percent. [Confirmed] So at V4 scale an mHC model is neither one carrier nor four, and its early mixing is close to input-independent. Audit finding 2's "mean-conserving re-mixing of four copies" holds for the early layers; the late layers are close to four separate identity skips. V4-Pro and V4.1-Flash's Single-Pass mHC remain open. [Inferred]
- **A mechanism for the near-identity mixing.** [Li, Sha and Yang, arXiv 2610.06653](https://arxiv.org/abs/2610.06653) split a doubly stochastic mixer into a mean channel, which is an ordinary residual update, and a difference channel that contracts at each layer unless the mixer is a permutation. [Reported: abstract]
- **Depth mixers as memories.** [González-Martínez et al., *Depth Memory*, arXiv 2610.18809](https://arxiv.org/abs/2610.18809) cast AttnRes as an explicit store over depth (a growing cache of layer outputs read by attention) and mHC as an implicit one (a fixed-size state written by outer products). They propose a recursive-least-squares depth memory, tested at 400M and 1.5B. [Confirmed] This makes Part 1.6's reading exact, and it carries the delta-rule and fast-weight vocabulary of Part 1.5 from the token axis to the depth axis. [Inferred]
- **A frontier-scale residual intervention under mHC.** [Shi, Chen and Shen, arXiv 2609.09793](https://arxiv.org/abs/2609.09793) (missed earlier) read a refusal direction in GLM-5.3-Flash (about 320B, four-stream mHC) by collapsing the streams with the hyper-connection weights. They project it out of all 12,479 residual writers, 12,384 of them fused expert down-projections. Editing attention, dense projections or routed experts alone removes 4, 2 and 15 percent of refusal; editing all three removes 78 percent. [Confirmed] This supplies one of the stream conventions finding 3 listed as missing, and shows experts carrying a large share of a residual direction. [Inferred]

## B.4 Recurrent gates: partly closed

- **GDN heads have fixed roles.** [GateSight, arXiv 2610.14754](https://arxiv.org/abs/2610.14754) measures Qwen3.8-27B and Qwen3.8-Flash-Next. The median GDN head half-life is about 24 tokens. Head rankings agree across documents at Spearman 0.99 or higher, and the static weights alone predict them at 0.94. Head identity explains 71.7 percent of the variance in log effective write, against 10.2 percent for the token. Strong writes by slow-decaying heads predict which attention KV entries will matter later (Spearman about 0.55). [Confirmed] The recurrent layers write where the attention layers will later read, which refines finding 7. [Inferred]
- **KDA's channel-wise decay is used.** [DASC, arXiv 2608.30386](https://arxiv.org/abs/2608.30386) (missed earlier) reads static per-channel decay horizons from Kimi K3's weights: median one-step decay 0.942. At a 64-token cutoff, 98.3 percent of K3's layer–head pairs mix retained and forgotten channels, and static horizons rank empirical ones at a median within-layer Spearman of 0.90. [Confirmed] Part 1.5's "none inspects KDA's per-channel α" is out of date; per-token gate trajectories on K3 or Qwen3.8-2.4T are still missing. [Inferred]
- **A lens on recurrent state exists for diagonal SSMs.** [Wang and Reid, arXiv 2609.32102](https://arxiv.org/abs/2609.32102) (missed earlier) redefine the Jacobian lens with the recurrent state as source. On Mamba-1, -2 and -3 and a Nemotron hybrid, a state lens beats the residual lens on concept recovery in most families. No delta-rule model is included; extending it to GDN and KDA is the next step that Part 1.7 asks for. [Confirmed for the results; Inferred for the extension]

## B.5 The "already clean" debate

- Goodfire's companion paper on language-model neurons has not appeared; it is described as "forthcoming in a few weeks". [Confirmed]
- [Leo Gao, *Neural networks are not already clean*](https://www.lesswrong.com/posts/Dkh7pXKjoNWkkxQDz/neural-networks-are-not-already-clean) (LessWrong, 17 October) concedes that neurons were written off too quickly. He disputes that matching top activations explains a neuron, and guesses that ablating weak activations "quite substantially degrades model performance", promising numbers. No new experiment. [Confirmed] A second senior dissent on Nanda's weak-activation crux. [Inferred]
- A [toy community replication](https://github.com/AMX07/already-clean-replication) (4- and 6-layer models, one seed) finds weak activations cheap to ablate: zeroing each neuron's weakest 75 percent of activations raises loss by 0.037, against 2.03 for a mass-matched ablation of the strongest. [Confirmed: README; unreviewed]
- Goodfire's own [VPD](https://arxiv.org/abs/2610.20748) decomposes a 67M dense model's weights into rank-one subcomponents and allows more of them than rows or columns, so as to capture computation in superposition. [Confirmed] The lab's parameter-decomposition line assumes what Cammarata's essay argues against. [Inferred]
- Zhou and Klindt's v2 adds only the NeurIPS 2026 acceptance. No responses were found. [Confirmed]
- **For thesis 2 (the facts crux).** [*Atoms, Not Knowledge*, arXiv 2610.25317](https://arxiv.org/abs/2610.25317) reports that single facts written into Engram-style hashed memory (V4.1-Flash; Qwen3.8-Flash-Next n-gram tables) are retrievable but not composable: two-hop accuracy is 26 percent against 25 percent expected from independent hops. [Reported: abstract; read before use]

## B.6 Smaller items

- **MoE.** [*The Router Already Knows*, arXiv 2610.27421](https://arxiv.org/abs/2610.27421) trains a dictionary per expert, opened only when the frozen router selects it, on one layer of Gemma 4 26B-A4B. It explains 0.518 of router-weighted output variance against 0.387 to 0.481 for controls. There is no causal evaluation. [Confirmed] It is a first, weak instance of what Part 1.3 said was missing, using the convention of treating routing as given. [Inferred]
- **Self-attribution in a GDN hybrid.** [*Where Is the "Self" of a Large Language Model?*, arXiv 2610.16717](https://arxiv.org/abs/2610.16717) finds a linear "self-index" separating the model's own messages from external ones at all 64 layers of Qwen3.8-27B. Swapping states after a message reverses self-attribution in layers 15–31. The abstract does not say whether the swapped states include the GDN state. [Reported] Relevant to the audit of *Experience, Selfhood* and *Indexical Unity*; whether the KV cache or the recurrent state carries the index is open. [Inferred]
- **Retrieval in Mamba.** [Yarden et al., arXiv 2610.19709](https://arxiv.org/abs/2610.19709): selection gates control retrieval, but they read query relevance from representations that encode it several layers too late. [Reported: abstract] This fits Part 1.5's point that gates and keys are functions of other positions' residual streams. [Inferred]

## B.7 Kanerva's sparse distributed memory and the homonymy thesis

Added 26 October after a discussion of the essay outline's lineage boxes.

**The model.** Kanerva's *Sparse Distributed Memory* (MIT Press, 1988) places many "hard locations" at random addresses in a high-dimensional binary space. A write adds the data to every location within a Hamming radius of the item's address. A read sums the locations within the radius of the query and thresholds the sum. Read as a network, it is a two-layer store with a fixed random first layer and a threshold nonlinearity. [Inferred from the standard description; the book has not been read for this note]
- [Bricken and Pehlevan, *Attention Approximates Sparse Distributed Memory*](https://arxiv.org/abs/2111.05498) (NeurIPS 2021) report that attention closely approximates SDM's read under certain data conditions, and that the conditions hold in pre-trained GPT-2. [Reported: abstract]
- [Bricken, Davies, Singh, Krotov and Kreiman, *Sparse Distributed Memory is a Continual Learner*](https://arxiv.org/abs/2303.11934) (ICLR 2023) turn SDM into a modified MLP that learns continually without replay or task labels. [Reported: abstract]

**The tension with "already clean".** By design, an SDM location sums every item written near its random address, so one unit holds many unrelated memories. In thesis 1's terms that is homonymy: senses joined by accident. It is also the shape of Nanda's facts crux, where facts sit in combinations of units. [Inferred]

**The resolution goes through thesis 3.** SDM's addresses are fixed and random. In a trained network the first-layer weights play the role of the addresses, and they are learned. [Inferred]
- With random addresses, nothing breaks the symmetry. Units hold unrelated items, and the basis is arbitrary, which corresponds to Zhou and Klindt's Theorem 4.1.
- With learned addresses, training can move each unit to a meaningful region of the input space. Its neighbouring items then extend one another, which is polysemy, Cammarata's picture.

So SDM is not evidence against clean neurons. It names the regime in which neurons are homonymous, and it turns the debate into a question about training: does it move the addresses to meaningful regions? This also restates thesis 1 as a claim about addressing. Homonymy is what random addressing produces, and polysemy is what learned addressing produces.

**Tests.**
1. Bricken et al.'s continual-learning MLP learns its addresses under top-$k$ sparsity. Are its trained units specialized (polysemous at most), and are its untrained units homonymous? *Partly answered by the paper itself (read 26 October, Appendix H, Table 10).* After continual learning on Split CIFAR-10, each neuron's entropy over the 10 classes that activate it, weighted by how often it is active, is 0.99 for the SDM MLP (learned, L2-normalized addresses, no bias, top-$k$), 1.48 for plain top-$k$, 1.96 for the SDM MLP without L2 normalization, and 2.25 for ReLU (the maximum is $\ln 10\approx2.30$). Without normalization, 13 "greedy" neurons are "not only highly polysemantic but active for many inputs" (up to 6 percent of inputs, against 1.4 percent). Trained on raw pixels, neurons become example-specific, "analogous to the hypothetical 'grandmother neuron'". Lower entropy goes with better continual learning. [Confirmed]
   - What this shows: the training regime, not the architecture's width, decides whether units are clean. The same two-layer store gives class-specific units under one set of constraints (normalized addresses, no bias, top-$k$) and mixed units under another. That is thesis 3 at toy scale, with the regime's ingredients named. [Inferred]
   - What it does not show: entropy over class labels cannot separate homonymy from polysemy. A unit active for cats and dogs has mixed classes and may be polysemous. The homonymy reading needs the semantic test of thesis 1, not a class count. The setting is also small (one hidden layer of 1,000 units on frozen embeddings), and specialization needed a static input distribution; jointly trained SDM layers produced many dead neurons. [Inferred; the last two Confirmed]
   - Bricken and Pehlevan's GPT-2 check, read in full, measured only the largest softmax input per head (an "effective β", mostly 3 to 12, a lower bound). It did not test SDM's read mechanism in GPT-2. Their two conditions for attention to approximate SDM are L2-normalized vectors and a suitable β. [Confirmed]
2. Thesis 2 sharpened: when a fact is written into an MLP, are the units it lands on near each other in meaning, or only near each other in a random projection of the input? The first is Cammarata's locality, the second SDM's distribution.

**Scope.** Kanerva's other line, hyperdimensional computing and binding by vector operations, bears on the binding problem of audit finding 4 (the tensor-product store). It belongs with that discussion, not here.

**Hawkins's Hierarchical Temporal Memory** draws on the same sparse-distributed tradition. HTM's sequence memory learns online through local, dendrite-like coincidence detection, and Numenta's active-dendrites work uses context-gated sparse subnetworks against forgetting. Neither entered the lineage of the seven checkpoints, and no recent comparison with Transformers was found. The successor, the [Thousand Brains Project](https://arxiv.org/abs/2507.04494) (Monty; *Neural Computation* 38, 2026), studies sensorimotor object recognition on YCB objects with Hebbian-like local learning. [Reported] Decision (26 October): HTM and the Thousand Brains Project are left out of the architectures essay and out of the mindedness essay's sources, and HTM is not a seed for a possible essay on non-gradient or zeroth-order learning.

## B.8 Open items after this check

- Item 4: done for V4-Flash (B.3); open for V4-Pro, V4.1-Flash and K3's pseudo-queries.
- Item 6: start from the split-prefill code (B.1).
- Item 7: the Goodfire companion paper is still pending; Zhou and Klindt §9.1 is still unread.
- New: read 2609.19101 in full for its residual-stream convention under AttnRes; read *Atoms, Not Knowledge* before using it for thesis 2.

---

# Source register

Format: source, scale, status. Scale flags: toy (≤1B), small (1B to 10B), mid (10B to 100B), large (>100B).

## Experts and routing
- [Herbst et al., *The Expert Strikes Back*](https://arxiv.org/abs/2604.02178), 2 Apr 2026, ICML 2026. Six MoEs 7B to 30B plus six dense. Text read.
- [Lasy, Cai, Ayonrinde, *RouterInterp*](https://arxiv.org/abs/2610.11775), 8 Oct 2026. gpt-oss-20b, OLMoE. Text read in part.
- [Wang, Hayou, Nalisnick, *The Myth of Expert Specialization*](https://arxiv.org/abs/2604.09780), 10 Apr 2026. Five models to about 30B. Text read in part.
- [Engmann et al., causal audit of expert importance](https://arxiv.org/abs/2606.10703), 9 Jun 2026, workshop. Three models 2B to 16B. Abstract.
- [Wang et al., *Illusion of Specialization*](https://arxiv.org/abs/2601.03425), 6 Jan 2026. Three unnamed models. Abstract.
- [Su et al., *Super Experts*](https://arxiv.org/abs/2507.23279), ICLR 2026. Qwen3-30B-A3B. Abstract.
- [Olson et al., *Probing Semantic Routing*](https://arxiv.org/abs/2502.10928), 2025. DeepSeek-R1 671B, Llama-4 (to 400B), Mixtral. Text read.
- [Fayyaz et al., *SteerMoE*](https://arxiv.org/abs/2509.09660), ICLR 2026. Six models to gpt-oss-120b. Text read.
- [Mixtral of Experts](https://arxiv.org/abs/2401.04088); [OLMoE](https://arxiv.org/abs/2409.02060); [DeepSeek-V3](https://arxiv.org/abs/2412.19437) (aux-loss-free balancing, Appendix C). Text read.
- [Li et al., knowledge attribution in MoE](https://arxiv.org/abs/2505.24593), ACL 2025. About 7B. Text read.
- Chen et al., routing as reasoning signal, [2606.22798](https://arxiv.org/abs/2606.22798); Yoon et al., misrouted experts, [2605.07260](https://arxiv.org/abs/2605.07260). Abstracts.

## SAEs, transcoders, attribution
- [Qwen-Scope](https://arxiv.org/abs/2605.11887), 12 May 2026. Qwen3 and Qwen3.5 SAEs to 35B-A3B, residual stream. Text read in part.
- [Goodfire, *Under the Hood of a Reasoning Model*](https://www.goodfire.com/research/under-the-hood-of-a-reasoning-model), 2025. R1 671B, one layer. Post read.
- [circuit-tracer](https://github.com/decoderesearch/circuit-tracer) (supported-model list). README read.
- [Chaudhari et al., sparse crosscoders for MoE and dense](https://arxiv.org/abs/2603.05805). Toy. Abstract.
- [Nguyen, *The Attribution Contract*](https://arxiv.org/abs/2605.23080), single author. Abstract plus search summary.
- [Yang et al., MoE-X](https://arxiv.org/abs/2503.07639). Small custom models. Text read.
- [Cammarata, *Neural Networks Are Already Clean*](https://already-clean.goodfire.com/), Goodfire, October 2026. Vision models to ConvNeXt; Qwen3-32B; one Kimi K3 graph. Whole page read through summarizing fetches. Addendum.
- Cammarata and Nanda on X, October 2026 (links in Addendum A.1). Read.
- [Zhou and Klindt, *Complete or Sparse*](https://arxiv.org/abs/2610.20851). Theory with synthetic experiments; real data to TinyLlama. First two-thirds read through summarizing fetches. Addendum.
- [Yang et al., *Breaking the Softmax Bottleneck*](https://arxiv.org/abs/1711.03953), ICLR 2018. Cited from memory, not re-read.

## Attention
- [Through the Bottleneck](https://arxiv.org/abs/2607.23054), 25 Jul 2026. 114M. Text read.
- [TransMLA](https://arxiv.org/abs/2502.07864); [MHA2MLA](https://arxiv.org/abs/2502.14837). Llama-2-7B. Abstracts.
- [DeepSeek-V3.2 (DSA)](https://arxiv.org/abs/2512.02556). Text read. [Xiu et al., top-k sparse attention study](https://arxiv.org/abs/2512.03494). Abstract; the 60-percent figure is from a search summary.
- [MiniMax Sparse Attention](https://arxiv.org/abs/2606.13392), about 109B-A6B. Text read. [IndexCache](https://arxiv.org/abs/2603.12201). Abstract.
- [DeepSeek-V4](https://arxiv.org/abs/2606.19348); [DeepSeek-V4.1-Flash](https://arxiv.org/abs/2609.19969) (abstract only for attention detail).
- [Cheng et al., *The Token Before the Value Is the Key*](https://arxiv.org/abs/2609.15545); [Qiao et al., *Rethinking the Role of Efficient Attention in Hybrid Architectures*](https://arxiv.org/abs/2606.15378). Toy to small. Text read (first), abstract (second).
- [MiMo-V2-Flash report](https://arxiv.org/abs/2601.02780); [MiMo-V2.6 report](https://arxiv.org/abs/2610.11959) (partial). [Kimi K3 report](https://arxiv.org/abs/2607.24653).
- [Qiu et al., gated attention](https://arxiv.org/abs/2505.06708); [Do new attention mechanisms fix sinks at million-token context?](https://arxiv.org/abs/2609.08574) (toy, inconclusive); [Dawes et al., local mixing and global NoPE](https://arxiv.org/abs/2609.38109) (abstract).

## Recurrent layers and hybrids
- [Lee et al., *How Linear Attention Remembers*](https://arxiv.org/abs/2609.33093), 27 Sep 2026. GLA and GDN 340M to 1.3B, Qwen3.5-4B and 9B. Text read; abstract confirms the hybrid claim.
- [Young, *WriteSAE*](https://arxiv.org/abs/2605.12770), single author. Qwen3.5-0.8B. Text read.
- Li, causal interventions on a quantized hybrid, [Research Square preprint rs-11201314](https://www.researchsquare.com/article/rs-11201314/v1), 30 Sep 2026. Independent preprint.
- [Su et al., massive activations in hybrids](https://arxiv.org/abs/2608.12149). 1.2B to 397B. Text read.
- [Jiang and Zhang, Mamba-2 state sink](https://arxiv.org/abs/2606.00930); [Hidden State Poisoning Attacks](https://arxiv.org/abs/2601.01972); [Mamba Knockout](https://arxiv.org/abs/2505.24244); [Locating and Editing Factual Associations in Mamba](https://arxiv.org/abs/2404.03646); [Does Transformer Interpretability Transfer to RNNs?](https://arxiv.org/abs/2404.05971); [Mamba selective-memory autoencoders](https://arxiv.org/abs/2512.15653). Small. Text read.
- [Kimi Linear](https://arxiv.org/abs/2510.26692); [Gated DeltaNet](https://arxiv.org/abs/2412.06464); [Olmo Hybrid](https://arxiv.org/abs/2604.03444); [Gated DeltaNet-2](https://arxiv.org/abs/2605.22791); [Complex KDA](https://arxiv.org/abs/2609.24797); [On the Design of Qwen3.8-Next](https://arxiv.org/abs/2608.30320). Architecture papers; no interpretability.

## Depth, residual pathways and lenses
- [mHC](https://arxiv.org/abs/2512.24880); [Hyper-Connections](https://arxiv.org/abs/2409.19606); [Attention Residuals](https://arxiv.org/abs/2603.15031); [Engram](https://arxiv.org/abs/2601.07372); [DenseFormer](https://arxiv.org/abs/2402.02622). Text read. Reference code and configs for V4 and K3 on Hugging Face.
- [Ablate and Rescue](https://arxiv.org/abs/2603.14833), 781M; [Stream Collapse](https://arxiv.org/abs/2606.03483), 0.12B to 0.36B; [Javadov, causal probes on Block AttnRes](https://arxiv.org/abs/2606.13168), 0.6B; [Low-Rank Attention Residuals](https://arxiv.org/abs/2607.09694) (K3 weights audit); [Delta-AttnRes](https://arxiv.org/abs/2605.18855). Text read.
- [Gurnee et al., Verbalizable Representations Form a Global Workspace](https://transformer-circuits.pub/2026/workspace/index.html), 6 Jul 2026. Claude models. Page text read.
- [Song and Feng, Jacobian lens at frontier scale](https://xiangchensong.github.io/blog/2026/jacobian-lens-global-workspace/) ([repository](https://github.com/xiangchensong/jacobian-lens-open-frontier)); [R-lens](https://www.lesswrong.com/posts/nv8oedrnLXKRzNEL9/r-lens-making-j-lens-more-faithful-on-early-layers); [J++](https://www.lesswrong.com/posts/nc9dHfcB22JdMzGbr/paper-j-lens-jacobian-filtering-enables-more-faithful). V4-Flash. Community write-ups, read.
- [Wang and Reid, looped transformers under the Jacobian lens](https://arxiv.org/abs/2609.01924); [Mozer et al., Recirculation](https://arxiv.org/abs/2608.17981).
- [Elhage et al., Mathematical Framework](https://transformer-circuits.pub/2021/framework/index.html); [Circuit Tracing](https://transformer-circuits.pub/2025/attribution-graphs/methods.html).

## Sources the essays cite, checked here
- [McGrath et al., Hydra effect](https://arxiv.org/abs/2307.15771): model not named on the abstract page.
- [Thought Anchors](https://arxiv.org/abs/2506.19143): receiver-head analysis on DeepSeek R1-Distill-Qwen-14B, compared with base Qwen-14B (search result, not read in full).

## Unverified or not cited
John Hewitt's "residual stream is not linear" could not be located. The Qwen3.8 "Gated Residual" description rests on a trade-press article that could not be retrieved. Architecture numbers for MiniMax M3's size and for the Kimi K3 license are reported inconsistently by third-party pages. The V4-Flash parameter count is 284B in the report and 304B in Song and Feng's README.
