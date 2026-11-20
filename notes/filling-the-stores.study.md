---
title: "Study notes: Filling the Stores"
essay: filling-the-stores
track: keeps-learning
reviewed-against: "c00a4d0"
requires:
  - {at: every-layer-a-store#selection-is-learned-retrieval, for: selectors and the miss}
  - {at: every-layer-a-store#memory-along-depth, for: mHC and worked example 4}
  - {at: every-layer-a-store#the-seven-assembled, for: "the seven models, and which stores are written in training"}
  - {at: how-does-a-policy-improve, for: the GRPO family, strength: helpful}
  - {at: how-can-a-reward-train-a-neural-network#from-one-choice-to-a-complete-journey, for: REINFORCE, strength: helpful}
  - {at: who-teaches-the-weights, for: "self-distillation, and why a student absorbs only what lies close to it", strength: helpful}
  - {at: where-experience-goes, for: the continual-learning consequences of forgetting, strength: helpful}
introduces:
  - {term: "pretraining, mid-training, SFT, RL, distillation and drafter training", at: the-stages-kept-apart}
  - {term: rollout and policy, at: the-stages-kept-apart}
  - {term: plateau before the facts, at: what-pretraining-writes-and-in-what-order, gloss: "the stretch of training in which a model knows the kind of answer a template wants and not which answer", related: ["stores written in training and stores written while reading"]}
  - {term: Muon, at: normalizing-a-matrix, related: ["Sinkhorn iteration"]}
  - {term: AdamW, at: normalizing-a-matrix, gloss: "Adam with its weight decay applied to the weights directly, outside the normalization, where under Adam it differs from a penalty on the squared weights", related: ["Muon"]}
  - {term: steepest descent under a norm, at: normalizing-a-matrix, gloss: "what Adam and Shampoo become when their running statistics hold only the current step: the sign of the gradient under the largest-entry norm, its orthogonalized form under the largest-singular-value norm", related: ["Muon", "AdamW"]}
  - {term: distilling a selector from the attention it replaces, at: selectors-cannot-learn-through-top-k}
  - {term: dense warm-up, at: selectors-cannot-learn-through-top-k, related: ["REINFORCE"]}
  - {term: Sinkhorn iteration, at: residual-mixers-must-stay-stable, gloss: "alternately rescaling a matrix's rows and columns until both meet a target: sums of one, giving a doubly stochastic matrix (mHC's mixer, the bookmaker's prices over permutations), or equal lengths (V4.1's optimizer update)", related: ["Manifold-Constrained Hyper-Connections"]}
  - {term: balancing loss, at: experts-must-stay-balanced, gloss: "a loss that multiplies each expert's share of the tokens, a count with no gradient, by the average score the router gave it, so that the gradient lowers the scores of overloaded experts", related: ["mixture of experts"]}
  - {term: global batch, at: experts-must-stay-balanced, gloss: "all the sequences that feed one optimizer step across every device, as against the few sequences of one device's micro-batch", related: ["balancing loss"]}
  - {term: Quantile Balancing, at: experts-must-stay-balanced, gloss: "Kimi K3's exact update of each expert's routing bias, set from the previous batch so that the target number of tokens would clear it", related: ["Stable LatentMoE", "balancing loss"]}
  - {term: context extension, at: long-context-comes-late-and-it-comes-cheaply, related: ["interference between stored keys"]}
  - {term: expert quantization, at: precision-enters-by-post-training, gloss: "storing the experts' weights in 4 bits, trained through a full-precision master copy that the rounded copy is read from", related: ["mixture of experts"]}
  - {term: speculative decoding, at: drafters-model-the-policy, gloss: "a drafter proposes tokens and the main model keeps each with probability min(1, p/q), which leaves the text distributed exactly as the main model's", related: ["rollout and policy"]}
  - {term: stale rollout, at: what-rl-optimizes-and-how-it-goes-wrong, related: ["stale keys"]}
  - {term: reward hacking, at: what-rl-optimizes-and-how-it-goes-wrong}
  - {term: on-policy distillation of specialists, at: specialists-then-one-checkpoint}
  - {term: self-distillation on a run's own rollouts, at: self-distillation-at-production-scale, gloss: "SFT on rollouts collected from an RL run, started from a mid-trained checkpoint, after which RL resumes"}
  - {term: climb, at: self-distillation-at-production-scale, gloss: "MAI's name for a whole RL run, after its rising scores", related: ["self-distillation on a run's own rollouts"]}
  - {term: open process and open weights, at: open-process-open-weights}
uses:
  - {term: selector, from: every-layer-a-store}
  - {term: mixture of experts, from: every-layer-a-store}
  - {term: Manifold-Constrained Hyper-Connections, from: every-layer-a-store}
  - {term: stores written in training and stores written while reading, from: every-layer-a-store}
  - {term: importance ratio, from: learning-about-what-you-do-not-do}
  - {term: on-policy and off-policy, from: how-can-a-reward-train-a-neural-network}
  - {term: GRPO, from: how-can-a-reward-train-a-neural-network}
  - {term: REINFORCE, from: how-can-a-reward-train-a-neural-network}
  - {term: SwiGLU, from: every-layer-a-store}
  - {term: shared expert, from: every-layer-a-store}
  - {term: Stable LatentMoE, from: every-layer-a-store}
---

### SFT as distillation {kind=distinguish at=the-stages-kept-apart}

In what sense is most SFT now a form of distillation? Name the two ways in which it differs from distillation that matches a teacher's whole distribution on the student's own text. Which recipe in the essay goes furthest the other way?

::: answer
Most demonstrations now come from other models, so SFT trains a student on a teacher's outputs. It learns from sampled tokens only, one per position, not from the teacher's distribution over all tokens. And it learns on the teacher's trajectories, not the student's, so a student that strays reaches states it never trained on. On-policy distillation lets the student generate and has the teacher score each token. K3 scores only the sampled token, with a clipped log-ratio. V4 finds such token-level estimates too noisy and distils over the full vocabulary.
:::

### The plateau before the facts {kind=explain at=what-pretraining-writes-and-in-what-order}

A small Transformer is trained on biographies of invented people. Describe the three phases of its loss on the attributes. What is learned on the plateau, and which experiment shows it? What limits does the essay put on the result?

::: answer
The loss fell at first, as the model learned the language and the kinds of answer a template wants. It then stopped at the entropy of the attribute values: the model knew that a birthplace is a city and did not know which city. After a plateau, knowledge of the individuals emerged. What is learned on the plateau is a circuit in the attention. When training restarted from the same initial parameters, with the attention patterns of a later checkpoint fed in and only the feed-forward weights learning, the plateau disappeared. The experiment ran at 44 million parameters on data with one task in it, the order in the weights is not "attention first", and in a larger model on natural text the heads specialized for answers are still turning over at the end of training.
:::

### One gradient, two normalizations {kind=compute at=normalizing-a-matrix}

Muon takes the matrix of momenta $M=USV^\top$ and steps along $UV^\top$. Let a gradient be $G=10\,u_1v_1^\top+1\,u_2v_2^\top$ with $u_1=(0.8,0.6)$, $u_2=(-0.6,0.8)$, $v_1=(0.6,0.8)$, $v_2=(0.8,-0.6)$. Compute Adam's first step, which keeps the sign of each entry, and Muon's step. What does each normalization keep, and what do both throw away?

::: answer
$G=\begin{pmatrix}4.32&6.76\\4.24&4.32\end{pmatrix}$. All four entries are positive, so Adam's step is the all-ones matrix, of rank 1, and the weak direction is gone. Muon sets both singular values to 1: $u_1v_1^\top+u_2v_2^\top=\begin{pmatrix}0&1\\1&0\end{pmatrix}$. The weak direction now counts as much as the strong one. Both updates throw away the gradient's overall scale. Adam keeps the signs of the entries, Muon the singular vectors.
:::

### Adam's first step, and the W in AdamW {kind=explain at=normalizing-a-matrix}

Adam keeps two running averages for every parameter. Which, and how does it step? Why is its first step the sign of the gradient? Why is weight decay under Adam not the same as a penalty on the squared weights, and what does AdamW do instead?

::: answer
An average of the gradient and one of its square. Adam steps by the first divided by the square root of the second, so an entry with consistently large gradients and one with consistently small ones move at about the same rate. At the first step both averages hold a single gradient, once corrected for starting at zero, so the step is the gradient divided by its own magnitude: its sign. Weight decay shrinks every weight a little at each step. Under plain gradient descent that is the same as adding the squared weights to the loss, but Adam divides the penalty's gradient along with the rest. AdamW applies the decay to the weights directly, outside the normalization.
:::

### Two norms, two steepest descents {kind=distinguish at=normalizing-a-matrix}

Bernstein and Newhouse asked what Adam and Shampoo do when their running statistics hold only the current step. What does each become, and under which norm? How does Muon relate to them? Which parameters did Muon's author leave to AdamW, and what two changes let Moonshot scale Muon up?

::: answer
Each divides the gradient by its own size and becomes steepest descent under a different norm. Measured by its largest entry, the step is the sign of the gradient, as at Adam's first step. Measured by its largest singular value, it is $UV^\top$, Shampoo's orthogonalized gradient. Muon keeps one running average, the momentum, and divides it by its own size at every step. Jordan meant Muon only for hidden weight matrices: scalars and vectors go to AdamW, and he found that the input embeddings and the output head need AdamW too, the split DeepSeek-V4 keeps. Liu and colleagues added AdamW's decoupled weight decay and matched the size of each matrix's update to Adam's, and found Muon about twice as compute-efficient.
:::

### A third normalization {kind=distinguish at=normalizing-a-matrix}

DeepSeek-V4.1 updates its embedding tables and output head with neither Adam nor Muon. Why not Adam? What does it do to the momentum, and where does the result sit between the other two normalizations? How does the same alternation differ in mHC?

::: answer
Adam's state for 196 billion table entries costs too much memory. V4.1 keeps only a momentum, and divides each row of it by the row's length, then each column by the column's, eleven times over. The resulting update has rows of about equal length, and columns too: a normalization between Adam's, entry by entry, and Muon's, of the whole matrix. The alternation is the Sinkhorn iteration. mHC applies it to sums instead of lengths, which makes a positive matrix doubly stochastic.
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

### Taught, not rewarded {kind=explain at=selectors-cannot-learn-through-top-k}

How could REINFORCE train a selector, and why would its estimate be far noisier than for an early hard-attention model? Why does the KL to the main attention need no sampling? Which problem of reinforcement learning remains, and how does a dense warm-up meet it?

::: answer
Treat the indexer's softmax as a policy over sets of entries, sample a set, and raise its log-probability in proportion to how much lower the loss came out than a baseline. The estimate is unbiased and needs no gradient through the choice, and hard attention that picked one image location per word was trained this way. For a selector, one number per query, the loss, would have to grade a choice of 1,024 entries among about 250,000, in DeepSeek-V4-Pro at a million tokens. The KL needs no sampling because the teacher gives the probability of every entry, the reason V4 gives for distilling over the full vocabulary. Exploration remains: a KL taken only over the selected set teaches nothing about an entry the selector never picks. The dense warm-up shows the student the whole distribution before it acts, as SFT comes before RL.
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

MSA ran one model on the same tokens twice, once sparse from the start and once with selection added late. The native model led on every retrieval, mathematics, image and video row, and the converted one on five rows of the general and code groups. That sparse pretraining beat full attention itself is unexplained, and the table gives no error bars. Two designs drop the student. They make selection cheap by scoring the attention's own keys in groups, not by scoring every key with a smaller model: N-LSA clusters the keys and learns from the next-token loss alone, and CISA scores chunks of the cache by summaries of their keys, with no gradient updates at all. Only a separate selector needs a teacher to select well.
:::

### Projecting a mixer {kind=compute at=residual-mixers-must-stay-stable}

Let a layer's raw mixing matrix be $\begin{pmatrix}3&1\\1&1\end{pmatrix}$. Do one round of the Sinkhorn iteration: divide each column by its sum, then each row by its sum. Apply the raw matrix to the streams $(2,4)$, and then the doubly stochastic limit, which has $0.634$ on its diagonal. What would the raw matrix's top eigenvalue do to a signal over ten layers? Why can training pass through this constraint and not through top-$k$?

::: answer
The column sums are 4 and 2, giving $\begin{pmatrix}.75&.5\\.25&.5\end{pmatrix}$. The row sums are 1.25 and 0.75, giving $\begin{pmatrix}.600&.400\\.333&.667\end{pmatrix}$. The raw matrix sends $(2,4)$ to $(10,6)$, a total of 16. Its top eigenvalue is $2+\sqrt2\approx3.41$, which would multiply the signal by about 200,000 over ten layers. The limit sends $(2,4)$ to $(2.73,3.27)$, and the total stays 6. Sinkhorn is division repeated, so it is smooth, and DeepSeek backpropagates through all twenty iterations. Top-$k$ is a choice, so a separate selector needs a teacher.
:::

### Counting the load {kind=explain at=experts-must-stay-balanced}

Why do expert loads drift apart unless something stops them, and what do unequal loads cost? A balancing loss multiplies two quantities for each expert: which, and why both? What did DeepSeek-V3 use instead? Over what must loads be counted, and why?

::: answer
The imbalance is self-reinforcing: the favored experts are trained more rapidly and are then selected even more. An expert that is rarely chosen is a store that learns almost nothing, and since experts sit on different chips, the busiest one sets the pace of every step, or the tokens past its capacity are dropped. The balancing loss multiplies each expert's share of the tokens it actually received, a count with no gradient, by the average score the router gave it, which has one. So the loss lowers each expert's score in proportion to how many tokens it took. DeepSeek-V3 replaced the loss with a bias for each expert, added to the scores when experts are chosen and moved by a fixed step after each batch. Loads must be counted over the global batch, all the sequences that feed one optimizer step across every device. Counted within the few sequences on one device, a balancing loss spreads even a sequence of code over all the experts, and the experts cannot specialize.
:::

### Four projections in series {kind=explain at=experts-must-stay-balanced}

Name the four projections a token passes through in Kimi K3's routed path. Why do they add no depth to what an expert computes, yet make its activations explode? Which two changes cut the problem? What does Quantile Balancing change about the routing bias, and with what rule about timing?

::: answer
The layer's shared down-projection from 7,168 dimensions to 3,584, the gate and up projections of each expert's SwiGLU unit, the expert's down-projection, and the shared up-projection back to 7,168. With no nonlinearity between the first two, the extra matrices add no depth, but they multiply the scale: the output grows with the product of all their norms, and the down-projection counts twice, since a SwiGLU unit multiplies two maps of the same input. K3 puts an RMSNorm between the experts' summed output and the up-projection, which cuts the chain in two, and replaces SwiGLU with SiTU, whose two factors are capped by $\tanh$. Quantile Balancing replaces a fixed-step bias update with an exact one, set so that the target number of tokens would have cleared the bias in the last batch. The update waits a step, "for causality": no token's route depends on the other tokens of its batch.
:::

### A router put back {kind=case at=experts-must-stay-balanced}

Why is RL where routing goes wrong fastest? MiMo intervened on a run whose expert loads had become unbalanced. What did it restore, what did it keep, and what did the outcome show? What did MiMo and MAI each decide about the router in RL?

::: answer
RL's data are narrow. With a trainable router, the share of cold experts, which receive almost no tokens, rose within twenty steps. MiMo restored the router's parameters to their pre-RL values and kept every other weight from step 20. Load balance recovered, and benchmark scores did not move. The expert stores had kept what they learned under a router that was put back. MiMo froze the router for RL. MAI keeps it free, with its balancing loss weighted by $10^{-2}$ during self-distillation and by $10^{-5}$ during RL. Heavy weighting during RL harms the rise in score, while the balance that self-distillation installs carries over.
:::

### Long context comes late {kind=explain at=long-context-comes-late-and-it-comes-cheaply}

MAI's last stage, at 256K, is 150 billion of about 33.5 trillion tokens. What share is that? What do MAI's ablations say about why so little is enough? Who disagrees about the data? What does the essay warn about a capability that arrives this fast?

::: answer
$150/33{,}500\approx0.45$ percent, less than half a percent. On small models, the vast majority of the improvement in loss at 256K came in the first 1 to 10 percent of the extension phase, and upweighting long documents gave no meaningful improvement. MAI's reading is that "the model is not acquiring fundamentally new capabilities during context extension, but rather calibrating its positional and attention mechanisms". Kimi K3's report disagrees: "Length alone, however, does not confer long-range capability", and Moonshot synthesizes documents that can be solved only by attending across the full million tokens. What comes fast can leave fast. MAI's self-distillation could erase long-context behaviour unless mid-training data was mixed back in.
:::

### Quantizing the experts {kind=explain at=precision-enters-by-post-training}

What values can an MXFP4 weight take, and what do the 32 weights of a block share? Why do the labs quantize the experts and not the rest? What did quantizing after training cost in Allen-Zhu and Li's experiments, and how does training through the rounding work?

::: answer
Zero, or one of 0.5, 1, 1.5, 2, 3, 4 and 6, with a sign: 16 codes in 4 bits. Each block of 32 weights shares a scale, a power of two that stretches the grid to the block's largest weight. The experts hold most of the parameters, and so most of the memory a served model needs, and at 4 bits they take a quarter of it. K3 keeps attention, the shared experts and the router in higher precision. Quantizing trained models to 4 bits lost more than half their capacity. Training through the rounding keeps a full-precision master copy of each weight. The forward pass runs on the rounded copy, the gradient passes through the rounding as if it were not there, and the update goes to the master copy, where steps too small to move a weight to the next code still add up.
:::

### Two engines, one computation {kind=explain at=precision-enters-by-post-training}

Why does RL give a sharper reason than capacity to fix the precision early? How do K3 and V4 meet it? MAI uses 16-bit arithmetic in both its inference engine and its learner. Why is that not enough, and which two choices does its learner replay?

::: answer
The rollouts come from an inference engine and the updates from a learner, and every discrepancy between them compounds in the importance ratios. K3 keeps experts at 4 bits in both, and V4 samples rollouts on native 4-bit weights. MAI's two engines run different kernels, so their numbers still differ. Its learner replays the experts each token went to, and the top-$p$ mask, the set of tokens the sampler kept. A small numerical difference then cannot send a token to other experts, and the learner scores each token against the same set it was sampled from.
:::

### Exact speculation {kind=derive at=drafters-model-the-policy}

A drafter proposes a token $x$ with probability $q(x)$, and the main model gives it $p(x)$. The token is kept with probability $\min(1,p(x)/q(x))$, and at a rejection a replacement is drawn from $\max(0,p-q)$, rescaled. Show that the text comes out distributed as $p$. What is the chance that a guess holds, and what does the acceptance rate therefore measure? Why does a drafter that lags the policy in RL cost only speed?

::: answer
A token $x$ comes out as an accepted guess with probability $q(x)\min(1,p(x)/q(x))=\min(p(x),q(x))$. A rejection happens with probability $1-\sum_y\min(p(y),q(y))$. Since $p=\min(p,q)+\max(0,p-q)$ for every token, $\max(0,p-q)$ sums to exactly that amount, so the replacement yields $x$ with probability $\max(0,p(x)-q(x))$. The two add up to $p(x)$, and token by token the whole text follows. The chance that a guess holds is $\sum_x\min(p(x),q(x))$, one minus the total variation distance between the two distributions. So the acceptance rate measures how far the drafter is from the main model, whichever of them is right. Because the output is exact, a drafter trained on an earlier policy only lowers the acceptance rate, while a stale rollout biases the update.
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
