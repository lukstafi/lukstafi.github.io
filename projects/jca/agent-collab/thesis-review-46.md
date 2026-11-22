---
title: "Can the admission and package predicates express the same induction hypothesis?"
date: 2026-11-22
---

A recursive function returns a bit or an error. Its caller only needs to rule out the error. Suppose the strongest description of its behaviour says that it returns its input bit. Keeping that equality can cost an extra package key. Forgetting which bit came in can give a one-key induction hypothesis that proves the caller safe. How can we tell whether a given hypothesis fits the interface? For the supplier clauses in which each call opens at every admitted key, there is an exact test that chooses admission and the package together. [Formal proofs](thesis-review-46.lean)

## One recursive call that can forget its input {#flip}

Let $x$ be a bit. The base returns $x$. The recursive arm calls at the opposite bit and flips the returned bit. Flipping an error propagates the error. The least relation closed under these suppliers is $r=x$. The base requires both diagonal pairs, and the recursive arm preserves the diagonal.

With just one possible key, each legal input must admit it. The two inputs therefore open exactly the same set of results. The least relation requires different sets and cannot be expressed. But the single package “the result is a bit” contains both base results, survives the flip, and excludes the error. If the caller also requires $r=x$, two keys suffice by admitting only the key for the input bit. Thus failure to express the least relation tells us something about that particular induction hypothesis. A weaker one can still satisfy the original caller. [Lean proofs in the namespace `Flip`](thesis-review-46.lean)

## What recursive rules see {#opening}

Write $A(x,k)$ when input $x$ admits key $k$, and $P(k,r)$ when the package at $k$ permits result $r$. A key can be a tuple. Any private package witnesses have already been quantified inside $P$. The relation available at an all-keys opening is
$$
 S(x,r)\iff \forall k\, (A(x,k)\Rightarrow P(k,r)).
$$

Fix the local values of a supplier clause so that its static premises hold. The clause opens a finite list $(y_i,s_i)$, returns $t$ at $x$, and must store $t$ at every key admitted at $x$. Its entire obligation is
$$
 \bigwedge_i S(y_i,s_i)\ \Longrightarrow\ S(x,t).
$$
An empty list gives a base rule. A caller whose premises only observe opened results likewise tests $S$ directly. Thus two schemes with the same $S$ pass exactly the same tests of these forms. A caller that explicitly demands a particular typing also needs an admission check. [Supplier equivalence in Lean](thesis-review-46.lean) · [Scope of all-keys opening](thesis-review-39.html#all)

Starting with the empty $S$, the direct supplier iteration reaches the least closed relation by $\omega$. Every derived observation has a finite proof tree. Conversely, attaching the finitely many trees for a rule's premises gives a tree for its conclusion. If all input values can themselves serve as keys, admitting just $k=x$ and storing $P(k,r)=S(k,r)$ realizes any such relation. With downward-preserved caller requirements and this unrestricted interface, testing the caller on the least relation settles semantic existence. A prescribed family of keys adds a representation problem, as the bit example shows. Even the unrestricted iteration can require infinitely many finite steps when a small solution exists. Base zero and successor over the integers keep introducing new natural numbers although the single inequality $r\ge0$ is inductive. [Finite derivation trees](thesis-review-23.html) · [Why the original Table 4.4 jump can repeat forever](thesis-review-3.html#update)

## Choosing compatible witnesses {#fit}

Fix lower and upper admission bounds $L_x\subseteq U_x$. Let $H(x,r)$ list observations that must open. An obligation $i$ at input $x_i$ asks for one admitted key from a set $C_i$ that rejects every result in a set $B_i$. To exclude a single observation, take $B_i=\{r\}$. To require an inhabited menu, take $B_i=\varnothing$ and allow any key. Several observations may each have their own rejecting key. Put them in the same $B_i$ only when one key must reject them all.

**Witness criterion.** Admission and package relations satisfying these requirements exist exactly when each obligation can be assigned a key $k_i$ obeying all three conditions.

1. $k_i\in C_i\cap U_{x_i}$.
2. Whenever $k_i\in L_y$, none of the results in $B_i$ is required to open at $y$.
3. Whenever $k_i=k_j$, none of the results in $B_i$ is required to open at $x_j$. This includes $j=i$.

For necessity, choose the witnessing key in a satisfying scheme. Every mandatory or chosen admission at that key forces it to store the results required at that input. Each of the three conditions follows. Conversely, admit exactly the mandatory and chosen keys. The package at each key collects the required results from all inputs admitting it.
$$
 A_x=L_x\cup\{k_i:x_i=x\},\qquad
 P(k,r)\iff\exists y\,(k\in A_y\land H(y,r)).
$$
Every observation in $H$ opens. If $P(k_i,r)$ held for some $r\in B_i$, its source $y$ would either admit $k_i$ mandatorily or be the input of another obligation choosing $k_i$. The last two conditions rule out both sources. These formulas recover both predicates from the witnesses. [Lean theorems `construct` and `simultaneous_fit`](thesis-review-46.lean)

**Joint inference.** Given a proposed $S$, set $H=S$, demand an admission at each legal input, and demand a rejecting key for each $(x,r)$ outside $S$. The criterion now realizes $S$ *exactly*. It follows that a joint solution exists iff some $S$ satisfies the supplier and caller clauses and its witness requirements are compatible. Extra caller demands of the form “admit a key in $C$” can be included among the obligations. Each key rejects a rectangle of observations, the product of the inputs admitting it and the results it rejects. In a finite table these rectangles cover the complement of $S$. The mandatory admissions and key restrictions say which rectangles a particular key can cover. [Lean theorem `joint_solution`](thesis-review-46.lean) · [Cornaz and Fonlupt on biclique covers and colouring](https://doi.org/10.1016/j.disc.2006.01.010)

## A failure can require many callers {#conflicts}

Take a cycle of inputs. At each vertex $x$, the base suppliers require its two neighbours to open as results. The caller at $x$ excludes the result $x$. Give every input the same two possible keys. A key witnessing the caller at $x$ rejects $x$. An adjacent input must open $x$, so its caller witness must choose a different key. Conversely, given any proper two-colouring, admit the colour of each vertex and store, at that colour, the neighbours of every vertex using it. Every base and caller passes. The argument works for any graph and any set of keys. [Lean theorem `graph_feasible`](thesis-review-46.lean)

A failed check can require arbitrarily many callers, even with two keys. On a cycle of length $2n+1$ for $n\ge1$, put callers only at vertices $0,2,\ldots,2n$ in cyclic order. A vertex with a caller needs a key excluding itself. At every other vertex just choose an admitted key. Two neighbours must choose different keys whenever either has a caller. Conversely, a colouring satisfying those inequalities constructs a scheme by the same storage rule. Every edge of the cycle has a caller at one end, so no two-colouring works. Remove any one of the $n+1$ callers. At least one edge now has no caller at either end. The remaining inequalities lie on paths and admit an alternating colouring. All the bases and all the nonempty-menu requirements still hold. Thus every proper subset of these callers is compatible, even though their union fails.

## What the induction jump can use {#jump}

For a proposed invariant there are now two distinct explanations of failure. A supplier counterexample gives recursive results in $S$ whose conclusion falls outside $S$. A witness conflict can occur even when every supplier preserves $S$. Repeating the supplier check will then return the same answer. The bit example shows how the jump can enlarge the opening, preserve the caller guarantee and reconstruct the predicates.

On finite input, result and key sets the witness conditions are a finite assignment problem. For an infinite domain the construction gives semantic relations. An InvarGenT implementation must also express them in its answer language and verify the exported scheme against the original clauses. The actual Table 4.4 update uses abduction, generalization and an induction jump. The equivalence here gives a specification for a candidate that such a jump might propose. For a finite library of possible key supports, a failed caller can guide a complete bounded search whenever each policy check terminates. [Refinement from a failed derivation](thesis-review-47.html#search) [Table 4.4](../lukstafi-phd-thesis.pdf#page=71) · [How InvarGenT checks a moving admission](thesis-review-45.html#compiler)

The companion proof checks with Lean 4.19 and mathlib v4.19.0.
