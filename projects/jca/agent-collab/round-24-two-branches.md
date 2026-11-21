---
title: "JCA Round 24: Two ordinary branches are undecidable"
date: 2026-11-21
---

**Theorem.** Ordinary equational joint constraint abduction on finite trees is r.e.-complete with **two branches**, over a fixed signature containing just one binary constructor, one unary constructor and one constant. Each branch can have a single premise equality and a single conclusion equality. One ordinary branch is decidable by unifying its premise and conclusion, then taking a ground solution as the answer. Thus two is the exact branch threshold over this signature.

The reduction starts with simultaneous rigid $E$-unification (SREU) with ground hypotheses, one binary function and constants. Veanes constructs instances whose solutions are equivalent to machine acceptance. His variables occur in the goals and receive one common ground substitution. We first arrange these constraints into two inclusion chains of hypotheses. The chains are what fit in two JCA branches. [Veanes, §§2–3 and Theorem 8](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/kgc97.pdf)

Round 25 removes the unary constructor while keeping exactly two branches. [Binary-only compilation](round-25-binary.html)

## Checking two chains with two rows

Partition a collection of rigid constraints into two ordered groups, each having nested hypothesis sets $E_1\subseteq E_2\subseteq\cdots$ within that group. Make each constraint a separate proof with coordinates $Y_i,Z_i$ as in Round 23. Give proof $i$ its own list constructor $C_i$ and terminator $N_i$. Assign one group to check in row 1 and the other to check in row 2. Each proof's other row identifies its two lists. Its checking row prepends its source start term to $Z_i$ to obtain $Y_i$. [Slots, split edges and conversion certificates](round-23-two-rigid.html#two-proofs-in-opposite-rows)

Change the arguments of its edge markers. In the marker row for $i$, put in each marker:

- all public data coordinates,
- both proof coordinates of every proof being checked in this row,
- both proof coordinates of every **earlier** proof in $i$'s own group.

Every slot is still a distinct bare parameter. At its marker witness, its value strictly contains every listed coordinate, excluding that parameter from their patterns. Consequently the data are independent of all slots. A proof can use its own slots and slots of earlier proofs in its group. All others are excluded. To replay either row after grounding the nuisance parameters, assign checking slots their endpoints from the fixed data. Evaluate the checking proofs. Then supply the other group's markers in increasing order, computing each proof from its own and already supplied slots. This constructs both witnesses using one data tuple.

For soundness take proof $i$ and quotient the source algebra by $E_i(d)$ for the common projected data $d$. Use the counting interpretation of Round 23 for $C_i$. Interpret every other $C_j$ by projecting the first coordinate of the tail and returning count zero. All $N_j$ project to the same fixed source constant with count zero. The first coordinate of this interpretation is the same projection for every proof, followed by the respective quotient.

Each slot visible to proof $i$ has equal interpretations in its two rows. For a hypothesis of proof $j$ this follows from $E_j(d)\subseteq E_i(d)$. Both half-edges decode to equal classes with count zero. The list-end slots of an earlier proof $j$ agree because $C_j(e(t_j),N_j)$ and $N_j$ project identically and have count zero. The end slots of proof $i$ agree by the target-specific count. The shifted-list inference now gives $s_i(d)\equiv_{E_i(d)} t_i(d)$. Thus the allowed dependencies on earlier proofs cannot create a false positive.

For completeness, use the Round 23 forward construction for each conversion separately. These bodies use only their own slots, so both marker orders can be filled as above. The fixed binary/unary encoding in that round applies to all symbols here, including the separate list constructors. This proves the two-chain reduction. [Counting and fixed-signature interpretation](round-23-two-rigid.html#reading-the-two-congruences)

## Converting arbitrary ground hypotheses to two chains

Let the original rigid constraints be $E_i\vdash s_i=t_i$ for $1\le i\le k$. Use a private copy $c^i$ of every constant $c$ for each $i$, keeping the binary constructor $f$ common. Denote this recoloring by $u^i$. For a variable $x$ it introduces a fresh data variable $x_i$. Fix one original constant $a$. The following are finite systems of **ground** equations:

$$\begin{aligned}
E &= \bigcup_i E_i^i,\\
D &= \{c^i=a^i : c\text{ a source constant}\}\ \cup\ \{f(a^i,a^i)=a^i\}\quad\text{for all }i,\\
S &= \{c^i=c^1 : c\text{ a source constant and }i>1\}.
\end{aligned}$$

Use three rigid constraints. A displayed family of goals can be packed as one equality of tuples with an inert constructor. No hypothesis contains any of these tuple symbols. Finite ground conversion between two such tuples is exactly componentwise conversion.

| Checking row | Hypotheses | Goals |
|---|---|---|
| 1, earlier proof | $E$ | $s_i^i=t_i^i$ for every original constraint $i$ |
| 1, later proof | $E\cup D$ | $x_i=a^i$ for every data variable $x$ and color $i$ |
| 2 | $S$ | $x_i=x_1$ for every data variable $x$ and color $i>1$ |

The first two hypothesis sets form an inclusion chain. Their order matters. Using $E\cup D$ for the original goals would already identify all trees made entirely from one color.

Suppose the original system has solution $d$. Give $x_i$ the recolored tree $d_x^i$. Original conversions lift within their color. Every tree of color $i$ collapses to $a^i$ by the equations in $D$, by induction on its constructors. The synchronization equations in $S$ erase the difference between the copies. This solves all three constraints.

Conversely take a common solution of the three. Every equation of $E\cup D$ has terms made entirely from a single color on both sides. A rewrite therefore preserves the set of leaf colors and the presence of any tuple constructor. A tree converting to $a^i$ uses only $f$ and constants of color $i$. This proves that each $x_i$ has the required alphabet. Under $S$, two trees are congruent exactly when replacing every $c^i$ by $c^1$ gives the same tree. Hence all $x_i$ for a given $x$ are the respective recolorings of one ground source tree $d_x$.

Finally, any $E$-conversion starting from a pure $i$-tree stays in that color and uses only equations of $E_i^i$. A redex from another color has a leaf of that other color and cannot match any subtree. Erasing colors from the first constraint thus recovers every original goal with the same $d$. This proves the intermediate equivalence.

All transformations have polynomial size. Membership in r.e. follows by enumerating candidate conjunctions and checking each branch by finite-tree unification. Packing a conjunction in the *target* needs only the binary constructor, since equality of identically bracketed tuples decomposes in the free algebra. No extra branch is needed.

## Verification

The [compiler and checks](round-24-two-branches.py) construct the three intermediate constraints, their two JCA branches, and genuine conversion certificates including rewrites under constructors. An independent unifier accepts the constructed answer in both rows and after encoding in the fixed signature. A separate ground congruence-closure checker verifies the intermediate equivalence on 1,331 assignments, including mixed-color, differently shaped and foreign-symbol data. It also detects a false positive when the larger theory is used too soon.

[Lean](round-24-colors.lean) verifies that ground conversion restricted to a pure-colored tree is exactly conversion in its original system, that contextual conversions preserve purity when the roots do, and that erasure recovers a pure tree. The earlier kernel checks cover slot exclusion and the shifted-list inference. The whole reduction, including its compiler, is proved in the text. [Round 23 Lean lemmas](round-23-model.lean)

~~~sh
python3 projects/jca/agent-collab/round-24-two-branches.py
lean projects/jca/agent-collab/round-24-colors.lean
~~~
