---
title: "JCA Round 38: A single forbidden read with only the weak escape test"
date: 2026-11-21
---

**Theorem.** Under leading-fresh validity and the extracted **weak** escape test, existence of an idempotent substitution answer for one implication is r.e.-complete over one binary constructor and one constant when just one public name is forbidden to one witness. The prefix and the forbidden read can be fixed. With all reads permitted the same problem is NP-complete. The answer format matters: on the hard family below, allowing arbitrary weak conjunctions makes *every* instance positive. [All reads permitted](round-31-leading.html) · [Earlier strong-rule proof](round-34-one-read.html)

## Put the data before the formal inputs

Take the binary requests $B(L(d))=S(d,z)$ and $B(R)=z$ for a single unknown body. Each column has one atomic end and one compound end, the columns are distinct for every choice of data, and $R$ is fixed. Each compound left entry is a macro of the form $f(t,P)$, where the argument list $P$ is either $a$ or $f(f(g,x),p)$, with $g=f(a,a)$. [Two-call source and one-constant encoding](round-17-three-branches.html)

Write $H_r([])=a$, $H_r(v::w)=f(f(r,v),H_r(w))$, and $M_r(w)=f(r,f(a,H_r(w)))$. An ordinary port value $L_j(d)$ can **never equal $M_r(w)$**. The atom has a different root; the right child of a compound port is either an atom or has a compound left child. The right child of $M_r$ has left child $a$. This disjointness holds also when the data contain arbitrary malformed trees.

Use the prefix and one ordinary branch

$$
 \exists d,z\quad\forall n_1\cdots n_k\quad\exists K\quad\forall r\quad\exists E,
$$

$$
 n=L(d)\quad\Longrightarrow\quad
 E=M_r([n_1,\ldots,n_k,S(d,z)])\ \land\ K=M_r([R_1,\ldots,R_k,z]).
$$

Only the ports and $K$ are designated and substituted. All witnesses may use every public name, except that $K$ cannot read $r$. Ordinary relevance and consistency see all variables before substitution. A source solution fixes the data to their literal ground values, leaves the ports and $r$ unbound, and defines $E$ by the left packed list with $B(n)$ as its final payload. Define $K$ by the right packed list with the ground result inlined. Its only universal is the later $r$, so it passes weak escape directly. The $E$ atom is individually prefix-valid. Choosing $n:=R$ and $K:=E$ gives validity by the second source evaluation.

## What the weak rule forces in a solved answer

Remove fresh names at a joint witness as in Round 31. In an idempotent substitution each public coordinate is either unbound or has a single definition over unbound public names. Any answer atom containing a port must be individually prefix-valid. Indeed that port itself is universal in the earliest designated block; none of the designated names in the atom can be strictly earlier. This uses the extracted comparison $u\not\le_Q k$. [Scope test and fresh-name elimination](round-31-leading.html)

1. **Each port is unbound.** A definition of universal $n_j$ can pass individual validity only by equating it to a *bare later existential* that can copy it. A compound misses the atomic choice, a constant misses another choice, and other bare names are fixed earlier or independently universal. The only later existentials are $K,E$. At an ordinary active row neither can equal a port, by the disjointness above. Consistency rules out both aliases.
2. **Data definitions omit all ports.** An initial existential cannot choose a value equal to a term containing a subsequently chosen universal for every choice of that universal. Thus a definition of a datum or of $z$ involving a port fails individual validity. If a datum is unbound its form already omits the ports.
3. **The tag is literally the free name $r$.** In the generic validity play, a retained universal's normal form must be a bare unbound name. A port alias $r=n_j$ fails individual validity under the two independent universal moves. An initial data coordinate cannot supply the rigid tag either: it is retained and played before $r$. An alias to $K$ or $E$ would require a finite tree to equal a packed tree containing itself at the ordinary active row. These exhaust the names. Since the initial data have ground generic values and the free $r$ has a rigid-letter value, the data forms also omit $r$. [Generic-play criterion](round-32-carriers.html)
4. **The observation definition omits the ports.** Hold the other nonport parameters fixed, set $n=L(d)$, and vary $r$. These choices always activate the premise because the data omit the ports and $r$. The required $K$ varies. Hence $K$ is defined and its body contains the literal $r$. If this same definition contained any port, it would require individual validity. The existential $K$ precedes $r$ and its finite value cannot contain every later choice of $r$ at a fixed address. This excludes every port from the body.
5. **The carrier has constructor root.** At the same varying ordinary rows its value is a fork that varies with $r$. A constant or any input other than $r$ would be fixed; the bare $r$ fails at $a$. Hence its normal form has root $f$.

## Extracting the two evaluations

Since the $K$ form, data and tag omit the ports, setting $n=L(d)$ for arbitrary nonport parameters gives the identity $P_K=M_r([R_1,\ldots,R_k,P_z])$. At a generic play let $r$ be a rigid letter and specialize the original dummy universal port moves to $a$. Among moves accessible to the witness for $K$, only $E$ can contain the rigid letter. Its value has root $f$. To construct the required $K$ with a constructor at the root, a witness would have to produce the bare rigid letter in its first child. This is impossible with a compound generator and ground moves. Thus $K$ copies $E$. [Single-generator lemma](round-33-probe.lean)

Ground the letter to $a$ and freeze every nonport parameter except $r$ at this play. The data become $d_0,z_0$. With the ports set to $L(d_0)$, leave $r$ formal in the ordinary row. Every strict ancestor of a payload in the packed output is a fork containing $r$, including the additional wrapper $f(a,H_r(\ldots))$ because the list is nonempty. No ground left port can supply such a fork, nor can the bare $r$. The payload addresses therefore exist in the open $E$ body itself. Set $r=a$ and read their bodies on the ports alone.

Write $N$ for the actual port values in the grounded validity row. The first $k$ payloads give $L_j(d_0)$ at $L(d_0)$ and $R_j$ at $N$. Opposite endpoint roots force each body to be a bare port. Distinct columns make the $k$ selections a permutation. Renaming the ports by this permutation gives the last payload value $S(d_0,z_0)$ at $L(d_0)$ and $z_0$ at $R$. This is the source solution. Enumeration of answers and witness terms gives the r.e. upper bound. The argument extends to every finite signature with a constant and a branching constructor by padding and projection as in Round 33. [Renaming and signature transfer](round-33-carrier-reduction.html)

## Two individually valid equations defeat the construction

Choose a port $p$ with left entry $a$ (an outgoing rule slot). Fix arbitrary ground data $d_0,z_0$. Let $Y(n)=M_a([n_1,\ldots,n_k,S(d_0,z_0)])$ and $K_0=M_a([R_1,\ldots,R_k,z_0])$. Use the data pins, $K=K_0$, and the two atoms

$$ E=Y(n),\qquad E=Y(n[p:=r]). $$

Each $E$ atom is individually prefix-valid, since $E$ is the last existential. Their conjunction entails $p=r$ by injectivity at the displayed payload. At an ordinary active row $p=L_p=a$, so the tag must be $a$ and the prescribed conclusions both hold. An active row exists at these exact values. In validity choose $p:=r$, any ground values for the other ports, and the literal $K_0$ for $K$. The final carrier can satisfy both identical requests. This argument works equally well for a negative directed reachability instance.

Thus changing to arbitrary weak conjunctions invalidates the converse for this family. A terminal carrier can impose an otherwise inadmissible equation between universal coordinates by using it in two individually valid definitions. Round 39 moves the port equations into the conclusion and proves the same lower bound for arbitrary weak conjunctions. [Guarded reduction](round-39-weak-conjunctions.html) [Executable branch, validity checks and counterexample](round-38-weak-solved.py)
