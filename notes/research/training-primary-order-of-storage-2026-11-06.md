# Primary-source read: the order in which training writes the stores

Research date: 6 November 2026. Status: a checked source note for *Filling the Stores* (outline §§8 and 10; `associative-memory-view.md` finding 4). Labels follow the repo's convention. **Confirmed**: read in the primary text. **Reported**: the authors or a vendor say so, and I did not verify it, or I read only the abstract. **Inferred**: my reading, or my arithmetic.

Coverage, stated honestly. I read text extracted from the PDFs. I did not look at figure images, so values that exist only in plots are absent here. Main text read in full for items 1–7, with these limits: for 2503.21676 all appendices; for 2404.05405 main text and Appendix D, the other appendices by search; for 2505.17863 main text and Appendix D.1; for 2608.15448 main text and Appendix A's statements and validation, not the proofs or Appendices B–G; for 2610.08718 main text and Appendices A, C.4, C.5, D.2, D.3; for 2610.03529 the sections bearing on post-training; for the tutorial Part II in full. Papers in §8 and §9 were read for the passages quoted, and each is marked where only the abstract was read.

---

## A. Corrections to the outline and the note

Each row is a claim as it now stands, what the source supports, and a suggested fix.

| # | Where | Claim now | What the source says | Fix |
|---|---|---|---|---|
| 1 | Outline §10 (planned) | Nobody has measured what RL changes in the stores | **False as stated.** Weight-level, feature-level and circuit-level measurements exist, one on a 671B pair (§8 below). | Restate: see the sentence at the end of §8.3. |
| 2 | Outline §8, note §4 | "at 44M to 400M… the plateau grows almost linearly with the number of individuals" | The scaling fit is on the 44M model only. The 163M and 400M runs are one robustness ablation at default population. Patching and fine-tuning are 44M only. | "In a 44M model…; the three phases also appear at 400M." |
| 3 | Same | "almost linearly" | The authors' words, but the fitted exponent is 0.81: doubling the population lengthens the plateau 1.75 times. | Give the exponent: $y=0.43\,x^{0.81}$, $R^2=0.998$. |
| 4 | Outline §8 | "Routing has to exist before storage is usable" | Too strong. The authors: "Prior to circuit formation, task learning remains possible… but progress is slow." Their claim is about speed. | "Until the routing forms, facts are written slowly." |
| 5 | Thesis, outline §1 | "circuits that route information form before facts can be stored" | Holds for recall measured at the output. In the companion toy model the order in the weights is the reverse at the start: "feedforward weight learning precedes and drives attention learning." The two then reinforce each other. | Say the circuit forms before facts become *recallable*. See §2 below. |
| 6 | Outline §10, note §4 | "with the damage in the FFN stores" | In 2503.21676 this is inference, not localization: stable attention statistics plus a one-hidden-layer MLP that reproduces the collapse. Direct evidence elsewhere is mixed (§1.6). | "The attention patterns stay stable, which points at the feed-forward stores." Then cite Kaplan et al. and Palit et al. C.5. |
| 7 | Outline §10 | "Some of that forgetting is a shared shift" (linked to Zucchet's collapse) | Palit et al. never test Zucchet's setup. Their nearest condition, new answers drawn from the whole pool, gives slow forgetting without a collapse. The shift needs concentrated new answers. | Keep the two results apart: a collapse in one setup, and a mechanism shown under a stated condition in another. |
| 8 | Note §4 | "Three ingredients are required" | Required for collapse *and recovery*. Without normalization the old facts still collapse and "never recover". | "Shared keys and concentrated values cause the collapse; normalization lets it reverse." |
| 9 | Note §4 | OLMo-2 1B, "from 0.28 to 0.77" | Correct, but the edit also cuts new-fact recall at step 400 from 0.90 to 0.40. The test set is 422 old facts in one model, and the small new-fact set of 250 individuals. | Give the cost beside the gain. |
| 10 | Outline §8 | "a context with $k$ plausible continuations costs about $k$ times the storage" | Proved for a linear-softmax head, top-$k$ criterion, up to logarithms, $k\ll d$. A trained head has log-log slope $-0.77$, not $-1$. | Name the criterion and the head. "About $k$ times" for the theory; "somewhat less than $k$" for the trained head. |
| 11 | Outline §8 | "About 2 bits per parameter after about 1,000 exposures" | A peak ratio over models up to 0.5B, from a bit-complexity bound on synthetic facts. Other work gets 1.6, 0.5–1 and 3.5–3.6 under other set-ups (§9). | "About 2 bits at best, in models up to half a billion parameters." |
| 12 | Outline §2 | "Per parameter, trained stores hold about 2 bits" | Same paper: "the Attention layers are also capable of storing knowledge"; removing all MLP layers leaves the 1000-exposure ratio unchanged. The bound is for the model, not for the FFN. | Attribute 2 bits to the whole model. |
| 13 | Note §2 | Result 9 | Confirmed, with 1.5 times at 100 exposures. Tested at 32 experts per layer, with `topk=1, cap_factor=2` as the sparsest case. GLM-5.3's config gives 256 routed experts, and K3.1 Pro's gives `num_experts: 896`. | Add the scale gap. |
| 14 | Outline §10 | "K3.1 Pro" as post-training-driven change | Moonshot says it is post-trained from K3, but the model card and tensors show an architecture change: 24 Gated MLA layers became Gated DSA, adding 120 tensors and 178,526,208 parameters. | Do not pair it with GLM-5.3 as "same architecture". Update §5's K3.1 note. |
| 15 | Outline §10 | "Fine-tuning… collapses old ones within about a hundred steps" | Confirmed ("on the order of a hundred steps"), but at 44M with a constant learning rate of $3\cdot10^{-5}$, and "some knowledge… remains": a loss near the baseline does not mean erasure. | Keep the number, add the condition. |

---

## B. The seven readings

### 1. Zucchet et al., arXiv 2503.21676 (v2, 24 Jul 2025): "How do language models learn facts?"

**1.1 Data.** [Confirmed, §1.2, App. B.2] $N$ individuals, each with a unique full name and six attributes: birthdate, birthplace, university, major, company, location. Pools: 900 first and middle names and 1,000 last names; 800 cities; 200 universities; 100 majors; 500 companies; dates drawn independently. There are 25 templates per attribute, generated by a language model and hand-filtered so that the name and attribute type precede the value. For each individual 20 are used in training and 5 held out. "Biographies are resampled for each new sequence", and the name recurs in every sentence. Unlike Allen-Zhu and Li's bioS, they "never repeat biographies".

**1.2 Models and training.** [Confirmed, §1.4, App. B.3, Table 1] Default: 8 layers, residual width 512, FFN 2048, 8 heads with keys and values of 64, about 44M non-embedding parameters; AdamW, cosine schedule, peak learning rate $4\cdot10^{-4}$, weight decay 0.1, batch 128, sequence length 512, 16k steps, 64k individuals. The 163M (12 layers, 16 heads, dimension 896) and 400M (12 layers, 12 heads, dimension 1536) models appear only in the model-size ablation of Figure C. Figure 2 uses 5 seeds; "we… ended up using a single seed for the rest of the experiments."

**1.3 The plateau.** [Confirmed, §2.1, Fig. 2] Three phases: "Initial language understanding", then "Performance plateaus at the edge of knowledge acquisition", then "Knowledge emergence".

- The no-knowledge baseline is "the entropy of the attribute value distribution". Attribute loss is the cross-entropy summed over attribute-value tokens, averaged by the six attributes and the batch, not by tokens.
- **The plateau's end has no operational definition in the text or appendices.** Figure 2's axis reads "Plateau end (steps)", and the prose speaks of "the number of training steps needed to escape the plateau". No threshold is stated. The companion paper does state one (§2 below), but not for this task. [Confirmed by text search]
- Scaling: "The plateau length grows almost linearly with the number of individuals (Figure 2, right panel), supporting the statistical hypothesis." The figure's fit: $y=0.43\,x^{0.81}$, $R^2=0.998$, with $N\in\{4k,\dots,256k\}$ (G.2). The caption says "nearly proportional". The statistical hypothesis: "the model needs to observe multiple biographies from the same individual to discern that attribute values are specific to each individual".
- What the fit implies at batch 128 [Inferred]:

| Individuals | Plateau end (steps) | Biographies per individual by then |
|---|---|---|
| 4k | 356 | 11.4 |
| 16k | 1,093 | 8.7 |
| 64k | 3,361 | 6.7 |
| 256k | 10,331 | 5.2 |

So the plateau ends after about 5 to 11 biographies per individual, and the count falls as the population grows. This is the sublinearity seen another way, and it fits a circuit that transfers across individuals. The hand-sized sentence: the model needs to see each person only about half a dozen times before it starts to tell them apart.

- With imbalance: "plateau length scales with the frequency of the most prevalent individuals", "whereas knowledge acquisition speed primarily depends on the frequency of the least prevalent ones". The $\alpha$ that minimizes plateau length "lies between 0.6 and 0.8, irrespective of the population size".

**1.4 Attention patching.** [Confirmed, §2.2, App. D.1, Fig. 3]

- What was transplanted: **attention patterns, not weights.** Footnote 1: "We call attention patterns the softmax of the attention logits." Training restarts "with the same initial parameters", and a reference model, frozen at some step, runs beside the modified model on the same samples and passes its attention scores layer by layer, with gradients stopped. "This means that all the token-to-token interactions are specified by the reference model and that the modified model only learns token-wise feedforward transformations."
- Reference checkpoints: steps 0, 500, 1k, 2k, 4k, 8k, 16k. Two configurations: `start_patching=0` (the main text) and `start_patching=reference_patching` (freezing attention at a point).
- Result: "the plateau disappears when providing the model with learned attention patterns (i.e. post-plateau patterns)." And a twist the outline omits: "the attention patterns acquired early during learning (e.g., at steps 500 and 1k) are significantly worse than the pre-learning ones", because attention then sits on attribute-type tokens.
- Mechanism proposed: without the circuit "errors are spread across irrelevant tokens". The extraction circuit forms across the plateau, while the name-grouping circuit emerges "within a few hundred steps", which "may be specific to our setup".
- The authors' own limits: "our results do not rule out that other qualitative changes may occur during this phase, and they do not provide any mechanistic insights regarding how models acquire individual-specific knowledge." The attention analysis "is purely correlational" and "ignores the impact of the values".
- Robustness: the phases recur with a recurrent mixer (Hawk, RG-LRU) in Figure C. So the *plateau* is not specific to attention, and the credit-assignment argument is said to generalize. [Confirmed]

**1.5 Hallucinations.** [Confirmed, §4.1, App. F.2, Fig. 5 left, Fig. M] Measured on 16k held-out individuals: attribute loss above the baseline means overconfidence. "hallucinations emerge simultaneously with knowledge acquisition about the training individuals, suggesting they may be a counterpart to accurate predictions." Appendix wording: "shortly after the plateau phase". The model stays "less confident in these hallucinations than in its grounded predictions". The authors call this "only a preliminary exploration".

**1.6 Fine-tuning collapse.** [Confirmed, §4.2, App. F, G.5]

- Set-up: start from the default 16k-step, 64k-individual model. New individuals $\in\{1k,\dots,16k\}$. Constant learning rate $3\cdot10^{-5}$.
- Timing: "a rapid collapse in performance on pre-training data during the initial stages of fine-tuning (first few hundred steps), with very little corresponding acquisition of new knowledge"; App. F.3: "on the order of a hundred steps". "A larger number of fine-tuning individuals intensifies this effect."
- Not total: "the increase in loss to values close to no-knowledge baseline does not necessarily mean that all pre-training knowledge is erased as some knowledge (i.e. non-zero accuracy) about the pre-training data remains." The section heading does say "erased"; the appendix softens it.
- Replay: Figure 5's caption: "Incorporating replay of pre-training data partially mitigates the final performance drop, but not the initial decline." The body text says replay "partially mitigates the initial collapse and facilitates the restoration of corrupted knowledge". The two sentences differ. The note follows the caption. [Confirmed; the discrepancy is in the paper]
- A condition the outline omits: "we do not observe such degradation when fine-tuning on subsets of the pre-training data". Fine-tuning on rare seen individuals raised non-celebrity accuracy from 50% to about 70%. New *keys* do the damage.
- Where the damage is. Evidence is two-pronged. Attention patterns are "remarkably stable" in fine-tuning (Fig. O: one run, 4k individuals, no replay, four summary statistics) and in the switching-distribution runs (Fig. X), "therefore mostly ruling out this hypothesis". And "a one hidden layer multi-layer perceptron" with 256 units, 64-dimensional keys and 30 values, "which has no attention layers at all", reproduces the main findings, "suggesting that changes in the feed-forward associative memories… are the main factor". App. F.4: "provide evidence for the hypothesis that mostly feed-forward associative memories are altered". **No weight or layer was measured in the 44M model.** The word in the abstract, "corrupts its existing parametric memories", is the authors' interpretation.

### 2. Zucchet, D'Angelo, Lampinen and Chan, arXiv 2505.17863 (NeurIPS 2025)

**When sparse attention emerges.** [Confirmed, §§2.1–2.2] Task: single-location linear regression, $y^*=W^*x_T$; a toy with $y=W\sum_t\mathrm{softmax}(a)_t x_t$, where the attention scores $a$ are free parameters and use no semantic information. Plateau: linearizing gradient flow gives the escape time to $(1-\varepsilon)$ of the initial loss,
$$T_\varepsilon=\frac{\sqrt{d}\,T}{2}\ln\!\big(\varepsilon\sqrt{d}\,T\big)\quad\text{(Eq. 6)},$$
with $\varepsilon=0.8$ in simulation. The fit with in-context repetition in Figure 2 is $T_{\text{plateau}}=1.51\,T^{0.99}B^{-0.99}d^{0.49}$, $R^2=0.999$. [Fit Confirmed. The equation is rebuilt from the PDF's layout, and it agrees with the stated scaling and the fit; check the factor of 2 against the rendered page.]

**The order inside the toy, which matters for the essay's thesis.** [Confirmed] "the feedforward weight W must first align with the target weights W* before attention can learn. A positive feedback loop is then progressively established: increased attention improves the learning signal for w, and a better-learned w further reinforces the correct attention pattern." And: "it confirms that feedforward weight learning precedes and drives attention learning". Figure 1's panel b caption: "the weights w begin learning before attention to the relevant token α". This sits awkwardly beside "circuits before facts", though the two can be reconciled. [Inferred] What precedes the circuit is alignment of the feed-forward weights to the shared map; what follows the circuit is individual facts. The toy has one map, not many facts, so it cannot speak to the second. The essay should not cite this paper as showing that attention moves first.

**Repetition.** [Confirmed]

- In-context repetition: effectively shortens the sequence from $T$ to $T/B$. Toy: escape time scales as $T\sqrt{d}/B$.
- Cross-sample repetition: plateau scales as $\sqrt{d}\,T/\sqrt{p^2d+(1-p)^2}$. It "only provides a temporary advantage": "In the long run, learning is slower".
- Transformer (2 layers, 4 heads, Adam at $10^{-4}$, no layer norm): $T_{\text{plateau}}=0.76\,d^{1.29}T^{0.80}B^{-0.80}$, $R^2=0.995$.
- In-context associative recall: $T_{\text{plateau}}=0.55\,N_{\text{tokens}}^{0.79}N_{\text{pairs}}^{2.25}$, $R^2=0.982$, with emergence "arbitrarily defined as the time needed to reach 5% accuracy". (The two exponents are given in §3.2; the figure caption's superscripts did not extract.)
- The headline: "repetition can significantly speed up emergence, by a factor of 4 for in-context repetition and a factor of 2 for cross-sample repetition." Conditions: $N_{\text{pairs}}=32$, $N_{\text{tokens}}=256$, evaluated on data with no repetition.

**Caveats.** [Confirmed]

- "the precise dependencies differ": "optimizer, architecture, and task specifics all influence these exponents". Replacing Adam by SGD slows emergence by "up to almost two order of magnitudes" on hard versions; single-layer single-head fits are $6.42\,d^{1.44}T^{1.07}$ for SGD against $1.45\,d^{1.31}T^{0.57}$ for Adam.
- Under cross-sample repetition, "power laws no longer accurately describe the empirical relationship".
- Overfitting: "too much repetition leads to learning strategies that do not generalize well", and test accuracy shows "some grokking-like patterns".
- "even simpler MLPs can give rise to abrupt emergence", and large-scale emergence is "unclear" between longer training and larger models.
- The factors of 4 and 2 are for an induction head on a toy recall task, not for factual recall. Outline §8's "Repetition speeds the emergence of the routing" is a fair summary only if it is said to come from that task. The note's "no capacity result here" holds. [Inferred]

Plateau measurement (App. D.1): toy, test loss at 0.2 of its initial value; Transformer, same, or 0.4 under cross-sample repetition; recall task, 5% accuracy. The thresholds differ across conditions, so the exponents are not strictly comparable. [Confirmed; last clause Inferred]

### 3. Allen-Zhu and Li, arXiv 2404.05405 (v1, Apr 2024; ICLR 2025)

**Data.** [Confirmed, §2.2] bioS($N$): biographies regenerated on the fly with new templates and order, 50 templates per attribute. bioS-simple: one fixed biography per person. bioR: 40 rewrites per person by LLaMA2. bioD: controlled synthetic family. $N$ reaches 20M for bioS and 1M for bioR. Six attributes, about 47.6 bits per person ignoring names (Remark 4.4).

**Models.** [Confirmed, §2.3] "GPT2" here means GPT-2 with rotary embeddings and no dropout, from random initialization. GPT2-$\ell$-$h$: $\ell$ layers, $h$ heads, $64h$ dimensions.

**Criterion.** [Confirmed, §§3–4] Not recall accuracy but a capacity ratio built on a proved lower bound on bit complexity, computed from cross-entropy losses summed over knowledge tokens. For bioS:
$$R(F)=\frac{N\log_2\frac{N_0}{e^{p_1}}+N\log_2\frac{S_0}{e^{p_2}}}{P},\qquad R_{\max}(F)=\frac{N\log_2\frac{N_0}{N}+N\log_2 S_0}{P},$$
with $p_1$ the name loss, $p_2$ the value loss, $N_0=400\times400\times1000$ possible names, and $S_0$ the count of possible attribute tuples (Definition 4.3, rebuilt from the layout; a perfect model has $p_1=\ln N$ and $p_2=0$, so $R=R_{\max}$, which checks it). Remark 3.5 explains why the bound is over a distribution of datasets.

**The numbers.** [Confirmed]

- **Result 1** (bioS, 1000 exposures, $N$ from 10K to 10M, GPT2 from 1M to 0.5B): "(a) the peak capacity ratio R(F) consistently exceeds R(F) ≥ 2; (b) models with Rmax(F) ≤ 1.8 attain near-perfect knowledge accuracies… (c) across all models, R(F) ≤ 2.3."
- **Result 4** (100 exposures): "the peak capacity ratio R(F) consistently exceeds R(F) ≥ 1". Therefore "training with just 100 exposures results in a capacity loss of no more than 2x."
- Definition of exposure: "each knowledge piece to be visited 1000 times during training, termed 1000-exposure to differentiate from traditional '1000-pass' terminology". A bioS run of 1000 exposures is under one pass.
- Largest runs: "Training GPT2-20-16 on bioS(10M) for 1000 exposures costs 8.5 days with 64 A100s, while GPT2-12-32 on bioS(20M) for 100 exposures took 2.4 days. In our synthetic setting, we see no need to scale up further."
- Extractability: "the '2bit/param' result is not about word-by-word memorization". Checked by fine-tuned QA (Appendix A.2, not read).
- Conclusion wording: "a sufficiently-trained transformer (i.e., one whose training loss has plateau-ed) can store 2 bits of knowledge per parameter, even when quantized to int8".

Peak ratios are the operative numbers. Most models sit below them. Result 1(b) gives the safe rule: "selecting a model size P ≥ B/1.8 is sufficient".

**Result 5, which the outline should use.** [Confirmed] "In the 1000-exposure setting, architectures do not matter much… Reducing the MLP size of GPT2 architecture by 1/4 or even eliminating all MLP layers does not affect its capacity ratio… This suggests, contrary to conventional beliefs, the Attention layers are also capable of storing knowledge." At 100 exposures removal costs more than 1.5 times (Result 6). And the "preliminary answer" from §8: "It is unlikely that the MLP layers alone store knowledge", with knowledge "akin to a safe with combination locks". So capacity tracks parameters, not FFN parameters. That belongs next to any sentence calling the FFN *the* store. [Inferred for the placement]

**Result 6/7.** Gated MLPs cost 1.3 times at 100 exposures, and "GatedMLP doesn't affect frequently encountered knowledge (with 1000 exposures)". This matters for the seven: the GLM and Kimi checkpoints, for instance, carry `mlp.gate_proj` tensors. [Confirmed; the relevance is Inferred]

**Result 8.** Post-training GPTQ quantization: int8 "negligible", int4 "reduces their capacity by more than 2x", to about 0.7 bit/param. It "suggests… incorporating quantization during training may be necessary." See §9 on 2609.32902.

**Result 9 (MoE).** [Confirmed, §9, App. D] GPT2's FFN ($d\to4d\to d$) is replaced by 32 experts ($d\to d\to d$): $64d^2$ total, $2d^2$ per token, with attention at $4d^2$. So total to effective is about 11.3, or 8.8% used. "in the 1000-exposure settings, the peak capacity ratio decreases by 1.3x; and in the 100-exposure settings, the peak capacity ratio decreases by 1.5x." Remark 9.1: holds at `topk=1, cap_factor=2`, using the tutel package; at testing `cap_factor=8`. Higher learning rates were needed. Remark 9.2: "this degradation does not come from the model's knowledge storage capability." Note also "Using topk=1 and cap_factor=1 is generally not advisable." [Confirmed] The note's account is accurate. Limits: 32 experts per layer, no shared expert, and synthetic facts. Independent support at scale: Li's probes on 93 open-weight models find, for MoE, total parameters predict knowledge ($R^2=0.67$) better than active ones ($R^2=0.41$). [Reported: abstract of 2604.24827]

**Results 10–12 (data quality).** [Confirmed] With 7/8 of tokens from junk ($N'=100$M), capacity falls by 20 times at 100 exposures, and by 3, 1.5 and 1.3 times at 300, 600 and 1000. Repetitive filler ($N'=1$K) does no harm. A special token on the useful data reduces the 20-fold loss to 2-fold. This is the closest the paper comes to natural mixtures, and it bears directly on outline §8's "Frequency decides what is stored". Gu et al. (§9) sharpen it.

### 4. Zucchet, Lee and Linderman, arXiv 2608.15448 (v1, 15 Aug 2026): "Language models suffer from a curse of ambiguity"

**Definitions.** [Confirmed, §2, App. A.1] Linear head $W\in\mathbb{R}^{d\times h}$ over embeddings of dimension $h$ and vocabulary $d$. Each context's target $p_i$ is uniform on a random support $S_i$ of size $k$. Embeddings are random on the unit sphere.

- Top-$k$ capacity: "the largest n such that the top-k predictions of the model over all contexts i match the support of the true conditional distributions."
- $\varepsilon$-capacity: largest $n$ with KL below $\varepsilon$ for every context. Stricter.

**Exact statement.** [Confirmed, §3.1, Eq. 6, App. A]

- Text: "Root 1: capacity $\propto hd/k$".
- Hebbian variance: $\sigma^2\approx nk/(hd)$ for $k\ll d$.
- Lower bound, Theorem 1: the Hebbian model stores all $n$ contexts if $n\lesssim h/(C\rho(1-\rho)\log(hd/\delta))$ with $\rho=k/d$.
- Upper bound, Theorem 5, for "any linear-softmax model": no $W$ exists, with probability at least $1-\delta$, when $n\ge C\,(hd\log(hd)+\log(1/\delta))\big/\log\binom{d}{k}$. Since $\log\binom{d}{k}\approx dH(\rho)$, this reads $n\gtrsim h/H(\rho)$ up to logarithmic factors.
- Combined, Eq. 56: "capacity $\asymp h/(\rho(1-\rho))$", "up to logarithmic factors". For $k\ll d$ this is $hd/k$. Note the $k=d/2$ end: the expression is not $hd/k$ across the whole range.
- "A size-k distribution requires k times more capacity than a deterministic one".

The scope is a linear head on given embeddings. Section 3.1 concedes the extension: "The fact that it recovers this universal scaling suggests that its dependence on ambiguity extends to more general models as well." That is suggestion, not proof. "Minimizing the actual cross-entropy loss by gradient descent would yield different weights with greater capacity, so this analysis only provides a lower bound on capacity."

**Experimental support for capacity.** [Confirmed, App. A.6] Linear head, $h=d=128$ (16,384 parameters), Adam on exact KL, batch 2,048, 150,000 steps, $k\in\{1,2,4,8,16,32\}$; capacity $n^*$ is the largest $n$ with median top-$k$ accuracy above 0.99.

- "the learned capacity exceeds the Hebbian one by a factor between 7 and 15, and the log-log slopes of $n^*$ against k are −0.77 (learned) and −0.97 (Hebbian)."
- Worked values: $n^*=1,030$ against 1,028 at $k=4$; 340 against 385 at $k=16$ (reduced protocol against full sweep). That is about 0.063 memories per parameter at $k=4$. [Inferred]
- Figure 7 verifies proportionality to $hd$ for $h=d\in\{32,\dots,256\}$.

So under training, fourfold more ambiguity from 4 to 16 costs about 2.7 times, not 4 (slope about $-0.71$ on those two points). [Inferred]

**At higher levels.** [Confirmed, §5]

- 4-layer, 4M Transformer on word 3-grams from TinyStories, 100M tokens: "performance degrades as effective support size increases at fixed context frequency", by leaking mass outside the support. Capacity and steps *shift* the iso-loss contour; embedding size and KL training *rotate* it.
- OLMo-2 1B against OLMo-2 13B as proxy ground truth, on 100,000 Dolma sequences of 512, pre-post-training checkpoints: "At fixed semantic context frequency, more ambiguous contexts are harder to model".

These support the *direction*, with KL as outcome, not the $1/k$ *rate*. Capacity in the sense of Section 3 is measured only on the linear head. Both proxies "are biased". The authors say "the picture there is less clean than in synthetic settings", and structure lets "rare contexts… be accurately predicted via shared, compressed mechanisms". [Confirmed; the rate distinction is Inferred]

Also relevant to §10: "Fine-tuning distributions that significantly differ from the pretraining distribution should also remain particularly exposed." [Confirmed]

### 5. Zucchet's tutorial, https://nicolaszucchet.github.io/Tutorial-scaling-laws (slides 24–49)

**Assumptions.** [Confirmed] Language modeling as context-to-next-token memories, with "No structure shortcuts the learning"; embeddings i.i.d. on the unit sphere; contexts follow "$p(i)\propto i^{-\alpha}$"; "Only one out of the d tokens exists in the data". Linear-softmax head.

**Derivation.** [Confirmed, slides 37–41]

- Model size: "assume infinite data, and that the first contexts below capacity get 0 loss and some value l afterwards." Then $L(N)\propto\sum_{i>\mathrm{capacity}(N)}i^{-\alpha}\,l\propto N^{1-\alpha}$.
- Dataset size: "assume instead that the model gets right every context it has seen at least once." Context $i$ is seen when $p(i)D\ge1$, i.e. $i\le D^{1/\alpha}$, so $L(D)\propto D^{\frac1\alpha-1}$.
- "Whatever the value of α, the bottleneck is the data D." "As α increases and the tail becomes rarer, the data becomes even more of a bottleneck."
- With Chinchilla additivity and $C=6ND$: $N^*\propto C^{1/(1+\alpha)}$, $D^*\propto C^{\alpha/(1+\alpha)}$, $L\propto C^{(1-\alpha)/(1+\alpha)}$.
- Simulation: "The loss decreases as $C^{-0.091}$ (predicted $C^{-0.091}$), the model size grows as $C^{0.449}$ (vs. $C^{0.455}$)." These numbers imply $\alpha=1.2$. [Inferred; the slide does not state it]
- Capacity: "stores 0.16 memories per parameter", Hebbian 0.02, at $d=256$, slope 1.01. At 8 bits per token choice, 0.16 is about 1.28 bits per parameter. [Inferred]

**Why "data is the bottleneck".** [Inferred] For $\alpha>1$, $|1/\alpha-1|<|1-\alpha|$, so loss falls slower in $D$ than in $N$. And the optimum has $D^*\propto(N^*)^\alpha$: tokens must grow faster than parameters. The tail sums converge only for $\alpha>1$. Word frequencies have $\alpha$ near 1, so the tutorial's $\alpha$ belongs to contexts and is a modelling choice.

**A hand-sized example.** [Inferred; arithmetic checked, script in the session scratchpad] Take $\alpha=1.2$ and 0.16 memories per parameter. Then $\zeta(1.2)=5.59$, so $p(i)=i^{-1.2}/5.59$.

| Parameters | Memories held | Tokens that fall beyond the store | Tokens to see the last memory once |
|---|---|---|---|
| 1M | 160,000 | 8.1% | 9.8M |
| 10M | 1.6M | 5.1% | 156M |

Ten times the parameters cuts the tail by over a third (×0.63) and needs 16 times the data (×15.8). One doubling of the store cuts the tail 13% and needs 2.3 times the tokens. At fixed compute the toy keeps these in step: 55% of each compute increase, in log terms, goes to tokens and 45% to parameters.

A frontier extrapolation shows what the toy cannot carry. At 33T tokens, the ranks seen at least once reach about $4.4\times10^{10}$, which 274B parameters would hold. Requiring 100 exposures, as Allen-Zhu's Result 4 suggests, the ranks fall to $9.5\times10^{8}$, or 6B parameters. **Do not print this as a claim about any model.** Contexts are not random keys, one exposure does not store a fact, and $k=1$ is false. It shows only that the toy's conclusion rests on those assumptions.

**Caveat, verbatim.** [Confirmed, slide 48] "Warning. We cannot say anything on whether this mechanism is the bottleneck that yields specific scaling behavior in actual LLMs, we can just say how changing the data affects scaling (which would be much harder in practice!)." Slide 49: "This is only one possible theory of scaling laws and we do not yet understand which mechanisms yield the scaling laws." Slide 47: the toy "does not capture emergence through learning". And in the slides' own results: "Additive scaling laws do not extrapolate well."

One small oddity. An HTML comment in the page's source digitizes Allen-Zhu's Figure 1(a) and lists peak ratios up to 2.72 at $N=$500K and 1M, above the paper's "R(F) ≤ 2.3". It is unpublished and I could not reconcile it. It is not for citation. [Confirmed that the comment exists]

### 6. Palit, Draye, Zucchet, Jin and Schölkopf, arXiv 2610.08718 (v1, 6 Oct 2026): "When forgetting is not catastrophic"

**The phenomenon.** [Confirmed, §2] Collapse: "recall of A quickly drops, well before the new facts are learned." Recovery: "partially returns as the new facts are acquired, although A never reappears in training." Erosion: declines "slowly and persistently".

**The three ingredients.** [Confirmed, §3] Abstract: "keys with shared structure, concentrated new values, and normalization in the network." Keys: $k_i=\sqrt\alpha\,\mu+\sqrt{1-\alpha}\,e_i$. Model: $p_i=\mathrm{softmax}(W_2\,\mathrm{RMS}(h_i))$, $h_i=W_1k_i$. "removing any one of its ingredients breaks this trajectory."

- Shared keys: under gradient flow $\dot h_a\approx-\alpha\bar\delta_B$. All old hidden states move together.
- Concentrated values: errors of the new facts agree only if their answers lie in one region. "When the new answers are instead drawn from the entire vocabulary, this common push largely cancels, and so does the collapse."
- Normalization: "Without normalization, or with a ReLU in its place, the old facts collapse and never recover." So it governs the reversal, not the collapse.

"The facts of A are hidden, not erased": their relative geometry survives, and "the readout weights of their answers are barely changed by finetuning". Removing the shared part of the update "restores their recall almost entirely". The fact-specific displacements still accumulate. [Confirmed, §3.3]

**Transformer.** [Confirmed, §4, App. A.1] 8 layers, dimension 512, 8 heads, pre-LayerNorm, no MLP blocks by default, 2,000 + 2,000 pretraining individuals with attribute values split in two halves, 500 new ones, 16,000 steps pretraining, 1,200 fine-tuning, peak $3.75\times10^{-5}$. "subtracting the common part removes the collapse entirely".

**Localization, the most useful number here for outline §10.** [Confirmed, App. C.4, C.5] Restoring one group of weights to its pre-fine-tuning value at the end of the collapse, and measuring the common shift of the old facts' final hidden states:

| Architecture | Attention value + output | MLP | Attention query + key | Embedding, LayerNorm |
|---|---|---|---|---|
| Attention-only | 84% | n/a | 11% | small |
| With MLP blocks | 47% | 46% | 3% | under 2% each |

"the shift is again written into the associative memories of the network rather than into where attention goes… the update that all new facts share is written wherever the network stores associations, in proportion to how much each store takes part in learning them." And: "The collapse is thus a change in what the network writes about each fact, not in which tokens it reads." That agrees with Zucchet on routing and disagrees with reading "FFN" narrowly. It is a toy at 4,500 individuals, and shares can overlap ("they need not add up to 100%").

**OLMo-2 1B.** [Confirmed, §5, App. A.2, D.2, Table 3] Old facts: 1,106 CounterFact facts the model answers, of which 422 are evaluated, those whose answer is not in the prompt; pre-fine-tuning recall 0.87. New facts: synthetic individuals (250 or 1,000, four attributes, 66 values) or 1,415 real product–manufacturer facts. 32,768 tokens per step, AdamW at $10^{-5}$, 100-step warmup, 3 seeds, no replay.

The edit: for each of the 112 matrices in the 16 layers (attention Q, K, V, O and three MLP matrices), subtract $\sigma_1u_1v_1^\top$ of $W(t)-W(0)$. Embedding and unembedding are untouched. "The removed direction is small: it holds about 15% of the squared norm of a typical update."

| New facts | Step | Old: trained | Old: top removed | Old: random removed | New: trained | New: top removed |
|---|---|---|---|---|---|---|
| Synthetic (small set) | 80 | 0.28 | 0.77 | 0.28 | 0.03 | 0.01 |
| | 400 | 0.38 | 0.70 | 0.38 | 0.90 | 0.40 |
| Real entities | 80 | 0.73 | 0.88 | 0.73 | 0.46 | 0.25 |
| | 400 | 0.55 | 0.79 | 0.55 | 1.00 | 0.66 |

Recovery without the edit happens for synthetic individuals only: "With real entities, the old facts never recover". "What helps a model generalize to new facts may thus be what keeps it from recovering the old ones."

**Limits.** [Confirmed] "Our minimal model is deliberately extreme, and normalization-driven recovery is likely weaker on real data, although the collapse may be more general… we study a single model."

**The gap to Zucchet's collapse.** [Inferred] Zucchet's new individuals draw values from the same pools as the old, which is Palit's condition C. In Palit's Transformer, C gives slow forgetting ("to 0.94 after 1,000 steps" with MLP blocks) and no collapse. Zucchet's setup still collapses, at a similar learning rate. The set-ups differ in population (64k against 4k), recall at the start of fine-tuning, and fine-tuning size. So Palit et al. supply a mechanism, and do not show that Zucchet's collapse is that mechanism. Their discussion lists Zucchet only among "performance drops sharply at the start of a new task". "Hallucination" and overconfidence on the new keys (Zucchet's account) and shared shift (Palit's) may both operate. This is an open question, and the essay should keep it open.

### 7. Zucchet and Linderman, arXiv 2610.03529 (v1, 2 Oct 2026): "Divergence controls entropy in distillation"

Only what bears on what distillation changes. [Confirmed, §§3–4 unless noted]

- **It measures output entropy, nothing inside.** The memory view appears once, in the toy model's description: "as an associative memory model (Cabannes et al…)". This confirms the note. It gives no weight, layer or activation measurement.
- Forward KL: the student's average entropy equals its average cross-entropy with the teacher at a stationary point, "inflates the student's entropy above the teacher's by the residual divergence". This "does not require the two distributions to be close. It only requires a softmax head". Since cross-entropy training is off-policy distillation against an implicit teacher, it extends to pretraining and SFT. Verified on OLMo 2 (1B, 7B, 13B) and Pythia.
- "Entropy decreases everywhere during finetuning even though we are using a forward KL objective", reflecting "the low entropy of the finetuning data". "supervised finetuning breaks it on the pretraining data."
- Reverse KL deflates entropy "until the gap between student and teacher gets too large". No average inflation was seen at scale.
- On-policy against off-policy: "the lower entropy of on-policy distillation is mainly due to reverse KL". The divergence's effect is two to three times larger than that of on-policy sampling. Experiment: Qwen3 Instruct teachers (from 1.7B up) into a Qwen3-0.6B-Base student, math problems, single seeds.
- Self-distillation (Olmo 3 7B Instruct, chemistry from SciKnowEval, and GSM8K): "With reverse KL, entropy collapses". A live teacher also collapses it; an EMA teacher "behaves like a frozen teacher and prevents the collapse".

For outline §10: this gives the output-side account of what distillation changes, and its scale is 0.6B to 13B. It speaks to MAI's dropout-for-entropy choice only by analogy. [Inferred]

---

## C. What post-training changes inside a model

### 8.1 Verdict

**The claim "nobody has measured what RL changes in the stores" is false.** At least ten papers measure inside post-trained checkpoints. They cover weights, activations, features, circuits, and spectral geometry, on models from 1.5B to 70B, plus one pair at 671B total. What the literature lacks is narrower: a measurement of post-training that resolves the seven models' stores (delta-rule state, indexers, routed experts, mHC, Engram) on a frontier checkpoint, and any account in the essay's terms of facts being rewritten by RL.

### 8.2 Studies, with what each measured

Weight space:

| Citation | Stage, pairs | Scale | What was measured | Finding | Label |
|---|---|---|---|---|---|
| Mukherjee, Yuan, Hakkani-Tür, Peng, [2505.11711](https://arxiv.org/abs/2505.11711), NeurIPS 2025 | 7 RL algorithms, 10 models; released checkpoints before and after | 7B to 70B; `DeepSeek v3 base → DeepSeek-R1-Zero`, 671B total (size is public, not in the paper) | Fraction of parameters unchanged, tolerance $10^{-5}$; per-layer and per-matrix; rank of updates | 68.5%–96.0% unchanged, R1-Zero 86.0%. SFT only 6%–15%. "nearly all parameter matrices receive similarly sparse updates"; "the layer normalization layers" are the exception. Updates "nearly full-rank". | Confirmed, with the correction below |
| Zhu et al., [2511.08567](https://arxiv.org/abs/2511.08567), Meta | 15 pairs incl. Qwen3-30B-A3B → UloRL-A3B | 1.5B–30B | bf16-aware sparsity; 5-run consensus per Q, K, V, O, MLP; spectrum; principal-subspace rotation | RL 36%–92%, SFT 0.6%–18.8%; "absolute levels on recent checkpoints are lower than earlier reports". Row and column stripes in Q/K/V and O, "highly consistent across runs". Jaccard about 0.55–0.60 against 0.41–0.47 random in block 13. "RLVR learns off-principal directions"; "SFT targets principal weights, distorts the spectrum". | Confirmed |
| Wang et al., [2601.04537](https://arxiv.org/abs/2601.04537) | RLVR trajectories, 13 settings incl. MoE | 1.5B–8B, Qwen3-30B-A3B | Per-weight $R^2$ against training step; layer-wise heatmap; activations | "over 70% of weights achieving R2 > 0.7"; SFT near 0.4. Holds across attention and MLP. "all Layer Normalization (LayerNorm) layers exhibit consistently low linearity". | Confirmed |
| Wei et al., [2605.21468](https://arxiv.org/abs/2605.21468) | GRPO | 1.5B, 4B, 8B | SVD of each tensor's *trajectory matrix* (steps × flattened weights) | A rank-1 reconstruction recovers performance; coefficient near-linear, $R^2>0.98$ for most tensors. 15–20% of the steps suffice to extrapolate. | Confirmed |

A correction that must travel with these. Zhu et al. show the "sparsity" is partly a storage artifact: "the apparent update sparsity largely disappears" at larger learning rates, updates below bf16's unit in the last place do not change stored values, and "Consistent with this view, concurrent work observes that sparsity mostly vanishes under float32 storage (Shenfeld et al., 2025)". They reject the reading that gradients are zero, "challenges the interpretation of (Mukherjee et al., 2025) that sparsity stems from zero gradients", while keeping a real bias in where updates land. So never write that RL leaves 70% of parameters alone. [Confirmed for the paper; Shenfeld et al. not read] In an MoE, a further cause exists: experts that the RL data rarely routes to receive little gradient. No paper I read separates this. [Inferred]

And a trap: "rank-1" means different things here. Wei et al.'s rank is that of the trajectory, one direction per tensor through time. Mukherjee's "full-rank" is the rank of $\Delta W$ as a matrix. Palit's top direction is the top singular pair of $\Delta W$, which holds about 15% of the squared norm. The first two are compatible. Palit and Wei do not measure the same thing. [Inferred]

Activations, features and circuits:

| Citation | Stage, pairs | Scale | What was measured | Finding | Label |
|---|---|---|---|---|---|
| Du, Tang, Liu, Duan, [2609.15064](https://arxiv.org/abs/2609.15064) | RL (GRPO, REINFORCE, RLOO), 13 checkpoints every 50 steps | Qwen2.5-1.5B Instruct at layer 27 of 28; also 3B, 7B with LoRA | Shared SAE per layer, feature drift | "drift is small, gradual, concept specific, and concentrated in late layers". $\max_f|\Delta_f|$ rises from 0.013 at layer 6 to 0.060 at layer 27. About 86% of amplification comes in the first 50 steps. Steering amplified features into the base "recovers around 80% of RL's performance gain". At the best dose, strict accuracy goes 0.050 → 0.192 against RL's 0.175, and lenient accuracy moves little. | Confirmed |
| Zhang, Hao, Xu, Li, [2509.21044](https://arxiv.org/abs/2509.21044), ICLR 2026 | SFT → RL, 4 pairs | 7B | Edge attribution patching: activation intensity, entropy of edges | Intensity rises and patterns diversify for online RL; DPO is "substantially weaker or inconsistent". In Table 1 sizes vary by model, dataset and cutoff, and some cells reverse. | Confirmed |
| Shi et al., [2604.25011](https://arxiv.org/abs/2604.25011) | Base, SFT, RL from the same base, same data | Qwen3-4B, Qwen2.5-7B | Three-model sparse crosscoder | SFT "rapidly introduces many highly specialized features that stabilize early"; RL "more restrained and continually evolving", which "largely preserve base models' representations". | Reported: abstract, methods scanned |
| Li et al., [2509.23024](https://arxiv.org/abs/2509.23024) | Pretraining through SFT, DPO, RLVR | OLMo 1B–7B, Pythia 160M–12B, Llama-3.1-Tülu-3.1-8B | Effective rank and spectral decay of last-token representations | SFT and DPO are "entropy-seeking", RLVR "compression-seeking". | Reported: abstract, intro |
| Wang et al., [2502.11812](https://arxiv.org/abs/2502.11812) | Fine-tuning on math tasks | 1.4B–6.7B | Circuits across checkpoints | "circuits maintain high node similarity… their edges undergo significant changes". | Reported: abstract |
| Clark, [2601.07473](https://arxiv.org/abs/2601.07473) | Olmo-3-7B across stages | 7B | Steerability via representations | "on seven Olmo-3 models steerability correlates with post training"; safety-focused post-training reduces it. | Reported: passages only |

An apparent conflict resolves. Weight changes are spread nearly evenly across layers (Mukherjee), while activation drift concentrates late (Du). Drift accumulates through the residual stream, and SAE drift is measured on it, so the two are compatible. No paper tests this. [Inferred]

Expert usage and routing:

| Citation | What | Scale | Finding | Label |
|---|---|---|---|---|
| MAI-Thinking-1 report §3.1.5 | Expert selection during RL | 35B active, 1T total | "expert selection during RL can become highly imbalanced. However, using a large load balancing coefficient during RL also harms stable performance improvement." Coefficients $10^{-2}$ in self-distillation and $10^{-5}$ in RL. **The outline already holds this, and it contradicts the planned §10 sentence.** No numbers are given. | Reported by the lab |
| Caruzzo, Yoo, Kim, [2608.15787](https://arxiv.org/abs/2608.15787) | Same-weight self-distillation, single step, frozen weights | 7 checkpoints (Mixtral-8x7B, OLMoE-1B-7B, Qwen3-30B-A3B, others) | Teacher and student route differently, but "the full routing term moves outputs by less than half the natural context effect". "Router movement alone is therefore not evidence of behavioral influence". Accumulated drift is "outside this study". | Confirmed: abstract, intro |
| Wang et al., [2609.32821](https://arxiv.org/abs/2609.32821) | Merged specialist MoEs: DeepSeekMoE, OLMoE, Qwen3-MoE | Sizes not checked | 26.5–54.3% of token–layer expert sets change; of those, 77.7–96.9% change under replacing the input alone, against 0.1–2.6% for router parameters in the domain tests. | Confirmed for the numbers quoted |

The last row is the nearest thing to "gate statistics under post-training", though for merging, not training. It says routes move mainly because the router's *inputs* moved.

Facts under fine-tuning, at or above 1B:

| Citation | Scale | Measured | Finding | Label |
|---|---|---|---|---|
| Kaplan et al., [2604.15574](https://arxiv.org/abs/2604.15574), COLM 2026 | Qwen2.5-1.5B (trends also at 7B, Llama 3.1 8B) | Freezing attention or FFN during SFT on known + new facts; Table 1 | Attention only: new facts 0.010, known 0.946, held 0.931. FFN only: 0.941, 0.997, 0.782. All: 0.946, 0.990, 0.780. Baseline without new facts: held 0.958. | Confirmed |
| Palit et al. | OLMo-2 1B | §6 above | | Confirmed |
| O'Neill et al., [2607.11020](https://arxiv.org/abs/2607.11020) | Qwen3-4B, 8B; 20 sequential writes, LoRA or full | Behaviour under iterated writes | 1% of earlier questions answered with repeated statements, 46% with varied examples. Retention "depends on the data used for the later writes, regardless of training method or parameter update". | Reported: abstract |
| Marek et al., [2605.26097](https://arxiv.org/abs/2605.26097) | Up to 46M mostly | Forgetting against capacity | Self-generated replay "nearly eliminat[es] forgetting", except that "models pretrained close to saturation cannot absorb new information". | Reported: abstract |

Kaplan's Table 1 is the best evidence I found for outline §10's FFN claim, and it is a causal intervention on natural facts. Training only the FFN reproduces the full damage, and training only attention acquires no new facts while holding old ones. [Inferred reading] Yet attention-only training there includes value and output weights, while Palit assigns those 47% of the shift. And Allen-Zhu's no-MLP models store facts anyway. So which matrices hold facts depends on the architecture and on what is already stored. This conflict is unresolved.

One paper not to use yet: Laitinen-Fredriksson Lundstrom-Imanov, [2601.18699](https://arxiv.org/abs/2601.18699). On its face it is what the essay wants: weight-trajectory tracking, CKA and routing-gate drift under sequential fine-tuning on ten open-weight models including DeepSeek-V4-Pro, Qwen 3.5-397B and GLM-5.1. Three things stop me. It is single-author, with a claimed scale that would be a very large compute budget and no hardware statement that I found. Its "Data availability" says the code is public but my text search found no link. And it runs the same sequential pipeline on closed models including Claude Fable 5 and Claude Mythos 5 through "API output analysis", and I do not know how such models could be sequentially fine-tuned through an API. The "64 percent" freezing figure that a search summary attributed to it does not appear in my search of the v2 text. I could not verify its numbers, so cite it only after someone checks the code. [Inferred]

### 8.3 What can honestly be said

Suggested replacement for the §10 sentence:

> Post-training has been measured from the inside, on models up to about 70B and on one 671B pair: where the weights move, how late-layer features drift, what happens to experts. Nobody has published such a measurement that resolves the 2026 frontier's own stores, the delta-rule gates, the indexers, or the routed experts of a post-trained checkpoint. The labs that hold the intermediate checkpoints report symptoms, not maps.

And the content §10 can now carry. All are small-model findings offered as mechanisms. [Inferred synthesis of Confirmed results]

- RL moves weights along a stable, low-dimensional drift (Wang, Wei), away from the principal directions (Zhu), whereas SFT moves them across those directions and densely. The difference appears in the stored weights.
- Features change late, little and early, mostly formatting first (Du). Sustained RL adds some reasoning.
- RL's effect on the output is partly a shift in what is sampled: all 29 RL-fixed GSM8K problems were already solvable by the base within 64 samples (Du, Table 2).
- These sit oddly beside the industrial picture. All measure short RL on math at 1.5B–8B, often 600–3,000 steps. MAI's climbs and K3.1's "large-scale joint reinforcement learning across hundreds of downstream domains" are a different regime, and Du warn that sustained training adds reasoning.

### 8.4 Open-weight pairs: what direct comparison would meet

Has anyone done it? I found no published diff of any 2026 pair. Searches returned benchmark pages only. [Confirmed for my search; absence cannot be proved] What follows comes from Hugging Face metadata, config files, safetensors headers and index files, read on 6 November. **No weights were downloaded.**

| Pair | Parameters | Stored format | Tensor-name diff | Comparable? |
|---|---|---|---|---|
| GLM-5.2 → GLM-5.3 | 753,329,940,480 in both | 5.2: BF16 (282 shards, 1.5 TB). 5.3: `F8_E4M3` with scales (141 shards, 756 GB) | 5.3 adds 59,044 `weight_scale_inv` tensors, nothing else | Yes after decoding. **But an element-wise diff mixes training change with FP8 rounding.** The card says: "GLM-5.3 uses the same base model as GLM-5.2 — every gain comes from post-training." |
| Kimi K3 → K3.1 Pro | 2,779,931,837,184 → 2,780,110,363,392 | Same layout, BF16 plus F32 in shard 1; MXFP4 packing in config | 120 tensors added, none removed: `self_attn.indexer.*` on 24 layers. 178,526,208 parameters, 0.006% | Yes for shared tensors, with matching formats. **Not a pure post-training pair**: "we replace the full-attention Gated MLA layers with Gated DeepSeek Sparse Attention (Gated DSA) layers". No shard is byte-identical. Repo created 2 November, last modified 5 November. |
| DeepSeek-V4-Flash-Base → V4-Flash | 292.0B → 290.9B | Base: mostly `F8_E4M3`. Instruct: mostly `I8` (encoding not inspected) | Not checked | A true base/post-trained pair, but formats differ and the totals differ. |
| DeepSeek-V4-Pro-Base → V4-Pro | 1,600.8B → 1,598.8B | Same contrast | Not checked | Same, at 1.6T. Largest clean case of pretrain against post-train. |
| V4.1-Flash → V4.1-Flash-1017 | 763,205,315,794 in both | Identical dtype counts | Not checked | **The cleanest pair**: same format, same count, a reported re-post-training ("RL with self-feedback"). |
| V4-Flash → V4-Flash-0731 | 290.9B → 304.2B | Same kinds | Not checked | Totals differ by 13.2B, despite secondary reports of "same… size". Check before pairing. |

So the outline's two suggested pairs are the harder ones. V4.1-Flash and its 1017 update could be compared exactly, element for element, with range requests on chosen tensors. V4-Pro against V4-Pro-Base reaches the pretraining-to-post-training question at 1.6T. Both need care: any quantization-aware step or EMA, and the rule that a change below format resolution is invisible (Zhu et al.). A diff shows where stored values differ, not what the change does. [Inferred]

---

## D. Replication and contest

Method: searches, plus the Semantic Scholar citation lists (44 citing papers for 2503.21676, 178 for 2404.05405, scanned by title). I read those that looked relevant.

### 9.1 Allen-Zhu and Li: capacity

The linear scaling with parameters is widely replicated. The constant is not settled, and it depends on criterion, data and training. There is no large-scale replication: every direct measure stops below 1.5B. [Inferred summary]

| Source | Result | Scale | Criterion, and why it differs | Label |
|---|---|---|---|---|
| Johnston, Sanz, Belrose, [2502.03490](https://arxiv.org/abs/2502.03490) | "We did not perfectly reproduce… around 1.6 bits per parameter"; earlier runs with different hyperparameters did replicate 2. "the scaling behaviour is more complex than identified in Allen-Zhu & Li (2024)". | Small; limited range | Same style; µP parametrization, 17 relations | Confirmed |
| Morris et al., [2505.24832](https://arxiv.org/abs/2505.24832) | 3.5–3.6 bits per parameter, $\alpha=3.64$; 3.83 in fp32. "slightly larger estimate than Allen-Zhu & Li" | 100K–20M for capacity; suite to 1.5B | Random uniform data, unintended memorization | Confirmed |
| Nguyen, Norman, Reddy, [2611.01564](https://arxiv.org/abs/2611.01564) (1 Nov 2026) | $C/P\approx0.5$–1 bit per parameter; $\gamma\approx1$ | Largest stated $5.7\times10^7$ (one-layer); 12-layer sizes not checked | Random binary sequences, Zipfian sampling | Confirmed |
| Tutorial (Zucchet) | 0.16 memories per parameter, about 1.28 bits [Inferred] | Linear head | Trained softmax head, one correct token | Confirmed |
| Gu et al., [2505.18091](https://arxiv.org/abs/2505.18091), NeurIPS 2025 | Under mixing, knowledge "does not always follow a smooth scaling law but can exhibit phase transitions". Below a critical ratio, "the model memorizes almost nothing even after significantly longer training" | **14M–6.9B** Pythia | Synthetic biographies mixed with web text | Confirmed |
| Li, [2604.24827](https://arxiv.org/abs/2604.24827) | 1,400 fact probes on 93 open-weight models (135M–1,600B), $R^2=0.910$ for log-linear calibration; "deliberately coarse", about 3 times either way | **To 1.6T, real weights** | Fraction of facts recalled. Measures recall, not bits. | Reported: abstract |
| Ye, Feldman, Talwar, [2604.08519](https://arxiv.org/abs/2604.08519) | Theorem connecting fact accuracy to capacity; pruning lets GPT2-Small (110M) match a 1.3B model on entity facts | 110M–1.3B, Wikipedia | Real facts | Reported: abstract |
| Paudel, Sheshappanavar, [2609.32902](https://arxiv.org/abs/2609.32902) | QAT, not post-training: int8 retains over 90%; ternary retention falls from 0.36 at 2.5M to 0.06 at 50M, and "post-training quantization methods… recover no measurable capacity below 4 bits". Follows bioS. | 2.5M–50M | Same protocol. Bears on Result 8 and outline §9 "Precision is trained in". | Confirmed: abstract, intro |
| Allen-Zhu, [2512.17351](https://arxiv.org/abs/2512.17351) | Reruns capacity on architectures; Canon layers narrow the gated-MLP and MoE gaps. | 1M–500M, $N$ to 2M | Same author | Confirmed: §5.5 |

Gu et al. is the nearest thing to a contest. It does not refute 2 bits. It says that a model in a mixture need not spend its capacity on facts at all. Result 10 already pointed there. The frontier is the mixture case, so a bare "2 bits per parameter" for a 1T model is not supported by anything. [Inferred]

### 9.2 Zucchet et al. 2503.21676: plateau and circuits

**I found no independent replication at larger scale.** Attention patching has been run only at 44M, as far as I can find. [Confirmed for the paper; absence by search] Nearest evidence:

- **Consistent, independent, small.** Nguyen et al. (1 Nov 2026) on random binary sequences, with one-layer and 12-layer models: "attention heads convey sequence information to MLPs where memories are stored. This picture is consistent with prior work, notably [22], who show that attention circuits develop before MLPs begin to store factual information." They add a weight swap: a hybrid of post-switch attention with pre-switch MLP "achieves above-chance accuracy on the original set". That is stronger than Zucchet's indirect case for the MLP. It uses random sequences, not language. And their "meta-memorization": larger models memorize faster because structured attention forms. [Confirmed]
- **Partly consistent, partly complicating, at 7B on natural text.** Hakimi et al., [2506.03434](https://arxiv.org/abs/2506.03434): OLMo-7B, 40 snapshots, Information Flow Routes. Early "general-purpose components, which later specialize". Attention heads "display the highest turnover": for answer-specific heads "even the IOU between the final model and the checkpoint just before the final model is just 0.2". "FFNs remain more stable throughout training". [Confirmed] So at 7B the attention "circuit" does not settle into a fixed form, and the paper never mentions a plateau. This is correlational, a different notion of circuit, and facts drawn from real text. It does not contradict Zucchet's claim about one task, but the phrase "circuits form, then facts fill them" reads too cleanly against it. [Inferred]
- **Gradual, not phased, in a real pretraining run.** Chang et al., [2406.11813](https://arxiv.org/abs/2406.11813), NeurIPS 2024, resume OLMo pretraining at 1B and 7B from a mid checkpoint (500B tokens) and inject probe facts: "factual knowledge acquisition in LLM pretraining occurs by progressively increasing the probability of factual knowledge presented in the pretraining data at each step. However, this increase is diluted by subsequent forgetting." Forgetting follows a power law. [Confirmed: abstract, methods] Zucchet's Appendix A.2 reads this as consistent, while finding forgetting "more pronounced".
- **Direction of acquisition.** Ou et al., [2502.11196](https://arxiv.org/abs/2502.11196): continual pre-training on GPT-2 to Phi-1.5, a "phase shift from formation to optimization" with "deep-to-shallow" evolution, where "mid-to-deeper layers first develop the extraction". Zucchet cite it as consistent. [Reported: abstract, intro]
- **Pooled across tasks?** Zucchet speculate: "even with natural text and its multi-task nature, task-specific learning dynamics retain the same abrupt transitions". That is the bridge to frontier models, and they mark it as speculation. Nobody has tested it there. [Confirmed]
- **Agent replication.** Falck et al., [2608.13331](https://arxiv.org/abs/2608.13331), include Figure 5 of this paper in a rubric for AI agents replicating research, as a qualitative task. It is a benchmark, not evidence about the claim. [Confirmed: rubric text seen]

### 9.3 Scale: what may be said about frontier models

| Result | Largest scale measured | Data | May say | May not say |
|---|---|---|---|---|
| Plateau scaling | 44M | Synthetic | A mechanism that appears when facts are isolated | That frontier models pass through a plateau; a corpus has no single population |
| Attention patching | 44M | Synthetic | Learned routing removes the plateau there | That routing precedes facts in a mixed corpus |
| Three phases | 400M, one run | Synthetic | Robust to size in that task | Scaling law at 400M |
| Bits per parameter | 0.5B (Allen-Zhu), 1.5B (Morris suite), 6.9B (Gu, under mixing) | Synthetic | A linear law to 0.5B, ratio near 2 in pure facts | A figure for what a 1T model holds; the store in mixtures is allocated |
| MoE cost | 32 experts, 0.5B | Synthetic | Sparsity costs little for pure facts | The same at 256 or 896 experts, or with shared experts |
| $hd/k$ | 16,384-parameter head; direction at 1B | Random keys; natural proxy | A rate for a linear head; direction at 1B | A rate for a backbone |
| Fine-tuning collapse | 44M, 1B (Palit, in a controlled form) | Synthetic | A fragility mechanism | That SFT at frontier scale does this: their fact mix is very different, with replay-like mixtures |
| Spurious forgetting | 1B, one model | CounterFact, 422 facts | Forgetting there is partly a shift | How much of MAI's or GLM's forgetting is spurious |
| RL weight geometry | 8B dense, 30B MoE, one 671B pair | Math RLVR | Stable low-dimensional drift | That it holds in long agentic climbs |
| RL feature drift | 1.5B–7B | Math | Late, small, format-first in short RL | Anything about K3 or GLM |

Three scale gaps are unlikely to shrink with more toy work. [Inferred] Pretraining mixtures replace uniform populations. Modern MoE models use far more experts. RL in the seven runs on long, multi-domain environments rather than short math problems, and on checkpoints stored in lower precision.

---

## E. Open items

- Equation (6) of 2505.17863, Definition 4.3 of 2404.05405 and Theorem 5 of 2608.15448 are rebuilt from layout text. Each passes a consistency check, but read them on the rendered page before printing.
- Figure-only values are unverified: the fine-tuning curves in Figures 5 and N of 2503.21676, and the layer heatmaps in 2505.11711 and 2601.04537.
- Shenfeld et al. (2025) on float32, and Wang et al. (2026) on RLVR, were not read directly. Shenfeld's result matters if the essay uses the bf16 point, and it needs a citation of its own.
- `index.html`, the outline and other notes were not edited. The K3.1 Pro config check that the outline schedules for "when its weights appear" is due now; the architecture change is in row 14 of Table A.

Scratch files (PDFs, extracted text, scripts) sit in `/private/tmp/claude-501/-Users-lukstafi-lukstafi-github-io/d8b679ee-ba34-4137-88a3-bda951d7be76/scratchpad/`, under `primary-order/`, `order-leads/` and `scripts_order/`.
