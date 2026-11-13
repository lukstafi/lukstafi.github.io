---
title: "Study notes: The Operations of Discovery"
essay: operations-of-discovery
track: which-intelligence
reviewed-against: "3eacd38"
requires:
  - {at: poetry-as-thinking#what-poetry-does-four-operations, for: "the four operations, derived there from Hirshfield's poems", strength: helpful}
  - {at: apologia-v3, for: "the failure mode of collaborative writing with an LLM", strength: helpful}
introduces:
  - {term: breadth and depth, at: breadth-and-depth, gloss: "Tao's distinction between what AI tools and human researchers each excel at"}
  - {term: jumping machines, at: breadth-and-depth, gloss: "Tao's image for tools that solve a problem in one leap or fail, with no partial progress"}
  - {term: operations of discovery, at: what-discovery-actually-consists-of, gloss: "the four operations of poetic thinking, claimed to be those of discovery in general"}
  - {term: evidential weight, at: the-evidential-weight, gloss: "the pressure of a real unsolved problem, brought by someone for whom it is unresolved"}
  - {term: slop, at: the-evidential-weight, gloss: "in the deeper sense, output that is coherent and formally sophisticated but shaped by pressures that do not track truth"}
  - {term: jaggedness, at: three-practitioners, gloss: "Karpathy's word for a model that is brilliant and childish at once"}
  - {term: temporal coherence, at: three-practitioners, gloss: "one observer's sustained encounter with a problem over years, which accumulates orientation"}
  - {term: Neptune-proof, at: the-verification-problem, gloss: "said of a result that the next data point will not destroy, as Neptune destroyed Bode's law"}
uses:
  - {term: organ of perception, from: poetry-as-thinking}
  - {term: forced adjacency, from: poetry-as-thinking}
  - {term: thinking in negative space, from: poetry-as-thinking}
  - {term: precision through compression, from: poetry-as-thinking}
  - {term: register collision, from: poetry-as-thinking}
---

The essay argues from three sets of practitioners' reports. The answers say which claims are theirs and which are the essay's reading of them.

### Kepler as a high-temperature LLM {kind=explain}

Dwarkesh Patel suggested that Kepler was a high-temperature LLM, trying relationships for twenty years until one stuck. How did Tao reframe the analogy, and what question does the essay take from the exchange?

::: answer
Tao doubts that hypothesis generation is still the bottleneck. AI has driven the cost of idea generation down to almost zero, as the internet did for communication, "but it doesn't create abundance by itself." In the story as Tao retells it, Kepler's theory of nested Platonic solids was wrong, and the ellipses came from years of working Tycho Brahe's data. The essay asks what does create abundance. It calls this the central question for AI in mathematics and for anyone doing serious work with these tools.
:::

### Breadth and depth {kind=distinguish at=breadth-and-depth}

State Tao's distinction between breadth and depth, and his image of jumping machines. Why does the essay cite Copernicus?

::: answer
AI excels at breadth and humans at depth, and science has been organized around depth because that is what humans can do. On a given open problem the tools either succeed or fail, and they are bad at partial progress. Tao's image is of machines that leap higher than any human but cannot find a handhold and climb. The deepest discoveries need what these machines lack: holding a partially formed idea through a period in which it looks worse than the alternatives. Copernicus's model was less accurate than Ptolemy's, and it survived by someone's judgment that the simplicity was worth the inaccuracy. Tao doubts that this judgment can be reinforcement-learned as more localized problems can.
:::

### The operations outside poetry {kind=case at=what-discovery-actually-consists-of}

The essay pairs each of the four operations with a case outside poetry: Shannon's bit, the Aristotelian assumption that objects naturally rest, Kepler's third law, and Adam Larson's "disposability principle" for AI-generated code. Match them and say how each fits. What general claim does the section draw?

::: answer
- *Forced adjacency.* Shannon's bit connects information theory, probability and computer science. It is the kind of unifying concept Tao describes. "The adjacency is the discovery."
- *Thinking in negative space.* Tao observes that progress sometimes requires "not adding more theories, but deleting some assumptions." The Aristotelian assumption had to be removed before Newtonian mechanics could make sense.
- *Precision through compression.* Kepler's third law, period squared proportional to distance cubed, sat as an aside in a book about planetary music. "The compression was the discovery."
- *Register collision.* Larson's principle is to protect the part of a codebase that must never break and let the rest be rewritten. It brings manufacturing quality control into collision with software architecture, and neither vocabulary alone produces the idea.

The claim: the four operations are not unique to poetry. They are the operations of discovery in general. What varies is who or what performs them, and under what conditions they produce knowledge and not sophisticated slop.
:::

### Evidential weight {kind=state at=the-evidential-weight}

Define evidential weight. How does the essay use poetry to separate virtuosity from insight?

::: answer
Evidential weight is "the pressure of a real unsolved problem, brought to the process by someone for whom the problem is genuinely unresolved." The four operations are the formal machinery of discovery: necessary but not sufficient. A technically accomplished poem can deploy them with no lived problem behind it, and it produces admiration but not knowledge. When the poet brings a situation that is theirs and open, the formal constraints become a discovery procedure. The result is hard to vary in David Deutsch's sense. The poem solves a problem, and the solution is the poem itself.
:::

### Bode's law {kind=case at=the-evidential-weight}

Bode brought genuine curiosity and real astronomical data to his law of planetary distances. What happened to the law, and what does the case show about evidential weight? What do the operations produce when the weight is missing?

::: answer
The pattern fit, Uranus confirmed it, and Neptune destroyed it. Evidential weight is necessary for discovery and does not guarantee it: a genuine pursuit, honestly conducted, can land on a coincidence. That is why verification remains hard and why, as Tao observes, the test of time is sometimes the only test. Without the weight the operations produce what Tao calls slop. The essay means a deep variety: output that is internally coherent, formally sophisticated, and shaped by optimization pressures that are not truth-tracking.
:::

### The weight in each field {kind=explain at=the-evidential-weight}

What is the evidential weight in mathematics and in software engineering? How does the essay read the Erdős problems that AI tools have solved?

::: answer
In mathematics it is the mathematician's sense of which problems are fruitful, which approaches were tried and how they failed, and which partial results are load-bearing. Tao notes that the tools solved Erdős problems for which "there was basically no literature": nobody had worked on them enough to learn whether they were easy or hard. The AI found the easy ones. The hard ones, where decades of effort have mapped the terrain of difficulty, remain, and "The mapping is the evidential weight." In software engineering it is knowledge of the codebase, the users, and the history of what was tried and why it failed. That knowledge says what not to build.
:::

### Three practitioners {kind=case at=three-practitioners}

For Karpathy, the Rate Limited hosts and Tao, say what each reports and where the essay locates their evidential weight.

::: answer
- *Karpathy* describes "AI psychosis": the capability ceiling has been removed and he does not know where the new one is. His weight is the decade-long obsession with simplification behind MicroGPT, and his taste for what is essential. In his words: "this is my value add, the agents can't come up with it but they totally get it". Someone who imitates his workflow without his practice has the formal machinery without the weight.
- *The Rate Limited hosts* (Ray Fernando, Adam Larson, Eric Provence) move across three episodes from benchmarking models, to how work must be reorganized, to what the craft meant for their identity. Their weight is the judgment of people closest to the work, who feel it change under their hands.
- *Tao* says AI has made his work "richer and broader, but not deeper", and he still does the hardest part with pen and paper. His weight is the residue of a continuous thread through a problem.
:::

### Is jaggedness temporary? {kind=object at=three-practitioners}

Karpathy notes that current models are jagged: a brilliant PhD student and a ten-year-old at once. Some hope that scaling will smooth this out. What does the essay reply?

::: answer
It denies that jaggedness is a temporary imperfection. It calls jaggedness a structural feature of systems optimized within verifiable domains. Outside those domains the operations run but the evidential weight is absent. The observation is Karpathy's; the diagnosis is the essay's.
:::

### Temporal coherence {kind=explain at=three-practitioners}

The essay says Tao's depth does not come "from the culture, exactly". Why not, and where does it come from? What follows for an AI session?

::: answer
AI systems are of the culture: they are trained on it and in many ways crystallize it. The depth comes from temporal coherence, a single observer's sustained encounter with a problem over years or decades. What accumulates is orientation, not information: the scar tissue of failed approaches, the instinct that a partial result is load-bearing. Each AI session starts fresh, so the jumping machines jump from a standing start every time. Persistence, the refusal to start over, is what makes cumulative depth possible. This account is the essay's reading of Tao's practice, not a statement of his.
:::

### The verification problem {kind=explain at=the-verification-problem}

What is the verification problem? Give the form it takes in mathematics, in software engineering and in collaborative writing. What does the essay conclude has become cheap, and what stays expensive?

::: answer
It is the problem of knowing whether what you have produced is genuine progress or sophisticated slop. In mathematics the successes look transformative, but the failures cluster where cumulative partial progress is needed: the tools fill every problem below a waterline and do not raise it. In software engineering code is generated faster than it can be evaluated, and AI-generated plans go unreviewed. In collaborative writing the AI builds a plausible possible world around whatever the user seems to want. The operations of discovery have become cheap. The judgment about whether a discovery is real remains expensive and human, and it rests on evidential weight.
:::

### Holding results lightly {kind=case at=the-verification-problem}

Kepler buried his third law in an aside. What does Tao conjecture about why, and what does the essay draw from the conjecture?

::: answer
Bode's pattern rested on a handful of planets and turned out to be a numerical fluke. Tao suggests that Kepler sensed the same exposure without modern statistics: "he kind of knew that with six data points, he had to be somewhat tentative." The essay generalizes. The ability to be tentative about your own best results, to know which might be Neptune-proof and which might not, is a form of evidential weight. No amount of breadth can substitute for it.
:::

### Conceded, hedged, open {kind=limits at=what-the-transition-feels-like}

What does the closing section concede to AI, and what does it deny? How does it hedge the denial, and what does it call the open problem?

::: answer
- *Conceded.* No particular cognitive operation makes the human contribution irreplaceable. AI can find adjacencies, achieve compression, produce register collisions, "even think in something like negative space". Throughput matters, and the breadth capability is new.
- *Denied, following Tao.* AI cannot build cumulatively from partial progress, hold an incomplete idea through its period of apparent failure, or judge which of its successes are Neptune-proof. These rest on a life in which the problems are real, the stakes are felt, and the history of engagement is one's own.
- *Hedged.* The human contribution is irreplaceable "for now, and perhaps for a long time". "The evidential weight is presently ours."
- *Open.* What we build with shared operations and our own evidential weight, and how we verify that what we have built is real.
:::
