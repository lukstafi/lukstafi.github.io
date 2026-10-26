# Outline: an essay on the architectures and training of the open frontier

Status: outline for review, 26 Oct 2026. Sample sentences show register only. Sections carry no word budgets; length follows content.

## Decisions taken so far

- **Scope.** A deep account of architectures and training. Interpretability results enter only where they show what a component does in a trained model.
- **Form.** One blog essay, landing on Substack in parts if it runs long. Split into an architectures article and a training article if the two halves stop cohering. The split point is fixed in advance: between §6 and §7.
- **No philosophical retrospective.** The 3 Oct dossier planned a section correcting earlier essays. Much of it landed on 25–26 Oct (*The Dynamics That Matter* retired; *What Breadth Reaches* §3 and *Where Experience Goes* revised). What remains concerns carriers and mindedness, so it moves to the mindedness essay. This essay ends with at most a paragraph pointing ahead.
- **The seven pinned checkpoints stay the subject**: MiMo-V2.6-Pro, Kimi K3, Qwen3.8-2.4T-A95B, GLM-5.3, DeepSeek V4-Pro, DeepSeek V4.1-Flash, MiniMax M3. MiniMax-M3.1-Flash and Kimi K3.1 Pro appear where they extend a trend (§5), and K3.1 Pro's config is checked when its weights appear (due 4 Nov).

Title (chosen 26 Oct): *Every Layer a Store: How the 2026 Open Models Are Built and Trained*. The seven checkpoints do not make seven distinct extensions: GLM-5.3 reuses its predecessor's architecture, K3 and Qwen3.8 share the delta-rule hybrid design, and the thesis stresses convergence.

Sources this outline draws on:

- `frontier-model-architectures.md` (3 Oct, addendum 26 Oct): model portraits, cost table, depth and monitorability, training stages, layer schedules, three hand-sized calculations, figure plans.
- `associative-memory-view.md` (26 Oct): every component as a store; capacity and its criteria; Zucchet's training results.
- `architecture-interpretability-and-audit.md` (15 Oct, addenda 18 and 26 Oct): Part 1 by component, and Addendum B for the measurements this outline uses.
- The continual-learning series and the two RL essays, linked rather than recapped.

---

## 1. Thesis

A language model keeps information in several stores. The weights are written by training. The attention cache, and in hybrids the recurrent state, are written by reading the context. The 2026 open frontier extends the Transformer by choosing which stores to have, how each one keeps its entries from interfering, and how much reading it costs. Training makes those stores usable, and it does so in an order: circuits that route information form before facts can be stored, and post-training edits what pretraining wrote.

What makes this more than a survey:

1. **One vocabulary for three kinds of mixing.** Mixing across tokens (attention, selection, compression, recurrence), across channels (gated FFNs, experts, lookup tables) and across depth (the residual stream, mHC, AttnRes) all read as stores. The reader learns one set of questions and applies it seven times, instead of learning seven designs.
2. **Capacity with its criterion attached.** The essay gives numbers for how much each store holds, and says each time what counts as recall. This is where popular accounts go wrong.
3. **Training explained by what it has to make work.** The new components each bring a training problem: indexers that cannot be trained by backpropagation through top-$k$, residual mixers that must stay stable, contexts that must be extended in stages. The disclosures are read as solutions to those problems.
4. **Convergence.** Seven labs made overlapping choices, and the October releases continue the pattern. The essay can say which choices recur and why, which a model-by-model tour cannot.

Sample sentence: "A Transformer layer is a memory, and the question every one of these designs answers is what that memory should be allowed to forget."

---

## 2. Sections

### Part A: Architectures

#### §0 Opening

**Purpose:** show the reader one concrete difference before introducing any term.

- **Opening (decided 26 Oct): show that the vanilla-Transformer picture is out of date.** Follow one 1M-token prompt into three of the seven. The vanilla picture says every layer keeps an entry for every token and reads all of them. A full-attention layer in MiMo does that only in its 10 global layers; its other 60 see a 128-token window. A KDA layer in Kimi K3 keeps a fixed-size matrix per head that every token updates. A V4.1-Flash decoder never runs most of the prompt through its own layers: a separate encoder builds the decoder's cache. Give each in one or two sentences, then ask where the prompt went.
- **Keep the striking hybrid result for §3.** A Qwen3.5 hybrid that has lost its recurrent state still recalls the value but answers in the wrong language; one that has lost its cache answers in French but cannot recall. It lands where the reader has the store vocabulary to see why.
- State the thesis in two sentences.

#### §1 From the 2017 Transformer to the contemporary block

**Purpose:** establish the baseline that every later section modifies, and the four quantities the essay keeps apart.

- The 2017 model was an encoder–decoder translator with post-normalization. "The original Transformer" in current usage is a later decoder-only, pre-normalized descendant. One paragraph.
- The attention equation, with queries, keys and values introduced as a lookup, which sets up §2.
- The schematic block: normalize, mix tokens, add; normalize, mix channels, add. Name the three slots that later sections replace: the token mixer, the channel mixer, and the residual combination.
- The short bridge items: RMSNorm; gated FFNs (SwiGLU); RoPE, and Kimi K3's NoPE backbone; GQA and MLA as two ways to shrink the cache; MoE as conditional computation.
- **Four quantities**: stored weights, active computation, context state, hardware time. "Active parameters" measures none of the others. This distinction is used in every later section.

Figure 1: the common block with three replaceable slots (from the dossier's figure list).

#### §2 Every layer is a store

**Purpose:** give the reader the questions they will apply to every component: what writes the store, when, how much it holds before interference, and what reading costs.

- Derive the stores in Wang's order, in one or two equations each: an outer-product store; a least-squares store; an MLP as a store whose nonlinearity suppresses interference; softmax attention as a store that suppresses every non-matching key exponentially. Credit Wang's post and the classical lineage (Kohonen, Anderson; Krotov–Hopfield; Ramsauer et al.; Geva et al. on FFNs as key–value memories).
- **The recall criterion.** Give the table of capacities under Wang's criterion, recall of a clean vector with random keys. Then give the discrete-readout count: about $d^2$ for a $d\times d$ linear map (Nichani, Lee and Bietti; Barnfield et al.). Two further cautions: the counts are per key dimension, not per parameter, and real keys are not random. Per parameter, trained stores hold about 2 bits (Allen-Zhu and Li).
- **Parametric and non-parametric stores.** Weights are written in training and hold the world's facts. The cache is written while reading and holds the context. Wang's thread juxtaposes the two in one breath; the essay keeps them apart.
- **Experts and lookup tables.** An MoE router acts as a coarse key match before recall. Splitting into experts costs about 1.3 times in stored knowledge per parameter, even with top-1 routing (Allen-Zhu and Li, Result 9). So total parameters, not active ones, indicate how much a model can store. DeepSeek V4's hash-routed early layers and V4.1-Flash's Engram tables are stores addressed by token identity or n-gram.

**Classical lineage (decided 26 Oct: §2 is a full section, with the background as titled boxes or subsections).** Each box tells one strand in a few paragraphs and ends where the main text picks it up. Candidates, in the order the main text needs them:

- *Box: The linear associative memory.* Kohonen's correlation-matrix memory and Anderson's interactive memory (both 1972); the pseudo-inverse "optimal" mapping of Kohonen and Ruohonen (1973), which is Wang's least-squares store; the Widrow–Hoff rule (1960) as the online route to it, and Diederich and Opper (1987) on a local rule converging to the projection rule. Lands at: the outer-product and least-squares rows of the capacity table, and §3's delta rule.
- *Box: Hopfield and the 0.14 N limit.* Hopfield (1982); Amit, Gutfreund and Sompolinsky (1985) for about $0.138N$ patterns with small errors; McEliece et al. (1987) for about $N/(4\log N)$ error-free; Gardner (1988) for $2N$ with optimal, non-Hebbian storage. Lands at: why the recall criterion moves the constants.
- *Box: Dense associative memory and modern Hopfield networks.* Krotov and Hopfield (2016): a steeper energy gives polynomial capacity, $N^{n-1}$; Demircigil et al. (2017): an exponential energy gives exponential capacity; Ramsauer et al. (2020): the update rule of that network is Transformer attention. Lands at: the MLP and softmax rows, with Wang's correspondence between his power $p$ and Krotov–Hopfield's $n=p+1$.
- *Box: Sparse distributed memory.* Kanerva (1988): many locations at random addresses, written and read within a radius, which makes a two-layer store with a fixed random first layer and a threshold. Bricken and Pehlevan (NeurIPS 2021): attention approximates SDM's read under data conditions that hold in GPT-2. Lands at: the bridge between the MLP row and the softmax row. At most one sentence on interpretability: random addresses put unrelated items in one unit, and training learns the addresses (the full argument is in the audit dossier, B.7). Read both sources before drafting; only the abstracts have been checked.
- *Box: Feed-forward layers as key–value memories, and fast weights.* Sukhbaatar et al. (2019) and Geva et al. (2021) for FFNs; Schmidhuber (1992), Katharopoulos et al. (2020) and Schlag, Irie and Schmidhuber (2021) for linear attention as a fast-weight memory written at inference. Lands at: the split between parametric and non-parametric stores, and §3.

Evidence status: the 2016–2021 papers' key passages were read for the associative-memory note. The classical papers (1960–1988) were checked for existence and bibliographic data only; their capacity figures are reported via Ramsauer et al. and Krotov and Hopfield. Read them, or quote them through those secondary sources with attribution, before drafting the boxes. Citations are in `associative-memory-view.md` and the gitignored source digest.

Worked example 1: a single head with $d_k=128$ under both criteria. How many random associations does it recall as clean vectors, and how many by picking the right answer from a vocabulary? The numbers should make the gap between the criteria visible in one line.

Sample sentence: "How much a memory holds depends on what you count as remembering."

#### §3 Memory along the context

**Purpose:** the five ways the seven models keep the past, with costs, and what trained hybrids actually do with them.

- **Five memories**: full history, a rolling window, selected entries, compressed entries, a recurrent state. Use the dossier's diagram of explicit versus recurrent memory and its table of long-context mechanisms by model.
- **Costs.** The dossier's cost table for prefill, decode and persistent state, with its three qualifications: sparse reads do not imply cheap selection; a hybrid with a fixed share of global layers keeps quadratic prefill asymptotically; different optimizations shrink different dimensions (heads, features, positions, bytes).
- **Selection is learned retrieval.** DSA and GLM's IndexShare, MSA's per-group block selection, CSA's selection among compressed entries. A selector can miss; that is the new failure mode. Composition limits for top-$k$ access (Eitan, Yehudai and Maron) belong in §6, not here.
- **The delta rule.** The equation, the error term read as the store's current prediction, and the gates. One step of online regression, the Widrow–Hoff rule. Link worked example G of *Where Experience Goes* rather than repeating it. What the delta rule buys over additive linear attention is overwriting, not capacity: its batch fixed point is the least-squares store, at most about twice the outer-product store under vector recall (Schlag, Irie and Schmidhuber motivated it this way). KDA's per-channel retention, with the dossier's calculation 1 as a hand-sized example.
- **What the trained hybrids do.** Exact retrieval runs through the attention cache; output language and persona run through the recurrent state (Afendulev et al., Qwen3.5 4B–27B and Kimi Linear). Most GDN heads in Qwen3.8-27B forget within about 24 tokens, and their roles are fixed by the weights (GateSight). In K3, nearly every head mixes channels kept for long and channels forgotten quickly (DASC). These three measurements tell the reader what the architecture's affordances turn into after training. This is interpretability in its intended role.
- **Long context as an interference problem.** Softmax capacity falls as distractors accumulate; raising the temperature with the log of the context length (LogN scaling, YaRN) keeps suppression up against random distractors but not against near-duplicates. This connects the architecture to §9's curricula.

Figure 2: the attention-memory comparison: full history, rolling window, selected blocks, compressed entries, recurrent state.
Figure 3: storage against read cost, showing why sparse attention can retain a growing cache and a hybrid can retain global-attention costs.

#### §4 Memory along depth

**Purpose:** the third kind of mixing, which most readers do not know exists.

- The residual stream as a shared bus: each layer reads it and adds to it. In storage terms it is a store over depth that lives only within one token's forward pass.
- **mHC** (DeepSeek V4, V4.1): four streams mixed by a doubly stochastic matrix. The dossier's calculation 3 shows the conservation of the residual total. The mean channel is an ordinary residual; differences between streams fade unless the mixer is a permutation (Li, Sha and Yang). Measured in V4-Flash, a typical site reads about two of the four streams, and mixing is near identity after layer 21 (Zhao et al.).
- **AttnRes** (Kimi K3): attention over earlier blocks' outputs, with a learned query per layer. Calculation 2. *Depth Memory* (González-Martínez et al.) reads AttnRes as an explicit store over depth and mHC as an implicit one, which carries §2's vocabulary over unchanged.
- The October releases continue the trend: Meta's Muse Spark Open replaces the plain sum by a learned gate.
- Keep apart what the dossier keeps apart: neither mechanism feeds a later layer back into an earlier one within a pass. These are not recurrence through depth in the sense §6 discusses.

#### §5 The seven assembled

**Purpose:** put the components together once, explaining each model by its distinctive choices, not by repeating shared mechanisms.

- Seven aligned layer strips with their exceptions drawn (the dossier's layer-schedule table): MiMo's global layers at irregular positions; K3's [KDA×3, MLA] motif plus a final MLA; Qwen's [GDN×3, attention]; GLM's indexer groups starting after three independent layers; V4-Pro's alternating CSA and HCA after two HCA layers; V4.1-Flash's 20 + 20 encoder–decoder; MiniMax's three full layers, then 57 sparse.
- One paragraph per model on what is distinctive, drawing on the dossier's portraits. Two of them carry an argument of their own:
  - **GLM-5.3**: a new release need not mean a new architecture. Its gains come from post-training on the GLM-5.2 base. This sets up Part B.
  - **DeepSeek V4-Pro against V4.1-Flash**: one lab's two answers to long context, two levels of compression against a split between prompt encoding and decoding.
- **Convergence**, with the October releases as evidence: sparse attention spreading to every layer (MiniMax-M3.1-Flash), to the global layers of window hybrids (StepFun Step-5-Preview), and to KDA-plus-MLA hybrids beyond Kimi (Ling-3.1-flash); and replacements for the residual sum (mHC, AttnRes, Meta's gate).
- A comparison table with the four quantities of §1 kept apart, and parameter counts as reported (GLM's left open).

Figure 4: seven aligned layer strips.

#### §6 Depth, recurrence and what a monitor can see

**Purpose:** answer the question that started the depth research: does recurrence make these models deeper than their layer count, and what does that mean for monitoring their reasoning?

- The five meanings of depth from the dossier's table: architectural depth, the depth of an unrolled recurrence, parallel evaluation depth, minimum circuit depth, and the effective horizon.
- The associative composition of affine updates, and why that gives a logarithmic parallel depth. The $\mathsf{TC}^0$ results and what they do and do not cover: transition structure matters; the seven's gates exclude the negative-eigenvalue extension that some constructions need.
- **Selection has its own depth limit**: composing two functions through top-$k$ access needs capacity growing as $\sqrt n$ (Eitan, Yehudai and Maron).
- **Monitorability.** Three paths between tokens: recurrence across positions, recurrence through depth, and generated text. Hybrids may need shorter scratchpads (Steifer; abstract only, so hedge or drop). Looped models at 1–3.5B decide most tokens at the first iteration (Olszowiec et al.).
- **Activation probes against CoT monitors** on Kimi K3: the two observation channels are complementary, and combining them nearly doubles detection of reward hacking on DeepSWE (Goodfire). Close with the dossier's distinction: monitoring is detection, explanation is a causal account, and depth is a constraint, not a certificate.

Sample sentence: "A fixed stack of layers no longer bounds how far back an answer depends on its input; what bounds it now is the algebra of the updates."

### Part B: Training

#### §7 The stages, kept apart

**Purpose:** the taxonomy the rest of Part B fills in.

- Pretraining, mid-training and context extension, SFT, RL, on-policy distillation, and inference-time drafting. For each: what changes in the model, and which disclosure documents it for which model. Flag that no single six-stage pipeline is documented for Qwen or MiniMax.
- One table: rows are the seven, columns are the stages, cells give the disclosed facts (token budgets, optimizer, context stages, precision, post-training method) or leave a gap. Gaps stay visible.

Figure 5: parallel training timelines, marking when modalities, long context, low precision, SFT, RL and distillation enter.

#### §8 What pretraining writes, and in what order

**Purpose:** connect §2's stores to how they fill.

- **Circuits before facts.** In synthetic-biography experiments at 44M to 400M, models sit on a plateau before facts appear; the plateau grows almost linearly with the number of individuals, and transplanting a later checkpoint's attention patterns removes it (Zucchet et al. 2503.21676). Routing has to exist before storage is usable. Repetition speeds the emergence of the routing (Zucchet et al. 2505.17863).
- **Frequency decides what is stored.** About 2 bits per parameter after about 1,000 exposures, 1 bit at 100 (Allen-Zhu and Li). Under a Zipf distribution, the data, not the parameter count, is the bottleneck: one derivation of scaling laws from storage alone (Zucchet's tutorial, with its own caveat that it cannot say whether this limits real models).
- **Ambiguity divides capacity**: a context with $k$ plausible continuations costs about $k$ times the storage (Zucchet, Lee and Linderman). Link *Who Teaches the Weights?*, which already uses this.
- Then the disclosed pretraining facts: token budgets (MiMo 27T text plus 3T multimodal; V4-Pro 33T; V4.1-Flash 45T multimodal), multimodal from the start (K3, MiniMax) or staged (MiMo; V4.1-Flash with a vision encoder frozen until decay), and the optimizer split (Muon or a variant for hidden matrices, AdamW for embeddings, head and router; Per-Head Muon in K3; Muown in MiMo).

#### §9 Making the new components trainable

**Purpose:** the essay's distinctive training content. Each new component brings a problem, and the reports read as solutions to it.

- **Selectors cannot learn through top-$k$.** MSA trains its indexer by matching the main attention's distribution under a KL objective, with stop-gradients that protect the backbone, after a full-attention warmup. V4 trains densely first, then warms up the indexer, then trains sparsely. A selector learns to imitate the attention it replaces. That is also why, in MSA's own analysis, it rediscovers attention sinks and local blocks.
- **Residual mixers must stay stable.** mHC's doubly stochastic constraint (the Sinkhorn projection) is a training device as much as an architecture. K3's SiTU controls activation growth.
- **Experts must stay balanced.** Quantile Balancing in K3; V4's hash routing in early layers removes the routing problem where it is hardest.
- **Long context is a curriculum.** K3 goes 8K, 64K, 256K, 1M; V4-Pro 4K, 16K, 64K, 1M; MiMo extends 256K to 1M in mid-training. Enlarging the position range does not teach long-range use; §3's interference account says why.
- **Precision is trained in.** MXFP4 quantization-aware training in MiMo's mid-training and K3's post-training; FP4 KV in V4.1-Flash; NVFP4 experts in MiniMax-M3.1-Flash.
- **Drafters are trained alongside.** MTP modules and DSpark propose tokens that the main model verifies. GLM-5.2 addresses the mismatch between drafter training and inference. A drafter is not evidence that the main model emits several tokens at once.

#### §10 Post-training edits the stores

**Purpose:** what SFT, RL and distillation change, read through §2.

- SFT teaches formats and tool use from demonstrations; the loss mask decides which tokens teach. RL separates policy, environment, verifier, advantage estimator and optimizer; a passing test does not distinguish a solution from an exploit. Goodfire report that models hack often on common benchmarks; GLM 5.2 hacked in 57.2% of DeepSWE rollouts.
- **Specialists, then distillation.** K3 trains nine policies (three domains, three reasoning efforts) and distils them on-policy; V4-Pro and GLM consolidate specialists by OPD; MiMo's MOPD2 distils through three streams, which separates demonstrations as targets from demonstrations as starting contexts. Distilling specialists into one checkpoint is not the same thing as routed experts inside it.
- **Why written facts are fragile.** Fine-tuning on new facts collapses old ones within about a hundred steps, with the damage in the FFN stores (Zucchet et al.). Some of that forgetting is a shared shift, not erasure (Palit et al.). Link *Where Experience Goes* and *Who Teaches the Weights?* for the continual-learning side rather than recap it.
- Post-training as the main source of release-to-release change: GLM-5.3, V4.1-Flash-1017 ("RL with self-feedback"), K3.1 Pro ("substantially larger post-training compute"). This closes the loop opened in §5.

#### §11 What the reports disclose

**Purpose:** a short, honest accounting.

- Which training facts are disclosed for which model, and which are missing: Qwen3.8's training provenance, production MiniMax M3's data and post-training, GLM's parameter accounting.
- Open weights are not open training: weights, license, training code and data are separate properties.
- Benchmarks across models cannot isolate an architectural change when data, compute and harnesses differ. Published ablations can.

#### §12 Closing

- Return to the opening question: where did the prompt go? Answer it in the essay's terms for the three models of §0.
- One paragraph pointing ahead: the stores this essay describes are what any account of a model's states has to be about. Questions of carriers, persistence and regulation belong to the mindedness essay.

---

## 3. Register and devices

- Equations as in *How Does a Policy Improve?*: the attention equation, the store equations of §2, the delta rule, the affine composition of §6. Each is introduced by what it computes, before its symbols.
- Worked examples numbered from 1 in this essay. Candidates: the $d_k=128$ head under two criteria (§2); the dossier's three calculations (§§3–4); a cost comparison for a 1M-token prompt across three of the seven (§3 or §0).
- Inline links at first mention, as in the continual-learning series; a sources paragraph at the end.
- Evidence discipline from the dossiers carries into the prose: what a config declares, what a report claims, what a study measured at what scale.

## 4. Open questions

1. ~~Opening~~ Decided 26 Oct: the three-model 1M-token prompt opens; the hybrid result lands in §3.
2. ~~Where the store vocabulary enters~~ Decided 26 Oct: §2 is a full section, with the classical lineage in boxes or subsections.
3. **§6's weight.** The depth-and-monitorability section is the most theoretical. Keep it in Part A, or close the essay with it after Part B?
4. **Figures.** Five original figures are planned. Draw them as SVG for the blog. Substack needs raster versions, which the publish script can produce.
5. **Remaining research before drafting**, from the dossiers: read the V4 equations for Single-Pass mHC; read MSA and DSA ablations; resolve the Qwen output-gate mismatch; read 2609.19101 in full; check K3.1 Pro's config on release.
