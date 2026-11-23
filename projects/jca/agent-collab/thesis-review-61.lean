import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import Mathlib.Algebra.Order.Ring.Abs
import Mathlib.Data.Real.Archimedean
import Mathlib.Algebra.Order.Archimedean.Basic

namespace FoldedCycle

/-- The weighted rotation and a tight reflection preserve the measured length. -/
theorem tight_length (D c s x y : ℝ) (unit : c^2 + D*s^2 = 1) :
    (c*x+D*s*y)^2 + D*|c*y-s*x|^2 = x^2 + D*y^2 := by
  rw [sq_abs]
  nlinarith [congrArg (fun a : ℝ => a*(x^2+D*y^2)) unit]

theorem relaxed_length (D c s x y z : ℝ) (hD : 0 ≤ D)
    (unit : c^2+D*s^2=1) (lo : -(c*y-s*x) ≤ z) (hi : c*y-s*x ≤ z) :
    x^2+D*y^2 ≤ (c*x+D*s*y)^2+D*z^2 := by
  have bound := mul_nonneg hD (mul_nonneg (sub_nonneg.mpr hi)
    (show 0 ≤ z+(c*y-s*x) by linarith))
  nlinarith [congrArg (fun a : ℝ => a*(x^2+D*y^2)) unit]

/-- A single angular inequality certifies an entire incoming wedge. -/
theorem tight_wedge {c b s x y : ℝ} (hc : 0 ≤ c) (hb : 0 ≤ b)
    (hs : 0 ≤ s) (hy : 0 ≤ y) (fits : (c*c-b*s)*y ≤ 2*c*s*x) :
    c*|c*y-s*x| ≤ s*(c*x+b*y) := by
  rcases le_total 0 (c*y-s*x) with h | h
  · rw [abs_of_nonneg h]; linarith only [fits]
  · rw [abs_of_nonpos h]
    nlinarith [mul_nonneg (mul_nonneg hb hs) hy, mul_nonneg (mul_nonneg hc hc) hy]

theorem propagate_wedge {c b s k x y : ℝ} (hc : 0 ≤ c) (hs : 0 ≤ s)
    (hx : 0 ≤ x) (hy : 0 ≤ y) (inside : y ≤ k*x)
    (angle : k*(c*c-b*s) ≤ 2*c*s) : (c*c-b*s)*y ≤ 2*c*s*x := by
  by_cases h : 0 ≤ c*c-b*s
  · nlinarith only [mul_le_mul_of_nonneg_left inside h,
      mul_le_mul_of_nonneg_right angle hx]
  · exact (mul_nonpos_of_nonpos_of_nonneg (le_of_not_ge h) hy).trans (by positivity)

theorem cap_bounds {D a x y : ℝ} (hy : 0 ≤ y)
    (wedge : (D-a^2)*y ≤ 2*a*x) :
    x^2+D*y^2 ≤ (x+a*y)^2 ∧ D*(x+a*y)^2 ≤ (D+a^2)*(x^2+D*y^2) := by
  constructor
  · nlinarith [mul_le_mul_of_nonneg_right wedge hy]
  · nlinarith [sq_nonneg (a*x-D*y)]

/-- An admitted parent has one radius below both caps. Each child may open
    the fold afresh with multiplicative overhead at most 1+d. -/
theorem child_caps {H L r d t R : ℝ} (hd : 0 ≤ d) (ht : 0 ≤ t) (hR : 0 ≤ R)
    (cone : R ≤ H*t) (guard : R ≤ 1+L*t)
    (gain : d ≤ r-1) (change : d*H ≤ L*(r-1)) :
    (1+d)*R ≤ H*(r*t) ∧ (1+d)*R ≤ 1+L*(r*t) := by
  have hr : 0 ≤ r := by linarith
  constructor
  · nlinarith only [mul_le_mul_of_nonneg_right gain hR, mul_le_mul_of_nonneg_left cone hr]
  · nlinarith only [guard, mul_le_mul_of_nonneg_left cone hd,
      mul_le_mul_of_nonneg_right change ht]

/-- Handles a whole caller, including zero slack and positive slack
    tending to zero. The caller may sit on the original disk boundary. -/
theorem caller_caps {H h r d t R : ℝ} (hd : 0 ≤ d) (ht : 0 ≤ t)
    (cone : R ≤ h*t) (disk : R ≤ 1+t)
    (headroom : (1+d)*h ≤ H) (change : d*h ≤ r-1) :
    (1+d)*R ≤ H*t ∧ (1+d)*R ≤ 1+r*t := by
  constructor
  · nlinarith only [mul_le_mul_of_nonneg_left cone (show 0 ≤ 1+d by linarith),
      mul_le_mul_of_nonneg_right headroom ht]
  · nlinarith only [disk, mul_le_mul_of_nonneg_left cone hd,
      mul_le_mul_of_nonneg_right change ht]

/-- One positive dyadic depth supplies all four cap implications, uniformly
    over the caller family and over every descendant. -/
theorem finite_precision {D H h r : ℝ} (hD : 0 < D) (hh : 0 < h)
    (hH : h < H) (hr : 1 < r) :
    ∃ m : ℕ, 0 < m ∧
      let d := (1/4 : ℝ)^m * (D/2)
      d ≤ r-1 ∧ d*H ≤ r*(r-1) ∧ (1+d)*h ≤ H ∧ d*h ≤ r-1 := by
  have posH := hh.trans hH
  have gap : 0 < r-1 := sub_pos.mpr hr
  have gapH : 0 < H-h := sub_pos.mpr hH
  let a := r*(r-1)/H
  let b := (H-h)/h
  let c := (r-1)/h
  let eps := min (min (r-1) a) (min b c)
  have pos : 0 < eps := by dsimp [eps,a,b,c]; positivity
  have posD : 0 < D/2 := by positivity
  obtain ⟨n,hn⟩ : ∃ n : ℕ, (1/4 : ℝ)^n < eps/(D/2) :=
    exists_pow_lt_of_lt_one (div_pos pos posD) (by norm_num)
  let d := (1/4 : ℝ)^(n+1)*(D/2)
  have small : d ≤ eps := by
    have step : (1/4 : ℝ)^(n+1) ≤ (1/4 : ℝ)^n := by
      rw [pow_succ]
      exact mul_le_of_le_one_right (by positivity) (by norm_num)
    exact (mul_le_mul_of_nonneg_right step posD.le).trans ((lt_div_iff₀ posD).mp hn).le
  have first : d ≤ min (r-1) a := small.trans (min_le_left _ _)
  have second : d ≤ min b c := small.trans (min_le_right _ _)
  refine ⟨n+1, Nat.succ_pos _, first.trans (min_le_left _ _), ?_, ?_, ?_⟩
  · exact (le_div_iff₀ posH).mp (first.trans (min_le_right _ _))
  · have eqn : d*h ≤ H-h := (le_div_iff₀ hh).mp (second.trans (min_le_left _ _))
    change (1+d)*h ≤ H
    linarith
  · exact (le_div_iff₀ hh).mp (second.trans (min_le_right _ _))

def follow {ι α : Type*} (field : ι → α → α) : List ι → α → α
  | [], p => p
  | e :: w, p => follow field w (field e p)

/-- The radius need only pay for guards at the new frontier. Every
    shorter obligation of a child is already in the parent's prefix. -/
theorem child_prefix {ι α : Type*} (field : ι → α → α) (guard : α → Prop)
    (N : ℕ) (p : α)
    (earlier : ∀ w : List ι, w.length < N → guard (follow field w p))
    (frontier : ∀ w : List ι, w.length = N → guard (follow field w p))
    (e : ι) (w : List ι) (hw : w.length < N) :
    guard (follow field w (field e p)) := by
  change guard (follow field (e :: w) p)
  by_cases inside : (e :: w).length < N
  · exact earlier _ inside
  · apply frontier
    simp only [List.length_cons] at inside ⊢
    omega

end FoldedCycle
