# Part 3 source check

All arXiv items were checked against the arXiv HTML full text (and the abstract page where noted). Local copies are in `scratchpad/dl/` and `scratchpad/p3/`.

---

## 1. Metalearning Continual Learning Algorithms

- **Title:** *Metalearning Continual Learning Algorithms* (an earlier version, Sept 2023, was titled "Automating Continual Learning").
- **Authors:** Kazuki Irie (Harvard), Róbert Csordás (Stanford), Jürgen Schmidhuber (KAUST; IDSIA). The work was done at IDSIA in 2023.
- **arXiv:** 2312.00276. v1 is dated 1 Dec 2023; v3 is dated 17 Feb 2025.
- **Venue:** **TMLR** (accepted Feb 2025; OpenReview IaUh7CSD3k). It is **not** the ACL conference.

**Summary.** The method is called **Automated Continual Learning (ACL)**. It meta-trains a "Recursive Self-Transformer" in which each self-attention layer is replaced by a self-referential weight matrix (SRWM). The SRWM rewrites itself at every input step. The meta-objective adds backward-transfer terms, i.e. accuracy on earlier tasks after later tasks have been seen in context. Without those terms, naive in-context learners show "in-context catastrophic forgetting" (Sec. 4.1–4.2, Table 1). The evaluation is Split-MNIST, replay-free (Table 3), meta-trained on Omniglot and Mini-ImageNet:

| Split-MNIST setting | ACL, meta-finetuned with 5-task ACL loss | Best non-meta baseline | GeMCL |
|---|---|---|---|
| 5-task domain-incremental | 84.5 | LwF 71.0 | — |
| 2-task class-incremental | 96.0 | — | 91.2 |
| 5-task class-incremental | 84.3 | LwF 24.2 | 79.0 |

The paper names a limitation: on "mini" Split-CIFAR100 and 5-datasets with a frozen ViT-B/16, ACL scores 68.3 and 61.5. L2P scores 83.9 and 81.1 on the harder full versions (Table 4). The authors write that this "illustrates a general limitation of in-context learning."

**Claims**
- **Self-referential weight matrix with a delta-rule update: CONFIRMED.** "Eq. 3 corresponds to a rank-one update of the SRWM, from W_{t−1} to W_t, through the delta learning rule (Widrow and Hoff, 1960; Schlag et al., 2021)."
- **Meta-learns in-context continual learning; method name "ACL": CONFIRMED.** "we propose Automated Continual Learning (ACL) to train self-referential neural networks to metalearn their own in-context continual (meta)learning algorithms." ACL here stands for the method, not a venue.
- **Split-MNIST: CONFIRMED** (Table 3).
- **Class-incremental: CONFIRMED.** Table 3 reports "domain-incremental (DIL) and class-incremental learning (CIL) settings".
- **Split-FashionMNIST: PARTLY.** It is not a headline benchmark. It appears only in the meta-validation ablation (Table 7: "Split-CIFAR-10, Split-Fashion MNIST (Split-FMNIST), and Split-MNIST in the domain-incremental setting"; ACL out-of-the-box scores 75.6 on FMNIST). Fashion-MNIST also appears as one task in the multi-dataset sequences (Sec. 4.3, Table 9).
- **Compared with EWC: CONFIRMED.** Table 3 rows: "Elastic Weight Consolidation (EWC) 58.9 ± 2.6 | 49.7 ± 0.1 | 19.8 ± 0.1" and "Online EWC 57.3 | 49.7 | 19.8". These compare with ACL's 84.5 / 96.0 / 84.3.
- **Compared with replay: WRONG.** No replay method is compared; the setting is deliberately replay-free. "No method here requires replay memory." "We are not aware of any existing hand-crafted CL algorithms that can achieve ACL's performance without any replay memory."

---

## 2. Text-to-LoRA

- **Title:** *Text-to-LoRA: Instant Transformer Adaption* ("Adaption" is the paper's own spelling).
- **Authors:** Rujikorn Charakorn, Edoardo Cetin, Yujin Tang, Robert Tjarko Lange. All are at **Sakana AI**.
- **arXiv:** 2506.06105. v1 is dated 6 Jun 2025.
- **Venue:** **ICML 2025**.

**Summary.** T2L is a hypernetwork. It takes an embedding of a natural-language task description plus learned module and layer embeddings, and it outputs LoRA A/B matrices. All modules and layers are produced batched in one forward pass. It is trained either by reconstructing pre-trained LoRAs or by multi-task SFT on 479 Super-NaturalInstructions tasks, each with 128 descriptions. The base model is Mistral-7B-Instruct; Llama and Gemma results are in App. A. Zero-shot results on 10 unseen benchmarks (Table 2, 8-task average):

| Method | 8-task average |
|---|---|
| Task-specific LoRAs (oracle) | 75.8 |
| T2L (SFT) L | 73.9 |
| Multi-task LoRA | 71.9 |
| Arrow Routing | 70.7 |
| 3-shot ICL | 66.5 |
| Prepending the task description | 65.8 |
| Base model | 60.0 |

Reconstruction-trained T2L matches task-specific adapters on the 9 training benchmarks (Table 1). SFT training beats reconstruction training on zero-shot tasks (66.3 vs 61.83).

**Claim**
- **A hypernetwork turns a natural-language task description into a LoRA adapter in one forward pass: CONFIRMED.** "we introduce Text-to-LoRA (T2L), a model capable of adapting large language models (LLMs) on the fly solely based on a natural language description of the target task. T2L is a hypernetwork trained to construct LoRAs in a single inexpensive forward pass."
- **Caveat:** zero-shot T2L does not fully reach task-specific LoRAs. "even though T2L cannot fully bridge the performance gap with task-specific LoRAs, it outperforms the oracles on a subset of tasks".

---

## 3. Doc-to-LoRA

- **Title:** *Doc-to-LoRA: Learning to Instantly Internalize Contexts*.
- **Authors:** Rujikorn Charakorn (Sakana AI), Edoardo Cetin, Shinnosuke Uesaka (Minerva University; Sakana AI intern), Robert Tjarko Lange. All except Uesaka are at Sakana AI, Tokyo.
- **arXiv:** 2602.15902. v1 is dated 13 Feb 2026.
- **Venue:** none stated on arXiv. The HTML keyword says "ICML", but there is no acceptance note.

**Summary.** D2L is a hypernetwork that "meta-learns to perform approximate CD [context distillation] within a single forward pass". It maps a context's token activations from the target model to a LoRA. Long inputs are split into chunks, and each chunk contributes rank. The hypernetwork is trained on about 3.2M contexts (mostly FineWeb-Edu) against the target's top-16 logits on generated queries. The base model is gemma-2-2b-it (8K context).

**Needle-in-a-haystack (Fig. 2).**
- D2L reaches near-perfect zero-shot accuracy up to 40K tokens (40 chunks), with graceful decline after that. Training used sequences of at most 256 tokens.
- The base model with the context in its prompt is perfect up to 8K, then "drops sharply."
- Inference memory: the base model needs more than 12 GB extra for a 128K haystack. D2L needs less than 50 MB regardless of length.

**Reading comprehension (Fig. 3, SQuAD).**
- D2L reaches 82.5% of the in-context upper bound. This is about equal to LLMLingua-2 compressing the context to 40%.
- Update latency: D2L internalizes in under 1 s. CD (oracle) takes about 40 s. CD with generated queries takes more than 100 s.
- Update memory: D2L and CD-oracle both use under 2 GB. CD with generated queries uses more than 40 GB.

**Long documents (Table 1, 2WikiMultihopQA, up to 32K tokens).** Normalized performance, update memory and latency:

| Method | Normalized performance | Update memory | Latency |
|---|---|---|---|
| D2L (batched) | 0.857 | 11.5 GB | 0.21 s |
| D2L (iterative) | 0.844 | 3.8 GB | 0.55 s |
| CD, oracle query | 0.901 | 7.8 GB | 40.2 s |
| CD, 25 generated queries | 0.745 | 59.9 GB | 465 s |
| CD, 5 generated queries | 0.704 | 79.4 GB | 72.5 s |

At response time, the in-context baseline uses about 1 GB of VRAM; all in-parameter methods use under 100 MB.

**Query budget (Table 4, 100 SQuAD samples).**
- D2L scores 0.866 at 0.086 s.
- CD with 100 generated queries scores 0.650 and takes 631 s.
- CD (oracle) scores 0.988.

**Claims**
- **One forward pass turns a document into an adapter: CONFIRMED.** "Given an unseen prompt, D2L generates a LoRA adapter for a target LLM, enabling subsequent queries to be answered without re-consuming the original context". Also: "A single, inexpensive forward pass executes the learned CD process". Nuance: there is also an "iterative" mode that generates layer by layer to save memory; it is mathematically equivalent.
- **Compared with in-context use of the same document: CONFIRMED, and it is below ICL in-window.** In-context use is treated as the upper bound ("Base model with context serves as the upper-bound"). D2L reaches "82.5% relative performance compared to the ICL upper bound on the SQuAD benchmark". D2L only exceeds in-context use when the document is longer than the native window (NIAH beyond 8K).
- **Beats context distillation: CONFIRMED only under limited budgets.** "On real-world QA datasets with limited compute, D2L outperforms standard CD while significantly reducing peak memory consumption and update latency." D2L stays below oracle CD (0.857 vs 0.901; 0.866 vs 0.988). The authors concede: "increasing the budget to hundreds or thousands of queries would likely boost CD performance beyond that of D2L".

---

## 4. Lake & Baroni (MLC)

- **Title:** *Human-like systematic generalization through a meta-learning neural network*.
- **Authors:** Brenden M. Lake (NYU, Psychology and Center for Data Science) and Marco Baroni (Universitat Pompeu Fabra; ICREA).
- **Venue:** *Nature* 623, 115–121. Published 25 Oct 2023.

**Summary.** Meta-learning for compositionality (MLC) trains a standard seq2seq transformer over a stream of episodes. In each episode, a new randomly generated interpretation grammar maps pseudowords to coloured-circle outputs. The network must infer word meanings from the study examples in context and answer queries. Its weights are frozen at test time. The full model is also optimized to reproduce human error biases. The human study used 25 participants, 14 study instructions and 10 queries.

**Few-shot instruction-learning task.**

| Measure | Humans | MLC |
|---|---|---|
| Exact algebraic match | 80.7% | 100% (best run, greedy decoding) |
| Sampled outputs matching the algebraic standard | — | 82.4% |
| Longer-than-trained outputs | 72.5% | 77.8% |
| Errors that are one-to-one translations | 24.4% | 56.3% |

**Open-ended task.** MLC matches the modal human response in 65.0% of samples.

**Benchmarks.** SCAN systematic splits have error ≤0.22%. COGS lexical generalization has error 0.87% (Table 2).

**Claim**
- **Human-level systematic generalization on a pseudoword instruction-learning task: CONFIRMED.** "The participants were able to produce output sequences that exactly matched the algebraic standard in 80.7% of cases". Also: "the transformer produced systematic outputs at an average rate (82.4%) close to human performance (80.7%), and appropriately handled longer output sequences at a rate (77.8%) near human levels (72.5%)". The best run was "perfectly systematic (100% exact match accuracy)".

---

## 5. Continual Learning Bench (CL-Bench)

- **Title:** *Continual Learning Bench: Evaluating Frontier AI Systems in Real-World Stateful Environments*.
- **Authors:** Parth Asawa (UC Berkeley), Christopher M. Glaze, Gabriel Orlanski, Ramya Ramakrishnan, Benji Xu, Asim Biswal, Vincent Sunn Chen, Frederic Sala, Matei Zaharia, Joseph E. Gonzalez. Affiliations are UC Berkeley, Snorkel AI and UW-Madison.
- **arXiv:** 2606.05661. Dated 4 Jun 2026.
- **Venue:** none stated.
- **Site:** "CL-Bench 1.0" was released May 4, 2026. The leaderboard JSON is stamped `last_updated 2026-07-18`.
- **Repo:** created 2026-04-30; last push 2026-07-19.

**Summary.** There are six tasks with a shared learnable latent structure (Appendix A):

| Task | Instances |
|---|---|
| Blind Spectrum Monitoring | 90 |
| Codebase Adaptation (SWE issue-fixing in one repo) | 19 |
| Cohort Studies (outbreak epidemiology) | 20 |
| Database Exploration (obfuscated SQLite) | 40 |
| Exploitable Poker (heads-up Hold'em vs fixed exploitable bots) | 120 |
| Sales Prediction | 12 |

**Metrics.** Gain is g_t = r_t^stateful − r_t^stateless on the same instance. Normalized gain divides the mean gain by the system's own headroom (r_max − stateless). Normalized reward subtracts a fixed stateless GPT-5.4 ICL reference instead. Every result is averaged over 5 rollouts.

**Findings.** In Table 1, full-context ICL with Sonnet 4.6 ranks first (reward 22.3%, gain 25.4%). "naive ICL outperforms systems dedicated to memory management". Cohort Studies, Codebase and Poker show "minimal gain throughout" (Fig. 5).

**Claims**
- **Environments include coding and poker: CONFIRMED.** "six diverse domains (software engineering, signal processing, disease outbreak forecasting, database querying, strategic game-playing, and demand forecasting)". The task directories are `codebase_adaptation` and `exploitable_poker`. Poker: "heads-up Texas Hold'em hands against deterministic opponent variants. Each opponent has a fixed, exploitable policy".
- **Has a learning-gain metric: CONFIRMED.** "we introduce a gain metric in addition to total reward, which measures the difference between a system's reward conditioned on online experience and what its reward would have been if stateless."
- **Every method on the leaderboard is in-context or harness memory, with no weight updates: CONFIRMED.** "Our initial evaluation focuses on context-based memory paradigms (in-context retention or compaction, retrieval-augmented memory, and structured notepads); we do not evaluate parametric approaches such as test-time training, though we seek to add them via community contributions". `src/systems/` contains: ace, claude, codex, human, icl, icl_notepad, mem0.

**Live leaderboard** (continual-learning-bench.com/leaderboard_data.json, last_updated 2026-07-18). Values are aggregate normalized reward / normalized gain / mean run cost:

| Rank | System · model | Reward | Gain | Cost |
|---|---|---|---|---|
| 1 | ICL · Claude Sonnet 4.6 | 19.6% | 24.1% | $30.4 |
| 2 | ICL · GPT-5.4 | 18.9% | 18.9% | $18.4 |
| 3 | Claude Code · Sonnet 4.6 | 18.5% | 24.1% | $38.6 |
| 4 | ICL · Claude Opus 4.7 | 18.3% | 19.5% | $49.6 |
| 5 | Mem0 · GPT-5.4 | 14.8% | 22.4% | $18.3 |
| 6 | ICL Notepad · Sonnet 4.6 | 13.2% | 18.2% | $31.5 |
| 7 | ICL Notepad · GPT-5.4 | 10.4% | 15.6% | $14.3 |
| 8 | ICL · Gemini 3 Flash | 9.2% | 15.5% | $7.6 |
| 9 | ACE · GPT-5.4 | 6.6% | 7.7% | $62.8 |
| 10 | Codex · GPT-5.4 | 5.7% | 12.0% | $27.2 |
| 11 | ICL Notepad · Gemini 3.1 Pro Preview | 0.3% | 8.1% | $13.3 |
| 12 | ICL · Gemini 3.1 Pro Preview | −7.6% | 3.6% | $15.2 |

The site's numbers differ slightly from paper Table 1. For example, the paper gives ICL·Sonnet 22.3 / 25.4 and Mem0 15.1 / 20.2, and its ordering differs. **Cite one source consistently.**

---

## 6. FutureSim

- **Title:** *FutureSim: Replaying World Events to Evaluate Adaptive Agents*.
- **Authors:** Shashwat Goel (ELLIS Institute Tübingen / MPI for Intelligent Systems), Nikhil Chandak, Arvindh Arun, Ameya Prabhu, Steffen Staab, Moritz Hardt, Maksym Andriushchenko, Jonas Geiping.
- **arXiv:** 2605.15188. Dated 14 May 2026.
- **Venue:** ICML 2026 (oral), per the icml.cc virtual listing in search results. This is not stated on the arXiv page.

**Setup.** There are 330 short-answer questions from Al Jazeera, resolving 1 Jan – 28 Mar 2026. Agents search a date-gated offline CCNews snapshot (7.36M articles, Jan 2023 – Mar 2026). The simulation advances day by day. Agents call `submit_forecast` and `next_day` and can revise forecasts. Each agent runs in its native harness, plus the authors' improved harness.

**Results.**
- Best top-1 accuracy is 25% (GPT 5.5). Many agents have a negative Brier skill score, i.e. they do worse than not predicting (Fig. 1, Fig. 3).
- GPT 5.5 forecasting each question directly with full information gets 31.2%. Updating sequentially inside the simulation gets 24.8% (Fig. 6).
- Memory ablation: models benefit from test-time memory (Fig. 5, right).

**Claim**
- **A weak initial forecast caps later improvement: CONFIRMED in substance, with a nuance.** It is shown as anchoring in one controlled experiment, not stated as a "cap". In Fig. 5 (left), all agents start from the worst agent's (Qwen3.6 Plus) initial forecasts. "At the end of the simulation, all agents fail to reach even the baseline Brier skill score (0) of not predicting at all, let alone their original positive Brier skill score performance. This is despite being informed that their predictions are obtaining a negative Brier skill score as they resolve, showing how frontier agents fail to adapt away from bad initial anchors." The caption says: "agents get anchored to the initial predictions ... even when their own capabilities are stronger." GPT 5.5, Opus 4.6 and DeepSeek V4 Pro still improve somewhat.

---

## 7. Learning, Fast and Slow

- **Title:** *Learning, Fast and Slow: Towards LLMs That Adapt Continually*.
- **Authors:** Rishabh Tiwari (UC Berkeley; Eragon), Kusha Sareen (Mila), Lakshya A Agrawal (Berkeley), Joseph E. Gonzalez, Matei Zaharia, Kurt Keutzer, Inderjit S Dhillon (UT Austin), Rishabh Agarwal (Mila; Periodic Labs), Devvrit Khatri (UT Austin; Mirendil).
- **arXiv:** 2605.12484. v1 is dated 12 May 2026; v3 is dated 14 Oct 2026.
- **Venue:** none listed. There is a GEPA blog post.

**Method: Fast-Slow Training (FST).** Slow weights are the model parameters θ, trained by RL (CISPO). Fast weights are a population Φ of K prompts, evolved by GEPA (reflective prompt evolution with a frozen reflection LM and a Pareto frontier).
- Training runs in cycles of T RL steps. At each cycle start, GEPA runs with the current policy on a lookahead batch and returns the top-K prompts.
- RL then updates θ on rollout groups that mix all K prompts (G/K rollouts each), so advantages include prompt-induced variation.
- The objective is max over θ and Φ of the expected reward, with the prompt drawn uniformly from Φ.

**Results.**
- FST is up to 3× more sample-efficient than RL alone (3.0× on CodeIO, Fig. 2) and reaches a higher fitted asymptote on CodeIO, Math (Polaris) and HoVer-hard (Fig. 3).
- At matched reward, KL to the base model is up to 70% lower (Fig. 4).
- Plasticity is better preserved (Fig. 5). For example, Physics→HoVer: FST-init 24.2% vs RL-init 19.9%.
- Continual stream HoVer→CodeIO→Physics, task switch every 200 steps (Fig. 6). On CodeIO, RL gains +2.6 pp (to 21.1%). FST gains +21.3 pp (to 39.8%).
- On HoVer, both channels together give 21.2% pass@1, vs 11.6% for trained weights alone and 10.6% for evolved prompts alone (Fig. 8).
- Explicit fast-to-slow distillation plateaus below FST (Fig. 17).

**Claim**
- **Prompt optimization gets reward off zero so that weight updates have a signal: CONFIRMED, but it is one supporting observation, not the paper's main thesis.** The source is Observation 1, on a synthetic star-graph task chosen for near-zero base reward (Fig. 7): "Parameter-only RL remains near zero for roughly 250 steps, whereas FST reaches measurable reward around step 50 ... driven primarily by the first few GEPA cycles. ... Although these early prompts solve only a few problems, they provide an initial reward signal that enables subsequent RL updates to improve rapidly." Fig. 7 caption: "Gradient norm ... shows earlier sustained gradient signal for FST's slow-weight updates".
- **The main framing is a division of labour.** Fast weights "absorb the task-specific information, while allowing slow weights to stay closer to the base model and persist general reasoning behaviors".

---

## 8. Learning to Discover at Test Time (TTT-Discover)

- **Title:** *Learning to Discover at Test Time*.
- **Authors:** Mert Yuksekgonul (Stanford), Daniel Koceja, Xinhao Li, Federico Bianchi, Jed McCaleb, Xiaolong Wang, Jan Kautz, Yejin Choi, James Zou, Carlos Guestrin, Yu Sun. Affiliations are Stanford, UCSD, Together AI, Astera Institute and NVIDIA.
- **arXiv:** 2601.16175. v1 is dated 22 Jan 2026; v2 is dated 5 Feb 2026.
- **Venue:** none listed.

**Method.** RL on a single test problem with gpt-oss-120b. Training uses LoRA rank 32 on Tinker for 50 steps, with 512 rollouts per step (8 groups × 64). Two pieces favour the best attempt:
- The **entropic objective** J_β tends to the max as β→∞. Advantages are w_β − 1 with a KL penalty.
- **PUCT** chooses which states to reuse, with Q(s) set to the **max** child reward rather than the mean.

Cost is "a few hundred dollars per problem."

**Results (headline table, Sec. 4).**

| Problem | TTT-Discover | Previous best |
|---|---|---|
| Erdős minimum overlap (upper bound) | 0.380876 | AlphaEvolve 0.380924; best human 0.380927 |
| Autocorrelation C1 (upper bound) | ≤ 1.50286 | — |
| GPUMode TriMul kernel, H100 | 1161 µs | top human 1371 µs |
| GPUMode TriMul kernel, A100 | 2198 µs | top human 4531 µs ("50% faster" than top human) |
| AtCoder Heuristic Contest 39 | 567,062 | 566,997 (top human) / 558,026 (prev. best AI) |
| Single-cell denoising | 0.71 | 0.64 |

The abstract describes the GPU result as "up to 2× faster than prior art."

**Claims**
- **Trains weights at test time on a single problem: CONFIRMED.** "We perform reinforcement learning at test time, so the LLM can continue to train, but now with experience specific to the test problem." Also: "our policy only needs to solve this single problem rather than generalize to other problems."
- **Optimizes for the best attempt rather than the average: CONFIRMED.** "its goal is to produce one great solution rather than many good ones on average". Also: "Naive RL optimizes average performance ... In discovery, however, success is determined by the maximum". And: "Rather than the mean (as in prior work), we use the maximum reward of children in Q(s)".
- **Needs a verifier: CONFIRMED.** The requirement is specifically a **continuous** verifiable reward. "TTT-Discover trains on a single test problem with a continuous verifiable reward". Limitation: "The current form of our method can only be applied to problems with continuous rewards, and the most important direction for future work is test-time training for problems with sparse or binary rewards, or problems in non-verifiable domains."

---

## 9. Ilija Lichkovski, "Defining Continual Learning"

- **Source:** an X Article by @carnot_cyclist (Ilija Lichkovski, Prime Intellect), posted 7 Apr 2026. The full text was fetched via the api.fxtwitter.com mirror; x.com returns 402. There is no mirror on ilijalichkovski.github.io, whose blog has only two 2025 posts. The article is titled "Part 1". Part 2, on benchmarking, is promised.
- **TLDR quote:** "we are interested in an LLM being able to efficiently and compositionally learn new capabilities during sequential exposure to new, differently-distributed data, while at least preserving general capabilities."

**Verdict: he does NOT claim that parametric updating is necessary for composition or integration.** Composition is one of five desiderata for continual learning in general, and the definition is explicitly left mechanism-neutral. His case for in-weights learning is hedged ("might be") and rests on two grounds, **Scaling** and **Automaticity**. In the Automaticity paragraph, automatic recombination is called a "prerequisite for flexible compositionality". That is the closest he comes to a necessity claim, but he concedes that in-context compositionality exists and argues only that it degrades with retrieval at scale. He leaves open whether harness/scaffold training could deliver continual learning without weight updates.

Key passages:
- Desideratum 5, mechanism-neutral: "Continually learning models should be able to compose skills encountered at different stages of sequential training."
- On added parameters: "In principle, there could be reasonable ways to minimally expand model capacity over time to accommodate new connections, so I have not limited our CL problem definition to only a fixed set of weights." He also discusses LoRAs and KV caches (Cartridges) as "possible and appealing".
- Hedged case: "I see two primary reasons that in-weights learning might be a desirable primary driver of true effective continual learning."
- **Scaling:** "the fixed nature of the underlying LLM places a hard ceiling ... when your set of skill files or memory markdowns grows to hundreds or thousands, you begin suffering from context rot and/or retrieval difficulties ... parametric knowledge fundamentally changes the amount of intelligence per forward pass, which holds significantly greater compounding potential."
- **Automaticity:** "Neural memory is advantageous in allowing hyper-efficient automatic recombination of knowledge, which is a prerequisite for flexible compositionality. Of course, an LLM can exhibit compositionality over in-context information, but as the knowledge bank grows, compositional ability reduces to the lowest common denominator of how good the retriever is. Creativity requires intuitive recombination of knowledge from different domains, often in ways not obvious enough to be amenable to intentional retrieval. ... The goal of internalizing new data into the weights is to promote this kind of automaticity, so that new connections are made intentionally [sic] without relying on the bottleneck of retrieval and context rot."
- Open question, scaffold training: "it remains to be seen if CL with the aforementioned desirable properties can be achieved this way, without dealing with the difficulties of modifying a model's weights."
- On integration, he uses the word only in "Overwriting knowledge": "How is this data integrated, and how adaptable do we want the model to be? ... Navigating this complexity is not unique to parametric methods".

---

## 10. Dagstuhl position paper

- **Title:** *Position: Modular Memory is the Key to Continual Learning Agents*.
- **Authors:** Vaggelis Dorovatas (Toyota Motor Europe) as first author, Malte Schwerin (Univ. Bremen) second, then 22 others including Caccia, Carta, Hammer, Kanan, Lomonaco, Prabhu, Tuytelaars, van de Ven, Choi, Mundt, and Rahaf Aljundi as lead last author.
- **arXiv:** 2603.01761. v1 is dated 2 Mar 2026; v2 is dated 16 Jun 2026.
- **Venue:** "ICML 2026 Position Track Spotlight. This work stems from discussions held at the Dagstuhl seminar on Continual Learning in the Era of Foundation Models (October 2025)". This is Dagstuhl Seminar 25432.

**Proposal.** A frozen-by-default **core model**, plus a **working memory** for active context, plus a **long-term memory** for experiences, facts and observations. The system runs in two regimes:
- In the **external** regime, it answers the environment. It retrieves from long-term memory into working memory, i.e. learning by ICL. It decides what of each interaction to write into long-term memory.
- In the **internal (self-driven) consolidation** regime, it runs "sparsely after accumulating sufficient experience". In that regime, "the model reprocesses and replays stored long-term memories to distill useful information into the core model". Long-term memory itself is also compressed, gracefully forgotten and reorganized.

The analogy is complementary learning systems: hippocampal replay into the neocortex. Sec. 4.3 names three ingredients for robust consolidation: (i) compressed memory encodings rather than raw trajectories; (ii) parameter stability, specialization and modularity, so that updates stay local (MoE, adapters); (iii) objectives that favour generalization. On (iii) it cites evidence that on-policy distillation and on-policy RL forget less than SFT. It suggests offline, sleep-like replay periods to trigger consolidation.

**The pathway, quoted:** "experience first enters working memory for immediate adaptation, accumulates in long-term memory for selective retrieval and refinement, and is gradually consolidated into the model parameters." Also: "since parametric consolidation into the core model occurs fairly infrequently ... the risks associated with continual IWL, e.g., forgetting, optimization instability and loss of plasticity, are naturally reduced."

---

## 11. Negation Neglect

- **Title:** *Negation Neglect: When models fail to learn negations in training*.
- **Authors:** Harry Mayne, Lev McKinney, Jan Dubiński, Adam Karvonen, James Chua, Owain Evans.
- **arXiv:** 2605.13829. Dated 13 May 2026.

**Claim: CONFIRMED**, for both claims and behaviours.
- On Qwen3.5-397B-A17B, finetuning on documents flagged as false raises average belief from 2.5% to 88.6%. Unflagged documents give 92.4%. The same documents given in context give only 15.3% belief.
- Behaviours: "Training on chat transcripts flagged as malicious can cause models to adopt those very behaviors". On Qwen3-30B-A3B, the misalignment rate on targeted behaviours was 19.9% with negation-flagged data vs 34.4% with unflagged data.
- Local negation ("Ed Sheeran did not win") is largely learned correctly, giving 0% and 7% belief.
