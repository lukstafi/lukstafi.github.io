/- Lean 4.19.0, mathlib v4.19.0. Build instructions in round-16-fixed-flat.md. -/
import «round-15-proof»

namespace FlatJCA.FixedFlat
open Scope

/-- All slot comparisons in one field have the very same witness. -/
structure Batch (n q : Nat) (xs ps : Nat → Pat) (u v r : Pat) : Prop where
  comparison : ∃ e, EqualAt u v e
  bindings : ∀ e, EqualAt u v e → (∀ i < n, (ps i).bind e = .a) ∧ r.bind e = .b
  flip : ∃ e : Env, (∀ i < n, (ps i).bind e = .b) ∧ r.bind e = .a
  left : ∃ e : Env, ∀ i < n, EqualAt (ps i) u e
  expose : ∃ e : Env, (∀ i < n, EqualAt (ps i) (xs i) e) ∧ e q = v.bind e

theorem batch_excludes {n q xs ps u v r} (h : Batch n q xs ps u v r) :
    ∀ i < n, ¬ (xs i).uses q := by
  intro i hi
  obtain ⟨ef, hf, hr⟩ := h.flip
  obtain ⟨el, hl⟩ := h.left
  obtain ⟨ex, hx, hq⟩ := h.expose
  apply exclusion q (xs i) u v (ps i) r
  exact ⟨h.comparison, fun e eq => ⟨(h.bindings e eq).1 i hi, (h.bindings e eq).2⟩,
    ⟨ef, hf i hi, hr⟩, ⟨el, hl i hi⟩, ⟨ex, hx i hi, hq⟩⟩

def pack (vs : Nat → T α) (tail : T α) : Nat → T α
  | 0 => tail
  | n + 1 => .fork (vs n) (pack vs tail n)

theorem bind_pack (vs : Nat → T α) (tail : T α) (e : α → T β) (n : Nat) :
    (pack vs tail n).bind e = pack (fun i => (vs i).bind e) (tail.bind e) n := by
  induction n with
  | zero => rfl
  | succ n ih => exact congrArg (T.fork ((vs n).bind e)) ih

theorem pack_inj (xs ys : Nat → T α) (x y : T α) (n : Nat) :
    pack xs x n = pack ys y n ↔ (∀ i < n, xs i = ys i) ∧ x = y := by
  induction n with
  | zero => simp [pack]
  | succ n ih =>
    simp only [pack, T.fork.injEq, ih]
    constructor
    · rintro ⟨last, before, tail⟩
      exact ⟨fun i hi => if eq : i = n then eq ▸ last else before i (by omega), tail⟩
    · rintro ⟨all, tail⟩
      exact ⟨all n (by omega), fun i hi => all i (by omega), tail⟩

theorem bind_local (x : Pat) (e d : Env) (agree : ∀ k, x.uses k → e k = d k) :
    x.bind e = x.bind d := by
  induction x with
  | a | b => rfl
  | var k => exact agree k rfl
  | fork l r hl hr =>
    exact congrArg₂ T.fork (hl (fun k hk => agree k (Or.inl hk)))
      (hr (fun k hk => agree k (Or.inr hk)))

theorem batch_iff (n q : Nat) (xs : Nat → Pat) :
    (∃ ps u v r, Batch n q xs ps u v r) ↔ ∀ i < n, ¬ (xs i).uses q := by
  constructor
  · rintro ⟨ps,u,v,r,h⟩; exact batch_excludes h
  intro absent
  obtain ⟨c, qc, fresh⟩ : ∃ c, q < c ∧ ∀ i < n, ceiling (xs i) < c := by
    induction n with
    | zero => exact ⟨q+1, by omega, by simp⟩
    | succ k ih =>
      obtain ⟨d, qd, h⟩ := ih (fun i hi => absent i (by omega))
      refine ⟨max d (ceiling (xs k) + 1), by omega, ?_⟩
      intro i hi
      by_cases eq : i=k
      · subst i; omega
      · have := h i (by omega); omega
  let ps (i : Nat) : Pat := .var (c+i)
  let r : Pat := .var (c+n)
  let u : Pat := pack (fun _ => .a) .b n
  let v := pack ps r n
  have character (e : Env) : EqualAt u v e ↔ (∀ i < n, e (c+i) = .a) ∧ e (c+n) = .b := by
    unfold EqualAt u v
    rw [bind_pack, bind_pack, pack_inj]
    simp only [T.bind, ps, r, eq_comm]
  let d : Env := fun _ => .a
  let values (i : Nat) := (xs i).bind d
  let expose : Env := fun k => if k = q then pack values .a n
    else if c ≤ k ∧ k < c+n then values (k-c) else .a
  have slot (i : Nat) (hi : i<n) : expose (c+i) = values i := by
    simp [expose, show c+i ≠ q by omega, show c+i < c+n by omega]
  have tail : expose (c+n) = .a := by simp [expose, show c+n ≠ q by omega]
  have stable (i : Nat) (hi : i<n) : (xs i).bind expose = values i := by
    apply bind_local
    intro k hk
    have kq : k ≠ q := fun eq => absent i hi (eq ▸ hk)
    have cap := (below_ceiling _ k hk).trans_lt (fresh i hi)
    simp [expose, d, kq, Nat.not_le_of_lt cap]
  refine ⟨ps,u,v,r, ?_⟩
  constructor
  · refine ⟨changeAt d (c+n) .b, (character _).mpr ⟨?_, by simp [changeAt]⟩⟩
    intro i hi; simp [changeAt, d, Nat.ne_of_lt hi]
  · exact fun e he => (character e).mp he
  · refine ⟨changeAt (fun _ => .b) (c+n) .a, ?_, by simp [r,T.bind,changeAt]⟩
    intro i hi; simp [ps, T.bind, changeAt, Nat.ne_of_lt hi]
  · let target : Ground := pack (fun _ => .a) .b n
    refine ⟨fun _ => target, fun i _ => ?_⟩
    change target = (pack (fun _ => .a) .b n : Pat).bind (fun _ => target)
    rw [bind_pack]
    rfl
  · refine ⟨expose, fun i hi => (slot i hi).trans (stable i hi).symm, ?_⟩
    change expose q = (pack ps r n).bind expose
    rw [bind_pack]
    change expose q = pack (fun i => expose (c+i)) (expose (c+n)) n
    rw [tail]
    simp only [expose, if_pos rfl] at ⊢
    apply (pack_inj _ _ _ _ _).mpr
    exact ⟨fun i hi => (slot i hi).symm, rfl⟩

/-- A row evaluates all coordinates with only the two marker values varying. -/
def active (i : Nat) (x y : α) := if i % 2 = 0 then x else y

theorem audit (T : Nat → α → α → α) (S : α → α) (n : Nat)
    (start : ∀ x y, T 0 x y = x)
    (scope : ∀ i ≤ n, ∀ x y, T i x y = T i (active i x y) (active i x y))
    (left : ∀ i < n, i % 2 = 0 → ∀ z, T i (S z) z = T (i+1) (S z) z)
    (right : ∀ i < n, i % 2 = 1 → ∀ z, T i z (S z) = T (i+1) z (S z)) :
    ∀ i ≤ n, ∀ x y, T i x y = S^[i] (active i x y) := by
  intro i
  induction i with
  | zero => intro _ x y; exact start x y
  | succ i ih =>
    intro hi x y
    have ii : i < n := by omega
    rw [scope _ hi x y]
    by_cases parity : i % 2 = 0
    · have next : (i+1) % 2 ≠ 0 := by omega
      simp only [active, if_neg next]
      have back := scope (i+1) hi (S y) y
      simp only [active, if_neg next] at back
      rw [← back, ← left i ii parity, ih (by omega)]
      simp only [active, parity, if_true, if_false]
      rfl
    · have next : (i+1) % 2 = 0 := by omega
      simp only [active, if_pos next]
      have back := scope (i+1) hi x (S x)
      simp only [active, if_pos next] at back
      rw [← back, ← right i ii (by omega), ih (by omega)]
      simp only [active, parity, if_true, if_false]
      rfl

#print axioms batch_iff
#print axioms audit
end FlatJCA.FixedFlat
