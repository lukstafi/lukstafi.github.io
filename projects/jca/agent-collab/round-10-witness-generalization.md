---
title: "JCA Existence over T(F), Round 10: Witness Generalization and the Remaining Decision Problem"
date: 2026-09-05
---

# JCA Existence over $\mathcal T(\mathcal F)$, Round 10: Witness Generalization and the Remaining Decision Problem

*Author: Codex. Research attempt requested by Łukasz Stafiniak, following the reactions added to [round 9](round-9-subsumption-bottleneck.html). This note proves the explicitly stated lemmas below, but does not settle unrestricted JCA or JCAQP existence. The accompanying [experiments](round-10-experiments.py) check examples and finite instances; they are not a formal verification of the general proofs. No priority claim is made for the anti-unification consequences.*

## 1. Outcome and scope

The main result of this attempt is an exact alternative formulation of **ordinary equational JCA existence**: choose one ground solution of each branch's premise and conclusion, compute their simultaneous least general generalization, and test that generalization as an answer. If an answer exists, some such choice succeeds (Theorem 4.2). The number of witnesses is exactly the number of branches. Their sizes remain unbounded.

This yields a decision procedure when each branch's premise and conclusion together determine all instance variables to ground terms (Theorem 5.1). It also gives a different complete positive semialgorithm for unrestricted JCA and a precise missing lemma for a decision procedure: a computable bound on the sizes of a successful set of witnesses.

The undecidability attempt through SUBSUME does not close. Besides the parameter-semantic discrepancy, there are two concrete problems with round 9's proposed implementation: shared-variable subsumption need not imply unifiability, and putting the comparison equation inside the answer identifies the represented terms before the proposed check can compare them. Neither observation proves SUBSUME inexpressible.

I focus the main proof on ordinary JCA because it is a common, unambiguous core of the variants under discussion. I do not silently transfer the witness theorem to answers subject to universal quantification or syntactic scope restrictions.

## 2. Specify the problem before trying to decide it

### 2.1 The common equational core

Fix, once and for all, the finite signature $\mathcal F=\{f/2,a/0,b/0\}$ and the algebra of **finite ground terms** over it, with syntactic equality. In particular $a\ne b$. The signature does not grow with the input, and rational/infinite trees are not allowed.

An instance $I$ consists of finitely many branches $(D_i,C_i)$, $1\le i\le m$, each a pair of finite conjunctions of equations. Let $X=(x_1,\ldots,x_n)$ list every variable occurring in the instance. We ask for a finite conjunction $A(X,B)$, with finitely many fresh variables $B$, such that

$$
\mathcal T(\mathcal F)\models
\forall X\,\forall B\;(D_i\land A\Rightarrow C_i),
\qquad
\mathcal T(\mathcal F)\models
\exists X\,\exists B\;(D_i\land A)
\quad\text{for every }i.
$$

Call this **JCA-EXIST**. No freshness restriction forbids $A$ from mentioning a variable merely because it first appeared in a premise. Fresh variables are existentially hidden when describing the answer's set of instance assignments:

$$S_A=\{\bar g\in\mathcal T(\mathcal F)^n:\exists B\;A(\bar g,B)\}.$$

Thus relevance means $S_A\cap S_{D_i}\subseteq S_{C_i}$ and consistency means $S_A\cap S_{D_i}\ne\varnothing$. This set formulation is legitimate because $B$ occurs in neither $D_i$ nor $C_i$.

If $m=0$, $\top$ is an answer; below assume $m\ge1$. An inconsistent $D_i$ makes the instance unsolvable under this definition. Dropping inconsistent branches, as a type-inference preprocessing policy might do, is a different input convention and must be stated separately.

### 2.2 Prefix variants are not interchangeable

The [extracted §4.2](../thesis_section_4_2.md) and [original TeXmacs source](../lukstafi-phd-thesis.tm), §4.2.1, disagree on two material details. In the original notation, validity substitutes the fresh answer parameters $\bar\alpha$ as well as $\bar\beta$, and its unification construction puts the substituted variables into a final existential block. The extraction leaves fresh parameters unsubstituted. The no-escaping order is also $\le_Q$ in the original versus $\not\le_Q$ in the extraction. See the reactions in round 9 §6. We should preserve the author's later intended semantics without calling it a literal transcription of the older source.

For a precise **parameter-free prefix variant** of this note, take $X=U\mathbin{\dot\cup}E$, a prefix $Q$ on $X$, and impose, in addition to §2.1,

$$\mathcal T(\mathcal F)\models\forall B\;Q:A.$$

Here there are no designated invariant parameters $\chi$ or prior parameters $\delta$, so the corresponding no-escaping clauses have no atoms to inspect. This is a specified mathematical problem, not a claim that the full implementation has this exact interface. In particular, it has no unspecified meta-level substitution convention.

Ordinary JCA embeds in this variant by using $Q=\exists X$. Lemma 4.1 gives a pattern answer $X=p(B)$, and $\forall B\exists X:X=p(B)$ is true. Conversely every answer to the prefix variant satisfies ordinary relevance and consistency. Hence ordinary JCA is a genuine lower-bound target for this variant.

To add invariant parameters, a problem specification must also say exactly which variables may be replaced in validity, which variables may occur in their replacement terms, and whether weak or strong no-escaping is required. A meta-level choice of the syntactic term $f(u,u)$ is compatible with its occurrence under $\forall u$; “choose the term first” does not mean “choose a ground value independent of $u$.”

### 2.3 A dependency-tree formulation

For a tree-scoped analogue, record the universal variables $U$, existential variables $E$, and an allowed dependency set $\operatorname{Dep}(e)\subseteq U$ for each $e\in E$. A concrete **term-witness** validity condition is: there exist finite terms

$$w_e\in\mathcal T(\mathcal F,B\cup\operatorname{Dep}(e))\quad(e\in E)$$

such that $A[E:=w]$ is a syntactic identity under universally variable $U\cup B$. For linear prefixes, let $\operatorname{Dep}(e)$ contain precisely the preceding universals. This makes the permitted witnesses explicit; it is not a quantification over arbitrary semantic functions.

Dependencies from different subtrees must remain distinguishable. For example, independent scopes can give $\operatorname{Dep}(e)=\{u\}$ and $\operatorname{Dep}(d)=\{v\}$. No single linear prefix realizes exactly those two sets: it would require both $u<e<v$ and $v<d<u$. An implementation can retain a linear comparison for some operations while also retaining ancestry for others.

This is what the inspected implementation suggests: `~/invargent/src/Infer.ml:1251` builds `cmp_v` and `upward_of`; `src/Terms.ml:1445` checks quantifier violations; `src/Invariants.ml:1198` selects parameters using ancestry. These are code observations, not a proof that the proposed dependency-set semantics exactly matches every code path. In particular, scope FIXME comments remain in the implementation.

## 3. Trying the subsumption attack again

Semi-unification uses valuations applied homomorphically **once** to a term. A valuation may map $p$ to a term containing $p$; that is not an infinite-tree equation. This convention is explicit in Dudenhefner's Definitions 1–2 and Example 4. His restricted simple constraints retain undecidability. [Dudenhefner, FSCD 2020](https://www.ps.uni-saarland.de/Publications/documents/Dudenhefner_2020_Semi-unification.pdf)

### 3.1 Shared variables: a missing completeness condition

Take $s=p$ and $t=f(p,p)$. There is a matcher $\sigma(p)=f(p,p)$ with $s\sigma=t$. But $s\doteq t$ has no finite-tree unifier. The idempotent answer substitution $\theta(v)=p$, $\theta(u)=f(p,p)$ realizes these images without an occurs violation in the answer itself.

Therefore round 9's consistency probe $D=(v\doteq u)$, $C=\top$ can reject a genuine subsumption pair. The familiar freezing test is correct after separating the roles of the pattern variables from target variables. For example, rename the pattern to $p'$ and freeze the target's $p$; then match $p'$ against $f(\widehat p,\widehat p)$. A fixed gadget must somehow perform the equivalent of that separation on the variables of an answer-chosen term. Naming finitely many fresh instance variables does not already accomplish it for arbitrary answers.

### 3.2 Linkage equations erase the distinction they were meant to test

**Proposition 3.1.** If a satisfiable equational answer $A$ entails $u\doteq v$ and $\theta=\operatorname{mgu}(A)$, then $\theta(u)=\theta(v)$ syntactically.

*Proof.* An mgu equalizes every equation entailed by its solved constraint. Alternatively, if the images differed, a ground substitution separating them would give a model of $A$ falsifying $u=v$. $\square$

In particular, the atoms

$$u\doteq t(B),\qquad v\doteq s(E),\qquad u\doteq v$$

may cause a prefix check to solve $s(E)=t(B)$, but after normalizing $A$ the port images are identical. They do not present two preserved images $\theta(v)$ and $\theta(u)$ between which a nontrivial matching relation is tested. A reduction could introduce separate representation and checking ports, but must then prove faithful copying and separation rather than assuming them.

**Result of this attack.** The logical shape $\forall\exists(s=t)$ is not enough. The reduction needs a representation theorem: two terms survive as independently represented terms, the pattern variables have independent matching copies, and the test cannot alter the target. I have not constructed such a gadget. Proposition 3.1 rules out this particular in-answer linkage construction; it does not rule out gadgets using branch premises, scoped copies, or another representation.

## 4. A different attack: one witness per branch

### 4.1 Pattern answers

A tuple pattern $p=(p_1,\ldots,p_n)$ has terms over $\mathcal F$ and fresh variables $B$, with no variables from $X$. Its instances are

$$\operatorname{Inst}(p)=\{p\rho:\rho:B\to\mathcal T(\mathcal F)\}.$$

It presents the answer $A_p=\bigwedge_j x_j\doteq p_j$. Tuple notation is meta-notation; it does not extend the fixed signature. Variable sharing across coordinates is essential.

**Lemma 4.1 (projection to a pattern).** Every ordinary JCA answer has the same set $S_A$ as a pattern answer $A_p$.

*Proof.* Consistency of at least one branch makes $A$ satisfiable. Compute an idempotent mgu $\mu$ of $A$ and form $(\mu(x_1),\ldots,\mu(x_n))$. Rename all residual variables appearing in that tuple to distinct fresh variables, preserving their sharing. Ground instances of this tuple are exactly the restrictions to $X$ of ground solutions of $A$. Residual variables not appearing in the tuple can be grounded arbitrarily to extend any such instance to a solution of $A$. Since the input branches use only $X$, relevance and consistency depend only on this projection. $\square$

This is existential projection of an ordinary answer. It is not a claim that replacing original universal variables with new answer parameters preserves prefix validity.

### 4.2 Simultaneous least general generalization

Given ground tuples $g_1,\ldots,g_m$ of the same length, define $h=\operatorname{lgg}(g_1,\ldots,g_m)$ simultaneously across **all coordinates**:

1. If the $m$ terms at a position have the same root constructor, retain it and recurse on corresponding children.
2. Otherwise replace the ordered vector of those $m$ subterms by a fresh variable. Reuse that variable whenever exactly the same vector appears anywhere else in the tuples.

Each $g_i$ is an instance of $h$. Moreover, if every $g_i$ is an instance of a pattern $p$, then $h$ is an instance of $p$. This is the usual least-general-generalization property: for each repeated variable of $p$, all of its positions receive the same vector of witness terms and hence the same generalized term; constructors of $p$ occur in every witness and are retained. The argument applies to any finite number of witnesses and to tuples using one shared memo table. For the classical construction and terminology see [Plotkin, *A Further Note on Inductive Generalization*](https://homepages.inf.ed.ac.uk/gdp/publications/MI6_further_note.pdf).

### 4.3 Exact witness theorem

**Theorem 4.2 (finite witness hull).** An ordinary JCA instance with $m\ge1$ has an answer iff there are ground tuples $g_i$ satisfying $D_i\land C_i$, one for each branch, such that $A_h$ is an answer, where

$$h=\operatorname{lgg}(g_1,\ldots,g_m).$$

More strongly: given any pattern answer $A_p$, choosing any $g_i\in\operatorname{Inst}(p)\cap S_{D_i}$ produces such an answer $A_h$ with $\operatorname{Inst}(h)\subseteq\operatorname{Inst}(p)$.

*Proof.* Given an answer, use Lemma 4.1 to obtain $p$. Consistency supplies a ground $g_i$ in each indicated intersection. Relevance makes $C_i(g_i)$ true. Since $p$ generalizes every $g_i$, the lgg property gives $h=p\sigma$ for some substitution $\sigma$, hence $\operatorname{Inst}(h)\subseteq\operatorname{Inst}(p)$. This inclusion preserves relevance: every instance of $h$ satisfying $D_i$ is an instance of $p$ satisfying $D_i$, so satisfies $C_i$. Consistency is preserved because the particular $g_i$ remains an instance of $h$. The reverse direction is immediate: an accepted $A_h$ is an answer. $\square$

The theorem exploits a useful asymmetry. Strengthening can normally destroy consistency, but here an explicitly retained witness for every branch prevents that. It need not preserve maximal generality, and none is required for existence.

### 4.4 Exact synthesis formulation and positive semialgorithm

Write $S_i=S_{D_i\land C_i}$. The decision problem is exactly

$$
\exists(g_1,\ldots,g_m)\in\prod_i S_i:\quad
\forall i\;
\operatorname{Inst}(\operatorname{lgg}(g_1,\ldots,g_m))\cap S_{D_i}
\subseteq S_{C_i}.
$$

Consistency need not be checked again in this formula: $g_i$ is its certificate. Crucially, it is **not** enough that $S_i$ is nonempty for every $i$.

A complete positive semialgorithm follows:

```
Reject if some D_i and C_i together are not unifiable.
For total ground-witness size N = 0, 1, 2, ...:
    Enumerate all m-tuples of ground assignments of total size N.
    Retain choices g_i satisfying D_i and C_i for every i.
    h := simultaneous lgg(g_1, ..., g_m)
    Accept with answer X = h if every D_i and X = h entails C_i.
```

Each size level is finite over the fixed signature. Unification and equalization decide the tests. Theorem 4.2 gives termination on every solvable instance; it gives **no termination guarantee on unsolvable instances**. Direct answer enumeration already showed recursive enumerability in round 8. The contribution here is the witness normalization and the restricted decision procedure it supports, not a new computability upper bound.

## 5. A fragment where the attempt does terminate

**Theorem 5.1 (ground-determined branch solutions).** Suppose that for each $i$, either $D_i\land C_i$ is inconsistent, or its mgu maps every variable in $X$ to a ground term. Then JCA-EXIST is decidable:

1. Reject if some $D_i\land C_i$ is inconsistent.
2. Otherwise let $g_i$ be its unique ground tuple on $X$.
3. Compute $h=\operatorname{lgg}(g_1,\ldots,g_m)$ and accept iff $A_h$ passes every branch.

*Proof.* The syntactic hypothesis is decidable by unification. In the consistent case each $S_i$ is the singleton $\{g_i\}$. Thus Theorem 4.2 has exactly one possible witness choice. If the test fails, no answer exists; if it passes, it supplies an answer. $\square$

Use a shared DAG if desired; no polynomial tree-size bound is asserted, because expanding unification substitutions can be expensive.

For a positive example on $X=(x,y)$, take

$$D_1=(x=a),\ C_1=(y=a),\qquad
D_2=(x=b),\ C_2=(y=b).$$

The witnesses $(a,a)$ and $(b,b)$ have lgg $(p,p)$, giving $\exists p:(x=p\land y=p)$, equivalently $x=y$. There is no single ground answer consistent with both premises; the pattern is necessary.

For a negative example take two empty premises with conclusions $x=a$ and $x=b$. The unique witnesses are $a,b$, their lgg is a variable, and it entails neither conclusion. The algorithm correctly rejects. Both individual branches are solvable, so this is a jointness test, not merely an inconsistency check.

As another complete special case, one branch has an answer iff $D_1\land C_1$ is satisfiable: choose a ground solution as the answer. This observation is about ordinary existence without restrictions on answer variables, not about maximal answers or prefix validity.

## 6. Trying to extend the decision procedure

### 6.1 Fixed default witnesses do not suffice

One tempting algorithm is to compute $\operatorname{mgu}(D_i\land C_i)$ and ground every remaining variable to $a$. It fails even on this small solvable instance, with $X=(x,y,z)$:

$$D_1=(x=a),\ C_1=(y=b),\qquad
D_2=(x=b),\ C_2=(z=b).$$

Default grounding gives $g_1=(a,b,a)$ and $g_2=(b,a,b)$. Their simultaneous lgg is $(p,q,p)$. Under $D_1$, $p=a$ leaves $q$ unconstrained, so $y=b$ is not entailed. Yet $A=(y=b\land z=b)$ is an answer. Witnesses $(a,b,b)$ and $(b,b,b)$ recover it via lgg $(p,b,b)$.

Thus the witnesses must be chosen *jointly*. Computing one arbitrary representative of each branch solution set is not a decision procedure. This example also explains why strengthening to ground witnesses before coordinating branches can discard the useful sharing pattern.

### 6.2 Two witnesses do not bound the number of lgg variables

For $j=1,\ldots,N$, choose pairwise distinct ground terms $t_j$ and form right-associated $f$-lists, terminated by $a$, whose corresponding elements are

$$\text{first list: }a,a,\ldots,a,
\qquad
\text{second list: }f(t_1,a),f(t_2,a),\ldots,f(t_N,a).$$

At element $j$ the root mismatch produces a variable indexed by $(a,f(t_j,a))$. These vectors are all distinct, so the lgg has $N$ distinct variables. This refutes a bound depending only on the **number of samples**. It does not refute a computable bound on some successful witnesses for each input: the exhibited large samples might be unnecessary for that input.

### 6.3 Naive finite-state abstraction loses sharing

Suppose a candidate finite-state search summarizes disagreement vectors only by root symbols. It will merge $(a,f(a,a))$ and $(a,f(b,a))$, creating repeated-variable constraints that the lgg did not have. Conversely, allocating a different variable at every disagreement occurrence loses necessary equality information when a vector repeats. For example, lgg of $(a,a)$ and $(b,b)$ is $(p,p)$, not $(p,q)$; replacing it by the latter loses the answer $x=y$ from §5.

This exposes the missing information in a simple tree-automaton approach: equality of whole witness-subterm vectors at distant positions. It is not a proof against richer automata with equality constraints or a more careful finite quotient. I have not supplied such a quotient or an emptiness algorithm for it.

### 6.4 The exact missing boundedness statement

**Question 6.1.** Is there a total computable function $W$ such that every solvable instance $I$ has a successful witness family from Theorem 4.2 of total ground-tree size at most $W(|I|)$?

For this fixed signature, a positive answer is **equivalent** to decidability of ordinary JCA:

- Given $W$, exhaust the finite witness search through that bound and reject if it finds no answer.
- Given a decider, enumerate the finitely many instance encodings of length at most $n$. For each solvable one, run the positive witness search until it succeeds, and take the maximum resulting size (or zero if none is solvable). This computes a suitable $W(n)$.

Thus “there should be a finite witness bound” is not independent evidence for decidability; proving a computable bound would be the main theorem. The one-witness-per-branch result bounds the number of samples, not their size, and does not evade round 8's warning about circular bounded-answer arguments.

## 7. Why prefix validity needs a different witness theorem

Even without designated invariant parameters, the strengthening step in Theorem 4.2 need not preserve $\forall B\,Q:A$. Consider $Q=\forall u\exists x$ and a single branch $\top\Rightarrow\top$. The answer $\top$ is valid. A ground witness $(u,x)=(a,a)$ has a one-sample lgg equal to that ground tuple; the resulting answer $u=a\land x=a$ is not valid under $Q$.

This is a counterexample to transferring the **construction**, not to existence in this instance. The prefix problem still has the original answer. One would need witnesses that leave $U$ symbolic and preserve uniform dependence across all universal assignments, together with a replacement for the least-general-generalization argument. For tree scopes, each existential witness must additionally respect its particular dependency set.

There is a second complication when no-escaping is present: its definition inspects individual atoms, so arbitrary normalization into an equivalent conjunction is not automatically admissibility-preserving. Ordinary JCA's solution-set proof is deliberately not used to bypass that check.

## 8. What has and has not been solved

The results defended here are the projection lemma, the finite witness hull theorem, and the decision procedure for ground-determined branch solutions. The subsumption and default-witness counterexamples are explicit finite refutations of particular constructions. The general fixed-signature JCA problem remains unresolved by this attempt, as do the specified prefix variant and any fully specified invariant-parameter/tree-scoped extension. A literature check supplied the cited standard tools and semi-unification result; it is not a claim of an exhaustive current-status survey.

The next decisive task on the decidability route is to represent the successful witness families of §4.4 with a structure whose emptiness is decidable, preserving repeated-subterm-vector equality. On the undecidability route it is to construct a representation-preserving comparison between two answer-chosen terms, with separate matching variables, before relying on the quantifier shape of a check. The source-semantic reconciliation is necessary for the prefix route but does not resolve either ordinary-JCA task.

## 9. Executable checks and provenance

Run `python3 projects/jca/agent-collab/round-10-experiments.py` from the repository root. It checks Example 4.3's counterexample, the shared-variable matching failure, the linkage collapse, both examples for Theorem 5.1, the default-witness failure, unbounded lgg-variable counts for two samples, and finite generated cases of the witness theorem. Matching applies a substitution once; unification recursively resolves acyclic bindings. These must not be conflated.

The experiments are limited to ordinary finite-term JCA. They do not implement the thesis's prefix checks or certify the whole InvarGenT implementation. All author-question reactions are based on the local source and code inspection; the research results above are this note's own arguments.

Recorded run: all named checks passed; 2,401 equality-only instances supplied 2,095 accepted-answer witness-hull checks and 1,633 fragment decisions agreeing with bounded pattern search. An additional 45 cases checked nested constructors and repeated variables. These finite checks support implementation confidence, while the proofs carry the unbounded claims.
