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

Classical logic is no help. From $p$ and $\sim p$ every sentence follows, so $r$ and $s$ follow, and so do their negations. A paraconsistent logic blocks that explosion, but it pays elsewhere. In the paraconsistent logic CLuN, a sentence and its negation may both be true, so *disjunctive syllogism* fails: from $q$ and $\sim q\lor s$ we may not conclude $s$, since $q$ and $\sim q$ might both hold and make the disjunction true without $s$. CLuN gives us neither $r$ nor $s$.

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

The proof took back a conclusion it had drawn. The premises did not change between line 5 and line 8; the proof only grew. The premise $\sim p$ could have come first, but a proof that records reasoning in progress need not see everything at once, and it can draw on whatever it has so far.

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

**Reliability**, the older strategy, treats every abnormality that occurs in a minimal Dab-formula as unreliable. Here both contradictions are unreliable, so both lines for $r$ are marked, and $r$ is not derived.

**Minimal Abnormality** looks at the ways the premises could be as normal as possible. One way makes only $p$ contradictory, and then the fifth premise, with $q$ consistent, gives $r$. The other makes only $q$ contradictory, and then the fourth premise gives $r$. Every minimally abnormal way of reading the premises contains $r$, so Minimal Abnormality derives it.

Both strategies have a semantics. Write $\mathrm{Ab}(M)$ for the set of abnormalities true in a model $M$ of the lower limit logic. Reliability keeps the models whose abnormalities all lie in the unreliable set. Minimal Abnormality keeps the models $M$ for which no other model $M'$ of the premises has $\mathrm{Ab}(M')\subset\mathrm{Ab}(M)$. A formula follows when it holds in all the models kept. Minimal Abnormality keeps fewer models, so it derives at least as much:

$$
\mathrm{Cn}_{\mathrm{LLL}}(\Gamma)\subseteq\mathrm{Cn}_{\mathrm{AL}^r}(\Gamma)\subseteq\mathrm{Cn}_{\mathrm{AL}^m}(\Gamma)\subseteq\mathrm{Cn}_{\mathrm{ULL}}(\Gamma).
$$

For abnormal premise sets the inclusions are typically strict. The second inclusion is strict in the example above.

## Proofs that change their minds

A line of an adaptive proof has the usual parts, a formula and a justification, plus a condition: a set of abnormalities. Three rules add lines. A premise may be written down with an empty condition. The unconditional rule applies the lower limit logic: if $A_1,\dots,A_n$ derive $B$, then $B$ may be written with the union of their conditions. The conditional rule is the adaptive one: if $A_1,\dots,A_n$ derive $B\lor\mathrm{Dab}(\Theta)$, then $B$ may be written with the union of their conditions and $\Theta$ added. The condition says what has to be normal for the line to stand. Rewriting every line $B$ on condition $\Theta$ as $B\lor\mathrm{Dab}(\Theta)$ turns an adaptive proof back into a proof in the lower limit logic. The adaptive part of the logic lies entirely in the *marking definition*, which says which lines are marked at the current stage of the proof.

Under Reliability, a line is marked when its condition contains an abnormality that occurs in a minimal Dab-formula already derived on the empty condition. The Minimal Abnormality marking is more involved. Roughly, it marks a line for $A$ unless every minimal choice of abnormalities, one from each derived minimal Dab-formula, leaves some derivation of $A$ with its condition untouched. The two lines for $r$ in the second example meet that test, one for each choice.

Marking makes the proof dynamic in two ways. *External* dynamics is ordinary nonmonotonicity: adding a premise can remove a conclusion. *Internal* dynamics is what the first proof showed: with the premises fixed, a line can be marked, and later unmarked again, as the proof goes on. A line comes back when a shorter Dab-formula is derived and shows that some abnormality was suspected without cause. So derivability at a stage is not yet the consequence relation. A formula is *finally derived* on a line when the line is unmarked, and every extension of the proof that marks it can be extended further to unmark it. Final derivability is sound and complete for the semantics of the previous section.

Final derivability has no positive test. Whether a line stays unmarked depends on certain Dab-formulas *not* being derivable, and a proof can only establish that things are derivable. For finite propositional premise sets the question is decidable, as [Batens, De Clercq, Verdée and Meheus](https://doi.org/10.1007/s11229-007-9268-4) note. Beyond that it gets hard quickly. [Leon Horsten and Philip Welch](https://doi.org/10.1007/s11229-006-9049-5) showed that already for infinite propositional premise sets, final consequence can be $\Sigma^0_3$-complete. [Peter Verdée](https://doi.org/10.1007/s11229-007-9291-5) showed that for Minimal Abnormality, some recursive premise sets have $\Pi^1_1$-complete consequence sets. For comparison, theoremhood in first-order classical logic is $\Sigma^0_1$: a positive answer can always be confirmed by finding a proof.

Batens's answer is that the stage is what a reasoner has, and it is not worthless. A proof's insight into the premises never decreases as the proof grows: even a marked line records something learned, namely which presumption failed. A stage is, in his words, "a fallible but sensible estimate" of what finally follows. Whether to keep proving or to rely on the present insight is a practical decision. Pollock, whose work comes next, says the same about agents: they have to act, and they cannot wait for reasoning that may never end.

> **A goal-directed procedure.** Batens also gave procedures that search for a proof of a given goal $G$ instead of deriving consequences blindly. In [one of them](https://arxiv.org/abs/cs/0207090), for propositional ACLuN1 under Reliability, each line carries two conditions: a *D-condition*, the subgoals still to be established, as in goal-directed proof search for classical logic, and an *A-condition*, the abnormalities. The procedure runs in three phases. In phase 1 it tries to derive $G$ on some condition $\Theta$. If it succeeds, phase 2 attacks that line: it tries to derive $\mathrm{Dab}(\Theta)$, the claim that some member of $\Theta$ is abnormal, itself on some condition $\Lambda$. If the attack succeeds, phase 3 counter-attacks: it tries to derive $\mathrm{Dab}(\Lambda)$ on the empty condition. A successful counter-attack defeats the attack, and the procedure looks for another. If no attack survives, $G$ is derived. If every line for $G$ falls, the procedure tries another derivation of $G$. When the search space runs out, $G$ is not derivable. For propositional premise sets it always halts, and Batens wrote a program that runs it. Argument, attack, counter-attack is the shape that Pollock's theory and argumentation frameworks make explicit.

## Generalizing and transferring

The format lets a logician choose the abnormalities. Two choices, studied in Batens's group, model reasoning that goes beyond its evidence on purpose.

**Induction.** In [Batens and Lieven Haesaert's logics of induction](https://users.ugent.be/~dbatens/publ/2001DLn_induct2.pdf) the lower limit logic is classical logic, and an abnormality has the form $\exists A\land\exists\sim A$, where $A$ is a formula built from predicates and variables alone, with no constants, quantifiers or sentence letters, and $\exists$ binds all its free variables. Such a formula says that some things are $A$ and some are not. Presuming it false presumes the world uniform. The upper limit logic adds the axiom $\exists A\supset\forall A$: whatever holds of one thing holds of all.

Observe $Pa\land Qa$. Then something satisfies $Px\supset Qx$, so the conditional rule derives $\forall x(Px\supset Qx)$ on the condition $\{\exists(P\supset Q)\land\exists\sim(P\supset Q)\}$. Observe $Pb\land\sim Qb$ later, and the abnormality is derived on the empty condition. The generalization is marked. The logic proposes every generalization that the data do not refute and withdraws each one when a counterexample arrives. From the single observation of $a$, uniformity alone also proposes $\forall x\,Px$ and $\forall x\,Qx$: everything is $P$, and everything is $Q$.

That structure comes from *background generalizations*. They enter as premises with priorities, and when observations contradict them jointly, those of lower priority give way first. A further variant, *pragmatic* background generalizations, keeps the instances of a generalization after the generalization itself is refuted. A refuted rule still licenses its predictions for cases not known to be exceptions. This is how people treat rules of thumb, and how a learned regularity often goes on being used after its first counterexample.

**Metaphor.** [Isabel D'Hanis](https://doi.org/10.1007/978-94-010-0550-0_2) built an adaptive logic for the analysis of metaphors of the form "$X$ is $Y$", where $X$ is the primary subject and $Y$ the secondary subject. A metaphor transfers structure: facts about $Y$ become facts about $X$, read non-literally. Her logic separates literal predicates from their non-literal counterparts. Its upper limit logic would replace every literal predicate with its non-literal one, so it would transfer everything. The adaptive logic transfers a fact on the condition that the fact's negation is not established for the primary subject, and it withdraws the transfer when the negation is derived.

Read "the atom is a solar system" this way. The planets orbit the sun, the sun is far more massive than the planets, and the planets attract one another. The first two transfer: electrons orbit the nucleus, and the nucleus is far more massive than the electrons. The third is withdrawn, because electrons are known to repel one another. The metaphor's content is what survives the primary subject's own facts.

[Another of her papers](https://www.logiqueetanalyse.be/archive/issues87-220/LA173-174-175/09Dhanis.pdf) moves from analysing metaphors to creating concepts with them. Several metaphors can share a subject. If the secondary subject of one is the primary subject of another, transfers chain, as in deduction. If two metaphors share a secondary subject, a common body of facts goes to two primary subjects. If they share a primary subject, several sources feed one poorly developed target, which D'Hanis calls "the most obvious way to create new ideas". Transfers from different sources can conflict. The logic settles conflicts with priorities, both for whole metaphors and for information within one, and the transfer with higher priority is kept.

Both logics treat a presumption as productive. Inductive generalization presumes that the world is uniform; analogical transfer presumes that the primary subject resembles the secondary one. Each projects far beyond what the premises establish, and each is held in check by the same mechanism, a condition that the premises can later falsify.

## Defeaters

John Pollock came to defeasible reasoning from epistemology, and in [his account](https://doi.org/10.1207/s15516709cog1104_4) the basic unit is a *prima facie reason*: a reason that supports a conclusion until something defeats it. Something looks red, so it is red. A defeater comes in two kinds. A *rebutting* defeater is a reason for the opposite conclusion: a reliable instrument reports that the object is not red. An *undercutting* defeater attacks the connection between reason and conclusion without supporting the opposite: the object is lit by red light, so its looking red says nothing about its colour.

In the adaptive format every defeat is an undercut. Deriving an abnormality removes a line's support without supporting the opposite conclusion: line 8 of the first proof showed that $p$ is contradictory, not that $r$ is false. Undercutters are also the more common kind in perception and testimony. Learning that the witness was not at the scene gives no reason to think the event did not happen; it only removes the reason to think it did.

Arguments built from reasons and defeaters form an *inference graph*. An argument is defeated when an undefeated defeater attacks it. A defeated defeater no longer defeats anything, so the argument it attacked comes back: an argument against the red light reinstates the inference from looking red to being red. Whether a conclusion is *warranted*, supported by an argument that survives everything the premises can bring against it, requires knowing that no defeater exists. Like final derivability, warrant has no positive test in general. Pollock's architecture OSCAR therefore reasons with conclusions *justified* at the current stage, revises them as new arguments and defeaters are built, and acts on what it currently has. OSCAR searches both forward from what it knows and backward from what it is interested in, and its interests shape its investigation, much like the goal-directed procedure of the previous box.

[Phan Minh Dung](https://doi.org/10.1016/0004-3702(94)00041-X) abstracted away from what arguments are made of. An *argumentation framework* is a set of arguments with an attack relation, and its semantics says which sets of arguments, called *extensions*, a reasoner may accept together. A set is *admissible* when no two of its arguments attack each other and it defends each member against every attacker. A *stable* extension attacks every argument outside it. The *grounded* extension is the least set closed under defence: start from the unattacked arguments, add whatever they defend, and repeat. Dung showed that Pollock's system corresponds to grounded semantics. He also showed that the stable models of a logic program, the subject of the next section, correspond to stable extensions of a framework built from the program.

Adaptive logics fit into the same picture. [Jesse Heyninck and Christian Straßer](https://arxiv.org/abs/1604.00162) translated adaptive logics in the standard format into *assumption-based argumentation*, in which arguments are deductions from assumptions and an attack derives the negation of an assumption. The assumptions are the negations of abnormalities, that is, the normality presumptions. Under the naive, preferred and stable semantics, the Minimal Abnormality consequences are the *sceptical* conclusions, those supported in every extension. The Reliability consequences are the conclusions derivable from the intersection of the extensions. The difference between the two strategies thus has a plain reading. Minimal Abnormality reasons inside each extension and keeps what they agree on. Reliability first discards every assumption that some extension rejects and then reasons with what remains. In the second example, one extension keeps the presumption that $p$ is consistent and the other keeps the presumption about $q$. Each extension derives $r$, so $r$ is sceptically accepted. Their intersection contains neither presumption, so Reliability does not derive $r$.

## Answer sets

A logic program reads like a set of definitions. In ASP, the rule

```
flies(X) :- bird(X), not ab(X).
```

says that a bird flies unless it is shown to be abnormal. The name `ab` is borrowed from [John McCarthy](https://doi.org/10.1016/0004-3702(86)90032-9), who proposed abnormality predicates in 1986 as the way to write defaults for circumscription. The `not` is *default negation*. `not ab(X)` holds when `ab(X)` cannot be derived. With the facts `bird(tweety)`, `bird(pingu)`, `penguin(pingu)` and the rule `ab(X) :- penguin(X)`, Tweety flies and Pingu does not.

"Cannot be derived" refers to the very set of conclusions the program is defining. [Michael Gelfond and Vladimir Lifschitz](https://www.cs.utexas.edu/~vl/papers/stable.ps) resolved the circularity with a guess and a check. Guess a set $X$ of atoms. Form the *reduct* of the program with respect to $X$: delete every rule with a literal `not a` for an atom $a$ in $X$, and delete the remaining `not` literals. The reduct has no negation, so it has a least model. $X$ is a *stable model*, or *answer set*, when that least model is $X$ itself. The guess about what is not derivable must reproduce itself.

The one-rule program `a :- not a.` has no stable model. Guess $\{a\}$, and the reduct deletes the rule, so its least model is empty. Guess $\emptyset$, and the reduct is the fact `a`, whose least model is $\{a\}$. Read classically, as $\sim a\supset a$, the rule has the model $\{a\}$. ASP rejects it because "$a$, since not $a$" is no derivation of $a$. Atoms in an answer set must be derived. Negative literals need only be true. This gives ASP a constructive flavour.

The logic behind ASP is a constructive logic too. Stable models were generalized from programs to arbitrary propositional theories through [David Pearce's](https://doi.org/10.1007/BFb0023801) *equilibrium logic*. It rests on the *logic of here-and-there*, an intermediate logic between intuitionistic and classical logic, whose models have just two worlds. Its interpretations are pairs $(X,Y)$ with $X\subseteq Y$: atoms in $X$ are true *here*, atoms outside $Y$ are false *there*, and those in between are not yet settled. An *equilibrium model* is a total pair $(Y,Y)$ that satisfies the theory while no pair $(X,Y)$ with $X\subset Y$ does. The answer sets are exactly the $Y$ of the equilibrium models. [Lifschitz, Pearce and Agustín Valverde](https://doi.org/10.1145/383779.383783) proved that two programs have the same answer sets in every context, which makes them interchangeable as parts of larger programs, exactly when they are equivalent in the logic of here-and-there.

The structure matches the adaptive format closely. In both, a monotonic logic is followed by a selection of minimal models. The adaptive logic minimizes abnormality, and ASP minimizes truth itself, subject to the guess. When the lower limit logic is classical, Minimal Abnormality is McCarthy's circumscription of the abnormalities, with everything else allowed to vary: Batens's minimally abnormal models are the models minimal in their abnormal part. We have not found this identification stated as a theorem in the literature, but it holds by the definitions. It means that ASP can compute Minimal Abnormality directly.

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
> Run with `clingo --heuristic=Domain --enum-mode=domRec 0`, clingo 5.8 reports two minimal sets of abnormalities, `ab(q)` and `ab(p)`. To ask whether $r$ follows, add the constraint `:- true(r).`, which keeps only the models without $r$. Among those models there is a single minimal set of abnormalities, `ab(p) ab(q)`, and it is not minimal for the premises as a whole. No minimally abnormal model lacks $r$, so Minimal Abnormality derives $r$. On the five premises from the opening, the same query for $r$ returns `ab(p)`, which is minimal, so $r$ is not derived, while the query for $s$ returns `ab(p) ab(q)`, so $s$ is. We have not found an earlier ASP encoding of adaptive logics. [Ofer Arieli](https://doi.org/10.1145/1243996.1244001) computed ACLuNs2, the Minimal Abnormality logic over a relative of CLuN, with solvers for quantified Boolean formulas.

The identification also places the computational cost. Propositional circumscription is $\Pi^p_2$-complete, by [Thomas Eiter and Georg Gottlob](https://doi.org/10.1016/0304-3975(93)90073-3). So is cautious reasoning, truth in all answer sets, for disjunctive logic programs, [by the same authors](https://doi.org/10.1007/BF01536399). Arieli's paper places Minimal Abnormality for ACLuNs2-type logics in $\Pi^p_2$. In both cases, checking a candidate model is easy, while confirming that no smaller model exists needs a universal quantifier over all of them. This is the second level of the polynomial hierarchy. Under standard complexity assumptions, a single call to a satisfiability solver cannot settle such questions, and ASP solvers for disjunctive programs are built to.

## The solver keeps no proof

Modern ASP solvers search the way satisfiability solvers do. The [Potassco](https://doi.org/10.2200/S00457ED1V01Y201211AIM019) solver clasp assigns truth values one decision at a time, propagates what the program forces, and checks that every true atom has a derivation that does not rest on itself. When an assignment violates a constraint, clasp analyses the conflict and *learns a nogood*, a set of assignments that cannot hold together. Then it *backjumps*: it undoes decisions back to the point where the new nogood forces a different choice.

A learned nogood over abnormality atoms says that these abnormalities cannot all be false, which is a Dab-formula. Backjumping withdraws the conclusions that depended on the failed choices, as marking withdraws the lines whose conditions failed. Decades before ASP solvers, [Johan de Kleer's](https://doi.org/10.1016/0004-3702(86)90080-9) *assumption-based truth maintenance system* recorded each conclusion with the sets of assumptions under which it holds, and recorded inconsistent sets as nogoods. Batens's conditions are such sets, and his derived Dab-formulas are such nogoods.

So the dynamics did not disappear from ASP. It moved from the proof into the solver. The solver's search revises itself as an adaptive proof does, but its intermediate states are not results. A user gets answer sets, and the trail of assignments, conflicts and backjumps that produced them is not part of the answer. In an adaptive logic the proof is the result, and a stage of it is something a reasoner can use. ASP's optimization statements are a partial exception: the solver reports a sequence of improving answer sets, each usable, while it searches for an optimal one.

ASP obtains exact answers by being finite. A solver works on a ground program, with every variable replaced by ground terms, and grounding is where the difficulty of first-order reasoning goes. Over a finite domain, grounding can produce exponentially many rules, most of which never apply. With function symbols, the ground program can be infinite. ASP systems require *safe* rules, in which every variable occurs in a positive body literal, so that grounding can compute each rule's instances from atoms it has already found possibly derivable. Grounding terminates when that over-approximation is finite. When it is not, the grounder runs forever. The undecidability that adaptive logics expose in their proof theory, ASP excludes by staying within finite ground programs.

## Explanations as conditions

Batens's group built adaptive logics of abduction too. In [Joke Meheus and Batens's logic LAr](https://doi.org/10.1093/jigpal/jzk015), the lower limit logic is classical logic, the strategy is Reliability, and an abnormality has the form

$$
\forall\alpha\bigl(A(\alpha)\supset B(\alpha)\bigr)\land\bigl(B(\beta)\land\sim A(\beta)\bigr):
$$

an effect $B$ occurred while a cause $A$ sufficient for it did not. The presumption is that when an effect has occurred, its potential causes have too. Hypotheses are kept as weak as possible, and when several explanations compete, LAr abduces only their disjunction. [Tjerk Gauderis and Frederik Van De Putte's LA∀](https://doi.org/10.1387/theoria.4059) abduces generalizations instead of singular facts, again choosing the logically weakest and merging competitors into a disjunction. [Batens later argued](https://doi.org/10.1007/978-3-319-58507-9_8) that inferring the disjunction of the possible explanations is not abduction at all. His own logics derive statements of the form "$A(a)$ is a potential explanation of $E(a)$" and keep competing explanations apart.

There is a simpler way to see abduction in the adaptive format, and Heyninck and Straßer's translation, which treats normality presumptions as assumptions, makes it exact. A line for $G$ on condition $\Theta$ says that the premises derive $G\lor\mathrm{Dab}(\Theta)$. When the lower limit logic contains classical logic, that is the same as saying that the premises together with the hypothesis "every member of $\Theta$ is normal" entail $G$. A condition is a hypothesis under which the goal follows. It is consistent with the premises exactly when $\mathrm{Dab}(\Theta)$ is not derivable. An adaptive derivation of $G$ is an abductive answer for $G$, drawn from a fixed language of normality presumptions, and the strategies are policies for which answers to trust.

> **Joint constraint abduction as an adaptive problem.** [*What Must Be True?*](https://lukstafi.github.io/notes/what-must-be-true.html#finding-an-assumption-that-survives-every-case) studied a problem from type inference. Given cases $(D_i, C_i)$ of equations over finite trees, find a single conjunction of equations $A$ such that, for every case, $D_i\land A$ entails $C_i$ and $D_i\land A$ is consistent. Whether an algorithm can always decide that an answer exists is open. Recast in the terms above, $A$ plays the part of a condition, and three differences stand out.
>
> First, the problem is *joint*: one condition must serve several premise sets and goals at once. An adaptive proof works within one premise set, and each of the abduction logics above explains one explanandum at a time.
>
> Second, the acceptance test is *consistency* alone. An answer is rejected only when it makes some case inconsistent, the analogue of deriving $\mathrm{Dab}(\Theta)$ outright. Reliability demands more, since it rejects a condition when any of its members occurs in a disjunction of abnormalities. The weaker test suits a search for hypotheses, where incompatible candidates can stand side by side. Joint constraint abduction keeps incomparable answers apart, as Batens's 2017 logics keep competing explanations apart, and unlike LAr and LA∀, which merge them. Its preference for more general answers corresponds to a preference for smaller conditions, which depend on fewer presumptions.
>
> Third, the language of hypotheses is *open*. The answers are equations, they may introduce fresh variables, and their depth is unbounded. Nothing presumes them true in advance. The nearest adaptive analogues are the logic of induction and LA∀, whose hypotheses are generalizations of a given form, infinite in number. LA∀ even admits relational formulas, and the answer $x\doteq y$ in that essay's example is a relation.
>
> The recasting shows where the difficulty lies. In an adaptive logic, final derivability lacks a positive test because marking depends on what cannot be derived. For equations over finite trees, consistency is decided by unification, so marking is decidable, and the abduction problem has a positive test: enumerate candidate answers and check each one. Joint constraint abduction is adaptive derivability with decidable marking and unbounded conditions. Whether it is decidable turns entirely on whether the size of a needed condition can be bounded in terms of the input. We have found no result in the adaptive-logic literature that bounds the size of conditions, and the problem's [research notes](https://lukstafi.github.io/projects/jca/agent-collab/round-8-reassessment.html#the-bounded-verification-barrier-is-false-as-stated) record why a naive bound fails: a single premise $x\doteq y$ lets an answer's equations interact at any depth.

## Can we always stop?

There are three answers to the question from *What Must Be True?*.

ASP stops, because the search begins only after grounding has made the problem finite. The solver's withdrawals happen inside the search and leave no trace in the result. The price is paid in grounding, and a program whose derivable atoms are infinite is outside what the solver can finish.

An adaptive logic need not stop, and it does not ask to. Final derivability can lie beyond every positive test, as it can for warrant in Pollock's sense. What the reasoner has at any time is a stage: the proof so far, with its marks. The first proof in this essay derived $r$ at line 5 and withdrew it at line 8. Before line 8 a reasoner would have acted on $r$, and would have been right to, given what the proof had found so far.

Joint constraint abduction sits between them. It has a positive test: if an answer exists, enumeration will find it. What it lacks is a rule that says when to stop looking. Its marking is as easy as ASP's checking, and its conditions are as open as those of an inductive logic.
