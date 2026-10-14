---
title: "Dependent Types from Rocq to Lean 4"
subtitle: "A mathematical refresher on constructions, computation, and proof"
author: "Łukasz Stafiniak and Codex"
date: 2026-10-12
header-includes:
  - |
    <style>
    .katex-display { overflow-x: auto; overflow-y: hidden; padding: 0.3em 0; }
    article table { display: block; max-width: 100%; overflow-x: auto; }
    pre.sourceCode code span { color: inherit; }
    article blockquote { padding-left: 1rem; }
    </style>
---

Suppose you want to state that every finite-dimensional vector space has a basis. On paper, the dimension, the vector space, the basis vectors, and the proof that they form a basis coexist comfortably in one sentence. A formal language must explain their dependencies. A basis with $n$ vectors is a different kind of object from a basis with $m$ vectors; the assertion that these vectors span refers to the particular vectors; and a construction of a basis differs from an assertion that one exists.

Dependent type theory gives these dependencies a uniform notation. Types may depend on values. Proofs inhabit types expressing propositions. Functions can return both mathematical objects and evidence about them. The interesting work begins when we ask which distinctions the system preserves, which it identifies automatically, and which require a theorem.

This article offers a route back into the subject for someone who once knew Coq, now called Rocq, and a route into Lean for a mathematician new to dependent types. The common foundation is the Calculus of Constructions and its extensions with inductive types. Lean and Rocq make different choices within that family; understanding those choices explains much of Lean's behavior. Programmers who know GADTs from Haskell or OCaml get a section of their own, which other readers can skip.

Milo Moses's [A critical look at Lean4](https://www.lesswrong.com/posts/zHhGa3iQBQcdSifFL/a-critical-look-at-lean4-1) supplies the occasion. It raises questions about normalization, consistency, and the reliability of implementations. We will return to those after developing enough of the machinery to distinguish them. The mathematical exposition comes first: what a proof term is, how computation enters a type, and what happens when equality itself becomes an object of reasoning.

## Families of types and dependent functions

A familiar function has a fixed codomain: $f:A\to B$. A dependent function has a codomain that varies with its input:

$$f:\prod_{x:A}B(x).$$

Here $B$ assigns a type $B(x)$ to each $x:A$. To give $f$ is to give an element $f(x):B(x)$ uniformly for each $x$. Geometrically, think of a family of fibers over $A$ and a section choosing a point in each fiber. This analogy concerns the dependency alone; continuity or smoothness would be additional conditions.

For example, let $B(n)$ be the type of tuples of length $n$. A function that produces a zero tuple for every length has type $\prod_{n:\mathbb N}B(n)$. Its result type records the length it was asked for. A function returning a list and a separate promise about its length carries similar information in a different representation.

Lean writes a dependent function type as `(x : A) → B x`. Application is juxtaposition, and `fun x => t` is function abstraction. Curly braces mark arguments that Lean should usually infer. These are the basic conventions of its [dependent type language](https://lean-lang.org/theorem_proving_in_lean4/Dependent-Type-Theory/).

Here is dependent composition. The result of `g` depends on the value that `f` produces:

```lean
universe u v w

def dependentCompose {A : Type u} {B : Type v}
    {C : B → Type w} (f : A → B) (g : (b : B) → C b) :
    (a : A) → C (f a) :=
  fun a => g (f a)
```

Read the signature before the body. `C` is a family over `B`; `g` selects an element in each fiber; composing with `f` produces a section of the family pulled back to `A`. The body is ordinary composition. The type records the dependency that ordinary function notation suppresses.

Typing is expressed by a *judgment*, conventionally

$$\Gamma\vdash t:T.$$

It says that, under the declarations collected in the context $\Gamma$, the term $t$ has type $T$. A context might contain `A : Type`, `x : A`, and `P : A → Prop`. The order matters: a declaration can depend on earlier declarations.

The colon here belongs to the language of judgments. By contrast, a proposition `x ∈ S` is itself a type whose inhabitants are proofs. Thus “this term has the wrong type” and “this mathematical proposition is false” are different claims.

Three rules explain dependent functions. Suppressing universe side conditions for the moment, they have the following shapes:

$$\frac{\Gamma\vdash A\ \mathrm{type}\qquad\Gamma,x:A\vdash B(x)\ \mathrm{type}}
{\Gamma\vdash\prod_{x:A}B(x)\ \mathrm{type}}$$

$$\frac{\Gamma,x:A\vdash t:B(x)}
{\Gamma\vdash(\lambda x:A.\,t):\prod_{x:A}B(x)}$$

$$\frac{\Gamma\vdash f:\prod_{x:A}B(x)\qquad\Gamma\vdash a:A}
{\Gamma\vdash f\,a:B(a)}.$$

The first forms the function type, the second constructs a function, and the third applies it. The substitution in the final result type is the dependent part: applying `g` to `f a` produces a term of `C (f a)`, exactly as in the example. The accompanying computation rule is beta reduction, $(\lambda x.\,t)\,a\longrightarrow t[a/x]$, with substitution avoiding accidental capture of variables.

## Why implication and universal quantification are function types

A proof of $P\to Q$ transforms any proof of $P$ into a proof of $Q$: it is a function. A proof of $\forall x:A,\,P(x)$ supplies a proof of $P(x)$ for every $x$: it is a dependent function. This is the propositions-as-types correspondence.

> **Syntax note.** Lean's `∀ (x : A), B x` and `(x : A) → B x` are the same dependent function type.

The proof of an elementary implication is therefore a small program:

```lean
theorem composeImplications (P Q R : Prop)
    (hPQ : P → Q) (hQR : Q → R) : P → R :=
  fun hP => hQR (hPQ hP)
```

The same proof can be constructed interactively:

```lean
theorem composeImplicationsBy (P Q R : Prop)
    (hPQ : P → Q) (hQR : Q → R) : P → R := by
  intro hP
  apply hQR
  exact hPQ hP
```

After `intro hP`, the context contains a proof of `P` and the goal is `R`. Applying `hQR` reduces that goal to `Q`; the final line supplies its proof. The kernel checks the resulting proof term. See Lean's [propositions and proofs tutorial](https://lean-lang.org/theorem_proving_in_lean4/Propositions-and-Proofs/).

Other logical connectives have corresponding constructors and elimination rules:

| Mathematical statement | Evidence to construct it | How to use the evidence |
|---|---|---|
| $P\land Q$ | A proof of each conjunct | Project either proof |
| $P\lor Q$ | A chosen disjunct and its proof | Reason by cases |
| $\exists x:A,\,P(x)$ | A witness and a proof about it | Reason about an arbitrary such witness |
| $\bot$ | No constructor | Derive any proposition from it |

Negation is $\neg P := P\to\bot$: assume $P$ and derive a contradiction. Classical logic adds principles such as double-negation elimination, $\neg\neg P\to P$, which the rules above do not provide.

Rocq's `forall x : A, P x` becomes `∀ x : A, P x`; `fun x => t`, `intros`, `apply`, and `exact` remain recognizable. The treatment of proofs and equality changes more substantially.

## The Calculus of Constructions and its descendants

The Calculus of Constructions, developed by Thierry Coquand and Gérard Huet, brought together dependent types and powerful polymorphism in one typed lambda calculus. Their [1988 paper](https://rocq-prover.org/papers/the-calculus-of-constructions) proves strong normalization: every reduction sequence from a well-typed term terminates. Extensions to the calculus require their own metatheoretic arguments.

For a returning type theorist, the lambda-cube description is a useful memory aid. Begin with simply typed functions. Add terms parameterized by types, type constructors parameterized by types, and types parameterized by terms. CoC combines all three forms of dependency. In the usual two-sort presentation there is a lower sort $*$ and an upper sort $\square$, with $*:\square$. Dependent products permit all four combinations of domain and codomain sorts. There is no axiom $\square:\square$.

For the mathematician, the payoff is uniformity. The same substitution operation instantiates a polynomial at a number, a construction at a vector space, or a theorem at a hypothesis. Types and terms share a syntax, while typing rules prevent arbitrary self-reference.

Pure CoC does not begin with a primitive natural-number type and the induction principle used in ordinary mathematics. Polymorphism permits Church encodings: an encoded natural number can describe iteration. But obtaining the desired dependent induction and computational behavior motivates a richer system with *primitive inductive definitions*. The [early history of Coq](https://docs.rocq-prover.org/master/refman/history.html) traces this development, including the work of Christine Paulin-Mohring.

Rocq's core language is a version of the **Calculus of Inductive Constructions**, or CIC. It includes a hierarchy of universes and rules for inductive families, recursive definitions, and coinductive constructions. Its [typing rules](https://docs.rocq-prover.org/master/refman/language/cic.html) specify a much more substantial language than the original CoC.

Lean belongs to the same broad family, with its own universe discipline, definitional proof irrelevance, primitive quotients, and rules governing inductives. These choices affect both everyday proofs and the metatheory; we will examine each in turn.

## Universes and the special role of propositions

Since types appear in expressions, they need types of their own. Lean uses a hierarchy:

$$\mathrm{Sort}\ u:\mathrm{Sort}\ (u+1).$$

`Prop` abbreviates `Sort 0`; `Type u` abbreviates `Sort (u + 1)`; bare `Type` means `Type 0`. Consequently, `Nat : Type` and `Type : Type 1`. Universe variables such as `u` are level parameters, distinct from ordinary natural-number variables inside a program.

The levels constrain self-reference. In the usual expressive dependent calculi, simply imposing a universal `Type : Type` permits paradoxes. A hierarchy lets us quantify over a collection of types without placing that collection inside itself.

Lean's [universe rules](https://lean-lang.org/doc/reference/latest/The-Type-System/Universes/) can be compressed into one formula. If $A:\mathrm{Sort}\ u$ and $B(x):\mathrm{Sort}\ v$, then

$$\left(\prod_{x:A}B(x)\right):\mathrm{Sort}(\operatorname{imax}(u,v)),$$

$$\operatorname{imax}(u,v)=\begin{cases}0&v=0,\\\max(u,v)&v>0.\end{cases}$$

Thus a proposition may quantify over objects in arbitrarily high *fixed* universes and remain a proposition. This is the impredicativity of `Prop`. For example, `∀ P : Prop, P → P` is itself a proposition, although its quantifier ranges over all propositions, including that one.

Data universes are predicative. A type of functions ranging over all small types generally lives higher than those small types. Impredicativity and `Type : Type` are different design choices; the former does not by itself imply the latter.

One practical trap for a Rocq user is **cumulativity**. Rocq permits smaller universes to embed into larger ones through its typing discipline. Lean does not automatically regard a type in `Type u` as an inhabitant of `Type (u + 1)`. Universe polymorphism often removes the need for lifting, but explicit constructions such as `ULift` are available when needed.

Rocq's `Set` is a sort for small computational data, which Lean places in `Type`; Lean's `Set α` is the type of predicates on `α`. The shared spelling conceals different roles.

## Induction is dependent recursion

Natural numbers are specified by a zero constructor and a successor constructor. Their dependent eliminator has the mathematical shape

$$
\begin{aligned}
\operatorname{rec}_{\mathbb N}&:
\prod_{C:\mathbb N\to\mathrm{Sort}\ u} C(0)\to{}\\
&\quad\left(\prod_{n:\mathbb N}C(n)\to C(n+1)\right)\to{}\\
&\quad\prod_{n:\mathbb N}C(n).
\end{aligned}
$$

The family $C$ is called the *motive*. If $C(n)$ is a proposition, this is induction. If it is a data type, this is a recursive construction. If it varies with $n$, the recursion constructs different types of results at different stages. The same principle accounts for all three readings. Lean's [induction and recursion chapter](https://lean-lang.org/theorem_proving_in_lean4/Induction-and-Recursion/) shows how recursive definitions are expressed through recursors.

An indexed inductive family makes the dependency visible:

```lean
inductive Vec (α : Type u) : Nat → Type u where
  | nil : Vec α 0
  | cons {n : Nat} : α → Vec α n → Vec α (n + 1)

def Vec.head {α : Type u} {n : Nat} : Vec α (n + 1) → α
  | .cons x _ => x
```

Arguments declared before a constructor's colon stay in scope for the type that follows. The `cons` line could equally be written

```text
| cons : {n : Nat} → α → Vec α n → Vec α (n + 1)
```

Either way, `n` is an implicit argument that Lean usually infers. The dependency comes from using `n` in the later types, not from where it is declared.

The element type `α` is a *parameter*: it stays fixed through the declaration. The length is an *index*: the constructors return different instances of the family. In `head`, the empty constructor cannot inhabit the input type, so there is no empty case to handle.

Compare `List.head?`, which must return an `Option α` because its input may be empty. `Vec.head` instead requires a nonempty vector, so its result needs no optional wrapper. The mathematical precondition is expressed in the domain of the function.

Inductive declarations require restrictions. In particular, recursive occurrences must meet *strict positivity* conditions. To understand the terminology, consider an occurrence of a type `X` in an expression built from function types. Start with positive polarity: entering an arrow's domain flips the sign, while entering its codomain preserves it. Intuitively, `A → X` produces an `X`, whereas `X → A` consumes one. Assuming `A` and `B` contain no `X`:

| Expression | Position of `X` | Strictly positive? |
|---|---|---|
| `X` | Positive | Yes |
| `A → X` | Positive | Yes |
| `X → A` | Negative | No |
| `(X → A) → B` | Positive: two sign flips | No |

Strict positivity is stronger than a positive final sign: in these arrow expressions, the path to `X` must never enter a function's domain. The check applies **inside each constructor argument's type**, not across the outer arrows that make the constructor a function. Thus `Vec α n` is an allowed recursive argument to `cons`, while a recursive argument of type `X → False` would be forbidden. Nested inductive type constructors have additional rules, described in the [inductive-type reference](https://lean-lang.org/doc/reference/latest/The-Type-System/Inductive-Types/).

If we freely admitted a type `Bad` with a constructor `mk : (Bad → False) → Bad`, its apparent elimination rule would let us define:

```text
d : Bad → False
d (mk f) := f (mk f)
```

The definition of `d` does not call itself: it applies the function stored in its argument. But the constructor lets us store `d` itself, as `mk d : Bad`. Applying `d` to it gives a closed term of type `False`. Unfolding `d` and matching the constructor returns the same term:

```text
d (mk d) → d (mk d) → ...
```

Self-application emerges from the constructor and its elimination rule despite the absence of explicit recursion. The closed term's type `False` is the contradiction; the loop also exposes the computational failure. The positivity check blocks the declaration of `Bad` before either becomes available.

Lean's kernel checks inductive declarations and their recursors. Surface recursive definitions are compiled into applications of those principles, including well-founded recursion when needed. Rocq's core language instead has primitive fixpoint terms, checked by a guardedness discipline; its recursors are defined from them. The two systems therefore organize the checking of recursion differently. Rocq's [inductive and recursive rules](https://docs.rocq-prover.org/master/refman/language/core/inductive.html) are the appropriate comparison, rather than the superficial similarity of pattern-matching syntax.

> **Aside: termination through decreasing measures**
>
> A standard termination argument assigns each recursive call a measure in a well-founded order. For a natural-number measure $\mu$, a call from input $x$ to input $y$ must satisfy $\mu(y)<\mu(x)$. Recursing on a list's tail decreases its length; more elaborate algorithms may decrease a lexicographically ordered tuple. There can be no infinite descending chain in the chosen order. Lean's [`termination_by` and `decreasing_by`](https://lean-lang.org/doc/reference/latest/Definitions/Recursive-Definitions/) let us specify such a measure and prove the required decreases, elaborating the definition into well-founded recursion.
>
> *Sized types* carry descent information in types themselves. Schematically, write $\mathrm{List}_{\leq n}(A)$ for lists of length at most $n$. A helper with type $\mathrm{List}_{\leq n}(A)\to\mathrm{List}_{\leq n}(A)$ promises not to exceed that bound. Applied to the tail of a list of length $n+1$, its result is still small enough for a recursive call, even if it is not a literal subtree of the original input. Size information can cross function boundaries instead of being recovered by inspecting each helper's implementation. Actual sized calculi have additional rules, and may use ordinal bounds; [Abel's MiniAgda paper](https://arxiv.org/html/1012.4896) develops this approach.
>
> An ordinary recursive-call check has no self-call to inspect in `d`. It calls a stored function, whose unrestricted type `Bad → False` imposes no descent condition. Packaging `d` with `mk` lets that call return to the same expression. Any rank strictly decreasing along this complete reduction cycle would require $\mu(t)<\mu(t)$. A termination-tracking system must therefore reject or restrict some part of the construction; merely attaching a measure to `d` cannot validate the unchanged rules.
>
> Strict positivity restricts the datatypes and eliminators we may introduce; decreasing measures justify recursive uses of the admitted principles. Sized types can connect these concerns, but a size index alone proves neither termination nor consistency. Well-founded recursion even brings a difficulty of its own. Lean's accessibility predicate `Acc` lives in `Prop`, and together with proof irrelevance it makes definitional equality undecidable; the section on normalization returns to this.

## Computation and the two forms of equality

Dependent types make computation part of type checking. To see why, define an addition that explicitly recurses on its first argument:

```lean
def addLeft : Nat → Nat → Nat
  | 0, m => m
  | n + 1, m => Nat.succ (addLeft n m)

example (n : Nat) : addLeft 0 n = n := rfl
```

`example` asks Lean to check an unnamed theorem. The argument `(n : Nat)` is arbitrary; the proposition to prove follows `:`, and its proof follows `:=`.

`rfl` stands for *reflexivity*. In `:= rfl`, it is a proof term with its argument inferred. The equality constructor `Eq.refl n` proves `n = n` and also works here. Writing `:= by rfl` instead invokes the tactic of that name to construct the proof. Both use the same reflexivity principle; see Lean's [equality reference](https://lean-lang.org/doc/reference/latest/Basic-Propositions/Propositional-Equality/) and [tactic tutorial](https://lean-lang.org/theorem_proving_in_lean4/Tactics/).

Reflexivity works even though the two sides look different: the defining equation for `addLeft` makes `addLeft 0 n` compute to `n`, even though `n` is unknown. The kernel's conversion relation recognizes the two sides as definitionally equal, so a proof of `n = n` also proves the displayed equation. No induction lemma is needed.

Now consider the other order:

```lean
theorem addLeft_zero (n : Nat) : addLeft n 0 = n := by
  induction n with
  | zero => rfl
  | succ n ih =>
      change Nat.succ (addLeft n 0) = Nat.succ n
      exact congrArg Nat.succ ih
```

An unknown `n` does not reveal whether the first argument of `addLeft` is zero or a successor. Computation alone cannot finish. Induction does: the successor case lifts the induction hypothesis through the function `Nat.succ`.

Two relations are at work. **Definitional equality** belongs to the machinery of typing and conversion; it lets the checker treat suitable expressions interchangeably. **Propositional equality**, written `a = b`, is a type inside the language, and a proof inhabiting it can be passed to other functions.

The latter is an inductive family with reflexivity as its constructor. Its elimination principle says that equal things can be substituted in dependent families. This is the formal justification for transporting an object from $B(a)$ to $B(b)$ using a proof of $a=b$. Lean's [quantifiers and equality chapter](https://lean-lang.org/theorem_proving_in_lean4/Quantifiers-and-Equality/) develops this substitution principle.

```lean
def transport {A : Type u} (B : A → Type v)
    {a b : A} (h : a = b) (x : B a) : B b :=
  h ▸ x

def resizeVec {α : Type u} {n m : Nat}
    (h : n = m) (xs : Vec α n) : Vec α m :=
  transport (Vec α) h xs
```

Nothing about the vector's entries changes. The equality proof justifies changing the index appearing in its type. This is why arithmetic identities can matter while manipulating a vector: a mathematically equal length may still require explicit transport if the two length expressions are not definitionally interchangeable.

Conversion is often explained as reducing both expressions to the same normal form. Lean's [type-system reference](https://lean-lang.org/doc/reference/latest/The-Type-System/) includes beta reduction of function applications, delta unfolding of definitions, iota reduction of recursors, and zeta substitution of let-bound values. It also includes function and structure eta rules, proof irrelevance, and quotient computation. The kernel implements an algorithmic conversion test; this is distinct from the declarative relation specified by the rules. The later normalization example will show why reducing every term to a normal form cannot provide a general implementation.

For writing proofs, a useful discipline is to ask what makes an equality available. Does it follow by unfolding and computation? Is it an induction theorem? Does it use extensionality? Each answer suggests a different Lean move: `rfl` or `change`, induction or rewriting, or an explicit extensionality principle.

## A first independent Lean proof

We can now write a proof without a guide. The composite of two injective functions is injective; an explicit definition keeps every step visible:

```lean
def IsInjective {A : Type u} {B : Type v} (f : A → B) : Prop :=
  ∀ ⦃x y : A⦄, f x = f y → x = y

theorem injectiveComp {A : Type u} {B : Type v} {C : Type w}
    (f : A → B) (g : B → C)
    (hf : IsInjective f) (hg : IsInjective g) :
    IsInjective (fun x => g (f x)) := by
  intro x y h
  apply hf
  apply hg
  exact h

#print axioms injectiveComp
```

The double braces in `⦃x y : A⦄` make `x` and `y` *strict implicit* arguments. Lean infers them, but only once a later explicit argument, here the equality, is supplied. So `hf` on its own still denotes the whole quantified statement.

[`intro x y h`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/#quantifiers) introduces and names three local assumptions. Unfolding `IsInjective` exposes two universally quantified variables followed by an implication. After `intro`, the new assumptions and remaining goal are:

```text
x y : A
h : g (f x) = g (f y)
⊢ x = y
```

Mathematically: let `x, y` be arbitrary and assume `h`. We could write `intro a b hab` and later `exact hab`. The remaining tactics work backward: `apply hf` asks for `f x = f y`, then `apply hg` asks for `g (f x) = g (f y)`, supplied by `exact h`. The final command, `#print axioms`, lists the axioms a theorem depends on; for `injectiveComp` it reports none.

For practice, rewrite the proof as one `fun` expression. Prove that injectivity of `g ∘ f` implies injectivity of `f`, using `congrArg g`. Then try surjectivity: a composite of surjections is surjective, and if `g ∘ f` is surjective, so is `g`. Both statements end in an existential, so their proofs must supply witnesses.

Finally, return to `Vec`. Define `Vec.toList` and prove by induction that its result has length `n`. Then use `resizeVec` with `Nat.zero_add n` to turn a `Vec α (0 + n)` into a `Vec α n`. This brings together the three skills on which the rest depends: reading a dependent signature, understanding the motive of induction, and recognizing when equality requires transport.

## How far GADTs take us

Readers who do not program in Haskell or OCaml can skip this section.

Much of the vector example is available in Haskell and OCaml through *generalized algebraic datatypes*, or GADTs. Their constructors can specify different result indices, and matching a constructor introduces type equations within the branch. This captures an important part of indexed inductive families. It does not by itself supply arbitrary dependence on ordinary terms.

### Indexed vectors in Haskell and OCaml

In Haskell, enable `GADTs`, `DataKinds`, and `KindSignatures`:

```haskell
data Nat = Z | S Nat

data Vec (n :: Nat) a where
  VNil  :: Vec 'Z a
  VCons :: a -> Vec n a -> Vec ('S n) a

headVec :: Vec ('S n) a -> a
headVec (VCons x _) = x
```

`DataKinds` promotes `Nat` to a kind of indices, with promoted constructors `'Z` and `'S`. The GADT declaration then constrains which indices each vector constructor produces. These are separate features: promotion supplies the index language; GADT matching supplies refinement. The [GHC documentation](https://ghc.gitlab.haskell.org/ghc/doc/users_guide/exts/gadt.html) explains the latter through typed expression trees, another useful indexed family.

OCaml can express the same nonempty-vector guarantee using separate types for zero and successor:

```ocaml
type z = Z
type 'n s = S of 'n

type (_, _) vec =
  | VNil : (z, 'a) vec
  | VCons : 'a * ('n, 'a) vec -> ('n s, 'a) vec

let head_vec : type n a. (n s, a) vec -> a = function
  | VCons (x, _) -> x
```

The `type n a.` annotation introduces locally abstract types for checking the body. Here `z` and `'n s` serve as indices; no values of those types need to be stored in a vector. Both languages rule out the empty constructor at this input type. OCaml's [GADT tutorial](https://ocaml.org/manual/5.5/gadts-tutorial.html) also develops existential indices and equality witnesses; Haskell provides the latter as `:~:`. Matching such a witness transports a value between equal indices, as Lean's `transport` does.

### Connecting an index to an ordinary value

Lean can express replication with the signature `(n : Nat) → α → Vec α n`: the ordinary argument occurs in the result type. Haskell's conventional encoding uses a *singleton* connecting a type-level index to its runtime representative:

```haskell
data SNat (n :: Nat) where
  SZ :: SNat 'Z
  SS :: SNat n -> SNat ('S n)

replicateVec :: SNat n -> a -> Vec n a
replicateVec SZ     _ = VNil
replicateVec (SS n) x = VCons x (replicateVec n x)

data SomeVec a where
  SomeVec :: SNat n -> Vec n a -> SomeVec a
```

For each finite natural-number index, the singleton has exactly one fully defined constructor-shaped value. Matching it reveals the index's structure. The existential package `SomeVec` lets a runtime computation return a vector of an initially unknown length. Unpacking exposes a fresh index shared by its singleton and vector. GADTs do not require every length to be a numeral known at compile time.

OCaml supports this singleton-and-package technique too. Its cost is maintaining the connection between an ordinary representation and an index. Libraries such as Haskell's [singletons](https://github.com/goldfirere/singletons) automate parts of that work; full dependent types express the connection directly.

### Computing with indices or carrying a relation

Haskell adds type families for computation in types. With `TypeFamilies`, concatenation can use a separate type-level addition:

```haskell
type family Add (n :: Nat) (m :: Nat) :: Nat where
  Add 'Z     m = m
  Add ('S n) m = 'S (Add n m)

append :: Vec n a -> Vec m a -> Vec (Add n m) a
append VNil ys = ys
append (VCons x xs) ys = VCons x (append xs ys)
```

The equations for `Add` reduce as the vector match reveals `n`. Lean can instead use an ordinary addition function inside the result type. This difference concerns the language of indices, beyond the GADT feature itself. See GHC's [type-family rules](https://ghc.gitlab.haskell.org/ghc/doc/users_guide/exts/type_families.html).

An OCaml encoding can replace that function with its graph: a relation carrying evidence that three indices satisfy addition.

```ocaml
type (_, _, _) plus =
  | PlusZ : (z, 'm, 'm) plus
  | PlusS : ('n, 'm, 'k) plus -> ('n s, 'm, 'k s) plus

let rec append : type n m k a.
    (n, m, k) plus -> (n, a) vec -> (m, a) vec -> (k, a) vec =
  fun sum xs ys ->
    match sum, xs with
    | PlusZ, VNil -> ys
    | PlusS smaller, VCons (x, rest) ->
        VCons (x, append smaller rest ys)
```

`PlusZ` witnesses $0+m=m$; `PlusS` lifts evidence for $n+m=k$ to evidence for $(n+1)+m=k+1$. Both versions enforce the result length. The OCaml interface carries an explicit witness instead of asking the checker to evaluate a type family. Witnesses can also be computed and packaged with results.

Haskell consequently offers more direct machinery for computing with indices. Higher-kinded type variables and kind polymorphism also make families easier to abstract over. OCaml uses module functors or encodings for corresponding abstractions over type constructors; [Yallop and White](https://www.cl.cam.ac.uk/~jdy22/papers/lightweight-higher-kinded-polymorphism.pdf) explain that tradeoff.

### What general dependency adds

The deeper step is allowing a type to mention the actual data being processed. Vector induction in Lean admits a motive of the form

$$M:\prod_{n:\mathbb N}\operatorname{Vec}(A,n)\to\mathrm{Prop}.$$

The proposition can depend on the entire vector and its entries, not only its length. A GADT match exposes constructor and index equations, but does not automatically make the matched value available as an argument to a type-level predicate. More dependencies can be encoded by representing more data in indices. General dependent products and elimination remove the need to construct that representation separately for each domain.

Finally, expressive specifications are not yet a logic. Haskell accepts a definition `fake :: p` with body `fake = fake`, where `p` can be any ordinary type; OCaml likewise permits computations that diverge or raise exceptions at any desired result type. Neither computation produces an equality witness, for example. Lean's later normalization counterexample will inhabit an already true proposition, without granting arbitrary proofs by unrestricted recursion. The rules controlling proofs matter independently of how richly a datatype can be indexed.

## Proof irrelevance and what can be extracted from existence

Lean identifies all proofs of a fixed proposition definitionally:

```lean
example (P : Prop) (h₁ h₂ : P) : h₁ = h₂ := rfl
```

This says that once the proposition `P` is fixed, the identity of its proof is irrelevant to conversion. The [reference on propositions](https://lean-lang.org/doc/reference/latest/The-Type-System/Propositions/) marks this as a property of the type system itself.

A visible benefit is array access with a proof that the index is in bounds. Imagine an operation `get xs i h`, where `h : i < xs.size`. Two parts of a program may establish the same bound differently, supplying proofs `h₁` and `h₂`. We want `get xs i h₁` and `get xs i h₂` to agree without reconciling those proofs. Lean's array notation makes this concrete:

```lean
example {α : Type u} (xs : Array α) (h₁ h₂ : 0 < xs.size) :
    xs[0]'h₁ = xs[0]'h₂ := rfl
```

The apostrophe supplies the bounds proof explicitly. In ordinary `xs[0]` notation, Lean attempts to construct that proof automatically, so two accesses can look identical while carrying different evidence. Proof irrelevance makes these differing proof arguments interchangeable by conversion. A proof-relevant system might instead establish independence from them with a separate lemma.

Ordinary Rocq `Prop` does not have this general definitional identification. One can assume propositional proof irrelevance in Rocq, but an axiom proving `h₁ = h₂` does not make the checker identify the terms directly. Modern Rocq also has [`SProp`](https://docs.rocq-prover.org/master/refman/addendum/sprop.html), a separate sort with definitional proof irrelevance and its own restrictions.

The distinction between a proof and data becomes concrete with existential quantification. Both of the following involve a witness, but they support different operations:

```lean
def WitnessData (α : Type u) (P : α → Prop) :=
  {x : α // P x}

theorem forgetWitness {α : Type u} {P : α → Prop}
    (w : WitnessData α P) : ∃ x, P x :=
  ⟨w.val, w.property⟩

noncomputable def chooseWitness {α : Type u} {P : α → Prop}
    (h : ∃ x, P x) : WitnessData α P :=
  ⟨Classical.choose h, Classical.choose_spec h⟩
```

In `∃ x, P x`, the comma separates the bound variable `x` from the proposition `P x`; it does not construct a pair. Lean infers `x : α` from `P : α → Prop`. The fully annotated form is `∃ x : α, P x`, which expands to `Exists (fun x : α => P x)`. The angle brackets in `forgetWitness` supply the witness `w.val` and the proof `w.property` that it satisfies `P`.

The subtype `{x : α // P x}` is data: we can project its stored witness. The existential type `∃ x, P x` belongs to `Prop`, so its inhabitants are proofs and obey Lean's restrictions on eliminating propositions into data. In typing notation, `(∃ x, P x) : Prop`, while `h : (∃ x, P x)` says that `h` proves that proposition. The ordinary eliminator for existence lets us reason about a witness to establish another proposition, but does not generally expose the witness as computational data. The reverse direction above uses classical choice and is marked `noncomputable`.

Why impose this restriction? Suppose one existential proof used witness `0` and another used witness `1`. Proof irrelevance identifies the proofs of that same existential proposition. A computational projection that distinguished them would make the identification incompatible with computation. `Classical.choose` instead selects an unspecified witness satisfying the predicate; it need not return the witness used to construct the proof. For a fixed predicate, changing the existential proof cannot change that selection.

More generally, $\sum_{x:A}B(x)$, a dependent pair or *sigma type*, packages an object with data whose type depends on it. When the second component is a proposition, a subtype is often the convenient Lean representation. When both components carry data, use a sigma type. An existential proposition forgets the computational distinction between witnesses.

There are controlled exceptions to the prohibition on eliminating propositions into data. Empty propositions and suitable single-constructor propositions have stronger elimination rules; equality supports transport. Thus “nothing can ever move from `Prop` to `Type`” is too strong. The restriction concerns which distinctions a recursor is allowed to observe. Rocq also restricts elimination from `Prop`, even though ordinary `Prop` there lacks Lean's general definitional proof irrelevance.

## Extensional mathematics and primitive quotients

Mathematicians normally identify functions that agree at every argument. In Lean this is a theorem, `funext`, used as follows:

```lean
example {A : Type u} {B : Type v} (f g : A → B)
    (h : ∀ x, f x = g x) : f = g :=
  funext h
```

Pointwise equality need not be definitional equality of the functions. The theorem gives a propositional equality, which permits substitution without making their implementations convertible.

For reasoning about programs, distinguish a function from an implementation with a particular execution history. This distinction already matters without function extensionality: β-reduction identifies `(fun y => y) x` with `x`, although an operational semantics that counts β-steps distinguishes their evaluation costs. An equality that identifies these expressions cannot simultaneously preserve that step count. Ordinary function types do not expose source syntax or execution traces for inspection.

Function extensionality also identifies sorting functions that agree on every input despite different running times. Given `e : f = g`, any observer must satisfy `observe f = observe g`, by `congrArg observe e`; even a postulated cost observer cannot consistently distinguish them. To study costs, represent algorithms as syntax with an evaluator that counts steps, or instrument them to return a result and a cost, with type `List Nat → List Nat × Nat`. Equal sorted outputs need not imply equal result-cost pairs. Dependent types support these richer models; the chosen representation determines which distinctions survive.

Rocq's [standard library supplies function extensionality as an axiom](https://rocq-prover.org/doc/v9.0/stdlib/Stdlib.Logic.FunctionalExtensionality.html), but omitting it does not restore the operational distinctions already lost through definitional equality.

Extensionality also affects computation involving equality proofs: transports using `funext` can block kernel reduction while compiled execution erases them. Lean's [Axioms and Computation](https://lean-lang.org/theorem_proving_in_lean4/Axioms-and-Computation/#function-extensionality) illustrates this difference between evaluation routes.

Similarly, propositional extensionality, `propext`, turns an equivalence `P ↔ Q` into an equality `P = Q`.

In particular, any two *proved* propositions are equal. Given proofs `a : A` and `b : B`, the functions `fun _ => b` and `fun _ => a` prove the two implications: each ignores its input and returns the available proof of its conclusion.

Does this erase the distinctions between formulas? Consider three Boolean variables and the formulas

$$F=p\land q\land r,\qquad G=r\land p\land q,\qquad H=p\lor q\lor r.$$

A formula with free variables is not a proposition but a predicate on assignments, `F : Assignment → Prop`. $F$ and $G$ agree at every assignment, so `propext` and `funext` together give `F = G`. $F$ and $H$ disagree at $(p,q,r)=(\mathrm{True},\mathrm{False},\mathrm{False})$. They are merely [equisatisfiable](https://www.cs.cmu.edu/~mfredrik/15414/lectures/02-propositional.pdf): each has a satisfying assignment. Then `propext` equates the propositions `∃ ρ, F ρ` and `∃ ρ, H ρ`, but not the predicates. Classically, `Prop` has two values up to propositional equality, yet three Boolean inputs permit $2^{2^3}=256$ distinct truth functions.

Representing subsets by membership predicates, these principles turn pointwise equivalence into equality:

```lean
def SubsetOf (A : Type u) := A → Prop

theorem subsetExt {A : Type u} (S T : SubsetOf A)
    (h : ∀ x, S x ↔ T x) : S = T :=
  funext (fun x => propext (h x))

#print axioms subsetExt
```

The last command exposes the theorem's axiom dependencies: `propext` and `Quot.sound`. Lean derives function extensionality from quotients, as we will see below.

Lean's primitive `Quot` identifies representatives related by $r$ propositionally. To define a function on the quotient, supply a function $f$ on representatives and a proof $h$ that it respects $r$. The computation rule is

$$\operatorname{Quot.lift}\ f\ h\ (\operatorname{Quot.mk}\ r\ a)\equiv f(a).$$

For example, quotient natural numbers by parity:

```lean
def SameParity (a b : Nat) : Prop := a % 2 = b % 2

def parityValue : Quot SameParity → Nat :=
  Quot.lift (fun n => n % 2) (fun _ _ h => h)

example : parityValue (Quot.mk SameParity 5) = 1 := rfl

example : Quot.mk SameParity 1 = Quot.mk SameParity 3 :=
  Quot.sound (by rfl)
```

Quotient soundness supplies the last equality without making its representatives definitionally identical. The library wrapper `Quotient` packages an equivalence relation with its laws; see the [quotient reference](https://lean-lang.org/doc/reference/latest/The-Type-System/Quotients/).

Standard Rocq CIC has no corresponding primitive quotient. A common approach uses *setoids*: carriers with equivalence relations, and functions proved to respect them. Other quotient constructions require further assumptions or particular encodings.

### From quotients to function extensionality

Let $F=A\to B$, and quotient it by pointwise equality:

$$f\sim g\quad:\!\iff\quad\forall x:A,\;f(x)=g(x),\qquad Q=F/{\sim}.$$

Given $h:\forall x,\;f(x)=g(x)$, `Quot.sound h` supplies $[f]=[g]$ in $Q$. How do we obtain equality back in $F$?

Fix an input $x$. Evaluation $f\mapsto f(x)$ respects the relation: the required proof is simply $h(x)$. Hence `Quot.lift` defines $\operatorname{eval}_x:Q\to B$ with $\operatorname{eval}_x([f])\equiv f(x)$. Assemble these evaluations into

$$\operatorname{rebuild}(q):=\lambda x.\operatorname{eval}_x(q).$$

The crucial calculation is definitional:

$$\operatorname{rebuild}([f])
\equiv\lambda x.\operatorname{eval}_x([f])
\equiv\lambda x.f(x)
\equiv f.$$

The final step uses function η-equality: Lean identifies `fun x => f x` with `f`. This rule concerns the expansion of one function; it does not assume that arbitrary pointwise-equal functions are equal.

Apply ordinary congruence to $[f]=[g]$. It gives $\operatorname{rebuild}([f])=\operatorname{rebuild}([g])$, whose endpoints are definitionally $f$ and $g$. Here is the derivation, generalized to dependent functions:

```lean
def Pointwise {A : Sort u} {B : A → Sort v}
    (f g : (x : A) → B x) : Prop :=
  ∀ x, f x = g x

def rebuild {A : Sort u} {B : A → Sort v}
    (q : Quot (@Pointwise A B)) : (x : A) → B x :=
  fun x =>
    Quot.lift (fun f => f x) (fun _ _ h => h x) q

theorem funextFromQuot {A : Sort u} {B : A → Sort v}
    (f g : (x : A) → B x)
    (h : ∀ x, f x = g x) : f = g :=
  congrArg rebuild (Quot.sound h)

#print axioms funextFromQuot
```

The reported dependency is only `Quot.sound`; quotient reduction and η-equality are built-in rules. This follows [Lean's implementation of `funext`](https://github.com/leanprover/lean4/blob/v4.34.1/src/Init/Prelude.lean#L4806-L4813).

The placement of the lambda avoids circularity. Lifting `fun f => f` directly would require proving $f\sim g\Rightarrow f=g$, our goal. Instead, we fix $x$, lift evaluation using `h x`, and then abstract over $x$. No representative is selected by choice: evaluation reconstructs a function, and quotient computation plus η makes reconstruction a left inverse of the quotient map.

### Classical principles and conversion

`Classical.choice`, together with the extensional principles, proves excluded middle; Lean's `Classical.em` follows Diaconescu's argument. Local `classical` commands enable associated instances without modifying the kernel's rules. Use `#print axioms` to inspect a theorem's actual dependencies.

Lean therefore combines an intensional account of computation with strong propositional extensionality principles and definitional proof irrelevance. It does not implement equality reflection, the rule that every proved equality becomes a conversion rule. Nor is it a homotopy type theory: equality proofs live in its proof-irrelevant `Prop`, and the resulting uniqueness of equality proofs is incompatible with the general higher structure sought in univalent foundations.

## What evolved from early Lean to Lean 4

Lean began in 2013; Lean 3 was released in 2017; Lean 4 development began in 2018, with version 4.0 released in September 2023. The [official history](https://lean-lang.org/doc/reference/latest/Introduction/) describes the progression from a prover centered on C++ infrastructure to a system implemented largely in Lean itself.

There was also a foundational branch that is easy to forget. Lean 2 supported a separate HoTT mode with proof irrelevance disabled and univalence postulated. Sebastian Ullrich's [account of Lean's development](https://lean-lang.org/papers/thesis-sebastian.pdf) records that experiment. Modern Lean's mainstream mathematical foundation follows the proof-irrelevant branch; its extensionality and quotient features should be understood in that setting.

Lean 3 already allowed tactics and other extensions to be written in Lean. Lean 4 substantially expanded this architecture through an extensible parser, hygienic macros, elaboration machinery, and a compiler intended to make Lean a useful programming language. The [Lean 4 system paper](https://lean-lang.org/papers/lean4.pdf), by de Moura and Ullrich, explains these engineering choices. They change how the prover can be extended and how efficiently proof search can be implemented.

The logical changes also matter. Carneiro's [2024 Lean4Lean paper](https://arxiv.org/html/2403.14064v1) identifies kernel support for nested inductive types and eta for structures as changes that substantially affect the metatheory. Structure eta identifies a structure with the result of rebuilding it from its fields, just as function eta identifies `fun x => f x` with `f`. Such rules remove bookkeeping from proofs, but their interaction with other conversion rules needs justification.

A nested inductive type places recursion underneath another type constructor. For example, a rose tree contains a list of subtrees:

```lean
inductive Rose (α : Type u) where
  | node : α → List (Rose α) → Rose α
```

Here the recursive occurrence sits underneath `List`. Generating and checking the elimination machinery is more involved than for a binary tree. This raises [soundness questions about the generated recursors](https://arxiv.org/html/2403.14064v1#S5) even without invoking non-terminating reduction. Carneiro's [2019 thesis](https://github.com/digama0/lean-type-theory/releases/download/v1.0/main.pdf) proved Lean 3's type theory consistent relative to ZFC with $n$ inaccessible cardinals for every finite $n$. Lean 4's extensions need further work beyond that argument.

The layers matter when learning the language. A numeral is surface syntax. Notation, implicit arguments, coercions, and type-class search help turn an expression into a fully specified term. Tactics solve elaboration goals by constructing terms. The kernel checks the resulting declarations. The compiler provides a further route from executable definitions to running programs. Lean's [elaboration and compilation reference](https://lean-lang.org/doc/reference/latest/Elaboration-and-Compilation/) separates these stages.

This explains why “I know the logic” and “I can use Lean fluently” are different achievements. A mathematician may understand a theorem perfectly while needing help with instance search or with the library's preferred representation. A former Coq user may recognize the proof term while misreading a coercion or assuming the wrong transparency behavior.

A compact comparison helps locate those surprises:

| Feature | Rocq | Lean 4 |
|---|---|---|
| Shared ancestry | CIC family | CIC family with distinct extensions |
| Ordinary `Prop` | Impredicative; no general definitional proof irrelevance | Impredicative and definitionally proof irrelevant |
| Data universes | Cumulative hierarchy | Noncumulative hierarchy; universe polymorphism and lifts |
| General quotients | Usually setoids or further constructions | Primitive quotient support |
| Recursive definitions | Core fixpoints subject to guardedness rules | Surface recursion translated to recursors |
| Mathematical function extensionality | An additional principle in ordinary CIC | Derived using primitive quotients |

Rocq also supports eta conversion for functions and primitive records. Its [conversion rules](https://docs.rocq-prover.org/master/refman/language/core/conversion.html) specify these features beyond the broad comparison in the table.

## What the normalization result actually says

We can now separate four metatheoretic properties. **Strong normalization** says every reduction sequence from a well-typed term terminates. **Canonicity**, in a specified fragment and with specified axioms, says closed terms of data types compute to appropriate canonical values, such as numerals. **Consistency** says there is no closed proof of `False` under the designated assumptions. **Decidability of type checking** says an algorithm settles every typing judgment, including every question of definitional equality. These properties interact, but they are not synonyms.

Normalization and an analysis of normal forms can establish consistency: if every closed proof normalizes, and no normal form can inhabit `False`, then no such proof exists. Losing that method does not exhibit a proof of `False`. A semantic model offers another route: interpret types as suitable objects and `False` as empty, then prove that derivable judgments preserve the interpretation.

Abel and Coquand's [2020 paper](https://arxiv.org/html/1911.08174) exhibits non-normalizing proof terms. Their closed example uses propositional extensionality as well as impredicativity and proof-irrelevant equality. It does not require a recursive definition or an assumption of `False`. We can reconstruct the mechanism in Lean 4, starting with the computational rule that makes it possible.

### A cast that does not wait for its proof

Transport along reflexivity should do nothing: `cast rfl x` reduces to `x`. Lean also permits the following behavior for *any* proof `h : A = A`:

```lean
example (A : Type) (h : A = A) (x : A) : cast h x = x := rfl

#reduce (fun (h : Nat = Nat) => cast h (37 : Nat))
-- fun h => 37
```

The variable `h` cannot be unfolded to reveal a reflexivity constructor. Nevertheless, the cast disappears. Definitional proof irrelevance identifies `h` with reflexivity at the fixed proposition `A = A`, and Lean's equality recursor supports the corresponding computation. The operational rule we need is

$$\operatorname{cast}_{A,A}(h,x)\longrightarrow x.$$

The crucial condition is that the *endpoints* coincide definitionally. A cast between arbitrary propositionally equal types need not disappear. Also, merely assuming a theorem of propositional proof irrelevance would not automatically install this computational rule. This is about conversion and reduction, not just a theorem saying that two proofs are equal.

### Impredicativity makes a controlled self-application typable

Define a proposition $T$ asserting that every proposition implies itself, and let $D$ abbreviate $T\to T$:

$$T:=\prod_{P:\mathrm{Prop}}(P\to P),\qquad D:=T\to T.$$

Both are propositions. Let $i:D$ be the identity on proofs of $T$. For a variable $z:T$, inspect this application one argument at a time:

$$\begin{aligned}
z\,D &: D\to D,\\
z\,D\,i &: D,\\
z\,D\,i &: T\to T,\\
z\,D\,i\,z &: T.
\end{aligned}$$

Thus we can define $d:D$ by $d(z):=z\,D\,i\,z$. This resembles self-application, but every application has a legitimate type. We instantiate `z` at a proposition which itself mentions the type of `z`.

Impredicativity does specific work here: quantifying over `Prop` leaves $T$ inside `Prop`, so $D$ is an allowed argument to `z`. Try the same construction with the predicative type $T_u:=\prod_{A:\mathrm{Type}\ u}(A\to A)$. Now $T_u$ lives in `Type (u + 1)`, and so does $T_u\to T_u$. That function type is too large to pass as the `Type u` argument of a term of $T_u$. The attempted self-application climbs out of its permitted universe.

### Propositional extensionality closes the loop

Recall that proofs `a : A` and `b : B` give `A ↔ B` by returning the available proof in each direction. Applying `propext` yields $e(a,b):A=B$.

Use this to construct $w:T$. Given any proposition $P$ and proof $p:P$, we have proofs $i:D$ and $p:P$, hence $e(i,p):D=P$. Cast $d:D$ along this equality:

$$w(P,p):=\operatorname{cast}_{D,P}(e(i,p),d):P.$$

This has exactly the type required for $w:T$. Finally set $L:=d(w):T$. All the definitions together are small enough to inspect:

```lean
namespace ReductionLoop
set_option linter.defProp false

def T : Prop := ∀ P : Prop, P → P
def ident : T → T := fun z => z
def diagonal (z : T) : T := z (T → T) ident z

def trueEq {A B : Prop} (a : A) (b : B) : A = B :=
  propext ⟨fun _ => b, fun _ => a⟩

def rolled : T := fun P p =>
  cast (trueEq (A := T → T) (B := P) ident p) diagonal

def loop : T := diagonal rolled

#print axioms loop
-- [propext]
end ReductionLoop
```

Here `ident`, `diagonal`, `rolled`, and `loop` are $i,d,w,L$. These are ordinary nonrecursive definitions. The linter option allows us to keep their proof bodies as transparent `def`s rather than following the usual stylistic preference for `theorem`.

Now perform the reductions. Unfolding `diagonal` exposes an application of `rolled`; unfolding that application exposes a cast with matching endpoints:

$$\begin{aligned}
L=d(w)
&\longrightarrow w\,D\,i\,w\\
&\longrightarrow
\bigl(\operatorname{cast}_{D,D}(e(i,i),d)\bigr)\,w\\
&\longrightarrow d(w).
\end{aligned}$$

The cast exposes `d` because its endpoints agree, without evaluating the `propext` proof to reflexivity. This returns us to the starting expression; otherwise the computation would remain stuck at the cast.

*Strong normalization* requires every reduction sequence to terminate; *weak normalization* requires at least one sequence reaching a normal form. The cycle alone refutes the former. A looping subterm can sometimes be discarded: $(\lambda t:T.\;0)(d\,w)$ reduces to $0$ by contracting the outer application. For $d\,w$ itself, [Abel and Coquand](https://arxiv.org/html/1911.08174#S2) establish that there is not even a *weak head normal form*: reduction cannot expose a finished outer shape. Thus this term is not weakly normalizing either; choosing another reduction order does not rescue it.

This identifies three distinct contributions: impredicativity permits the instantiation at $D$; propositional extensionality supplies the casts between inhabited propositions; and proof-irrelevant cast reduction removes the cast when the loop returns to $D$. The claim is about this combination of rules, not every system that has some notion of proof irrelevance. Rocq keeps a related combination behind an option: its manual [warns](https://docs.rocq-prover.org/master/refman/addendum/sprop.html#non-termination-with-uip) that the `Definitional UIP` flag for `SProp`, off by default, breaks termination of reduction in the presence of an impredicative sort, and cites this example.

The example type-checks in Lean 4.34.1. The accompanying Lean file checks that `#reduce (proofs := true) ReductionLoop.loop` reaches a bounded recursion limit. This diagnostic corroborates the behavior; the reduction argument establishes divergence.

There is no contradiction: $T$ already has the proof `fun P p => p`. Proof irrelevance identifies `loop` with it, but does not supply a computational reduction to it. A checker can recognize proofs of the same proposition without reducing them, so the example does not force every type check to diverge.

### Undecidable conversion and the kernel's approximation

Lean's checker faces a second limitation, independent of the loop. Carneiro's [thesis](https://github.com/digama0/lean-type-theory/releases/download/v1.0/main.pdf#page=16) shows that definitional equality under Lean's rules is undecidable. The source is the accessibility predicate behind well-founded recursion, which Lean's core library defines as follows:

```lean
inductive Acc {α : Sort u} (r : α → α → Prop) : α → Prop where
  | intro (x : α) (h : (y : α) → r y x → Acc r y) : Acc r x
```

`Acc` is a proposition, yet its recursor may eliminate into data. It computes when the proof is built by `intro`. Any proof `a : Acc r x` yields, by projection, the argument that `intro` would need. Proof irrelevance then makes `a` definitionally equal to `intro` applied to those projections. That rebuilt proof lets the recursor take one more step, and the rebuilding can be repeated indefinitely.

Carneiro uses this to encode an unbounded search. Fix a decidable predicate $P$ on natural numbers, and take the relation $>$, which is not well-founded. Define a function by the recursor that tests $P(n)$ and continues to $n+1$ while it holds, returning `false` at the first failure. Assume a proof `a : Acc (· > ·) 0` as a hypothesis. No such proof exists, but definitional equality must still be decided in that context. The function's result at $0$ is then definitionally equal to `false` exactly when $P$ fails somewhere. Halting of a Turing machine has this form, so no algorithm decides definitional equality.

The kernel's conversion check is therefore a decidable approximation. It does not search for rebuilt proofs, so it can fail to confirm equalities that the rules permit. Carneiro draws two further consequences. The algorithmic relation is not transitive: it confirms a rebuilding step and the reduction that follows it, but not the equation that skips the rebuilt proof. And typing based on that relation fails subject reduction: reducing a well-typed term can produce one the checker rejects at the same type.

Neither result yields a proof of `False`. Both concern completeness: the kernel may reject terms the declared rules accept, but should not accept terms they reject. In practice Lean avoids depending on such reductions; definitions by well-founded recursion are irreducible by default, and their defining equations are used as theorems.

There is another, milder way computation can fail to produce an answer: a term can become *stuck* at an opaque axiom. This is different from an infinite reduction sequence. Classical choice can specify a mathematical object without an executable construction. `noncomputable` records that situation; it does not mean “unproved,” and it does not grant arbitrary recursive proofs. Similarly, Lean's programming facilities for partial or unsafe code have restrictions separating them from ordinary logical definitions.

## Denotational semantics and the meaning of a dependent type

A reduction describes how an expression changes during computation. A *denotation* assigns the expression a mathematical meaning. These are different kinds of account: a function can denote a perfectly ordinary mathematical object even when a particular reduction strategy fails to produce a normal form for its expression.

Start with a data fragment containing dependent functions. An environment $\rho$ assigns mathematical values to the variables in a context. We want a typing judgment to imply membership:

$$\Gamma\vdash t:A
\quad\Longrightarrow\quad
\llbracket t\rrbracket_\rho\in\llbracket A\rrbracket_\rho
\quad(\rho\models\Gamma).$$

Interpret a type as a set, a family as a set-valued assignment, and a dependent function as a graph selecting one element from each fiber:

$$\llbracket\prod_{x:A}B(x)\rrbracket_\rho
=\prod_{a\in\llbracket A\rrbracket_\rho}
\llbracket B(x)\rrbracket_{\rho[x\mapsto a]}.$$

For a finite example, take $A=\{0,1\}$, $B(0)=\{a,b\}$, and $B(1)=\{c\}$. The dependent product contains exactly two graphs:

$$\{(0,a),(1,c)\},\qquad\{(0,b),(1,c)\}.$$

A lambda expression specifying the first choice denotes the first graph. Applying it to `1` denotes `c`. Beta reduction preserves that meaning because substituting an argument in a body agrees with evaluating the body in an environment assigning that argument to the bound variable. That statement is the semantic substitution lemma behind the familiar computation rule.

To interpret universes, we need collections of sets with the closure properties demanded by the typing rules. Merely saying “let a universe contain all sets” does not produce a set. Which closure conditions we choose, and whether product formation remains in the same universe, determine the required set-theoretic assumptions. Werner's [“Sets in Types, Types in Sets”](https://doi.org/10.1007/BFb0014566) (1997) settled the strength needed for Rocq's calculus. ZFC with $n$ inaccessible cardinals proves the consistency of CIC with $n+1$ universes, and CIC with $n+2$ universes proves the consistency of ZFC with $n$ inaccessibles. Carneiro's thesis adapts this model to Lean.

### Why propositions make the model less immediate

A tempting interpretation uses just two proposition meanings: $0=\varnothing$ for false and $1=\{\star\}$ for true. It explains proof irrelevance by giving each true proposition exactly one proof value. But combining it with ordinary function graphs needs care.

For example, the ordinary dependent product $\prod_{x:A}1$ is a singleton containing the constant graph

$$g_A=\{(a,\star)\mid a\in A\}.$$

Its sole element is $g_A$, not necessarily $\star$. Changing $A$ changes the graph. Thus the products of true propositions over different domains do not automatically become the same designated truth value $1$. To keep quantification impredicative and proofs irrelevant, a model must reconcile these representations with abstraction, application, and substitution. Saying “all proofs are a point” does not itself do that work.

Miquel and Werner analyze this difficulty in [“The not so simple proof-irrelevant model of CC”](https://www.lix.polytechnique.fr/~werner/publis/cc.pdf). Carneiro's [thesis](https://github.com/digama0/lean-type-theory/releases/download/v1.0/main.pdf) handles it by proving *unique typing* first: each term has one type up to definitional equality. The model can then tell which products land in `Prop` and interpret them differently. Barras found a shortcut. Aczel's encoding represents a function $f$ as the set of pairs $(x,y)$ with $y\in f(x)$. Taking $\star=\varnothing$ makes the constant function to $\star$ the empty set, which is $\star$ itself, whatever its domain.

This is also where the normalization example becomes illuminating. In a successful proof-irrelevant model of its rules, `loop` and the elementary proof of $T$ would have the same denotation. Every step around the loop would preserve that denotation. There is no contradiction in

$$t\longrightarrow t'\longrightarrow t,
\qquad\llbracket t\rrbracket=\llbracket t'\rrbracket.$$

Soundness requires preservation of meaning. Termination requires an additional argument ruling out infinite computation; equality of meanings supplies no decreasing measure. A semantic consistency proof can therefore succeed even when reduction fails to normalize.

### A mathematician's alternative: semantics first

Tristan Bice's [Dependent Types Simplified](https://arxiv.org/abs/2507.04071) (2025) reverses the usual order of work. Writing as “a mathematician trained in classical logic,” Bice observes that a typical paper on dependent types opens with pages of inference rules and explains their meaning later, if at all. His two systems start from set interpretations and admit only inference rules that are sound for them.

An interpretation assigns sets to constants and variables, and nothing else affects it. Bice contrasts this with Miquel–Werner and Carneiro, whose interpretations also depend on the typing context and split the language into propositional and non-propositional parts. In his view, the split gives up the main attraction of propositions as types: one uniform treatment of types and propositions.

The price is impredicativity. Bice's universes are the sets $H(\kappa_n)$ of hereditary size below chosen regular cardinals; the lowest contains the propositions $\varnothing$ and $\{\varnothing\}$. A dependent product whose domain lives at level $m$ and whose fibers live at level $n$ lands at level $\max(m+1,n)$. Bice notes that $m+1$ cannot be lowered to $0$, even when the fibers are propositions. Identifying all singletons would force it, but would forget each function's domain, which is the $g_A$ problem above. Barras's shortcut is, in effect, that identification. It suffices for a soundness proof, but Bice wants the semantics alone to decide which terms are well-formed, and a forgotten domain makes that impossible.

Bice simulates impredicativity instead. His first system defines universal quantification as a doubly negated product, $\neg\neg\prod$. Since $\neg X := X\to\bot$ denotes $\{\varnothing\}$ when $X$ is empty and $\varnothing$ otherwise, the truncated product always denotes one of the two propositions. The truncation bears on our loop. A proof of $\neg\neg\prod_{P}(P\to P)$ is not a function that accepts a proposition, so the instantiation at $D$ cannot be written. His second system specifies quantifiers by typing statements about constants.

Specifications are how the second system introduces mathematical structure. A specification is a set of typing statements about fresh constants, judged by whether every canonical model interprets them as intended. Equality is a worked example: a reflexivity constant and a substitution constant force every canonical model to make the equality type nonempty exactly on equal pairs. These two constants mirror `Eq.refl` and the substitution principle behind Lean's `transport`.

Large cardinals become optional. With inaccessible cardinals, each universe satisfies ZFC, as in Carneiro's model. Without them, each still satisfies ZFC minus the power-set axiom.

Computation enters as reduction statements added as axioms. Bice states the trade-off plainly: the more reduction statements a system admits, the more likely type checking becomes undecidable. His future-work section places Lean in this frame, citing Carneiro. Lean's computation rules correspond to an intermediate option, between pure type systems, which reduce only by β, and extensional systems, which admit arbitrary reductions and give up decidability. Normalization would require restricting attention to suitable contexts. Bice leaves it open, together with completeness of the inference rules relative to the semantics.

Bice's systems are not Lean, and he does not claim that they model it. They isolate the choice that makes Lean's semantics delicate: an impredicative `Prop`, which the loop above also exploits. To connect semantics to a proof assistant's reliability, we also need an argument about the checker that accepts its terms.

## Consistency proofs and the reliability of a checker

Mario Carneiro's [February 2025 HoTTEST presentation](https://hottest-seminar.github.io/hottestfiles/Carneiro-2025-02-06-HoTTEST.pdf) reports a gap in the thesis, found while formalizing it. The affected theorems are unique typing and definitional inversion, which rest on a confluence argument; the talk now lists them as conjectures. The thesis's soundness proof used unique typing, though the thesis itself notes that Barras's encoding avoids that dependency. The talk mentions an alternative route to soundness, while some kernel optimizations still depend on the conjectured theorems.

As of October 13, 2026, the [con-leche project](https://github.com/leanprover/con-leche) constructs a set-theoretic interpretation and proves that every environment accepted by its verified checker has a model. It assumes set theory with an ω-chain of Grothendieck universes; the interpretation of accepted declarations is then proved to exist. Since `False` denotes the empty set, no accepted theorem can inhabit it. The checker deliberately differs from the official kernel, including its handling of inductives, so the result covers con-leche's accepted declarations without automatically covering everything the official kernel accepts.

The result is relative: the accepted declarations are consistent if set theory with those universes is. The proof is itself a Lean development, so Lean also serves as the metatheory, checked by the official kernel. Connecting that theorem to an executable checker also requires accounting for its parsing, runtime, and input handling.

This leads to four separate questions about an individual formalization:

| Question | What would answer it |
|---|---|
| Does the formal statement express the intended mathematics? | Inspect definitions, hypotheses, quantifiers, and representations |
| Does the proof depend only on acceptable assumptions? | Inspect its transitive axiom dependencies |
| Does the checker implement its stated rules correctly? | Implementation analysis, verification, and independent rechecking |
| Are those rules consistent under the chosen foundations? | A metatheoretic argument for the precise formal system |

Success at one level does not discharge the others. A correct kernel can check an unintended theorem. A plausible mathematical theory can have a defective implementation. A theorem about one checker may omit parts of the runtime used to execute it.

De Moura's [August 24, 2026 postmortem](https://leodemoura.github.io/blog/2026-8-24-postmortem-for-the-kernel-soundness-bug-hunt/) documents kernel and runtime soundness bugs and reports fixes in Lean 4.33.1. It explains why adversarial developments need validation beyond an ordinary build, including statement comparison and external checking. These exploits concern the behavior of the affected implementations.

`#print axioms` answers the dependency question. Statement inspection and implementation validation answer others. A successful build provides evidence about a particular checking run; assessing its trust assumptions also requires knowing how tactics, native computation, and imported artifacts enter that run.

Moses's critique makes claims of several kinds, and these distinctions sort them. Its normalization claim is correct; the loop above reconstructs it. What it costs is one route to consistency, not evidence of inconsistency. Its consistency claim also stands as written: no public proof covers Lean 4 as the official kernel implements it. Carneiro's thesis covers Lean 3, and its proof now has a reported gap; con-leche covers a different checker. Its strongest evidence concerns implementations: kernel bugs, nested inductives, and validation tools run without isolation. That evidence belongs to the third row of the table, and the postmortem confirms it. Its warning about mistranslated statements belongs to the first row. Its forecast that current Lean accepts some proof of `False` is a judgment about implementation risk, which the foundational results here neither support nor refute.

The opening basis theorem now has a more precise shape. It can assert that a natural number and a family of vectors satisfying the basis properties exist, package them as data with proofs attached, or define a particular basis using classical choice. Each formulation makes a different promise about computation and observation. Reading Lean means seeing those promises in the type.

*The accompanying [Lean file](dependent-types-from-rocq-to-lean.lean) contains the Lean examples in order. The GADT examples are collected in [Haskell](dependent-types-from-rocq-to-lean.hs) and [OCaml](dependent-types-from-rocq-to-lean.ml) files. The Lean examples were checked with Lean 4.34.1, using its bundled library and no Mathlib dependency. For continued study, use [Theorem Proving in Lean 4](https://lean-lang.org/theorem_proving_in_lean4/) alongside the [Rocq reference manual](https://docs.rocq-prover.org/master/refman/): read the common construction first, then compare the rules that differ.*
