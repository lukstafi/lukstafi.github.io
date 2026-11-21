---
title: "JCA Round 29: One quantified branch has polynomial-size certificates"
date: 2026-11-21
---

**Theorem.** One parameter-free equational JCA implication under an arbitrary quantifier prefix is in NP for every fixed finite single-sorted signature with a constant. Data and output bodies have a successful representation by a polynomial-size directed acyclic term graph whenever an answer exists. Over a branching signature the problem is NP-complete, even with all inputs before all outputs. [Three-block lower bound](round-27-joint-pins.html#np-hardness-with-the-fixed-premise-yz)

Round 28 bounds the depth of a successful strategy, but a shallow tree can still have exponentially many differently marked copies of the same subtree. To control their representation, retain the parts of each body actually inspected in a derivation of the input bindings. On the rest of each body we need only preserve its value after applying those bindings and the set of input names it may read.

## The inspected fragments have polynomial size

Start with the strategy and common witness of [Round 28](round-28-compression.html). Put \(P=D[d,B]\) and \(Q=C[d,B]\). The ground values of every side and every public coordinate have depth \(L=O(n^2)\). Regard \(P,Q\) as the original syntax with pointers to the data terms and output bodies at their occurrences.

Run unification on \(P\) by the first-disagreement procedure. Keep each binding \(h_i=t_i\) as a pointer to the **raw subterm** on the other side of the disagreement. When following a path, dereference a previously bound input by jumping to its saved right-hand side. This represents the same substitutions as eager replacement. The directed graph of the saved definitions is acyclic. Adding an edge back to the current input would have failed the occurs check after dereferencing, or both sides would have been the same unbound variable.

Record the two traversals of the disagreement path for each binding. Inspect only the path that proves the binding, even if the search for it looked elsewhere. At each constructor record its head and the chosen child. Also record every dereferenced input name and the roots at the two endpoints. These records justify the equality \(h_i=t_i\) using the selected premise equation, decomposition of equal constructors, and previously justified bindings.

The substituted equation has the same ground value as at the witness. Each child step therefore consumes one level of a tree of depth at most \(L\). Between child steps there are at most \(|H|\) jumps between definitions, by acyclicity. Pointers from formula coordinates to a data term or body add at most one jump per raw visit. The entire record has polynomially many visits over at most \(|H|\) pivots. Every recorded location inside an original body or datum has an address of length at most \(L\).

In each datum and output body retain the recorded nodes and their ancestors. Give each unexplored child subtree a separate placeholder; use the same partial body at every occurrence of its public coordinate. A completely unexplored body gets one placeholder. The resulting finite fragments have polynomial total size because the signature has bounded arity. Record for each placeholder \(p\) the set \(A_p\) of inputs actually occurring in its omitted subtree. In a datum this set is empty. Restoring a term over any subset of \(A_p\) preserves the scope of the original strategy.

## Terms after applying the input bindings

Treat each unbound input as a distinct new rigid constant. Let \(T_h\) be the fully dereferenced term of input \(h\) in this enlarged ground algebra. For an unbound input it is its own rigid constant. Let \(U_p\) be the fully dereferenced value of the omitted body at placeholder \(p\). These terms may initially be huge. They satisfy three finite descriptions.

1. Reading the inspected fragments with \(h\) valued as \(T_h\) and \(p\) as \(U_p\) makes all equations of \(D,C\) identities. This follows from the successful original strategy and the most general unifier of its premise.
2. Each binding expression \(t_i\), read the same way, has value \(T_{h_i}\). Its pointer is into the original formula or an inspected fragment.
3. Each \(U_p\) is built using original constructors and the values \(T_h\) for \(h\in A_p\). The omitted open body is just such a construction.

We can satisfy these descriptions with polynomial-size ground DAGs. In the given solution, mark the values at explicit constructor nodes of the fragments and the original formulas, together with every new rigid constant. The expressions in item 2 use subexpressions of these same fragments and formulas. There are polynomially many marked values. Transform a ground term value by keeping its root and transforming its children if it is marked, and replacing it by a fixed original constant otherwise.

This transformation commutes with evaluation of all the displayed expressions, by induction through their explicit constructors. Items 1 and 2 survive, and the rigid constants keep their distinct identities. Item 3 survives as well. In a construction of \(U_p\), a generator transforms to the corresponding transformed \(T_h\). An unmarked constructor value transforms to the available base constant. At a marked constructor value, apply the constructor to its transformed children. Sharing one node per marked value, plus the base, bounds the whole collection of transformed terms by a polynomial.

For each \(p\), recover a small open body building its new \(U_p\). At a value equal to an allowed generator, use that generator's input name. Otherwise recursively construct it from its children. Item 3 guarantees that a rigid leaf is reached only when some generator covers it. Memoizing per value for this placeholder produces at most one body node per node of the polynomial DAG. There are polynomially many placeholders. Inserting all these bodies in the inspected fragments gives candidate data and strategies of polynomial total DAG size.

## Why the recovered strategies work

The unbound-input constants can be assigned arbitrary ground trees from the original signature. Assign each input \(h\) the corresponding ground instance of its transformed \(T_h\). The recovered bodies realize the transformed \(U_p\), so item 1 supplies a consistency witness.

Conversely, take **any** active input assignment for the recovered strategy. Replay the recorded traversals: every inspected constructor and input name remains at its recorded position. A jump uses a previously established equality between an input and the saved right-hand side. Decomposing the current active premise equality along the recorded children therefore proves the next binding with its recovered right-hand side. This forces all saved bindings. Their dependency graph remains acyclic because every new placeholder body uses a subset of its original input names.

On fixing the values of the unbound inputs, the recovered definitions determine all other inputs uniquely in dependency order. Item 2 and the recovered generator bodies show that the corresponding ground instances of the transformed \(T_h\) give exactly these values. Item 1 now gives every conclusion equality at this active assignment. This proves relevance.

To verify an NP certificate, guess the acyclic term graph of the strategy, check scopes, unify the instantiated premise with the finite-tree occurs check, and test whether its most general unifier equalizes each conclusion. All operations are polynomial on shared graphs. The proof bounds the certificate even on instances where expanding the shared bodies would destroy that bound.

The [executable construction](round-29-small-dags.py) traces raw subterm pointers, extracts the partial bodies, compresses the values over rigid letters, reconstructs the omitted terms from accessible generators, and checks the result using an independent unifier. It exercises all 404 examples of the preceding round. In a separate example with a 1,024-leaf output, the strategy shrinks from 347 distinct nodes to 32; the resulting premise still forces both input values and the entire output tree. These checks validate instances of the transformation. The polynomial bound is the counting argument above.

[Lean](round-29-generators.lean) checks that ground-value compression preserves the explicitly marked expressions and that it preserves generation by each permitted set of inputs, for arbitrary constructor arities. The lower bound extends to every nontrivial monadic signature as well. [Exact one-branch complexity](round-30-monadic.html)
