# Prompts: What Must Be True?

*These are Łukasz Stafiniak's prompts that led to [“What Must Be True? The Three Operations of Logic and the Search for Explanations”](what-must-be-true.html). They distinguish the human framing and research direction from Codex's drafting. The first two prompts initiated the mathematical investigation; the later prompts directed the essay. The thesis and defence slides are also Łukasz's work. The relevant prompts are reproduced in order.*

---

What interesting problem in this repository you'd like to work on?

---

Set an alarm for 20 minutes, at which point, stop and take stock of progress. Use subagents to see how much you can accomplish in 20 minutes. Good luck!

---

Let's pivot. Let's write a general public article for our blog, presenting a framing and the problems. We can either focus on the constraint abduction problem more narrowly or can present my PhD thesis more broadly. What would you prefer?

---

Can you parse these slides maybe? \~/invargent/doc/invargent-simple-slides.pdf There I'm bringing up a quote from Sherlock Holmes: "When you've eliminated what's impossible, what remains, however improbable, must be the truth".

---

Do you by any chance know "The Myth of Artificial Intelligence Why Computers Can’t Think the Way We Do" by Erik J. Larson?

---

Yes, I'd like the article to have a philosophical component in addition to the theoretical component. If the article grows too large, we can split into a two-parter. Larson's is a very unreasonable argument; a more palatable version of it is behind David Deutsch criticism of current AI systems. We can discuss how formal approaches already undermine Larson's thesis of non-formalizability, but still contrast formal approaches with what abduction means for open-ended reasoning systems like yourself.

---

/compact Focus on the blog essay, we will combine the two parts for a tighter, longer and more impactful article.

---

The soft limits (aimed for range) for the blog articles is 4,000 to 7,000 words, with 10,000 words being a hard upper limit forcing a split. The inspiration for the shape that my thesis took came from Pierce, with his account of the three operations of logic: deduction, induction, and abduction. In particular, Pei Wang incorporated these into his "non-axiomatic logic". The system from the thesis involves all three if we equate induction with generalization. For the technical-theoretical part of our essay, let's put more emphasis on the openness of decidability and comparing the hardness of constraint abduction versus deduction in the same constraint shape context.

---

This is very good! Maybe it could be made slightly tighter? For example, close to the end, I would remove: "A candidate that survives checking answers the first question for one instance. It does not answer the second." And later I would remove: "Neither programme requires declaring every difficulty solved, or every unexplained capacity unformalizable."

For the technical part, do you know if we can bound the complexity of search by the size of the answer, conditional on the answer existing? Is it exponential by enumerating all admissible terms?

---

The essay is centered around abduction, but it does mention that to address the problem of synthesizing properties for recursive programs, we need iteration. This bigger problem is known to be undecidable via the special case of polymorphic recursion; but for polymorphic recursion, if I recall, the problem is polynomial in the size of the answer. Do you remember?
