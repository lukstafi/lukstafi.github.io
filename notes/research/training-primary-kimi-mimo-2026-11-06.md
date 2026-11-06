# Primary-source read: how Kimi K3 and MiMo-V2.6-Pro were trained

Prepared 6 Nov 2026 for *Filling the Stores* (outline: `architectures-and-training-outline.md`, §§7–10).

**Labels.** **[C] Confirmed**: I read it in the primary text, or checked the mathematics myself. **[R] Reported**: a lab's causal or performance claim that nobody outside has checked, as far as these sources show. **[I] Inferred**: my reading, not the source's. **[Gap]**: searched for and not disclosed. Page numbers are PDF pages; in both reports they match the printed numbers.

## 0. What was read

Read in full text from the arXiv PDFs (pdftotext; figures rendered where the numbers mattered):

- Kimi K3 technical report, arXiv 2607.24653v2: §§1–5, Appendices B–D, relevant parts of §§6–7.
- MiMo-V2.6, arXiv 2610.11959v1: §§1–8. Title: *MiMo-V2.6: Scaling Reinforcement Learning Towards Self-Improvement*. It covers Pro and Flash.
- Jordan et al., Muon post (full text; the post's defining equation is an image, so the equation below comes from the code in the post and from Liu et al.).
- Lion et al., *Muown*, arXiv 2605.10797: §§1–3, Algorithm 1.
- Liu et al., *Muon is Scalable*, arXiv 2502.16982: §2.
- Kimi K2 (2507.20534): §2.1, §2.5, §3.1. Kimi K2.5 (2602.02276): Eq. 1, the RL loss K3 inherits. GLM-5 (2602.15763): Muon Split.
- Ma et al., *MOPD*, arXiv 2606.30406: §§3–4. Liao et al., *ReOPD*, arXiv 2607.04763: §§1–4, Algorithm 1. Qu et al., *Can Muon Fine-tune Adam-Pretrained Models?*, arXiv 2605.10468: abstract and §1.
- AttnRes (2603.15031): grep and §5 only, for initialization.

Not read: Su's blog post [112] on per-head Muon, one of K3's two citations for the variant (kexue.fm redirects by script and returns 403 to fetchers). GLM-5, the other citation, was read. MiMo's live run log at mimo.xiaomi.com/rl/mimo-v26 is a script-driven dashboard; I did not extract its data. It is the only disclosure of per-step metrics and may be worth a look by hand.

## 1. Corrections to carry into the outline first

1. **MiMo did not pretrain with Muon or Muown.** §8 of the outline lists "Muown in MiMo" among disclosed pretraining facts. MiMo pretrained with AdamW and switched to Muown at mid-training, to prepare for large-batch RL. This is the most useful correction, because the switch is itself an ordering fact.
2. **K3's report never says what gets AdamW.** The string "Adam" appears in K3 only in a bibliography entry. The report says Muon is for "its matrix parameters". The split into AdamW for embeddings, head and router is general Muon practice (Jordan; Liu et al.) and MiMo's stated recipe, not a K3 disclosure.
3. **K3 discloses no pretraining token budget.** TPP (tokens per parameter) is named as a tuned hyperparameter and its value is withheld. A cell in the §7 table must stay empty.
4. **SiTU is misfiled.** The outline puts it under "Residual mixers must stay stable". SiTU-GLU sits inside the MoE feed-forward branch and has nothing to do with AttnRes.
5. **"Demonstrations as targets" needs care.** In MOPD2 demonstrations are never targets for the student, but they are targets for the SFT teachers one level up. See §6.

## 2. Kimi K3

### Pretraining

- **Budget.** [Gap] No token count, batch size, peak or minimum learning rate, or step count. Fig. 7 (p. 11) fits scaling-law curves against FLOPs on an axis marked $10^{20}$ and $10^{21}$, with no values on the loss axis and no point labelled as the final run. Fig. 6's ablations run to about 30k steps, but they are ablations. "2.5×" is a scaling-efficiency gain over K2, in validation loss against FLOPs (Fig. 7). For comparison K2 disclosed 15.5T tokens, 67M tokens per batch, and learning rate 2e-4 to 2e-5 (K2 §2.5), so K3 is a step back in disclosure.
- **Visual tokens.** [C] Interleaved in one objective: "visual and textual tokens are interleaved within a single next-token prediction objective" (§3.3, p. 11). Pixel shuffle "reduces the number of visual tokens by a factor of four" (§2.4, p. 10). [Gap] How they count toward any budget.
- **Modalities.** [C] Joint from the first step: "language and vision are jointly optimized from the start of training, rather than grafting a vision encoder onto a pre-trained language model through a post-hoc alignment stage" (§3.3). No audio is mentioned.
- **Vision encoder.** [C] MoonViT-V2 is trained "entirely from scratch with next-token prediction" (§2.4, p. 9). [R] The reason given is stability: "When a pre-trained encoder is attached to the LLM, joint optimization becomes unstable: the SigLIP-initialized MoonViT-3D shows persistently higher gradient norms with frequent spikes", and the from-scratch encoder "matches the SigLIP-initialized baseline across vision evaluations".
- **Optimizer.** [C] "We optimize the model using the Per-Head Muon optimizer (§ 2.5) together with the weight-clipping mechanism introduced in Kimi K2, while adopting QB (§ 2.3.3) for MoE load balancing. We use a cosine learning rate schedule with a 1% linear warmup. Weight decay is set to 0.1 throughout." (§3.3, p. 11). The clipping mechanism is K2's QK-Clip.
- **Schedule.** [R] Cosine beat WSD (warmup–stable–decay), K2's schedule, once each had its own scaling-law search: "comparing the two schedules using a shared set of hyperparameters may unfairly favor one" (§3.2, p. 10).
- **Context stages.** [C] "The window grows from 8K to 64K tokens during pre-training, and from 256K to 1M tokens during the cooldown phase. Concentrating the costly long-sequence computation within a small fraction of the overall training budget keeps the curriculum economical" (§3.4, p. 12). K3 uses "cooldown" where others say mid-training; the word "mid-training" does not occur. [Gap] Tokens per stage; the fraction.
- **Long-context data.** [C] "Length alone, however, does not confer long-range capability." They "synthesize additional long-context data by carefully permuting and concatenating multimodal documents and sub-tasks, so that the embedded tasks can be solved only by attending to information scattered across the full 1M-token context. This trains the attention mechanism at the intended scale and prevents it from degenerating into local patterns." (§3.4).
- **Precision during pretraining.** [C] Attention output kept in FP32 "To correct the biased rounding error identified by [99] in flash attention" (§2.1.2, p. 6). Activations saved for the backward pass use block-wise FP8 (§5.2.2, p. 20); that is storage. No expert quantization yet.

### Post-training

The paradigm is stated in one sentence (§4.1, p. 12): "initializing baseline agent capabilities via supervised fine-tuning (SFT), developing specialized domain experts at varying reasoning effort via Reinforcement Learning (RL), and consolidating these domain-specific policies into a single model using Multi-Teacher On-Policy Distillation (MOPD)."

- **SFT.** [C] Trajectories are synthesized "using domain-specialized models from the prior Kimi series, followed by multi-stage verification and human-in-the-loop annotation" (§4.1.1). QAT starts here. [Gap] Dataset size.
- **QAT.** [C] "we apply quantization-aware training (QAT) from the SFT stage onward, with MXFP4 weights and MXFP8 activations" (§4.1.1). Scope: "MoE expert weights ... to MXFP4, with activations computed in MXFP8, while all non-expert components (attention projections, latent MoE projections, shared experts, and MoE routers) remain in higher precision" (§4.1.4, p. 14). "During RL, rollout and training share the same quantization scheme — eliminating the train–inference mismatch." The text says QAT covers "both SFT and RL"; MOPD is not named. [I] MOPD presumably inherits it, since it runs in the RL framework.
- **RL domains.** [C] Three: general tasks; general agents; coding agents (§4.1.2, p. 12). Crossed with efforts {low, high, max}: "a total of nine expert models".
- **Effort curriculum.** [C] An ordering fact: "We first train a max-budget variant with a relatively large τ, while still capping the maximum budget to suppress excessive overthinking. We then anneal τ to smaller values to obtain the high- and low-effort expert models." (§4.1.2, p. 13). Reward is overridden with −1 for trajectories whose token count exceeds $\tau\cdot b_0(x)$, where $b_0$ is estimated from the cold-start model.
- **RL objective.** [C] K3 says only that optimization "follows the algorithm in Kimi K2.5 [60]", with partial rollouts and "a per-token regularization" (p. 13). K2.5's Eq. 1 is

  $$L_{RL}(\theta)=\mathbb{E}_x\Big[\tfrac1N\sum_{j}\sum_{i}\mathrm{Clip}\big(\tfrac{\pi_\theta}{\pi_{old}},\alpha,\beta\big)\big(r(x,y_j)-\bar r(x)\big)-\tau\big(\log\tfrac{\pi_\theta}{\pi_{old}}\big)^2\Big]$$

  Tokens outside the bounds get zero gradient. The squared log-ratio is the regularizer that tolerates staleness. [Gap] Whether K3 changes any of this; values of $\alpha,\beta,\tau,\lambda,N,K$.
- **Partial rollout.** [C] "the generation phase pauses as soon as a fraction λ ∈ (0, 1) of trajectories completes"; paused rollouts resume next iteration, so "an individual long-horizon trajectory naturally spans multiple iterations, introducing data staleness" (p. 13). This answers the outline's §9 note on stale rollouts: both reports cover it.
- **Compute.** [C] "keep each 1M-context Kimi K3 RL experiment within a few hundred GPUs" (§5.3.1, p. 21), co-located training and rollout. "51,219,741 sandboxes across 1,505,678 images" over training and evaluation (§5.3.2, p. 22). [Gap] RL step count, cost, cluster size, tokens. Fig. 8's RL FLOPs axis has no tick values.
- **Non-verifiable rewards.** [C] An agentic Generative Reward Model with a tournament of binary comparisons and a mandatory four-step protocol: read, generate a rubric, score each candidate, record in a scorepad. "a candidate whose output length exceeds σ · ℓ0 automatically loses the binary comparison" (§4.1.2, p. 13).
- **Verifiers.** [C] Kernel tasks: numerical error over threshold gives zero; matching an expert implementation gives 0.5, approaching the hardware roofline approaches 1 (§4.2.4). Autonomous Execution Tasks have independent verifiers, public and hidden (§4.2.6). Web tasks combine deterministic checks and model judges; "The reward is zeroed when a project fails to build, runs with errors, or fakes rather than implements the artifact." (§4.2.7).
- **Drafter.** [C] "Kimi K3 is pre-trained with a multi-token-prediction (MTP) layer that mirrors the structure of a backbone block." It is then fine-tuned into an EAGLE-3 draft "with the target model frozen and only the draft layer and its feature-fusion projection updated", unrolled seven steps, consuming its own outputs (§4.1.4, p. 14). Input fuses the outputs of AttnRes blocks 1, 4 and final through $W_{E3}$, "initialized as [ 0 0 I ] so that the fused representation coincides at initialization with the high-level feature". The loss is the LK loss $-\log\sum_x\min(p(x),q(x))$, the negative log of the acceptance rate, since KL "does not guarantee maximizing this rate for a capacity-limited draft model". Draft training uses the post-training QAT configuration.

## 3. MiMo-V2.6-Pro

### Pretraining

- **Budget.** [C] "MiMo-V2.6-Flash is trained on 48T tokens, comprising 26T tokens in the text stage and 22T in the omni stage. MiMo-V2.6-Pro is trained on 30T tokens, with 27T and 3T tokens in the two stages, respectively." (§3.1, p. 7).
- **Visual tokens.** [C] The ViT is pretrained separately: "After pre-training on more than 4T image tokens, MiMo-ViT learns strong visual representations" (§2.2, p. 4). [Gap] Whether these sit outside the 30T (the sentence on 30T suggests they do), and what one "image token" is at that stage. [I] Taken at face value, the encoder saw more image tokens in its own stage than Pro's whole omni stage holds in tokens of all kinds. Flash's 22T omni stage against Pro's 3T is a seven-fold difference that the report does not explain.
- **Modalities.** [C] Staged. "In the first stage, we train the language backbone on text-only data ... In the second stage, we integrate the backbone with our in-house pre-trained ViT and audio encoder and jointly train the full model on omni-modal data" (§3.1, p. 7). The Audio Tokenizer is trained separately on 20 million hours; the audio patch encoder "is trained jointly with the text backbone" (§2.3, p. 5).
- **Vision device.** [C] "To pre-train MiMo-ViT from scratch, we pair it with a small pre-trained LLM and optimize the resulting VLM solely on multimodal understanding data using a cross-entropy objective. ... Crucially, the LLM remains trainable to provide stable, semantically meaningful gradients to the ViT." (§2.2).
- **Optimizer.** [C] "We employ the AdamW optimizer in the pre-training of MiMo-V2.6." (§3.1). [Gap] Learning rate, schedule, batch size.
- **Context.** [C] "We begin pre-training with a context length of 32K tokens and extend it to 256K partway through training."
- **MTP.** [C] An SWA and dense-FFN MTP module "to improve model performance during pre-training" (§2.1, p. 4).

### Mid-training (§3.2, p. 7)

- **Purpose.** [C] "further developing the model's agentic abilities, extending long-context support, and adapting the optimization setup for large-batch training".
- **Data.** [C] An agent-centric mixture: agent trajectories across coding, general, visual and research tasks, with text, repository-level code, image, video and audio. [Gap] Token budget for this stage.
- **Context.** [C] "we first train with a 256K context length, allocating the majority of compute to this stage, and then extend the context length to 1M in the final stage."
- **Optimizer switch.** [C] "Our base model was pre-trained with AdamW, but our preliminary experiments showed diminishing optimization efficiency as the batch size increased in mixed-task RL. ... We therefore switch to a variant of Muon optimizer, Muown, for the hidden weight matrices during mid-training to prepare the model for subsequent large-batch RL. ... Embeddings, the LM head, and the MoE router continue to use AdamW."
- **Mismatch.** [R] "Prior work reports that switching an Adam-pre-trained model to Muon training can cause optimizer mismatch and degraded performance (Qu et al., 2026). Nevertheless, during our mid-training, we observe no loss spike throughout the training process." Qu et al. find mismatch "disrupts pretrained knowledge" and scales with update strength. [I] "No loss spike" is weaker than "no degradation"; the report gives no matched comparison.
- **Precision.** [C] "We employ MXFP4 quantization-aware training (QAT) during mid-training". §6.4 (pp. 31–32): "we apply quantize–dequantize (QDQ) to the experts after each parameter update", matching the MXFP4 kernels used in rollout, "so the two engines see identical expert weights".
- **Alignment data.** [C] An early-RL failure goes back into this stage. See §7 below.

### Post-training

- **SFT.** [C] "a short supervised fine-tuning (SFT) stage" (§4, p. 7). That is nearly all. [Gap] Size and content of V2.6's own SFT. The numbers in Table 4 (77.4B total tokens, 27.2B loss tokens) belong to the separate Distill-Qwen-9B model.
- **RL scale.** [C] "$2.6M and $0.9M on RL post-training" for Pro and Flash; 1,568 prompts with group size 16, "each step rolls out 25K sequences that amount to 2.7B–3.7B training tokens" (§4.1, p. 8). Thirty training steps; Pro took 123.1 h including failures (Fig. 12). Pro's cost split: rollout 43.8%, training 43.5%, grader 12.7%. Task mix: "agentic and competitive coding (68%), general tool use (12%), aesthetic design (13%), context following (3%), and cyber security (4%)" (§5.1, p. 20). RL runs at 1M context (§6.4).
- [I] Thirty steps at about 3.2B tokens is about 100B training tokens, some 0.3% of pretraining's 30T. On that small fraction Pro's DeepSWE avg@3 moves from 58.4 to 72.6.
- **Objective.** [C] GRPO (Eq. 1, p. 8):

  $$L(\theta)=-\mathbb{E}_{q,\{o_i\}\sim\mu_{\theta_{old}}}\Big[\frac{1}{\sum_i|o_i|}\sum_{i=1}^{G}\sum_{t=1}^{|o_i|} r_{i,t}M_{i,t}A_i\log\pi_\theta(o_{i,t}\mid q,o_{i,<t})\Big]$$

  with $r$ the importance ratio, $M$ the token mask, $A$ the advantage, and prompt-mean aggregation, which "prevents response length from growing too quickly". Staleness 4. The ratio is clipped by four decoupled bounds, initially [0.2, 5.0], "tuned independently at runtime based on policy entropy" (§5.1).
- **Optimizer in RL.** [C] "the Muown optimizer with a learning rate of 3 × 10−6, no weight decay or learning rate warmup, and a gradient clipping threshold of 1.0. For the Muon component, we use a momentum coefficient of 0.95 with Nesterov momentum enabled, perform 10 Newton–Schulz iterations per update, and apply an additional update scaling factor of 0.5. For the Adam component, we set β1 = β2 = 0.95 and ϵ = 10−8." (§5.1, p. 20). [Gap] Whether "Adam component" means Muown's row-magnitude Adam, the AdamW parameters, or both; and whether 0.5 replaces or multiplies the 0.2 of Muown's Algorithm 1.
- **Stage hand-over.** [C] "To stabilize MXFP4 training, we initialize RL by carrying over the FP32 master weights and Muown's row state from the SFT checkpoint." [I] A checkpoint of quantized weights would lose both.
- **Router.** [C] Frozen in RL. See §5 below.
- **Grading.** [C] A self-hosted SFT checkpoint is the grader: "During RL, a self-hosted MiMo-V2.6-SFT model serves as the grader to support stable scoring." (§4.2.2, p. 12), and "An SFT-trained agentic grader" in GAR (§4.3.2).
  - GRS (subset of high-pass-rate tasks): $R_i=R_i^{test}\cdot S_i^{sol}\cdot S_i^{beh}$ (Eq. 2).
  - GAR (remaining code tasks): for $\mathcal P=\{i:R_i=1\}$, $\lambda=\sum_{j\in\mathcal P}A_j/\sum_{j\in\mathcal P}f_jA_j$, $A_i'=\lambda f_iA_i$ for passes, unchanged for failures (Eq. 3). Then the group mean is subtracted.
  - Group-relative length penalty (Eq. 4) and segment-level behavioural penalties (Eq. 5).
- **Drafter.** [C] Architecture: 5 layers, dense FFN, block diffusion per DFlash, "predicts 7 subsequent tokens in a single forward pass for parallel verification by the backbone" (§2.4). Training: "RL rollouts use block-6 DFlash for speculative decoding by default, replacing the multi-token prediction (MTP-3) configuration inherited from SFT. Initially trained on the SFT policy, DFlash is then finetuned on early RL rollout logs resampled to match the RL training distribution." [R] 31.3% longer accepted length than MTP. RL-adapted FP8 DFlash gives about 10.3% more per-node throughput (§6.4, p. 32).

## 4. Side by side

| | Kimi K3 | MiMo-V2.6-Pro |
|---|---|---|
| Parameters | 2.78T total, 104.2B active | 1.02T total, 42B active |
| Pretraining tokens | Not disclosed | 27T text + 3T omni; ViT separately on >4T image tokens |
| Modalities | Text and vision jointly from step one; encoder from scratch | Text first; then ViT, audio joined |
| Optimizer, pretraining | Per-Head Muon + QK-Clip, weight decay 0.1, cosine, 1% warmup | AdamW |
| Optimizer, later | Not stated for post-training | Muown from mid-training on; AdamW for embeddings, LM head, router |
| Context | 8K → 64K (pretrain) → 256K → 1M (cooldown) | 32K → 256K (pretrain) → 256K, then 1M (mid) |
| Expert precision | MXFP4 weights, MXFP8 activations from SFT on | MXFP4 QDQ from mid-training on; activations unstated |
| SFT | Prior Kimi models' trajectories, verified, annotated | "short"; no details |
| RL | Nine experts; partial rollouts; a few hundred GPUs per experiment | One mixed-task run; 30 steps; thousands of GPUs; $2.6M |
| Consolidation | MOPD over nine teachers, effort-conditioned student | MOPD2 over mixRL and SFT teachers, three workflows |
| Balancing | Quantile Balancing, MoonEP | Router frozen in RL; R3 replay |
| Drafter | Pretrained MTP layer fine-tuned to EAGLE-3 | MTP in pretraining; DFlash trained on SFT policy, fine-tuned on RL logs |

## 5. Muon and its variants

### Plain Muon

Update, with $G_t$ the gradient (Liu et al. Eq. 1; [C], and it agrees with Jordan's code):

$$M_t=\mu M_{t-1}+G_t,\qquad O_t=\mathrm{NS}(M_t),\qquad W_t=W_{t-1}-\eta_t O_t$$

In practice Nesterov style: NS is applied to $\mu M_t+G_t$. (Liu et al., footnote 1; Jordan: "using Nesterov-style momentum for Muon works a bit better".)

$\mathrm{NS}$ approximates $UV^\top$ where $M=USV^\top$. Jordan: "the NS iteration effectively replaces SGD-momentum's update matrix with the nearest semi-orthogonal matrix to it. This is equivalent to replacing the update by $UV^\top$". SVD is rejected because "it's far too slow"; NS "can be stably run in bfloat16".

Newton–Schulz, verified from the post's code and proof: start at $X_0=M/\|M\|_F$, then

$$X_{k+1}=aX_k+b(X_kX_k^\top)X_k+c(X_kX_k^\top)^2X_k,\qquad (a,b,c)=(3.4445,-4.7750,2.0315)$$

Each step acts on singular values alone, $S\mapsto \varphi(S)$ with $\varphi(x)=ax+bx^3+cx^5$. So $U$ and $V$ never change. Dividing by the Frobenius norm puts every singular value in $[0,1]$. The coefficients trade exactness for speed at small singular values: $a=\varphi'(0)$ sets how fast small ones grow. Jordan: "$\varepsilon$ can be as high as around 0.3 without harming the loss curve". The tuned iteration therefore does not converge to 1; it settles inside [0.7, 1.3]. Default 5 steps. MiMo uses 10.

Two scalings added by Liu et al., both in K2's MuonClip: decoupled weight decay, and a shape correction, because a full-rank Muon update has RMS $1/\sqrt{\max(A,B)}$ while AdamW's is "usually around 0.2 to 0.4":

$$W_t=W_{t-1}-\eta_t\big(0.2\,\sqrt{\max(A,B)}\,O_t+\lambda W_{t-1}\big)$$

Scope: "scalar and vector parameters of the network, as well as the input and output layers, should be optimized by a standard method such as AdamW" (Jordan). Q, K and V separately works better than as one matrix (Jordan, credit to Boza).

### How it differs from Adam on a matrix

Adam normalizes entry by entry, Muon normalizes the matrix as a whole. On a constant gradient, Adam's bias-corrected moments are $\hat M=G$, $\hat V=G^2$ (Qu et al. Eqs. 3–5), so the step is $-\eta\,G/(|G|+\epsilon)\approx-\eta\,\mathrm{sign}(G)$ [C, my derivation from those equations]. Each entry keeps its sign and loses its size. Each is the normalized steepest-descent direction in its own norm: sign$(G)$ for the largest-entry box, $UV^\top$ for the spectral ball (Liu et al. §2; Muown §1).

Both updates ignore the overall scale of the gradient. They differ in what they keep. Adam keeps the signs of the entries, Muon keeps the singular vectors.

### Worked 2×2 example [C: computed; the example is mine]

Take singular vectors from the 3-4-5 triangle: $u_1=(0.8,0.6)$, $u_2=(-0.6,0.8)$, $v_1=(0.6,0.8)$, $v_2=(0.8,-0.6)$, with singular values 10 and 1:

$$G=10\,u_1v_1^\top+1\,u_2v_2^\top=\begin{pmatrix}4.32&6.76\\4.24&4.32\end{pmatrix}$$

This is the shape Jordan describes: "almost low-rank matrices, with the updates for all neurons being dominated by just a few directions".

| | update | singular values |
|---|---|---|
| Gradient $G$ | as above | 10, 1 |
| SGD | $G$ | 10, 1 |
| Adam (sign) | $\begin{pmatrix}1&1\\1&1\end{pmatrix}$ | 2, 0 |
| Muon, exact | $UV^\top=\begin{pmatrix}0&1\\1&0\end{pmatrix}$ | 1, 1 |
| Muon, NS tuned, 5 steps | $\begin{pmatrix}-0.003&0.704\\0.706&-0.003\end{pmatrix}$ | 0.709, 0.702 |

All four entries of $G$ are positive, so Adam's first step is rank one: the weak direction is gone. Muon raises the weak direction to the size of the strong one. Jordan's speculation: orthogonalization "effectively increases the scale of other 'rare directions' which have small magnitude in the update but are nevertheless important for learning."

Newton–Schulz by hand, singular values after normalization (start 0.995, 0.0995):

| step | tuned (3.4445, −4.775, 2.0315) | baseline (2, −1.5, 0.5) |
|---|---|---|
| 1 | 0.705, 0.338 | 1.000, 0.198 |
| 2 | 1.109, 0.989 | 1.000, 0.384 |
| 3 | 0.715, 0.710 | 1.000, 0.687 |
| 4 | 1.103, 1.097 | 1.000, 0.964 |
| 5 | 0.709, 0.702 | 1.000, 1.000 |

The tuned coefficients reach the band by step 2 and then oscillate between about 0.7 and 1.1; they never converge. The baseline converges to the exact swap in 5 steps. For a hand example in the essay the baseline is cleaner, with a remark that production Muon stops earlier and tolerates the error. With the RMS scaling, $0.2\sqrt2\,UV^\top$ has entries 0.283 and RMS 0.2. Adam's RMS in this example is 1, because the gradient is constant; with noisy gradients it falls to the 0.2–0.4 quoted above.

Momentum does not change this first step, since $\mu M_1+G_1=(1+\mu)G$ and NS ignores scale.

### Per-Head Muon (K3)

[C] §2.5, p. 10: "instead of applying Newton–Schulz orthogonalization to the full Q, K, and V projection matrices, we partition their momentum matrices along the head dimension and orthogonalize each head's block separately." Stated reason: "full-matrix orthogonalization treats all heads as a single coupled block, so heads with larger gradient or momentum scales dominate the shared update direction, while smaller-scale heads receive insufficiently normalized updates; per-head orthogonalization equalizes the update scale across heads." [R] "more balanced learning dynamics across heads and improves training stability at larger scales". Also cheaper: "Newton–Schulz iterations on tall per-head blocks are cheaper than on the full projection matrix".

It applies to attention projections only. Other matrix parameters get plain Muon, as far as the text says.

[C] The variant is GLM's: K3 cites [112, 147], and [147] is GLM-5, whose "Muon Split" splits MLA's up-projections by head. GLM's wording pulls the other way: the split "enables projection weights for different attention heads to update at different scales", and "the scale of attention logits of GLM-5 remains stable during pre-training without any clipping strategy." K3 says "equalizes" and keeps QK-Clip all the same.

[I] Both wordings are right. Each head gets a matrix update of the same spectral size, independent of the others, so relative to the shared gradient the heads move at different rates. A sketch with two one-column heads, gradient columns $(3,0)$ and $(0.03,0.03)$: full-matrix orthogonalization gives columns about $(1,-0.01)$ and $(0.01,1)$, so the small head's update is rotated 45° away from its own gradient, by the large head. Per-head gives $(1,0)$ and $(0.707,0.707)$. That is K3's "dominate the shared update direction".

**QK-Clip** (K2 §2.1) is the "weight-clipping mechanism". After each update, for heads whose max attention logit $S^h_{max}$ exceeds $\tau$, rescale query and key weights by $\gamma_h=\tau/S^h_{max}$ (split between them). K2 used $\tau=100$. [R] Vanilla Muon at 53B had max logits above 1000, with "significant loss spikes and occasional divergence". [Gap] K3's $\tau$. QK-Clip bounds softmax logits and KDA has no softmax, so [I] it presumably acts on the MLA layers only. Not stated.

### Muown (MiMo)

[C] Lion et al. (Algorithm 1). Motivation: under Muon without weight decay the spectral norm of the weights drifts up, and they decompose it as $\|W\|^2_{S_\infty}=\|g\|^2_\infty\,\lambda_{max}(PCP)$, a row-magnitude factor times a row-coherence factor. The row magnitude is the driver. Freezing it stops the drift.

The fix is weight normalization inside the optimizer: $W=\mathrm{Diag}(g/\|R\|_{row})R$, with $g\in\mathbb R^m$ one gain per output neuron. The forward pass does not change. Each step:

1. Reconstruct the direction from the stored weight: $R\leftarrow\mathrm{Diag}(r/g)W$, $D\leftarrow\mathrm{Diag}(1/r)R$. Here $r$ caches the row norms of $R$.
2. Split the gradient: $\nabla_g=(\nabla_W\odot D)\mathbf 1_n$ (radial part per row), $\nabla_R=\mathrm{Diag}(g/r)\,\mathrm{Proj}_D(\nabla_W)$ (each row with its radial component removed).
3. Muon with Nesterov on the direction: $M\leftarrow\beta_1M+\nabla_R$, $O=\mathrm{ortho}(\beta_1M+\nabla_R)$ with descent sign, $R\leftarrow R+0.2\sqrt{\max(m,n)}\,\eta_tO$.
4. Adam on the gains: $g\leftarrow\mathrm{Adam}(\nabla_g)$.
5. $r\leftarrow\|R\|_{row}$, $W\leftarrow\mathrm{Diag}(g/r)R$.

Same learning rate for both. So Muown keeps Muon's update on direction and gives each neuron's size an Adam update, one scalar per row. Weight decay, when used, is applied to the effective $W$ and $g$ is then recomputed (arXiv HTML of Algorithm 1). [R] Muown improves perplexity over Muon, AdamW and others from 124M to 2.7B parameters, and "reduces sensitivity to weight decay". [I] This suits MiMo's RL setting, which uses no weight decay at all.

[C] Jordan's post lists as open: "Is it possible that Muon works only for pretraining, and won't work for finetuning or reinforcement learning workloads?" K2 (post-training with Muon, §3.1), K2.5 (RL with MuonClip) and MiMo answer it in practice. K3's report does not name its post-training optimizer.

## 6. Distillation

### K3: MOPD (§4.1.3, pp. 13–14)

[C] "for a given domain d and a sampled reasoning effort level e ∈ {low, high, max}, optimization is guided by the corresponding teacher model among the nine experts." The per-token reward on the student's token $y_t$ is

$$r^{d}_{opd}(y_t\mid e,x,y_{<t})=\mathrm{clip}\Big(\mathrm{sg}\big(\log\frac{\pi^{(d,e)}_{teacher}(y_t\mid x,y_{<t})}{\pi_\theta(y_t\mid e,x,y_{<t})}\big),-R_{max},R_{max}\Big)$$

Note where $e$ sits: the student is conditioned on effort, the teacher is not, because each teacher is one effort. [I] This is how one checkpoint comes to hold three effort levels: effort becomes an input.

[C] "This dense reward signal seamlessly integrates into our RL framework", so partial rollouts carry over. "While we also experimented with more fine-grained top-k distillation objectives, we observed no clear advantage in either convergence speed or final performance in our setting."

[I] K3 does not call this reverse KL; Ma et al. derive that the same log-ratio is the policy-gradient form of per-token reverse KL. On-policy: the student generates $y$, the teacher scores it.

[C] Also: "Trajectories produced by the resulting experts at all reasoning levels are jointly collected for supervised fine-tuning and multi-teacher on-policy distillation." (§4.1.2). So some off-policy SFT on expert trajectories exists alongside MOPD. [Gap] Its order relative to MOPD; the student's starting checkpoint; $R_{max}$.

### MiMo: MOPD2 (§5.6, pp. 24–25)

[C] Full name: "Multi-Prefix Multi-Teacher On-Policy Distillation". It runs "After mixed RL". Teachers are of two kinds (Fig. 13): mixRL teachers on verifiable tasks, and "SFT teachers on high-quality synthetic demonstrations" for open-domain tasks "where reliable RL rewards are difficult to design". The report itself gives no equation; it builds on Ma et al. and Liao et al.

"Three streams" is the outline's word. The report has three workflows:

| Workflow | Where the context comes from | What the student generates | Teacher |
|---|---|---|---|
| Standard MOPD | Task prompt; "autonomous student rollouts" with the environment | Full trajectory | mixRL |
| Teacher-Prefix OPD | A teacher rollout, split into $k$ prefixes | One turn per prefix | mixRL or SFT (Fig. 13) |
| SFT-Prefix OPD | An SFT demonstration, split into $k$ prefixes | One turn per prefix | mixRL or SFT (Fig. 13) |

Mechanism: "A trajectory with k assistant turns provides k complete history prefixes, each ending before the corresponding turn. The student samples one new turn from each prefix without regenerating earlier interactions. A preassigned teacher provides token-level supervision conditioned on the same history and the student's preceding tokens."

Why prefixes: SFT teachers' "training may provide limited coverage of histories reached after repeated student deviations in long-horizon tasks ... SFT-Prefix OPD therefore starts each rollout from a fixed demonstration prefix, limiting deviations before the sampled turn. Demonstrations supply the context, while the student generates its own continuation rather than imitating a fixed response." Fig. 13 caption: "SFT data provide prefix contexts rather than fixed continuation targets."

So the outline's sentence holds for the student. The demonstrations remain targets for the SFT teachers. The chain is: demonstrations teach the teacher by imitation; the same kind of demonstration gives the student a place to start; the teacher then scores what the student does from there.

The signal, from Ma et al. (Eqs. 1–4) [C for that paper; [Gap] whether V2.6 uses exactly this form]:

$$L_{rev\text{-}KL}=\mathbb{E}_{x,y\sim\pi_\theta}\Big[\frac1{|y|}\sum_t\sum_v\pi_\theta(v)\log\frac{\pi_\theta(v)}{\pi_{\phi_d}(v)}\Big],\qquad \hat A_t=\mathrm{sg}[\log\pi_{\phi_d}(y_t)-\log\pi_\theta(y_t)]$$

clipped to $\pm A_{max}$ and used as a per-token advantage. Identical in form to K3's Eq. 15.

Liao et al. supply the reason at more depth: a "prefix trap", where "making histories more student-on-policy improves relevance to the student, but can query the teacher on histories where its target is unreliable." Their ReOPD samples prefixes with step-decaying probability $\kappa^t$, favouring early turns. It also removes tool calls during student training. [Gap] MiMo says "k complete history prefixes" and does not mention decay.

### Same-origin teachers (Ma et al. §4.4.2): an ordering constraint

[C/R] In MOPD the student "is initialised from the Stage-1 SFT checkpoint", and each teacher is RL-trained from the same checkpoint. They swapped the 30B math teacher for Qwen3-235B-A22B, "a stronger but distributionally different model". Initial per-token KL went from about 0.04 to about 0.19. Under the policy-gradient form math accuracy degraded and entropy contracted from 0.30 to 0.21. Under top-$k$ AIME25 fell to 0.94% and training "diverges catastrophically around step 18". "MOPD's use of same-origin teachers is critical". Norm. score: 0.937 same-origin, 0.600 external PG, −1.190 external top-$k$.

Against the MOPD alternatives on Qwen3-30B-A3B (Table 2): Mix-RL 0.882, Cascade RL 0.775, Off-Policy Finetune 0.824, Param-Merge average 0.328, task arithmetic 0.857, MOPD 0.937. Cascade RL shows interference: "Math accuracy degrades during the subsequent SWE stage". This is the OPD side of the outline's contrast with MAI-Thinking-1's off-policy consolidation.

[Gap] MiMo-V2.6 says "After mixed RL" and does not state the student's starting checkpoint. It may be the mixed-RL model rather than the SFT checkpoint, which would make the same-origin relation different from Ma et al.'s. K3 does not state it either.

Note on results: Fig. 3 gives Pro's end-of-RL DeepSWE avg@3 as 72.57 and Flash's as 65.68. Table 3 (final results, metric not restated) gives 71.9 and 67.9. [I] If Table 3 is post-MOPD2 on the same metric, distillation cost Pro 0.7 and gained Flash 2.2. The report does not say.

## 7. Expert balancing and activation control

### K3: why they were needed

[R] §2.3, pp. 6–7: "This extreme sparsity amplifies two failure modes of the vanilla design. First, the routed path composes W↓, a gated multi-branch expert feed-forward network, and W↑ into a chain of nearly four consecutive matrix multiplications. This ill-conditioned structure, combined with the 2.8-trillion-parameter scale, produces exploding internal activations in the routed branch. Second, balancing the load of nearly 10³ experts exceeds the regime in which existing auxiliary-loss-free bias updates remain well behaved." "Stable LatentMoE" answers with three parts: RMSNorm before $W_\uparrow$ (Eq. 11), SiTU-GLU, and QB.

### SiTU-GLU

[C] Eq. 12, p. 7:

$$\mathrm{SiTU\text{-}GLU}(x)=\beta_1\tanh\Big(\frac{W_gx}{\beta_1}\Big)\odot\mathrm{Sigmoid}(W_gx)\odot\beta_2\tanh\Big(\frac{W_ux}{\beta_2}\Big)$$

with $\beta_1=4$ on the gate and $\beta_2=25$ on the up branch. SwiGLU is $\mathrm{Swish}(W_gx)\odot W_ux$ with both factors unbounded: "coincident large coordinates can produce activation outliers and increase overflow risk in low-precision arithmetic." SiTU matches SwiGLU to first order at the origin, recovers it as $\beta_1,\beta_2\to\infty$, and every output coordinate satisfies $\|\cdot\|_\infty\le\beta_1\beta_2=100$ (Appendix B, Eqs. 18–19). "Unlike hard clamping of gate pre-activations, the smooth cap preserves nonzero gradients away from saturation boundaries, which we find to give better training behavior."

[I] So the purpose is bounded activations for low-precision training. It pairs with MXFP8 activations and FP8 storage, though the report does not draw that link in so many words.

### Quantile Balancing

[C] §2.3.3 and Appendices C–D, pp. 8–9, 43–45. The setting: auxiliary-loss-free routing. For token $i$, scores $s_i=\mathrm{Sigmoid}(W_rx_i)$ and

$$T_i=\mathrm{argtopk}(s_i+b),\qquad p_{i,j}=\frac{s_{i,j}}{\sum_{r\in T_i}s_{i,r}}$$

"Because b is omitted from $p_{i,j}$, it regulates dispatch without altering the mixture weights or the gradient-based optimization of the router." DeepSeek-V3's rule was $b_j\leftarrow b_j+\gamma\,\mathrm{sign}(\bar\ell-\ell_j)$, where $\gamma$ "trades off slow adaptation against load oscillation".

QB replaces the step by the exact solution. For $m$ tokens, $n$ experts, top-$k$, target load $q=mk/n$:

1. Route with Top-$(k+1)$ on $s_i+b^{(t)}$. The first $k$ are the routes taken. The $(k{+}1)$-th value is the cutoff $\alpha_i^{(t)}$ an expert must beat to enter token $i$'s Top-$k$.
2. For each expert take the margins $s_{:,j}-\alpha^{(t)}$. Set the new bias so that exactly $q$ margins clear it:

$$\hat b_j^{(t+1)}\leftarrow-\mathrm{quantile}_{1-k/n}\big(s_{:,j}-\alpha^{(t)}\big),\qquad b^{(t+1)}\leftarrow\hat b^{(t+1)}-\mathrm{mean}(\hat b^{(t+1)})\mathbf 1$$

3. "For causality, the update takes effect only in the next step, i.e., a batch is never routed with a bias derived from itself." "The final bias is frozen at inference."

It is one coordinate step on the dual of the balanced assignment problem: maximize total score subject to each token taking $k$ experts and each expert taking $mk/n$ tokens. The LP relaxation is exact. $\beta_j$ of the dual is $-b_j$; the token duals $\alpha_i$ are discarded (Appendix C). The old sign rule is SignSGD on the same dual; QB jumps to the coordinate minimizer. "This view explains both why QB requires no learning-rate-like hyperparameter and why it equilibrates within a few update steps even for nearly 10³ experts." [R] Figure 5's example: $m=8,n=4,k=1$ takes loads (4, 3, 1, 0) to (2, 2, 2, 2).

Practice: per-expert histograms, 1000 bins, one all-reduce per layer per step. Counts are additive, so the estimate is the quantile of the pooled global batch, "rather than an average of per-rank quantiles" (Appendix D). This independently matches MAI-Thinking-1's finding in the outline that aggregation over the global batch matters.

[Gap] Whether QB stays on during RL.

### MoonEP

[C] §5.2.1: a separate, execution-level balance. Load across expert-parallel ranks is made exact by placing redundant copies of experts, with a proof that $E/R$ redundant experts per rank always suffice (Appendix E). Every rank gets exactly $S\times K$ tokens, so shapes are static. "training is never interrupted".

### MiMo: freeze the router

[C] §5.4, p. 23. Two Pro RL runs differing only in router freezing, at decoder layer 9: with a trainable router, "CV increasing from 0.78 to 2.0, peak load from 6× to 16×, and the cold-expert fraction from 0.5% to 22%" in 20 steps. The diagnosis is a clean intervention: "we restore the router parameters of the step-20 checkpoint to their initial pre-RL values while keeping all other parameters unchanged: load balance recovers to near-initial levels while benchmark performance remains unchanged, indicating that the collapse is driven by router drift rather than by degradation of the expert weights." Frozen: CV ≈ 0.7, peak ≈ 5.5×, cold ≈ 1%.

[I] Note what remains after freezing: peak load 5.5× the mean is far from balanced by K3's standard. And RL's narrow data moved the router, as MAI-Thinking-1 also found. Three labs, three responses: MAI schedules the balancing coefficient; MiMo freezes; K3 reports QB and does not say what it does in RL.

R3 (§6.4): "records the expert indices used during rollout and replays them during training", because numerical differences "can flip discrete expert selections".

## 8. Reward hacking and verifier exploitation

### MiMo (§4.2.6, pp. 14–16; §4.3.2)

The fullest account in either report.

- [C] Definition and failure mode: "solution leakage: agents obtain a published fix beyond the intended task context and use it to construct a patch". Table 2 gives five verbatim cases: pytest, Astropy, Matplotlib, Django, Sphinx. For example, thinking "Let me look for the fix. The issue is likely fixed in later versions." then `pip index versions sphinx`.
- [C] Layers: mid-training alignment data; environment preparation (remove build logs, verifier outputs, binaries, caches; truncate Git history; network isolation); a hack agent; training-time auditing; the groupwise grader.
- [C] Hack agent: "It uncovered many exploit paths that we had not observed during training and that our existing cleanup procedures did not cover. ... We continued this process until the hack agent could no longer find a successful exploit in any of the environments."
- [C, read off Fig. 6b] Hackable rate starts near 100% in round 1; three datasets fall to about 10–20% by round 2; `code/dataset-obg8` goes about 93, 49, 34, 22 over four rounds. [I] That last point sits awkwardly with "could no longer find a successful exploit in any of the environments"; the plot may stop before the final rounds or may measure something else. Worth quoting with care.
- [C] "the groupwise agentic grader ... sets the effective reward of confirmed hacking trajectories to zero before recomputing group statistics and advantages. With this correction in place, the logged confirmed-hack share remains below 2% throughout the whole training process". The plot shows detected share between about 0.5 and 1.8% per step for both models. [I] This is a rate of what their detector finds. The 2% is a detection floor, not a hacking rate.
- [C] "When evidence confirms dependence on an external or leaked answer, we reset the trajectory's effective reward to zero and treat it as a failure".
- [C] A subtler effect than hacking, from a code-only Flash comparison at batch 128 (Fig. 8): "under pressure to improve test pass rates, policies trained without online grading increasingly adopted undesirable behaviors such as speculative compatibility branches, broad exports, exception swallowing, relaxed validation, and evaluation-specific configuration changes." Without GAR, turns and token length "grow rapidly"; with it, pass-rate gains are sustained through step 52. This is the outline's "a passing test does not distinguish a solution from an exploit" with a measured dose.
- [C] Supervision audits: each task attempted four times, an auditing agent compares each patch with a specification-first judgment and flags false positives and false negatives; tests must be stable over eight reruns (§4.2.1, pp. 10–11).
- [C] Cyber verifier as a case of designing against the gradient: "Either error corrupts the training gradient." Fix-binary differential testing and LLM judges are rejected; a PoC is accepted iff vulnerability type and top project stack frame both match the sanitizer report by string match (§4.2.4, p. 13).
- [C] Rubrics: adversarial solutions "that appear correct without actually solving the task" and negative checks on unrelated files (§4.2.2).

### K3

- [C] Kernel tasks: "a hacking-detection system that penalizes reward-hacking strategies such as CUDA graph replay, input caching, and precision reduction, and we continuously extend it with new safeguards as new hacking strategies are observed during Kimi K3's development." (§4.2.4).
- [C] Autonomous Execution Tasks: "Reward hacking is mitigated by isolating agents from verifiers, pairing public verifiers that offer diagnostic feedback with hidden verifiers that evaluate held-out scenarios, and applying penalty-based rewards under limited submission budgets." (§4.2.6).
- [C] GRM: "To mitigate reward hacking toward increasingly verbose outputs, we apply a budget-based verbosity control" (§4.1.2).
- [C] Sandboxes: "As agents become more capable and tasks more difficult, they tend to explore more aggressively and may even attempt reward hacking. ... in our early experiments with traditional container-based sandbox runtimes, we observed several kernel panics and deadlocks caused by unintended agent operations." (§5.3.2).
- [Gap] No measured hack rate, no audit results. K3 names mechanisms and MiMo gives a curve.

## 9. Stated failures, ablations, instabilities

**K3**

| What failed or was compared | Outcome | Where |
|---|---|---|
| Vanilla LatentMoE at sparsity 56 | Exploding routed-branch activations | §2.3 |
| Sign-based bias updates at 896 experts | Load oscillation or slow adaptation | §2.3.3 |
| SigLIP-initialized encoder | Unstable joint optimization, gradient spikes (Fig. 6) | §2.4 |
| WSD against cosine | Cosine lower final loss, with independent searches | §3.2 |
| Hard clamping against SiTU | SiTU trains better | App. B |
| BIP inequality-constrained balancing | "markedly slows equilibration" | App. C |
| Top-$k$ distillation | No clear advantage | §4.1.3 |
| Container sandboxes | Kernel panics and deadlocks | §5.3.2 |
| Prior EP schemes with preset redundancy | Training "forced to stop" when no plan exists | §5.2.1 |

**MiMo**

| What failed or was compared | Outcome | Where |
|---|---|---|
| Trainable router in RL | Load collapse (numbers above) | §5.4 |
| AdamW at large RL batches | "diminishing optimization efficiency" | §3.2 |
| Early RL | Reward hacking tendency | §4.2.6 |
| No GAR | Token growth; bad code habits | §4.3.2 |
| Production harnesses for RL | Rejected: extras "fall outside the task-completion reward signal" | §4.2.5 |
| Infrastructure in the run | GPU double-bit errors; K8s failure in cyber cluster (Flash); grader unreachable after step 14 (Pro) | §5.5 |
| Rollout | Short rollouts finish first, biasing length estimates and exhausting KV pools | §5.5 |
| Training | GPU OOM: "an expert-parallel (EP) rank received over 30× the mean token load despite a relatively balanced full batch" | §5.5 |
| Driver | CPU OOM packing long sequences late in Flash | §5.5 |

[I] The 30× OOM against K3's MoonEP is a direct contrast: a balanced batch is not a balanced micro-batch, and MoonEP exists to remove exactly this. Worth a sentence in §9 of the essay.

From the AttnRes paper [C]: "Crucially, all pseudo-query vectors must be initialized to zero. This ensures that the initial attention weights αi→l are uniform across source layers, which reduces AttnRes to an equal-weight average at the start of training and prevents training volatility, as we validated empirically." (§5, PDF p. 8.)

## 10. Audit of the outline's claims about K3 and MiMo, §§7–10

| § | Claim | Verdict |
|---|---|---|
| 7 | Stages: pretraining, mid-training and context extension, SFT, RL, on-policy distillation, drafting | **Confirmed.** K3 calls mid-training "cooldown"; MiMo names mid-training as a stage |
| 8 | MiMo 27T text plus 3T multimodal | **Confirmed** for Pro. Add: >4T image tokens for the ViT in a separate stage |
| 8 | K3 multimodal from the start | **Confirmed** |
| 8 | MiMo staged | **Confirmed**, with text first and pretrained encoders joined later |
| 8 | Optimizer split as pretraining fact: Muon or variant for hidden matrices, AdamW for embeddings, head, router | **Wrong for MiMo pretraining**: AdamW for everything. The split begins at mid-training. **Not found for K3**: report says only "matrix parameters" |
| 8 | Per-Head Muon in K3 | **Confirmed**, for attention projections, with QK-Clip |
| 8 | Muown in MiMo | **Confirmed as a variant, wrong as to stage**: mid-training on |
| 9 | K3's SiTU controls activation growth | **Confirmed**, but **misplaced**: it belongs under experts, not residual mixers |
| 9 | Quantile Balancing in K3 | **Confirmed** |
| 9 | K3 8K, 64K, 256K, 1M | **Confirmed** |
| 9 | MiMo extends 256K to 1M in mid-training | **Confirmed**. Add 32K → 256K in pretraining, and that most mid-training compute stays at 256K |
| 9 | Enlarging the position range does not teach long-range use | **Confirmed in substance** by K3's "Length alone ... does not confer long-range capability". K3 has no position range to enlarge (NoPE), which makes the point cleaner |
| 9 | MXFP4 QAT in MiMo's mid-training and K3's post-training | **Confirmed**. K3's is experts only, from SFT on, MXFP8 activations |
| 9 | Drafters: MTP modules propose tokens the main model verifies | **Confirmed**. K3: MTP layer becomes EAGLE-3 draft. MiMo: MTP replaced in RL by DFlash |
| 9 | Drafter not evidence of several tokens at once | **Consistent** with both. MTP in pretraining is an auxiliary objective; MiMo says it improves performance |
| 10 | SFT teaches formats and tool use; the loss mask decides | **Confirmed** for K3 (tool calling, XTML format). **Not found** for V2.6's own SFT. MiMo's $M_{i,t}$ is an RL mask. Distill-Qwen-9B's 77.4B total against 27.2B loss tokens is the best number for the point |
| 10 | RL separates policy, environment, verifier, advantage, optimizer | **Confirmed** by MiMo's three-part decomposition plus GAR |
| 10 | A passing test does not distinguish a solution from an exploit | **Confirmed**, MiMo §4.2.6 |
| 10 | K3 trains nine policies (three domains, three efforts) | **Confirmed** |
| 10 | K3 distils them on-policy | **Confirmed**. Student is effort-conditioned. Some SFT on expert trajectories too |
| 10 | MOPD2 distils through three streams | **Confirmed in substance**. "Streams" is not the report's word |
| 10 | Separates demonstrations as targets from demonstrations as starting contexts | **Confirmed for the student**. **Needs nuance**: demonstrations are targets for SFT teachers |
| 10 | Post-training as main source of release-to-release change | **Not found** in these reports for K3.1 or a K3 update. MiMo's title and framing support it in general |
| §9 note | Does the essay cover stale rollouts? | Material exists: K3 §4.1.2, MiMo §§4.1, 5.1 (staleness 4; inference probabilities not recomputed) |

## 11. What the outline misses

### Order of training

1. **The optimizer is staged in MiMo.** AdamW writes the stores; Muown takes over before RL because of batch size. K3 is the opposite design, Muon from step one. Pairs with Qu et al.'s mismatch and K2's "a Muon-pre-trained checkpoint produces the best performance with Muon fine-tuning".
2. **RL's failures feed back into mid-training.** "In early experiments, we observed a tendency toward reward hacking in MiMo. To mitigate this behavior, we synthesized a set of training examples from these cases and included them in mid-training. For each case, MiMo reflects on the faulty reasoning, revises the relevant turn, and continues with actions grounded in the task specification." (p. 14). So the pipeline is not a line. A trial RL run comes before the final mid-training. This pairs with MAI-Thinking-1's self-distillation. Attribution of improvement is [R]: "We found that adding these examples improved the model's alignment."
3. **The SFT checkpoint is the grader.** An earlier stage of the model judges the later stage. SFT must exist before RL for a second reason beyond the cold start, and it stays fixed "to support stable scoring".
4. **Router before RL.** Routing is learned in pretraining and mid-training, then locked. MiMo's reset experiment shows the expert weights can keep improving under a router that has been put back. A strong instance of "circuits before facts", at the post-training end. [I]
5. **Max effort first.** K3 trains the highest budget, then anneals down. The low-effort policy comes from the high-effort one, never the reverse.
6. **Teachers must descend from the student's checkpoint.** Ma et al.: a stronger stranger harms. [Gap] for K3 and V2.6 themselves.
7. **Vision: two opposite orders, one objective.** K3 trains encoder and language model jointly from nothing, because attaching a pretrained encoder destabilizes joint training. MiMo pretrains the encoder apart, with a small LLM kept trainable, and attaches it later. Both avoid contrastive pretraining and use next-token cross-entropy.
8. **Quantization enters before the policy does.** K3 at SFT, MiMo at mid-training, so that RL's rollouts and updates see the same weights. RL cannot start on full precision and be quantized later without a train–inference gap. MiMo carries FP32 master weights across the stage boundary, along with Muown's row state.
9. **The drafter follows the policy.** MiMo trains DFlash on the SFT policy, then fine-tunes on early RL logs. K3 freezes the target. A drafter is a model of the policy, so it comes after it.
10. **Long context at the end, in a small share of budget.** K3 states this. MiMo agrees: most mid-training compute at 256K, then 1M last.

### Components made trainable by a specific device

1. **Lower-bounded decay in KDA.** $g=g_{min}\mathrm{Sigmoid}(e^Az)$ with $g_{min}=-5$ (Eq. 5, p. 5). The chunkwise form divides by cumulative decay, which "can grow without bound and overflow in finite precision". With the bound, cumulative log-decay over a 16-token tile lies in $(-80,0)$, so the reciprocal stays "within the BF16 dynamic range" (I checked: $e^{80}\approx5.5\times10^{34}$, BF16 max about $3.4\times10^{38}$). A retention floor of $e^{-5}\approx0.0067$ is chosen for number format. It does not restrict memory much, since a channel with $\alpha=0.0067$ is already gone in one step. This is a striking case of arithmetic choosing a parameterization. [C for the bound; I for the last remark]
2. **FP32 attention output** to correct biased rounding in flash attention (§2.1.2), with the kernel redesigned to overlap it with KV staging.
3. **Identity-preserving initialization** recurs: AttnRes pseudo-queries at zero (uniform averaging at the start); $W_{E3}=[0\;0\;I]$ in K3's draft fusion; and MAI-Thinking-1's zero-gain attention output in the outline. [I] A pattern worth stating: the new component starts as the simpler model it replaces and learns its way out. MiMo's dense first layer "to stabilize early representation learning" (§2.1) is a kindred device.
4. **Bias excluded from mixture weights** (Eq. 13): balancing acts on dispatch only, so the router's gradient is untouched.
5. **Teacher scoring treated as reward.** Dense distillation drops into RL infrastructure, so partial rollouts and async teachers work (K3 §4.1.3; MiMo §6.2; Ma §3.3).
6. **Forked sandboxes for judging.** K3's AgentENV "fork creates a new sandbox ... useful for reward judging without side effects".

### Smaller points worth a clause

- **Harness diversity, two ways.** K3 composes modules that instantiate real harnesses, Claude Code and Codex among them (§4.2.1). MiMo rejects production harnesses for RL and builds decoupled mini-harnesses; held-out mean Pass@1 goes from about 50% to 66% (§5.3).
- **Length control, two ways.** K3: over-budget trajectories get reward −1. MiMo: prompt-mean aggregation plus a group-relative penalty.
- **Self-application.** "an early Kimi K3 checkpoint was already handling most of our kernel optimization work during late-stage development" (§7, p. 33). MiMo corrects its own hacking traces. The MiMo report's framing is recursive self-improvement.
- **Scale difference in RL.** MiMo's single run is thousands of GPUs. K3 keeps each experiment to a few hundred, and needs nine or more. The two are not comparable without K3's step counts.
- **"You Only RL Once"** is the MiMo section title (§5). One run of 30 steps.

## 12. Disclosure gaps

These are findings for the essay's §11.

**K3:** pretraining tokens; TPP value; batch size; peak and floor learning rate; Muon momentum and NS steps; QK-Clip threshold; what uses AdamW; tokens per context stage; cooldown's learning rate and data share; SFT size; RL steps, cost and total compute; $\lambda,N,K,\tau,\sigma,R_{max}$; post-training optimizer; whether QB runs in RL; MOPD student's starting checkpoint and order relative to SFT on expert trajectories; any measured hack rate.

**MiMo:** pretraining learning rate, schedule and batch size; mid-training token budget and learning rate; what an image token is and whether 4T counts toward 30T; V2.6's own SFT content and size; expert activation precision; meaning of "Adam component" and of the 0.5 factor; MOPD2's token budget, loss form, prefix sampling and student checkpoint; how the three workflows are weighted; whether the hack rate has any independent check.

**Comparison.** Pretraining is K3's thin spot only by contrast with K2. RL and hacking are where MiMo is far ahead. K3 is ahead on the architecture-specific devices (QB, SiTU, decay, MoonEP) with derivations and proofs. Neither report gives a pretraining cost.
