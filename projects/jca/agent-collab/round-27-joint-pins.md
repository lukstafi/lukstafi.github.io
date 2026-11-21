---
title: "JCA Round 27: A conclusion can bound the search for an output strategy"
date: 2026-11-21
---

Consider one equational implication \(D\Rightarrow C\) with initial data, universally chosen inputs and existential outputs. The moves may interleave. There are no designated parameters. A successful strategy must admit at least one input satisfying \(D\), and at every such input it must satisfy \(C\). Thus any witness for a successful strategy also satisfies \(D\land C\). The conclusion can bound the size of an output strategy even when the premise permits every output value.

**Theorem.** Suppose every output used asymmetrically in the premise has a ground value in the most general unifier of \(D\land C\). One-branch existence is decidable. It is in NP when these values, expanded as trees, have polynomial total size. Already with the fixed premise \(y=z\) comparing two existential outputs and a single literal \(y=G\) in the conclusion, the problem is NP-complete over one binary constructor and one constant. Here \(G\) is an explicitly written ground tree, and other conclusion equations are allowed. All universals can precede all outputs.

## Guess the body seen at a joint witness

Compute a most general unifier \(\lambda\) of \(D\land C\). Failure rules out a witness. An output \(y\) is asymmetric if it occurs at different sets of positions on the two sides of some premise equation. Write \(G_y=\lambda(y)\). At a witness of a successful term strategy, a ground \(G_y\) is the value of its body \(B_y\). Consequently \(B_y\) is \(G_y\) with disjoint subtrees replaced by names of inputs preceding \(y\). The same name may occupy several positions. [Term-strategy characterization](round-20-one-branch.html#one-witness-determines-the-strategy-form)

Guess these replacements for every asymmetric output. Substitute the resulting **bodies** into both \(D\) and \(C\). Erase all other outputs from \(D\) by replacing their occurrences on both sides by a fixed constant. Those occurrences face identical output leaves, so erasure preserves the truth of each equality. The remaining premise mentions only data and inputs. Apply the input-only solver with the original order of the remaining moves. A returned strategy extends by the guessed bodies. Conversely the bodies at the witness of any successful strategy occur in this enumeration. [Input-only algorithm](round-20-one-branch.html)

Retaining the actual bodies in the premise matters. For example, take

$$
\forall h,k\,\exists y,z.\qquad y=z\quad\Rightarrow\quad y=a\ \land\ h=a\ \land\ k=a.
$$

At its required witness each body for \(y,z\) evaluates to the atom \(a\). Its only possible forms are \(a,h,k\). One equality between two such forms cannot force both inputs to \(a\) in a nontrivial ground algebra. Adding \(y=a\) to the premise admits \(y=h,z=k\), whose original active inputs include the entire diagonal.

## Joint values with free subtrees

There is a decidable extension even when the joint unifier leaves an output value unbounded. For every asymmetric \(y\), require that **each residual variable in \(\lambda(y)\) occurs in \(\lambda(h)\) for every input \(h\) preceding \(y\)**. Ground joint values satisfy the condition vacuously. Use an idempotent unifier, and count an unbound coordinate as its own residual.

To see what this condition buys, write a joint witness as \(\lambda\theta\). If an occurrence of \(h\) in \(B_y\) were rooted strictly inside a residual value \(\theta(r)\) in \(\lambda(y)\theta\), then \(\lambda(h)\theta\) would be a proper subtree of \(\theta(r)\). But \(r\) occurs in \(\lambda(h)\), so \(\theta(r)\) is itself a subtree of \(\lambda(h)\theta\). Finite-tree size excludes this. Every input occurrence in the body is therefore rooted at a syntactic position of \(\lambda(y)\), possibly at a residual leaf.

Give each residual in these output patterns one fresh initial datum. Guess disjoint cuts in the finite pattern \(\lambda(y)\), replacing each cut subtree by an earlier input and each uncut residual leaf by its fresh datum. Run the same input-only procedure. The original joint witness supplies the extra data in the completeness direction. In the soundness direction, substitute the chosen ground data into the returned bodies. The solver has checked the original premise and conclusion with exactly these bodies. For example, \(y=z\Rightarrow y=f(h,k)\land h=k\), with both inputs preceding both outputs, has joint output pattern \(f(k,k)\). Both input values contain its residual. The strategies \(y=f(h,k)\) and \(z=f(k,h)\) satisfy the implication.

For a fixed finite signature, the joint unifier has a polynomial-size DAG. Its expansion has at most exponential size. Guessing the cuts and running the NP input-only check therefore gives a nondeterministic exponential-time upper bound on the entire extension. When the expanded output patterns have polynomial total size the same argument gives NP. For a fixed total expanded size and three quantifier blocks \(\exists X\,\forall H\,\exists Y\), enumerate the polynomially many choices of cuts and labels and use the polynomial input-only solver.

## NP-hardness with the fixed premise \(y=z\)

Use the graph-coloring palette from Round 22. Fix three ground colors and a tagged binary term \(E(s,t)\) for an ordered pair. A fixed palette tree contains exactly the six distinct-color pairs as subtrees of this tagged form. For a graph with \(m\) edges let \(G\) be a list of \(m\) copies of the palette. Its tagged pairs still have exactly those six values. Use a data coordinate \(x_v\) for each vertex and a universal \(h_e\) for each edge. The two outputs \(y,z\) follow all inputs. The single branch is

$$y=z\quad\Rightarrow\quad y=G\ \land\
  \bigwedge_{e=uv} h_e=E(x_u,x_v).$$

A coloring gives a strategy. Set \(z=G\). In the body for \(y\), replace the appropriate pair in edge \(e\)'s palette block by \(h_e\). The premise holds precisely at the tuple of prescribed edge values.

Conversely, in a successful strategy each \(h_e\) must occur in at least one of the two tested bodies. Otherwise changing it to the atom \(a\) preserves the premise at a witness and violates its constructor-headed conclusion. At a joint witness both bodies evaluate to \(G\), so \(h_e\) must be a subtree of \(G\). Its conclusion forces that subtree to be one of the six pairs. The witness values of the incident vertices therefore give a coloring. The same argument works with the vertex coordinates as additional outputs after all inputs, since the right side for each edge always has a constructor root. The unifier of \(D\land C\) grounds both asymmetric outputs to the single written tree \(G\), giving the NP upper bound. [Palette construction and verification](round-22-ground-tests.html#one-literal-can-carry-a-graph-coloring)

The [reference solver](round-27-joint-pins.py) enumerates the markings, calls the input-only solver, and checks each reconstructed strategy against the original implication. It compares 144 finite-algebra instances against direct exhaustive strategy search under two quantifier orders and checks branching and residual examples. If a witness can place an input occurrence arbitrarily deep inside a free joint residual, the finite-position argument does not apply. Rounds 28 and 29 handle that case by retaining the paths inspected by unification. [General one-branch bound](round-29-small-dags.html)

~~~sh
python3 projects/jca/agent-collab/round-27-joint-pins.py
~~~
