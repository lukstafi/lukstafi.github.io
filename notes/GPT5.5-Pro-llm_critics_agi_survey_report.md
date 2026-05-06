# Why LLM-Based AI May Be an Off-Ramp from the Shortest Path to AGI

**A survey of arguments from Yann LeCun, Richard Sutton, David Silver, François Chollet, Subbarao Kambhampati, and related critics**

**Prepared:** April 30, 2026  
**Scope:** This report focuses on modern technical critiques of LLM-centered AGI strategies. It intentionally does **not** dwell on the older strong-form claim that deep learning cannot handle symbolic or abstract reasoning at all; that claim is too blunt to explain the empirical capabilities of contemporary systems.

---

## Executive thesis

The strongest critiques of LLM-centered AI are not that LLMs are useless, nor that neural networks cannot reason. The more precise claim is this:

> **LLM-centered AI optimizes imitation of human-produced artifacts, especially text, whereas AGI likely requires agents that learn from grounded experience, build predictive world models, plan over consequences, explore, verify, and discover new knowledge beyond the human corpus.**

On this view, LLMs are powerful compressors of human knowledge and behavior. They can serve as interfaces, code generators, memory systems, proposal generators, tool routers, and priors over human concepts. But they are not obviously the central mechanism by which one obtains robust, autonomous, human-level or superhuman intelligence.

The shared objection is that current LLMs are trained primarily on records of human cognition rather than on the world-generating processes that produced those records. Human text is partial, lossy, retrospective, socially filtered, and biased toward what humans chose to write down. It contains many conclusions but omits most perceptual, causal, motor, experimental, and motivational structure.

Different critics emphasize different missing ingredients:

- **Yann LeCun:** world models, latent predictive representations, action-conditioned prediction, and planning.[^lecun-path]
- **Richard Sutton:** scalable general methods, especially learning and search, rather than reliance on fixed human knowledge.[^bitter]
- **David Silver and Sutton:** experience, reward, and agent-generated data rather than imitation of human data.[^era]
- **David Silver’s AlphaZero line:** self-play and search as evidence that superhuman discovery can arise from interaction rather than human demonstrations.[^alphazero]
- **François Chollet:** intelligence as skill-acquisition efficiency, not merely skill accumulated through massive prior exposure.[^chollet]
- **Subbarao Kambhampati and planning researchers:** LLMs can produce plan-like text, but planning requires state models, constraints, search, and verification.[^planbench]
- **Hallucination and calibration critics:** plausible language generation is not the same as truth-tracking belief formation.[^calibrated-hallucination][^why-hallucinate]
- **Data-bottleneck analysts:** human-generated public text is finite, so future scaling must rely increasingly on experience, verification, synthetic data, private data, or other non-textual signals.[^epoch-data]

The resulting position is not “LLMs will disappear.” It is closer to: **LLMs may be modules inside future AGI systems, but an LLM-first route risks converging to a local optimum around human-data imitation rather than to the shortest path toward autonomous general intelligence.**

---

## 1. What is being criticized?

The target is not every use of transformers, self-supervised learning, or large neural networks. The target is **LLM-first AGI**, roughly the strategy of:

1. Train a very large autoregressive model on human text, code, images, video, and other human-generated or human-curated data.
2. Post-train it with instruction tuning, RLHF, preference optimization, synthetic reasoning traces, or related methods.
3. Add prompting, tool use, retrieval, memory, code execution, and agent scaffolding.
4. Scale model size, data, compute, context length, and test-time inference.

This strategy has produced highly useful systems. The skeptical question is narrower: **Is this the shortest path to AGI?** The critics surveyed here argue that it probably is not, because the core optimization target is misaligned with the mechanisms needed for robust agency.

An LLM is excellent at modeling the distribution of human-produced sequences. An AGI, by contrast, must learn and act in the world. It must choose actions, anticipate consequences, acquire new skills, revise beliefs, verify hypotheses, and continue learning outside the fixed corpus on which it was trained.

The critique therefore concerns several mismatches:

| Mismatch | LLM-centered strategy | AGI-relevant requirement |
|---|---|---|
| **Objective** | Predict or generate plausible human-like outputs | Act to achieve goals under uncertainty |
| **Data source** | Human artifacts and demonstrations | Grounded interaction, exploration, feedback, and experience |
| **Representation** | Linguistic and statistical regularities | Predictive, causal, spatial, temporal, and action-conditioned world models |
| **Planning** | Generate plan-like text or reasoning traces | Search over executable actions with constraints and verification |
| **Evaluation** | Static benchmarks and preference judgments | Robust transfer, continual skill acquisition, real-world consequences |
| **Reliability** | Fluent continuation, often with confident guesses | Calibrated belief, uncertainty awareness, and truth-preserving action |

---

## 2. Yann LeCun: language is not the substrate of intelligence

### 2.1 The world-model argument

Yann LeCun’s critique centers on the claim that intelligence requires **predictive world models**. In *A Path Towards Autonomous Machine Intelligence*, he asks how machines can learn as efficiently as humans and animals, reason and plan, and learn representations of percepts and action plans at multiple abstraction levels.[^lecun-path]

The central idea is that an intelligent system needs a model of the world that supports:

- prediction of future states;
- estimation of which actions lead to which outcomes;
- planning at multiple time scales;
- abstraction over irrelevant perceptual detail;
- learning from observation and interaction without requiring labels or explicit supervision for everything.

LeCun’s proposed route emphasizes joint-embedding predictive architectures, latent-space prediction, self-supervised representation learning, hierarchical planning, and intrinsic objectives. The major contrast with autoregressive LLMs is that LLMs predict the next token in a sequence, whereas LeCun wants systems that predict latent states of the world and use those predictions for action.

### 2.2 Why text is insufficiently grounded

Language is a powerful representational layer, but it is not the world. A sentence such as “the cup falls when pushed off the table” is a sparse symbolic summary of a dense physical process involving object geometry, gravity, contact dynamics, uncertainty, occlusion, motor affordances, and consequences. Human infants and animals learn much of this structure before language and without reading.

LeCun’s critique is that an LLM can learn the linguistic regularity that cups fall when pushed, but this is not the same as learning a robust, action-conditioned physical model that supports planning in novel situations. The system can say what usually happens without necessarily being able to simulate, control, or adapt to the underlying process.

This is the sense in which LLMs may be an “off-ramp”: they learn the linguistic projection of intelligence rather than the world-modeling machinery that makes intelligence possible.

### 2.3 JEPA and video-based world modeling

The JEPA line illustrates the alternative path. Instead of reconstructing raw pixels or tokens, JEPA-style models learn to predict representations of missing or future parts of sensory input in latent space. Recent V-JEPA 2 work is explicitly framed around self-supervised video models for understanding, prediction, planning, and robot control, combining large-scale video data with interaction data.[^vjepa2]

The important point is architectural and objective-level, not merely modality-level. A multimodal LLM that consumes images or video may still be optimized primarily as a sequence model. LeCun’s alternative is to train systems to learn compact latent representations that support prediction and planning directly.

### 2.4 The implied AGI path

LeCun’s implied sequence is roughly:

1. Learn self-supervised perceptual representations from the world.
2. Learn predictive latent world models.
3. Learn action-conditioned models of consequences.
4. Plan in latent space.
5. Add memory, intrinsic objectives, hierarchical control, and language.

The LLM-first route reverses this order: it starts from language and attempts to bolt on grounding, planning, and agency afterward. LeCun’s objection is that this may produce impressive assistants but not the most direct path to autonomous intelligence.

---

## 3. Richard Sutton: the bitter lesson and the danger of human-data dependence

### 3.1 The bitter lesson

Richard Sutton’s “bitter lesson” is that the largest long-term advances in AI have tended to come from general methods that scale with computation, especially **search and learning**, rather than from methods that encode human knowledge directly.[^bitter]

This lesson appears, at first, to support LLMs. LLMs are not hand-coded symbolic systems. They are large learned models trained with scalable computation. But Sutton’s deeper point can also be turned against LLM-centered AGI: the human text corpus is still a form of human knowledge. It is not hand-coded by AI researchers, but it is fixed, retrospective, and bounded by what humans have produced.

In that sense, LLMs may be halfway between two paradigms:

- They are bitter-lesson-compatible in their use of scale and learning.
- They are bitter-lesson-limited in their dependence on human-generated artifacts as the main source of competence.

### 3.2 Why imitation is not the highest-scaling source of intelligence

The core Suttonian critique is that imitation of human data is unlikely to be the ultimate scaling path. A model trained to imitate human outputs can become very useful, but it is still largely constrained by the distribution of those outputs.

For superhuman discovery, the data source must not be limited to what humans already wrote or demonstrated. It must include the agent’s own search, experimentation, failures, and successes. That is why Sutton’s preferred mechanisms are learning and search in environments, not merely compression of human text.

### 3.3 LLMs as a local optimum

LLMs may represent a local optimum in which AI progress is measured by increasingly broad imitation of human communicative competence. This local optimum is commercially attractive because language interfaces are useful and easy to deploy. But commercial usefulness is not the same as shortest-path AGI.

A Sutton-style critique would ask: **What process can keep producing new capability as compute grows?** Human text eventually saturates. Experience, search, simulation, and self-play can in principle keep generating new data.

---

## 4. David Silver and Sutton: the era of experience

### 4.1 From human data to experience

David Silver and Richard Sutton’s *Welcome to the Era of Experience* makes the argument explicit. They describe contemporary systems as having benefited from large-scale human data, but argue that the next era should involve agents acquiring capabilities predominantly from experience.[^era]

The key claim is that imitation of human data is unlikely to yield superhuman capabilities in domains such as mathematics, programming, science, and open-ended discovery, because the necessary breakthroughs are not already present in the corpus. Agents must generate new knowledge by acting, observing, testing, and learning from consequences.

### 4.2 What “experience” means

Experience is not merely more dialogue. It means temporally extended interaction in which the agent’s actions affect future observations and rewards. It includes:

- action;
- observation;
- feedback;
- consequences;
- long-horizon credit assignment;
- exploration;
- self-improvement;
- adaptation to changing environments.

This is fundamentally different from next-token prediction. A language model observes a static corpus. An experience-based agent participates in the process that generates future data.

### 4.3 Why experience matters for AGI

The strongest form of the argument is that AGI must be able to discover what humans have not already discovered. That requires a data-generating process beyond human imitation.

| Paradigm | Main data source | Main bottleneck | Mechanism for superhuman discovery |
|---|---|---|---|
| LLM-centered AI | Human-generated text, code, demonstrations, and preferences | Finite human corpus; retrospective human knowledge | Weak unless paired with search, verification, tools, or environments |
| Experience-centered AI | Agent interaction with environments | Environment design, reward, exploration, safety | Stronger: self-play, experimentation, reinforcement learning, feedback loops |

LLMs can still help agents reason about experience. But the experience-centered view makes language a support mechanism rather than the primary learning substrate.

---

## 5. David Silver: AlphaZero, reward, and self-discovery

### 5.1 AlphaZero as evidence against human-imitation dependence

AlphaZero is important because it demonstrates superhuman performance arising from self-play reinforcement learning rather than imitation of human expert games. AlphaZero learned chess, shogi, and Go from random play, using only the rules of the games, and defeated world-champion programs in each case.[^alphazero]

This does not prove that the same recipe solves open-world intelligence. Games are unusually clean: they have fixed rules, cheap simulation, objective outcomes, and well-defined success metrics. But AlphaZero does show that human demonstrations are not necessary for superhuman competence when a system has:

- an environment;
- a valid action space;
- a feedback signal;
- search;
- self-generated experience;
- a learning loop that improves from that experience.

The contrast with LLMs is direct. LLMs learn from the products of human intelligence. AlphaZero-style systems learn by generating and evaluating their own trajectories.

### 5.2 “Reward is enough”

In “Reward is Enough,” Silver, Singh, Precup, and Sutton argue that intelligence and associated abilities can be understood as serving reward maximization.[^reward-enough] Whether one accepts the thesis in its strongest form or not, it provides a coherent alternative to LLM-first AGI: build agents that learn to act in the world to maximize long-run reward.

LLM pretraining is not primarily about long-run action and consequence. RLHF and preference tuning add a reward-like layer, but this reward is usually attached to short dialogue outputs and human judgments, not to extended environmental consequences.

### 5.3 The limitation of the reward-centered view

The reward-centered view has its own weaknesses. Open-world reward specification is hard. Sparse rewards can be inefficient. Mis-specified rewards can produce unsafe or perverse behavior. Real environments are not as clean as Go or chess.

However, these limitations do not rescue pure LLM-first AGI. They suggest that future systems need better environments, richer feedback, safer exploration, and world models. In other words, they push toward hybrid agent architectures, not toward language modeling alone.

---

## 6. François Chollet: task skill is not intelligence

### 6.1 Intelligence as skill-acquisition efficiency

François Chollet’s critique is based on measurement. In *On the Measure of Intelligence*, he argues that intelligence should not be identified with task performance alone. A system can acquire high task skill through enormous prior exposure. What matters is **skill-acquisition efficiency**: how efficiently a system can acquire new skills from limited information.[^chollet]

This is a particularly important critique of LLMs. LLMs often appear generally intelligent because they have absorbed enormous amounts of prior information. But if success depends on massive prior exposure, then benchmark performance may measure the scale of training more than fluid intelligence.

### 6.2 ARC and ARC-AGI

The Abstraction and Reasoning Corpus was designed to test few-shot abstraction on tasks that humans can often solve from a few examples. ARC-style tasks try to reduce the usefulness of memorized world knowledge and instead test rapid rule inference.

The ARC Prize 2024 technical report says the state of the art on the private ARC-AGI evaluation set rose from 33% to 55.5%, driven by methods such as deep-learning-guided program synthesis and test-time training.[^arc2024] The ARC Prize 2025 technical report describes ARC-AGI-2 as more difficult and reports a top score of 24% on the private evaluation set.[^arc2025]

The implication is not that LLMs cannot reason. It is that broad pretraining may not give the kind of rapid abstraction and adaptation that humans display on genuinely novel tasks.

### 6.3 Crystallized versus fluid intelligence

A useful distinction is:

- **Crystallized intelligence:** accumulated knowledge, patterns, and skills from prior exposure.
- **Fluid intelligence:** ability to infer new abstractions and solve novel problems from little data.

LLMs are extremely strong in crystallized intelligence. The open question is whether their fluid intelligence scales in the way AGI requires. Chollet’s answer is skeptical: performance bought by massive pretraining should not be mistaken for efficient skill acquisition.

---

## 7. Kambhampati and planning critics: plan text is not planning

### 7.1 The planning gap

Subbarao Kambhampati and collaborators argue that LLMs should not be treated as autonomous planners merely because they can generate plausible plan descriptions. In one systematic benchmark based on classical planning domains, LLM-generated executable plans achieved only about 3% success on average in autonomous mode.[^planbench]

The critical distinction is between:

- **describing** a plan;
- **constructing** a valid executable plan;
- **verifying** that the plan satisfies preconditions, effects, and constraints;
- **repairing** the plan when execution diverges from expectation.

Autoregressive text generation can produce language that resembles planning, but it does not by itself guarantee state consistency, constraint satisfaction, or correctness.

### 7.2 What real planning requires

Planning requires some combination of:

- a state representation;
- action preconditions;
- action effects;
- search over alternatives;
- constraint propagation;
- long-horizon credit assignment;
- uncertainty handling;
- plan validation;
- replanning after failure.

An LLM may implicitly approximate some of these operations in familiar domains, but the architecture does not enforce them. This is why LLM plans often become brittle when tasks require exactness, long horizons, or unfamiliar constraints.

### 7.3 LLM-Modulo as a constructive alternative

Kambhampati’s “LLM-Modulo” framing is not anti-LLM in a simplistic sense. It argues that LLMs can be useful proposal generators or knowledge sources, but that their outputs should be checked by external critics, solvers, simulators, planners, or verifiers.[^llm-modulo]

This is an important middle ground. LLMs may remain valuable inside planning systems, but the planning reliability comes from the larger architecture, not from autoregressive text generation alone.

---

## 8. Hallucination as objective mismatch

### 8.1 Hallucination is not merely a bug

Hallucination is often discussed as a temporary defect that better post-training will reduce. But some analyses suggest a deeper structural issue.

Kalai and Vempala’s “Calibrated Language Models Must Hallucinate” gives statistical lower bounds showing that certain types of hallucination are expected for calibrated pretrained language models when facts are arbitrary or rare in the training data.[^calibrated-hallucination]

A later paper, “Why Language Models Hallucinate,” argues that hallucinations persist partly because training and evaluation procedures reward guessing over acknowledging uncertainty.[^why-hallucinate]

### 8.2 Why this matters for AGI

An AGI must maintain calibrated beliefs, know when it does not know, seek information when needed, and avoid acting on false assumptions. A model optimized to produce plausible completions can be pushed toward confident answers even under uncertainty.

The problem is not only factual error. It is epistemic posture. LLMs often behave like exam takers rewarded for guessing, whereas autonomous agents need to behave like investigators that can suspend judgment, test hypotheses, and gather evidence.

### 8.3 Verification as the missing ingredient

Hallucination is reduced when outputs are grounded in external correctness signals:

- retrieval from reliable sources;
- code execution;
- theorem proving;
- simulation;
- experiment;
- database lookup;
- human or automated verification;
- calibrated abstention.

Again, the pattern is the same: the most reliable path is not language alone, but language embedded in a system with external grounding and verification.

---

## 9. The data bottleneck: human text is finite

### 9.1 Public human text does not scale forever

Epoch AI estimates that, if current trends continue, language models could fully utilize the stock of public human-generated text between 2026 and 2032.[^epoch-data] The precise timeline is uncertain, but the qualitative point is robust: public human text is not an unlimited resource.

This matters because LLM progress has depended heavily on scaling data and compute. If human text saturates, future gains must come from some combination of:

- better data quality;
- private or proprietary data;
- multimodal data;
- synthetic data;
- tool-generated data;
- agent experience;
- formal verification;
- improved architectures;
- more efficient training and inference.

### 9.2 Synthetic data only helps when grounded

Synthetic data is not automatically a solution. It is most useful when there is an external correctness signal. Examples include:

- synthetic math problems checked by formal or numerical verification;
- synthetic code checked by execution and tests;
- synthetic proofs checked by theorem provers;
- simulated robot trajectories checked by physics engines or real-world transfer;
- self-play games checked by game rules and outcomes.

Without verification, synthetic data can amplify model errors and collapse diversity. The important ingredient is not that the data is synthetic; it is that the data is connected to feedback.

### 9.3 Why this reinforces the experience thesis

The data bottleneck supports Sutton and Silver’s “era of experience.” If the main training source is finite human output, then the system’s competence is tethered to past human cognition. Experience-based systems can, in principle, generate new data as they act and improve.

---

## 10. The shared structure of the critique

Across the surveyed researchers, the anti-LLM-first argument has a common form.

### 10.1 Objective mismatch

LLMs are trained primarily to model or produce human-like sequences. AGI requires selecting actions that transform world states in pursuit of goals. These objectives overlap but are not equivalent.

A system can be excellent at describing actions while being poor at choosing, executing, or adapting those actions in the world.

### 10.2 Data-source mismatch

LLMs learn from human artifacts. AGI likely needs to learn from the world. Human artifacts are finite, filtered, and retrospective. Experience is open-ended, interactive, and consequence-bearing.

### 10.3 Grounding mismatch

Language refers to the world, but it is not the world. Physical, social, and causal understanding require models that connect perception, action, and consequence.

### 10.4 Planning mismatch

Text generation is sequential generation. Planning is search over possible futures. A generated chain of thought may resemble planning, but robust planning requires state tracking, constraints, and verification.

### 10.5 Evaluation mismatch

Benchmarks often measure accumulated competence rather than learning efficiency. A system can perform well because it has seen enough related data, not because it can infer new abstractions from little evidence.

### 10.6 Reliability mismatch

Fluency and confidence are not truth. AGI requires calibrated belief, uncertainty awareness, and external grounding.

---

## 11. Where LLMs may still fit

A careful version of the critique does not say that future AGI systems will contain no LLM-like components. More likely, LLMs will function as powerful subsystems.

Possible roles include:

- natural-language interfaces;
- summarization and translation between human and machine representations;
- retrieval and memory front ends;
- code generation;
- tool-use orchestration;
- proposal generation inside search systems;
- priors over human concepts;
- explanation modules;
- assistants to formal planners, theorem provers, simulators, and verifiers.

The key distinction is between **LLM as the engine of intelligence** and **LLM as a component inside a broader intelligence architecture**. Many of the critics reject the former while accepting the latter.

Indeed, current frontier trends toward tool use, code execution, verifiable reasoning tasks, test-time search, multimodality, and agentic interaction can be read two ways:

1. The pro-LLM reading: LLMs are evolving into AGI.
2. The critic’s reading: systems become more promising precisely as they become less purely LLM-based and more grounded in search, tools, verification, world models, and experience.

---

## 12. The strongest counterargument to the critics

The strongest counterargument is that “LLM-based AI” may evolve into a broader family of architectures that includes multimodal perception, tool use, reinforcement learning, self-play, memory, planning, and verification. A sufficiently large transformer-like system trained on text, video, code, actions, tool traces, and reward-bearing interactions might internalize world models and planning procedures.

This counterargument has force. It is plausible that many ingredients associated with world models and experience can be implemented within or around transformer architectures. The boundary between “LLM” and “agentic world model” may blur.

But this counterargument also concedes much of the critics’ point. If success requires grounded interaction, search, verification, long-horizon memory, reward, and world models, then the shortest path is not simply “scale next-token prediction.” It is to build broader learning systems in which language modeling is one component among several.

---

## 13. Summary matrix

| Researcher / school | Core criticism of LLM-first AGI | Missing ingredient | Implied alternative |
|---|---|---|---|
| **Yann LeCun** | Text prediction does not yield robust world understanding or planning | Predictive world models, latent-space abstraction, perception-action grounding | JEPA-style self-supervised world models, intrinsic objectives, hierarchical planning |
| **Richard Sutton** | Human knowledge and human data are not the most scalable long-term route | General learning and search from experience | Systems that exploit compute through learning, search, and interaction |
| **David Silver / Sutton** | Imitating human data is unlikely to produce superhuman discovery | Streams of grounded experience and reward | Experience-based agents, self-play, RL, environment-grounded learning |
| **AlphaZero line** | Superhuman competence need not come from human demonstrations | Self-play, search, objective feedback | Agents that generate and evaluate their own trajectories |
| **François Chollet** | Benchmark skill can be bought with priors and data | Skill-acquisition efficiency from sparse evidence | ARC-style tests of fluid abstraction and novel task learning |
| **Kambhampati / planning critics** | Generating plan-like text is not reliable planning | State models, search, constraints, verification | LLMs plus external planners, solvers, critics, and verifiers |
| **Hallucination / calibration critics** | Plausible generation is not truth-tracking | Uncertainty, abstention, external grounding | Calibrated systems with verification and better evaluation incentives |
| **Data-scaling critics** | Public human text is finite and backward-looking | New data from interaction and verification | Experience, synthetic data with checks, multimodal grounding, continual learning |

---

## 14. Bottom line

The strongest modern critique of LLM-centered AGI is not the older claim that neural networks cannot represent symbols or perform reasoning. It is a more specific and more durable claim:

> **LLMs are excellent at amortizing past human cognition, but AGI requires systems that generate new cognition through grounded interaction, search, planning, verification, and self-improving experience.**

LeCun’s version says the missing core is a predictive world model. Sutton’s version says the missing core is scalable learning and search from experience. Silver’s version says superhuman discovery comes from agents that generate and evaluate their own trajectories. Chollet’s version says intelligence is rapid skill acquisition, not performance purchased by massive prior exposure. Kambhampati’s version says planning needs verifiable state-space reasoning, not fluent plan descriptions.

On this synthesis, LLMs are not irrelevant. They are likely to remain powerful modules. But an LLM-only or LLM-centered route looks like a local optimum around human-data imitation. The shorter path to AGI, according to these critics, runs through **experience, world models, search, grounded reward, formal or environmental verification, and continual learning**, with language as an interface and representational layer rather than the sole engine of intelligence.

---

## References

[^lecun-path]: Yann LeCun, *A Path Towards Autonomous Machine Intelligence*, 2022. <https://openreview.net/pdf?id=BZ5a1r-kVsf>

[^bitter]: Richard S. Sutton, “The Bitter Lesson,” 2019. <https://www.incompleteideas.net/IncIdeas/BitterLesson.html>

[^era]: David Silver and Richard S. Sutton, *Welcome to the Era of Experience*, 2025. <https://storage.googleapis.com/deepmind-media/Era-of-Experience%20/The%20Era%20of%20Experience%20Paper.pdf>

[^alphazero]: David Silver et al., “Mastering Chess and Shogi by Self-Play with a General Reinforcement Learning Algorithm,” arXiv, 2017. <https://arxiv.org/abs/1712.01815>

[^reward-enough]: David Silver, Satinder Singh, Doina Precup, and Richard S. Sutton, “Reward is Enough,” *Artificial Intelligence*, 2021. <https://www.sciencedirect.com/science/article/pii/S0004370221000862>

[^chollet]: François Chollet, “On the Measure of Intelligence,” arXiv, 2019. <https://arxiv.org/abs/1911.01547>

[^arc2024]: François Chollet et al., *ARC Prize 2024: Technical Report*, 2024. <https://arcprize.org/media/arc-prize-2024-technical-report.pdf>

[^arc2025]: François Chollet et al., *ARC Prize 2025: Technical Report*, arXiv, 2026. <https://arxiv.org/abs/2601.10904>

[^planbench]: Karthik Valmeekam, Sarath Sreedharan, Matthew Marquez, Alberto Olmo, and Subbarao Kambhampati, “On the Planning Abilities of Large Language Models,” arXiv, 2023. <https://arxiv.org/abs/2302.06706>

[^llm-modulo]: Subbarao Kambhampati, “LLMs Can’t Plan, But Can Help Planning in LLM-Modulo Systems,” ICML, 2024. <https://raw.githubusercontent.com/mlresearch/v235/main/assets/kambhampati24a/kambhampati24a.pdf>

[^calibrated-hallucination]: Adam Tauman Kalai and Santosh S. Vempala, “Calibrated Language Models Must Hallucinate,” arXiv, 2023. <https://arxiv.org/abs/2311.14648>

[^why-hallucinate]: Adam Tauman Kalai, Ofir Nachum, Santosh S. Vempala, and Edwin Zhang, “Why Language Models Hallucinate,” arXiv, 2025. <https://arxiv.org/abs/2509.04664>

[^epoch-data]: Pablo Villalobos et al., “Will we run out of data? Limits of LLM scaling based on human-generated data,” Epoch AI, 2024. <https://epoch.ai/blog/will-we-run-out-of-data-limits-of-llm-scaling-based-on-human-generated-data>

[^vjepa2]: Meta AI, “V-JEPA 2: Self-Supervised Video Models Enable Understanding, Prediction and Planning,” 2025. <https://ai.meta.com/research/publications/v-jepa-2-self-supervised-video-models-enable-understanding-prediction-and-planning/>
