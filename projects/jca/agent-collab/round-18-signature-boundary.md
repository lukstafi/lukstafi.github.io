---
title: "JCA Round 18: The constructor arity boundary"
date: 2026-11-21
---

**Theorem.** Fix a finite, single-sorted ranked signature with at least one constant. Ordinary equational JCA answer existence over its finite ground trees is decidable if every constructor has arity at most one. If some constructor has arity at least two, the problem is r.e.-complete with three branches and a fixed number of coordinates.

On the decidable side, any number of unary constructors gives a PSPACE upper bound. With exactly one unary constructor the problem is NP-complete, even with just one constant. With only constants it is NP-complete for two or more constants, and trivial for one. The general unary problem can express satisfiability of systems of word equations over its constructor alphabet.

Round 25 sharpens the branching lower bound to two ordinary branches over every branching signature. [Exact threshold](round-25-binary.html)

## 1. Unary trees are words with a leaf

Let $\Gamma$ be the alphabet of unary constructors and $C$ the set of constants. A term is uniquely $w\ell$ with $w\in\Gamma^*$ and $\ell$ a variable or a constant. Composition of constructor prefixes is word concatenation, written in outermost-first order.

An ordinary equational answer on $n$ coordinates is a tuple of patterns $P_x=W_x e_x$. Guess each leaf $e_x$ from $C\cup\{p_1,\ldots,p_n\}$, sharing equal parameters across coordinates. There are enough parameters because each coordinate has one leaf. Leave each word $W_x$ unknown. An input occurrence $vx$ now reads $vW_x e_x$, and a literal term $vc$ keeps its literal prefix and constant. The same $W_x,e_x$ are used in all branches. [Tuple-pattern characterization](round-10-witness-generalization.html#pattern-answers)

## 2. Check a branch with existential word equations

Fix a branch $D\Rightarrow C'$. Its premise must have a ground instance and its conclusion must hold at every such instance. We construct a symbolic most general unifier of the premise. Start with no bindings on the parameters $p_j$ and process the equations of $D$ in input order. Apply all bindings already recorded to the two sides. Write the result as $A e=B d$, where $A,B$ are concatenations of letters and word unknowns.

- If $e=d$, record the word equation $A=B$. Equality at a common tail requires equality of the prefixes by right cancellation, even when the common leaf is a free parameter.
- If $e\ne d$, choose a direction in which the shorter side ends in a parameter. For example, if that side is $Ae$ with parameter $e$, introduce a fresh word unknown $U$ and record $AU=B$. Bind $e$ to $Ud$. The reverse direction is also available when $d$ is a parameter. The empty remainder $U$ is allowed. Distinct constant leaves give no choice.

Finish by applying the bindings to each conclusion equality. Its two sides must have the **same** remaining leaf. Require equality of their word prefixes. Repeat independently for every branch, retaining all the word equations produced along one complete choice of orientations.

*Soundness.* Fix a solution of the word equations. In the second step cancellation leaves exactly $e=Ud$. Both leaves had already been normalized. They are distinct, so this binding passes the occurs check and eliminates one parameter. In the first step an identical prefix reduces the equation to an identity. Thus all the bindings together are a most general unifier. Assign any ground value to every remaining parameter to witness consistency. The final equalities hold under every such assignment by construction.

*Completeness.* Start with any answer and its actual prefix words. For a solvable premise, the two known prefixes of each equality are prefixes of the same ground word, so one extends the other. A strict extension requires the shorter side to have a parameter leaf. Equal prefixes with different leaves allow either variable to be eliminated if both are variables. Taking the actual suffix as $U$ follows a permitted choice and produces the ordinary unifier. A consequent valid on every specialization of that unifier must be syntactically identical on both sides. In a unary algebra with at least one unary constructor, distinct free tails can be given independently chosen lengths, and a free tail opposite a constant can be varied. With a common tail, words cancel on the right. Distinct constant leaves cannot coincide. This proves the stated test. $\square$

If there are only constants, there are finitely many tuple patterns up to renaming and each can be checked directly. A one-element algebra satisfies every equality.

Each orientation eliminates a parameter or discharges an equation. A recorded binding prefixes its tail by **one** fresh word variable, so the normalized prefix of an occurrence has at most $n$ added symbols. A guessed trace has polynomial total size. Its finite system of word equations is decidable in polynomial space. Multiple equations can be joined by a fresh separator, with variables restricted to the original alphabet, or handled by a solver for systems directly. Nondeterministic polynomial space equals PSPACE. [Diekert, Jeż and Kufleitner, algorithm for systems of word equations](https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.ICALP.2016.127) · [Jeż, word equations in linear space](https://arxiv.org/abs/1702.00736)

## 3. Word equations embed back into unary JCA

Choose a unary letter $g$ and a constant $a$. Two consistency guards $h=a$ and $h=g(a)$ force $P_h$ to be a bare parameter $p$, since the two prescribed roots differ. The following two branches ensure that $P_y$ ends in this very parameter. The coordinate $z$ is private.

| Premise | Conclusion |
|---|---|
| $h=g(z)$ | $\top$ |
| $y=z$ | $h=a$ |

The first witness implies that $p$ is absent from $P_z$ by the occurs check. If $p$ were also absent from $P_y$, a witness of $y=z$ would still be a witness after setting $p=g(a)$, violating relevance. Conversely if $P_y=wp$, choose $P_z=wa$. The first branch can set $p=g(wa)$. In the second, cancellation of $w$ forces $p=a$.

Force two marker coordinates $h,k$ to be bare in this way and separate them by a guard $h=a\land k=g(a)$. For every named word $U$ allocate $U_h,U_k$ with the corresponding prescribed tails. Add $h=k\Rightarrow U_h=U_k$ for all $U$. At a witness their tails agree, so right cancellation makes their prefixes identical. Write this common word as $u$.

Encode a concatenation $UV=W$ by the one branch

$$h=V_k\quad\Rightarrow\quad U_h=W_k.$$

Its premise can set the parameter of $h$ to $v$ applied to the parameter of $k$. At that valuation the conclusion gives $uv=w$ by cancellation. If the word equation holds, every premise witness satisfies the conclusion. Literal words and equalities between words are unconditional equations, for instance $U_h=gh$ for the one-letter word $g$, or $U_h=h$ for the empty word. Naming partial products reduces any system of word equations to these forms in polynomial size. Conversely any word solution gives an answer using precisely those prefixes on the two markers. The private tests extend as proved above.

## 4. One unary constructor is NP-complete

On a one-letter alphabet, equality of words is equality of lengths. Every guessed system in §2 becomes a polynomial-size system of linear equations in nonnegative integers. A satisfiable system has a solution with polynomially many bits, giving NP membership. [Papadimitriou, *On the Complexity of Integer Programming*](https://publications.csail.mit.edu/lcs/pubs/pdf/MIT-LCS-TM-152.pdf)

For NP-hardness take a 3-CNF formula. Give each Boolean variable two word lengths $x,\bar x$ and require $x+\bar x=1$. They encode its truth value and its complement. In each clause require the sum of its three literal lengths to equal $1+d$ for a fresh nonnegative slack $d$. This holds exactly when at least one literal is true. The equations use concatenation, named intermediate sums and the one-letter literal from §3. This gives the lower bound with one constant and one unary symbol. It also gives NP-hardness in every nonempty unary alphabet: the equations forcing complementary words to concatenate to the chosen one-letter word force those words to be empty or that same letter.

## 5. Constants alone can enforce three colors

Over constants alone, tuple patterns consist of constants and bare parameters. Guessing a pattern up to parameter renaming and checking all branches by unification takes nondeterministic polynomial time when there are at least two constants.

For the matching lower bound fix two distinct constants $a,b$. Given a graph, create three palette coordinates $h_1,h_2,h_3$ and a coordinate $x_v$ for each vertex. Use one informative branch

$$h_1=a\land h_2=a\land h_3=a\quad\Rightarrow\quad\bigwedge_v x_v=a.$$

Add a consistency guard $\bigwedge_v x_v=b$, and a guard $x_u=a\land x_v=b$ for each edge $uv$, oriented arbitrarily. Each vertex takes both constants, so its coordinate must be a bare parameter. At the informative premise each palette coordinate is either $a$ or a bare parameter. Any vertex parameter other than these palette parameters could be changed to $b$ while the premise stayed true. Thus every vertex uses one of at most three parameters, and each edge guard separates its endpoints. Conversely, a proper three-coloring gives an answer by using three distinct parameters for the palette and assigning each vertex its color's parameter. This reduces graph three-colorability with just one informative branch. With one constant and no other constructor every instance has an answer.

## 6. Every branching signature inherits the lower bound

The [three-branch theorem](round-17-three-branches.html#one-constant-suffices) supplies hard inputs and a two-call interpolation encoding over $\{f/2,a\}$. For a new signature choose a constant $c$ and a constructor $H$ of arity $k\ge2$. Translate $a$ to $c$ and $f(u,v)$ to $H(u,v,c,\ldots,c)$, recursively. Keep the same branches and variable names.

A source answer from the reduction translates directly using its canonical ground data and its body on the bare formals. Every target valuation satisfying a translated evaluation premise provides exactly the displayed argument values at those formals. The output equality follows by substitution in the translated body; the scope premise has its usual witness.

For the converse, the translated scope guard again forces distinct bare formals absent from the data. Its witness has strictly increasing sizes, and each formal is a constant at one evaluation. We therefore recover a target interpolation solution, allowing **all** constructors of the new signature in its data and body. Map a ground target value or body back by interpreting $c$ as $a$, $H(t_1,\ldots,t_k)$ as $f(D(t_1),D(t_2))$, and every other symbol as the constant $a$. Keep every formal hole. This interpretation commutes with plugging data into a body and is a left inverse on translated constructor expressions. Both target requests consequently decode to the original binary requests on a single body and a single data tuple. Round 17 recovers the hard source instance. The branch and coordinate counts are unchanged. Finite-answer enumeration gives the r.e. upper bound.

## 7. Parameter-free quantifier prefixes

For the version fixed in Round 10, the extra condition on a presentation $A(X,B)$ of the answer is $\forall B\;QX.\,A(X,B)$. Relevance and consistency still refer to ordinary ground assignments. There are no designated invariant parameters. The same arity classification and the same upper bounds hold for this problem. [Definition of the variant](round-10-witness-generalization.html#prefix-variants-are-not-interchangeable)

**Pattern criterion.** Assume the ground algebra has at least two elements. An ordinary answer relation given by a tuple pattern $P$ admits a presentation satisfying the extra condition exactly when:

1. Each universal coordinate $u$ in $Q$ has $P_u$ equal to a bare parameter $p_u$, distinct for different universals.
2. For every existential $e$ preceding $u$, $p_u$ is absent from $P_e$.

*Necessity.* Fix the fresh variables of any valid presentation to one ground tuple. The prefix must still be able to play every choice of the universal values, with resulting instance tuples in the projected relation $\operatorname{Inst}(P)$. A constant or compound coordinate misses at least one ground value. Shared universal parameters would prevent different choices at the two coordinates. If an earlier existential pattern contained $p_u$ at an address, its selected ground value would determine $u$ at that address before $u$ is played. Choosing a different value for $u$ then defeats the prefix.

*Sufficiency.* Replace every universal parameter $p_u$ in the existential patterns by the **original variable** $u$. Retain all other parameters as fresh leading variables $B$. Present the relation by the equations $e=P_e$ after this renaming, one per existential. The original universal coordinates require no equations, and the ordinary projected relation is exactly $\operatorname{Inst}(P)$. For every assignment of $B$, choose each existential as the value of its right-hand side at its turn. Only earlier universal moves can occur there, so the strategy works under $Q$. This choice of presentation avoids imposing a new leading universal on a coordinate already universal in $Q$. $\square$

For unary terms, require $W_u$ empty, require $e_u$ to be a parameter, and exclude its leaf from all earlier coordinates. These are just equations of words and finitely many tests on the guessed leaves. The lower bounds carry over with all-existential prefixes; the one-element case remains immediate. This result uses the stated parameter-free validity condition. Round 19 treats designated invariant parameters and explicit atomwise escape tests under both fresh-parameter conventions. [Designated-parameter proof](round-19-designated-parameters.html)

## 8. Verification

[Lean proof of the unification step](round-18-proof.lean). For arbitrary word values it checks prefix comparability, both cancellation rules, and that the proposed substitution describes exactly the solutions of each variable binding. The composition of these steps and the arity classification are proved above.

[Executable word-equation reduction](round-18-monadic.py). The generator emits the finite choices and the corresponding conjunctions of word equations. Its checker instantiates the answer-prefix variables, reconstructs each residual by cancellation, and compares acceptance with independent finite-tree unification. It checks 4,704 patterns involving distinct unary letters, shared tails, cyclic premises and unconditional conclusions. A reverse compiler checks 64 concatenation cases, including empty and noncommuting words. The three-color construction passes on every four-vertex graph except the complete graph. Another 1,000 checks compare the prefix criterion with explicit quantifier games over two constants. The unbounded decision in §2 uses the cited word-equation algorithm.

~~~sh
python3 projects/jca/agent-collab/round-18-monadic.py
lean projects/jca/agent-collab/round-18-proof.lean  # Lean 4.19.0
~~~
