/- The two independent shape probes exclude registers at every possible depth. -/
import Std

namespace TwoObservations

inductive Tree (α : Type) where
  | atom
  | label (name : α)
  | fork (left right : Tree α)
deriving DecidableEq

open Tree

def observe (values : α → Tree β) : Tree α → Tree β
  | atom => atom
  | label name => values name
  | fork l r => fork (observe values l) (observe values r)

def perfect (marker : α) : Nat → Tree α
  | 0 => label marker
  | n+1 => fork (perfect marker n) (perfect marker n)

inductive Typed (colors : α → Prop) : Nat → Tree α → Prop where
  | leaf {c} : colors c → Typed colors 0 (label c)
  | node {n l r} : Typed colors n l → Typed colors n r → Typed colors (n+1) (fork l r)

inductive WithRegisters (colors regs : α → Prop) : Nat → Tree α → Prop where
  | color {c} : colors c → WithRegisters colors regs 0 (label c)
  | register {n c} : regs c → WithRegisters colors regs n (label c)
  | node {n l r} : WithRegisters colors regs n l → WithRegisters colors regs n r →
      WithRegisters colors regs (n+1) (fork l r)

/-- A shape observation restricts each generator that could occupy a whole subtree.
The port table determines which colors and private registers are possible. -/
theorem one_probe {colors regs : β → Prop} {store : α → Tree β} {test : α → Tree γ}
    {marker : γ}
    (ports : ∀ name n, test name = perfect marker n → WithRegisters colors regs n (store name))
    (body : Tree α) (n : Nat) (eqn : observe test body = perfect marker n) :
    WithRegisters colors regs n (observe store body) := by
  induction body generalizing n with
  | atom => cases n <;> simp [observe,perfect] at eqn
  | label name => exact ports name n eqn
  | fork l r ihl ihr =>
    cases n with
    | zero => simp [observe,perfect] at eqn
    | succ n =>
      simp only [observe,perfect,Tree.fork.injEq] at eqn
      exact .node (ihl n eqn.1) (ihr n eqn.2)

theorem intersect_probes {colors first second : α → Prop}
    (disjoint : ∀ c, first c → second c → False)
    {n : Nat} {t : Tree α} (a : WithRegisters colors first n t)
    (b : WithRegisters colors second n t) : Typed colors n t := by
  induction a with
  | color h => exact .leaf h
  | register h =>
    cases b with
    | color hc => exact .leaf hc
    | register h' => exact False.elim (disjoint _ h h')
  | node _ _ ihl ihr =>
    cases b with
    | node hl hr => exact .node (ihl hl) (ihr hr)

/-- Register names can be read by either output strategy. The equality in the
storage observation and the two private marker tests suffice for exact typing. -/
theorem twins {colors first second : β → Prop}
    {store : α → Tree β} {test : α → Tree γ} {m₁ m₂ : γ}
    (p₁ : ∀ h n, test h = perfect m₁ n → WithRegisters colors first n (store h))
    (p₂ : ∀ h n, test h = perfect m₂ n → WithRegisters colors second n (store h))
    (disjoint : ∀ c, first c → second c → False)
    (u v : Tree α) (n : Nat)
    (s₁ : observe test u = perfect m₁ n) (s₂ : observe test v = perfect m₂ n)
    (same : observe store u = observe store v) : Typed colors n (observe store u) := by
  apply intersect_probes disjoint (one_probe p₁ u n s₁)
  rw [same]
  exact one_probe p₂ v n s₂

#print axioms twins

end TwoObservations
