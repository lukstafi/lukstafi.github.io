---
title: "Study notes: What Must Be True?"
essay: what-must-be-true
track: which-intelligence
reviewed-against: "75d8bc6"
requires:
  - {at: which-agi#three-grains-three-thresholds, for: "the difference between a model and a deployment, which the essay applies to its own collaboration", strength: helpful}
  - {at: what-breadth-reaches, for: "an earlier approach to Deutsch through the question of knowledge creation", strength: helpful}
introduces:
  - {term: "deduction, generalization and abduction", at: peirces-three-operations, gloss: "Peirce's three operations as the thesis uses them: work out consequences, find a common description of cases, supply the missing condition"}
  - {term: precondition and postcondition, at: reading-a-contract-out-of-the-code}
  - {term: joint constraint abduction, at: finding-an-assumption-that-survives-every-case, gloss: "find one condition $A$ with $D_i\\land A\\models C_i$ for every case $i$, each $D_i\\land A$ consistent"}
  - {term: semidecision procedure, at: the-open-question-is-whether-we-can-always-stop}
  - {term: constant-test fragment, at: where-the-difficulty-first-appears, gloss: "premises only test variables against the two constants, and conclusions contain no constructors"}
  - {term: anti-unification, at: can-generalization-tell-us-when-to-stop}
  - {term: three achievements of an open-ended reasoner, at: when-the-framing-itself-becomes-a-hypothesis, gloss: "generating admissible hypotheses, selecting and testing them under a budget, revising the framing"}
uses:
  - {term: "process, deployment and lineage", from: which-agi}
---

### The catch in the maxim {kind=explain}

"When you have eliminated the impossible, whatever remains, however improbable, must be the truth." Under which three conditions does elimination identify the truth? Which two difficulties does the maxim run together, and how do they come apart in the essay's equational setting?

::: answer
The truth must have been among the possibilities considered, the eliminations must have been justified, and the survivors must narrow down far enough. The two difficulties are whether a proposed explanation works and whether any suitable explanation exists. In the equational setting the first is efficiently decidable and the second leads to a longstanding open problem, although facts, requirements and explanations are all written as the same kind of elementary equations.
:::

### Three operations, three questions {kind=state at=peirces-three-operations}

State the question each of Peirce's three operations answers. How does the thesis read induction, and where does the essay say the correspondence with Peirce stops?

::: answer
Deduction: given an account, what follows? Induction: across these cases, what general relationship holds? Abduction: what missing assumption would explain or establish this result? The thesis reads induction as generalization, obtaining common descriptions from cases. The correspondence has limits. Mathematical induction is a deductive proof method and not this. Generalization covers only part of Peirce's later conception of induction as the experimental testing of a theory. The useful inheritance is the cooperation of operations with different jobs.
:::

### The filter's contract {kind=compute at=reading-a-contract-out-of-the-code}

A filter's candidate postcondition says that an input of length $n$ gives an output of length $k$ with $0\le k\le n$. In the recursive case the tail has length $m$ and its filtered result has length $j$. Check the candidate. Which operation did you just perform, and what do the other two contribute? What does the bound not establish?

::: answer
The recursive contract gives $0\le j\le m$. The result has length $j$ or $j+1$ and the input has length $m+1$. Both satisfy the bound: $0\le j\le m<m+1$ and $0<j+1\le m+1$. The empty case gives $0\le0\le0$. That was deduction, checking a candidate. Generalization collects the results of the cases into a common bound. Abduction finds the input conditions that let one contract meet its obligations across cases. The bound does not establish that the function kept precisely the items satisfying the predicate.
:::

### One assumption for every case {kind=compute at=finding-an-assumption-that-survives-every-case}

State joint constraint abduction, including the consistency condition and what it is for. Then solve: $a$ and $b$ are distinct values; in one case the fact is $x=a$ and the requirement $y=a$, in the other the fact is $x=b$ and the requirement $y=b$. Why does solving the cases separately fail? What does "best" mean for an answer here?

::: answer
Find $A$ such that $D_i\land A\models C_i$ for every case $i$, with each $D_i\land A$ consistent. Without consistency, declaring a case impossible would be a cheap escape, since a contradiction entails anything. The joint answer is $x=y$: with $x=a$ it gives $y=a$, with $x=b$ it gives $y=b$, and it is consistent with both facts. The separate answers $y=a$ and $y=b$ contradict each other when combined. "Best" often means avoiding unnecessary restrictions, since a restrictive contract excludes valid uses. There need not be a unique best answer: several can be incomparable.
:::

### Same language, different question {kind=compute at=keep-the-language-fixed-change-the-question}

The language has constants $a$, $b$ and a constructor $\operatorname{pair}$ over finite trees. Let $D$ be $x=\operatorname{pair}(y,b)$, $y=a$. Does $D$ entail $x=\operatorname{pair}(a,b)$? Does it entail $x=\operatorname{pair}(y,y)$? Which two kinds of inconsistency does unification detect? What changes when the question becomes abductive, and why does an efficient checker not put the problem in NP?

::: answer
The most general substitution satisfying $D$ sends $y$ to $a$ and $x$ to $\operatorname{pair}(a,b)$. Under it the first equation has identical sides, so it is entailed. The second becomes $\operatorname{pair}(a,b)=\operatorname{pair}(a,a)$, which is not an identity, so it is not entailed. Unification detects a clash of distinct constructors or constants, and by the occurs check a tree equated with a pair that contains it. Checking a supplied $A$ uses the same polynomial-time tests on $D_i\land A$. What changes is that $A$ may not be supplied: it has unknown shape and size. A problem is in NP only if short certificates always suffice, and an efficient checker alone gives no size bound.
:::

### Stopping {kind=derive at=the-open-question-is-whether-we-can-always-stop}

Why is answer existence easy for a single unrestricted case? For the joint problem, derive a bound on the time enumeration takes to find an answer whose shortest encoding has $L$ bits, on an input of $N$ bits. What is missing for a decision procedure?

::: answer
For one case, if $D\land C$ is consistent it is itself an answer. With several cases, conjoining the individual solutions can make a case impossible. Enumerate candidates by increasing length. There are fewer than $2^{L+1}$ binary strings of length at most $L$, and parsing and checking each takes polynomial time, so success comes within $2^{O(L)}\operatorname{poly}(N+L)$. The procedure need not know $L$. This is a semidecision procedure: it confirms success and may run forever on failure. What is missing is a computable ceiling on $L$ in terms of the input alone, which would let the search reject. Maher identified the decidability status as unknown in 2005, and the authors have found no published resolution.
:::

### An answer with structure the question lacked {kind=case at=where-the-difficulty-first-appears}

Find a relationship among $x,y,u,v$ such that whenever $x=y$ it follows that $u=a$ and $v=b$, this case is possible, and $u=b$, $v=a$ is also possible. Verify the essay's answer. Why can no flat answer work, and what does the example show about formal search?

::: answer
The answer is $x=\operatorname{pair}(u,v)$, $y=\operatorname{pair}(a,b)$. If $x=y$ then $\operatorname{pair}(u,v)=\operatorname{pair}(a,b)$, and pairs are equal exactly when their components are, so $u=a$ and $v=b$. With $u=b$, $v=a$ we get $x=\operatorname{pair}(b,a)\ne y$, which is consistent. A flat answer, using only variable-to-variable and variable-to-constant equalities, must leave $u$ and $v$ as separate unknowns to allow the swap, and the one added equality $x=y$ cannot then fix both to different constants. The requirements contained no pairs. Search constructed an organization the question never supplied, without inventing a new primitive: pairing was in the language from the outset.
:::

### Four questions, four statuses {kind=recall at=where-the-difficulty-first-appears}

In the equational setting, give the status of: entailment between given equations; checking a supplied joint answer; existence of a joint answer in the constant-test fragment; existence with general premises and conclusions. Define the fragment and name the problem its hardness proof encodes. Why does restricting inputs to shallow terms not help?

::: answer
- Entailment: polynomial-time deduction checks.
- Checking a supplied answer: polynomial time in the size of instance and answer.
- Existence in the constant-test fragment: NP-complete in the authors' current analysis.
- Existence in general: decidability unresolved.

In the fragment, premises only test variables against $a$ or $b$ and conclusions contain no constructors. The hardness proof encodes graph three-colouring: the answer must organize variables into at most three shared parameter classes, and consistency keeps adjacent vertices apart. Shallow input does not help because compound subterms can be given fresh names, with their defining equations added to every case. Depth-one input represents the full problem.
:::

### Generalizing from examples {kind=compute at=can-generalization-tell-us-when-to-stop}

Compute the most specific common pattern of $\operatorname{pair}(\operatorname{pair}(a,b),a)$ and $\operatorname{pair}(\operatorname{pair}(b,b),b)$. State the reformulation of answer existence that uses this operation. What stays unbounded, and why is a computable bound on it equivalent to decidability?

::: answer
The pattern is $\operatorname{pair}(\operatorname{pair}(p,b),p)$. The difference $a$ against $b$ occurs twice and must get the same variable; $\operatorname{pair}(\operatorname{pair}(p,b),q)$ would lose that agreement. The reformulation: choose one fully specified assignment for each case, satisfying its premises and conclusions; anti-unify them; check whether the pattern is a joint answer. If an answer exists, some choice of examples succeeds, though not every choice. The size of the example trees stays unbounded. A computable bound gives a decision procedure by finite search. Conversely, a decision procedure identifies the solvable inputs up to a given size, and running their successful searches computes a bound. So assuming a bound would assume the result.
:::

### What recursion adds {kind=distinguish at=what-recursion-adds}

Type inference with polymorphic recursion is undecidable, and Henglein proved that inference with small typings is polynomial-time decidable. Why is there no contradiction? How does the constant-test fragment differ from this picture?

::: answer
Henglein fixes a polynomial bound on the size of the fully annotated program and decides in polynomial time whether a typing fits it. Exceeding the bound rules out a small typing, not every typing. There can be no computable universal bound on the smallest successful typing, since with checking and finite search it would decide an undecidable problem. The difficulty of polymorphic recursion is unbounded growth of the necessary typing. In the constant-test fragment polynomial-size answers already suffice, and existence is still NP-complete. Joint abduction can additionally impose a hard choice among small answers.
:::

### Larson's exclusion {kind=object at=what-larsons-objection-misses}

Larson says of abductive logic programming that "the three types of inference are formally distinct, so they don’t reduce to each other and can’t be combined to get a third." What is the essay's reply? Which parallel mistake does it name, and which demand of Larson's does it accept as serious?

::: answer
The essay argues that the objection confuses an inference's role with its implementation. A procedure can construct assumptions, test their consequences by deduction and return the survivors. Implementing it in a logical language does not make the assumptions deductive consequences of the evidence: $x=y$ connects two cases and follows from neither. A checker for $D\land A\models C$ is not a solver for $A$, so an algorithm that finds $A$ would not show abduction had been deduction all along. The parallel mistake moves from "trained to predict" to "incapable of conjecturing". Larson can still demand a stronger capacity: proposing fruitful accounts while choosing relevant information and revising the representation. That concerns the scope and effectiveness of methods, not whether abduction can be formalized. The essay notes that his book treats human-level AI as an open question and attacks its inevitability.
:::

### Deutsch's challenge {kind=argue at=deutschs-more-productive-challenge}

Where does the essay agree with Deutsch's "Creative blocks", and at which two points does it part from him?

::: answer
It agrees that fitting observations is insufficient: two programs can pass every test and support different expectations outside the tests. It agrees that the missing account is of how explanatory knowledge is created. Formal abduction makes part of this precise, since an answer succeeds relative to a model, a constraint language and a set of obligations, and can be perfect there and still an inadequate explanation. First departure: observations failing to logically determine an explanation does not imply that an algorithm cannot propose one, because proposal is the step that need not guarantee truth. Second: Deutsch's insistence that a philosophical account must precede the engineering is found unpersuasive. A method and its theory can develop together.
:::

### Three achievements {kind=state at=when-the-framing-itself-becomes-a-hypothesis}

Which three achievements does the essay distinguish for an open-ended reasoning system? What operational questions does it draw from Larson's emphasis on surprise, and where does jointness reappear?

::: answer
Generating admissible hypotheses. Selecting and testing promising ones under a resource budget. Revising the framing that determines which hypotheses are relevant. Success at one does not imply mastery of the others, and failure at the third does not make the first two fictitious. The operational questions: does the system notice a prediction failure, identify the assumption responsible, change its working account, and carry the correction into later work? Jointness reappears in the quality of correction. A revision that adds an exception for each failure, or drops what earlier evidence established, is poor: a new explanation must answer to more than the latest piece of evidence.
:::

### What is established and what is not {kind=limits}

What status does the essay give its own restricted theorem? What does Codex say the research session does not show? What would a future undecidability proof, and a future decidability proof, each leave standing?

::: answer
The restricted existence theorem is recorded in the research notes with written proofs, executable checks and separate agent review. It is not machine-checked and carries no claim of priority. The session is not a controlled test of originality: it cannot establish which ideas were new, its finite experiments do not prove unrestricted claims, and the general decision problem was not solved. The unit doing the work was an arrangement of a human choice of problem, existing research, several model instances, checks and review, not an isolated model. An undecidability result would limit a universally correct, terminating algorithm for the specified task; formal definitions, restricted procedures and fallible search would remain. A decidability proof would not complete a theory of scientific creativity.
:::
