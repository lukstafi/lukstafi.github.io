# Prompts: Which World Model?

*These are Łukasz Stafiniak's prompts that led to “Which World Model? Representation, Reliability, and the Uses of Prediction.” They record the human framing, source selection, and revisions separately from Codex's research and drafting. The local paths identify materials supplied for the essay; the private extracts themselves are not reproduced here.*

---

Let's write an essay that's a follow-up to [which-agi.md](which-agi.md) . While the most vocal objection to current AIs being AGI is the lack of continual learning, a prominent minority argues about LLM-derived frontier AIs doing insufficient world modeling. How can some people claim AIs lack world modeling, while to me, their efficacy is an inconvertible proof of sophisticated world modeling? The most forceful framing is in this quote from Richard Carrier: `~/lukstafi.github.io/notes/private/richardc_extract.txt` . You can use this recent podcast conversation to incorporate a broad machine learning context: `~/lukstafi.github.io/notes/private/prior_structure.vtt` . This article by LeCun provides a detailed technical account of Carrier's desiderata: `~/Downloads/Why_AI_systems_dont_learn-arXiv-2603.15381v1/papv2.tex` . Maybe these articles would be helpful: `~/Downloads/LeVLJEPA-arXiv-2607.00784v1/main.tex`  (a practical recent implementation of JEPA), `~/Downloads/next_latent_prediction-arXiv-2511.05963v4/content/`  (that predicting latents is more efficient than predicting tokens) and `~/Downloads/demonstrating_world_modeling-arXiv-2609.21748v1/main.tex` (that maybe we fail to elicit the world models that Transformers are building).
We could also demolish this article, which piles a wrong point upon a wrong point: [https://medium.com/@Reiki32/why-transformers-are-wrong-for-agi-e5c7b132196c](https://medium.com/@Reiki32/why-transformers-are-wrong-for-agi-e5c7b132196c)

---

"its inability to navigate an unfamiliar physical situation" What is "it" pointing to? Do the critics demonstrate the lack of improvement where improvement would be expected?

---

Hmm, that's an interesting read to put the improvement within the system. I meant something more mundane: An evidence that we're on a wrong path needs to establish that the path is not pointed in the right direction. That's what I wanted: the inability in question to be made more precise -- measured against what metric, and what's the expectation of the progress on the metric?

---

Delete this filler: "Faster generation and more accurate reasoning are different benefits, and the paper should not be cited as though the first established the second." It does not strike me as a plausible worry, the poor accuracy gain speaks for itself.

---

This sounds like unnecessary filler, it fails at conveying the idea I think you had in mind: "LeVLJEPA therefore illustrates how an objective changes the usefulness of representations for different downstream tasks. It is not, by itself, a demonstration of an agent learning causal dynamics through action, planning in imagined futures, or consolidating an autobiography."

---

But does it improve representations? Isn't the struggle to get JEPA to work an argument against "the current LLM-derived trajectory" being misguided? What does the podcast discussion I linked say about this?

---

I deleted: "His remarks do not establish that language pretraining supplies everything required." It's too defensive (and bad for the reading rhythm).

---

I think this is a bit tiresome to read: "Nor do they establish a rate of progress sufficient to fulfill all those requirements. Those conclusions would need the trajectory to be measured and its expected course defended." I would replace it with a comment like "The investments into the AI ecosystem, even as the bulk goes into scaling, fuel these ideas too." WDYT?

---

Any ideas for improving the following four paragraphs? If nothing else, I'd like to tighten the ending.

---

Very nice. Let's step back, what do you think of the topic and my selection of sources? Would you like to make a final editorial pass?

---

Selected text:

> Much of the disagreement turns on moving between these standards without notice.

Can you explain what you mean?

---

Yes, let's do that.

---

It looks like the NextLat results are underwhelming. "Yet the co-trained dynamics model, run recurrently, does generalize substantially farther." Isn't that just recurrence rather than anything JEPA like? And "the average multiple-choice accuracy gain is modest, from 58.82 to 59.21, and uneven across tasks" sounds like it vindicates regular LLMs? The speculative decoding claim is offtopic in particular as it's not compared to other speculative decoding approaches. WDYT?

---

Okay, thank you! Let's commit and push. Note the perplexity results are not relevant as that's the LLM objective, just the multiple-choice results are relevant.
