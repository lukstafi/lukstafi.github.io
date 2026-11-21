---
title: "JCA Round 21: When the premise can test the output"
date: 2026-11-21
---

**One implication with one universal input is P-complete**, even when its premise tests the outputs. For example, consider

$$\forall h\;\exists y.\qquad y=f(b,a)\ \Rightarrow\ h=b.$$

The answer $y=f(h,a)$ makes the premise true at precisely $h=b$. Freezing $y$ at its value in that witness would make the premise true at every input. The distinction is whether a term strategy can arrange for one witness to be the only active input.

The same test applies to arbitrarily many inputs linked by the premise. As in Round 20, work over the finite ground trees of a finite single-sorted signature with a constant. There are initial existential data $X$, universal inputs $H$, and existential outputs $Y$ interleaved with the inputs. There are no designated invariant variables. The single implication $D(X,H,Y)\Rightarrow C(X,H,Y)$ has conjunctive equational sides, and the sought answer is equational. The one-element algebra is immediate. [Term-strategy characterization](round-20-one-branch.html#one-witness-determines-the-strategy-form)

## Count the free inputs in the premise

First unify $D\land C$. Failure means that the branch cannot have a consistency witness. Separately take an idempotent most general unifier $\mu$ of $D$, using original variables as residuals. For each ground choice of the data in the projection of $D$, the residuals $Z$ in $\mu(X)$ have uniquely determined values. Count the remaining residuals appearing in $\mu(H)$. Write $R$ for their set and call $|R|$ the **input rank** of the premise. This count is invariant under renaming the unifier's parameters. It measures independent variations of the input tuple at fixed data in the projection of $D$. Some may be visible only as subtrees of inputs.

**Theorem.** For premises of input rank at most one, one-branch existence is in NP for arbitrary quantifier order and in P when all inputs precede all outputs. Both bounds are tight on every branching signature. One public universal can contain several independent subtrees. The pinning argument below also covers that case.

To see the qualification, $h=f(y_1,y_2)$ already gives rank two with just one public input. For one universal $h$, either $h$ is the sole residual in $\mu(h)$, or each residual of $\mu(h)$ distinct from $h$ is an unbound original data or output variable. In the latter case all members of $R$ occur in $\mu(Y)$. More explicitly, if $h$ occurs in its own idempotent normal form then that form is $h$ by the occurs check. Otherwise every unbound name comes from $X$ or $Y$. In both cases the tests below decide the instance in polynomial time.

## Pinning the inputs by constant outputs

Pick a ground joint witness of $D\land C$. If **all** members of $R$ occur in $\mu(Y)$, fix the data and the outputs to their joint witness values. Every input residual is then fixed by a subtree of some data or output coordinate. Only the witness input tuple can satisfy $D$ with those fixed values. This is an answer, regardless of the rank or the quantifier order. In particular rank zero needs only the initial joint-unification test.

The remaining rank-one case has a single residual $r$ which occurs in $\mu(H)$ and is absent from $\mu(X),\mu(Y)$. Since it is an unbound original variable, one public input is $r$ itself. Once the data are fixed, the projected input tuples are $S(r)=\mu(H)$ with the fixed residuals specialized. Each $S_h(r)$ is an ordinary term in this one variable. For any joint witness, holding its data and **all its outputs** constant still satisfies $D$ throughout this family. In the unifier of $D$ one can vary $r$ without changing a data or output coordinate.

The one-witness specialization proof in Round 20 applies to arbitrary $D$. A term strategy specializes an equational answer while retaining the chosen row and preserving relevance. For fixed data and any term strategy, substituting $H=S(r)$ and the chosen output terms into $D$ leaves a conjunction in the single variable $r$. If satisfiable, it either consists of identities and holds everywhere, or has a unique ground solution. Indeed unifying a nonidentity over one variable must bind that variable to a ground tree. The binary-tree lemma also has a direct proof in Lean. [Two distinct inputs force term identity](round-21-fiber.lean)

## Deciding if one input can be isolated

Call an output $y$ **asymmetric in the premise** if some atom has different sets of occurrence positions for $y$ on its two sides. In $f(y,z)=f(y,a)$, for example, $z$ is asymmetric and $y$ is symmetric. Call an input $h$ **varying** if $r$ occurs in $S_h(r)$. Both tests are independent of the chosen data values.

A singleton active set is possible **if and only if** some asymmetric output $y$ has an earlier varying input $h$ and there is a joint witness of $D\land C$ in which the value of $h$ is a subtree of the value of $y$. The statement requires the unique active point to satisfy the conclusion.

For sufficiency, take such a joint witness, write its input parameter as $r_0$, and begin with constant data and outputs. Inside the ground value of $y$, replace one occurrence of the ground value of $h$ by the public name $h$. Its value at $r_0$ is unchanged. The new strategy still contains the joint witness. To show it isolates $r_0$, take a premise equality with an occurrence of $y$ on one side at a position $q$ absent on the other. At the joint witness all occurrences of this same ground value on the two sides of the equality have identical or disjoint root positions. Two strictly nested copies of one finite tree would contradict their sizes. Thus every occurrence of $y$ on the other side is disjoint from $q$. With all outputs constant, both sides were identical as terms in $r$, and there was no occurrence of $r$ under $q$. After the replacement, $S_h(r)$ introduces an occurrence of $r$ underneath $q$ on just one side. This is now a nonidentity, so it can hold at only $r_0$.

For necessity, take a term strategy with its unique active point $r_0$. Freeze all its outputs at their values there. This frozen strategy satisfies $D$ on the entire input family. A symmetric output occupies exactly the same positions on both sides of every atom, so changing its term back on both sides cannot create a difference there. If every asymmetric output expanded to a constant in $r$, those constants would already agree with their values at $r_0$, leaving every premise equality an identity. At least one asymmetric output therefore varies. Its body must contain an earlier varying $h$. At $r_0$, this makes the whole value of $h$ a subtree of that output in the joint witness.

**Checking the subtree condition takes polynomial time.** Let $\lambda$ unify $D\land C$, put $s=\lambda(h)$, $t=\lambda(y)$, and try unifying $s$ with each syntactic subterm of $t$. A successful test gives the required witness after grounding the remaining variables. Conversely suppose $s\theta$ is a subtree of $t\theta$. Its root either corresponds to a node of $t$, or lies strictly inside the value of a residual $w$ at a leaf of $t$. In the latter case $w$ cannot occur in $s$, since $s\theta$ would then contain $w\theta$ while lying strictly inside it. Hence $s$ unifies with that leaf $w$. The successful test may choose different ground values from the original witness. Term DAGs have only polynomially many distinct subterm nodes.

## The case with all projected inputs active

When the isolation test fails, a successful strategy must satisfy $D\land C$ at every projected input for its chosen data. Conversely such a strategy gives an answer, since outside the projection the original premise cannot hold for any outputs.

Express this as a Round 20 input-only instance. Give the residuals $Z$ in $\mu(X)$ fresh names and quantify them as additional initial data. Use the input-only premise

$$X=\mu(X)(Z),\qquad H=\mu(H)(Z,r)$$

and the conclusion $D\land C$. The coordinate for $r$ is its original public input, so introducing this premise preserves when each output can first use $r$. The data witnesses for $Z$ can be read from the original data. Conversely the solver for this instance returns fixed data and output terms on earlier original inputs, which also solve the initial branch. Keeping the projected templates shared gives a polynomial-size reduction. If the chosen input format requires unshared terms, name shared nodes in the verifier's term graph. The polynomial upper bound for the three-block case follows from the two-unification algorithm. [Input-only decision procedure](round-20-one-branch.html#when-two-unifications-suffice)

The NP lower bound with arbitrary order already uses an input-only premise of rank one. Its six earlier inputs have the forms $f(f(c_i,c_j),r)$, with a single later universal $r$. P-hardness for the three-block case holds even with the prefix $\forall h\,\exists Y$, no initial data, $D=\top$ and $C$ an arbitrary unification problem on $Y$. In particular **one universal and one arbitrary implication is P-complete** on every branching signature. With two implications the Round 19 hard family has rank *zero in each premise*: at fixed data each premise names its entire input tuple. [One-branch hardness proofs](round-20-one-branch.html) · [Two-branch reduction](round-19-designated-parameters.html#the-prefix-replaces-the-scope-branch)

## Eliminate a defined universal in the three-block prefix

There is a normalization for **arbitrary** one-branch premises under $\exists X\,\forall H\,\exists Y$. If a premise atom is $h=t(X,H',Y)$, where $h$ is a universal and $H'=H\setminus\{h\}$, delete the atom and substitute $t$ for $h$ throughout the remaining premise and conclusion. Delete $h$ from the prefix. This preserves answer existence even though the original outputs could read $h$.

To lift a strategy for the reduced clause, take its output bodies independent of $h$ in the original game. The deleted atom then fixes exactly one value of $h$ at each choice of the other inputs. The two implications agree on those inputs, and a witness in the reduced branch extends with that value of $h$.

For the other direction fix the data and a term strategy $Y=B(H',h)$ from an original answer. Its active joint witness gives some $h_0$. The deleted atom after substitution is $h=T(H',h)$. If $h$ appeared properly inside $T$, this equality could never hold on finite trees. Thus either $T$ omits $h$ or $T=h$ syntactically. In the first case put $U(H')=T(H')$. In the second put $U=h_0$. In both cases $Y'=B(H',U(H'))$ is a permitted strategy under the reduced prefix. It extends every active reduced row to an original one by taking $h=U(H')$, and it retains the chosen witness. Having all $H'$ available when each output is chosen makes the composition legal.

Compute a solved unifier of the whole premise before applying the rule. Every bound universal has a definition using only unbound names, so all such definitions can be eliminated. The remaining premise consists solely of the solved data and output equations. For instance, if the premise just defines distinct universal inputs by trees in data, other inputs and outputs, the reduced premise is empty when those definitions have acyclic input dependencies. The three-block input-only algorithm then decides the instance in P, even at unbounded input rank. More generally, one can run either the rank test or the test for data-determined outputs on the normalized clause. [Data-determined output tests](round-22-ground-tests.html#when-the-initial-data-determine-the-test)

## Verification and the remaining case

The [reference solver](round-21-one-input.py) returns term strategies and independently checks the original implication at each returned strategy. It compares all 625 combinations of a single premise equation and a single conclusion equation on two constants, one universal and two outputs against direct enumeration of every term strategy in that algebra. Another 625 comparisons check defined-input elimination against all strategies with two universal inputs. Branching examples check access to a whole earlier input, latent input parameters, incompatible output tests, and pinning several inputs by constant outputs.

The remaining one-branch problem requires several independent input parameters and some parameter outside the data and output patterns. A nonidentity can then constrain the inputs to a proper family of positive dimension. The isolated-point argument no longer exhausts the possibilities. For instance, $\forall h,k\,\exists y$ with $y=a\Rightarrow h=a$ admits $y=h$, whose active inputs are all $(a,k)$. The constant answer $y=a$ fails relevance and any different ground constant value for $y$ fails consistency. Round 22 handles active sets of this kind at arbitrary input rank when the premise pins its tested outputs to ground trees. [Ground output tests](round-22-ground-tests.html) · [General one-branch classification](round-30-monadic.html)

~~~sh
python3 projects/jca/agent-collab/round-21-one-input.py
lean projects/jca/agent-collab/round-21-fiber.lean
~~~
