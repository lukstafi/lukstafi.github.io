---
title: "Study notes: What Should a Program Inherit?"
essay: what-should-a-program-inherit
track: which-intelligence
reviewed-against: "75d8bc6"
requires:
  - {at: what-must-be-true#can-generalization-tell-us-when-to-stop, for: "anti-unification, and the example of pair(a,a) and pair(b,b)"}
  - {at: what-must-be-true#reading-a-contract-out-of-the-code, for: "the 2015 thesis, where generalization and abduction reconstruct contracts from programs", strength: helpful}
  - {at: what-persists-when-agents-change, for: "how an inquiry continues across changing participants and records", strength: helpful}
introduces:
  - {term: genealogical identity, at: finding-the-parts-that-can-vary-together, gloss: "a module stays a descendant of the same module while its implementation changes; duplication creates a new identity"}
  - {term: linear schema, at: finding-the-parts-that-can-vary-together, gloss: "a common pattern in which each schema variable occurs only once, so that every hole can vary independently"}
  - {term: library learning, at: babble-when-a-common-pattern-becomes-a-useful-function, gloss: "finding definitions that let a collection of programs be rewritten more economically, paying for the definitions as well as their uses"}
  - {term: e-graph, at: babble-when-a-common-pattern-becomes-a-useful-function}
  - {term: algorithm C, at: tyflow-which-choices-should-remain-choices, gloss: "the 2005 thesis's procedure that constructs a term from a sequence of choices alongside type inference, returning a term and a substitution"}
  - {term: provenance graph, at: alphaevolve-variation-selection-and-what-survives, gloss: "a record of which versions, documents and evaluation results were supplied to an attempt and which edits it produced"}
uses:
  - {term: anti-unification, from: what-must-be-true}
  - {term: "deduction, generalization and abduction", from: what-must-be-true}
---

### The question and its three answers {kind=state}

Why can recombining individually successful pieces of code fail? What does each of the three systems the essay visits make explicit? On what does the answer to "what should a program inherit?" depend?

::: answer
Code is full of relationships that a change can break: a function expects a kind of argument, two occurrences refer to one binding, one calculation prepares the input of another. Recombination need not preserve the conditions under which the pieces succeeded. babble makes explicit a useful common pattern, TyFlow a valid next construction step, AlphaEvolve a candidate worth developing further. The answer depends on what the next operation needs to do. A relationship worth preserving in an abstraction may be worth relaxing during recombination, and an unknown worth leaving to search may instead be resolved by inference.
:::

### Which parts correspond {kind=distinguish at=finding-the-parts-that-can-vary-together}

Before two programs are combined, their parts must be matched. Why does matching by position fail? Why does similarity alone not settle it? What did the 2001 proposal distinguish?

::: answer
The third local definition of one program may correspond to the fourth of another because a definition was inserted. Position confuses an editorial accident with a functional relationship. Two definitions can look alike because they descend from one, because the same idiom was useful twice, or because the language offers few ways to say something. Corresponding definitions can also acquire quite different implementations. The 2001 proposal distinguished a module's genealogical identity from its current implementation. A genealogy records one kind of relationship and comparison of current structure discovers another, and the proposal gave both a role.
:::

### Why genetic schemata are linear {kind=compute at=finding-the-parts-that-can-vary-together}

The parents are $\operatorname{pair}(a,a)$ and $\operatorname{pair}(b,b)$. How many offspring can be formed by filling the holes of the most specific common pattern from the parents' substitutions? How many from the linear pattern? Why did the 2002 draft require linearity, and when is the coupling right after all?

::: answer
The most specific pattern is $\operatorname{pair}(p,p)$, with substitutions $p\mapsto a$ and $p\mapsto b$. It yields $2$ offspring, the parents themselves. The linear pattern $\operatorname{pair}(p,q)$ has two independent holes and yields $2\times2=4$: the parents, $\operatorname{pair}(a,b)$ and $\operatorname{pair}(b,a)$. Linearity keeps the generalization from tying locations together merely because they underwent the same difference in two examples. If the pair holds two copies of a checksum, independent variation would usually be destructive. If it holds two settings that happened to match, coupling them forever could prevent useful exploration. An accurate description of the parents need not be a good space in which to search for their descendants.
:::

### A generalizer answers to its mutations {kind=explain at=finding-the-parts-that-can-vary-together}

How did the 2002 work try to make the requirement on a decomposition less impressionistic? Give its example of a mutation that strains a simple generalizer. Why do bindings make shared code harder to recognize?

::: answer
It related generalization to mutation. Suppose one program arose from another by a specified kind of change: a common-schema algorithm should recover the material left unchanged and place the difference in an appropriate hole. Inserting a wrapper around an expression should not make the whole wrapped expression vanish from the common structure, so more powerful mutations demand more expressive correspondences. The principle is to judge the generalizer partly by the variations it must interpret: a representation and its operators are designed together. A fragment that mentions a local variable cannot be transplanted wherever its syntax fits. Its meaning depends on which definition the name refers to, and its type can depend on decisions made outside the fragment.
:::

### An equation exposes a pattern {kind=compute at=babble-when-a-common-pattern-becomes-a-useful-function}

Anti-unify $2+1$ and $1+3$ syntactically. Then use commutativity and anti-unify again. What function does the second pattern suggest? In an e-graph where class $A$ holds $2+1$ and $1+2$ and class $B$ holds $1+3$ and $3+1$, how many expressions does the single node $\operatorname{pair}(A,B)$ represent? Name babble's three jobs.

::: answer
Position by position the two disagree on both sides, so the pattern is $X+Y$. Rewriting the second as $3+1$ gives the pattern $X+1$: an increment function, with arguments $2$ and $3$. The node $\operatorname{pair}(A,B)$ represents $2\times2=4$ expressions without storing four trees. babble's jobs are to expose equivalent representations, propose abstractions, and select a library whose savings justify its costs. Whether the increment is worth adding depends on its savings across uses after paying for the definition.
:::

### Inside an e-graph {kind=recall at=babble-when-a-common-pattern-becomes-a-useful-function}

Define e-class and e-node. What are congruence closure, equality saturation and extraction? Why keep the alternatives when one could normalize every expression to a preferred form?

::: answer
An e-class groups alternatives known to be equal. Each alternative is an e-node: an operation whose children point to e-classes, so each child can itself offer several forms. Applying an equation adds the rewritten form to the class of the original, and classes merge when a form already belongs to another. Congruence closure propagates this upward: once child classes merge, parent nodes with the same operation and corresponding children are equivalent too. Equality saturation applies rewrites and restores these relationships until nothing new is added or a resource limit is reached. Extraction chooses a node from the root class and recursively for its children, guided by a cost. Normalizing decides in advance what will be easy to notice: the best representation for discovering one abstraction may differ from the best for another.
:::

### Compressing is not searching {kind=distinguish at=babble-when-a-common-pattern-becomes-a-useful-function}

Read as a function, $\operatorname{pair}(p,p)$ is `duplicate(p)`. What does installing `duplicate` as a primitive do to later variation? State the three questions the essay says can be asked of one pattern. What does babble's evaluation leave open?

::: answer
With `duplicate` as a primitive, agreement between the two components is effortless. To vary them independently, search must use `pair`, open the definition, or otherwise escape the coupling. The dependency that restricted recombination is what the function reuses. A smaller description of existing successes is not automatically the best neighborhood around them. The three questions: what does a pattern say about its instances, what does it save when installed as a function, and what variations does it make available? They concern one mathematical object and can have different preferred answers. babble reports better compression than the compared DreamCoder results. Whether its libraries improve later synthesis or evolutionary recombination remains open.
:::

### A construction that infers {kind=derive at=tyflow-which-choices-should-remain-choices}

Why is a type not a complete statement of intent? Algorithm C is given $f:\forall a.\,a\to a$ and $b:\mathrm{bool}$, a requested type $\mathrm{bool}$, and the choices: application, then $f$, then $b$. Trace the types. What did the construction not have to guess?

::: answer
Many Boolean expressions have type $\mathrm{bool}$ and compute different answers. The type restricts the search, and the fitness criterion supplies further reasons to prefer a candidate. Choosing application introduces an unknown argument type $\beta$, so the function position must have type $\beta\to\mathrm{bool}$. Choosing $f$ gives a fresh instance $\alpha\to\alpha$. Unifying $\alpha\to\alpha$ with $\beta\to\mathrm{bool}$ forces $\alpha=\beta=\mathrm{bool}$. The argument is constructed at $\mathrm{bool}$, and choosing $b$ succeeds. The requested result determined the argument's type through the selected function, so no type that unification can determine was guessed separately. This use of $f$ is specialized, and its polymorphic scheme remains available for other uses.
:::

### A shared unknown is not a quantifier {kind=derive at=tyflow-which-choices-should-remain-choices}

Now the environment is $p:\alpha\to\mathrm{bool}$ and $b:\mathrm{bool}$, with $\alpha$ an unknown shared with the context, and the construction is `let test = p in test b`. Why may C not give `test` the scheme $\forall a.\,a\to\mathrm{bool}$? What happens at `test b`, and what does C return?

::: answer
Generalization is relative to the environment: variables already shared with the context must stay shared. Here $\alpha$ occurs in the type of $p$, and `test` is an alias for that one binding. Quantifying would invent a freedom the definition does not have. So the body sees $p:\alpha\to\mathrm{bool}$ and $\mathit{test}:\alpha\to\mathrm{bool}$. Choosing `test` ties the argument type to $\alpha$, and choosing $b$ forces $\alpha=\mathrm{bool}$. The substitution refines both bindings, so the outer $p$ must accept a Boolean too. C returns a term and a substitution: the local name disappears outside its scope and the discovered constraint does not. Applying `test` to an integer in the same body would conflict. Had $p$ been universally quantified, a polymorphic alias could have been legitimate.
:::

### Where C and TyFlow differ {kind=distinguish at=tyflow-which-choices-should-remain-choices}

Use the environment $f:\mathrm{bool}\to\mathrm{bool}$, $b:\mathrm{bool}$ and the requested type $\mathrm{bool}$. After application is chosen, how is the goal $?a$ settled in C, and how in TyFlow's displayed variable rule? Which difference between the systems does the essay keep separate from this one? What do TyFlow's experiments separate, and what do the formal guarantees of both systems not promise?

::: answer
In C, selecting $f$ retrieves $\mathrm{bool}\to\mathrm{bool}$ from the environment and unification determines $?a=\mathrm{bool}$. In TyFlow's rule the model supplies both the name $f$ and the type $?a=\mathrm{bool}$, and the engine checks membership. Its predicate accepts or rejects a name–type pair and does not return a missing type, so a proposal of $f$ with $?a=\mathrm{int}$ fails although the environment held the answer. The essay's criticism is that this leaves the model to predict what inference could determine. The difference in type systems is separate: C handles polymorphic schemes, while TyFlow takes typing rules as input, so the introductory example gives no expressiveness ranking. The experiments separate validity from task success: compilation errors can fall to zero while many tasks stay unsolved. A checked construction is well typed under the supplied rules. Coverage does not say a finite learned search finds every derivation, and C's completeness concerns the existence of choice paths.
:::

### Who defines the unit of change {kind=explain at=alphaevolve-variation-selection-and-what-survives}

Name the four evolutionary roles in AlphaEvolve's loop. Where did the early programme put the responsibility for useful variation, and where does learned editing put it? Which three questions does the essay ask of an edit?

::: answer
Candidates (stored programs with outputs and scores), variation (LLM-generated edits from a parent and further inspirations), fitness (evaluation) and selection (a database that balances improvement with diversity). The early programme put the responsibility on the definition of the operators: a common schema fixed the correspondence, substitutions expressed the parental alternatives, and one could ask what an operation preserved before running an experiment. Learned editing asks a proposal mechanism to interpret the code and suggest a change. A fixed operator needs a representation that makes its unit accessible, and a learned editor might infer the unit from the program and context. The questions: can an edit change an internal representation and adjust its uses together? Can it recognize when separate pieces implement one idea? Can it leave a relationship intact when the syntax expressing it changes?
:::

### Two levels, two kinds of evidence {kind=distinguish at=alphaevolve-variation-selection-and-what-survives}

In the tensor-decomposition example, what is the evolving object? Which two levels and which two kinds of evidence does the example separate?

::: answer
The evolving object is a search procedure: mutations change its optimizer, initialization, loss and hyperparameters. The two levels are changes to the searcher and the search it conducts, so a candidate embodies a way of searching whose fitness depends on the results of that search. The 2001 outline had proposed structural evolution with numerical optimization inside a parameterized program, and the example moves that boundary. The two kinds of evidence: a search procedure may be useful without a theorem that it always finds a solution, while a particular object it discovers admits an exact check. Heuristic exploration and rigorous acceptance cooperate.
:::

### What selection keeps {kind=connect at=alphaevolve-variation-selection-and-what-survives}

What does a provenance graph record, and what can it not show by itself? Why keep a candidate that performs poorly overall? How does the essay connect evolutionary search to "What Persists When the Agents Change?", and what may programs and scores leave out?

::: answer
The graph records which versions, documents and evaluation results were supplied to an attempt and which edits it produced. It traces access and descent. Which source caused an improvement needs further evidence. A weak candidate may contain a component that helps another, and retaining it preserves that opportunity if the proposal mechanism can identify and adapt it. The question is which retained differences become useful under later variation. Evolutionary search is a limited instance of the other essay's problem: past work matters through the material retained and the process that can use it, and an executable artifact changes the next attempt's starting point without being absorbed into the proposing model's parameters ([What Persists](/notes/what-persists-when-agents-change.html#representations-in-use)). Programs and scores may omit why an unsuccessful idea seemed promising, which objection is unresolved, or why the evaluation criterion deserves revision.
:::

### Warranted, or nerdsniped {kind=limits at=returning-to-the-unfinished-work}

The author asks whether the move from evolution to type theory was warranted. Why does the essay say the two possibilities are not clean opposites? What do the formal results not establish? Which comparison is missing, and what scope does the essay claim for its own examples?

::: answer
The environment dependencies are real, and formalizing them gave meaningful results. A formal problem also offers a kind of progress that an unfinished evolutionary system does not: precise statements and results complete within their setting. A proof that every well-typed term has a construction path leaves open which paths a search explores, and an operator that preserves exactly the declared relationships need not improve performance. So the work may have met real obstacles and still drawn attention from the experiments that would have tested their importance. The absence of those experiments does not prove the direction mistaken. The missing comparison is with a smaller implemented system, which could have shown which dependencies limit search. Contemporary systems sharpen that counterfactual without settling it. The construction traces are explanations derived from the algorithms, not experiments, and the comparisons claim no influence, priority or equivalence.
:::
