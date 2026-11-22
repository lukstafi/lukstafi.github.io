import Mathlib.Data.List.Basic
import Lean.Elab.Tactic.Omega

namespace GuardedTermCalls

variable {X W : Type*}

def Live (S : X → W → Prop) (x : X) := ∃ w, S x w
def Good (S G : X → W → Prop) (x : X) := Live S x ∧ ∀ w, S x w → G x w

theorem guarded_summary (S G : X → W → Prop) (x : X) :
    (∀ w, S x w → G x w) ↔ (Live S x → Good S G x) :=
  ⟨fun h live => ⟨live, h⟩, fun h w hw => (h ⟨w, hw⟩).2 w hw⟩

theorem check_scheme (Q : X → Prop) (S G : X → W → Prop) :
    (∀ x, Q x → ∀ w, S x w → G x w) ↔
    ∀ x, Q x ∧ Live S x → Good S G x := by
  constructor
  · rintro h x ⟨q,l⟩
    exact (guarded_summary S G x).mp (h x q) l
  · intro h x q
    exact (guarded_summary S G x).mpr (fun l => h x ⟨q,l⟩)

variable {Y Z I : Type*}

/-- Pull each guard of the second call back along the first result. -/
theorem sequence_domain (D : X → Prop) (H : X → Y → Prop) (L G : I → X → Y → Prop)
    (x : X) :
    (D x ∧ ∀ y, H x y → ∀ i, L i x y → G i x y) ↔
    (D x ∧ ∀ i, let S := fun a b => H a b ∧ L i a b
                Live S x → Good S (G i) x) := by
  constructor
  · rintro ⟨hd,h⟩
    exact ⟨hd, fun i => (guarded_summary _ _ x).mp (fun y hy => h y hy.1 i hy.2)⟩
  · rintro ⟨hd,h⟩
    exact ⟨hd, fun y hy i hi => (guarded_summary _ _ x).mpr (h i) y ⟨hy,hi⟩⟩

theorem sequence_result (H : X → Y → Prop) (D : X → Y → Prop) (J : X → Y → Z → Prop)
    (x : X) (z : Z) (safe : ∀ y, H x y → D x y) :
    (∃ y, H x y ∧ D x y ∧ J x y z) ↔ ∃ y, H x y ∧ J x y z := by
  constructor
  · rintro ⟨y,h,_,j⟩
    exact ⟨y,h,j⟩
  · rintro ⟨y,h,j⟩
    exact ⟨y,h,safe y h,j⟩

/-- A unary pattern is a string of successors ending at zero or a named hole. -/
structure Pat where
  depth : Nat
  hole : Option Nat

def Pat.val (p : Pat) (s : Nat → Nat) :=
  p.depth + p.hole.elim 0 s

abbrev Row := Pat × Pat
def Matches (p : Row) (x y : Nat) := ∃ s, p.1.val s = x ∧ p.2.val s = y
def Safe (p : Row) := ∀ s, p.1.val s ≠ p.2.val s

theorem same_hole {i j a b : Nat} (safe : Safe (⟨a,some i⟩, ⟨b,some j⟩)) : i = j := by
  by_contra h
  have forbid := safe (fun k => if k = i then b else a)
  simp [Pat.val, Ne.symm h, Nat.add_comm] at forbid

/-- Every sufficiently deep (n,2n) is outside this safe pattern. -/
theorem gap_missed (p : Row) (n : Nat) (hx : p.1.depth < n) (hy : p.2.depth < n)
    (safe : Safe p) : ¬ Matches p n (2*n) := by
  obtain ⟨⟨a, i⟩, ⟨b, j⟩⟩ := p
  change a < n at hx
  change b < n at hy
  rintro ⟨s, hs, ht⟩
  cases i with
  | none => simp [Pat.val] at hs; omega
  | some i =>
    cases j with
    | none => simp [Pat.val] at ht; omega
    | some j =>
      obtain rfl := same_hole safe
      simp [Pat.val] at hs ht
      omega

def maxDepth : List Row → Nat
  | [] => 0
  | p :: ps => max (max p.1.depth p.2.depth) (maxDepth ps)

theorem depth_bound {p : Row} {ps : List Row} (h : p ∈ ps) :
    p.1.depth ≤ maxDepth ps ∧ p.2.depth ≤ maxDepth ps := by
  induction ps with
  | nil => simp at h
  | cons q qs ih =>
    rcases List.mem_cons.mp h with rfl | rest
    · simp only [maxDepth]
      exact ⟨le_trans (le_max_left _ _) (le_max_left _ _),
        le_trans (le_max_right _ _) (le_max_left _ _)⟩
    · obtain ⟨ha,hb⟩ := ih rest
      exact ⟨le_trans ha (le_max_right _ _), le_trans hb (le_max_right _ _)⟩

theorem no_finite_cover (ps : List Row) (safe : ∀ p ∈ ps, Safe p) :
    ∃ x y : Nat, x ≠ y ∧ ∀ p ∈ ps, ¬ Matches p x y := by
  let n := maxDepth ps + 1
  exact ⟨n, 2*n, by dsimp [n]; omega, fun p hp =>
    gap_missed p n (Nat.lt_succ_of_le (depth_bound hp).1)
      (Nat.lt_succ_of_le (depth_bound hp).2) (safe p hp)⟩

/-- Every fixed positive offset is already maximal among the safe patterns. -/
theorem offset_maximal (d : Nat) (p : Row) (safe : Safe p)
    (covers : ∀ x, Matches p x (x+d)) :
    ∀ x y, Matches p x y → y = x+d := by
  obtain ⟨⟨a, i⟩, ⟨b, j⟩⟩ := p
  obtain ⟨t, ta, tb⟩ := covers (a+b+1)
  cases i with
  | none => simp [Pat.val] at ta; omega
  | some i =>
    cases j with
    | none => simp [Pat.val] at tb; omega
    | some j =>
      obtain rfl := same_hole safe
      simp [Pat.val] at ta tb
      rintro x y ⟨s, hx, hy⟩
      simp [Pat.val] at hx hy
      omega

inductive Piece where
  | gapRight (d : Nat)
  | gapLeft (d : Nat)
  | fixedLeft (n : Nat)
  | fixedRight (n : Nat)

def Piece.contains : Piece → Nat → Nat → Prop
  | .gapRight d, x, y => y = x+d+1
  | .gapLeft d, x, y => x = y+d+1
  | .fixedLeft n, x, y => x = n ∧ n < y
  | .fixedRight n, x, y => y = n ∧ n < x

/-- These four forms cover all safe unary patterns by generalization. -/
theorem classify (p : Row) (safe : Safe p) :
    ∃ c : Piece, ∀ s, c.contains (p.1.val s) (p.2.val s) := by
  obtain ⟨⟨a, i⟩, ⟨b, j⟩⟩ := p
  cases i with
  | none =>
    cases j with
    | none =>
      have neq := safe (fun _ => 0)
      simp [Pat.val] at neq
      by_cases h : a < b
      · exact ⟨.fixedLeft a, fun _ => by simp [Piece.contains, Pat.val, h]⟩
      · exact ⟨.fixedRight b, fun _ => by simp [Piece.contains, Pat.val]; omega⟩
    | some j =>
      have neq := safe (fun _ => a-b)
      simp [Pat.val] at neq
      exact ⟨.fixedLeft a, fun s => by simp [Piece.contains, Pat.val]; omega⟩
  | some i =>
    cases j with
    | none =>
      have neq := safe (fun _ => b-a)
      simp [Pat.val] at neq
      exact ⟨.fixedRight b, fun s => by simp [Piece.contains, Pat.val]; omega⟩
    | some j =>
      obtain rfl := same_hole safe
      have neq := safe (fun _ => 0)
      simp [Pat.val] at neq
      by_cases h : a < b
      · exact ⟨.gapRight (b-a-1), fun s => by simp [Piece.contains, Pat.val]; omega⟩
      · exact ⟨.gapLeft (a-b-1), fun s => by simp [Piece.contains, Pat.val]; omega⟩

theorem cutoff_maximal (n : Nat) (p : Row) (safe : Safe p)
    (cover : ∀ y, n < y → Matches p n y) :
    ∀ x y, Matches p x y → x = n ∧ n < y := by
  obtain ⟨c, bound⟩ := classify p safe
  have mem {x y} (h : Matches p x y) : c.contains x y := by
    obtain ⟨s, rfl, rfl⟩ := h
    exact bound s
  have h₁ := mem (cover (n+1) (by omega))
  have h₂ := mem (cover (n+2) (by omega))
  intro x y h
  have h₃ := mem h
  cases c <;> simp only [Piece.contains] at h₁ h₂ h₃ <;> omega

end GuardedTermCalls
