---
title: "JCA Round 17: Three branches over one binary constructor and one constant"
date: 2026-11-21
---

**Theorem.** Ordinary equational JCA answer existence over finite $\{f/2,a\}$-trees is recursively enumerable complete with **three branches**. One branch has conclusion $\top$. Each of the other two has a single conclusion equality. The number of instance variables can be fixed independently of the input. The proof first uses a second constant for a transparent binary encoding. Section 7 removes it.

In the [four-branch reduction](round-14-four-branches.html), a dedicated branch makes every formal argument of an unknown operation take an atomic value. With enough distinct constants, splitting each rewrite rule at a private atomic midpoint removes that branch. Here the atom $a$ serves every midpoint. Its enclosing wrappers record which rule it belongs to. The proof must account for an arbitrary answer body that places the same atom under different wrappers.

## 1. The source equation

Use the fixed ground rewrite system $R=\{l_i\to r_i:1\le i\le k\}$ of Ganzinger, Jacquemard and Veanes. Its hard family asks whether $s(d)\to_R^*t(d)$ for some ground values $d$ of the data variables. They use a fixed machine accepting an r.e.-complete language. With fresh symbols $\operatorname{cons},\operatorname{nil}$, the reachability question is equivalent to the existence of $d$ and a finite term body $B$ satisfying

$$ B(\vec l,\operatorname{cons}(t(d),\operatorname{nil}))
=\operatorname{cons}\big(s(d), B(\vec r,\operatorname{nil})\big). \tag{1} $$

This equivalence includes the reverse direction for arbitrary bodies and ground data in the enlarged signature. In the forward direction we use the actual rewrite path. [Ganzinger, Jacquemard and Veanes, §§3–4, especially equation (6) and Lemma 5](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/98ASIAN.pdf)

## 2. Binary templates and rule positions

First describe the encoding with unary wrappers $W_1,\ldots,W_m$, where $m=k+1$, and a symbol $C_g$ of the original arity for each source constructor $g$ other than $\operatorname{nil}$. These are abbreviations for the binary templates below. Write $W_{j:h}$ for consecutive nested wrappers with $W_j$ outermost, using the identity when $j>h$.

Encode a data variable by a raw target variable, encode $\operatorname{nil}$ by $a$, and put

$$e(g(\vec t))=W_{1:m}\big(C_g(e(\vec t))\big).$$

Write $E_g(\vec u)=W_{1:m}(C_g(\vec u))$ for the constructor acting on already encoded children. For a rule side $v=g(\vec t)$ put

$$v^{[i]}=W_{i+1:m}\big(C_g(e(\vec t))\big),\qquad e(v)=W_{1:i}(v^{[i]}).$$

All rule sides have an original constructor at the root. The new $\operatorname{nil}$ is absent from $R$.

Use two formal slots $I_i,O_i$ for each rule, and one tail slot $T$. The two calls use these argument columns.

| Slot | Left call | Right call |
|---|---|---|
| $I_i$ | $l_i^{[i]}$ | $a$ |
| $O_i$ | $a$ | $r_i^{[i]}$ |
| $T$ | $e(\operatorname{cons}(t,\operatorname{nil}))$ | $a$ |

For fresh data coordinate $z$ require a single body $Y$ to return $E_{\operatorname{cons}}(e(s),z)$ on the left and $z$ on the right. Every slot is atomic in one call. It is compound in the other.

**Actual binary templates.** Put $K=f(b,b)$ and $M=f(b,K)$. Assign distinct tags $b,f(b,b),f(f(b,b),b),\ldots$ to all the wrappers and constructor symbols. For macro symbol $G$ with tag $t_G$ use

$$\begin{aligned}
L()&=b, & L(x,\vec y)&=f(f(K,x),L(\vec y)),\\
G(\vec x)&=f\big(M,f(t_G,L(\vec x))\big).
\end{aligned}$$

Call a tree protected when it equals $a$ or has the form $f(M,v)$. Every call argument is protected, including the tail with arbitrary ground data. No fixed part strictly inside a template can match a protected tree. The fixed leaf is $b$. A left-comb tag has no node whose left child is $M$, and $M$ is too large to occur as a left child within itself or $K$. The payload has a left-comb tag as left child. A list node has left child $f(K,x)$, which differs from $M=f(b,K)$ for all $x$. The node $f(K,x)$ itself has left child $K$. This covers every fixed position. A macro match uniquely determines its symbol and its ordered list of slots.

## 3. A rewrite path supplies a binary body

Encode each tree of the source path. A rewrite at a redex $l_i$ now gives two local steps

$$ W_{1:i}(l_i^{[i]})\ \longrightarrow\ W_{1:i}(a)\ \longrightarrow\ W_{1:i}(r_i^{[i]}).$$

At the first step put $W_{1:i}(I_i)$ in the encoded redex context. Its left and right evaluations give the trees just before and after that step. At the second step use $W_{1:i}(O_i)$ in that same context. All other subtrees remain fixed ground trees.

If the resulting path is $v_0,\ldots,v_N$, denote its two-evaluation step bodies by $H_0,\ldots,H_{N-1}$. Build the body $Y$ as a list with these heads, using $E_{\operatorname{cons}}$ at each node and the tail hole $T$ at the end. The right evaluation produces the list of $v_1,\ldots,v_N$ ending in $a$. Use this value for $z$. The left evaluation produces the list of $v_0,\ldots,v_N$ ending in $a$, since its tail already contains $v_N=e(t(d))$. This is $E_{\operatorname{cons}}(e(s(d)),z)$. An empty path uses $T$ as the whole body. All encoded data variables take the encodings of their source values.

## 4. Decode every binary body

Use modes $0,\ldots,m$. The default output is $c_0=c_m=\operatorname{nil}$ and $c_i=r_i$ for $1\le i\le k$. Define $D_j$ on arbitrary ground binary trees by the following three rules.

1. In mode $j<m$, a $W_{j+1}(v)$ macro match returns $D_{j+1}(v)$.
2. In mode $m$, a $C_g(\vec v)$ match returns $g(D_0(\vec v))$, applying $D_0$ to each child.
3. All remaining inputs, including $a$, return $c_j$.

The recursion descends into proper subtrees. For any target data assignment $d'$, structural induction gives $D_0(e(s)[d'])=s[D_0(d')]$, and likewise for $t$.

Read a rule column in mode $i$. The left and right values of $I_i$ decode to $(l_i,r_i)$, while those of $O_i$ decode to $(r_i,r_i)$. In any other mode $j$ both values of either column decode to $(c_j,c_j)$, because the first wrapper on its compound value is $W_{i+1}$. The tail column gives the last argument pair of (1) in mode zero and $(c_j,c_j)$ in every other mode.

Decode a target body $Y$ with the same rules, matching its formal holes as rigid leaves. At a hole use the following special rule. In mode $i$, the hole $I_i$ yields the original rule hole $\xi_i$. In mode zero, $T$ yields the original tail hole. Every other hole yields the current default $c_j$. This gives source bodies $D_j^*(Y)$; write $B=D_0^*(Y)$.

**Substitution lemma.** In either call, decoding $Y$ after supplying the target arguments gives the same tree as evaluating $D_j^*(Y)$ on the corresponding source arguments.

*Proof.* At a root hole the assertion is exactly the column calculation above. At any other root, a previously recognized macro persists after substitution. A new match would place an inserted argument at a strict fixed position, which §2 excludes. Thus the same decoder case applies before and after substitution. In a matching case use induction at the slots, switching modes as the decoder prescribes. In a default case both sides return $c_j$. $\square$

Now apply $D_0$ to the two target requests at any binary solution. The right request gives $B(\vec r,\operatorname{nil})=D_0(z)$. Substituting this in the decoded left request gives (1) with the **same** $B$ and data. The source equivalence recovers a successful reachability instance. In particular, putting a formal hole at a wrong wrapper position cannot introduce a spurious rule. Both evaluations there return the same ground default.

## 5. Three JCA branches

Use the two evaluations of §2 and the scope guard of Round 14. Explicitly, for data coordinates $X$ including $z$, let $K_X$ be a binary list containing each coordinate and let $J(t)=f(t,a)$. Number all the formal coordinates $h_j$ starting at one. The scope premise requires $h_j=J^j(K_X)$ for every $j$ and has conclusion $\top$. Each evaluation requires $h_j$ equal to its entry in the table and has the one indicated result equality.

Every $P_{h_j}$ takes the value $a$ at one evaluation witness and a compound value at scope. It must be a bare parameter. At the common scope witness these parameters have distinct sizes, all strictly larger than every data value. They are therefore distinct and absent from the data coordinates. Ground all other parameters once. The data are now a single ground tuple and the body coordinate gives one term operation on the formal parameters. Each evaluation premise can be realized at exactly its specified arguments, so its equality holds. Conversely any solution to the two requests gives an answer by using bare distinct formals, the solution data and the solution body. This is the [Round 14 guard argument](round-14-undecidability.html#compiling-one-unknown-operation-into-branches).

The fixed machine supplies fixed $k$, signature and data-variable count. Only the input term grows. Enumeration and unification give membership in the recursively enumerable sets. Round 25 later obtains two ordinary branches by a different reduction. In the construction above, the two evaluations already distinguish the formal parameters by their atomic ends and their distinct wrapper tags. The scope witness also keeps these parameters out of the data, including $z$.

## 6. Dropping scope gives symmetric conversion exactly

**Proposition.** For any finite ground rule set $R$ on the original signature, the two evaluation branches of §2 alone have an answer if and only if $s(d)\leftrightarrow_R^* t(d)$ for some ground tuple $d$ over that signature. Thus this particular two-branch family is decidable, including instances with data variables. It is a single rigid $E$-unification constraint with ground equations. [Ganzinger, Jacquemard and Veanes, §1, single rigid equation](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/98ASIAN.pdf)

*From an undirected path.* Encode the path and split each step as in §3, following the encoded half-steps in reverse order when the source rewrite is backwards. For each consecutive pair $v_j,v_{j+1}$ there are two head bodies $H_j,K_j$ with left evaluations $v_j,v_{j+1}$ and the same right evaluation. For a forward half-step choose its step body for $H_j$ and the literal $v_{j+1}$ for $K_j$. For a backward half-step choose the literal $v_j$ for $H_j$ and the forward step body for $K_j$.

Take $Y$ to be the list of heads $H_j$ ending in $T$. Take the coordinate $z$ to be the list of heads $K_j$ ending in the literal $a$. At the right call the two lists coincide. At the left call the second list starts at $v_1$ and ends at $v_N$, while the first starts at $v_0$ and acquires $v_N$ from its tail. Both evaluation equalities follow. An empty path gives $Y=T,z=a$. This construction can use the formal parameters in $z$.

*From an arbitrary answer.* Every formal takes both atomic and compound values. Slots of opposite orientation differ at one witness by their root. Two slots of the same orientation have different wrapper tags on their compound ends. The tail starts with $W_1$, which distinguishes it from all rule slots. Thus all formal coordinates are distinct bare parameters already in the two evaluations.

Ground all nuisance parameters to $a$. For the left call set the rule formals to their specified ground values. The target data in $t$ can now be evaluated before setting the tail formal. Indeed its left value $E_{\operatorname{cons}}(e(t),a)$ strictly contains every coordinate occurring in $t$. An occurrence of the tail parameter in any such coordinate would violate the occurs check at the original left witness. Set the tail formal to the resulting value. For the right call all formals have prescribed ground values. Other data and $z$ may vary freely between these two calls.

Write $d_L$ for the componentwise decoding of the left data. Set $s'=s(d_L)$ and $t'=t(d_L)$, which may contain the fresh list symbols through $d_L$. After the common grounding, $Y$ and $z$ are both binary bodies on the slots. By §4 the two decoded evaluations of **each** are congruent modulo the ground equations

$$\{l_i=r_i:1\le i\le k\}\ \cup\ \{\operatorname{cons}(t',\operatorname{nil})=\operatorname{nil}\}.$$

This follows by applying their decoded bodies to congruent argument vectors. Let $Z_L$ denote the decoded left value of $z$. The evaluation equalities give $\operatorname{cons}(s',Z_L)\equiv Z_L$ in this congruence.

To read this equality, let $Q$ be the original ground term algebra modulo the equations of $R$. Project an extended term to $Q$ by interpreting $\operatorname{nil}$ as any original constant and $\operatorname{cons}(u,v)$ as the projection of $v$. Write $\pi$ for this projection. Build a model on $Q\times\mathbb N$. Every original constructor acts as usual on first coordinates and returns zero on the second. Give $\operatorname{nil}$ its projected value and second coordinate zero. Define

$$\operatorname{cons}((u,h),(v,j))=(v,\ j+\mathbf 1_{u\ne\pi(t')}).$$

First coordinates compute $\pi$ throughout. All original rule equations hold, and prepending $t'$ to $\operatorname{nil}$ preserves its value. The congruence equality for $Z_L$ therefore forces $\pi(s')=\pi(t')$. Choosing original ground representatives of $\pi(d_L)$ gives a single substitution witnessing $s(d)\leftrightarrow_R^*t(d)$. $\square$

Round 23 makes two proofs of symmetric conversion coexist in two ordinary branches while sharing their data. [Two simultaneous rigid constraints](round-23-two-rigid.html)

Even a backwards application of a single irreversible ground rule can therefore pass both evaluations. The third branch restores direction by making $z$ independent of the slots. The proposition applies to this compiled family. The general two-branch problem is r.e.-complete. [Exact threshold](round-25-binary.html)

## 7. One constant suffices

Use $a$ as the only constant. The templates in §2 used $b$ at fixed leaves so that an atomic argument could never complete a template by substitution. Here the decoder reads a finite state at each tag. A hole and every value that may replace it have the same state. This makes even a tag containing a hole safe to inspect.

Let $N$ be the number of wrapper and constructor macros. Number them $0,\ldots,N-1$. Use states $0,G,E,L,T_0,\ldots,T_{N-1}$. The atom $a$ and every unfilled hole have state $0$. Compute the state of $f(l,r)$ from the states of its children by the following table. Omitted cases return $0$.

| Left state | Right state | Result |
|---|---|---|
| $0$ | $0$ | $G$ |
| $G$ | any | $E$ |
| $E$ | any | $L$ |
| $0$ | $G$ | $T_0$ |
| $T_i$ | $G$ | $T_{i+1}$ when $i+1<N$ |

Put $g=f(a,a)$, $t_0=f(a,g)$, $t_{i+1}=f(t_i,g)$. These trees have states $G,T_0,T_1,\ldots$ respectively. Encode the arguments of a macro by a list

$$P()=a,\qquad P(x,\vec y)=f(f(g,x),P(\vec y)).$$

For macro $i$ use $f(t_i,P(\vec x))$. Every complete macro has state $0$ for **arbitrary** slot values. A nonempty list has state $L$, its first entry $f(g,x)$ has state $E$, and an empty list has state $0$.

The parser at a binary root reads the state of its left child to identify the macro. On the right it reads exactly the declared number of list nodes. To read one cell, require a fork of state $L$ whose left child is a fork of state $E$. Its left child's right child is the next slot. Continue on the cell's right child. Require the final remainder to have state $0$. This parser reads back the slots of every encoded macro. Its tag and end tests also define a unique result on arbitrary malformed trees whenever a match succeeds.

**Substitution.** Every inserted argument is $a$ or a complete macro, so replacing a hole by its argument preserves the state at every pre-existing node. A state test on a tag or list terminator therefore has the same result before and after substitution. Every strict position at which the parser *opens a fork* must have state $L$ or $E$. A hole, even after filling, has state $0$ and cannot be opened there. Thus at a non-hole root the same macro matches before and after substitution with exactly the substituted slots. At a root hole the mode-specific column calculation of §4 still applies. This proves the substitution lemma for the new encoding. $\square$

Use these templates everywhere in §§2–6. The scope guard uses only $a$ and $f$. Atomic and compound endpoints still have distinct roots, and different wrapper tags still distinguish the compound columns. This proves both the three-branch theorem and the two-branch conversion proposition over the single-constant signature. One branch by itself is decidable: unify its premise and conclusion jointly, then use any ground solution as a singleton answer. Round 25 attains the remaining value two over this same signature. [Two-branch proof](round-25-binary.html)

[Round 18](round-18-signature-boundary.html) extends this lower bound to every finite signature with a branching constructor and a constant. It gives a decision procedure for all signatures with only unary constructors and constants.

## 8. Verification

[Lean proof](round-17-proof.lean). The kernel verifies substitution for both binary parsers, for every tag and arity. It checks that each one-constant macro has state zero and returns its original slots, including slots with arbitrary tree values. It also checks the counting-model argument for arbitrary body terms of any finite signature rank. The reported theorems use only `propext` and `Quot.sound`. The interpretation in modes and the full reductions are proved above.

[Executable reduction and checks](round-17-three-branches.py). The program constructs all three binary JCA branches and verifies a complete answer for two successive source rewrites inside a context. It also checks the empty path, malformed data, and 5,688 instances of the decoding identity with the two-constant parser and 7,360 with the one-constant parser, moving a hole through fixed template positions and genuine slots in every mode. The reversed path passes the two evaluation branches and fails the scope guard.

~~~sh
python3 projects/jca/agent-collab/round-17-three-branches.py
lean projects/jca/agent-collab/round-17-proof.lean  # Lean 4.19.0
~~~
