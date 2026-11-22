import Mathlib.Algebra.Group.Hom.Basic
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas
import Mathlib.Data.Rat.Defs
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

namespace RecursiveCapture

variable {V K I : Type*} [AddCommGroup V]

/-- The first letter names the first recursive update applied to the error. -/
def steps (t : I → V →+ V) : List I → V →+ V
  | [] => AddMonoidHom.id V
  | a :: w => (steps t w).comp (t a)

theorem steps_append (t : I → V →+ V) (u v : List I) (b : V) :
    steps t (u ++ v) b = steps t v (steps t u b) := by
  induction u generalizing b with
  | nil => simp [steps]
  | cons a u ih => simpa [steps] using ih (t a b)

/-- After every word of length n kills the base, truncation preserves
    every longer output. This bounds the exact convex supplier iteration. -/
theorem bounded_orbit (t : I → V →+ V) (base : Set V) (n : Nat)
    (kill : ∀ w : List I, w.length = n → ∀ b ∈ base, steps t w b = 0)
    (w : List I) (b : V) (hb : b ∈ base) :
    ∃ short : List I, short.length ≤ n ∧ steps t short b = steps t w b := by
  by_cases h : w.length ≤ n
  · exact ⟨w,h,rfl⟩
  · have len : (w.take n).length = n := by simp [List.length_take, Nat.le_of_not_ge h]
    have killed := kill _ len b hb
    have parts := steps_append t (w.take n) (w.drop n) b
    rw [List.take_append_drop, killed, map_zero] at parts
    exact ⟨w.take n,len.le,killed.trans parts.symm⟩

def obs (c : V →+ ℚ) (t : I → V →+ V) (w : List I) := c.comp (steps t w)

/-- A finite-dimensional hull can still acquire a fresh rational endpoint
    at every pass, inside a fixed bounded interval. -/
theorem halving_strict (n : Nat) :
    ∃ e : ℚ, ((1/2 : ℚ)^(n+1) ≤ e ∧ e ≤ 1) ∧ ¬ ((1/2 : ℚ)^n ≤ e) := by
  have pos : 0 < (1/2 : ℚ)^n := pow_pos (by norm_num) n
  have bounded : (1/2 : ℚ)^n ≤ 1 := pow_le_one₀ (by norm_num) (by norm_num)
  refine ⟨(1/2 : ℚ)^(n+1), ⟨le_rfl, ?_⟩, ?_⟩ <;> rw [pow_succ] <;> linarith

structure Valid (legal : V → Prop) (h : V → K) (c : V →+ ℚ)
    (t : I → V →+ V) (R : K → V → Prop) : Prop where
  base : ∀ x, legal x → R (h x) x
  next : ∀ x, legal x → ∀ a r, R (h x) r → R (h x) (x + t a (r - x))
  safe : ∀ x, legal x → ∀ r, R (h x) r → c r ≤ c x

theorem run_word {legal h c t R} (v : Valid (K:=K) (I:=I) legal h c t R)
    (x : V) (hx : legal x) (w : List I) (r : V) (hr : R (h x) r) :
    R (h x) (x + steps t w (r - x)) := by
  induction w generalizing r with
  | nil => simpa [steps, add_comm] using hr
  | cons a w ih =>
    have later := ih _ (v.next x hx a r hr)
    simpa [steps, add_comm] using later

/-- A one-sided caller forces equality of all future observations on each
    legal interface fibre. The invariant built in the reverse direction
    can be used for arbitrarily many different recursive suppliers. -/
theorem interface_iff (legal : V → Prop) (h : V → K) (c : V →+ ℚ)
    (t : I → V →+ V) :
    (∃ R, Valid legal h c t R) ↔
    ∀ x, legal x → ∀ y, legal y → h x = h y →
      ∀ w, obs c t w x = obs c t w y := by
  constructor
  · rintro ⟨R,v⟩ x hx y hy eq w
    have bound (p q : V) (hp : legal p) (hq : legal q) (same : h p = h q) :
        obs c t w q ≤ obs c t w p := by
      have start : R (h p) q := same.symm ▸ v.base q hq
      have upper := v.safe p hp _ (run_word v p hp w q start)
      simp [map_add, map_sub] at upper
      change c (steps t w q) ≤ c (steps t w p)
      linarith
    exact le_antisymm (bound y x hy hx eq.symm) (bound x y hx hy eq)
  · intro equal
    let R (k : K) (r : V) := ∀ y, legal y → h y = k →
      ∀ w, obs c t w r = obs c t w y
    refine ⟨R, ?_, ?_, ?_⟩
    · intro x hx y hy same w
      exact equal x hx y hy same.symm w
    · intro x hx a r hr y hy same w
      have e := hr x hx rfl (a :: w)
      have xy := equal x hx y hy same.symm w
      simp only [obs,steps,AddMonoidHom.comp_apply] at e
      simp only [obs,AddMonoidHom.comp_apply,map_add,map_sub] at xy ⊢
      rw [e]
      simpa using xy
    · intro x hx r hr
      exact le_of_eq (hr x hx rfl [])

section Rank
variable {E : Type*} [AddCommGroup E] [Module ℚ E]

def observationRow (c : E →ₗ[ℚ] ℚ) (t : I → E →ₗ[ℚ] E) :
    List I → E →ₗ[ℚ] ℚ
  | [] => c
  | a :: w => (observationRow c t w).comp (t a)

theorem closed_rows (L : Submodule ℚ (E →ₗ[ℚ] ℚ)) (c : E →ₗ[ℚ] ℚ)
    (t : I → E →ₗ[ℚ] E) (base : c ∈ L)
    (closed : ∀ f ∈ L, ∀ a, f.comp (t a) ∈ L) (w : List I) :
    observationRow c t w ∈ L := by
  induction w with
  | nil => exact base
  | cons a w ih => exact closed _ ih a

variable {F G : Type*} [AddCommGroup F] [Module ℚ F] [AddCommGroup G] [Module ℚ G]

theorem fibres_iff_kernel (capture : E →ₗ[ℚ] F) (observe : E →ₗ[ℚ] G) :
    (∀ x y, capture x = capture y → observe x = observe y) ↔
    LinearMap.ker capture ≤ LinearMap.ker observe := by
  constructor
  · intro agree v hv
    have hz : capture v = capture 0 := by simpa using hv
    simpa using agree v 0 hz
  · intro included x y same
    have h : x-y ∈ LinearMap.ker capture := by simp [same]
    have diff := included h
    apply sub_eq_zero.mp
    simpa using diff

theorem minimum_linear_rank [FiniteDimensional ℚ E]
    (capture : E →ₗ[ℚ] F) (observe : E →ₗ[ℚ] G)
    (same : ∀ x y, capture x = capture y → observe x = observe y) :
    Module.finrank ℚ (LinearMap.range observe) ≤ Module.finrank ℚ (LinearMap.range capture) := by
  have k := Submodule.finrank_mono ((fibres_iff_kernel capture observe).mp same)
  have cap := capture.finrank_range_add_finrank_ker
  have ob := observe.finrank_range_add_finrank_ker
  omega

/-- A row that separates a collision adds an independent statistic. -/
theorem collision_strict (known : Submodule ℚ (E →ₗ[ℚ] ℚ)) (x y : E)
    (row : E →ₗ[ℚ] ℚ) (same : ∀ f ∈ known, f x = f y)
    (diff : row x ≠ row y) :
    known < known ⊔ Submodule.span ℚ {row} := by
  apply lt_of_le_of_ne le_sup_left
  intro eq
  have member : row ∈ known ⊔ Submodule.span ℚ {row} :=
    (show Submodule.span ℚ {row} ≤ known ⊔ Submodule.span ℚ {row} from le_sup_right)
      (Submodule.subset_span (Set.mem_singleton row))
  exact diff (same row (eq.symm ▸ member))

/-- Only actual additions are counted. Each collision can come from a
    different domain while the supplied rows remain in a fixed ceiling. -/
theorem repair_budget [FiniteDimensional ℚ E] (S : Nat → Submodule ℚ E)
    (ceiling : Submodule ℚ E) (n : Nat)
    (grow : ∀ j < n, S j < S (j+1)) (cap : S n ≤ ceiling) :
    n ≤ Module.finrank ℚ ceiling - Module.finrank ℚ (S 0) := by
  have steps (j : Nat) (hj : j ≤ n) :
      Module.finrank ℚ (S 0) + j ≤ Module.finrank ℚ (S j) := by
    induction j with
    | zero => simp
    | succ j ih =>
      have prev := ih (Nat.le_of_succ_le hj)
      have inc := Submodule.finrank_lt_finrank_of_lt (grow j hj)
      omega
  have total := steps n le_rfl
  have bound := Submodule.finrank_mono cap
  omega
end Rank

/-- Errors are measured relative to the three input indices. -/
abbrev Triple := ℚ × ℚ × ℚ

def simplex (cap : ℚ) (e : Triple) :=
  0 ≤ e.1 ∧ 0 ≤ e.2.1 ∧ 0 ≤ e.2.2 ∧ e.1 + e.2.1 + e.2.2 ≤ cap

inductive Reach (cap : ℚ) : Triple → Prop where
  | base : Reach cap (0,0,cap)
  | a {e} : Reach cap e → Reach cap (e.2.1,0,0)
  | b {e} : Reach cap e → Reach cap (0,e.2.2,0)

theorem reachable (cap : ℚ) (e : Triple) : Reach cap e ↔
    e = (0,0,cap) ∨ e = (0,cap,0) ∨ e = (cap,0,0) ∨ e = (0,0,0) := by
  constructor
  · intro h
    induction h with
    | base => exact Or.inl rfl
    | a _ ih => rcases ih with rfl | rfl | rfl | rfl <;> simp
    | b _ ih => rcases ih with rfl | rfl | rfl | rfl <;> simp
  · rintro (rfl | rfl | rfl | rfl)
    · exact .base
    · exact .b .base
    · exact .a (.b .base)
    · exact .a .base

theorem simplex_inductive {cap : ℚ} (hc : 0 ≤ cap) :
    simplex cap (0,0,cap) ∧ ∀ e : Triple, simplex cap e →
    simplex cap (e.2.1,0,0) ∧ simplex cap (0,e.2.2,0) := by
  refine ⟨by simp [simplex,hc], ?_⟩
  rintro e ⟨ha,hb,hc',h⟩
  simp [simplex,hb,hc']
  constructor <;> linarith

/-- In arbitrary dimension the normalized distances are exactly the
    barycentric weights at the nonzero axis vertices. -/
theorem weighted_barycentric {ι : Type*} [Fintype ι] (u e : ι → ℚ)
    (positive : ∀ i, 0 < u i) :
    ((∀ i, 0 ≤ e i) ∧ ∑ i, e i / u i ≤ 1) ↔
    ∃ (origin : ℚ) (weight : ι → ℚ), 0 ≤ origin ∧ (∀ i, 0 ≤ weight i) ∧
      origin + ∑ i, weight i = 1 ∧ ∀ i, weight i * u i = e i := by
  constructor
  · rintro ⟨nonneg,total⟩
    refine ⟨1 - ∑ i, e i / u i, fun i => e i / u i, sub_nonneg.mpr total,
      fun i => div_nonneg (nonneg i) (positive i).le, by simp, ?_⟩
    intro i
    exact div_mul_cancel₀ _ (positive i).ne'
  · rintro ⟨o,w,ho,hw,hs,he⟩
    have coord (i : ι) : e i / u i = w i := by
      rw [← he i]
      exact mul_div_cancel_right₀ _ (positive i).ne'
    exact ⟨fun i => he i ▸ mul_nonneg (hw i) (positive i).le, by simp_rw [coord]; linarith⟩

theorem pairwise_gap : (1:ℚ)+1 ≤ 2 ∧ ¬ simplex 2 (1,1,1) := by
  norm_num [simplex]

end RecursiveCapture
