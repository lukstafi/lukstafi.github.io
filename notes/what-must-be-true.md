---
title: "What Must Be True?"
subtitle: "The Three Operations of Logic and the Search for Explanations"
author: "Łukasz Stafiniak and Codex"
date: 2026-09-21
---

> When you have eliminated the impossible, whatever remains, however improbable, must be the truth.

Sherlock Holmes's maxim appears in the defence slides for Łukasz's 2015 PhD thesis, *GADTs for Reconstruction of Invariants and Postconditions*. The thesis concerns programs that discover conditions under which other programs work correctly. The detective's question becomes a programmer's question: what missing relationship would make all these pieces fit?

There is a catch in the maxim. Eliminating possibilities identifies the truth only if the truth was among the possibilities considered, the eliminations were justified, and the survivors narrow down far enough. A detective can overlook the secret passage. Several explanations can survive. The remaining explanation can be the best one we have without being the last one we will ever need. Holmes speaks the maxim while investigating a locked room in [*The Sign of the Four*, chapter VI](https://dev.gutenberg.org/cache/epub/2097/pg2097-images.html); getting the possibilities right is part of the detective work.

Computer science lets us separate two difficulties that the maxim runs together. We can ask whether a proposed explanation works. We can also ask whether any suitable explanation exists. In a remarkably spare mathematical setting, the first question is efficiently decidable, while the second leads to a longstanding open problem. The difference persists even when facts, requirements, and proposed explanations are all written using the same kind of elementary equations.

That is already an interesting problem in logic. It also bears on a larger argument about AI. Erik Larson has argued that existing computational approaches miss abduction, the formation of explanatory hypotheses. David Deutsch has made a more productive challenge out of the creation of explanatory knowledge. Formal approaches give us grounds to resist sweeping exclusions, and equally good reasons to take the remaining difficulties seriously.

To see both, we need to bring three operations back together.

## Peirce's three operations

Charles Sanders Peirce distinguished **deduction, induction, and abduction**. His familiar example involves a bag of beans. Knowing a rule about the bag and knowing that some beans came from it lets us deduce something about those beans. Examining beans drawn from the bag can instead suggest a generalization about its contents. Finding beans with the relevant appearance can suggest that they came from that bag. The last two moves go beyond what their premises guarantee. Peirce called the third *hypothesis* in his [1878 essay “Deduction, Induction, and Hypothesis”](https://en.wikisource.org/wiki/Popular_Science_Monthly/Volume_13/August_1878/Illustrations_of_the_Logic_of_Science_VI).

The distinction gives us three questions. Given an account, what follows? Across these cases, what general relationship holds? What missing assumption would explain or establish this result?

Their cooperation matters as much as their difference. A proposed explanation gives deduction something to work on. Its consequences guide investigation. What we learn can support, modify, or defeat the proposal. In his [1903 lectures](https://www.unav.es/gep/OnThreeTypesReasoning.html), Peirce placed particular emphasis on induction as the experimental testing of a theory through its consequences. His account was richer than a diagram in which deduction goes forward and the other operations merely reverse arrows.

This three-way organization was an inspiration for the shape Łukasz's thesis took. Pei Wang's **Non-Axiomatic Logic**, developed as the logic of the Non-Axiomatic Reasoning System, or NARS, was an important computational example. Wang's [“Abduction in Non-Axiomatic Logic”](https://cis.temple.edu/~pwang/Publication/abduction.pdf) presents deduction, induction, and abduction within a common semantic framework. Its starting point is that a reasoning system must operate with insufficient knowledge and resources. It cannot assume that all relevant facts are available or that every promising inference can be completed before an answer is needed.

In Wang's account, beliefs carry degrees of evidential support and remain open to revision. A logic specifies inference rules; a control mechanism allocates attention and memory. *Non-axiomatic* concerns the revisable status of the knowledge being processed. It does not mean that the system lacks formal rules. Wang's [introduction to NARS](https://cis.temple.edu/~pwang/NARS-Intro.html) makes that distinction explicit. We need not accept every claim made for NARS to recognize the significance of the project: formal reasoning can be designed around incomplete information, defeasible conclusions, and limited resources.

The thesis pursued a different objective and a different standard of success. It sought guarantees about programs in a specified mathematical setting. Its inference system nevertheless involves all three operations if we understand induction here as **generalization**: obtaining common descriptions from cases. Deduction develops and checks consequences; generalization finds shared structure; abduction supplies conditions needed to make the account work.

This correspondence has limits. *Mathematical induction* is a deductive proof method, distinct from generalizing program cases. Generalization also covers only part of Peirce's later conception of experimental inquiry. The useful inheritance is the cooperation of operations with different jobs.

## Reading a contract out of the code

Consider a function that returns the first item of a list. Its ordinary type might say that it accepts a list of numbers and returns a number. Something important is missing: an empty list has no first item.

A more informative type records the list's length, *n*, and requires that *n* be at least one. This is a **precondition**, a promise the caller must keep. For a filtering function, the useful information runs the other way. If the input contains *n* items, the output contains some number *k* satisfying

$$0 \le k \le n.$$

This is a **postcondition**, a promise made by the function. We need not know the exact output length in advance. We can package the output together with the fact that such a length exists and obeys the bounds.

Both examples appear in the thesis's presentation. Its practical ambition was to reconstruct such information automatically from implementations. Programmers already express much of what a program does in its code. Requiring them to restate every structural fact in a separate specification makes verification harder to adopt and specifications harder to maintain. [The thesis](../projects/jca/lukstafi-phd-thesis.pdf) develops inference techniques and the InvarGenT implementation around this problem.

The title's *GADTs* are generalized algebraic data types. Their important feature here is that a data constructor can carry logical information. An empty list has length zero; adding an item increases the length by one. When a function examines which constructor it has received, it learns something about its input. Reasoning by cases in the program becomes reasoning by cases in the logic.

Filtering illustrates how the three operations cooperate. The empty-input case produces length zero. A recursive case filters the tail, then either keeps the current item or discards it. Suppose the tail has length *m* and its filtered result has length *j*. A candidate recursive contract tells us that *0 ≤ j ≤ m*. Deduction then calculates the possibilities: the result has length *j* or *j + 1*, while the original input has length *m + 1*. Both satisfy the proposed overall bound.

That calculation checks a candidate. An inference procedure also has to find it. Generalization collects descriptions of results into a common bound. Abduction finds the input conditions and relationships needed for the current proposed account to meet its obligations. Deduction checks implications and consistency throughout. The thesis organizes this work as an iteration, using base cases as a starting point and revisiting inferred preconditions and postconditions as information changes. This larger inference problem has its own [undecidability result](#what-recursion-adds), distinct from the open question about constraint abduction alone.

The division of labour can be stated simply:

| Operation | Its role in reconstructing a contract |
| --- | --- |
| Deduction | Work out consequences of the code, data declarations, and candidate contract; check the resulting obligations. |
| Induction, understood as generalization | Find a common description of the results of different cases. |
| Abduction | Find the missing conditions that let one contract satisfy the obligations across cases. |

The guarantee is about the properties the analysis expresses. A length bound for filtering does not by itself establish that the function retained precisely the items satisfying the predicate. That distinction will matter later, when we return to choosing the questions an inference system ought to answer.

The program's structure constrains what a successful contract can be. The three operations make that contract explicit.

## Finding an assumption that survives every case

Constraint abduction isolates one part of that interaction. Given available facts *D* and a requirement *C*, find a missing condition *A* such that

$$D \land A \models C.$$

Whenever the available facts and the proposed condition both hold, the requirement must hold too. We also require that *D* and *A* can hold together. Without that consistency condition, declaring the situation impossible would provide a cheap escape: a contradiction entails anything.

An abductive answer is a sufficient condition: it says what would make the requirement follow. It need not be the only possible condition, and the requirement alone does not establish that the proposed assumption is true.

The answer must have an appropriate form. If arbitrary formulas are allowed, we can encode the entire implication as the answer. A useful contract must instead speak in a language the type system can express, respecting the variables and dependencies available at that point. [Michael Maher's work on constraint abduction](https://doi.org/10.1109/LICS.2005.21) makes the choice of constraint language part of the problem.

For **joint constraint abduction**, the same *A* must work across several cases:

$$D_i \land A \models C_i \qquad\text{for every case }i.$$

Each *Dᵢ* together with *A* must also remain consistent. The answer cannot discard an inconvenient case by making it impossible. This is a condition of the particular mathematical problem studied here; a broader program analysis can handle genuinely unreachable code separately.

Here is a small example. Let *a* and *b* be distinct values. In one case, the fact is *x = a* and the requirement is *y = a*. In another, the fact is *x = b* and the requirement is *y = b*. A joint answer is simply

$$A:\quad x=y.$$

By contrast, solving the cases independently with the answers *y = a* and *y = b*, then combining those answers, gives a contradiction. The successful joint answer identifies a relationship that works in both cases, while allowing their values to differ.

Generality is valuable because an unnecessarily restrictive contract excludes valid uses. For the first-item function, requiring a hundred elements prevents the empty-list error but rules out many acceptable inputs. Requiring at least one is more useful. “Best explanation” in this setting often means avoiding unnecessary restrictions, rather than assigning the highest probability to a historical cause.

There need not be a unique best answer. Several contracts can be incomparable: each allows something another excludes. We should also distinguish finding *some* answer from finding a maximally general one, and both from representing *all* answers. Those are different computational problems, even when they arise from the same input.

## Keep the language fixed, change the question

How much harder is abduction than deduction? An answer is meaningful only after we say which logic and which task we are comparing. Deduction in an expressive logic can itself be extremely difficult or undecidable. Comparing unrestricted deduction with abduction over a tiny finite domain would tell us little about the difference between the operations.

We can make a much cleaner comparison. Fix a language containing two distinct constants, *a* and *b*, and one binary constructor, `pair`. Values are finite trees assembled from these pieces. A pair is equal to another pair exactly when their corresponding components are equal, and no pair equals either constant. These are structured values with fixed meanings, not arbitrary equations supplied as rewrite rules. The shape language is already rich enough to describe nested data structures and patterns of shared components.

Our constraints are finite conjunctions of equations. An answer may introduce fresh variables to express relationships, but it stays within this equational language. We temporarily leave arithmetic and the thesis's additional quantifier conditions aside. The full formal statement is in [the research notes' common equational core](../projects/jca/agent-collab/round-10-witness-generalization.html#the-common-equational-core).

First consider deduction: do equations *D* entail equations *C*? Suppose *D* says

$$x=\operatorname{pair}(y,b),\qquad y=a.$$

Then *x = pair(a,b)* follows. A unification algorithm makes the relationships explicit by finding the most general substitution satisfying *D*. For consistent *D*, a required equality follows precisely when its two sides become the same term under that substitution. Unbound variables represent remaining freedom; the requirement must hold for every way of filling it.

Unification detects clashes too. The constants *a* and *b* cannot be equal. A finite tree cannot equal a pair containing itself as a proper component. Detecting this latter failure is the purpose of the *occurs check*. We can therefore decide consistency as well as these implications.

These operations admit efficient algorithms. [Paterson and Wegman's linear-unification result](https://doi.org/10.1016/0022-0000(78)90043-0) is a classic reference. The representation matters: repeated subtrees should be shared, rather than expanded into an exponentially large printed tree. With an appropriate representation, the deduction checks at issue here take polynomial time: their worst-case cost is bounded by a fixed power of input size, the usual theoretical criterion of tractability.

Now give the checker an abductive candidate *A*. It checks the same kinds of conditions using *Dᵢ ∧ A*: consistency and implication, case by case. This is again efficient in the combined size of the problem and the supplied answer. We have not made the checking logic stronger merely by asking whether *A* is a good candidate.

What changes is that *A* may not be supplied. We must search for a finite relationship of an unknown shape and size, while making it satisfy every case. **Efficiently checking an explanation does not tell us how far we must search to find one—or when we may conclude that none exists.**

The complexity class **NP** consists of decision problems whose yes-answers have certificates of polynomially bounded size that can be checked efficiently. “Guess an answer and check it” puts a problem in NP only if such short certificates always suffice. An efficient checker alone provides no size bound.

## The open question is whether we can always stop

For one ordinary, unrestricted case, answer existence is easy: if *D ∧ C* is consistent, that conjunction itself supplies an answer. This observation says nothing about whether the answer is suitably general, or whether it satisfies extra restrictions on variables. But it makes the source of the joint problem especially clear. Several cases demand a common answer that preserves the possibility of each; conjoining all their individual solutions can destroy exactly that possibility.

The central question is whether there is an algorithm that always terminates and correctly says whether an ordinary joint equational answer exists. Maher identified the decidability status as unknown in his [2005 paper](https://doi.org/10.1109/LICS.2005.21). It remains unresolved in the thesis and subsequent research line we are following; we have not found a published resolution in the sources checked for this investigation. Our recent work establishes restricted results, not a general decision procedure or an undecidability proof.

We can already recognize positive instances eventually. Enumerate finite candidate answers, checking each in turn. If an answer exists, this search will eventually reach one. If none exists, the search can continue forever. Such a procedure is called a **semidecision procedure**. It can confirm success without necessarily recognizing failure.

We can even bound the time to success **in terms of the answer's size**. Fix a standard binary encoding of candidate constraints. If a shortest successful answer occupies *L* bits and the input occupies *N*, enumeration by increasing length finds an answer within

$$2^{O(L)}\operatorname{poly}(N+L)$$

time: there are fewer than $2^{L+1}$ binary strings of length at most *L*, and parsing and checking each candidate takes polynomial time. The algorithm need not know *L* beforehand. This counts the whole answer, including which variables repeat and any references to shared terms; counting only tree or graph nodes hides part of that encoding cost.

What we lack is a computable ceiling on *L* in terms of the input alone. Such a ceiling would let us reject an instance after exhausting the bounded search. This is the distinction between decidability and semidecidability, not just between a fast algorithm and a slow one. Every successful instance has a finite answer; that fact alone gives no effective stopping rule for unsuccessful instances.

Nor can we settle the question by pointing to undecidability results for richer type systems or superficially similar equation problems. A reduction has to preserve the exact meaning of the constraints and the admissible answers. Equations describing finite trees behave differently from equations allowed to rewrite terms. Restrictions on which variables a substitution may change also matter. A resemblance can suggest a proof strategy; it cannot substitute for the proof.

The thesis introduces further structure through quantifier prefixes and restrictions on how inferred terms depend on parameters. Those variants deserve their own analysis. A procedure for the simpler equational core would not automatically settle them. Keeping the core separate gives us a precise question on which to make progress, without presenting a restricted success as a complete solution to invariant inference.

## Where the difficulty first appears

A small example shows why bounding the search is subtle. Stay in the same language of two constants and finite pairs. We seek a relationship between four values, *x*, *y*, *u*, and *v*, satisfying two requirements:

1. Whenever *x = y*, it must follow that *u = a* and *v = b*. This case must be possible.
2. It must also be possible to have *u = b* and *v = a*.

The second requirement prevents the answer from fixing *u* permanently to *a* and *v* to *b*. A working answer is

$$x=\operatorname{pair}(u,v),\qquad y=\operatorname{pair}(a,b).$$

Now equality of *x* and *y* forces both component equalities. The swapped values remain possible; they make *x* different from *y*.

There were no pairs in the requirements. Pairs appear in the answer because they let one equality enforce two relationships at once. In the specified language of conjunctive equations, no answer using only variable-to-variable and variable-to-constant equalities can do this. Such a flat answer must leave *u* and *v* as separate unknowns, while one additional flat equality cannot fix both to different constants. The [full proof](../projects/jca/agent-collab/round-11-witness-bounds.html#two-constructor-free-branches-can-require-a-constructor-answer) also accounts for auxiliary variables.

A solver that looked only for structures already visible in the requirements would miss this answer. Yet the example does not invent a new primitive: pairing was available in the language from the outset. It illustrates a useful middle ground between selecting from an explicit list and inventing an entirely new conceptual vocabulary. Formal search can construct an organization the question never supplied.

The converse temptation also fails. Restricting inputs to shallowly nested terms might appear to simplify the general problem. But compound subterms can be given fresh names and their defining equations added to every case. Our [flattening result](../projects/jca/agent-collab/round-11-witness-bounds.html) shows, under the stated semantics, that depth-one input can represent the full ordinary problem. Shallow notation need not mean shallow difficulty.

A productive restriction turns out to lie elsewhere. If premises only test variables against *a* or *b*, and conclusions contain no constructors, our current research establishes a bounded search. If an answer exists, suitable examples using only the two constants suffice to recover one. Allowing a variable-to-variable premise already crosses the boundary illustrated above.

Even this restricted problem is **NP-complete**: it belongs to NP and is among that class's hardest problems. The proof encodes graph three-colouring, the task of assigning one of three colours to each vertex so that connected vertices differ. The unknown abductive answer must organize variables into at most three shared parameter classes, while consistency checks prevent adjacent vertices from occupying the same class. A proposed colouring is easy to check; finding a compatible global organization is the difficult part. The [note](../projects/jca/agent-collab/round-11-witness-bounds.html#a-decidable-constant-test-fragment) gives the reduction and the matching upper bound.

This gives a concrete comparison within the same constraint setting:

| Question | Status in the equational setting described here |
| --- | --- |
| Do given premises entail given conclusions? | Polynomial-time deduction checks. |
| Does this supplied answer work in every case? | Polynomial-time checking in the size of the instance and answer. |
| Does any joint answer exist in the constant-test fragment? | NP-complete in our current analysis. |
| Does any joint answer exist with general equational premises and conclusions? | Decidability remains unresolved in the research line discussed here. |

Unless P equals NP, the restricted existence problem already has no polynomial-time decision algorithm, despite the inexpensive deduction checks. The unrestricted problem inherits this lower bound. It might still be decidable by a much more expensive procedure; NP-hardness does not resolve that question.

There is a separate, published complexity result about generality. In [“On Computing Constraint Abduction Answers”](https://doi.org/10.1007/978-3-540-89439-1_30), Maher and Ge Huang prove that checking a proposed answer to a simple problem is linear-time in their quantifier-free formalism, while recognizing a maximally general answer is co-NP-complete. Verifying that an answer works and verifying that no strictly more general answer works are different tasks. Their result uses the paper's precise answer conventions; it should not be transferred indiscriminately to every variant with hidden variables or quantifier restrictions.

Our restricted existence theorem is a result recorded in the current notes, supported by written proofs, executable checks, and separate agent review. It is not a machine-checked proof or a claim of priority in the literature. Its role here is to exhibit the difficulty that jointness alone can introduce, while keeping the underlying deductive language simple.

## Can generalization tell us when to stop?

The three operations meet again in a possible route toward decidability. A result in [Round 10 of our research notes](../projects/jca/agent-collab/round-10-witness-generalization.html) reformulates ordinary equational answer existence using successful examples. Choose one fully specified assignment for each case, satisfying that case's premises and conclusions. Then compute the most specific common pattern of those assignments, preserving relationships across all their coordinates. Check whether that pattern is a joint answer.

If an answer exists, some choice of examples succeeds. The theorem does not say that arbitrary examples will do. Choices that look harmless one case at a time can lose the relationships needed by the others. But it reduces the number of examples we need to the number of cases.

The generalization operation is called **anti-unification**. The most specific common pattern of `pair(a,a)` and `pair(b,b)` is `pair(p,p)`. Their components agree, although the value changes between examples. The looser pattern `pair(p,q)` would lose that agreement. An implementation must remember repeated differences consistently, including across different components of an assignment.

The theorem works because a successful answer already covers at least one successful example from each case. Generalizing those selected examples as specifically as possible stays within that answer's permitted assignments, while retaining the examples that keep every case possible. Deduction then checks the resulting pattern. The search for the examples supplies the remaining abductive choice.

What remains unbounded is their size. One example per case sounds small, but each value in an example may be a large tree. The desired theorem would bound the size of some successful family by a computable function of the input's size. We could then exhaust the candidates up to that limit and correctly reject the problem if none worked.

In this fixed finite language, the existence of such a computable bound is equivalent to decidability. A bound gives a decision procedure by finite search. Conversely, a decision procedure would let us examine all inputs up to a given size, identify the solvable ones, run the successful searches, and compute a large enough bound for them. This converse matters: assuming an effective bound would effectively assume the result we are trying to prove.

The distinction between trees and shared representations matters here too. A short chain of equations can describe a tree that doubles in size at each step. Printing every occurrence may take exponentially more space than storing repeated subtrees once. Bounds on expanded tree size, shared representation size, depth, and answer size are different claims. A counterexample to one proposed bound need not defeat the others.

The research question has therefore become quite tangible. Can we prove a normalization or a bound that makes the unsuccessful searches recognizable? Can we represent the relevant sharing patterns by a finite structure without losing correctness? Or can this modest equational language encode an undecidable problem in the requirement for one answer to fit all cases?

We have ways to formulate the search, to check proposals, and to solve fragments. What we lack is the theorem that settles the unrestricted choice. That is a limitation of our present mathematical knowledge about a formal problem, not evidence that the problem cannot be formalized.

## What recursion adds

The inference problem for recursive programs is larger than an individual abduction problem. A recursive definition must support the assumptions made about its recursive calls. **Polymorphic recursion** allows those calls to use different instances of the function's general type: a function processing values of type *a* might recursively process lists of such values.

Unrestricted type inference allowing this feature is already undecidable. The connection is through *semi-unification*, a generalization of unification that also permits different instantiations at different uses. [Henglein's work](https://doi.org/10.1145/169701.169692) connects inference to semi-unification; [Kfoury, Tiuryn, and Urzyczyn](https://doi.org/10.1006/inco.1993.1003) established the latter's undecidability. The larger synthesis problem therefore contains an undecidable special case even before adding the thesis's richer constraints. This does not settle the separate abduction problem we isolated.

Yet Henglein also proves a striking positive result: **polymorphic-recursive inference with small typings is polynomial-time decidable**. Here a typing includes annotations throughout the program, not merely the type of its final result. More precisely, fix any polynomial bound on the size of a fully annotated program; deciding whether a suitable typing fits that bound takes polynomial time. The proof controls the growth of the inference procedure's constraint graph by the size of a successful typing. It yields a polynomial bound on successful inference in terms of the program and a complete typing, under the paper's representation. This concerns finding the typing, beyond checking one supplied in advance. [Henglein, §6.2, Theorem 8](https://suif.stanford.edu/~brm/reading/p253-henglein.pdf#page=33).

There is no contradiction with undecidability. If the size bound is exceeded, we have ruled out a small typing, not every typing. In this setting there can be no computable universal bound on the smallest successful typing in terms of program size: combined with checking and finite search, such a bound would decide the undecidable problem.

The contrast sharpens our question about abduction. In the constant-test fragment, polynomial-size answers already suffice, yet existence is NP-complete. Unless P equals NP, we cannot promise inference time polynomial in the input and the smallest answer's size even there. Polymorphic recursion illustrates difficulty caused by unbounded growth of the necessary typing. Joint abduction can additionally impose a hard choice among small answers.

## What Larson's objection misses

The distinction between formalization and decidability matters when reading Erik J. Larson's *The Myth of Artificial Intelligence*. Larson organizes much of his argument around deduction, induction, and abduction, treating the last as indispensable to human intelligence and inadequately understood in AI. His introduction explicitly treats the possibility of human-level AI as an open scientific question. The myth he attacks is its supposed inevitability. Calling this an impossibility theorem would misrepresent the book. [Larson, 2021, introduction](https://www.jstor.org/stable/j.ctv322v43j).

His stronger exclusion appears in his treatment of computational approaches. In a [2021 interview](https://bdtechtalks.com/2021/09/20/myth-of-artificial-intelligence-erik-larson/amp/), he dismisses abductive logic programming as a reformulation of deductive machinery. He says that “the three types of inference are formally distinct, so they don’t reduce to each other and can’t be combined to get a third.” In [a 2025 research proposal](https://erikjlarson.substack.com/p/the-new-cybernetics), he similarly describes language models' apparent abduction as simulation, while advocating richer human–machine feedback.

The objection to logic programming confuses an inference's role with its implementation. A computational procedure can construct assumptions, test their consequences by deduction, and return assumptions that survive. Its implementation in a logical language does not make those assumptions deductive consequences of the original evidence. The procedure preserves the distinction between what was given, what was hypothesized, and what follows conditionally.

This distinction was explicit in [Kakas, Kowalski, and Toni's work on abductive logic programming](https://www.doc.ic.ac.uk/~rak/papers/abdsurv.pdf). [Toni and Kowalski's reduction of an abductive formalism to normal logic programs](https://www.doc.ic.ac.uk/~rak/papers/reduction.pdf) studies when the relevant semantics are preserved. An implementation correspondence can explain how the abductive operation is performed. It does not erase the operation.

Our complexity comparison helps locate the mistake. A checker for *D ∧ A ⊨ C* is not automatically a solver for the unknown *A*. Discovering an algorithm that uses checking to organize search would be a substantive computational achievement. It would not show that abduction had secretly been deduction all along. Conversely, failing to find a terminating search procedure does not show that no computational treatment of abduction exists.

The elementary example *x = y* makes the epistemic difference plain. It is an assumption that connects two cases, not a consequence that either case's premises already guaranteed. The pairing example goes further by assembling structure absent from the requirements. Both have precise success conditions. To exclude them from abduction, one needs a substantive account of the additional capacity being demanded, rather than a rule that disqualifies anything once its computation has been explained.

Wang's work makes another useful distinction visible. A system can formalize defeasible reasoning without treating its acquired beliefs as axioms. The choice is not exhausted by classical theorem proving on one side and an unformalizable faculty of insight on the other. There are explicit proposals about evidence, revision, and resource allocation to examine. Their empirical success and their limits are legitimate subjects for criticism.

There is a parallel mistake in moving directly from “trained to predict” to “incapable of conjecturing.” A training objective describes how a system is trained; it does not, by itself, characterize every computation the resulting system can perform. Whether a particular trained system generates and tests useful hypotheses requires evidence about that system. This removes an automatic disqualification without providing an automatic entitlement to intelligence.

None of these arguments claims that constraint abduction reproduces the full scope of human explanation. Larson can demand a stronger capacity: proposing fruitful accounts while choosing relevant information and revising the representation itself. That is a serious demand. It concerns the scope and effectiveness of methods, rather than the non-formalizability of abduction as such.

## Deutsch's more productive challenge

David Deutsch's [2012 essay “Creative blocks”](https://aeon.co/essays/how-close-are-we-to-creating-artificial-intelligence) gives that demand a more productive form. He argues that artificial general intelligence is physically possible while identifying the central missing account as one of creating explanatory knowledge. Following Popper, he emphasizes conjecture and criticism: observations do not uniquely dictate their explanation. The obstacle concerns the process of creating knowledge, rather than a privileged biological material. This is a historical statement of his argument, not a report of his latest assessment of particular models.

We agree that fitting observations is insufficient. Two programs can reproduce every example in a test suite while supporting very different expectations outside it. One may express a general relationship; another may be a collection of special cases. We want to understand what supports the successful generalization and which failures would expose its limits.

Formal abduction makes part of that question precise. An answer succeeds relative to a specified model, constraint language, and collection of obligations. It can be a perfect answer to that problem and an inadequate explanation of what motivated it. A filter's length bound can hold even if it retains the wrong elements. A researcher or user still has to choose a property that bears on the real concern.

But the failure of observations to *logically determine* an explanation does not imply that an algorithm cannot *propose* one. Proposal is precisely the step that need not guarantee truth. A process may be selective, inventive, and fallible at once. The question is how its proposals become better through criticism, counterexamples, and further experience.

Deutsch's further insistence that an adequate philosophical account must precede successful engineering is a separate claim, and we find it unpersuasive. A method and a theory of that method can develop together. We can investigate which systems revise hypotheses successfully before possessing a complete theory of creativity. Building and studying such systems can help produce the theory.

An earlier essay, [“What Breadth Reaches”](what-breadth-reaches.html), approached Deutsch through the question of knowledge creation. Classifying training as induction does not settle whether the resulting system can conjecture, deduce, and correct itself. Its performance and reliability require investigation.

## When the framing itself becomes a hypothesis

A fixed formal language need not contain a fixed list of answers. A finite grammar can describe infinitely many structures; a programming language can describe programs its designers never wrote. Constraint abduction already requires this distinction. Its candidate answers are finite, but there may be no known effective limit on the structures worth considering.

There is nevertheless a further capacity beyond assembling expressions in an available vocabulary: introducing a more useful vocabulary, changing what is held fixed, or recognizing that the current question misses the phenomenon. A length analysis will not reveal that a filter preserves the wrong ordering. A scientific theory may need a quantity the existing model does not represent. A mathematical investigation may need to distinguish expanded trees from shared representations before its complexity claims make sense.

Changing a representation does not automatically require leaving computation. Programs can introduce definitions, construct programs, and treat candidate theories as data. A fixed computational framework can support revisions to theories expressed within it. What remains difficult is choosing revisions that are productive. Universal expressive power supplies no adequate account of why a researcher investigates one explanation rather than a billion irrelevant alternatives.

Consider a filter that returns no items when its user expected several. Its length contract may be perfectly satisfied. The defect may concern the predicate, the encoding of the input, or the user's understanding of the data. An investigation might inspect an example, ask which item should have survived, run the predicate separately, and discover that dates are being compared as text.

Each step can create a bounded subproblem with a definite check. The inquiry also decides which subproblem is worth creating. New evidence can alter that decision: a failed test might demand another implementation, or reveal that the test expresses the wrong requirement. The freedom to revise the setup brings additional opportunities for progress and additional ways to go wrong.

For an open-ended reasoning system, at least three achievements need to be distinguished: generating admissible hypotheses; selecting and testing promising ones under a resource budget; and revising the framing that determines which hypotheses are relevant. Success at one does not imply general mastery of the others. Failure at the third does not make the first two fictitious.

Larson's recent emphasis on surprise comes closer to this distinction. The public opening of his [March 2026 essay](https://erikjlarson.substack.com/p/language-models-and-the-problem-of) describes unexpected evidence as a reason to reconsider underlying assumptions. We can turn that into concrete questions. Does a system notice a prediction failure, identify the assumption responsible, change its working account, and carry the correction into subsequent work? Whether it also has a subjective experience of surprise is a further question, which those operational tests alone do not answer.

The quality of correction matters. A system can accommodate every failure by adding an exception, or change its explanation whenever challenged without preserving the constraints that earlier evidence established. Revision becomes useful when it improves the account while retaining what still has support. The analogue of jointness reappears: a new explanation must answer to more than the latest piece of evidence.

## Reasoning about the reasoner

*Codex:* There is a modest example in the collaboration that prompted this article. Łukasz asked me to investigate the joint-abduction problem with subagents and a twenty-minute stopping point. We considered simplifying restrictions, proposed bounds, searched for counterexamples, and revised the promising directions. The distinction between shallow input and a genuinely easier fragment emerged from that process. The [research note](../projects/jca/agent-collab/round-11-witness-bounds.html) and [separate proof review](../projects/jca/agent-collab/reviews/round-11-proof-review.html) make the resulting claims inspectable.

This was reasoning *about* abduction: choosing lemmas, testing conjectures, and changing direction in response to mathematical objections. The resulting artifacts make that process of conjecture and correction inspectable.

It is not a controlled test of originality. The session cannot establish which ideas were absent from training data or new to the literature. Its written proofs remain subject to scrutiny, and its finite experiments do not prove unrestricted claims. The general decision problem was not solved.

The unit doing the work also matters. It included a human choice of problem, existing research, several model instances, executable checks, written arguments, and review. Those capacities belong to that arrangement; attributing them indiscriminately to an isolated model or a persistent autonomous researcher would obscure how the work was done. [“Which AGI?”](which-agi.html) develops this distinction between a model and a deployment.

A fluent account of revising a belief is weaker evidence than a revised artifact that survives further checks. Do corrections persist? Do errors recur in related situations? Can the system select useful tests before a human identifies the important assumption?

## What remains possible

*Together:* The mathematical and philosophical questions now meet at a useful point. Formalization tells us what counts as an answer. A decision procedure would tell us whether an answer exists for every input. An efficient procedure would make that decision affordable. A capable investigator must additionally choose fruitful questions and representations, use evidence well, and retain corrections. These are distinct achievements.

The unresolved decidability question gives the article's title two readings. Within a program analysis, we ask what must be true for the obligations to hold. In our own inquiry, we ask what would have to be proved before we could promise that the search will always end.

Even a future undecidability result would not establish that abduction lies beyond formal treatment. It would establish a precise limit on a universally correct, terminating algorithm for the specified task. Formal definitions, useful restricted procedures, and fallible search would remain possible. Human ingenuity would not be exempt from the result merely by being human; a claim of exemption would need its own argument.

Likewise, a future decidability proof would not complete a theory of scientific creativity. We would still need to understand effective search, useful representations, the choice of problems, and the relation between formal guarantees and the world. Wang's attention to insufficient knowledge and resources keeps those concerns in view. Peirce's three operations remind us that progress depends on their interaction.

For constraint abduction, the research agenda is to find bounds, normal forms, or reductions that settle where terminating search is possible. For open-ended reasoning systems, it is to build and test mechanisms that select hypotheses, expose them to criticism, revise the setup when needed, and preserve what the criticism has taught them.

Holmes's maxim begins after the possibilities have somehow been assembled. A theory of inquiry must also account for assembling them, discovering omissions, and deciding when an apparent impossibility was our own mistake. Elimination matters. So does learning what to put on the list.
