# AlphaEvolve: what an evolutionary search can inherit

Reading note, 25 September 2026. Fixed source: Novikov et al.,
[*AlphaEvolve: A coding agent for scientific and algorithmic discovery*,
v1](https://arxiv.org/html/2506.13131v1), June 2025 white paper.
This is a bounded comparison with Łukasz's archive and the previous essay,
not a replication or a claim of historical priority.

## Compact evidence record

| Location | Reported mechanism or evidence |
| --- | --- |
| [§§2.2–2.5, Figure 2](https://arxiv.org/html/2506.13131v1#S2.SS2) | The database retains programs, outputs, and scores. Sampling selects a parent and inspirations; LLM edits produce a child, evaluation supplies feedback, and the database receives results. Optional meta-prompts evolve separately. |
| [§3.1, Figure 4](https://arxiv.org/html/2506.13131v1#S3.SS1) | A tensor-decomposition searcher evolves through 15 mutations: optimizer, initialization, loss, and hyperparameter changes. Evaluation checks rounded decompositions and rewards rank and success frequency. Results include rank 48 for complex 4×4 multiplication. |
| [§4, Figure 8](https://arxiv.org/html/2506.13131v1#S4) | Ablations favor evolution over repeated initial-program proposals; tensor experiments also favor stronger models, context, meta-prompts, and full-file editing. Three runs; horizontal axes show fractions of compute budget. |
| [§3.3.4](https://arxiv.org/html/2506.13131v1#S3.SS3.SSS4) | Compiler-code candidates receive randomized tests; experts subsequently check the final result for all inputs. |

The ablations do not isolate formal crossover, database diversity, or interpreter
replacement. Resource accounting is insufficient here to equate normalized
budgets with matched tokens, FLOPs, or money. The correctness evidence is
application-specific, not a universal synthesis guarantee.

## Working through the distinction between search and evidence

Figure 4 is useful for our comparison because it invites two separate questions:
*what changes the search?* and *what warrants accepting its output?* The trace
above is a reconstruction of the published example's stages, not an independent
execution or a complete mutation-by-mutation genealogy.

Here is an original small mathematical example to make the distinction precise.
It is not one of AlphaEvolve's experiments. Suppose we want to compute

\[
  d(x,y)=x_1y_1+x_2y_2
\]

using products of linear forms. An attractive proposed shortcut is
\((x_1+x_2)(y_1+y_2)\). It uses one multiplication, but expanding it exposes the
unwanted terms \(x_1y_2+x_2y_1\). It can pass selected numerical examples:
take \(x=(1,0),y=(1,0)\). It fails on \(x=(1,0),y=(0,1)\).

Write any proposed construction as

\[
  \widehat d(x,y)=\sum_{r=1}^{R}(u_r^T x)(v_r^T y).
\]

Its universal correctness is equivalent to the finite coefficient identity
\(\sum_r u_rv_r^T=I_2\). Over the reals or complexes, one outer product has
rank at most one, whereas \(I_2\) has rank two. Thus the shortcut cannot work
in this representation. Two products suffice, with the standard basis vectors.

This separates four possible achievements: proposing a plausible expression,
finding coefficients, checking an identity, and proving a lower bound. An
effective search procedure need not be proved to find an answer; a particular
answer can nevertheless have a complete correctness certificate. Conversely,
passing tests does not prove an identity. Rounding approximate coefficients
also needs a subsequent identity check: rounding alone proves nothing.

For the anniversary essay, this distinction prevents an easy ambiguity in
“correct program.” A program can be well typed, can execute successfully, can
pass a finite test set, or can come with a proof of its specified behavior.
Those are different accomplishments. A certificate for a discovered artifact
does not certify all behavior of the procedure that searched for it.

## What the old programme contributes to the comparison

The opening outline of [MGP1](../sources/MGP1.TXT) already distinguishes
genealogical identity from functional similarity. In its planned §2,
mutation preserves a module's identity while duplication creates another
identity. The discussion of crossover in §§4–5 asks which common structures
should survive recombination and why positional matching can be misleading.
These are claims about the *relation between variants*, not just about the
quality of isolated programs.

That supplies a sharper comparison than calling both projects evolutionary.
A proposed edit may preserve a useful relationship by accident, learned
judgment, an explicit constraint, or a proved property of the operator.
These possibilities require different evidence. To identify MCS-style
recombination, we would need a schema language, a correspondence between
parental positions, an admissible family of substitutions, and a preservation
statement. Seeing several examples before proposing an edit establishes none
of those by itself. Equally, absence of such a formalism would not imply that
the proposal mechanism cannot make effective coordinated changes.

MGP1's planned §9 considers continuous optimization within a program whose
structure has been parameterized. The useful comparative question is where
the boundary between structural and numerical search belongs. One can change
constants within a fixed expression, change the expression, or change the
procedure that searches for constants. Each moves a different part of the
problem into the evolutionary representation. This is a productive continuity
of questions, without suggesting that the outline implemented the contemporary
system or anticipated its learned proposal machinery.

The thesis states the broader division especially clearly: express the
tractable logical part of a specification through types, and put remaining
knowledge in the fitness function. See the prose around lines 500–504 of the
[decoded TeXmacs source](../extractions/dyplom4.source.utf8.txt).
This passage does not require interpreting damaged mathematical notation.
For our comparison, it raises a design question: should a requirement constrain
construction, reject completed candidates, or merely influence their ranking?
The anniversary essay can follow that question across the papers without
treating their guarantees as interchangeable.

## Developing the evolutionary comparison first

The anniversary section should establish the genetic-programming connection
before extending it toward the previous essay. Its central question is how
variation and selection work together when the individuals are programs.
The following are comparative questions for drafting, not additional claims
of experimental findings.

**What is the unit of variation?** Identify the candidate, its editable parts,
and the context needed to interpret those parts. MGP1 distinguishes module
identity from functional similarity, while its crossover proposal makes
correspondence between parts explicit. This gives us a question to bring to
a learned editor: what dependencies must it preserve or repair when it changes
a part? An operator's ability to propose coordinated changes and a formal
guarantee of preservation are different properties. Neither should silently
stand in for the other.

**What counts as recombination?** A child can descend directly from one
program while drawing ideas from others. That creates a useful distinction
between genealogical descent, influence, and recombination defined by an
explicit correspondence between parental parts. GENERA gives the third a
precise target through schemata and substitutions. Our comparison should ask
whether useful structure can transfer between candidates without assuming
that every such transfer is an instance of that operator. Nor should the
discussion of learned editing erase the continuing question of which changes
can usefully be made independently.

**What does selection preserve?** Evaluating a candidate and deciding which
material to make available for future variation are distinct decisions. A
candidate that is worse under the present evaluation might contain a useful
component; keeping it does not ensure that a proposal mechanism will find
or exploit that component. This is already a genetic-programming problem,
before it becomes a question about records in a continuing inquiry. The
paper's database draws on MAP-Elites and island models
([§2.5](https://arxiv.org/html/2506.13131v1#S2.SS5)); this does not identify
MGP1's speculative biological account with those methods.

**How do constraints and fitness divide the work?** Carry forward the C
discussion: a type need not encode the whole intended behavior. A shortest
well-typed candidate need not be the best candidate for the task. Ask which
requirements should restrict variation, which should reject a candidate, and
which should contribute to its ranking. This connects the thesis's design
choices to the evolutionary loop without imposing a common guarantee on
different systems.

**What happens when the evolving program is itself a search procedure?** Use
the tensor example from the evidence record to separate outer variation of
the searcher from its inner search for a mathematical object. MGP1's planned
§9 gives a historical reason to examine the boundary between structural and
numerical search. Keep the certificate discussion here, serving the example:
evidence about the discovered object and evidence about the search procedure
answer different questions.

Within the section's 1,400-word budget, allocate roughly 1,150 words to this
evolutionary account and its concrete example, then 250 to the bridge below.
The earlier essay should extend the argument once the comparison has earned
it, rather than supplying the section's initial organizing frame.

## Connection to “What Persists When the Agents Change?”

The [previous essay](../../../notes/what-persists-when-agents-change.md)
distinguishes possessing a record, finding it, interpreting it, checking it,
and using it. We can use that distinction as an analytical framework here.
A stored achievement only changes future possibilities through a route that
makes it available at an appropriate moment. Storage capacity alone is a poor
measure of cumulative intelligence.

The resulting question is more concrete than “does the system have memory?”
What would be lost if we retained an answer but removed the evidence for it?
What if we retained evidence but removed the procedure that produced it?
What if both remained available but the selection policy never surfaced them?
These are distinct counterfactuals. The source's ablations should not be made
to answer all of them at once.

An evolutionary archive also raises the essay's concern about minority
programmes. A currently unsuccessful proposal may contain an insight whose
value appears only after another change. Preserving diversity could help,
but diversity of observed scores is not automatically diversity of ideas.
Likewise, retaining a program and its measured outcome need not preserve
why a researcher considered it promising, which objection remains unresolved,
or what evidence would justify changing the objective itself.

These considerations support a narrow bridge: **productive continuation
depends on what is retained and on how the next search uses it.** They do not
settle whether a continuing participant outperforms a replacement, whether
separate weight updates improve an inquiry, or whether artificial participants
have personhood. The previous essay explicitly proposes additional comparisons
for those questions; this survey should preserve that separation.

## What is ready for the anniversary essay

The evolutionary thread has a concrete contemporary comparison, and the
earlier essay provides useful language for explaining why inheritance is more
than keeping the best final answer. The technical lesson is to track three
separate relations: a descendant to its predecessors, a result to its evidence,
and a future attempt to the records it can actually use.

Before making stronger claims, we would need finer evidence about resource
matching and the causal contribution of particular retention mechanisms.
No new experiment is proposed here. The reading pass is sufficient to write
this bounded comparison; it is insufficient for declaring formal equivalence,
a generally optimal organization of search, or a resolution of the philosophical
questions in the previous essay.
