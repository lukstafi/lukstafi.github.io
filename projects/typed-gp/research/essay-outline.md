# What Should a Program Inherit?

Working subtitle: **Revisiting typed genetic programming, twenty-five years later**

Outline, 25 September 2026. Agreed essay length: **6,000–7,000 words**, exceeding
7,000 only if a substantive need arises. The section allocations below total
approximately 6,500 words and are guides, not quotas.

The anniversary is September 2026: Łukasz recalls beginning the original
document in September 2001, the last month of university summer break. Its
October 2001 date records the last modification, not its origin. The master's
thesis is from 2005. This is an editorial outline, not the essay draft.

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

Use a small example with two parents:

```text
f(a,a)                    f(b,b)
```

A shared pattern is `f(X,X)`. Filling `X` with `a` or `b` reconstructs the
parents. Explain anti-unification as finding such a common pattern and the
fillings that recover its instances. Then expose the historical purpose:
recombination should be able to mix parental choices. With only one hole,
the choices remain tied; `f(X,Y)` permits `f(a,b)` and `f(b,a)` as well.

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
`λX.f(X,X)` asks callers for one argument and expresses its reuse explicitly.
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

Use the shared application example from the close reading:

```text
available: f : bool → bool, b : bool
requested result type: bool
program to construct: f b
```

Explain C's steps in ordinary language. Choosing application creates an
unknown argument type. Choosing `f` resolves it to `bool`; the argument must
then be constructed at that type, and choosing `b` succeeds. This is enough
to show how one choice changes the conditions for the next.

Introduce TyFlow's recent decision representation and learned guidance.
Trace the same example only far enough to expose the difference: under its
displayed STLC rules, the model supplies the remaining unknown type and name
before an environment-membership condition checks them. C obtains this type
through unification with the selected environment binding.

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
arrive only after a candidate has been executed and evaluated. How does a
search retain and use what those attempts teach it?

Primary source: [TyFlow v2](https://arxiv.org/html/2510.10216v2).
Detailed trace, statements, and evaluation: [TyFlow exploration](tyflow.md).
The essay should call this a related construction strategy, with different
operational choices, rather than equating the algorithms.

## 5. AlphaEvolve: an inheritance for the next attempt

**Approximately 1,400 words.** Introduce AlphaEvolve's loop briefly: proposals,
evaluation, and retained programs that inform later proposals. Use the paper's
evolving tensor-decomposition searcher as the concrete case. Distinguish the
procedure being improved from the mathematical object it discovers, and the
evidence that warrants accepting that object.

The interpretive work should occupy most of the section. A descendant's
relationship to earlier programs, a result's relationship to its evidence,
and a future attempt's access to useful records are three distinct questions.
They let us revisit the old concern with inheritance without identifying
learned editing with a formally specified common-schema operator.

Bring in [What Persists When the Agents Change?](../../../notes/what-persists-when-agents-change.md)
here, after the technical comparisons have earned the connection. That essay
asks how an inquiry continues across changing participants and representations.
An executable artifact is one way a past achievement can change the starting
point of later work. Its usefulness still depends on selection, interpretation,
and appropriate evaluation.

Retain the philosophical limit. Preserving a successful program need not
preserve why a failed idea was promising, which objection is unresolved, or
why the evaluation criterion deserves revision. The previous essay gives us
those further questions; the AlphaEvolve comparison does not settle them.

**Section conclusion:** The record and the process that uses it jointly
determine what an attempt can inherit.

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

The conclusion should permit revision of the old programme. A dependency can
be valuable for one purpose and restrictive for another. A choice that search
can make may be better resolved by inference. An archived achievement becomes
useful through its contribution to subsequent work. None of these observations
requires the early proposal to have been complete or successful.

End with the concrete circumstance of the present essay: the old documents
have survived, and reading them against newer work changes which questions we
can ask of them. That is a modest instance of the continuity discussed in the
previous essay. The outcome of this return is a clearer account of the
questions, with room to reconsider their answers.

## Editorial decisions for drafting

The two main worked examples are repeated versus independent holes and the
construction of `f b`. The small commutativity example explains babble's added
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

This outline is ready to draft from. The reading notes identify unresolved
questions that constrain stronger claims; none blocks the proposed account.
