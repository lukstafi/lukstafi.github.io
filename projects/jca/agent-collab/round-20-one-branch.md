---
title: "JCA Round 20: One implication under an alternating prefix"
date: 2026-11-21
---

Take one implication $D\Rightarrow C$ over finite ground trees. Quantify the initial existential data $X$ first. After that, universally chosen inputs $H$ may alternate with existential outputs $Y$ in any order. Suppose the premise mentions only $X,H$. The conclusion may mention all three sets. Both sides, and the answer sought, are conjunctions of equations. There are no designated invariant variables. Fresh variables are permitted in a candidate answer.

**Theorem.** One such implication is decidable. Over any finite single-sorted signature with a branching constructor and a constant, the problem is NP-complete. For the prefix $\exists X\,\forall H\,\exists Y$ it is P-complete. Two implications of this same input-only form with this same three-block prefix are already r.e.-complete. With only unary constructors and constants, the single-implication problem is in P for every prefix. [Two-branch reduction](round-19-designated-parameters.html#the-prefix-replaces-the-scope-branch)

For example, require $y=v$ whenever $u=f(v,a)$. With $\forall u\,\forall v\,\exists y$, the answer $y=v$ works. With $\forall u\,\exists y\,\forall v$, the value of $y$ must be a term in $u$. Such a term can copy $u$ whole or build around it. Neither operation returns its left child for every $v$. The decision procedure tracks exactly which whole input trees each output can use.

## One witness determines the strategy form

Write $H_{<e}$ for the inputs preceding output $e$. A **term strategy** consists of fixed ground data $d$ and one term $B_e(H_{<e})$ per output. It is a solution when $D(d,H)$ has some ground instance and $C(d,H,B(H))$ holds at every instance of $D(d,H)$.

Any term strategy gives the answer $X=d,\ e=B_e(H_{<e})$. Conversely, project a valid equational answer onto all public coordinates and take a tuple pattern for that projection. The pattern for each universal input must be a distinct bare parameter absent from all preceding coordinates. This follows by playing two different values of that input after fixing the preceding moves. A proper constructor at its root would exclude some input value, and sharing its parameter with a preceding coordinate would fix its value. This uses the nontrivial ground algebra. The singleton algebra admits the empty answer for every instance. [Prefix pattern criterion](round-18-signature-boundary.html#parameter-free-quantifier-prefixes)

Choose one ordinary joint witness for the answer and $D$. Specialize every pattern parameter except those bare input parameters to its value in this witness. The resulting tuple still includes the witness. It lies in the original answer relation, so every active instance satisfies $C$. Initial data are now ground. Each other existential coordinate is a term in the earlier inputs. This proves the characterization with either fresh-variable convention of Round 19 when there are no designated variables. Choosing the witness **from this branch** is essential. Different branches can require different specializations.

## Two unifications expose the inputs

Unify $D(X,H)$ with finite-tree occurs checks. Failure means the branch is inconsistent. Take an idempotent most general unifier $\mu$ using original names for residual variables. Include even unused inputs in the tuple $\mu(H)$. Separate its residuals into two groups.

- $Z$ consists of residuals appearing in the data tuple $\mu(X)$. When the data are chosen, each of these residuals is fixed by a subtree of a data coordinate.
- Treat every other residual as a new **rigid letter** $r$. For each one there is a public input $h$ with $\mu(h)=r$, since an unbound original variable outside the data is itself an input.

The active inputs and data now have the form $H=S(Z,r)$ and $X=A(Z)$. Each ground choice of $Z$ gives a nonempty active set. Holding $Z$ fixed, all assignments to the distinct $r$ occur, and they produce exactly the active inputs at those data.

In $C$, substitute $A,S$ for the data and inputs. Represent each expanded output $B_e(S_{<e})$ by its own first-order unknown $T_e$, shared between all occurrences of that output. Unify the resulting equations treating each $r$ as a distinct new constant. This tests equality as *terms* in $r$ because two different terms over a nontrivial free ground algebra can be separated by some assignment of their variables. At a differing position, distinct constructors disagree outright, distinct variables can be given different values, and a variable can be given a root different from a prescribed constructor. Reject failure. Also reject if the most general unifier $\nu$ puts any $r$ into a member of $Z$, since data must be ground over the original signature.

Write $G_h=\nu(S_h)$ for the resulting input templates and $L_e=\nu(T_e)$ for the required outputs. Every residual in the $G_h$ or data is **pure**, meaning that its value must be a ground tree over the original signature. Other residuals in the $L_e$ may have values containing rigid letters. After instantiating all residuals, the remaining condition is

$$L_e\ \in\ \langle\Sigma,\ G_h\ (h\in H_{<e})\rangle \qquad\text{for each } e.$$

The right side consists of trees built with ordinary constructors and the indicated whole input trees. An expression building $L_e$ gives $B_e$ by replacing each use of an input tree with its public input name. This constructs a total term on arbitrary inputs, including those outside $D$.

## A finite choice of subterms

Call a tree **mixed** if it contains a rigid letter. Fix any successful assignment of the residuals. For every mixed output residual $w$ whose value is a subtree of some instantiated $G_h$, retain its value. This value is an instance of a *syntactic subterm* of $G_h$ containing a rigid letter. A path to its root cannot enter a pure residual of $G_h$, since that entire subtree would then be pure.

Replace every remaining mixed residual by the same ordinary constant $a$. This preserves all membership conditions simultaneously. To see it, follow a construction of an output. Whenever the construction takes a whole generator, every slot occurring inside the matching part of the output template has value a subtree of that generator. All those slots keep their values. At a slot changed to $a$, construct $a$ directly. At an ordinary constructor continue into its children. A slot may occur several times, including in different outputs. The replacement rule uses the same value at every occurrence. The second unifier has already solved the conclusion equations, so specializing its residuals preserves those equations too. [Lean proofs of replacement and subterm origin](round-20-subterms.lean)

This gives a finite decision procedure.

1. For each output residual not forced pure, either declare it pure or substitute a mixed syntactic subterm of some $G_h$. The substitution is acyclic because the generators contain only forced-pure residual variables.
2. Check each output template recursively. A template containing no $r$ is constructible for every assignment of the pure unknowns. At a mixed template, either choose an earlier generator and record an equation equating it to this template, or build its ordinary outer constructor and check every child. A bare rigid letter can only take the generator option.
3. Unify all the recorded equations together. Reject a constructor clash, an occurs-check failure, or a pure variable forced to contain a rigid letter. Otherwise ground any unbound variables to $a$ and read off the term strategies.

The finite-subterm argument proves completeness. A successful computation constructs an answer and supplies an active instance, proving soundness. The mixed-subterm choice can be necessary. Under $\forall h\,\exists y\,\forall r\,\exists z$, take $D$ to be $h=f(r,f(r,a))$ and $C$ to be $y=f(r,z)$. Choosing $y=h$ forces $z=f(r,a)$, a proper subterm of the earlier generator. This value for $z$ can be built once $r$ has been played.

Use shared directed acyclic graphs for the polynomial certificate. The two unifiers and the substituted input and output templates occupy polynomially many nodes. Guessing each mixed subterm uses a node index. For each pair of an output scope and a reachable template node, guess one construction step. For fixed successful ground values the same construction can be reused whenever that pair recurs. Constructor steps descend in the acyclic graph. Generator choices yield polynomially many first-order equations checked together in polynomial time. This proves NP membership even when printing a witness as an unshared tree would take exponential space. [Paterson and Wegman, *Linear unification*](https://www.sciencedirect.com/science/article/pii/0022000078900430)

## When two unifications suffice

For $\exists X\,\forall H\,\exists Y$, every rigid $r$ occurs as a bare generator available to every output. As soon as the second unification succeeds and passes data purity, ground its remaining residuals to $a$. Build each output using ordinary constructors and the public inputs naming its rigid leaves. There are no guesses. In particular this computes the three-block decision directly, without first-order quantifier elimination.

The three-block problem includes ordinary finite-tree unifiability. Put the equations in $D$, quantify their variables as initial data, and take $C=\top$. For an explicitly nonempty alternating prefix add an unused input and output. Unifiability is P-complete under logspace reductions even for terms given with only leaf sharing. To work over $f/2,a$, encode each original constructor by a distinct ground tag paired with the list of its encoded children. Constructor clashes become tag clashes, decomposition recovers the corresponding child equations, and variable occurrences are preserved. These encodings are computable in logspace using a fresh data variable and a defining equation per input node if desired. For higher arity use $f(x,y)=F(x,y,a,\ldots,a)$. This gives P-completeness on every branching signature. [Dwork, Kanellakis and Mitchell, *On the Sequential Nature of Unification*](https://groups.csail.mit.edu/tds/papers/Dwork/journal-logic-programming.pdf)

For an arbitrary prefix on a **monadic** signature, every term is one word followed by one leaf. After the second unification, ground all residuals to $a$. An output ending in a residual is then pure. An output ending in a rigid letter was already a fixed word on that letter, independent of any residual assignment. It can be built exactly when some available generator is a suffix ending in the same rigid letter. A generator with a residual leaf stays pure. Thus one can check all the outputs in polynomial time, including with several unary symbols or only constants.

## One late universal gives NP-hardness

Use $f/2,a$ and pick three distinct ground trees $c_1,c_2,c_3$. For a graph introduce initial data $x_v$ for the vertex colors. Universally quantify six inputs $h_{ij}$ for ordered pairs $i\ne j$ of colors. Choose one existential output $y$ and finally quantify one universal $r$. The premise is the same six equations for every graph,

$$h_{ij}=f(f(c_i,c_j),r)\quad(i\ne j).$$

For edge $vw$ put $E_{vw}=f(f(x_v,x_w),r)$. Form a list of all $E_{vw}$ using $f$ as cons and $a$ as nil. The sole conclusion equation sets $y$ equal to this list.

Given a coloring, use the ground colors for the data. Build the list for $y$ using input $h_{ij}$ for each edge with endpoint colors $i,j$. Conversely, on the active inputs, $r$ is a free rigid letter. A term in the six inputs cannot construct bare $r$. Its outermost symbol is an ordinary constructor or it takes one whole input, each of which has root $f$. No list cell can equal an input, since its tail has ordinary root $f$ or $a$ whereas an input has right child $r$. A construction of the list must therefore construct each cell and supply each $E_{vw}$. At an edge it cannot construct the outer $f$, which would require constructing the right child $r$. It must take a whole $h_{ij}$. Equality then forces the endpoints to have the prescribed distinct colors. Isolated vertices can be colored arbitrarily. Padding extra argument places gives the same proof in any branching signature. [Garey, Johnson and Stockmeyer, graph 3-colorability](https://doi.org/10.1016/0304-3975%2876%2990059-1)

The same reduction works with **no initial data**. Put the $x_v$ in the existential block alongside $y$, after the six inputs and before $r$. Their expanded values on the active inputs are now terms in $r$. The forced match at every edge still identifies the two endpoint terms with distinct ground colors. Thus even $\forall^6\exists^*\forall^1$ with one conclusion equality is NP-hard. With initial data, the reduction needs just one output.

## Verification and scope

The [reference solver](round-20-one-branch.py) returns explicit term strategies. It checks each returned strategy independently by substituting it into the original branch, unifying the premise and testing the conclusion at that unifier. It exercises the selector, the necessary proper-subterm choice, incompatible shared outputs, data purity, and the fixed-premise coloring construction on all 64 labeled simple graphs on four vertices. It uses ordinary Python tuples for readability. The polynomial NP verifier above uses shared graphs. [Lean proof of the finite-subterm step](round-20-subterms.lean)

The input-only hypothesis enters when the first unification computes the entire active set before any output body has been chosen. A premise depending on a later existential output can change its active inputs when that output's strategy changes. Round 21 decides output-dependent premises with one universal input and, more generally, premises with only one independent input parameter at fixed data. [Output-dependent premises](round-21-one-input.html) Round 25 proves ordinary two-branch JCA r.e.-complete. [Ordinary two-branch proof](round-25-binary.html)

~~~sh
python3 projects/jca/agent-collab/round-20-one-branch.py
lean projects/jca/agent-collab/round-20-subterms.lean
~~~
