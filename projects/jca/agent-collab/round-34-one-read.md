---
title: "JCA Round 34: Removing one permitted read makes one branch undecidable"
date: 2026-11-21
---

**Theorem.** Consider leading-fresh validity for idempotent substitution answers with the strong escape rule printed in the extraction. Over one binary constructor and one constant, one implication is NP-complete when substitution witnesses may use all public names. Remove **one read by one witness** and existence is r.e.-complete, even without the weak escape test. The prefix, public variables and forbidden read can be fixed independently of the input. The result also holds with both escape tests. [All reads permitted](round-31-leading.html) · [The two escape conventions](round-19-designated-parameters.html#two-parameter-conventions)

In Round 33 the weak check excluded an answer identifying the retained universal $r$ with a formal input $n_j$. Here every formal input in an ordinary active row must strictly contain $r$. Finite-tree consistency itself rules out the identification. [Single-carrier construction](round-33-carrier-reduction.html)

A different guard gives the single-forbidden-read lower bound for arbitrary presentations under the extracted weak escape rule alone. [Arbitrary weak conjunctions](round-39-weak-conjunctions.html)

## A binary encoding with a varying tag

Start with Round 17's two requests $B(L(d))=S(d,z)$ and $B(R)=z$. The ground vector $R$ is fixed. Each column has an atomic end and a compound end. The ordered columns are distinct for every ground choice of data. Every $L_j$ has an explicit outer constructor, including the data-dependent tail. [Source equivalence and binary templates](round-17-three-branches.html)

Use the same binary symbol $f$ and constant $a$. Take distinct ground trees $c_0=f(a,f(a,a))$ and $c_1=f(f(a,a),a)$ of equal size. Write $\theta_i(r)=f(c_i,r)$. Define a translation $e_r$ which leaves a variable alone and interprets the source constructors by

$$ A_r=f(\theta_0(r),a),\qquad F_r(x,y)=f(\theta_1(r),f(f(a,x),y)). $$

Thus $e_r(a)=A_r$ and $e_r(f(s,t))=F_r(e_r(s),e_r(t))$. The translation acts on the source expressions before instantiating their data. Use the prefix, designated set and packed lists $M_r$ of Round 33. The ordinary branch is

$$
 \bigwedge_j n_j=e_r(L_j)(d)\quad\Longrightarrow\quad
 E=M_r([n_1,\ldots,n_k,e_r(S)(d,z)])\ \land\
 K=M_r([e_r(R_1),\ldots,e_r(R_k),z]).
$$

All public names are permitted to every substitution witness, with the sole exception that the witness for $K$ cannot mention $r$. It can mention $E$, the only original existential move after $r$.

Given source data $d_*,z_*$ and body $B$, leave the ports and $r$ unbound. Define each data coordinate by its translated ground value $e_r(d_*),e_r(z_*)$, which can use the later $r$ under the strong rule. Define $E$ as the left packed list with final payload $e_r(B)(n)$, and $K$ as the right packed list with the translated $z_*$ inlined. At the activated ports the first source equality gives ordinary relevance. Any ground tag gives an active row. For validity, substitute $e_r(R_j)$ for the ports, the translated data for each datum, and $E$ for $K$. The second source equality gives the common packed value that $E$ plays. The definition of $E$ is individually prefix-valid. All other defined heads are designated and use only the later universal $r$, so the weak check is satisfied too.

Restoring the missing read makes **every instance of this particular family positive**, including a source with no rewrite path. Fix arbitrary ground data and $z$. Define $E$ literally by its required left expression (with the chosen data inlined), and define $K$ by the right expression. Use that right expression itself as the witness for $K$. It can now build the answer directly from $r$ and its ground literals. The ports can use any ground validity witnesses. Relevance holds by construction, and the ordinary ports can activate the premise at any chosen tag.

## The tag cannot alias a formal input

Eliminate fresh names at a joint witness and write $P_x$ for the solved public coordinates. As in Round 33, the strong rule leaves each $n_j$ unbound and excludes all ports from $P_d,P_z,P_K$. The generic validity play forces $P_r$ to be a bare parameter $u$. If $u=n_j$, the active premise would equate $n_j$ with a tree containing $n_j$ as a *proper* subtree inside its outer $\theta_i(n_j)$. No finite active witness could exist. Hence $P_r$ omits the ports. [Fresh-name elimination](round-31-leading.html#which-inputs-can-a-substitution-witness-observe)

For any values of the nonport parameters, set each port to its translated left input using $r=u$. This activates the premise. The $K$ equality therefore holds identically on all nonport parameters. The form $P_E$ must have root $f$: set every nonport parameter to $a$ and activate the ports. Its prescribed tree is compound and strictly contains every port value, so no bare parameter can equal it.

In the generic validity play specialize the original, substituted port moves to $a$ and call the independent value of $r$ the rigid letter $b$. Every original game move that $K$ may read, except $E$, is ground over $f,a$. This concerns the original moves before simultaneous substitution. The required $K$ has root $f$ with first child $b$. No term in the ground moves and the compound value of $E$ can construct the bare letter $b$. The witness must therefore return $E$ itself. [Single-generator lemma](round-33-probe.lean)

## The two packed evaluations yield a single body

Replace $b$ by $a$ in the validity row and freeze every nonport parameter at its resulting ground value. Write $d',z'$ for these data values and $N$ for the actual port values in this row. The carrier is now an open binary body in the ports alone. On the ordinary activated ports $L'_j=e_a(L_j)(d')$ it gives the left packed list. On $N$ it gives the right packed list by the carrier equality. Write $R'_j=e_a(R_j)$.

The addresses of every payload already exist in that body. At the left evaluation each fork strictly above a payload has left child either $a$ or $f(a,v)$ for some $v$. Every inserted port, on the other hand, has root $f$ with left child $f(c_i,a)$, where $c_i\ne a$. A port cannot occupy any of those strict ancestors. Extract the payload bodies $T_j,T_*$ at the same addresses in the two evaluations. Then

$$ T_j(L')=L'_j,\quad T_j(N)=R'_j,\qquad T_*(L')=e_a(S)(d',z'),\quad T_*(N)=z'.$$

Each $T_j$ must be a bare port. An atom could not produce $L'_j$. If $T_j=f(v,w)$, the value $v(L')$ is one of the two tags $\theta_i(a)$. Every left port tree is strictly larger than either tag, since the tags have equal size. Therefore $v$ contains no port at all. It must have the same value in the other row, whereas the two ends of the source column have opposite root types and hence different tags. This is impossible.

The ordered encoded columns are distinct. The compound ends of two rule columns with the same orientation have distinct encodings of their fixed ground wrapper tags. The data-dependent tail still has its own outer wrapper. Equivalently, the decoder below maps every putative equality of encoded column pairs to an equality of original pairs at the common decoded data. As in Round 33, the $k$ bare probes select a permutation of the $k$ ports. Rename the formal inputs in $T_*$ by this permutation. The resulting binary body has the specified left value at $L'$ and right value at $R'$.

## Decoding arbitrary bodies

At a root hole the decoder returns the corresponding formal input. At a root matching $F_a(x,y)$ return $f(D(x),D(y))$. At every other root return $a$. These rules decode $A_a$ and $F_a$ to their original constructors for all child values. In particular $D(e_a(S)(d',z'))=S(D(d'),D(z'))$.

For any open body $T$ and either vector of prescribed encoded arguments $v=L',R'$, decoding commutes with evaluation:

$$ D(T[v])=D(T)[D(v)]. $$

At a hole this is the definition. At a non-hole root an existing $F_a$ match keeps its two children after substitution. A new match could arise only if a whole substituted port occupied a strict fixed position in the pattern. At the tag or inside it this is impossible by size. At the right cell $f(f(a,x),y)$ it is impossible because a port's left child is $f(c_i,a)$ with $c_i\ne a$. At $f(a,x)$ the required left child would be $a$. The remaining fixed leaf is $a$ itself. Thus the same case applies, and induction at the two payload children proves the identity. Applying it to the renamed body gives the original source solution with data $D(d'),D(z')$.

Enumeration of candidates and prefix/unification checks give the r.e. upper bound. The construction also works on any fixed finite signature with a branching constructor and a constant: embed $f$ in the first two fields of that constructor with constant padding. In decoding, inspect only those two fields and treat every other root as a default. A bare probe is still forced because its first child at the left row is too small to contain a port. The proper-containment, generator, and address arguments use only the two selected fields. On monadic signatures both conventions are decidable for arbitrarily many branches. [Monadic result](round-19-designated-parameters.html)

## Verification

The [executable check](round-34-one-read.py) builds an implication for a directed rewrite path and checks its explicit answer with and without the weak test. It also checks that every port alias violates consistency and tests the decoder on malformed bodies and insertions into fixed positions. [Lean](round-34-decoder.lean) checks the fixed-position obstruction and proves decoder commutation for arbitrary binary bodies and lists of admissible replacements. The reduction from source reachability is the written proof above.
