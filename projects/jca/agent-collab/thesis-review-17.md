---
title: "Checking a caller after inferring the package it opens"
date: 2026-11-22
---

InvarGenT at revision `0da0cd6` infers the two-constructor packed-payload type on pass 6. The client that needs a `Cargo` payload passes, and the client that asks for `Marker` on the same call fails. A four-constructor program still has a constant-size solution that every outer budget misses. Interchanging two disjoint match arms is enough for the solver to infer the written solution. [Two-constructor source](packed_payload.gadt) · [Four-constructor source](four_axis_payload.gadt) · [Executable comparisons](thesis-review-17.py)

## Where the retry loses the payload {#opening}

The program returns its payload twice. Its test opens the result of `f (Left Box) (S Z)` and checks the first component against `Box`. The successful input must admit $\mathrm{Tag}(\mathrm{Marker},\mathrm{Cargo})$. At `cac61af` pass 0 first guesses $\mathrm{Tag}(a,a)$. After pass 1 rejects that diagonal, the term abducer actually proposes $\mathrm{Tag}(\mathrm{Marker},a)$ on the retry. The failure occurs in the next operation, which splits the conjecture among the predicates and the residual constraint. [Previous proof and normalized predicates](thesis-review-16.html#package)

The client asks the splitter to account for $u=(\mathrm{Cargo},b)$, where $u$ is the type inside the opened package. In this candidate $b$ is a rigid type variable local to the caller's pattern. The splitter cannot put that variable in the result predicate. Putting the equality in the residual also fails the quantifier check. The client itself places no requirement on the second component.

There is an exact rule for this use of a package. Let $p:W\to V$ assemble the part opened by the pattern, and let $P(w)$ be the client's test on the visible fields. Write the requirement that $v$ matches and every matching assignment passes as
$$
  (\exists w.\ p(w)=v)\ \land\ \forall w.\,(p(w)=v\Rightarrow P(w)).
$$
**This is equivalent for every $v$ to $\exists w.\,p(w)=v\land P(w)$ exactly when $P$ has the same truth value on any two assignments producing the same $v$.** For sufficiency, transport the witnessing assignment's test along equality of the assembled values. For necessity, take any successful assignment $w$, put $v=p(w)$, and apply the universal test to every other assignment producing $v$. An injective tuple constructor satisfies the condition for every test. A constructor that forgets a hidden Boolean illustrates the limit. If $P$ requires `true`, both Booleans produce the same visible value and only one passes. [Lean equivalence and counterexample](thesis-review-17.lean)

For the pair test the exact condition on $u$ is $\exists h.\,u=(\mathrm{Cargo},h)$. The witness belongs to this opening. Putting the caller's rigid $b$ into a global predicate changes the quantifier. For a constructor pattern with several field tests, fix the public parameter values and let $P$ be a conjunction of equations on the fields. Unify those equations over finite types. A clash makes the accepted set empty. Otherwise, if $\sigma$ is a most general unifier, the accepted results are exactly the ground instances of $p\sigma$, with its remaining variables existential. For example, checking that the first of three fields has type `Cargo` and the other two have the same type projects to $\exists h.\,u=(\mathrm{Cargo},h,h)$. Keeping the repeated hole preserves the second test. This construction gives a specification for projecting such obligations directly.

## What the solver now checks {#confirmation}

After a type-search failure involving a definition with external openings of its recursive result, the solver tries the positive branches again with those observation branches deferred. It retains the call itself, so its argument types can still determine which input predicate to choose. It also retains the defining branches and their recursive uses. When this search finds stable input and result predicates, it starts the next pass with the complete original branch list and an empty residual. Acceptance requires the ordinary stopping test on the complete problem. Negative branches retain their usual checks. This implements a second search order. The projection theorem above explains the obligation that the complete pass must discharge.

For the two-constructor program, the proposal stabilizes on pass 5. It captures the argument type and gives both result components that type. Pass 6 reinstates the client and succeeds. Setting the outer budget to 5 prevents acceptance. Giving the program a right-hand client instead infers the symmetric type. Requiring the first component from `Left Box` to have type `Marker` produces a type mismatch on the complete pass. Asking one conjunctive scheme to support marked calls on both axes also fails, as the earlier lower bound predicts. [Positive and negative controls](thesis-review-17.py) · [Conjunctive coverage lower bound](thesis-review-1.html)

## A four-constructor counterexample after the repair {#four}

Let $M$ denote `Marker`. Each of the four constructors places its payload type in its own argument position of `Tag` and places $M$ in the other three. The base branch returns $(z,z)$ from its payload $z$. The successor recurses at the same tag. The sole attached call uses `Third Box`. A certificate is
$$
  \forall a.\;\mathrm{Tag}(M,M,a,M)\to\mathrm{Nat}\to\exists().\,(a,a).
$$
For `Third`, the payload has type $a$. Matching any other constructor gives $a=M$ and a payload of type $M$. All four branches are live at the all-$M$ input. In the erased constraints the unary function predicate ranges over these instances of the displayed arrow. Its binary postcondition relates $(a,a)$ to the one-entry parameter tuple $\langle a\rangle$. The successor preserves the same parameter at every depth, and the client instantiates $a$ with `Cargo`. InvarGenT checks the written type and the generated OCaml runs with each constructor. [Source](four_axis_payload.gadt) · [Lean proof at arbitrary depth](thesis-review-17.lean)

With the annotation erased and the arms in declaration order, the trace contains just the following candidate inputs. Letters $a,b$ are fresh within each row. The third marked argument would require the tuple $(M,M,\mathrm{Cargo},M)$.

| Search | Candidate index tuples in order | Last result |
|---|---|---|
| All branches | $(a,b,b,b)$, $(M,M,M,a)$, $(a,a,a,b)$ | Pass 0 exhausts term abduction on the next retry. |
| External openings deferred | $(a,b,b,b)$, $(M,M,M,a)$, $(a,a,a,b)$, $(M,a,M,M)$ | Pass 0 exhausts term abduction on the next retry. |

Each pass-0 candidate reaches pass 1, which rejects it with a type mismatch. The pass-1 errors and the final pass-0 errors occur before the outer timeout comparison. The only successful abduction passes that inspect the limit have pass number zero. The second search never returns a proposal, so the comparison that reserves a pass for confirmation is unreachable. Thus budget zero stops on the first pass and **every positive outer budget follows the same finite failing path**, with the component search settings fixed. The executable driver checks limits through 10,000. To reproduce the intermediate choices in `src/Invariants.ml`, print `iter_no` and `sol2` with `pr_chi_subst` immediately above `if not !initstep && finished`. Print the pass and `msg` at the `Aux.Left (sort, e)` return above `match answer`. This counterexample concerns successful discovery. The solver returns an error on every run.

Swapping the `Second` and `Fourth` arms preserves every constructor's return expression. On the second search it changes the fourth candidate to $(M,M,a,M)$, which admits the marked call. The solver confirms the resulting type on pass 6. With the original arm order and the default outer budget, every inner failed-branch allowance from the default 10 through 28 rejects. At `-term_abduction_fail 29` the solver infers the certificate. Returning the ordinary unboxed pair in the original order still gives a term-abduction failure at the default settings. The remaining obstacle in this example is the component's search over input types. The separate arithmetic moving-floor example still raises the question of what happens after arbitrarily many induction jumps. [Arm-order comparison](thesis-review-17.py) · [Arithmetic jump trace](thesis-review-16.html#restarts)

## Quantifiers in the unifier {#scope}

Two small formulas expose independent errors below the splitter. In $\forall u\,\exists z.\ u=z$, the witness is $z=u$. The old unifier checked whether it could bind the left operand before choosing the direction of the substitution. It rejected the displayed formula and accepted the same equation with its operands reversed.

Now consider $\exists x\,\forall u\,\exists z.\ x=\mathrm{Box}(z)\land z=u$. Choose two different ground types for $u$. The earlier $x$ would have to equal both $\mathrm{Box}(\mathrm{Marker})$ and $\mathrm{Box}(\mathrm{Cargo})$. If the old solver first bound $x$ to $\mathrm{Box}(z)$ and later bound $z$ to $u$, it rechecked the old right-hand side and stored the new one. The resulting substitution assigned $\mathrm{Box}(u)$ to the earlier $x$. Revision `8e0777e` checks the direction it actually binds and checks every rewritten right-hand side after composition. The source-level packed-payload failure remains reproducible with just this unifier repair. [Lean witnesses](thesis-review-17.lean)

I compared quantified unification with an oracle that shares the ordinary unifier and checks scope separately. It freezes each universal as a distinct private constructor, solves the free equations, then checks every existential's fully substituted term for later rigid symbols. A residual flexible hole can be filled with a fixed ground constant. The audit uses three ordered variables, both quantifiers at each position, two constants and a unary constructor applied to each variable. It considers all ordered pairs of oriented equations over the eight resulting terms.

| Checker | Systems | False acceptances | False rejections |
|---|---:|---:|---:|
| Before `8e0777e` | 32,768 | 10 | 392 |
| After `8e0777e` | 32,768 | 0 | 0 |

The OCaml 5.3 compatibility suite passed all 301 active tests, with 10 existing TODOs. All 145 earlier inferred signatures matched byte for byte. Both OCaml 5.3 and 5.5 executed the program comparisons.

The scope audit exercises the pure type component with no designated parameters. To reproduce it, copy `scope_audit.ml` into the solver's `src` directory in a build checkout and build `src/scope_audit.native` with the same OCaml libraries as the solver. It exits unsuccessfully on any disagreement. Run `lean thesis-review-17.lean` for the proofs and `python3 thesis-review-17.py /path/to/InvarGenT.native` for the programs. [Scope audit](scope_audit.ml) · [Lean development](thesis-review-17.lean) · [Executable checks](thesis-review-17.py)
