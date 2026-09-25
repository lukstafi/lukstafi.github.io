# Learning structure for program synthesis: focused survey

Scope agreed with Łukasz on 25 September 2026. This is the active research
phase; building our own experimental system is deferred. Following the initial
seven-paper overview, Łukasz narrowed the core to **babble, TyFlow, and
AlphaEvolve**. DreamCoder, Stitch, LILO, and Bayesian Program Learning by
Decompiling Amortized Knowledge remain supporting context, without equal
coverage commitments. *Synthesizing DSLs for Few-Shot
Learning* and *Numerical Superoptimization for Library Learning* are outside
this survey, by choice rather than an assessment of their quality.

This first pass summarizes mechanisms and reported evidence from primary
sources. It is not a full proof audit, replication, or historical-priority
assessment. Connections to the 2001–2005 documents are our provisional
interpretations. Detailed formal comparisons remain to be written.

## Three focal papers

| Paper and fixed reading version | Reason for focus | Close-reading target |
| --- | --- | --- |
| [babble, v1](https://arxiv.org/html/2212.04596v1) — December 2022 preprint, POPL 2023 | Technical connection to common schemata and equational generalization | §§3–5 and Appendix A: pattern language, anti-unification, pruning assumptions, and extraction objective; compare with MGP1 and GENERA. |
| [TyFlow, v2](https://arxiv.org/html/2510.10216v2) — February 2026 revision | Technical connection to the thesis and recent work | §§2–4: synthesis decisions, typing judgments, and correctness statements; compare with algorithm C. Use §6 to delimit the experimental claims. |
| [AlphaEvolve, v1](https://arxiv.org/html/2506.13131v1) — June 2025 | Recent evolutionary synthesis and connection to the previous essay | §2 and §4: candidate inheritance, evaluation, population diversity, and ablations; examine how retained results affect subsequent search. |

Use these exact versions for section references and comparisons. arXiv HTML
is the default reading format: prose, searchable headings, references, and much
of the mathematics are accessible. Inspect figures separately and check the
corresponding PDF or TeX source when a formula, inference rule, or code listing
has conversion artifacts. In particular, babble's HTML text extraction exposes
verbose formatting macros in some displayed code expressions. A successful
page fetch is not evidence that every formula or figure has been read correctly.

## Connection to the previous essay

[What Persists When the Agents Change?](../../../notes/what-persists-when-agents-change.md)
asks how an inquiry accumulates useful knowledge across changing participants.
The survey asks how structures found during program search change the
possibilities available to subsequent searches. AlphaEvolve is the main bridge:
examine the respective roles of retained candidates, feedback, and the machinery
that turns them into further proposals. This is an architectural comparison;
the paper is not itself a controlled study of replacing inquiry participants.

The essay's discussion of executable artifacts provides a second connection.
Keep a distinction between preserving program behavior through refactoring and
preserving the reasons, failures, and unresolved alternatives in an inquiry.
Compression adequate for one purpose need not preserve what the other needs.
This framing should help interpret the technical comparisons, without requiring
all three papers to answer the essay's broader philosophical questions.

## Organizing question

How does a synthesis system acquire and preserve useful program structure,
and how does that structure affect its next search?

The historical programme supplies three questions to bring to the papers:

1. What makes a shared schema a useful unit of variation or reuse?
2. Which dependencies must be preserved for generated programs to remain valid?
3. How does experience change the representation or the procedure used to search?

These questions allow comparison without assuming that the selected systems solve
the same problem or compete on a common benchmark.

## Initial reference notes (focal papers and supporting context)

### DreamCoder — Ellis et al., PLDI 2021

**Mechanism.** Task solving, library extraction, and neural search learning form
a repeating cycle. Abstraction sleep refactors solutions to discover reusable
functions. Dream sleep trains the search model using solved tasks and sampled
programs. Library functions shorten descriptions; the learned search policy
changes which candidates are explored. See §2 and Figures 2–3 of the
[paper](https://people.csail.mit.edu/asolar/papers/EllisWNSMHCST21.pdf).

**Evidence and limits.** The paper demonstrates the combined architecture across
multiple synthesis domains. Its learned abstractions and search policy are
separate contributions to assess; compression alone does not establish useful
transfer to new tasks.

**Historical connection.** This is the reference architecture for comparing
the early library proposal with an implemented learning loop. The 2001 outline
does not specify an equivalent system. The close-reading question is which
relationships between fragments are represented explicitly, and which are
captured only by probabilities learned from experience.

### Stitch — Bowers et al., POPL 2023

**Mechanism.** Corpus-guided top-down search constructs abstractions, using
matches of partial candidates and bounds on their utility to prune the search.
Lambda-aware matching accounts for binding. Read §§3–4 for the algorithm and
§§5–6 for its relationship to deductive refactoring and its evaluation in
[Top-Down Synthesis for Library Learning](https://arxiv.org/html/2211.16605v2).

**Evidence and limits.** The reported 3–4 orders of magnitude speedup and roughly
100-fold memory reduction compare library extraction with DreamCoder's
deductive component. Library quality is measured by compression. These figures
are not end-to-end synthesis speedups. The paper also considers combining its
search with deductive approaches.

**Historical connection.** Compare the abstraction language and treatment of
bound variables with the CSA drafts. A useful distinction to investigate is
between optimizing a shared fragment for corpus compression and choosing a
common schema that supports the intended mutations and recombinations.

### babble — Cao et al., POPL 2023

**Mechanism.** Library learning modulo an equational theory uses equality
saturation to represent alternative equivalent expressions, then e-graph
anti-unification to generate common patterns. Library selection includes the
cost of the library itself and uses approximate extraction. The overview and
worked example in §§1–2 of
[the paper](https://arxiv.org/html/2212.04596v1) expose the main ideas.

**Evidence and limits.** The authors evaluate compression on corpora from
DreamCoder and 2D CAD, reporting better compression and substantial speedups.
The equations are supplied domain knowledge. These experiments assess library
learning, not mutation-compatible crossover or an entire evolving synthesizer.

**Historical connection.** This is the most direct comparison for MGP1's
proposal of common schemata modulo equational theory. We should compare what
counts as an admissible generalization, how equivalent representations affect
matching, and what the selection objective rewards. Shared terminology alone
does not establish identical algorithms or objectives.

### Bayesian Program Learning by Decompiling Amortized Knowledge — Palmarini, Lucas, and Siddharth, ICML 2024

**Mechanism.** The neural search policy helps choose library components, making
knowledge that guides search also influence how the search space is structured.
The key issue is the interaction between search breadth and depth: adding a
component can shorten programs while increasing the number of choices. Read
§§3–4 of [the paper](https://arxiv.org/html/2306.07856v3); the
[proceedings entry](https://proceedings.mlr.press/v235/palmarini24a.html)
records the published version.

**Evidence and limits.** Integrated with DreamCoder, the method reports faster
learning and better generalization, especially with fewer example solutions.
Its evidence concerns the evaluated domains and search model, not a universal
criterion for useful abstractions.

**Historical connection.** It sharpens the question of how the process using an
abstraction should influence its selection. Compare that feedback with the
historical requirement that generalization recover variation introduced by
mutation; the two couple representation to search in different ways.

### LILO — Grand et al., ICLR 2024

**Mechanism.** LILO combines LLM proposals and enumerative synthesis with Stitch
compression and AutoDoc, which names and documents learned functions. The
documentation helps the generator use an evolving library. See §3 of
[the paper](https://arxiv.org/html/2310.19791) and its
[publication record](https://proceedings.iclr.cc/paper_files/paper/2024/hash/819cebb05f993840e8a52d7564c5c282-Abstract-Conference.html).

**Evidence and limits.** Evaluation covers string editing, scene reasoning, and
graphics. §4 separates online synthesis from a controlled comparison using
frozen libraries and enumerative search. Crucially, the evaluated DreamCoder
baseline also uses Stitch. LILO's gains therefore cannot simply be credited to
replacing the original compressor. Pretraining provides additional knowledge
that matters when interpreting comparisons.

**Historical connection.** The relevant question is how discovered abstractions
become usable by the mechanism that proposes programs. Names and descriptions
introduce another representation of reusable structure, alongside syntax and
types. Examine the AutoDoc and enumeration ablations before attributing gains
to any single component.

### TyFlow — Huang et al., 2025 preprint, revised February 2026

**Mechanism.** TyFlow links synthesis derivations to typing derivations and
represents programs as synthesis decisions. A neural model predicts decisions
in the current proof context. The revised manuscript is titled
[*TyFlow: A Type-Aware Approach to Neural Code Models*](https://arxiv.org/html/2510.10216v2);
the [abstract record](https://arxiv.org/abs/2510.10216) retains the earlier title.
Read §§2–4 for construction and correctness, and §6 for evaluation.

**Evidence and limits.** Experiments cover SuFu and a subset of Java. Type
correctness is relative to the implemented type systems. Functional correctness
is assessed separately by tests. The Java implementation omits features,
including lambda expressions; it does not establish coverage of all Java.

**Historical connection.** Compare algorithm C and its choice sequences with
TyFlow's synthesis decisions. Build a correspondence between judgments,
unification, contexts, branching, and the soundness/completeness statements.
The current resemblance is architectural; formal equivalence has not been
established. Generating valid terms also leaves the distinct problem of valid
recombination to be examined.

### AlphaEvolve — Novikov et al., June 2025 white paper

**Mechanism.** LLMs propose program edits using prior candidates and feedback;
evaluators score the results; a population database preserves promising and
diverse candidates. The database combines ideas from MAP-Elites and island
models. Programs can encode solutions, constructors, or search procedures.
See §§2.1–2.5 of [the paper](https://arxiv.org/html/2506.13131v1).

**Evidence and limits.** Results include mathematical constructions, matrix
multiplication algorithms, and computational infrastructure improvements.
Tasks require automated evaluation; the strength of correctness evidence
depends on the evaluator and application. These results do not establish
DreamCoder-style library induction or typed common-schema crossover.

**Historical connection.** AlphaEvolve belongs in the core survey because it
returns directly to variation, selection, and retention. The comparison should
ask what is inherited through prompts and population selection, what structure
an edit preserves, and where validity is enforced. Multiple prior programs in
a prompt do not by themselves provide a formally specified recombination
operator. Read §4's ablations to distinguish the contribution of evolution
from that of the proposal model.

## Comparative synthesis to develop

The working distinction is between three roles for structure: it can be
preserved by a variation operator, extracted as a reusable abstraction, or
enforced as a constraint during construction. Their interaction is the survey's
central subject. None should be inferred solely from the presence of another.

| Comparison | Question to resolve by close reading |
| --- | --- |
| Common schemata and learned libraries | When does sharing explain reuse, and when does it identify useful variation? |
| Syntactic and equational matching | Which equivalent representations are available, and at what computational cost? |
| Generation and recombination | Which guarantees survive when choices from separate programs are combined? |
| Library and search-policy learning | How does changing the available vocabulary change the usefulness of the policy? |
| Typed construction and evaluation | Which requirements are guaranteed during construction, checked afterwards, or only sampled by tests? |
| Corpus compression and task performance | What evidence connects a smaller representation to better subsequent search? |

For each detailed comparison, record the paper section, a small worked example,
the precise historical passage, and the status of the conclusion: demonstrated,
plausible analogy, or unresolved. Keep author-reported results separate from
our interpretations. Read the authoritative TeXmacs source for thesis formulas;
the approximate extraction is unsuitable for checking proofs.

## Reading sequence and deliverables

1. Read babble against the common-schema drafts, working through a small
   anti-unification example and the role of the supplied equations.
2. Compare algorithm C with TyFlow's rules and guarantees, tracing the same
   small term through each construction where the languages permit it.
3. Read AlphaEvolve's algorithm and ablations against the evolutionary aims and
   the previous essay's account of cumulative inquiry.
4. Consult the supporting papers only where they clarify these comparisons.
5. Write the cross-paper synthesis, then choose the anniversary essay's scope.

The deliverable is a source-linked survey with worked comparisons and an
evidence table, not a new implementation. This document supplies the initial
coverage and reading agenda; the detailed comparisons and evidence table are
still pending. Historical references already listed in [the research
notes](notes.md#literature-leads-from-the-discussion) remain context; expand the
core corpus only when a specific comparison requires it.
