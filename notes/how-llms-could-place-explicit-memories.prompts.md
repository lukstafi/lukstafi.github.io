# Prompts for How LLMs Could Place Explicit Memories

*The human-side prompts that developed and steered the draft, in conversation order. Assistant responses, button replies, and interface metadata are omitted.*

## The idea

For a future essay, we will trace the lineage from Memorizing Transformers https://arxiv.org/html/2203.08913v1 to this: https://prefrontal.ai/news/lsa/ , https://arxiv.org/html/2610.42147v1 . The essay will land after the LLMs' two-part deep dive into architecture and training (which is in progress still), so it shouldn't be redundant. It will also point back to multiple other essays, especially the continual learning series. I attended a weekly reading group organized by Christian Szegedy, so the authors of the paper are familiar to me. WDYT?

## The outline

All I have is notes/private/emergent_scratchpad-to_Marcus_Rabe.txt because I no longer have my meeting notes. I attended the reading group online. Draft the outline, thanks!

Q1: I think the paper was discussed, I was referring to the paper in the letter/email to Marcus. Q2: use the email as source of truth; the exact idea was mine, but the group was working on retrieval-augmented contrastive training, where the training batch would be used constrastively IIRC. Q3: indexer-as-student, keep it here. Q4: a full section. https://osf.io/preprints/psyarxiv/j75zw_v1 argues that in PFC "the abstract structure of the world is embedded locally in connections between prefrontal neurons encoding conjunctions of action and context"; would that be relevant? Q5: keep one sentence. Q6: don't know, sth like "How LLMs Could Place Explicit Memories"? Q7: sure.

## Two views of consolidation

"If consolidation is amortization (Where Experience Goes)" -- this is a deflationary view. There's also a substantive view that consolidation does representation-building work not reachable by retrieval even if intelligent (What Breadth Reaches).

## Before drafting

Any further questions or ideas you'd raise before writing the essay draft?

Q1: we can also wait till the training draft exists, WDYT? Q2: sounds good. Q3: I think you can correct the typos (not wording or grammar), that's jarring without benefit. Q4: Sounds good. Staleness: good point, it's a bit like the off-policy problem.

## Memorilla

This is probably great to pull into the essay, wdyt? https://arxiv.org/html/2610.21375v3

## Drafting

Alright, the first draft of the training essay is here: notes/filling-the-stores.md
(It will probably still evolve, but unlikely to drop info.)

## Reading pass

What suggestions do you have for reviewing this essay?

"Nobody is asking what to keep, because everything is kept." Not sure about that: 1 million tokens of context is still maybe 3 megabytes, no? But an uncompressed KV cache for 1 million tokens would be much bigger. Anyway, the 1 million context runs out quickly; it's not a lifelong memory store. Another angle: since the memory comes from middle to upper layers, I'm curious about storing "landmark blocks" alone, which encode a longer context than the tokens directly underneath.

But the compression schemes are uniform, right? The "landmark block memory" idea would be a non-uniform scheme where the "peaks of understanding" are stored.

Draft it; cover non-uniform writing more broadly rather than any particular interpretation of "peak understanding". The across-surprise-boundary is one strategy or heuristic. Eviction also fits (it need not be non-uniform at first-write time).

NSA and MoBA are not explained anywhere.

RLMs are also relevant, but might strain the essay's cohesion. WDYT?

Can you do an interim editorial pass, or other improvements you had in mind? I'll keep reading.

Not sure if worthwhile, but do you remember old research, I think from a robotics lab, with a non-parametric clustering or centroid-based memory? I somehow associate it with the acronym SAIL, but might be entirely wrong. Yes, this one (SAIL and IHDR). Do add a sentence to the essay: it makes the essay more unique, as against a generic survey.

"CISA makes the same point: it retrofits a dense model": maybe worth saying what the dense model is or does? (CISA's first appearance speaks of summaries.)

"A compressed read keeps structure and loses names. The Isabelle lemma would not survive it." This is about Memorilla, right? But isn't Memorilla retrieving the document via the embeddings, i.e. isn't it a classical RAG in this sense?

Can we give more detail on how the query vectors, the 16 slots, and the document embedding vectors interact in Memorilla? Do the 16 slots correspond to 16 fixed vectors which are both keys for the model and queries for the documents?

Sorry, I accepted this too quickly. It's still unclear, and the extra words don't help. For the store, it suffices to say that it's a store of embeddings of chunks of documents, one or two hundred tokens long, where the embeddings are independent of the models. The reader is trained per model, and has 16 vectors as output. What does it have as input? And what does the frozen embedding model take as input to produce the question? "The question" is not a technical term; "the prompt" would already be clearer.

Do these systems have a dedicated memory layer like the original Memorizing Transformers? Ah, Memorilla's outputs live in token embedding space?

I wonder if this proof deserves a box? Compositionality is a core capability. "Eitan, Yehudai and Maron prove that top-κ access needs capacity growing as √n."

What does the width of the block mean? The cache needs to store the two n-sized tables. Is it related to the fact that we have only one access to both tables, so we need to encode both tables at once? Does their device bypass this restriction, is that what they say? Is there a concise, clear description of the hybrid block? The paper looks a bit cryptic. Is the recurrence just a further capability, not needed for multi-hop? So the crux is to read "which κ" from the full-attention layer rather than from the previous layer.

I'm not getting less confused. Assemble the box and add it to Section 6; maybe some readers can grasp it.

So the construction is a kind of hierarchical softmax attention, where the intermediate value is a query for re-attending? Is there a connection to our essay "The Algebraic Mind Meets the Neural World"?

In one of the essays, we bring up an extension of attention that combines three slots rather than two. Can multi-hop attention be viewed as an efficient approximation to simplicial attention? Is there an opportunity to generalize while preserving efficiency?

Anything to pay attention to in Sections 7 to 9? Do you need anything from me before a final editorial pass over the whole essay?

You can drop "as I remember it" on line 49: I do remember.
