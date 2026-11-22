---
title: "When can a recursive result select its own typing?"
date: 2026-11-22
---

The original common-atom induction jump can renew a caller demand forever with a two-inequality solution already in hand. Current InvarGenT finishes that example on pass 9. There is a simpler feedback calculation inside the full problem that *does* stabilize, even with infinitely many keys and results. It explains why a hypothetical bad result can sometimes supply the typing that rules it out. [Original counterexample](thesis-review-3.html#update) · [Repaired jump trace](thesis-review-21.html#feedback)

## Which part stabilizes? {#closure}

Fix the runtime arguments of a call and the declared package. Let $K$ be the keys permitted by its written signature. Write $P(k,r)$ when the package at key $k$ permits payload $r$, including the existence of any private witnesses. In Table 4.4 the binary predicate relates the existential package's payload type to its captured parameter tuple. Here that tuple includes $k$, and fixing the other arguments lets us display just $k$ and the numeric payload index $r$. The recursive function's input predicate determines which keys it actually admits. [Table 4.4](../lukstafi-phd-thesis.pdf#page=71) · [The two predicates in a recursive package](thesis-review-22.html#binary)

For a domain $D\subseteq K$, the strongest result guarantee obtained by using all its typings is $F(D)$. In the other direction, $G(S)$ contains every key compatible with a set $S$ of supplier outcomes.

$$
F(D)=\{r\mid \forall k\in D.\ P(k,r)\},\qquad
G(S)=\{k\in K\mid\forall r\in S.\ P(k,r)\}.
$$

The same rectangle $D\times S\subseteq P$ can be read in either direction, so $S\subseteq F(D)$ exactly when $D\subseteq G(S)$. Each map reverses inclusion. Applying this equivalence twice gives $F(G(F(D)))=F(D)$ and $G(F(G(S)))=G(S)$. **One exact round trip stabilizes the pair.** A direct proof of the first equality is that every old key belongs to $G(F(D))$, and every added key already accepts every result in $F(D)$. [Lean proofs of compatibility and both identities](thesis-review-34.lean)

Suppose the supplier must support every outcome in $B$, some callers require keys $D_0$, and every result the consumer can see must be in $H$. A domain meeting all three demands exists exactly when

$$
D_0\subseteq G(B)\quad\text{and}\quad F(G(B))\subseteq H.
$$

Any candidate domain lies inside $G(B)$, so its package guarantee contains $F(G(B))$. Conversely, $G(B)$ itself witnesses sufficiency. If a call must have a typing, also require $G(B)$ to be inhabited. This gives a local feasibility test when $P,B,D_0,H$ are fixed. In the full table a recursive supplier can change $B$ when its input postcondition changes, and widening can discard a consequence of that supplier. Those are the operations responsible for the earlier recurrence. [Feasibility proof](thesis-review-34.lean) · [Supplier and caller steps of the recurrence](thesis-review-3.html#update)

For example, take $K=\{1,\ldots,n\}$, $0\le r\le n$, and $P(k,r)$ meaning $r\ne k$. Then $F(D)=\{0\}\cup(K\setminus D)$ and $G(F(D))=D$. There are $2^n$ different closed pairs at this one input. The identities bound the length of exact alternation even when the number of possible answers grows exponentially. If the supplier must return 2, key 2 disappears and the full intersection still contains 2. No selection of admitted keys can prove that this outcome is impossible. [Closed-pair and missing-key proofs](thesis-review-34.lean)

## One opening can justify another {#opening}

For the zero-returning program, take an unconditional first typing at key 1. Its package gives $0\le r\le n$. Choose a second key $q(r)=\max(1,r)$. When $r>0$, the new package excludes $r$ itself. This is one result-dependent typing in addition to the first. Any list fixed before seeing the result needs all $n$ keys in total. [Program](punctured_key.gadt) · [Fixed-key lower bound](thesis-review-33.html#puncture)

To apply this rule in a recursive definition, first type the call at $a$. For every payload and private witness allowed by that opening, prove that the inferred input predicate admits $q(r)$ at the same arguments. Only then use $P(q(r),r)$ to check the body. The second package has fresh private witnesses. In the induction on a terminating evaluation, the recursive subevaluation already satisfies each admitted typing. We can apply that hypothesis twice to the same subevaluation, even when evaluating an argument has a side effect. [Opening lemma](thesis-review-34.lean)

InvarGenT generates a positive obligation on the recursive predicate using only the first opening. It also checks the proposed keys against the **final exported domain**. For the first key it starts from arbitrary admitted arguments and an admitted key at those arguments. For the second it may add facts about the first package's payload. Numeric witnesses for changed arrow coordinates are supplied explicitly, then the checker verifies the new coordinate equalities and the entire domain by entailment. This check applies to the earlier fixed-endpoint retry too. The caller still sees the original package contract.

To find a choice, the compiler looks at a disjunctive inequality $f(k,r)\le0\lor g(k,r)\le0$ in the written postcondition. Each strict complement suggests a boundary key. For an increasing integer key coefficient, try the first integer above the root. For a decreasing coefficient, try the last integer below it. The coefficients on the observed input and result indices must be integral. The compiler clips the proposed key to the written interval. The guard and the inferred domain are checked separately for every successful proposal.

| Key excluded by a hypothetical payload $r$ | Written key interval | Outcome at budget 2 |
|---|---|---|
| $r$ | $[1,n]$ | Accepts and prints 0 |
| $r-1$ | $[1,n]$ | Accepts the guard $2\le r\le n$ and prints 0 |
| $n+1-r$ | $[1,n]$ | Accepts and prints 0 |
| $2r+1$ | $[3,2n+1]$ | Accepts and prints 0 |

The signature checks compare the exported domain and postcondition with their written meanings over integers and rationals. An effect in the argument of a depth-two call runs exactly twice. The punctured-key program with unbounded $n$ failed at revision `4fd76e5`. It now finishes on pass 2, before the induction jump. [Executable replay, signature checks and trace assertions](thesis-review-34.py)

### What goes wrong if the inferred domain is skipped? {#admission}

Change the base result from 0 to 2. At width 3 the recursive branch now enters the guard $1\le r\le n$ and returns a Boolean where a number is required. An experimental build with only the final admission check disabled accepts the definition. Even that build exports the narrowed domain $n\ge2$, $1\le k\le n$, $k\ne2$ on integers. Its generated OCaml reaches the erased branch and raises an assertion. The positive call obligation in the generated constraints was present throughout this experiment.

The repaired checker rejects the candidate at $r=2$, where the proposed key is precisely the missing key. Replacing both step bodies by the number 2 gives a well-typed control. It exports that same narrowed domain and prints 2. [Mutation, reachable guard and live control](thesis-review-34.py) · [Arithmetic countermodel](thesis-review-34.lean)

## How much must the selector observe? {#observations}

For any inhabited admitted domain $D$ and *any* projected postcondition $P$, there exists a single result-dependent selector $q$ such that $q(r)\in D$ and $P(q(r),r)\iff r\in F(D)$. If a key excludes $r$, choose one. Otherwise choose any admitted key. This is a classical existence proof. A compiler still needs a representation for the selector and a coverage proof in its constraint language. With private witnesses, excluding a payload at one key requires excluding every possible witness at that key. [Full-observation theorem](thesis-review-34.lean)

Suppose instead that a selector can see only $o(r)$. For a bad result $r$, let $E_r=\{k\in D\mid\neg P(k,r)\}$. At most $m$ selected keys per observation suffice **exactly when**, in each observation class, a set of at most $m$ admitted keys meets every $E_r$ for the bad results in that class. Necessity follows by inspecting the selector's list for that observation. For sufficiency, choose one such list in each class. Any facts already obtained at a first opening can be used to restrict the bad results in this statement.

In the punctured example $E_r=\{r\}$ for each positive result. Thus each distinct positive in an observation class costs one key. Listing precisely those positives attains the bound. With $d$ available observation values, distributing $n$ positives as evenly as possible gives the sharp worst-class cost $\lceil n/d\rceil$ for $n,d\ge1$. This counts the keys used to exclude those $n$ results. [Observation criterion, cardinality bound and attainment](thesis-review-34.lean)

## A result can be visible and still need a piecewise key {#signed}

Let $-n\le r\le n$, $1\le k\le n$, and require $r\ne k$ and $r\ne-k$. The full intersection is $\{0\}$. The first typing at key 1 leaves the interior payloads $2,-2,3$ possible when $n\ge4$. To refute them with one more typing the selected keys must be $2,2,3$ respectively. All three keys are strictly inside $[1,n]$. Clipping leaves the affine target unchanged at those points. A line taking the same value at 2 and $-2$ is constant, so it cannot take value 3 at 3. This argument allows the slope and intercept to depend on the fixed width. The single piecewise choice $q(r)=\max(1,|r|)$ covers the entire interval. [Machine-checked separation](thesis-review-34.lean)

The compiler tries both affine targets $r$ and $-r$ for this definition. Budgets 2, 40 and 10,000 produce byte-identical diagnostic traces. The guard is still live and no induction jump runs. Adding $r=0$ to the written package checks and executes at budget 2. This leaves a concrete question about the general iteration. Can it construct the missing piecewise selector from failed guard checks while preserving independent admission for each choice? [Signed program](signed_result_key.gadt) · [Trace and strengthened control](thesis-review-34.py)

The compiler change is revision `72c1ec3`. The OCaml 5.3 compatibility build passed all 350 active suite tests, with ten existing TODOs. All 178 previous example signatures matched byte for byte. The source replays use OCaml 5.5.

Run Lean 4.19 on `thesis-review-34.lean`. With OCaml and Python's `z3-solver`, run `python3 thesis-review-34.py /path/to/InvarGenT.native`. Use `--original` with revision `772b9b4` to replay the original timeout and the delayed jump that succeeds. The optional `--before` uses revision `4fd76e5`. For `--trace`, apply the four earlier diagnostic patches followed by the key diagnostics. For `--unchecked`, in an experimental checkout replace the final call `admits_key_query query sig_cn t scheme loc` by `true`. [Earlier diagnostics](thesis-review-28.html#policy) · [Key diagnostics](thesis-review-34-keys.patch)
