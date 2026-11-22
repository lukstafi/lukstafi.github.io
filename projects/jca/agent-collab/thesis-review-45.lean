import Mathlib.Data.Finset.Insert
import Mathlib.Data.Finset.Image
import Mathlib.Data.Rat.Floor
import Mathlib.Data.Fintype.Basic
import Mathlib.Topology.Compactness.Compact
import Mathlib.Algebra.Order.Archimedean.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

namespace Admission

variable {X K V : Type*}
abbrev Policy (X K : Type*) := X → K → Prop
abbrev Package (K V : Type*) := K → V → Prop

def Sub {α β : Type*} (A B : α → β → Prop) := ∀ x k, A x k → B x k
def Between (lo A hi : Policy X K) := Sub lo A ∧ Sub A hi
def Join (A B : Policy X K) : Policy X K := fun x k => A x k ∨ B x k

/-- Positive admission tests can be added together, even when they refer to
the same runtime input. The remaining failure condition must survive shrinking. -/
theorem least_completion {lo hi pins : Policy X K} {bad : Policy X K → Prop}
    (nested : Sub lo hi) (down : ∀ {A B}, Sub A B → bad B → bad A) :
    (∃ A, Between lo A hi ∧ Sub pins A ∧ bad A) ↔ Sub pins hi ∧ bad (Join lo pins) := by
  constructor
  · rintro ⟨A, ⟨lower, upper⟩, keep, fail⟩
    exact ⟨fun x k h => upper x k (keep x k h),
      down (fun x k h => h.elim (lower x k) (keep x k)) fail⟩
  · rintro ⟨fits, fail⟩
    exact ⟨Join lo pins, ⟨fun _ _ => Or.inl, fun x k h => h.elim (nested x k) (fits x k)⟩,
      fun _ _ => Or.inr, fail⟩

def One (x : X) (k : K) : Policy X K := fun y j => y = x ∧ j = k

def Open (A : Policy X K) (P : Package K V) (x : X) (r : V) := ∀ k, A x k → P k r

def Body (A : Policy X K) (P : Package K V) (calls : List (X × V)) :=
  ∀ q ∈ calls, Open A P q.1 q.2

/-- A rule instance supplies r at x from a finite list of runtime calls.
All static side conditions and legal instantiations are part of rules. -/
abbrev Rules (X V : Type*) := X → V → List (X × V) → Prop

def Step (rules : Rules X V) (A : Policy X K) (P : Package K V) (k : K) (r : V) :=
  ∃ x calls, rules x r calls ∧ A x k ∧ Body A P calls

def Robust (rules : Rules X V) (lo hi : Policy X K) (P : Package K V) (k : K) (r : V) :=
  ∃ A, Between lo A hi ∧ Step rules A P k r

theorem body_pin {lo : Policy X K} {P : Package K V} {x : X} {k : K} {calls} :
    Body (Join lo (One x k)) P calls ↔
      Body lo P calls ∧ ∀ q ∈ calls, q.1 = x → P k q.2 := by
  constructor
  · intro h
    exact ⟨fun q hq j hj => h q hq j (Or.inl hj),
      fun q hq eq => h q hq k (Or.inr ⟨eq,rfl⟩)⟩
  · rintro ⟨h, extra⟩ q hq j hj
    rcases hj with old | ⟨same, rfl⟩
    · exact h q hq j old
    · exact extra q hq same

theorem one_key_step {rules : Rules X V} {lo hi : Policy X K} (nested : Sub lo hi)
    {P : Package K V} {k : K} {r : V} :
    Robust rules lo hi P k r ↔ ∃ x calls, rules x r calls ∧ hi x k ∧
      Body (Join lo (One x k)) P calls := by
  constructor
  · rintro ⟨A, ⟨lower,upper⟩, x, calls, rule, chosen, opened⟩
    refine ⟨x, calls, rule, upper x k chosen, ?_⟩
    intro q hq j hj
    apply opened q hq j
    rcases hj with old | ⟨same, rfl⟩
    · exact lower _ _ old
    · simpa [same] using chosen
  · rintro ⟨x, calls, rule, chosen, opened⟩
    refine ⟨Join lo (One x k), ⟨fun _ _ => Or.inl, ?_⟩,
      x, calls, rule, Or.inr ⟨rfl, rfl⟩, opened⟩
    rintro y j (old | ⟨rfl,rfl⟩)
    · exact nested y j old
    · exact chosen

/-- When admission requirements are upward closed, retain all keys compatible
with the whole tuple of calls. This includes demands to admit some key in
each prescribed set, possibly without a common mandatory representative. -/
def Compatible (hi : Policy X K) (P : Package K V) (calls : List (X × V)) : Policy X K :=
  fun y j => hi y j ∧ ∀ q ∈ calls, q.1 = y → P j q.2

theorem greatest_completion {hi : Policy X K} {P : Package K V} {calls : List (X × V)}
    {need : Policy X K → Prop} (up : ∀ {A B}, Sub A B → need A → need B) :
    (∃ A, Sub A hi ∧ need A ∧ Body A P calls) ↔ need (Compatible hi P calls) := by
  constructor
  · rintro ⟨A, upper, demand, opens⟩
    apply up _ demand
    intro y j hj
    refine ⟨upper _ _ hj, ?_⟩
    intro q hq eq
    exact opens q hq j (eq.symm ▸ hj)
  · intro h
    exact ⟨Compatible hi P calls, fun _ _ h => h.1, h,
      fun q hq j hj => hj.2 q hq rfl⟩

/-- Rechecking all arrows against a fixed postcondition gives a monotone
operator in the recursive call domain. -/
def RecheckAt (rules : Rules X V) (hi : Policy X K) (P : Package K V) (A : Policy X K)
    (x : X) (k : K) := hi x k ∧ ∀ t calls, rules x t calls → Body A P calls → P k t

theorem admission_sound_iff {rules : Rules X V} {A hi : Policy X K} {P : Package K V}
    (upper : Sub A hi) : Sub A (RecheckAt rules hi P A) ↔ Sub (Step rules A P) P := by
  constructor
  · rintro correct k t ⟨x, calls, rule, chosen, body⟩
    exact (correct x k chosen).2 t calls rule body
  · intro correct x k chosen
    exact ⟨upper x k chosen, fun t calls rule body => correct k t ⟨x,calls,rule,chosen,body⟩⟩

theorem recheck_mono {rules : Rules X V} {A B hi : Policy X K} {P : Package K V}
    (sub : Sub A B) : Sub (RecheckAt rules hi P A) (RecheckAt rules hi P B) := by
  rintro x k ⟨upper,valid⟩
  exact ⟨upper, fun t calls rule body =>
    valid t calls rule (fun q hq j hj => body q hq j (sub q.1 j hj))⟩

theorem monotone_step {rules : Rules X V} {lo hi : Policy X K} {P Q : Package K V}
    (inc : Sub P Q) : Sub (Robust rules lo hi P) (Robust rules lo hi Q) := by
  rintro k r ⟨A, bounds, x, calls, rule, hk, opened⟩
  exact ⟨A, bounds, x, calls, rule, hk, fun q hq j hj => inc j q.2 (opened q hq j hj)⟩

private theorem synchronize {α : Type*} (s : Finset α) (test : α → ℕ → Prop)
    (inc : ∀ a n m, n ≤ m → test a n → test a m)
    (each : ∀ a ∈ s, ∃ n, test a n) : ∃ n, ∀ a ∈ s, test a n := by
  classical
  induction s using Finset.induction_on with
  | empty => exact ⟨0, by simp⟩
  | insert a s _ ih =>
    obtain ⟨i, old⟩ := ih (fun b hb => each b (Finset.mem_insert_of_mem hb))
    obtain ⟨j, added⟩ := each a (Finset.mem_insert_self a s)
    refine ⟨max i j, ?_⟩
    intro b hb
    rcases Finset.mem_insert.mp hb with rfl | mem
    · exact inc _ _ _ (le_max_right _ _) added
    · exact inc _ _ _ (le_max_left _ _) (old b mem)

def AtLimit (P : ℕ → Package K V) : Package K V := fun k r => ∃ n, P n k r

/-- Omega continuity only requires finite menus in the lower policy. -/
theorem robust_limit {rules : Rules X V} {lo hi : Policy X K} (nested : Sub lo hi)
    (core : X → Finset K) (describes : ∀ x k, k ∈ core x ↔ lo x k)
    (P : ℕ → Package K V) (inc : ∀ n m, n ≤ m → Sub (P n) (P m))
    (k : K) (r : V) :
    Robust rules lo hi (AtLimit P) k r ↔ ∃ n, Robust rules lo hi (P n) k r := by
  classical
  constructor
  · intro atLimit
    obtain ⟨x, calls, rule, hk, opened⟩ := (one_key_step nested).mp atLimit
    let menu := Join lo (One x k)
    let available (q : X × V) (n : ℕ) := Open menu (P n) q.1 q.2
    have grows q n m (hnm : n ≤ m) (h : available q n) : available q m :=
      fun j hj => inc n m hnm j q.2 (h j hj)
    have atCall (q : X × V) (hq : q ∈ calls) : ∃ n, available q n := by
      let keys := insert k (core q.1)
      have covers j (h : menu q.1 j) : j ∈ keys := by
        rcases h with hj | ⟨_, rfl⟩
        · exact Finset.mem_insert_of_mem ((describes _ _).mpr hj)
        · exact Finset.mem_insert_self ..
      obtain ⟨n, sync⟩ := synchronize keys (fun j n => menu q.1 j → P n j q.2)
        (fun j n m hnm h hj => inc n m hnm j q.2 (h hj)) (fun j _ => by
          by_cases hj : menu q.1 j
          · obtain ⟨n, hn⟩ := opened q hq j hj
            exact ⟨n, fun _ => hn⟩
          · exact ⟨0, fun h => (hj h).elim⟩)
      exact ⟨n, fun j hj => sync j (covers j hj) hj⟩
    obtain ⟨n, sync⟩ := synchronize calls.toFinset available grows
      (fun q hq => atCall q (List.mem_toFinset.mp hq))
    exact ⟨n, (one_key_step nested).mpr
      ⟨x, calls, rule, hk, fun q hq => sync q (List.mem_toFinset.mpr hq)⟩⟩
  · rintro ⟨n, step⟩
    exact monotone_step (P := P n) (Q := AtLimit P) (fun _ _ h => ⟨n,h⟩) k r step

def stage (rules : Rules X V) (lo hi : Policy X K) : ℕ → Package K V
  | 0 => fun _ _ => False
  | n+1 => Robust rules lo hi (stage rules lo hi n)

theorem least_at_omega {rules : Rules X V} {lo hi : Policy X K} (nested : Sub lo hi)
    (core : X → Finset K) (describes : ∀ x k, k ∈ core x ↔ lo x k) :
    let R := AtLimit (stage rules lo hi)
    (∀ k r, Robust rules lo hi R k r ↔ R k r) ∧
      (∀ Q, Sub (Robust rules lo hi Q) Q → Sub R Q) := by
  let s := stage rules lo hi
  have next n : Sub (s n) (s (n+1)) := by
    induction n with
    | zero => exact fun _ _ h => h.elim
    | succ n ih => exact monotone_step ih
  have inc i j (h : i ≤ j) : Sub (s i) (s j) := by
    induction h with
    | refl => exact fun _ _ h => h
    | step _ ih => exact fun k r h => next _ k r (ih k r h)
  constructor
  · intro k r
    constructor
    · intro step
      obtain ⟨n, hn⟩ := (robust_limit nested core describes s inc k r).mp step
      exact ⟨n+1, hn⟩
    · rintro ⟨n, hn⟩
      cases n with
      | zero => exact hn.elim
      | succ n => exact (robust_limit nested core describes s inc k r).mpr ⟨n,hn⟩
  · intro Q closed k r opened
    have below n : Sub (s n) Q := by
      induction n with
      | zero => exact fun _ _ h => h.elim
      | succ n ih => exact fun j t h => closed j t (monotone_step ih j t h)
    obtain ⟨n, hn⟩ := opened
    exact below n k r hn

def Meet (A : ℕ → Policy X K) : Policy X K := fun x k => ∀ n, A n x k

private theorem finite_hit {α : Type*} (keys : Finset α) (A : ℕ → α → Prop)
    (shrinks : ∀ n m, n ≤ m → ∀ j, A m j → A n j)
    (hit : ∀ n, ∃ j ∈ keys, A n j) : ∃ j ∈ keys, ∀ n, A n j := by
  classical
  by_contra! missing
  obtain ⟨n, empty⟩ := synchronize keys (fun j n => ¬ A n j)
    (fun j n m hnm absent h => absent (shrinks n m hnm j h)) missing
  obtain ⟨j, hj, active⟩ := hit n
  exact empty j hj active

theorem recheck_limit {rules : Rules X V} {hi : Policy X K} {P : Package K V}
    {A : ℕ → Policy X K} (upper : ∀ n, Sub (A n) hi)
    (shrinks : ∀ n m, n ≤ m → Sub (A m) (A n))
    (few : ∀ x k t calls, rules x t calls → ¬ P k t → ∃ F : Finset (X × K),
      ∀ p, p ∈ F ↔ hi p.1 p.2 ∧ ∃ q ∈ calls, q.1 = p.1 ∧ ¬ P p.2 q.2) (x : X) (k : K) :
    RecheckAt rules hi P (Meet A) x k ↔ ∀ n, RecheckAt rules hi P (A n) x k := by
  classical
  constructor
  · exact fun h n => recheck_mono (A := Meet A) (B := A n) (fun _ _ hj => hj n) x k h
  · intro h
    refine ⟨(h 0).1, ?_⟩
    intro t calls rule opens
    by_contra bad
    obtain ⟨F, describes⟩ := few x k t calls rule bad
    have hit n : ∃ p ∈ F, A n p.1 p.2 := by
      by_contra! absent
      apply bad
      apply (h n).2 t calls rule
      intro q hq j hj
      by_contra fail
      exact absent (q.1,j) ((describes _).mpr ⟨upper n _ _ hj, q, hq, rfl, fail⟩) hj
    obtain ⟨p, hp, remains⟩ := finite_hit F (fun n p => A n p.1 p.2)
      (fun n m hnm p => shrinks n m hnm p.1 p.2) hit
    obtain ⟨_, q, member, same, fail⟩ := (describes p).mp hp
    exact fail (opens q member p.2 (same.symm ▸ remains))

def Blockers (A : Policy X K) (P : Package K V) (x : X) (r : V) : Set K :=
  {k | A x k ∧ ¬ P k r}

/-- A descending menu and an ascending package can be synchronized when
the keys refuting this observation form a compact, closed nested sequence. -/
theorem diagonal_open [TopologicalSpace K] {A : ℕ → Policy X K} {P : ℕ → Package K V}
    (shrinks : ∀ n m, n ≤ m → Sub (A m) (A n))
    (grows : ∀ n m, n ≤ m → Sub (P n) (P m)) {x : X} {r : V}
    (compact : IsCompact (Blockers (A 0) (P 0) x r))
    (closed : ∀ n, IsClosed (Blockers (A n) (P n) x r)) :
    Open (Meet A) (AtLimit P) x r ↔ ∃ n, Open (A n) (P n) x r := by
  classical
  constructor
  · intro allowed
    by_contra! never
    let D n := Blockers (A n) (P n) x r
    have less (n : ℕ) : D (n+1) ⊆ D n := fun k hk =>
      ⟨shrinks n _ (Nat.le_succ n) x k hk.1, fun hr => hk.2 (grows n _ (Nat.le_succ n) k r hr)⟩
    have inhabited (n : ℕ) : (D n).Nonempty := by
      have h := never n
      simp only [Open, not_forall] at h
      obtain ⟨k, hk, fail⟩ := h
      exact ⟨k, hk, fail⟩
    obtain ⟨k, hk⟩ := IsCompact.nonempty_iInter_of_sequence_nonempty_isCompact_isClosed
      D less inhabited compact closed
    have allStages := Set.mem_iInter.mp hk
    obtain ⟨n, hn⟩ := allowed k (fun n => (allStages n).1)
    exact (allStages n).2 hn
  · rintro ⟨n, hn⟩ k hk
    exact ⟨n, hn k (hk n)⟩

theorem diagonal_inductive {rules : Rules X V} {A : ℕ → Policy X K} {P : ℕ → Package K V}
    (shrinks : ∀ n m, n ≤ m → Sub (A m) (A n))
    (grows : ∀ n m, n ≤ m → Sub (P n) (P m))
    (syncOpen : ∀ x r, Open (Meet A) (AtLimit P) x r → ∃ n, Open (A n) (P n) x r)
    (valid : ∀ n, Sub (Step rules (A n) (P n)) (P n)) :
    Sub (Step rules (Meet A) (AtLimit P)) (AtLimit P) := by
  classical
  rintro k r ⟨x, calls, rule, chosen, opened⟩
  obtain ⟨n, synchronized⟩ := synchronize calls.toFinset
    (fun (q : X × V) n => Open (A n) (P n) q.1 q.2)
    (fun q i j hij old k hk => grows i j hij k q.2 (old k (shrinks i j hij q.1 k hk)))
    (fun q hq => syncOpen _ _ (opened q (List.mem_toFinset.mp hq)))
  exact ⟨n,valid n k r ⟨x, calls, rule, chosen n, fun q hq => synchronized q (List.mem_toFinset.mpr hq)⟩⟩

theorem rounded_weak (u : ℤ) (c : ℚ) : ((u : ℚ) + c ≤ 0) ↔ u + ⌈c⌉ ≤ 0 := by
  have h : ⌈c⌉ ≤ -u ↔ c ≤ -(u : ℚ) := by rw [Int.ceil_le, Int.cast_neg]
  constructor
  · intro hu
    have := h.mpr (by linarith : c ≤ -(u : ℚ))
    omega
  · intro hu
    have := h.mp (by omega : ⌈c⌉ ≤ -u)
    linarith

theorem rounded_strict (u : ℤ) (c : ℚ) : ((u : ℚ) + c < 0) ↔ u + ⌊c⌋ + 1 ≤ 0 := by
  have h : ⌊c⌋ < -u ↔ c < -(u : ℚ) := by rw [Int.floor_lt, Int.cast_neg]
  constructor
  · intro hu
    have := h.mpr (by linarith : c < -(u : ℚ))
    omega
  · intro hu
    have := h.mp (by omega : ⌊c⌋ < -u)
    linarith

theorem floor_difference {a b : ℚ} {d : ℤ} (h : a - b ≤ (d : ℚ)) : ⌊a⌋ - ⌊b⌋ ≤ d := by
  have h' := Int.floor_mono (show a ≤ b + d by linarith)
  rw [Int.floor_add_intCast] at h'
  omega

namespace Shrinking
def menu (n : ℕ) (_ : Unit) (k : ℚ) := 0 ≤ k ∧ k ≤ 1 / ((n : ℚ) + 1)
def stored (k r : ℚ) := r = 0 ∨ (k = 0 ∧ 0 ≤ r ∧ r ≤ 1)

theorem finite_open (n : ℕ) (r : ℚ) : Open (menu n) stored () r ↔ r = 0 := by
  constructor
  · intro hr
    have pos : 0 < 1 / ((n : ℚ)+1) := by positivity
    rcases hr _ ⟨pos.le,le_rfl⟩ with h | h
    · exact h
    · exact (pos.ne' h.1).elim
  · exact fun h _ _ => Or.inl h

theorem limit_menu (k : ℚ) : Meet menu () k ↔ k = 0 := by
  constructor
  · intro h
    by_contra ne
    have pos : 0 < k := lt_of_le_of_ne (h 0).1 (Ne.symm ne)
    obtain ⟨n, large⟩ := exists_nat_gt (1/k)
    have large' := (div_lt_iff₀ pos).mp large
    have small := (le_div_iff₀ (by positivity : 0 < (n : ℚ)+1)).mp (h n).2
    nlinarith
  · rintro rfl n
    exact ⟨le_rfl, by positivity⟩

theorem limit_fails :
    Open (Meet menu) stored () 1 ∧ ¬ Open (Meet menu) stored () (2*1) := by
  constructor
  · intro k hk
    exact Or.inr ⟨(limit_menu k).mp hk, by decide, le_rfl⟩
  · intro h
    have impossible := h 0 ((limit_menu 0).mpr rfl)
    norm_num [stored] at impossible

end Shrinking
end Admission
