import Mathlib.Topology.Order.Basic
import Mathlib.Data.Fintype.Card
import Mathlib.Tactic.Linarith

namespace AffineGuards

variable {X F I J : Type*}

/-- Coefficients in the validity cone give nonpositive values everywhere on a cell. -/
def Valid (eval : F → X → ℚ) (cell : X → Prop) (f : F) :=
  ∀ x, cell x → eval f x ≤ 0

theorem outside_cones (eval : F → X → ℚ) (live : I → X → Prop) (bad : X → Prop) :
    (∃ f, Valid eval bad f ∧ ∀ i, ¬ Valid eval (live i) f) ↔
    (∃ f, Valid eval bad f ∧ ∀ i, ∃ x, live i x ∧ 0 < eval f x) := by
  simp only [Valid, not_forall, Classical.not_imp, not_le, exists_prop]

/-- Once the faces are fixed, each live state must keep one witness across all faces. -/
theorem shared_tuple (live : I → X → Prop) (hit : J → X → Prop) :
    (∀ i, ∃ x, live i x ∧ ∀ j, hit j x) ↔
    (∃ p : I → X, (∀ i, live i (p i)) ∧ ∀ j i, hit j (p i)) := by
  constructor
  · intro h
    choose p hp both using h
    exact ⟨p, hp, fun j i => both i j⟩
  · rintro ⟨p, hp, both⟩ i
    exact ⟨p i, hp i, fun j => both j i⟩

/-- Finite strict margins preserve the freedom to choose witnesses in a dense
subset of each live cell, including a lower-dimensional cell. -/
theorem dense_witnesses {Y : Type*} [TopologicalSpace Y] [LinearOrder Y] [Zero Y]
    [OrderClosedTopology Y] [TopologicalSpace X] [Finite J]
    (allowed : I → Set X) (x : I → X) (denseAt : ∀ i, x i ∈ closure (allowed i))
    (value : J → X → Y) (cont : ∀ j, Continuous (value j))
    (margin : ∀ i j, 0 < value j (x i)) :
    ∃ p : I → X, (∀ i, p i ∈ allowed i) ∧ ∀ j i, 0 < value j (p i) := by
  apply (shared_tuple (fun i y => y ∈ allowed i) (fun j y => 0 < value j y)).mp
  intro i
  let U := ⋂ j, {y | 0 < value j y}
  have op : IsOpen U := isOpen_iInter_of_finite fun j => isOpen_lt continuous_const (cont j)
  have mem : x i ∈ U := Set.mem_iInter.mpr fun j => margin i j
  obtain ⟨y, hy, ha⟩ := (mem_closure_iff.mp (denseAt i)) U op mem
  exact ⟨y, ha, Set.mem_iInter.mp hy⟩

/-- A returned conjunction that admits all pairwise midpoints needs at least
one affine face per excluded point. Each face cannot reject both endpoints. -/
theorem face_lower_bound [Fintype I] [Fintype J] (rejects : J → I → Prop)
    (guard : ∀ i, ∃ j, rejects j i)
    (midpoints : ∀ j i k, rejects j i → rejects j k → i = k) :
    Fintype.card I ≤ Fintype.card J := by
  choose face bad using guard
  apply Fintype.card_le_of_injective face
  intro i k eq
  exact midpoints (face i) i k (bad i) (eq ▸ bad k)

theorem midpoint_forces_one (u v : ℚ) (inside : (u+v)/2 ≤ 0) : u ≤ 0 ∨ v ≤ 0 := by
  by_contra! h
  linarith [h.1, h.2]

/-- Candidate faces for each forbidden cell already retain the fixed points.
The new point fails for that cell just when its evaluation is nonpositive
on the entire candidate family. -/
theorem last_witness (eval : F → X → ℚ) (live : X → Prop) (candidates : J → F → Prop) :
    (∃ x, live x ∧ ∀ j, ¬ Valid (fun y f => eval f y) (candidates j) x) ↔
    (∃ x, live x ∧ ∃ faces : J → F, ∀ j, candidates j (faces j) ∧ 0 < eval (faces j) x) := by
  simp only [Valid, not_forall, Classical.not_imp, not_le, exists_prop]
  constructor
  · rintro ⟨x, hx, h⟩
    choose f hf using h
    exact ⟨x, hx, f, hf⟩
  · rintro ⟨x, hx, f, hf⟩
    exact ⟨x, hx, fun j => ⟨f j, hf j⟩⟩

/-- Midpoint obstruction and a matching line for the narrow window. -/
theorem slit (lo hi : ℚ) (t : ℚ) (h : 0 ≤ t ∧ t ≤ 1) :
    (¬ (0 ≤ t ∧ t ≤ lo) ∧ ¬ (hi ≤ t ∧ t ≤ 1)) ↔ lo < t ∧ t < hi := by
  simp [h.1, h.2]

theorem denominator_cost (n d q : ℕ) (positive : 0 < n) (small : n*q < d) : q < d := by
  exact lt_of_le_of_lt (by simpa using Nat.mul_le_mul_right q positive) small

end AffineGuards
