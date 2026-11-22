---
title: "What can arithmetic abduction gain by combining premises?"
date: 2026-11-22
---

Suppose a constructor hides two numbers $x,y$ and publishes upper bounds $i,j$. A function adds the numbers and compares their sum with a cap $z$. What condition can its type ask of the caller? From $x\le i$ alone the sum is unbounded. The same holds for $y\le j$ alone. Together they give **exactly $i+j\le z$**. Sufficiency follows by adding the inequalities. Necessity follows by choosing the allowed payload $(x,y)=(i,j)$. InvarGenT at `29feeaf` accepted this annotation and failed to infer a type for the unannotated definition. The new search infers the guard. [Source program](joint_affine_abduction.gadt) · [Lean proof](thesis-review-54.lean)

## Where the algorithm selects pairs {#pairs}

Section 4.2.4.2 of the thesis distinguishes two ways of proposing a single answer atom. For an **inequality**, select the required atom and a premise inequality. Eliminate a shared variable or cancel a constant to obtain a sufficient condition. InvarGenT chooses bounds from a solved context, so one available bound can already incorporate several source inequalities. For an **equation**, the thesis allows a linear combination of the required equation and several premise equations. InvarGenT searches a finite set of rational coefficients and prunes wide combinations. Joint abduction accumulates the proposed atoms and checks compatibility across branches. The separate problem of excluding a negative branch also has a search over entire polyhedra. [Thesis §4.2.4.2](../lukstafi-phd-thesis.pdf#page=65) · [Negative branches and shared witnesses](thesis-review-49.html#dual)

## Fitting several coefficients from sibling branches {#equations}

Three constructors have public indices $(0,0),(1,0),(0,1)$. Their branches return $0,7,11$. For an affine result index $a i+b j+c$, the branches give $c=0$, $a+c=7$ and $b+c=11$. The old scalar recovery step could learn one coefficient from another branch. The compiler accepted the written result $7i+11j$ and rejected the unannotated function.

Let the current goal be $g=0$. Adding any combination of equations $e_s=0$ known in the current branch gives an equivalent goal there. To find a candidate that also works on siblings, start with rows $e_1,\ldots,e_k,g$. Substitute each eligible sibling's solved equations into the rows and use Gaussian elimination to keep the combinations with zero residual. Keeping $g$ last preserves its coefficient of one whenever its row survives. The compiler checks that the correction vanishes on the current branch, applies its existing support limit, then submits the proposal to ordinary joint validation. The recovery uses siblings where the goal residual is constant.

InvarGenT now infers $\mathrm{Axis}(i,j)\to\mathrm{Num}(7i+11j)$. The replay also recovers mixed signs and a four-index result with coefficients $7,11,13,17$ while the coefficient enumeration radius is one. [Native compiler replay](thesis-review-54.py)

## Projecting hidden variables from a required inequality {#bounds}

Write a required inequality as $g(p,h)\le0$, with public parameters $p$ and hidden payload $h$ satisfying a conjunction $D(p,h)$ of weak linear inequalities and equations over the rationals. Introduce a fresh scalar $t$ and project
$$
  \exists h.\ D(p,h)\land t\le g(p,h).
$$
Every public upper bound $t\le u(p)$ in this projection gives an abduction candidate $u(p)\le0$. Indeed, for each allowed payload we may choose $t=g(p,h)$. The new recovery step puts hidden variables first in the existing elimination order, reads off the upper bounds on $t$, and submits proposals to the usual scope and validation checks. When it finds two upper bounds it tries their binary minimum before trying each separately.

There is no fixed bound on how many source premises one answer inequality can need. For $n$ independent hidden payloads $x_s\le i_s$, summing gives the exact public guard $\sum_s i_s\le z$. Omit any one premise and its payload can grow until the sum exceeds $z$, at every fixed public input. InvarGenT infers the guard for three, four and six independent payloads. Removing one essential premise in the original two-payload program makes inference fail. [Lean theorems `many_bounds` and `missing_row`](thesis-review-54.lean) · [Native checks](thesis-review-54.py)

For an oblique example, take $x+y\le i$ and $x-y\le j$. The sharp bound on $3x+y$ is $2i+j$. Add twice the first premise to the second for sufficiency. Both are tight at $x=(i+j)/2$, $y=(i-j)/2$. InvarGenT infers the guard on $z$. [Sharp bounds in Lean](thesis-review-54.lean) · [Compiler replay](thesis-review-54.py)

## When callers need alternative bounds {#alternatives}

Fix public parameters with at least one feasible payload. An exact projection with finitely many upper bounds $t\le u_1,\ldots,t\le u_k$ permits all and only $t$ below every bound. **The weakest safe guard is $\bigvee_{s=1}^k u_s\le0$.** If every bound is positive, some positive rational $t$ lies below them all. With no upper bounds one can take $t=1$. Either case witnesses an allowed payload whose goal is positive. On a public input with no feasible payload the implication is vacuous. [Lean theorem `projected_alternatives`](thesis-review-54.lean)

For example, suppose $x\le i$, $x\le j$ and $y\le j$. Then the exact guard for $x+y\le z$ is $\min(i+j,2j)\le z$. Trying each projected bound on its own inferred $2j\le z$. The compiler now infers the minimum and runs clients at $(i,j,z)=(0,6,6)$ and $(8,2,4)$. The first client needs $i+j\le z$ and the second needs $2j\le z$. Their midpoint $(4,4,5)$ admits the unsafe payload $(4,4)$. Every conjunction of affine inequalities admitting both clients also admits their midpoint. The compiler rejects this midpoint call. [Both admitted calls](joint_affine_abduction.gadt) · [Rejection control](thesis-review-54.py)

For several fixed branch obligations, take the conjunction of their exact guards. In particular, if the branches under consideration have feasible payloads throughout the public region and each goal has one or two projected upper bounds, ordinary inequalities and binary minima already express the exact safety condition there. The full iteration must also choose what its recursive predicates mean. This calculation applies once their meanings in the branch premises are fixed.

A smaller example isolates a remaining search decision. A constructor hides just $x$ under $x\le i$ and $x\le j$. To prove $x\le z$, either original premise already gives a sufficient public guard. Ordinary pair search succeeds with $j\le z$, so the declaration never enters recovery. The written $\min(i,j)\le z$ type accepts one caller needing each alternative. The inferred type rejects their combination. Making this improvement available on successful declarations requires a choice about when to seek a weaker public guard and how to validate it across other obligations. [Native comparison](thesis-review-54.py)
