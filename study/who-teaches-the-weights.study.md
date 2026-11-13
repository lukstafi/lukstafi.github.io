---
title: "Study notes: Who Teaches the Weights?"
essay: who-teaches-the-weights
track: keeps-learning
reviewed-against: "159bde0"
requires:
  - {at: how-can-a-reward-train-a-neural-network#actions-change-the-examples-we-learn-from, for: why acting changes the training data}
  - {at: how-does-a-policy-improve#improving-a-distribution-without-throwing-away-the-prior, for: the tilt and the two directions of KL}
  - {at: how-does-a-policy-improve#mpo-separates-improvement-from-fitting, for: improvement and fitting as separate jobs}
introduces:
  - {term: teacher and support, at: where-the-model-trains-and-what-it-imitates}
  - {term: self-distillation with privileged context, at: the-model-with-privileged-context-as-teacher}
  - {term: implicit value of a context, at: the-model-with-privileged-context-as-teacher}
  - {term: forgetting within a task, at: what-on-policy-training-forgets}
  - {term: Vector Policy Optimization, at: what-on-policy-training-forgets}
  - {term: two conditions on a teacher, gloss: "it must know more than the student, and its targets must be ones the student can absorb"}
  - {term: usable information, at: the-model-with-privileged-context-as-teacher}
  - {term: moving teacher and fixed anchor, at: where-the-model-trains-and-what-it-imitates}
uses:
  - {term: exponential tilt, from: how-does-a-policy-improve}
  - {term: mass-covering and mode-seeking KL, from: how-does-a-policy-improve}
  - {term: on-policy and off-policy, from: how-can-a-reward-train-a-neural-network}
  - {term: GRPO, from: how-can-a-reward-train-a-neural-network}
---

### What the ablations isolate {kind=explain}

*Retaining by Doing* found that supervised fine-tuning on a stronger model's solutions damaged other skills and GRPO did not. Which two further experiments show what was responsible?

::: answer
Removing GRPO's penalty toward the original model mostly did not bring the forgetting back, so the penalty was not the cause. Supervised fine-tuning that regenerated its examples from the current model each epoch forgot little or nothing. Where the data comes from mattered more than the algorithm.
:::

### Teacher and support {kind=distinguish at=where-the-model-trains-and-what-it-imitates}

The stability term is $\lambda\,\mathbb E_{x\sim\mu}D(q(\cdot\mid x)\,\|\,p_\theta(\cdot\mid x))$. Say what $q$ and $\mu$ are, then give both for Learning without Forgetting, Dark Experience Replay, a moving-average teacher, on-policy distillation and EWC.

::: answer
The teacher $q$ is what the model is pulled toward. The support $\mu$ is the set of inputs on which it is pulled.

- Learning without Forgetting: the old model, on the new task's inputs.
- Dark Experience Replay: the old model's stored logits, on stored old inputs.
- Moving average: a fresh copy of the student, on current inputs.
- On-policy distillation: any teacher, on whatever the student generates.
- EWC: the old model on the old inputs, compressed into one Fisher number per weight.
:::

### A moving-average teacher {kind=compute at=where-the-model-trains-and-what-it-imitates}

A teacher averages the student's weights with momentum $0.999$. What share of it comes from student states older than $1{,}000$ steps? Older than $5{,}000$? What follows?

::: answer
$0.999^{1000}\approx0.37$ and $0.999^{5000}\approx0.007$. The teacher is the only reference and it moves with the student, so many small agreed steps can add up to any distance from the base model. The repair is a second reference that never moves: a frozen copy of the base model.
:::

### The self-teacher is a tilt {kind=derive at=the-model-with-privileged-context-as-teacher}

Show that the model with privileged context $c$ is an exponential tilt of the bare model, and say what plays the critic.

::: answer
Take the reference $p=\pi(\cdot\mid x)$ and the value $Q_c(y)=\log\frac{\pi(y\mid x,c)}{\pi(y\mid x)}$. At $\eta=1$ the tilt $p\,e^{Q_c}/Z$ is $\pi(\cdot\mid x,c)$ with $Z=1$. The context is the critic and its scores are log-ratios. A response's log-probability is a sum over tokens, so $Q_c$ is too: each token carries a dense implicit reward.
:::

### A demonstration as a critic {kind=compute at=the-model-with-privileged-context-as-teacher}

At some prefix the bare model gives three continuations $(0.6,0.3,0.1)$ and the model with a demonstration gives $(0.1,0.2,0.7)$. Compute the implicit values and the half step between student and teacher. At what temperature is the half step a tilt?

::: answer
The log-ratios are $(-1.79,\,-0.41,\,+1.95)$. The half step is the normalized geometric mean: $(\sqrt{0.06},\sqrt{0.06},\sqrt{0.07})$ normalized, about $(0.325,\,0.325,\,0.351)$. The interpolation $p^{1-\lambda}T^{\lambda}$ equals $p\,e^{\lambda Q_c}$ up to normalization, so $\lambda=1/2$ is a tilt at $\eta=2$.
:::

### Why the model with context can teach {kind=explain at=the-model-with-privileged-context-as-teacher}

A teacher must know more than the student, and its targets must be ones the student can absorb. How does the model with context meet both?

::: answer
It knows more because in-context learning generalizes where fine-tuning does not: with a fact in view, the model answers reversals and syllogisms that the same fact trained into the weights does not support. Its targets are absorbable because they come from the student's own distribution. Nothing is created: the context's implications were latent, and the teacher exposes them in a form a gradient step can use.
:::

### Grounded and ungrounded self-teaching {kind=explain at=the-model-with-privileged-context-as-teacher}

When the model writes its own privileged context, why does a wrong hint do less damage as the teacher's context than as a fine-tuning target?

::: answer
The tilt moves the teacher only as far as the model finds the hint plausible, so a wrong hint weakens the signal more than it reverses it. As a fine-tuning target the wrong answer is trained on directly. The agreement filter is a weak grounding: it makes the teacher as reliable as what the model already knows, and consistent errors still enter training.
:::

### Dense targets reorder the correct answers {kind=derive at=where-self-teaching-breaks}

Why does a sequence-level reward leave the student's preferences among correct answers alone, when a token-level self-teacher does not?

::: answer
Tilting by a sequence-level reward gives $q(y)\propto p(y)e^{R(y)/\eta}$, so $q(y)/q(y')=p(y)/p(y')$ whenever $R(y)=R(y')$. Only the boundary between correct and incorrect moves. The implicit value $Q_c$ is not constant on the correct answers: it ranks them by resemblance to the context's exemplar, in phrasing, format and order of steps. The student is reordered toward one exemplar at every prefix, and the next round's teacher inherits the quirks.
:::

### Small differences become total {kind=compute at=what-on-policy-training-forgets}

Two strategies differ in scalar reward by $0.1$. After ten improvement steps at $\eta=0.1$, each using the previous iterate as reference, by what factor have the odds moved? What bounds this?

::: answer
After $k$ steps the policy is the original tilted by $kR/\eta$, an effective temperature of $\eta/k$. The odds move by $e^{0.1\times10/0.1}=e^{10}\approx22{,}000$. A KL penalty toward a fixed reference with coefficient $\beta$ keeps the effective temperature from falling below $\beta$. In practice $\beta$ is small or the penalty is dropped.
:::

### The max rewards specialists {kind=compute at=what-on-policy-training-forgets}

Rewards have two components and weightings are $w=(u,1-u)$ with $u$ uniform on $[0,1]$. A balanced answer scores $(0.6,0.6)$; two specialists score $(1,0)$ and $(0,1)$. Compute VPO's set score for three balanced copies and for the two specialists with one balanced answer. What would the fixed weighting $(0.5,0.5)$ prefer?

::: answer
Three copies score $0.6$ under every weighting. The mixed set scores $\max(u,\,1-u,\,0.6)$: integrating, $0.32$ from $u\le0.4$, $0.12$ from the middle and $0.32$ from $u\ge0.6$, in total $0.76$. Under the fixed weighting the balanced answer is worth $0.6$ and each specialist $0.5$, so scalar training pushes every sample toward the balanced answer.
:::

### Each half of VPO fails alone {kind=explain at=what-on-policy-training-forgets}

VPO writes several answers in one response and scores the set by a max over random weightings. What happened with several answers and a scalar reward? With the weighting written into the prompt? Where does the diversity come from?

::: answer
Several answers under a scalar reward had the capacity to differ and no reason to: their reward vectors converged. A model given $w$ in its prompt learned to ignore it and collapsed to one behaviour. Under the max, similar answers compete for the same weightings and one is wasted. The model cannot turn a weight vector into a strategy, and it can read its first answer and write a different second one. In-context learning is the explorer here, as it was the teacher earlier.
:::

### Two kinds of forgetting {kind=explain at=what-on-policy-training-forgets}

Name the two kinds. Why is the second a loss of plasticity even if every weight can still change?

::: answer
Across tasks: learning the new thing damages old skills. Within the task: alternatives the model could once produce stop appearing. Policy-gradient methods raise the probability only of what the model sometimes does, and off-policy methods need data in which a behaviour appears. A strategy the model no longer produces cannot be taught to it short of an outside demonstration.
:::

### Result or conjecture {kind=limits at=what-on-policy-training-forgets}

Which two claims does the essay mark as untested?

::: answer
That a self-teacher conditioned on a negative example passes the failure on (an open question raised by *Negation Neglect*). That diversity along known reward axes helps transfer to a reward not yet known (Bahlous-Boldi's reply to the objection that the future reward vector is unavailable).
:::
