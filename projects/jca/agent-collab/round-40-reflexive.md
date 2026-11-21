---
title: "JCA Round 40: The reflexive escape order with prior substituted parameters"
date: 2026-11-21
---

**Theorem.** Use leading-fresh validity with the reflexive weak comparison $u\le_Q k$. Distinguish the designated invariants tested for escape from additional public parameters substituted in validity. One-branch existence for arbitrary conjunctions is r.e.-complete on branching signatures with one designated invariant $K$ and all reads except $K$ reading $r$. With unrestricted reads it is NP-complete. The prefix, additional parameters and forbidden pair are fixed. The construction also works when both reflexive escape tests are imposed on solved answers. This concerns the leading convention. The original source's trailing validity has a separate one-branch NP theorem. [Two parameter roles and conventions](round-19-designated-parameters.html#two-parameter-conventions) · [Unrestricted-read theorem](round-37-comparable.html)

## Reordering the game

Use $X,n,r,E,K,G,J,M$ and the guarded implication from Round 39. The ports $n$ are now **prior substituted parameters**. Only $K$ is designated for escape. Add one public move $H$, use the prefix

$$ \exists G\quad \forall r,K\quad \exists H\quad \forall X,n\quad \exists E, $$

and add $H=f(r,r)$ to the ordinary conclusion. The premise is still just $G=J(X,L(d))$. The block containing the ports and data must come strictly after the designated variable. The intermediate existential creates that separation, and the added equality specifies what the intermediate move can carry. [Guard and branch](round-39-weak-conjunctions.html)

For a source solution use the same equations as in Round 39, together with the new definition of $H$. The ordinary role of $G=J(X_0,n)$ is unchanged. In validity the ports have been simultaneously replaced by $R$, so the initial $G$ move can choose $J(X_0,R)$. Its original atom mentions no designated invariant. The only atom mentioning $K$ is $K=M_r([R,z_0])$ with the result inlined. Its universals $K,r$ are in the same block, so both satisfy the reflexive comparison to $K$. The original move for $K$ is a dummy universal after substitution. Choosing its witness $E$ and making the final move play the common list verifies validity.

## Isolating the observation

In any successful answer, specialize fresh names at a joint witness and take the public mgu tuple. The retained universals $r,X$ have distinct bare representatives. The initial $G$ cannot use the representative $u$ of $r$. Thus varying $u$ at an ordinary active witness preserves the premise. As in Round 39 all the ports stay fixed at $L(d_0)$ by relevance and the two packed observations vary with the tag. Their forms have constructor root.

The normal form of $H$ is **exactly $f(u,u)$**. Its varying row requires a fork for every $u$, ruling out every bare residual and the atom. After the other residuals are fixed each child must be the bare formal $u$. No constructor and no different residual can have that value throughout the variation. The equality therefore holds on the whole tuple pattern. In particular $H$ consumes no residual parameter. It cannot contain $K$ on the varying row, where its children are just the tag letter.

Decomposition again yields a raw primitive $K=t$. Neither the ground coordinates, the bare tag nor $H$ can contain this packed $K$. The other packed tree $E$ excludes it by the packed-subtree lemma. At the varying row the right side $t$ cannot be a bare coordinate: $X,n,G$ are fixed, $r$ is the bare letter, $H=f(r,r)$ has the wrong second child, and $E$ has different port payloads. So $t$ has constructor root. [Packed-subtree lemma](round-39-packing.lean)

If $t$ mentions $X$ or a port, its parent contains a universal **later** than the sole designated name $K$. The reflexive weak escape test requires this parent to be individually prefix-valid. It entails $K=t$, which is individually false because the original universal $K$ may be chosen as $a$ and the right side is compound. This rules out every late data and port name, including in presentations with padding. The guard is also excluded from $t$ by the strict subtree bound at $r=a$. The primitive can therefore use only $r$ and $H$. Substituting the already established $f(u,u)$ for $H$ shows that $P_K$ is a unary term in $u$ that equals the prescribed right list at all tags.

## The separator cannot supply the hidden tag

In a generic validity play specialize $X=X_0$, the original dummy universals (including $K$) to $a$, and leave $r$ as a rigid letter $b$. The witness for $K$ can read every public name except $r$. Its only potentially nonground generators are $E$ and $H=f(b,b)$, both compound. It cannot construct the required bare first child $b$. It must therefore use a whole generator as its result. $H$ has second child $b$ while the required observation has a compound second child. Only $E$ remains.

Grounding the tag now gives the two payload evaluations from Round 39. There is one additional public name $H$ but it is already defined by a compound pattern. The number of available proof residuals is still at most the number of ports. The guard's proper-subtree bound removes its name if it was unbound. The bare distinct probes exhaust the remaining inputs and the final payload solves the source with common data. The same constructor padding and projection transfer the proof to any fixed branching signature.

The distinction between the two parameter sets is necessary for this scope argument. If the late ports were themselves designated, a parent could be padded with a late designated name, permitting the otherwise obstructing late universal. The extracted comparison admits a proof with the two sets identical. [Equal-set result for the extracted comparison](round-39-weak-conjunctions.html) · [Executable checks](round-40-reflexive.py)
