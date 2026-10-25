---
title: "Learning About What You Do Not Do"
subtitle: "Continual learning, part 2: GQ(λ), Horde, successor features, and Vector Policy Optimization"
author: "Łukasz Stafiniak and Claude (Anthropic)"
date: 2026-10-21
header-includes:
  - |
    <style>
    .katex-display { overflow-x: auto; overflow-y: hidden; padding: 0.3em 0; }
    .katex-display > .katex { width: max-content; min-width: 100%; }
    article table { display: block; max-width: 100%; overflow-x: auto; }
    </style>
---

*This is the second of three parts on continual learning. [Part 1](https://lukstafi.github.io/notes/who-teaches-the-weights.html) ended on a need that neither self-distillation nor on-policy training meets: learning about behaviour the model is not currently producing. This part follows an older tradition built around that need and joins it to a recent method for language models. [Part 3](https://lukstafi.github.io/notes/where-experience-goes.html) places these methods on a ladder of memory stores. The reinforcement-learning background, from value functions to eligibility traces, is in [How Can a Reward Train a Neural Network?](https://lukstafi.github.io/notes/how-can-a-reward-train-a-neural-network.html), cited below as the reward essay.*

The phrase "continual learning" came from reinforcement learning: Mark Ring's 1994 dissertation was *Continual Learning in Reinforcement Environments*. Ring pictured an agent that accumulates skills over an unbounded stream of experience, each built on the ones before. The language-model literature narrowed the phrase, mostly to the problem of not forgetting. The older tradition kept a broader question: what should an agent learn from one stream of experience, so that it is ready for tasks it has not met?

Between 2008 and 2011, Richard Sutton's group at the University of Alberta gave one answer. An agent should learn many predictions at once, each about the consequences of some way of behaving, including ways it is not currently behaving. Hamid Maei and Sutton's [GQ(λ)](https://doi.org/10.2991/agi.2010.22) (2010) made this workable, and the [Horde](http://incompleteideas.net/papers/horde-aamas-11.pdf) architecture (2011) put it to use. Horde's paper names Gary Drescher's *Made-Up Minds* (1991) among its precursors. In 2013, [writing notes on Drescher](https://lukstafi.github.io/notes/drescher-made-up-minds.html)'s schema mechanism, I thought it "would be cool to redo Gary Drescher's project, but using Rich Sutton and Hamid Maei's recent results — Gradient Temporal-Difference Algorithms with off-policy learning — instead of schemas". This part is partly that old wish, redirected to language models.

The claim is this. [Vector Policy Optimization](https://arxiv.org/abs/2605.22817) (VPO), the method Part 1 introduced, optimizes the objective that the successor-features literature arrived at for transfer between tasks: a set of behaviours whose best member is good under any weighting of the reward's components. VPO works at the horizon of one response, where every answer is scored exactly, so it needs no predictions. GQ(λ) makes the same objective available when the horizon is long and the data comes from behaviour other than the current policy. The two lines are halves of one strategy for a learner facing objectives it does not yet know. It can behave diversely, which is VPO's half, or predict what each behaviour would achieve, which is Horde's half. An operation called generalized policy improvement joins the halves.

## Questions and answers

A [value function](https://lukstafi.github.io/notes/how-can-a-reward-train-a-neural-network.html#values-evaluate-a-particular-policy) answers a question: if the agent follows policy $\pi$ from here on, how much reward will it collect? Horde started from the observation that nothing in this question needs to be about reward. Any signal the agent receives can stand in for the reward, and any rule for when to stop counting can stand in for the end of an episode. A **general value function** (GVF) is the answer to a question specified by four functions:

- a **target policy** $\pi$, the behaviour the question is about;
- a **termination function** $\beta$, giving the probability of stopping in each state;
- a **cumulant** $r$, the signal summed along the way;
- an **outcome** $z$, the signal read off at the moment of stopping.

The question is then "if I followed $\pi$ until $\beta$ said stop, what would the sum of $r$ plus the final $z$ be?". The Horde paper's examples come from a small mobile robot. "If I keep moving, I will bump into something within a few seconds." "If I follow this wall as long as I can, will my light sensor then have a high reading?" Each question has a precise answer, the expected value under the world's actual dynamics. In the paper's words: "The approximate value function is the knowledge, and its match to the value function—to the actual future reward—defines what it means for the knowledge to be accurate."

This is a semantics for knowledge whose correctness condition the world supplies, not the learner. In the terms of [The Given and the Found](https://lukstafi.github.io/notes/the-given-and-the-found.html), every GVF has a given correctness condition, even when the learner chose the question.

Horde ran many such learners, called demons, in parallel on one robot. They shared one stream of sensor readings, one set of features and one behaviour policy, and each learned the answer to its own question. The paper reports running "thousands of demons using billions of binary features of which a few thousand were active at a time, using laptop computers."

The questions translate readily to language-model agents. A coding agent can ask: "If I keep editing and rerunning the suite until it passes or I give up, how many of the twenty tests will pass?" It can also ask that question once per test, which gives twenty GVFs instead of one. "If I keep using this tool for the rest of the episode, will the user's request succeed?" "If I continue this answer to its end, will its citation of the second document be correct?" Each has a target policy, a stopping rule and a signal to predict. A learned answer is computed from features $\phi$ of the current state, and for a language model these can be its own hidden states.

## Learning off the policy

Every one of those questions is about a behaviour that the agent is mostly not following. A wandering robot sees wall-following only in fragments, a few steps at a time. Learning about a target policy $\pi$ from data generated by a different behaviour policy $b$ is **off-policy** learning, which the [reward essay](https://lukstafi.github.io/notes/how-can-a-reward-train-a-neural-network.html#learning-values-from-experience) distinguished from merely reusing stored data. Learning only on-policy would mean waiting for the rare occasions on which the behaviour matched the question all the way to termination. Learning from fragments makes Horde "massively parallel", since every demon learns from every step.

The difficulty is that off-policy learning combined with function approximation and [bootstrapping](https://lukstafi.github.io/notes/how-can-a-reward-train-a-neural-network.html#learning-values-from-experience) (updating a prediction toward another prediction) can diverge. [Sutton and Barto](http://incompleteideas.net/book/the-book-2nd.html) call this combination the deadly triad. Function approximation means that one set of weights, read through features, serves every state, so an update made at one state moves the predictions at others. [Leemon Baird's 1995 counterexample](https://doi.org/10.1016/B978-1-55860-377-6.50013-X) showed off-policy temporal-difference learning with a linear approximator driving its weights to infinity. Q-learning, the most widely used off-policy algorithm, has the same weakness.

Off-policy methods that did come with guarantees paid for them. Tabular methods keep a separate number for every state, which works only when the states can be enumerated. Averagers, such as state aggregation or nearest-neighbour smoothing, generalize by averaging stored values with fixed weights. [Geoffrey Gordon showed in 1995](https://doi.org/10.1016/B978-1-55860-377-6.50040-2) that they cannot diverge, but the similarity that sets their weights is chosen in advance, not learned. Least-squares methods solve for the predictions directly but cost time quadratic in the number of features at every step. Importance-weighting whole episodes converges, but with a variance that grows with episode length.

The [gradient temporal-difference methods](https://doi.org/10.1145/1553374.1553501) of Sutton, Maei, Szepesvári and colleagues (2008–2009) were the first to be stable off-policy with linear function approximation at a per-step cost linear in the number of features. Ordinary temporal-difference learning is not gradient descent on any objective, which is why it can wander off. The gradient methods choose an objective and descend it. The objective, the projected Bellman error, measures how far the current predictions are from their own one-step-ahead targets, counting only the directions the features can represent. GQ(λ) extended this to action values, eligibility traces and the four-function questions above.

> **Iterating to a fixed point, or descending to it.** The projected Bellman error is zero where $V_\theta=\Pi T^\lambda V_\theta$: apply the $\lambda$-Bellman operator $T^\lambda$, project the result back onto what the features can represent, and land where you started. The true value function usually lies outside the features' reach, so this projected fixed point is the target of ordinary and gradient TD learning alike. They reach it differently.
>
> - *Ordinary TD iterates.* It steps toward $\Pi T^\lambda V_\theta$ and repeats. This converges only if $\Pi T^\lambda$ is a contraction. On-policy it is, because $\Pi$ projects under the policy's own state distribution. Off-policy, $\Pi$ projects under the behaviour's distribution. The composition can then stretch distances instead of shrinking them, and iteration diverges although the fixed point exists.
> - *Gradient TD descends.* It minimizes how far the fixed-point equation is from holding. That residual is smallest at the fixed point whether or not the operator contracts.
>
> The descent has one practical obstacle. The gradient of the projected Bellman error contains a product of expectations, and multiplying two quantities estimated from the same sample biases the product by their covariance. GQ(λ) learns part of the product separately, as the secondary weights $h$ below, so each step needs only one sample. [Shen and colleagues](https://arxiv.org/abs/2609.16222) (2026) prove the general form of the first bullet for any objective with a stopped gradient: its stationary points are the fixed points of its target, and its update need not be the gradient of anything.

The updates are short enough to state in full. Write $\phi_t$ for the features of the state and action at time $t$, and $\bar\phi_{t+1}=\sum_a\pi(s_{t+1},a)\,\phi(s_{t+1},a)$ for the features expected under the target policy at the next state. The prediction is linear, $\theta^\top\phi$. Each step computes a temporal-difference error and an importance ratio,

$$
\delta_t=r_{t+1}+\beta_{t+1}z_{t+1}+(1-\beta_{t+1})\,\theta_t^\top\bar\phi_{t+1}-\theta_t^\top\phi_t,
\qquad
\rho_t=\frac{\pi(s_t,a_t)}{b(s_t,a_t)},
$$

updates an eligibility trace,

$$
e_t=\phi_t+(1-\beta_t)\,\lambda_t\,\rho_t\,e_{t-1},
$$

and then two weight vectors:

$$
\begin{aligned}
\theta_{t+1}&=\theta_t+\alpha_\theta\big[\delta_t e_t-(1-\beta_{t+1})(1-\lambda_{t+1})\,(h_t^\top e_t)\,\bar\phi_{t+1}\big],\\
h_{t+1}&=h_t+\alpha_h\big[\delta_t e_t-(h_t^\top\phi_t)\,\phi_t\big].
\end{aligned}
$$

(The paper calls the secondary vector $w$; it is $h$ here because $w$ will soon mean something else.)

Each piece has a job.

- The **TD error** $\delta_t$ compares the current prediction with what happened next: the cumulant received, the outcome if the question terminated, and otherwise the prediction at the next state under the target policy.
- The [**eligibility trace**](https://lukstafi.github.io/notes/how-can-a-reward-train-a-neural-network.html#learning-values-from-experience) $e_t$ remembers which recent features deserve credit for the current error. Its decay rate $\lambda_t$ may depend on the state. With $\lambda=1$ the method uses the full observed outcome, as Monte Carlo does; with $\lambda=0$ it trusts the next prediction instead.
- The **importance ratio** $\rho_t$ reweights each step by how much more or less likely the target policy was to take the action that the behaviour actually took. Where the target would never have taken that action, $\rho_t=0$ and the trace is cut.
- The **secondary weights** $h$ learn to predict the TD error from the features. The correction term in the update of $\theta$ uses that estimate to remove the part of the step that would chase the learner's own moving target. This is what turns the update into a true gradient and secures convergence.

> **Traces are not momentum.** The prediction $\theta^\top\phi_t$ is linear, so its gradient is $\phi_t$, and the trace is a decayed sum of recent prediction gradients. Momentum in stochastic gradient descent is also a decayed sum of gradients, but it pairs them with errors differently. Take the on-policy case with a constant $\lambda$ and no termination, so the trace decays by $\lambda$ per step. Momentum carries each step's update, made with that step's own error, forward in time:
>
> $$
> \text{momentum: }\sum_{k\le t}\mu^{t-k}\,\delta_k\,\phi_k,
> \qquad
> \text{trace: }\delta_t\sum_{k\le t}\lambda^{t-k}\,\phi_k.
> $$
>
> A trace multiplies the old gradients by the current error. Summed over an episode, momentum only scales each step's own update, by about $1/(1-\mu)$. The trace pairs each gradient $\phi_k$ with the decayed sum of *later* errors, $\sum_{t\ge k}\lambda^{t-k}\delta_t$, which is the gap between the $\lambda$-return and the prediction. Momentum changes how fast a solution is reached; $\lambda$ changes which solution is reached. Cutting a trace, as in worked example E below, stops later errors from reaching earlier predictions.

GQ(λ) converges with probability one, off-policy, with linear function approximation. Two conditions matter later. The behaviour policy must be "exciting", $b(s,a)>0$ for every state and action, so that every action the target might take is sometimes taken. And the target and behaviour policies are held fixed while the learner converges. Maei and Sutton described the aim as "a universal prediction learning algorithm suitable for learning experientially grounded knowledge of the world."

The [reward essay](https://lukstafi.github.io/notes/how-can-a-reward-train-a-neural-network.html#from-evaluating-behavior-to-choosing-better-behavior) already contained the problem in miniature.

> **Worked example D: the door, off the policy.** That essay's delivery robot reaches a junction. It can take a detour, which ends the episode with reward $2$, or approach a door, with reward $0$. At the door it can open it, with reward $6$, or give up, with reward $0$; the discount is $\gamma=0.9$. The behaviour policy approaches the door half the time and, once there, opens it a quarter of the time. Ask a question about a different policy: if the robot approached the door and opened it, what would the return be? The answer is $0.9\times 6=5.4$.
>
> *All observed returns, reweighted* ($\lambda=1$). Weight each episode by the product of its ratios $\pi/b$. Approaching has ratio $1/0.5=2$, opening has ratio $1/0.25=4$, and the detour and giving up have ratio $0$. One episode in eight approaches and opens, and its weighted return is $2\cdot 4\cdot 5.4=43.2$. Every other episode counts as $0$. The average is $\tfrac18\cdot 43.2=5.4$, which is correct, with a standard deviation of $14.3$ per episode.
>
> *One step, then bootstrap* ($\lambda=0$). Estimate the action value of opening, $Q(D,\text{open})$, from the quarter of door visits that happened to open: it is $6$. The target for approaching is then $0+0.9\sum_a\pi(D,a)\,Q(D,a)=0.9\cdot 6=5.4$. No ratio appears. The update concerns the action actually taken at the junction, and the target policy enters only through the expectation at the next state, which is what $\bar\phi_{t+1}$ computes in GQ(λ). The price is dependence on the estimate of $Q(D,\text{open})$.
>
> GQ(λ) interpolates between these two estimators, and the ratios enter only through the trace. Now take the policy that the earlier essay reached after one step of policy iteration, which always takes the detour. That essay remarked that evaluating its door action "asks a counterfactual question even when $\pi_1$ always takes the detour". As a behaviour policy, $\pi_1$ never reaches the door: $b(J,\text{door})=0$, nothing at the door is ever observed, and no off-policy method can recover the $6$. The essay saw this too: "If it never opens the door, its dataset may contain no example revealing the reward of $6$."

The importance ratio is where language models are unusual. In robotics the behaviour policy's probabilities have to be logged or modelled. A language model computes the probability of every token it emits, so for any two versions of a model, the ratio at each token is exact. The trouble is length. A ratio enters the trace multiplicatively at every step.

> **Worked example E: why traces must be cut.** Let the behaviour policy be an older checkpoint and the target a slightly updated one. Model the per-token log-ratio $\log\rho_t$ as noise with standard deviation $\sigma=0.1$, with its mean set so that each ratio averages exactly 1 under the behaviour, as importance ratios must. The product of $T$ such ratios still averages 1, but its variance is $e^{\sigma^2 T}-1$. For a response of 200 tokens that is $e^{2}-1\approx 6.4$, which is tolerable. For an agentic episode of 2,000 tokens it is $e^{20}\approx 5\times 10^{8}$. Almost every trace then carries a product near zero, and the average is held at 1 by rare traces with enormous weights. GQ(λ)'s state-dependent $\lambda_t$ is the lever. Setting $\lambda_t$ low where the policies diverge cuts the trace there, and the update bootstraps from the current prediction instead. Later algorithms such as [Retrace](https://arxiv.org/abs/1606.02647) (Munos and colleagues, 2016) made the cut automatic by truncating each ratio at 1.

## From many predictions to a choice

Horde's demons were mostly predictors. The step from predictions to behaviour came through a different route, at DeepMind, a few years later.

Suppose the reward of every task the agent might face is a weighted sum of a fixed set of cumulants $c\in\mathbb R^d$: $r_w=w^\top c$. The tasks differ only in the weights. Then the value of any policy $\pi$ under any task $w$ splits into two factors,

$$
Q^\pi_w(s,a)=w^\top\psi^\pi(s,a),\qquad
\psi^\pi(s,a)=\mathbb E_\pi\Big[\sum_t\gamma^t c_t\,\Big|\,s,a\Big].
$$

The vector $\psi^\pi$ collects the **successor features** of $\pi$: one general value function per cumulant, all with the same target policy. [Barreto and colleagues](https://arxiv.org/abs/1606.05312) introduced the decomposition in 2017, generalizing [Peter Dayan's successor representation](https://doi.org/10.1162/neco.1993.5.4.613) (1993). Once $\psi^\pi$ is learned, evaluating $\pi$ on a new task costs one dot product. Successor features sit between a value function and a [world model](https://lukstafi.github.io/notes/how-does-a-policy-improve.html#the-different-jobs-of-a-world-model): they predict future cumulants instead of next states, and only under one policy.

The second half of their proposal was **generalized policy improvement** (GPI). Take a library of policies $\pi_1,\dots,\pi_m$ with their successor features. Faced with a task $w$, act by

$$
\pi_{\text{GPI}}(s)\in\arg\max_a\,\max_i\,w^\top\psi^{\pi_i}(s,a).
$$

Their theorem guarantees that this policy is at least as good as every policy in the library on task $w$, up to a term proportional to the error in the learned $\psi$'s. No learning is needed for the new task. Ordinary [policy improvement](https://lukstafi.github.io/notes/how-does-a-policy-improve.html#evaluating-a-policy-and-improving-it), the step at the heart of Q-learning, takes a max over actions under one policy's values. GPI takes a max over actions and over policies. It can also switch between library policies from state to state, following whichever one looks best from where the agent now stands.

A cruder composition commits at the start: pick the one library policy with the highest value for $w$ at the initial state, and follow it to the end. [Zahavy, Barreto and colleagues](https://arxiv.org/abs/2102.04323) called this the **set-max policy**. Its value is

$$
\max_i\,w^\top\psi^{\pi_i}(s_0).
$$

GPI is never worse than it. Their 2021 paper asked which library to build. Their answer was an iteration that adds one policy at a time, each chosen to raise the worst-case value of the set-max policy over all weightings $w$. They proved that the worst-case value strictly improves at each step until no new policy can raise it. In a grid world and in simulated locomotion, the policies the iteration discovered were visibly diverse: different routes and different gaits. Diversity was not the objective. It followed from asking the set to be good under every weighting. [Alegre, Bazzan and da Silva](https://arxiv.org/abs/2206.11326) (2022) gave a related construction, optimistic linear support, which picks the weightings to train on so that, with exact learning, GPI over the library becomes optimal for every $w$.

## VPO builds a library in one response

Set the two lines side by side.

| Vector Policy Optimization | Successor features and GPI |
| --- | --- |
| reward component $r_j(x,y)$ | cumulant $c_j$, one GVF per component |
| answer $y_i$ in the response | policy $\pi_i$ in the library |
| reward vector $r(x,y_i)$ | successor features $\psi^{\pi_i}(s_0)$ |
| $\max_{y\in S}\,w^\top r(x,y)$ | set-max value $\max_i\,w^\top\psi^{\pi_i}(s_0)$ |
| average over $w$ drawn uniformly from the simplex | worst case over $w$ (Zahavy et al.); chosen corner weightings (Alegre et al.) |
| answer $i$ written after reading answers $1,\dots,i-1$ | next policy trained against the current library's weakest weighting |
| test-time search picks the best candidate | GPI's max at deployment |

VPO's objective, $\mathbb E_w[\max_{y\in S}w^\top r(x,y)]$, is the average-case version of the set-max objective, for a library of $m$ policies whose horizon is one answer. At that horizon successor features need no learning. Each "policy" is a single answer, and its successor features are just its reward vector, computed exactly by running the tests. GPI and the set-max policy coincide, because there is no later state at which to switch. What remains is the question Zahavy's iteration answered: which set to build.

Two differences are worth noticing, and both favour VPO in its setting. First, VPO builds the library inside one response. Zahavy's iteration trains a new policy for each addition, on the weighting under which the current library does worst. VPO's second answer is written by the same network after reading the first. The step "add the policy that most improves the set" is performed by in-context learning. Second, VPO averages over weightings instead of taking the worst case. That suits a deployment in which test-time search will select under one particular weighting and the training signal should reward broad coverage, not insurance against the least favourable task.

The max in VPO's objective does more than reward coverage. It assigns each answer its own objective. Write $C_i$ for the set of weightings under which answer $i$ is the best in its set. Away from ties, the first-order effect of improving answer $i$'s reward vector by a small $\delta$ is

$$
\frac{\partial R}{\partial r_i}\cdot\delta=\bar w_i^\top\delta,
\qquad
\bar w_i=\mathbb E_w\big[w\,\mathbf 1\{w\in C_i\}\big]=P(C_i)\,\mathbb E[w\mid C_i].
$$

The cells partition the simplex, so the per-answer weightings add up to the average weighting, $\sum_i\bar w_i=\mathbb E[w]$. Under the uniform distribution that average is exactly the uniform weighting a scalar method would use. VPO splits that weighting among the answers, giving each the part of the simplex where it is responsible for the set's score.

> **Worked example F: the weighting each answer is trained under.** Part 1's set had two specialists, $(1,0)$ and $(0,1)$, and a balanced answer, $(0.6,0.6)$, with weightings $w=(u,1-u)$ for $u$ uniform. The first specialist is best for $u\ge0.6$, the second for $u\le0.4$, and the balanced answer in between. The per-answer weightings are $\bar w_1=(0.32,0.08)$, $\bar w_2=(0.08,0.32)$ and $\bar w_3=(0.10,0.10)$, and they sum to $(0.5,0.5)$. The first specialist gains four times as much from improving the first component as from improving the second. The balanced answer carries a fifth of the total weight, split evenly. A scalar method would push all three answers along $(0.5,0.5)$.

Ryan Bahlous-Boldi, VPO's first author, described the max in an interview on *Deep Learning with Yacine* as inducing something "almost like an unsupervised ... clustering" of the weightings into groups that one answer can serve. The cells $C_i$ are that clustering, and $\bar w_i$ is the objective each cluster hands to its answer. The same cells organize optimistic linear support. Alegre and colleagues compute the regions of the simplex in which each library policy is optimal and train the next policy at a corner where those regions meet, the weighting at which the library is most likely to improve. VPO's gradient instead pushes each answer along a weighted centroid of its own cell. One method extends the library at the boundaries; the other sharpens each member within its territory.

The mapping also explains two of VPO's empirical findings.

**Goal conditioning failed in the policy, not in the critic.** VPO's authors tried the obvious alternative: write the weighting $w$ into the prompt and train the model to satisfy it. The model learned to ignore the conditioning and collapsed to one behaviour. In the successor-feature construction the policy never sees $w$. Conditioning on $w$ happens in the critic, where it costs one dot product, and GPI selects among unconditioned behaviours.

Ignoring the conditioning is not peculiar to language models. [Zhou and Levine](https://arxiv.org/abs/2610.19783) (2026) found it in robot policies conditioned on a scalar advantage, where training with the true advantages and with random ones gave nearly the same gradients. Their fix leans on a critic. The conditional policy learns only a correction to an unconditioned one, and the critic labels extra actions sampled from the unconditioned policy, so the data show the advantage varying where the recorded actions barely did. Neither result is evidence against conditioning on tasks as such. Critic-side conditioning has a history: [universal value function approximators](https://proceedings.mlr.press/v37/schaul15.html) (Schaul and colleagues, 2015) folded Horde's separate demons into one network that takes the goal as input, and [universal successor features approximators](https://arxiv.org/abs/1812.07626) (Borsa and colleagues, 2019) did the same for successor features, with $w$ as the input.

**Collinear rewards mean few effective features.** VPO stopped helping on a preference dataset whose five reward criteria mostly agreed. In successor-feature terms, five nominally distinct cumulants spanned roughly one direction, so a library of one policy already covered every weighting. The rank of the reward vectors under the current policy, which the VPO paper uses as its diagnostic, measures how large a library the task can use.

The VPO paper does not mention successor features, GPI or general value functions. Its authors place it in multi-objective reinforcement learning and in lexicase selection, a technique from evolutionary computation that selects candidates by their performance on test cases taken one at a time in random order. In the interview, Bahlous-Boldi pointed in the direction this section has followed, without naming it. The assumption that reward is linear in its components was, in the interview's words, "a choice". Bahlous-Boldi also described unsupervised reinforcement learning, whose "goal is to learn one representation that at test time can satisfy any reward function you want with no training at all", adding that "nobody has scaled it up to LLM scale yet". *Learning One Representation to Optimize All Rewards* is the title of [Touati and Ollivier's 2021 paper](https://arxiv.org/abs/2103.07945) on forward–backward representations, which generalize successor features to rewards that need not be fixed in advance. That thread runs straight through the successor-feature line, and from there back to Horde.

## What GQ(λ) would add

At the horizon of one response, then, the mapping adds a vocabulary and two explanations, but no new algorithm. The tests score each answer exactly, and there is nothing to predict. The prediction machinery earns its place under three conditions that a continual learner meets constantly.

**Long horizons.** In an agentic episode the reward components arrive late and at different times. Tests pass after several rounds of editing, tool calls succeed or fail turn by turn, and sub-questions are settled at different hops. VPO currently assigns the same set-level advantage to every token of the episode, as [REINFORCE](https://lukstafi.github.io/notes/how-can-a-reward-train-a-neural-network.html#from-one-choice-to-a-complete-journey) does with a single return. In temporal-difference terms this is the $\lambda=1$ end of the scale: no bootstrapping, all credit from the final outcome. A bank of $d$ GQ(λ) learners, one per component and all reading the model's hidden states, would estimate the successor features $\psi(\text{prefix})\in\mathbb R^d$ at every token. The value of any weighting at any point of the episode is then $w^\top\psi$, so one bank serves the whole simplex. The trace parameter $\lambda$ interpolates between VPO's Monte Carlo credit and credit bootstrapped from the bank.

**Off-policy data.** A continual learner could train only on its current policy's samples, but it would discard most of its experience: traces from older checkpoints, from the base model, from earlier members of its own diverse sets, and from deployment logs gathered before the last update. GQ(λ) learns about the current target from all of them. In a language model the ratios $\rho_t$ are exact, and the state-dependent $\lambda$ handles their variance, as worked example E showed. Part 1's case for on-policy data concerned updating the policy, which forgets less when trained on its own samples. Learners that read frozen features leave the policy untouched, so they can use everything. A frozen library raises the same need: when a new reward component appears, every stored policy's successor features need a new entry, learned from the fragments of that policy which GPI still executes and off-policy everywhere else. One caution: traces that survived a selection step have no known behaviour policy. If a search loop sampled thirty answers and kept the best, the kept answer was produced by a max, not by a sampler with known probabilities. Off-policy correction applies to the raw samples, not to the survivors.

**Answers as options.** Each answer slot in a VPO response is an *option* in the sense of [Sutton, Precup and Singh](https://doi.org/10.1016/S0004-3702(99)00052-1): a course of action with its own termination condition, here the delimiter that closes the answer. The question "if I finish this answer, what will reward component $j$ be?" is literally a GQ(λ) question. Its target policy is the model, $\beta=1$ at the delimiter, the outcome $z$ is $r_j$, and the cumulant is zero, or the token count if length matters. GQ(λ) was built for these option-conditional questions. Its original motivation was intra-option learning, which learns about several options from data generated while executing only one.

Three proposals follow. None has been tested.

1. **Per-answer credit, without a critic.** VPO's set score decomposes into marginal gains,
   $$
   R(S)=\sum_{i=1}^{m}\mathbb E_w\Big[\max_{j\le i}w^\top r_j-\max_{j<i}w^\top r_j\Big].
   $$
   (Take the max over no answers to be zero; rewards here are non-negative.) Answer $i$ could be credited with its own term, the improvement it makes to the set already written. Bahlous-Boldi said in the interview that per-answer credit was left out to avoid over-complicating the method. This version needs no learned predictor, since the rewards are exact, and it mirrors Zahavy's iteration, in which each policy is valued by what it adds. The shared reasoning before the first answer would keep the full set score. Whether the split destabilizes training is an empirical question.
2. **A vector critic from linear demons.** Attach $d$ linear GQ(λ) heads to frozen hidden states of the model, one per reward component, sharing features and behaviour policy as Horde's demons did. The cost per token is $O(d\,n)$ for hidden size $n$, negligible beside a forward pass. Linear predictors on frozen features are the setting in which GQ(λ)'s convergence guarantee holds as stated. Interpretability research calls such predictors probes. The reward essay's [generalized advantage estimator](https://lukstafi.github.io/notes/how-can-a-reward-train-a-neural-network.html#what-values-and-policy-gradients-make-possible) then has a vector form. With vector temporal-difference errors $\boldsymbol\delta_t=c_t+\gamma\psi(s_{t+1})-\psi(s_t)\in\mathbb R^d$,

   $$
   \hat{\mathbf A}_t=\sum_{k\ge0}(\gamma\lambda)^k\boldsymbol\delta_{t+k},
   $$

   and for any weighting, $w^\top\hat{\mathbf A}_t$ is the generalized advantage of that scalarization, by linearity. For VPO's set score, the tokens of answer $i$ would take the advantage $\bar w_i^\top\hat{\mathbf A}_t$, under the weighting of their own cell from worked example F. Uses: credit within an answer on long agentic tasks; GPI at intermediate points, for instance deciding which candidate an evolutionary loop should extend; and evaluating a new weighting $w$ on logged traces before deploying anything.
3. **Continual VPO under drifting weights.** When the deployment weighting changes (new tests are added, or a criterion gains importance), a reward-diverse model should adapt by selection before it adapts by learning. Prediction: after a shift in $w$, a VPO checkpoint recovers best-of-$k$ performance under the new weighting in fewer updates than a GRPO checkpoint. VPO's maze task, whose collectibles can be reweighted at will, would test this cheaply.

## Diversity is a coverage condition

GQ(λ) assumes a behaviour policy that is "exciting": every action has some probability of being taken. The assumption is not a technicality. A learner can learn about an action only if its behaviour sometimes takes it, or something close enough that the features generalize. Where the behaviour never acts as the target would, $\rho_t=0$, the trace is cut, and nothing is learned about the target there. Where the behaviour acts that way only rarely, the ratio is huge and the update unusable.

Part 1 described how scalar reinforcement learning collapses a model onto one strategy per problem. In the language of this part, the collapse destroys the coverage that every later off-policy learner depends on. The model can no longer produce data about the alternatives, so nothing trained on its data can learn about them. That includes off-policy critics, later rounds of policy improvement, and consolidation by self-distillation. VPO restores coverage along the axes the reward defines. Its value to a continual learner therefore does not depend on test-time search. A reward-diverse model is a better behaviour policy for whatever learning comes next.

Bahlous-Boldi puts plasticity first: "we need to figure out where this loss of plasticity comes from" before one can "even start thinking about continual learning". [Dohare and colleagues](https://doi.org/10.1038/s41586-024-07711-7), also in Sutton's group, showed in 2024 that deep networks trained on a long sequence of tasks gradually lose the ability to learn new ones, until they learn "no better than a shallow network". Their remedy, continual backpropagation, reinitializes a small fraction of rarely used units. That is plasticity at the level of weights. The collapse of alternatives is plasticity lost at the level of behaviour: weights that could still change, attached to a policy that no longer visits the states from which change would be learned. The two can come apart. A network with perfectly plastic weights is still stuck if its behaviour generates no data about anything new.

Bahlous-Boldi framed the remedy in evolutionary terms. Two equally fit organisms may differ in how readily their descendants adapt. Selection cannot see the difference until the environment shifts, and then it is decisive. "Even though there was never a pressure to be nicely regularized, everybody is nicely regularized … the pressure comes from the changing environment." A continual learner faces a changing environment by definition. Keeping several competent behaviours alive is how it stays ready for a shift it cannot foresee. [What Should a Program Inherit?](https://lukstafi.github.io/notes/what-should-a-program-inherit.html) asked the same question of evolutionary search over programs: which retained differences become useful under later variation? There, a candidate that scores poorly overall may carry a component that a later candidate can use.

## Two halves of one strategy

A learner in a stream must prepare for objectives it does not know yet. There are two ways to prepare, and the two research lines this part has joined each took one.

Horde prepares by *predicting*. Its demons learn, off-policy, what would happen under many behaviours the agent is not following. That is knowledge without behaviour: the agent can say what wall-following would achieve without having become a wall-follower. VPO prepares by *behaving diversely*. It keeps a set of competent alternatives alive in the policy itself, with no critic. That is behaviour without knowledge: the model produces the alternatives, and only the tests know which one is best. GPI joins the halves. With a library of diverse behaviours and successor features that predict each one's per-component outcomes, a new weighting is met at once by a max, with no training. Consolidation, the subject of Part 1, can then make the selected behaviour cheap by distilling it into the weights. After that, the library has to be re-opened, or the next shift will find the model collapsed again.

Both halves stop at the same boundary. Each GVF answers a question someone posed, and each component of VPO's reward vector is a criterion someone wrote down. The world supplies the answers, but not the questions. Which cumulants to predict, which reward components to keep apart, which features to learn them over: these remained the open problem of the Horde programme, and later work on discovering useful questions ([Veeriah and colleagues](https://arxiv.org/abs/1909.04607), 2019) only began on it. The same problem appears in VPO as Bahlous-Boldi's open question of where vector rewards come from when there is no verifier. A continual learner that must also find its own questions has crossed from the given into the found. Neither line has crossed.

[Part 3](https://lukstafi.github.io/notes/where-experience-goes.html) takes stock. It places in-context learning, fast weights, harness memory, adapters, prediction banks and core weights on one ladder, and asks which store teaches which.

---

*Sources.* Ring, *Continual Learning in Reinforcement Environments*, PhD dissertation, University of Texas at Austin (1994). Drescher, *Made-Up Minds: A Constructivist Approach to Artificial Intelligence*, MIT Press (1991); my notes from 2013 are [here](https://lukstafi.github.io/notes/drescher-made-up-minds.html). Maei and Sutton, *GQ(λ): A general gradient algorithm for temporal-difference prediction learning with eligibility traces*, AGI 2010. Sutton, Modayil, Delp, Degris, Pilarski, White and Precup, *Horde: A scalable real-time architecture for learning knowledge from unsupervised sensorimotor interaction*, AAMAS 2011. Baird, *Residual algorithms: Reinforcement learning with function approximation*, ICML 1995. Gordon, *Stable function approximation in dynamic programming*, ICML 1995. Sutton and Barto, *Reinforcement Learning: An Introduction*, 2nd ed., MIT Press (2018). Sutton, Szepesvári and Maei, *A convergent O(n) algorithm for off-policy temporal-difference learning with linear function approximation*, NIPS 2008; Sutton et al., *Fast gradient-descent methods for temporal-difference learning with linear function approximation*, ICML 2009. Shen, Goldstein, Wang, Puli and Ranganath, *How I learned to stop worrying and love StopGrads: Stationarity, Convergence, and a case study on Flow Map Learning*, arXiv 2609.16222 (2026). Sutton, Precup and Singh, *Between MDPs and semi-MDPs: A framework for temporal abstraction in reinforcement learning*, Artificial Intelligence (1999). Munos, Stepleton, Harutyunyan and Bellemare, *Safe and efficient off-policy reinforcement learning* (Retrace), NeurIPS 2016. Dayan, *Improving generalization for temporal difference learning: The successor representation*, Neural Computation 5 (1993). Barreto et al., *Successor Features for Transfer in Reinforcement Learning*, NeurIPS 2017, arXiv 1606.05312. Zahavy, Barreto, Mankowitz, Hou, O'Donoghue, Kemaev and Singh, *Discovering a set of policies for the worst case reward*, ICLR 2021, arXiv 2102.04323. Alegre, Bazzan and da Silva, *Optimistic Linear Support and Successor Features as a Basis for Optimal Policy Transfer*, ICML 2022, arXiv 2206.11326. Zhou and Levine, *Reinforcement Learning via Advantage Guidance*, arXiv 2610.19783 (2026). Schaul, Horgan, Gregor and Silver, *Universal Value Function Approximators*, ICML 2015. Borsa, Barreto, Quan, Mankowitz, Munos, van Hasselt, Silver and Schaul, *Universal Successor Features Approximators*, ICLR 2019, arXiv 1812.07626. Touati and Ollivier, *Learning One Representation to Optimize All Rewards*, arXiv 2103.07945 (2021). Bahlous-Boldi et al., *Vector Policy Optimization: Training for Diversity Improves Test-Time Search*, arXiv 2605.22817 (2026), and the interview with Ryan Bahlous-Boldi on *Deep Learning with Yacine* (2026). Dohare, Hernandez-Garcia, Lan, Rahman, Mahmood and Sutton, *Loss of plasticity in deep continual learning*, Nature 632 (2024). Veeriah et al., *Discovery of Useful Questions as Auxiliary Tasks*, NeurIPS 2019.

*This article was co-authored by Łukasz Stafiniak and Claude (Opus 5.5).*
