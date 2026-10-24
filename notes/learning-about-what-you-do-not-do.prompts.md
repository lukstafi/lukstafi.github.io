# Prompts for Learning About What You Do Not Do

*The human-side prompts that developed and steered the draft, in conversation order. Assistant responses, button replies, and interface metadata are omitted. The conversation began with Part 1; see [Prompts for Who Teaches the Weights?](who-teaches-the-weights.prompts.html).*

## The bridge question

Let's start writing the essay on continual learning, and continual-learning related RL. On top of what we already explored, see notes/research/ , let's also cover VPO: see notes/private/VPO-Yacine_podcast.vtt , also https://arxiv.org/html/2605.22817v1 etc. I'm curious if VPO line of research can be connected with Maei and Sutton's 2010 paper notes/private/GQ_lambda-TD_prediction_with_eligibility_traces-1920.pdf ?

## Part 2

Three parts is fine. Draft Part 2 on GQ(λ), Horde, successor features/GPI and VPO.

## Going deeper through the RL essays

Can we go deeper technically if we connect to the two prior essays on RL (four Substack articles)? notes/how-can-a-reward-train-a-neural-network.md and notes/how-does-a-policy-improve.md

## Review

Go ahead, review parts 2 and 3, then commit. Thanks!

## Links

Yes, add inline links to papers at first mention across all three parts, like How Does a Policy Improve?. I thought footnotes might be good but the definition-highlight-style links are better.

## Evolutionary search

We have an essay touching on evolutionary algorithms.

## Second review

This can be trimmed even if we preserve all info and examples, at least the early sections. Can you make it tighter? Any chance we could make more / earlier references the RL intro essay / other RL essays? The part about giving up either function approximation or guarantees, what does giving up approximation mean?

But it's tabular in the sense of non-parametric? Exhaustive tabular is for toy problems only

## Traces and momentum

Why do the features $\phi$ enter into the eligibility trace verbatim?

Interesting, so eligibility traces are similar to implementing momentum in SGD?

Looking at what we said about eligibility traces in earlier articles, would it be worthwhile to include this comparison in this article? (e.g. in a box)

## World models

Are we building a latent state (+ action) world model via the features $\phi$? While $\theta$ is the policy parameters?

Do we cover successor features in here or in part 3?

## Fixed points

What is the update a gradient of, loosely speaking?

So it's a gradient toward the Bellman fixpoint?

Worth adding a box or a subsection on this. The two bullet-points from your last response, and a remark that $h$ corrects the sample error from multiplying two expectations. WDYT? Also: Hmm, is this at all related to https://arxiv.org/html/2609.16222v1 ?

## Conditioning

We mention GVF without defining the acronym.

Is it related to the later research on GVFs which was IIRC goal-conditioning?

Is GPI related to regret minimization for multi-armed bandits?

How much exposition did we give multi-armed bandits in the earlier essays? (E.g. around UCT)

There's recent work: https://arxiv.org/html/2610.19783v2 It's in between AWR and upside-down RL.

## The library

Does the GPI policy library keep training the old policies, or only iteratively adds new policies?

But the GPI mixture-policy keeps using the frozen policies in their winning domains?

"A continual learner does not train only on its current policy's samples." This is an assumption about the training economics, right? "For best data efficiency, ..."

Looks good overall! Please make a final editorial pass, thanks!
