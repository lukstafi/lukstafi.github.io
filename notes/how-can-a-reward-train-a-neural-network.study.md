---
title: "Study notes: How Can a Reward Train a Neural Network?"
essay: how-can-a-reward-train-a-neural-network
track: keeps-learning
reviewed-against: "eb169c2"
requires: []
introduces:
  - {term: policy, at: actions-change-the-examples-we-learn-from}
  - {term: Markov state, at: actions-change-the-examples-we-learn-from, related: ["belief state", "macrostate as predictor"]}
  - {term: return and discount factor, at: returns-give-delayed-consequences-a-number, related: ["λ-return and eligibility trace", "general value function"]}
  - {term: state value and action value, at: values-evaluate-a-particular-policy, related: ["general value function", "successor features", "baseline and advantage"]}
  - {term: Bellman expectation equation, at: values-evaluate-a-particular-policy, related: ["policy-improvement argument", "projected Bellman error and gradient TD"]}
  - {term: policy iteration, at: from-evaluating-behavior-to-choosing-better-behavior, related: ["policy-improvement argument", "generalized policy improvement"]}
  - {term: Bellman optimality equations, at: from-evaluating-behavior-to-choosing-better-behavior, related: ["flow conservation"]}
  - {term: temporal-difference error, at: learning-values-from-experience, related: ["delta-rule memory", "GQ(λ)"]}
  - {term: bootstrapping, at: learning-values-from-experience, related: ["deadly triad"]}
  - {term: λ-return and eligibility trace, at: learning-values-from-experience, related: ["generalized advantage estimation", "GQ(λ)"]}
  - {term: on-policy and off-policy, at: learning-values-from-experience, related: ["stale rollout", "teacher and support", "five remedies for stale keys"]}
  - {term: REINFORCE, at: from-one-choice-to-a-complete-journey, related: ["reparameterization trick", "GRPO"]}
  - {term: baseline and advantage, at: better-than-expected-is-more-informative-than-positive, related: ["advantage-weighted regression", "GRPO"]}
  - {term: generalized advantage estimation, at: what-values-and-policy-gradients-make-possible, related: ["GQ(λ)"]}
  - {term: GRPO, at: what-values-and-policy-gradients-make-possible, related: ["Vector Policy Optimization", "forgetting within a task"]}
---

The delivery problem, used by several questions: at the junction $J$ the detour ends the episode with reward $2$; approaching the door gives $0$ and leads to $D$; at the door, opening gives $6$ and giving up gives $0$; $\gamma=0.9$.

### Evaluate a half-hearted policy {kind=compute at=values-evaluate-a-particular-policy}

The policy approaches the door half the time and opens it a quarter of the time. Compute $V^\pi(D)$, $Q^\pi(J,\text{door})$ and $V^\pi(J)$.

::: answer
$V^\pi(D)=0.25\times6=1.5$. $Q^\pi(J,\text{door})=0+0.9\times1.5=1.35$. $V^\pi(J)=0.5\times2+0.5\times1.35=1.675$. The door route holds the best return available, $5.4$, and is still the worse choice under this behavior at the door.
:::

### Why one greedy step is not enough {kind=explain at=from-evaluating-behavior-to-choosing-better-behavior}

Improve the policy above greedily, once. Which route does the new policy take, and why does it miss the best one? What fixes it?

::: answer
The new policy opens at the door ($6>0$) and takes the detour ($2>1.35$), earning $2$. The value $1.35$ assumed the old behavior at the door. Re-evaluating gives $V(D)=6$ and $Q(J,\text{door})=5.4$, and a second greedy step takes the door. Evaluate, improve, repeat is policy iteration: a better later decision changes which earlier decision is right.
:::

### Where the max sits {kind=explain at=from-evaluating-behavior-to-choosing-better-behavior}

In $Q^*(s,a)=\mathbb E[r+\gamma\max_b Q^*(s',b)\mid s,a]$, why is the max inside the expectation?

::: answer
The agent chooses actions; it does not choose which random outcome the environment produces. Its action value must average over that randomness. At the next state it can respond to what actually happened, so the max is taken there, after the outcome is known.
:::

### Two parameters, two jobs {kind=distinguish at=learning-values-from-experience}

What does $\gamma$ set, and what does $\lambda$ set?

::: answer
$\gamma$ is part of the objective: how much later rewards count. $\lambda$ is part of the estimator: how observed rewards and value predictions are mixed to estimate that objective. Every target in the $\lambda$ mixture estimates the same $\gamma$-discounted return. Lowering $\lambda$ leans on the value estimates (bias) instead of long sampled outcomes (variance).
:::

### A gradient without the world's derivative {kind=derive at=a-gradient-for-a-sampled-choice}

A sampled reward has no label for the correct action, and the environment cannot be differentiated. Derive an estimator of $\nabla_\theta\,\mathbb E[r]$ that needs neither.

::: answer
Use $\nabla_\theta\pi_\theta(a)=\pi_\theta(a)\nabla_\theta\log\pi_\theta(a)$. Then $\nabla_\theta\sum_a\pi_\theta(a)\bar r(a)=\mathbb E_{a\sim\pi_\theta}[r\,\nabla_\theta\log\pi_\theta(a)]$, so the sampled reward times the gradient of the sampled action's log-probability is an unbiased estimate. For a whole episode the log-probability of the trajectory is a sum, and the environment's terms do not depend on $\theta$, so only the actions' log-probabilities remain. The environment still decides which trajectories are sampled.
:::

### One sample at the door {kind=compute at=better-than-expected-is-more-informative-than-positive}

At the door, opening has probability $p=\sigma(\theta)=0.25$. Give the two possible single-sample gradient estimates and their mean. Repeat with the baseline $1.5$.

::: answer
The log-probability derivatives are $1-p=0.75$ for opening and $-p=-0.25$ for giving up. Without a baseline the estimates are $6\times0.75=4.5$ and $0$, with mean $0.25\times4.5=1.125=6p(1-p)$. With the baseline they are $4.5\times0.75=3.375$ and $(-1.5)\times(-0.25)=0.375$, with the same mean. Both outcomes now push toward opening, and the two estimates are closer together.
:::

### Why a baseline is free {kind=derive at=better-than-expected-is-more-informative-than-positive}

Show that subtracting $b(s)$ from the return leaves the expected gradient unchanged.

::: answer
$\sum_a\pi_\theta(a\mid s)\nabla_\theta\log\pi_\theta(a\mid s)=\nabla_\theta\sum_a\pi_\theta(a\mid s)=\nabla_\theta 1=0$. A baseline that does not depend on the sampled action multiplies this zero. Using $\hat V(s)$ as the baseline turns the weight into an estimate of the advantage $Q^\pi(s,a)-V^\pi(s)$.
:::

### Stored, replayed, off-policy, offline {kind=distinguish at=learning-values-from-experience}

Which of these make learning off-policy: storing a trajectory to compute its targets, a replay buffer, a fixed dataset, reusing a batch after one policy update?

::: answer
Off-policy means learning about a policy other than the one that generated the data. Storing a trajectory does not do that by itself. A replay buffer usually does, because it holds data from older policies. Offline RL learns from a fixed dataset with no new collection, so it is off-policy for any policy that differs from the dataset's. Reusing an on-policy batch after the update is off-policy, and the unbiased-gradient reading no longer holds.
:::

### What no estimator recovers {kind=limits at=learning-values-from-experience}

The robot always takes the detour. What can it learn about the door?

::: answer
Nothing from its own data: no example reveals the reward of $6$. A network may generalize from related situations, but its prediction about an untried action can be wrong. Exploration decides which predictions get tested. Part 2 of the continual-learning series returns to this as a coverage condition.
:::
