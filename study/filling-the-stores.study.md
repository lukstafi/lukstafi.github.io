---
title: "Study notes: Filling the Stores"
essay: filling-the-stores
track: keeps-learning
reviewed-against: "fd70cfb"
requires:
  - {at: every-layer-a-store#selection-is-learned-retrieval, for: selectors and the miss}
  - {at: every-layer-a-store#memory-along-depth, for: mHC and worked example 4}
  - {at: every-layer-a-store#the-seven-assembled, for: "the seven models, and which stores are written in training"}
  - {at: how-does-a-policy-improve, for: the GRPO family, strength: helpful}
  - {at: who-teaches-the-weights, for: "self-distillation, and why a student absorbs only what lies close to it", strength: helpful}
  - {at: where-experience-goes, for: the continual-learning consequences of forgetting, strength: helpful}
introduces:
  - {term: "pretraining, mid-training, SFT, RL, distillation and drafter training", at: the-stages-kept-apart}
  - {term: rollout and policy, at: the-stages-kept-apart}
  - {term: plateau before the facts, at: what-pretraining-writes-and-in-what-order, gloss: "the stretch of training in which a model knows the kind of answer a template wants and not which answer"}
  - {term: Muon, at: normalizing-a-matrix}
  - {term: distilling a selector from the attention it replaces, at: selectors-cannot-learn-through-top-k}
  - {term: dense warm-up, at: selectors-cannot-learn-through-top-k}
  - {term: Sinkhorn iteration, at: residual-mixers-must-stay-stable}
  - {term: context extension, at: long-context-comes-late-and-it-comes-cheaply}
  - {term: stale rollout, at: what-rl-optimizes-and-how-it-goes-wrong}
  - {term: reward hacking, at: what-rl-optimizes-and-how-it-goes-wrong}
  - {term: on-policy distillation of specialists, at: specialists-then-one-checkpoint}
  - {term: self-distillation on a run's own rollouts, at: self-distillation-at-production-scale, gloss: "SFT on rollouts collected from an RL run, started from a mid-trained checkpoint, after which RL resumes"}
  - {term: open process and open weights, at: open-process-open-weights}
uses:
  - {term: selector, from: every-layer-a-store}
  - {term: mixture of experts, from: every-layer-a-store}
  - {term: Manifold-Constrained Hyper-Connections, from: every-layer-a-store}
  - {term: stores written in training and stores written while reading, from: every-layer-a-store}
  - {term: importance ratio, from: learning-about-what-you-do-not-do}
  - {term: on-policy and off-policy, from: how-can-a-reward-train-a-neural-network}
  - {term: GRPO, from: how-can-a-reward-train-a-neural-network}
---

### The plateau before the facts {kind=explain at=what-pretraining-writes-and-in-what-order}

A small Transformer is trained on biographies of invented people. Describe the three phases of its loss on the attributes. What is learned on the plateau, and which experiment shows it? What limits does the essay put on the result?

::: answer
The loss fell at first, as the model learned the language and the kinds of answer a template wants. It then stopped at the entropy of the attribute values: the model knew that a birthplace is a city and did not know which city. After a plateau, knowledge of the individuals emerged. What is learned on the plateau is a circuit in the attention. When training restarted from the same initial parameters, with the attention patterns of a later checkpoint fed in and only the feed-forward weights learning, the plateau disappeared. The experiment ran at 44 million parameters on data with one task in it, the order in the weights is not "attention first", and in a larger model on natural text the heads specialized for answers are still turning over at the end of training. The result is offered as a mechanism, not as a measurement of the seven.
:::

### One gradient, two normalizations {kind=compute at=normalizing-a-matrix}

Muon takes the matrix of momenta $M=USV^\top$ and steps along $UV^\top$. Let a gradient be $G=10\,u_1v_1^\top+1\,u_2v_2^\top$ with $u_1=(0.8,0.6)$, $u_2=(-0.6,0.8)$, $v_1=(0.6,0.8)$, $v_2=(0.8,-0.6)$. Compute Adam's first step, which keeps the sign of each entry, and Muon's step. What does each normalization keep, and what do both throw away?

::: answer
$G=\begin{pmatrix}4.32&6.76\\4.24&4.32\end{pmatrix}$. All four entries are positive, so Adam's step is the all-ones matrix, of rank 1, and the weak direction is gone. Muon sets both singular values to 1: $u_1v_1^\top+u_2v_2^\top=\begin{pmatrix}0&1\\1&0\end{pmatrix}$. The weak direction now counts as much as the strong one. Both updates throw away the gradient's overall scale. Adam keeps the signs of the entries, Muon the singular vectors.
:::

### What a selector can see {kind=compute at=selectors-cannot-learn-through-top-k}

One query reads four entries, and the selector keeps two. The main attention's target is $p=(0.40,0.20,0.35,0.05)$. The indexer's scores $(2,1,0,-1)$ give $q=(0.644,0.237,0.087,0.032)$.

(a) Which entries are selected, and what is missed? (b) Raise entry 3's score from 0 to 0.1. What happens to the task loss, and why? (c) The gradient of the KL from $p$ to $q$ on the scores is $q-p$. Compute it and say what a descent step does. (d) Take the KL over the selected entries only. What does it report?

::: answer
(a) Top-2 picks entries 1 and 2. Entry 3, with 35 percent of the attention, is missed.

(b) Nothing happens. The selected set stays the same, and so do the attention, the output and the loss. The main attention receives the selected positions as integers, so the task loss is a step function of the scores. That is the missing gradient.

(c) $q-p=(+0.244,+0.037,-0.263,-0.018)$. A descent step lowers entry 1's score and raises entry 3's.

(d) Both distributions are confined to entries 1 and 2: $(2/3,1/3)$ against $(0.731,0.269)$, a KL of 0.010 and no gradient at all on entry 3. The student looks nearly done while 40 percent of the attention lies outside what it selected. This is why most recipes begin with a dense warm-up, in which the indexer learns from the whole distribution before it controls anything.
:::

### When selection can be added {kind=case at=selectors-cannot-learn-through-top-k}

At which points of a pipeline has selection been added? What did the one experiment that held everything else fixed find, and what does it leave unexplained? Which selectors need no teacher?

::: answer
Every position from the first token to the released checkpoint has been tried:

- From the first token, with no dense warm-up (DeepSeek-V4.1-Flash).
- After a trillion dense tokens (V4-Flash).
- From mid-training (GLM-5.2), or at the end of it (GLM-5).
- In post-training, on a model released without a selector (Kimi K3.1 Pro).
- After release, by distilling an indexer onto a frozen checkpoint (Latent Sparse Attention, ZHA).

MSA ran one model on the same tokens twice, once sparse from the start and once with selection added late. The native model led on every retrieval, mathematics, image and video row, and the converted one on five rows of the general and code groups. That sparse pretraining beat full attention itself is unexplained, and the table gives no error bars. Designs that select with the attention's own keys, or retrofit a dense model with no gradient updates, drop the student: only a separate selector needs a teacher to select well.
:::

### Projecting a mixer {kind=compute at=residual-mixers-must-stay-stable}

Let a layer's raw mixing matrix be $\begin{pmatrix}3&1\\1&1\end{pmatrix}$. Do one round of the Sinkhorn iteration: divide each column by its sum, then each row by its sum. Apply the raw matrix to the streams $(2,4)$, and then the doubly stochastic limit, which has $0.634$ on its diagonal. What would the raw matrix's top eigenvalue do to a signal over ten layers? Why can training pass through this constraint and not through top-$k$?

::: answer
The column sums are 4 and 2, giving $\begin{pmatrix}.75&.5\\.25&.5\end{pmatrix}$. The row sums are 1.25 and 0.75, giving $\begin{pmatrix}.600&.400\\.333&.667\end{pmatrix}$. The raw matrix sends $(2,4)$ to $(10,6)$, a total of 16. Its top eigenvalue is $2+\sqrt2\approx3.41$, which would multiply the signal by about 200,000 over ten layers. The limit sends $(2,4)$ to $(2.73,3.27)$, and the total stays 6. Sinkhorn is division repeated, so it is smooth, and DeepSeek backpropagates through all twenty iterations. Top-$k$ is a choice, so a separate selector needs a teacher.
:::

### A router put back {kind=case at=experts-must-stay-balanced}

Why is RL where routing goes wrong fastest? MiMo intervened on a run whose expert loads had become unbalanced. What did it restore, what did it keep, and what did the outcome show? What did MiMo and MAI each decide about the router in RL?

::: answer
RL's data are narrow. With a trainable router, the share of cold experts, which receive almost no tokens, rose within twenty steps. MiMo restored the router's parameters to their pre-RL values and kept every other weight from step 20. Load balance recovered, and benchmark scores did not move. The expert stores had kept what they learned under a router that was put back. MiMo froze the router for RL. MAI keeps it free, with a balancing coefficient of $10^{-2}$ during self-distillation and $10^{-5}$ during RL. A large coefficient during RL harms the climb, while the balance that self-distillation installs carries over.
:::

### Long context comes late {kind=explain at=long-context-comes-late-and-it-comes-cheaply}

MAI's last stage, at 256K, is 150 billion of about 33.5 trillion tokens. What share is that? What do MAI's ablations say about why so little is enough? Who disagrees about the data? What does the essay warn about a capability that arrives this fast?

::: answer
$150/33{,}500\approx0.45$ percent, less than half a percent. On small models, the vast majority of the improvement in loss at 256K came in the first 1 to 10 percent of the extension phase, and upweighting long documents gave no meaningful improvement. MAI's reading is that "the model is not acquiring fundamentally new capabilities during context extension, but rather calibrating its positional and attention mechanisms". Kimi K3's report disagrees: "Length alone, however, does not confer long-range capability", and Moonshot synthesizes documents that can be solved only by attending across the full million tokens. What comes fast can leave fast. MAI's self-distillation could erase long-context behaviour unless mid-training data was mixed back in.
:::

### How RL goes wrong {kind=explain at=what-rl-optimizes-and-how-it-goes-wrong}

In GRPO, what is an answer's advantage, and what does the importance ratio correct for? The essay then sets three headings over RL at scale: stale rollouts, verifiers, and environments. State the point of each.

::: answer
For each prompt the model samples a group of answers, and an answer's advantage is its reward relative to the group, $(R_i-\operatorname{mean})/\operatorname{std}$. Every token of the answer gets that advantage. The importance ratio $\pi_\theta/\pi_{\rm old}$ corrects for the policy having moved since sampling.

- Stale rollouts: sampling and learning run at once, so a rollout may come from weights the learner has since left behind. The asynchronous recipes buy throughput with a loss of freshness, and most of them cap it.
- Verifiers are the attack surface: a passing test does not distinguish a solution from an exploit, and the models find the exploits. Without a grader that zeroes confirmed hacks, policies under pressure to raise pass rates drift toward the reward's shortcuts, and those are written into the stores.
- Most of the gain is in the environments: the labs credit the scale, diversity and verifiability of their environments, not new algorithms. These attributions are the labs' own.
:::

### Two jobs for distillation {kind=distinguish at=post-training-edits-the-stores}

Post-training uses distillation in two ways: to consolidate specialists into one checkpoint, and on a run's own rollouts. Describe each, and give one known cost or risk of each.

::: answer
Consolidation: a lab trains several specialist policies, which are whole models and have nothing to do with routed experts, and distils them into one checkpoint. On-policy distillation lets the student generate and has the teacher score each token, so the student learns on the states it actually visits. It is cheap, and on small models students match their teachers on the teachers' domains while falling below the base model outside them. The teachers' origin matters, since a student can absorb only what lies close to it.

Self-distillation: MAI periodically collects rollouts from an RL climb, runs SFT on them starting from a mid-trained checkpoint, and resumes RL from the result. It uses the loop to change the prompt format, to carry a climb onto a new base model, to filter out reward hacking, and to recover from collapses. The risk is that distillation can copy a policy too exactly. On the order of a million traces match the teacher, and many more narrow the policy, which leaves "little room for exploration once RL resumes".
:::

### What post-training changes inside {kind=explain at=what-changes-inside}

Which contents of the trained stores are the fragile case, and what does the damage? Give the essay's evidence that some forgetting is not erasure, and that how far a store moves does not say how much it matters.

::: answer
Facts are the fragile case. In a small model, fine-tuning on new people collapsed old facts within about a hundred steps while attention patterns stayed stable, and fine-tuning on people it already knew did no such harm. New keys do the damage. Which stores take it is unsettled: one study puts it in the feed-forward layers, another divides it almost equally between attention's value and output weights and the feed-forward layers. Some forgetting is not erasure: removing the top singular direction of each weight update brought much of the recall of old facts back, at a cost in new-fact recall. And in one model the weights move about equally at all depths under full RL, yet training one layer alone recovers very different shares of RL's gain, with the strongest layers in the middle of the stack.
:::

### The line bends back {kind=case at=the-line-bends-back}

Self-distillation already carries RL's rollouts back onto a mid-trained checkpoint. Give four further cases in which a later stage reached into an earlier one. Which holds the sharpest warning?

::: answer
- MAI decays its pretraining learning rate only to a tenth of its peak, because decaying less improved results after RL.
- MiMo saw a tendency toward reward hacking in early experiments, synthesized examples of the model correcting itself, and put them into mid-training.
- Moonshot watched vulnerability research improve as post-training scaled, found one root in the mid-training corpus and one in the RL environments, and removed the data from both stages.
- Qwen let each block read only the two strongest branches of its gated residual. Pretraining loss and benchmarks were almost unaffected, but quality degraded clearly after post-training.

The last is the sharpest: "pre-training metrics alone would have led to the wrong decision." Choosing what to write early for what it will do late is a bet.
:::

### Open process, open weights {kind=distinguish at=open-process-open-weights}

What question does an open process answer, and what question do open weights answer? Give a case of each without the other. In the essay's comparison of four public pairs of checkpoints, which pair isolates a single stage, and what did that stage change?

::: answer
An open process says what was done and what its authors believe it did. Open weights let anyone check what happened to the stores. MAI-Thinking-1 has closed weights and an open process. GLM-5.2 and GLM-5.3 supply the checkpoints with an account of method and few numbers. A question like "what did RL change in the gates?" needs both. MiMo's pair is the only one that isolates a stage, the distillation that followed RL. That pass changed the stored weights by at most about 0.2 percent, near the format's resolution, and left the routers byte-identical. In the three pairs that span post-training, attention and shared experts moved near 10 percent, and the selectors moved most.
:::

### What the weights keep {kind=explain at=what-the-weights-keep}

When one of MAI's climbs collapsed, why did going back to an earlier checkpoint often fail, and why did distillation work as a repair? What does the essay conclude about reading a store, and about the order of the stages?

::: answer
Going back fails "as some instabilities are already embedded in the model parameters many steps before the actual collapse occurs." A store takes good updates and bad ones alike, as the same kind of number, and nothing in the weights says which is which. Behaviour is the only label, and it arrives late. Distillation copies what the model does and leaves the weights behind, along with whatever was broken in them and not yet showing. Nobody can tell what a store holds by reading its numbers, only by running it forward and seeing what survives. That is why the line bends back. The stages keep their order because a few orders are known to fail, and the rest are too expensive to test.
:::

### What the evidence cannot show {kind=limits}

On what does the essay's evidence rest? Name four places where it says its findings are not established for the frontier models.

::: answer
Almost everything rests on what the labs chose to say, so the evidence is open process, not open weights.

- The order of writing: the plateau experiment ran at 44 million parameters on one task, and nobody has run it at scale.
- Capacity: a frontier run mixes facts into other text, so no number from a pure-facts experiment says what a trillion-parameter model holds.
- Inside a post-trained model: the studies run from 44 million to 70 billion parameters, mostly on mathematics. No published measurement resolves the 2026 frontier's own stores, the delta-rule gates, the indexers and the routed experts across a long climb.
- The weight comparison: endpoints, on a handful of tensors. GLM's "same base model" may mean two post-training runs from one base, and K3.1 Pro appears to include a rerun of mid-training. The table is offered as evidence that the measurement is within reach.
:::
