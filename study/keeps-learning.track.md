---
title: "Across the track: How a model keeps learning"
track: keeps-learning
---

Questions whose answers draw on more than one essay. Attempt each group after the last essay of its stage.

## Continual learning

Questions whose answers draw on more than one essay. Attempt them after the last essay of the stage.

### One formula, four uses {kind=connect}

The exponential tilt $q^*\propto p\,e^{Q/\eta}$ is derived in *How Does a Policy Improve?* Name four places the continual-learning series uses it.

::: answer
- The self-teacher is the bare model tilted by the context's log-ratio at $\eta=1$ ([Part 1](/notes/who-teaches-the-weights.html#the-model-with-privileged-context-as-teacher)).
- A half step of distillation, and iSDFT's per-token budget, are tilts at higher temperature (same section).
- A sequence-level reward preserves the ratios among equally rewarded answers, which a token-level target does not ([Part 1](/notes/who-teaches-the-weights.html#where-self-teaching-breaks)).
- Repeated on-policy improvement lowers the effective temperature to $\eta/k$, which is why alternatives vanish ([Part 1](/notes/who-teaches-the-weights.html#what-on-policy-training-forgets)).
:::

### The roles of in-context learning {kind=connect}

In-context learning does a different job in each part of the trilogy. What are they?

::: answer
Teacher: the model with privileged context supplies the targets (Part 1). Explorer: the model reads its first answer and writes a different second one (Part 1). Library builder: writing answer $i$ after reading the earlier ones performs the step "add the policy that most improves the set" (Part 2). E-step: the context is the fastest store and the best learner on the ladder, and slower stores absorb what it builds (Part 3).
:::

### Nothing outside the support {kind=connect}

Four statements across the track say that what is never produced cannot be learned. Find one in each essay from the policy essay onward, and the reward essay's version.

::: answer
- Reward essay: a robot that never opens the door has no example revealing the $6$.
- Policy essay: regularization toward a prior cannot produce alternatives outside the prior's support.
- Part 1: a strategy the model no longer produces is a strategy nothing can teach it, short of an outside demonstration.
- Part 2: where the behaviour never acts as the target would, the importance ratio is zero and nothing is learned.
- Part 3: a mass-covering fit cannot restore the alternatives a teacher lost.
:::

### The door through three essays {kind=connect}

The delivery problem appears in the reward essay and again in Part 2. What does each use it to show?

::: answer
The reward essay uses it for policy evaluation ($V^\pi(J)=1.675$), for policy iteration (a second greedy step finds the door) and for the policy gradient at the door (estimates $4.5$ and $0$, mean $1.125$). Part 2 asks an off-policy question about it: the return of "approach and open" estimated from a behaviour that mostly does neither, by reweighting ($\lambda=1$) or by bootstrapping ($\lambda=0$), and not at all once the behaviour always takes the detour.
:::

### Where improvement is kept {kind=connect}

Apply the policy essay's four questions to GQ(λ) heads and to self-distillation. Where do they differ?

::: answer
For self-distillation the candidates are the student's samples, the evaluation is the same model with context, the improved distribution is the teacher's conditional, and the improvement is kept in core weights. For GQ(λ) heads the candidates are the behaviour's experience, reweighted toward many target policies, and what is kept is a prediction. No policy is fitted. They differ in the last question: one stores what to do, the other stores what would happen.
:::

## The open frontier

Questions whose answers draw on more than one essay of the stage, and on the continual-learning trilogy where the essays themselves make the link. Attempt them after *How LLMs Could Place Explicit Memories*.

### One selector, three essays {kind=connect}

A selector appears in each essay of the stage. What does each say about it?

::: answer
- [*Every Layer a Store*](/notes/every-layer-a-store.html#selection-is-learned-retrieval): a selector is a second, cheaper store placed in front of the cache. Its choice is a hard top-$k$, so no gradient flows through it, and it brings a new failure, the miss.
- [*Filling the Stores*](/notes/filling-the-stores.html#selectors-cannot-learn-through-top-k): the selector gets a teacher, the attention it replaces. The KL sits behind stop-gradients so that the student does not teach the teacher. Selection has been added at every point from the first token to a released, frozen checkpoint.
- [The memory essay](/notes/how-llms-could-place-explicit-memories.html#who-teaches-the-index): the teacher meets both conditions of *Who Teaches the Weights?* in a clean form. Dense attention has looked at every key, and the student only has to learn where the teacher would look. An indexer that scores every key makes finding the bottleneck, and Latent Sparse Attention replaces the scan with an index. A later weight update would stale that index along with the keys.
:::

### Reading everything hurts {kind=connect}

The first essay calls long context an interference problem. How does the claim return in the second essay and in the third?

::: answer
In [*Every Layer a Store*](/notes/every-layer-a-store.html#long-context-is-an-interference-problem), a longer context puts more keys in competition with the right one. Sharpening the softmax handles random competitors and cannot separate the near-duplicate keys of real text, so a model that accepts a million tokens may still fail to use them. [*Filling the Stores*](/notes/filling-the-stores.html#long-context-comes-late-and-it-comes-cheaply) treats this as a training problem. The longest context arrives late and in a small share of the tokens, and it can leave as fast: self-distillation could erase long-context behaviour, which may be the same interference problem in the weights. The [memory essay](/notes/how-llms-could-place-explicit-memories.html#full-context-is-not-an-upper-bound) finds the problem at both ends of its line. In 2023 it was named the distraction issue and met by training on other documents as negatives. In 2026 full context trails both a trained reader and a distilled sparse attention.
:::

### The recurrent state, from the ladder to the placements {kind=connect}

Follow the delta-rule state from *Where Experience Goes* through this stage. What is it on the ladder? What does the first essay add about how it writes and what it holds? Where does the memory essay put it among the three placements?

::: answer
On the [ladder](/notes/where-experience-goes.html#a-ladder-of-stores) it is the second rung: a fixed-size matrix that every token updates by one error-correcting step, a TD(0) learner with no future to bootstrap from, and parametric continual learning already running inside frontier models. [*Every Layer a Store*](/notes/every-layer-a-store.html#the-recurrent-state-learns-while-it-reads) adds the learned decay before the write, per head in Gated DeltaNet and per channel in KDA, and that the rule buys overwriting, not capacity. In trained hybrids the state holds settings such as language and voice, the cache holds the content, and the state forgets quickly by design. The [memory essay](/notes/how-llms-could-place-explicit-memories.html#where-the-brain-places-memories) calls it a fast form of the third placement, into connections. But the store is bounded, it carries settings and not content, and it ends with the session.
:::

### Written by older weights {kind=connect}

Three things in the track are produced by an older checkpoint and consumed by a newer one: off-policy experience in *Learning About What You Do Not Do*, rollouts in *Filling the Stores*, and cached keys in the memory essay. What is done about each, and where does the parallel break?

::: answer
In [Part 2](/notes/learning-about-what-you-do-not-do.html#learning-off-the-policy) the behaviour policy is an older checkpoint and the target a slightly updated one. A language model's token ratios are exact, but their product over a long episode has enormous variance, so traces are cut. In [*Filling the Stores*](/notes/filling-the-stores.html#what-rl-optimizes-and-how-it-goes-wrong) sampling and learning run at once, and the labs cap the staleness: they discard rollouts past a bound and mask tokens whose ratios leave a band. The [memory essay](/notes/how-llms-could-place-explicit-memories.html#an-off-policy-problem-without-a-ratio) is where the parallel breaks. A stale key has no ratio. It is a vector computed by a function that no longer exists, and reweighting does not change coordinates. The remedies are of another kind: re-encode, tolerate, translate, constrain, or keep keys the model did not compute.
:::

### Consolidation, from the trilogy to the frontier {kind=connect}

The trilogy described consolidation as self-distillation and as an M-step split across two stores, and argued for it by amortization. What does this stage add about consolidation as the labs practise it, and about its worth once reading is cheap?

::: answer
[*Filling the Stores*](/notes/filling-the-stores.html#post-training-edits-the-stores) shows the release cycle's consolidation from the inside. Specialists are distilled on-policy into one checkpoint, cheaply, with students falling below the base model outside the teachers' domains. Self-distillation on a run's own rollouts can copy a policy too exactly and can erase long-context behaviour. It also [repairs a collapsed run](/notes/filling-the-stores.html#what-the-weights-keep), because it copies what the model does and leaves the weights behind. The [memory essay](/notes/how-llms-could-place-explicit-memories.html#consolidation) splits the argument in two. Cheap reading raises the break-even of the amortization case, which is the right account of explicit memories. It leaves untouched what consolidation builds beyond them: representations no retrieved item contains. And a model that consolidates while it keeps a cache [meets stale keys](/notes/how-llms-could-place-explicit-memories.html#staleness-returns): a store written by old weights can undo what consolidation taught the new ones.
:::
