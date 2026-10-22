# Outline: an essay on self-distillation and the routes to continual learning

Status: outline for review, 15 Oct 2026. Revised 21 Oct 2026 (below). The sample sentences show register only.

## Revision, 21 Oct 2026: technical links to the RL essays

At the author's request, all three parts now tie into *How Can a Reward Train a Neural Network?* and *How Does a Policy Improve?*:
- Part 1: the self-teacher is exactly the KL-regularized tilt at $\eta=1$, with the implicit value $Q_c=\log\pi(y|x,c)/\pi(y|x)$ (the DPO identity run backwards). Worked example B reuses the robot's $p=(0.6,0.3,0.1)$: the teacher spends 1.10 nats, against the robot critic's 1.06. iSDFT's λ is the Lagrange multiplier from the dual $g(\eta)$. The fitting direction is MPO's mass-covering M-step. The sequence tilt preserves within-class ratios, which is the mechanism behind *Denser ≠ Better*. Collapse is the falling effective temperature $\eta/k$ under refreshed references, floored at β by a fixed KL penalty. The GRPO advantage formula has been added.
- Part 2: worked example D is the robot's door question off-policy (IS 43.2 with probability 1/8, standard deviation 14.3, against a ratio-free λ=0 bootstrap). The collapsed π₁ is a behaviour policy with no coverage. Worked example F gives VPO's per-answer cell weightings $\bar w_i=P(C_i)E[w|C_i]$, which sum to E[w]. GAE has a vector form, with per-answer advantage $\bar w_i^\top\hat A_t$.
- Part 3: the delta rule is TD(0) at γ=0. A table reads each consolidation method as an E-step in a fast store plus an M-step in a slow one. Lichkovski's hypernetwork is an amortized M-step toward the multitask "trivial solution".

## Revision, 21 Oct 2026: VPO and GQ(λ)

The author added two sources: Vector Policy Optimization (arXiv 2605.22817 and the Yacine podcast with Ryan Bahlous-Boldi) and Maei and Sutton's GQ(λ) (2010). The analysis is in `vpo-and-gq-lambda.md`. Default decisions taken to start drafting (open questions 1, 2 and 5 below), all revisable:

- **Split into parts.** The essay now has three threads (consolidation, alternatives, off-policy knowledge), which is too much for one post.
  - **Part 1, *Who Teaches the Weights?***, drafted in `notes/who-teaches-the-weights.md`. It covers §§0–4 as planned, plus a new §5, "What on-policy training forgets", on VPO. On-policy RL retains other tasks (*Retaining by Doing*) but forgets alternatives within the task (pass@$k$ below base). VPO keeps them with in-context exploration, so in-context learning appears a second time, as the explorer. Part 1 ends on diversity as the coverage condition for learning about what one does not do.
  - **Part 2, *Learning About What You Do Not Do***, drafted 21 Oct in `notes/learning-about-what-you-do-not-do.md`. It opens with GQ(λ) and Horde: continual learning as many predictions (general value functions) learned off-policy from one stream. It then gives the mapping VPO ≈ the set-max policy of successor features and GPI, at the horizon of one response, and the vector-critic proposal. Ryan's "it actually is a continual learning paper" and his unsupervised-RL remark go here.
  - **Part 3, *Where Experience Goes***, drafted 21 Oct in `notes/where-experience-goes.md`: the old §§5–9 (learned update rules, the ladder of stores, benchmarks, corrections to *The Dynamics That Matter*, closing). The ladder gains a predictive store, a GVF bank written by TD.
- **Register.** Part 1 keeps mathematics to the general loss, the tilt (worked example B), the EMA arithmetic (A) and a small VPO example. Part 2 needs the GQ(λ) and GPI equations, in the style of *How Does a Policy Improve?*.
- **Corrections** stay in Part 3 as planned (§8), since their evidence (ladder, Doc-to-LoRA, Lampinen) lands there.
- **Lichkovski's unpublished runs** appear in Part 1 §4 in two sentences, labelled as preliminary results he presented in the podcast. Still to ask him (open question 3).

Working titles (pick one, or supply another):

- *Who Teaches the Weights? Self-Distillation and the Routes to Continual Learning*
- *The Model as Its Own Teacher: What Self-Distillation Brings to Continual Learning*
- *Consolidation: How In-Context Learning Could Teach the Weights*

Sources this outline draws on:

- `notes/research/self-distillation-deep_research_GPT6_Pro.md` (the report; its citations did not export).
- `notes/private/continual-learning-podcast-lichkovski-transcript.md`. It is private, so the essay paraphrases it, and any quotation needs checking against the audio.
- `notes/research/continual-learning-podcast-lichkovski.md` (chapters and the 18-item reading list).
- `notes/research/frontier-model-architectures.md` and `notes/research/architecture-interpretability-and-audit.md`.
- Earlier essays, linked below by file name.

---

## 1. Thesis

Continual learning is usually framed as protecting old weights from new data. The self-distillation work of 2026 points to a different framing: the hard part is choosing what teaches the weights. A language model given a demonstration, a document or an error message in its context already behaves better than the same model without it, so in-context learning has done the learning. Self-distillation trains the bare model toward that better-informed copy of itself, on the states the bare model actually visits. It is therefore a consolidation step: it moves what in-context learning achieved into the weights. This reading explains when it works and when it fails. It retains old skills because its targets stay close to the model's own distribution. It fails when the in-context learner is a poor teacher, when a dense token-level target constrains the wrong things, and when nothing in the training stream revisits what the model used to know. Consolidation supplies stability, not memory. A continually learning system therefore needs several stores that run at different timescales: context, fast weights, harness notes, adapters and core weights. The design question is the traffic between them, meaning what writes each store, what persists in it, and which faster store teaches which slower one. On this view the open-weight labs already practise continual learning at the cadence of releases, when they distil specialist policies into one checkpoint on-policy. Two things are missing: doing it at the cadence of deployment, and benchmarks that could tell whether it works.

What makes this more than a survey:

1. It names one mechanism, in-context learning acting as the teacher, behind the methods the report groups as context-conditioned self-distillation (SDFT, OPSD, SDPO, iSDFT). It derives their strengths and their failures from that mechanism.
2. It replaces the parametric-versus-harness dichotomy with a ladder of stores. The interesting questions sit on the rungs between them.
3. It retracts two claims from *The Dynamics That Matter*, and the evidence for the retraction comes from the same literature.

---

## 2. Sections

Budget: about 7,000 words of main text (see open question 1 on splitting). Each entry gives a purpose line, the beats, the sources and a rough word count.

| § | Working title | Words |
| --- | --- | ---: |
| 0 | Opening | 350 |
| 1 | What would count as continual learning | 600 |
| 2 | Where the model trains and what it imitates | 900 |
| 3 | The model with privileged context as teacher | 1,100 |
| 4 | Where self-teaching breaks | 900 |
| 5 | Learning the update rule | 800 |
| 6 | A ladder of stores | 1,000 |
| 7 | What the benchmarks can and cannot see | 550 |
| 8 | Revisiting *The Dynamics That Matter* | 550 |
| 9 | Closing | 250 |
| | **Total** | **7,000** |

### §0 Opening (350)

**Purpose:** show the phenomenon before naming it. The same model and the same new skill produce opposite forgetting depending on where the training data came from.

- Lead with *Retaining by Doing*. Qwen-2.5-7B trained on Countdown by SFT loses 29.2 points on non-target tasks; trained by GRPO it loses −0.3. The figures for IFEval are 5.6 vs 0.2, and for MMLU 14.6 vs 0.2. Removing GRPO's KL term mostly did not restore SFT-like forgetting. Approximately on-policy SFT that regenerates its data once per epoch mostly removed the forgetting.
- Pose the question the essay answers: if the source of the data matters this much, what should the model learn from, and on which states?
- State the thesis in two sentences.

Sample opening sentence: "Teach a language model a numbers game by showing it worked solutions, and it gets worse at nearly everything else; teach it the same game by letting it play and rewarding wins, and it loses almost nothing."
(This is a true parallel pair, so the semicolon is the right joint. Check first that the report's numbers match the paper.)

Sources: report, evidence table (*Retaining by Doing*).

### §1 What would count as continual learning (600)

**Purpose:** fix the terms the rest of the essay measures with, without recapping Lichkovski's desiderata. *The Dynamics That Matter* §1 already lists them, so link there.

- Three scenarios (van de Ven et al., *Three types of incremental learning*): task-, domain- and class-incremental. Class-incremental learning asks the model to tell apart classes it never saw together. Lichkovski's split-MNIST numbers make this concrete: EWC barely beats naive fine-tuning at about 20%, because careful navigation of the loss landscape does not compose representations.
- Measurement: the matrix $R_{i,j}$ of performance on task $j$ after training through task $i$. Accuracy, forgetting and backward transfer are all read off it. LLM studies mostly report "average non-target drop", which cannot separate a temporary regression from a permanent loss.
- The trivial solution that the efficiency desideratum rules out: retrain on everything seen so far, which turns sequential learning back into multitask learning.
- Lichkovski's reframing, "replay becomes play": a deployed agent revisits its general skills just by working. Present this as the bridge to §2. On-policy data does part of the job that replay was invented for.
- His aside on cortical cultures: the Cortical Labs Pong paper reports that the cells forget too. On his reading, retention in brains comes from replay that something else orchestrates (the hippocampus), not from the cells themselves. One sentence at most, attributed to him.

Sources: transcript 0:17–0:32, 0:49–0:52; *Three types of incremental learning*; report §"unified mathematical view"; *The Dynamics That Matter* §1 (link only).

### §2 Where the model trains and what it imitates (900)

**Purpose:** give the reader the one decomposition that organizes the rest. A stability term has a **teacher** (what distribution to match) and a **support** (on which inputs to match it).

- The general loss: plasticity term plus $\lambda\,\mathbb E_{x\sim\mu}D(q\,\|\,p_\theta)$. EWC constrains parameters; distillation constrains behaviour on chosen inputs. One sentence on the Fisher link between the two.
- Place the classic methods on the grid:
  - LwF: old teacher, new-task support. It protects old behaviour only where the old and new inputs overlap.
  - DER: old teacher, old support, and it stores old logits. On S-CIFAR-10 with 200 buffered examples, ER scores 44.8, DER 61.9 and DER++ 64.9. The model's past soft outputs carry information that its past labels do not.
  - EMA teacher: fresh teacher, current support. Worked example A shows why it is a stabilizer, not a memory.
  - On-policy distillation: the support is whatever the student generates.
- *Retaining by Doing* returns as evidence that support matters on its own. On-policy sampling and the self-distillation objective are different choices: the first decides where the model trains, the second what it is pulled toward. Conflating them made early claims too optimistic.
- Link the reward essay's first section ("Actions change the examples we learn from") instead of re-explaining on-policy data.

Sources: report §§"Technical foundations", "unified mathematical view", "mapping onto paradigms"; *How Can a Reward Train a Neural Network?* (link).

### §3 The model with privileged context as teacher (1,100)

**Purpose:** the core argument. Context-conditioned self-distillation is policy improvement, with the improvement step done by in-context learning and the fitting step done by distillation.

- The construction (SDFT 2026, OPSD, SDPO): the student samples a response. The same model, conditioned on a demonstration or on environment feedback, scores the same prefixes. The student is trained toward those token distributions. The teacher is usually an EMA copy.
- Connect to *How Does a Policy Improve?* without recapping it. That essay separates constructing an improved distribution (an exponential tilt of the current policy, or MPO's E-step) from fitting a parametric policy to it. Here the improved distribution is the model's own conditional $\pi(\cdot\mid x,c)$, so no critic or search is needed. The token log-ratio $\log\pi(y_t\mid x,c,y_{<t})-\log\pi(y_t\mid x,y_{<t})$ acts as a dense implicit reward. Worked example B shows this with three answers.
- iSDFT makes the step size explicit. It takes a geometric interpolation $P^{1-\lambda}T^{\lambda}$ under an information budget and adds a KL anchor to the frozen base. The earlier essay's trust region reappears, together with a permanent reference point. iSDFT reports 73% of retention evaluations within 0.5 points of base, against 52% for the strongest baseline.
- Why the teacher is the strength: in-context learning generalizes where fine-tuning does not. Lampinen et al.'s controlled study shows that in context, a model handles reversals, syllogisms and rephrasings of a new fact. Trained on the same fact, it mostly does not, unless the training set is augmented with inferences the model draws in context. Self-distillation automates that augmentation, because the teacher's distribution already contains the implications.
- Usable information (Xu et al., 2020) gives the frame in one paragraph. Processing cannot add Shannon information, but it can make information usable by a bounded learner. Self-distillation and synthetic data do this: they expose what was latent, and they do not create information from nothing. This is Lichkovski's closing point, attributed to him and paraphrased.
- Link *The Given and the Found* §5: the confidence of a manufactured target sets the size of the update, and grounding sets its sign. Here the grounding is the privileged context. Where the context carries a demonstration or a test result, the self-teacher is grounded. Without one it is the ungrounded self-distillation that essay warned about. §4 shows that failure.
- Cost: SDFT reports about 2.5× the FLOPs and 4× the wall-clock time of SFT. Regenerating data once per epoch (*Retaining by Doing*) is the cheaper middle ground.

Sample sentence: "The teacher in self-distillation fine-tuning is the policy-improvement step, computed by reading instead of by search."

Sources: report §§"unified mathematical view" (SDFT, inverse-RL reading, iSDFT), evidence table (SDFT, SDPO, iSDFT); Lampinen et al. 2505.00661; Xu et al. 2002.10689; transcript 0:32–0:36, 1:13–1:17, 1:32–1:35; *How Does a Policy Improve?* Part 2 (link); *The Given and the Found* §5 (link).

### §4 Where self-teaching breaks (900)

**Purpose:** derive the failures from the mechanism in §3, so they read as predictions rather than a list of caveats.

- **A weak in-context learner is a weak teacher.** SDFT works less well at 3B than at 7B or 14B. SynthSelf (0.5B–3B) uses a slightly larger same-family model to write distribution-matched targets. Across settings it reports acquisition of 56.4 against 44.1 for SDFT, at equal retention (41.7 vs 41.5). The lesson that transfers is "stay close to the learner's own distribution", which is weaker than "teach yourself".
- **A dense target constrains the wrong things.** *Denser ≠ Better* finds that token-level SDPO forgets more than sequence-level GRPO under sequential post-training, amplifies formatting artifacts and sometimes collapses. Sequence-level reward accepts many valid paths; token-level matching forces one. This is compatible with *Retaining by Doing*: the support can protect while the objective undoes the protection.
- **A moving teacher has no fixed reference.** Small steps can add up to a large distance from the base. Worked example A puts numbers on this. iSDFT's base anchor is the repair.
- **On-policy support is not old-task support.** Tool-use rollouts say nothing about medical questions. Only replay, generated old inputs, an anchor evaluated on suitable prompts, or isolated capacity covers them.
- **What the context says is not what the weights learn.** Negation Neglect: models fine-tuned on material that describes what not to do still learn the behaviour. Lichkovski raises this for agents that read documentation about bad customer interactions. A self-teacher conditioned on a negative example might share the same failure. That is an open question, not a result.
- **Plasticity loss.** A model can score low on forgetting by becoming hard to change, so results should be reported as an acquisition-versus-retention frontier.
- Lichkovski's own runs as illustrations, labelled as preliminary and unpublished. Sequential SDFT on three skill files (Stripe, then Twitter, then Notion) replicated the paper's retention advantage over SFT and off-policy KD. An OPSD-vs-GRPO run on Qwen3-8B switched environments every 100 steps for 700 steps; some transitions (hotel booking to restaurant operations) caused sharp drops. He called it poorly tuned.

Sources: report §§"Why it can fail", "Open problems", evidence table (SDFT, SynthSelf, *Denser ≠ Better*); Negation Neglect 2605.13829; transcript 1:09–1:10, 1:17–1:21.

### §5 Learning the update rule (800)

**Purpose:** the second route, where a network learns how to update instead of the update being a gradient step on a fixed loss. Show what it promises and what it can learn by mistake.

- Meta-learned continual learning (Irie, Csordás and Schmidhuber, *Metalearning Continual Learning Algorithms*). It uses a self-referential weight matrix with a delta-rule update, so the learning rule depends on the input. Note for §6: this is the same family of update as the delta-rule layers in the frontier hybrids.
- Hypernetworks. Text-to-LoRA turns a task description into an adapter. Doc-to-LoRA turns a document into an adapter in one forward pass. Lichkovski's point: the second is a learned learning algorithm, a sample-efficient map from input to weight change, even though nothing in its setup is shaped like continual learning.
- Lichkovski's split-MNIST hypernetwork (unpublished, from the podcast). It is trained to map the current weights plus a new task to the multitask-trained weights. Average accuracy rises with each task, backward transfer is positive, and deployment cost per task is one forward pass. The negative result: ablations show it ignores the task identity. It learned a task-independent operator that nudges any weights toward the multitask manifold. The weights carry far more information than the task embedding, so the operator attended to the weights.
- The lesson, linked to *The Given and the Found* §5: an amortized learner learns whatever the distribution of its training updates rewards. Here that was a generic consolidation move. The result is interesting in itself: a learned "move toward multitask" operator is a learned stability mechanism.
- One paragraph on composition with a meta-learning prior: Lake and Baroni's MLC reaches human-level systematic generalization on the pseudoword task (dax, wif, fep). Lichkovski's benchmark (§7) is a sequential version of the same task.

Sources: Irie et al. 2312.00276; Text-to-LoRA 2506.06105; Doc-to-LoRA 2602.15902; MLC (Nature 2023); transcript 0:38–1:02.

### §6 A ladder of stores (1,000)

**Purpose:** answer where fast weights and in-context learning sit relative to parametric continual learning (content brief item 3; detail in Part 3 of this outline). Replace "parametric versus harness" with a ladder of stores and the traffic between them.

- The ladder, fastest to slowest (figure 1):
  1. attention over the KV cache (in-context learning);
  2. delta-rule recurrent state (fast weights);
  3. harness notes, skill files and optimized prompts;
  4. adapters (LoRA), written by gradient or by a hypernetwork;
  5. core weights (SFT, RL, self-distillation);
  6. the release cycle (multi-teacher on-policy distillation of specialists).
- Four questions for each rung: what writes it; what persists, and for how long; its capacity and interference; and the cost of reading it.
- Fast weights get one paragraph, linked to *Solving the Loop* §2 and to the architecture essay. Do not re-derive. A delta-rule layer applies one gradient step per token on a regression loss, so Qwen and Kimi's hybrids already run an online continual learner inside every forward pass. It is error-correcting, which means it can revise a fact: worked example C shows a redefinition overwritten in place. It is bounded, and its gates set the rate of forgetting (KDA's per-channel decay). Its contents vanish when the session ends unless the serving protocol keeps the state.
- The audit adds a caution. In Qwen3.5 hybrids, associative recall runs through the KV cache: recurrent interventions recover only 0.2–3.6% of the donor effect. Having a fast-weight store does not show that the model uses it for memory.
- Consolidation is traffic from one rung to the rung below:
  - context to weights: self-distillation (§3);
  - context to adapter: Doc-to-LoRA (§5);
  - experience to prompt to weights: *Learning, Fast and Slow*, where prompt optimization gets reward off zero so that weight updates have signal (the discovery-shaped problem in the transcript, 1:28);
  - specialists to checkpoint: frontier on-policy distillation.
- Frontier distillation as existing practice. DeepSeek V4 builds specialists by fine-tuning and GRPO, then consolidates them by OPD. GLM-5.2 uses OPD to consolidate specialists, and GLM-5.3 attributes its gains to more post-training on the same base. Kimi K3 trains nine policies (three domains by three reasoning efforts), then runs multi-teacher OPD. MiMo's MOPD2 uses three streams: autonomous student rollouts scored by teachers, student turns continuing teacher histories, and student continuations of SFT demonstrations. This is the report's hybrid of modular capacity plus distillation, done at scale. Say what it does not test: the specialists are built in parallel from one base, so tasks never arrive in sequence.
- Where the parametric argument survives: automaticity. Lichkovski's version is that retrieval gets harder as the store grows, while parametric competence should get more automatic. This is a claim about cost and scaling, not about whether composition is possible (see Part 4).
- The overwriting paragraph of *The Dynamics That Matter* §7 holds in a narrower form: different content should update at different rates. Multi-timescale teachers (EMA, episodic buffer, base anchor) and per-channel gates are concrete versions.

Sources: frontier-model-architectures.md §§"Training stages", the GLM, DeepSeek V4-Pro, Kimi and MiMo sections, and the first part of "Revisiting"; architecture-interpretability-and-audit.md §1.5 and Part 2 item 7; *Solving the Loop* §2 (link); *Learning, Fast and Slow* 2605.12484; report §"Open problems" (multi-timescale loss); transcript 0:23–0:25, 1:28–1:30.

### §7 What the benchmarks can and cannot see (550)

**Purpose:** say what evidence would separate the routes, and why the current benchmarks favour in-context methods.

- Continual Learning Bench (coding and poker environments, a learning-gain metric): every method on its leaderboard is in-context learning or harness memory. FutureSim (forecasting over a news corpus released in time order) is a continual-learning benchmark in all but name. A weak initial forecast caps later improvement.
- Lichkovski's requirement: a benchmark has to be method-agnostic. In-context and in-weight methods need the same inputs, so he proposes on-policy traces as the common substrate. In-context methods keep the traces in context; distillation and RL train on them.
- His knowledge-unit dependency graph. Primitives and functions arrive at different times, with probes that require composing them, including redefinitions ("zup" redefined at step 4) and backward order (a function learned before its arguments). Ablations vary temporal distance and recency. Pair this with worked example C.
- Connect to *What Breadth Reaches* §2 in a short paragraph. Lambert's substitution argument currently wins on the benchmarks we have, and the reason is that they are short. The in-context runs Lichkovski calibrated would pass a dozen million tokens of context by step 700. That is the regime where the cost argument from §6 should start to bite. It is a prediction, not a result.

Sources: CL Bench 2606.05661 and site; transcript 1:02–1:13, 1:17–1:21; *What Breadth Reaches* §2 (link).

### §8 Revisiting *The Dynamics That Matter* (550)

**Purpose:** make the two corrections this essay owns, as a connected argument with links, not a ledger. Part 4 below gives the detail.

### §9 Closing (250)

**Purpose:** end on the boundary, not a recap.

- *Learning to Discover at Test Time* trains weights on one problem at test time, aiming for the best attempt rather than the average. This is continual learning compressed into a single problem. It still needs a verifier. In the terms of *The Given and the Found*, it amortizes search under a given condition, and the boundary that essay drew still stands.
- The closing claim: consolidation makes the weights inherit what the context made available. It cannot inherit a correctness condition that nothing supplied.

Sources: TTT-Discover 2601.16175; *The Given and the Found* §6 (link).

---

## 3. Where fast weights and in-context learning fit

The three kinds of learning are three rungs, not rivals. They differ in four respects:

| Store | What writes it | What persists | Capacity and interference | Cost to read |
| --- | --- | --- | --- | --- |
| KV cache (in-context learning) | the forward pass; nothing is overwritten | the session, or until eviction or compaction | grows with context; no overwriting, but context rot | grows with the cache, or with the selection under sparse attention |
| Delta-rule state (fast weights) | one error-correcting step per token, with a learned but frozen rule | the session, if the protocol keeps it | bounded; overlapping keys interfere; writes erase along their key | constant per token |
| Harness memory | the agent writes text | indefinitely | unbounded; retrieval quality falls as the store grows | retrieval plus context |
| Adapter | gradient, or one hypernetwork pass | indefinitely | small; composing adapters is an open problem | none extra once merged |
| Core weights | gradient toward data, reward or a self-teacher | indefinitely | large but entangled, which is where catastrophic forgetting lives | none extra |

Claims the essay makes about this ladder:

1. **In-context learning is the best learner on the ladder, per example.** It composes and generalizes better than fine-tuning on the same content (Lampinen et al.). The question is whether consolidation can keep that quality while the content leaves the context.
2. **Fast weights are parametric continual learning that already runs inside the frontier models.** Their timescale is a session, their capacity is bounded, and their update rule was meta-learned by pretraining. Irie et al.'s meta-learned continual learning is the same idea used for the slow timescale. The essay does not claim this state carries memory in practice. The Qwen3.5 recall results suggest the KV cache does that job in hybrids.
3. **Parametric continual learning in the slow weights is best understood as consolidation from the faster rungs.** That is what self-distillation does from context, what Doc-to-LoRA does from documents, and what frontier OPD does from specialists. The open problems are coverage (what revisits the old) and composition across time (§7), more than stability.
4. **The cut between parametric and non-parametric memory is the wrong one.** The delta-rule state is parametric and resets every session. Harness memory is non-parametric and permanent. The questions that discriminate are what writes, what persists, what interferes, and what it costs to read.

The architecture essay owns the details of delta-rule mechanics, gates, KV storage and within-session continuity. This essay links to it and to *Solving the Loop* §2 and uses one worked example (C).

---

## 4. Corrections to earlier essays

### Owned by this essay (*The Dynamics That Matter*)

**Correction 1 (§§1 and 7): parametric updating is necessary for compositionality and integration, and harness memory cannot provide them.**

- What the earlier essay said: harness memory keeps "the cognitive labor homogeneous". Composition "requires the integration to have happened at the parametric level rather than the harness level". The five desiderata rely on a heterogeneity "which parametric CL can provide and harness-based CL cannot".
- Correction: the controlled evidence runs the other way for single facts. Content held in context composes: reversals, syllogisms, Kalamang from a grammar book. Content trained into the weights composes poorly unless the training data spells out the implications. Retrieval does not stop later computation from integrating what it retrieved.
- What survives: the cost and automaticity argument. Retrieval gets harder as the store grows, context has a ceiling, and competence that has to be retrieved is slower than competence that is automatic. Whether composition survives at scale and across temporal distance is an empirical question, and Lichkovski's benchmark is designed to ask it.
- Keep the consolidation picture of §4 and the Dagstuhl modular-memory proposal. Self-distillation and frontier OPD are concrete versions of the consolidation pathway it imagined. This is an update, not a correction.

**Correction 2 (§7): low sample efficiency indicates deep integration. Retract.**

- What the earlier essay said: parametric updates being less sample-efficient "is a signal that the integration is happening at a level that requires evidence to support", and "pushing sample efficiency too low would mean either superficial integration or fragile integration".
- Retraction: sample efficiency measures the update rule and the prior, not the depth of integration. The clearest case is the one the earlier essay used. Fine-tuning needs many augmented samples to learn the implications of a fact, and those samples are the inferences in-context learning draws for free. Its sample hunger shows that the update rule cannot extract what was latent, which is the opposite of deep integration. Usable information gives the general statement. Doc-to-LoRA (one pass per document) and Lichkovski's hypernetwork (one pass per task, with positive backward transfer) are fast updates that are not obviously superficial.
- Replacement measure: integration should be measured by transfer, composition and interference, using the $R$ matrix and dependency probes, not by how many samples an update took.

Phrasing for the essay: corrections to our arguments, in our voice, without attributing the stronger claims to Lichkovski. His piece argued for automaticity, and it was our essay that turned that into a necessity claim. Re-read his "Defining Continual Learning" before drafting to confirm this.

### Coordinated with the architecture essay (not owned)

- Its ledger keeps *The Dynamics That Matter* §§2–3 (gradient descent "memoryless", agent–environment coupling), §§5, 8 and 10 (backpropagation), and the six axes.
- *What Breadth Reaches* §2's remark that simple online learners avoid interference is on that essay's list ("needs narrower conditions"). This essay can supply the evidence, because a delta-rule layer is exactly such a learner and its overwrite failures are documented (HiSPA on Mamba, a plausible analogue in GDN and KDA). Suggest the architecture essay link here, or the other way round, depending on publication order (open question 4).
- *What Breadth Reaches* §2 itself, on integration across sessions and the taste species, is not corrected. §7 above updates the evidence on the Lambert-versus-Dwarkesh question and leaves the taste question open.

---

## 5. Figures and worked examples

**Figure 1, the ladder of stores.** A vertical diagram of the six rungs from Part 3. Arrows between rungs are labelled with consolidation mechanisms (self-distillation, Doc-to-LoRA, prompt-to-weights, multi-teacher OPD). Annotate each rung with what writes it and how long it persists. This is the essay's main figure.

**Figure 2, the teacher-by-support grid.** Rows are teachers: old self, EMA self, frozen base, self with privileged context, external or larger same-family model. Columns are supports: new-task inputs, replayed old inputs, on-policy samples. Place LwF, DER, EMA, SDFT and OPSD, SDPO, iSDFT (two cells: self-teacher plus base anchor), SynthSelf, and frontier OPD. Empty cells and failure notes go in a caption.

**Figure 3, forgetting by data source.** Bars for *Retaining by Doing* on Qwen-2.5-7B, SFT vs GRPO non-target drops: 5.6 vs 0.2, 14.6 vs 0.2, 29.2 vs −0.3. Optional second panel: SDPO on LiveCodeBench v6 (27.9 to 48.8, against GRPO 41.2) with the holdout average (43.5 to 42.4).

**Worked example A, why an EMA teacher is not a memory (§2 and §4).** With momentum $m = 0.999$, the share of the teacher that comes from states older than $k$ steps is $m^k$. That is 37% at $k = 1{,}000$ and 0.7% at $k = 5{,}000$. A teacher that agrees with the student at every step can drift arbitrarily far from where training began. Three lines of arithmetic, then the base anchor as the fix.

**Worked example B, the implicit reward as a tilt (§3).** Three candidate answers. The bare model gives (0.6, 0.3, 0.1); with the demonstration in context it gives (0.1, 0.2, 0.7). The log-ratios (−1.79, −0.41, +1.95) are the implicit rewards. A full step lands on the teacher. iSDFT's half step ($\lambda = 0.5$, the normalized geometric mean) gives (0.325, 0.325, 0.351). It takes part of the teacher's information and stays near the student. Link the exponential tilt in *How Does a Policy Improve?* Part 2. The numbers are computed; recheck them while drafting.

**Worked example C, overwriting a redefined word (§6 and §7).** Use Lichkovski's "zup" redefinition with a 2-D delta-rule memory.
- With orthogonal keys, writing zup → red, then dax → blue, then zup → green at $\beta = 1$ replaces the zup association in place and leaves dax intact. At $\beta = 0.5$ zup reads as half red and half green, and repeated presentation converges at rate $1-\beta\|k\|^2$.
- Additive linear attention would read zup as red plus green.
- With overlapping keys (say $k_{\text{dax}} = (0.6, 0.8)$), revising zup also shifts dax by $0.6$ times the correction. Interference becomes visible in one line.
- Contrast with fine-tuning a contradicting fact, which has no targeted erase. Keep this as a contrast, not a claim about any particular model.

**Optional: frontier consolidation table.** One row each for DeepSeek V4, GLM-5.2/5.3, Kimi K3 and MiMo MOPD2: specialists built how, consolidated how, sources. It could go in a footnote, or be left to the architecture essay (open question 4).

**Optional: Lichkovski's knowledge-unit graph.** A small DAG over dax, kiki, tufa, zup, twice, thrice and surround, with the redefinition edge marked. Redraw it ourselves rather than use his slide, and ask him first (open question 3).

---

## 6. Before drafting

1. **Recover the report's citations.** They did not export. Every number quoted above comes from the report and must be checked against the paper: *Retaining by Doing*, SDFT 2026 (2601.19897), SDPO, iSDFT, *Denser ≠ Better* (v2, Oct 2026), SynthSelf (9 Oct 2026), DER, and Yang et al. 2024 SDFT.
2. **Read in full, not by abstract:** Lampinen et al. (ICL vs FT), Negation Neglect, *Learning, Fast and Slow*, Doc-to-LoRA, Irie et al. (meta-learned CL), CL Bench, FutureSim (locate it; it is not in the reading list), and TTT-Discover. Lichkovski's descriptions are a starting point, not a citation.
3. **Re-read Lichkovski's "Defining Continual Learning"** for correction 1's attribution.
4. **Check against the audio** any phrase the essay attributes to Lichkovski: "replay becomes play", automaticity, the hypernetwork ablation, usable information. The transcript stays private.
5. **Check the Dagstuhl position paper** before calling self-distillation "the consolidation pathway it imagined".

Reading-list items the essay will not use, or will mention only in passing: *Overcoming classic challenges… incentives and practice* (Irie and Lake) gets one clause at most in §1. The Cortical Labs Pong and Doom work gets one sentence at most, attributed. EWC appears only as the regularization baseline.

---

## 7. Open questions for the author

1. **Length and splitting.** The plan is about 7,000 words, close to the architecture essay's budget. Recommendation: two Substack parts of about 3,500 words each.
   - Part 1, "Who teaches the weights": §§0–4, covering the mechanism, the evidence and the failures.
   - Part 2, "Where experience goes": §§5–9, covering learned update rules, the ladder, benchmarks, corrections and the closing.
   - Part 1 stands alone. Part 2 needs §2's grid and §3's consolidation idea, so it would open with a 150-word bridge.
   - Alternative: one essay of about 6,000 words, dropping §5's MLC paragraph, the frontier table and worked example A.
2. **Register and byline.** The policy and reward essays are math-forward (KaTeX, Codex). The dynamics series is prose-forward (Claude). This essay sits between them. Should it carry the policy essay's equations, or keep mathematics to the three worked examples? The answer also decides how much of the report's notation (the loss with $q$ and $\mu$, the tilt) appears.
3. **Lichkovski's unpublished results.** The split-MNIST hypernetwork, the knowledge-unit benchmark, the skill-file SDFT runs and the OPSD-vs-GRPO run were shown in a public podcast but are not published. Should we ask him before featuring them, or ask him to check our description? Should we wait for his benchmark paper?
   - **Decided 22 Oct 2026:** asking is not a prerequisite, because the blog's reach is tiny compared with the podcast's. Keep the results labelled as preliminary and unpublished, as he presented them.
4. **Order relative to the architecture essay.** If this essay comes first, its links to the architecture essay are forward links, and the fast-weight paragraph leans on *Solving the Loop* §2. Should the frontier-OPD material live here (as evidence of consolidation at scale) or there (as a training stage), with a link from the other?
5. **Form of the corrections.** A dedicated §8 (as planned), or inline at §§3 and 6 where the evidence appears, with a short closing note? Inline is shorter and avoids a recap. A dedicated section is easier for readers of the old essay to find.
6. **Title.** See the working titles at the top.
7. **Vision continual-learning results.** Keep DER as the one example that past soft outputs are memory, and drop MOSE and PRD? The plan keeps DER only.
