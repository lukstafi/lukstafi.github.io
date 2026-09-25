# babble: common structure for compression and for variation

Close reading, 25 September 2026. Fixed paper: David Cao et al.,
[*babble: Learning Better Abstractions with E-Graphs and Anti-Unification*,
arXiv:2212.04596v1](https://arxiv.org/html/2212.04596v1), subsequently POPL 2023.
This note uses the author-supplied TeX distribution alongside the HTML. Source
filenames and line numbers below refer to that version; the files remain in
the local Downloads directory. Historical sources are the archived originals.
The examples marked **derivation** are worked comparisons, not experiments or
claims that the historical algorithms have been implemented.

The strongest connection is explicit: the 2001 outline proposes extracting
common schemata into definitions and using equations to expose otherwise hidden
common structure. babble develops an implemented, evaluated approach to this
problem. The strongest difference is equally informative: compression can
benefit from tying two occurrences to one parameter, whereas the 2002 programme
deliberately separates genetic loci so they can vary independently. Neither
criterion alone defines the right abstraction for the other's purpose.

## 1. What babble optimizes

The input is a corpus of programs, represented formally as a tuple of terms,
plus domain equations. The output is a library and a refactored corpus. Its
objective counts both the rewritten programs and the library definitions,
charging for a shared definition once. Expanding the learned calls must recover
a corpus equivalent to the input under the supplied equations. This is an
optimization problem over descriptions of existing programs; improved future
synthesis is a motivation, not the measured objective of this paper.
See [§§3.1–3.2](https://arxiv.org/html/2212.04596v1#S3.SS1) and
[§4.1](https://arxiv.org/html/2212.04596v1#S4.SS1), `au.tex:111–195` and
`egraphs.tex:132–181`.

Three operations need to be distinguished:

1. **Expose equivalent representations.** Equality saturation adds rewrites to
   an e-graph while retaining the original alternatives. Each e-class groups
   equivalent expressions; child references allow these alternatives to share
   structure.
2. **Propose abstractions.** Anti-unification finds common patterns between
   pairs of represented subterms. A pattern's variables become function
   parameters.
3. **Select a library.** Compression rewrites introduce calls to those functions.
   Selection trades definition costs against savings across the corpus,
   including opportunities for one library function to use another.

This separation matters: finding a common pattern does not show that installing
it as a library function pays off. Nor does a locally attractive function
necessarily belong in the best combination of functions. The algorithm is in
`llmt_algorithm.tex:1–30`, label `fig:algo-llmt`;
[§5](https://arxiv.org/html/2212.04596v1#S5) explains selection.

## 2. A small derivation: what the equations change

Use the paper's arithmetic illustration, made explicit here. Treat addition
as a binary constructor and the numerals as distinct constants:

```text
t₁ = 2 + 1                 t₂ = 1 + 3
```

Syntactic anti-unification retains the shared `+` but sees disagreements in
both argument positions. It therefore yields `X + Y`, with substitutions

```text
σ₁ = {X ↦ 2, Y ↦ 1}        σ₂ = {X ↦ 1, Y ↦ 3}.
```

Now supply commutativity, `U + V ≡ V + U`. One e-class represents `2+1` and
`1+2`; another represents `1+3` and `3+1`. Comparing `2+1` with `3+1` produces
`X+1`, with substitutions `{X ↦ 2}` and `{X ↦ 3}`. The corresponding function
`inc = λX. X+1` reconstructs the selected representatives; the second is
equivalent to the original `1+3` by the supplied equation.

This does **not** equate `2+1` with `1+3`. Their different results remain
different. Equations change which representations of each expression are
available for discovering shared structure. Nor is the two-expression example
a claim of positive compression after paying for a definition: it illustrates
candidate discovery. A sufficiently substantial surrounding common context or
more uses can make the abstraction economical. These are the mechanisms of
[§1](https://arxiv.org/html/2212.04596v1#S1) and
[§4.2](https://arxiv.org/html/2212.04596v1#S4.SS2), particularly
`egraphs.tex:330–339`; the substitutions above are our derivation.

The e-graph algorithm makes this comparison without enumerating every complete
equivalent program. It compares e-nodes: matching constructors recurse over
child e-classes; different constructors yield a hole. Holes are named by the
pair of e-class identifiers they abstract, so encountering the same pair again
reuses the same hole. Alternative e-nodes can yield multiple candidate
patterns. This is a set of candidates over the available representations, not
a promise of one canonical least general generalization modulo every possible
theory. See `egraphs.tex:206–277`, label `fig:ecau`.

The algorithm also discards dominated candidates: for fixed matched e-classes,
a no-larger pattern requiring a subset of the same named holes has no larger
definition or argument cost for those matches. The authors use this reasoning
to justify pruning cyclic traversals as well. Returning to an already visited
pair produces the empty candidate set on that branch, not a newly invented
hole. Their co-occurrence filter avoids comparing alternatives that cannot
appear together in one represented corpus (`egraphs.tex:292–354,378–420`).
These arguments belong to the candidate framework; they do not remove the
approximations discussed below.

## 3. The historical connection is specific

The heading of the 2001 outline's item 11 is “MCS modulo equational theory.”
Its next paragraph proposes finding a common schema of two or more subterms,
binding it in their scope, and replacing each subterm with an application that
reconstructs it. It then proposes equations to transform subterms so that more
common structure becomes visible. This is direct documentary evidence for
both abstraction extraction and equational generalization in the programme:
[MGP1.TXT](../sources/MGP1.TXT), lines 141–154.

That passage is in the **outline**, not a completed implementation or an
algorithm with established guarantees. Its reference to an associative and
commutative algorithm describes intended coverage. The later outline item on
a library of convergent functionality also identifies a proposed use for
discoveries extracted from multiple programs (lines 186–197). These passages
support a connection of research questions, not priority over the extensive
earlier literature on anti-unification, refactoring, or inductive learning.

babble makes several decisions that this outline does not settle: representing
equivalence by e-graphs, generating candidates by e-class anti-unification,
charging for library definitions, jointly choosing abstractions, and using
bounded search when exact selection becomes expensive. It also concentrates
its formal result on **global**, closed library definitions. The outline's
definitions can be local to a containing scope.

The main historical application was more demanding in a different direction.
MGP1 describes recombination by mixing the two substitutions that reconstruct
the parents from their common schema (lines 817–824). The 2002 draft sharpens
the goal: identify the unchanged material after mutation, placing differences
into slots that can act as genetic loci. Its mutation-compatibility condition
explicitly assumes that mutations do not introduce constants already present
in the original term. See [GENERA.TXT](../sources/GENERA.TXT), lines 34–49 and
181–189. This is a condition on preservation under a chosen variation operator,
not on the total description length of a corpus.

## 4. Repeated holes reveal different objectives

**Derivation.** For distinct constants `a` and `b`, ordinary first-order
anti-unification gives

```text
f(a,a), f(b,b)  →  f(X,X)
σ₁ = {X ↦ a}      σ₂ = {X ↦ b}.
```

Reusing `X` records that the same disagreement `(a,b)` occurred twice. It is
more specific than `f(X,Y)`: the latter also admits `f(a,b)`. babble's
pair-indexed holes preserve precisely this repeated-variable information.
In a learned abstraction `λX.f(X,X)`, callers supply the argument once.
This can save representation cost, especially when repeated arguments are
large. Again, this tiny example illustrates a pattern distinction rather than
asserting that this particular function would be selected.

GENERA requires schema metavariables to be **linear**, appearing once, so that
different loci are not completely linked (lines 164–167). Applied to this
example, that requirement gives `f(X,Y)`, with parent substitutions

```text
σ₁ = {X ↦ a, Y ↦ a}        σ₂ = {X ↦ b, Y ↦ b}.
```

If `a` and `b` have the same appropriate type and there are no additional
constraints, independently selecting parental assignments allows `f(a,b)` and
`f(b,a)`. A single shared hole permits only the two original combinations.
This is a consequence of the chosen representation, not an empirical result
about which offspring are useful. Type or semantic dependencies may still
require some choices to stay linked.

The contrast gives the essay a substantive point: **a dependency worth
retaining for compression can be a dependency worth relaxing for variation.**
It would be inaccurate to say that babble simply implements the 2002 MCS
criterion. The draft already distinguishes genetic schemata from richer
schemata for other uses (`MGP1.TXT:829–858`).

## 5. Insertion, higher-order holes, and binding

**Derivation from GENERA's insertion example** (`GENERA.TXT:48–49`). Consider

```text
t₁ = a(b(c))               t₂ = a(g(b(c))).
```

With fixed unary function symbols and no helpful equations, first-order
anti-unification at the roots gives `a(X)`: `b` and `g` disagree immediately
inside `a`. The common internal material `b(c)` is swallowed by the hole.
The historical projection idea permits the more informative schema

```text
a(M(b(c)))
M₁ = λz.z                  M₂ = λz.g(z).
```

Substitution followed by meta-level beta-reduction reconstructs the parents.
For example, assign `c:τ` and `a,b,g:τ→τ`; both fillings of `M:τ→τ` are then
well typed. This exposes the unchanged internal structure while representing
the insertion as the varying context. It neither asserts that `g` is the
identity nor requires the parents to have equivalent behavior.

This **functional hole with projection** goes beyond the first-order pattern
language of babble's main formalization. GENERA also discusses preserving
object-language binding structure and relating type and value substitutions
(lines 136–175), with insertion/deletion in its CSA2 agenda (lines 674–693).
Those concerns should not be assimilated to e-class equality: sharing a
semantic equivalence class is different from preserving the identity and scope
of a bound variable, or identifying homologous positions after an insertion.

The limitation here is on what the **paper's theorem establishes**. babble
explicitly says its implementation is not restricted to the first-order
setting (`au.tex:11–15`). We have not audited its higher-order implementation,
so the example does not establish that the tool cannot express or discover
such a function. It establishes that the published first-order theorem is
insufficient to justify an equivalence with GENERA's richer schema language.

## 6. What is proved, approximated, and evaluated

**Theorem scope.** [Theorem 3.1](https://arxiv.org/html/2212.04596v1#S3.Thmtheorem1),
“Soundness and Completeness of Pattern-Based Library Learning,” concerns the
first-order formulation and global library learning. A compression rewrite for
a pattern `p` replaces a match by `(λX₁…Xₙ.p) X₁…Xₙ`, where the parameters
are the free variables of `p`. Soundness follows by reversing that step through
beta-reduction. Completeness says an optimal compressed term in the specified
class can be obtained using patterns that match subterms of the original
corpus. It does **not** say that pairwise least general generalizations contain
every candidate needed for optimal compression.

The proof is [Theorem A.3](https://arxiv.org/html/2212.04596v1#A1.Thmtheorem3),
`appendix.tex:35–94`; the statement is `au.tex:273–283`, label
`thm:pat-lib-learning`. The proof reverses applicative evaluation, excludes
unused parameters from minimal solutions, invokes closedness of global
definitions, and uses Lemma A.2 to trace matches back through compression.
This note checks the intended scope and proof structure, not a full formal
verification of every lemma.

**Explicit incompleteness.** [§3.3](https://arxiv.org/html/2212.04596v1#S3.SS3)
first describes the larger parameterization lattice above pairwise joins,
then restricts practical generation to pairwise joins themselves. Its supplied
counterexample is

```text
f(a+a), f(a+c), f(c+c).
```

Their pairwise least general generalizations are `f(a+X)`, `f(X+X)`, and
`f(X+c)`. The common pattern `f(X+Y)` covering all three is absent. The paper
also explains why a more general, smaller definition can sometimes beat a
more specific one when uses are few. These are acknowledged limitations, not
contradictions of Theorem 3.1 (`au.tex:632–704`, label `fig:lattice`).

**Further search limits.** §5's cost sets track both library membership and
use cost because the cost of sharing is nonlocal. Its beam approximation caps
the number of functions in a candidate library and retains only the best `K`
library alternatives at an e-class (`beam.tex:274–293`). Thus an end-to-end
global optimum is not guaranteed even over generated candidates. Equational
discovery is also relative to supplied, semantically valid equations and the
equivalent expressions represented in the constructed e-graph; arbitrary
program equivalence is not being decided.

**Evidence.** [§6.1](https://arxiv.org/html/2212.04596v1#S6.SS1) reports better
compression than DreamCoder's library-learning benchmark results at 1–2 orders
of magnitude less time, across five domains. These are component comparisons,
with different recorded hardware/core configurations, not end-to-end synthesis
speedups. List and Physics ablations compare syntactic library learning,
equational optimization alone, and their combination; equations further
improve compression. In [§6.2](https://arxiv.org/html/2212.04596v1#S6.SS2),
removing redundant transformations from the nuts-and-bolts corpus leaves
compression unchanged with equations but worsens it without them—a useful
direct demonstration of robustness to representation. Sources:
`eval.tex:14–41,184–230,293–309`. These experiments do not establish better
evolutionary recombination or transfer to unseen synthesis tasks.

## 7. Consequences for the survey and essay

| Claim | Status after this reading |
| --- | --- |
| The 2001 outline connects schema extraction, definitions, and equations. | Explicit historical proposal, not a completed algorithm. |
| babble supplies a technical connection to that proposal. | Demonstrated at the problem/mechanism level. |
| babble implements the historical genetic schema criterion. | Unsupported; linearity and mutation compatibility expose different objectives. |
| The practical pipeline is complete or always finds the optimal library. | Incorrect; separate the theorem from pairwise generation and beam approximations. |
| Equational abstraction is invariant to arbitrary syntactic changes. | Too broad; limited by equations and represented alternatives. |
| Smaller libraries make future search better. | Motivation requiring additional evidence beyond this paper's compression evaluation. |

The initial survey characterization remains useful but should explicitly add
the repeated-hole distinction and the two approximation stages. An essay can
now make a narrower, defensible claim: the old outline asked how shared
structure could become an explicit reusable operation even when its surface
forms differ; babble shows a concrete modern answer and reveals why the answer
depends on the intended use of that structure.

Two questions remain open for a later technical comparison: what babble's
implementation guarantees for binders and higher-order arguments, and what
criterion could balance independent variation against compressive sharing.
Neither needs to be settled to write the historical comparison honestly.

### Source cautions

The active inputs were checked in `main.tex:135–142,161`; notation in `defs.tex`
identifies `\gau` with `AU` and `\intro` with body size. Commented-out alternative
algorithms and `beam_old.tex` are not evidence of published claims.

There are apparent transcription errors in v1's worked compression example:
`au.tex:299–301` supplies `g(a),g(a),(g(1)+h(2))` to the displayed three-parameter
pattern where reconstruction requires `g(a),1,2`; the figure at line 212 also
uses second-call arguments `2,3` where its source corpus has `3,4`. The examples
in this note were derived independently to avoid propagating those errors.
They do not by themselves undermine the theorem.
