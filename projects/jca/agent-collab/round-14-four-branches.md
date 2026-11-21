---
title: "JCA Round 14: Four branches over one binary constructor"
date: 2026-11-21
---

*Companion to [the ordinary JCA undecidability proof](round-14-undecidability.html).*

**Theorem.** Ordinary JCA answer existence over $\{f/2,a,b\}$ is undecidable with four branches. Two branches have conclusion $\top$. The other two evaluate the same answer coordinate. The number of instance variables can also be bounded by a constant independent of the input. With a larger fixed set of constants, §4 lowers the branch count to three.

Ganzinger, Jacquemard and Veanes prove hardness for an equation containing just two applications of one second-order variable. Their construction uses several constructor symbols, including a fresh list constructor. For the four-branch bound we need to preserve the number of applications when changing signature. Simply assigning each constructor a binary code would leave the behavior of arbitrary target-side function bodies unaccounted for. The following encoding supplies a decoder for every such body. [Ganzinger, Jacquemard and Veanes, “Rigid Reachability,” §4, equation (6) and Lemma 5](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/98ASIAN.pdf)

**Round 15 update.** The constructor-free question with unrestricted branch count now has a negative decidability result. [Proof](round-15-constructor-free.html)

**Round 17 update.** Three branches now suffice over $\{f/2,a,b\}$ and even over $\{f/2,a\}$. Indexed wrappers distinguish the rules that share one atomic midpoint. [Proof](round-17-three-branches.html)

## 1. Protect each argument

Start with first-order data equations and requests $F(\vec s)=t$ over a finite ranked signature $\Sigma$ containing a constant $c$. All terms $\vec s,t$ in a request are first-order. Choose a distinct ground tag $T_g$ over $f,a$ for each constructor $g$, for instance the successive terms $a,f(a,a),f(a,f(a,a)),\ldots$. Write

$$
\begin{aligned}
H(v)&=f(b,v),\\
L()&=a,\\
L(v_1,\ldots,v_m)&=f(f(a,v_1),L(v_2,\ldots,v_m)),\\
C_g(v_1,\ldots,v_m)&=H(f(T_g,L(v_1,\ldots,v_m))).
\end{aligned}
$$

Use one raw data variable $x'$ for each source variable $x$. Encode first-order terms by $e(x)=H(x')$ and $e(g(\vec t))=C_g(e(\vec t))$. Encode the equations pointwise. Each request gives one request $F'(e(\vec s))=e(t)$. The input to $F'$ at each argument position is always a tree of the form $H(v)$, including when the source argument is an unknown data value.

The $v_i$ in $C_g$ are slots. The templates have three properties.

1. The tag determines $g$, and a successful match gives unique slot values.
2. At every **strict position in a template outside the slots**, the subpattern cannot match any $H(v)$. Constants have the wrong root, a node within a tag contains no $b$, the tag at the payload root differs from $b$, and the two kinds of list node have left child $f(a,\cdot)$ or $a$. The outer marker $b$ itself is a constant.
3. Each slot is a proper subtree. Decoding can therefore recurse on the values at the slots.

## 2. Decode every candidate body

On ground binary trees define $D(C_g(v_1,\ldots,v_m))=g(D(v_1),\ldots,D(v_m))$. For a tree matching no template set $D(v)=c$. On a target body $B$ with formal holes, define $D_*(B)$ by the same rule, treating holes as distinct new leaf symbols during template matching, and set $D_*(\xi_j)=\xi_j$.

**Substitution lemma.** For all target bodies $B$ and all ground $u_j$ with outer shape $H(\cdot)$,

$$D(B[\xi_j:=u_j])=D_*(B)[\xi_j:=D(u_j)].$$

*Proof.* A hole at the root gives the identity immediately. Otherwise consider matching the root of $B$ against a template. Substitution preserves every successful match and substitutes into its slots. Conversely, in any match after substitution, an inserted $u_j$ encountered while checking the fixed structure would occupy a strict non-slot position. Property 2 rules that out. Hence a match after substitution was already a match before substitution, with exactly the same template. If there is no match, both decoders return $c$. For a match, apply induction at each slot. $\square$

**Encoding lemma.** The source and encoded interpolation instances are equisolvable.

*Forward.* Encode a closed source data value using its constructor templates. Its result is $H(v)$ for a unique payload $v$. Assign that payload to $x'$. Encode a source body by replacing each constructor with its template and leaving its holes unchanged. Plugging encoded argument values into this body gives the encoded source output, by induction on the body.

*Backward.* Given arbitrary target data values $d'_x$, set $d_x=D(H(d'_x))$. Induction on the first-order term $t$ gives $D(e(t)[d'])=t[d]$. Decode the chosen target body by $D_*$. The input encodings have outer shape $H(\cdot)$, so the substitution lemma decodes each complete request. Decoding both sides of each data equation gives the corresponding source equation. $\square$

The enclosing $H$ on a data variable matters. It makes the substitution lemma applicable even if $d'_x$ is a malformed payload. The fallback $c$ assigns such a value a consistent source interpretation.

## 3. Count the branches

Write the hard equation as $F(\vec l,\operatorname{cons}(t,\operatorname{nil}))=\operatorname{cons}(s,F(\vec r,\operatorname{nil}))$. Here $\vec l,\vec r$ are the sides of a fixed ground rewrite system, and $s,t$ are first-order terms with data unknowns. One fresh data variable $z$ suffices to write the two requests

$$
\begin{aligned}
F(\vec r,\operatorname{nil}) &= z,\\
F(\vec l,\operatorname{cons}(t,\operatorname{nil})) &= \operatorname{cons}(s,z).
\end{aligned}
$$

Their joint solvability is exactly the original equation. There are no separate data equations. The hard family uses a fixed machine and rewrite system, one operation of fixed arity, and eight original first-order variables. The signature encoding adds no variables. Its templates and tags are fixed across the family. [Ganzinger, Jacquemard and Veanes, Theorem 1 and §4, equation (6)](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/98ASIAN.pdf)

Apply the [Round 14 reduction](round-14-undecidability.html#compiling-one-unknown-operation-into-branches) to the two encoded requests. It produces one pin, one scope guard and two evaluation branches. Both setup conclusions are $\top$ because the list of data equations is empty. $\square$

This proves hardness with two informative branches and two consistency guards. The question with two branches *in total*, and the question with constructor-free input, remain open in this investigation. Flattening the target terms to depth one preserves the four branches. In that last transformation the number of variables can grow with the input. [Round 11, Proposition 6.1](round-11-witness-bounds.html#shallow-syntax-is-a-normal-form-not-a-restricted-fragment)

## 4. Three branches with more constants

**Theorem.** For some fixed finite set of constants and a single binary constructor, three branches suffice. Two evaluate the body and the third checks consistency. The number of constants here comes from a fixed ground rewrite system.

Let $R=\{l_i\to r_i\}$ be the fixed system in the rigid-reachability source above. Introduce a fresh constant $m_i$ for each rule. Replace it by two rules $l_i\to m_i$ and $m_i\to r_i$. In the two-call equation of §3, use all these new pairs as argument columns and retain the last column $(\operatorname{cons}(t,\operatorname{nil}),\operatorname{nil})$. Each column now has a known constant at one end.

*Why this change preserves hardness.* If $s\sigma$ reaches $t\sigma$ in $R$, replace each rewrite in the path by its two steps. Write the resulting path $w_0,\ldots,w_N$. For step $j$, take its rewrite context with the hole for that step's rule at the redex, leaving the rest of $w_j$ intact. This gives a term $U_j$ whose evaluations on the two rule-side vectors are $w_j$ and $w_{j+1}$. A body solving the modified equation is
$\operatorname{cons}(U_0,\operatorname{cons}(U_1,\ldots,\operatorname{cons}(U_{N-1},\xi_{\rm last})\ldots))$.
For an empty path use $\xi_{\rm last}$ alone.

Conversely, suppose the modified equation has a solution. Apply the homomorphism $m_i\mapsto r_i$ to its data and its body, leaving original constructors fixed. In the body, replace the hole for $l_i\to m_i$ by the original rule hole $i$, and the hole for $m_i\to r_i$ by the closed term $r_i$. Keep the last hole. On the two evaluations, these replacements give exactly the images of the modified argument pairs, namely $(l_i,r_i)$ and $(r_i,r_i)$. The resulting body solves the original hard equation. This direction also covers data or body literals containing the new intermediate constants. [Original hard equation and reachability equivalence](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/98ASIAN.pdf)

*Keep the midpoint constants atomic when encoding.* In addition to $a,b,f$, reserve distinct target constants for every $m_i$ and for $\operatorname{nil}$. Encode those distinguished symbols as their own atoms. Use the templates of §1 for all other constructors. Set $e(x)=x'$ for data variables and decode them directly by $D$. Decode each reserved atom to its source constant. The substitution lemma of §2 now accepts as an argument either a wrapped tree $H(v)$ or a reserved atom. A reserved atom cannot match a strict non-slot position in the templates, whose only literal constants are $a,b$. A template for a reserved atom has no strict positions. The same induction therefore applies. Every input to either call is either ground with a constructor at the root or explicitly headed by $\operatorname{cons}$. Thus its encoding is protected even with this encoding of data variables. Outputs and the data values themselves can be arbitrary.

*Remove the pin.* Keep the scope branch and the two evaluation branches. At one evaluation in each column, the formal coordinate $h_j$ takes a reserved atomic value. At the scope witness it has root $f$. This forces $P_{h_j}$ to be a parameter. The same scope witness gives distinctness and absence from data by the size argument of the guard lemma. There are no separate data equations, so the pin had no further obligation. The forward and reverse constructions of the main theorem now apply with three branches. $\square$

The third branch uses a single binary constructor. The larger stock of constants allows every midpoint to have an atomic root. Over exactly $\{f/2,a,b\}$ the proved bound here is four.

## 5. Check the signature change

[The executable signature check](round-14-signature.py) implements both decoders and compares the two sides of the substitution lemma. It includes inputs with malformed payloads, bodies with a hole at every fixed position in a constructor template, and bodies with holes nested at genuine slots. The run checks 58,482 identities on 722 bodies and 81 protected argument pairs. The midpoint extension checks another 18,150 identities and both directions of the rule-splitting construction on a concrete path. Removing the outer protection gives a failing identity. Run from the repository root.

~~~sh
python3 projects/jca/agent-collab/round-14-signature.py
~~~

The signature change and its application to the published hard family are proved above. [The Lean file](round-14-reduction.lean) verifies the subsequent step from binary-signature interpolation to ordinary JCA.
