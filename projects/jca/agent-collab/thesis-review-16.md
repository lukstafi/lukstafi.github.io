---
title: "A recursive package that fails before the induction jump"
date: 2026-11-22
---

InvarGenT at revision `cac61af` can miss a constant-size solution on a single recursive definition for every outer iteration budget. There is no arithmetic in the example. InvarGenT checks the written type, and its generated OCaml runs. With the annotation erased, the solver retries its first input guess and reports a quantifier violation. The induction jump is scheduled for pass 8. [Unannotated source](packed_payload.gadt) · [Executable comparison](thesis-review-16.py) · [Table 4.4](../lukstafi-phd-thesis.pdf#page=71)

A later revision infers this type on pass 6 and checks the complete client. At that revision a four-constructor version fails at every outer budget. [Repair, four-way counterexample and scope audit](thesis-review-17.html)

## A result with no hidden index {#package}

The constructor `Left` gives its argument type the second position in `Tag(Marker,a)`. The constructor `Right` gives it the first position in `Tag(a,Marker)`. At depth zero the function unpacks either constructor and returns its payload twice. At a successor it makes the same call at the preceding depth. The attached test unpacks the result of `f (Left Box) (S Z)` and checks the first component against `Box`, whose type is `Cargo`. Because the test is attached to the recursive definition, the solver sees its call together with the base and successor branches. [Source](packed_payload.gadt)

A certificate is
$$
\forall a.\; \mathrm{Tag}(\mathrm{Marker},a)\to\mathrm{Nat}
   \to \exists().\,(a,a).
$$
The package captures $a$. It introduces no hidden witness and requires no side conditions. For `Left`, the payload has type $a$. For `Right`, matching the declared input equates $a$ with `Marker`, and the payload has type `Marker`. Both constructors are live. The successor returns the preceding result at the same type. The attached call instantiates $a$ with `Cargo`. Lean checks the two constructor cases and the returned pair at every depth. InvarGenT accepts the annotation, and the driver executes both constructors. Reversing the two input positions gives the symmetric type for a client using `Right Box`. Giving that client the first type is rejected. [Proof and constructor witnesses](thesis-review-16.lean) · [Executable checks](thesis-review-16.py)

The erased program's constraints name the binary postcondition $X_1$ and the unary function predicate $X_2$. Write $K(s)$ for a package with parameter tuple $s$, and $\langle a\rangle$ for the one-entry tuple. An explicit interpretation is
$$
\begin{aligned}
 X_1(u,s) &\iff \exists a.\;s=\langle a\rangle\land u=(a,a),\\
 X_2(v) &\iff \exists a.\;v=(\mathrm{Tag}(\mathrm{Marker},a)\to\mathrm{Nat}\to K(\langle a\rangle)).
\end{aligned}
$$
The unary use of $X_1$ in the solver records the choice of parameter tuple at the package definition. Choose $\langle a\rangle$ from the input there. In the base branch, both tag matches now give the payload type $a$, so $(a,a)$ satisfies the binary predicate. The recursive application instantiates $X_2$ at the same $a$ and repacks the child's pair with the same parameter. At the attached call choose $a=\mathrm{Cargo}$. Every opening of the resulting package then gives $(\mathrm{Cargo},\mathrm{Cargo})$, as required by the test. These choices supply the witnesses for the erased definition as well as explaining its written annotation.

### Why every outer budget fails {#budget}

At revision `cac61af`, pass 0 initially guesses $\mathrm{Tag}(a,a)$ for the input and leaves the binary result predicate empty. The diagonal is a sound choice for the base definition in isolation. It cannot admit the test's $\mathrm{Tag}(\mathrm{Marker},\mathrm{Cargo})$. The trace for the complete definition is short.

| Pass | Search action | Outcome |
|---|---|---|
| 0 | First abduction | Stores the diagonal input. Continues if the budget is positive. |
| 1 | Checks the next approximation | Returns a type mismatch to pass 0. |
| 0 | Retries with the rejected choice recorded | Returns a quantifier violation involving the test's pair type. |

The last two failures take the error arm of `match answer` in `Invariants.solve`. Neither reaches the budget comparison. The retry returns directly to the caller of the first pass. There are no earlier inferred definitions whose answers could depend on the budget. The only earlier read of the outer limit tests whether pass 0 has exhausted it. The other read in this module occurs after a successful solve. Thus every positive budget follows this same finite path, even if the outer timeout is removed. Budget zero stops on the first row. With the historical executable supplied via `--before-package`, the driver checks budgets 0, 1, 8, 11, 80 and 10,000 with the other settings at their defaults. As a control, change the function to return the ordinary payload. InvarGenT then accepts the left and right client tests when each is attached separately. [Driver](thesis-review-16.py) · [Earlier nonprincipality theorem](thesis-review-1.html)

This refutes guaranteed *successful* convergence of the implemented iteration under a solution-size promise, even for a fixed type with zero constraint atoms. On this example the search terminates early. In the earlier two-inequality example, the original common-atom jump regenerates a caller obligation forever. [Infinite recurrence](thesis-review-3.html#update)

### What happens at an actual jump on the moving-floor program {#restarts}

The two-result arithmetic program does reach the jump. It returns a payload $r$ and a tag $p+r$ at floor $p$. A recursive call raises the floor by $e$. The six-atom certificate admits both attached calls. At `cac61af` the default run exhausts budget 11, and a longer run exhausts budget 80. Its jump starts at pass 8. After failed retries, passes 9, 20 and 42 restart from the base and reschedule the jump for passes 19, 41 and 85 respectively. The restart rule sets the new threshold to twice the current pass number plus one. [Recursive source](tagged_floor.gadt) · [Certificate and driver](thesis-review-13.html#tag)

At pass 41 the caller asks for $2p+e\le p+r$, or $p+e\le r$. The base returns $r=p$, so this demand would require $e\le 0$. One attached call starts at $p=3,e=1$ and depth two. It reaches the base at $p=5$, where the demand would require $6\le 5$. The candidate input on that pass actually fixes $e=0$. The next pass fails numeric abduction. The retry of pass 41 puts $r\le p+e$ in the result instead and drops the restriction $e=0$ from the input. Pass 42 restarts. Thus even the direction of the disputed bound changes across a retry. The three observed restarts explain why extrapolating from two repeated printed bounds would be insufficient. Whether the run on this particular program eventually succeeds remains open.

## Recovering an equation written differently by the suppliers {#affine}

An arithmetic example locates a repair in the supplier step itself. On input $p$ the base returns $(p,2p)$. The successor calls the function at $-p$, checks the child's pair, and returns $(p+1,2p+1)$. A pair $(r,t)$ at input $p$ must satisfy $t=p+r$. The identity holds in both branches for every $p$. Indeed the certificate $\forall p.\;\mathrm{Num}(p)\to\mathrm{Nat}\to\exists r.\,(\mathrm{Num}(r),\mathrm{Num}(p+r))$ needs no side conditions. [Recursive source](affine_tag.gadt)

The old generalizer intersected finite lists of equations from the solved branches. The base can write $r=p,\ t=2p$. The successor can write $r=p+1,\ t=2p+1$. Neither list needs to contain $t=p+r$. For any integer $k$, replacing the second coordinates by $(k+1)p$ and $(k+1)p+k$ gives an example where *every* common affine equation is a multiple of $t=p+kr$. To check the claim, substitute the base at $p=0,1$ and the step at $p=0$ into $A p+B r+C t+D=0$. The resulting equations force $D=0$, $B=-kC$, and $A=-C$. [Lean proof](thesis-review-16.lean)

Revision `9119892` supplements the common equations when the numeric result has at least two target indices outside the candidate parameter set. Start with a basis for the equations in the first solved region. Substitute the second region's solved equations into every basis row, obtaining a residual for each. Reduce the residual rows by Gaussian elimination and apply each row operation to the original equations as well. The original combinations whose residual is zero span exactly the intersection of the two equation spaces. Row operations preserve the span, and the surviving nonzero residual pivots are independent. The constant column participates in elimination. Repeat for every remaining region. A third region that violates the proposed equation removes it. This calculation concerns the affine equations present in the solved regions. Inequalities and extrema continue through their own generalizer.

At `e5cd09c` the reflected recursion commits to $p=0$ on pass 5 and rejects the separately defined client at $p=7$. The explicitly written unrestricted certificate passes on that same revision. At `9119892` the solver infers $p\le r\le p+1$ and puts $p+r$ directly in the second component's type. The client at 7 executes, and a client claiming $t=8+r$ fails. [Source and signature checks](thesis-review-16.py)

## When an affine induction jump does converge {#dimension}

Fix the input predicate, the captured parameters and the type shape. Suppose one result predicate ranges over $d$ rational coordinates. Let $B$ be the nonempty set of base results, and write $x\mathrel T y$ when a recursive supplier can return $y$ given $x$. Represent the stored predicate by an affine subspace. Take the exact affine hull of the suppliers on each pass, starting with $S_0=\operatorname{aff}(B)$ and updating by
$$
S_{n+1}=\operatorname{aff}\bigl(B\cup\{y\mid \exists x\in S_n.\;x\mathrel T y\}\bigr).
$$

Suppose there is an inductive affine solution $R$ whose results satisfy the caller. Then $S_n\subseteq R$ on every pass. The base lies in $R$, the suppliers preserve $R$, and taking an affine hull stays inside an affine subspace containing its arguments. Consequently the caller can consume every $S_n$ and requires no strengthening. Monotonicity gives $S_n\subseteq S_{n+1}$, starting with inclusion of the base. Widening by $\operatorname{aff}(S_n\cup S_{n+1})$ therefore leaves $S_{n+1}$ intact.

**There are at most $d-\dim S_0$ strict increases, followed by one verification pass.** A point outside a nonempty affine subspace adds a linearly independent direction. At equality the supplier update contains the base and all successors of its current points, which proves inductiveness. Applying the bound to an implementation requires a join that preserves the common affine consequences, an equality test that recognizes equivalent presentations, and a fixed interface and input predicate. The Lean development proves containment, the decreasing dimension budget and the inductiveness test given the dimension rank. [Formal iteration lemmas](thesis-review-16.lean)

The bound is sharp. Start at zero in $d$ coordinates and take $T(x_1,\ldots,x_d)=(1,x_1,\ldots,x_{d-1})$. After $k\le d$ strict increases the first $k$ coordinates range freely and all later coordinates are zero. The base and the first $k$ iterates have this affine hull because successive iterates differ by each of the first $k$ coordinate vectors. The next pass adds the next coordinate direction. This is a convergence guarantee for a specified instance of the update, with the ambient dimension providing the bound. The package counterexample shows what changes when Table 4.4 must infer the interface and solve the input obligations too.

## Rational endpoints and exported packages {#interfaces}

A supplier returning $1/2$ at the base and $3/2$ at each successor has an immediate two-bound contract. Before `ef47f20` pass 2 raised an OCaml exception while comparing two rational constants by structural equality. Numeric equality repairs the operation. InvarGenT now infers the interval and the emitted OCaml executes. Increasing the successor to $5/2$ violates the next caller's range and is rejected. [Program](rational_endpoints.gadt) · [Comparisons](thesis-review-16.py)

The package proof exposed two export problems, repaired in `cac61af`. A vacuous existential binder printed as `∃.(a,a)`, which the parser could not read back. It now accepts an empty binder list and preserves the package and its captured parameters. In generated OCaml a locally abstract type named `a` could also shadow the concrete type for the source datatype `A`. With concrete types `A` and `A'` in scope the printer now chooses `a''` for that binder and uses it consistently in the body annotations. Both the reimported interface and the generated OCaml are checked by executable regressions.

The regression suite passed all 299 active tests, with 10 existing TODOs. All 143 signatures generated from the earlier examples matched their outputs at `e5cd09c` byte for byte. The comparison driver passed on OCaml 5.3 and 5.5.

Lean 4.19.0 checks the standalone file with `lean thesis-review-16.lean`. Run `python3 thesis-review-16.py /path/to/InvarGenT.native` in this directory. Add `--before-package` with a binary from `cac61af` to reproduce the original two-constructor failure. Add `--before-affine` with a binary from `e5cd09c` to reproduce the earlier arithmetic failures. [Lean file](thesis-review-16.lean) · [Comparison driver](thesis-review-16.py)
