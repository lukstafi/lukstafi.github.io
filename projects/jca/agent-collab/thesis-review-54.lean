import Mathlib.Tactic.Linarith
import Mathlib.Algebra.Order.Field.Rat
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Algebra.BigOperators.Group.Finset.Piecewise

namespace ArithmeticAbduction

/-- The three constructor branches fix every coefficient of an affine answer. -/
theorem coordinate_fit (a b c east north : ℚ)
    (originRow : c = 0) (eastRow : a + c = east) (northRow : b + c = north) :
    a = east ∧ b = north ∧ c = 0 := by
  exact ⟨by linarith, by linarith, originRow⟩

/-- Project the region below the goal. Its upper bounds control every payload. -/
theorem margin_criterion {H : Type*} (D : H → Prop) (g : H → ℚ) :
    (∀ h, D h → g h ≤ 0) ↔ (∀ t, (∃ h, D h ∧ t ≤ g h) → t ≤ 0) := by
  constructor
  · rintro allSafe t ⟨h, dh, ht⟩
    exact ht.trans (allSafe h dh)
  · intro bounded h dh
    exact bounded (g h) ⟨h, dh, le_rfl⟩

private theorem positive_below (bounds : List ℚ) (pos : ∀ u ∈ bounds, 0 < u) :
    ∃ t : ℚ, 0 < t ∧ ∀ u ∈ bounds, t ≤ u := by
  induction bounds with
  | nil => exact ⟨1, by decide, by simp⟩
  | cons v vs ih =>
    obtain ⟨t, ht, below⟩ := ih (fun u hu => pos u (List.mem_cons_of_mem _ hu))
    refine ⟨min v t, lt_min (pos v (List.mem_cons_self ..)) ht, ?_⟩
    intro u hu
    rcases List.mem_cons.mp hu with rfl | h
    · exact min_le_left _ _
    · exact (min_le_right _ _).trans (below u h)

/-- At a fixed feasible public input, a finite exact projection supplies
    precisely a disjunction of guards, including false for no upper bounds. -/
theorem projected_alternatives {H : Type*} (D : H → Prop) (g : H → ℚ)
    (bounds : List ℚ)
    (projection : ∀ t, (∃ h, D h ∧ t ≤ g h) ↔ ∀ u ∈ bounds, t ≤ u) :
    (∀ h, D h → g h ≤ 0) ↔ ∃ u ∈ bounds, u ≤ 0 := by
  rw [margin_criterion]
  constructor
  · intro safe
    by_contra none
    have pos : ∀ u ∈ bounds, 0 < u := fun u hu =>
      lt_of_not_ge (fun nonpos => none ⟨u, hu, nonpos⟩)
    obtain ⟨t, ht, below⟩ := positive_below bounds pos
    exact (not_lt_of_ge (safe t ((projection t).mpr below))) ht
  · rintro ⟨u, hu, nonpos⟩ t attained
    exact ((projection t).mp attained u hu).trans nonpos

theorem box (i j z : ℚ) :
    (∀ x y : ℚ, x ≤ i → y ≤ j → x + y ≤ z) ↔ i + j ≤ z := by
  constructor
  · intro h
    exact h i j le_rfl le_rfl
  · intro h x y hx hy
    linarith

theorem many_bounds {I : Type*} (S : Finset I) (i : I → ℚ) (z : ℚ) :
    (∀ x : I → ℚ, (∀ s ∈ S, x s ≤ i s) → S.sum x ≤ z) ↔ S.sum i ≤ z := by
  constructor
  · intro h
    exact h i (fun _ _ => le_rfl)
  · intro h x hx
    exact (Finset.sum_le_sum hx).trans h

theorem missing_row {I : Type*} (S : Finset I) (i : I → ℚ) (z : ℚ) (m : I)
    (hm : m ∈ S) : ∃ x : I → ℚ, (∀ s, s ≠ m → x s ≤ i s) ∧ z < S.sum x := by
  classical
  refine ⟨fun s => i s + if s = m then z + 1 - S.sum i else 0, ?_, ?_⟩
  · intro s h
    simp [h]
  · simp only [Finset.sum_add_distrib, Finset.sum_ite_eq', hm, if_true]
    linarith

theorem oblique (i j z : ℚ) :
    (∀ x y : ℚ, x + y ≤ i → x - y ≤ j → 3*x + y ≤ z) ↔ 2*i + j ≤ z := by
  constructor
  · intro h
    have hh := h ((i+j)/2) ((i-j)/2) (by linarith) (by linarith)
    linarith
  · intro h x y hx hy
    linarith

/-- Two projected upper bounds yield alternative sufficient conditions. -/
theorem alternatives (i j z : ℚ) :
    (∀ x y : ℚ, x ≤ i → x ≤ j → y ≤ j → x+y ≤ z) ↔
      i+j ≤ z ∨ 2*j ≤ z := by
  constructor
  · intro h
    rcases le_total i j with hij | hji
    · exact Or.inl (h i j le_rfl hij le_rfl)
    · have hh := h j j hji le_rfl le_rfl
      exact Or.inr (by linarith)
  · rintro (h | h) x y hi hj hy <;> linarith

end ArithmeticAbduction
