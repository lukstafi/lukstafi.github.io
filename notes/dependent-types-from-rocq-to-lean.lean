-- Examples for Dependent Types from Rocq to Lean 4
-- Checked with leanprover/lean4:v4.34.1. No Mathlib dependency.

universe u v w

def dependentCompose {A : Type u} {B : Type v}
    {C : B → Type w} (f : A → B) (g : (b : B) → C b) :
    (a : A) → C (f a) :=
  fun a => g (f a)

theorem composeImplications (P Q R : Prop)
    (hPQ : P → Q) (hQR : Q → R) : P → R :=
  fun hP => hQR (hPQ hP)

theorem composeImplicationsBy (P Q R : Prop)
    (hPQ : P → Q) (hQR : Q → R) : P → R := by
  intro hP
  apply hQR
  exact hPQ hP

inductive Vec (α : Type u) : Nat → Type u where
  | nil : Vec α 0
  | cons {n : Nat} : α → Vec α n → Vec α (n + 1)

def Vec.head {α : Type u} {n : Nat} : Vec α (n + 1) → α
  | .cons x _ => x

def addLeft : Nat → Nat → Nat
  | 0, m => m
  | n + 1, m => Nat.succ (addLeft n m)

example (n : Nat) : addLeft 0 n = n := rfl

theorem addLeft_zero (n : Nat) : addLeft n 0 = n := by
  induction n with
  | zero => rfl
  | succ n ih =>
      change Nat.succ (addLeft n 0) = Nat.succ n
      exact congrArg Nat.succ ih

def transport {A : Type u} (B : A → Type v)
    {a b : A} (h : a = b) (x : B a) : B b :=
  h ▸ x

def resizeVec {α : Type u} {n m : Nat}
    (h : n = m) (xs : Vec α n) : Vec α m :=
  transport (Vec α) h xs

example (P : Prop) (h₁ h₂ : P) : h₁ = h₂ := rfl

example {α : Type u} (xs : Array α) (h₁ h₂ : 0 < xs.size) :
    xs[0]'h₁ = xs[0]'h₂ := rfl

def WitnessData (α : Type u) (P : α → Prop) :=
  {x : α // P x}

theorem forgetWitness {α : Type u} {P : α → Prop}
    (w : WitnessData α P) : ∃ x, P x :=
  ⟨w.val, w.property⟩

noncomputable def chooseWitness {α : Type u} {P : α → Prop}
    (h : ∃ x, P x) : WitnessData α P :=
  ⟨Classical.choose h, Classical.choose_spec h⟩

example {A : Type u} {B : Type v} (f g : A → B)
    (h : ∀ x, f x = g x) : f = g :=
  funext h

def SubsetOf (A : Type u) := A → Prop

theorem subsetExt {A : Type u} (S T : SubsetOf A)
    (h : ∀ x, S x ↔ T x) : S = T :=
  funext (fun x => propext (h x))

#print axioms subsetExt

def SameParity (a b : Nat) : Prop := a % 2 = b % 2

def parityValue : Quot SameParity → Nat :=
  Quot.lift (fun n => n % 2) (fun _ _ h => h)

example : parityValue (Quot.mk SameParity 5) = 1 := rfl

example : Quot.mk SameParity 1 = Quot.mk SameParity 3 :=
  Quot.sound (by rfl)

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

inductive Rose (α : Type u) where
  | node : α → List (Rose α) → Rose α

example (A : Type) (h : A = A) (x : A) : cast h x = x := rfl

#reduce (fun (h : Nat = Nat) => cast h (37 : Nat))
-- fun h => 37

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

-- Bounded diagnostic for the non-normalizing example discussed in the article.
-- The handwritten reduction cycle proves divergence; this only checks the
-- behavior of the pinned toolchain without running an unbounded reduction.
/--
error: maximum recursion depth has been reached
use `set_option maxRecDepth <num>` to increase limit
use `set_option diagnostics true` to get diagnostic information
-/
#guard_msgs in
set_option maxRecDepth 128 in
#reduce (proofs := true) ReductionLoop.loop
