---
title: "Which rates must a recursive postcondition remember?"
date: 2026-11-22
---

Two safe calls to the same function can disagree about what a child may return. In the crossing-cap program one call returns 16 at floor and cap parameter both zero. A different caller reaches those same child arguments but can consume at most 14. The existential result type must carry enough information to distinguish the two calls. There is an exact test for how much it can forget. [Program](crossing_caps_annotated.gadt) · [Lean proofs](thesis-review-15.lean) · [Executable witnesses](thesis-review-15.py)

## When two modes can share a result predicate {#sharing}

A call starts at floor $p$ and cap parameter $m$. The recursion advances them by $e$ and $d$. Write $s$ for a choice of these rates and $C_s$ for its effective supplier offset. A supplier can return the floor or grow a child payload by at most one, up to $\max(p,m+C_s)$. The parent requires its child result to lie between $p$ and $\max(p,m+L)$. Assume $C_s\le L$. The greatest input domain from the previous review admits exactly the modes with
$$
0\le e_s,\qquad e_s\le\max(0,d_s),\qquad d_s\le L-C_s
$$
at the starting positions where $e_s\le\max(0,m-p+L)$. The input predicate can still see both rates. Suppose the result predicate sees $p,m$ and just one value $K(s)$ computed from the mode. Which choices of $K$ preserve that whole domain? [Derivation of the domain](thesis-review-14.html#domain)

**Theorem.** A shared result relation exists exactly when every ordered pair of modes satisfies
$$
K(s)=K(t)\quad\Longrightarrow\quad C_s+d_t\le L.
$$
The supplier in mode $s$ has to fit the caller in mode $t$ whenever the result type gives them the same key. Equivalently, within each key class every lower endpoint $C_s$ lies below or at every upper endpoint $L-d_t$. The theorem quantifies over arbitrary result relations. The explicit certificates below also give formulas in the thesis language. [Lean theorem `shared_iff`](thesis-review-15.lean)

For sufficiency, let the result at key $z$ guarantee $p\le r$ and impose $r\le\max(p,m+L-d_t)$ for every $t$ with $K(t)=z$. The pairwise inequality puts every supplier result below every required upper bound. At a child reached from mode $t$, the cap arm becomes $(m+d_t)+L-d_t=m+L$. The input guard already places its floor $p+e_t$ within the caller's limit. The base and recursive input obligations follow from the domain above.

For necessity, put $x=m-p$. If $d_s\ge e_s$, the slack stays level or rises during recursion. At sufficiently large $x$ the supplier obligations force the shared relation to include a payload $x+C_s$ above the floor. This follows by growing the payload one grid unit at a time. Choose a caller in mode $t$ whose child has this same floor and $x$. Its own limit forces $x+C_s\le x+L-d_t$. If $d_s<e_s$, admissibility forces $e_s=0$. Assume $C_s+d_t>L$ and place the recipient's child at $x=d_t-L$. Its parent allows nothing above the child's floor. At those coordinates the source can take its base value and offer a payload one grid unit above the floor, a contradiction. The proof uses integer numerators. For rational data a common denominator for the offending pair and the fixed constants gives the same witness. [Payload growth lemma](thesis-review-8.lean) · [Both necessity cases](thesis-review-15.lean)

## No least choice of parameters {#keys}

Take $L=20$ and $C(e)=\min(19,22-2e)$. The interval of possible upper-bound offsets for one mode is $[C(e),20-d]$.

| Floor rate $e$ | Cap rate $d$ | Interval |
|---|---|---|
| 3 | 4 | $[16,16]$ |
| 4 | 4 | $[14,16]$ |
| 4 | 6 | $[14,14]$ |

Keeping $d$ lets the first and second rows share a result predicate. Keeping $e$ lets the second and third share one. Both choices work on the full program. Any key that forgets at least as much as both choices would identify all three rows by transitivity. The first supplier and third caller violate the theorem since $16+6>20$. Even among three modes there is no least sufficient partition. On the infinite edge $e=n+2$, $d=2e-2$ for natural $n$, every interval is a different singleton. A finite set of tags cannot represent all these distinctions. One captured numeric parameter still suffices. [Proofs `no_common_coarsening` and `edge_key_injective`](thesis-review-15.lean)

Restricting the input predicate cannot repair the first/third clash if it must admit just two particular calls. Take the first mode at $p=m=0$ and the third mode at $p=-4,m=-6$. The latter's child has $p=m=0$. The actual first call returns 16 at depth four. Feeding 16 to the latter's primitive exceeds its limit of 14 and triggers its assertion. Each call executes successfully with its own children. The Lean proof derives incompatibility for every pair of input predicates admitting these calls and every common result relation, using only the primitive declarations. [Two-client proof](thesis-review-15.lean) · [OCaml witness](thesis-review-15.py)

## Exactly which affine keys suffice {#affine}

On the full crossing-cap domain a scalar key $z=ae+bd+c$ with rational coefficients suffices exactly when $(a,b)$ is nonzero and both coefficients are nonnegative or both are nonpositive. The constant $c$ has no effect. To see sufficiency, write $h(e)=20-C(e)=\max(1,2e-2)$. An incompatible pair would satisfy $d_t>h(e_s)$. Since $d_s\le h(e_s)$ and $d_t\le h(e_t)$, both $d$ and $e$ strictly increase from $s$ to $t$. Every such nonzero same-sign key separates the two modes.

For opposite signs, clear denominators and reverse the sign if needed to write the key as $ve-ud$, with positive integers $u,v$. Take $E=v+2u+3$ and $D=2E-2-\max(0,v-2u)$. Both $(E,D)$ and $(E+u,D+v)$ are admissible. The key has the same value on both, yet $D+v>2E-2=h(E)$. The first and third rows of the table rule out a constant key. [Checked classification `scalar_interface_exact`](thesis-review-15.lean)

**Each sufficient key has a short certificate.** Choose the sign that makes the coefficients nonnegative, drop the additive constant and write $A=a+2b$. Alongside $p\le r$, take
$$
r\le\max(p,m+19),\qquad Ar\le\max\bigl(Ap,Am+22a+40b-2z\bigr).
$$
The second cap's offset is the weighted average of the supplier arm $22-2e$ and the caller arm $20-d$, with weights $a$ and $2b$. Both arms bound the effective supplier offset from above. If $19\le20-d$, the first cap suffices for the caller. Otherwise feasibility gives $22-2e\le20-d$ and the weighted average fits too. This supplies three result atoms for every sufficient affine key, in addition to the four input atoms. For $z=d$ the simpler result $p\le r\le\max(p,m+20-d)$ already suffices. [General interpolation proof `weighted_cap_scheme`](thesis-review-15.lean) · [Six-atom scheme](thesis-review-14.html#domain)

Can one replace the two upper bounds by $r\le\max(p,m+H(z))$ with a single affine offset $H$? On any mode with $e\le d$, such an offset must lie in $[C(e),20-d]$. At large slack the supplier can fill its own cap, and a caller must accept the largest value allowed by $H$. The modes $(0,1)$ and $(1,1)$ therefore both force $H=19$. If $a\ne0$ their key values are distinct, so an affine $H$ would be constant. But $(3,4)$ forces $H=16$. Thus among the sufficient scalar keys, exactly the nonzero multiples of $d$ (up to an additive constant) permit this single affine cap over the full rational domain. [Band bounds and affine obstruction](thesis-review-15.lean)

For $z=e+d$ the weighted bound reads $3r\le\max(3p,3m+62-2z)$. The supplied program takes $z,d,p,m$ as inputs and exposes only $z,p,m$ in its annotated result. InvarGenT checks it. Erasing the annotation also succeeds with the default pass budget. The inferred result in that run retains both rate coordinates. These two executions distinguish successful discovery of a valid type from discovery of a particular sufficient parameter set. [Program](sum_key.gadt) · [Inference and interface checks](thesis-review-15.py)

## Establishing witness equations during abduction {#equations}

Revision `752520c` failed on pass 1 even with the shorter crossing-cap type written out. It also failed on pass 2 on the unannotated double-rate program for every outer budget that got that far. In a numeric branch $P\Rightarrow E\land D$, the equations $E$ identify witnesses used by an extremum in $D$. Revision `29e5974` gives numeric abduction two successive obligations,
$$
P\Rightarrow E,\qquad P\land E\Rightarrow D.
$$
Both uses of $E$ have the same candidate answer and the same witnesses. Pointwise the first judgment supplies the premise needed by the second, so the transformation commutes with the surrounding quantifiers. Branch validation and liveness still use the original branches. The change applies when a conclusion contains equations and an extremum. With it the written type checks and the unannotated double-rate program infers its six-atom scheme under the default settings. [Logical equivalence](thesis-review-15.lean) · [Historical and repaired runs](thesis-review-14.py) · [Written-type control](thesis-review-15.py)

The original common-atom induction jump still gives a negative answer to the general bounded-solution conjecture. On its two-inequality program one whole pass restores the same stored state and regenerates the same nonempty caller demand. Induction repeats the failed stopping test at every later pass. That recurrence was repaired. On today's solver the two-result moving-floor program still exhausts outer budgets 11 and 80 despite its six-atom certificate. A proof that it exhausts *every* budget would have to track the state of its backtracking search. [Original recurrence](thesis-review-3.html#update) · [Two-result certificate and remaining convergence question](thesis-review-13.html#tag)

## Preserving the checked bound in the exported interface {#printing}

The sum-key certificate exposed an independent error. When writing a min or max constraint, InvarGenT isolated a variable common to the two arms and silently dropped its coefficient. Even the function that returns the first of two arguments demonstrated the effect. Give it the result constraint $3r\le\max(3i,3j)$. The old interface printed $r\le\max(3i,3j)$. At $i=j=-1$ a client reading the signature could conclude $r\le-3$. That client passed typechecking and its assertion failed on the returned value $-1$.

Revision `e5cd09c` prints the coefficient on the isolated term. Reading the exported signature back now rejects the false client. Equality and inequality round trips cover both directions of min and max, including rational coefficients. The sum-key program also round-trips a genuine non-unit bound. At $p=m=-100$, $z=7$, $d=4$, the reimported signature proves $r\le-84$ and rejects $r\le-252$. [End-to-end signature tests](thesis-review-15.py)

Lean 4.19.0 checked the proofs. Compile `thesis-review-8.lean` and `thesis-review-14.lean` in that order with `lean -o`, placing the matching `.olean` files on `LEAN_PATH`, then run `lean thesis-review-15.lean`. The OCaml 5.3 compatibility suite passed 295 tests with 10 existing TODOs. All 141 previously generated signatures matched byte for byte. The comparison driver takes the InvarGenT executable and optionally `--before-equations` with a binary from `752520c`. [Runnable checks](thesis-review-15.py)
