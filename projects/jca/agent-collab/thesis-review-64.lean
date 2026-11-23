import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Algebra.Order.Field.Basic
import Mathlib.Data.Rat.Cast.Order
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

namespace LiteralUnfolding

open Finset

/-- A positive dependence among evaluated guard normals supplies the sign
    in finitely many raw rows. The chosen words may have different gains. -/
theorem derive_sign {ι : Type*} [Fintype ι] (w lhs c r : ι → ℚ) (t : ℚ)
    (weights : ∀ i, 0 ≤ w i) (rows : ∀ i, lhs i ≤ c i + r i*t)
    (cancel : ∑ i, w i*lhs i = 0) (offset : ∑ i, w i*c i ≤ 0)
    (gain : 0 < ∑ i, w i*r i) : 0 ≤ t := by
  have bound : 0 ≤ (∑ i, w i*c i) + (∑ i, w i*r i)*t := calc
    0 = ∑ i, w i*lhs i := cancel.symm
    _ ≤ ∑ i, w i*(c i+r i*t) :=
      sum_le_sum (fun i _ => mul_le_mul_of_nonneg_left (rows i) (weights i))
    _ = _ := by simp only [mul_add, ← mul_assoc, sum_add_distrib, sum_mul]
  by_cases ht : 0 ≤ t
  · exact ht
  · linarith only [bound, offset, mul_neg_of_pos_of_neg gain (lt_of_not_ge ht)]

/-- No finite prefix of the written guard at x=0 derives nonnegative slack.
    The very next guard excludes the point exhibited for that prefix. -/
theorem no_finite_prefix (N : ℕ) :
    ∃ t : ℚ, t < 0 ∧ (∀ k ≤ N, 0 ≤ 1 + 2^k*t) ∧ 1 + 2^(N+1)*t < 0 := by
  have pos : 0 < (2:ℚ)^N := by positivity
  refine ⟨-(1 / (2:ℚ)^N), neg_lt_zero.mpr (one_div_pos.mpr pos), ?_, ?_⟩
  · intro k hk
    have h := pow_le_pow_right₀ (by norm_num : 1 ≤ (2:ℚ)) hk
    have hd : (2:ℚ)^k/(2:ℚ)^N ≤ 1 := (div_le_one₀ pos).mpr h
    rw [show 1 + (2:ℚ)^k * -(1 / (2:ℚ)^N) = 1 - (2:ℚ)^k/(2:ℚ)^N by ring]
    linarith only [hd]
  · have step : (2:ℚ)^(N+1) * (1 / (2:ℚ)^N) = 2 := by
      rw [pow_succ]
      field_simp
    rw [mul_neg, step]
    norm_num

end LiteralUnfolding
