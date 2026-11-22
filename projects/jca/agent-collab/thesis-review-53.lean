import Lean.Elab.Tactic.Omega
import Mathlib.Data.Nat.Basic

namespace UnaryCaller

inductive Guard where
  | empty
  | point (k : Nat)
  | tail (k : Nat)
  | neg (g : Guard)
  | either (g h : Guard)

def Holds : Guard → Nat → Prop
  | .empty, _ => False
  | .point k, n => n = k
  | .tail k, n => k ≤ n
  | .neg g, n => ¬ Holds g n
  | .either g h, n => Holds g n ∨ Holds h n

def bound : Guard → Nat
  | .empty => 0
  | .point k => k+1
  | .tail k => k
  | .neg g => bound g
  | .either g h => max (bound g) (bound h)

theorem stable (g : Guard) (n m : Nat) (hn : bound g ≤ n) (hm : bound g ≤ m) :
    Holds g n ↔ Holds g m := by
  induction g with
  | empty => rfl
  | point k => simp [bound] at hn hm; simp [Holds]; omega
  | tail k => simp [bound] at hn hm; simp [Holds, hn, hm]
  | neg g ih => exact not_congr (ih hn hm)
  | either g h ig ih =>
    exact or_congr (ig (le_trans (le_max_left _ _) hn) (le_trans (le_max_left _ _) hm))
      (ih (le_trans (le_max_right _ _) hn) (le_trans (le_max_right _ _) hm))

def initialPoints (P : Nat → Prop) [DecidablePred P] : Nat → Guard
  | 0 => .empty
  | k+1 => .either (initialPoints P k) (if P k then .point k else .empty)

theorem prefix_spec (P : Nat → Prop) [DecidablePred P] (k n : Nat) :
    Holds (initialPoints P k) n ↔ n < k ∧ P n := by
  induction k with
  | zero => simp [initialPoints, Holds]
  | succ k ih =>
    simp only [initialPoints, Holds, ih]
    by_cases eq : n = k
    · subst n
      by_cases h : P k <;> simp [h, Holds]
    · have lt : n < k+1 ↔ n < k := by omega
      by_cases h : P k <;> simp [h, Holds, eq, lt]

theorem expressible (P : Nat → Prop) :
    (∃ g, ∀ n, Holds g n ↔ P n) ↔ (∃ k, ∀ n, k ≤ n → (P n ↔ P k)) := by
  classical
  constructor
  · rintro ⟨g, hg⟩
    exact ⟨bound g, fun n hn => (hg n).symm.trans ((stable g n _ hn le_rfl).trans (hg _))⟩
  · rintro ⟨k, hk⟩
    refine ⟨.either (initialPoints P k) (if P k then .tail k else .empty), ?_⟩
    intro n
    simp only [Holds, prefix_spec]
    by_cases hn : k ≤ n
    · have h := hk n hn
      by_cases hp : P k <;> simp [hp, Holds, hn, Nat.not_lt_of_ge hn, h]
    · simp [Nat.lt_of_not_ge hn]
      split <;> simp [Holds, hn]

theorem even_inexpressible : ¬ ∃ g, ∀ n, Holds g n ↔ n % 2 = 0 := by
  rintro ⟨g, hg⟩
  let b := bound g
  have h := (hg (2*b)).symm.trans
    ((stable g (2*b) (2*b+1) (by dsimp [b]; omega) (by dsimp [b]; omega)).trans (hg (2*b+1)))
  omega

/-- Start by permitting every depth. Each recheck rejects one more odd depth. -/
def step (D : Nat → Prop) : Nat → Prop
  | 0 => True
  | 1 => False
  | n+2 => D n

def stages : Nat → Nat → Prop
  | 0 => fun _ => True
  | t+1 => step (stages t)

theorem stage_spec (t n : Nat) : stages t n ↔ n % 2 = 0 ∨ 2*t ≤ n := by
  induction t generalizing n with
  | zero => simp [stages]
  | succ t ih =>
    cases n with
    | zero => simp [stages, step]
    | succ n =>
      cases n with
      | zero => simp [stages, step]; omega
      | succ n => simp only [stages, step, ih]; omega

theorem strict_stage (t : Nat) : stages t (2*t+1) ∧ ¬ stages (t+1) (2*t+1) := by
  simp only [stage_spec]
  omega

theorem limit (n : Nat) : (∀ t, stages t n) ↔ n % 2 = 0 := by
  refine ⟨fun h => ?_, fun h t => (stage_spec t n).mpr (Or.inl h)⟩
  have := (stage_spec (n+1) n).mp (h (n+1))
  omega

/-- Every safe inductive domain contains the recursive predecessors of its calls. -/
theorem predecessors {D : Nat → Prop} (safe : ∀ n, D n → step D n) (m : Nat)
    (top : D (2*m)) : ∀ k ≤ m, D (2*k) := by
  induction m with
  | zero =>
    intro k hk
    have : k = 0 := by omega
    simpa [this] using top
  | succ m ih =>
    have prev : D (2*m) := by
      have h := safe (2*(m+1)) top
      rw [show 2*(m+1) = 2*m+2 by omega] at h
      exact h
    intro k hk
    by_cases eq : k = m+1
    · simpa [eq] using top
    · exact ih prev k (by omega)

theorem inductive_even {D : Nat → Prop} (safe : ∀ n, D n → step D n) :
    ∀ n, D n → n % 2 = 0 := by
  intro n
  induction n using Nat.strong_induction_on with
  | h n ih =>
    intro hn
    cases n with
    | zero => decide
    | succ n =>
      cases n with
      | zero => exact False.elim (safe 1 hn)
      | succ n =>
        have h := ih n (by omega) (safe (n+2) hn)
        omega

theorem initial_evens_inductive (m : Nat) (n : Nat) :
    (n % 2 = 0 ∧ n ≤ 2*m) → step (fun k => k % 2 = 0 ∧ k ≤ 2*m) n := by
  cases n with
  | zero => simp [step]
  | succ n =>
    cases n with
    | zero => simp [step]
    | succ n => simp only [step]; omega

/-- One cycle of a deterministic unary control orbit decides expressibility. -/
theorem cycle_criterion (P C : Nat → Prop) (start period : Nat) (pos : 0 < period)
    (cycle : ∀ t i, i < period → (P (start + t*period + i) ↔ C i)) :
    (∃ g, ∀ n, Holds g n ↔ P n) ↔ ∀ i, i < period → (C i ↔ C 0) := by
  rw [expressible]
  constructor
  · rintro ⟨k,h⟩ i hi
    have large : k ≤ k*period := Nat.le_mul_of_pos_right _ pos
    exact (cycle k i hi).symm.trans ((h _ (by omega)).trans
      ((h (start + k*period + 0) (by omega)).symm.trans (cycle k 0 pos)))
  · intro uniform
    refine ⟨start, fun n hn => ?_⟩
    let t := (n-start)/period
    let i := (n-start)%period
    have hi : i < period := Nat.mod_lt _ pos
    have sum : i + period*t = n-start := Nat.mod_add_div _ _
    have en : start + t*period + i = n := by rw [Nat.mul_comm t]; omega
    have base := cycle 0 0 pos
    simp only [Nat.zero_mul, Nat.add_zero] at base
    rw [← en]
    exact (cycle t i hi).trans ((uniform i hi).trans base.symm)

variable {Q : Type*}

def run (next : Q → Q) (q : Q) : Nat → Q
  | 0 => q
  | n+1 => run next (next q) n

inductive Evidence (next : Q → Q) (finish : Q → Prop) : Q → Nat → Prop where
  | stop {q} : finish q → Evidence next finish q 0
  | more {q n} : Evidence next finish (next q) n → Evidence next finish q (n+1)

theorem evidence_spec (next : Q → Q) (finish : Q → Prop) (q : Q) (n : Nat) :
    Evidence next finish q n ↔ finish (run next q n) := by
  induction n generalizing q with
  | zero =>
    constructor
    · intro e; cases e with | stop h => exact h
    · exact Evidence.stop
  | succ n ih =>
    constructor
    · intro e; cases e with | more h => exact (ih _).mp h
    · intro h; exact Evidence.more ((ih _).mpr h)

end UnaryCaller
