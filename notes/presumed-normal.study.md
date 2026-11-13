---
title: "Study notes: Presumed Normal"
essay: presumed-normal
track: learners-and-uncertainty
reviewed-against: "625fd37"
requires:
  - {at: what-must-be-true#the-open-question-is-whether-we-can-always-stop, for: "the question the essay follows through four kinds of system, when a reasoner may stop", strength: helpful}
  - {at: what-must-be-true#finding-an-assumption-that-survives-every-case, for: "joint constraint abduction, which a box recasts as an adaptive problem", strength: helpful}
  - {at: the-bookmaker-is-a-learner#the-combinatorial-wall, for: "matching against pricing, the gap the box on weighted abnormalities returns to", strength: helpful}
introduces:
  - {term: adaptive logic, at: a-logic-in-three-parts, gloss: "a lower limit logic, a set of abnormalities presumed false, and a strategy for reading the premises as normally as possible", related: ["Self and idealized sources"]}
  - {term: Dab-formula and unreliable set, at: a-logic-in-three-parts, related: ["nogood"]}
  - {term: Reliability and Minimal Abnormality, at: a-logic-in-three-parts, related: ["gaps and gluts"]}
  - {term: condition and marking, at: proofs-that-change-their-minds, related: ["paradox resistance"]}
  - {term: internal and external dynamics, at: proofs-that-change-their-minds, related: ["logical omniscience"]}
  - {term: final derivability, at: proofs-that-change-their-minds, related: ["semidecision procedure"]}
  - {term: rebutting and undercutting defeaters, at: defeaters, related: ["reason, price and defeater", "presumption of independence"]}
  - {term: argumentation framework and extension, at: defeaters, related: ["stable model and reduct"]}
  - {term: stable model and reduct, at: answer-sets, related: ["paradox resistance"]}
  - {term: here-and-there and equilibrium model, at: answer-sets}
  - {term: nogood, at: the-solver-keeps-no-proof}
  - {term: abnormality with a price, at: the-solver-keeps-no-proof, gloss: "a weight $w$ on each abnormality, which turns the selection of minimal models into a distribution over models and plays the part of an inverse temperature", related: ["matching as pricing at zero temperature", "presumption of independence", "gaps and gluts"]}
  - {term: condition as an abductive answer, at: explanations-as-conditions, gloss: "the condition of an adaptive derivation of $G$, read as a hypothesis of normality under which the premises entail $G$", related: ["deduction, generalization and abduction"]}
uses:
  - {term: matching as pricing at zero temperature, from: the-bookmaker-is-a-learner}
  - {term: joint constraint abduction, from: what-must-be-true}
  - {term: semidecision procedure, from: what-must-be-true}
---

The essay's examples are small enough to redo by hand, and several questions ask for that.

### The opening proof {kind=case}

The premises are $p$, $\sim p\lor r$, $q$, $\sim q\lor s$ and $\sim p$. What do classical logic and the paraconsistent logic CLuN say about $r$ and $s$? What does the adaptive logic ACLuN1 conclude, and how does its proof get there?

::: answer
Classical logic derives every sentence from $p$ and $\sim p$, so it derives $r$, $s$ and their negations. In CLuN a sentence and its negation may both be true, so disjunctive syllogism fails, and CLuN gives neither $r$ nor $s$. ACLuN1 derives $s$ and withholds $r$. Its proof writes $r$ on the condition $\{p\land\sim p\}$ and $s$ on the condition $\{q\land\sim q\}$: each holds provided that the contradiction is false. Once $p\land\sim p$ is derived from the first and last premises, the line for $r$ is marked and $r$ no longer counts as derived. Nothing ever derives $q\land\sim q$, so the line for $s$ stands.
:::

### Three ingredients {kind=state at=a-logic-in-three-parts}

Name the three ingredients of an adaptive logic in Batens's standard format, with the first two as they are in ACLuN1. What is the upper limit logic, and in what sense does an adaptive logic lie between its limits?

::: answer
- A lower limit logic: a monotonic logic whose consequences the adaptive logic keeps whatever else the premises say. In ACLuN1 it is CLuN.
- A set of abnormalities: formulas picked out by their logical form and presumed false unless the premises show otherwise. In ACLuN1 they are contradictions, $A\land\sim A$.
- A strategy, which says what interpreting the premises as normally as possible amounts to.

The upper limit logic is the lower limit logic strengthened so that no abnormality can be true. For ACLuN1 it is classical logic. When the premises are normal the adaptive logic delivers everything the upper limit logic does. When they are not, it falls back to the lower limit logic only where it has to.
:::

### Two strategies, one example {kind=compute at=a-logic-in-three-parts}

The premises are $p$, $q$, $\sim p\lor\sim q$, $\sim p\lor r$ and $\sim q\lor r$. Which Dab-formula does CLuN derive, and what is the unreliable set? Does $r$ follow under Reliability? Under Minimal Abnormality? Which model separates the two?

::: answer
CLuN derives $(p\land\sim p)\lor(q\land\sim q)$ and nothing stronger. The formula is minimal, so the unreliable set $U(\Gamma)$ contains both contradictions. A proof derives $r$ twice: on the condition $\{p\land\sim p\}$ from the fourth premise, and on $\{q\land\sim q\}$ from the fifth.

*Reliability* refuses to presume anything about the members of $U(\Gamma)$. Each line for $r$ rests on one of them, so both lines are marked and $r$ is not derived.

*Minimal Abnormality* looks at the ways the premises could be as normal as possible. One makes only $p$ contradictory, and then the fifth premise gives $r$. The other makes only $q$ contradictory, and then the fourth gives $r$. Every such reading contains $r$, so $r$ is derived.

The separating model makes both $p$ and $q$ contradictory and $r$ false. Reliability keeps it, because its abnormalities lie inside $U(\Gamma)$. It is not minimally abnormal.
:::

### Final derivability {kind=derive at=proofs-that-change-their-minds}

With the premises fixed, a line of an adaptive proof can be marked and later unmarked. When is a formula finally derived? Under Reliability, restate final derivability so that each quantifier has a visible job, and count the quantifiers. Why not require every derivation of the formula to survive?

::: answer
A formula is finally derived on a line when the line is unmarked, and every extension of the proof that marks it can be extended further to unmark it. Restated: $A$ is finally derivable from $\Gamma$ iff there is a finite condition $\Theta$ such that $A\lor\mathrm{Dab}(\Theta)$ is derivable in the lower limit logic and no member of $\Theta$ is in $U(\Gamma)$. The first clause is $\Sigma^0_1$, since a proof confirms it. Membership of an abnormality in $U(\Gamma)$ is $\Sigma^0_2$: some $\mathrm{Dab}(\Delta)$ containing it is derivable, and no $\mathrm{Dab}$ of a proper subset of $\Delta$ is. So the second clause is $\Pi^0_2$ and the whole statement is $\Sigma^0_3$.

The outer quantifier chooses which derivation to trust. Requiring every derivation to survive would be too strong: any condition can be enlarged with an abnormality that is derivable outright, which gives a line that stays marked forever.
:::

### Presumptions that produce {kind=case at=generalizing-and-transferring}

In the logics of induction, what is an abnormality? Say what the logic does after observing $Pa\land Qa$, and then after observing $Pb\land\sim Qb$. In D'Hanis's logic of metaphor, which facts about the solar system transfer to the atom, and which transfer is withdrawn? What do the two logics have in common?

::: answer
An abnormality has the form $\exists A\land\exists\sim A$: some things are $A$ and some are not. Presuming it false presumes the world uniform. From $Pa\land Qa$ the conditional rule derives $\forall x(Px\supset Qx)$ on the condition $\{\exists(P\supset Q)\land\exists\sim(P\supset Q)\}$. Uniformity alone also proposes $\forall x\,Px$ and $\forall x\,Qx$. Observing $Pb\land\sim Qb$ derives the abnormality on the empty condition, and the generalization is marked.

The logic of metaphor transfers a fact about the secondary subject on the condition that its negation is not established for the primary subject. That the planets orbit the sun and that the sun is far more massive both transfer. That the planets attract one another is withdrawn, because electrons are known to repel one another.

Both logics treat a presumption as productive. Each projects far beyond what the premises establish, and each is held in check by a condition that the premises can later falsify.
:::

### Two kinds of defeater {kind=distinguish at=defeaters}

Distinguish Pollock's rebutting and undercutting defeaters, using the object that looks red. Which kind is every defeat in the adaptive format, and why? How does a defeated argument come back?

::: answer
A rebutting defeater is a reason for the opposite conclusion: a reliable instrument reports that the object is not red. An undercutting defeater attacks the connection between reason and conclusion without supporting the opposite: the object is lit by red light, so its looking red says nothing about its colour. In the adaptive format every defeat is an undercut. Deriving an abnormality removes a line's support without supporting the opposite conclusion: line 8 of the first proof showed that $p$ is contradictory, not that $r$ is false. A defeated defeater no longer defeats anything, so an argument against the red light reinstates the inference from looking red to being red.
:::

### The strategies as an order of operations {kind=explain at=defeaters}

Heyninck and Straßer translate adaptive logics into assumption-based argumentation. What are the assumptions? How do Reliability and Minimal Abnormality differ in that setting? Apply the difference to the premises $p$, $q$, $\sim p\lor\sim q$, $\sim p\lor r$, $\sim q\lor r$.

::: answer
The assumptions are the negations of abnormalities, the normality presumptions, and an attack derives the negation of an assumption. Minimal Abnormality first derives conclusions from each extension separately and then keeps those that every extension yields, the sceptical conclusions. Reliability first intersects the extensions and then derives conclusions from the intersection. Deriving after intersecting yields less, because a conclusion may rest on different presumptions in different extensions. In the example one extension keeps the presumption that $p$ is consistent and the other keeps the presumption about $q$. Each derives $r$, so $r$ is sceptically accepted. The intersection contains neither presumption, so Reliability does not derive $r$.
:::

### Guess and check {kind=compute at=answer-sets}

State the test that makes a set of atoms a stable model. Apply it to the one-rule program `a :- not a.` Then use the three-valued table of here-and-there to find the answer sets of `a :- not not a.`

::: answer
Guess a set $X$ of atoms. Form the reduct: delete every rule with a literal `not a` for an atom $a$ in $X$, and delete the remaining `not` literals. $X$ is a stable model when the least model of the reduct is $X$ itself.

For `a :- not a.`, the guess $\{a\}$ deletes the rule, and the least model is empty. The guess $\emptyset$ leaves the fact `a`, whose least model is $\{a\}$. Neither guess reproduces itself, so there is no stable model.

In the table an implication $a\to b$ takes the value 1 when $a\le b$ and the value $b$ otherwise, and $\neg a$ is $a\to0$. The second rule is $\neg\neg a\to a$. At $a=1$ it holds, and lowering $a$ to ½ gives $\neg\neg\tfrac12\to\tfrac12=1\to\tfrac12=\tfrac12$, so the formula fails and $a=1$ is an equilibrium model. At $a=0$ it holds with nothing to lower. The answer sets are $\emptyset$ and $\{a\}$: the rule lets the solver guess $a$ either way, which is what a choice rule means.
:::

### Minimal models and their cost {kind=explain at=answer-sets}

What do the semantics of ASP and the adaptive format have in common, and what does each minimize? Which older formalism does Minimal Abnormality coincide with? Why does reasoning over minimal models sit at the second level of the polynomial hierarchy?

::: answer
In both, a monotonic logic is followed by a selection of minimal models. The adaptive logic minimizes abnormality, and ASP minimizes truth itself, subject to the guess. Minimal Abnormality coincides with McCarthy's circumscription: circumscribing the abnormalities, with every other symbol allowed to vary, selects the models whose sets of abnormalities are ⊆-minimal. Since ASP can compute models that are minimal in chosen atoms, it can compute Minimal Abnormality directly. Checking a candidate model is easy. Whether a conclusion holds in every minimal model asks, for every model, whether a smaller one exists: a universal quantifier over an existential one. That alternation puts the problem at the second level.
:::

### The solver keeps no proof {kind=explain at=the-solver-keeps-no-proof}

Match a conflict-driven ASP solver to an adaptive proof: what is a learned nogood over abnormality atoms, and what does backjumping correspond to? Where do the two then differ? What is the partial exception?

::: answer
A learned nogood over abnormality atoms says that these abnormalities cannot all be false, which is a Dab-formula. Backjumping withdraws the conclusions that depended on the failed choices, as marking withdraws the lines whose conditions failed. So the dynamics moved from the proof into the solver. The difference is in what counts as a result. The solver's intermediate states are not results: a user gets answer sets, and the trail of assignments, conflicts and backjumps is not part of the answer. In an adaptive logic the proof is the result, and a stage of it is something a reasoner can use. Optimization statements are a partial exception: the solver reports answer sets of decreasing cost while it searches, and each can be used. The last is known to be optimal only once the search for a cheaper one has failed.
:::

### Abnormality with a price {kind=compute at=the-solver-keeps-no-proof}

The clingo encoding gives each letter $A$ two independent atoms, `true(A)` and `neg(A)`, at least one of which holds, and calls a letter with both abnormal. For the premises $p$, $q$, $\sim p\lor\sim q$, $\sim p\lor r$, $\sim q\lor r$, sort the models by their number of abnormalities and find where $r$ fails. Give each model with $k$ abnormalities the weight $e^{-wk}$. What is the probability of $r$ at $w=0$, at $w=2$ and as $w\to\infty$? Which computational problem is the limit, and which is any finite $w$?

::: answer
`true(p)` and `true(q)` hold, and at least one of `neg(p)`, `neg(q)`. With exactly one of them, $r$ must be true and `neg(r)` is free: four models, two with one abnormality and two with two. With both, $r$ may be true, false or both: three models, with two, two and three abnormalities. That makes seven models: two with one abnormality, four with two, one with three. The only model in which $r$ fails has two, those of $p$ and $q$.

$$
P(r)=\frac{2e^{-w}+3e^{-2w}+e^{-3w}}{2e^{-w}+4e^{-2w}+e^{-3w}}.
$$

At $w=0$ this is $6/7\approx0.86$. At $w=2$ it is about $0.95$. As $w\to\infty$ it approaches 1, the verdict of Minimal Abnormality. The limit needs only the models of least total price, which an optimization statement finds. Any finite $w$ needs every model, weighted, which takes a count. The weight $w$ plays the part of an inverse temperature.
:::

### A condition is a hypothesis {kind=explain at=explanations-as-conditions}

In what sense is the condition of an adaptive derivation an abductive answer? Recast joint constraint abduction in those terms: name the three differences from an adaptive proof, and say what the recasting shows about where the difficulty lies.

::: answer
A line for $G$ on condition $\Theta$ says that the premises derive $G\lor\mathrm{Dab}(\Theta)$. When the lower limit logic contains classical logic, that is the same as saying that the premises together with the hypothesis "every member of $\Theta$ is normal" entail $G$. The hypothesis is consistent with the premises exactly when $\mathrm{Dab}(\Theta)$ is not derivable. The strategies are policies for which answers to trust.

In joint constraint abduction the answer $A$ plays the part of a condition, with three differences.

- The problem is joint: one condition must serve several premise sets and goals at once.
- The acceptance test is consistency alone: an answer is rejected only when it makes some case inconsistent.
- The language of hypotheses is open: the answers are equations, they may introduce fresh variables, and their depth is unbounded.

For equations over finite trees consistency is decided by unification, so marking is decidable and the problem has a positive test. Whether it is decidable turns entirely on whether the size of a needed condition can be bounded in terms of the input.
:::

### Three answers {kind=recall at=can-we-always-stop}

When may a reasoner stop? Give the essay's answer for answer set programming, for an adaptive logic and for joint constraint abduction. What is a stage of an adaptive proof worth?

::: answer
*ASP* stops, because the search begins only after grounding has made the problem finite. The price is paid in grounding, and a program with infinitely many possibly derivable atoms is outside what the solver can finish.

*An adaptive logic* need not stop, and it does not ask to. Final derivability can lie beyond every positive test, because whether a line stays unmarked depends on Dab-formulas not being derivable. What the reasoner has is a stage, the proof so far with its marks. Batens calls a stage "a fallible but sensible estimate" of what finally follows. Before line 8 of the first proof a reasoner would have acted on $r$, and would have been right to, given what the proof had found so far.

*Joint constraint abduction* sits between them. If an answer exists, enumeration will find it. What it lacks is a rule that says when to stop looking.
:::

### What is not settled {kind=limits}

Name four places where the essay marks a result as hard, a link as its own observation, or a question as open.

::: answer
- Final derivability is decidable for finite propositional premise sets and gets hard quickly beyond them: $\Sigma^0_3$-complete for some infinite decidable premise sets, and $\Pi^1_1$-complete for some recursive ones under Minimal Abnormality. Horsten and Welch had claimed the $\Sigma^0_3$ bound for Minimal Abnormality as well, and Verdée's result shows that it fails there.
- The coincidence of Minimal Abnormality with circumscription follows from the two definitions, but the authors have not found it stated as a theorem. It is literal only when the lower limit logic is classical or its models can be encoded classically.
- The authors have not found an earlier ASP encoding of adaptive logics.
- They have found no result in the adaptive-logic literature that bounds the size of conditions. Whether joint constraint abduction is decidable stays open, and a naive bound fails.
:::
