# Prompts: What Should a Program Inherit?

*These are Łukasz Stafiniak's substantive prompts that shaped “What Should a Program Inherit? Revisiting typed genetic programming, twenty-five years later.” They record the source selection, historical clarifications, and editorial revisions separately from Codex's research and drafting. Brief acknowledgments and a discussion of commit frequency are omitted. Local paths identify sources as supplied; the historical documents were subsequently moved into the public archive under `projects/typed-gp/`. Links to earlier essays are adjusted to this page's location.*

---

What do you think of this old article of mine? notes/private/MGP1.TXT Is it worth writing a 25th anniversary blog post about?

---

The next iteration of the programme in my spotty records is notes/private/GENERA.TXT

---

Would you also like to see my master's thesis? That was the culmination, but it was still purely theoretical and surveying, overview sort of work. The ideas were concrete enough for experimentation, but I ran out of time. I only have the thesis in the TeXmacs format, which might be cumbersome to read for you (and a PDF that stopped working).

---

I had to write it in Polish. notes/private/dyplom4.tm and notes/private/prezentacja.tm

---

Would you suggest moving the sources and your extractions to a new directory under `projects/` so we continue some work before settling on an essay for the blog?

---

Well, I assumed this would entail tracking it in the public repo. I don't mind making the documents public, as they are my own copyright, except for the potential embarrassment.

---

Is DreamCoder the pinnacle of this program synthesis research direction, or are there more recent results?

---

This is super exciting. I would hold off on building our own experimentation and instead do a focused survey coverage of these sources. I would omit the two articles: Synthesizing DSLs and Numerical Superoptimization. I would definitely include AlphaEvolve.

---

There is also a tenuous connection with the previous essay on our blog: [what-persists-when-agents-change.md](what-persists-when-agents-change.md) WDYT?

---

Are articles fetched via arXiv HTML very readable to you? I think we should focus on babble [https://arxiv.org/html/2212.04596v1](https://arxiv.org/html/2212.04596v1) for technical connection, TyFlow [https://arxiv.org/html/2510.10216v2](https://arxiv.org/html/2510.10216v2) for technical connection and recency, AlphaEvolve [https://arxiv.org/html/2506.13131v1](https://arxiv.org/html/2506.13131v1) for recency and connection to the previous essay.

---

TeX for babble is now at `~/Downloads/babble-arXiv-2212.04596v1/` and for TyFlow at `~/Downloads/TyFlow-arXiv-2510.10216v2/chapters/`

---

Would you like to write the anniversary essay now, or is it better to be more methodical about constructing the survey and the essay?

---

Let's do the three explorations via subagents.

---

I would have proposed an essay length of 7,000 words (upper end of the intended range for the blog, still below the hard limit of 10K to 11K). It's a lot of ground to cover. WDYT?

---

No -- 6,000 to 7,000 words unless need arises to exceed.

---

The original document originated in September of 2001, last month of university summer break. October 2001 is when I last modified it.

---

Not sure if we need to build anti-unification from scratch or if we can rely on the following recent article: [what-must-be-true.md](what-must-be-true.md) In any case, we should also point back at this article and connections with my PhD thesis.

---

I think a better simple example for C would be polymorphic: `available: f : a. a → a, b : bool`

---

But maybe this particular type is too generic in the sense of "types are proofs". WDYT? I don't want to make it too complicated, but I think environment management is important about C. Otherwise, the problem would appear trivial.

---

It's actually not a detriment that the program we want to synthesize is not the simplest that meets the type, since we're not operating under a semantically complete representation of intent in the type.

---

Section 5 AlphaEvolve plan does not touch on the evolutionary connection with genetic programming much. I think I would work this out a bit first before pivoting to constructing a follow-up to the "What Persists" essay.

---

About the paragraph "The conclusion should permit revision of the old programme." We could also question if that direction of change was warranted or if, on the contrary, I was nerdsniped into type theory.

---

That's nice, thank you. Would you like to continue writing the essay from here, or do you think a fresh context would serve it better?

---

Go ahead! :-)

---

I think this is fluff: "Neither the shared values nor their different spellings tells us which situation we are in." In other places, it's hard for me to say what's fluff and what's good exposition because of "the curse of knowledge"... This sentence is unclear and I'd maybe remove it: "They also show why growth was so easy: every plausible operation exposed another dependency that a richer representation might capture." The following guardedness is not needed deep inside the essay, remove: "This was an outline of intended work, not a completed system, but the connection is specific." More fluff to remove: "We have not claimed that the original expressions are equal: one evaluates to three, the other to four."
The paragraph "The equation set matters." is poor, I would rather say "The beneficial semantic equivalences are hard to capture as an equation set. Finding the right equations for a domain is its own challenge." and maybe not go into the details. Can you also tighten a bit the following 5 paragraphs?

---

Can we make a details box (I guess Markdown quotation?) explaining e-graphs in more detail?

---

Now in the TyFlow section. Let's remove: "It does not need to make the requested type difficult to inhabit.", the sentence isn't fluff but it doesn't do work the essay needs. I would remove: "These results concern the tested languages, models, and tasks; they are not a claim that every compiler obligation or intended behavior has been captured." In the preceding text, I would try clarifying the pronounced difference better. Is it about information flow (TyFlow only checks after the fact)? Maybe worth stating explicitly that TyFlow's system is less "impressive" because it uses a weaker type system IIUC, WDYT?

---

Now in the AlphaEvolve section. The first few paragraphs are good, but I feel at some point it gets too long winded, but can't quite put a finger on it. I would maybe remove: "We should be able to discuss influence and inherited functionality without pretending to have proved that an informal transfer implements a formal crossover definition." I agree with the sentiment, but one could still formalize information provenances if a model (or even agent) reads sources.

---

Alright this looks good! Let's do a final editorial pass and commit, thank you!
