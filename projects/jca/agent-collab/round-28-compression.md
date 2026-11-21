---
title: "JCA Round 28: Every successful one-branch strategy has a bounded witness"
date: 2026-11-21
---

**Theorem.** One equational implication over finite ground trees is decidable under an arbitrary parameter-free quantifier prefix, including when outputs occur in its premise. For a fixed finite single-sorted signature with a constant, every successful instance of size \(n\) has a term strategy and an active witness of depth \(O(n^2)\). The ground values of its entire public tuple at that witness share a DAG of size \(O(n^2)\).

Take the initial existential data \(X\), universal inputs \(H\), and existential outputs \(Y\) in prefix order. A strategy fixes ground data \(d\) and a term \(B_y\) in earlier inputs for each output. Its instantiated premise \(P=D[d,B]\) must have a ground solution, and every such solution must satisfy \(Q=C[d,B]\). Every successful equational answer yields such a strategy by fixing its extra parameters at one joint witness. Scope is preserved throughout the proof below because the transformation never introduces an input name into a term. [Strategy characterization](round-20-one-branch.html#one-witness-determines-the-strategy-form)

## What one unification run needs to remember

Start with any successful strategy and choose a ground input assignment \(\eta\) satisfying \(P\). Evaluate the public coordinates and all syntactic subterms of the **original** \(D,C\) at this row. Let \(S\) be the set of distinct resulting ground values. Include unused public coordinates. The number \(s=|S|\) is at most the number of coordinate declarations and syntax nodes, independent of the size of the strategy. Call \(v\in S\) *fixed at the root* if it is the value of an explicit constructor application in \(D\) or \(C\), including a literal constant. Each of its immediate children belongs to \(S\).

Unify \(P\) as follows. While some current equality is not a syntactic identity, follow identical constructor heads to a first disagreement in that equality. The two terms have the same value at \(\eta\), so the disagreement is an unbound input \(h\) against a distinct term \(u\). The variable \(h\) cannot occur in \(u\), by finite-tree size. Record the path from this equation's root to the disagreement and apply the substitution \(h\mapsto u\) to every current equation. Previous substitutions preserve \(\eta\). Each step removes one input and there are at most \(|H|\) steps.

The composite substitution is a most general unifier. It turns every conclusion equality into an identity. Otherwise two distinct remaining terms could be separated by a ground assignment to the remaining inputs, contradicting relevance. Distinct terms over a nonsingleton free ground algebra admit such a separating assignment. The singleton algebra is immediate.

## Keep selected paths in the witness

Each recorded path runs in the common ground value of one premise equation, from a member of \(S\) to the value of the input \(h\), another member of \(S\). Along this path mark every occurrence of a value in \(S\). For consecutive marks at \(v\) and \(w\), retain the relative path from \(v\) to \(w\). Collect these relative paths by the **value** \(v\), across all pivots and all occurrences. At a fixed root use all its immediate children. At any other \(v\), the collected paths are incomparable because each ends at the first subsequent value in \(S\). A single pivot cannot visit \(v\) twice since size decreases, so at most \(|H|\) paths are collected there.

Define a transformation \(\pi(t)\) for each term over \(H\) whose value \(v=t\eta\) lies in \(S\).

1. If \(t\) is an input variable, keep it.
2. Otherwise, at a fixed root keep the constructor and transform its children.
3. At any other root, inspect the open subtrees \(t|_p\) at the retained paths for \(v\). Pack their transformed values in a fixed constructor context, using each exactly once in a fixed order. With no paths use a fixed constant.

The lookups in step 3 exist. The root under inspection is a constructor, and an input variable strictly inside a retained path would have its value in \(S\) before the first marked descendant. Recursion descends strictly in ground-value size. A binary constructor gives an ordinary list context, and a larger arity works with padding. In a monadic algebra incomparable paths number at most one and a unary application suffices for that path. In an algebra of constants they number zero.

**Substitution identity.** If a substitution \(\rho\) respects the witness, meaning \(\rho(h)\eta=\eta(h)\) for every input, set \(\widehat\rho(h)=\pi(\rho(h))\). Then

$$\pi(t\rho)=\pi(t)\widehat\rho.$$

For a variable this is the definition. At every other root the two calls select the same positions because their witness values coincide. Along any selected path all strict prefixes in \(t\) are constructors. Thus taking that subtree commutes with substitution, and induction on the smaller ground values gives the identity.

Set \(d'=\pi(d)\), \(B'_y=\pi(B_y)\), and \(\eta'(h)=\pi(\eta(h))\) componentwise. Induction on the original syntax shows that the new instantiated premise and conclusion are exactly \(\pi(P),\pi(Q)\) applied to their respective equation sides. This is why all explicit constructor occurrences in the original problem were fixed at the root. The substitution identity applied to \(\eta\) shows that \(\eta'\) still satisfies the new premise.

## Why the shortened premise still forces the conclusion

Take any assignment satisfying the new premise. Suppose it satisfies the transformed bindings from the first \(j-1\) pivots. Applying those substitutions to its equations preserves their truth. By the substitution identity, the current transformed equations are the images of the original equations just before pivot \(j\).

On the recorded path for that pivot, both original sides had constructor roots at every strict prefix. Between consecutive marks, the transformed sides have the same packing context or the same fixed constructor. Equality of those roots forces equality of the chosen child at its retained address. Following the marks to the end therefore forces \(h=\pi(u)\). This proves the \(j\)-th binding. It also covers an empty path, when the binding is the entire equation.

Induction forces every transformed binding at every active input. The original conclusions became identities after all the original bindings. Their images are identities after all the transformed bindings, again by the substitution identity. The new strategy therefore satisfies the conclusion at every active input.

## Bounds and decision procedure

For a ground value \(v\in S\), its transformed tree uses a context of \(O(|H|+1)\) nodes pointing only to transformed proper subvalues in \(S\). Sharing once per \(v\) gives a DAG of \(O(s(|H|+1))\) nodes for the transformed witness. Along any branch, the open transformation visits at most \(s\) distinguished values and inserts \(O(|H|+1)\) constructor levels per visit. In a signature of maximum arity \(q\), one explicit depth bound for the list construction is \(s\max(1,|H|)\): a padded list of \(b\) entries has depth at most \(b\) above its children, and a fixed root contributes one. A variable or constant has depth zero.

Hence finite enumeration of strategy terms of that depth, respecting scope, followed by ordinary unification and equalization decides existence. The expanded trees have at most \((c(n+1))^{s+1}\) nodes for a signature-dependent constant \(c\), since each visit makes at most \(\max(q,|H|)\) recursive calls. This gives a nondeterministic exponential-time bound directly. Over monadic signatures the terms already have polynomial size. The bound here concerns one joint witness of a single branch. A second branch may require a different witness and different paths through the very same output body. [Two-branch lower bound](round-25-binary.html)

The [general decision procedure](round-28-decision.py) enumerates ground values for the residuals of the joint unifier up to the proved depth bound. For each resulting public row it generates the output bodies by replacing subtrees by in-scope inputs of the same value, then checks the original implication. Its answers agree with exhaustive strategy search on all 1,296 single-premise-atom, single-conclusion-atom instances in a two-constant test algebra with two interleaved inputs and two outputs. The exhaustive procedure is intended for small instances.

The [executable compression](round-28-compression.py) records actual pivots, collects paths by ground value, rebuilds the strategy, and independently unifies the shortened premise to verify relevance. Its examples cover two different retained paths in distinct copies of the same value, a disagreement exposed by a previous binding, and unary and constant-only signatures. It also verifies 400 generated strategies with interleaved quantifiers and initial data.

[Lean](round-28-projection.lean) checks the substitution identity for binary terms and arbitrary finite selection plans whose retained paths exist and whose holes use the designated plan of their witness value. Round 29 uses the depth bound to obtain a polynomial-size certificate. [Shared strategy theorem](round-29-small-dags.html)
