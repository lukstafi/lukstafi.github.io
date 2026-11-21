---
title: "What a branch witnesses: revisiting the InvarGenT thesis"
date: 2026-11-21
---

The 2015 thesis asks a solver to infer types from what each branch of a program must do. Three operations in that argument deserve closer inspection. Normalizing a guard can turn one source case into several implications. Substituting into a solved equation can move a dependency across a quantifier. Projecting a type equation can erase the only connection between two indices. Each operation has a small counterexample and a useful replacement rule. [Thesis, Chapters 3–5 and Appendix A](../lukstafi-phd-thesis.pdf) · [Lean proofs](thesis-review-1.lean)

## Which branches need a witness?

Definition 3.5 fixes an interpretation of the unknown predicates. Write $\operatorname{sat}(D)$ for existential closure in that interpretation. The default rule asks for $\operatorname{sat}(D_i)\Rightarrow\operatorname{sat}(D_i\land A)$ on each normalized branch, where $A$ is the residual answer. Its “without dead code” variant requires $\operatorname{sat}(D_i\land A)$ on each branch with conclusion different from $\bot$. Definition 4.1, for joint constraint abduction, requires $\operatorname{sat}(D_i\land A)$ on **every** branch. [Definition 3.5, p. 50](../lukstafi-phd-thesis.pdf#page=50) · [Definition 4.1, p. 59](../lukstafi-phd-thesis.pdf#page=59)

**Counterexample to Theorem 4.5 as stated.** Take two distinct nullary type constructors $K_0,K_1$, an empty prefix, and the branches
\[
(K_0=K_1\Rightarrow\top),\qquad(\top\Rightarrow\top).
\]
The first premise has no witness for any $A$. Table 4.1 deletes that branch in its first satisfiability test and recurses on the second. The remaining problem admits $\top$. The same computation must therefore serve two problems, one with no answer and one on which completeness requires an output. This contradicts the conjunction of correctness and completeness in Definition 4.4, independently of which complete component solvers are supplied. For strict JCA the local fix is to return the empty sequence on an impossible premise, including a premise shown impossible by a side sort. [Definitions 4.1 and 4.4](../lukstafi-phd-thesis.pdf#page=60) · [Theorem 4.5 and Table 4.1](../lukstafi-phd-thesis.pdf#page=61)

The negative branch exposes a second difference. Consider $\exists x.\,(x=0\Rightarrow\bot)$ in arithmetic. The residual $A=(x=1)$ is prefix-valid and makes the assertion unreachable. The default condition of Definition 3.5 still demands a witness of $x=0\land x=1$ because $x=0$ was feasible on its own. The “without dead code” condition exempts this negative branch. Thus switching between the two printed policies can admit an answer as well as exclude one. InvarGenT translates `assert false` into `CFalse` and partitions these branches before solving. It also enriches a negative guard $N$ with conclusions of positive implications whose premises occur in $N$. This step preserves exclusion. Whenever $N\Rightarrow D$ and $A\land D\Rightarrow C$, the formulas $A\land N$ and $A\land N\land C$ are equivalent. [Assert-false translation](https://github.com/lukstafi/invargent/blob/772b9b45b31ac11ef2a0d8e88b391db21d55eaa5/src/Infer.ml#L534) · [Negative branch preparation](https://github.com/lukstafi/invargent/blob/772b9b45b31ac11ef2a0d8e88b391db21d55eaa5/src/Invariants.ml#L923-L945)

**Proposed definition for program inference.** Keep source case identities through Proposition 3.4. Give each positive case $b$ a guard $G_b$ on its public variables. The permissive policy preserves a witness for each initially feasible $G_b$. The strict policy requires a witness for every positive $G_b$. Each negative assertion with guard $N$ requires $\neg\operatorname{sat}(N\land A)$. Both policies still require relevance for every generated implication and validity under the original prefix. These guards express reachability in the constraint model. Treating them as a criterion for operational reachability would additionally require a correspondence with evaluation and pattern order.

**Normalization lemma.** Suppose the normalizer proves, at each public valuation $r$,
\[
 G_b(r)\ \longleftrightarrow\ \bigvee_j\exists \ell_j.\,G_{bj}(r,\ell_j).
\]
Here $\ell_j$ are private to alternative $j$ and fresh for the answer. Keep all coordinates visible to $A$ in $r$, including any answer parameters during this comparison. Then
\[
 \exists r.\,G_b(r)\land A(r)
 \quad\longleftrightarrow\quad
 \bigvee_j\exists r,\ell_j.\,G_{bj}(r,\ell_j)\land A(r).
\]
A witness on the left selects an alternative and its local witnesses. A witness on the right projects to one for the source case. Relevance with a common public conclusion still distributes over **every** alternative. For example, splitting $\top$ over the rationals into $x\le0$ and $0\le x$ and taking $A=(x=-1)$ preserves the source witness. Requiring witnesses for both generated clauses rejects it. This is an additional obligation on the normalizer beside the logical equivalence proved in Proposition 3.4. [Proposition 3.4](../lukstafi-phd-thesis.pdf#page=50) · [Formal witness lemma](thesis-review-1.lean)

The implementation exposes the difference to users. With `Pos` carrying $0\le n$, the case `Pos i when i <= -1` has no witness. On the program in the upstream tests, both the default settings and `-allow_dead_code` inferred $\forall n.\,\mathrm{Positive}(n)\to\mathrm{Num}(n)$. With `-force_no_dead_code` inference failed on the numeric inequality. The flag documentation specifically mentions alternatives produced by expanding min/max. Retaining the case identity would give those alternatives the witness condition above. [Flag definitions](https://github.com/lukstafi/invargent/blob/772b9b45b31ac11ef2a0d8e88b391db21d55eaa5/src/Defs.mli#L8-L19) · [Upstream test program](https://github.com/lukstafi/invargent/blob/772b9b45b31ac11ef2a0d8e88b391db21d55eaa5/src/InvariantsTest.ml#L299-L329)

## When can a solved variable be replaced?

**Counterexample to Proposition A.11.** Work in the finite-tree algebra with a constant $a$ and an injective unary constructor $f$. The equation $x=f(v)$ is in solved form. Under $Q=\exists x\,\forall h\,\exists v$ it is valid. Take $x=f(a)$ and $v=a$. Replace $v$ by $h$. The only variable in the replacement strictly precedes $v$, as the proposition requires. Now $x=f(h)$ must hold for both $h=a$ and $h=f(a)$ with the same $x$. The two values of $f(h)$ differ by injectivity. Even a replacement consisting of one variable, without a cycle, invalidates the claim. The proof of Theorem 4.5 appeals to this property to combine choices of witnesses. [Proposition A.11](../lukstafi-phd-thesis.pdf#page=106) · [Proof of Theorem 4.5, steps (23)–(24)](../lukstafi-phd-thesis.pdf#page=107)

For pure free terms there is an exact test. Apply the replacement, recompute an idempotent most general unifier with the occurs check, and read off the pattern $P_z$ for **each coordinate in the prefix**. An unbound coordinate has itself as its pattern. Over a ground algebra with at least two elements, the prefix is valid precisely if unification succeeds and every universal coordinate is a bare residual variable absent from every preceding coordinate pattern. A fixed root misses a ground value. An earlier occurrence of that residual fixes the universal’s value at a particular address before the universal is played. Conversely, instantiate each such residual by its universal input and ground the other residuals arbitrarily. Each existential pattern is now a legal move depending only on earlier inputs. The comparison at $x$, the head of the affected equation, detects A.11’s counterexample. This criterion concerns closed prefix validity of a supplied equality conjunction. [Prefix criterion and proof](round-18-signature-boundary.html#parameter-free-quantifier-prefixes)

**Freezing the indices of an early constructor.** There is also a constructive replacement for a mixed-sort case. Let $K$ be a fixed constructor context with a hole at each of a tuple of distinct addresses. Every hole occurs, so $K$ is injective on the tuple of hole values. Let $Q'$ be any suffix over inhabited sorts. Let $x$ and $\bar c$ be fresh for $Q',\bar e,\Phi$. Then, pointwise in the earlier variables,
\[
 \exists x.\ Q'.\bigl(x=K(\bar e)\land\Phi\bigr)
 \quad\longleftrightarrow\quad
 \exists\bar c.\ Q'.\bigl(\bar c=\bar e\land\Phi\bigr).
\]
For the forward direction fix the winning $x$. One play of the suffix gives $x=K(\bar c)$ for some $\bar c$. On **every** winning play injectivity now forces $\bar e=\bar c$. The same continuation wins with that early choice. Conversely, choose $x=K(\bar c)$ and keep the continuation. The proof needs only monotonicity of the suffix and existence of a play for every winning strategy. These are the two hypotheses of the Lean theorem `freezeIndices`. [Formal proof](thesis-review-1.lean)

For example, $\exists x_{\rm type}\,\forall h_{\rm num}\,\exists v_{\rm num}.\,x=\mathrm{Num}(v)\land v=h$ becomes $\exists c\,\forall h\,\exists v.\,c=v\land v=h$, which fails in a numeric sort with two values. Each original conjunct is separately prefix-valid. The combined criterion exports both an equality **and the place at which its value must be chosen**. This supplies one case of the witness compatibility argument needed in Theorem 4.5.

## When can type information be projected away?

**Counterexample to Lemma A.12(1).** Put $D=(u=\mathrm{Num}(n))$, $\Psi=(u=\mathrm{Num}(m))$, and $C=(n=m)$. The antecedent $D\land\Psi$ is satisfiable and entails $C$ by injectivity. Solving $D$ alone gives one type binding and no numeric restriction on $n$. The claimed implication with only the numeric part of $D$ and the original $\Psi$ fails at $u=\mathrm{Num}(1),\,m=1,\,n=0$. The quantification over arbitrary $\Psi$ is where information disappears. [Lemma A.12](../lukstafi-phd-thesis.pdf#page=106)

**Joint projection lemma.** Let $E$ be a conjunction of type equations over freely generated finite types carrying side-sort values. Let $P$ be any condition on side variables. Assume type inhabitants exist, side expressions contain only side variables, and equality is the only observation the type equations make on side values. Unify all of $E$ together. Decompose matching type constructors, apply type-variable bindings throughout, reject a constructor clash or a type-variable occurs check, and emit a side equality whenever matching arguments have side sort. Call the conjunction of emitted equalities $R_E$, with $R_E=\bot$ on structural failure. If fresh names stand for side expressions, expand their definitions in $R_E$. Then
\[
 \exists\bar u_{\rm type}.\,(E\land P)\quad\longleftrightarrow\quad R_E\land P
\]
at each fixed side valuation, where $\bar u_{\rm type}$ contains every type variable of $E$.

Every unification step preserves the type solutions at that valuation, with matching constructors requiring equality of their arguments. In the successful solved form, ground all unbound type variables and evaluate the acyclic type bindings. This constructs an extension for every side valuation satisfying $R_E$. Consequently a side conclusion $C$ follows from $E\land P$ exactly when it follows from $R_E\land P$. A context sharing type variables must contribute its equations to $E$ before projection, or those coordinates must be retained on the interface. Moving this existential projection past an arbitrary prefix would require a dependency argument such as the freezing lemma.

InvarGenT takes the joint route. `Abduction.ml` combines the premise’s type substitution with the candidate’s substitution, computes the residual of the conclusion, and passes the numeric constraints on. I ran its `combine_sbs` on the two substitutions above. Each alone emitted zero numeric constraints. Together they emitted `m = n`. This gives an implementation-backed replacement for the entailment step in A.12(1). Completeness of synthesis in Theorem 4.5 requires more, including admissible presentations of the answers and compatible prefix witnesses. [Abduction call site](https://github.com/lukstafi/invargent/blob/772b9b45b31ac11ef2a0d8e88b391db21d55eaa5/src/Abduction.ml#L827-L849) · [Type unification](https://github.com/lukstafi/invargent/blob/772b9b45b31ac11ef2a0d8e88b391db21d55eaa5/src/Terms.ml#L1467-L1546) · [Combining substitutions](https://github.com/lukstafi/invargent/blob/772b9b45b31ac11ef2a0d8e88b391db21d55eaa5/src/Terms.ml#L1631-L1634)

## A program with no principal conjunctive type

Local GADT assumptions can destroy principality, as illustrated in the OutsideIn(X) paper. Here one can see exactly which ground typings force the failure in InvarGenT’s conjunctive answer language. The following is a complete program. Its indices record which payload type each constructor carries. [Vytiniotis et al., *OutsideIn(X)*](https://simon.peytonjones.org/outsideinx/)

```ocaml
datatype A
datacons A : A
datatype B
datacons B : B
datatype Tag : type * type
datacons Left : ∀b. b ⟶ Tag(A,b)
datacons Right : ∀a. a ⟶ Tag(a,A)
let payload = function Left y -> y | Right x -> x
```

Write $(h,k,y)$ for the two argument indices and the result type of $\mathrm{Tag}(h,k)\to y$. The left branch requires $h=A\Rightarrow y=k$. The right branch requires $k=A\Rightarrow y=h$. Both are ordinary instances of constructor-pattern refinement. Two sound schemes are
\[
 \forall t.\,\mathrm{Tag}(A,t)\to t,\qquad
 \forall t.\,\mathrm{Tag}(t,A)\to t.
\]
In the first scheme the right constructor forces $t=A$, so returning its payload has the required type. The second scheme follows by symmetry. Both constructors have a witness at $(A,A,A)$. InvarGenT inferred a third sound scheme, $\forall t.\,\mathrm{Tag}(t,t)\to t$. Adding `let left_payload = payload (Left B)` to the program produced a type mismatch between $A$ and $B$. On that input the function reduces to the value `B`. [Type inference for patterns, Table 3.6](../lukstafi-phd-thesis.pdf#page=47)

**Theorem.** No scheme whose ground type triples are described by an existential conjunction of free type equations is both sound for `payload` and at least as general as the first two schemes. Generality here means inclusion of ground instances. Failure under this order also excludes a principal scheme under any instantiation order implying such inclusion.

*Proof.* The two schemes together require the three ground triples
\[
 (A,A,A),\qquad(A,B,B),\qquad(B,A,B).
\]
Solving any satisfiable conjunction and projecting its most general unifier to $h,k,y$ gives a single tuple pattern. Every coordinate takes both $A$ and $B$ in the displayed triples, so all three coordinates must be bare holes. The result hole differs from the first input hole on the second row and from the second input hole on the third. Assign the input holes $A$ and the result hole $B$. This produces $(A,A,B)$, although `Left A` has type $\mathrm{Tag}(A,A)$ and returns $A$. The contradiction applies with any number of auxiliary type variables or other free type constructors. [Formal three-row argument](thesis-review-1.lean)

The two refinements agree at their intersection. A semantic result function exists, for example $y=k$ when $h=A$ and $y=h$ otherwise. On the union of constructor-compatible input indices its graph is exactly
\[
 (h=A\land y=k)\ \lor\ (k=A\land y=h).
\]
This is an ordinary disjunction of two type-equation conjunctions. The example gives a source-level reason to distinguish validity of the generated implications, existence of an expressible answer on a proposed domain, and existence of a principal type. Theorems 3.1–3.2 concern the correspondence with typing derivations. Proposition 4.14 gives the implication from a solution to semantic validity. The example supplies an obstruction to principality even for a nonrecursive function with one match. [Theorems 3.1–3.2](../lukstafi-phd-thesis.pdf#page=46) · [Proposition 4.14](../lukstafi-phd-thesis.pdf#page=70)

## How many inferred types would a beam need?

Chapter 6 proposes keeping several candidate types and discarding inferior candidates. The payload example gives a lower bound on how many final types would cover all useful applications. For each $m\ge2$, declare a datatype $T_m$ with $m$ type indices and one constructor per position:
\[
 K_i:\forall t.\ t\to T_m(A,\ldots,A,t,A,\ldots,A).
\]
The function with cases `K_i x -> x` returns the sole field. Each constructor gives a sound scheme on its axis with result $t$. At the all-$A$ input all constructors agree on result $A$. [Beam search in §6.2](../lukstafi-phd-thesis.pdf#page=83)

**Theorem.** Exactly $m$ sound conjunctive equational schemes are needed to cover every ground typing on this function’s constructor-compatible input indices. The lower bound holds even if the schemes may divide the ground instances of each constructor among themselves.

*Proof.* Mark the $m$ concrete calls `payload (K_i B)`. Each has result $B$, with $B$ at input position $i$ and $A$ everywhere else. Suppose one tuple pattern contains the marked calls for distinct $i,j$. Its $i$th input pattern takes both $B$ and $A$, so it is a bare hole $p$. Start with the valuation for call $i$ and change only $p$ from $B$ to $A$. The other input coordinates, all equal to the nullary constructor $A$ on this row, are ground constants or holes different from $p$. The output, equal to the nullary $B$ on both rows, is also ground or a different hole, since $p=A$ on row $j$. The modified row thus assigns output $B$ to all-$A$ inputs, contradicting soundness. Each sound scheme covers at most one marked call. The $m$ constructor schemes give the matching upper bound. In fact the lower bound uses only ordinary ground calls on explicitly constructed values. [Lean proof for an arbitrary index set](thesis-review-1.lean)

I ran the three-constructor program with constructors `First`, `Second` and `Third`. InvarGenT inferred $\forall a,b.\,T_3(a,b,b)\to a$ (the source datatype was named `Tag`). It typed `payload (First B)` at $B$ and rejected the `Second B` and `Third B` calls. Each of those calls also computes $B$. A fixed beam can still find a sound answer. If its purpose is to preserve all these calls for downstream use, a fixed bound on the number of final conjunctive schemes cannot suffice across this family. A disjunction indexed by the constructors describes the $m$ alternatives directly.

## What a variable pattern knows about list length

Section 5.2.2 suggests attaching an invariant common to all constructors to a pattern variable once its datatype is known. A run of the two versions of `append` on p. 77 gives a precise target. I used `LNil : List(a,0)` and `LCons : ∀n,a [0 ≤ n]. a * List(a,n) ⟶ List(a,n+1)`. The thesis describes the short version as failing to typecheck. In the tested checkout it succeeded with a precondition.

| Second argument pattern | Inferred type (quantifiers omitted) |
|---|---|
| Variable, as in the short definition | $[1\le k+n\ \land\ 1\le n].\ \mathrm{List}(a,k)\to\mathrm{List}(a,n)\to\mathrm{List}(a,n+k)$ |
| Both constructors, as in the expanded definition | $\mathrm{List}(a,k)\to\mathrm{List}(a,n)\to\mathrm{List}(a,n+k)$ |

The first type excludes `append LNil LNil`. Both values exist and the computation returns `LNil`. Merely replacing a rejected program by an accepted one would miss this difference. [Section 5.2.2 and both programs](../lukstafi-phd-thesis.pdf#page=77)

**Constructor invariant rule.** For each inductive datatype $D$, propose a predicate $I_D$ on its parameters. For each constructor $K$ of $D$, let $G_K$ be its index guard, $r_K$ its result parameters, and $D_j(u_j)$ its immediate inductive data fields. Check the universally closed obligation
\[
 G_K\land\bigwedge_j I_{D_j}(u_j)\ \Rightarrow\ I_D(r_K).
\]
Every finite constructor value of type $D(r)$ then satisfies $I_D(r)$. Induct on the size of the value. Its typing gives the guard and result indices for the outer constructor. Each listed field is a strictly smaller value, so the constructor obligation applies. The same proof allows mutually recursive declarations. For an abstract or external producer of values, the invariant must form part of the producer’s specification.

For lists choose $I(n)=(0\le n)$. The checks are $0\le0$ and $0\le j\Rightarrow0\le j+1$. The latter already follows from the recursive field, even if the declaration omits its guard. In the short `append`, the variable holding the second argument supplies $0\le n$. Matching the first list against `LCons` supplies $0\le j$ for its tail. The induction hypothesis returns a list of length $n+j$, and $0\le n+j$ discharges the guard on the result constructor. The companion checks this append with integer indices and exactly one recursive match. [Lean derivation](thesis-review-1.lean)

A typing rule can expose $I_D(r)$ in the assumptions for the body that binds an actual value of type $D(r)$, including a variable pattern. The type expression $\mathrm{List}(a,-1)$ still exists in the freely generated type domain. Making $0\le n$ an axiom about *type expressions* would invalidate that model. A full extension of MMG would need rules for value bindings, a revised constraint-generation correspondence, and a soundness argument covering the external-value boundary. The constructor induction establishes the premise for that extension. [Table 3.6](../lukstafi-phd-thesis.pdf#page=47) · [Type soundness and the translation to HMG(X)](../lukstafi-phd-thesis.pdf#page=56) · [Simonet and Pottier’s HMG(X)](https://gallium.inria.fr/~fpottier/publis/simonet-pottier-hmg-toplas.pdf)

## An exact target for linear arithmetic generalization

Fix the public variables. Suppose both the branches and candidate generalizations in Definition 4.8 use only rational affine equalities and weak inequalities. Branch-local variables are existential. The most specific common consequence is the **closed convex hull of the projected branches**, over the reals, or its rational points over the rationals. This gives §4.3.2 a reference algorithm even for implicit equalities, lower-dimensional faces and unbounded branches. The construction is the classical extended formulation for disjunctive programming. [Definition 4.8 and §4.3.2](../lukstafi-phd-thesis.pdf#page=66) · [Balas](https://epubs.siam.org/doi/10.1137/0606047) · [Cornuéjols and Lemaréchal, Lemma 6.4](https://bipop.inrialpes.fr/publis/CoLe2005MATHPROG.pdf)

Project each branch onto the public variables by linear elimination. Remove empty branches, returning $\bot$ if none survive. Write the remaining nonempty polyhedra as $P_i=\{x:A_ix\le b_i\}$. Use the following conjunction with existential $\lambda_i,z_i$:
\[
 \lambda_i\ge0,\qquad \sum_i\lambda_i=1,\qquad x=\sum_i z_i,\qquad
 A_i z_i\le\lambda_i b_i\quad\text{for every }i.
\]
Its projection is a closed polyhedron containing all ordinary convex combinations. Conversely, choose $q_i\in P_i$ and positive weights $w_i$ summing to one. Given any feasible extended point, replace $(\lambda_i,z_i)$ by $(1-\epsilon)(\lambda_i,z_i)+\epsilon w_i(1,q_i)$ for $0<\epsilon<1$. All new weights are positive, so dividing gives points of $P_i$ and their convex combination tends to $x$. This proves equality with the closure. A conjunction of weak affine inequalities defines a closed convex set, as does its existential projection by linear elimination. Every admissible common consequence therefore contains this hull. Rational elimination gives rational coefficients and witnesses on rational data.

Take the origin and the ray $\{(1,t):t\ge0\}$. Their convex hull misses $(0,1)$, although $(1/j,1)$ is a convex combination for each positive integer $j$. All their common weak affine inequalities hold at $(0,1)$. The best expressible answer is $0\le x\le1,\ y\ge0$. InvarGenT also searches for min/max constraints. Completeness of its face-selection heuristic and generalization in that richer language require separate proofs. [Numerical disjunction elimination](https://github.com/lukstafi/invargent/blob/772b9b45b31ac11ef2a0d8e88b391db21d55eaa5/src/NumS.ml#L3386-L3444)

## Status of the remaining questions

| Question | Status in this project |
|---|---|
| Does general finite-term JCA have a decision algorithm? | The project’s reduction proves r.e.-completeness for ordinary JCA already with two branches, one binary constructor and one constant. The corresponding prefix problem includes these instances. This is a manuscript result. [Proof and signature assumptions](round-25-binary.html) |
| Is there a most general answer or an automatic route from maximal answers to a decision procedure? | Example 4.3 already has infinitely many incomparable maxima. A supplied ground example does allow maximization above that example. The `payload` theorem above now shows failure of principality on generated constraints in the stated scheme language. [Example 4.3](round-43-infinite-maxima.html) · [Maximization from a seed](round-42-maximal.html) |
| Can generated constraints realize the abstract two-branch reduction without polymorphic recursion? | Open here. Milner–Mycroft typability with polymorphic recursion is already undecidable. The payload family realizes crossing guards without recursion, but transferring the JCA reduction would require realizing its data, prefix order and witness conditions in generated constraints. [Henglein](https://suif.stanford.edu/~brm/reading/p253-henglein.pdf) · [Thesis §6.3](../lukstafi-phd-thesis.pdf#page=84) |
| Does multi-sort synthesis enumerate all admissible answers? | Table 4.1 can miss an answer even when every branch is live. The replacement algorithm in Theorem 4.5R proves witness compatibility and covers arbitrary conjunctive answers with designated parameters. [Repaired theorem and proof](thesis-review-2.html#combination) |
| Does the predicate iteration reach a solution? | A covered chain of nonempty free-term patterns has finite height. Weakest one-step arithmetic refinement can diverge with a constant-size solution. A known bound on verifiable certificates gives a terminating search. The original Table 4.4 induction jump can force a caller to restore the same valid upper bound indefinitely. With implied bounds retained, an inductive caller contract on a fixed vocabulary bounds the number of changes. [Unary convergence results](thesis-review-2.html#convergence) · [Binary counterexample and trace](thesis-review-3.html#update) · [Fixed-contract bound](thesis-review-3.html#fixed-demands) |
| What should InvarGenT check before accepting an inferred type? | Reinsert the candidate into the original branches, preserve when constructor indices become fixed, and verify negative guards with the final residual. Granting value bindings new datatype invariants additionally needs a typing rule. [Implementation examples](thesis-review-2.html#implementation) |

One convention-specific question also survives the earlier fragment analysis. With leading fresh parameters, a single forbidden read and the reflexive weak escape comparison, the one-branch hardness proof uses additional substituted parameters outside the designated set. The equal-set result uses the comparison in the Markdown extraction. Those proofs leave the equal-set, reflexive version unsettled here. [Scope distinction in the proof](round-40-reflexive.html) · [Equal-set construction for the extracted comparison](round-39-weak-conjunctions.html)

**Checks.** The companion file runs with `lean thesis-review-1.lean` in Lean 4.19.0. It checks both appendix counterexamples, the witness-distribution and index-freezing lemmas, the three-row obstruction for `payload`, the arbitrary-arity beam obstruction, and the indexed-list derivation. The general unification, projection and polyhedral arguments above are mathematical proofs. I ran InvarGenT at commit `772b9b45` with `-inform -no_ml -no_sig -no_verif`. The OCaml 5.5.1 build used a temporary copy with compatibility edits for `Pervasives`, legacy standard-library names and the reserved identifier `nonrec`. The reported types and diagnostics come from the solver. [Lean companion](thesis-review-1.lean) · [Implementation revision](https://github.com/lukstafi/invargent/tree/772b9b45b31ac11ef2a0d8e88b391db21d55eaa5)
