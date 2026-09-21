---
title: "JCA Existence over T(F), Round 11: Witness Bounds and a Constant-Test Fragment"
date: 2026-09-21
---

# JCA Existence over $\mathcal T(\mathcal F)$, Round 11: Witness Bounds and a Constant-Test Fragment

*Author: Codex, with parallel research and independent proof review by Codex subagents. This note records a twenty-minute investigation following [Round 10](round-10-witness-generalization.html). The results concern ordinary finite-term JCA only. The proofs below are mathematical arguments, not machine-checked formal proofs; the [executable checks](round-11-experiments.py) are finite tests. No priority claim or comprehensive literature-status claim is made.*

## 1. What this attempt establishes

The main result is that ordinary JCA with **constant-test premises and constructor-free conclusions is NP-complete**. If an answer exists, there are successful witnesses using only $a$ and $b$, giving the upper bound. A direct graph-colouring reduction gives the matching lower bound, and therefore an NP-hardness lower bound for unrestricted ordinary JCA as well.

The boundary is substantive. Allowing a single variable-equality premise can require constructors in every answer, already with two branches and no constructors anywhere in the input. With more branches, constructor-free inputs can force unbounded tuple-pattern answer and witness depth.

Three further observations constrain the next search:

- Depth-one input is a normal form of unrestricted ordinary JCA, by a branch-count-preserving flattening transformation. Shallow syntax alone does not give an easier fragment.
- In an explicit two-branch family, the minimum witness depths needed jointly add, rather than taking the maximum of the depths needed separately.
- Expanded ground-tree witnesses can have exponential size even when the empty answer works. Tree size, shared-DAG size, answer size, and depth must be kept separate.

None of these results decides unrestricted JCA, unrestricted two-branch JCA, or the prefix variants.

## 2. Setting and the witness criterion

Use precisely [Round 10, §2.1](round-10-witness-generalization.html#the-common-equational-core): the fixed signature is $\mathcal F=\{f/2,a/0,b/0\}$, terms are finite, and equality is syntactic equality in its ground term algebra. There are $m\ge1$ branches $(D_i,C_i)$, and $X=(x_1,\ldots,x_n)$ lists the instance variables. An equational answer $A(X,B)$ may use fresh parameters $B$. For each branch it must satisfy

$$D_i\land A\models C_i,\qquad D_i\land A\text{ is satisfiable}.$$

Entailment here universally closes free variables. Fresh answer variables are existentially hidden when projecting the answer's solution set onto $X$.

By Round 10's projection lemma, an answer can be represented as a tuple pattern $P=(P_1,\ldots,P_n)$ with fresh variables only, presenting $X=P$. By its witness-hull theorem, answer existence is equivalent to the existence of ground tuples $g_i\models D_i\land C_i$ whose simultaneous least general generalization $H=\operatorname{lgg}(g_1,\ldots,g_m)$ is an answer. Generalization uses **one shared disagreement-vector table across all coordinates**.

Depth is the number of constructor edges on a longest path, with variables and constants at depth zero. Tree size counts every occurrence, including repeated occurrences and repeated tuple coordinates.

## 3. A decidable constant-test fragment

**Theorem 3.1.** Suppose every premise is a conjunction of tests $x=a$ or $x=b$, and every conclusion is a conjunction of equations between instance variables and the constants $a,b$. Then:

1. If an answer exists, a constructor-free tuple-pattern answer exists.
2. If an answer exists, a successful witness family exists with every coordinate in $\{a,b\}$, of total tree size $mn$.
3. Existence is decidable by enumerating these finite witness families. The fragment has an NP upper bound.

Empty premises and conclusions are allowed. Inconsistent premises are rejected under the ordinary consistency requirement.

*Proof of (1).* Let $P$ be any pattern answer. If a coordinate $P_x$ is tested against a constant in any premise, consistency forces it to be either a constant or a single parameter: an $f$-headed term cannot unify with $a$ or $b$. Therefore, after substituting $P$ into any premise, its consistent mgu $\nu_i$ only binds parameters to $a$ or $b$. It introduces no constructors and does not identify two still-unbound parameters.

Construct $Q$ by replacing **each $f$-headed coordinate** of $P$ by $a$, leaving all variable and constant coordinates unchanged. No tested coordinate changes, so every substituted premise and its mgu are unchanged. In particular, consistency is preserved.

Consider a conclusion equation. If neither side was an $f$-headed coordinate, the substituted equation and its image under $\nu_i$ are unchanged, hence remain equal. If both sides were $f$-headed coordinates, the new equation is $a=a$. The remaining case, one $f$-headed side and one simple side, could not have been entailed by the original answer: under $\nu_i$ the first side remains $f$-headed, while the second remains a parameter or a constant. This exhausts the constructor-free conclusion syntax. Thus $Q$ is an answer. $\square$

*Proof of (2).* For each branch, choose a solution of $Q\land D_i$ by retaining its forced constant bindings and setting every remaining parameter to $a$. Each resulting tuple $g_i$ belongs to $\{a,b\}^n$. Round 10's witness-hull theorem makes their simultaneous lgg an answer. There are $mn$ constant coordinates, each of tree size one. $\square$

*Algorithm and (3).* Reject a branch whose premise and conclusion together are inconsistent. Enumerate the at most $2^{mn}$ binary witness families, discard those that do not satisfy their respective $D_i\land C_i$, compute each simultaneous lgg, and test answerhood by unification and equalization. Accept a passing hull; reject after exhaustion. Completeness follows from (2). For the NP upper bound, guess the $mn$ bits of a witness family. Its lgg is a flat tuple of at most $n$ coordinates, and all checks take polynomial time. No optimal running-time claim is made. $\square$

### 3.1 Matching lower bound

**Theorem 3.2.** The fragment of Theorem 3.1 is NP-complete. Consequently unrestricted ordinary JCA existence is NP-hard.

*Proof.* Membership was proved above. For hardness, reduce graph 3-colourability, using its standard NP-completeness ([Garey, Johnson, and Stockmeyer, 1976](https://doi.org/10.1016/0304-3975%2876%2990059-1)). Given a finite undirected graph $(V,E)$, introduce variables $c_1,c_2,c_3$ and $x_v$ for every vertex. Construct

$$B_0:\quad c_1=a\land c_2=a\land c_3=a
\ \Rightarrow\ \bigwedge_{v\in V}x_v=a,$$
$$B_1:\quad \bigwedge_{v\in V}x_v=b\ \Rightarrow\ \top,$$
$$B_{uv}:\quad x_u=a\land x_v=b\ \Rightarrow\ \top
\quad(\{u,v\}\in E),$$

choosing either orientation of each edge. The construction has $O(|V|+|E|)$ structural size and meets the fragment's restrictions.

Given a proper colouring $\chi:V\to\{1,2,3\}$, use fresh distinct parameters $p_1,p_2,p_3$ and the flat answer $c_j=p_j$, $x_v=p_{\chi(v)}$. The main premise sets all three parameters to $a$. The variation guard $B_1$ sets every used parameter to $b$. Each edge guard consistently assigns $a,b$ to two different parameters. All branches pass.

Conversely, normalize any answer, including one originally containing constructors, to a tuple pattern $P$. The main branch requires each vertex coordinate to have an instance $a$, and the variation guard requires an instance $b$. Thus $P_{x_v}$ is a parameter $q_v$. Main-premise consistency makes each $P_{c_j}$ either $a$ or a parameter. Substituting the main premise into $P$ therefore binds at most three distinct parameters to $a$. Relevance forces each $q_v$ to be one of those parameters, since otherwise it remains free. Every edge guard requires $q_u\ne q_v$ syntactically, or its premise would require the same parameter to equal both $a$ and $b$. The at most three parameter classes give a proper colouring. $\square$

One can replace $B_1$ by a separate branch $x_v=b\Rightarrow\top$ for each vertex. Then every premise has at most three atoms, with the same proof. This is an explicit reduction, not a claim that the complexity classification is new in the literature.

This supplies the warm-up hardness result sought in [Round 8, §9](round-8-reassessment.html#next-steps). It also corrects the suggestion in that round's §6 that hardness must essentially use back-propagation depth: this reduction uses only parameter aliasing and constant tests. Unbounded constructor structure is not needed for NP-hardness.

The witness-bound proof relies on **constant tests**, not merely constructor-free premises. The next example pinpoints the difference.

## 4. Two constructor-free branches can require a constructor answer

Use $X=(x,y,u,v)$ and

$$D_0=(x=y),\quad C_0=(u=a\land v=b),$$
$$D_1=(u=b\land v=a),\quad C_1=\top.$$

**Proposition 4.1.** This instance has an answer, but no constructor-free answer. Its minimum successful witness depth is exactly one, and its minimum total witness tree size is exactly $16$.

*Existence.* With fresh $p,q$, take

$$P=(f(p,q),\ f(a,b),\ p,\ q).$$

In branch 0 the premise decomposes into $p=a,q=b$, giving the conclusion and a consistency witness. Branch 1 is consistent at $p=b,q=a$ and has no conclusion to check.

*Impossibility of a flat answer.* In any constructor-free tuple-pattern answer $Q$, the coordinates for $u,v$ must each admit both $a$ and $b$: branch 0 requires values $(a,b)$ and branch 1 requires $(b,a)$. They must therefore be two distinct parameters $r,s$. The only additional equation in branch 0 is $Q_x=Q_y$, with each side a constant or a single parameter. A consistent such equation does nothing, identifies two parameters, or binds one parameter to one constant. It cannot force both distinct parameters to the distinct constants $r=a,s=b$. Hence relevance fails. A constructor-free equational answer also normalizes to a constructor-free tuple pattern, so fresh variables or a different equational presentation do not evade the argument.

*Witness depth.* A successful family with depth zero would have a flat lgg, which was just excluded. The depth-one witnesses

$$g_0=(f(a,b),f(a,b),a,b),\qquad
g_1=(f(b,a),f(a,b),b,a)$$

have lgg $P$, proving the upper bound. Their total tree size is $16$. For the matching size lower bound, the $u,v$ coordinates of every answer hull are parameters, as above. If at most one of its $x,y$ coordinates were compound, Lemma A.1 below would turn it into a flat answer, a contradiction. Thus both are compound, and the $x,y$ coordinates in both witnesses have constructor roots and size at least three. Their four terms contribute at least $12$ nodes, while the four $u,v$ values contribute four more. $\square$

The executable checks exhaust all eight binary witness pairs satisfying the two branch premise/conclusion conjunctions, and all $6^4=1,296$ flat tuples over $a,b$ and four parameter names. All fail; the constructor answer passes. The proof, rather than this finite enumeration, explains why the candidate set covers all flat answers.

## 5. Constructor-free inputs can force arbitrarily deep tuple-pattern answers

The preceding example is not an unbounded-depth result with two branches. The following family obtains unbounded depth by increasing both the branch count and the number of variables.

Fix $r\ge2$, put $k=2^r-1$, and index variables $u_s$ by the nonzero vectors $s\in\{0,1\}^r$. There are also variables $x,y$. Let $c(0)=a,c(1)=b$. Use the branches

$$B_0:\quad x=y\ \Rightarrow\ \bigwedge_{s\ne0}u_s=a,$$
$$G_j:\quad \bigwedge_{s\ne0}u_s=c(s_j)\ \Rightarrow\ \top
\quad(1\le j\le r).$$

**Proposition 5.1.** This instance is solvable. Every tuple-pattern answer, and every successful witness family, has maximum coordinate depth at least $r-1$. An answer and witnesses of depth at most $r$ exist.

*Lower bound.* In any answer pattern $P$, the coordinate for $u_s$ has an instance $a$ by relevance and consistency at $B_0$, and an instance $b$ by a guard at a nonzero bit of $s$. Thus $P_{u_s}$ is a parameter $p_s$. Distinct bit vectors are separated by a guard, so these parameters are pairwise distinct.

Every $p_s$ must occur in $P_x$ or $P_y$. Otherwise unifying $P_x=P_y$ leaves $p_s$ free, and a ground solution with $p_s=b$ contradicts $B_0$'s conclusion. Consequently the two binary terms $P_x,P_y$ together contain at least $k$ distinct variable leaves. If their depths are at most $d$, they have at most $2^{d+1}$ leaves, so

$$d\ge\lceil\log_2 k\rceil-1=r-1.$$

The lgg of a successful witness family is an answer and cannot be deeper than its deepest input coordinate, proving the witness lower bound.

*Upper bound.* Choose a balanced binary $f$-tree $T$ with $k$ leaves. Set $P_x=T((p_s)_s)$, $P_y=T((a)_s)$, and $P_{u_s}=p_s$. The central premise forces all parameters to $a$; every guard has its specified parameter assignment as a consistency witness. The tree has depth $\lceil\log_2 k\rceil=r$. Choosing those assignments gives witnesses with the same depth bound. $\square$

This rules out a witness-depth bound depending **only on input-term depth**, even when that depth is zero. It does not challenge a computable bound depending on the whole input size. The answer-depth claim concerns normalized tuple patterns: a general equational answer can name subterms with fresh auxiliary variables and use depth-one equations to describe a deep pattern.

## 6. Shallow syntax is a normal form, not a restricted fragment

**Proposition 6.1 (flattening).** Any ordinary JCA instance can be transformed effectively into an equisolvable instance with all input terms of depth at most one, preserving the number of branches and the fixed signature. Structural output size is $O(m|I|)$, hence polynomial and linear for fixed branch count, up to variable-name encoding.

*Construction.* Introduce a fresh variable $y_t$ for each distinct compound subterm $t=f(s,u)$ appearing anywhere in the instance. Write $\operatorname{rep}(x)=x$, $\operatorname{rep}(a)=a$, $\operatorname{rep}(b)=b$, and $\operatorname{rep}(t)=y_t$ for compound $t$. Form the common acyclic definitions

$$G(X,Y)=\bigwedge_{t=f(s,u)}y_t=f(\operatorname{rep}(s),\operatorname{rep}(u)).$$

Replace each original atom $s=t$ by $\operatorname{rep}(s)=\operatorname{rep}(t)$, writing $E^{\mathrm{flat}}$ for this transformation. Replace each branch by

$$(G\land D_i^{\mathrm{flat}},\ C_i^{\mathrm{flat}}).$$

The **whole common $G$ is included in every premise**, including definitions originating in other branches or in conclusions.

*Proof.* Every ground assignment to $X$ has a unique extension to $Y$ satisfying $G$, given by $y_t=t[X]$. Under $G$, an original equation and its flattened version are equivalent. An original answer therefore answers the flattened instance unchanged, with consistency witnesses extended by these definitions.

Conversely, if $A'(X,Y,B)$ answers the flattened instance, take

$$A(X,Y,B)=G(X,Y)\land A'(X,Y,B)$$

as an answer to the original instance, now treating $Y\cup B$ as fresh answer variables. Its branch consistency witnesses are supplied by the transformed branches. Under $D_i\land A$, the definitions give $D_i^{\mathrm{flat}}$, transformed relevance gives $C_i^{\mathrm{flat}}$, and the definitions give $C_i$. Thus arbitrary answer references to auxiliary variables are accounted for; one must not simply erase them. Counting definitions and their copies proves the size bound. $\square$

**Witness correspondence.** Functional extension commutes with simultaneous lgg. If $H=\operatorname{lgg}(g_1,\ldots,g_m)$, then for every original term $t(X)$,

$$\operatorname{lgg}(t[g_1],\ldots,t[g_m])=t[H],$$

where all coordinates use the same memo table. Induct on $t$: constructors are common roots and are retained; variable occurrences reuse the generalized coordinate. Thus the lgg of the extended tuples is $(H,(t[H])_t)$, up to renaming, and entails $G$. Original successful witness families correspond exactly to successful extended families.

In particular, a computable bound for all shallow **two-branch** instances would decide unrestricted **two-branch** JCA. This reduction does not reduce an arbitrary number of branches to two.

## 7. Joint witness depths can add

Let $F(t)=f(a,t)$ and $K(t)=f(b,t)$. For $h,k\ge1$, take two variables $x,y$ and the branches

$$B_0:\quad y=F^h(x)\ \Rightarrow\ x=a,$$
$$B_1:\quad x=K^k(y)\ \Rightarrow\ \top.$$

**Proposition 7.1.** The separate branch solution sets have minimum maximum-coordinate depths $h$ and $k$, respectively. The minimum maximum-coordinate depth of a **successful joint witness family** is exactly $h+k$.

The first branch's premise and conclusion have the unique witness

$$g_0=(a,F^h(a)).$$

Every second-branch witness is $g_1=(K^k(t),t)$ for some ground term $t$. The separate minimum depths follow by taking $t=a$ in branch 1. We now analyze the simultaneous lgg of $g_0,g_1$.

Its $x$ coordinate is the disagreement parameter $p$ indexed by $(a,K^k(t))$. That parameter cannot occur in the $y$ coordinate: such an occurrence would require $K^k(t)$ to be a subterm of $t$, impossible by strict tree size.

If the right spine of $t$ stops after $j<h$ constructor nodes, let its terminal constant be $c$. At this position the $y$ lgg has the disagreement parameter indexed by $(F^{h-j}(a),c)$. This parameter, say $q$, occurs nowhere else: its first component is a unique nonconstant suffix of $F^h(a)$, whereas all earlier left-side disagreements and the $x$ coordinate have first component $a$.

The $y$ lgg consequently has $j$ retained $f$ nodes, with left children equal to $a$ or disagreement parameters, followed by $q$. Set $p=b$, every left-side disagreement parameter to $a$, and $q=F^{h-j}(b)$. This gives a ground instance satisfying the first premise and violating $x=a$. Thus a successful $t$ must have at least $h$ right-spine constructor nodes, in particular depth at least $h$. Then $K^k(t)$ has depth at least $h+k$.

The bound is attained by $t=F^h(a)$. The hull is $(p,F^h(a))$, an answer: the first premise forces $p=a$, and the second is consistent at $p=K^k(F^h(a))$. $\square$

**Exact success condition.** If the right spine has at least $h$ nodes, write

$$t=f(s_0,f(s_1,\ldots,f(s_{h-1},s_h)\ldots)).$$

The $y$ hull has these $h$ constructors. Its leaf at position $j$ is $a$ if $s_j=a$, and otherwise a parameter indexed by $(a,s_j)$, shared exactly when these subterms are equal. Under the first premise every left leaf becomes $a$, while $p$ equals the final leaf. Therefore the witnesses succeed exactly when

$$s_h=a\quad\text{or}\quad s_h\in\{s_0,\ldots,s_{h-1}\}.$$

This explains why successful witness choices need not be unique. For $h=k=1$, both $t=f(b,a)$ and $t=f(b,b)$ work; in the second case the $y$ hull is $f(q,q)$ and parameter sharing forces the result. A stronger uniqueness conjecture considered during this session was refuted by these examples.

## 8. Tree size can be exponential even for the empty answer

Define $T_0(c)=c$ and $T_{j+1}(c)=f(T_j(c),T_j(c))$. On $X=(x_0,\ldots,x_k)$, let

$$E_k=\bigwedge_{j=1}^k x_j=f(x_{j-1},x_{j-1}).$$

Use $(E_k\land x_0=a,\top)$ and $(E_k\land x_0=b,\top)$. The empty answer works. Nevertheless each branch has a unique ground witness, respectively $(T_j(a))_{j=0}^k$ and $(T_j(b))_{j=0}^k$. Since $|T_j(c)|=2^{j+1}-1$, every witness family has total expanded tree size

$$2\sum_{j=0}^k(2^{j+1}-1)=2^{k+3}-2k-6.$$

The input has $O(k)$ structural size, all terms have depth at most one, and the two witnesses have maximum depth $k$. Shared DAGs represent the tuples in $O(k)$ nodes. With ordinary binary variable-name encodings, input bit length is $O(k\log k)$; the witness trees are still superpolynomial in that length. This is a lower bound for expanded **witness trees**, not for answer size or DAG size.

## 9. Executable checks and remaining questions

Run the companion experiments from the repository root:

```bash
python3 projects/jca/agent-collab/round-11-experiments.py
```

The script exposes `bounded_search` for general instances and `constant_test_decide` for Theorem 3.1's fragment. The latter validates the fragment's syntax and enumerates canonical flat patterns, returning `NO` after complete exhaustion. An optional resource cap returns `UNKNOWN`. Successful decisions include binary witnesses and their verified hull. The generic bounded search also distinguishes a found answer, a proved negative case, and exhaustion of a search bound. Outside a fragment with a proved bound, exhaustion means **unknown**, not unsatisfiable.

Recorded checks for this session:

- All $1,296$ flat candidate tuples and eight binary witness families fail on §4's obstruction; a constructor answer succeeds.
- Nine choices $h,k\in\{1,2,3\}$ attain depth $h+k$, and all $138$ smaller witness families in their reduced searches fail.
- All $3,969$ specified two-variable constant-test instances agree between binary-witness search and $400$ constructor-pattern candidates. There are $1,280$ positive cases; $1,146$ accepted single-branch patterns retain validity under constructor-root collapse.
- The colouring reduction agrees with independent colouring enumeration on all $76$ labelled simple graphs with zero through four vertices. The comparison checks $21,132$ canonical flat patterns and verifies $75$ positive binary-witness certificates. The complete graph $K_4$ rejects all $17,007$ canonical patterns for its seven instance variables.
- Shallow chain cases $k=0,\ldots,8$ satisfy the exact expanded-tree and shared-DAG counts.
- All existing Round 10 checks still pass.

The separate three-variable profile check is reproducible with

```bash
python3 projects/jca/agent-collab/round-11-flat-profiles.py
python3 projects/jca/agent-collab/round-11-flat-profiles.py --random 10000 --depth 4
```

Its default run checks $27,000$ depth-one tuples, with $198$ distinct profiles, against all $37$ consistent flat premises and all $37$ canonical flat patterns. The displayed random run adds $10,000$ seeded depth-four cases, giving $205$ profiles in total. Both flat domination and the constructive normalization from Appendix B pass. These are finite implementation checks, not substitutes for the proofs. The [independent proof review](reviews/round-11-proof-review.html) records the mathematical audit and its scope.

The useful next mathematical target is a bound on shared witness structure for a fragment that permits variable-equality premises. Theorem 3.1 provides a baseline, Proposition 4.1 shows exactly what its proof loses, and Proposition 5.1 shows why preserving only input depth cannot repair it. The appendices give two further positive fragments. The general two-branch constructor-free fragment remains a candidate for a stronger result; no completeness bound for that entire fragment is established here.

This session stopped at its twenty-minute checkpoint. The unrestricted witness-size question from Round 10 remains unresolved.

## Appendix A. Constant coverage permits some variable-equality premises

All inputs in this appendix are constructor-free. Reject if any $S_i=D_i\land C_i$ is inconsistent. Call a variable **constant-covered** if some $S_i$ entails that variable equals $a$ or $b$, and let $U$ be the uncovered variables. This is decidable by unification of the flat input systems.

**Lemma A.1 (one compound term).** Let a tuple pattern $P$ have only variable and constant coordinates, except possibly for coordinates all equal to one $f$-headed term $t$. Replace those coordinates by the same fresh parameter $q$, giving a flat pattern $Q$. For every constructor-free premise $D$ consistent with $P$, $D$ remains consistent with $Q$, and $D\land P$ and $D\land Q$ entail exactly the same constructor-free equations on instance variables.

*Proof.* Solve the flat equation system $D[Q]$ by union-find, choosing $q$ as the representative of its class. Original consistency implies that this class contains no constant and that no class identifies $a,b$. Write $\delta$ for the resulting substitution, leaving parameters appearing only inside $t$ unchanged. Original consistency also implies that $\delta(t)$ does not contain $q$: restoring $q=\delta(t)$ would otherwise fail the finite-term occurs check. An mgu for $D[P]$ is obtained by composing $\delta$ with $q\mapsto\delta(t)$, then restricting to the original parameters. Since $\delta(t)$ is constructor-headed and every other flat-class representative is a parameter or constant, this restoration identifies no distinct flat-class representatives. Therefore two instance coordinates or constants are equalized exactly when they were already in the same flat class. $\square$

The consistency qualification matters: abstraction may make additional premises satisfiable, which is harmless when retaining the already-consistent branches of an answer.

**Theorem A.2.** If $|U|\le1$, answer existence is equivalent to existence of a flat answer and to existence of a successful binary witness family. Such witnesses have total size $mn$.

*Proof.* From any answer choose a successful witness family using Round 10. At a constant-covered coordinate, at least one witness has constant root, so its simultaneous lgg coordinate cannot be constructor-headed. At most one lgg coordinate can therefore be compound. Apply Lemma A.1 to obtain a flat answer. In each consistent flat answer/premise conjunction, ground free parameter classes to $a$ and retain classes fixed to $b$; these binary witnesses have a successful hull by Round 10. $\square$

The example of §4 has exactly two uncovered coordinates, $x,y$, so the threshold is sharp for this flat-answer completeness property. This does not imply undecidability when the threshold is exceeded. For two branches in the fragment, all binary witness hulls are tuples over $\{a,b,p,q\}$: the only disagreement columns are $(a,b)$ and $(b,a)$. Testing $4^n$ such tuples is sufficient.

## Appendix B. Four variables are necessary for the constructor obstruction

**Theorem B.1.** Every solvable constructor-free instance on at most three instance variables has a constructor-free answer, regardless of the number of branches. Thus the two-branch, four-variable example in §4 is minimal in both counts for requiring a constructor answer.

*Proof.* Pad a pattern answer to three coordinates if necessary. We construct a flat pattern passing every constructor-free branch passed by it. Classify by the number of constructor-headed coordinates.

- **Zero:** nothing to change.
- **One:** Lemma A.1 applies.
- **Three:** replace the tuple by $(s,s,s)$ for one fresh parameter. No premise consistent with the original pattern, or conclusion entailed under such a premise, can equate a coordinate to a constant. Every remaining atom is a coordinate equality or a true constant equality, and the replacement satisfies all of them.
- **Two:** write the tuple as $(P,Q,R)$ with $P,Q$ constructor-headed. If $R=c$ is a constant, use $(s,s,c)$: neither compound coordinate can be equated to a constant in a consistent premise or an entailed conclusion. It remains to treat $R=r$ a parameter.

In this last case, write the coordinates as $x,y,z$. Up to equivalence, the nontrivial consistent premises are $z=c$, $x=y$, $x=y\land z=c$, $x=z$, $y=z$, or $x=y=z$, with $c\in\{a,b\}$; the empty premise is also allowed. A premise equating a compound coordinate to a constant is inconsistent. Beyond the premise's own equalities, the only possible additional consequences are

1. $x=y$ without a premise, if $P=Q$ syntactically;
2. $x=y$ under $z=c$, if $P[r:=c]=Q[r:=c]$;
3. $z=c$ under $x=y$, if the mgu of $P=Q$ binds $r$ to $c$.

For completeness of this list, under $x=z$ consistency requires $r$ absent from $P$. If $Q$ contains $r$, then $Q[r:=P]$ contains $P$ properly and cannot equal $P$. If $Q$ does not contain $r$, it equals $P$ after substitution only when it already did. The case $y=z$ is symmetric. Under $x=y$, $r$ cannot equal the common compound term: if it occurs within $P$ or $Q$, its image is a proper subterm of that term; otherwise it remains free. Compound coordinates never become constants.

If $P=Q$ is inconsistent, or its mgu does not bind $r$ to a constant, replace the tuple by $(s,s,r)$. This preserves every possible extra conclusion just listed and every originally consistent premise. If its mgu binds $r$ to $c\in\{a,b\}$, replace it by $(r,c,r)$. This enforces $z=c$ under $x=y$ and $x=y$ under $z=c$. Its only inconsistent premise in the list is $x=y\land z=d$ for $d\ne c$, already inconsistent with the original tuple. Unconditional $P=Q$ and equality after $r:=d$ for $d\ne c$ are impossible in this case, so no other required conclusion is lost. This covers all cases. Finally remove any padding coordinates. $\square$

There are exactly $3$, $10$, and $37$ canonical flat tuple patterns on one, two, and three coordinates, respectively: partitions of the coordinates together with distinguished constants $a,b$, keeping those constants in different classes. Enumerating these gives a decision procedure for the fragment. A single constructor-free branch has a binary ground answer whenever its premise and conclusion are jointly satisfiable, proving minimality of the two-branch count as well.

The companion [flat-profile experiment](round-11-flat-profiles.py) compares constructor patterns with canonical flat patterns across every consistent flat premise on three coordinates. These finite comparisons check the case analysis; the argument above carries its unbounded claim.
