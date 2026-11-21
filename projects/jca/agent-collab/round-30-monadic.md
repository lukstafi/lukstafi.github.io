---
title: "JCA Round 30: One quantified implication is NP-complete on every nontrivial signature"
date: 2026-11-21
---

**Theorem.** For every fixed finite single-sorted signature whose algebra of finite ground trees contains at least two elements, existence for one parameter-free quantified equational implication is NP-complete. Hardness already holds with all inputs before all outputs and no initial data. The one-element algebra always admits an answer.

The polynomial-certificate theorem supplies the upper bound. On a branching signature the coloring reduction works with the vertex coordinates as additional outputs. It remains to cover all monadic signatures, including an algebra consisting of just two constants. On these signatures the following hard inputs mention **only variables and equality**, with no constructor occurrences at all. [Polynomial certificate](round-29-small-dags.html) · [Branching lower bound](round-27-joint-pins.html#np-hardness-with-the-fixed-premise-yz)

## Each premise equality can bind at most one input

Start with 3-PARTITION, with \(3m\) positive integer weights \(w_i\) summing to \(mB\) and \(B/4<w_i<B/2\). The question is whether the weights can be assigned to \(m\) bins of total weight \(B\) each. The problem is NP-hard even with unary weights, so a construction of size \(O(mB)\) is polynomial. [Garey and Johnson, strong NP-completeness of 3-PARTITION](https://perso.limos.fr/~palafour/PAPERS/PDF/Garey-Johnson79.pdf)

For bin \(j\) introduce \(B+1\) distinct universal inputs \(h_{j,0},\ldots,h_{j,B}\). For item \(i\) introduce \(w_i+1\) distinct existential outputs \(y_{i,0},\ldots,y_{i,w_i}\). After all inputs and then all outputs, write one implication

$$
\bigwedge_i\ \bigwedge_{t=1}^{w_i} y_{i,0}=y_{i,t}
\quad\Longrightarrow\quad
\bigwedge_j\ \bigwedge_{s=1}^{B} h_{j,0}=h_{j,s}.
$$

Given a partition, use the anchor input \(h_{j,0}\) as \(y_{i,0}\) for each item assigned to bin \(j\). Use the other \(w_i\) outputs to read \(w_i\) different nonanchor inputs of the bin, allocating each of those inputs once. Each output body is a bare input. The premise now requires exactly the bin equalities in the conclusion and has a witness.

Conversely, instantiate the premise with any successful term strategy. A monadic term is a word of unary constructors applied to one input or to a constant. When unifying two such terms, stripping their common constructor prefix leaves an identity or at most one variable binding, as long as the equality is consistent. Substitution preserves the monadic form. Thus unifying \(mB\) premise equalities binds at most \(mB\) of the \(m(B+1)\) input names. At least \(m\) input names remain unbound.

Under this most general unifier all inputs in each bin have identical normal forms, because every active assignment satisfies the conclusion and distinct open terms in the nontrivial algebra can be separated. No two unbound names can therefore occur as coordinates in the same bin. It follows that there are exactly \(m\) unbound names, one in each bin. Every input's normal form is its bin's bare unbound name.

Within an item, the normalized output bodies must all agree. Either they are all an identical ground term, or they are one common unary word applied to the free name of one bin. In the latter case each original body is that same word on some input in that bin. Its premise equalities consequently connect only input names in this bin. A ground item contributes no bindings and is impossible: every one of the \(mB\) equalities must contribute a binding to reach the required total.

Assign each item to its resulting bin. Connecting a bin's \(B+1\) distinct input names requires at least \(B\) equalities there. Each assigned item supplies \(w_i\), and the sum over all bins is exactly \(mB\). Thus each bin receives total weight \(B\). The source bounds imply that each receives three items. This recovers a 3-partition.

The [executable check](round-30-monadic.py) constructs actual input/output implications and verifies strategies with bare input bodies and with unary words added to an entire item. On small balanced instances it compares the bin criterion against exhaustive output strategies over two constants, and on a negative instance also exhausts depth-one unary bodies.

## Designated coordinates under the trailing-witness convention

The same one-branch classification applies to the thesis-source trailing convention with \(K\subseteq T\) and its atomwise escape checks. Round 19 proves that a public pattern admits a valid presentation precisely when its projection away from \(T\) passes the retained prefix game. Thus remove the substituted public coordinates from their original prefix positions and append them as final existential outputs. Keep their original occurrences in \(D,C\). The resulting parameter-free prefix game tests exactly that projection. Its successful strategy gives a public pattern that Round 19 presents by one equation per coordinate using fresh leaves, satisfying the escape checks. The empty designated set gives the lower bound. For leading fresh parameters, the classification depends on the witness read permissions. [Unrestricted witnesses](round-31-leading.html) · [One forbidden read](round-34-one-read.html). [Presentation equivalence](round-19-designated-parameters.html#trailing-witnesses-admit-a-direct-pattern-presentation)
