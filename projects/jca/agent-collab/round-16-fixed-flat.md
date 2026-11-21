---
title: "JCA Round 16: A fixed number of constructor-free branches"
date: 2026-11-21
---

**Theorem.** For some fixed integer $M$, ordinary equational JCA answer existence over the finite trees of $\{f/2,a,b\}$ is recursively enumerable complete on instances with at most $M$ branches of the form

$$u=v\quad\Rightarrow\quad \bigwedge_j s_j=t_j.$$

Every premise compares two variables. Every conclusion compares variables, except for a single occurrence each of $a$ and $b$ fixing two coordinates. The input contains no occurrence of $f$. The number of coordinates and the width of the conclusions can grow.

The [single-equation reduction](round-15-constructor-free.html) spends branches as the arithmetic system grows. Here the arithmetic system is fixed. The varying input is one natural number $n$. Two comparisons read its value from a chain of $n$ equalities, and at most eight further branches keep the two ends of each link independent.

## 1. Four branches exclude a parameter from many terms

Write $P_x$ for the finite answer tree at coordinate $x$. A branch requires a ground witness for its premise and requires its conclusion at every such witness. Suppose $P_h$ is a bare parameter $q$. For given coordinates $x_1,\ldots,x_k$, introduce fresh coordinates $u,v,r,p_1,\ldots,p_k$. Use the following branches for $k\ge1$.

| Premise | Conclusion |
|---|---|
| $u=v$ | $r=b\ \land\ \bigwedge_j p_j=a$ |
| $r=a\ \land\ \bigwedge_j p_j=b$ | $\top$ |
| $\bigwedge_j p_j=u$ | $\top$ |
| $h=v\ \land\ \bigwedge_j p_j=x_j$ | $\top$ |

**Lemma.** These branches admit an extension of the given pattern if and only if $q$ occurs in none of the $P_{x_j}$.

*From an answer.* Fix $j$. The first branch supplies all its conclusions under the same premise. The three remaining branches each supply a joint witness, which also satisfies the equations for this $j$. Thus $u,v,p_j,r$ meet all four conditions of the single-coordinate absence lemma for $x_j$. Apply that lemma to every $j$. The proof allows parameters to be shared between any of the new coordinates. [Single-coordinate lemma](round-15-constructor-free.html#flat-branches-can-test-occurrence)

*To an answer.* Take a binary tree shape $K$ with $k+1$ slots, each appearing once. Choose fresh distinct parameters $s_1,\ldots,s_k,t$. Set

$$P_u=K(a,\ldots,a,b),\qquad P_v=K(s_1,\ldots,s_k,t),\qquad P_{p_j}=s_j,\quad P_r=t.$$

The comparison fixes the displayed leaves. The second branch reverses their two values. For the third assign every $s_j$ the ground tree $P_u$. For the fourth, first choose arbitrary ground values of the $P_{x_j}$ and assign them to the corresponding $s_j$. Choose $t=a$ and set $q=K(s_1,\ldots,s_k,t)$ at these values. Absence of $q$ and freshness of the $s_j,t$ preserve every chosen value. $\square$

Each pure guard $D\Rightarrow\top$ can be written as **one** branch $u'=v'\Rightarrow D$ with fresh variables. Any witness of $u'=v'$ satisfies all of $D$. Conversely, given one witness of $D$, pack the parameters occurring in $D[P]$ into $P_{u'}$ and their selected ground values into $P_{v'}$ with the same tree shape. Equality selects exactly those values on those parameters. Replace the displayed constants in the four branches by the two coordinates already fixed to $a,b$ in the arithmetic instance. These changes preserve the branch count. [Witness selection](round-15-constructor-free.html#identities-between-unknown-tree-operations)

## 2. Two comparisons specify an iterate

The fixed part of the instance supplies two distinct bare parameters at coordinates $p,q$. It also supplies coordinates $A_p,A_q,Z_p,Z_q$. For a fixed interpretation of the other parameters, their respective values at $p=x,q=y$ are $S(x),S(y),S^d(x),S^d(y)$. Here $S$ is an unknown unary operation on ground trees such that $S(z)$ is strictly larger than $z$, and $d$ is one natural number chosen by the solution. Section 3 constructs this fixed part and specifies the grounding used to read it.

For $n>0$ take $T_0=p$ and fresh $T_1,\ldots,T_{n-1}$. Use the existing $Z_p$ for $T_n$ when $n$ is even and $Z_q$ when $n$ is odd. Apply §1 once to keep the parameter of $q$ out of all even interior stages and once to keep that of $p$ out of all odd interior stages. Skip an empty group. Add these two branches, omitting an empty conclusion.

| Premise | Conclusion |
|---|---|
| $p=A_q$ | $\bigwedge_{i<n,\ i\ \mathrm{even}}T_i=T_{i+1}$ |
| $q=A_p$ | $\bigwedge_{i<n,\ i\ \mathrm{odd}}T_i=T_{i+1}$ |

For $n=0$ use the single branch $p=p\Rightarrow p=Z_p$.

**Lemma.** The extension forces $d=n$. A canonical arithmetic answer with $d=n$ extends across the new branches.

*From an answer.* Fix all parameters other than those of $p,q$ as in §3. An even stage now has a unary value $F_i(x)$ in $p$, an odd stage a unary value $F_i(y)$ in $q$. The start and endpoint have the required independence by their definitions. For an even $i$, choose $q=z$ and $p=S(z)$ for an arbitrary ground tree $z$. This satisfies the first premise. Relevance gives $F_{i+1}(z)=F_i(S(z))$. For an odd $i$, choose $p=z$ and $q=S(z)$. The second premise gives the same identity. Since $F_0(z)=z$, induction gives $F_n(z)=S^n(z)$. The endpoint already gives $F_n(z)=S^d(z)$. Successive iterates on any one ground tree have strictly increasing sizes, so $d=n$. The case $n=0$ follows directly from the unconditional equality.

*To an answer.* At every interior even stage take the tree expression $S^i(p)$ and at every interior odd stage take $S^i(q)$, retaining the color arguments used by $S$. These expressions have the required absences. Every valuation that satisfies an audit premise makes each of its consecutive pairs equal. Either premise admits a witness by choosing the two marker values in the order used above. The endpoint already has its prescribed value. $\square$

## 3. A fixed arithmetic system can read the chain

Choose an r.e.-complete set $H\subseteq\mathbb N$. By the DPRM theorem one fixed polynomial over natural-number unknowns represents membership in $H$. Separate its positive and negative coefficients and name its intermediate values. This gives a fixed finite system $\Delta$ of constraints $t=1$, $s+t=u$, $st=u$ with a distinguished unknown $d$, such that $n\in H$ exactly when $\Delta$ has a solution with $d=n$. Zero can be defined by $z+z=z$ and equality by $s+z=t$. [Bayer et al., formalization of DPRM](https://isa-afp.org/entries/DPRM_Theorem.html)

Use the identity construction from Round 15 for $\Delta$. It gives a binary term operation $L$ using both its arguments, a successor $S_{v,w}(x)=L(v,L(w,x))$, and a ternary numeral $N_d$ equal as a term operation to $S_{v,w}^{\,d}(x)$. Add two fresh universal letters $p,q$. For each $e$ in

$$S_{v,w}(p),\ S_{v,w}(q),\ N_d(v,w,p),\ N_d(v,w,q)$$

include the identity $e=e$ so the compiler allocates its expression coordinate. These four coordinates are $A_p,A_q,Z_p,Z_q$. Write $B_\Delta$ for the number of branches of this fixed compilation, including the two constant anchors. [Numeral, multiplication and expression compilation](round-15-constructor-free.html)

In the reverse direction the compilation first grounds all nuisance parameters, retaining its distinct bare formals and universal letters. It recovers fixed term operations solving the identities. Fix the formals and all universal letters other than $p,q$ to $a$. The four expression coordinates still evaluate as their expanded expressions for **every** choice of $p,q$. In particular $S=S_{a,a}$ is one fixed operation. As the tree body of $L$ uses both arguments, its root is compound and its tail argument occurs at positive depth. This gives the strict growth needed in §2 even after the two colors become equal. For the forward direction use $L=f$ and the canonical bodies for any arithmetic solution.

The mapping $n\mapsto J_n$ thus reduces membership in $H$ to flat JCA answer existence. It uses at most $M=B_\Delta+10$ branches. The added number of equation occurrences and coordinates is linear in the unary input $n$. Enumerating finite patterns and checking each branch by unification gives the r.e. upper bound. This proof gives a bound relative to a choice of universal arithmetic system. It does not identify the least possible $M$.

With both the branch count and the conclusion width fixed in the stated syntax, there are only finitely many instances up to renaming and deletion of unused variables. Indeed the total number of variable positions is bounded. The unbounded conclusion width in this theorem is therefore essential. Round 15 instead allows an unbounded number of branches with **one** conclusion equality apiece. With constructors in the input, three branches suffice over the same signature. [Three-branch theorem](round-17-three-branches.html)

## 4. Verification

[Lean proof](round-16-proof.lean) · [Executable compiler and checks](round-16-experiments.py)

The Lean kernel checks the four-branch equivalence for any finite number of coordinates and the induction recovering the iterate from the two audit comparisons. The latter theorem quantifies over arbitrary stage functions of both marker values subject to the displayed independence condition. The fixed arithmetic compiler and its use of DPRM are justified by §3 and Round 15. To reproduce the kernel check, run these commands from a Lean 4.19.0 project with mathlib v4.19.0, setting `src` to this note's directory.

~~~sh
out=$(mktemp -d)
lake env lean --root="$src" -o "$out/round-15-proof.olean" "$src/round-15-proof.lean"
LEAN_PATH="$out${LEAN_PATH:+:$LEAN_PATH}" lake env lean "$src/round-16-proof.lean"
~~~

The Python check builds the complete flat input and canonical answer using the fixed example $1\cdot d=d$ and its coordinate for one. Its arithmetic part takes 2,402 branches. At length nine the chain adds ten. It checks lengths zero through nine, a pairing duplicating its first argument, and incorrect endpoints above and below the intended length when defined. The example exercises the construction on a known arithmetic relation. Hardness comes from choosing the single system for $H$ in §3.

~~~sh
python3 projects/jca/agent-collab/round-16-experiments.py
~~~
