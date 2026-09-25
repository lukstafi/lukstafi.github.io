# What Should a Program Inherit?

Working subtitle: **Revisiting typed genetic programming, twenty-five years later**

Outline, 25 September 2026. Agreed essay length: **6,000–7,000 words**, exceeding
7,000 only if a substantive need arises. The section allocations below total
approximately 6,500 words and are guides, not quotas.

The anniversary is September 2026: Łukasz recalls beginning the original
document in September 2001, the last month of university summer break. Its
October 2001 date records the last modification, not its origin. The master's
thesis is from 2005. This is an editorial outline, not the essay draft.

The [essay](../../../notes/what-should-a-program-inherit.md) was written
and revised on 25 September 2026. This outline preserves the drafting plan;
the reviewed essay supersedes its word allocations. Subsequent revisions
added an e-graph inset, sharpened the TyFlow lookup comparison, and shortened
AlphaEvolve's discussion while making information provenance explicit.

## The argument

The programme began with a question about how useful structures could survive
genetic recombination. It developed into questions about generalization,
abstraction, and constructing programs under typing constraints. Revisiting it
through babble, TyFlow, and AlphaEvolve reveals that useful structure depends
on its intended role: compressing existing programs, permitting productive
variation, enforcing requirements, or supporting subsequent search.

The essay should earn this conclusion through examples. Its interest comes
from the changing questions and the differences between the answers. The
historical documents supply the personal thread; the modern papers supply
concrete systems against which to examine it.

Keep the direction of that development open to criticism. Moving from
evolutionary operators toward type theory may have addressed real dependencies
while also shifting attention toward questions with clearer formal success
criteria. The retrospective should ask whether that shift served the original
experimental ambition, rather than treating increasing formal sophistication
as an automatically warranted progression.

The intended reader is interested in programming and AI but need not know
anti-unification or type-directed synthesis. Explain each term when its example
makes it necessary. Use first-person singular for Łukasz's documented work and
recollections, and “we” for the present comparison. Do not invent memories of
motivation or the circumstances of abandoning the work.

## 1. An unfinished programme, twenty-five years later

**Approximately 450 words.** Open with the manuscript's September 2001 origin,
during the last month of university summer break, and its
ambition: evolving programs whose useful parts could survive changes to the
whole. Briefly introduce genetic programming as searching through programs by
varying and selecting them. The central difficulty is already recognizable:
changing code can destroy the relationships that made it work.

Establish the three historical stages in one paragraph: the 2001 modularity
and common-schema draft, the 2002 generalization algorithms, and the 2005
Polish thesis on typed genetic programming. State plainly that the programme
remained theoretical and surveying, with ideas concrete enough to motivate
experiments that were never completed. Distinguish the early contents outline
from the developed definitions and arguments in the thesis.

Introduce the present reason to return: the questions can now be examined
against implemented systems. Give one sentence locating DreamCoder as the
library-learning background for babble, then name the three comparisons.

**Transition:** To see what it means for an improvement to survive, first ask
what counts as the same part in two different programs.

Sources: [MGP1](../sources/MGP1.TXT), [GENERA](../sources/GENERA.TXT),
[thesis](../sources/dyplom4.tm), and [historical reading notes](notes.md).
The essay should link the public archive so the originals are available.

## 2. Finding the parts that can vary together

**Approximately 1,000 words.** Explain the early distinction between genealogical
identity and visible similarity. A module can retain its identity while its
implementation changes; copying a module creates another locus. This supplies
the intuition for correspondence before introducing common schemata.

Reuse the example from
[What Must Be True?](../../../notes/what-must-be-true.md#can-generalization-tell-us-when-to-stop),
with a short, self-contained refresher rather than another full introduction
to anti-unification. Readers should not need to follow the link to understand
the comparison. Start with two parents:

```text
pair(a,a)                 pair(b,b)
```

A most specific common pattern is `pair(p,p)`. Filling `p` with `a` or `b`
reconstructs the parents. Explain anti-unification as finding such a common
pattern and the fillings that recover its instances. The earlier essay uses
this example to explain why generalization must preserve repeated differences
consistently: the two components agree. Then expose the historical purpose:
recombination should be able to mix parental choices. With only one hole,
the choices remain tied; `pair(p,q)` permits `pair(a,b)` and `pair(b,a)` as well.
The relationship preserved in the previous essay is precisely the one this
genetic operator deliberately relaxes.

GENERA deliberately requires each schema metavariable to occur once. That
restriction makes sense relative to its intention to expose independently
variable loci. State the assumptions of the example: interchangeable types
and no further dependency requiring the choices to remain linked. Producing
more combinations says nothing yet about their fitness.

**Transition:** The same repeated structure becomes attractive when the goal
changes from recombination to building a reusable library.

Evidence: [babble exploration, §§3–4](babble.md), especially
`GENERA.TXT:164–167` and `MGP1.TXT:817–858`.

## 3. babble: when a common pattern becomes a useful function

**Approximately 1,500 words.** Return to the repeated-hole example. A function
`λp.pair(p,p)` asks callers for one argument and expresses its reuse explicitly.
This can help compression. The contrast gives the reader a reason to care
about the objective before encountering the machinery.

Now introduce the 2001 outline's additional proposal: use equations to expose
common structure, then turn that structure into a named definition. Work
through the arithmetic example:

```text
2 + 1                    1 + 3
```

Purely positional comparison finds two varying arguments. If addition is
commutative, `1+3` can also be represented as `3+1`, exposing the common pattern
`X+1`. The two original expressions are still different computations; the
equation permits alternative representations of each.

Explain an e-graph as a compact representation of equivalent alternatives,
then give babble's three jobs: expose alternatives, find candidate patterns,
and select definitions whose savings justify their costs. The tiny arithmetic
example demonstrates discovery, not a claim that defining an increment
function pays off in a two-expression corpus.

Give one bounded evaluation sentence and one qualification: the paper measures
library compression, while its practical candidate generation and selection
make approximations. Its completeness theorem has a broader, specified formal
scope than the implemented candidate restriction. Leave the theorem details
in the linked reading note.

**Section conclusion:** Which relationships should be retained depends on what
we want to do with them. The historical genetic criterion and the compression
criterion can reasonably choose different patterns.

Primary source: [babble v1](https://arxiv.org/html/2212.04596v1).
Detailed support: [babble exploration](babble.md). Describe the historical
equational passage as a proposal in an outline, with no claim of influence
on babble or priority over earlier abstraction research.

## 4. TyFlow: which choices should remain choices?

**Approximately 1,600 words.** Move to the 2005 thesis. Its division of labor
puts tractable requirements into types and leaves other expectations to
fitness. Introduce algorithm C as a constructor driven by choices, alongside
type inference. It propagates constraints as it constructs a term, allowing
search to choose among possibilities that may succeed or fail.

Use the polymorphic application example from the close reading as a brief
warm-up, not the full demonstration of C:

```text
available: f : ∀a. a → a, b : bool
requested result type: bool
program to construct: f b
```

Explain C's steps in ordinary language. Choosing application creates an
unknown argument type `β`, so the function must have type `β → bool`.
Choosing `f` instantiates its scheme with a fresh `α`, giving `α → α`.
Unifying these function types forces both `α` and `β` to be `bool`; the
argument must then be constructed at that type, and choosing `b` succeeds.
The environment still offers polymorphic `f` for other uses. This shows how
the requested result and a selected binding jointly constrain the next choice.

The main example should expose environment management. A compact candidate is:

```text
available: p : α → bool, b : bool
requested result type: bool
one construction: let test = p in test b
```

Here `α` is a shared type unknown, not a universally quantified variable.
Such unknowns can arise while constructing an enclosing function. Choosing
`LET` and then `p` creates a local binding `test : α → bool`. C must not
generalize `α`, because it occurs free in the surrounding environment through
`p`. Constructing `test b` then fixes `α = bool`, updating both `test` and
`p`. This demonstrates scope extension, generalization relative to the
environment, and propagation of constraints back into that environment.
Contrast this with the fresh instantiation of `∀a` in the warm-up. A second
use of `test` at `int` would conflict with its use at `bool`; it cannot choose
its input type independently at each occurrence.

Use the example to explain the division of labor: types express part of the
requirements, while fitness evaluates further aspects of intended behavior.
Both `b` and `test b` can meet the type without being interchangeable for the
task. The existence of a shorter inhabitant is no objection to constructing
the longer program; C must support varied candidates while maintaining their
typing dependencies. The type is not a semantically complete specification
of intent, and finding its simplest inhabitant is not the objective. Keep
the warm-up short enough to accommodate this within the existing budget.

Introduce TyFlow's recent decision representation and learned guidance.
For the trace under TyFlow's displayed STLC rules, explicitly use the
monomorphic environment `f : bool → bool, b : bool`. This lets us compare
the construction of `f b` without attributing polymorphic instantiation to
those rules. The model supplies the remaining unknown type and name before
an environment-membership condition checks them. C obtains this type through
unification with a fresh instance of the selected environment binding.

Use a short paragraph to connect this construction problem to the later PhD,
[GADTs for Reconstruction of Invariants and Postconditions](../../jca/lukstafi-phd-thesis.pdf)
(2015), and the account in
[What Must Be True?](../../../notes/what-must-be-true.md#reading-a-contract-out-of-the-code).
The master's work constructs programs under typing constraints; the PhD
reconstructs informative types and contracts from programs. In the PhD,
generalization finds common consequences for postconditions, while abduction
finds conditions supporting invariants. Its generalization machinery includes
anti-unification over free terms. These are related uses of logical structure,
not inverse algorithms or evidence of a single uninterrupted GP project.
Mention the implemented InvarGenT system so that the early programme's
theoretical status is not mistakenly extended to the PhD.

The comparison is a question about where to put work. A general rule-based
framework and a constructor specialized around inference expose different
choices to search. Neither this example nor the architectural resemblance
establishes which approach performs better in general.

Separate the guarantees: a completed checked construction is well typed under
the specified rules; coverage of all typing derivations does not make finite
neural search exhaustive; typing does not ensure the requested behavior.
Use one evaluation sentence to distinguish validity from task success. If
mentioning compiler errors, retain the qualification that Java errors remain
outside the implemented typing checks.

**Transition:** Construction can enforce some requirements. Other judgments
arrive only after a candidate has been executed and evaluated. We can now
return to the full evolutionary loop: how do variation and selection turn
existing programs into better candidates?

Primary source: [TyFlow v2](https://arxiv.org/html/2510.10216v2).
Detailed trace, statements, and evaluation: [TyFlow exploration](tyflow.md).
The essay should call this a related construction strategy, with different
operational choices, rather than equating the algorithms.

## 5. AlphaEvolve: variation, selection, and what survives

**Approximately 1,400 words: 400 for the evolutionary loop, 400 for variation
and recombination, 350 for the concrete search example, and 250 for the bridge
to the earlier essay.** Develop the genetic-programming comparison before
turning to continuity of inquiry.

Start with the evolutionary roles: candidate representation, variation,
fitness evaluation, and selection for further variation. In AlphaEvolve,
programs and their evaluations populate a database; a sampled parent and
inspirations inform LLM-generated edits. Discuss this as an evolutionary
process over programs. Selection and variation are separate design choices:
what counts as a successful candidate need not tell us how to produce one.
Connect this directly to the master's division between typing constraints
and fitness, including why the simplest inhabitant of a type need not serve
the task.

The central comparative question is **what makes a useful variation operator?**
Return to MGP1's concern with correspondence between modules and GENERA's
relationship between generalization and mutation. Independent variation is
valuable only where dependencies permit it. Ask what an operator must retain,
what it may change, and whether a useful change requires coordinated changes
elsewhere. Compare an explicitly specified schema-and-substitution operator
with a learned proposal mechanism. Treat this as a change in where the
responsibility for producing useful variants lies; formal preservation and
empirical effectiveness remain different claims.

Make room for recombination without equating every use of earlier candidates
with formal crossover. Distinguish direct descent from a selected parent,
influence from other examples, and the historical operation of exchanging
parts through a common schema. The latter specifies a correspondence and
admissible substitutions. Whether another mechanism accomplishes a similar
practical transfer of useful structure is a separate question. Likewise,
retaining alternatives raises a concrete evolutionary question: which
currently less successful structures might become useful after further
variation? Do not infer that preserving candidates guarantees that their
useful parts will be recognized or combined.

Use the paper's tensor-decomposition searcher as the worked application:
optimizer, initialization, loss, and hyperparameters change over 15 mutations.
Now separate two levels of search: evolving a procedure and running that
procedure to find a mathematical object. Connect this to MGP1's planned
combination of structural evolution and numerical optimization. The old
proposal motivates the comparison; it does not establish equivalence between
these organizations of search. Explain what is being varied, what is being
evaluated, and what evidence warrants accepting the discovered object. Keep
the correctness distinction attached to this example rather than making it
the organizing theme of the whole section.

Only then bring in
[What Persists When the Agents Change?](../../../notes/what-persists-when-agents-change.md).
The evolutionary discussion has established why inheritance involves both
retained material and a process capable of using it. The earlier essay
asks how an inquiry continues across changing participants and representations.
An executable artifact is one way a past achievement can change the starting
point of later work. Its usefulness still depends on selection, interpretation,
and appropriate evaluation.

Retain the philosophical limit. Preserving a successful program need not
preserve why a failed idea was promising, which objection is unresolved, or
why the evaluation criterion deserves revision. The previous essay gives us
those further questions; the AlphaEvolve comparison does not settle them.

**Section conclusion:** The record and the process that uses it jointly
determine what an attempt can inherit. This broadens a question developed
through genetic programming; the section remains primarily an evolutionary
comparison, with a short opening toward the earlier essay.

Primary source: [AlphaEvolve v1](https://arxiv.org/html/2506.13131v1).
Evidence and scope: [AlphaEvolve exploration](alphaevolve.md). Keep source
paraphrase compact and tied to §§2–4. Avoid a catalogue of performance records
or attributing separately measured benefits to mechanisms that the ablations
do not isolate.

## 6. Returning to the unfinished work

**Approximately 550 words.** Return to the distinction between the historical
stages. In 2001, the programme asked which structures should survive variation;
in 2002, it specified how mutation should shape generalization; by 2005, it
also asked how to construct within logical constraints. Looking back through
the three papers makes the consequences of those choices easier to see.

The conclusion should question the direction of the programme's development,
including Łukasz's suggested possibility: **was I nerdsniped into type theory?**
Give that question substance. Environment dependencies were real problems,
and formalizing them produced meaningful results. But proving properties of
typed construction and showing that an evolutionary system finds useful
programs are different achievements. Did the formal work remove an obstacle
to experiments, or did its tractable questions displace the less tidy work
of building and evaluating the search? Both could have happened.

Distinguish the value of the subsequent type-theoretic research, including
the PhD, from its necessity for the original GP ambition. Its independent
value does not establish that it was the best next step for that programme.
Conversely, the lack of early experiments does not establish that the
theoretical direction was a mistake. The missing evidence is how much a
simpler implemented system could have taught us before the richer machinery
was developed. Modern systems sharpen that question; their present resources
do not settle which route was feasible or preferable in 2001–2005.

Let the earlier comparisons inform this self-questioning: a dependency can
be valuable for one purpose and restrictive for another; inference can
resolve choices that would otherwise burden search, but its contribution to
search effectiveness still needs evaluation. Keep the judgment open without
turning it into either retrospective vindication or a declaration of wasted
work. The user proposed this as a question, not an established account of
their motives. Fit it within the existing 550-word conclusion budget.

End with the concrete circumstance of the present essay: the old documents
have survived, and reading them against newer work changes which questions we
can ask of them. That is a modest instance of the continuity discussed in the
previous essay. The outcome of this return is a clearer account of the
questions, with room to reconsider their answers.

## Editorial decisions for drafting

The two earlier essays have distinct roles. *What Must Be True?* supplies the
anti-unification refresher and an accessible account of the PhD's inference
problem. *What Persists When the Agents Change?* supplies the questions about
retention and continued inquiry at the end of the AlphaEvolve section, after
the genetic-programming comparison has been developed. The PhD connection
belongs within the existing section budgets; it does not add a fourth paper
survey or require a second introduction to deduction, generalization, and
abduction.

For the PhD connection, use the contributions and generalization discussion
in the [canonical thesis source](../../jca/lukstafi-phd-thesis.tm), especially
§§4.2–4.3. The witness-generalization theorem discussed in *What Must Be True?*
comes from the [2026 Round 10 work](../../jca/agent-collab/round-10-witness-generalization.md),
not the 2015 thesis. It need not be retold here. Do not transfer its scope over
ordinary term equality to babble's generalization modulo supplied equations.

The two main worked examples are repeated versus independent holes and C's
environment-sensitive `let` construction, with `f b` as a short warm-up and
the basis of the STLC comparison. The small commutativity example explains babble's added
machinery. These fit inline code blocks; no large diagram is necessary. Keep
the functional-hole insertion example and the bilinear certification example
in the reading notes unless the draft needs them to clarify a specific claim.

Use links to the public historical archive, the three fixed paper versions,
and the detailed notes. DreamCoder needs only a brief orientation; the other
supporting papers can remain in the survey. A short sources-and-scope paragraph
can identify versions and explain that this is a selective retrospective, not
a priority study or a complete proof audit.

Leave apparent transcription errors and detailed theorem side conditions in
the research notes. The published essay should preserve the implications of
those qualifications without turning into an errata list. Its claims should
rest on the worked constructions we can explain clearly.

This outline accompanies the reviewed essay. The reading notes identify unresolved
questions that constrain stronger claims; none blocks the proposed account.
