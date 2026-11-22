---
title: "Which result index should the induction jump keep?"
date: 2026-11-22
---

InvarGenT now infers the same type for two ways of using a recursive result. The recursive call returns a payload $r$ and a tag $t$. At the child’s floor $q$, they satisfy $t=q+r$. The caller can pass $r$ directly to its next operation, or it can compute $t-p-e$ using the parent floor $p$ and the floor increment $e$. Both programs stop on pass 9. Revision `80624f9` already inferred the tag equation on pass 2, yet the second program exhausted 171 passes. The missing step was to use the equation $q=p+e$ at the point where the caller asks for a bound. [Program](tagged_floor.gadt) · [Earlier comparison](thesis-review-18.html#graph) · [Reproduce the comparison](thesis-review-19.py)

## Where the recursive call gets its floor {#guard}

Table 4.4 generalizes the branches that construct a result, then uses that generalization at calls that open the result. A *binary postcondition* $\chi_K(\delta,\delta')$ relates the type $\delta$ carried by an existential package to its captured parameter tuple $\delta'$. The two arguments can describe a scalar payload just as well as a pair. In this example the carried type eventually becomes $(\mathrm{Num}(r),\mathrm{Num}(p+r))$, and the tuple captures the cap $m$ as well as the floor $p$. [Table 4.4](../lukstafi-phd-thesis.pdf#page=71) · [Derivation of the scalar obligations](thesis-review-13.html)

On pass 2 the child’s actual input $a$ is defined unconditionally by $a=p+e$. The branch that opens the package has the guard $a=q\land q\le r$. Its conclusion contains $t=q+r$ and the administrative equations computing $x=t-p-e$. The primitive `step` requires $p\le x\le\max(m+20,p)$. The old abducer could take $t=q+r$ as a binding while the actual argument equation still referred to $a$. Its resulting upper-bound request, simplified to parent coordinates, was $r\le e+\max(m+20,p)$. The extra $e$ changed the subsequent search.

Revision `1ffe1eb` substitutes the equations known on the whole guard into its conclusion equations before abduction splits the branch into numeric cases. On this branch it gets $t=a+r$. The ordinary argument and arithmetic equations then give $x=r$. Here are the passes where the outcome changes. [Executable checks at budgets 8 and 9](thesis-review-19.py)

| Pass, from zero | Supplier postcondition or change | Caller feedback |
|---|---|---|
| 1 | The base returns $(p,2p)$. | No extra demand. |
| 2 | The supplier proposes $(r,p+r)$ with $p\le r$. | Requests $r\le\max(m+20,p)$. |
| 8, the induction jump | The supplier gives $p\le r\le\max(p,m+19)$ and captures $m,p$. | The caller needs no additional postcondition. |
| 9 | The stored inputs and result pass the stopping tests. | Inference returns the same signature as the direct-payload program. |

**Guard substitution lemma.** Let $G$ be the guard of one branch. Suppose a substitution $\sigma$ sends each assignment satisfying $G$ to itself. Then $G\Rightarrow C$ and $G\Rightarrow C\sigma$ agree at every assignment. On a guarded row this follows by substituting the same values into $C$. On every other row both implications hold. The identity still holds after conjoining an arbitrary candidate answer and under the original quantifier prefix, using the same witnesses. Equations obtained by choosing just one arm of a disjunction satisfy the hypothesis only on that arm. This is why the implementation uses the unsplit guard. [Lean proof](thesis-review-19.lean)

There is also an exact comparison for expressions in a solved guard. If $h$ maps the free coordinates onto exactly the rows satisfying $G$, expressions $u,v$ agree on those rows if and only if $u\circ h=v\circ h$. One direction evaluates at $h(z)$. For the converse, every guarded row has such a $z$. For affine equations over the rationals, a solved linear system supplies this parametrization. Additional inequalities restrict its parameter domain. [Formal equivalence](thesis-review-19.lean)

## Which field carries the witness? {#coordinate}

Change the tag to $t=r+kp+b$, with fixed signed integers $k,b$. At the recursive input its value is $r+k(p+e)+b$. The caller recovers $r$ by subtracting $kp+ke+b$. For **every** $k,b$, substituting in any caller predicate on the recovered value gives exactly the scalar predicate on $r$. Each supplier constructs the tag from its own output and floor. The scalar inductive certificate therefore lifts to every member of the family. Its four input conditions and two payload inequalities are unchanged. This establishes existence for the entire family. [Lean proof for an arbitrary caller predicate](thesis-review-19.lean) · [Supplier graph lemma](thesis-review-18.html#graph)

For $k=-1,b=0$, the same result type has two presentations. With $r$ as witness the fields are $(r,r-p)$. With $s=t$ as witness they are $(p+s,s)$. At floor $q=p+e$ the caller’s upper demand on $s$ becomes $s\le\max(m+20-p-e,-e)$. With $r$ as witness it is simply $r\le\max(m+20,p)$. The two demands agree under the change of variables. The solver’s guessing and widening operations inspect the written bounds. After the guard and substitution repairs alone, the negative-tag run with ordinary field order had still not returned after 120 seconds at the default budget. That observation gives a time limit on the experiment.

**When must the caller know the floor?** Fix the public inputs and let $e$ range over the private choices still allowed by the approximation. In the tag coordinate $s$, suppose the supplier gives $L_e\le s$ and the caller asks for $s\le T_e$. A single predicate $D(s)$ gives the exact answer on every feasible row if and only if each safe endpoint $T_i$ passes every other test at which it is feasible:
$$
 L_i\le T_i\ \land\ L_j\le T_i \quad\Longrightarrow\quad T_i\le T_j
 \qquad\text{for all }i,j.
$$
Necessity tests $D$ at $T_i$. For sufficiency take the union of the safe intervals $[L_i,T_i]$. If a point of such an interval is feasible at $j$, its upper endpoint is feasible there too. The criterion puts the entire overlap below $T_j$. If every floor admits a safe payload, this simplifies further: **all thresholds must coincide**. The larger of two distinct thresholds would be feasible at both floors and receive opposite answers. [Lean equivalences](thesis-review-19.lean)

Here $q=p+e$, the supplier gives $q\le r$, and the caller requires $r\le U$ with $U=\max(m+20,p)$. In tag coordinates $L_e=q+kq+b$ and $T_e=U+kq+b$. Take $p=3$, $m=-16$, so $U=4$ and both floors $3,4$ admit safe payloads. Their thresholds differ by $k$. Consequently the tag alone can express this exact pass-2 upper test for both floors **if and only if $k=0$**. For $k=-1,b=0$, the same tag $s=1$ represents $r=4$ at floor 3 and $r=5$ at floor 4. Both satisfy the supplier’s current lower bound. Only the first satisfies the caller. This is a statement about the information available on pass 2. The final supplier has learned a stronger upper bound.

The base already tells the solver something about a useful presentation. In $(p,0)$ the payload position carries a bare index. When generalizing the next result, revision `f570a4b` aligns corresponding constructor fields with the preceding result type. If some fresh numeric indices occur in previously bare positions and others do not, it keeps the former as possible witnesses and solves the current equations for dependent fields. Thus $(0,p)$ guides the solver to the payload in the second field as well. No equality between old and new witnesses is assumed. On the signed example the inferred type is $\exists r\,[p\le r\le\max(p,m+19)].\,(\mathrm{Num}(r-p),\mathrm{Num}(r))$ in that order.

The driver checks eight $(k,b)$ pairs in both tuple orders. Each run has a budget of 9 and a separate client requiring the tag equation. The emitted OCaml executes the calls and checks their tags. A client that shifts the required tag by one is rejected. These tests cover positive, negative, zero and repeated coordinates. Whether the concrete implementation follows the scalar run for every coefficient and every presentation remains open. [Signed family and controls](thesis-review-19.py)

## Keeping every equation when selecting a witness {#pivots}

Consider $n_1=n_2+n_3$ and $n_1=n_4+n_5$. A solver may prefer to write a single variable on the left. If it chooses $n_1$ for both equations and puts them in a substitution map, the second binding replaces the first. The assignment $(3,0,0,1,2)$ satisfies the retained equation and violates the original system. Even pure aliases suffered this loss. For $a=b\land b=c$, a call to the old numeric substitution routine returned only $a=c$.

Revision `9ae38cf` changes a pivot in the entire solved system. For example, pivoting the first row on $n_1$ requires a second row equating the two sums. In general, suppose $a=f(s,b)$ is equivalent to $b=g(s,a)$, with $s$ denoting all remaining parameters. On that row, every occurrence of $b$ in the other equations can be replaced by $g(s,a)$. Reversing the substitution on a satisfying assignment recovers every original row. Pure aliases keep the representative already selected by the solver. Equalities between variables protected from substitution are returned as residual constraints, including when the caller has requested a separate, unapplied substitution. [Row-exchange proof](thesis-review-19.lean)

For alias equations there is an exact test for a loss. Draw an undirected edge for each retained equality. Over any domain with two distinguishable values, these edges imply $x=y$ exactly when $x$ and $y$ are connected. For necessity, give the component of $x$ one value and all other components the other. Sufficiency follows along the path. Three equal fields already need two edges. Previously the program with branches returning $(0,0,0)$ and $(1,1,1)$ failed inference when a client required all three fields to share one index. The inferred type is now $\exists n\,[0\le n\le 1].\,(\mathrm{Num}(n),\mathrm{Num}(n),\mathrm{Num}(n))$. Changing the last field to $2$ in the second branch is rejected. [Connectivity theorem](thesis-review-19.lean) · [Triple regression](thesis-review-19.py)

The numeric audit compares the input constraint with the returned substitution together with its residual, using the solver’s implication checker in both directions. Across 47,296 combinations of systems, protected and bound variable sets, and application and constant-handling flags, revision `80624f9` returned a weaker formula 11,628 times. After the repair every comparison passed in both directions. The row-exchange proof addresses the algebraic operation independently of this finite audit. [OCaml audit](numeric_pivot_audit.ml)

## What a size bound buys {#bound}

The arithmetic example now succeeds because the abducer can express the caller’s need in a coordinate the supplier keeps through the jump. A small certificate alone still gives no guarantee for Table 4.4. With the original common-atom jump, two inequalities suffice for a solution, yet every later pass reinstates the same caller demand and fails the stopping test. At revision `f570a4b` the reachable guarded call on the four-constructor example still exhausts term abduction before the jump for every positive outer budget. Its written certificate has zero constraint atoms and checks. These are distinct failures of discovery, one through perpetual feedback and the other through finite exhaustion. A fair search through a finite, checkable bounded certificate language has a separate completeness argument. [Infinite recurrence](thesis-review-3.html#update) · [Guarded call and budget-independent control flow](thesis-review-18.html#guard) · [Bounded search](thesis-review-2.html)

A later revision recovers the hidden-index call on pass 6. The same program with an impossible guard still has a constant-size solution that search exhausts before the jump. [Guard criterion and new all-budget trace](thesis-review-20.html)

The three solver changes are `1ffe1eb`, `9ae38cf` and `f570a4b`. The OCaml 5.3 compatibility build passed all 306 active tests, with 10 existing TODOs. All 146 previously generated example signatures compared byte for byte with revision `80624f9`. The signed program driver used OCaml 5.5.1 and the proofs used Lean 4.19. [Build notes](thesis-review-1.html)
