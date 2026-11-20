# Prompts for Filling the Stores

*The human-side prompts that developed and steered the draft, in conversation order. Assistant responses, button replies, and interface metadata are omitted. The research behind the essay began in earlier sessions; the scope, the title and the split from* Every Layer a Store *are recorded in [the prompts for that essay](every-layer-a-store.prompts.html).*

## Drafting

Let's draft the training article from notes/research/architectures-and-training-outline.md . What questions do you have before you start?

## Open process

(My original intent was about open process rather than open weights; but open weights might carry future interpretability essays.)

## Reading pass

Expert quantization is not explained.

Let's add boxes for AdamW and Muon. WDYT?

What does "accumulation-free" mean, since the statistics are part of Adam's definition?

Unclear what this editorial remark does. Remove? "We offer the result as a mechanism, not as a measurement of the seven."

Is it worth adding a box for Sinkhorn iterations? Is there a concept recorded for Sinkhorn? I see the Bookmaker study has "Sinkhorn iteration" in `related`.

Is there a relation between training the selectors and REINFORCE or other discrete policy optimization approaches?

"Two designs drop the student altogether." But doesn't the selector's efficiency depend on the selector model being smaller?

I have a vague complaint about the expert routing. For example, what causes exploding? Can we trace which four matrices it is? Is this problem equivalent to having a deeper FFN?

What's the "expert's share of the tokens" independently of "its share of the router's probability"? Isn't the former the sample of the latter? So it's not an expert's probability, but an expert's score. As an aside, in Switch is it a normalized score, or a sampling probability? I think adding the Gaussian noise makes it closer to a probability: the end result is a sample.

I remembered from the selectors section: "The two stop-gradients", but the formula only has stopgrad(P) explicit. Is there another one in L_LM?

Can you take a look at a few other things you wanted to check? I'll keep reading. (On Table 2 for Substack: render it as an image.)

What does the global batch mean? I've always been a bit confused about batches, since originally I thought batches are portions of a corpus, not the whole corpus, and mini-batches are a sub-split of a batch. But I think many sources take batch and corpus as synonyms.

Nit: "each expert's gate and up projections" -> "each expert's gate and up SwiGLU projections", although not necessarily, since SwiGLU is mentioned soon after.

"Both labs separate the choice of experts from the newest parameters": meaning the latest gradient update? And the older parameters are a delayed snapshot? Is it shared with the RL algorithm's normalization? No, it's about a loss spike?

What's a balancing coefficient for MAI?

In "with 16-bit arithmetic on both sides of RL", what does "both sides" refer to? And is the replay token-by-token, i.e. the high-precision outcome token gets discarded and the low-precision one accepted? I didn't know (remember?) about the truncated softmax. The difference in kernels, even apart from the details, has its own significance.

Let's add a box to give more color to drafters and speculative decoding. That sounds like it could have philosophical significance too.

"Much of what a large model says, a far smaller model can anticipate. Where the large model's extra capacity shows, it shows most in the tokens where the guess fails." is too many words for too little said. Don't worry about length if it's well spent. (Then: I was wrong that it is a truism. There's some difference that cannot be attributed to capacity, either noise or architecture difference.)

If we had a math companion page for this essay, we could prove this there: "This is rejection sampling. The text that comes out is distributed exactly as if the main model had written it alone." But there is not enough content for a math companion.

Don't worry too much about Substack; annoyed readers can switch to our website. Converter improvements are great. Just degrading the richness of formatting is not nice.

Is SFT always, or almost always, distillation? So the form of distillation that is distribution matching: when and where does it appear?

"MAI's RL starts from a model that has never seen reasoning traces, prompted in raw text. Its climbs are long": what's "climbs" here?

Just to confirm: does "attention alone learned almost none of them" include the values, or only keys and queries?

I got confused by this paragraph at first: "Moonshot traced a capability backward in the same way." The earlier one injects the post-training into earlier training, so my mind jumped to time travel of data.

Nice research in section 6. Looks good overall. Can you make a final editorial pass, please? Then update the study sidecar, and add the new concepts.
