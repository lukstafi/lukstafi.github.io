/- Monadic JCA: the word-equation unification step and its ground instances.
   Lean 4.19.0, no mathlib. -/
import Std
namespace MonadicJCA

inductive Leaf (C P : Type) where
  | constant (c : C) | param (p : P)
  deriving DecidableEq

abbrev Ground (Γ C : Type) := List Γ × C
abbrev Term (Γ C P : Type) := List Γ × Leaf C P

variable {Γ C P : Type}
def prepend (w : List Γ) (v : Ground Γ C) : Ground Γ C := (w ++ v.1, v.2)

def leaf (env : P → Ground Γ C) : Leaf C P → Ground Γ C
  | .constant c => ([],c)
  | .param p => env p

def value (env : P → Ground Γ C) (t : Term Γ C P) := prepend t.1 (leaf env t.2)

theorem same_leaf (e : P → Ground Γ C) (a b : List Γ) (d : Leaf C P) :
    value e (a,d) = value e (b,d) ↔ a=b := by
  constructor
  · intro h
    have eq : a ++ (leaf e d).1 = b ++ (leaf e d).1 := congrArg Prod.fst h
    exact List.append_cancel_right eq
  · rintro rfl; rfl

theorem oriented (e : P → Ground Γ C) (a u : List Γ) (p : P) (d : Leaf C P) :
    value e (a,.param p) = value e (a++u,d) ↔ e p = value e (u,d) := by
  simp [value, prepend, leaf, Prod.ext_iff, List.append_assoc]

def replace [DecidableEq P] (p : P) (rhs : Term Γ C P) (t : Term Γ C P) : Term Γ C P :=
  match t.2 with
  | .param q => if q=p then (t.1++rhs.1,rhs.2) else t
  | .constant _ => t

def rebind [DecidableEq P] (p : P) (rhs : Term Γ C P) (e : P → Ground Γ C) (q : P) :=
  if q=p then value e rhs else e q

theorem value_replace [DecidableEq P] (p : P) (rhs t : Term Γ C P) (e : P → Ground Γ C) :
    value e (replace p rhs t) = value (rebind p rhs e) t := by
  obtain ⟨w, c | q⟩ := t
  · rfl
  · by_cases h : q=p <;> simp [value, replace, prepend, leaf, rebind, h, List.append_assoc]

theorem rebind_solves [DecidableEq P] (p : P) (rhs : Term Γ C P)
    (fresh : rhs.2 ≠ .param p) (e : P → Ground Γ C) :
    rebind p rhs e p = value (rebind p rhs e) rhs := by
  obtain ⟨w, c | q⟩ := rhs
  · simp [value, rebind, leaf]
  · have ne : q ≠ p := fun eq => fresh (eq ▸ rfl)
    simp [value, rebind, leaf, ne]

theorem rebind_complete [DecidableEq P] (p : P) (rhs : Term Γ C P)
    (e : P → Ground Γ C) (solves : e p = value e rhs) : rebind p rhs e = e := by
  funext q
  by_cases h : q=p <;> simp [rebind, h, ← solves]

theorem prefix_comparable (a b x y : List Γ) (h : a++x = b++y) :
    (∃ u, b=a++u) ∨ (∃ u, a=b++u) := by
  induction a generalizing b with
  | nil => exact Or.inl ⟨b,rfl⟩
  | cons c a ih =>
    cases b with
    | nil => exact Or.inr ⟨c::a,rfl⟩
    | cons d b =>
      obtain ⟨rfl, tail⟩ := List.cons.inj h
      rcases ih b tail with ⟨u, rfl⟩ | ⟨u, rfl⟩
      · exact Or.inl ⟨u,rfl⟩
      · exact Or.inr ⟨u,rfl⟩

/-- A strict prefix cannot end on a constant on the shorter side. -/
theorem short_constant (a u : List Γ) (c : C) (d : Leaf C P) (e : P → Ground Γ C)
    (eq : value e (a,.constant c) = value e (a++u,d)) : u=[] := by
  have h := congrArg (fun z : Ground Γ C => z.1.length) eq
  change (a ++ []).length = ((a ++ u) ++ (leaf e d).1).length at h
  simp only [List.append_nil, List.length_append] at h
  apply List.length_eq_zero_iff.mp
  omega

#print axioms same_leaf
#print axioms oriented
#print axioms value_replace
#print axioms rebind_solves
#print axioms rebind_complete
#print axioms prefix_comparable
#print axioms short_constant
end MonadicJCA
