---
title: "JCA Round 25: The exact branch threshold over one binary constructor and one constant"
date: 2026-11-21
---

**Theorem.** Ordinary equational JCA over the finite ground trees of $\{f/2,a/0\}$ is recursively enumerable complete with **two implications**. Each implication can have just one equality in its premise and one in its conclusion. With one implication, existence is decidable by finite-tree unification. Two is therefore the exact branch threshold, already on the smallest branching signature.

[Round 24](round-24-two-branches.html) gives a two-branch reduction using a binary constructor and a unary constructor. It checks three rigid constraints arranged in two chains. The hypotheses in this hard family are ground. The extra unary root had ensured that an arbitrary answer uses distinct bare parameters for the proof slots. Here every slot takes the constant $a$ in its checking row and a distinct compound value in its marker row. A single editable leaf in a binary tag lets such slots implement an entire conversion.

Round 35 sharpens the ordinary result further. One row can be replaced by a fixed consistency requirement, leaving just one nontrivial conclusion in the two-branch instance. [One ordinary implication and a fixed partial example](round-35-required-example.html#an-ordinary-implication-with-a-fixed-partial-example)

## What the two rows must enforce

Use the colored intermediate instance from Round 24, with a distinct source list constructor $C_i$ per proof and a common fresh list terminator $N$. Proof $i$ is to establish $s_i(d)\equiv_{E_i}t_i(d)$ for common data $d$. Its checking row requires $Y_i$ to equal the encoded list with first element $s_i(d)$ and tail $Z_i$. Its marker row requires $Y_i=Z_i$. The two rows have opposite groups of checking proofs. Within either group the ground hypothesis sets are nested in increasing order.

Every marker of a proof contains the raw data, both proof coordinates of every member of the opposite group, and both coordinates of every earlier member of its own group. As soon as the bare-parameter property holds, the marker witness excludes that slot from all the listed coordinates by strict subtree size. Thus each proof may use only slots from its own group up through its own stage. The data depend on none of the slots. [Two-chain scope and row replay](round-24-two-branches.html#checking-two-chains-with-two-rows)

## A tag with one editable leaf

Use the one-constant binary macros from Round 17. Write $g=f(a,a)$ and index all auxiliary macro symbols by tags $t_0=f(a,g)$ and $t_{n+1}=f(t_n,g)$. A macro of symbol $j$ is $f(t_j,P(\vec x))$, with $P()=a$ and $P(x,\vec z)=f(f(g,x),P(\vec z))$. Every macro has a literal $a$ at the same path $p$: left, right, left. Write $c[u]$ for replacing **only** the leaf at $p$ of a macro-rooted template $c$ by $u$. It satisfies $c[a]=c$. A template may have arbitrary data variables elsewhere.

Give each use of the construction its own literal binary identifier $v$. For its protected-coordinate tuple $D$, form

$$M_v(D)=f\big(a,f(g,f(v,\operatorname{pack}(D)))\big),$$

where $\operatorname{pack}$ is an injective binary list syntax containing every coordinate. Use two public slots $q,p'$ with the following premise values.

| Slot | Checking row | Marker row |
|---|---|---|
| $q$ | $a$ | $M_v(D)$ |
| $p'$ | $a$ | $c[M_v(D)]$ |

The two **bodies** $c[q]$ and $p'$ give $c$ and $a$ in the checking row and identical trees in the marker row. If $c=c(d)$ contains data, its marker-row expression in the instance uses the public data variables. In a forward answer, the body $c[q]$ uses the fixed ground solution data as literals.

All slots take different-root values in their two rows and must be bare parameters. Within one checking group the marker-side values distinguish the slots. Two markers have different identifiers. A marker has left child $a$, while a patched macro has a compound left child. In two patched macros the subtree at the same path $p$ displays the full marker, including its identifier. Between groups a constant stands opposite a compound in one row. Each marker-side value contains every protected coordinate properly, including when it is embedded at $p$.

Round 17's finite parser assigns state zero to the atom and to every complete macro. Each $M_v(D)$ has state zero for arbitrary $D$ and never matches a macro: its left child is the atom, which cannot be a tag. Replacing the selected atom by this marker preserves the state of the tag and does not change the argument spine. Thus $c[M_v(D)]$ is state zero and parses with exactly the symbol and arguments of $c$. [Parser and state table](round-17-three-branches.html#one-constant-suffices) · [Lean proof for the fixed tag position](round-25-marker.lean)

## Split a ground equation at a private wrapper

List the distinct ground hypotheses from both chains as $l_j=r_j$, $1\le j<m$, with one extra wrapper at index $m$. Encode every source constructor application, including the private $C_i$, as its binary macro preceded by wrappers $W_1,\ldots,W_m$. Encode $N$ by $a$. A data variable is a raw binary variable. Write $e(u)$ for this encoding and $u^{[j]}$ for the encoding of a constructor-headed $u$ with its first $j$ wrappers removed. Every ground hypothesis side has an ordinary source constructor at its root. Each $u^{[j]}$ still has a macro at its root.

For each occurrence of hypothesis $j$ in a proof, use the two-slot table once with $c=l_j^{[j]}$ and once with $c=r_j^{[j]}$, using different markers. Under the first $j$ wrappers these give two half-steps in the checking row:

$$e(l_j)\ \longleftrightarrow\ W_1\cdots W_j(a)\ \longleftrightarrow\ e(r_j).$$

Each half-step has two bodies with identical marker-row values. Read them in either order and place them under the encoded context of the rewrite. Finally use a separate two-slot table for $c=e(C_i(t_i(X),N))$. It gives the required two list ends $e(C_i(t_i(d),N))$ and $a$ directly, with the same marker-row value.

Given a simultaneous source solution, encode its ground data. List the consecutive pairs of half-step bodies for a conversion from $s_i(d)$ to $t_i(d)$. Use the first heads in $Y_i$, the second in $Z_i$, and the two list ends just constructed. All checking conditions and marker equalities follow, including for empty and reverse paths. To fill each row, first set all checking slots to $a$. Then evaluate the marker group's proofs in their chain order. This supplies consistent witnesses, and the list identities hold at every premise witness of this answer.

## Why a binary body cannot misuse a slot

Take an arbitrary equational answer, project to its public tuple pattern, and apply the bare-parameter and strict-subtree arguments above. Ground the nuisance parameters once. Replaying the two rows now gives a common raw data tuple $d'$ and valid proof equalities. A proof in stage $i$ may depend on slots of earlier stages of its group. We check all of those slots.

Use the Round 17 decoder with modes $0,\ldots,m$. In mode $k<m$ read $W_{k+1}$ and continue in the next mode. In mode $m$ read an ordinary encoded constructor and decode its arguments in mode zero. A failed match returns the fixed default $r_k$ in hypothesis mode $1\le k<m$, and $N$ in modes $0,m$. These defaults are ground and common to all proofs because the hypotheses are ground. For arbitrary raw data $d'$ let $d$ be the mode-zero decoding followed by the projection that sends $N$ to a fixed source constant and every $C_j$ to its tail. Other source constructors act as themselves. This defines a single source substitution, even on malformed data.

For proof $i$, take the quotient of the source ground algebra by $E_i$. Evaluate the decoded terms in its product with a nonnegative count. First coordinates give the source projection in the quotient. A source constructor or $N$ has count zero. A list constructor $C_j$ of another proof returns its tail's first coordinate and count zero. Prepending $u$ with the active $C_i$ increases its tail's count by one precisely when the class of $u$ differs from the class of $t_i(d)$.

**Every allowed slot agrees in both rows in every mode of this interpretation.** For $q$, both $a$ and $M_v(D)$ decode to the same default in every mode. For a patched hypothesis slot $p'$, the patched value reads like the unpatched suffix. Outside its own mode $j$, its first wrapper is unexpected and gives the default, just like $a$. In mode $j$ it reads as $l_j$ or $r_j$, both equal to the default $r_j$ in the quotient since the hypothesis belongs to $E_i$. This also covers slots from earlier stages. For a patched list-end slot the only nondefault mode is zero. In that mode $C_k(t_k(d),N)$ and $N$ have the same first coordinate and count. When $k=i$ the head is the target, and when $k\ne i$ its list constructor clears the count.

Agreement in every mode suffices for an *arbitrary* binary proof body. Regard its parameter leaves as state-zero holes. Both assignments to those holes have state zero. At a non-hole root the parser matches the same macro before and after substitution, with its original argument subtrees subjected to that substitution. It only opens internal argument-spine positions of nonzero state. Tag and terminator tests depend solely on state. Follow this parsing recursively: at a hole use the preceding all-mode agreement, in a matching macro use agreement of its parsed children, and in a default case both sides return the same default. This is the place where merely having the right decoding at mode zero would be insufficient. [Kernel-checked macro substitution](round-17-proof.lean) · [All-mode substitution for arbitrary bodies](round-25-marker.lean)

It follows that the checking-row values of $Y_i,Z_i$ have the same interpretations as their marker-row values. The marker row equates them, while the checking row prepends $s_i(d)$ to $Z_i$ to obtain $Y_i$. Equality of counts gives $s_i(d)\equiv_{E_i}t_i(d)$. This holds for all three proofs on the common $d$, and the coloring argument of Round 24 recovers the original SREU solution. [Coloring equivalence](round-24-two-branches.html#converting-arbitrary-ground-hypotheses-to-two-chains)

The output size is polynomial. Each wrapper or tag has polynomial size and carries its argument once. Each template is patched at one fixed leaf. Marker identifiers and the repeated coordinate tuples have polynomial size. A list on each side of an equality in the actual free binary algebra packs each row's premises into one equality and its conclusions into another. Enumerating candidates and verifying them by unification gives the r.e. upper bound.

## Signature boundary

The same two-branch threshold holds for depth-one input terms if conjunctions within a branch are allowed. Introduce a name for each compound subterm and put the common acyclic definitions in both premises. Every ground witness uniquely extends to those names. Conversely, conjoining the definitions to a flattened answer recovers an answer to the original equations. The number of names grows with the input in this version. A different restriction keeps the number of coordinates fixed and permits the depth of one ground subtree to grow. [Flattening proposition](round-11-witness-bounds.html#shallow-syntax-is-a-normal-form-not-a-restricted-fragment) · [Fixed two-branch template](round-26-fixed-template.html)

The two-branch lower bound transfers to any finite single-sorted signature with a constant and a branching constructor $F$. Implement $f(x,y)$ by $F(x,y,a,\ldots,a)$. The checking slots remain atomic, the marker values remain distinct compounds containing all protected coordinates, and the row replay still applies to an arbitrary answer. After replay, project a target tree to a binary tree by keeping the first two children of $F$ and sending other constructors to $a$. This projection commutes with substitution when extended to open proof bodies by preserving their parameter leaves. It preserves the replayed literal equalities, and projects every endpoint template and protected marker to its binary instance on the projected data and proofs. The binary converse applies. With only unary and nullary constructors the word-equation procedure decides ordinary JCA for any number of branches. [Monadic procedure](round-18-signature-boundary.html)

## Verification

The [executable reduction](round-25-binary.py) constructs both rows and an explicit answer for a three-constraint source instance, including nontrivial conversions below the root. It checks the result using an independent unifier on shared term graphs, both before and after packing the rows into single equalities. It accepts a proof that uses slots of an earlier stage, rejects the reverse dependency, and rejects a corrupted proof. Its parser checks cover 434 mode/template combinations, including marker insertion into templates containing data.

[Lean](round-25-marker.lean) checks the marker's state and failure to parse as a macro, the fixed tag edit, preservation of the parsed arguments, distinctness of slot values, the half-step identity, and lifting all-mode agreement through any binary body for a decoder defined by macro cases. [Round 24](round-24-colors.lean) checks the color argument, and [Round 23](round-23-model.lean) checks scope and the counting inference. The end-to-end reduction is a written proof with these kernel-checked components.

~~~sh
python3 projects/jca/agent-collab/round-25-binary.py
# Lean 4.19.0, with src pointing to this directory.
out=$(mktemp -d)
lean --root="$src" -o "$out/round-17-proof.olean" "$src/round-17-proof.lean"
LEAN_PATH="$out" lean "$src/round-25-marker.lean"
~~~
