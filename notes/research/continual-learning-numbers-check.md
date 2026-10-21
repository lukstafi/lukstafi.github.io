# Numbers check: continual-learning essay (checked 2026-10-21 against arXiv abs + HTML)

## 1. Retaining by Doing: CONFIRMED (one caveat on Iterative-SFT scope)
- Title: *Retaining by Doing: The Role of On-Policy Data in Mitigating Forgetting*
- Authors: Howard Chen, Noam Razin, Karthik Narasimhan, Danqi Chen, all at Princeton Language and Intelligence, Princeton University. No MIT involvement.
- arXiv 2510.18874. v1 21 Oct 2025, v2 3 Dec 2025, v3 26 Jun 2026. Venue: ICML 2026 (PMLR 306; arXiv journal-ref "Proceedings of the 43rd ICML, 2026").
- Models: Llama-3.2-1B-Instruct, Llama-3.1-8B-Instruct, Qwen-2.5-1.5B-Instruct, Qwen-2.5-7B-Instruct.
- Setup (§2.2): there are three target tasks: IFEval (instruction following), MMLU (general knowledge) and Countdown (arithmetic). "After training on one target task, we evaluate the model's performance on all the other tasks." The non-target set also includes MATH, WildJailbreak and WildGuardTest. Drop = mean accuracy decrease over the non-target tasks. SFT data comes from Llama-3.3-70B-Instruct, filtered for correctness. Training runs for 2 epochs. RL is GRPO with 0/1 reward.
- Table 1, Qwen 2.5 7B Inst. (Gain / Drop, %):
  - SFT: IFEval 24.2 / **5.6**; MMLU 9.4 / **14.6**; Countdown 10.4 / **29.2**
  - REINFORCE: 5.7 / 2.9; 6.4 / -0.6; 11.9 / -0.1
  - GRPO: 17.0 / **0.2**; 8.4 / **0.2**; 29.2 / **-0.3**
  - All six numbers in the claim are CONFIRMED. For comparison, Llama 3.1 8B SFT drops are 27.8 / 38.5 / 36.4, against GRPO's 3.4 / -0.2 / -0.5.
- KL ablation: CONFIRMED, with one exception. Fig. 6 compares GRPO at β=0.05 and β=0. The paper says: "non-regularized GRPO achieves a similar target task gain and non-target tasks drop tradeoff as KL-regularized GRPO across all considered models and datasets, except for Llama models trained on IFEval."
- Iterative-SFT: CONFIRMED, but it was tested on a narrower set than the claim implies. Fig. 7 covers only Qwen 2.5 1.5B and 7B, on IFEval and MMLU. Countdown and Llama were not tested. Iterative-SFT "uses data generated at the start of each round (i.e., epoch)… runs for multiple rounds until the target accuracy matches SFT". The paper reports that it reaches "a target accuracy that is higher than or comparable to that of SFT, while only exhibiting mild to no forgetting."
- Further ablations: REINFORCE has no advantage estimator and forgets about as little as GRPO. SFT on traces from an RL run also reduces forgetting (App. A.4.1).
- Relevant to #2: the paper finds that RL's Razor's "hypothesis on the connection between KL divergence from the initial policy and forgetting does not always hold in our setting" (App. A.5, "KL Divergence From Initial Policy and Forgetting Correlate Moderately").

## 2. RL's Razor: CONFIRMED
- Title: *RL's Razor: Why Online Reinforcement Learning Forgets Less*
- Authors: Idan Shenfeld\*, Jyothish Pari\*, Pulkit Agrawal (\*equal contribution). Affiliation: **Improbable AI Lab, MIT**.
- arXiv 2509.04259, v1 4 Sep 2025 (only version). Venue: ICLR 2026.
- Main claim (abstract): "the degree of forgetting is determined by the distributional shift, measured as the KL-divergence between the fine-tuned and base policy evaluated on the new task… on-policy RL is implicitly biased towards KL-minimal solutions… We term this principle RL's Razor: among all ways to solve a new task, RL prefers those closest in KL to the original model."
- Direction of the KL: the paper writes E_{x∼τ}[KL(π₀‖π)], with the base policy as the first argument, and calls it "forward KL". The essay should not write it the other way round.
- Headline numbers:
  - ParityMNIST: "A quadratic fit achieves R²=0.96". In the LLM experiments, "a quadratic fit achieving R²=0.71 (Figure 11)".
  - Table 1 (MNIST, R² of a 2nd-degree polynomial fit): forward KL 0.96±0.01, reverse KL 0.93±0.01, TV 0.80, distribution L2 0.56, weight-change L1 0.34, Fisher-weighted L2 0.58, spectral norm 0.58, activation L1 0.52, activation L2 0.55. Sparsity and rank of updates are N/A: the observed sparsity came from bf16, and all updates were full rank.
  - Oracle SFT on the KL-minimal labeling "retained more prior knowledge than RL".
- Setups: Qwen 2.5 3B-Instruct trained on Open-Reasoner-Zero math, SciKnowEval Chemistry L-3, and ToolAlpaca. OpenVLA-7B on SimplerEnv pick-and-place.

## 3. SDFT, *Self-Distillation Enables Continual Learning*: CONFIRMED
- Authors: Idan Shenfeld, Mehul Damani, Jonas Hübotter, Pulkit Agrawal. Listed affiliations are MIT, Improbable AI Lab and ETH Zurich; Hübotter is the ETH author. This is an **Agrawal / Improbable AI Lab paper**.
- arXiv 2601.19897. v1 27 Jan 2026, v2 7 Aug 2026. Venue: ICML 2026 (PMLR 306:111542–111558).
- Construction: the same model plays two roles. The student is P=π(·|x). The teacher is the model conditioned on an expert demonstration c, Q=π(·|x,c). The paper says: "samples responses from the student policy y∼πθ(·|x) and minimizes the reverse KL… between the student and the teacher."
- EMA teacher: **yes**. "Unless mentioned otherwise, we use an exponential moving average (EMA) of the student parameters for the teacher." App. A.3 / Fig. 8 compare it with alternatives: a frozen base teacher gives inferior results, and using the current student as teacher is unstable.
- Caveat (v2): "Although the theory points to Reverse KL as a suitable loss, we found in practice that Forward KL yields the best performance" for the token-level loss. The official repo likewise says the results used on-policy sampling with a per-token forward KL. Sampling is on-policy, but the loss in practice is not reverse KL.
- Scale: CONFIRMED, and the paper's claim is stronger than "less effective". In §5 / Fig. 5: "At small scales, such as the 3B variant, the model's in-context learning is too weak to provide meaningful teacher guidance, and performance lags behind standard SFT… The 7B model achieves a four-point improvement over SFT, and the 14B model widens the margin to seven points." The measurement is on Science Q&A with Qwen 2.5.
- Compute: CONFIRMED. "approximately 2.5× the computational cost in FLOPs and roughly 4× the wall-clock training time compared to SFT."
- Sequential result: the model is trained sequentially on three skills (Science Q&A on SciKnowEval Chem L-3, Tool Use on ToolAlpaca, Medical via HuatuoGPT-o1). Base model is Qwen2.5-7B-Instruct. Fig. 3: "SDFT is able to learn each one while retaining performance on the others. In contrast, SFT performance on each task drops once it starts learning the next one." Performance is normalized so that 0 is base accuracy and 1 is the best accuracy of either method. The paper gives no single headline number for this experiment.
- Other numbers:
  - Knowledge acquisition (2025 disasters corpus, Table 1): strict accuracy SFT 80 vs SDFT 89, oracle RAG 91; OOD accuracy SFT 80 vs SDFT 98.
  - KL to base on ToolAlpaca: SFT model 1.26 nats vs demo-conditioned teacher 0.68 nats.
  - The prior-capability suite is HellaSwag, TruthfulQA, MMLU, IFEval, Winogrande and HumanEval.
  - Known artifact: the student learns prefaces such as "Based on the text…". The fix is to mask the loss on the first few tokens.

## 4. SDPO, *Reinforcement Learning via Self-Distillation*: CONFIRMED (SFT holdout avg is 41.4, GRPO 41.8)
- Authors: Jonas Hübotter, Frederike Lübeck, Lejs Behric, Anton Baumann, Marco Bagatella, Daniel Marta, Ido Hakimi, Idan Shenfeld, Thomas Kleine Buening, Carlos Guestrin, Andreas Krause.
- Affiliations: ETH Zurich (main), MIT (Shenfeld), Stanford (Guestrin), MPI for Intelligent Systems. Correspondence: jonas.huebotter@inf.ethz.ch. Code: github.com/lasgroup/SDPO (Krause's group).
- No Agrawal. Shenfeld joined in Dec 2025 and contributed to core algorithmic ideas.
- arXiv 2601.20802. v1 28 Jan 2026, v2 16 Feb 2026. Venue: ICML 2026 (PMLR 306).
- Model: Qwen3-8B. Table 5 (§4, LCBv6 plus holdout tasks):

  | | LCBv6 | IFEval | AH-v2 hard | AH-v2 creative | MMLU-Pro | Avg holdout |
  |---|---|---|---|---|---|---|
  | Base | 27.9 | 83.9 | 14.0 | 13.7 | 62.5 | 43.5 |
  | SFT on self-teacher | 42.7 | 83.7 | 11.2 | 8.9 | 61.9 | 41.4 |
  | GRPO | 41.2 | 82.2 | 12.0 | 10.8 | 62.3 | 41.8 |
  | SDPO | 48.8 | 83.2 | 12.3 | 11.1 | 62.9 | 42.4 |

- All four LCB numbers are CONFIRMED, and so is holdout 43.5 → 42.4 for SDPO.
- The table caption reads: "On-policy methods do not suffer from catastrophic forgetting… SDPO achieves the best performance–forgetting tradeoff."
- Also: SDPO reaches "GRPO's final accuracy in 4× fewer generations".

## 5. iSDFT: CONFIRMED
- Title: *iSDFT: Information-Proximal Self-Distillation for Continual Learning in LLMs*
- Authors: Ahmed Khaled Khamis\*, Xiaotong Ji\*, Hassan Jaber, Rasul Tutunov, Matthieu Zimmer, Jun Wang, Haitham Bou-Ammar.
- Visible affiliations: Imperial College London, Politecnico di Torino, UCL Centre for AI. Khamis's email is gatech.edu.
- arXiv 2609.24646. v1 21 Sep 2026, v2 28 Sep 2026. Preprint, no venue.
- Construction: CONFIRMED. Prop. 1 gives Q*_t(v) ∝ P_t(v)^{1−λ_t} T_t(v)^{λ_t}. Here λ_t is "not a tuned interpolation weight, but the local Lagrange multiplier induced by the information budget γ_t", solved by bisection.
- Loss: ℓ_t = KL(Q*_t‖P_t) + μ·KL(P_base‖P_t), with μ = 2×10⁻³. This is the "KL anchor to a frozen base policy".
- Abstract numbers: CONFIRMED. "iSDFT improves vanilla SDFT in 7 of 8 model-task settings and matches it in the remaining one… with 73% of evaluations remaining within 0.5 points of the base model versus 52% for the strongest baseline."
- Settings: 4 backbones (Qwen2.5-7B-Instruct, Qwen3-1.7B, Gemma-4-E2B-it, OLMo3-7B-Think) × 2 tasks (Tool Use, Science). The average gain over SDFT is 2.7 points. There are 48 retention evaluations per method.

## 6. Denser ≠ Better: CONFIRMED; exact title and id below
- Title: *Denser ≠ Better: Limits of On-Policy Self-Distillation for Continual Post-Training*
- Authors: Meng Wang, Haohan Zhao, Wenzhuo Liu, Lu Yang, Geng Liu, Haiyang Guo, Guo-Sen Xie, Gaofeng Meng, Hongbin Liu, Fei Zhu.
- Affiliations: CAIR, HKISI-CAS; Institute of Automation, CAS; UCAS; Nanjing Univ. of Sci. & Tech.
- arXiv **2607.01763**. v1 2 Jul 2026, **v2 2 Oct 2026**. Code: github.com/Moenupa/SDPO-CL.
- Abstract: "In continual post-training, SDPO exhibits greater forgetting and can even collapse, whereas GRPO… adapts more conservatively and better preserves prior capabilities. Further analyses link these failures to increased drift in parameter and response space, and to amplification of high-frequency artifacts through a self-reinforcing teacher–student loop. Thus, on-policy data alone is insufficient for continual learning."
- Wording: the abstract says "high-frequency artifacts". The body says "reinforces teacher noise, temporal mismatch, and formatting artifacts many times within a single response". It contrasts SDPO with "sequence-level reward optimization (GRPO)".
- Collapse example: "SDPO_5% … collapses after the third stage and remains near zero."
- Models: Qwen3-4B-Instruct/Thinking-2507 and Olmo-3-7B-Instruct/Think-DPO.

## 7. SynthSelf: CONFIRMED
- Title: *Continually Post-training Small Models via Synthetic Self-distillation*
- Authors: Woosung Koh\* (KAIST AI; work done as an intern at LG AI Research), Hyunsoo Lee, Kyungjae Lee, Haeju Park, Dahyun Lee, Dasol Hwang, Moontae Lee (all LG AI Research).
- arXiv **2610.13113**, v1 **9 Oct 2026**. Preprint.
- Method: a "minimally larger, same-family aligner" (Qwen2.5-7B or 14B) rewrites the demonstrations in-distribution. The rewrites go through rejection sampling, then off-policy SFT. Base models are Qwen2.5 0.5B/1.5B/3B (Instruct).
- Table 1, "Average / Avg." row (Base, SFT, SDFT, DFT, ASFT, SS-1Δ, SS-2Δ):
  - Acq.: 34.2, 52.2, **44.1**, 39.8, 46.1, **56.4**, 56.4
  - Ret.: 42.8, 40.5, **41.5**, 40.4, 41.8, **41.7**, 41.8
- So 56.4 vs 44.1 and 41.7 vs 41.5 are CONFIRMED. Caveats:
  - ASFT retention (41.8) equals or beats SS-1Δ.
  - All methods retain less than Base (42.8).
  - SFT acquisition (52.2) beats SDFT at these scales.
  - The caption says SynthSelf "ties the best baseline on 14 retention tasks."

## 8. DER (Buzzega et al. 2020): CONFIRMED
- Title: *Dark Experience for General Continual Learning: a Strong, Simple Baseline*
- Authors: Pietro Buzzega, Matteo Boschini, Angelo Porrello, Davide Abati, Simone Calderara.
- arXiv 2004.07211. Venue: NeurIPS 2020.
- Table 2, buffer 200, S-CIFAR-10 Class-IL: ER 44.79±1.86, DER 61.93±1.79, DER++ 64.88±1.17. The same rows give iCaRL 49.02, GEM 25.54, A-GEM 20.04 and JOINT 92.20.

## 9. Lampinen et al.: CONFIRMED in substance; augmented fine-tuning often beats ICL
- Title: *On the generalization of language models from in-context learning and finetuning: a controlled study*
- Authors: Andrew K. Lampinen, Arslan Chaudhry, Stephanie C. Y. Chan, Cody Wild, Diane Wan, Alex Ku, Jörg Bornschein, Razvan Pascanu, Murray Shanahan, James L. McClelland. Affiliations: Google DeepMind; McClelland also Stanford.
- arXiv 2505.00661. v1 1 May 2025, v3 10 Nov 2025. Venue: FoRLM workshop, NeurIPS 2025.
- Setup: Gemini 1.5 Flash, plus Flash-8B in an appendix. Datasets use nonsense words to rule out contamination: Berglund et al.'s reversal-curse data, simple reversals, simple syllogisms, and a "semantic structure" dataset with splits for reversal, syllogism and category holdout.
- Finding: "in-context learning over the entire training dataset often generalizes better than finetuning, when evaluated on systematic holdouts like reversals, syllogistic inferences, and other logical deductions."
  - On the reversal-curse data, ICL is "nearly at ceiling on the reversals", while plain fine-tuning has "near zero accuracy".
  - In the semantic structure dataset, plain fine-tuning does generalize above chance to reversals embedded in a coherent knowledge structure, which qualifies the reversal curse.
  - Category holdouts stay hard for all methods.
- Method name: **"augmented finetuning" / dataset augmentation**. The model is prompted to reason about the data in context, and the resulting traces are added to the fine-tuning set. There are two variants: a "local (sentence) augmentation" (rephrasings and reversals) and a "global (document) augmentation" (the full dataset in context, with inferences linking documents). The paper also proposes "sentence splitting" to amplify the benefit.
- Strength of the effect: "closes much of the gap" undersells it. On the reversal-curse data it "yields similarly high test performance" to ICL. On the semantic structure data, augmentation "improves performance from finetuning, in many cases outperforming even ICL."

## 10. Puri et al. 2026: CONFIRMED (title, id); the paper calls the method "Multi-Answer RLVR / RLCR"
- Title: *Reaching Beyond the Mode: RL for Distributional Reasoning in Language Models*
- Authors: Isha Puri, Mehul Damani, Idan Shenfeld, Marzyeh Ghassemi, Jacob Andreas, Yoon Kim. All MIT; no Agrawal.
- arXiv 2603.24844, v1 25 Mar 2026. No venue listed.
- Naming: the paper mostly says "Multi-Answer RL", "Multi-Answer RLVR" and "Multi-Answer RLCR". "Multi-RLVR" appears only once, in Appendix B.
- Summary: post-training collapses a model's answer distribution onto one mode. The authors instead train the model with GRPO (Qwen3-8B base) to emit a set of K distinct candidate answers in one chain of thought.
  - The reward is R = Σᵢ 1[aᵢ ∈ Y*]. Uniqueness is enforced by zeroing all rewards when answers repeat. This reduces to standard RLVR at N=K=1 and to pass@K at N=1, K>1.
  - Multi-Answer RLCR adds a per-answer verbalized confidence, trained with a multi-answer Brier score (the RLCR line of Damani et al. 2025).
  - Evaluation is on DDXPlus (differential diagnosis), HotPotQA-Modified (relevant paragraphs removed) and MBPP.
  - Results: better diversity, coverage and set-level calibration than single-answer training, with fewer tokens than repeated sampling. "on coding tasks, our approach boosts top-1 accuracy by over 50% while cutting token usage by more than half."
  - The authors position it as "a principled and compute-efficient alternative to inference-time scaling procedures such as best-of-k."

## 11. Sutton's group: CONFIRMED
- Dohare et al. paper:
  - Title: *Loss of plasticity in deep continual learning*
  - Authors: Shibhansh Dohare, J. Fernando Hernandez-Garcia, Qingfeng Lan, Parash Rahman, A. Rupam Mahmood, Richard S. Sutton. Affiliation: University of Alberta, Dept. of Computing Science.
  - Published in *Nature* 632(8026):768–774, online 21 Aug 2024. doi:10.1038/s41586-024-07711-7.
  - Abstract: "standard deep-learning methods gradually lose plasticity in continual-learning settings until they learn no better than a shallow network… [shown] using the classic ImageNet dataset and reinforcement-learning problems… Plasticity is maintained indefinitely only by algorithms that continually inject diversity into the network, such as our continual backpropagation algorithm, a variation of backpropagation in which a small fraction of less-used units are continually and randomly reinitialized… sustained deep learning requires a random, non-gradient component to maintain variability and plasticity."
- Javed & Sutton paper:
  - Exact title: *The Big World Hypothesis and its Ramifications for Artificial Intelligence*, by Khurram Javed and Richard S. Sutton (2024).
  - Venue: **Finding the Frame Workshop at the Reinforcement Learning Conference (RLC) 2024**. This is a workshop paper, not a main-track one.
  - I confirmed the venue from the reference list of Lewandowski et al., arXiv 2512.23419. I did not reach the OpenReview page itself.
