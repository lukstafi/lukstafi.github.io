---
title: "Which caller observations can guide the induction jump?"
date: 2026-11-22
---

The same moving-floor program gives two outcomes in InvarGenT at revision `80624f9`. A recursive call returns a payload and a tag from which the caller can recover that payload. Passing the payload directly to the next operation lets inference finish at the default budget of 11. Recovering it from the tag exhausts budgets 11, 80 and 171. **The type inferred from the first spelling checks the second spelling verbatim.** Both generated OCaml programs execute the stationary and rising calls. [Source](tagged_floor.gadt) · [Executable comparison](thesis-review-18.py)

A subsequent repair makes both spellings converge on pass 9 by substituting the recursive call’s actual floor into the conclusion equations. [Repair and signed affine tags](thesis-review-19.html)

## Eliminating a determined result coordinate {#graph}

At floor $p$ the base branch returns $(p,2p)$. Each returning arm of the successor produces either $(u,u+p)$ or $(p,2p)$. Thus every returned pair $(r,t)$ satisfies $t=r+p$, independently of how the abducer estimates the range of $r$. The recursive call uses floor $p+e$. Its caller passes $t-(p+e)$ to `step`. On every possible return this is $r$. Changing that one argument preserves the recursion, the pair type, the primitive declaration and both attached calls.

The inferred type has the four input conditions
$$
 d\le1,\qquad 0\le e,\qquad e\le\max(0,d),\qquad e\le\max(0,m-p+20).
$$
Its result is $\exists r\,[p\le r\land r\le\max(p,m+19)].\,(\mathrm{Num}(r),\mathrm{Num}(p+r))$. The equality appears in the type of the second coordinate, so the consumer can use it without an extra abductive guess. At budget 171 the original spelling still reports “Answers do not converge”. Whether some larger budget suffices for that spelling remains open. [Earlier jump and restart trace](thesis-review-16.html#restarts)

**Graph lemma.** Let $x$ include the inputs, captured parameters and payload of a scalar state. Enlarge each state with a tag $g(x)$, and write $L(R)=\{(x,g(x)):x\in R\}$. Let $F(R)$ contain all bases and one-step successors from $R$, with $F'$ the corresponding supplier operation on tagged states. Suppose the tagged bases are exactly the images of the scalar bases. Suppose that from $(x,g(x))$ the tagged transition can produce $(y,t)$ exactly when the scalar transition can produce $y$ and $t=g(y)$. Then
$$
 F'(L(R))=L(F(R)).
$$
A base or transition witness projects to the scalar witness. Conversely, append $g$ to each state of a scalar witness. A caller test $A(x,t)$ accepts every member of $L(R)$ exactly when $A(x,g(x))$ accepts every $x\in R$. These two identities transport supplier obligations, caller obligations and inductive certificates. They hold for arbitrary $R$, including the approximations *before* a solution is known. [Lean proof](thesis-review-18.lean)

This gives a sufficient rule for a jump on a fixed interface. Once the branches prove the graph equation, run the scalar widening and caller abduction on the projected constraints and restore the tag when storing the answer. Each scalar pass lifts to a tagged pass by the two identities, provided the split answers, empty-demand test and retries are transported too. Induction on the pass number gives the same stopping pass for the projected iteration. The observed difference between the two spellings shows that the current search does not have this invariance. Finding the graph and its captured floor during reconstruction remains a separate obligation.

## A constant-size certificate for which every outer budget fails {#guard}

The four constructors of `Tag` each put their payload type in a different argument position. The three other positions contain `Marker`, abbreviated $M$. The recursive function `f` returns its payload twice at depth zero and calls itself at the same tag at each successor. Give its attached client a value `Pick n` whose integer index is hidden by the constructor. The client opens `f (Third Box) (S Z)` and requires its first component to have type `Cargo` when $1\le n$. The external implementation supplies `Pick 1`, so execution reaches the call. [Guarded source](guarded_payload.gadt)

A solution is $\forall a.\ \mathrm{Tag}(M,M,a,M)\to\mathrm{Nat}\to\exists().\,(a,a)$. On the third constructor its payload has type $a$. Matching any other constructor forces both its payload type and $a$ to be $M$. Recursion preserves $a$, and the client uses $a=\mathrm{Cargo}$. In the erased problem the unary predicate accepts those arrow instances and the binary predicate relates the pair $(a,a)$ to the captured tuple $\langle a\rangle$. Thus the certificate covers the suppliers, recursive use and client for every value of the hidden index. InvarGenT checks the written type and the driver executes both `Pick 0` and `Pick 1`. [Erased predicate witnesses](thesis-review-16.html#package) · [Driver](thesis-review-18.py)

With the annotation erased, the full search proposes two inputs on pass 0. Pass 1 rejects each with a type mismatch. Pass 0 then exhausts term abduction. Deferring the three external result-opening clauses gives four proposals. Each fails on pass 1 and term abduction again fails on pass 0. The normalized client guard is $1\le n$ with $n$ unknown, so the required-call test below finds no further input sample. The two searches read the outer budget only at the end of successful pass-0 updates. The pass-1 errors return before the comparison, and neither search reaches a stable proposal. **Every positive outer budget therefore follows the same finite failing path**, with the component settings at their defaults. Budget zero stops at the first comparison. The driver checks budgets through 10,000.

This example refutes a guarantee of successful discovery under a bound on certificate size for the revised implementation. Its type has zero constraint atoms. The earlier common-atom induction jump gives a different failure, where a caller restores the same upper bound on every pass forever under that update rule. Table 4.4 leaves choices to its component algorithms. A finite exhaustive search over bounded, checkable certificates would have a different guarantee. [Infinite recurrence and its repair](thesis-review-3.html#update) · [Bounded certificate search](thesis-review-2.html)

## When a call can rule out a guess {#coverage}

Suppose a client in public context $b$ supplies argument $t(b)$ whenever a private witness $w$ satisfies $G(b,w)$. A candidate input domain $D$ must admit every argument of a guarded call. When does this license checking $t(b)$ in *all* contexts, for every $D$? Exactly when every such argument has a guarded representative. Formally, for each $b$ there are $c,w$ with $G(c,w)$ and $t(c)=t(b)$. For sufficiency use the obligation at $c$. For necessity choose $D$ to be the set of arguments with a guarded representative. If the candidate can distinguish public contexts too, include $b$ in the observable argument. The condition then becomes $\forall b\,\exists w.\,G(b,w)$. For a fixed argument the check needs just one reachable call. [Lean equivalences](thesis-review-18.lean)

Revision `80624f9` uses a sufficient case of this rule. After the existing searches report a type failure, it reads calls with empty guards or numeric guards entailed by unconditional numeric facts. It matches the arguments in the common prefix of the call and definition arrows. Each call instantiates the proposed type separately, preserving repeated variables within that call. These comparisons guide the first term-abduction pass of the retry. The complete original clients still have to pass. In particular, a call at `Third Box` and another at `Third Mark` can use the same polymorphic scheme.

For the direct four-constructor call the solver now confirms the result on pass 6, with the arms in their original order. It does the same under $1\le n$ when the unconditional facts set $n=1$. The ordinary unboxed pair succeeds on pass 2. An incompatible result test and simultaneous marked calls on two different axes are rejected. Incremental validation also needed an occurs check. Given $a=\mathrm{Box}(b)$, the previous validator admitted $b=\mathrm{Wrap}(a)$ because $b$ had no binding of its own. Revision `d41f835` composes the binding with the current substitution and detects the cycle. [Original four-way trace](thesis-review-17.html#four) · [Regression programs](thesis-review-18.py)

## Which input types solve the marked-call problem? {#patterns}

Take $m$ constructors, a payload type $C\ne M$ and a client calling constructor $j$ with a payload of type $C$. Restrict attention to conjunctions of finite free-type equations with existential witnesses. Require the common all-$M$ input to be admitted. Every constructor can produce a value there. Project a solution to its $m$ input indices and the first component of the returned pair. Joint unification and projection give a single tuple pattern for this relation. [Projection lemma](thesis-review-1.html)

**Classification.** The selected input and the observed result must be the same hole $a$. Each other position is pinned to $M$ or belongs to a group of at least two positions sharing a hole of their own. Every pattern of this form is the projection of a solution.

The all-$M$ input returns $M$, so the pattern contains the all-$M$ row. Since $M$ is nullary, each coordinate of the pattern is either $M$ or a bare hole. The marked row has $C$ at $j$ and in the result, and $M$ everywhere else. The holes at $j$ and in the result can occur in no other input. If they were different, one could change just the result hole to $M$ on the marked row. That would violate the client's guarantee. Now suppose an unmarked input hole occurs just once. Give it $C$ and set all other holes to $M$. Its constructor would return $C$ where the pattern predicts $M$. Conversely, a pair of tied unmarked positions forces their common type to $M$ whenever one of them supplies the constructor, since its partner is $M$. Each admitted constructor therefore returns the selected type. Returning $(a,a)$ supplies a full scheme at every recursive depth. [Lean proofs for the marked call and repeated holes](thesis-review-18.lean)

There are exactly $B_{m-1}$ projected patterns up to hole renaming, where $B_n$ is the number of partitions of $n$ labeled positions. The singleton blocks are the pins. Compare these patterns by inclusion on **all ground type tuples**. A pattern is maximal exactly when it has at most one pin and every free group has size two or three. Two pins can be freed together. A group of at least four can be split into two free groups. Conversely, an enlargement can pin only a previously pinned coordinate. Any equality it keeps must already hold for every old assignment. Thus its free groups can only split an old group or release old pins together. Neither change is possible under the stated conditions.

For four constructors and the third marked, there are five patterns. The inferred $(M,M,a,M)$ lies below the four incomparable maxima
$$
 (b,b,a,b),\quad (M,b,a,b),\quad (b,M,a,b),\quad (b,b,a,M).
$$
All five admit exactly the same **constructor-built** ground inputs. They give different interfaces to an abstract caller. A forwarding function inferred against the first maximal annotation accepts $\mathrm{Tag}(b,b,a,b)$ at arbitrary $b$. Against the inferred all-pinned type it requires $b=M$. InvarGenT checks all four written maxima, and the driver compiles and executes their OCaml together with calls on the other constructors. Enumerating the ground truth tables over $M,C$ for one through seven axes gives $1,1,1,4,7,25,85$ maxima. The classification proof applies to arbitrary ground types.

Lean 4.19 checks the graph, coverage and hole lemmas. Run `python3 thesis-review-18.py` for the independent finite enumeration. Supply an InvarGenT executable to check the programs, and add `--long` to run the arithmetic comparison through pass 171. The OCaml 5.3 compatibility build passed 303 active tests with 10 existing TODOs. All 145 earlier generated interfaces were byte-identical. [Lean proofs](thesis-review-18.lean) · [Comparison driver](thesis-review-18.py)
