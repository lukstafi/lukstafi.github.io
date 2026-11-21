/- Structural steps in the single-carrier reduction. Lean 4.19, Std only. -/
import Std

namespace Carrier

inductive Tree (α : Type) where
  | a
  | var (x : α)
  | fork (l r : Tree α)
deriving DecidableEq

open Tree

def sub (σ : α → Tree β) : Tree α → Tree β
  | a => a
  | var x => σ x
  | fork l r => fork (sub σ l) (sub σ r)

abbrev Rigid := Tree Unit

def tag : Rigid := var ()

theorem cannot_get_tag (q : Tree Unit) (l r : Rigid) :
    sub (fun _ => fork l r) q ≠ tag := by
  cases q <;> simp [sub, tag]

theorem observation_copies (q : Tree Unit) (l r z : Rigid)
    (h : sub (fun _ => fork l r) q = fork tag z) : q = var () := by
  cases q with
  | a => cases h
  | var x => cases x; rfl
  | fork v w => exact False.elim (cannot_get_tag v l r (Tree.fork.inj h).1)

def tagged : Rigid → Bool
  | a => false
  | var _ => true
  | fork l r => tagged l || tagged r

def atPath : Tree α → List Bool → Option (Tree α)
  | t, [] => some t
  | fork l r, b :: p => atPath (if b then r else l) p
  | _, _ :: _ => none

/-- Every strict ancestor along this address is a fork whose left child carries the rigid tag. -/
def guarded : Rigid → List Bool → Prop
  | _, [] => True
  | fork l r, b :: p => tagged l = true ∧ guarded (if b then r else l) p
  | _, _ :: _ => False

theorem recover_address (σ : α → Rigid)
    (inert : ∀ x l r, σ x = fork l r → tagged l = false)
    (p : List Bool) (t : Tree α) (ok : guarded (sub σ t) p) :
    ∃ v, atPath t p = some v ∧ atPath (sub σ t) p = some (sub σ v) := by
  induction p generalizing t with
  | nil => exact ⟨t,by simp [atPath],by simp [atPath]⟩
  | cons b p ih =>
    cases t with
    | a => exact False.elim ok
    | var x =>
      change guarded (σ x) (b :: p) at ok
      cases h : σ x with
      | a => rw [h] at ok; exact False.elim ok
      | var y => rw [h] at ok; exact False.elim ok
      | fork l r =>
        rw [h] at ok
        exact Bool.noConfusion ((inert x l r h).symm.trans ok.1)
    | fork l r =>
      cases b with
      | false => exact ih l ok.2
      | true => exact ih r ok.2

def spine : List Rigid → Rigid
  | [] => a
  | x :: xs => fork (fork tag x) (spine xs)

def address : Nat → List Bool
  | 0 => [false,true]
  | n+1 => true :: address n

theorem spine_guard (xs : List Rigid) (i : Nat) (h : i < xs.length) :
    guarded (spine xs) (address i) := by
  induction xs generalizing i with
  | nil => simp at h
  | cons x xs ih =>
    cases i with
    | zero => simp [spine,address,guarded,tagged,tag]
    | succ i =>
      exact ⟨by simp [tagged,tag], ih i (Nat.lt_of_succ_lt_succ h)⟩

theorem packed_guard (xs : List Rigid) (i : Nat) (h : i < xs.length) :
    guarded (fork tag (spine xs)) (true :: address i) :=
  ⟨by simp [tagged,tag], spine_guard xs i h⟩

theorem bare_at_opposite_roots (s t : α → Tree β) (p : Tree α) (l r : Tree β)
    (h : (sub s p = a ∧ sub t p = fork l r) ∨
         (sub t p = a ∧ sub s p = fork l r)) : ∃ i, p = var i := by
  cases p with
  | a => simp [sub] at h
  | var i => exact ⟨i,rfl⟩
  | fork v w => simp [sub] at h

#print axioms observation_copies
#print axioms recover_address
#print axioms packed_guard
#print axioms bare_at_opposite_roots
end Carrier
