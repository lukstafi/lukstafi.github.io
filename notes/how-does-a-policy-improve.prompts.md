# Prompts for How Does a Policy Improve

*The human-side prompts that developed and steered this essay, in conversation order. Assistant responses and interface metadata are omitted. The two source slide decks are private; their filenames identify the material without publishing the files.*

## Source format

Which format do you prefer to read slides in: PDF, ODP, or PPTX? They have embedded screenshots of articles (figures etc.)

## Initial request

*Attached slides: Model-Based_RL.pdf and PWIL-Relative_Entropy-MPO-AWR.pdf.*

I'm thinking that we could write an expository essay for the next slot on our blog, built around the attached slides, also present under notes/private/ . It would be quite technical. If nothing else, a refresher for me.

## First pass

*In response to a choice between a proposed structure and a complete draft:*

Proposed structure and technical through-line

## Mathematical connections

Would this be covering connections to ELBO and EM?

## Recent research

These slides are at least 5 years old. Are there recent research highlights worth mentioning?

## Length and scope

You can budget for 8,000 words, a substantial writeup. The hard limit is 11,000 words, and I'd rather not split into two articles.

## Drafting

Go for it, thanks!

## Generalization in the opening example

"Its usual behavior is to take the familiar route": maybe e.g. "Its instinct is to take the route that looks familiar"? That implies generalization the former suggests revisitng an exact state.

## Explicit state arguments

"For a recurring example, imagine a delivery robot deciding whether to wait" -- maybe clearer to write with the function parameters? $\pi_0(s,.)$ and $Q^{\pi_0}(s,.)$ WDYT?

## Introductory companion

*The subsequent discussion led to a separate introductory article, “How Can a Reward Train a Neural Network?”. Its [prompt companion](https://lukstafi.github.io/notes/how-can-a-reward-train-a-neural-network.prompts.html) records the framing and the request to introduce Bellman optimality before policy gradients.*

## Return distributions and conditioning on outcomes

*The discussion of discounting, eligibility traces, risk, exploration, and upside-down RL is recorded in the [introductory article's prompt companion](https://lukstafi.github.io/notes/how-can-a-reward-train-a-neural-network.prompts.html#discounting-and-effective-horizons). It led to additions to both articles.*

Sounds good. How do we incorporate this discussion into the articles? Just the introductory article, or do we split?

Sounds good. Let's do that.

## Relative feedback and representation learning

GRPO made me think of contrastive vs. regularized methods in representation learning. I wonder if it's worth bringing up, but in the core article that I haven't started reading yet? (Too heavy for the introductory one.)

Thanks! In "Which World Model", we write "[Mattick] agrees with LeCun that the contrastive instruction to pull similar examples together and push others apart insufficiently constrains a useful representation." Maybe we could refer back to it saying sth like that RL has internalized that lesson?

## Making the policy-improvement argument explicit

Introduction is now on Substack! Coming back to "How Does a Policy Improve?". This fragment is not landing with me: "The policy-improvement argument explains why this local operation has a global consequence. [...] then applying its Bellman operator repeatedly propagates that inequality forward. Monotonicity and contraction give `V^π′≥V^π`." The two equations are the same equation, where does monotonicity and contraction enter here?

Ah because it's $Q^{\pi}$ rather than $\pi'$, right!

Do you want to spell out the contraction? Adding a mention of following the old policy or somehow pointing out the π versus π' would be enough for me, but spelling out the argument would also work.


A bit tighter: drop the sentences: replace "**Monotonicity** means that `v≥w` implies `Tπ′v≥Tπ′w`:" by "`Tπ′` is monotonic:", drop "The expression `Tπ′nVπ` evaluates ..."

For proving the J difference formula: "Along a trajectory the value terms telescope." But the expectation isn't directly over trajectories, I would first say e.g.: "Rearrange the expectation space from states to trajectories."

## Explaining the benefit of model-generated experience

This paragraph is probably too verbose, and a bit confusing: "Model-generated data offers cheap computation, but not independent evidence." I'd say "Model-generated data replaces costly environment interactions by cheap computation." Correspondingly, "computational reuse" doesn't sound intuitive, but maybe it's the technical term used. What I think happens is that we transfer evidence of world transitions into a format that on-policy learning can use. What do you suggest?

Is my intuition right that this helps because learning world transitions is more sample efficient because learning action and state values is policy-sensitive? (Even off-policy, it's values *for* a policy>)

Thanks, let's do these two changes combined.

## Clarifying recurrent memory in the latent state

Latent state: "Here `z` can include deterministic recurrent memory as well as stochastic variables." Is q giving a stochastic model, while p alone would suffice for a deterministic model? It's not that q and p are used alternately when unrolling / executing a trajectory; they together model a stochastic process. Do I get it right?

So q is used to initialize a rollout and p to perform a rollout? And during execution, do we only use q?

But the q-p formulation does not mention h.

Maybe: "Here `z` can include deterministic recurrent memory (whose transition can be shared between q and p) as well as stochastic variables." WDYT?

Do that, thanks!

## Explaining reparameterization gradients

"Continuous random variables can be expressed as differentiable transformations of parameter-independent noise, enabling reparameterization gradients. Straight-through estimators enter for discrete choices; they are not a universal description of all gradients through Dreamer’s model." Is any of this further explained later on? The reparameterization trick is neat, so maybe we could explain it here to not name-drop.

## Identifying data and learned distributions in the ELBO

Can we make the q and p more tangible in "For a generic latent-variable model, variational inference gives ..."? Which expressions are learned and which are empirical / ground truth?

Instead of "It is neither an empirical frequency nor a separate prediction network." let's say something like: it's not tractable, but we want to maximize it to fit the data distribution.

For "the KL term keeps their inferred representations compatible with the prior" could we say "the KL term keeps their discriminatively inferred representations compatible with the generative prior"? Or would "discriminatively" be unjustified?

Which learned components are useful downstream, and which are auxiliary? Or do all of them have different uses?

Do both updates, thanks.

## Connecting the cross-entropy method to BOA

Offtopic: "iteratively fits a proposal distribution to an elite set of high-scoring candidates" reminds me of Bayesian optimization.

However BOA was originally an improvement over genetic algorithms, before it got invaded by math afficionados.

Ah right, I was confused but in a good way (BO and BOA are related).

Let's add a reference to BOA next to the cross-entropy method (makes the article more personal for me).

## Tightening the planning discussion

Remove this filler sentence: "An ensemble is a practical estimator, not a certificate that all important uncertainty has been captured." Also this is too long: "“Offline planning” and “offline RL” should therefore never be treated as interchangeable labels without explaining the intended meaning." -> "So we can have online planning with offline RL." would be enough.

## Clarifying AlphaZero's tree search

Right, so does Alpha Zero actually implement MCTS with policy network-based rollouts, or does it do deterministic tree expansion based on the value networks?

So it combines game research with learning updates. It doesn't do MCTS because it does deterministic best-first expansion, with exploration bonus derived from visit counts. WDYT?

Do that, thanks!

## Connecting MuZero to JEPA

Maybe we could point from the MuZero paragraph to the "Which World Model" paragraph discussing JEPA.

## Tightening the transition to policy improvement

Remove filler: "They are different achievements."
Would it be pendanting if in "Let `p(a)` be a reference policy with positive probabilities and let `Q(a)` be a fixed vector of action values." we had `a |-> p(a)` and `a |-> Q(a)` instead?

## Mass covering and mode seeking

Would it make sense to discuss mass covering versus mode seeking at the beginning of the second part?

Go ahead, thanks.

## Connecting KL to entropy

Do we bring the entropy connection later on? We could introduce it in the KL section.

## Clarifying the two uses of KL

I don't like this style: "The roles of the distributions matter as much as their names. Constructing an improved policy against a reference and fitting a neural policy to an improved target are separate operations." How can we say it more clearly in one sentence?

That's great. Do it.

## Showing where the log normalizer comes from

"Substitute the expression for `q∗` into the KL divergence to obtain" -- maybe we could make it easier to see how `log Z` ends up in the outcome, unless you think it's not illustrative and taking on faith is good enough.

## Removing the imitation-reward detour

Jumping ahead a bit because this can impact how we feel about word counts: Should we remove imitation learning from the essay? PWIL was on the slides because imitation learning was one of the core focuses of the group (and the author of that algorithm was in the group also).

Go ahead and remove it. We'll still keep the split into two parts because I think we should explain a few more things in the core essay.

## Explaining Lagrange multipliers

We can have a brief box (using Markdown quotation) to explain constraint optimization via Lagrangian multipliers.


"use an unrestricted multiplier like `c` above" -> "use an unrestricted multiplier like `c` in the paragraph about `F(q)`"


"“Using a hard constraint” therefore does not mean avoiding Lagrange multipliers" -> "“Using a hard constraint” therefore does not mean avoiding temperature" WDYT?

Go ahead, thanks.

Is the intuition behind Lagrange multipliers that the force to keep the constraint equals the push on the constraint from the objective?

I think this is worth adding to the essay. I'm not sure how extensively: whether the full paragraph you provided or just a brief remark.


## Clarifying the auxiliary observation

"and it should not be mistaken for proof that a trajectory is optimal" -> "and `O = 1` doesn't mean that a trajectory is optimal", right?

## Showing the exact ELBO gap

Let's add a step into the equality `logpθ​(O=1)−L(q,θ)=DKL​(q(τ)∥pθ​(τ∣O=1))` to clarify the derivation of the exact ELBO gap.

## Interpreting the posterior through selection

The ELBO-EM section does not give an explicit intuition for the posterior or latent `q`. Is `q` related to the proposal distribution from Bayesian Optimization (Algorithm)?

That's neat! (Pun not intended.) Let's add this connection to the article as a box.

## Explaining the feasible trajectory distribution

"We can impose that feasibility by restricting the auxiliary distribution to ..." -- add sth like "to a form that cannot adapt based on state transitions" i.e. point out verbally what the difference is.

## Making occupancy distributions tangible

"Let `ν(s,a)` be the candidate occupancy and `μ(s,a)` the reference data distribution." -- Let's give "candidate occupancy" and "reference data distribution" a better handle on how it connects with earlier content, maybe not formally but in a few words. E.g. "Let `ν(s,a)` be the candidate occupancy (probability that the candidate policy visits `s` and picks `a` there) ..."

## Deriving the flow-constraint contribution

This jumps too quickly for me: "The coefficient of each `ν(s,a)` in the Lagrangian contains ..." This pattern matches on very familiar formulas, but the derivation is different, so the familiarity makes one overlook the opportunity to build the intuition.

I'd help the reader via this parenthetical: "Keeping `ν` normalized and adding the KL-budget term (i.e. the `DKL​(.∥.)≤ϵ` constraint) gives"

## Splitting the essay into three installments

How many words are from the beginning of part 2 to the beginning of section "*From return distributions to return-conditioned policies"?*

Would it make sense to make it a split point for part 3?

And the other option of putting return conditioned policies into part two, is it a worse fit conceptually? ?

I'm sure I'll ask for adding things to part three as I read through it, so let's go for the three-parter with your motivation for the split.

## Representing MPO's improvement distribution with weighted samples

In MPO, is the non-parametric distribution `q_i` a weighted average of samples from the replay buffer?

"Their empirical weights are proportional to exponentiated critic values." -> "They are weighted proportionally to exponentiated critic values to form a single sample of the non-parametric distribution, thus defined." WDYT?

This is not an empirical approximation, this is a sample? It's how that distribution is defined. (Sorry about being confused, yes not a single sample.) Ah but yes the empirical distribution of the samples is an approximation...

Yes, let's do that.

## Trimming MPO and explaining expectiles

At the end of the MPO section, I'd drop this filler: "The likelihood objective tells us what target to fit; it does not guarantee that the representation or dataset supplies the distinctions needed to fit it well." IQL subsection: what is "an upper expectile"? I'd keep it but parenthetically explain.

## Making IQL's value propagation explicit

The IQL subsection is still mysterious e.g. as to how the learned value gets propagated through transitions. But maybe that's fine. Maybe the gist you were after is perfectly expressed, and we don't want to bloat the article more.

Let's add that. Thanks.

## Clarifying the return in the data conditional

Under Decision Transformer, what work does this sentence do? "Both reflect the continuation behavior represented in the data; neither automatically describes what an improved policy will achieve."

Ah good, do that.

## Separating outcome variability from baseline weighting

This is confusing to me: "This distinction also matters when interpreting AWR’s sampled advantage estimates: subtracting a fixed state baseline does not remove outcome variability before exponentiation." What we discussed in earlier sections  is that, although subtracting could preserve the normalized distribution, it changes the algorithmic behavior (presumably because we don't normalize).

Do that, thanks!

## Making the search normalization constraint explicit

Part 3 woohoo! "Differentiating with a normalization multiplier `c` gives" -- it's the Lagrange multiplier from the summing to 1 constraint, right?

Do that, thanks!

## Connecting bandits, UCT, and tree search

We could have a box explaining some of MCTS, UCT, and multi-armed bandits. I'm not sure what the scope is that's best.

Sounds good, let's add!

## Comparing the full PUCT score with the derivative

"The exploration term can then be expressed using `p/π^`, the same ratio appearing in the derivative of the regularized objective." This confuses me because that formula from the derivative used Q values.

|A| is action size, right? This definitely helps, add it.

## Explaining the Gumbel search methods

The Gumbel methods are underexplained, no idea what these algorithms are doing.

## Expanding the DPO derivation

The hard limit does not apply anymore because we're splitting into three parts for Substack.

Can we spell out a bit more detail about DPO? What's in there is clear, but it cuts off. Or is related content covered later?


## Defining the accepted-output conditional

In PMPO, what (conditional) event specifically has the distribution `q+`​?

There's no need to introduce another sentence. I would simply add the intermediate definitional $\(q_+(y)=P(Y=y\mid accepted)\)=...$

## Clarifying fixed and refreshed reference policies

For the discussion around DPO and PMPO, is the reference policy a twin delayed variant of the trained policy, or is it fixed all the way back to the pre-trained policy?

Let's add that information, thanks. I think we can add it in this paragraph rather than inline when introduced: "KL-regularized policy improvement embodies a lesson related to the representation-learning discussion". WDYT?

## Clarifying GRPO's group-relative advantage

"GRPO’s relative weighting acts on response probabilities, whereas contrastive representation learning acts on embedding similarities." Confusing.

Yes, remove it. Can we see GRPO as a poor man's way of computing the advantage?

## Connecting GRPO to the earlier RL machinery

I would also remove the restatement: "These are complementary roles." Let's maybe try analogizing GRPO to the machinery we covered throughout the RL series. We have the non-parametric advantage computation. We have the high-variance, low-bias effect of using returns rather than action values. We have something analogous to eligibility traces by updating the whole trajectory at once. WDYT?

I wouldn't say GRPO "reconnects", it is remarkably simple except I keep forgetting it has the nuance of PPO also. It is more that we can see it in a richer light.

Make the expansion, thanks!

## Linking the GRPO objective back to PPO

Discussed PPO before, so I would change "These advantages enter a PPO-style objective" to sth like "These advantages enter an objective originally worked out by PPO (link)"

*We haven't (sorry speech rec glitch)

## Explaining shortcut forcing

In Dreamer 4, what's "a shortcut-forcing objective"?

Let's add this info in a box.

## Explaining POCO's candidates and fitting objective

Can we maybe give a bit more detail about POCO?

## Making POCO's supervised targets explicit

What does POCO actually minimize? It has fixed actions in the optimized expressions.

I see. These are targets, okay.

Let's do that. Why optimize toward samples rather than more directly toward whatever process that sampled them?

## Identifying the weighted batch update

So this is the action mixing approach. We've seen it before. Was it MPPI, or which?

Right, the sum is on top of the losses, so it's just a batch update.

Maybe add: "This corresponds to a weighted batch update." right below the formula.

## Shortening the loss-capping explanation

Capping a loss just throws out a bad sample.

This is all too lengthy. My first sentence was just eight words or so. Replace this with something like it: "As written, a candidate loss above `ζ` contributes no gradient through that capped term, while the replay loss remains active. Capping a loss does not itself bound the parameter update or the policy’s KL divergence."

## Tightening the concluding comparison

Small loss doesn't mean small gradients, right?

Close to the end, I would drop this sentence except then the paragraph ends a bit abruptly. But informationally it doesn't make much sense. "The common questions remain useful even when the answers differ."

## Final editorial pass

the article becomes a lighter reading toward the end, but I think that's good to give people some wind-down time. Some parts are authorial choice that I'm not entirely sure about but can accept, e.g. "Confusing them makes it easy to mistake repeated internal calculation for stronger empirical evidence." (Is it something that can really be confused? unless you call wishful thinking a confusion...) It was exciting for me to recall those things in a simultaneusly more precise and a bigger-picture way. Thanks for the fruitful multi-day session! Please do a final editorial pass over the essay.

## Absolute links for Substack

Are all the cross-file links absolute? That's needed for Substack.

Ah, maybe that got fixed recently.

## Committing the essay and index update

Let's commit, include index.html update I added

## Preparing the Substack draft

Can you help me publish? Here's what I get:
```yaml
(.venv-substack) lukstafi@LukaszsacStudio lukstafi.github.io % .venv-substack/bin/python scripts/publish_to_substack.py notes/how-does-a-policy-improve.md
Traceback (most recent call last):
  File "/Users/lukstafi/lukstafi.github.io/scripts/publish_to_substack.py", line 410, in <module>
    main()
    ~~~~^^
  File "/Users/lukstafi/lukstafi.github.io/scripts/publish_to_substack.py", line 351, in main
    prepare_images(doc["body"], md_path, assets_dir)
    ~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/Users/lukstafi/lukstafi.github.io/scripts/substack_media.py", line 53, in prepare_images
    from PIL import Image
ModuleNotFoundError: No module named 'PIL'
```

## Updating the prompt record

Can you update the prompts file? Do you have my prompts readily and available?
