import Mathlib.Tactic.Linarith
import Mathlib.Algebra.Order.Field.Rat
import Mathlib.Algebra.Order.Archimedean.Basic
import Mathlib.Data.Rat.Cast.Order
import Mathlib.Tactic.Ring

namespace ConstructorObservations

section Templates
variable {X A : Type*}
variable (rule : (n : ℕ) → (Fin n → X) → X → Prop) (holds : A → X → Prop)

/-- A proposal is justified at one constructor layer by previously certified child facts. -/
def Check (S : A → Prop) (a : A) :=
  ∀ n children x, rule n children x → (∀ i b, S b → holds b (children i)) → holds a x

def Stage (pool : A → Prop) : ℕ → A → Prop
  | 0, _ => False
  | k+1, a => Stage pool k a ∨ (pool a ∧ Check rule holds (Stage pool k) a)

/-- Each value in H can expose one constructor. Its children can include the value itself. -/
theorem stage_sound (pool : A → Prop) (H : X → Prop)
    (expose : ∀ x, H x → ∃ n children, rule n children x ∧ ∀ i, H (children i)) :
    ∀ k a x, Stage rule holds pool k a → H x → holds a x := by
  intro k
  induction k with
  | zero => intro a x h; exact False.elim h
  | succ k ih =>
    intro a x cert hx
    obtain ⟨n,children,ok,hc⟩ := expose x hx
    rcases cert with old | ⟨_,step⟩
    · exact ih a x old hx
    · exact step n children x ok (fun i b hb => ih b (children i) hb (hc i))

/-- Starting from no facts computes the least set closed under finite certificates. -/
theorem stage_least (pool closed : A → Prop)
    (intro_rule : ∀ a, pool a → Check rule holds closed a → closed a) :
    ∀ k a, Stage rule holds pool k a → closed a := by
  intro k
  induction k with
  | zero => intro a h; exact False.elim h
  | succ k ih =>
    intro a cert
    rcases cert with h | ⟨candidate,step⟩
    · exact ih a h
    · apply intro_rule a candidate
      intro n children x ok hc
      exact step n children x ok (fun i b hb => hc i b (ih b hb))

end Templates

inductive FiniteTower : ℚ → Prop
  | floor : FiniteTower 0
  | step {q} : FiniteTower q → FiniteTower (q+1)

theorem finite_nonnegative {q} (h : FiniteTower q) : 0 ≤ q := by
  induction h with
  | floor => exact le_rfl
  | step _ ih => linarith

/-- All rational indices form a consistent typing of the single Step self-loop. -/
theorem spiral_all (q : ℚ) : ∃ child : ℚ, q = child+1 ∧ (fun _ : ℚ => True) child := by
  exact ⟨q-1, by linarith, trivial⟩

section Graph
variable {N X : Type*}
variable (edge : N → X → N → X → Prop) (guard : N → X → Prop)

inductive Walk : N → X → N → X → Prop
  | nil (v x) : Walk v x v x
  | cons {v x u y w z} : edge v x u y → Walk u y w z → Walk v x w z

def Safe (v : N) (x : X) := ∀ u y, Walk edge v x u y → guard u y

theorem safe_unfold (v x) : Safe edge guard v x ↔
    guard v x ∧ ∀ u y, edge v x u y → Safe edge guard u y := by
  constructor
  · intro allPaths
    exact ⟨allPaths v x (.nil v x), fun _ _ e w z p => allPaths w z (.cons e p)⟩
  · rintro ⟨hg,children⟩ u y path
    cases path with
    | nil => exact hg
    | cons e tail => exact children _ _ e _ _ tail

theorem greatest_safe (P : N → X → Prop)
    (head : ∀ v x, P v x → guard v x)
    (tail : ∀ v x u y, P v x → edge v x u y → P u y) :
    ∀ v x, P v x → Safe edge guard v x := by
  intro v x hv u y path
  induction path with
  | nil => exact head _ _ hv
  | cons e _ ih => exact ih (tail _ _ _ _ hv e)

end Graph

def grow : ℕ → ℚ → ℚ
  | 0, q => q
  | n+1, q => 2 * grow n q + 1

theorem grow_formula (n : ℕ) (q : ℚ) : grow n q = 2^n * (q+1)-1 := by
  induction n with
  | zero => simp [grow]
  | succ n ih => rw [grow, ih, pow_succ]; ring

theorem grow_kernel (q : ℚ) : (∀ n, grow n q ≤ 0) ↔ q ≤ -1 := by
  constructor
  · intro allSteps
    by_contra! h
    have pos : 0 < q+1 := by linarith
    obtain ⟨n,hn⟩ := pow_unbounded_of_one_lt (1/(q+1)) (by decide : (1:ℚ) < 2)
    have gt := (div_lt_iff₀ pos).mp hn
    have obs := allSteps n
    rw [grow_formula] at obs
    linarith
  · intro h n
    rw [grow_formula]
    have prod := mul_nonpos_of_nonneg_of_nonpos (pow_nonneg (by decide : (0:ℚ) ≤ 2) n)
        (by linarith : q+1 ≤ 0)
    linarith

abbrev Point := ℚ × ℚ

def turn (p : Point) : Point := ((3*p.1-4*p.2)/5, (4*p.1+3*p.2)/5)
def radiusSq (p : Point) := p.1^2+p.2^2

theorem rotation_preserves_radius (p : Point) : radiusSq (turn p) = radiusSq p := by
  simp only [radiusSq, turn]
  ring

theorem disk_passes (p : Point) (inside : radiusSq p ≤ 1) (k : ℕ) : ((turn^[k]) p).1 ≤ 1 := by
  have stable : radiusSq ((turn^[k]) p) = radiusSq p := by
    induction k with
    | zero => rfl
    | succ k ih => rw [Function.iterate_succ_apply', rotation_preserves_radius, ih]
  have radius : radiusSq ((turn^[k]) p) ≤ 1 := stable.trans_le inside
  generalize (turn^[k]) p = q at radius ⊢
  unfold radiusSq at radius
  nlinarith [sq_nonneg q.2, sq_nonneg (q.1-1)]

def scaled : ℕ → ℤ × ℤ
  | 0 => (1,0)
  | n+1 => let p := scaled n; (3*p.1-4*p.2,4*p.1+3*p.2)

theorem scaled_residues (n : ℕ) :
    (scaled (n+1)).1 % 5 = 3 ∧ (scaled (n+1)).2 % 5 = 4 := by
  induction n with
  | zero => decide
  | succ n ih =>
    change (3*(scaled (n+1)).1 - 4*(scaled (n+1)).2) % 5 = 3 ∧
      (4*(scaled (n+1)).1 + 3*(scaled (n+1)).2) % 5 = 4
    omega

theorem scaled_turn (n : ℕ) : (turn^[n]) (1,0) =
    (((scaled n).1 : ℚ)/5^n, ((scaled n).2 : ℚ)/5^n) := by
  induction n with
  | zero => norm_num [scaled]
  | succ n ih =>
    rw [Function.iterate_succ_apply', ih]
    ext <;> simp [turn, scaled, pow_succ] <;> ring

theorem no_positive_period (n : ℕ) : (turn^[n+1]) (1,0) ≠ (1,0) := by
  intro h
  rw [scaled_turn] at h
  have hy := congrArg Prod.snd h
  change ((scaled (n+1)).2 : ℚ)/5^(n+1) = 0 at hy
  have zero : (scaled (n+1)).2 = 0 := by
    have hq : ((scaled (n+1)).2 : ℚ) = 0 :=
      (div_eq_zero_iff.mp hy).resolve_right (by positivity)
    exact_mod_cast hq
  have residue := (scaled_residues n).2
  omega

theorem rotation_delayed_failure :
    (∀ k : Fin 20, ((turn^[k.val]) (1,1/5)).1 ≤ 1) ∧
    1 < ((turn^[20]) (1,1/5)).1 := by native_decide

end ConstructorObservations
