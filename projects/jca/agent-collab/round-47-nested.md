---
title: "JCA Round 47: A chain of input premises admits a polynomial algorithm"
date: 2026-11-21
---

**Theorem.** Take the parameter-free prefix $\forall H\,\exists Y$. Suppose every premise uses only inputs and their sets of satisfying assignments are totally ordered by inclusion. Answer existence is decidable in polynomial time for *any* number of branches on a fixed finite single-sorted signature with a constant. The problem is P-complete on branching signatures. Two jointly satisfiable premises without the containment requirement already give NEXP-completeness. [Two compatible premises](round-46-two-observations.html) · [P-hardness of one implication](round-21-one-input.html)

Order the premises from weakest to strongest, so $D_{i+1}\models D_i$. An inconsistent premise rules out an answer by ordinary consistency. Otherwise an mgu for $D_j$ tests $D_j\models D_i$ by checking each equality of $D_i$ after unification. Pairwise tests suffice to find the order. Work in a nontrivial ground algebra below. The singleton algebra satisfies every equality.

For each $i$, compute an idempotent input mgu $\mu_i$ of $D_i$, and treat its surviving input names as distinct rigid letters. Check by finite-tree unification that

$$
 (C_1\land\cdots\land C_i)\mu_i
$$

can be solved for the outputs $Y$. Accept if all these checks succeed. They use polynomial time on shared term graphs. Each check works on the original written equations and input mgu. A successful strategy necessarily satisfies them: at the generic inputs of branch $i$, every earlier branch also applies. Universal equality of open terms follows from separation in the free ground algebra. The outputs of an arbitrary answer can be specialized to term strategies at one common witness, obtainable at any solution of the strongest input premise.

## Lift the output bindings one stage at a time

Initially each output template is a separate unassigned output name. After stage $i-1$, consider any input row satisfying $D_{i-1}$. Maintain two properties:

- All earlier conclusions that apply under their respective premises already hold as term identities for any further choice of the unassigned outputs as input terms.
- At rows of $D_{i-1}$ the tuples satisfying all the earlier conclusions are *exactly* the instances of the current templates there. The remaining output names are independent.

Both statements are immediate for the initial templates before the first branch. At stage $i$, substitute the current templates in $C_i$ and the input mgu $\mu_i$ in the resulting terms. Unify for the remaining output names, with residual input letters rigid. This succeeds by the cumulative test above. Indeed the previous solved output equations describe all possible solutions of the earlier conclusions at these stronger inputs. This equivalence holds also with arbitrary formal letters as values: decomposing constructors and eliminating output variables derived each solved equation, and substituting the solved forms gives back every original equality.

Lift each new binding to the global templates by using its rigid letters as the *original input names they represent*. At every row of $D_i$ these input coordinates really have precisely the freely assigned residual values. The lifted equations therefore give the entire unifier relation at those rows and imply $C_i$. Earlier branch identities remain identities under the new output bindings. Rows outside $D_i$ introduce no condition from this branch. This proves the induction statements. Finally put the base constant for each still-free output. The resulting terms satisfy every branch and give a valid answer. Every premise has an active row because it uses only independent inputs and was checked for consistency.

For example $\top\Rightarrow y=f(h,z)$ leaves the choice of $z$ open. Add $h=f(k,k)\Rightarrow z=k$. The second test lifts $z=k$ to both templates, giving $y=f(h,k)$ everywhere. The first conclusion survives on rows where the second premise fails. With $D=\top$ and an arbitrary unification instance in the conclusion on outputs alone, finite-tree unification reduces to this problem, giving the stated branching-signature lower bound.

Equivalently, for a chain with consistent premises the semantic sentence $\forall H\,\exists Y.\bigwedge_i(D_i\Rightarrow C_i)$ already suffices for a term answer. At the inputs of $D_i$ the sentence implies solvability of the cumulative conjunction there. A conjunction of free-term equations solvable for all residual inputs admits output terms in those inputs by the prefix pattern criterion. This yields the generic tests. The chain supplies the stronger fact that the term choices for its several implications can be lifted to one common strategy. [Prefix pattern criterion](round-18-signature-boundary.html#parameter-free-quantifier-prefixes)

For a crossing pair the distinction already appears with two inputs and one output. Take $h=a\Rightarrow y=k$ and $k=a\Rightarrow y=h$. At the intersection, both require $y=a$. Everywhere else at most one applies, so a semantic choice exists at every input. No term $B(h,k)$ works. A compound term misses $a$ at the intersection. A literal cannot return every $k$ on the first branch. Each bare input fails one of the branches. In the hard family the same promise of semantic feasibility coexists with NEXP-hard answer existence. [Semantic promise and hard family](round-46-two-observations.html#semantic-feasibility-and-the-size-of-an-answer)

The [constructive check](round-47-nested.py) implements stagewise lifting and compares its decisions with every possible term strategy for 1,000 three-branch instances over two constants. It also checks a binary lifting example and an input pair that violates the chain hypothesis.
