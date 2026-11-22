import Mathlib.Algebra.Order.Archimedean.Basic
import Mathlib.Data.Rat.Floor
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum

/-! Exact recomputation of the unary admission predicate at a fixed package.
The greatest sound policy is reached at omega plus one. -/
namespace Recheck

inductive Key where
  | anchor | star | ordinary (k : ℚ)
inductive Result where
  | num (r : ℚ) | trigger | stop

def upper : Key → Prop
  | .ordinary k => 0 ≤ k
  | _ => True

def package : Key → Result → Prop
  | .ordinary k, .num r => r+1 ≤ k ∨ k+1 ≤ r
  | .ordinary _, .trigger => False
  | .star, .stop => False
  | _, _ => True

def opens (A : Key → Prop) (r : Result) := ∀ k, A k → package k r

/-- Keep exactly the keys at which the base and both successor clauses hold,
given A as the domain for recursive calls. -/
def update (A : Key → Prop) (k : Key) :=
  upper k ∧ package k (.num 0) ∧
  (∀ r : ℚ, 0 ≤ r → opens A (.num r) → package k (.num (r+1))) ∧
  (opens A .trigger → package k .stop)

def finite (n : ℕ) : Key → Prop
  | .ordinary k => (n : ℚ) ≤ k
  | _ => True

def firstLimit : Key → Prop
  | .ordinary _ => False
  | _ => True

def last : Key → Prop
  | .anchor => True
  | _ => False

theorem start (k : Key) : upper k ↔ finite 0 k := by cases k <;> simp [upper, finite]

theorem mono {A B : Key → Prop} (sub : ∀ k, A k → B k) (k : Key) :
    update A k → update B k := by
  rintro ⟨legal, base, step, edge⟩
  exact ⟨legal, base, fun r pos hr => step r pos (fun j hj => hr j (sub j hj)),
    fun hr => edge (fun j hj => hr j (sub j hj))⟩

theorem finite_numeric (n : ℕ) (r : ℚ) : opens (finite n) (.num r) ↔ r+1 ≤ n := by
  constructor
  · intro h
    by_cases hr : (n : ℚ) ≤ r
    · have atSelf := h (.ordinary r) hr
      change r+1 ≤ r ∨ r+1 ≤ r at atSelf
      rcases atSelf with h | h <;> linarith
    · have atEdge := h (.ordinary n) le_rfl
      change r+1 ≤ n ∨ (n : ℚ)+1 ≤ r at atEdge
      rcases atEdge with h | h <;> linarith
  · rintro h (_ | _ | j) hj
    · trivial
    · trivial
    · exact Or.inl (h.trans hj)

theorem finite_step (n : ℕ) (key : Key) : update (finite n) key ↔ finite (n+1) key := by
  have blocked (h : opens (finite n) .trigger) : False := h (.ordinary n) le_rfl
  cases key with
  | anchor => simp [update, upper, package, finite]
  | star => simpa [update, upper, package, finite] using blocked
  | ordinary k =>
    change _ ↔ ((n+1 : ℕ) : ℚ) ≤ k
    push_cast
    constructor
    · rintro ⟨legal, base, step, _⟩
      change 0 ≤ k at legal
      change 0+1 ≤ k ∨ k+1 ≤ 0 at base
      have one : 1 ≤ k := by rcases base with h | h <;> linarith
      cases n with
      | zero => simpa using one
      | succ m =>
        push_cast at *
        by_cases hk : k ≤ (m : ℚ)+1
        · have atSelf := step (k-1) (by linarith)
            ((finite_numeric _ _).mpr (by push_cast; linarith))
          change (k-1+1)+1 ≤ k ∨ k+1 ≤ (k-1+1) at atSelf
          rcases atSelf with h | h <;> linarith
        · have atEdge := step m (by positivity) ((finite_numeric _ _).mpr (by simp))
          change ((m : ℚ)+1)+1 ≤ k ∨ k+1 ≤ (m : ℚ)+1 at atEdge
          rcases atEdge with h | h <;> linarith
    · intro h
      have hn : (0 : ℚ) ≤ n := by positivity
      refine ⟨by change 0 ≤ k; linarith, Or.inl (by linarith), ?_, fun ht => (blocked ht).elim⟩
      intro r _ hr
      have low := (finite_numeric n r).mp hr
      exact Or.inl (by linarith)

theorem finite_strict (n : ℕ) :
    finite n (.ordinary n) ∧ ¬ finite (n+1) (.ordinary n) := by
  simp [finite]

theorem limit_is_intersection (k : Key) : firstLimit k ↔ ∀ n, finite n k := by
  cases k with
  | anchor => simp [firstLimit,finite]
  | star => simp [firstLimit,finite]
  | ordinary k =>
    simp only [firstLimit,finite, false_iff, not_forall]
    obtain ⟨n, h⟩ := exists_nat_gt k
    exact ⟨n,not_le_of_gt h⟩

theorem no_ordinary_step {A : Key → Prop} (without : ∀ k, ¬ A (.ordinary k)) (key : Key) :
    update A key ↔ last key := by
  have number (r : ℚ) : opens A (.num r) := by
    rintro (_ | _ | k) h
    · trivial
    · trivial
    · exact (without k h).elim
  have trigger : opens A .trigger := by
    rintro (_ | _ | k) h
    · trivial
    · trivial
    · exact (without k h).elim
  cases key with
  | anchor => simp [update,upper,package,last]
  | star => simp [update,upper,package,last,trigger]
  | ordinary k =>
    change _ ↔ False
    rw [iff_false]
    rintro ⟨legal, base, step, _⟩
    change 0 ≤ k at legal
    change 0+1 ≤ k ∨ k+1 ≤ 0 at base
    have one : 1 ≤ k := by rcases base with h | h <;> linarith
    have atSelf := step (k-1) (by linarith) (number _)
    change (k-1+1)+1 ≤ k ∨ k+1 ≤ k-1+1 at atSelf
    rcases atSelf with h | h <;> linarith

theorem limit_step (k : Key) : update firstLimit k ↔ last k :=
  no_ordinary_step (fun _ h => h) k

theorem fixed (k : Key) : update last k ↔ last k :=
  no_ordinary_step (fun _ h => h) k

theorem limit_strict : firstLimit .star ∧ ¬ last .star := ⟨trivial, id⟩

/-- A direct certificate for dropping the entire ordinary tail at once. -/
theorem numeric_orbit {A : Key → Prop} (sound : ∀ k, A k → update A k) (n : ℕ) :
    opens A (.num n) := by
  induction n with
  | zero => exact fun k hk => (sound k hk).2.1
  | succ n ih =>
    intro k hk
    simpa using (sound k hk).2.2.1 n (by positivity) ih

theorem ordinary_impossible {A : Key → Prop} (sound : ∀ k, A k → update A k) (k : ℚ) :
    ¬ A (.ordinary k) := by
  intro hk
  have nonneg : 0 ≤ k := (sound _ hk).1
  have near := numeric_orbit sound ⌊k⌋₊ (.ordinary k) hk
  change (⌊k⌋₊ : ℚ)+1 ≤ k ∨ k+1 ≤ (⌊k⌋₊ : ℚ) at near
  have low := Nat.floor_le nonneg
  have high := Nat.lt_floor_add_one k
  rcases near with h | h <;> linarith

theorem greatest {A : Key → Prop} (sound : ∀ k, A k → update A k) (k : Key) (hk : A k) :
    last k := by
  have below (n : ℕ) : ∀ j, A j → finite n j := by
    induction n with
    | zero => exact fun j hj => (start j).mp (sound j hj).1
    | succ n ih => exact fun j hj => (finite_step n j).mp (mono ih j (sound j hj))
  have atLimit j (hj : A j) := (limit_is_intersection j).mpr (fun n => below n j hj)
  exact (limit_step k).mp (mono atLimit k (sound k hk))

end Recheck
