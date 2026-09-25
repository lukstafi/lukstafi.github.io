---
title: "What Should a Program Inherit?"
subtitle: "Revisiting typed genetic programming, twenty-five years later"
author: "Łukasz Stafiniak and Codex"
date: 2026-09-25
---

In September 2001, during the last month of university summer break, I began writing a proposal for modular genetic programming. The surviving file says October, when I last modified it. Twenty-five years later, that distinction matters mainly because it fixes the anniversary. The more interesting discrepancy is between the programme the document announces and the work that followed.

The ambition was to evolve programs whose useful parts could survive changes to the whole. Genetic programming searches by varying programs and selecting among the results. But code is full of relationships that a change can break: a function expects a particular kind of argument; two occurrences refer to the same binding; one calculation prepares the input for another. Recombining individually successful pieces need not preserve the conditions of their success.

My [2001 draft](../projects/typed-gp/sources/MGP1.TXT) proposed ways of identifying corresponding parts and combining their differences. A [2002 continuation](../projects/typed-gp/sources/GENERA.TXT) worked on generalization algorithms. By the time of my [2005 master's thesis](../projects/typed-gp/sources/dyplom4.tm), written in Polish, the programme included substantial work on constructing terms in typed languages. The work combined a survey of existing approaches with new definitions, algorithms, proofs, and unfinished proposals. I ran out of time before experimenting with the intended system.

Reading those documents now, I can follow a movement from evolutionary questions toward questions about programming languages. There were good reasons for that movement. Whether it was the right way to pursue the original ambition is a question I want to leave open.

Three recent systems provide useful places to stop along the way. [babble](https://arxiv.org/html/2212.04596v1) finds reusable abstractions through anti-unification and equations. [TyFlow](https://arxiv.org/html/2510.10216v2) organizes learned program generation around typing rules. [AlphaEvolve](https://arxiv.org/html/2506.13131v1) returns us to evolutionary search over programs, with a different source of variation. [DreamCoder](https://people.csail.mit.edu/asolar/papers/EllisWNSMHCST21.pdf) supplies part of the library-learning background to the first comparison: its broad ambition is to make discoveries change the language and guidance available for subsequent synthesis.

These systems do not form a competition on one benchmark. They make different things explicit: a useful common pattern, a valid next construction step, a candidate worth developing further. Comparing them with the old documents helps distinguish questions I had placed under one research programme.

What should a program inherit from its predecessors? The answer depends on what the next operation needs to do. A relationship worth preserving in an abstraction may be worth relaxing during recombination. An unknown worth leaving to search may instead be resolved by inference. And a successful program may be useful both for what it computes and for what another attempt can learn from its construction.

## Finding the parts that can vary together

The first problem is correspondence. Before combining two programs, we need some account of which parts belong opposite one another.

The 2001 proposal distinguished a module's genealogical identity from its current implementation. A module could change while remaining a descendant of the same module. Duplicating it would create another identity, allowing the copies to develop separately. The analogy was biological, but the programming problem was concrete. The third local definition in one program might correspond to the fourth in another because a new definition had been inserted. Matching by position would confuse an editorial accident with a functional relationship.

Similarity alone does not settle this either. Two definitions can look alike because they descend from one definition, because the same small idiom was useful twice, or because the language offers few ways of expressing something. Conversely, corresponding definitions can acquire quite different implementations. A genealogy records one kind of relationship; comparison of current structure discovers another. The old proposal tried to give both a role.

There is a smaller version of the correspondence problem that we can work through completely. In [“What Must Be True?”](what-must-be-true.html#can-generalization-tell-us-when-to-stop), we used this pair of expressions to explain anti-unification:

```text
pair(a,a)                 pair(b,b)
```

Treat `a` and `b` as distinct constants. We seek a pattern whose holes can be filled to recover either expression. The most specific common pattern is:

```text
pair(p,p)
```

Fill `p` with `a` to recover the first expression and with `b` to recover the second. The repeated hole preserves something the examples have in common: their two components agree. A looser pattern, `pair(p,q)`, also covers them, but admits pairs whose components differ.

Finding such a common pattern is **anti-unification**. The pattern is accompanied by substitutions telling us how to recover its instances. These give an explicit relationship between the abstraction and the expressions from which it was obtained.

For the earlier essay, preserving the repeated hole was the point. For genetic recombination, it can be an obstacle. If an offspring chooses the first component from one parent and the second from the other, we would like the possibilities to include:

```text
pair(a,b)                 pair(b,a)
```

The shared hole in `pair(p,p)` prevents both. Once we choose its filling, we have chosen both positions. The looser `pair(p,q)` exposes two independently variable locations. Each parent still supplies a substitution that reconstructs it, but now we can mix entries from those substitutions.

That is why the 2002 draft deliberately required its genetic schemata to be *linear*: a schema variable occurs only once. Here “linear” describes occurrences in a pattern, not a restriction from linear type theory. The condition prevents the generalization procedure from tying together locations merely because they happened to undergo the same difference in the two examples.

This example assumes that `a` and `b` have interchangeable types and that no further requirement forces the components to agree. If the pair represents two copies of a checksum, independent variation would usually be destructive. If it represents two settings that happened to match in both parents, coupling them forever could prevent useful exploration.

The question is therefore more demanding than finding as much similarity as possible. We want a decomposition that retains useful structure while exposing useful choices. An accurate description of the parents need not be a good space in which to search for their descendants.

The 2002 work tried to make that requirement less impressionistic by relating generalization to mutation. Suppose one program arose from another through a specified kind of change. Could a common-schema algorithm recover the material left unchanged, placing the difference in an appropriate hole? More powerful mutations demand more expressive ways of describing the correspondence. Inserting a wrapper around an expression, for example, should not necessarily make the entire wrapped expression disappear from the common structure.

The draft develops this criterion under restrictions on what a mutation may introduce. Its unfinished algorithms pursue a useful principle: judge the generalizer partly by the variations it is supposed to interpret. A representation and its operators have to be designed together.

Bindings make this more difficult. A fragment that mentions a local variable cannot simply be transplanted wherever its syntax fits. Its meaning depends on which definition that name refers to, while its type can depend on decisions made outside the fragment. Recognizing a shared piece of code therefore requires attention to relationships that a drawing of two syntax trees can conceal.

These concerns explain why the programme grew toward more elaborate accounts of terms, scope, and types. Before following that movement, it helps to examine a different use for common structure. Suppose we want to preserve the behavior of our existing programs while making their recurring operations cheaper to express.

## babble: when a common pattern becomes a useful function

Return to `pair(p,p)`. As a reusable function, it has an immediate interpretation:

```text
duplicate(p) = pair(p,p)
```

The caller supplies one argument, and the function uses it twice. The dependency that restricted recombination now expresses a reusable operation. If the argument is a large expression, having to describe it once can save considerable space. Whether this particular definition is worth adding still depends on how often it is used and what the representation charges for a definition and a call.

This is the setting of **library learning**. We already have a collection of programs. We seek definitions that let us rewrite the collection more economically, paying for the definitions as well as their uses. A function that saves a few symbols at one call site can cost more than it saves overall. A modest saving repeated throughout a corpus can justify a new operation in the language.

My 2001 outline contains a proposal close enough to be worth quoting in its own vocabulary: “MCS modulo equational theory.” MCS meant maximal common schema. The paragraph proposes finding a common schema of subterms, giving it a local name, and replacing the original subterms with applications that reconstruct them. It then proposes using equations to reveal common structure obscured by different surface forms.

babble develops an implemented approach to this combination. Its three jobs are to expose equivalent representations, propose abstractions, and select a library whose savings justify its costs.

Consider two expressions, treating addition as a binary operation and the numerals as constants:

```text
2 + 1                    1 + 3
```

Comparing them position by position finds disagreement on both sides of the plus sign. A syntactic common pattern is `X + Y`. Now suppose we are allowed to use commutativity. We can represent the second expression as `3 + 1` and compare:

```text
2 + 1                    3 + 1
```

The pattern `X + 1` becomes visible. It suggests an increment function, with arguments `2` and `3` recovering the chosen representatives. The equation gives us alternative representations of each computation, making their common operation easier to see.

Whether this abstraction helps compression depends on its savings across uses after paying for the definition. Larger recurring contexts or more occurrences can make it worthwhile.

babble's representation for the alternatives is an **e-graph**. An equivalence class groups expressions known to be equal under the supplied equations, and the graph shares their component structure. Instead of choosing one rewrite and throwing away the previous expression, it can retain several forms together. Those alternatives need not be separately expanded into every complete program they could represent.

> **Inside an e-graph**
>
> An ordinary expression tree commits to one expression: a `+` node has a particular left child and a particular right child. An e-graph has two kinds of components. An **e-class** groups equivalent alternatives. Each alternative is an **e-node**: an operation whose children point to e-classes, so each child can itself offer several equivalent forms.
>
> For our addition example, using commutativity as the only rewrite, the relevant classes can be written as:
>
> ```text
> C₁ = { 1 }
> C₂ = { 2 }
> C₃ = { 3 }
> A  = { +(C₂, C₁), +(C₁, C₂) }
> B  = { +(C₁, C₃), +(C₃, C₁) }
> ```
>
> The braces contain e-nodes; the names identify e-classes. Class `A` represents both `2 + 1` and `1 + 2`. Both addition classes reuse `C₁`. If a larger expression contains `pair(A,B)`, that single node represents all four combinations of the alternatives in `A` and `B`, without storing four complete trees.
>
> Applying an equation adds the rewritten form to the same class as the original. If the new form already belongs to another class, the classes merge. This equality propagates upward: once two child classes merge, two parent nodes with the same operation and corresponding children also describe equivalent expressions. Maintaining this property is called **congruence closure**. It lets a discovered equality become usable wherever those expressions occur.
>
> **Equality saturation** repeatedly applies rewrites and restores these relationships, until no new information is added or a resource limit is reached. Each rewrite preserves the existing alternatives, so a locally unhelpful form can remain available for a later rewrite that makes it useful.
>
> To obtain an ordinary expression again, **extraction** chooses a node from the root class and recursively chooses forms for its children, guided by a cost such as expression size. For library learning, costs also depend on which definitions are shared across uses. babble searches the represented alternatives for common patterns before selecting the library and rewritten programs together. [The paper's e-graph formulation](https://arxiv.org/html/2212.04596v1#S4) gives the definitions behind this example.

The best representation for discovering one abstraction may differ from the best representation for another. Normalizing every expression to one preferred form decides in advance what will be easy to notice. An e-graph keeps more of those possibilities available.

Anti-unification then works across this structure. Matching operations allow the comparison to proceed into their arguments; differences introduce holes. Encountering the same pair of differing components again reuses the same hole. That is the graph-based counterpart of preserving `pair(p,p)` in our earlier example. Different equivalent forms can expose different candidate patterns.

The beneficial semantic equivalences are hard to capture as an equation set. Finding the right equations for a domain is its own challenge.

Selecting a library requires weighing definitions together. Two abstractions may compete for the same occurrences, or one may shorten another's definition. babble accounts for both definition and use costs, using a bounded search over libraries. Repeatedly choosing the best isolated saving need not produce the best combination.

Scope also matters. A local helper can refer to surrounding bindings; moving it into a global library requires making those dependencies explicit, for example as arguments. The 2001 outline proposed definitions within the relevant scope, while babble's central formal result concerns global definitions with no free variables.

The paper proves that suitable patterns suffice to express an optimal global library in its first-order setting. Its practical generator considers only pairwise anti-unifiers, which can miss useful candidates; library selection is also approximate. The [close reading](https://github.com/lukstafi/lukstafi.github.io/blob/main/projects/typed-gp/research/babble.md) explains the theorem's scope and the paper's counterexample to pairwise generation.

The [evaluation](https://arxiv.org/html/2212.04596v1#S6) reports better compression than the compared DreamCoder library-learning results. Supplied equations also make abstraction discovery less sensitive to redundant syntactic transformations. Whether these libraries improve subsequent synthesis or evolutionary recombination remains a further question.

That gap is especially interesting from the perspective of the old programme. A compressed corpus has preserved the ability to reconstruct its computations while changing how they are expressed. A genetic representation must also make promising new computations accessible. The two objectives can support each other: a useful new function can turn a long sequence of coordinated choices into one operation. But it can also conceal internal choices that later variation needs to separate.

For example, making `duplicate` a primitive makes agreement between two components effortless. To vary the components independently, search must instead use `pair`, open the definition, or otherwise escape the coupling. Which operation is easier to reach now depends on the vocabulary and the available edits. A smaller description of existing successes is not automatically the best neighborhood around those successes.

The historical outline already allowed richer schemata for uses outside genetic recombination. Returning to it through babble makes the reason clearer. We can ask what a pattern says about its instances, what it saves when installed as a function, and what variations it makes available. Those are three questions about the same mathematical object, with potentially different preferred answers.

The old proposal recognized that common structure could become an explicit operation, including when equations were needed to expose it. babble makes that recognition part of a concrete optimization process. Its comparison with genetic schemata shows how the value of an abstraction depends on the work it makes possible.

## TyFlow: which choices should remain choices?

The move toward types began from a division of labor. Some requirements on a program can be expressed as logical constraints and maintained during construction. Other expectations can be expressed through a fitness function that evaluates candidates. My master's thesis put this distinction near the beginning of its account of synthesis.

A type is not assumed to be a semantically complete representation of intent. Many Boolean expressions have type `bool`, while computing different answers under the same circumstances. Finding the shortest expression of that type would answer a different question from finding a useful classifier, predicate, or decision procedure. The type restricts the search, and the fitness criterion supplies further reasons to prefer one candidate over another.

Once we try to maintain types during generation, however, “choose a fragment of the right type” becomes an inadequate description. The type may contain unknowns. A fragment can resolve an unknown that occurs elsewhere. Introducing a local definition changes what is available, and deciding whether that definition is polymorphic depends on the surrounding environment.

The thesis's algorithm **C** constructs a term alongside type inference. Its inputs include an environment of available bindings, a requested type, fresh type variables, and a sequence of choices. A choice might select a variable, a function construction, an application, or a local binding. The construction propagates constraints as those choices are interpreted. A path can succeed or fail; choosing a form does not promise that every subsequent choice can complete it.

For a first example, suppose we have:

```text
available: f : ∀a. a → a, b : bool
requested result type: bool
one construction: f b
```

The `∀a` means that `f` has a polymorphic type scheme. Each use can receive a fresh instance of that scheme. Choose application as the outer form. C introduces an unknown argument type, say `β`, so the function position must have type `β → bool`. Choosing `f` gives a fresh instance `α → α`. Matching these function types forces `α` and `β` both to be `bool`. The argument is then constructed at `bool`, and choosing `b` succeeds.

The requested result has helped determine the argument's type through the selected function. This particular use of `f` is specialized; the environment still makes its polymorphic scheme available for other uses. We have made several choices, but we have not needed to guess separately a type that unification can determine.

To see why the environment matters, change the example:

```text
available: p : α → bool, b : bool
requested result type: bool
one construction: let test = p in test b
```

This time there is no universal quantifier. The `α` is one unknown shared with the context. Such a situation can arise while constructing an enclosing function whose parameter types have not all been determined. Choosing one use of `p` may tell us something that every other use must respect.

Choose a local binding and then choose `p` as its definition. The new name `test` receives the type `α → bool`. C must now decide which variables in this type can be generalized, so that different uses of `test` could instantiate them independently. The decision is relative to the environment: variables already shared with the context must remain shared.

Here `α` occurs in the type of `p`. Giving `test` the scheme `∀a. a → bool` would invent a freedom that its definition does not have. We have made an alias for one existing binding, not a predicate that can accept arbitrary types independently at each call. Thus the environment for the body contains both `p : α → bool` and `test : α → bool`.

Next choose the application `test b`. Choosing `test` ties the application's argument type to `α`; choosing `b` then forces `α = bool`. That substitution refines both bindings. Inside the body, `test` accepts a Boolean. The outer `p` must accept one too, and C returns this information about the original context along with the constructed term. The local name disappears outside its scope; the discovered constraint does not.

If the same body also tried to apply `test` to an integer, those uses would conflict. If `p` had actually possessed a universally quantified input type, a polymorphic alias could have been legitimate. The difference is between a shared unknown whose value must be consistent and a quantified variable that permits fresh instantiation. Environment management is where that difference becomes operational.

The simpler expression `b` also meets the requested type. That is entirely consistent with the purpose of C. `p b` can compute a different result, and the type alone does not tell us which behavior the task needs. The example shows how to maintain dependencies along a candidate construction, leaving further criteria to evaluate the candidate.

This explains the shape of C's result: it returns a term and a substitution. One choice can teach the rest of the construction something about its types. The environment is part of that communication, rather than a static catalogue from which independent pieces are fetched. In genetic programming, this matters whenever a changed subterm shares type information with the code around it.

Constructing a function changes the environment in a complementary way. The body gains access to its argument and, in C's recursive function form, to the function being defined. These bindings have related types: choosing how to use the argument can constrain the function, and recursive calls must respect the same developing account. A local definition, meanwhile, becomes available in its body, with precisely the generalization its context permits. The choice sequence therefore acts on an environment that the construction itself is building. Available names, their scopes, and their remaining type freedom change as the program takes shape.

That matters for reuse as much as for construction from scratch. A fragment mentioning a local argument is usable only where the relevant binding is available, or after an explicit transformation that supplies it. A genetic operator cannot treat the fragment's text and its environment as independent pieces. This is the same dependency that a library extractor encounters when it turns a local computation into a callable abstraction.

The [February 2026 revision of TyFlow](https://arxiv.org/html/2510.10216v2) makes a related separation between choices and enforcement the interface to a learned model. Given a language and its typing rules, its framework constructs synthesis rules. A neural model predicts construction decisions, while a symbolic engine propagates information and checks constraints. The representation gives learning access to the steps of a typed construction, rather than treating the eventual source text as the only object to predict.

TyFlow's introductory simply typed lambda-calculus rules expose a difference in how much type information the model must supply. To isolate it, use the same monomorphic environment for both constructions:

```text
available: f : bool → bool, b : bool
requested result type: bool
```

Choosing application creates a function goal `?a → bool` and an argument goal `?a`. In C, selecting `f` retrieves `bool → bool` from the environment; unification determines `?a = bool`. In TyFlow's displayed variable rule, the model supplies both the name `f` and the remaining type `?a = bool`. The engine checks that `f : bool → bool` belongs to the environment. A proposal of `f` with `?a = int` would fail that check even though the environment already contains the information needed to choose correctly.

TyFlow propagates the successful assignment to the argument goal, which now requires `bool`, and also uses unification when applying synthesis rules. Checking is interleaved with construction. The difference is specifically that its environment-membership predicate accepts or rejects a supplied name–type pair; it does not return a missing type from a selected name. Information available through C's lookup becomes an additional model prediction here. Encoding lookup as a relation that can return bindings could change this behavior. The [worked reading note](https://github.com/lukstafi/lukstafi.github.io/blob/main/projects/typed-gp/research/tyflow.md) records the trace and its source locations.

The difference in type systems is separate. C handles polymorphic schemes and generalization relative to the environment; the introductory simply typed calculus has neither. C therefore demonstrates richer type inference than that example. TyFlow's framework takes typing rules as input, however, and its experiments use SuFu and a Java subset whose grammar includes generics. The introductory example does not establish an expressiveness ranking for the whole system.

The sharper criticism is that this encoding leaves the model to predict some information that inference could determine, even in the simpler type system. That was already a concern in the thesis. TyFlow's contribution lies in turning supplied typing rules into a construction interface that can be learned from derivations and evaluated across languages. We can value that contribution while asking whether a more capable inference procedure would relieve the model of avoidable choices.

TyFlow's experiments help separate validity from task success. In the reported SuFu evaluation with the 220M model, compilation errors fall to zero while the proportion of tasks solved by at least one of ten candidates rises from 32.76% to 46.55%. The remaining unsolved tasks make the distinction plain. For Java, compilation errors remain because some compiler checks lie outside the implemented typing rules. [Table 2 and its discussion](https://arxiv.org/html/2510.10216v2#S6.T2) give the relevant comparison.

The formal guarantees have their own scope. A successful checked construction is well typed under the supplied rules. Coverage of all typing derivations says that the representation can express the relevant constructions; it does not say that a finite learned search will find every one. Similarly, C's completeness result concerns the existence of choice paths under its stated conditions. It does not turn an arbitrary choice sequence into a successful or terminating search.

There is a later personal connection here. My [2015 PhD thesis, *GADTs for Reconstruction of Invariants and Postconditions*](../projects/jca/lukstafi-phd-thesis.pdf), developed inference in the other direction: reconstructing informative types and contracts from programs. Generalization finds common consequences used in postconditions; abduction finds conditions supporting invariants. Anti-unification over free terms participates in that generalization. The resulting InvarGenT system was implemented, unlike the early evolutionary programme.

[“What Must Be True?”](what-must-be-true.html#reading-a-contract-out-of-the-code) develops that connection at greater length. The witness-generalization result discussed later in that essay belongs to our recent work, not to the 2015 thesis. For this retrospective, the continuity is already interesting without collapsing the projects together: logical structure can help construct a candidate, reconstruct a contract, or explain what a collection of cases has in common. Each use places different demands on the machinery.

C and TyFlow leave us with a concrete allocation problem. Some decisions remain choices because several valid possibilities exist. Other apparent decisions can be settled by propagating what earlier choices already imply. Maintaining that distinction can save search effort and preserve consistency. It still leaves the evolutionary question with which the programme began: among the valid possibilities, how do we produce variations that are worth trying?

## AlphaEvolve: variation, selection, and what survives

Genetic programming brings together several decisions that we have so far examined separately. We need a representation of candidate programs, operations that vary them, an evaluation of their performance, and a way to choose material for further variation. Changing any one of these changes the work demanded of the others. A strong evaluator cannot select a discovery the variation procedure never proposes. An expressive representation can still arrange the search space badly for its operators.

[AlphaEvolve's evolutionary loop](https://arxiv.org/html/2506.13131v1#S2) stores programs with outputs and scores. A selected parent and additional inspirations enter the context for LLM-generated edits; evaluation supplies feedback for subsequent search. Its database design draws on MAP-Elites and island models to balance improvement with diversity. This gives the comparison concrete evolutionary roles: candidates, variation, fitness, and selection. The proposal mechanism changes, while the problem of making successive variations useful remains.

My early programme put substantial responsibility on the definition of the variation operators. If a common schema established which parts corresponded, substitutions could express the parental alternatives, and recombination could be analyzed in terms of what it retained. The attraction was an explicit relationship between the structure of the parents and the possibilities available to their children. We could ask whether an operation preserved a stated class of common features before running an evolutionary experiment.

Learned editing invites a different allocation of that responsibility. Rather than prescribing every permissible correspondence in advance, one can ask a proposal mechanism to interpret code and suggest a useful change. The relevant comparison is between ways of producing variations under dependencies. Can an edit change an internal representation and adjust its uses together? Can it recognize when apparently separate pieces implement one idea? Can it leave a relationship intact even when the syntax expressing it changes?

These questions connect directly to the old concern about modules. A useful unit of change may cross several syntactic boundaries, while a large syntactic subtree may contain several independently changeable decisions. A fixed operator needs a representation that makes its intended unit accessible. A learned editor might infer a suitable unit from the particular program and context.

The paper's tensor-decomposition example makes another choice of representation concrete. The evolving object is a search procedure. Across 15 mutations, changes affect its optimizer, initialization, loss, and hyperparameters. Evaluation measures decomposition rank and success frequency, with checks on the resulting mathematical objects. Results include multiplying complex 4×4 matrices with 48 scalar multiplications. The rank counts the products in the decomposition. Thus there are two levels: changes to the searcher and the search it conducts. [Figure 4 and the accompanying discussion](https://arxiv.org/html/2506.13131v1#S3.SS1) describe the case.

My 2001 outline had proposed combining structural evolution with numerical optimization inside a parameterized program. The contemporary example moves the boundary: we can vary constants in a fixed procedure, vary the procedure that chooses constants, or vary the representation of the numerical problem. A single evolutionary candidate can therefore embody a way of searching, whose fitness depends on the results of that search.

This separates two kinds of evidence. A search procedure may be useful without a theorem that it always finds a solution, while a particular object it discovers admits an exact check. Heuristic exploration and rigorous acceptance can cooperate: we evaluate how effectively the procedure searches and check whether its proposed objects satisfy the mathematical requirements.

A program can also descend from one parent while drawing ideas from several sources. This inheritance can have a formal provenance: a graph could record which versions, documents, and evaluation results were supplied to an attempt, and which edits it produced. An agent's retrieval history could extend the graph as it consults further sources. Such a record traces access and descent; determining which source caused a particular improvement requires further evidence. The correspondence is broader than mapping code positions through a common schema, and remains useful when an optimization is re-expressed with little shared text.

Selection determines which of these sources remain available. A candidate that performs poorly overall may contain a component that helps another candidate. Retaining it preserves that opportunity, provided the proposal mechanism can identify and adapt the component. This gives the old concern about modules and species a concrete question: which retained differences become useful under later variation? Diversity under a convenient score or descriptor is valuable insofar as it helps preserve such opportunities.

Inheritance can thus improve either an answer or the method used to seek it. The old question about preserving useful pieces expands into one about preserving useful ways to search, together with records of how they developed.

Here the connection to [“What Persists When the Agents Change?”](what-persists-when-agents-change.html) becomes natural. That essay asks how inquiry continues across changing participants and representations. Evolutionary search supplies a concrete instance of a more limited problem: past work matters through the material retained and the process that can use it. An executable artifact can change the next attempt's starting point without being absorbed into the parameters of the proposing model.

That raises a further question about what the records contain. Programs and scores may leave out why an unsuccessful idea seemed promising, which objection is unresolved, or why the evaluation criterion deserves revision. An inquiry may need to retain reasons for questioning its selection process. Provenance can help recover those reasons when it leads back to arguments and evidence that the scores alone omit.

## Returning to the unfinished work

In 2001, the programme asked how useful structure could survive variation. The 2002 continuation tried to make generalization answer to the kinds of mutation it should recognize. By 2005, constructing programs under logical constraints had become a substantial subject in its own right. The later work on type inference continued questions that this development had made interesting.

Was that direction warranted, or was I nerdsniped into type theory?

The two possibilities are not clean opposites. The environment dependencies we worked through are real. Ignoring them would not have made them disappear from an implementation. Formalizing them gave meaningful results, including a clearer account of how construction and inference can cooperate. At the same time, a formal problem offers a kind of progress that an unfinished evolutionary system does not: precise statements, identifiable proof obligations, a result that can be complete within its chosen setting.

Those accomplishments do not establish that the search finds useful programs. A proof that every well-typed term has an appropriate construction path leaves open which paths an actual search will explore. A carefully designed common-schema operator can preserve exactly the declared relationships without improving performance on the tasks we care about. The passage from a useful formal property to a useful evolutionary mechanism still requires work.

It is therefore possible that the programme encountered genuine obstacles and that working on them drew attention away from the experiments that would have tested their importance. The independent value of the subsequent type-theoretic research does not decide whether it was the best next step for genetic programming. Equally, the absence of the intended experiments does not prove that the theoretical direction was mistaken.

The missing comparison is with a smaller implemented system. What could it have taught me before I developed the richer machinery? Which dependencies would actually have limited search? Which elegant improvements would have been dominated by evaluation cost, a poor fitness signal, or an unproductive choice of representation? The old documents cannot answer those questions, and contemporary systems operate with resources and proposal mechanisms that were unavailable to that programme. They sharpen the counterfactual without settling it.

The three comparisons nevertheless change how I would now describe the original ambition. babble makes the cost and purpose of an abstraction explicit. TyFlow makes the boundary between learned choices and enforced obligations something we can examine operationally. The evolutionary comparison asks whether our ways of preserving structure also make useful changes accessible. These are standards against which parts of the old work can be reconsidered, without requiring the whole programme to have been a success.

The archive has survived better than the experiment it was supposed to support. That survival is useful because it lets us inspect the questions before the later path made them look inevitable. Some dependencies deserve stronger protection; others deserve to be loosened. Some apparent search problems yield to inference; some tempting formal problems need an experiment before more theory. A twenty-fifth anniversary seems a reasonable occasion to recover that freedom of direction, and to ask again what the next attempt should inherit.

---

*Sources and scope.* This retrospective uses the [public archive of the 2001–2005 documents](https://github.com/lukstafi/lukstafi.github.io/tree/main/projects/typed-gp) and fixed versions of babble (arXiv 2212.04596v1), TyFlow (2510.10216v2), and AlphaEvolve (2506.13131v1). The [survey and close readings](https://github.com/lukstafi/lukstafi.github.io/blob/main/projects/typed-gp/research/survey.md) distinguish source claims, reconstructed examples, and qualifications. The small construction traces are explanations derived from the algorithms, not new experiments. The comparisons concern research questions and mechanisms; they make no claim of influence, historical priority, or equivalence between the systems.
