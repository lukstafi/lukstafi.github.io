---
title: "JCA Round 19: Designated parameters and two-branch prefix hardness"
date: 2026-11-21
---

**Results.** Over one binary constructor and one constant, two evaluation branches suffice for r.e.-complete equational JCA under an $\exists\forall\exists$ prefix. With only unary constructors and constants, allowing designated invariant parameters still gives a decision procedure under each of the two parameter conventions recorded in this project. They agree on this decidability boundary but can give different answers on the same one-branch input.

Throughout, the model consists of finite ground terms over a finite single-sorted signature with at least one constant. Answers are finite conjunctions of equations, with existential projection of fresh variables for ordinary relevance and consistency. Sections 2–4 specify how fresh variables are treated for the additional validity test.

## 1. The prefix replaces the scope branch

Let $d$ range over the data coordinates, $h_1,\ldots,h_k$ over the formal arguments and $y$ over the result. A two-call term interpolation instance asks for one ground data tuple and one finite body $B$ such that

$$B(\vec s_i(d))=t_i(d)\qquad (i=1,2).$$

Use the two branches $\vec h=\vec s_i(d)\Rightarrow y=t_i(d)$ and give them the common prefix

$$\exists d\quad\forall\vec h\quad\exists y.$$

**Lemma.** With no designated parameters, these branches have an answer exactly when the two requests have a solution. The proof works for any number of requests.

A solution supplies the answer equations fixing the data to $d$ and setting $y=B(\vec h)$. They have no fresh variables. For every tuple of arguments, choosing this value of $y$ witnesses prefix validity. Each evaluation can choose its displayed arguments and then gives the required result.

Conversely, prefix validity supplies a data tuple $d_0$ for which every argument tuple occurs in some full solution of the answer equations. For leading fresh universals, fix them all to one ground value first. For trailing fresh existentials, keep the witnesses selected after the arguments. In particular one may play all $h_j=a$ and, in another play at the same $d_0$, set each $h_j$ to a different tree strictly larger than every component of $d_0$, using the scope terms of Round 14. These are precisely the two consistency witnesses needed for its pin and scope guards. Their conclusions are empty since there are no separate data equations. Adding both guards to the ordinary evaluation conditions now gives an interpolation solution by Round 14. The data in that recovered solution need not equal $d_0$. [Equational reduction and guard proof](round-14-undecidability.html#compiling-one-unknown-operation-into-branches)

Apply the lemma to the two-call hard family over $\{f/2,a\}$ of Round 17. The resulting prefix problem is r.e.-complete with **two branches**, each with one conclusion equality, and a fixed number of coordinates. Enumeration checks a proposed finite answer and, when needed, its finite witness terms. Fixed candidate tests here reduce to unification and prefix games on finite-tree patterns. Round 18 extends the lower bound to every fixed signature with a branching constructor. Round 25 subsequently proves ordinary two-branch hardness by a different construction. [Ordinary two-branch lower bound](round-25-binary.html) In the construction here, omitting the guard from the *ordinary* reduction permits backwards rewrites; adding the prefix prevents the data from changing with the arguments. [One-constant encoding and the ordinary relaxation](round-17-three-branches.html) · [Ganzinger, Jacquemard and Veanes, equation (6) and Lemma 5](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/98ASIAN.pdf)

### One branch with an input-only premise

In the parameter-free three-block prefix $\exists d\,\forall h\,\exists y$, allow arbitrary tuples and a single branch $D(d,h)\Rightarrow C(d,h,y)$ of conjunctions of equations. Answer existence is equivalent to the first-order sentence

$$\exists d\;\big[(\exists h\; D(d,h))\ \land\
       \forall h\,(D(d,h)\Rightarrow\exists y\,C(d,h,y))\big].$$

For necessity, project an answer to its tuple pattern. Its $h$ coordinates are independent bare parameters absent from every data coordinate, by prefix validity. Choose $d$ **from the branch consistency witness** and hold all parameters other than the $h$ parameters at their values in that witness. Every $h$ is still available with this same $d$. Whenever $D$ holds, the answer outputs give $C$ by relevance.

Conversely fix a ground $d$ from the sentence. Compute an idempotent unifier $\mu$ of $D(d,h)$ and write $r$ for its unbound original input variables. Every assignment to $r$ extends to inputs $\mu(h)$ satisfying $D$, and at these inputs each coordinate in $r$ retains its freely assigned value. The sentence gives $\forall r\,\exists y.\, C(d,\mu(h),y)$. The solutions of this conjunction form a tuple pattern. Its $r$ coordinates must be distinct bare parameters because every $r$ tuple is available. Rename them to the original $r$ variables and ground any other residual parameters. This gives a tuple of **terms** $B(r)$ that works at every assignment to $r$. Use the answer fixing $d$ and setting $y=B(r)$ on the original input coordinates. It is valid even on inputs outside $D$, and relevance and consistency follow. The one-element algebra is immediate.

The first-order theory of finite ground terms is decidable, so this gives an exact one-versus-two branch threshold for the three-block prefix **with input-only premises** over branching signatures. Interleaving universals can change this argument. For instance, $\forall u\,\exists y\,\forall v.\,(u=f(v,a)\Rightarrow y=v)$ admits an ordinary semantic strategy that reads the left child. A term answer must choose $y$ using only $u$ and independent parameters. After grounding the latter, a term containing $u$ is too large when $u=f(v,a)$ and a term lacking $u$ cannot return every $v$. [Comon and Lescanne, *Equational Problems and Disunification*](https://inria.hal.science/inria-00075652/file/RR-0904.pdf)

Round 20 gives a polynomial-time algorithm for this three-block case. It also decides one input-only branch for arbitrary interleavings, where the problem is NP-complete on branching signatures. [One-branch classification](round-20-one-branch.html)

## 2. Two parameter conventions

Write $X$ for all public variables, $K\subseteq X$ for the designated invariants tested for escaping, $T\subseteq X$ for public variables substituted in validity, and $B$ for the fresh answer parameters. All public variables are quantified. Prior parameters can be included among $T$ when the convention calls for their substitution. Ordinary branch tests see the original public variables.

- **Trailing witnesses.** In the original TeXmacs source both fresh and designated parameters receive term substitutions. Its operational validity test moves those variables into a trailing existential block. Use $Q_{X\setminus T}\,\exists T\,\exists B.\,A$ and allow substitution witnesses to mention the remaining universal variables. The original weak and strong escape clauses use the reflexive relation $u\le_Q k$.
- **Leading fresh parameters.** In the extraction and the later clarification, the fresh parameters survive the substitution. Test $\forall B\, Q.\,A[T:=\vec t]$ for some finite tuple of terms. Substitution is simultaneous. A finite set of allowed variable leaves for each $t$ specifies which original variables or fresh parameters it may mention. This covers ground witnesses as well as witnesses allowed to use earlier or later named variables. The construction below works with either printed comparison on prefix positions.

The original $\le_Q$ compares quantifier blocks. The extraction prints $\not\le_Q$ in both escape clauses. We keep the scope predicate as an input to the leading-fresh decision procedure. This covers a fixed ancestry relation on public names when it is used as the **atomwise** test. An implementation can impose further conditions on substitutions and solved forms. [Original source, §4.2.1](../lukstafi-phd-thesis.tm) · [Extracted definition](../thesis_section_4_2.md) · [Recorded clarification and source comparison](round-9-subsumption-bottleneck.html)

## 3. Trailing witnesses admit a direct pattern presentation

**Theorem.** Under the trailing convention with $K\subseteq T$ and the original atomwise escape clauses, a public pattern relation has an admissible presentation if and only if its projection onto $X\setminus T$ passes the prefix game for $Q_{X\setminus T}$.

Necessity follows by projecting any valid presentation. For sufficiency, give **every** public coordinate $x$ the equation $x=P_x(B)$, using only fresh names for the distinct residual parameters of the tuple pattern. These equations form an idempotent substitution. For any winning play of the projected prefix game, the remaining coordinates and fresh leaves have a joint extension by the definition of projection. They are precisely the trailing witnesses. The ordinary solution relation on *all* public coordinates, including $T$, stays the same.

This presentation also gives syntactic witness terms. By the Round 18 criterion the retained universal coordinates have distinct bare leaves. Replace those fresh leaves by the corresponding original universals. Replace every other fresh leaf by one ground constant. Use these terms for $B$, and the resulting $P_t$ for each $t\in T$. Every retained existential can play its resulting coordinate term when its turn comes. By the criterion, that term contains only earlier retained universals. This realizes the source validity test with actual term witnesses. Before substitution the fresh parameters are jointly unconstrained in the ordinary sense that every assignment of all of them extends to an answer tuple. [Prefix pattern criterion](round-18-signature-boundary.html#parameter-free-quantifier-prefixes)

Every answer atom contains at most one *public* variable. An atom involving $k\in K$ is $k=P_k(B)$. The only possible universal from $Q$ in it is $k$ itself, and $k\le_Q k$. Both original escape tests therefore hold, including the strong test for substitution-form answers. This is a statement about existence of a presentation. A scope test on the transitively expanded dependencies of the original variables could distinguish a different class of answers.

On a monadic signature use the Round 18 word-equation construction on the full pattern for the branch tests and just its retained coordinates for prefix validity. This gives the same complexity bounds as ordinary JCA. For a single branch on any nontrivial signature, moving the substituted coordinates to the final existential block gives an NP-complete problem. [Single-branch corollary](round-30-monadic.html#designated-coordinates-under-the-trailing-witness-convention)

For leading validity on branching signatures, one branch is NP-complete for solved answers with unrestricted witnesses. Restricting each witness to its own specified names can already give r.e.-complete one-branch existence under the extracted strong rule. [Unrestricted witnesses](round-31-leading.html) · [One forbidden read](round-34-one-read.html)

## 4. A small presentation for leading fresh parameters

The preceding presentation would turn a universal coordinate $u$ into an equation $u=b$ with $b$ fixed before $u$ is chosen. For leading fresh parameters, search the atom presentation itself. Assume for now that the algebra has at least two ground terms. The singleton case admits the empty answer for every instance.

**Small-presentation lemma.** Over a monadic signature, if an answer exists in the leading convention, an answer exists with at most $n=|X|$ fresh parameters and at most $2n$ atoms. The bound counts atoms and parameter names. Constructor words in those atoms can have unbounded length.

*One fresh root per component.* A satisfiable monadic equation has comparable unary prefixes. After cancelling their common prefix it is an identity, a relation $x=w y$, or a pin $x=w c$ to a ground term. Use the variable-variable relations as edges, including isolated vertices. The value of either endpoint determines the value of the other whenever the equation holds, by prefix cancellation. A component can therefore contain at most one leading fresh parameter. Indeed validity supplies an ordinary solution of $A$ for **every** independent choice of $B$: evaluate the witness terms for $T$ in a successful play and use those values in the original equations. Two distinct leading parameters in the same component would violate that independence. Discard components with no public variable. Their equations have a ground solution, so this preserves the public projection. Any removed fresh parameter occurring in a validity witness term can be specialized to a constant. Each remaining component contains a public vertex, proving $|B|\le n$.

*Keep a spanning forest and one pin per component.* Retain the original atoms on the forest edges. The most general unifier of those edges assigns all variables in a connected component terms with the same leaf, since the two sides of every retained edge unify. A deleted chord $x=w y$ holds in one full ground witness of $A$. At the forest unifier its sides have the form $Ue$ and $Ve$ with the same leaf $e$. Equality in that witness gives $U=V$ by right cancellation. Thus the forest entails every deleted chord. One ground pin determines the whole component whenever a pin exists. A component on $v$ variables now uses at most $v$ atoms. The retained atoms are a subset of the original ones, so every atomwise check they passed still holds. Deleting an equation from an idempotent substitution also preserves its solved syntax.

For the weak test, cancelling common prefixes in retained atoms preserves both their variable sets and their prefix validity, and exchanging sides preserves equality. For the strong substitution-form test use the original orientation $x=t$; no cancellation is necessary. With no branches the empty answer suffices. Otherwise branch consistency supplies the joint witness used in the proof. $\square$

**Decision procedure.** Guess the names, the atom endpoints, and symbolic unary words on at most $2n$ edges and pins. For the strong test, guess an idempotent substitution and check its syntactic orientation. For each $d\in T$ guess a witness word and an allowed variable or constant leaf. Use the following tests on these shared word unknowns.

1. For each branch, compute a symbolic most general unifier of $A\land D_i$ and check $C_i$ at it. Round 18 implements each orientation of prefix cancellation with an existential word equation.
2. After the single simultaneous substitution, unify $A[T:=\vec t]$ symbolically. Test the resulting full-coordinate pattern against $\forall B\,Q$. At a universal, its normalized prefix must be empty and its leaf must be fresh relative to all preceding coordinates. These are word equalities and finite name tests.
3. For the weak escape condition inspect each atom involving a designated variable. If some universal in the atom has no allowed designated partner there, require the **original atom on its own** to pass $\forall B\,Q$. This implements the exemption for individually valid atoms. The strong oriented condition uses its prescribed syntactic test, without that exemption. The two tests can also be imposed together.

Every passing disjunct directly specifies an answer and its permitted witness terms. The small-presentation lemma ensures completeness. Each trace has polynomial size: an elimination appends one fresh remainder word, and a removed leaf never reappears. A word-equation solver therefore puts the problem in PSPACE. With exactly one unary symbol the trace is a polynomial-size nonnegative linear system, giving NP membership. The all-existential instances give the matching one-letter NP lower bound; they also give the constants-only NP lower bound with at least two constants. The branching lower bound in §1 uses empty $K,T$, so it applies to both full input classes. These results classify single-sorted **existence**, without requiring the enumeration of most-general answers. [Word-equation bound](https://arxiv.org/abs/1702.00736) · [Ordinary lower bounds](round-18-signature-boundary.html)

## 5. An input separating the two conventions

Use a unary constructor $g$, a constant $a$, $K=T=\{k\}$, and the original weak scope order. Take

$$\forall k\;\exists z\;\forall u.\quad (\top\Rightarrow k=g(u)).$$

For trailing witnesses the two atoms $u=b$ and $k=g(b)$ work with fresh $b$. Use $b:=u,k:=g(u)$ in validity. Each atom satisfies the escape check and the ordinary branch is consistent and relevant.

For leading fresh parameters **no answer exists**, even when the witness for $k$ may mention $u$. Fix the leading parameters and the original choice of the universally bound $k$ in the validity game. Choose the same winning $z$ before trying two different values of $u$. After evaluating the substitution for $k$, one obtains two ordinary solutions of $A$, agreeing on every variable except $u,k$. Relevance forces the two values of $k$ to be $g(u)$ in their respective rows. Some atom must mention both $k$ and $u$: otherwise one could mix $k$ from the first row with $u$ from the second while preserving every atom, contradicting relevance. In a monadic language such an atom has the two distinct leaves $k,u$, one on each side. It fails individual validity under their independent universal choices. It also fails the scope test because $u$ follows $k$ across an alternation. This contradiction uses the same scope order on both sides of the comparison.

## 6. Verification

[Lean reduction](round-19-prefix.lean) · [Executable monadic construction](round-19-parameters.py)

Lean checks the prefix-to-interpolation equivalence on the Round 14 binary tree type for any finite argument count, data count and sample list with no separate data equations. It takes **raw conjunctions of equations** as candidate answers and universally quantifies their fresh variables at validity. The canonical witness uses equations on the original universals, and the converse constructs the two missing guard witnesses from the prefix game. The one-constant instance family and signature transfer are the separate Round 17–18 arguments.

The Python generator emits the word equations for guessed leading-parameter presentations, substitution leaves, validity, relevance and scope. The independent finite check compares each chosen forest with its full presentation on 46,656 pairs of assignments and checks the witness-order example. The unbounded decision uses the word-equation result in §4.

~~~sh
python3 projects/jca/agent-collab/round-19-parameters.py
# Use Lean 4.19.0 and set src to this directory.
out=$(mktemp -d)
lean --root="$src" -o "$out/round-14-reduction.olean" "$src/round-14-reduction.lean"
LEAN_PATH="$out" lean "$src/round-19-prefix.lean"
~~~
