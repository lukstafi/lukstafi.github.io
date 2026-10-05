# Prompts for How Can a Reward Train a Neural Network

*The human-side prompts that developed this introductory companion to “How Does a Policy Improve?”, in conversation order. Assistant responses and interface metadata are omitted. The initial slide reference prompted a discussion of audience and scope; the later instruction freed the article from the slides' progression.*

## An introductory companion

What do you think of these very introductory slides? /Users/lukstafi/ocannl-staging/docs/slides-RL-REINFORCE.md I'm contemplating releasing two articles at the same blog slot, since this one moves quite quickly. An RL-novice blog reader could read just the introductory one.

## Standalone reading and preparation

The slides chose to focus on policy gradients to not complicate the presentation with Bellman equations yet get somewhere exciting. But maybe the introductory article doesn't need to stick to that progression. It depends on whether we want it to work more standalone or more as preparation for the decor as an article we started with.

## Speech recognition correction

"the decor as an article" -> "the core article" (sory speech rec)

## Bellman optimality

Sounds good. You can ignore my slides. Should we also introduce Bellman optimality equations to prepare for the follow-up essay?

## Drafting

Go for it. Thanks!

## Eligibility traces and their modern connections

An old-school approach to credit assignment was to use eligibility traces, but this idea died out, hasn't it?

Let's add that. Thanks.

## Reasonable rewards and unintended incentives

Nitpick: "Even a positive reward can favor undesirable behavior" -- "positive" here doesn't capture the idea that the reward is "reasonable", better states/outcomes assigned more value.

## Discounting and effective horizons

Do we discuss the connection between the discount factor and effective time horizon?

What happens to the value function when episodes with end-of-episode reward are longer than the effective horizon?

Relative value of successor states is what counts, so is that insensitive to discount?

Isn't using eligibility traces and the discount factor kind of double discounting?

## Return distributions and exploration

Are there approaches that use a distribution of values (e.g., both expectation and variance) to replace using the discount factor?

Risk-sensitive RL would appear to penalize exploration? Is distributional RL also used in the opposite direction to improve exploration?

From distributional RL, the next step is upside-down RL.

## Dividing the discussion between the articles

Sounds good. How do we incorporate this discussion into the articles? Just the introductory article, or do we split?

Sounds good. Let's do that.

## Tightening the examples and Bellman explanation

"These are invented scores for an abstract problem, not measured delivery times." Is unnecessarily defensive, remove.

"They are not a requirement that an agent explicitly calculate every possible future. An algorithm might solve a small known model, learn estimates from experience, or combine both." This is a bit awkward, unclear, slightly verbose; I would replace it with sth like "Computing $V^\pi$ and $Q^\pi$ exactly is only possible in toy models, typically we approximate them."

## Clarifying the bias and variance tradeoff

"choosing `λ` changes the balance between sampling noise and prediction error" -- what's the difference, i.e. what is the prediction error and is the sampling noise coming from the environment, or from action selection (i.e. it's the noise of the Monte Carlo estimate of expectation)?

Sounds good, and we can also parenthetically mention the bias-variance trade-off (thanks for bringing it up). "... balances variability ("variance" in the tradeoff) across sampled trajectories—from both action selection and environmental randomness—against errors in the learned value estimates ("bias" in the tradeoff) ..." WDYT?

## Stored trajectories and off-policy learning

Is "replay buffer" related to "processing stored trajectories"? Is it worth bringing up offline RL?

Right, I actually meant off-policy (for a moment the distinction blurred in my mind). Let's add the short connection.

## Making the parameter dependence explicit

"Its expected reward is `J(θ)=6p`" There is an mental shortcut here because the formula does not depend on theta.

Let's add a reminder of $J$'s definition right before the equation for $\nabla_\theta J(\theta)$ in which the log-trick for $\pi$ is already applied.

## Removing a redundant clarification

What work does this sentence do? I.e. what would otherwise be confusing. "The sum over decisions is part of the equation; one term at an unspecified time is not the complete episode gradient."

I would remove the sentence. Your replacement is already in the text when we establish the equation.

## Making the baseline update order explicit

"For a clean unbiased-estimator argument, the baseline is fixed before the sampled action" -- What does it imply in practice? Which data flows to which gradient, ideally?

I would replace "the baseline is fixed before the sampled action" with something like"the baseline is trained/updated on a sample/batch/trajectory after the policy is done training/updating", WDYT?

Do that, "fixed" was confusing (underspecified) to me.

## Keeping distributional RL in policy terms

In the "Distributional RL" paragraph: "We can still choose actions by the mean" sounds confusing, because we spent most of the article using an explicit policy.

## Acknowledging policies derived from action values

Are Q-based agents (implicit policy) a thing of the past?

Ah good, let's add that.

## Removing an unhelpful evaluator caveat

Toward the end, this sentence is not doing any work: "The mathematics does not establish that the evaluator captures everything we care about in a response." We could say instead that specifying and balancing good training environments is challenging, and reward hacking remains a problem -- but don't have to.

## Removing another unnecessary qualification

Again, I would remove this: "These are extensions with their own assumptions, not prerequisites for understanding the basic gradient."

## Final editorial pass

Do a final editorial pass over the introductory article, thank you! I'm proceeding to the core article now.
