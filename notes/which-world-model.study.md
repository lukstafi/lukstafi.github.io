---
title: "Study notes: Which World Model?"
essay: which-world-model
track: which-intelligence
reviewed-against: "12a9821"
requires:
  - {at: which-agi#the-question, for: "the running model, the deployment and the lineage as three different systems"}
  - {at: which-agi#what-a-deployment-has-and-what-it-lacks, for: "the inventory that puts a structured world model among the roles filled inside the network, and the difference between interpreted and compiled knowledge"}
introduces:
  - {term: level and trajectory claims, gloss: "\"this system falls short\" reports a level of performance; \"this approach is a dead end\" is a claim about a trend, and needs a metric, its movement across systems, and an expectation"}
  - {term: possessing versus using a representation, gloss: "a representation is a model when its organization supports inferences about the represented system, and explanatory when the agent uses those inferences; competence shows neither where the structure sits nor how it is used"}
  - {term: transition model, gloss: "the control sense of \"world model\": a predictor of the next state from an estimated state and a candidate action", related: ["three jobs of a world model"]}
  - {term: five capacities of a world model, gloss: "representing structure, tracking the current situation, predicting consequences, using a model, and maintaining a model; they vary independently", related: ["three jobs of a world model"]}
  - {term: goal compass, gloss: "Beckmann, Queloz and Freitas's name for a directional representation, separate from the map, that steers travel toward a distant goal"}
  - {term: belief state, gloss: "in the NextLat paper's sense: a hidden state sufficient for predicting the future sequence", related: ["Markov state"]}
  - {term: JEPA, gloss: "Joint Embedding Predictive Architecture: predict representations of targets and not the targets themselves", related: ["three jobs of a world model"]}
  - {term: "Systems A, B and M", gloss: "Dupoux, LeCun and Malik's division: learning from observation, learning through action, and the control of their interaction", related: ["compiled/interpreted gap", "self-sustainment", "pretraining, mid-training, SFT, RL, distillation and drafter training"]}
  - {term: cost of elicitation, gloss: "the examples, additional training, search, tool calls and experimenter-supplied information needed to bring a capacity out"}
uses:
  - {term: "process, deployment and lineage", from: which-agi}
  - {term: compiled/interpreted gap, from: which-agi}
---

The essay has no section headings, so the questions follow its order without section links. The answers state what the essay argues about its sources.

### What competence shows {kind=argue}

The essay starts from the intuition that competence needs an explanation. Why does "pattern matching" not supply one? What does competence leave unidentified? State the three grades of evidence and achievement that the essay separates.

::: answer
A system that repeatedly succeeds at unfamiliar tasks, under variations that defeat memorized answers, must have acquired something about the relations that make the tasks work. "Pattern matching" leaves the question open: which patterns, represented how, combined by what operations? Competence does not identify a mechanism. It can come from a policy that does not simulate consequences, from a shortcut that works in the tested domain, or from an external tool. The grades: diverse, transferable competence is strong evidence for sophisticated representations. Targeted experiments can establish that particular representations model environmental structure and causally guide behavior. A coherent, continually maintained model that the agent consults reliably is a further achievement, and failing at it can be mistaken for an absence of world modeling.
:::

### Falls short, or dead end {kind=distinguish}

Distinguish "this system falls short" from "this approach is a dead end". What three things does empirical support for the second need? Apply the distinction to a study in which a spurious association between syntax and subject domain persisted across the model sizes tested.

::: answer
The first reports a level of performance. The second is a claim about a trajectory. It needs a relevant metric, the metric's movement across successive systems or increasing research resources, and an expectation against which to judge that movement. A persistent gap below a demanding threshold can coexist with substantial progress toward it. The study of Shaib and colleagues is evidence against expecting those changes alone, under that recipe, to remove the shortcut. It excludes reasoning models and does not measure successive frontier systems. A local scaling result can identify a bottleneck without showing that a research programme points away from the goal.
:::

### Carrier's pathway {kind=object}

Carrier describes a progression from modeling one's surroundings and body up to a narrative self, and concludes: "That model-building and model-navigating pathway is the only way to real AI." Between which four standards does the essay say his list moves? Give its two replies.

::: answer
Knowing the structure of an environment. Using that knowledge to control a body. Retaining discoveries across a lifetime. Having a narrative self whose projects organize that lifetime. First reply: an absence at the fourth level cannot establish an absence at the first, or an animal's uncertain status as an autobiographical self would cast doubt on whether it represents its surroundings. Second reply: the order in which capacities developed biologically shows a successful route, and uniqueness needs a further argument. A machine trained on the products of human culture starts with information the first organisms had to acquire by other means. It may acquire extensive knowledge of causal systems before a robust model of its own embodiment. The essay shares much of Carrier's aspiration and rejects the jump to an impossibility claim.
:::

### Five capacities {kind=recall}

When does a representation earn the name "model", and when does it earn explanatory significance? Name the five capacities the essay separates, with what counts as evidence for each. Give two ways they come apart.

::: answer
It is a model when its internal organization supports inferences about the represented system. It is explanatorily significant when the agent uses those inferences.

- Representing structure: internal variables encode the relevant entities and relations, including on held-out cases.
- Tracking the current situation: the variables update appropriately as observations and actions arrive.
- Predicting consequences: the system forecasts transitions under specified actions, including alternatives.
- Using a model: altering or disabling the representation changes decisions in the predicted way.
- Maintaining a model: experience leads to durable corrections that improve later performance.

A system may know the map and lose its position. It may correct itself within a conversation and forget the correction afterward. Whether it "has" a world model is not a single bit.
:::

### What the objective leaves open {kind=explain}

What does the description "next-token predictor" identify, and what does it not? Why does learning from language neither prohibit world modeling nor guarantee truthfulness? State the real causal limitation and what it does not establish.

::: answer
The description identifies an objective and an output interface. It does not enumerate the computations learned to perform the objective. When the next observation depends on a state the sequence does not name, a predictor can benefit from inferring that state and its transition rules, and it can also exploit shortcuts. People write to describe, deceive, invent, speculate, quote and err, so predicting their text can reward representations of the world and of speakers' beliefs, and it can reward reproducing a persuasive falsehood. The causal limitation: observations alone can leave different causal explanations indistinguishable. It concerns the information and assumptions available to the learner. It does not establish that a transformer cannot represent a causal explanation, learn from descriptions of interventions, or run an experiment through its tools. The question of sufficient evidence applies to every architecture.
:::

### The map and the route {kind=case}

A transformer trained on routes through Manhattan predicted the next turn well. Maps reconstructed from its generated routes were incoherent, and forced detours hurt it. What did Beckmann, Queloz and Freitas find inside the model? Why is their evidence more than decoding? How do the map and the failure coexist, and what does the study show about shortcuts?

::: answer
They found representations of intersections, of legal moves and of connections between intersections: substantial relational structure with measurable imperfections. A probe can read information the model does not use, so a readable feature is not enough. Here changing the encoded position changes the model's choices appropriately. A separate goal compass was also found: steering it changes the direction of travel, and ablating it largely preserves legal moves while impairing progress toward distant goals. The intersection features share representational space. Under distribution shift the signal for the current location weakens, and the model applies information belonging to the wrong intersection. Restoring the position signal or reducing interference substantially improves the behavior. Intersections with the same moves have similar representations, so a confusion can leave the next move legal. What looks like a shortcut coexists with finer structure and protects behavior. "The model's failure was real. So was its map."
:::

### A compact state {kind=explain}

Why does ordinary next-token training not impose a compact state with a consistent update rule? What does NextLat add, and what does its theorem establish? On language benchmarks the averages were $58.82$ for next-token training, $58.79$ for NextLat with one-step supervision and $59.21$ with two-step supervision. Compute the differences and say what the essay concludes.

::: answer
Attention can look backward again at the next step, so the current hidden vector need not contain everything required to continue the computation. NextLat jointly trains a small dynamics model to predict the transformer's next hidden state from its current hidden state and the next token, and keeps the next-token loss. The theorem: if the model achieves both the correct next-token distribution and the specified consistency of latent transitions, its hidden state is sufficient for predicting the future sequence, a belief state. That is predictive sufficiency under exact conditions. Whether training attains them is empirical. The differences are $-0.03$ and $+0.39$ points. NextLat's strongest evidence concerns particular synthetic tasks, and its language results give little reason to regard ordinary language-model training as a mistaken direction.
:::

### Learned targets {kind=explain}

A JEPA predicts representations of targets and not the targets themselves. What freedom does this introduce that next-token prediction lacks? Recount the three steps of LeVLJEPA's ablation. What does a comparison between working language models and an idealized latent predictor get wrong?

::: answer
Next-token prediction has an externally fixed target: the learner cannot make its task trivial by changing the tokens it must predict. Jointly learned latent targets add a freedom that must be controlled, and learning what to discard is a substantive problem. In the ablation, directly matching image and text representations almost completely collapses the visual representation. Adding the distributional regularizer spreads the representations out and still yields poor features. Adding prediction heads and stop-gradient targets makes the features useful. "Avoiding a constant representation is not enough; the distinctions that survive must be useful." A comparison that assumes the latent predictor retains exactly the right information gives the alternative credit for a central problem it has to solve.
:::

### The scope of a dead end {kind=argue}

Why should the boundary of an alleged dead end be stated before a result is known? How does LeVLJEPA illustrate the point?

::: answer
Scaling a fixed next-token training recipe is a narrower programme than developing systems descended from language models. A successful change of objective might count against the sufficiency of the fixed recipe while counting as progress within the broader programme. If the boundary is not stated first, every improvement can be reassigned to a different path, and the original path's alleged sterility becomes impossible to test. LeVLJEPA changes the learning objective within familiar machinery, a vision transformer and a GPT-2-style text encoder. In its downstream tests the visual encoder feeds an existing language model. Research motivated by a criticism of current training becomes part of an LLM-derived system.
:::

### Systems A, B and M {kind=connect}

Name the three systems of Dupoux, LeCun and Malik and the central problem they pose. Why does the essay say this makes autonomy a matter of organization? How does it place the proposal among the systems of "Which AGI?", and where do the two objections to current AI meet?

::: answer
System A learns from observation. System B learns through action. System M controls their interaction: it selects inputs, routes information, changes operating modes and regulates learning by signals such as uncertainty and error. The central problem is that human engineers still organize much of the cooperation between A and B. System M's core routing policy is fixed over a lifetime while the systems it regulates change, so a fixed rule can direct learning, and plastic components can still depend on an outside operator. Autonomy turns on where control of learning resides. At the lineage level the laboratory already supplies data selection, evaluation and changes to the recipe, and the proposal internalizes some of those functions within a deployment ([Which AGI?](/notes/which-agi.html#three-grains-three-thresholds)). The two objections are insufficient world modeling and insufficient continual learning. A model that cannot durably revise itself keeps an increasingly unsuitable account, and a learner with poor representations may not recognize what an experience should change.
:::

### The cost of using knowledge {kind=explain}

Mattick observes that perfect knowledge of the rules of chess leaves the player with an enormous problem. What does a perfect one-step dynamics model leave unsolved? How can a planner misuse a learned simulator? What does the essay infer from Mattick's point about prior structure?

::: answer
It leaves search, evaluation and the allocation of computation. A simulator does not make control easy or tell the agent which imagined experiments are worth conducting. A planner can exploit it by discovering actions that appear successful only because the simulator gets them wrong, so model quality has to be assessed over the situations the resulting policy visits. Mattick argues for incorporating knowledge for which someone has already paid the price of discovery. The essay's own inference is that a corpus holds the products of costly investigations, and discarding that inheritance merely because it arrived through language would be wasteful.
:::

### Specify the computation {kind=object}

Rekhi's article argues that transformers are wrong for AGI. Which error of inference does the essay find throughout it? Give three instances, and the four computations a claim about limits must choose among.

::: answer
The article takes a limitation of a specified computation or training regime as a universal limitation of systems built using transformers.

- The composition bound of Peng, Narayanan and Papadimitriou is proved for a single attention layer under explicit conditions. "The condition specifying the lower bound is part of the result."
- Merrill and Sabharwal's placement in TC⁰ is an upper bound for a formal class, and their later work studies how intermediate generation extends computational power.
- Frozen deployment weights are a choice about when updates occur, not an architectural inability to learn.

The computation may be one pass, multiple generated steps, recurrent latent updates, or a controller invoking external tools. A fixed-size network asked to answer immediately and a deployment allowed to run an algorithm are different computational systems.
:::

### A useful evaluation {kind=state}

Outline the evaluation the essay proposes for a system and for a deployed agent. Dual Exam's pilot put an agent inside a generated environment and completed none of its tasks. Why was that uninformative, what does the benchmark do instead, and why does an average score say little?

::: answer
Start with a novel environment whose states and interventions can be controlled. Test prediction when surface features change and familiar elements recombine. Compare success with plausible shortcuts, including memorized examples. Probe candidate representations, then intervene on them. Measure separately whether the system knows the structure, tracks its state, selects useful actions and retains corrections after its context is gone. For a deployed agent, repeat with its tools and memory, account for their contributions, and include the cost of elicitation. In the pilot the trajectories could not say which side had failed. Dual Exam tests each side with the other held fixed: agents act in reference environments, and world models receive scripted actions. Rankings of world models reversed between scenarios, so an average says little about how a model will serve the states one particular agent visits.
:::

### What the studies do not establish {kind=limits}

How does the essay propose to assess a research direction, as against a system? What does it say the reviewed studies do and do not establish? Which limits does it note on the Manhattan experiments and on its sources?

::: answer
Turn the evaluations into comparisons across successive systems, with observations, actions, task distribution and inference budget specified, and training resources tracked. State the expected progress beforehand: a sustained plateau, deterioration under controlled conditions, or costs that grow prohibitively would weigh against a proposal. A positive slope does not guarantee that a target is reached within feasible resources. A claim of practical unviability needs a cost argument, and a claim of architectural impossibility needs a stronger one. The studies identify particular bottlenecks and particular improvements. They do not establish a longitudinal failure of LLM-derived systems on the capabilities Carrier requires. The Manhattan experiments use a finite world with deterministic transitions, and some interventions supply the experimenter's knowledge of the correct state, which an autonomous agent would have to recover itself. The empirical papers are preprints reported within their tested settings, and the connections among the sources are the essay's own argument.
:::
