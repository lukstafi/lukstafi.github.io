---
title: "Study notes: How Does a Policy Improve?"
essay: how-does-a-policy-improve
track: keeps-learning
reviewed-against: "4b16cbf"
requires:
  - {at: how-can-a-reward-train-a-neural-network#values-evaluate-a-particular-policy, for: action values}
introduces:
  - {term: policy-improvement argument, at: evaluating-a-policy-and-improving-it, related: ["generalized policy improvement", "projected Bellman error and gradient TD"]}
  - {term: discounted occupancy, at: evaluating-a-policy-and-improving-it, related: ["flow conservation"]}
  - {term: three jobs of a world model, at: the-different-jobs-of-a-world-model, related: ["transition model", "five capacities of a world model", "successor features"]}
  - {term: amortization, at: the-different-jobs-of-a-world-model, related: ["amortization argument for weights", "amortization as learning and as efficiency"]}
  - {term: reparameterization trick, at: the-different-jobs-of-a-world-model}
  - {term: model-predictive control, at: planning-over-trajectories-and-trees, related: ["search as regularized policy improvement"]}
  - {term: mass-covering and mode-seeking KL, at: improving-a-distribution-without-throwing-away-the-prior, related: ["self-distillation with privileged context", "consolidation as an M-step", "coverage condition"]}
  - {term: exponential tilt, at: improving-a-distribution-without-throwing-away-the-prior}
  - {term: temperature as a Lagrange multiplier, at: improving-a-distribution-without-throwing-away-the-prior, related: ["momentum as the price of a constraint", "forgetting within a task"]}
  - {term: control as inference, at: the-evidence-lower-bound-and-expectation-maximization}
  - {term: E-step and M-step of policy improvement, at: the-evidence-lower-bound-and-expectation-maximization, related: ["consolidation as an M-step", "improvement separated from fitting"]}
  - {term: restricted ELBO, at: the-evidence-lower-bound-and-expectation-maximization, related: ["return-conditioned policy"]}
  - {term: flow conservation, at: reps-and-the-consistency-of-state-distributions}
  - {term: improvement separated from fitting, at: mpo-separates-improvement-from-fitting, related: ["self-distillation with privileged context"]}
  - {term: advantage-weighted regression, at: weighted-regression-and-learning-from-a-fixed-dataset, related: ["return-conditioned policy"]}
  - {term: aleatoric and epistemic uncertainty, at: from-return-distributions-to-return-conditioned-policies}
  - {term: return-conditioned policy, at: from-return-distributions-to-return-conditioned-policies, related: ["generalized policy improvement"]}
  - {term: search as regularized policy improvement, at: search-as-regularized-policy-improvement, related: ["bandit and exploration"]}
  - {term: Direct Preference Optimization, at: from-relative-entropy-to-preference-learning, related: ["implicit value of a context", "moving teacher and fixed anchor"]}
  - {term: four questions for reading an algorithm, at: a-reusable-way-to-read-the-algorithms, related: ["consolidation as an M-step"]}
uses:
  - {term: state value and action value, from: how-can-a-reward-train-a-neural-network}
  - {term: policy iteration, from: how-can-a-reward-train-a-neural-network}
  - {term: temporal-difference error, from: how-can-a-reward-train-a-neural-network}
  - {term: bootstrapping, from: how-can-a-reward-train-a-neural-network}
  - {term: λ-return and eligibility trace, from: how-can-a-reward-train-a-neural-network}
  - {term: on-policy and off-policy, from: how-can-a-reward-train-a-neural-network}
  - {term: REINFORCE, from: how-can-a-reward-train-a-neural-network}
  - {term: baseline and advantage, from: how-can-a-reward-train-a-neural-network}
---

The robot's junction, used by several questions: the reference policy gives waiting, the detour and the shortcut probabilities $(0.6,0.3,0.1)$, and their action values are $(0,1,2)$.

## Part 1

### From one decision to every decision {kind=derive at=evaluating-a-policy-and-improving-it}

Suppose $\sum_a\pi'(a\mid s)Q^\pi(s,a)\ge V^\pi(s)$ at every state. This says that one decision under $\pi'$, followed by $\pi$, is no worse than $\pi$. Show that following $\pi'$ at every decision is no worse.

::: answer
Write $T_{\pi'}$ for the Bellman operator that backs continuation values up through one decision under $\pi'$. The assumption is $T_{\pi'}V^\pi\ge V^\pi$. The operator is monotonic, because it averages with nonnegative probabilities and multiplies by $\gamma\ge0$, so applying it repeatedly gives $V^\pi\le T_{\pi'}V^\pi\le T_{\pi'}^2V^\pi\le\cdots$. It is also a contraction: each backup shrinks the largest difference between two bounded value functions by at least a factor of $\gamma$. After $n$ decisions the effect of reverting to the old policy is at most $\gamma^n$ times the largest difference between $V^\pi$ and $V^{\pi'}$, which vanishes. The chain converges to $V^{\pi'}$, so $V^{\pi'}\ge V^\pi$.
:::

### What a trust region is for {kind=limits at=evaluating-a-policy-and-improving-it}

With $d^\pi$ the normalized discounted occupancy, $J(\pi')-J(\pi)=\frac{1}{1-\gamma}\,\mathbb E_{s\sim d^{\pi'},\,a\sim\pi'}[A^\pi(s,a)]$. Which part of the right-hand side is unavailable from the old policy's data? What replaces it, and at what cost?

::: answer
The expectation is over states visited by the new policy, and the data usually come from the old one. Replacing $d^{\pi'}$ by $d^\pi$ gives a manageable surrogate. It is an approximation whose quality depends on how much the behavior changes. A trust region helps keep the data distribution relevant to the policy about to be deployed.
:::

### Three jobs of a model {kind=recall at=the-different-jobs-of-a-world-model}

Name the three ways a learned model can take part in control, with a system that uses each. Which of them leaves computation to be done at deployment, and what is the alternative called?

::: answer
- Supply simulated transitions for value learning: Dyna, and SimPLe at the scale of Atari.
- Train an actor through imagined trajectories: Dreamer.
- Evaluate candidate actions during planning: model-predictive control, or the tree search of AlphaZero and MuZero.

Planning makes extra computation available at deployment, and the computation must finish before the next action is due. Dreamer's actor amortizes instead: a training cost is paid so that repeated decisions become cheaper. Amortization does not guarantee that the cheap action matches what a planner with more time would choose.
:::

### Averaging two good plans {kind=compute at=planning-over-trajectories-and-trees}

A planner scores three steering commands: left ($-1$) and right ($+1$) each have predicted return $2$, and straight ($0$) runs into the obstacle with predicted return $0$. Weight them by $w_k\propto e^{\hat G_k/\eta}$ with $\eta=0.5$ and execute the weighted average. What does the robot do? Does a lower temperature help?

::: answer
The weights are $(e^4,e^4,1)$ normalized, about $(0.495,\,0.495,\,0.009)$. The average command is $0$: straight into the obstacle, the worst candidate. A lower temperature moves the remaining weight onto the two tied winners and leaves the average at $0$. An expressive distribution over plans can preserve alternatives that a single mean collapses. Selecting, mixing and fitting candidates are different operations even when their scores are identical.
:::

## Part 2

### The regularized improvement {kind=derive at=improving-a-distribution-without-throwing-away-the-prior}

Maximize $\sum_a q(a)Q(a)-\eta\,D_{\mathrm{KL}}(q\|p)$ over distributions $q$. What is the optimum, and what does $\eta$ do?

::: answer
Setting the derivative to zero with a multiplier for normalization gives $q^*(a)=p(a)e^{Q(a)/\eta}/Z$ with $Z=\sum_b p(b)e^{Q(b)/\eta}$. It is a softmax of $\log p(a)+Q(a)/\eta$, so a rare action needs enough value to overcome its small prior. As $\eta$ grows the update approaches the reference; as it shrinks, probability concentrates on the best supported action. The optimal value of the objective is $\eta\log Z$.
:::

### Tilt the robot's policy {kind=compute at=improving-a-distribution-without-throwing-away-the-prior}

With $p=(0.6,0.3,0.1)$, $Q=(0,1,2)$ and $\eta=0.5$, compute $q^*$ and the expected value before and after.

::: answer
The weights $p(a)e^{2Q(a)}$ are about $(0.6,\,2.217,\,5.460)$, so $q^*\approx(0.073,\,0.268,\,0.660)$. The expected value rises from $0.5$ to about $1.587$. Greedy improvement would reach $2$ and discard both alternatives.
:::

### Two directions of KL {kind=distinguish at=improving-a-distribution-without-throwing-away-the-prior}

A target $p$ has two separated peaks and $q$ must be a single Gaussian. What does each direction of KL produce, and when does the direction stop mattering?

::: answer
Minimizing $D_{\mathrm{KL}}(p\|q)$ is mass-covering: the expectation is under $p$, so $q$ must have mass wherever $p$ does, and it spreads over both peaks and the valley between. Minimizing $D_{\mathrm{KL}}(q\|p)$ is mode-seeking: the expectation is under $q$, so $q$ avoids the valley and settles on one peak. If $q$'s family can represent $p$ exactly, both give $q=p$.
:::

### A budget in place of a temperature {kind=explain at=improving-a-distribution-without-throwing-away-the-prior}

Replace the penalty with the constraint $D_{\mathrm{KL}}(q\|p)\le\epsilon$. How is the temperature then determined?

::: answer
The temperature is the Lagrange multiplier of the constraint, found by minimizing $g(\eta)=\eta\epsilon+\eta\log\sum_a p(a)e^{Q(a)/\eta}$. Since $g'(\eta)=\epsilon-D_{\mathrm{KL}}(q_\eta\|p)$, the minimization adjusts the temperature until the update spends exactly the allowed divergence. If the best action already fits within the budget, the constraint is inactive.
:::

### What a prior cannot supply {kind=limits at=improving-a-distribution-without-throwing-away-the-prior}

What happens to the tilt at an action with $p(a)=0$?

::: answer
It stays at zero: putting mass there makes $D_{\mathrm{KL}}(q\|p)$ infinite. Regularization toward a prior preserves experience and cannot produce alternatives outside the prior's support.
:::

### A posterior as a selected population {kind=derive at=the-evidence-lower-bound-and-expectation-maximization}

Draw trajectories from $p_\theta(\tau)$ and keep each with probability $e^{(R(\tau)-C)/\alpha}$, where $C$ bounds the returns from above. What is the distribution of the kept trajectories? Write the evidence lower bound for the event $O=1$ that a trajectory is kept. What is it after multiplying by $\alpha$, and when is it tight?

::: answer
By Bayes' rule $p_\theta(\tau\mid O=1)=p_\theta(\tau)e^{R(\tau)/\alpha}/\mathbb E_{p_\theta}[e^{R/\alpha}]$: the current trajectory distribution reweighted toward higher returns. For any $q$ with the same support, Jensen's inequality gives $\log p_\theta(O=1)\ge\mathbb E_q[\log p(O=1\mid\tau)]-D_{\mathrm{KL}}(q\|p_\theta)$. Multiplied by $\alpha$ this is $\mathbb E_q[R(\tau)]-\alpha D_{\mathrm{KL}}(q\|p_\theta)$, up to the constant $-C$: the return-minus-divergence objective. The gap is $D_{\mathrm{KL}}(q\,\|\,p_\theta(\tau\mid O=1))$, so the bound is tight when $q$ is the posterior.
:::

### Why exact EM cannot lose {kind=argue at=the-evidence-lower-bound-and-expectation-maximization}

What does each of the E-step and the M-step hold fixed, and what does it change? Why can exact EM not lower the evidence? What weakens the argument in practice?

::: answer
The E-step fixes $\theta$ and sets $q$ to the posterior over trajectories. The M-step fixes $q$ and adjusts $\theta$ to raise the bound. Its policy-dependent part is $\max_\theta\mathbb E_{\tau\sim q}\bigl[\sum_t\log\pi_\theta(a_t\mid s_t)\bigr]$: supervised learning on targets constructed to favor good behavior. After the E-step the bound equals the evidence at the old parameters, the M-step raises the bound, and the evidence at the new parameters is at least the new bound. If the E-step is restricted or approximate, the starting bound need not be tight, and raising a loose bound does not establish that the evidence rose. Sampling error and incomplete neural optimization add further qualifications.
:::

### A posterior that moves the gate {kind=limits at=the-evidence-lower-bound-and-expectation-maximization}

The essay keeps two distinctions explicit once control is cast as inference. What are they? Which restriction on $q$ repairs the second?

::: answer
First, $\alpha\log\mathbb E_{p_\theta}[e^{R/\alpha}]$ is not the expected return. For large $\alpha$ it is the mean plus $\operatorname{Var}(R)/(2\alpha)$, so unrestricted conditioning can favor a risky lottery whose lucky outcomes receive enormous weight. Second, a trajectory posterior can change the apparent dynamics: among journeys conditioned on success, the gate appears open more often than it opens. The robot controls its actions, not the gate. The repair restricts $q(\tau)$ to $\rho_0(s_0)\prod_t q(a_t\mid s_t)P(s_{t+1}\mid s_t,a_t)$, which can change action probabilities and keeps the initial-state distribution and the transitions fixed. The optimizer of this restricted ELBO generally does not equal the unrestricted posterior.
:::

### Values as prices {kind=derive at=reps-and-the-consistency-of-state-distributions}

REPS improves a state-action occupancy $\nu(s,a)$ against a reference $\mu(s,a)$ under a KL budget, maximizing average reward. Which further constraint must $\nu$ satisfy, and why? Attach a multiplier $V(s')$ to it. What score does each pair $(s,a)$ receive, and what is the optimum?

::: answer
Flow conservation: $\sum_a\nu(s',a)=\sum_{s,a}\nu(s,a)P(s'\mid s,a)$, so the probability flowing into a state equals the state's marginal probability. Without it the optimizer could put all its mass at the delivery destination without paying for the journeys that arrive there. Raising one $\nu(s,a)$ contributes $-V(s)$ through the marginal at $s$ and the expected successor multiplier through the incoming flows. With the reward, the coefficient of $\nu(s,a)$ is $\delta_V(s,a)=r(s,a)+\sum_{s'}P(s'\mid s,a)V(s')-V(s)$. For fixed $V$ and $\eta$ this is the tilt with state-action pairs as candidates: $\nu^*(s,a)\propto\mu(s,a)e^{\delta_V(s,a)/\eta}$. Here $V$ starts as a set of constraint multipliers, prices that enforce consistency between states, and not as an estimate of a fixed policy's return.
:::

### The samples carry the prior {kind=compute at=mpo-separates-improvement-from-fitting}

At the robot's junction MPO draws ten actions from $\pi_i=(0.6,0.3,0.1)$: suppose six waits, three detours and one shortcut. The critic gives $Q=(0,1,2)$ and $\eta=0.5$. What weight does each sample get, and which distribution do the weighted samples represent? What if each weight were also multiplied by $\pi_i(a)$?

::: answer
Each sample gets a weight proportional to $e^{Q/\eta}$: $1$ for a wait, $7.39$ for a detour, $54.6$ for the shortcut. The three groups total $(6,\,22.2,\,54.6)$, which normalizes to $(0.073,\,0.268,\,0.660)$: the tilt $q^*$. Sampling from $\pi_i$ already represents the reference factor. Multiplying by the density again weights the actions by $\pi_i^2e^{Q/\eta}$, about $(0.229,\,0.423,\,0.348)$. The reference is counted twice, and the shortcut loses its lead.
:::

### Two responsibilities {kind=explain at=mpo-separates-improvement-from-fitting}

What does MPO gain by constructing $q_i$ before fitting $\pi_\theta$? In which direction of KL is the fit? For the robot, what do a good and a poor M-step look like?

::: answer
One gradient step in policy parameters need not simultaneously discover good actions, preserve sensible exploration and represent the improved behavior. The E-step constructs a better distribution from estimated values, and the M-step solves a supervised fitting problem. The quality of the estimate and the quality of the fit are distinct responsibilities. The fit maximizes weighted likelihood, which minimizes $D_{\mathrm{KL}}(q_i\|\pi_\theta)$: the mass-covering direction, with a further trust region on how far the parameterized policy moves. A successful M-step learns what distinguishes this junction from other junctions. A poor one memorizes a background texture or pushes all similar scenes toward the shortcut.
:::

### A baseline that cancels and still matters {kind=explain at=weighted-regression-and-learning-from-a-fixed-dataset}

At a fixed state, replacing $Q(s,a)$ by $A(s,a)=Q(s,a)-V(s)$ leaves the tilted distribution unchanged. Why does the baseline still matter in advantage-weighted regression? Take two junctions with the same action preferences, where every journey from the second earns an extra $100$.

::: answer
Subtracting $V(s)$ multiplies every action weight at $s$ by the same factor, and the factor cancels when each state's distribution is normalized separately. Weighted regression does not normalize state by state: it fits one network across states with the unnormalized weights $e^{\hat A(s,a)/\beta}$. With raw returns the second junction's weights are larger by $e^{100/\beta}$, and that junction dominates the dataset-wide objective. Subtracting each junction's baseline removes the common offset. The intended conditional choices stay the same; the allocation of the learner's finite capacity changes. Weight clipping can further break the cancellation.
:::

### Good decisions and good luck {kind=compute at=from-return-distributions-to-return-conditioned-policies}

One action pays $2$ for certain. Another pays $10$ with probability $0.1$ and nothing otherwise. With equal action priors and $\eta=1$, compare the weights obtained by exponentiating expected returns with those obtained by exponentially weighting realized returns. What does conditioning on a return of $10$ select, and what does playing the selection again achieve?

::: answer
The means are $2$ and $1$. Exponentiating them gives $e^2\approx7.39$ against $e\approx2.72$, so the certain reward gets about $0.73$ of the probability. Weighting realized returns gives $e^2$ against $0.9+0.1e^{10}\approx2204$, so the lottery gets about $0.997$. Conditioning on a return of $10$ selects only lottery actions, and playing them again leaves the winning probability at $0.1$. Conditioning can select favorable environmental outcomes that a policy cannot cause. MPO's critic-based step exponentiates an estimated expected value; AWR with sampled returns can give unusually lucky outcomes disproportionately large weights.
:::

## Part 3

### The opposite direction {kind=compute at=search-as-regularized-policy-improvement}

Reverse the KL: maximize $\sum_a q(a)Q(a)-\lambda D_{\mathrm{KL}}(p\|q)$. Find the form of the optimum. For the robot with $\lambda=0.5$, the multiplier that normalizes it is $c\approx2.06994$. Compute $q^*$ and compare it with the exponential tilt.

::: answer
With a multiplier $c$ for normalization, the derivative is $Q(a)+\lambda p(a)/q(a)-c$. Setting it to zero gives $q^*(a)=\lambda p(a)/(c-Q(a))$ with $c>\max_aQ(a)$: a rational expression, not an exponential one. For the robot, $q^*=(0.3/2.06994,\;0.15/1.06994,\;0.05/0.06994)\approx(0.1449,\,0.1402,\,0.7149)$. The tilt gave $(0.0725,\,0.2678,\,0.6597)$. Both favor the shortcut and keep different amounts of the other actions. Equal penalty coefficients do not imply equal divergence budgets, so the comparison is illustrative.
:::

### PUCT follows a derivative {kind=derive at=search-as-regularized-policy-improvement}

Write $N=\sum_bN(s,b)$. Rewrite the PUCT score $Q(s,a)+c_{\mathrm{puct}}\,p(a\mid s)\sqrt{N}/(1+N(s,a))$ in terms of the smoothed visit distribution $\hat\pi(a\mid s)=(1+N(s,a))/(|\mathcal A|+N)$. What is the search doing to the reversed-KL objective? What keeps it from being an exact solve?

::: answer
Since $1+N(s,a)=\hat\pi(a\mid s)\,(|\mathcal A|+N)$, the score is $Q(s,a)+\lambda_N\,p(a\mid s)/\hat\pi(a\mid s)$ with $\lambda_N=c_{\mathrm{puct}}\sqrt N/(|\mathcal A|+N)$. The derivative of the reversed-KL objective is $Q(a)+\lambda p(a)/q(a)-c$, and $c$ is common to all actions. With $q=\hat\pi$ and $\lambda=\lambda_N$, PUCT selects the action with the largest derivative, and visiting it increases its share of the counts. Values and counts evolve during search, so this is not an exact solve for one fixed objective. Final training targets can also use different visit-count conventions.
:::

### DPO from the tilt {kind=derive at=from-relative-entropy-to-preference-learning}

Treat a prompt $x$ as a context and a whole response $y$ as an action. The KL-regularized optimum is $\pi^*(y\mid x)=\pi_{\mathrm{ref}}(y\mid x)e^{r(x,y)/\beta}/Z(x)$. Under the Bradley–Terry model, $y_+$ is preferred to $y_-$ with probability $\sigma(r(x,y_+)-r(x,y_-))$. Derive DPO's margin. What preference does it predict at $\pi_\theta=\pi_{\mathrm{ref}}$?

::: answer
Rearranging the optimum gives $r(x,y)=\beta\log\frac{\pi^*(y\mid x)}{\pi_{\mathrm{ref}}(y\mid x)}+\beta\log Z(x)$. In the difference $r(x,y_+)-r(x,y_-)$ the term $\beta\log Z(x)$ cancels. Replacing $\pi^*$ with the trainable $\pi_\theta$ gives the margin $m_\theta=\beta\Bigl[\log\frac{\pi_\theta(y_+\mid x)}{\pi_{\mathrm{ref}}(y_+\mid x)}-\log\frac{\pi_\theta(y_-\mid x)}{\pi_{\mathrm{ref}}(y_-\mid x)}\Bigr]$, and the loss is $-\log\sigma(m_\theta)$ averaged over labeled pairs. At $\pi_\theta=\pi_{\mathrm{ref}}$ the margin is zero and the predicted preference probability is $1/2$. The KL-regularized optimum supplies the parameterization; the implemented loss fits preferences directly, without a separately trained reward model.
:::

### Four places to look {kind=case at=recent-agents-bring-the-constructions-together}

An agent that learns behavior inside a world model fails at the gate. Which four things does the essay say we can ask about separately? Give the four ways the gate can go wrong.

::: answer
We can ask whether the simulated experience is faithful, whether the values are correct, whether the preference signal is useful, and whether the actor represents the resulting distribution. At the gate:

- The model hallucinates an opening. The critic may correctly evaluate the hallucinated world.
- The model predicts the closure, and the critic assigns a large terminal value to waiting there.
- Both predictions are sound, and the fitting objective puts too little weight on the rare closed-gate examples.
- Perception mistakes which junction the robot occupies, so the actor acts from the wrong latent state.

A successful system depends on all the parts, and an observed failure need not indict all of them.
:::

### A confident wrong critic {kind=compute at=what-constrains-improvement-when-the-estimates-are-wrong}

The true values stay $(0,1,2)$, and the critic mistakenly scores waiting as $5$. With $p=(0.6,0.3,0.1)$ and $\eta=0.5$, compute the tilt, the expected value the critic believes in and the true expected value, before and after. What failed? What does a KL constraint on the policy leave unprotected?

::: answer
The weights are $(0.6e^{10},\,0.3e^{2},\,0.1e^{4})\approx(13216,\,2.2,\,5.5)$, so $q^*\approx(0.9994,\,0.0002,\,0.0004)$. By the critic's scores the expected value rose from $3.5$ to about $5.0$. The true expected value fell from $0.5$ to about $0.001$. The optimization functioned as specified. What failed is the premise that its scores measure the desired consequences. A KL constraint limits the size of a step relative to its reference: it does not calibrate the critic, constrain every future state equally, or ensure that the reference is appropriate. Repeated small steps can also add up to a large departure.
:::

### Four questions {kind=recall at=a-reusable-way-to-read-the-algorithms}

Name the four questions the essay asks of any policy-improvement algorithm.

::: answer
Where do the candidates come from? How are they evaluated? How is an improved distribution built from them? How is the improvement retained?
:::

### Exact, then approximate {kind=limits at=a-reusable-way-to-read-the-algorithms}

Which result does the essay call exact? It then lists five steps away from that result, each needing its own reason. Name them, with a method from the essay that takes each step.

::: answer
The exponential tilt is an exact finite-action optimizer under stated assumptions. The steps away from it:

- Replacing values with a neural critic, as in MPO's E-step.
- Sampling a few candidates, as MPO and POCO do at each state.
- Omitting a state-dependent normalizer, which changes a shared-parameter regression objective, as in AWR.
- Reversing a KL, which changes its optimizer, as in the analysis of AlphaZero's search.
- Replacing likelihood with a generative surrogate, which changes what can be inferred from an EM argument, as in POCO's flow-matching loss.
:::
