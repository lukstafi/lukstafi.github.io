---
title: "Independent Proof Review of JCA Round 11"
date: 2026-09-21
---

# Independent proof review of JCA Round 11

*Reviewer: a Codex subagent assigned to skeptical proof review independently of the agents proposing the results. Reviewed the research drafts and the integrated [Round 11 note](../round-11-witness-bounds.html), including its appendices. This is a mathematical review, not machine-checked verification or an independent literature survey.*

## Verdict and scope

The ten claims below pass this review under the exact ordinary-JCA semantics of [Round 10, §2.1](../round-10-witness-generalization.html#the-common-equational-core): finite terms over the fixed signature $\{f/2,a/0,b/0\}$, branchwise relevance and consistency, and fresh answer parameters existentially hidden when projecting onto instance variables. No unresolved proof defect was found in the integrated note, including Appendices A and B.

The review found one invalid auxiliary-variable shortcut in a research draft. The final note omits that shortcut; its actual flattening theorem already uses the correct construction. The review also prompted explicit qualification of answer-depth statements as statements about **tuple-pattern answers**.

## The ten audited findings

### 1. Flattening preserves existence and branch count

The common system $G$ must include definitions for all original compound subterms and occur in every transformed premise. Under this construction, every original ground assignment has a unique extension satisfying $G$. Both directions of the existence proof follow.

The backward direction correctly includes $G$ in the projected original answer and treats its auxiliary variables as fresh answer parameters. This accounts for arbitrary references to auxiliaries in a transformed answer. Merely deleting those variables would not be justified. The stated structural size bound $O(m|I|)$ and preservation of branch count are correct.

**Limit:** this is an ordinary-JCA result, without prefix or scope restrictions. Preserving two branches does not reduce arbitrary branch counts to two.

### 2. Functional extension commutes with simultaneous lgg

For a term $t(X)$ and a common memo table, generalizing the vector $(t[g_i])_i$ gives $t[H]$, where $H$ is the simultaneous lgg of the original tuples. Structural induction is valid: constructors are retained, and occurrences of an original variable reuse its generalized coordinate, including its internal sharing.

The extended hull consequently satisfies $G$ and projects exactly to $H$. Original witness families are successful exactly when their functional extensions are successful.

**Limit:** the shared disagreement-vector table is essential. This assertion does not justify independent generalization of coordinates with unrelated parameter names.

### 3. The four-variable, two-branch constructor obstruction

For $x=y\Rightarrow u=a\land v=b$ and $u=b\land v=a\Rightarrow\top$, the displayed constructor answer and depth-one witnesses are valid. In any flat answer, the $u,v$ coordinates must be two distinct parameters. One consistent equation between flat terms cannot force both parameters to two different constants. Constructor-free equational answers also normalize to flat tuple patterns, so changing the answer presentation does not evade the obstruction.

The minimum total witness tree size is exactly $16$. In every successful hull, the $u,v$ coordinates are parameters. If at most one of $x,y$ were compound, Lemma A.1 would produce a flat answer, contradicting the obstruction. Thus both hull coordinates are constructor-headed, and all four corresponding coordinates of the two witnesses have at least three nodes each. The four $u,v$ witness coordinates are forced one-node constants. This gives $4\cdot3+4=16$, attained by the displayed family.

**Limit:** the exact minimum witness depth one and total tree size $16$ concern this instance. They give no general bound for two branches.

### 4. Binary-code guards force unbounded tuple-pattern depth

The guards force $k=2^r-1$ distinct parameter coordinates. Every such parameter must occur in one of the two coordinates compared by the central premise; otherwise it remains independently assignable to $b$. Two binary terms of depth at most $d$ contain at most $2^{d+1}$ leaves, giving $d\ge r-1$. The balanced-tree construction gives depth at most $r$, and the lower bound transfers to successful witnesses because lgg cannot exceed their maximum depth.

**Limits:** branch and variable counts grow. The result does not refute a computable bound in total input size or establish fixed-two-branch unboundedness. For answers, the lower bound concerns normalized tuple patterns: arbitrary equational presentations can name subterms using fresh auxiliaries and depth-one equations.

### 5. Exponential expanded witness trees

The doubling-chain example fixes unique ground witnesses for both branches. The total expanded tree size

$$2^{k+3}-2k-6$$

is correct. Input structural size is $O(k)$; with binary variable identifiers, the stated $O(k\log k)$ bit-length bound still yields superpolynomial witness trees.

**Limits:** the empty answer already works. Shared DAGs need only $O(k)$ nodes and witness depth is $k$. This is not an answer-size, DAG-size, or noncomputable-bound result.

### 6. Binary witnesses and NP membership for constant-test premises

Consistency ensures that every premise-tested coordinate of an answer pattern is a parameter or constant. Each substituted premise therefore only binds parameters to $a$ or $b$. Replacing all remaining constructor-headed coordinates by $a$ preserves relevance: simple/simple conclusion equations are unchanged, compound/compound equations become $a=a$, and a mixed simple/compound equation could not have been entailed originally.

Grounding unforced parameters with $a$ gives binary branch witnesses. The $mn$-bit witness matrix is a polynomial certificate, and its flat lgg and branch checks are computable in polynomial time.

**Limit:** the argument needs constant-test premises. Arbitrary constructor-free premises are excluded by finding 3.

### 7. Exact additive joint witness depth

For the two-branch family using $F(t)=f(a,t)$ and $K(t)=f(b,t)$, the minimum successful joint witness depth is exactly $h+k$, although individual minimum depths are $h$ and $k$.

The critical independence arguments are sound. The $x$-coordinate disagreement key contains $K^k(t)$, which is larger than every subterm of $t$, so that parameter cannot recur in the $y$ hull. An early right-spine stop creates another parameter occurring only once, permitting the stated countermodel. The exact success condition on the terminal and side subterms follows from their shared disagreement keys.

**Limits:** successful choices need not be unique. This refutes a maximum-of-individual-depths bound, not a sum bound or a bound in input size.

### 8. NP-hardness and NP-completeness of the constant-test fragment

The graph 3-colouring reduction is correct, including its treatment of arbitrary constructor answers. The common-$a$ branch and variation guard make every vertex coordinate a parameter with both $a$ and $b$ instances. The common premise binds at most three parameter classes to $a$, and relevance forces every vertex coordinate into one of those classes. An edge guard forces its endpoints into different classes. Conversely a proper colouring supplies the stated pattern answer and all branch witnesses.

Together with finding 6, this proves NP-completeness of the specified fragment and NP-hardness of unrestricted ordinary JCA. Splitting the variation guard into one branch per vertex preserves the proof and bounds premise size by three atoms.

**Limits:** this gives no upper bound for unrestricted JCA and makes no claim of novelty in the complexity literature.

### 9. At most one uncovered coordinate

The abstraction lemma in Appendix A is valid. Abstract the sole distinct constructor-root term by $q$ and solve the flat premise by union-find. Original consistency excludes both a constant in the $q$ class and occurrence of $q$ in the restored compound term. Restoring that term therefore identifies no distinct flat-class representatives, preserving exactly the constructor-free equality consequences.

Every constant-covered coordinate of a successful witness hull is flat, since some witness has a constant there. Thus at most one uncovered coordinate permits the abstraction lemma, yielding a flat answer and binary witnesses of total size $mn$. The four-variable obstruction has exactly two uncovered coordinates and makes this threshold sharp.

**Limits:** abstraction need only preserve premises consistent with the original pattern. Exceeding the coverage threshold does not imply undecidability or rule out other finite bounds.

### 10. Constructor-free completeness with at most three variables

Appendix B's case analysis is sound. Its one-compound case follows from the audited abstraction lemma. With two compound coordinates $P,Q$ and a flat parameter $r$, the listed possible additional equality consequences are exhaustive. If unifying $P,Q$ forces $r=c$, the replacement $(r,c,r)$ preserves every originally accepted branch. Otherwise $(s,s,r)$ suffices. The constant-third-coordinate and three-compound cases are also valid.

Consequently at most three instance variables admit flat answers whenever an answer exists. The canonical pattern counts $3,10,37$ are correct. Together with the one-branch observation, the four-variable, two-branch constructor obstruction is minimal in both counts.

**Limit:** this is specific to constructor-free input and the stated two-constant signature. Finite profile experiments support the case analysis but do not replace its unbounded proof.

## Draft issue excluded from the final results

A draft suggested replacing a branch-local equality $u=v$ by fresh equations $z=f(u,a)\land z=f(v,a)$. Existential equivalence of those conjunctions does **not** alone establish a JCA reduction: auxiliary coordinates can become branch selectors.

For example, the original branches $x=y\Rightarrow u=a$ and $x=y\Rightarrow u=b$ are jointly unsolvable. Encoding their premises independently with $z_1,z_2$ admits the answer

$$x=y=f(a,b),\quad u=p,\quad z_1=f(f(p,q),a),\quad z_2=f(f(q,p),a).$$

The two transformed premises respectively force $(p,q)=(a,b)$ and $(b,a)$.

This shortcut is **omitted from the final note**, rather than retained as a result. A repair would put all chosen base definitions into the common $G$ in every premise and carry them into the projected answer. The actual flattening theorem already follows that discipline and is unaffected.

## Remaining scope

The integrated note establishes the stated finite fragments and lower bounds. It does not decide unrestricted ordinary JCA, unrestricted two-branch JCA, the general two-branch constructor-free fragment, or any prefix/scoped variant. A computable successful-witness bound for those broader cases remains unproved.
