# Research notes — 25 September 2026

These are provisional assistant reading notes from the discussion with Łukasz,
not historical source text, a proof audit, or a literature-priority assessment.
Łukasz describes the thesis as the theoretical and surveying culmination of
the programme: the ideas reached a stage suitable for experimentation, but
time ran out before experiments were done. The current intention is to do more
research before settling on an essay. On 25 September 2026, Łukasz chose a
[focused survey](survey.md) as the next phase, subsequently narrowing its core
to babble, TyFlow, and AlphaEvolve. The other four papers supply background.
Building our own experiments is deferred; the sketch below is retained only
as a record of the earlier proposal.

## Development of the programme

**2001 — MGP1.** Mutation and recombination determine which program structures
persist long enough for selection to act on them. Genealogical module IDs
provide correspondence across programs; duplication creates a new identity.
Recombination preserves selected common schemata and mixes the corresponding
substitutions. The draft recognises that maximal syntactic commonality need
not identify useful evolutionary units. Much of its broad programme exists
only in the contents outline.

**2002 — GENERA.** Generalization should recover variation introduced by
mutation. The CSA progression associates richer generalizers with richer
mutation families. Projections permit inserted contexts, while metavariable
coalescing condenses differences. Linearity permits independent choices at
different loci, deliberately giving up some equality information. Binder
correspondence and genealogical identities for local definitions supply
different forms of alignment. The pseudocode is unfinished; polynomial-time
claims involving caches indexed only by term paths need examination of the
role of the binder environment and accumulated costs.

**2005 — thesis and presentation.** The programme combines deductive and
inductive synthesis: put tractable logical requirements in types and
constraints, and express remaining expectations through fitness. It develops
term generation alongside type inference, including soundness and completeness
arguments for a Mini-ML setting. It examines termination-oriented typing,
code reuse, and richer constraint-based systems. Recombination must coordinate
choices whose types depend on one another. The richer generalization treatment
uses common relational substructures and engages critically with Hasker's
practical matching algorithm. Some results have detailed proofs, some have
sketches, and extensions to the full intended system remain open.

The presentation makes incremental constraint solving, polymorphic recursion,
and GADT inference particularly prominent. An interpretation to discuss:
building the GP system was generating independent programming-language
research questions.

## Concrete points to revisit

1. **Mutation compatibility.** The thesis specifies offspring mutation sets
   `N` satisfying `K ∩ L ⊆ N ⊆ K ∪ L`, under restrictions on compatible sample
   mutations. Recover the exact assumptions before using this as an invariant.
2. **Independence and dependency.** `f(a,a)` and `f(b,b)` illustrate the tradeoff
   between an equality-preserving schema `f(X,X)` and independently variable
   positions `f(X,Y)`. Separately, `map String.length ["hello"]` and
   `map abs [-3]` illustrate type dependencies between different holes.
3. **Typed recombination.** Reconstruct the proposed type-generalization
   variables and dependency relation; compare permitted choices against direct
   type inference on every offspring for small examples. Its thesis proof is
   explicitly a sketch.
4. **Structural matching.** Recheck the criticism of Hasker, including the
   embedding definition and the example `x(a,b,c)` versus `f(a,g(b,c))`.
   Distinguish maximal correspondences from maximum-size correspondences,
   and a generalization plus its substitutions from the schema alone.
5. **Genealogy.** By the thesis's later matching algorithms, suspected ancestry
   can guide the selection of matching nodes. Compare this role with the
   stronger module-ID mechanism in the initial draft.

## Deferred experiment sketch (not an active task)

Start with a small, explicitly specified language and the simplest common-
schema crossover. Reconstruct the mutation-compatibility property and test it
exhaustively on small terms before implementing the richest higher-order
algorithm. If this foundation is sound, compare common-schema crossover,
ordinary subtree crossover, and mutation-only search with matched evaluation
budgets, recording both search outcomes and operator cost. Choose benchmarks,
typing restrictions, and seeds before interpreting results.

The prerequisites for the complete envisioned system are broader than those
for a useful first experiment. Keep claims of correctness, search efficiency,
and historical novelty separate.

## Source navigation

Line numbers refer to the unchanged original `sources/dyplom4.tm` and also
match the decoded source copy; they do not match the lossy reading text.

| Topic | Starting source line |
| --- | ---: |
| Introduction | 338 |
| Division between logical specification and fitness | 501 |
| Mutation-compatible recombination | 794 |
| Algorithms W and C | 1549 |
| Recombination and generalization | 3493 |
| Type compatibility of recombination | 3726 |
| Generalization reconstruction | 4452 |
| Common relational substructures; Hasker criticism | 4703 |
| Matching algorithms and ancestry preference | 5083 |
| Contributions and open tasks | 5253 |

## Literature leads from the discussion

- [Hasker, *The Replay of Program Derivations* (1995)](https://faculty-web.msoe.edu/hasker/research/thesis.pdf): original available; the embedding definition was checked, but the entire correction has not been independently verified.
- [Stanley and Miikkulainen, NEAT (2002)](https://nn.cs.utexas.edu/downloads/papers/stanley.ec02.pdf): historical markings are a relevant comparison for genealogical correspondence; no priority claim follows from publication dates alone.
- [Poli and Langdon, *Genetic Programming with One-Point Crossover* (1997)](https://gpbib.cs.ucl.ac.uk/gp-html/poli_1997_1pxoWSC2c.html): earlier correspondence-aware crossover to include in any historical comparison.
- [DreamCoder (2021)](https://people.csail.mit.edu/asolar/papers/EllisWNSMHCST21.pdf): a later comparison for learning reusable program abstractions; the 2001 library proposal is an outline, not an equivalent implemented system.
- The thesis bibliography identifies Lu, Harao, and Hagiya's *Generalization in λ2* as a July 1998 workshop paper. Locate that exact version rather than substituting a related publication.

## Possible eventual essay

The anniversary refers to October 2001. An eventual essay could follow the
transition from evolutionary units, through mutation-compatible generalization,
to typed program synthesis. Its angle and conclusions should depend on what
the source reconstruction and focused literature survey establish. New
experiments are not a prerequisite for the essay. No blog draft has been started.
