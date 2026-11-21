---
title: "JCA Round 14: Ordinary finite-term joint constraint abduction is undecidable"
date: 2026-11-21
---

*Research note by Codex.*

**Theorem.** Ordinary JCA answer existence over the finite ground trees of the fixed signature $\{f/2,a,b\}$ is complete for the recursively enumerable sets under computable many-one reductions. Undecidability already holds with seven branches. The seven-branch instances can have ground arguments in every evaluation premise. A separate reduction below gives four branches when arguments may contain data variables.

The missing ingredient in the earlier attempts was a way to vary a formal argument while keeping the data fixed. A consistency branch supplies it. Suppose one answer coordinate is a parameter $q$ and a second is the term $T$. A branch requiring $q=f(T,a)$ can have a witness only if $q$ is absent from $T$. Otherwise the witness would contain a finite tree as a proper subtree of itself. This turns the occurs check into a restriction on the syntax of an unknown answer.

**Round 15 update.** Even fully constructor-free input is undecidable when the number of branches is unrestricted. [Flat reduction and multiplication proof](round-15-constructor-free.html)

## 1. What a branch requires

An instance consists of branches $D_i\Rightarrow C_i$ over a common tuple of variables. Premises and conclusions are finite conjunctions of first-order equations. An answer is a conjunction of equations, possibly using fresh variables. For each branch, the answer must admit at least one ground assignment satisfying $D_i$. Every such assignment must satisfy $C_i$.

Equivalently, an answer is a tuple of patterns $P$ over fresh parameters. Grounding the parameters gives all rows of the answer. For the equivalence, take a most general unifier of the answer equations, read off the terms for the instance variables, and rename their residual variables while preserving sharing. Conversely, the equations $v=P_v$ present any tuple pattern. [Round 10, Lemma 4.1](round-10-witness-generalization.html#pattern-answers)

## 2. Compiling one unknown operation into branches

The source problem has first-order unknowns $X=(x_1,\ldots,x_n)$ and one unknown $k$-ary term operation $F$. The input consists of first-order equations $E(X)$ and evaluation requests

$$F(s_{i1}(X),\ldots,s_{ik}(X))=t_i(X).$$

A solution chooses a ground tuple $d$ and a finite term $B(\xi_1,\ldots,\xi_k)$ over the constructors and formal holes. Holes may occur anywhere, any number of times. We require $E(d)$ and $B(s_{i1}(d),\ldots,s_{ik}(d))=t_i(d)$ for every request.

This is an interpolation form of second-order unification. To flatten a general equation, replace each application of $F$ bottom-up by a fresh first-order data variable, and add one evaluation request equating that application on its flattened arguments to the new variable. Put the resulting first-order equation in $E$. A solution extends by assigning each fresh variable its subterm value. Substitution in the opposite order recovers the original equation. There is one request per application. A closed assignment suffices because any residual free unknowns can be grounded. [Levy and Veanes, §§2 and 5, especially Lemma 8](https://www.microsoft.com/en-us/research/wp-content/uploads/2000/01/1-s2.0-S0890540100928773-main.pdf)

Keep the data coordinates $X$, add $k$ coordinates $h_1,\ldots,h_k$ for the arguments, and add $y$ for the body. Write $K(X)=f(x_1,f(x_2,\ldots,f(x_n,a)\ldots))$, with $K()=a$, and $W(t)=f(t,a)$. Compile the instance as follows.

| Branch | Premise | Conclusion |
|---|---|---|
| Pin | $\bigwedge_{j=1}^k h_j=a$ | $E(X)$ |
| Scope | $\bigwedge_{j=1}^k h_j=W^j(K(X))$ | $\top$ |
| Evaluation $i$ | $\bigwedge_{j=1}^k h_j=s_{ij}(X)$ | $y=t_i(X)$ |

All entries in the table expand into first-order equations in the fixed signature. The input names neither the parameters of an answer nor the operation being synthesized.

**Guard lemma.** In every answer, each $P_{h_j}$ is a bare parameter $q_j$. The $q_j$ are distinct, and none occurs in any $P_{x_\ell}$.

*Proof.* At a witness for the pin, $P_{h_j}$ takes the value $a$. At a witness for scope it has root $f$. Only a parameter admits both roots. Use a single scope witness for all $j$. If $K(X)$ has $N$ nodes there, $q_j$ has $N+2j$ nodes. The sizes distinguish the parameters. Each data value is a subtree of $K(X)$, so it has at most $N$ nodes. An occurrence of $q_j$ in a data coordinate would put its larger value inside that smaller tree. $\square$

**Reduction theorem.** The source instance has a solution exactly when its compiled branches have an ordinary JCA answer.

*From a solution to an answer.* Set $P_X=d$, $P_{h_j}=q_j$ for fresh distinct parameters, and $P_y=B(q_1,\ldots,q_k)$. For the pin and scope choose the values their premises prescribe. At an evaluation branch, assigning $q_j=s_{ij}(d)$ witnesses consistency. Every assignment satisfying its premise gives precisely that evaluation of $B$, so its conclusion holds.

*From an answer to a solution.* Take the parameters from the guard lemma. Ground every other parameter to $a$. The data coordinates now give a single ground tuple $d$ for every choice of the $q_j$. In $P_y$ rename the $q_j$ to formal holes $\xi_j$ and use the same grounding elsewhere. Call the resulting term $B$. Set every $q_j$ to $a$ to obtain $E(d)$ by the pin. For request $i$, set $q_j=s_{ij}(d)$. These choices satisfy the whole premise, so relevance gives $B(s_{i1}(d),\ldots,s_{ik}(d))=t_i(d)$. This constructs all source witnesses from the same answer. $\square$

## 3. Undecidability and branch bounds

Levy and Veanes prove undecidability for a single unary second-order variable, including a signature with one binary symbol and one constant. This already proves undecidability here with one formal coordinate $h$. For a one-constant source, any decoded solution using the additional constant $b$ yields a source solution by replacing $b$ everywhere with $a$. This homomorphism fixes the input and commutes with evaluation of a body. [Levy and Veanes, Corollary 11 and the signature remark immediately following it](https://www.microsoft.com/en-us/research/wp-content/uploads/2000/01/1-s2.0-S0890540100928773-main.pdf)

A different family in the same paper comes from acceptance by a fixed universal Turing machine. It has one second-order variable of bounded arity with at most five occurrences. Its arguments are ground and of bounded depth. The authors also give the fixed-signature sharpening. Flattening preserves these arguments and adds at most five evaluation branches. The two guards bring the total to at most seven. The source reduction gives hardness for recursively enumerable sets. Membership follows by enumerating finite answer patterns and checking each branch by first-order unification. [Levy and Veanes, Theorem 14 and Corollaries 15–16(a)](https://www.microsoft.com/en-us/research/wp-content/uploads/2000/01/1-s2.0-S0890540100928773-main.pdf)

**Four branches with two informative evaluations.** Ganzinger, Jacquemard and Veanes give a hard equation with two occurrences of one second-order variable. It uses a larger constructor signature. The protected encoding in the [four-branch proof](round-14-four-branches.html) translates its two requests into the fixed binary signature while retaining their count. The two requests can be written without separate data equations, leaving both setup branches with conclusion $\top$. The same companion proof gives three branches over one binary constructor with a larger fixed set of constants. The ground-argument seven-branch family above has a separate source.

## 4. Consequences and scope

- There is no computable worst-case bound on the size or depth of a smallest successful family of ground branch witnesses as a function of input size. Such a bound would let the finite hull search terminate on every instance. The same reasoning applies to normalized answer-pattern size or depth, allowing for renaming of the finitely many leaf positions. [Round 10, §6.4](round-10-witness-generalization.html#the-exact-missing-boundedness-statement)
- All input terms can be made depth at most one, preserving the branch count. Introduce a variable for each compound subterm and put the common acyclic definitions in every premise. Constructor-free inputs and the case of two *total* branches remain separate questions. [Round 11, Proposition 6.1](round-11-witness-bounds.html#shallow-syntax-is-a-normal-form-not-a-restricted-fragment)
- The parameter-free prefix problem specified in Round 10 is undecidable. Use the all-existential instance prefix. A pattern answer $V=P(Q)$ satisfies $\forall Q\,\exists V.\ V=P(Q)$. This proves the same lower bound for a prefix formulation that includes this subcase with the same admissible answers. Additional application-specific restrictions on answers require their own embedding. [Round 10, §2.2](round-10-witness-generalization.html#prefix-variants-are-not-interchangeable)

## 5. Verification and guard counterexamples

[The Lean proof](round-14-reduction.lean) checks the guard lemma and both directions of the reduction for arbitrary $n,k$, lists of equations and lists of requests. The definition of a passing branch contains both the existential consistency test and the universal relevance test. The final theorem, `equational_reduction`, uses arbitrary finite conjunctions of equations with fresh auxiliary variables. Its proof avoids assuming a unification theorem. Choose one full ground witness for each branch, including its auxiliary variables. Generalize these rows simultaneously, giving identical disagreement columns the same parameter. This generalization commutes with every constructor, so each answer equation that held in every row holds identically in the resulting pattern. Projecting to the instance coordinates retains all the witnesses. The published source hardness results and the four-branch signature change are the mathematical steps surrounding the Lean reduction.

Run from the repository root with Lean 4.19.0 and Python 3.9 or later.

~~~sh
lean projects/jca/agent-collab/round-14-reduction.lean
python3 projects/jca/agent-collab/round-14-experiments.py
~~~

The kernel reports only the standard axioms `propext`, `Classical.choice`, and `Quot.sound` for both `JCA.reduction` and `JCA.equational_reduction`. The [Python checks](round-14-experiments.py) use the earlier equational-answer checker. They enumerate 8,000 shallow answer tuples on one test, recover valid source solutions from all 24 accepted tuples, and check duplication, deletion, distinctness, and a parameter hidden inside a data term.

The guards also have short independent counterexamples.

- **Omit scope.** Ask for $F(a)=X$, $F(b)=X$, $F(a)=a$, and $F(b)=b$. A global $X$ would have to equal both constants. The tuple $P_h=P_X=P_y=q$ passes every evaluation and the pin. Scope rejects it because $q$ would occur inside its own value.
- **Omit the pin.** Ask for $F(f(a,a))=a$ and $F(f(b,a))=b$, with no data. A constant body cannot give two distinct results. A hole or an $f$-rooted body gives a compound result on these inputs. Yet $P_h=f(q,a), P_y=q$ passes both evaluations and the scope branch. The pin rules out that projection of the left child.
