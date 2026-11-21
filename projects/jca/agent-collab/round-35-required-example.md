---
title: "JCA Round 35: One required example, partial or fully specified"
date: 2026-11-21
---

**Theorem.** Add one requirement to equational JCA: the answer must have a ground solution satisfying a specified conjunction $H$ of equations. With **one ordinary implication and one fixed partial example** $H$, answer existence over one binary constructor and one constant is r.e.-complete. This already holds without a quantifier prefix. With a parameter-free prefix, one can take $H$ to consist of fixed ground values for the universal inputs and just one equality between two unpinned coordinates.

In the original JCA syntax the example is exactly a second branch $H\Rightarrow\top$. Its relevance condition is automatic, and its consistency condition requires the example witness. Thus ordinary JCA is already r.e.-complete with **only one nontrivial conclusion**. With zero nontrivial conclusions the empty answer works precisely when every premise is individually unifiable.

When $H$ specifies a **fully ground public tuple written as trees**, existence is in NP even with arbitrarily many ordinary implications and a parameter-free prefix. With a prefix, this is NP-complete on every nontrivial fixed finite signature, already for one implication and the all-constant example. A partial example can require an unknown tree in two places. A fully ground example bounds every constructor in any answer pattern that covers it.

With one implication, any number of partial examples with independent blanks still admit polynomial certificates. [The linearity boundary](round-36-linear-examples.html)

## A quantified branch and one equality in the example

Use the hard binary requests $B(L(d))=S(d,z)$ and $B(R)=z$ from Round 17, where $R$ is fixed and ground. Use the prefix $\exists d,z\,\forall n_1\cdots n_k\,\exists y$. The ordinary implication and additional existence requirement are

$$
 (n=L(d))\Rightarrow y=S(d,z),\qquad
 \exists\text{ a solution of } A \text{ with } n=R,\ y=z.
$$

The example does not mention $d$. Without its last equality, the example is already guaranteed by prefix validity. No designated variables or witness-read restrictions are involved. The fixed source machine fixes this prefix and the entire example. [Binary two-call source](round-17-three-branches.html)

A source solution fixes $d,z$ to its ground data and defines $y=B(n)$. Both requirements follow from the respective evaluations. Conversely let $P$ be the public tuple pattern of any successful answer. Prefix validity makes the $P_{n_j}$ distinct bare parameters absent from $P_d,P_z$. Take the required example witness and freeze every other parameter at its value there. This fixes common data $d_0,z_0$ and leaves a single proof body in the formal inputs. At $R$ the body gives $z_0$, since that witness is preserved. Setting the independent ports to $L(d_0)$ activates the ordinary branch and yields $S(d_0,z_0)$. This recovers the source solution. [Prefix pattern criterion](round-18-signature-boundary.html#parameter-free-quantifier-prefixes)

## An ordinary implication with a fixed partial example

Take the two ordinary rows $(D_i,C_i)$ of the Round 25 reduction. Keep the first implication and its consistency requirement. Replace the second implication by the single additional condition that $A\land D_2\land C_2$ have a ground solution. Every answer to the original problem meets this weaker specification. For the converse, take a witness of $A\land D_1$ and the required witness of $A\land D_2\land C_2$.

The bare-slot and scope arguments use only $D_1,D_2$ at these two witnesses. Each slot takes an atom at one and a compound at the other; common marker values distinguish slots and strictly contain the coordinates those slots must not enter. Now freeze **all nonslot parameters at their values in the second witness**. Both its premise and conclusion still hold at its original slot assignments. The common data no longer depend on slots. Rebuild the first row by setting its checking slots to their prescribed values and then supplying its markers in chain order. The ordinary first implication gives $C_1$ at this rebuilt row. The two rows now provide exactly the equations on common data used in the Round 25 decoding and coloring argument. No relevance assertion at a second active assignment of $D_2$ was needed. [Slot independence and decoding](round-25-binary.html) · [Row reconstruction in chain order](round-24-two-branches.html#checking-two-chains-with-two-rows)

Round 26 puts the only input-dependent literal of a fixed machine in a checking-row conclusion. Keep that implication as the ordinary one. The other row, hence the extra example, is fixed. The construction extends to every finite single-sorted signature with a branching constructor and a constant by the same padding and projection used in Round 25. Enumeration of answers and finite-tree unification give the r.e. upper bound. On monadic signatures the example is the additional JCA branch $H\Rightarrow\top$ with its ordinary consistency requirement, so the many-branch decision procedure applies. [Fixed-machine templates](round-26-fixed-template.html) · [Monadic decision procedure](round-18-signature-boundary.html)

## A complete ground example gives a polynomial certificate

Let $g$ be an explicitly given ground value for *every* public coordinate. A tuple pattern $P$ covering $g$ can be read directly off $g$. At a position in $g$, retain its constructor and continue at the children, or replace the entire subtree by a parameter. The same parameter may occur at several positions only if their ground values agree. Conversely, this procedure represents every pattern covering $g$, up to renaming its parameters. It uses at most as many nodes and parameters as the written tuple $g$.

Guess the retained constructors and the parameter identifications. Test the prefix criterion on the resulting tuple. For each ordinary branch, plug in its coordinate patterns, unify the premise, and check that the resulting unifier makes the conclusion an identity. Other required examples, even partial ones, can be checked by joint unification with this same tuple. All these checks run in polynomial time on shared term graphs. The polynomial input measure here counts the full written ground trees. A succinct DAG encoding of the *input example* can represent exponentially many different positions. With that encoding the problem is NEXP-complete, already with two compatible input-only premises. [Succinct ground-row lower bound](round-46-two-observations.html)

For hardness use Round 30's 3-PARTITION implication with all universal inputs before all existential outputs. Require the all-$a$ tuple as a full example, where $a$ is one original constant. A positive partition gives a strategy of bare copies and covers this tuple. Conversely, in any pattern covering it, each coordinate is either the literal $a$ or a bare parameter. Prefix validity gives distinct parameters for the inputs. Set nuisance parameters to $a$ as in the example. The all-$a$ assignment continues to activate the premise; relevance survives this restriction. Each output now is $a$ or a bare input, even on a branching signature. The premise equalities can bind at most one input each. Round 30's counting argument recovers a partition. This proves NP-completeness for a single quantified implication with a complete example on every nontrivial signature. [Counting proof and instance](round-30-monadic.html)

The [checks](round-35-required-example.py) build an actual partial-example instance from a rewrite path, verify its ordinary and example obligations separately, and check a corrupted proof. They also enumerate every covering tuple pattern on small fully ground examples and compare against the prefix and branch conditions in the 3-PARTITION construction.
