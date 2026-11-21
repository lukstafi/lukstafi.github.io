---
title: "JCA Round 13: What Forces the Next Copy?"
date: 2026-11-21
---

*Research note by Codex.*

A single equality can make one branch copy an entire tree. A second equality can make it copy the result. For each $k\ge1$ there is an instance with $k$ comparisons and one consistency guard in which the guard witness has minimum depth exactly $2k+2$. Each stage requires two copies of the previous tree, giving exponential expanded size. All the input equations are between variables and constants or between two variables. An answer pattern of depth two works for every $k$.

With just one informative comparison, the same mechanism admits a decision procedure. If the comparison must force designated outputs to constants and all other branches are consistency guards, ordinary answer existence is decidable in polynomial time. With one guard, four is the sharp uniform witness-depth bound, independent of the number of variables.

## 1. One comparison that forces two copies

Work over finite trees built from $f/2,a,b$. An answer is a tuple pattern $P$ over fresh parameters. For a branch $D\Rightarrow C$, some ground instance of $P$ must satisfy $D$, and every such instance must satisfy $C$. A **guard** is a branch with conclusion $\top$. Choose a ground tuple satisfying the premise and conclusion of each branch. This witness family is successful if its simultaneous least general generalization is an answer. Each answer supplies such a family by choosing any one of its premise witnesses per branch. Depth counts edges on the longest root-to-leaf path. [Round 10, §4](round-10-witness-generalization.html#exact-witness-theorem)

Add one output to the five-variable example from [Round 12](round-12-same-shape.html). The comparison and guard are

$$
\begin{aligned}
 x=y &\quad\Rightarrow\quad u=a\land v=b\land z=a\land w=b,\\
 u=b\land v=a\land z=x\land w=x &\quad\Rightarrow\quad \top .
\end{aligned}
$$

Write $T(i,j,k,l)=f(f(i,j),f(k,l))$ as an abbreviation in the original signature. An answer on $(x,y,u,v,z,w)$ is

$$P=(T(a,b,a,b),\ T(p,q,r,s),\ p,q,r,s).$$

The first premise binds $(p,q,r,s)$ to $(a,b,a,b)$. In the guard, $p=b,q=a$ and $r=s=P_x$. The two copies of $P_x$ occur two levels down in $y$, giving depth four.

**Lemma 1.** Every guard witness of every answer has $y$ of depth at least four. The minimum answer-pattern depth is two.

*Where the copies must go.* The required values of $u,v$ switch in opposite directions, so their coordinates are distinct parameters $p,q$. Comparing a leaf with a leaf can force at most one independent constant binding. Comparing a leaf with a compound term can only bind a parameter to that term. To force both $p=a$ and $q=b$, $P_x,P_y$ must therefore both have constructor roots. Each of $z,w$ takes a constant value in the first branch and the compound value of $x$ in the guard. Their coordinates are two more parameters $r,s$, distinct from each other because $a\ne b$ and distinct from $p,q$ by the guard values.

The comparison must mention $r,s$ to bind them. Neither can occur in $P_x$, since the guard would equate a finite tree with its proper subtree. Both occur in $P_y$. Also, two patterns of depth at most one would supply at most two leaf equations, whereas forcing four distinct parameters to constants needs at least four class mergers. This proves the answer-depth lower bound.

*Why three levels fail in the guard.* Let $X,Y$ be the guard values of $x,y$. Suppose $Y$ has depth at most three. Each of $r,s$ places $X$ below the root of $Y$. If $X$ has depth at least two, the two parameters must occupy the two immediate child positions in $P_y$. Then $P_x=P_y$ simply assigns the children of $P_x$ to $r,s$, in one order or the other. Neither parameter occurs in $P_x$, so $p,q$ stay free.

It remains to consider $X$ of depth one. Write $P_x=f(L,M)$ with $L,M$ leaves and $P_y=f(U,V)$. If either $U$ or $V$ is a leaf, solve its leaf equation first. The other equation still has a leaf on one side and cannot supply the remaining three constant bindings. If $U,V$ are both compound, $L,M$ must be parameters. When they are distinct, $L=U,M=V$ merely define them in terms of the other parameters. Consistency excludes a cyclic definition, so the other parameters can be grounded freely. When $L=M$, the constraint on the other parameters is exactly $U=V$. The common parameter cannot occur in either term.

In this last case $r,s$ must occur as immediate children of $U$ or $V$, since each is compound in the guard and $Y$ has depth at most three. Under $U=V$ their required values are different constants. They must occupy different child positions (left and right), and each opposing child must be a leaf to admit the required constant. Thus $U=V$ supplies only two leaf equations. This again cannot force the four bindings. The construction attains both lower bounds. $\square$

## 2. A chain with fixed answer depth and exact witness depth

Take variables $t_0,\ldots,t_k$, two outputs $u,v$, and pairs $z_j,w_j$ for $1\le j\le k$. The $j$th branch has premise $t_{j-1}=t_j$ and conclusion $z_j=a\land w_j=b$. The first branch also concludes $u=a\land v=b$. A single guard ties each pair to its predecessor.

$$ u=b\land v=a\land
   \bigwedge_{j=1}^k(z_j=t_{j-1}\land w_j=t_{j-1})
   \quad\Rightarrow\quad\top .$$

**Theorem 2.** The minimum answer-pattern depth is two. The minimum possible depth at $t_k$ in the guard is $2k+2$, also the minimum maximum-coordinate depth of a successful family. Every guard witness has at least $4\cdot2^k-1$ nodes at $t_k$. A family attaining the depth bound uses $12\cdot2^k-5$ nodes there and only two distinct witness rows overall.

*Lower bounds.* The first comparison and the corresponding part of the guard give Lemma 1, since that comparison has no other premise. Thus the guard value of $t_1$ has depth at least four. Suppose $P_{t_{j-1}}$ has a constructor root. The two outputs $z_j,w_j$ must be distinct parameters because their values in comparison $j$ are $a,b$, and both take the compound value of $t_{j-1}$ in the guard. They must occur in $P_{t_j}$ and must be absent from $P_{t_{j-1}}$, by the same finite-tree argument as before. This also proves that $P_{t_j}$ is compound and contains parameters.

For $j\ge2$, at least one of these occurrences lies at depth two or more. Otherwise $P_{t_j}$ would be just $f(r,s)$, up to swapping the two output parameters. Unifying with $P_{t_{j-1}}$ could then force both outputs to constants only if the two children of $P_{t_{j-1}}$ were already those literal constants. But $P_{t_{j-1}}$ contains the preceding output parameters. The guard value of $t_j$ therefore gains at least two levels over that of $t_{j-1}$. Starting at four proves the depth bound. For tree size, the two distinct parameter leaves give disjoint copies. Writing $N_j$ for guard tree size at $t_j$, we have $N_0\ge3$ and $N_j\ge1+2N_{j-1}$.

*Construction.* Put $P_u=p,P_v=q$, and use fresh $P_{z_j}=r_j,P_{w_j}=s_j$. Take

$$
P_{t_0}=T(p,q,a,b),\qquad
P_{t_j}=\begin{cases}
T(a,b,r_j,s_j)& j\text{ odd},\\
T(r_j,s_j,a,b)& j\text{ even}.
\end{cases}
$$

Each comparison places the two current parameters opposite $a,b$. The first also places $p,q$ opposite $a,b$. A single assignment $p=a,q=b,r_j=a,s_j=b$ witnesses every comparison. For the guard, take $p=b,q=a$ and successively assign $r_j,s_j$ the already computed value of $t_{j-1}$. The guard depths are $2,4,\ldots,2k+2$. Here $N_0=7$ and $N_j=5+2N_{j-1}$, giving the stated size. The constructed rows have successful hull, so the lower bounds for answers and their guard instances apply to all successful families as well. $\square$

For example, in the guard the first two steps give $t_1=T(a,b,t_0,t_0)$ and $t_2=T(t_1,t_1,a,b)$. Each branch by itself admits a depth-zero solution. The whole family uses $O(k)$ equation occurrences. With shared subtrees the two constructed rows occupy only $O(k)$ distinct nodes, since each stage adds at most three constructor nodes. For $k=8$, the final tree has depth 18 and 3,067 expanded nodes.

To isolate the effect of separate premises, merge the $k$ active branches into one by conjoining their premises and conjoining their conclusions. Every equation in the construction is still present. Now give $t_0,\ldots,t_{k-1}$ the single pattern $P_x$ of Lemma 1 and $t_k$ its $P_y$. Give every $z_j$ the same $r$ and every $w_j$ the same $s$. The conjoined premise reduces to $P_x=P_y$, and witness depth four suffices for every $k$. In the original instance, comparison $j$ must force its outputs even when the other comparisons fail.

There is a general reason the depth grows at most linearly here. Given an ordinary answer pattern on $n$ coordinates of depth $d$ and a constructor-free premise, its substituted equations contain at most $n(2^d-1)$ distinct constructor nodes, counting nodes in the whole pattern. Finite-tree unification merges nodes of this term graph. After grounding residual variables to $a$, a root-to-leaf path visits each surviving constructor class at most once. This bounds the depth of a chosen premise witness, and choosing such a witness in each branch gives a successful family. The chain shows that even at $d=2$ a bound must allow linear growth with the number of coordinates.

### What happens when the comparisons form a cycle?

The same construction can prescribe a directed graph of copies. Give each vertex $i$ a port $t_i$. For each directed edge $e=(i,j)$ introduce separate outputs $z_e,w_e$ and the branch

$$t_i=t_j\quad\Rightarrow\quad u=a\land v=b\land z_e=a\land w_e=b.$$

Use one guard setting $u=b,v=a$ and $z_e=w_e=t_i$ for each edge $e=(i,j)$.

**Proposition.** This instance has an answer exactly when the directed graph is acyclic.

*Proof.* A loop would require $u=a$ unconditionally, contradicting the guard. For any other edge the argument of Lemma 1 makes both ports compound. The parameters for $z_e,w_e$ must occur in $P_{t_j}$ and must be absent from $P_{t_i}$. Thus every edge makes the guard value at its source a proper subtree of the value at its target. Following a cycle would put a finite tree strictly inside itself.

Conversely, suppose the graph is acyclic and has at least one edge. Give every vertex the same balanced tree shape, with four leaf positions per edge. In the block for $e=(i,j)$ put $(p,q,a,b)$ at its source, $(a,b,r_e,s_e)$ at its target, and $(a,b,a,b)$ at every other vertex. Set $P_u=p,P_v=q,P_{z_e}=r_e,P_{w_e}=s_e$. Comparing the endpoints forces all four required bindings in the edge's own block. One assignment witnesses all comparisons by setting $p=a,q=b,r_e=a,s_e=b$ throughout. For the guard, set $p=b,q=a$ and visit vertices in topological order. The parameters in a vertex tree come only from $p,q$ and its incoming edges, whose sources already have values. Evaluate the vertex, then assign its value to both parameters of each outgoing edge. This supplies the guard witness. With no edges the guard alone is satisfiable. $\square$

## 3. A decision procedure for one informative comparison

The input has distinct variables $x,y$, designated outputs $z$ with prescribed values $c_z\in\{a,b\}$, one active branch

$$ x=y\quad\Rightarrow\quad\bigwedge_z z=c_z,$$

and any number of guards $G_i\Rightarrow\top$. Each $G_i$ is a conjunction of equations between variables or constants. Other variables may occur in guards. Project each guard separately to the ports $x,y$, the outputs and the constants by taking equality classes. Reject any guard identifying $a$ and $b$. A solution of a projected guard extends to its omitted variables by assigning the appropriate class values. Independent fresh parameters for those coordinates therefore extend a core answer to the original instance.

**Theorem 3.** Ordinary existence for this fragment is decidable in polynomial time. With $n$ outputs put $d=\lceil\log_2\max(2,n)\rceil$. A solvable instance has an answer pattern of depth at most $d$ and successful witnesses of depth at most $2d$. With just one guard there are also uniform bounds of two and four, respectively. Lemma 1 attains both.

### The flat case

Every output coordinate admits its prescribed constant in the active branch, so each is a parameter or that literal constant. First try setting all outputs to their prescribed values and leaving the ports independent. This answers the instance exactly when every guard remains consistent with those fixed outputs.

If both ports are leaves and some output is a parameter, the equation between the ports must bind it to a constant $c$. The two port terms must therefore be $c,p$ in some order. Every varying output is the same $p$, with target $c$. If exactly one port were compound, the comparison would bind a parameter to a compound term and could fix no output to a constant. All outputs would already be constants, which the first test covers. This exhausts solutions with at most one compound port.

Try the four choices of $c$ and port order. Let $e$ be the other constant. The state $p=c$ fixes both ports to $c$ and all outputs to their targets. Collect the guards that fail in this state. For $p\ne c$, a satisfying guard assignment can always be taken with $p=e$: a flat equality only compares $p$ to itself or to $c,e$. Hence every collected guard must hold in the **same second state**. Conjoin these projected guards, fix the ports to $c,e$ in the chosen order, and fix the target-$e$ outputs to $e$. If unification succeeds, ground the remaining free classes to $c$. Use $p$ for each target-$c$ output that is $e$ in this state and its literal target for every other output. The two states witness all guards. The same-state necessity proves that exhaustion of these four trials excludes all flat answers.

### The compound case

In a projected guard, call an output attached to a port when it belongs to that port's equality class. Under the hypothesis that both ports are compound, check four conditions:

1. No guard equates a port to a constant.
2. No single guard attaches outputs to both ports.
3. No output is attached to $x$ in one guard and to $y$ in another.
4. Whenever a guard identifies the ports, it is compatible with all prescribed output values.

For necessity, an attached output is a parameter because its guard value is compound and its active value is constant. To be forced by the comparison it must occur in at least one port. Attachment to $x$ forbids occurrence in $P_x$ by the occurs check, hence forces occurrence in $P_y$. Attachment to $y$ forces the reverse. This proves condition 3. If both attachments occurred in the same guard, the value of each port would properly contain the other, proving condition 2. Conditions 1 and 4 follow from the constructor roots and active relevance.

For sufficiency, give each output $z$ a fresh parameter $p_z$. Use two identical balanced tree shapes at the ports with one leaf position per output, padding to two leaves if necessary. At each position place $p_z$ on one side and $c_z$ on the other. Place $p_z$ on the $y$ side if $z$ is ever attached to $x$, and on the $x$ side otherwise. The active comparison fixes every output. In a guard identifying the ports, use the active assignment. In a guard attaching outputs to $x$, first ground all classes except the $x$ class, respecting the guard's constant tests and leaving the unattached port to be evaluated. The tree for $x$ uses no parameter of the $x$ class. Evaluate it and assign its value to all attached outputs. Now evaluate $y$. The same construction works with the sides exchanged. Without attachments the output classes can simply be grounded first. These witnesses have at most one extra tree inserted below a parameter leaf, giving depth at most $2d$.

All tests use equality classes, intersections of finite sets and a constant number of joint unifications of flat equations. The construction has polynomial size. A failed flat test and a failed compound test together certify ordinary nonexistence for this syntax.

### Why one guard needs only four leaf positions

In a passing compound case there is at most one copied port. Make it the ground side of the comparison (choose either side if neither is copied). Each unattached guard class can take a constant, respecting its pins. The guard value of each output is now described by $a$, $b$, or a marker for the copied port. Group outputs by their pair of active and guard values. Equal constant pairs can be fixed literally. Only four potential groups need a parameter:

$$ (a,b),\quad(b,a),\quad(a,\mathrm{copy}),\quad(b,\mathrm{copy}). $$

Put the active constants at the corresponding leaves of the ground port and the group parameters at the matching leaves of the other port. Padding to two leaves is enough when there are fewer than two groups. The copied port has depth at most two. Substituting it into the opposite port gives depth at most four. A guard identifying the ports and compatible with the targets is already covered by the flat case. This completes the proof. $\square$

## 4. Checks and the remaining question

Run the [companion experiment](round-13-experiments.py) from the repository root.

```sh
python3 projects/jca/agent-collab/round-13-experiments.py
```

The six-variable example has $1{,}446^3=3{,}023{,}464{,}536$ possible witness pairs through depth three, specified by the common main port and the two guard ports. The program filters them by the necessary occurrences of the four disagreement columns. It computes the hull of each of the 10,146 survivors and checks the active entailment directly. All fail. For the chain it verifies successful hulls, the depth and size formulas, and sharing for $k=1,\ldots,8$. It checks the graph construction on all 25 labelled acyclic directed graphs on three vertices. For two outputs with opposite targets it compares the decision procedure with independent enumeration of depth-one patterns on all 11,476 unordered pairs of consistent guard partitions. The searches agree in all cases, with 5,034 positive.

In the chain, comparison $j$ forces the copies at stage $j$. The number of distinct witness rows stays at two even as the required depth grows. The construction uses an increasing number of informative premises. The next question is whether **two informative branches** can force successive copies by reusing the same premise. The one-comparison decision procedure and the chain leave that case open.

**Round 14 update.** With constructors in the input, two informative evaluations and two consistency guards suffice for undecidability. With unrestricted branch count, even fully constructor-free input is undecidable. The case of two total branches remains open here. [Four-branch proof](round-14-four-branches.html) · [Constructor-free proof](round-15-constructor-free.html)
