---
title: "Study notes: Learning About What You Do Not Do"
essay: learning-about-what-you-do-not-do
track: keeps-learning
reviewed-against: "d60a682"
requires:
  - {at: how-can-a-reward-train-a-neural-network#values-evaluate-a-particular-policy, for: value functions}
  - {at: how-can-a-reward-train-a-neural-network#learning-values-from-experience, for: "TD errors, bootstrapping, traces, off-policy learning"}
  - {at: how-can-a-reward-train-a-neural-network#from-evaluating-behavior-to-choosing-better-behavior, for: the delivery problem and policy improvement}
  - {at: who-teaches-the-weights#what-on-policy-training-forgets, for: VPO and the collapse of alternatives}
introduces:
  - {term: general value function, at: questions-and-answers, related: ["correctness condition", "schema mechanism", "ladder of stores"]}
  - {term: deadly triad, at: learning-off-the-policy}
  - {term: projected Bellman error and gradient TD, at: learning-off-the-policy}
  - {term: GQ(λ), at: learning-off-the-policy}
  - {term: importance ratio, at: learning-off-the-policy, related: ["stale keys"]}
  - {term: successor features, at: from-many-predictions-to-a-choice}
  - {term: generalized policy improvement, at: from-many-predictions-to-a-choice}
  - {term: set-max policy, at: from-many-predictions-to-a-choice}
  - {term: per-answer weighting, at: vpo-builds-a-library-in-one-response}
  - {term: coverage condition, at: diversity-is-a-coverage-condition, related: ["bandit and exploration"]}
uses:
  - {term: temporal-difference error, from: how-can-a-reward-train-a-neural-network}
  - {term: λ-return and eligibility trace, from: how-can-a-reward-train-a-neural-network}
  - {term: on-policy and off-policy, from: how-can-a-reward-train-a-neural-network}
  - {term: Vector Policy Optimization, from: who-teaches-the-weights}
  - {term: forgetting within a task, from: who-teaches-the-weights}
---

### A question in four functions {kind=recall at=questions-and-answers}

Which four functions specify a general value function? Pose one for a coding agent.

::: answer
A target policy $\pi$ (the behaviour the question is about), a termination function $\beta$ (when to stop counting), a cumulant $r$ (the signal summed along the way) and an outcome $z$ (the signal read at stopping). For example: "If I keep editing and rerunning the suite until it passes or I give up, how many of the twenty tests will pass?" Asked once per test, that is twenty questions. The world's dynamics fix the answer, so the knowledge has a correctness condition the learner does not supply.
:::

### Iterating or descending {kind=explain at=learning-off-the-policy}

Name the three ingredients of the deadly triad. Why can ordinary TD diverge off-policy while gradient TD cannot, when both aim at the same fixed point?

::: answer
Off-policy learning, function approximation and bootstrapping. Ordinary TD iterates: it steps toward $\Pi T^\lambda V_\theta$ and repeats, which converges only if that composition is a contraction. On-policy it is. Off-policy the projection is taken under the behaviour's state distribution and the composition can stretch distances. Gradient TD descends the projected Bellman error, which is smallest at the fixed point whether or not the operator contracts. GQ(λ)'s secondary weights $h$ estimate one factor of a product of expectations, so each step needs one sample.
:::

### The door, off the policy {kind=compute at=learning-off-the-policy}

The behaviour approaches the door half the time and opens it a quarter of the time. Estimate the return of "approach and open" in two ways: by reweighting whole episodes, and by one step followed by bootstrapping. Then let the behaviour always take the detour.

::: answer
The true answer is $0.9\times6=5.4$.

*Whole episodes* ($\lambda=1$): approaching has ratio $1/0.5=2$ and opening $1/0.25=4$; the detour and giving up have ratio $0$. One episode in eight approaches and opens and counts as $2\cdot4\cdot5.4=43.2$. The average is $5.4$, with a standard deviation of $14.3$ per episode.

*Bootstrap* ($\lambda=0$): the door visits that opened give $Q(D,\text{open})=6$. The target for approaching is $0+0.9\sum_a\pi(D,a)Q(D,a)=5.4$, with no ratio: the target policy enters through the expectation at the next state.

If the behaviour never approaches, nothing at the door is observed and no method recovers the $6$.
:::

### Traces are not momentum {kind=distinguish at=learning-off-the-policy}

Both are decayed sums of gradients. What does each pair the gradients with, and what does each change?

::: answer
Momentum carries each step's update forward: $\sum_{k\le t}\mu^{t-k}\delta_k\phi_k$, every gradient paired with its own error. A trace multiplies old gradients by the current error: $\delta_t\sum_{k\le t}\lambda^{t-k}\phi_k$, so each gradient meets the decayed sum of later errors. Momentum changes how fast a solution is reached. $\lambda$ changes which solution is reached.
:::

### Why traces must be cut {kind=compute at=learning-off-the-policy}

Per-token log-ratios between two checkpoints have standard deviation $0.1$, and each ratio averages $1$. What is the variance of the product over $200$ tokens? Over $2{,}000$? What is unusual about importance ratios in a language model, and what is the remedy for length?

::: answer
The variance is $e^{\sigma^2T}-1$: $e^2-1\approx6.4$ at $200$ tokens and $e^{20}\approx5\times10^8$ at $2{,}000$. A language model computes the probability of every token it emits, so the ratio between two versions is exact, where a robot's must be logged or modelled. The remedy is a state-dependent $\lambda_t$ set low where the policies diverge, which cuts the trace and bootstraps from the current prediction. Retrace does this by truncating each ratio at $1$.
:::

### From predictions to a choice {kind=derive at=from-many-predictions-to-a-choice}

Suppose every task's reward is $r_w=w^\top c$ for fixed cumulants $c$. Define successor features, state generalized policy improvement and its guarantee, and say how the set-max policy differs.

::: answer
$\psi^\pi(s,a)=\mathbb E_\pi[\sum_t\gamma^tc_t\mid s,a]$, one general value function per cumulant, so $Q^\pi_w=w^\top\psi^\pi$ and a new task costs one dot product. GPI acts by $\arg\max_a\max_i w^\top\psi^{\pi_i}(s,a)$ over a library of policies. It is at least as good as every library policy on task $w$, up to the error in the learned $\psi$'s, with no learning for the new task. The set-max policy picks one library policy at the initial state and follows it to the end. GPI can switch from state to state and is never worse.
:::

### VPO as a policy library {kind=recall at=vpo-builds-a-library-in-one-response}

Give the successor-feature counterpart of each: a reward component, an answer, an answer's reward vector, the max over the set, writing answer $i$ after reading the earlier ones, test-time search. Why does VPO need no learned predictions?

::: answer
A cumulant; a policy in the library; that policy's successor features at the start state; the set-max value; training the next policy against the library's weakest weighting; GPI's max at deployment. VPO averages over weightings where Zahavy's iteration takes the worst case. At the horizon of one answer the tests compute each reward vector exactly, and GPI coincides with set-max because there is no later state at which to switch.
:::

### The weighting each answer is trained under {kind=compute at=vpo-builds-a-library-in-one-response}

For Part 1's set (specialists $(1,0)$ and $(0,1)$, balanced $(0.6,0.6)$, $w=(u,1-u)$), compute $\bar w_i=\mathbb E_w[w\,\mathbf 1\{w\in C_i\}]$ for each answer.

::: answer
The first specialist is best for $u\ge0.6$: $\bar w_1=\int_{0.6}^{1}(u,\,1-u)\,du=(0.32,\,0.08)$. By symmetry $\bar w_2=(0.08,\,0.32)$. The balanced answer holds $0.4\le u\le0.6$: $\bar w_3=(0.10,\,0.10)$. They sum to $(0.5,0.5)$, the weighting a scalar method would apply to all three. The max splits it by territory.
:::

### Two findings the mapping explains {kind=explain at=vpo-builds-a-library-in-one-response}

Why did writing the weighting into the prompt fail, and why did VPO stop helping on the preference dataset?

::: answer
In the successor-feature construction the policy never sees $w$. Conditioning on $w$ happens in the critic, as one dot product, and GPI selects among unconditioned behaviours. On the preference dataset the five criteria mostly agreed, so five cumulants spanned about one direction and a library of one policy covered every weighting. The rank of the reward vectors measures how large a library a task can use.
:::

### Diversity is a coverage condition {kind=explain at=diversity-is-a-coverage-condition}

GQ(λ) assumes the behaviour policy is "exciting". Use that assumption to say what the collapse of Part 1 costs, and why VPO's value does not depend on test-time search.

::: answer
Exciting means $b(s,a)>0$ everywhere. Where the behaviour never acts as the target would, $\rho_t=0$, the trace is cut and nothing is learned; where it rarely does, the ratio is too large to use. A collapsed model produces no data about its lost alternatives, so no critic, later improvement step or self-distillation trained on its data can learn about them. A reward-diverse model is a better behaviour policy for whatever learning comes next. This is plasticity at the level of behaviour: weights that can still change, attached to a policy that no longer visits the states from which change would be learned.
:::

### Two halves and their shared boundary {kind=explain at=two-halves-of-one-strategy}

How do Horde and VPO each prepare for an unknown objective, what joins them, and where do both stop?

::: answer
Horde predicts: it learns off-policy what many behaviours would achieve, which is knowledge without behaviour. VPO behaves diversely: it keeps competent alternatives alive with no critic, which is behaviour without knowledge. GPI joins them: a library plus successor features meets a new weighting by a max. Both stop at the questions. Someone posed each general value function and wrote down each reward component. The world supplies the answers and not the questions.
:::

### Proposals, not results {kind=limits at=what-gqλ-would-add}

The essay makes three untested proposals. Name them, and the caution about data that passed through a search loop.

::: answer
Per-answer credit from the marginal gain each answer adds to the set, with no critic. A vector critic: linear GQ(λ) heads on frozen hidden states, one per reward component, giving a vector form of the generalized advantage. Continual VPO under drifting weights, with the prediction that a VPO checkpoint recovers best-of-$k$ performance in fewer updates than a GRPO checkpoint. The caution: an answer kept by a max has no known behaviour policy, so off-policy correction applies to the raw samples and not to the survivors.
:::
