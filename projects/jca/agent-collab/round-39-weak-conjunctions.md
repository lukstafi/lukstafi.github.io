---
title: "JCA Round 39: One forbidden read for arbitrary weak conjunctions"
date: 2026-11-21
---

**Theorem.** Under leading-fresh validity and the extracted weak atomwise escape test, one-branch existence for **arbitrary conjunctive equational answers** is NP-complete when every substitution witness may read every public name. Removing **one read by one witness** makes it r.e.-complete over one binary constructor and one constant. The prefix, all public names, the forbidden read and the number of atoms in the instance can be fixed. The premise is a single equality between a public variable and a term. The reduction extends to every finite single-sorted signature with a branching constructor and a constant. [Unrestricted witnesses](round-37-comparable.html) · [Monadic decision procedure](round-19-designated-parameters.html)

A solved answer has at most one definition per coordinate. A conjunction can equate two different bodies to the same carrier, effectively imposing equations whose direct presentation would fail escape. Round 38 gives a negative rewrite instance that passes in exactly this way. Here the proof starts with the mgu of **any** successful conjunction. Only one raw primitive is ever required to obey a particular scope restriction. [The bridge counterexample](round-38-weak-solved.html#two-individually-valid-equations-defeat-the-construction)

## The guard chooses the data on active rows

Use the hard two-call system of Round 17. Write $X=(d,z)$ for its entire data tuple, and $k$ for its number of ports. It asks for ground $X_0$ and a body $B$ with $B(L(d_0))=S(d_0,z_0)$ and $B(R)=z_0$. The ordered pairs $(L_j(d),R_j)$ are distinct at every ground data tuple and have opposite root types. Fix a machine with at least one rewrite rule. [One-constant source](round-17-three-branches.html)

Use the tagged list $M_r(w)=f(r,f(a,H_r(w)))$ of Round 38, with $H_r([])=a$ and $H_r(v::w)=f(f(r,v),H_r(w))$. Define $J(X,v)$ as a binary list containing each coordinate of $X$, then each entry of a vector $v$, followed by the two trees

$$ M_a([L(d),S(d,z)]),\qquad M_a([R,z]). $$

Here and below a vector inside brackets contributes its individual entries. The list displays $X$ and $v$ injectively, and both final trees occur as **proper** subtrees. Use the prefix

$$ \forall X,n_1,\ldots,n_k\quad\exists G,K\quad\forall r\quad\exists E. $$

Only the ports $n_j$ and the observation $K$ are designated and simultaneously substituted. Every witness may read every public name with the sole exception that $K$ cannot read $r$. The guard $G$ is a retained existential move, chosen after all the ports and before the tag $r$. The one implication is

$$
 G=J(X,L(d))\quad\Longrightarrow\quad
 n=L(d)\ \land\ E=M_r([n,S(d,z)])\ \land\ K=M_r([R,z]).
$$

Given a source solution, define $G=J(X_0,n)$ with **literal** ground $X_0$, define $K=M_r([R,z_0])$, and define $E=M_r([n,B(n)])$. Leave $X,n,r$ free. Equality of the guard lists forces $X=X_0$ and $n=L(d_0)$ on every active row, so the first source equality gives the conclusion. Choosing those values supplies a witness. For validity substitute the fixed $R$ for the ports and $E$ for $K$. The second source equality lets the final move satisfy both requests for every original choice of the universals. The guard can play $J(X_0,R)$ at its turn. Both port-containing atoms are individually prefix-valid since $G,E$ follow the ports. The $K$ definition uses only the later universal $r$. This forward answer is already an idempotent substitution.

## Vary the tag at an ordinary witness

Remove fresh names at a joint witness. For a weak conjunction this means specializing its fresh names to their ground values at that witness. The leading validity sentence held at those values, ordinary relevance survives specialization, and every individually valid exemption survives. Let $P_x$ be the mgu coordinate forms over unbound **public** names. [Fresh elimination](round-31-leading.html#which-inputs-can-a-substitution-witness-observe)

In a generic validity play the retained universal coordinates $X,r$ are distinct independent rigid letters. Hence their $P$-forms are distinct bare parameters. Denote the one for $r$ by $u$. The form $P_G$ omits $u$: $G$ precedes $r$, so its original, nonsubstituted game value cannot contain the rigid letter chosen for $r$. Every $P_X$ omits $u$ by independence. These are **all the coordinates in the premise**. [Generic play with read permissions](round-32-carriers.html)

Take an ordinary active witness and call its data $X_0=(d_0,z_0)$. Hold all residuals other than $u$ at that witness and vary $u$. The data and guard stay fixed, so the row remains active for every tag. Ordinary relevance now forces $n=L(d_0)$ throughout those rows. This is why even unrestricted port witnesses cannot pin the tag in this construction. Treat $u$ as a fresh formal letter $b$. The prescribed observations are $M_b([L(d_0),S(d_0,z_0)])$ and $M_b([R,z_0])$. Identities at every ground tag with the other values fixed are identities in that formal letter, by separation in the free algebra. The forms for $K,E$ both have root $f$: they vary with $u$, always have fork root, and cannot be the bare $u$ at $u=a$.

## One raw equation for the observation

Decompose the original fresh-free atoms through identical constructor heads, drop identities, and orient every remaining consistent primitive as a variable against a term. These primitives are jointly equivalent to the answer. Each parent entails each of its primitives.

At the varying ordinary row, the $K$ value occurs in **no other public coordinate as a subtree**. The guard, data and ports are ground trees without $b$, while $r$ is the bare $b$. In a packed list whose payloads are ground, the only subtree of the form $f(b,v)$ with $b$ *also in* $v$ is the whole list: the individual tagged entries have ground second children. A nonempty list cell has a compound left child and the extra wrapper has left child $a$. The other packed tree $E$ differs from $K$ at a port payload by the opposite-root condition, so it cannot contain $K$ either. The symmetric exclusion holds for $E$ in $K$.

There must be a primitive involving $K$ because its mgu coordinate is not bare. By the subtree exclusion it has the form $K=t$ with $t$ over $G,X,n,r$. Any nontrivial reverse occurrence, or any occurrence of $E$ in $t$, would make one of the excluded subtrees. The variation in $K$ requires that $t$ literally use $r$, since the other available coordinates are fixed on these rows.

The primitive cannot mention $n_j$ **or any data universal in $X$**. Such a universal is in the earliest designated block. Its parent atom contains $K$ and has no strictly earlier designated name. Weak escape therefore requires the parent, and hence this primitive, to be individually prefix-valid. But $K$ is chosen before $r$, and no fixed $K$ can equal a term containing every later choice of $r$ at a fixed address. Finally $G$ cannot occur in $t$. At the same active row with $r=a$, $G=J(X_0,L(d_0))$ strictly contains the entire prescribed $K$ value. An occurrence in $t$ would give the reverse subtree inclusion. Thus the original conjunction entails a literal identity **$K=t(r)$**. On the varying row this unary term equals $M_r([R,z_0])$ for every tag. This proves that equality throughout the answer relation, regardless of any other equations imposed by its presentation.

## Account for every possible proof parameter

At a generic validity play specialize the retained data universals to $X_0$ and the original dummy universal port moves to $a$, keeping $r$ as the formal letter $b$. Every accessible original move other than $E$ is now ground over $f,a$. The required $K=M_b([R,z_0])$ has first child $b$; the generator $E$ is compound. A witness with a constructor at its root could not produce that bare letter in its first child. Hence the witness copies $E$, giving $E=K$ at this play. Ground $b$ to $a$ to get the second row. [Single-generator lemma](round-33-probe.lean)

Specialize the $|X|$ residuals representing the data universals to $X_0$ in the open $P_E$ body. These are the same choices in both rows, regardless of which public names represent those universals. In the ordinary row with $u$ still formal, every remaining residual except $u$ has a fixed ground value. Every strict ancestor of a payload address in the carrier is a fork containing $u$. No other residual can supply such a fork and the bare $u$ cannot supply one. Thus all payload addresses already exist in the open body. Set $u=a$ and extract the $k+1$ subterms at those addresses.

The first $k$ extracted bodies take the values $L_j(d_0)$ at the ordinary assignment and $R_j$ at the grounded validity assignment. By opposite roots they are bare residuals. By distinct columns they are $k$ different residuals. The last body takes $S(d_0,z_0)$ and $z_0$ at these respective assignments.

There are **at most $k$ eligible residuals in any of these payloads**. The public names are $G,X,n,K,r,E$. Neither $K$ nor $E$ is an unbound name. The $|X|+1$ distinct residuals for $X,r$ have already been specialized. This leaves at most $k+1$. If $G$ was defined, subtract its name as well. If $G$ is unbound, it cannot represent a coordinate of $X$, since at the active witness $G$ strictly contains each such coordinate. It cannot represent $r$, since it is played before $r$. At the grounded ordinary row its value strictly contains the entire left packed observation. It cannot occur in *any* payload, whose value is a subtree of that observation. Either way at most $k$ residuals remain.

The $k$ bare probes have therefore exhausted the possible inputs to the last body. Rename the residual selected by probe $j$ to the $j$th formal argument. Its ordinary value was exactly $L_j(d_0)$, and its grounded validity value was exactly $R_j$. Evaluating the renamed last body gives the two source requests with common data $d_0,z_0$. This counting step does not assume the ports were unbound, that the answer was triangular, or that $G$ had been defined by a literal.

Enumeration of finite conjunctive answers and substitutions, followed by the effective scope, prefix and branch tests, gives membership in the recursively enumerable sets. For a higher-arity branching constructor use its first two children with constant padding. At the varying ordinary row the extra fields in the explicit observations are ground, so the subtree exclusions persist. Extract at the two selected fields, and project the recovered body and data to binary trees as in Round 25. [Signature transfer](round-25-binary.html#signature-boundary)

## What the missing read does

If $K$ can also read $r$, choose arbitrary data $X_0$, use $G=J(X_0,n)$ as before, give $E$ the literal left expression with these data, and give $K$ the literal right expression. Its witness can build the required value directly from $r$. Every instance of this family becomes positive. For the full one-branch class with all reads permitted, Round 37 gives NP-completeness.

The forward construction only uses ground port witnesses and the single read of $E$ by $K$. The converse permits all reads except $(K,r)$. Therefore hardness holds for every intermediate permission policy which allows those forward witnesses and omits that read. This includes the uniform policy in which every witness may read all public names except $r$. It also includes the policy in which every witness may read precisely the existential moves: $r$ is then inaccessible while $E$ is available.

For leading validity with the reflexive comparison, the same boundary holds when prior substituted names can be distinguished from designated invariants. [Reflexive-order construction](round-40-reflexive.html)

The [executable checks](round-39-weak-conjunctions.py) verify the positive path, the guard, the permission change on a reversed path, and extraction with a nonidentity permutation of the probes. They also test that the two individually admissible definitions imposing $p=r$ fail ordinary relevance in the revised implication. [Lean](round-39-packing.lean) checks the packed-subtree exclusion used to isolate the raw observation equation. It also checks that distinct probes exhaust the remaining names and that renaming those names recovers a body with both prescribed evaluations.
