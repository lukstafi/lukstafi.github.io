---
title: "JCA Round 43: The maximal answers in thesis Example 4.3"
date: 2026-11-21
---

**Theorem.** Under Definition 4.1, the two-branch problem in Example 4.3 has **infinitely many incomparable maximally general answers**. The displayed answer $\exists\gamma.\ y=f(z,\gamma)$ is one maximal answer. The single-branch problem in the same example already has infinitely many, even over one binary constructor and one constant. Maher and Huang established the general phenomenon for Herbrand abduction. Here the infinite family applies to the particular implications for which the thesis states a most general answer and a two-element list, respectively. [Thesis §4.2.1, Example 4.3](../thesis_section_4_2.md) · [Original TeXmacs source](../lukstafi-phd-thesis.tm) · [Maher and Huang, *On Computing Constraint Abduction Answers*](https://www.researchgate.net/publication/220896539_On_Computing_Constraint_Abduction_Answers)

The public variables $x,y,z$ are existential. The branches are $y=f(c,x)\Rightarrow z=c$ for $c=a,b$, where $a\ne b$. Definition 4.1 requires some ground solution of $A\land D_c$ for each branch. Prefix validity also holds for every arbitrary choice of fresh parameters in the answers below. The example demonstrates a stronger property of its displayed answer: *each branch* can be activated for *every* choice of the fresh parameters. Imposing that stronger condition changes the two-branch answer set.

## A maximal answer at every depth

Write $C_0(t)=t$ and $C_m(\vec u,t)=f(u_1,f(u_2,\ldots f(u_m,t)\ldots))$. For each $m\ge 0$, use the public tuple

$$
 x=C_m(\vec u,f(q,q)),\qquad
 y=f(p,C_m(\vec v,f(s,p))),\qquad z=s .
$$

All parameter names are distinct except at the indicated repetitions. Each list of padding names is private to its own chain. When $y=f(c,x)$, its first argument gives $p=c$. Comparing $x$ with the second argument of $y$ gives $f(q,q)=f(s,p)$ after descending $m$ right children. Hence $z=s=q=p=c$. Each branch activates by choosing $s=q=p=c$ and equal corresponding pads. For every choice of the fresh parameters the displayed equations also supply the three existential public values required by validity.

A more general tuple pattern can erase constructor subtrees and split occurrences of repeated parameters. This follows by matching it to the displayed tuple. Every constructor-rooted subterm occurs exactly once across that tuple. Thus a variable replacing any such subtree must be private. Each repeated parameter $p,q,s$ has just two occurrences. Every strict generalization consequently contains an elementary relaxation obtained by erasing one constructor subtree or splitting one such pair. [Pattern ordering and existential generality](round-42-maximal.html#enumerate-all-maximal-extensions-of-one-answer)

Every elementary relaxation admits a row with $y=f(a,x)$ and $z=b$.

- Erase the root of $y$. Set $z=b$ and assign the new variable $f(a,x)$.
- Erase a constructor on the rightward chain of $x$, including its terminal fork. Put $s=b,p=a$. Match the pads above the cut and fill the erased subtree with the corresponding subtree of the second argument of $y$. Both occurrences of $q$ were below the cut.
- Erase a constructor on the rightward chain of the second argument of $y$, including its terminal fork. Put the public $z=b$ and the first argument of $y$ equal to $a$. Fill the cut from $x$ and match the pads above it.
- Split the two occurrences of $q$. Give its two leaves the values $b,a$ and put $s=b,p=a$. Split $s$ instead and the compared forks may both be $f(a,a)$ while the public $z=b$. Split $p$ instead and both forks may be $f(b,b)$ while the first argument of $y$ is $a$.

The first branch therefore rules out every strict generalization. Patterns at distinct depths have different numbers of constructor occurrences and cannot be variants. They are pairwise incomparable since they are all maximal. The proof uses only the first branch for maximality. For the single-branch instance over $\{f/2,a\}$, use the ground tree $b=f(a,a)$ in every counterexample.

## If each branch must work for every fresh tuple

For the two-branch example strengthen consistency to $\forall B\,\exists x,y,z.\ A\land y=f(c,x)$ for each $c$. Under this alternative the complete set of maximal answers has **exactly two** members,

$$
 \exists\gamma.\ y=f(z,\gamma)
 \qquad\text{and}\qquad y=f(x,z).
$$

To prove completeness, unify any successful presentation on $x,y,z,B$. Every fresh coordinate is a distinct bare residual, since every fresh tuple occurs. Each unbound residual has a coordinate that names it. The $z$ coordinate must be bare to take the distinct values $a,b$. It cannot name a fresh coordinate because a branch must also activate when that fresh coordinate differs from $c$.

If $y$ were bare, it could not occur in $x$: an active row would make a finite tree contain itself strictly. It cannot be $z$, which at an active row is a constant. It cannot name a fresh coordinate, which can be given a value with root different from $f$. Thus $y$ could be assigned $f(a,x)$ independently of $x,z$, admitting a row with $z=b$. It follows that $y=f(t,u)$. The first argument $t$ must be bare to take both constants, and cannot name a fresh coordinate by uniform activation. Its only possible unbound public representatives are $x,z$. If $t$ is the residual of $z$, the answer lies below the first displayed maximum. Otherwise $x=t$ is bare and independent of $z$. In that case activation requires $u=x=c$ on the branch, so $u$ too must be bare and cannot name a fresh coordinate. The choice $u=x$ leaves $z$ free on the active branch and violates relevance. The only remaining possibility is $u=z$, giving the second displayed maximum. Both candidates are uniformly activatable and neither matches the other.

For **one** branch, even this strengthened convention still permits infinitely many maxima. Set $F(t)=f(a,t)$. For each $m$ take the fresh-free answer $x=F^m(a)$, $y=f(a,F^m(z))$. Its active rows have $F^m(z)=F^m(a)$, hence $z=a$. For $m<n$, apart-renaming parameters and taking the least general generalization of the two public patterns gives

$$
 x=F^m(u),\qquad y=f(a,F^m(v)),\qquad z=w
$$

with three independent residuals. Indeed the three disagreement pairs are $(a,F^{n-m}(a))$, $(s,F^{n-m}(t))$, and $(s,t)$. They are distinct. Set $u=v=a,w=f(a,a)$ to obtain a row falsifying the branch. Every common generalization of these seeds contains that row. Each seed has only finitely many generalizations, so each extends to a maximal admissible answer, and no two seeds can share one. The proof needs no second ground constant symbol.

The [executable checks](round-43-infinite-maxima.py) verify both original branches at depths 0 through 12, generate concrete false rows for all 468 elementary relaxations across the two choices of $b$, and test the stronger consistency convention and the least general generalizations of its single-branch seeds.
