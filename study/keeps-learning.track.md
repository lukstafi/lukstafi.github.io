---
title: "Across the track: How a model keeps learning"
track: keeps-learning
stage: continual-learning
---

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
