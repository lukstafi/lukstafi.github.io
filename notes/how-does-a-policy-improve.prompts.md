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

*The subsequent discussion led to a separate introductory article, “How Can a Reward Train a Neural Network?”. Its [prompt companion](how-can-a-reward-train-a-neural-network.prompts.html) records the framing and the request to introduce Bellman optimality before policy gradients.*

## Return distributions and conditioning on outcomes

*The discussion of discounting, eligibility traces, risk, exploration, and upside-down RL is recorded in the [introductory article's prompt companion](how-can-a-reward-train-a-neural-network.prompts.html#discounting-and-effective-horizons). It led to additions to both articles.*

Sounds good. How do we incorporate this discussion into the articles? Just the introductory article, or do we split?

Sounds good. Let's do that.

## Relative feedback and representation learning

GRPO made me think of contrastive vs. regularized methods in representation learning. I wonder if it's worth bringing up, but in the core article that I haven't started reading yet? (Too heavy for the introductory one.)

Thanks! In "Which World Model", we write "[Mattick] agrees with LeCun that the contrastive instruction to pull similar examples together and push others apart insufficiently constrains a useful representation." Maybe we could refer back to it saying sth like that RL has internalized that lesson?
