---
title: "Study notes: Where Experience Goes"
essay: where-experience-goes
track: keeps-learning
reviewed-against: "9549221"
requires:
  - {at: who-teaches-the-weights#the-model-with-privileged-context-as-teacher, for: self-distillation as consolidation}
  - {at: who-teaches-the-weights#what-on-policy-training-forgets, for: forgetting within a task}
  - {at: learning-about-what-you-do-not-do#questions-and-answers, for: prediction heads}
  - {at: how-can-a-reward-train-a-neural-network#learning-values-from-experience, for: the TD(0) update}
  - {at: how-does-a-policy-improve#the-evidence-lower-bound-and-expectation-maximization, for: E-step and M-step}
  - {at: how-does-a-policy-improve#a-reusable-way-to-read-the-algorithms, for: the four questions}
introduces:
  - {term: learned update rule, at: learning-the-update-rule}
  - {term: ladder of stores, at: a-ladder-of-stores}
  - {term: delta-rule memory, at: a-ladder-of-stores}
  - {term: consolidation as an M-step, at: consolidation-is-an-m-step}
  - {term: amortization argument for weights, at: what-survives-of-the-argument-for-parametric-memory}
uses:
  - {term: temporal-difference error, from: how-can-a-reward-train-a-neural-network}
  - {term: E-step and M-step of policy improvement, from: how-does-a-policy-improve}
  - {term: mass-covering and mode-seeking KL, from: how-does-a-policy-improve}
  - {term: self-distillation with privileged context, from: who-teaches-the-weights}
  - {term: forgetting within a task, from: who-teaches-the-weights}
  - {term: general value function, from: learning-about-what-you-do-not-do}
---

### The ladder {kind=recall at=a-ladder-of-stores}

List the seven stores from fastest to slowest, and the four questions that separate them.

::: answer
The context; the recurrent state of hybrid models; harness memory (notes, skill files, retrieved documents); prediction heads; adapters; core weights; the release cycle. The questions: what writes the store, what persists in it and for how long, how much it holds before entries interfere, and what it costs to read.
:::

### The delta rule is TD(0) without a future {kind=derive at=a-ladder-of-stores}

A delta-rule layer writes $S_t=S_{t-1}+\beta_t(v_t-S_{t-1}k_t)k_t^\top$. Show that this is a gradient step, and relate it to temporal-difference learning.

::: answer
It is one step of gradient descent on $\tfrac12\|Sk_t-v_t\|^2$: read the prediction, compare with the value, write the correction. TD(0) with a linear estimate adds $\alpha(r+\gamma\,\theta^\top\phi'-\theta^\top\phi)\phi$. With $\gamma=0$ the target is the observed signal alone, which is the delta rule with $\phi$ as key and $r$ as value. The recurrent state and the prediction heads share an update rule. They differ in their targets and in how long they keep what they learn.
:::

### Overwriting a redefined word {kind=compute at=a-ladder-of-stores}

Keys $k_{\text{zup}}=(1,0)$ and $k_{\text{dax}}=(0,1)$. Write zup → red, dax → blue, zup → green with $\beta=1$. What do zup and dax read? What changes with $\beta=0.5$, with purely additive writes, and with keys of cosine $0.6$?

::: answer
Zup reads green and dax reads blue: the third write added $(\text{green}-\text{red})k_{\text{zup}}^\top$ and replaced the association in place. With $\beta=0.5$ zup reads half red and half green, and each repetition shrinks the remaining error by $1-\beta\|k\|^2$. An additive memory, which writes without reading, makes zup read red plus green. With overlapping keys the same correction moves dax's readout by $0.6\,(\text{green}-\text{red})$. Interference is proportional to key overlap.
:::

### What the recurrent state turned out to hold {kind=explain at=a-ladder-of-stores}

Two interpretability studies swapped or kept the attention cache and the recurrent state. What did each store carry?

::: answer
Exact recall ran through the attention cache: swapping caches moved the answer almost fully and swapping recurrent states barely moved it. The recurrent state carried the requested output language and the persona. So far the second rung is a store of dispositions for the session, not of facts. The prompts did not overflow the state, so the routing was learned and not forced by capacity.
:::

### A hypernetwork that ignored its instructions {kind=explain at=learning-the-update-rule}

Lichkovski's hypernetwork took the current weights and the next task's identity and was trained to output the weights multitask training would produce. What did the ablations show, and why is the failure also a finding?

::: answer
It ignored the task identity. It had learned a general operator that moves any weight configuration toward the region where multitask solutions lie. Nothing in the loss penalized ignoring the identity, and supervision constrains a model only where training visits. The finding: a learned consolidation step that does not need to know what it consolidates. It is an amortized M-step toward Part 1's trivial solution, retraining on everything.
:::

### Consolidation is an M-step {kind=explain at=consolidation-is-an-m-step}

State the claim. Then give the E-step and M-step for self-distillation fine-tuning, for VPO, and for Doc-to-LoRA.

::: answer
Each consolidation is an EM step split across two stores. A faster store performs the E-step, because it can build a better distribution without changing weights. A slower store performs the M-step, because it can keep the result.

- SDFT: the student's samples rescored by the same model with a demonstration in context; kept in core weights by per-token distillation on the student's prefixes.
- VPO: a set of answers built in context and scored by the max over weightings; kept in core weights by GRPO on the set score.
- Doc-to-LoRA: a document; kept in an adapter written in one pass, an amortized M-step.
:::

### What a mass-covering fit cannot restore {kind=limits at=consolidation-is-an-m-step}

Multi-teacher distillation could fit the student in the mass-covering direction to keep each teacher's alternatives. What does that leave unsolved?

::: answer
The teachers were themselves trained by reinforcement learning on scalar rewards. A mass-covering fit preserves the alternatives a teacher still has. It cannot restore the ones the teacher lost.
:::

### The wrong cut {kind=explain at=a-ladder-of-stores}

Why does the cut between parametric and non-parametric memory fail to predict how a store behaves?

::: answer
The recurrent state is parametric and wiped at the end of every session. Harness memory is non-parametric and permanent. Prediction heads are parametric, are trained toward their own next predictions, and hold a different kind of content: what would happen, not what to do. The four columns of the ladder predict behaviour; the parametric label does not.
:::

### What survives of the case for weights {kind=explain at=what-survives-of-the-argument-for-parametric-memory}

Which argument for changing weights survives, and which two stronger claims does the essay reject?

::: answer
Automaticity survives, as amortization: retrieval degrades as the store grows, context has a ceiling, and consolidation pays once in training for a competence otherwise rebuilt from context each time. Rejected: that knowledge composes only once it is in the weights. Content in context composes into reversals and syllogisms, and the same content trained into weights composes poorly unless the training data spells out the implications. Also rejected: that slow learning signals deep integration. Sample efficiency measures the update rule and the prior.
:::

### The release cycle {kind=explain at=the-release-cycle-is-consolidation-already}

In what sense do the open-weight labs already consolidate, and what two things are missing for it to be continual learning?

::: answer
They train specialist policies and distil them into one checkpoint, with on-policy support because the student generates the states on which the teachers advise. Missing: the specialists are built in parallel from one base, so nothing is learned on top of a previous consolidation's side effects. And no report measures the alternatives within each skill before and after distillation.
:::

### What the benchmarks cannot see {kind=explain at=what-the-benchmarks-can-and-cannot-see}

The matrix $R_{i,j}$ measures forgetting and transfer between tasks. Name three things it misses and the measurement Part 1 asks to add.

::: answer
Whether knowledge acquired at different times can be combined. Revision as distinct from interference (zup now means green, against dax drifting too). Erasure as distinct from lost access, since part of forgetting is a shared shift of representations that can be undone. Part 1 adds the alternatives within a task: report best-of-$k$ or pass@$k$ at large $k$ beside the single-attempt score, before and after each phase.
:::

### The boundary {kind=limits at=the-boundary}

A learner can construct its own teaching conditions: write its own training data, invent its own tasks, pose its own questions. What stays given in each case, and which kind of question escapes?

::: answer
Each works under a condition given one level up: SEAL's reward is accuracy on questions someone wrote, PowerPlay's test for a new task is fixed in advance, OPST's topics are named by people, and novelty is measured in a space of behaviours someone chose. Constructing teaching conditions moves the given condition up a level and does not remove it. Predictive questions escape: a learner can pose them itself and the world grades them for free.
:::
