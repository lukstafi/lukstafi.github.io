---
title: "Study notes: What Persists When the Agents Change?"
essay: what-persists-when-agents-change
track: which-intelligence
reviewed-against: "fb0bdad"
requires:
  - {at: which-agi#the-trajectory-and-the-front, for: "the claims this essay revises: that a consensus front carries only what is consistent across the population, and that interpreted memory saturates"}
  - {at: which-agi#why-the-lineage-should-stay-a-civilization, for: "the monoculture concern and the preference for individually compiled trajectories"}
  - {at: which-agi#what-a-deployment-has-and-what-it-lacks, for: "roles against fillers, and interpreted consolidation as filling a role"}
  - {at: which-world-model, for: "the standard that competence does not locate a mechanism, and the separation of having a map from tracking, predicting, acting and retaining"}
introduces:
  - {term: model identity and trajectory identity, at: shared-weights-divergent-trajectories, gloss: "copies of one model given one prompt still make different attempts, and each attempt becomes part of its own later context"}
  - {term: persistent inquiry with replaceable interpreters, at: when-discoveries-accumulate, gloss: "Wójcik's proposal: explicit records carry an inquiry's history so that it is recoverable across interpreters"}
  - {term: transactive memory, at: where-experience-persists, gloss: "a shared repository of trajectories from which other agents retrieve, matched to their current state"}
  - {term: local memory, at: where-experience-persists, gloss: "explicit, role-specific state that gives a shared conversation a different retained interpretation for each participant"}
  - {term: hosting and judging perspectives, at: representations-in-use, gloss: "representing two traditions in shared machinery against assessing their claims well"}
  - {term: representational conjecture, at: what-should-persist, gloss: "that training insulated within a trajectory reaches representational spaces which shared training and contextual adaptation do not"}
uses:
  - {term: "process, deployment and lineage", from: which-agi}
  - {term: cog view, from: which-agi}
  - {term: profile, from: which-agi}
  - {term: compiled/interpreted gap, from: which-agi}
  - {term: trajectory and front, from: which-agi}
  - {term: possessing versus using a representation, from: which-world-model}
  - {term: five capacities of a world model, from: which-world-model}
---

The essay revises a position taken in "Which AGI?". The answers state the revision as the essay makes it, and mark which sources are experiments and which are testimony.

### What is being reassessed {kind=state}

Which speculative conjecture lay behind the earlier preference for individual consolidation? What does Wójcik's response propose in its place, and what three things does it say interpretation positively enables? Where does the essay now stand on the conjecture?

::: answer
The conjecture: training insulated within particular trajectories might reach qualitatively different representational spaces from those reached through a common training process and contextual adaptation. Wójcik, in discussion with the Thomas Epistemes chatbot, proposes persistent inquiries supported by replaceable interpreters, with explicit records carrying their histories. Interpretation enables communication, immediate revision, and entering a new conceptual framework without first retraining the learner. The essay no longer takes the conjectured advantage as a reason to favor individually compiled trajectories. The conjecture remains an empirical question, and it no longer carries the argument for a preferred form of artificial individuality.
:::

### The corrected sentence {kind=explain}

"Which AGI?" said that a consensus front "can carry only what is consistent across the population." What is wrong with that? Why would consistency under a particular context still miss something?

::: answer
A shared model can support incompatible perspectives, and its competence need not reduce them to what they agree on. Learning from a corpus does not make a model an intellectual average of the corpus. Consistency under a context misses that a context can leave several developments open. One continuation provisionally adopts a hypothesis and another rejects it, and each trajectory stays coherent while their commitments conflict. Stochastic generation makes the branching visible, and new evidence, an instruction or a chosen experiment can also select a branch. The resulting history then becomes part of the conditions for later thought.
:::

### The jobs of a record {kind=connect}

"Which World Model?" separated possessing a map from tracking a position, predicting, acting and retaining corrections. Which jobs does this essay separate for a research trajectory? Why is there no clean opposition between an external history and internal understanding?

::: answer
Possessing a record, finding the relevant part, interpreting it, deciding whether to trust it, and using it to improve a new attempt. Coordinating them can be an achievement of the deployment, and recognizing the jobs as filled leaves open how their interaction changes its reach. Reading a record can produce representations of its subject during inference: a note about a failed experiment can lead the model to represent the dependency that caused the failure. The weights stay unchanged while the active representation of the problem changes substantially. Conversely, storing a lesson in parameters does not guarantee that it is retrieved or applied appropriately. An inquiry's history can be reconstructed in use without being continuously instantiated between uses.
:::

### Same model, different attempts {kind=case at=shared-weights-divergent-trajectories}

In the multiagent debate experiments, copies of one model receive the same prompt, answer independently, then read one another's answers and revise. What does this arrangement separate? Why is agreement among the agents weak evidence by itself? What becomes of the earlier essay's concern about correlated failure?

::: answer
It separates model identity from trajectory identity. Identical instructions do not produce identical attempts, an agent's answer becomes part of its own later context, and another answer supplies a new object of scrutiny. Some examples begin with every agent wrong and end correct. The procedure can also settle confidently on a false conclusion, so the evidential value of agreement depends on how it was reached. Heterogeneity names several interventions: a team can share weights and differ in instructions, evidence, tools or history, and a team of different model families can converge on the same mistake. Diversity is useful relative to a problem. The concern about correlated failure survives as an evaluation question: which consequential failures stay correlated under different contexts and histories. The number of distinct weight sets is one possible explanatory variable.
:::

### More than parallel sampling {kind=compute at=when-discoveries-accumulate}

The communication study compares a team with the best result from the same number of independent agents. Why is that the right baseline? On the public ARC-AGI-3 games, teams of five solved $8.0$ percent of full games and the best of five independent attempts solved $2.2$ percent; matching the team was estimated to need $33$ independent attempts. Compute the ratio of solve rates and the ratio of attempts. In what sense was the setup homogeneous and still differentiated?

::: answer
The independent baseline keeps its best final result, so communication has to contribute something beyond the extra chances of parallel sampling. The solve rate is $8.0/2.2\approx3.6$ times higher, and matching it takes $33/5=6.6$ times as many independent attempts. Most games stayed unsolved either way. The agents shared model, tools, instructions and per-agent resources, with no specialist roles or orchestrator. The protocol differentiated them: they claim separate slots, choose approaches distinct from those already claimed, publish reproducible evidence, adopt a clearly better result, and preserve a meaningful variation after adopting it.
:::

### An idea passes through three agents {kind=case at=when-discoveries-accumulate}

In the polyomino-packing run, trace the contact criterion through three agents. What would be lost if only winning answers crossed between agents? How does the run qualify the idea that depth belongs to one continuing locus?

::: answer
One agent proposes favoring placements with more contact against occupied cells; its implementation is slow and the score barely improves. A second reads the proposal in the log, reconstructs the method without reading the code, and makes a thorough search over orientations affordable. A third extends the criterion to contact with the rectangle's walls. The useful idea first appeared inside an unsuccessful implementation. With only winners shared, a recipient could not reconsider what failed, separate a principle from its inefficient implementation, or find a use the producer did not realize. No single agent carries every stage. Shared discoveries alter where later exploration begins, so the team's breadth contributes to its depth: the search does not restart from the original problem.
:::

### When communication helps {kind=explain at=when-discoveries-accumulate}

Name the conditions under which the communicating team kept its advantage, and the comparison in which it did not. Why does the protocol tell agents to preserve a variation? Why do the experiments not settle the question of heterodox inquiry, and what does the essay refuse to conclude from that?

::: answer
Participants could check intermediate progress: programs receive scores and game levels can be completed, which gives grounds for adoption beyond another agent's confidence. They also needed enough budget each to explore before there was progress to exchange. On Terminal-Bench a communicating pair did not beat two independent attempts. Copying every later choice would eliminate the independent exploration from which the next improvement comes. A new research programme may lack a score, since its contribution may be a different question, a new instrument, or an objection to the evaluation. That is a limit on the experiments, and it is not evidence that a privately compiled individual supplies the missing answer. A committee, a protected project or a continuing dialogue can also organize the judgment. Protecting a research programme and insulating its neural training are different interventions.
:::

### Experience across a population {kind=explain at=where-experience-persists}

In Multi-Agent Transactive Memory, what is stored and how is retrieval matched to the consumer? What is the reranker trained to predict? What did the study find about the direction in which useful experience flows? Why does the essay say the interpreted/compiled division runs through the system?

::: answer
Producer agents contribute action–observation histories, not only polished solutions. The consumer's recent interaction history helps form the query, because two agents with the same goal can have reached different intermediate states. The reranker's target is whether adding a chunk improves the consumer's outcome relative to proceeding without it, which is more demanding than textual similarity. Consumers benefited from producers on both sides of the capability gap, and the gap had only a small, statistically insignificant association with the advantage. A stronger general interpreter does not make a particular history redundant. The system combines explicit records with a trained mechanism for exploiting them, so the division does not place whole systems on opposite sides. The study does not isolate a benefit of model diversity.
:::

### Shared archive, local memory {kind=distinguish at=where-experience-persists}

Which two operations do the memory proposals supply? Contrast a record that says "use method B" with one that serves a successor better. Why is replacing a process while keeping its memory a different intervention from deleting the memory?

::: answer
A shared repository makes experience available beyond its producer. Local, role-specific memory organizes what matters to a particular participant: a design change matters to a cost specialist and to a reliability specialist for different reasons. The two coexist. "Use method B" may reproduce a useful orientation. A record of why method A failed, which observation favored B and what still counts against B also supplies grounds for changing course. Curation should let a successor re-enter the inquiry critically. A process can be replaceable because the state organizing its contribution is preserved elsewhere. A fresh model given only a generic role description can fail where the former succeeds. The difference shows a contribution of history without establishing a requirement for private neural consolidation.
:::

### What an identity is for {kind=explain at=where-experience-persists}

Anthropic's scaffold gives agents individual identities that persist across model upgrades. What epistemic function does the essay find in this? State Janus's two concerns about how continuity is maintained, and the status the essay gives them.

::: answer
If three agents repeat a claim from one unverified experiment, preserving its origin keeps their agreement from counting as three independent confirmations. A continuing identity also makes a history of decisions open to scrutiny: who checked a result, who relayed it, who revised it. This works only if agents and oversight use the records, and the report does not isolate the effect. Janus's first concern is compression: a large compaction near the end of a context window can lose what is needed to reconstruct the agent's situation, and she favors frequent compression of smaller portions. Her second is switching models beneath a continuing identity, which can mismatch the inherited history with the new model's self-model; she suggests an explicit handoff. The essay treats these as practitioner observations and hypotheses that need testing. Her assumption about Anthropic's compaction method is unverified.
:::

### Having a perspective and sustaining it {kind=distinguish at=representations-in-use}

What distinction does the essay take from nostalgebraist's comment on the persona selection model? Why does a role label explain little? Distinguish hosting perspectives from judging between them, and say what the essay would test.

::: answer
Having resources for representing a perspective differs from reliably sustaining its expression. Novel characters can arise by recombining learned features, so an inquiry can acquire an organization never present as a named persona in the corpus. A role description supplies an initial orientation, and evidence, objective, perceived evaluation and memory affect its expression: a skeptical reviewer who defers to confident colleagues is not effectively skeptical. A practical account traces what changes decisions. Shared machinery might let one tradition expose a blind spot in another, and representing both does not guarantee that the criticism is elicited or assessed well. The test: can the model recover a minority programme's consequential distinctions, apply them to a new problem, and identify evidence for or against its claims? Imitating its vocabulary is insufficient.
:::

### Saturation, revisited {kind=argue at=representations-in-use}

"Which AGI?" held that interpreted memory must saturate because every achievement has to be reread and followed again. Why does the essay now call the inference to a fixed ceiling too quick? Name four forms in which a lesson can persist, and the failure modes the essay attaches to the remedies.

::: answer
Some costs recur, and four mechanisms loosen the ceiling. Retrieval avoids loading the whole history. Summaries preserve selected dependencies. Executable artifacts replace repeated derivation with invocation. A deployment can change its working environment so that later steps begin from a more capable position. A lesson can persist as a learned skill (fluent and cheap), an explicit procedure (assumptions visible, immediately correctable), a reusable program (cheap without entering the parameters), or a retrieval policy that learns which record to consult. Different parts of one lesson can take different forms. The failure modes: a summary omits the reason an exception matters, retrieval surfaces an obsolete procedure, a tool conceals an assumption. These call for provenance, exposed conditions of use and support for revision.
:::

### The replacement experiment {kind=state at=what-should-persist}

Describe the intervention the essay proposes for finding out what must persist. How is each outcome read? Which further comparison would test the original representational conjecture?

::: answer
Replace participants at different stages of an inquiry. Give the new process the curated state its predecessor left, and compare it with a continuing process under comparable resources. Vary what is preserved: the full transcript, a compact project record, local memory, executable artifacts, or only the original task. Measure repeated mistakes, time recovering context, selection of experiments and later results. Introduce evidence against an inherited assumption and test whether the successor can explain why it was held and revise it. If curated records suffice, that shows what can be transferred. If replacement costs something, ask which omitted state explains it. If a better handoff removes the cost, the deficit belonged to the transfer mechanism. The conjecture needs another comparison: learning histories that modify neural components separately, the same experience pooled into shared training, and histories preserved in contextual memory. Different representations alone would not show an advantage; they would have to enable consequential inquiry.
:::

### What the essay leaves open {kind=limits at=what-should-persist}

What has changed since "Which AGI?", and what has not been shown? Name three further matters the essay leaves open.

::: answer
The speculative case for favoring insulated neural trajectories has weakened, because the reach of interpreted, interacting trajectories has become more concrete. The essay no longer infers from neural homogeneity that trajectories lack the differentiation that matters. The studies do not compare the representational spaces reachable through insulated and shared training, so the conjecture stands untested.

- Whether training on a protected project's records preserves its structure faithfully.
- Who controls the shared interpreter: training, post-training and access decisions can leave a tradition archived and hard to activate competently.
- The moral question. Wójcik's precautionary argument against engineering toward persistent artificial personhood is set aside for separate consideration. An inquiry's surviving the replacement of processes does not establish that they lack experience or interests.
:::
