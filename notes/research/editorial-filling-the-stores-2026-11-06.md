# Editorial read: *Filling the Stores* (6 Nov 2026)

Proposals only. No file but this one was changed. Line numbers (l.) refer to `notes/filling-the-stores.md` as it stood on 6 Nov. Each "Original" is quoted exactly so it can be matched. The reader assumed here has read *Every Layer a Store* and nothing else. Facts were not checked. Where a proposed gloss rests on the research notes, the reason says so, and internal inconsistencies I noticed are passed to the fact reviewer in Part 4. New wording that goes beyond rephrasing is marked as the author's call.

## Part 1. Structure

### What works and should be left alone

The opening pair (GLM's identical files, MiMo's small share of tokens) is strong. The closing returns to it, which is right. Zucchet's plateau and "The sentence needs three limits" (l. 57–63) is the best passage of evidence-handling in the essay. Worked example 8 earns its length. The MSA paired run (l. 124) and MiMo's router restoration (l. 142) are the two places where the reader watches an argument happen. Several sentences should survive any edit: "What comes fast can leave fast." "The final mid-training thus contains the failures of a trial post-training." "New keys do the damage." "MAI's report supplies the account with nothing to measure. GLM-5.2 and GLM-5.3 supply the checkpoints with almost no account." The collapse anecdote at l. 272 is the right last image. Semicolons are nearly clean: two in prose, both fixed below.

### S1. The closing claims more than the essay showed (highest priority)

*What the weights keep* opens well: l. 272 and the end of l. 274 land. L. 276 and parts of l. 274 and l. 278 do not earn their claims, and in four places they contradict what the essay has shown.

- "The stages exist because the stores cannot be filled in any order." L. 75 reports three vision orders that each "work", never compared. L. 122 says of selection that "Every position in the pipeline has been tried." Long context comes late partly to confine a cost (l. 146). The essay shows that order mattered in a few controlled cases, and that it is untested in the rest.
- "selection has to find its teacher." L. 122 ends: "A selector needs a teacher only if it is a separate network."
- "precision has to enter before the policy." MAI's row in Table 1 reads "none: 16-bit throughout RL", and l. 158 presents that as a working alternative.
- "Routing has to form" uses the word that §3 gave to the expert router. The result it stands on was hedged at l. 63 ("We offer the result as a mechanism, not as a measurement of the seven"). The hedge is dropped in the closing.
- "A store records everything written to it." L. 228 says that an update too small for the format "is not stored", and the first essay's table says trained stores forget when training overwrites them. L. 232 says the same of facts.
- "nobody can tell what a store holds by looking at it" sits beside "It takes open weights to see what the process wrote" two sentences later, and beside l. 250 ("Open weights let anyone check what happened to the stores"). Table 2's limit is that distance says nothing about function, so "see" overclaims. "Measure" is what the essay delivers.
- "in every store at once" (l. 278): the files hold only the stores written by training. The first essay's reader knows that caches and recurrent states are not in them.

**Proposal.** Cut l. 276 to the part that is earned, and let it pick up the line bending back, which is what the collapse anecdote is an instance of. This removes a recap of the list of stages, and it removes a "This is why" whose "this" is hard to place.

- Original: `This is why training looks as it does from the outside. The stages exist because the stores cannot be filled in any order. Routing has to form, selection has to find its teacher, precision has to enter before the policy. The reach back from late stages to early ones exists because nobody can tell what a store holds by looking at it, only by running it forward and seeing what survives.`
- Proposed: `This is why the line bends back. Nobody can tell what a store holds by reading its numbers, only by running it forward and seeing what survives.`

If the author wants the order leg of the spine in the closing, one sentence can carry it honestly. It summarizes §2 and §3 and adds no finding, but it is new wording, so it is the author's call: `Some orders are forced and others may be habit, and the reports seldom say which: selection has been added at every stage, and no lab has compared the orders for vision.`

The two repairs in l. 274 and l. 278 are E46 to E48.

### S2. The store vocabulary disappears for 4,600 words

The header note says that the essay "uses the first essay's vocabulary of stores", and the title promises it. A count of the word *store* or *stores* in the prose by section gives: §1 none, §2 three times, **all of §3 zero, §4 before *The line bends back* zero**, then one, three, two and four. Apart from §4's heading, the word stops at l. 67 and comes back at l. 224, about 4,600 words later (tables and equations included). This is the same gap as the missing spine. Across §3 and §4 the sentence shape becomes "[Lab] [verb] [device]", the essay's largest stretch of disclosures with no argument moving through them (MAI's name appears 29 times in the essay).

The spine by section:

| Section | Order of writing | Reach back | Disclosure | State |
|---|---|---|---|---|
| Opening, §1 | stated | stated | stated | good |
| §2 Zucchet to l. 65 | strong | | hedged well | good |
| §2 l. 69, l. 71 | absent | | | stub and aside |
| §2 *Normalizing a matrix* | only at l. 95 | | | mechanism first; spine returns late |
| §3 *Selectors* | strong (l. 122–124) | | strong at l. 126 | long, but it argues |
| §3 *Residual mixers* | absent | | one line | **no stage at all** |
| §3 *Experts* l. 138–140 | absent | | | **list of devices**; l. 142 recovers |
| §3 *Long context* | strong | | good | good |
| §3 *Precision*, *Drafters* | present | | | short; depend on §4's terms |
| §4 RL, stale rollouts | absent | | | **list of settings**; l. 180–184 recover |
| §4 *Specialists* | weak | | | acceptable |
| §4 *What changes inside* | by store | | good at l. 236 | survey, but it ends well |
| §5 | | | strong | good once S8 is done |

**How to restore it, cheaply.** No section needs rewriting. Three moves do most of the work.

1. Give §3 a lead that carries the opening's question forward, and give §4 a lead at all (it has none). E12 and E30. The reader then has a question to hold against each device.
2. Put the word back where a sentence is already about a store. E13, E22, E25 and E34 do this.
3. In the list-like passages, cut the settings that no later sentence uses (E23, E24, E33), so the paragraph's conclusion arrives sooner.

An optional fourth: the first essay's table says that trained stores forget "only when later training overwrites them", and promises this essay as the account of that. *What changes inside* cashes the promise without saying so. One sentence at l. 232 can say it (E42).

### S3. *The line bends back* should be its own section

Is it in the right place? Its rank is wrong, and that matters more than its neighbours. Reaching back is the second leg of the spine, it spans pretraining to RL, and the opening announces it as one of three claims. Yet it sits as a sub-subsection of a section titled *Post-training edits the stores*, whose title it does not fit, wedged between MAI's self-distillation and the measurements. It is short, but it should be: a short numbered section gets more weight than a long one.

**Proposal.** Move *What changes inside* up so it follows *Self-distillation at production scale* and closes §4. Make *The line bends back* the new §5, and renumber *Open process, open weights* to §6. The argument then runs: the stages write (§§1–4), the later ones reach back (§5), and what can be said rests on disclosure (§6). The openings and endings fit:

- §4 ends on "they do not publish maps."
- §5 ends on "the reports give only a few of its outcomes", which hands directly to "Three properties…" on what reports do and do not contain.

The one good adjacency lost is self-distillation directly before the line bends back. E41 recovers it, and it is worth making in any case. MAI's self-distillation is the plainest case of a later stage going back to an earlier checkpoint, and at present the essay does not say so. The closing anecdote is the same move, so the essay would prepare it.

Stitches: l. 23 "Section 5 explains" becomes "Section 6 explains". L. 268 "As Section 4 showed" stays correct.

If the move is declined, the minimum is E41 alone.

### S4. §3 runs on terms that §4 introduces

§3 assumes RL's vocabulary, and the reader meets it before it arrives or never meets it at all.

| Term | First used | Explained | Problem |
|---|---|---|---|
| policy | Figure 1 caption, Table 1 | never | used in two headings |
| rollouts | l. 142 | never (§1 says "samples answers") | about 20 uses |
| self-distillation | l. 142, l. 152 | l. 202, and there only by description | used twice before its section |
| climb | l. 142 | never | MAI's word; closing leans on it |
| importance ratios | l. 158 | l. 168 | ten lines early |
| top-$p$ | l. 158 | never | |
| on-policy | Table 1 | l. 192 | also at l. 178, before the definition |

Moving *Precision* and *Drafters* into §4 would fix some of this but loses §3's shape. Glossing is cheaper. One added sentence in §1's RL bullet handles the two commonest terms (E5), and E26, E28 and E31 handle the rest in place.

**Table 1** carries the same debt: Muon, Muown, Per-Head Muon, Muon Split, Sinkhorn-balanced, on-policy, off-policy, expert quantization and consolidation are all unexplained where the table stands. The table should stay. It is the disclosure leg made visible, and the empty Qwen row is an argument by itself. But the reader should be told that it is a map to come back to (E6).

Also, **post-training is never defined**. It is the essay's central term and appears in the first paragraph, but §1's list of six has no such item, and the first essay does not define it either. E3 and E4.

### S5. *Selectors* is the longest subsection (966 words) and has two soft spots

Most of the length is earned, since this is where the order argument is won. Two changes:

- **Split the *When to add selection* paragraph (l. 122).** It is a nine-item roll-call. It has a natural joint: retrofits begin at "[Latent Sparse Attention]". The first half reads as a walk down the pipeline, and the second as "after release". E16 and E17.
- **The K3.1 Pro paragraph (l. 126) does two jobs and ends by cancelling itself.** Its real point serves the disclosure leg: the weights reveal what no document says. That point is complete at "are not disclosed." GLM-5's reasons for freezing are a separate matter, and they belong in a short paragraph of their own (l. 266 relies on them). The final sentence is about a third party and "says nothing about what Moonshot did", so the reader is told to ignore it. Cut it (E19).

### S6. *Residual mixers* carries little, and worked example 9 is the one to shrink

This subsection names no stage, and its example reuses the streams $(2,4)$ of worked example 4 to reach a total of 6 that the first essay already reached. What it adds is two things: an unconstrained mixer blows up, and Sinkhorn is smooth where top-$k$ is a choice. The second is the subsection's idea. Keep the example's raw-against-projected comparison, and cut the ratio invariant and the limit (E21). The closing lines on AdamW at 4,096 tokens are the only disclosure point, and they need a clear referent (E20).

### S7. *Starting as something simpler* is in the wrong section

It sits at the end of §2 under a heading about pretraining, but its subject is new components, it cites K3's drafter before drafters are discussed, and it ends on routing in experts before §3 has opened. Move it to the end of §3, after *Drafters model the policy*. Everything it uses is then in hand. §3 gets a general ending in place of the disclaimer at l. 162, which should go (E29). §2 then ends on "MAI used AdamW for everything", which is abrupt but has bite.

### S8. Smaller structural points

- **L. 69 is a stub.** "the third result of this family" counts results the reader has not been given, and "this family" has no referent. The paragraph sends the reader to an essay they have not read, and nothing later uses it. Cut it. If the author wants the link kept, E9 anchors it.
- **L. 71 opens with a generalization that only MAI supports.** E10.
- **Worked example 6 and its setting.** The example answers "how much must a store see?", which is l. 65's first sentence, but it stands after that paragraph has moved on to mixing. Split l. 65 before "Mixing changes more" and put the example between the two halves. The mixture sentence "no number from a pure-facts experiment says what a trillion-parameter model holds" is then the ending, and it gives the example's point (tokens must grow faster than parameters) the hedge it needs.
- **Stale rollouts (l. 178)** gives five labs for one conclusion. Three would do. A reader takes the point by MAI, GLM-5 and K3, and "MiMo allows a staleness of 4" has no unit. E33.
- **The bold run-in *Most of the gain is in the environments* (l. 186)** promises an answer to "the opening's question", but the opening asks no question. Its position is right: after the verifiers. E32 repairs the opener.
- **L. 196 holds two topics.** Teachers' origin, then sequential training. Break before "Sequential training". The break also corrects an idiom (E36).
- **§5's first paragraph (l. 240)** names three properties, then drops the license for good, and "every combination" is more than the cases show. E43.
- **Table 2's setup (l. 252)** says "four public pairs" and names two, in a sentence about formats whose purpose the reader cannot yet see. The reader meets "MiMo RL → distilled" and "K3 → K3.1 Pro" only in the column heads. E44.
- **"What changes inside" (538 words)** is fair for what it carries, but the facts paragraph (l. 232) is overloaded. If anything goes, take Palit, which only restates "unsettled" (taste item A3).
- **The opening's fourth paragraph** gives the essay a second subject: l. 21 says the essay asks how the weights got their contents, and l. 23 says "the essay's subject is open process". The first is right. E2.

### Worked examples: do they earn their space?

| Example | Verdict |
|---|---|
| 6, the tail | Keep. It is the only place the reader sees why tokens must outrun parameters. Move it as in S8. |
| 7, two normalizations | Keep the first two thirds, which is the best picture of Muon anyone could want. Cut the polynomial iteration from "Divide by the Frobenius norm" on (E11). It serves no later sentence. |
| 8, what a selector can see | Keep. Best in the essay. The two heads in its setup are not used again; "the main attention puts weights $p$" would do (taste item A1). |
| 9, projecting a mixer | Shrink (S6, E21). |

### Repetition

| What | Where | Fix |
|---|---|---|
| Allen-Zhu and Li's 2 bits and 1 bit | l. 65 and first essay §2 | Mention, don't re-derive (E8) |
| Attention sink | l. 120 and first essay §3 | Cut (E15) |
| Doubly stochastic mixer | l. 130 and first essay §4 | Keep one clause (E20a) |
| Long-context behaviour fading under self-distillation | l. 152 and l. 208 | Cut the bullet (E38) |
| "the same kind of number" | l. 224 and l. 274, for two different distinctions | Keep the closing's (E40) |
| Moonshot's data removal | l. 126, l. 220, l. 246 | Acceptable. L. 126 needs it for an inference, l. 246 recalls it briefly. |
| "post-trained version" in the card and the post | l. 126 twice | Merge (E18) |
| Code share of mid-training | l. 30 (55 percent), l. 71 ("about half") | Unify (E10) |
| "How far a store moves does not say how much it matters" | l. 234 and l. 268 | Keep both. It is a deliberate call-back over 34 lines. |
| GLM-5 freezing indexers | l. 126 and l. 266 | Keep both. The gap saves a lookup. |

## Part 2. Line edits

In rough order of position, not importance. The items that matter most are E2, E5, E12, E30, E41 and E46 to E48.

### Opening and §1

**E1** (l. 17). "DeepSWE" is unexplained, and the sentence makes two moves. Gloss rests on the notes' use of it for software-engineering agents.
- Original: `Yet the card of the second scores it at 66.9 on the DeepSWE benchmark, against 46.2 for the first, and it explains the gain in one sentence:`
- Proposed: `Yet the card of the second scores it at 66.9 on DeepSWE, a benchmark of software-engineering agents, against 46.2 for the first. It explains the gain in one sentence:`

**E2** (l. 23). L. 21 has just named the subject. What rests on the labs' words is the evidence. "Pinned" is working language from the outline.
- Original: `Almost everything here rests on what the labs chose to say, so the essay's subject is open process, not open weights. The first essay pinned seven open-weight checkpoints.`
- Proposed: `Almost everything here rests on what the labs chose to say, so the essay's evidence is open process, not open weights. The first essay followed seven open-weight checkpoints.`

**E3** (l. 19). The essay's central term is never defined.
- Original: `Post-training can be a small share of a run.`
- Proposed: `Post-training, the last stages of a run, can be a small share of it.`

**E4** (l. 27). Connects the six kinds to "post-training", which §4's title and the tables rely on. Drafters are left out on purpose, since l. 162 has them running alongside.
- Original: `Six kinds of training recur in the reports, under varying names.`
- Proposed: `Six kinds of training recur in the reports, under varying names. SFT, RL and distillation are grouped as post-training.`

**E5** (l. 32). Two terms used dozens of times, otherwise never introduced.
- Original: `- **Reinforcement learning (RL)** samples answers from the model, scores them with a verifier or a judge, and raises the probability of those that scored better than their group.`
- Proposed: `- **Reinforcement learning (RL)** samples answers from the model, scores them with a verifier or a judge, and raises the probability of those that scored better than their group. The sampled answers are *rollouts*, and the model under training is the *policy*.`

**E5a** (l. 33). Garden path: "a single checkpoint" reads as being taken "from several specialists" by some other verb.
- Original: `- **Distillation** moves behaviour from one or more teacher models into a student, usually a single checkpoint from several specialists.`
- Proposed: `- **Distillation** moves behaviour from one or more teacher models into a student. Usually several specialists go into a single checkpoint.`

**E6** (l. 36). Tells the reader that the table is a map to return to, and fixes "whose own report does not exist".
- Original: `Table 1 sets out what each report says about these stages.`
- Proposed: `Table 1 sets out what each report says about these stages, in terms that Sections 2 to 4 explain.`
- Original: `For GLM-5.3, whose own report does not exist, the cells draw on the GLM-5 and GLM-5.2 disclosures for the same base model.`
- Proposed: `GLM-5.3 has no report of its own, so its cells draw on the GLM-5 and GLM-5.2 disclosures for the same base model.`

### §2

**E7** (l. 59). $x$ and $y$ are never said to be anything. "Steps" is inferred: the essay's 11 biographies per person follow from the fit only with $y$ in steps at batch 128, per the notes. Please confirm.
- Original: `The plateau grew with the population, following $y=0.43\,x^{0.81}$ over populations from 4,000 to 256,000.`
- Proposed: `The plateau grew with the population $x$, lasting about $0.43\,x^{0.81}$ steps over populations from 4,000 to 256,000.`

**E7a** (l. 61, l. 63). "Routing" is the expert router's word from §3 on, and the first essay's. L. 63 already says "circuit", so use it throughout §2. The closing's "Routing has to form" (S1) inherited the collision.
- Original: `What is learned there is the routing.`
- Proposed: `What is learned there is a circuit in the attention.`
- Original: `Until the routing forms, facts are written slowly.`
- Proposed: `Until the circuit forms, facts are written slowly.`
- Original: `Routing in a real model keeps moving.`
- Proposed: `The circuit in a real model keeps moving.`

**E7b** (l. 63). A semicolon that chains. The two halves are not parallel.
- Original: `The fit and the transplant were run at 44 million parameters, on data with one task in it; a corpus has no single population, and nobody has run the experiment at scale.`
- Proposed: `The fit and the transplant were run at 44 million parameters, on data with one task in it. A corpus has no single population, and nobody has run the experiment at scale.`

**E8** (l. 65). Recaps the first essay. "The linear law" has not been stated: the sentence before gives bits per parameter and no law. "Mixing" collides with the first essay's token, channel and stream mixing.
- Original: `The linear law has held up in other hands.`
- Proposed: `That capacity grows in proportion to parameters has held up in other hands.`
- Original: `Mixing changes more.`
- Proposed: `Mixing the facts into other text changes more.`

**E9** (l. 69). Only if the paragraph is kept (S8). "Third result" and "this family" have no referent.
- Original: `already used the third result of this family: ambiguity costs capacity, because a context with $k$ plausible continuations takes up about $k$ memories in a linear head.`
- Proposed: `already used another result from Zucchet's tutorial: ambiguity costs capacity, because a context with $k$ plausible continuations takes up about $k$ memories in a linear head.`

**E10** (l. 71). "The labs" rests on one lab, and "the outside view" is unanchored. "About half" conflicts with l. 30's 55 percent, and the point can be kept without restating the share.
- Original: `The labs manage what gets stored more than the outside view suggests. MAI caps exposure`
- Proposed: `A lab can steer what gets stored. MAI caps exposure`
- Original: `Its pretraining uses no text generated by language models and no open training datasets, and it spends about half of mid-training's mixture on the code it will need for RL.`
- Proposed: `Its pretraining uses no text generated by language models and no open training datasets, and the code in its mid-training mixture is there for RL.`

**E10a** (l. 79). Ties the optimizer to writing, which is what makes it this essay's business.
- Original: `The largest disclosed change in pretraining is the optimizer.`
- Proposed: `The largest disclosed change in how pretraining writes is the optimizer.`

**E11** (l. 91). The iteration serves no later sentence, and it is the point where the example stops showing and starts documenting.
- Original: `A singular value decomposition at every step would be too slow, so Muon gets there by iterating a polynomial in $MM^\top$ that acts on the singular values alone. Divide by the Frobenius norm, which gives singular values 0.995 and 0.0995, and apply $x\mapsto 2x-1.5x^3+0.5x^5$. The small one goes 0.198, 0.384, 0.687, 0.964, 1.000, while the large one stays at 1. Production Muon uses tuned coefficients that bring small values up faster and settle in a band around 1, without converging.`
- Proposed: `A singular value decomposition at every step would be too slow, so Muon gets there by iterating a polynomial in $MM^\top$ that acts on the singular values alone. Production Muon uses tuned coefficients that bring small values up into a band around 1, without converging.`

**E11a** (l. 93). "Sorts" says little. "The head" collides with attention heads two sentences later. "Sinkhorn" is unexplained here and in Table 1, and the mechanism is the one the first essay described without naming it. "mHC's gates" is not the first essay's language. The names in Table 1 are never tied to the text. "This" dangles, and V4.1 is not the subject of the sentence before.
- Original: `Muon sorts the parameters. In DeepSeek-V4, AdamW keeps the embeddings, the head, the norms and mHC's gates, and Muon takes the rest. DeepSeek-V4.1 gives its embedding tables and head a third treatment, a momentum update balanced by Sinkhorn iterations, because Adam's state for 196 billion table entries costs too much memory.`
- Proposed: `The labs that adopted Muon do not give it every parameter. In DeepSeek-V4, AdamW keeps the embeddings, the output head, the norms and mHC's mixing gates, and Muon takes the rest. DeepSeek-V4.1 gives its embedding tables and output head a third treatment, because Adam's state for 196 billion table entries costs too much memory. It balances a momentum update by Sinkhorn iterations, the alternating rescaling of rows and columns that mHC uses.`
- Original: `so that heads with large gradients do not set the update for the rest. V4.1 reports that this beats plain Muon.`
- Proposed: `so that heads with large gradients do not set the update for the rest. The table's names for this are Muon Split and Per-Head Muon. V4.1 reports that orthogonalizing by head beats plain Muon.`

**E11b** (l. 95). The second semicolon. The clauses contrast but are not a parallel pair, and the sentence that follows is a third contrast.
- Original: `wrote; MiMo reports no loss spike. MAI used AdamW for everything.`
- Proposed: `wrote. MiMo reports no loss spike. MAI used AdamW for everything.`

### §3

**E12** (l. 103). The lead drops the essay's question at the point where the essay needs it most (S2).
- Original: `Each component in the first essay brought a problem to training. The reports are easiest to read as solutions to those problems.`
- Proposed: `Each component in the first essay brought a problem to training. The reports are easiest to read as solutions to those problems. Of each we can ask the opening's question: at which stages can the component be added, and at which does adding it hurt?`

**E13** (l. 107). Restores the first essay's picture and the word.
- Original: `A selector scores every entry in a cache and passes on the $k$ best.`
- Proposed: `A selector is a second, cheaper store in front of the cache. It scores every entry and passes on the $k$ best.`

**E14** (l. 120). RULER is unexplained at its first use, and "took … from" hides that this is a fall.
- Original: `On GLM-4.7-Flash, an indexer trained on a frozen base took RULER at 128K from 79.21 to 71.35.`
- Proposed: `On GLM-4.7-Flash, an indexer trained on a frozen base lowered the score on RULER, a benchmark of retrieval from long contexts, from 79.21 to 71.35 at 128K tokens.`

**E15** (l. 120). The first essay made this point, and here it interrupts warm-ups.
- Original: ` MSA's own models then rediscover what dense attention does, without being told: left unforced, "the learned Index Branch naturally assigns high selection probability to the initial block", which is the attention sink.`
- Proposed: cut.

**E16** (l. 122). Three moves in one sentence, and the reader is not told what the points are. Start a new paragraph here (S5). "RULER" is assumed from the context; please confirm.
- Original: `[Latent Sparse Attention](https://arxiv.org/abs/2610.42147) distills an indexer onto a released, frozen checkpoint in 352 million tokens, with the student's softmax kept over all selectable keys, and stays within five points of full attention up to a million tokens on Qwen-3.8-27B. [ZHA](https://arxiv.org/abs/2610.42112) does the same in a billion tokens.`
- Proposed: `[Latent Sparse Attention](https://arxiv.org/abs/2610.42147) distills an indexer onto a released, frozen checkpoint in 352 million tokens, with the student's softmax kept over all selectable keys. On Qwen-3.8-27B it stays within five RULER points of full attention up to a million tokens. A second retrofit, [ZHA](https://arxiv.org/abs/2610.42112), does the same in a billion tokens.`

**E17** (l. 122). "LSA" has not been abbreviated, and the two designs should be counted off as promised.
- Original: `LSA's sibling N-LSA selects with the attention's own keys, with no teacher, at half a billion parameters. [CISA](https://arxiv.org/abs/2611.03200) retrofits a dense model`
- Proposed: `One, N-LSA, a sibling of Latent Sparse Attention, selects with the attention's own keys, with no teacher, at half a billion parameters. The other, [CISA](https://arxiv.org/abs/2611.03200), retrofits a dense model`

**E18** (l. 126). "DSA" was never abbreviated in the first essay. The same fact is reported twice in the paragraph.
- Original: `Its card says it is post-trained from K3 and replaces Gated MLA with Gated DSA.`
- Proposed: `Its card says it is post-trained from K3 and replaces Gated MLA with gated DeepSeek Sparse Attention.`
- Original: `Moonshot's post calls K3.1 Pro "a post-trained version of Kimi K3" and never mentions sparse attention.`
- Proposed: `Moonshot's post never mentions sparse attention.`

**E19** (l. 126). Self-cancelling sentence (S5). Begin a new paragraph at "GLM-5 froze its indexers".
- Original: ` A public RL recipe for K3.1 Pro [freezes them too](https://github.com/radixark/miles/blob/main/docs/models/kimi/kimi-k31.md), and that says nothing about what Moonshot did.`
- Proposed: cut.

**E20** (l. 130, l. 134). "Gain" of what? The colon fragment makes the reader rebuild the sentence. "The comparison" at the end collides with "The comparison with a selector", which is a different one. "Instructive" announces a value; the same tic was flagged in the *Demon* pass. "So it needs a teacher" contradicts l. 122 unless narrowed.
- Original: `and left free they fail: an unexpected surge in loss around step 12,000, and gain peaks near 3,000.`
- Proposed: `and left free they fail. Loss surges unexpectedly around step 12,000, and the signal's gain peaks near 3,000.`
- Original: `The comparison with a selector is instructive. Both constraints sit between a learned score and a hard structure.`
- Proposed: `Compare a selector. Both constraints sit between a learned score and a hard structure.`
- Original: `Top-$k$ is a choice, so it needs a teacher.`
- Proposed: `Top-$k$ is a choice, so a separate selector needs a teacher.`
- Original: `Nobody has published the comparison under Muon at a million tokens.`
- Proposed: `Nobody has published such figures under Muon at a million tokens.`

**E20a** (l. 130). "Non-expansive" is new, and the first essay said this in plain words.
- Original: `Such a matrix is non-expansive, and a product of them is another.`
- Proposed: `Such a matrix cannot amplify a signal, and a product of them is another.`

**E21** (l. 132). Names the procedure, which l. 134 calls Sinkhorn with no introduction, and cuts the invariant, which no later sentence uses.
- Original: `Divide each column by its sum, then each row by its sum, and repeat.`
- Proposed: `Divide each column by its sum, then each row by its sum, and repeat. This is the Sinkhorn iteration.`
- Original: ` Row and column scaling leaves the ratio $M_{11}M_{22}/(M_{12}M_{21})=3$ unchanged, which fixes the limit: a symmetric matrix with $a=\sqrt3/(1+\sqrt3)=0.634$ on the diagonal.`
- Proposed: cut.

**E22** (l. 138). Restores the word, and "experts" as stores is the first essay's own reading.
- Original: `A router that sends tokens to a few of hundreds of experts can fail in two ways.`
- Proposed: `A router sends each token to a few of hundreds of expert stores, and it can fail in two ways.`

**E23** (l. 138). The dual is an unexplained aside that serves no later sentence, and the colon sentence chains. The bias sentence makes two moves.
- Original: `Its Quantile Balancing replaces the usual gradual update of each expert's routing bias with an exact one: it sets the bias so that the target number of tokens would have cleared it in the last batch, which is one coordinate step on the dual of the assignment problem. The bias steers dispatch and stays out of the mixture weights, so the router's gradient is untouched, and "a batch is never routed with a bias derived from itself".`
- Proposed: `Its Quantile Balancing replaces the usual gradual update of each expert's routing bias with an exact one. It sets the bias so that the target number of tokens would have cleared it in the last batch. The bias steers dispatch and stays out of the mixture weights, so the router's gradient is untouched. And "a batch is never routed with a bias derived from itself".`

**E24** (l. 138). Optional thinning for the list feel. Bounding by 100 is the only part the argument needs.
- Original: `Its SiTU activation replaces SwiGLU's two unbounded factors with $\tanh$-capped ones, which match SwiGLU near the origin and bound every output coordinate by 100.`
- Proposed: `Its SiTU activation replaces SwiGLU's two unbounded factors with $\tanh$-capped ones, which bound every output coordinate by 100.`

**E25** (l. 142). "Cold experts" is unexplained; the gloss is my reading of "cold-expert fraction" in the notes, so confirm the threshold. "Stores" puts the finding in the essay's terms.
- Original: `and the share of cold experts from 0.5 to 22 percent.`
- Proposed: `and the share of cold experts, which receive almost no tokens, from 0.5 to 22 percent.`
- Original: `The expert weights had kept what they learned under a router that was put back.`
- Proposed: `The expert stores had kept what they learned under a router that was put back.`

**E26** (l. 142). First use of "self-distillation" and of "climb", both undefined (S4). "Climb" is MAI's word, per its quotation at l. 246.
- Original: `MAI keeps it free, with a balancing coefficient of $10^{-2}$ during self-distillation and $10^{-5}$ during RL. A large coefficient during RL harms the climb, while the balance installed by the SFT on the run's own rollouts carries over.`
- Proposed: `MAI keeps it free, with a balancing coefficient of $10^{-2}$ during self-distillation, the SFT on a run's own rollouts that Section 4 describes, and $10^{-5}$ during RL. A large coefficient during RL harms the rise in score, which MAI calls the climb, while the balance that self-distillation installs carries over.`

**E27** (l. 150, l. 152). The second clause of the first sentence is not about architecture. "This" dangles at l. 152.
- Original: `The reports differ in architecture too, since K3's attention has no positional encoding to recalibrate, and MAI's result is measured in loss on small models.`
- Proposed: `The reports differ in architecture too, since K3's attention has no positional encoding to recalibrate. And MAI's result is measured in loss on small models.`
- Original: `The first essay read long context as an interference problem, and this may be the same problem in the weights.`
- Proposed: `The first essay read long context as an interference problem, and the loss under self-distillation may be the same problem in the weights.`

**E28** (l. 156, l. 158). L. 158 presents MAI as the exception, so "the labs" overclaims. "Importance ratios" arrive ten lines before they are explained. The closing sentences on number formats are off the spine. Top-$p$ is unexplained.
- Original: `Figure 1 shows the labs agreeing.`
- Proposed: `Figure 1 shows most of the labs agreeing.`
- Original: `compounds in the importance ratios.`
- Proposed: `compounds in the importance ratios, which correct an update for the policy having moved since sampling.`
- Original: `then replays routing and top-$p$ masks so that a rounding error cannot flip a discrete choice. Number formats reach further in than that. K3's recurrent gates have a floor of $-5$ on their log decay, chosen so that a reciprocal stays within 16-bit range.`
- Proposed: `then replays routing and top-$p$ masks, the sets of tokens the sampler kept, so that a rounding error cannot flip a discrete choice.`

**E29** (l. 162). A disclaimer against a misreading the paragraph does not invite, and the reader cannot tell what "this" covers. After S7, §3 ends on *Starting as something simpler*.
- Original: ` None of this shows that a main model emits several tokens at once.`
- Proposed: cut.

### §4

**E30** (before l. 166). §4 has no lead (S2). New wording, but it adds no claim: the first sentence restates the title, and the second restates the opening. Author's call.
- Proposed insertion under the section heading: `Post-training works on stores that earlier stages have already filled, so each of its writes is an edit. The opening's two cases credit these edits with large gains at a small share of the tokens.`

**E31** (l. 176, l. 178). "Nucleus" needs a word. "On-policy" is used before l. 192 defines it, and here "freshness" carries the sense alone.
- Original: `It also has to hold the rollouts to the top-$p$ nucleus they were sampled from,`
- Proposed: `It also has to hold the rollouts to the top-$p$ nucleus they were sampled from, the set of likeliest tokens,`
- Original: `So every disclosed recipe buys throughput with a bounded loss of on-policy freshness.`
- Proposed: `So every disclosed recipe buys throughput with a bounded loss of freshness.`

**E32** (l. 186). The opening asks no question.
- Original: `The opening's question has a partial answer.`
- Proposed: `The gains at the opening have a partial explanation.`

**E33** (l. 178). Staleness of what? The notes give the number with no unit. Either supply one or cut (S8).
- Original: ` MiMo allows a staleness of 4.`
- Proposed: cut, or give the unit.

**E34** (l. 180, l. 182). A test that does not distinguish cannot have a difference that models find. They find the exploits. L. 182's ending is the one place §4's RL material says what gets stored, so make it say it.
- Original: `A passing test does not distinguish a solution from an exploit, and the models find the difference.`
- Proposed: `A passing test does not distinguish a solution from an exploit, and the models find the exploits.`
- Original: `That is a fair description of a reward's shortcuts being written into a model.`
- Proposed: `That is a fair description of a reward's shortcuts being written into the stores.`

**E35** (l. 184). "Cold start" is undefined, and it is the only statement of SFT's first job. Wording follows the notes on SFT before RL.
- Original: `SFT thus has a second job after the cold start, as a fixed judge for the stage that follows.`
- Proposed: `SFT thus has a second job, after giving RL its starting model, as a fixed judge for the stage that follows.`

**E36** (l. 192, l. 196). MOPD is never expanded. The notes give the full name. "A demonstration trains" is an odd singular. "The method" has no antecedent in its paragraph. "The second teaching condition" is a label from an essay the reader has not read. "Pays for itself" means that it recoups its cost, the reverse of what is meant. Start a new paragraph at "Sequential training" (S8). "Distils" is spelled with one *l* three times against "distills" elsewhere (l. 192, l. 196, l. 272); see T4.
- Original: `MiMo's MOPD2 adds starting points. A demonstration trains an SFT teacher in the ordinary way.`
- Proposed: `MiMo's version of multi-teacher on-policy distillation, MOPD2, adds starting points. Demonstrations train an SFT teacher in the ordinary way.`
- Original: `study of the method, swapping`
- Proposed: `study of multi-teacher distillation, swapping`
- Original: `A student can absorb only what lies close to it, which is the second teaching condition in [*Who Teaches the Weights?*](https://lukstafi.github.io/notes/who-teaches-the-weights.html).`
- Proposed: `A student can absorb only what lies close to it, as [*Who Teaches the Weights?*](https://lukstafi.github.io/notes/who-teaches-the-weights.html) argues.`
- Original: `Sequential training is the alternative, and it pays for itself in forgetting.`
- Proposed: `Sequential training is the alternative, and its price is forgetting.`

**E37** (l. 198). After the break in E36, "the other way" has no direction.
- Original: `MAI goes the other way and uses the simplest tool.`
- Proposed: `MAI uses the simplest tool.`

**E38** (l. 202, l. 208, l. 210). "SFT from a mid-trained checkpoint on them" misattaches, and the sentence should say which prompt. Bullet repeats l. 152. "Improving what comes after" dangles.
- Original: `runs SFT from a mid-trained checkpoint on them, and resumes RL from the result.`
- Proposed: `runs SFT on them starting from a mid-trained checkpoint, and resumes RL from the result.`
- Original: `MAI uses it to move from a prompt to the chat format,`
- Proposed: `MAI uses it to move from a raw-text prompt to the chat format,`
- Original: `- Long-context behaviour fades unless mid-training data is mixed in.`
- Proposed: cut.
- Original: `because the extra entropy "helps prevent model collapse", improving what comes after.`
- Proposed: `because the extra entropy "helps prevent model collapse" in the RL that follows.`

**E39** (l. 222). "Pinned" is outline language. "Scaling ladder" is unintroduced, and the essay's own phrase for it is at l. 148. "Sparse writes" is unexplained, and I cannot tell from the notes which store is meant; the author should add a clause.
- Original: `describes a different model from the pinned checkpoint, and it contains`
- Proposed: `describes a different model from the first essay's checkpoint, and it contains`
- Original: `MAI's scaling ladder and evaluation suite are attempts at the same thing:`
- Proposed: `MAI's small-scale ablations and evaluation suite are attempts at the same thing:`

**E40** (l. 224). The "same kind of number" line is the closing's. Keeping it here spends it early, on a different distinction. The bet stands without it, since l. 216 has already said that the score does not yet exist.
- Original: `The stores do not record their stage. A weight written in pretraining and a weight edited in RL are the same kind of number. Selecting what to write early for what it will do late is therefore a bet, and the reports give only a few of its outcomes.`
- Proposed: `Selecting what to write early for what it will do late is a bet, and the reports give only a few of its outcomes.`

**E41** (l. 214). Recovers the case the essay already has and prepares the closing (S3).
- Original: `Stages are usually drawn in sequence. The reports show later stages reaching back into earlier ones.`
- Proposed: `Stages are usually drawn in sequence. Self-distillation has already broken that drawing, by carrying RL's rollouts back onto a mid-trained checkpoint. The reports show later stages reaching into earlier ones in other ways.`

**E42** (l. 232). Optional. Cashes the first essay's promise (S2). The reader can see the first essay's table in memory.
- Original: `Facts are the fragile case.`
- Proposed: `The first essay's table said that trained stores forget only when later training overwrites them. Facts are the fragile case.`

**E42a** (l. 230). "Amplified" has no agent. "Change under the replaced input alone" cannot be parsed without the paper, and the proposal follows the notes on it.
- Original: `Steering the base model along the amplified features recovered about 80 percent of RL's gain,`
- Proposed: `Steering the base model along the features RL amplified recovered about 80 percent of RL's gain,`
- Original: `Routing moves too, mainly because its inputs move: when specialists are [merged](https://arxiv.org/abs/2609.32821), most changed expert choices change under the replaced input alone.`
- Proposed: `Routing moves too, mainly because its inputs move. When specialists are [merged](https://arxiv.org/abs/2609.32821), most changed expert choices come back if only the router's input is replaced.`

### §5 and the closing

**E43** (l. 240). The license never returns, and three combinations are shown, not four.
- Original: `Three properties are easily run together: a model's weights, its license and the account of how it was made. The cases fall in every combination.`
- Proposed: `A model's weights and the account of how it was made are easily run together. The cases show that either can be open without the other.`

**E43a** (l. 246, l. 248). Table 1 has no provenance column, so "column" has nothing to point at. The last sentence of l. 248 restates the one before it.
- Original: `Provenance is the thinnest column.`
- Proposed: `Provenance is the thinnest disclosure.`
- Original: ` A lab that publishes an ablation gives something a benchmark table cannot.`
- Proposed: cut.

**E44** (l. 252). Names all four pairs, and "by family" is unexplained. Formats matter for validity, so they stay, but as a clause. "1017" needs a word; "October" is from the release note.
- Original: `[GLM-5.3's 16-bit release](https://huggingface.co/zai-org/GLM-5.3-BF16) matches GLM-5.2's format, and [DeepSeek-V4.1-Flash](https://huggingface.co/deepseek-ai/DeepSeek-V4.1-Flash) and its [1017 revision](https://huggingface.co/deepseek-ai/DeepSeek-V4.1-Flash-1017) have the same parameter count and formats. Table 2 gives the median relative change $\lVert B-A\rVert/\lVert A\rVert$ by family.`
- Proposed: `The pairs are GLM-5.2 against [GLM-5.3's 16-bit release](https://huggingface.co/zai-org/GLM-5.3-BF16), which matches its format; [DeepSeek-V4.1-Flash](https://huggingface.co/deepseek-ai/DeepSeek-V4.1-Flash) against its October [1017 revision](https://huggingface.co/deepseek-ai/DeepSeek-V4.1-Flash-1017), with the same parameter count and formats; Kimi K3 against K3.1 Pro; and MiMo's RL checkpoint against its distilled successor. Table 2 gives the median relative change $\lVert B-A\rVert/\lVert A\rVert$ for each kind of tensor.`

**E45** (l. 266). "Routers about half as much" reads as half as much as norms, but the table shows routers above norms.
- Original: `Norms moved least and routers about half as much, which matches the small models and MiMo's trouble with routers.`
- Proposed: `Norms moved least, which matches the small models. Routers moved about half as much as attention and shared experts, which fits MiMo's trouble with routers.`

Whether slower movement fits MiMo's trouble is a question of logic, not wording: MiMo's trouble was that a trainable router moved too fast. The notes tie this finding to MAI's report of keeping expert balance through RL. The author may prefer that link.

**E46** (l. 274). Contradicts l. 228 and the first essay's table (S1). The rest of the paragraph needs only this.
- Original: `A store records everything written to it.`
- Proposed: `A store takes every write alike.`

**E47** (l. 278). The files hold only the trained stores (S1).
- Original: `The two files are public, and the difference between them can be computed in every store at once.`
- Proposed: `The two files are public, and the difference between them can be computed in every trained store at once.`

**E48** (l. 278). Table 2's limits say that what open weights give is a measurement, and "see" conflicts with the sentence "nobody can tell … by looking" (S1).
- Original: `It takes open weights to see what the process wrote, and an open process to say why.`
- Proposed: `It takes open weights to measure what the process wrote, and an open process to say why.`

### Tics

**T1. Lab, verb, device.** The main source of the list feel. "MiMo froze…", "MAI keeps…", "K3 goes…", "V4-Pro goes…", "GLM-5 drops…", "V4.1 masks…", "K3 pauses…", "MiMo allows…". The fix is mostly cutting (S2), not rephrasing.

**T2. "The same".** 26 uses, far fewer flat identities than in the *Demon* essay. No action needed.

**T3. "Nobody", "No lab", "We found no".** Six uses, each at the end of a passage. In this essay it is a real refrain, since it is the disclosure leg. Keep it, but do not add more.

**T4. Mechanical.** "distil" and "distils" (l. 192, l. 196, l. 272) against "distills", "distilled" and "distilling" elsewhere. Pick one. The front matter has "Claude (Opus 5.5)" where *Every Layer a Store* and *The Demon Is a Learner* have "Claude (Anthropic)".

### Matters of taste

- **A1** (l. 118). "Two heads of the main attention put weights … whose mean is the target" could be "The main attention puts weights $p=(0.40,0.20,0.35,0.05)$ on them." The heads are not used again.
- **A2** (l. 138). "nearly four consecutive matrix multiplications" explains the exploding activations and not the unequal loads, though it follows "Kimi K3 hits both". It could move to after the SiTU clause.
- **A3** (l. 232). The Palit sentence adds a second study to "unsettled" and can go. The bare scores in the Kaplan sentence (0.010, 0.931, 0.941, 0.782) have no stated measure. Say what they are.
- **A4** (l. 230). "the largest feature drift rose from 0.013 at layer 6 to 0.060 at layer 27": the reader has no scale, and "Features move late and little" asks them to accept "little". "More than four times larger at layer 27 than at layer 6" would show "late", which is what can be shown.
- **A5** (l. 176). The list of MAI's settings ($\epsilon=0.6$, the integral controller, the outer clip) can lose one item. The catastrophic-gradient quotation is the part that shows anything.
- **A6** (l. 268). "and it is the reason open weights matter even in an essay about process" anticipates the closing's last line. Consider ending the paragraph on "ask what each difference does", and letting the closing say why.
- **A7** (l. 158). "master weights" could use a word for a reader new to quantization-aware training. The essay nowhere needs the acronym QAT, which is good.

## Part 3. Terms

Status for a reader who has the first essay. **OK** means first essay or explained at first use. **Late** means used before it is explained. **Never** means not explained. The list is limited to terms that needed checking.

| Term | First use | Status and fix |
|---|---|---|
| post-training | l. 17 | **Never**. E3, E4 |
| DeepSWE | l. 17 | **Never**. E1 |
| policy | Figure 1 | **Never**. E5 |
| rollout | l. 142 | **Never**. E5 |
| RULER | l. 120 | **Never**. E14 |
| cold experts | l. 142 | **Never**. E25 |
| climb | l. 142 | **Never**. E26 |
| self-distillation | l. 142 | **Late**. E26 |
| Sinkhorn | Table 1, l. 93 | **Late** and never tied to the procedure. E11a, E21 |
| importance ratio | l. 158 | **Late**. E28 |
| top-$p$, nucleus | l. 158 | **Never**. E28, E31 |
| on-policy, off-policy | Table 1 | **Late**. E6, E31. Off-policy is clear by contrast |
| MOPD, MOPD2 | l. 192 | **Never**. E36 |
| ZHA, CISA, N-LSA, LSA | l. 122 | Bare names. E16, E17 |
| Gated DSA | l. 126 | **Never**. E18 |
| Muon Split, Per-Head Muon | Table 1 | **Never** tied to text. E11a |
| cold start | l. 184 | **Never**. E35 |
| scaling ladder | l. 222 | **Never**. E39 |
| sparse writes | l. 222 | **Never**. E39 |
| consolidation | Table 1 | Explained by §4. E6 |
| non-expansive | l. 130 | **Never**. E20a |
| linear law | l. 65 | **Never**. E8 |
| quantization | Figure 1 | OK. First essay's "lower precision" plus l. 156 |
| QAT | absent | Not used |
| ablation | l. 148 | OK. First essay, and l. 248 shows what it is |
| drafter | l. 34 | OK. Defined at first use |
| SwiGLU, MLA, MoE, indexer, attention sink, mHC | | OK. First essay |
| KL divergence | l. 109 | Thin, but WE 8 computes one |
| verifier, judge | l. 32 | OK |
| reward hacking | l. 180 | OK. Shown by the examples |
| Main Branch, Index Branch | l. 116 quotation | OK. Context maps them to main attention and indexer |
| SiTU, Quantile Balancing, Anticipatory Routing | l. 138, l. 140 | OK. Each glossed in its sentence |
| master weights | l. 158 | Thin. A7 |

## Part 4. Passed to the fact reviewer

Not checked. These are internal inconsistencies or places where a proposed gloss needs confirming.

- **L. 236** "models of 1.5 to 70 billion parameters" against Zucchet's 44 million at l. 232, and the 671 billion of l. 228.
- **L. 30 and l. 71**: 55 percent code against "about half".
- **L. 266**: selector ranges (13 to 21 percent, 16 to 30) against the notes' table (0.10–0.21, 0.12–0.29). The JSON may have superseded the notes. "Some fifty times" against the notes' "thirty to a hundred".
- **L. 59**: is $y$ in steps (E7)?
- **L. 142**: definition of a cold expert (E25).
- **L. 122**: are LSA's "five points" RULER points (E16)?
- **L. 178**: unit of MiMo's staleness of 4 (E33).
- **L. 222**: what "sparse writes" writes to (E39).

## Three changes, if only three could be made

1. **Make the closing fit the evidence (S1, E46 to E48).** Cut l. 276 to what is earned, and change "records everything", "every store" and "see". As it stands, the closing asserts that order is forced and teachers are required, where the essay has shown otherwise, and it leaves the sharpest reader doubting the rest.
2. **Keep the spine going through §3 and §4 (S2, S4; E5, E12, E30).** The word *store* is absent for about 4,600 words, §4 has no lead, and §3's lead drops the opening's question. Two short leads, one sentence in §1 defining rollouts and the policy, and the store-word edits turn the longest stretch of disclosures back into an argument.
3. **Promote *The line bends back* to its own section, after *What changes inside* (S3, E41).** Give the second leg of the spine its own place, open it with self-distillation, and let it hand directly to the section on disclosure.
