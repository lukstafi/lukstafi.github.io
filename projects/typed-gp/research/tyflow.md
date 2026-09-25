# TyFlow and algorithm C: decisions inside a typed construction

Reading note, 25 September 2026. This comparison uses **TyFlow: A Type-Aware
Approach to Neural Code Models**, arXiv **2510.10216v2**, dated 6 February
2026, and the 2005 thesis. The title belongs to this exact revision; the earlier
title used in our conversation should not identify v2. This is a worked
comparison of mechanisms and stated guarantees, not a replication or complete
proof audit.

**Finding:** the technical connection is real. Both systems separate the
decisions that choose a program from the machinery that constructs it under
typing constraints. Both propagate information discovered in one subterm into
the construction of another. Their decision representations, treatment of
unknowns, and search objectives nevertheless differ. TyFlow does not establish
that its construction is equivalent to algorithm C, and this comparison gives
no basis for a priority or influence claim.

## Sources and authority

The historical authority is [dyplom4.tm](../sources/dyplom4.tm). The
[decoded TeXmacs source](../extractions/dyplom4.source.utf8.txt) preserves the
markup and corresponding line positions while making Polish prose readable.
The approximate plain-text extraction was not used to establish formulas.
Principal locations, in both source files:

- Lines 516–619: separation of construction and search, answer substitutions,
  choice sequences, backtracking, and why type inference matters.
- Lines 1549–1680: algorithms W and C; the C definition has label `algC` at
  line 1624.
- Lines 1802–1900: C soundness and its proof.
- Lines 2162–2379: C completeness, label `pelnoscC` at line 2184, and the
  following generality result.

For TyFlow, use the [fixed public version](https://arxiv.org/html/2510.10216v2).
The supplied TeX is under `/Users/lukstafi/Downloads/TyFlow-arXiv-2510.10216v2/`.
`manuscript.tex:178–194` identifies the active chapters; `macros.tex` defines
the judgment, unknown-variable, acquisition, and substitution notation.
The detailed source references below are relative to that directory. In
`overview-rules.tex`, material following `\endinput` is inactive and is not
evidence for the published construction.

## What the thesis proposed

Algorithm C takes an environment `E`, a requested type `τ`, a supply `V` of
fresh type variables, and a sequence `w` of natural-number choices. On a
successful path it returns a substitution `T`, a term `e`, and the unused
supplies. Its intended typing relation is

```text
T E ⊢ e : T τ.
```

The requested type may contain unknowns. Construction can discover their
values, including values needed elsewhere in the environment. This is more
expressive than picking a term from a preclassified bucket of exactly typed
subtrees.

The four cases are `VAR`, `FIX`, `APP`, and `LET`. A choice selects a case;
`VAR` additionally selects an environment entry. It instantiates the entry's
polymorphic scheme with fresh variables, then unifies that instance with the
requested type. `FIX` introduces the recursive function and its argument into
the environment. `APP` generates the function before its argument and carries
the resulting substitution forward. `LET` generates a definition, generalizes
its type relative to the environment, and constructs the body with that scheme
available.

The choice stream is an external expression of nondeterminism. It is not a
learned token representation in the thesis. Multiple natural numbers can select
the same branch through the modulus operations, and paths can fail. The thesis
explicitly separates choosing paths from interpreting them, discusses
backtracking and breadth-first search, and treats exhausted practical budgets
as failed genetic-operator attempts. It also connects replacement of a subterm
to the local environment and type in that subterm's derivation.

This supplies the historical connection without inventing an implementation:
there is already an interface at which a search procedure can choose while a
typed constructor enforces obligations. The thesis cites proof search and
SLD-resolution in its discussion of answer substitutions; these ideas were
presented as part of an existing logical tradition.

## What TyFlow constructs and learns

TyFlow generalizes the construction interface across user-specified languages.
The user provides inductively defined syntax, typing rules expressed as
constrained Horn clauses, and a type checker that produces derivation trees
for training programs. Rules contain recursive judgment premises and
computable side conditions. The framework uses **first-order unification**;
the fact that a source language can contain functions does not make this
higher-order unification. See [§3](https://arxiv.org/html/2510.10216v2#S3),
`chapters/methods_meta.tex`.

Its rule translation has five main operations:

1. Unify the current, possibly incomplete judgment with a fresh rule conclusion.
2. Acquire ground values for remaining variables that the rule's recursive
   premises will not determine.
3. Recursively construct the premises in order, propagating substitutions.
4. Check the rule's computable side condition.
5. Compose the substitutions and return the assignment relevant to the goal.

The model answers two kinds of query: **which rule**, and **which ground
assignment**. A model-generated assignment can include a name, literal, type,
or another structured term, encoded by constructor and constant tokens.
“Free variable” here means a metavariable of the synthesis rule, not
necessarily a free variable of the generated program.

Typing derivations from existing programs provide training decisions. During
generation, the model sees the natural-language specification, its previous
decisions, and the current synthesis goal. The implementation separately
encodes the static specification and changing goal, then combines them through
cross-attention. Thus the representation and training targets expose typing
structure, while the symbolic engine still performs unification and checks.
The guarantee does not depend on the neural model having perfectly learned
the type system. See [§4.2](https://arxiv.org/html/2510.10216v2#S4.SS2) and
[§5](https://arxiv.org/html/2510.10216v2#S5),
`chapters/methods_system.tex:114–158` and `chapters/model.tex:4–43`.

## One small application in both systems

The following is our reconstructed example, not a benchmark run or a quoted
example. It uses the common variable/application fragment, avoiding a false
identification of MiniML's recursive `fix` with STLC's annotated lambda. Let

```text
E = { f : bool → bool, b : bool }
goal: construct a term of type bool
chosen result: f b
```

`bool` can be a base type constant in the thesis's setting. Both bindings are
monomorphic, so the example does not purport to compare their polymorphism.

### Algorithm C

Choose `APP`. Introduce a fresh type variable `β` and start with

```text
C(E, β → bool).
```

Choose `VAR`, then environment entry `f`. Its type is `bool → bool`.
Unification returns `R = { β ↦ bool }`; the generated function is `f`.

The application case now constructs its argument with the **updated** goal

```text
C(R E, R β) = C(E, bool).
```

Choose `VAR`, then `b`. Unification succeeds without a further nontrivial
substitution. The composed result is `f b : bool`. Symbolically the consumed
choices are `APP; VAR, f; VAR, b`. This notation names their meanings instead
of assigning literal integers: the old definition's enumeration and modulus
convention should not be silently converted into a new executable encoding.

The decisive operation is the unification at `f`: it determines the type that
the argument must have. If the argument choice instead selected a binding
`c : bool → bool`, that path would fail.

### TyFlow with its displayed STLC rules

Start with the synthesis goal `E ⊢ ?p : bool`. Choosing `S-App` unifies the
program hole with `?p₁ ?p₂` and creates goals

```text
E ⊢ ?p₁ : ?a → bool
E ⊢ ?p₂ : ?a.
```

Choose `S-Var` for the first goal. There is an important difference from C:
TyFlow's displayed `T-Var` encodes environment membership as an **executable
constraint**, not a recursive relation that searches the environment and
returns a type. The remaining unknown name and type must be acquired before
that predicate can run. One successful model assignment supplies the name
`f` and `?a = bool`; the engine checks that `f : bool → bool` belongs to `E`.

That assignment changes the second goal to `E ⊢ ?p₂ : bool`. Another `S-Var`
choice supplies `b`, and its membership check succeeds. Composition gives
`?p = f b`. Supplying a name with an incompatible type would fail the check
and prune this branch.

These steps follow the normal-form rule translation in
[§3.3](https://arxiv.org/html/2510.10216v2#S3.SS3) and the same acquisition
behavior shown for the paper's identity-function example in
[§2.2](https://arxiv.org/html/2510.10216v2#S2.SS2),
`chapters/overview.tex:192–231`. They establish a shared pattern of
construction and information flow, but also a concrete operational difference:
**C infers this type from the selected binding; the displayed TyFlow encoding
asks the model to propose it and then checks it.** A different Horn-clause
encoding of lookup could change that behavior; we have not constructed or
proved such an encoding equivalent to C.

This difference illuminates a tension already articulated in the thesis
(lines 600–619): searching over type annotations can waste effort that a type
inference algorithm could discharge. TyFlow's generality and learned guidance
make a different engineering tradeoff. “Both have decision sequences” is
therefore a starting point for the comparison, not its conclusion.

## Exactly what is guaranteed

For **C**, the soundness statement says that a defined computation returning
`(T,e,...)` yields `T E ⊢ e : T τ`. The completeness theorem `pelnoscC` says,
with its freshness and substitution conditions, that if
`T′ E ⊢ e : T′ τ`, some choice path generates `e`, with a result substitution
through which `T′` factors outside the fresh-variable supply. The theorem
requires an infinite fresh supply disjoint from the stated free-variable sets
and `F(T′) ∩ Dom(T′) = ∅`. This is an existence/generalization statement for
the presented MiniML construction, not a promise that any random path succeeds
or that a practical search terminates. These are reported theorem statements
with inspected proofs, not newly certified proofs of the historical manuscript.

For **TyFlow**, [§4.4](https://arxiv.org/html/2510.10216v2#S4.SS4) proves the
correspondence through derivation trees: every successfully constructed
synthesis tree extracts a program derivable in the supplied type system; every
program with a typing derivation has a corresponding synthesis tree. See
`chapters/methods_system.tex:166–224` and Appendix A. The trees preserve rule
structure and ordered children, with assignments relating their labels. This
is not a claim of one unique decision sequence per source program.

Completeness here concerns the **representation's coverage**. It does not
guarantee that the language model or finite beam search finds every well-typed
program. Soundness concerns successful checked trees, not arbitrary token
sequences predicted without the checking engine. Neither system's stated type
guarantee establishes the functional behavior requested in natural language,
or termination of arbitrary generated recursive programs.

TyFlow's final assignments ground syntactic metavariables. C can return
schematic types through an answer substitution and explicitly handles
Hindley–Milner instantiation/generalization. These formulations cannot be
identified without specifying a common object language and representation of
type variables and schemes.

One source discrepancy deserves retention for a future formal audit:
TyFlow's Algorithm 1 subgoal loop omits `σ₀` in two printed substitution
chains (`chapters/methods_system.tex:92–94`), although the preceding rule
definition and prose include it. This note follows the explicit normal-form
rule, not that omission. No corrected implementation has been tested here.

## Evidence and its limits

The evaluation uses 220M CodeT5 and 2B T5Gemma2 bases, the ML-style SuFu
language, and an implemented Java subset. The stated datasets contain 290
SuFu tasks with an 80/20 split and 608 covered MBJP tasks with a 90/10 split.
These are specialized fine-tuning evaluations, not a frontier-model leaderboard.
See [§6.1](https://arxiv.org/html/2510.10216v2#S6.SS1),
`chapters/evaluation.tex:12–55`.

The v2 [Table 2](https://arxiv.org/html/2510.10216v2#S6.T2)
(`chapters/evaluation.tex:65–110`) reports:

| Language/base | Baseline pass@10 → TyFlow | Baseline compilation error rate → TyFlow |
| --- | --- | --- |
| SuFu / 220M | 32.76% → 46.55% | 83.10% → 0% |
| SuFu / 2B | 37.93% → 50.00% | 61.21% → 0% |
| Java / 220M | 20.90% → 28.36% | 38.51% → 3.52% |
| Java / 2B | 35.82% → 40.30% | 15.22% → 3.12% |

Pass@10 is defined here as the proportion of tasks for which at least one of
the top ten candidates passes the reference tests; compilation error rate
counts generated candidates failing to compile. Their denominators differ.
The table percentages are reported as printed, without reconstructing candidate
counts. In particular, **TyFlow does not eliminate all Java compilation
errors**: the authors attribute remaining failures to checks outside their
implemented type system, including unreachable-code analysis. Zero SuFu
compilation errors and the relative type-correctness theorem should not become
an unrestricted compiler-correctness claim.

The sequential SuFu/220M ablation is especially informative. Decision sequences
without checks still have 74.26% compilation errors. Adding syntactic pruning
leaves 72.13%; adding type pruning brings that to zero. Adding the dynamic
typing context then increases pass@10 from 43.10% to 46.55%, while pass@1
stays at 37.93%. These results separate enforcing validity from improving the
ranking of useful candidates. The sequential design does not establish each
component's effect in every possible combination. See
[Table 3](https://arxiv.org/html/2510.10216v2#S6.T3),
`chapters/evaluation.tex:115–175`.

The paper also compares with rejection sampling and separated type/code
generation. Its measured baselines do not establish that all constrained
decoding methods are equivalent or universally inferior. We should carry the
specific results into the essay rather than adopting that broader rhetoric.

## What belongs in the anniversary essay

An accurate connection would be: *The thesis treated typed generation as a
constructor driven by choices. TyFlow makes a related interface the object of
learning: a neural model predicts synthesis decisions while a symbolic engine
propagates and checks their typing obligations.*

The application example gives this sentence substance. The lookup difference
keeps it honest. TyFlow contributes a general rule translation, a derivation
representation usable for supervised training, an architecture that exposes the
current goal, and measured generation results. The thesis supplies an earlier,
different construction and a reason to examine which choices should remain
choices at all. Neither an anticipation claim nor an algorithm-equivalence
claim is needed to make that comparison interesting.
