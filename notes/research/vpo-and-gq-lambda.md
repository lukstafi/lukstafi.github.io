# VPO and GQ(λ): a bridge through Horde, successor features and GPI

Research note, 21 Oct 2026, for the continual-learning essay. It answers the question of whether the Vector Policy Optimization line connects to Maei and Sutton's GQ(λ) (2010). Short answer: yes, but not directly. The connection goes through two later lines that grew from GQ(λ): Horde's general value functions (GVFs), which use GQ(λ) as their learner, and successor features with generalized policy improvement (GPI). VPO's objective is the set-max objective of that literature, evaluated at the horizon of a single response and with Monte Carlo rewards. GQ(λ) supplies what VPO lacks: off-policy, bootstrapped, per-component predictions. A continual learner needs those once horizons grow and data comes from behaviour other than the current policy. Neither VPO paper cites this lineage; the connection is ours.

Sources:

- VPO: Bahlous-Boldi, Puri, Shenfeld, Kumar, Damani, Risi, Khattab, Hong, Agrawal, *Vector Policy Optimization: Training for Diversity Improves Test-Time Search*, arXiv 2605.22817 (21 May 2026). MIT and Improbable AI Lab; Risi is at Sakana AI.
- Podcast: Deep Learning with Yacine, interview with Ryan Bahlous-Boldi. Transcript in `notes/private/VPO-Yacine_podcast.vtt`; timestamped digest in `notes/private/VPO-Yacine_podcast-digest.md`. Quotes are machine-captioned and need checking against the audio. Where Ryan and the paper disagree, the paper wins: Ryan says "Qwen2.5-7B" and "I think ... a thousand iterations", while the paper says Qwen2.5-Coder-7B-Instruct and 200 OpenEvolve iterations.

**What Ryan says that bears on this note** (digest §4):

- Continual learning is his PhD goal, and its first obstacle is "loss of plasticity", which current RL produces [00:18:37]. "A lot of people were expecting this first paper to be a continual learning paper ... and it actually is. I just didn't write about it" [01:53:04].
- His reframe: find "every single trough in your loss landscape and ... cover them all", so that one of them is already good at the next task. "Even on a reward function that's unknown having diversity will help you transfer to an unknown reward" [01:54:38], [01:57:07].
- Linearity of reward in its components is "a choice" [01:12:12]. Unsupervised RL learns "one representation that at test time can satisfy any reward function you want with no training at all ... nobody has scaled it up to LLM scale yet" [01:49:45]. This describes forward–backward and successor-feature methods without naming them. The bridge below is the one he points at but does not draw.
- He is "much more sold on the Rich Sutton style of generate and test" [01:56:08]. Evolution is a "meta regularizer" whose "pressure comes from the changing environment" [01:58:37]–[02:00:43].
- He mentions hindsight relabeling as "very easy to do with VPO" but not done [00:36:25]. Per-answer credit assignment was skipped: "we didn't want to over complicate it" [01:02:09]. K is about 10,000 weight draws [00:56:54].
- He identifies VPO with max@n under a nonlinear reward, except that "each solution can attend to the previous solutions in context" [01:51:54].
- GQ(λ): Maei and Sutton, *GQ(λ): A general gradient algorithm for temporal-difference prediction learning with eligibility traces*, AGI 2010. <http://incompleteideas.net/papers/maei-sutton-10.pdf>. Not in `notes/private/` as of this note; fetched from Sutton's site.
- Horde: Sutton, Modayil, Delp, Degris, Pilarski, White, Precup, *Horde: A scalable real-time architecture for learning knowledge from unsupervised sensorimotor interaction*, AAMAS 2011, pp. 761–768. It states that "in this work we use the GQ(λ) algorithm (Maei & Sutton 2010)".
- Successor features and GPI: Barreto et al., *Successor Features for Transfer in Reinforcement Learning*, NeurIPS 2017; Barreto et al., *Fast reinforcement learning with generalized policy updates*, PNAS 2020.
- Set-max policies: Zahavy, Barreto, Mankowitz, Hou, O'Donoghue, Kemaev, Singh, *Discovering a set of policies for the worst case reward*, ICLR 2021, arXiv 2102.04323.
- Optimistic linear support: Alegre, Bazzan, da Silva, *Optimistic Linear Support and Successor Features as a Basis for Optimal Policy Transfer*, ICML 2022, arXiv 2206.11326.
- Per-component critics: van Seijen et al., *Hybrid Reward Architecture for Reinforcement Learning*, NeurIPS 2017, arXiv 1706.04208. Unread; cite only as the per-component-value precedent.

---

## 1. What each paper does

**VPO.** The reward is a vector $r(x,y)\in\mathbb R^d$: per-test-case correctness, per-hop citation, per-criterion scores. The model writes $m$ answers in one autoregressive chain (with $m=3$ throughout), so answer $i$ sees answers $1..i-1$. The set $S$ is scored by

$$R(S)=\mathbb E_{w\sim\mathrm{Dir}(\mathbf 1)}\Big[\max_{y\in S} w^\top r(x,y)\Big],$$

estimated with $K$ weight draws shared across the GRPO group. The GRPO advantage of the set reward is applied to every token of the rollout. Two ingredients, and each fails alone. Multi-answer chains under a fixed scalar (Multi-RLVR, Puri et al. 2026) collapse in reward space. Random weights on single answers do nothing (Random-w ≈ GRPO). A goal-conditioned policy given $w$ in its prompt mode-collapsed and ignored the conditioning (Maze, Table 6). VPO wins on best@$k$ as $k$ grows and loses on pass@1, which the authors accept. On LiveCodeBench, inside OpenEvolve, it solves problems on which GRPO never passes a test. It does not help when the reward components are nearly collinear (UltraFeedback scored by ArmoRM: the simplex collapses to a near-line, App. F).

The authors place it in multi-objective RL (Roijers 2013, Hayes 2022) and lexicase selection (Spector). They do not mention value functions, GVFs or successor features.

**GQ(λ).** It learns the answer to one *question* off-policy, from a single stream of experience generated by a behaviour policy $b$. A question is four functions: a target policy $\pi$, a termination function $\beta$, an outcome target $z$ (what you see when the option ends) and a transient reward $r$ (what accumulates along the way). The answer is linear, $Q_\theta(s,a)=\theta^\top\phi(s,a)$. The updates are

$$
\begin{aligned}
\delta_t &= r_{t+1}+\beta_{t+1}z_{t+1}+(1-\beta_{t+1})\theta_t^\top\bar\phi_{t+1}-\theta_t^\top\phi_t,\\
e_t &= \phi_t+(1-\beta_t)\lambda_t\rho_t e_{t-1},\qquad \rho_t=\pi(s_t,a_t)/b(s_t,a_t),\\
\theta_{t+1}&=\theta_t+\alpha_\theta\big[\delta_t e_t-\kappa_{t+1}(w_t^\top e_t)\bar\phi_{t+1}\big],\qquad \kappa=(1-\beta)(1-\lambda),\\
w_{t+1}&=w_t+\alpha_w\big[\delta_t e_t-(w_t^\top\phi_t)\phi_t\big].
\end{aligned}
$$

It is gradient descent on the projected Bellman error, so it converges off-policy with linear function approximation where Q-learning and TD(λ) can diverge. Its cost per step is linear in the number of features. Its stated goal is "a universal prediction learning algorithm suitable for learning experientially grounded knowledge of the world". It covers policy evaluation only; control was future work, later done as Greedy-GQ.

**Horde** runs thousands of GQ(λ) learners ("demons") in parallel on one robot. They share features $\phi$ and behaviour $b$, and each has its own question. "Knowledge is represented as a large number of approximate value functions learned in parallel"; a value function's match to the actual future "defines what it means for the knowledge to be accurate."

**Successor features and GPI.** Suppose the reward is linear in a vector of cumulants, $r_w=w^\top c$. Then a policy's value under any $w$ is $Q^{\pi}_w=w^\top\psi^\pi$, where $\psi^\pi$ is a vector of GVFs, one per cumulant. Given a library of policies $\pi_1..\pi_m$ with their $\psi$'s, GPI acts by $\arg\max_a\max_i w^\top\psi^{\pi_i}(s,a)$. The result is at least as good as every policy in the library, for every $w$, with no further learning. Zahavy et al. build the library by adding policies one at a time, each chosen to raise the worst-case value of the "set-max policy", $\min_w\max_i w^\top\psi^{\pi_i}(s_0)$. The discovered sets turn out diverse.

## 2. The mapping

| VPO | SF/GPI and Horde |
| --- | --- |
| reward component $r_j(x,y)$ | cumulant $c_j$; one GVF per component |
| answer $y_i$ in the chain | policy $\pi_i$ in the library |
| $r(x,y_i)\in\mathbb R^d$ | successor features $\psi^{\pi_i}(s_0)$, here exact because the horizon is one response |
| $\max_{y\in S}w^\top r(x,y)$ | set-max value $\max_i w^\top\psi^{\pi_i}(s_0)$ (GPI evaluated at the start state) |
| $\mathbb E_{w\sim\mathrm{Dir}}$ | Zahavy et al. take $\min_w$; Alegre et al. choose corner weights of the convex coverage set |
| answer $i$ conditioned on answers $<i$ | Zahavy's iteration: the next policy is chosen given the current set |
| goal-conditioned GRPO (failed) | universal value/successor-feature approximators, which condition on $w$ |
| test-time search picks the best | GPI's max at deployment |

So **VPO trains a policy library for set-max GPI, at the horizon of one response, built in context.** Two features are new relative to the SF literature. The library lives inside one autoregressive chain, so "add the next policy given the set so far" is done by in-context learning rather than by an outer loop of separate networks. And the evaluation is exact Monte Carlo: unit tests score each answer, so no $\psi$ has to be learned.

The second feature is also where the bridge stops being trivial. At the horizon of one response, the successor features *are* the reward vector, and GPI reduces to "take the best answer". Nothing needs predicting. GQ(λ) becomes relevant when one of three things holds.

**Long horizons.** In an agentic episode the components arrive late and at different times: tests pass after several edits, sub-questions are answered at different hops, tool calls succeed or fail turn by turn. VPO then gives every token the same set-level advantage, which is Monte Carlo at $\lambda=1$. A bank of $d$ GQ(λ) demons over the model's hidden states would predict $\psi(\text{prefix})\in\mathbb R^d$ at every token. Any scalarization's value at any prefix is then a dot product, $w^\top\psi$. One bank of $d$ predictors serves the whole simplex, which is the point of successor features. Eligibility traces and a state-dependent $\lambda$ interpolate between VPO's Monte Carlo credit and bootstrapped credit.

**Off-policy data.** A continual learner trains on traces it did not generate under its current policy: older checkpoints, the base model, the diverse set itself, other agents. GQ(λ) learns about a target policy from such data, and in a language model the per-token ratio $\rho_t=\pi(a_t\mid s_t)/b(a_t\mid s_t)$ can be computed exactly from two log-probabilities. The practical problem is variance: products of ratios over thousands of tokens. A state-dependent $\lambda$ is GQ(λ)'s own lever for cutting traces where the ratios run wild. Retrace-style truncation is the later fix. One caution: traces that survived test-time selection have an unknown behaviour policy, because selection is a max, not a sampler. Off-policy correction works on raw samples, not on survivors.

**Options and termination.** Each answer slot is an option that terminates at its delimiter. "If I continue this slot to its delimiter, what will $r_j$ be?" is literally a GQ(λ) outcome question: $\pi$ is the policy, $\beta=1$ at the delimiter, $z=r_j$ and $r=0$. A transient $r$ (tokens spent) can ride along as one more cumulant. The shared reasoning prefix is the part before any option starts.

## 3. What each side contributes to continual learning

**Diversity is the coverage condition of off-policy learning.** GQ(λ) assumes a behaviour policy that is "fixed and exciting", $b(s,a)>0$ for all $s,a$. A learner can learn about what it does not do only if its behaviour still visits it. Scalar RL's mode collapse removes exactly that. Pass@$k$ falls below the base model's, and the ratios needed to learn about alternatives blow up, or the data is absent. VPO restores coverage along the axes that matter, the reward trade-offs. This holds independently of test-time search: a reward-diverse behaviour policy is a better data source for every later learner, including off-policy critics and later consolidation.

**Two halves of one strategy for unknown future objectives.** A learner in a stream must prepare for objectives it does not yet know, or that will change. In VPO's terms, $w$ drifts: new test cases, new personas, new rubric items. Horde prepares by *predicting*: it learns off-policy about many policies it does not follow, which is knowledge without behaviour. VPO prepares by *behaving diversely*: it keeps a set of competent alternatives alive, which is behaviour without knowledge, since it has no critic. GPI is the operation that joins them. With a reward-diverse set plus predictions of each member's per-component outcomes, a new $w$ is met at once by a max, with no retraining. Consolidation can then make the selected behaviour cheap (Part 1's self-distillation), after which the diverse set has to be re-opened.

**Goal conditioning belongs in the critic, not the policy.** VPO's goal-conditioned baseline ignored its $w$. In the SF construction, conditioning on $w$ costs nothing in the critic, since it is a dot product, and the policy never sees $w$; GPI picks among unconditioned behaviours. The VPO failure is therefore no evidence against the SF route. It is evidence against asking a language model to translate a weight vector written in text into behaviour.

**Collinearity is low feature rank.** VPO does not help when components are collinear. In SF terms, the effective number of cumulants is small, so a small library covers the simplex. The same diagnostic (the rank of on-policy reward vectors, App. F) would size a GVF bank.

**Knowledge as predictions, and the given.** Horde's semantics is that a GVF's accuracy is defined by its match to the actual future. That is a correctness condition supplied by the world, in the sense of *The Given and the Found*. VPO's components are given conditions of the same kind (tests, gold citations). The bridge therefore stays inside the given; it does not touch the found-condition boundary.

## 4. Proposals and conjectures (not results)

1. **Per-slot marginal credit for VPO.** The set reward is a sum of marginal gains, $R(S)=\sum_i\mathbb E_w[\max_{j\le i}w^\top r_j-\max_{j<i}w^\top r_j]$. Crediting slot $i$ with its own marginal gain, instead of giving every token the set advantage, is a difference reward. It needs no critic, because the rewards are exact. It mirrors Zahavy's incremental construction. Untested; it may destabilize the shared prefix, whose credit would remain the full $R(S)$.
2. **A vector critic from GQ(λ) demons.** Linear GQ(λ) heads on frozen residual-stream features, one per reward component and sharing $\phi$ and $b$ as Horde's demons do, would predict $\psi(\text{prefix})$. The cost is $O(d\cdot n)$ per token, where $n$ is the hidden size and $d$ is in the tens, which is negligible beside a forward pass. Uses: mid-slot credit for VPO on long agentic tasks; GPI over the set at intermediate decision points (for instance, choosing which slot to extend in an evolutionary loop); off-policy evaluation of new $w$ from logged deployment traces. Linear heads on frozen features are the setting where GQ(λ)'s convergence guarantee holds. They are also what interpretability calls probes.
3. **Continual VPO.** Under a drifting $w$, a reward-diverse policy adapts by selection before it adapts by learning. Prediction: after a shift in $w$ (new tests added), a VPO checkpoint recovers best@$k$ under the new $w$ with fewer updates than a GRPO checkpoint. This is testable with VPO's own Maze by reweighting the items.
4. **Does consolidation undo VPO?** Context-conditioned self-distillation tilts toward the teacher's mode. Distilling a VPO model into itself might collapse the set again. Open question; check whether SDFT or SDPO papers report pass@$k$ or diversity.

## 5. Where it goes in the essay

Part 1 gets VPO's evidence as a second kind of forgetting: on-policy RL retains other tasks (*Retaining by Doing*, *RL's Razor*) but forgets alternatives within the task. Part 2 opens with the GQ(λ)/Horde picture of continual learning as many predictions learned off-policy from one stream, and uses the mapping above to join it to VPO. The ladder of stores then gains a rung or a cross-cutting store: a GVF bank is predictive knowledge that TD writes and that persists in weights.
