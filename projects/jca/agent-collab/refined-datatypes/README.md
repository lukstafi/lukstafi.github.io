# Synthesizing datatypes for the successful inputs of an algorithm

A tree search can return the path to its unique marked leaf. What type should a caller supply if it needs a path on every call? A path to a mark certifies existence. Uniqueness also requires a fact about every sibling the path passes. In this directory five constructors express both facts. A generator obtains their types from the search's transitions. Lean checks that the resulting family is inhabited on exactly the successful inputs. [Search](Search.lean) · [Generator](replay.py) · [Proof](Unique.lean)

## Where the new datatype enters

InvarGenT can infer an existential result when different branches produce values with different private type indices. A caller opening such a package can use relationships among its components. For example, two values may share the same hidden type. This inference works over a vocabulary of declared datatypes. Review 53 shows what happens when a recursive caller needs a property outside its finite equational guard language. On unary inputs, finite Boolean combinations of patterns are eventually constant in depth. Even depth needs a recursive definition. Review 53 supplies one by turning the accepting base cases and successor transitions of a finite machine into constructors of an indexed proof. [Inferred packages in review 51](../thesis-review-51.md) · [Unary evidence in review 53](../thesis-review-53.md) · [InvarGenT thesis](../../lukstafi-phd-thesis.pdf)

The research question is how to obtain that vocabulary from the computation. In review 53 a parent passes a control state down to its child. Here each child returns a summary and the parent combines two summaries. The summary needed to decide success is finite even though the path returned on success has unbounded length.

## First result — locating a unique mark

The input is a finite ordered tree with two kinds of leaf, `Clear` and `Mark`, and a binary `Fork`. The search returns `zero` at a clear leaf and `hit(here)` at a mark. A fork with one hit and one empty child prefixes the path with the direction of the hit. Two empty children give `zero`. Two hits give `many`, as does either child already reporting `many`. Only a hit counts as success at the root. For example, on `Fork(Fork(Clear, Mark), Clear)` the answer is left, then right.

Write `one` for the tag of any hit. Lean proves that the parent tag depends only on the two child tags. The generator can therefore run the actual combining function on one representative per tag, using `hit(here)` for every hit. It reads both leaf outcomes and all nine fork outcomes. Every row producing `many` can be dropped because that tag persists in every enclosing tree. An empty subtree, in contrast, can be the sibling of a hit. Its evidence must survive. [Proofs `step_exact` and `many_absorbs`, and transition enumeration](Search.lean)

| Input | Child evidence, in order | Parent evidence |
|---|---|---|
| `Clear` | — | `E(zero, Clear)` |
| `Mark` | — | `E(one, Mark)` |
| `Fork(l,r)` | `E(zero,l)`, `E(zero,r)` | `E(zero, Fork(l,r))` |
| `Fork(l,r)` | `E(zero,l)`, `E(one,r)` | `E(one, Fork(l,r))` |
| `Fork(l,r)` | `E(one,l)`, `E(zero,r)` | `E(one, Fork(l,r))` |

Each row becomes one constructor. Its first index names a state. Its second describes the entire labelled input tree. Fresh variables `l` and `r` in a fork preserve the identity and order of its children. The generator emits both the Lean family and the InvarGenT declaration from those same rows. The two emitted sections are checked on every replay. [Generated constructors and consumer](unique.gadt) · [Generator](replay.py)

**For every finite tree `t`, the following three statements are equivalent.**

1. There is a finite constructor value of type `Evidence(one,t)`.
2. The search on `t` returns a path.
3. The number of marked leaves in `t` is one.

For soundness, read a witness from its root. A fork witness supplies evidence that the sibling is empty as well as evidence for the child containing the mark. Induction on the witness gives the exact path the search returns. Following it in the original tree reaches a mark. For completeness, recurse on the tree. Each child search supplies the evidence appropriate to its outcome. When the parent returns a hit or zero, its transition identifies the constructor to apply. A separate induction adds the child mark counts and relates the result to each of the three search outcomes. These arguments cover trees of arbitrary finite depth. [Lean definitions and proofs `certify`, `sound`, `route_hits`, `unique_iff`, `empty_iff` and `exactly_one`](Unique.lean)

The three tags are necessary for a total deterministic bottom-up recognizer of success. Take a clear leaf, a marked leaf and a fork with two marks. At the root only the marked leaf succeeds. Placing each of the other two trees in the hole of `Fork(□,Mark)` accepts the clear leaf and rejects the two-mark fork. Thus every pair has a distinguishing context. Three is a bound on *control states*. The path and the recursive proof can both grow with the input.

## What the InvarGenT run establishes

The consumer has the written interface `∀a. Evidence(One,a) → Tree a → Path`. It follows the branch selected by the proof and returns an ordinary path. Its caller supplies an explicit constructor value. On an already certified tree the consumer follows only the path, whereas certifying an arbitrary tree may require inspecting every node. This distinction matters if a tree is certified once and handed to several clients. [Consumer `locate`](unique.gadt)

The producer `choose` has two branches with different tree shapes. Each branch explicitly builds its tree and proof. Its result type is unwritten. InvarGenT infers

```text
val choose : Bool → ∃a.(Tree a, Evidence (One, a))
```

Opening one result yields precisely the common index `locate` needs. The replay checks the inferred scheme and executes both branches in generated OCaml. It also checks three type rejections. Swapping the leaves makes a valid proof refer to a different one-mark tree. Supplying two mark witnesses prevents construction of the claimed one-mark proof. Finally, opening two packages independently gives the caller no equality between their private shapes. That client fails even though each package individually contains a valid proof. [Runnable source](unique.gadt) · [Compiler controls](replay.py)

The finite-state abstraction and the consumer are supplied in this experiment. Constructor generation is automatic once the tag map and its transition law are available. Lean's `certify` builds evidence for an arbitrary tree by structural recursion. The two InvarGenT producer branches show existential inference over that new vocabulary. Recovering a suitable abstraction from source code and inserting a call to a certifier at an ordinary program boundary are further synthesis problems.

## Relation to existing constructions

- **Indexed GADTs.** Matching a constructor can refine an index in the branch that handles it. Xi, Chen and Chen's type representations tie a runtime witness to the type it represents. Here matching a witness for a fork exposes the exact child indices as well as their control states. Generating those declarations makes this established mechanism available to a new consumer. [Xi, Chen and Chen, *Guarded Recursive Datatype Constructors*](https://www.cs.bu.edu/~hwxi/atslangweb/MYDATA/GRDT-popl03.pdf)
- **Finite tree automata.** For a ranked constructor `f` of arity `k`, turn the transition `f(q₁,…,qₖ) → q` into a constructor taking one `E(qᵢ,xᵢ)` per child and returning `E(q,f(x₁,…,xₖ))`. Distinct variables make the child indices independent. A finite constructor value spells out an automaton run, and every accepting run builds such a value by induction. Forget the input index and the rules are a regular tree grammar, one nonterminal per state. Determinism gives a unique run for a fixed tree. A nondeterministic machine may give several witnesses, which matters to a consumer that computes with them. [Comon et al., *Tree Automata Techniques and Applications*, chapters 1–2](https://inria.hal.science/hal-03367725)
- **Datatype refinement.** Freeman and Pfenning let the programmer specify recursive subclasses of an ML datatype and infer types using those distinctions. The `zero` and `one` rows above could be read as two such subclasses of the same tree datatype. Jones and Ramsay infer constructor restrictions for pattern-match safety. Here the requested output is a recursive witness family whose elimination computes a path and whose index can be shared through an existential package. An evaluation should measure both the accepted input language and what a client can recover on opening the result. [Freeman and Pfenning, *Refinement Types for ML*](https://www.cs.cmu.edu/~fp/papers/pldi91.pdf) · [Jones and Ramsay, *Intensional Datatype Refinement*](https://arxiv.org/abs/2008.01452)

## What changes if a branch tests sibling equality?

Consider a second algorithm that accepts `Fork(l,r)` exactly when `l = r`, over the same free algebra of finite labelled trees. Any deterministic bottom-up state assignment to recognize this diagonal must distinguish every pair of different trees. If `s` and `t` had the same state, the parent would receive the same pair of states on `Fork(s,s)` and `Fork(s,t)`. The first must succeed and the second must fail. There are infinitely many trees, so no finite assignment suffices. Determinization extends the obstruction to ordinary nondeterministic finite tree automata. Comparing the two finite *tags* in the unique-mark search poses no such problem. [Lean lemma `diagonal_separates`](Unique.lean) · [Tree automata with sibling constraints, §4.3](https://inria.hal.science/hal-03367725)

A GADT can still express the diagonal by repeating the index, for example `Twin : ∀a. Tree a → EqualFork(Fork(a,a))`. A client holding `Tree(Fork(l,r))` can pair it with this witness only when the indices agree. On an unknown input, a certifier must establish that agreement, for example by structural comparison returning an equality witness. In this example the index records every leaf tag, so equal indices describe equal trees. Adding an unindexed payload would restrict this technique to equality of the indexed shape. Equality of payloads would need its own representation or comparison evidence. A sibling-equality transition belongs to a studied constrained automaton model with decidable emptiness. That model needs its own decision procedure. [Review 52's indexed comparison](../compare_term_indices.gadt) · [Comon et al., §4.3.1–3](https://inria.hal.science/hal-03367725)

## Research programme

1. **Extract the finite observations from source.** Start with pure, terminating structural folds whose clauses inspect their child results by pattern matching. Use the tested result constructors as candidate states. Check for each input constructor that equal child tags imply equal parent tags for all payloads. The path payload here is a positive control. A branch that accepts only equal-height child trees is a counterexample to an abstraction retaining just their root tags. Deliver either a validated transition table or two argument tuples that the proposed tags conflate. Restrict the first extractor to a finite pattern fragment in which these obligations are decidable.
2. **Synthesize the interface for a client observation.** Mark the accepting states for the question the caller asks. Remove unreachable states and states from which no accepting context is reachable. Minimize a completed deterministic automaton by distinguishability in contexts. Measure state count, constructor count, and which indices the client must share. For unique mark, the two distinguishing contexts above give an independent minimality check. If a consumer returns data, check its output separately. Merging states that agree on success can discard information used to compute the result.
3. **Elaborate producers and consumers.** For the validated fragment, generate a structural certifier and prove that erasing its evidence preserves the source verdict and observable result. An indexed input `Tree a` should keep its public `a` on success. A producer starting with an unindexed tree can reify the shape and return an optional `∃a.(Tree a, Evidence(One,a))`. Test that these interfaces compose with existing existential inference, that mismatched trees still fail to type-check, and that a typed caller can reuse the proof. Compare separate proof construction with construction fused into the original traversal.
4. **Admit equality at a stated boundary.** Begin with structural equality between immediate children whose full labelled trees are reflected in the indices. Generate a nonlinear result index and an equality-producing comparison. Use the diagonal as the first test, then add a payload omitted from the index as the rejection control. The proof obligation is equivalence to the source comparison. Report separately the cost of checking one given tree and the decision problem of whether *any* tree inhabits the generated family.

## Replay

From this directory, with Python 3 and Lean 4.19 on the path, run

```sh
python3 replay.py
```

For the package, path and rejection checks, also put OCaml on the path and supply an InvarGenT executable.

```sh
python3 replay.py --compiler /path/to/InvarGenT.native
```

The full replay passed with Lean 4.19.0, OCaml 5.5.1 and the local review 54 InvarGenT compatibility build (`jointdecl5455`). It checked five constructors, the existential scheme above, paths at the root and at depth two, and all three rejections. The default replay verifies that the recorded declarations match fresh generation. After changing the search, use `--write` to replace the two generated sections and rerun the proofs. `--lean /path/to/lean` selects an executable. All compiler outputs are temporary. [Replay driver](replay.py)
