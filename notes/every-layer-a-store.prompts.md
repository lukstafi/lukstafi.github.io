# Prompts for Every Layer a Store

*The human-side prompts that developed and steered the draft, in conversation order. Assistant responses, button replies, and interface metadata are omitted. The research behind the essay began in earlier sessions (the architecture dossier of 3 October and the interpretability dossier of 15 October); this session started from them.*

## Scope

Let's start working toward the "LLM architectures and training" essay. What's the lay of the resources we have collected?

About the scope and shape to be covered in this session: my initial thinking was to have a deep account of architectures and training first, probably as one essay for the blog that might land as parts on Substack if it ends up being long; but could split into architectures article and training article if that ends up more natural. I would keep interpretability in a subservient role to understanding the surveys' content. Where I see the blog going after what we're discussing in this session: (a) re-evaluating and deepening our account of mentality / mindedness. (b) This is tempting but not fully decided: Responding to critics of AI mindedness (phrased as "proper intelligence") in the current frontier AIs, coming from the "Partially Examined Life" podcast, I haven't listened to it yet; engaging with an upcoming video by Richard Brown on consciousness in current AIs (from the brief description the take seems to be "illusionism turns out to be true of AIs"). (c) Clarifying and defending our core metaphysical commitment to ontic structural realism. The topics that are still unclear whether they receive a dedicated essay in near future: a separate interpretability article; a separate article about personhood.

## Title

Are the 7 checkpoints distinct enough to merit the title "Seven Ways to Extend the Transformer, and How They Are Trained"? If yes then it's a good title, otherwise "Every Layer a Store: How the 2026 Open Models Are Built and Trained" is good.

"5 ideas" might also make a good title, WDYT? Otherwise we stick with the current pick.

## Sources

Would this survey be a good additional source? Not sure because at first glance it looks a bit armchair'y. https://arxiv.org/html/2504.15965v2

## Opening and the store vocabulary

I agree with the suggested opening -- open strong with showing how a naive vanilla Transformer view is outdated, the preserve the striking example for later.

Q2. A full section; I'm expecting I'll ask for the classical lineage background as subsections or boxes.

## Kanerva and Hawkins

Is Kanerva's work worth bringing up? Is it at tension with the recent "NNs are clean" message?

That's exciting! Agreed, add a note somewhere interpretability-attached (I like the homonymy point). What about Hawkins "Hierarchical Temporal Memory", is that research direction relevant to the current state-of-the-art?

Ah ok, that's not worth bringing up then, I'd leave it out of sources of the mindedness essay. At some point we can write about non-gradient / zeroth-order methods, but HTM doesn't look like a productive candidate to seed that essay.

## Structure and figures

I'd keep section 6 in Part A, it fits as architecture consideration.

Q4: is SVG better than Mermaid? Or would it be Mermaid exported to SVG?

## Drafting

Okay, ready to start drafting the essay(s)?

Maybe we should already decide to split into essay A and essay B? Draft A in one go.

## MAI-Thinking-1

Let's continue working on the LLMs two-parter, with notes/every-layer-a-store.md covering the architecture and the next essay covering training. Is it worth extending the survey to include MAI-Thinking-1 ? https://microsoft.ai/pdf/mai-thinking-1.pdf

Yes, add to outline (the MAI-Thinking-1 points in the Part B sections, plus the one-sentence aside for essay A).

## Fact check

What should I look into next to improve "Every Layer a Store"?

Yes, fact check first (results to a numbers-check note in notes/research/).

## Stores table

Yes, stores table (one row per store, columns for the four questions plus how it forgets).

## Figures

Yes, figures (Figures 1–3 as matplotlib SVGs with their scripts in the repo).

## Editorial pass

Yes, editorial pass (AGENTS.md style).

## Reading pass

Let's do the post-draft iteration over the essay. Should we cover activation functions, in particular what makes SwiGLU special? https://www.cognitiverevolution.ai/the-neuron-basis-goodfire-s-curt-tigges-on-agentic-interp-monosemanticity-reverse-engineering/ claims SwiGLU is better for interpretability because it does a more sophisticated per-neuron computation.

Should we add a box or section to cover positional encodings, and maybe a box with this blog post derivation? https://blog.janestreet.com/using-group-theory-to-explore-positional-encodings-attention/

We could also add a back pointer to the mathematics companion which introduced Lie groups.

"[The exponential] suppresses interference more than any single power does." What's the more precise intuition to see this? The fact that the square suppressed interference was obvious because of the square of a fraction being an order of magnitude smaller. But in the exponential, we add up all the powers, so we don't drop the differences.

"which shrinks only with the logarithm of $1/s$" -- what's on the other axis of shrinking that makes it logarithmic? $p$ itself?

About the MAI-Thinking-1 paragraph: "adding a shared expert brought it little or nothing" is confusing. Is it the point that the shared layer "trained faster on the hardware" and that's why it was introduced, while it neither helped nor hurt storage?

How does sliding window attention work with the KV cache? For the essay your earlier point about "layers that had already read the whole prompt" is more important.

"Its IndexShare lets one indexer serve a group of four consecutive layers." Is it just weight sharing, or index sharing too? "always includes the block that contains the query" What does "query" mean here?

So DeepSeek-V4-Pro's is compression-by-mixing, and the weights are vectors applied pointwise? This is strange overall, could you try again describing it. Is it like convolution? Make the subsection a bit tighter, I have the impression some facts are repeated with different wording.

Is KDA an LSTM? Add a sentence on the mLSTM relation to §3.

"and generators that cannot be diagonalized add polynomial terms that Puranik could not interpret" this is not quite true, check out this summary of https://www.youtube.com/watch?v=k86eUj4hgdc

Maybe worth clarifying for AttnRes "the completed sums of earlier groups of 12 layers", is it a regular unweighted sum? Does mHC have a recognizable preserved format across layers? Is Stable LatentMoE explained earlier in the essay? Is the projection shared across layers, or per-layer?

We're ready for a final editorial pass, and then let's add an update tag in the index and Substack publication date, and let's schedule it on Substack.
