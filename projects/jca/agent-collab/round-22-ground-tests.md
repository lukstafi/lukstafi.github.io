---
title: "JCA Round 22: Testing an output against a ground tree"
date: 2026-11-21
---

With one branch and prefix $\exists X\,\forall H\,\exists Y$, input-only premises give a P-complete problem over branching signatures. Allow the premise to be just **one equation $y=G$**, where $G$ is a ground tree supplied with the instance. Answer existence is then **NP-complete**, already with one binary constructor and one constant. The result also holds with no initial data if additional existential outputs are available. The ground tree in the one-test reduction grows with the instance. If both its size and the number of tests are bounded in advance, the three-block problem stays in P. [Input-only classification](round-20-one-branch.html#when-two-unifications-suffice)

## A certificate for ground-tested outputs

Use one arbitrary equational implication with initial existential data, universal inputs and interleaved existential outputs, under the parameter-free prefix convention of Round 20. An output is **asymmetric** if its occurrences on the two sides of some premise atom have different tree positions. Suppose the most general unifier of the premise assigns **every asymmetric output** $y$ a ground tree $G_y$. This includes explicit ground tests, and allows other premise equations to imply those tests. A symmetric output can be replaced by any constant on both sides of each premise equation without changing its truth, since each replaced occurrence faces the identical output. [Occurrence test and one-branch strategy form](round-21-one-input.html#deciding-if-one-input-can-be-isolated)

**Theorem.** This fragment is in NP, including when the inferred ground trees are given by shared directed acyclic graphs.

Take a term strategy and one joint witness of its premise. The body for a pinned output $y$ must evaluate to $G_y$ there. It is therefore $G_y$ with some disjoint subtrees replaced by earlier public input names. Conversely such a body evaluates to $G_y$ exactly when every inserted input has the ground value of the subtree it replaced. If an input name occurs several times in one body, consistency forces the replaced subtrees to be identical. Retain only one occurrence of that name and put the ground subtrees back at its other occurrences. This preserves the equality test $y=G_y$ at every input. On its active set it preserves the value of $y$ in every other premise and conclusion equation. Formally, conjoin the entailed tests $y=G_y$ to $D$ before performing the replacement. This proves that one retained occurrence per input per body suffices.

For each pinned $y$, guess a set of its earlier input names and one position in $G_y$ for each selected name. Check that these positions are pairwise incomparable by the prefix order within that body. For choice $(h,p)$, conjoin $h=G_y|_p$ to the premise. Replace pinned outputs everywhere by their ground values, erase symmetric outputs from the premise, and remove the pinned output moves from the prefix. What remains is an input-only instance of Round 20. Its solutions extend by the guessed bodies, and the preceding reduction preserves a successful term strategy whenever one exists.

There are at most $|H||Y|$ guessed paths, each at most the depth of a unifier DAG. Following each path and checking disjointness takes polynomial time. The input-only decision then has a polynomially checkable certificate. With all inputs before all outputs, this last test is deterministic polynomial time. If the total *expanded* size of the ground tests is bounded by a fixed $k$, there are at most $(|H|+1)^k$ choices of markings. This gives the stated polynomial bound for a fixed test size.

## When the initial data determine the test

The same NP upper bound holds on branching signatures when every asymmetric output is determined by the **chosen initial data** on the premise. This permits unbounded test trees. To recognize the condition, write $Z$ for the residuals in $\mu(X)$ and check that each asymmetric $\mu(y)$ has residuals only in $Z$. For fixed realizable data, each member of $Z$ has a fixed value at a subtree of the data. The premise therefore pins $y$ to the ground instance of $G_y(Z)=\mu(y)$. Conversely a residual outside $Z$ can be varied with the data held fixed.

Introduce $Z$ as fresh initial data and require $X=\mu(X)(Z)$ in the input-only premise. As above, guess which earlier names $h$ occur in the body for each pinned $y$. For each name used anywhere introduce a ground data coordinate $v_h$ and include the test $h=v_h$ in the new premise. Substitute $G_y(Z)$ for the pinned outputs in $D,C$ and erase symmetric outputs from $D$. The additional constraint on the **chosen data** is that the selected values $v_h$ for each one body have occurrences at pairwise incomparable positions in $G_y(Z)$. If the constraint holds, replace those occurrences by the input names to recover the body. Duplicate uses can be dropped for the same reason as with literal pins. These existence constraints on data must be imposed outside the implication.

For example, take $\exists d\,\forall h,k\,\exists y$ and the sole premise $y=d$. The conclusion $h=f(a,a)\land k=a$ admits $d=f(f(a,a),a)$ and $y=f(h,k)$. If the conclusion instead requires $d=f(a,a),\ h=d,\ k=a$, it is impossible. The required occurrence for $h$ would occupy the root of $d$, leaving no disjoint occurrence for $k$. Each required value individually is a subtree.

The disjoint occurrences have an existential description using ordinary equations and the non-strict subtree predicate $s\sqsubseteq t$. For one value require just $v_h\sqsubseteq G_y(Z)$. For several, guess the tree formed by their lowest common ancestors. At each branching point guess an ordinary constructor, name its children by fresh variables, and place the roots of its different groups in distinct children using $\sqsubseteq$. Require the top branching point to be a subtree of $G_y(Z)$. A group of size one ends at its selected value. There are at most as many branching points as values minus one. This description enforces distinct *positions* even when two selected values happen to be equal.

Use this description together with the input-only NP computation. Round 20's guesses yield ordinary equations and the requirement that the remaining data variables have pure ground values. Apply its final unifier and reject any violation of purity. All newly added subtree constraints now mention only ordinary terms over the remaining pure variables. The finite-subterm replacement in Round 20 changes only output residuals outside the data, so it preserves these constraints. A satisfying ground assignment of the final existential equations and subtree tests completes the certificate.

For completeness, this last positive theory has polynomial-size ground DAG witnesses on every branching signature. In any solution take the distinct values of all syntactic nodes of the final constraints. Build replacements in increasing subtree order. For a value represented by a constructor node, retain its constructor on the replacements of its children. For a value represented only by variables, use a binary constructor (padded if necessary) to pack the replacements of all its observed strict subvalues as proper subtrees, or use a constant when there are none. Inductively each observed subtree relation survives. At a constructor, any strict subvalue lies in some child, whose value is also observed. Equal values have one replacement. With $N$ observed values the new DAG has $O(N^2)$ nodes, and both equality and subtree reachability can be checked there in polynomial time. Venkataraman gives the NP result for the full existential language of binary trees with subtree. [Venkataraman, *Decidability of the Purely Existential Fragment of the Theory of Term Algebras*](https://doi.org/10.1145/23005.24037)

## One literal can carry a graph coloring

Use three distinct ground colors $c_1,c_2,c_3$ and a ground marker $K$ taller than every $f(c_i,c_j)$. Encode an ordered pair by

$$E(s,t)=f(K,f(s,t)).$$

Use ordinary $f$-lists ending at $a$. Let $P$ be the fixed six-entry list of $E(c_i,c_j)$ for $i\ne j$. For a graph with $m$ edges, let the one tested literal $G$ be the list of $m$ copies of $P$. Its only subtrees of the form $E(s,t)$ encode distinct colors. Indeed the marker cannot contain itself properly, the colors are shorter, and the left child of each list cell is an encoded entry or a palette, each larger than $K$.

Choose initial data $x_v$ for vertices. Use one universal input $h_e$ per edge, all before the single existential output $y$. For the edge $e=vw$ add one conclusion equation. The entire branch is

$$y=G\quad\Rightarrow\quad \bigwedge_{e=vw} h_e=E(x_v,x_w).$$

Given a coloring, fix the data to its colors. In the palette block for edge $e$, replace the corresponding encoded pair by $h_e$. Use this modified list for the body of $y$. Equality to $G$ pins each $h_e$ to the intended ordered pair. These pins are jointly satisfiable and imply every conclusion.

Conversely, take a successful term strategy and a joint witness. Every $h_e$ must occur in the body for $y$. Otherwise changing just that input to $a$ retains the premise and violates its conclusion, whose right side has root $f$. At the witness, the value of every used input is a subtree of $G$. The conclusion identifies that value with $E(x_v,x_w)$. Inspection of the palette forces both endpoint values to be colors, and the two colors to differ. The witness colors every non-isolated vertex. Give isolated vertices any color. The construction takes linear size in the graph for this fixed palette. For any higher-arity branching constructor, pad its extra arguments with $a$. [Garey, Johnson and Stockmeyer, graph 3-colorability](https://doi.org/10.1016/0304-3975%2876%2990059-1)

The same proof works when the $x_v$ are existential outputs after the universal inputs. If $h_e$ is absent from the tested body, setting it to $a$ violates the required constructor root whatever the other output strategies do. One joint witness again gives a coloring. With several tested outputs one can instead use **the same fixed literal $P$ for every graph**, one equation $y_e=P$ per edge. Both versions grow the total size of the tests.

## Verification and limits

The [reference implementation](round-22-ground-tests.py) covers the literal and implied-ground cases. It recognizes implied ground tests, enumerates incomparable occurrence positions, and reconstructs checked term strategies for the original equations. It compares all 72 single-pin, single-conclusion instances in the two-constant algebra with two inputs and two outputs against exhaustive strategies. The separate coloring check reads the allowed pairs from the actual palette tree, recovers a strategy for each colorable four-vertex graph, and checks its active-input unifier. The adjacent notes cover one universal with arbitrary output tests and the two-branch undecidability result. [One universal](round-21-one-input.html) · [Two branches](round-19-designated-parameters.html#the-prefix-replaces-the-scope-branch)

The data-determined extension above is a reduction on paper. If an output can vary on the premise even after the initial data are fixed, its inferred pattern can depend on active inputs. Replacing repeated input occurrences by ground subtrees then need not preserve the active inputs. The later general proof bounds the strategy by compressing a single witness and its unification paths. [Arbitrary output-dependent premises](round-29-small-dags.html)

~~~sh
python3 projects/jca/agent-collab/round-22-ground-tests.py
~~~
