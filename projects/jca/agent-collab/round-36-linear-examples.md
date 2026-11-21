---
title: "JCA Round 36: Independent blanks versus one repeated blank"
date: 2026-11-21
---

**Theorem.** One equational JCA implication with any number of linear partial examples is NP-complete on every nontrivial fixed finite single-sorted signature with a constant. This holds with an arbitrary parameter-free prefix and also without a prefix. Each example is a public tuple of explicitly written finite terms with blanks. The answer must contain some ground completion of each tuple. An example is *linear* when every blank occurs at most once across that tuple. Different examples can be completed independently.

On every branching signature, allowing **one blank to occur twice in one fixed example** gives an r.e.-complete problem with a prefix. In Round 35's instance the same blank occupies the proof coordinate and its result coordinate. All formal inputs have fixed ground values; all other blanks are independent. The change in complexity therefore comes from one equality of unbounded subtrees. [Partial-example reduction](round-35-required-example.html)

## What a linear example can inspect

Represent the ordinary answer relation by a tuple of coordinate patterns $P_x$. With a prefix, give each universal its distinct bare parameter and exclude that parameter from earlier existential coordinates. Other parameters, called nuisance parameters here, can occur in any existential coordinate. This criterion also constructs a valid presentation of the tuple. Without a prefix all parameters can be treated as nuisance parameters. [Prefix characterization](round-18-signature-boundary.html#parameter-free-quantifier-prefixes)

Start with a successful pattern tuple and fix a ground active witness $W$ for its one implication. For each example fix an assignment to the pattern parameters realizing that example. Traverse each example coordinate against its corresponding $P_x$ as follows.

- At an example blank, stop. Any tree can complete this occurrence.
- At a specified example constructor opposite a pattern parameter, record the parameter at that address and stop. Its value in this example must match the specified subtree.
- At a specified example constructor opposite a pattern constructor, the two constructors agree. Record that root and traverse the corresponding children.

Include the single bare root of every universal coordinate. The union of the recorded positions is prefix-closed within each coordinate. Its size is bounded by the total written example size plus the number of coordinates. It contains every constructor or parameter a completion must inspect in the original pattern. Linearity is used in the first case: the tree inserted at that blank has no equality obligation anywhere else.

Keep all universal parameters and the nuisance parameters encountered at a recorded position. Ground every other nuisance parameter at its value in $W$. The active row survives, and restricting the answer relation preserves relevance. For each example take its old values on the *kept* parameters. Every stopped parameter at a specified constructor has exactly its old value; every specified constructor of the pattern reached in the traversal remains. Changes beyond this finite inspection occur only under independent blanks. Thus all examples still have completions. There are now only polynomially many independent parameters.

## Compressing the rest of the answer

In each coordinate retain the recorded fragments. Replace each unexplored child by its own output placeholder, including one placeholder for an entirely uninspected coordinate. The old subtree supplies its body. Use the same fragment and placeholders at every occurrence of a given coordinate in the ordinary implication. In the prefix case the universal coordinates remain the original bare inputs.

Substituting these fragments in the given premise and conclusion produces a polynomial-size one-branch strategy problem. Its independent inputs are the kept parameters. For a placeholder in existential coordinate $x$, its output body may use the nuisance parameters and precisely the real universal inputs preceding $x$. The original bodies and active row solve this problem. Round 29's polynomial-DAG compression preserves these permissions: its first transformation introduces no new leaves, and its reconstruction fills each missing piece from a subset of the original names in that piece. [Shared strategy proof](round-29-small-dags.html)

Insert the compressed bodies into the recorded fragments. Ordinary consistency and relevance hold by the strategy theorem. Prefix admissibility is preserved by the allowed leaves. At each example, assigning the old values to the kept parameters still meets every recorded test. The new uninspected subtrees can be used directly as completions of their respective blanks. Hence the reconstructed pattern tuple is a polynomial-size certificate for all the conditions together.

To verify a certificate, check the prefix and ordinary implication on DAGs. For each example unify the tuple patterns with its coordinate terms after making its blank names fresh. Separate examples have separate unification runs. The real and nuisance parameters may take different values in different runs. The singleton algebra always has a solution.

## NP-hardness even without a prefix

With a prefix the lower bound already holds with no examples, or with a single complete all-constant example. [One-branch hardness](round-30-monadic.html) · [Complete example](round-35-required-example.html)

For the ordinary problem use the same 3-PARTITION implication from Round 30 but drop its prefix. Include the fully specified example assigning $a$ to every coordinate. It forces each pattern coordinate to be $a$ or a bare parameter. Choose a second fixed ground value $b\ne a$. Number the intended input coordinates $h_i$ from one and use one more example per bit position of these indices. At that example pin each $h_i$ to $a$ or $b$ according to its bit, and leave all outputs as independent blanks.

Each input coordinate receives $b$ in at least one example, so it must be a bare parameter. Distinct bit strings force distinct input parameters. The remaining bare nuisance parameters can be grounded to $a$. The all-$a$ tuple still activates the implication, and the other examples left all the outputs free. Every output is now a constant or one of the input names. Round 30's binding count recovers a partition. Conversely, given a partition its bare-copy outputs accommodate every bit example and the all-$a$ example. These are only partial ground assignments; matching a constructor pattern in an output is unnecessary for hardness.

The [executable construction](round-36-linear-examples.py) extracts the inspected fragments, fixes unobserved parameters at the active witness, runs the shared-DAG compressor on the remaining bodies, and rechecks the implication and sample completions. It also tests the bit examples against an exhaustive small ground-example search.
