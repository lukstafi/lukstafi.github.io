---
title: "JCA Round 33: One branch and one restricted carrier can test a proof twice"
date: 2026-11-21
---

**Theorem.** Under leading-fresh validity with the extracted strong escape rule, existence of an idempotent substitution answer is r.e.-complete over one binary constructor $f$ and one constant $a$, already for **one implication**. The prefix, number of public variables, and witness permissions can all be fixed. It suffices to give *every* witness the same permission to read every public name except one universal $r$. The same lower bound holds if witnesses can read only existential moves. With the weak and strong escape checks together, **one forbidden read in the whole instance** suffices: every witness may read every name, with the sole exception that $K$ cannot read $r$.

Round 34 removes a single read even under the strong test alone by giving every formal input a tree containing the tag. [One forbidden read](round-34-one-read.html)

The choice of permitted names matters. With unrestricted witnesses, the same one-branch solved-answer problem is NP-complete. The hard family lets a witness read a value containing a universal input while denying direct access to that input. Each supplied answer still has a decidable validity test. [Unrestricted witnesses](round-31-leading.html) · [Checking a supplied answer](round-32-carriers.html)

## Two requests for the same term

Use the binary encoding of fixed ground rigid reachability. Its input specifies terms $L_j(d)$ and $S(d,z)$, with the following undecidable question. Do there exist ground data $d,z$ and a binary term $B$ in $k$ formal arguments such that

$$ B(L_1(d),\ldots,L_k(d))=S(d,z),\qquad B(R_1,\ldots,R_k)=z? $$

Here $R_j$ are fixed ground trees. For every ground $d$, exactly one end of each column $(L_j(d),R_j)$ is $a$, and the other has root $f$. The columns are pairwise distinct. Each compound left entry has a fixed ground tag as its left child, even when its payload contains data. Different rule slots of the same orientation have different wrapper tags at their compound ends, and the tail has its own tag. The equivalence with directed reachability holds for arbitrary binary solutions. A fixed machine supplies fixed $k$ and a fixed number of data names. [Binary construction, §§2–4 and 7](round-17-three-branches.html) · [Ganzinger, Jacquemard and Veanes, §§3–4](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/98ASIAN.pdf)

## One implication and one carrier

For a tag value $r$, write $H_r([])=a$ and $H_r(v::w)=f(f(r,v),H_r(w))$. Put $M_r(w)=f(r,H_r(w))$. Every strict ancestor of a payload position in $M_r$ has root $f$ and contains the tag.

Use the prefix

$$ \forall n_1\cdots n_k\quad\exists d,z,K\quad\forall r\quad\exists E. $$

The designated names, also substituted simultaneously in validity, are $n_1,\ldots,n_k,d,z,K$. First allow every witness to read every public name except $r$. The proof also applies if all may read only existential moves, or if only $K$ may read $E$ and the other witnesses must be ground. In each case $K$ can copy $E$ and all witnesses can use ground trees. The ordinary branch is

$$
\bigwedge_j n_j=L_j(d)\quad\Longrightarrow\quad
 E=M_r([n_1,\ldots,n_k,S(d,z)])\ \land K=M_r([R_1,\ldots,R_k,z]).
$$

Both sides can be packed into one equality each using matching binary constructors. The strong test for a definition with designated left side $x$ requires every original universal $u$ in that **whole atom** to satisfy $u\not\le_Q x$. Thus a designated universal port cannot itself be a defined left side. A defined datum, $z$, or $K$ cannot use a port in its body. This is the comparison printed in the extraction. [Escape clauses and their source conventions](round-19-designated-parameters.html#two-parameter-conventions)

Given a solution, leave $n,r$ free, define $d,z$ by their ground solution, and use the two definitions

$$ E=M_r([n_1,\ldots,n_k,B(n)]),\qquad K=M_r([R_1,\ldots,R_k,z_0]), $$

where $z_0$ is the literal ground value of $z$. The ordinary branch checks the first evaluation and is active at $n=L(d)$. For validity choose $n:=R$, the displayed ground data, and $K:=E$. The final existential move plays the common packed tree, using the second evaluation. The definition of $E$ alone is prefix-valid since its inputs precede it. The other definitions pass the strong and weak scope tests directly.

## Recovering the source solution from any answer

Remove fresh names using a joint witness as in Round 31. Write $P_x$ for each coordinate of the resulting solved answer in its unbound public names. The strong test leaves every port $n_j$ as its own independent parameter. The forms $P_d,P_z,P_K$ omit every port, including when the corresponding coordinate is itself unbound. [Eliminating leading fresh names](round-31-leading.html#which-inputs-can-a-substitution-witness-observe)

Take a generic validity play, treating $r$ as a new rigid letter $b$. Specialize the original, substituted universal moves for the ports to $a$. Write $V_x$ for the ordinary coordinate values obtained by applying the chosen witnesses at that play. They form an instance of $P$. The retained universal has value $b$, so $P_r$ is a bare unbound parameter $u$ with $V_u=b$. At this play every original game move except $r,E$ is ground over $f,a$, since the other existential moves precede $r$. The ordinary values of substituted coordinates may differ from these original moves. [Generic validity tuple](round-32-carriers.html#checking-a-supplied-answer-by-generation-of-terms)

First, $P_E$ has root $f$. Set all nonport parameters to $a$ and set the ports to $L(P_d)$. This satisfies the premise because $P_d$ omits the ports. The prescribed $E$ has every port value as a proper subtree, so it differs from every port. It is compound, so it also differs from $a$ and from every other parameter at this row. Consequently its open form can be neither a constant nor a bare parameter.

The only permitted game value that could contain the rigid letter $b$ is $V_E$, and it has root $f$. No term constructed from that tree and ground trees over $f,a$ can yield the bare letter $b$. Hence $u$ is different from every port. This step only requires excluding $r$ from the port witnesses.

Every assignment to the nonport parameters extends to an ordinary active row by setting $n=L(P_d)$. Since $P_K,P_z,P_r$ omit the ports, relevance forces the identity

$$ P_K=M_u([R_1,\ldots,R_k,P_z]). $$

Distinct open terms can be separated by a ground assignment in this nontrivial free algebra. Thus the identity holds also at the generic validity play, where $V_K=M_b([R_1,\ldots,R_k,V_z])$. Replace every ground move read by the witness for $K$ with its literal ground tree. The resulting term has just one possible generator, $V_E$. It cannot have root $f$, because its first child would have to yield the bare letter $b$. It cannot be $a$. It must therefore return the generator itself, giving $V_E=V_K$.

Replace $b$ by $a$ throughout the generic row to obtain ground data $d_0,z_0$ and actual port values $N$. Freeze all nonport parameters except $u$ at their values in this row, leaving $u$ and the ports formal. The remaining data forms may still contain $u$. First set the ports to $L(P_d(u))$, leaving $u$ formal. Ordinary relevance makes the carrier identically the left packed expression at these arguments. This identity holds because every original ground choice of $u$ activates the branch with these ports.

Every strict ancestor of a payload position in that expression has root $f$ and has the formal $u$ in its **left child**. This holds for the outermost fork, each list cell and each tagged entry. No substituted port can supply such a fork: a left column entry $L_j(P_d(u))$ is either $a$ or a fork with a fixed ground tag as its left child. A bare occurrence of $u$ cannot supply the fork either. Therefore all those addresses exist already in the open carrier body. Now set $u=a$ and extract its payloads $T_j,T_*$. They are terms on the ports alone. The ordinary evaluation at $u=a$ and the grounded generic equality $V_E=V_K$ give

$$
 T_j(L(d_0))=L_j(d_0),\qquad T_j(N)=R_j,\qquad
 T_*(L(d_0))=S(d_0,z_0),\qquad T_*(N)=z_0 .
$$

Each $T_j$ takes both atomic and compound values, so it is a bare port $n_{i(j)}$. Its two values are the desired column $(L_j(d_0),R_j)$. Distinct columns force distinct $i(j)$. There are exactly $k$ ports, making $i$ a permutation. Rename $n_{i(j)}$ to $n_j$ in $T_*$. Its left evaluation stays the same because $L_{i(j)}(d_0)=L_j(d_0)$. Its new right evaluation is the old value at $N$ because $N_{i(j)}=R_j$. The renamed term solves the original two requests with the same $d_0,z_0$.

Finally enumerate finite answers and permitted witness terms. Ordinary unification, the two syntactic escape tests, and the prefix test after the witnesses are supplied are effective. Together with the fixed-source reduction this proves r.e.-completeness.

## Removing just one read permission

When both escape tests are imposed, allow every witness to read every name with the single exception of the read of $r$ by $K$. Reconsider the sole step that restricted the port witnesses. If $u=n_j$, the solved answer contains exactly the atom $r=n_j$, since $r$ and $n_j$ are distinct public names and $P_r$ is a bare parameter. Both variables are independently universal in the original prefix, so the atom fails individual validity. Its only designated variable is $n_j$. Taking the universal $n_j$ itself in the weak escape test would require $n_j\not\le_Q n_j$. The atom is therefore inadmissible. This excludes every port alias without restricting any port witness. The remaining proof uses only the missing read by $K$. With all reads restored, Round 31 gives NP-completeness under the same two escape tests. [All reads permitted](round-31-leading.html)

The weak test is used essentially in this last argument. For this very family, keeping only the strong test and restoring all port reads makes even negative source instances pass. Choose a port $p$ whose left endpoint is $a$. Use the definition $r=p$, arbitrary ground data $d_0,z_0$, the ordinary left packed expression with tag $p$ for $E$, and the literal right packed expression with tag $a$ for $K$. At every active row $p=a$. In validity choose the witness $p:=r$ and let $K$ use its literal ground value. The strong test permits the nondesignated left side $r$. The weak test rejects $r=p$ exactly as above.

## The arity boundary

Both hardness statements hold on **every fixed finite single-sorted signature with a branching constructor and a constant**. Choose an $m$-ary symbol $g$, $m\ge2$, and a constant $c$. Translate each binary node to $g(x,y,c,\ldots,c)$ and $a$ to $c$. The carrier must have root $g$ because the ordinary check forces this root and rules out every bare parameter. A witness constructing the observation by a $g$-node still has to produce the bare rigid letter at its first child. The argument recovering the payload addresses follows the first two children of each marked constructor. Each pair of endpoints still contains an atom and a compound, so the bare-port and permutation arguments are unchanged.

The resulting proof body and data may use extra constructors. Map each $g$-node to the binary fork on the images of its first two children, and map every other constructor to $a$. Keep formal parameters as parameters. This map commutes with substitution by structural induction and is the identity on binary terms after the displayed embedding. Applying it to the two recovered evaluations produces a genuine binary source solution. The forward direction embeds the binary answer and its witnesses directly. With unary constructors and constants alone, Round 19 decides even arbitrarily many branches and arbitrary read permissions. [Monadic decision proof](round-19-designated-parameters.html#a-small-presentation-for-leading-fresh-parameters)

## Verification

The [executable reduction](round-33-carrier-reduction.py) constructs the packed implication over the one-constant encoding, checks the ordinary branch and the quantified substituted answer independently, and exercises both escape rules. It checks a directed path of two rewrites inside a context, the empty path, a nonground observation requirement, and a solution with two port names exchanged. It checks the same witness under the common and single-deletion permissions and checks the spurious port alias with the weak test switched off and on. The [Lean file](round-33-probe.lean) checks the single-generator argument, recovery of the payloads when a substituted port has a ground left tag, and the bare-port conclusion from opposite roots. The full reduction and its permutation argument are proved above.
