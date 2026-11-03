---
title: "Presumed Normal"
subtitle: "Adaptive logics, defeasible arguments and answer set programming: where a reasoner takes a conclusion back"
author: "Łukasz Stafiniak and Claude (Opus 5.5)"
date: 2026-10-31
header-includes:
  - |
    <style>
    .katex-display { overflow-x: auto; overflow-y: hidden; padding: 0.3em 0; }
    .katex-display > .katex { width: max-content; min-width: 100%; }
    article table { display: block; max-width: 100%; overflow-x: auto; }
    </style>
---

Suppose a body of information contains a contradiction somewhere, and we still want to reason with it. Here are five premises, with $\sim$ for negation:

$$
p,\qquad \sim p\lor r,\qquad q,\qquad \sim q\lor s,\qquad \sim p.
$$

Classical logic is no help. From $p$ and $\sim p$ every sentence follows, so $r$ and $s$ follow, and so do their negations. A paraconsistent logic blocks that explosion, but it pays elsewhere. In the paraconsistent logic CLuN, a sentence and its negation may both be true. So *disjunctive syllogism* fails: from $q$ and $\sim q\lor s$ we may not conclude $s$, since $q$ and $\sim q$ might both hold and make the disjunction true without $s$. CLuN gives us neither $r$ nor $s$.

Yet the premises treat $p$ and $q$ differently. They contradict themselves about $p$ and say nothing against $q$. A careful reader would conclude $s$ and withhold $r$. The adaptive logic ACLuN1, from [Diderik Batens's](https://doi.org/10.1007/s11787-006-0012-5) program, does exactly that, and the way it does so is worth watching. Here is a proof in it:

| Line | Formula | From | Condition |
|---:|:---|:---|:---|
| 1 | $p$ | premise | |
| 2 | $\sim p\lor r$ | premise | |
| 3 | $q$ | premise | |
| 4 | $\sim q\lor s$ | premise | |
| 5 | $r$ | 1, 2 | $\{p\land\sim p\}$ ✗ |
| 6 | $s$ | 3, 4 | $\{q\land\sim q\}$ |
| 7 | $\sim p$ | premise | |
| 8 | $p\land\sim p$ | 1, 7 | |

Line 5 records what CLuN does prove from lines 1 and 2: either $r$, or $p$ is contradictory. The adaptive rule writes the second disjunct as a condition. Line 5 reads "$r$, provided that $p\land\sim p$ is false". Line 6 is built the same way. At line 8 the condition of line 5 is derived outright, so line 5 is *marked*, which is what the ✗ shows, and $r$ no longer counts as derived. Nothing ever derives $q\land\sim q$, so line 6 stands.

The proof took back a conclusion it had drawn. The premises did not change between line 5 and line 8; the proof only grew. The premise $\sim p$ could have come first. But a proof records reasoning in progress, and reasoning in progress need not see everything at once. It draws on whatever it has so far.

Reasoning that withdraws conclusions is called *defeasible*. This essay follows where the withdrawal happens in four kinds of system: in the lines of a proof, in Batens's adaptive logics; in a graph of arguments, in John Pollock's theory of defeasible reasoning; in the extensions of an argumentation framework; and inside a solver, in answer set programming (ASP). The question that runs through them comes from [*What Must Be True?*](https://lukstafi.github.io/notes/what-must-be-true.html#the-open-question-is-whether-we-can-always-stop): when may a reasoner stop?

## A logic in three parts

Batens's [standard format](https://doi.org/10.1007/s11787-006-0012-5) builds an adaptive logic from three ingredients.

The first is a *lower limit logic*. It can be any of a wide range of monotonic logics, in which adding premises never removes conclusions. Classical logic qualifies, and so do intuitionistic, modal, relevant and paraconsistent logics. Everything the lower limit logic derives, the adaptive logic derives too, whatever else the premises say. In ACLuN1 the lower limit logic is CLuN.

The second is a set of *abnormalities*, formulas picked out by their logical form. They are presumed false unless the premises show otherwise. In ACLuN1 the abnormalities are contradictions, formulas of the form $A\land\sim A$.

The third is a *strategy*, which says what interpreting the premises "as normally as possible" amounts to. Two strategies are the most common, and they come apart below.

The lower limit logic, strengthened so that no abnormality can be true, is the *upper limit logic*. For ACLuN1 it is classical logic. An adaptive logic lies between its limits. When the premises are normal, as a consistent premise set is for ACLuN1, the adaptive logic delivers everything the upper limit logic does. When they are not, it falls back to the lower limit logic only where it has to, and the rest of the premise set keeps the upper limit's strength. That is the behaviour of the proof above: disjunctive syllogism was lost for $p$ and kept for $q$.

Premises can establish that something is abnormal without saying what. A disjunction of abnormalities is called a *Dab-formula*. Take these premises:

$$
p,\qquad q,\qquad \sim p\lor\sim q,\qquad \sim p\lor r,\qquad \sim q\lor r.
$$

They assert $p$ and $q$, add that at least one of them fails, and add that whichever fails, $r$ holds. CLuN derives the Dab-formula $(p\land\sim p)\lor(q\land\sim q)$ and nothing stronger: the premises are contradictory about $p$ or about $q$, and they do not say which. An adaptive proof can derive $r$ twice, once on the condition $\{p\land\sim p\}$, from the fourth premise, and once on the condition $\{q\land\sim q\}$, from the fifth.

**Reliability**, the older strategy, asks which abnormalities the premises implicate. A Dab-formula implicates each of its disjuncts as a possible culprit, but only when it is *minimal*: when no disjunction of a proper subset of its disjuncts is derivable as well. Minimality matters because any Dab-formula can be weakened by adding disjuncts. From $(p\land\sim p)\lor(q\land\sim q)$ follows $(p\land\sim p)\lor(q\land\sim q)\lor(s\land\sim s)$, and that says nothing against $s$. The abnormalities that occur in some minimal Dab-formula form the *unreliable set*, written $U(\Gamma)$ for premises $\Gamma$. Reliability presumes normal every abnormality outside $U(\Gamma)$ and refuses to presume anything about those inside it. Here $U(\Gamma)$ contains both contradictions. Each line for $r$ rests on an unreliable abnormality, so both lines are marked, and $r$ is not derived.

**Minimal Abnormality** looks at the ways the premises could be as normal as possible. One way makes only $p$ contradictory, and then the fifth premise, with $q$ consistent, gives $r$. The other makes only $q$ contradictory, and then the fourth premise gives $r$. Every minimally abnormal way of reading the premises contains $r$, so Minimal Abnormality derives it.

Both strategies have a semantics. Write $\mathrm{Ab}(M)$ for the set of abnormalities true in a model $M$ of the lower limit logic. Reliability keeps the models $M$ with $\mathrm{Ab}(M)\subseteq U(\Gamma)$: models that make true no abnormality the premises do not implicate. Among them, in the example, is a model in which both $p$ and $q$ are contradictory and $r$ is false, so $r$ does not follow. Minimal Abnormality keeps the models $M$ for which no other model $M'$ of the premises has $\mathrm{Ab}(M')\subset\mathrm{Ab}(M)$. A formula follows when it holds in all the models kept. Minimal Abnormality keeps fewer models, so it derives at least as much:

$$
\mathrm{Cn}_{\mathrm{LLL}}(\Gamma)\subseteq\mathrm{Cn}_{\mathrm{AL}^r}(\Gamma)\subseteq\mathrm{Cn}_{\mathrm{AL}^m}(\Gamma)\subseteq\mathrm{Cn}_{\mathrm{ULL}}(\Gamma).
$$

(Here $\mathrm{Cn}_{\mathrm{L}}(\Gamma)$ is the set of formulas that follow from $\Gamma$ in the logic L, and $\mathrm{AL}^r$ and $\mathrm{AL}^m$ are the adaptive logic under Reliability and under Minimal Abnormality.) For abnormal premise sets the inclusions are typically strict. The second inclusion is strict in the example above.

## Proofs that change their minds

A line of an adaptive proof has the usual parts, a formula and a justification, plus a condition: a set of abnormalities. Three rules add lines. A premise may be written down with an empty condition. The unconditional rule applies the lower limit logic: if $A_1,\dots,A_n$ derive $B$, then $B$ may be written with the union of their conditions. The conditional rule is the adaptive one: if $A_1,\dots,A_n$ derive $B\lor\mathrm{Dab}(\Theta)$, then $B$ may be written with the union of their conditions and $\Theta$ added. The condition says what has to be normal for the line to stand. Rewriting every line $B$ on condition $\Theta$ as $B\lor\mathrm{Dab}(\Theta)$ turns an adaptive proof back into a proof in the lower limit logic. The adaptive part of the logic lies entirely in the *marking definition*, which says which lines are marked at the current stage of the proof.

Under Reliability, a line is marked when its condition contains an abnormality that occurs in a minimal Dab-formula already derived on the empty condition. The Minimal Abnormality marking is more involved. Roughly, it marks a line for $A$ unless every minimal choice of abnormalities, one from each derived minimal Dab-formula, leaves some derivation of $A$ with its condition untouched. The two lines for $r$ in the second example meet that test, one for each choice.

Marking makes the proof dynamic in two ways. *External* dynamics is ordinary nonmonotonicity: adding a premise can remove a conclusion. *Internal* dynamics is what the first proof showed: with the premises fixed, a line can be marked, and later unmarked again, as the proof goes on. A line comes back when a shorter Dab-formula is derived and shows that some abnormality was suspected without cause. So derivability at a stage is not yet the consequence relation. A formula is *finally derived* on a line when the line is unmarked, and every extension of the proof that marks it can be extended further to unmark it. Final derivability is sound and complete for the semantics of the previous section.

Final derivability has no positive test. Whether a line stays unmarked depends on certain Dab-formulas *not* being derivable, and a proof can only establish that things are derivable. For finite propositional premise sets the question is decidable, as [Batens, De Clercq, Verdée and Meheus](https://doi.org/10.1007/s11229-007-9268-4) note. Beyond that it gets hard quickly. [Leon Horsten and Philip Welch](https://doi.org/10.1007/s11229-006-9049-5) showed that already for infinite but decidable propositional premise sets, final consequence can be $\Sigma^0_3$-complete. [Peter Verdée](https://doi.org/10.1007/s11229-007-9291-5) showed that for Minimal Abnormality, some recursive premise sets have $\Pi^1_1$-complete consequence sets. For comparison, theoremhood in first-order classical logic is $\Sigma^0_1$: a positive answer can always be confirmed by finding a proof.

> **Counting quantifiers.** The arithmetical hierarchy sorts problems by the quantifiers that their simplest definition needs in front of a decidable check $R$. A $\Sigma^0_1$ problem has the form "there is an $n$ such that $R(n)$". A yes is confirmed when a witness turns up, and a no may never be. Theoremhood is like this, with a proof as the witness. A $\Pi^0_1$ problem has the form "for every $n$, $R(n)$", and there a counterexample confirms a no. Each alternation of quantifiers adds a level. $\Sigma^0_2$ is "there is an $n$ such that for every $m$", $\Pi^0_2$ is "for every $n$ there is an $m$", and $\Sigma^0_3$ is "there is, for every, there is". From the second level up, in general neither answer can be confirmed by a finite computation. Under Reliability, final derivability has the $\Sigma^0_3$ shape: there is a stage at which the line is unmarked, such that every extension that marks it has a further extension that unmarks it.
>
> A problem is *complete* for a class when it belongs to the class and every problem in the class reduces to it. A complete problem cannot be defined with fewer alternations. A standard $\Sigma^0_3$-complete problem asks whether a program halts on all but finitely many inputs: there is a bound such that for every larger input there is a halting time.
>
> The superscript says what the quantifiers range over. With superscript 0 they range over numbers, or over finite objects coded by numbers, such as proofs. With superscript 1 they range over infinite objects, such as infinite sequences or sets of numbers. A $\Pi^1_1$ problem has the form "for every infinite sequence $f$ there is an $n$ such that $R(f,n)$". The standard complete example asks whether a computable tree has no infinite branch. Every problem in the arithmetical hierarchy, at any level, lies strictly below a $\Pi^1_1$-complete problem. Minimal Abnormality is defined by quantifying over models, and the set of abnormalities of a model can be infinite. Verdée's result shows that this quantifier cannot be traded for any number of quantifiers over finite proofs.

> **Where the third quantifier comes from.** Under Reliability, final derivability can be restated so that each quantifier has a visible job. $A$ is finally derivable from $\Gamma$ iff there is a finite condition $\Theta$ such that $A\lor\mathrm{Dab}(\Theta)$ is derivable in the lower limit logic and no member of $\Theta$ is in $U(\Gamma)$. The first clause is $\Sigma^0_1$, since a proof confirms it. Membership of $B$ in $U(\Gamma)$ is $\Sigma^0_2$. It says that some $\mathrm{Dab}(\Delta)$ with $B$ in $\Delta$ is derivable, and that $\mathrm{Dab}(\Delta')$ is not derivable for any of the finitely many proper subsets $\Delta'$ of $\Delta$. So "no member of $\Theta$ is in $U(\Gamma)$" is $\Pi^0_2$, and the whole statement is $\Sigma^0_3$.
>
> The outer quantifier chooses which derivation to trust. Take the premises $p$, $\sim p$, $\sim p\lor r$, $q$, $\sim q\lor r$. One derivation gives $r$ on the condition $\{p\land\sim p\}$, and another gives $r$ on $\{q\land\sim q\}$. Neither derivation has a redundant step, and neither condition contains the other. The first condition is unreliable, because $p\land\sim p$ is derivable outright. The second is reliable, so $r$ follows. With the premises $p$, $q$, $\sim p\lor\sim q$, $\sim p\lor r$, $\sim q\lor r$ the same two derivations exist, but both conditions are unreliable, and $r$ does not follow. Requiring every derivation of $r$ to survive would be too strong. Any condition can be enlarged with $p\land\sim p$, which gives a line for $r$ that stays marked forever.
>
> For a finite propositional premise set, only finitely many conditions are worth considering, and the choice is a finite disjunction. For an infinite premise set there can be infinitely many, and the quantifier does real work. Horsten and Welch's completeness result shows that it cannot be removed. If some normal form for proofs replaced the choice with a universal quantifier or with a computation, final derivability would be $\Pi^0_2$, and a $\Sigma^0_3$-complete set is not. Horsten and Welch had claimed the $\Sigma^0_3$ bound for Minimal Abnormality as well. Verdée's $\Pi^1_1$ result shows that it fails there.

What, then, is a stage of a proof worth? Batens answers that the stage is what a reasoner has, and it is not worthless. A proof's insight into the premises never decreases as the proof grows: even a marked line records something learned, namely which presumption failed. A stage is, in his words, "a fallible but sensible estimate" of what finally follows. Whether to keep proving or to rely on the present insight is a practical decision. Pollock, whose work comes next, says the same about agents: they have to act, and they cannot wait for reasoning that may never end.

> **A goal-directed procedure.** Batens also gave procedures that search for a proof of a given goal $G$ instead of deriving consequences blindly. In [one of them](https://arxiv.org/abs/cs/0207090), for propositional ACLuN1 under Reliability, each line carries two conditions: a *D-condition*, the subgoals still to be established, as in goal-directed proof search for classical logic, and an *A-condition*, the abnormalities. The procedure runs in three phases. In phase 1 it tries to derive $G$ on some condition $\Theta$. If it succeeds, phase 2 attacks that line: it tries to derive $\mathrm{Dab}(\Theta)$, the claim that some member of $\Theta$ is abnormal, itself on some condition $\Lambda$. If the attack succeeds, phase 3 counter-attacks: it tries to derive $\mathrm{Dab}(\Lambda)$ on the empty condition. A successful counter-attack defeats the attack, and the procedure looks for another. If no attack survives, $G$ is derived. If every line for $G$ falls, the procedure tries another derivation of $G$. When the search space runs out, $G$ is not derivable. For finite propositional premise sets it always halts, and Batens wrote a program that runs it. Argument, attack, counter-attack is the shape that Pollock's theory and argumentation frameworks make explicit.

## Generalizing and transferring

The format lets a logician choose the abnormalities. Two choices, studied in Batens's group, model reasoning that goes beyond its evidence on purpose.

**Induction.** In [Batens and Lieven Haesaert's logics of induction](https://users.ugent.be/~dbatens/publ/2001DLn_induct2.pdf) the lower limit logic is classical logic. An abnormality has the form $\exists A\land\exists\sim A$, where $A$ is a formula built from predicates and variables alone, with no constants, quantifiers or sentence letters, and $\exists$ binds all its free variables. Such a formula says that some things are $A$ and some are not. Presuming it false presumes the world uniform. The upper limit logic adds the axiom $\exists A\supset\forall A$: whatever holds of one thing holds of all.

Observe $Pa\land Qa$. Then something satisfies $Px\supset Qx$, so the conditional rule derives $\forall x(Px\supset Qx)$ on the condition $\{\exists(P\supset Q)\land\exists\sim(P\supset Q)\}$. Observe $Pb\land\sim Qb$ later, and the abnormality is derived on the empty condition. The generalization is marked. The logic proposes every generalization that the data do not refute and withdraws each one when a counterexample arrives. From the single observation of $a$, uniformity alone also proposes $\forall x\,Px$ and $\forall x\,Qx$: everything is $P$, and everything is $Q$.

Background knowledge enters as *background generalizations*. They are premises with priorities, and when observations contradict them jointly, those of lower priority give way first. A further variant, *pragmatic* background generalizations, keeps the instances of a generalization after the generalization itself is refuted. A refuted rule still licenses its predictions for cases not known to be exceptions. This is how people treat rules of thumb, and how a learned regularity often goes on being used after its first counterexample.

**Metaphor.** [Isabel D'Hanis](https://doi.org/10.1007/978-94-010-0550-0_2) built an adaptive logic for the analysis of metaphors of the form "$X$ is $Y$", where $X$ is the primary subject and $Y$ the secondary subject. A metaphor transfers structure: facts about $Y$ become facts about $X$, read non-literally. Her logic separates literal predicates from their non-literal counterparts. Its upper limit logic would replace every literal predicate with its non-literal one, so it would transfer everything. The adaptive logic transfers a fact on the condition that the fact's negation is not established for the primary subject, and it withdraws the transfer when the negation is derived.

Read "the atom is a solar system" this way. The planets orbit the sun, the sun is far more massive than the planets, and the planets attract one another. The first two transfer: electrons orbit the nucleus, and the nucleus is far more massive than the electrons. The third is withdrawn, because electrons are known to repel one another. The metaphor's content is what survives the primary subject's own facts.

[Another of her papers](https://www.logiqueetanalyse.be/archive/issues87-220/LA173-174-175/09Dhanis.pdf) moves from analysing metaphors to creating concepts with them. Several metaphors can share a subject. If the secondary subject of one is the primary subject of another, transfers chain, as in deduction. If two metaphors share a secondary subject, a common body of facts goes to two primary subjects. If they share a primary subject, several sources feed one poorly developed target, which D'Hanis calls "the most obvious way to create new ideas". Transfers from different sources can conflict. The logic settles conflicts with priorities, both for whole metaphors and for information within one, and the transfer with higher priority is kept.

Both logics treat a presumption as productive. Inductive generalization presumes that the world is uniform; analogical transfer presumes that the primary subject resembles the secondary one. Each projects far beyond what the premises establish, and each is held in check by the same mechanism, a condition that the premises can later falsify.

## Defeaters

John Pollock came to defeasible reasoning from epistemology, and in [his account](https://doi.org/10.1207/s15516709cog1104_4) the basic unit is a *prima facie reason*: a reason that supports a conclusion until something defeats it. Something looks red, so it is red. Defeaters come in two kinds. A *rebutting* defeater is a reason for the opposite conclusion: a reliable instrument reports that the object is not red. An *undercutting* defeater attacks the connection between reason and conclusion without supporting the opposite: the object is lit by red light, so its looking red says nothing about its colour.

In the adaptive format every defeat is an undercut. Deriving an abnormality removes a line's support without supporting the opposite conclusion: line 8 of the first proof showed that $p$ is contradictory, not that $r$ is false. Undercutters are common in perception and testimony. Learning that the witness was not at the scene gives no reason to think the event did not happen; it only removes the reason to think it did.

Arguments built from reasons and defeaters form an *inference graph*. An argument is defeated when an undefeated defeater attacks it. A defeated defeater no longer defeats anything, so the argument it attacked comes back: an argument against the red light reinstates the inference from looking red to being red. Whether a conclusion is *warranted*, supported by an argument that survives everything the premises can bring against it, requires knowing that no defeater exists. Like final derivability, warrant has no positive test in general. Pollock's architecture OSCAR therefore reasons with conclusions *justified* at the current stage, revises them as new arguments and defeaters are built, and acts on what it currently has. OSCAR searches both forward from what it knows and backward from what it is interested in, and its interests shape its investigation, much like Batens's goal-directed procedure in the box above.

[Phan Minh Dung](https://doi.org/10.1016/0004-3702(94)00041-X) abstracted away from what arguments are made of. An *argumentation framework* is a set of arguments with an attack relation, and its semantics says which sets of arguments, called *extensions*, a reasoner may accept together. A set is *conflict-free* when no two of its arguments attack each other, and *admissible* when it also defends each member against every attacker. A *naive* extension is a maximal conflict-free set, and a *preferred* extension is a maximal admissible set. A *stable* extension attacks every argument outside it. The *grounded* extension is the least set closed under defence: start from the unattacked arguments, add whatever they defend, and repeat. Dung showed that Pollock's system corresponds to grounded semantics. He also showed that the stable models of a logic program, the subject of the next section, correspond to stable extensions of a framework built from the program.

Adaptive logics fit into the same picture. [Jesse Heyninck and Christian Straßer](https://arxiv.org/abs/1604.00162) translated adaptive logics in the standard format into *assumption-based argumentation*, in which arguments are deductions from assumptions and an attack derives the negation of an assumption. The assumptions are the negations of abnormalities, that is, the normality presumptions. Under the naive, preferred and stable semantics, the two strategies differ in the order of two operations. Minimal Abnormality first derives conclusions from each extension separately and then keeps those that every extension yields, the *sceptical* conclusions. Reliability first intersects the extensions, keeping only the presumptions that all of them share, and then derives conclusions from that intersection. Deriving after intersecting yields less, because a conclusion may rest on different presumptions in different extensions. In the second example, one extension keeps the presumption that $p$ is consistent and the other keeps the presumption about $q$. Each extension derives $r$, so $r$ is sceptically accepted. Their intersection contains neither presumption, so Reliability does not derive $r$.

## Answer sets

A logic program reads like a set of definitions. In ASP, the rule

```
flies(X) :- bird(X), not ab(X).
```

says that a bird flies unless it is shown to be abnormal. The name `ab` is borrowed from [John McCarthy](https://doi.org/10.1016/0004-3702(86)90032-9), who proposed abnormality predicates in 1986 as the way to write defaults for circumscription. The `not` is *default negation*. `not ab(X)` holds when `ab(X)` cannot be derived. With the facts `bird(tweety)`, `bird(pingu)`, `penguin(pingu)` and the rule `ab(X) :- penguin(X)`, Tweety flies and Pingu does not.

"Cannot be derived" refers to the very set of conclusions the program is defining. [Michael Gelfond and Vladimir Lifschitz](https://www.cs.utexas.edu/~vl/papers/stable.ps) resolved the circularity with a guess and a check. Guess a set $X$ of atoms. Form the *reduct* of the program with respect to $X$: delete every rule with a literal `not a` for an atom $a$ in $X$, and delete the remaining `not` literals. The reduct has no negation, so it has a least model. $X$ is a *stable model*, or *answer set*, when that least model is $X$ itself. The guess about what is not derivable must reproduce itself.

The one-rule program `a :- not a.` has no stable model. Guess $\{a\}$, and the reduct deletes the rule, so its least model is empty. Guess $\emptyset$, and the reduct is the fact `a`, whose least model is $\{a\}$. Read classically, as $\sim a\supset a$, the rule has the model $\{a\}$. ASP rejects it because "$a$, since not $a$" is no derivation of $a$. Atoms in an answer set must be derived. Negative literals need only be true. That requirement gives ASP a constructive flavour.

The logic behind ASP is a constructive logic too. Stable models were generalized from programs to arbitrary propositional theories through [David Pearce's](https://doi.org/10.1007/BFb0023801) *equilibrium logic*. It rests on the *logic of here-and-there*, an intermediate logic between intuitionistic and classical logic, whose models have just two worlds. Its interpretations are pairs $(X,Y)$ with $X\subseteq Y$: atoms in $X$ are true *here*, atoms outside $Y$ are false *there*, and those in between are not yet settled. An *equilibrium model* is a total pair $(Y,Y)$ that satisfies the theory while no pair $(X,Y)$ with $X\subset Y$ does. The answer sets are exactly the $Y$ of the equilibrium models. Two programs are *strongly equivalent* when they have the same answer sets in every context, so that either can replace the other inside a larger program. [Lifschitz, Pearce and Agustín Valverde](https://doi.org/10.1145/383779.383783) proved that two programs are strongly equivalent exactly when they are equivalent in the logic of here-and-there.

> **Here-and-there as a truth table.** The logic of here-and-there is also Gödel's three-valued logic. A pair $(X,Y)$ gives each atom one of three values: 1 if it is in $X$, ½ if it is in $Y$ but not in $X$, and 0 if it is outside $Y$. Conjunction takes the minimum and disjunction the maximum. An implication $a\to b$ takes the value 1 when $a\le b$, and the value $b$ otherwise. Negation $\neg a$ abbreviates $a\to 0$, so $\neg\tfrac12 = 0$. A formula holds when it takes the value 1. Excluded middle fails: at $p=\tfrac12$, $p\lor\neg p$ takes the value ½. An equilibrium model is a valuation with no atom at ½ that satisfies the theory, such that lowering any nonempty set of its true atoms to ½ breaks it.
>
> The rule `a :- not a.` is the formula $\neg a\to a$. Classically it is equivalent to $a$, so $a=1$ satisfies it. Lowering $a$ to ½ gives $\neg\tfrac12\to\tfrac12 = 0\to\tfrac12 = 1$, so the formula still holds. Nothing forces $a$ to be true here, and $a=1$ is not an equilibrium model. The valuation $a=0$ fails the formula, since $\neg 0\to 0 = 1\to 0 = 0$. The program has no answer set, as the reduct showed above.
>
> The rule `a :- not not a.` is the formula $\neg\neg a\to a$. At $a=1$ it holds. Lowering $a$ to ½ gives $\neg\neg\tfrac12\to\tfrac12 = 1\to\tfrac12 = \tfrac12$, so the formula fails, and $a=1$ is an equilibrium model. At $a=0$ it holds with nothing to lower, so $a=0$ is one too. The answer sets are $\varnothing$ and $\{a\}$: the rule lets the solver guess $a$ either way. This is what the choice rule `{a}.` means, and the line `{ true(A) : atom(A) }.` in the clingo box makes one such guess per atom.

ASP's semantics matches the adaptive format closely. In both, a monotonic logic is followed by a selection of minimal models. The adaptive logic minimizes abnormality, and ASP minimizes truth itself, subject to the guess. Minimal Abnormality, in particular, coincides with McCarthy's circumscription. Batens's minimally abnormal models are the models of the premises whose sets of abnormalities are ⊆-minimal. Circumscribing the abnormalities, with every other symbol allowed to vary, selects the same models. Circumscription is defined over classical models, so the coincidence is literal when the lower limit logic is classical, or when its models can be encoded classically, as the box below does for CLuN. We have not found it stated as a theorem in the literature, but it follows from the two definitions. Since ASP can compute models that are minimal in chosen atoms, it can compute Minimal Abnormality directly.

> **Minimal Abnormality in clingo.** This program encodes the second example. It represents each sentence letter $A$ by two independent atoms, `true(A)` for $A$ and `neg(A)` for $\sim A$, at least one of which holds. That is CLuN's excluded middle without consistency. An abnormality is a letter with both.
>
> ```
> atom(p;q;r).
> { true(A) : atom(A) }.  { neg(A) : atom(A) }.
> :- atom(A), not true(A), not neg(A).
> ab(A) :- true(A), neg(A).
> % Premises: p, q, ~p v ~q, ~p v r, ~q v r.
> :- not true(p).
> :- not true(q).
> :- not neg(p), not neg(q).
> :- not neg(p), not true(r).
> :- not neg(q), not true(r).
> % Prefer ab(A) false, and enumerate subset-minimal sets of abnormalities.
> #heuristic ab(A) : atom(A). [1,false]
> #show ab/1.
> ```
>
> When the program is run with `clingo --heuristic=Domain --enum-mode=domRec 0`, clingo 5.8 reports two minimal sets of abnormalities, `ab(q)` and `ab(p)`. To ask whether $r$ follows, add the constraint `:- true(r).`, which keeps only the models without $r$. Among those models there is a single minimal set of abnormalities, `ab(p) ab(q)`, and it is not minimal for the premises as a whole. No minimally abnormal model lacks $r$, so Minimal Abnormality derives $r$. On the five premises from the opening, the same query for $r$ returns `ab(p)`, which is minimal, so $r$ is not derived, while the query for $s$ returns `ab(p) ab(q)`, so $s$ is. We have not found an earlier ASP encoding of adaptive logics. [Ofer Arieli](https://doi.org/10.1145/1243996.1244001) computed ACLuNs2, the Minimal Abnormality logic over a relative of CLuN, with solvers for quantified Boolean formulas.

The identification with circumscription also places the computational cost. Propositional circumscription is $\Pi^p_2$-complete, by [Thomas Eiter and Georg Gottlob](https://doi.org/10.1016/0304-3975(93)90073-3). So is cautious reasoning, truth in all answer sets, for disjunctive logic programs, [by the same authors](https://doi.org/10.1007/BF01536399). Arieli's paper places Minimal Abnormality for ACLuNs2-type logics in $\Pi^p_2$. In both cases, checking a candidate model is easy. Whether a conclusion holds in every minimal model asks, for every model, whether a smaller one exists: a universal quantifier over an existential one. That alternation puts the problem at the second level of the polynomial hierarchy. Under standard complexity assumptions, a single call to a satisfiability solver cannot settle such questions, and ASP solvers for disjunctive programs are built to.

## The solver keeps no proof

Modern ASP solvers search the way satisfiability solvers do. The [Potassco](https://doi.org/10.2200/S00457ED1V01Y201211AIM019) solver clasp assigns truth values one decision at a time, propagates what the program forces, and checks that every true atom has a derivation that does not rest on itself. When an assignment violates a constraint, clasp analyses the conflict and *learns a nogood*, a set of assignments that cannot hold together. Then it *backjumps*: it undoes decisions back to the point where the new nogood forces a different choice.

A learned nogood over abnormality atoms says that these abnormalities cannot all be false, which is a Dab-formula. Backjumping withdraws the conclusions that depended on the failed choices, as marking withdraws the lines whose conditions failed. Decades before ASP solvers, [Johan de Kleer's](https://doi.org/10.1016/0004-3702(86)90080-9) *assumption-based truth maintenance system* recorded each conclusion with the sets of assumptions under which it holds, and recorded inconsistent sets as nogoods. Batens's conditions are such sets, and his derived Dab-formulas are such nogoods.

So the dynamics did not disappear from ASP. It moved from the proof into the solver. The solver's search revises itself as an adaptive proof does, but its intermediate states are not results. A user gets answer sets, and the trail of assignments, conflicts and backjumps that produced them is not part of the answer. In an adaptive logic the proof is the result, and a stage of it is something a reasoner can use. ASP's optimization statements are a partial exception. They give each answer set a cost, the total weight of the atoms they count, and the solver reports answer sets of decreasing cost while it searches. Each is a stable model and can be used. The last is known to be optimal only once the search for a cheaper one has failed.

> **Abnormality with a price.** Weights turn a selection of models into a distribution over them. In [Markov logic](https://doi.org/10.1007/s10994-006-5833-1), Matthew Richardson and Pedro Domingos attach a weight to each first-order formula. A world that violates a formula is not excluded, only made less probable, by a factor that grows with the weight. A weighted formula is a presumption that can be broken at a price. [Joohyung Lee and Yi Wang](https://aaai.org/papers/16-12901-weighted-rules-under-the-stable-model-semantics/) carried the scheme into ASP as LP<sup>MLN</sup>, which assigns probabilities to stable models and into which Markov logic networks can be embedded. [plingo](https://arxiv.org/abs/2206.11515) implements it on top of clingo.
>
> Applied to abnormalities, weights extend the range of strategies. Reliability refuses to presume anything about the unreliable abnormalities. Minimal Abnormality keeps the models whose sets of abnormalities are ⊆-minimal. An optimization statement with a price on each abnormality keeps the models of least total price, which are also the most probable ones. Counting keeps every model and weighs it, and the probability of a conclusion is the weighted share of the models in which it holds.
>
> In the encoding of the clingo box, the second example has seven models. Give each model the weight $e^{-wk}$, where $k$ is its number of abnormalities. The only model in which $r$ fails has two abnormalities, those of $p$ and $q$. Two of the models in which $r$ holds have a single abnormality. With $w=0$ every model counts equally, and $r$ holds in six of the seven. With $w=2$ the probability of $r$ is about 0.95, and as $w$ grows it approaches 1, the verdict of Minimal Abnormality. In the limit the probability concentrates on the models of least total price. These are minimal by cardinality, not by inclusion, and in this example the two coincide.
>
> Counting answer sets is harder than finding one. clingo counts only by enumerating them. Dedicated counters such as [aspmc](https://doi.org/10.1016/j.artint.2024.104109), by Thomas Eiter, Markus Hecher and Rafael Kiesel, exploit the structure of the program to count without enumerating.
>
> The weight $w$ plays the part of an inverse temperature, and the gap between finding and counting is a gap between temperatures. In [*The Bookmaker Is a Learner*](https://lukstafi.github.io/notes/the-bookmaker-is-a-learner.html#the-combinatorial-wall), a bookmaker on a race finds the finishing order that would cost it most in polynomial time, while the probabilities it quotes are sums over all finishing orders, which are #P-hard to compute. The first problem is the second at zero temperature. Here, the limit $w\to\infty$ needs only the models of least total price, which an optimization statement finds. Any finite $w$ needs every model, weighted, which takes a count.

ASP obtains exact answers by being finite. A solver works on a ground program, with every variable replaced by ground terms, and grounding is where the difficulty of first-order reasoning goes. Over a finite domain, grounding can produce exponentially many rules, most of which never apply. With function symbols, the ground program can be infinite. ASP systems require *safe* rules, in which every variable occurs in a positive body literal, so that grounding can compute each rule's instances from atoms it has already found possibly derivable. Grounding terminates when that over-approximation is finite. When it is not, the grounder runs forever. The undecidability that adaptive logics expose in their proof theory, ASP excludes by staying within finite ground programs.

## Explanations as conditions

Batens's group built adaptive logics of abduction too. In [Joke Meheus and Batens's logic LAr](https://doi.org/10.1093/jigpal/jzk015), the lower limit logic is classical logic, the strategy is Reliability, and an abnormality has the form

$$
\forall\alpha\bigl(A(\alpha)\supset B(\alpha)\bigr)\land\bigl(B(\beta)\land\sim A(\beta)\bigr):
$$

an effect $B$ occurred while a cause $A$ sufficient for it did not. The presumption is that when an effect has occurred, its potential causes have too. Hypotheses are kept as weak as possible, and when several explanations compete, LAr abduces only their disjunction. [Tjerk Gauderis and Frederik Van De Putte's LA∀](https://doi.org/10.1387/theoria.4059) abduces generalizations instead of singular facts, again choosing the logically weakest and merging competitors into a disjunction. [Batens later argued](https://doi.org/10.1007/978-3-319-58507-9_8) that inferring the disjunction of the possible explanations is not abduction at all. His own logics derive statements of the form "$A(a)$ is a potential explanation of $E(a)$" and keep competing explanations apart.

There is a simpler way to see abduction in the adaptive format, and Heyninck and Straßer's translation, which treats normality presumptions as assumptions, makes it exact. A line for $G$ on condition $\Theta$ says that the premises derive $G\lor\mathrm{Dab}(\Theta)$. When the lower limit logic contains classical logic, that is the same as saying that the premises together with the hypothesis "every member of $\Theta$ is normal" entail $G$. A condition is a hypothesis under which the goal follows. It is consistent with the premises exactly when $\mathrm{Dab}(\Theta)$ is not derivable. The condition of an adaptive derivation of $G$ is an abductive answer for $G$, drawn from a fixed language of normality presumptions, and the strategies are policies for which answers to trust.

> **Joint constraint abduction as an adaptive problem.** [*What Must Be True?*](https://lukstafi.github.io/notes/what-must-be-true.html#finding-an-assumption-that-survives-every-case) studied a problem from type inference. Given cases $(D_i, C_i)$ of equations over finite trees, find a single conjunction of equations $A$ such that, for every case, $D_i\land A$ entails $C_i$ and $D_i\land A$ is consistent. Whether an algorithm can always decide that an answer exists is open. Recast in the terms above, $A$ plays the part of a condition, and three differences stand out.
>
> First, the problem is *joint*: one condition must serve several premise sets and goals at once. An adaptive proof works within one premise set, and each of the abduction logics above explains one explanandum at a time.
>
> Second, the acceptance test is *consistency* alone. An answer is rejected only when it makes some case inconsistent, the analogue of deriving $\mathrm{Dab}(\Theta)$ outright. Reliability demands more, since it rejects a condition when any of its members occurs in a disjunction of abnormalities. The weaker test suits a search for hypotheses, where incompatible candidates can stand side by side. Joint constraint abduction keeps incomparable answers apart, as Batens's 2017 logics keep competing explanations apart, and unlike LAr and LA∀, which merge them. Its preference for more general answers corresponds to a preference for smaller conditions, which depend on fewer presumptions.
>
> Third, the language of hypotheses is *open*. The answers are equations, they may introduce fresh variables, and their depth is unbounded. Nothing presumes them true in advance. The nearest adaptive analogues are the logic of induction and LA∀, whose hypotheses are generalizations of a given form, infinite in number. Batens's 2017 logics allow only explanations that ascribe a property to a single individual. LA∀ also admits relations between individuals, which joint constraint abduction needs: the answer $x\doteq y$ in the elementary example of *What Must Be True?* relates two variables.
>
> The recasting shows where the difficulty lies. In an adaptive logic, final derivability lacks a positive test because marking depends on what cannot be derived. For equations over finite trees, consistency is decided by unification, so marking is decidable, and the abduction problem has a positive test: enumerate candidate answers and check each one. Joint constraint abduction is adaptive derivability with decidable marking and unbounded conditions. Whether it is decidable turns entirely on whether the size of a needed condition can be bounded in terms of the input. We have found no result in the adaptive-logic literature that bounds the size of conditions, and the problem's [research notes](https://lukstafi.github.io/projects/jca/agent-collab/round-8-reassessment.html#the-bounded-verification-barrier-is-false-as-stated) record why a naive bound fails: a single premise $x\doteq y$ lets an answer's equations interact at any depth.

## Can we always stop?

There are three answers to the question from *What Must Be True?*.

ASP stops, because the search begins only after grounding has made the problem finite. The solver's withdrawals happen inside the search and leave no trace in the result. The price is paid in grounding, and a program with infinitely many possibly derivable atoms is outside what the solver can finish.

An adaptive logic need not stop, and it does not ask to. Final derivability can lie beyond every positive test, as warrant in Pollock's sense can. What the reasoner has at any time is a stage: the proof so far, with its marks. The first proof in this essay derived $r$ at line 5 and withdrew it at line 8. Before line 8 a reasoner would have acted on $r$, and would have been right to, given what the proof had found so far.

Joint constraint abduction sits between them. It has a positive test: if an answer exists, enumeration will find it. What it lacks is a rule that says when to stop looking. Its marking is as easy as ASP's checking, and its conditions are as open as those of an inductive logic.
