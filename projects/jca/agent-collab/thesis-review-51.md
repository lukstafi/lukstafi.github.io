---
title: "Which input types must an existential result remember?"
date: 2026-11-22
---

Consider a recursive function with three arguments. It opens a hidden payload of type $h$, takes a known value of type $b$, and ignores an argument of type $c$. At depth zero it returns the payload twice with the known value between the two copies. At positive depth it calls itself. InvarGenT infers, up to renaming,
$$
  \forall b,c.\quad \mathrm{Hidden}\to b\to c\to\mathrm{Nat}
       \to \exists h.\,(h,(b,h)).
$$
The generated OCaml declares a package with exactly one type parameter, $b$. A caller can compare the middle component with the known argument, or the two hidden components with each other. Both clients type-check and run. A third client that equates the hidden type with the known argument's concrete type is rejected. [Source and compiler replay](thesis-review-51.py)

For conjunctive free-term predicates there is an exact test for which input types a package must remember. It also explains why changing admission can move one feedback step in either direction, while the *least inductive results* for the two admissions obey a definite order.

## Which distinctions can one admission express? {#representation}

Let $A(x,k)$ admit a package key $k$ at a public input $x$. Put $D(x)=\exists k\,A(x,k)$. For a stored postcondition $P(k,r)$ the admitted opening is
$$
  U(x,r) = D(x)\land\forall k\,(A(x,k)\Rightarrow P(k,r)).
$$
Keep $D$ even if no result opens at some admitted input. An input to a diverging recursive call can be typeable. Fix ambient parameters throughout, or include the public ones explicitly among the input coordinates. A satisfiable equational admission is one pattern $(p,q)$, and its admitted opening with a term-pattern package is again a pattern or empty. [Term representation and elimination proof](thesis-review-50.html#eliminate)

Write $x\sim_A y$ when the two inputs share a key. The ground match of $x$ against $p$ determines all holes of $p$. Its menu of keys consists of the instances of $q$ with the holes shared between $p$ and $q$ fixed by that match. A key determines those same holes on its side. Thus the menus at admitted inputs are equal or disjoint. On $D$, $x\sim_A y$ holds exactly when their matches agree on every shared hole.

**Representation theorem.** A proposed public term pattern $U$, including the empty relation, is expressible at admission $A$ exactly when its inputs lie in $D$ and its result sections agree for any two inputs sharing a key. When expressible, its least stored package is
$$
  P_A(k,r) = \exists y\,(A(y,k)\land U(y,r)).
$$
Compute it by unifying the input coordinates of two freshly renamed patterns and projecting to $(k,r)$. This returns one pattern or empty. Every realization must store these rows, since each result opening at $y$ must be available at every key of $y$.

To see exactly what this construction does, open $P_A$ at $x$. From any admitted key at $x$ storing $r$ one obtains a source $y$ that admits this key and has $U(y,r)$. Conversely, if such a $y$ shares one key with $x$, its menu contains *every* key of $x$, so $r$ opens there. The resulting public relation is precisely $\exists y\,(x\sim_A y\land U(y,r))$. This proves sufficiency. Necessity follows because equal menus give equal openings. [Lean proofs of representation, saturation and least storage](thesis-review-51.lean)

## Reading the smallest capture set from the result {#captures}

Fix a nonempty domain pattern $p(a_1,\ldots,a_n)$ with each distinct hole listed once. The $a_i$ range independently over ground terms. Suppose the proposed public result $U$ lies over this domain. Which of the $a_i$ must appear in the key pattern $q$? Unify $x=p(a_1,\ldots,a_n)$ with the input of $U(x,r)$ and project onto $(a_1,\ldots,a_n,r)$. For a nonempty result write this lifted pattern as $(w_1,\ldots,w_n,t)$.

**Minimum capture theorem.** An input hole $a_i$ can be forgotten exactly when $w_i$ is a bare hole that occurs just once in the entire lifted pattern. All such coordinates can be forgotten simultaneously. The other coordinates form the unique least set of input holes needed to express this particular $U$. An empty $U$ needs none. The count is of independent input holes, several of which can be bundled into a single key term.

A bare hole occurring once can be varied independently in every matching row. If $w_i$ has a constructor head, take any matching row and replace coordinate $i$ by a ground term with a different head. If $w_i$ is a hole that occurs elsewhere, change its ground value at coordinate $i$ alone. The other occurrence still fixes the old value. In both cases the changed row no longer matches. Forgetting $a_i$ would give the two inputs identical menus, contradicting the representation theorem. This argument uses two available ground root symbols, as in the free type algebra with a constant and the arrow constructor. Capturing precisely the necessary holes gives a key whose equivalence classes preserve $U$. The representation theorem then constructs the package. [Lean proof that single-coordinate dependence determines capture](thesis-review-51.lean) · [Symbolic construction and checks](thesis-review-51.py)

For example, over all inputs $(a,b)$, the result $(a,a)$ requires only $a$. A *constant* result $M$ that opens exactly when $a=b$ requires **both** coordinates. Keeping $b$ alone would make inputs $(B,B)$ and $(M,B)$ indistinguishable. The test therefore accounts for where a result exists as well as for the variables written in the result type. It applies to a specified public result. Different sound answers to the original inference problem can require incomparable captures.

## One feedback step and the least inductive answer {#feedback}

Fix the admitted domain and the ground supplier rules. Each rule tests earlier admitted openings, then requires its destination result at every admitted key there. Take the least inductive *pattern* opening on each of two admissions. If every pair sharing a key on the first admission also shares a key on the second, the first least opening is contained in the second. Indeed, the second opening is constant on the coarser classes, hence on the finer ones. Its least store on the finer admission realizes it exactly and obeys the same suppliers. Leastness on the finer admission gives the inclusion. Existence follows from finite ascending pattern closure with a fixed admission, since opening is monotone in the stored package. This comparison even allows different key types on the two sides. [Transfer proof](thesis-review-51.lean) · [Finite least-package theorem](thesis-review-50.html#iteration)

In particular, capturing every input hole gives the finest partition. With the domain fixed, if its least opening violates a caller forbidding observations, every coarser capture fails too. If a coarser capture already proves the caller, its least result may be less informative. For a base that returns $(x,x)$ at every input $x$, capturing $x$ gives $r=(x,x)$. Forgetting $x$ gives $r=(h,h)$ with $h$ private. Both preserve equality of the components.

The hull of the rows freshly required by one producer step can still move in both directions. Use distinct constants $M,B$. Start from the trial package $P(k,r)$ given by $k=r$. A base stores $M$ at input $M$. A second supplier stores $B$ there if $B$ opens at input $B$. With $k=x$ the second supplier fires, giving the required rows $(M,M),(M,B)$ and their hull $(M,h)$. With every key admitted at every input it cannot fire, and the base forces $(h,M)$. The two fresh hulls are incomparable. Joining each with the trial package would give the unrestricted relation on both sides. Starting the two inductions from empty gives least packages $(M,M)$ and $(h,M)$ respectively. The second supplier never fires in either run. The comparison theorem concerns these inductive answers. [Executable two-input example](thesis-review-51.py)

## When call admission can be inferred in the same iteration {#joint}

Suppose the key interface may capture the public input tuple $x$. For **any** pair of patterns $D,U$ with $U(x,r)\Rightarrow D(x)$, take admission $D(x)\land k=x$ and package $U(k,r)$. The opening at each admitted input is exactly $U(x,r)$. This permits a finite joint inference for systems whose clauses are positive first-order Horn rules on the public predicates $D,U$. A rule can require $D(y)$ as soon as a call must be typeable, and later use $U(y,s)$ when consuming its result. Include $U(x,r)\Rightarrow D(x)$ for each function. Destination inputs in supplier obligations must be admitted for the obligation to require an opening. Static guards may mention the ground values. [Identity-key proof](thesis-review-51.lean) · [Supplier semantics](thesis-review-46.html#opening)

Start every predicate empty. At each step take the pattern hull of its previous rows and all rows forced by the current premises. Each component ascends. After the first nonempty pattern, every strict ascent lowers the number of term nodes minus the number of distinct holes. Thus finitely many predicates stabilize after finitely many changes. Every inductive pattern pair contains every iterate, by positivity and leastness of the hull. Reifying the stationary pair gives a scheme. For conjunctive equational branches each head projection uses unification, and finitely many projected patterns are joined by anti-unification. This computes the **least required call domain** alongside the least inductive opened result for these rules, with no promise on solution size. A downward-closed caller succeeds for some scheme in this class iff it succeeds for the least pair. [Rank and hull proof](thesis-review-50.html#iteration)

For instance, demand a call at $S(M)$, and let a call at $S(x)$ demand a call at $x$. An admitted base at $M$ returns $M$. If $x$ opens $r$, an admitted successor at $S(x)$ returns $S(r)$. The call hull first contains just $S(M)$, then generalizes to every input. The result is still empty at that point. The next two rounds give $(M,M)$ and then $(h,h)$, which is inductive. [Four-round symbolic replay](thesis-review-51.py)

Table 4.4 also chooses abduced assumptions, solves for witnesses under quantifier prefixes, and can change the captured interface. The joint theorem requires that the clauses see keys only through call admission and the all-keys opening, and that the needed input captures are in scope. A client demanding a *particular* key can distinguish even two constant singleton keys giving identical $D,U$. A choice between several admissible call typings can also persist when the rules fail to determine a single required head. Those obligations fall outside the positive iteration. The full search for a most general function domain or for a preferred solution among incomparable schemes remains a separate question. [Table 4.4](../lukstafi-phd-thesis.pdf#page=71) · [Incomparable pure-term function types](thesis-review-50.html#patterns)
