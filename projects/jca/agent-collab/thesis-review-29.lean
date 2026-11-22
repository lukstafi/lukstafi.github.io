import «thesis-review-28»

namespace IntervalPolicies
open SharedChoices IntervalOpening

def Fits {H : Type} (x lo hi : H → Int) (m c : Int) (h : H) :=
  lo h ≤ m*x h+c ∧ m*x h+c ≤ hi h

/-- Four observations suffice, including for an infinite family of closed
    finite integer intervals. Repetitions cover families of size below four. -/
theorem four_iff {H : Type} (x lo hi : H → Int) :
    (∃ m c, ∀ h, Fits x lo hi m c h) ↔
      ∀ a b s t, ∃ m c, Fits x lo hi m c a ∧ Fits x lo hi m c b ∧
                         Fits x lo hi m c s ∧ Fits x lo hi m c t := by
  constructor
  · rintro ⟨m,c,all⟩ a b s t
    exact ⟨m,c,all a,all b,all s,all t⟩
  intro four
  let P := {p : H × H // x p.1 < x p.2}
  let low := fun p : P => -((hi p.val.1 - lo p.val.2) / (x p.val.2 - x p.val.1))
  let high := fun p : P => (hi p.val.2 - lo p.val.1) / (x p.val.2 - x p.val.1)
  have bounds (p : P) (m : Int) :
      low p ≤ m ∧ m ≤ high p ↔
        m*x p.val.1 - m*x p.val.2 ≤ hi p.val.1 - lo p.val.2 ∧
        m*x p.val.2 - m*x p.val.1 ≤ hi p.val.2 - lo p.val.1 := by
    have pos : 0 < x p.val.2 - x p.val.1 := by have := p.property; omega
    have l := Int.le_ediv_iff_mul_le (a := -m) (b := hi p.val.1 - lo p.val.2) pos
    have u := Int.le_ediv_iff_mul_le (a := m) (b := hi p.val.2 - lo p.val.1) pos
    simp only [Int.neg_mul, Int.mul_sub] at l u
    dsimp only [low, high]
    omega
  have cross (p q : P) : low p ≤ high q := by
    obtain ⟨m,c,ha,hb,hs,ht⟩ := four p.val.1 p.val.2 q.val.1 q.val.2
    unfold Fits at ha hb hs ht
    have lp := ((bounds p m).mpr (by constructor <;> omega)).1
    have uq := ((bounds q m).mpr (by constructor <;> omega)).2
    exact Int.le_trans lp uq
  obtain ⟨pick, ok⟩ := (uniform_iff (fun _ : P => ()) low high).mpr (fun p q _ => cross p q)
  apply (affine_iff x lo hi).mpr
  refine ⟨pick (), fun h j => ?_⟩
  rw [Int.mul_sub]
  by_cases lt : x h < x j
  · let p : P := ⟨(h,j),lt⟩
    exact ((bounds p _).mp (ok p)).2
  by_cases gt : x j < x h
  · let p : P := ⟨(j,h),gt⟩
    exact ((bounds p _).mp (ok p)).1
  · obtain ⟨m,c,hh,hj,_⟩ := four h j h j
    unfold Fits at hh hj
    have same : x h = x j := by omega
    rw [same] at hh ⊢
    omega

inductive Four | a | b | s | t deriving DecidableEq

def coord : Four → Int | .a => -2 | .b => 1 | .s => -1 | .t => 2
def lower : Four → Int | .a => -5 | .b => 1 | .s => 0 | .t => -5
def upper : Four → Int | .a => 0 | .b => 5 | .s => 5 | .t => 2

theorem sharp :
    (∀ omitted : Four, ∃ m c, ∀ h, h ≠ omitted → Fits coord lower upper m c h) ∧
    ¬ ∃ m c, ∀ h, Fits coord lower upper m c h := by
  constructor
  · intro omitted
    cases omitted
    case a => exact ⟨0,1,by intro h; cases h <;> unfold Fits <;> decide⟩
    case b => exact ⟨0,0,by intro h; cases h <;> unfold Fits <;> decide⟩
    case s => exact ⟨1,0,by intro h; cases h <;> unfold Fits <;> decide⟩
    case t => exact ⟨1,1,by intro h; cases h <;> unfold Fits <;> decide⟩
  · rintro ⟨m,c,all⟩
    have a := all .a
    have b := all .b
    have s := all .s
    have t := all .t
    simp [Fits, coord, lower, upper] at a b s t
    omega

/-- These intervals also arise as legal keys of width-seven packages. -/
theorem sharp_packages (h : Four) (k : Int) :
    Works (upper h) 7 k [⟨lower h-1, lower h-1, Int.le_refl _⟩] ↔
      lower h ≤ k ∧ k ≤ upper h := by
  rw [key_interval _ _ _ (by decide)]
  cases h <;> simp [leastKey, greatestKey, upper, lower] <;> omega

def usable (i k : Int) := Works (4*i+1) 2 k [⟨2,4,by decide⟩]

theorem three_bands (i k : Int) (states : i = 0 ∨ i = 1 ∨ i = 2) :
    usable i k ↔ (i = 0 ∧ k = -1) ∨ (i = 1 ∧ k = 5) ∨ (i = 2 ∧ 7 ≤ k ∧ k ≤ 9) := by
  unfold usable
  rw [key_interval _ _ _ (by decide)]
  rcases states with rfl | rfl | rfl <;> simp [leastKey, greatestKey] <;> omega

theorem three_policy :
    (∀ i, 0 ≤ i → i ≤ 2 → usable i (min (6*i-1) (4*i+1))) ∧
    ¬ ∃ m c, ∀ i, 0 ≤ i → i ≤ 2 → usable i (m*i+c) := by
  constructor
  · intro i lo hi
    rw [three_bands _ _ (by omega)]
    omega
  · rintro ⟨m,c,all⟩
    have a := (three_bands _ _ (Or.inl rfl)).mp (all 0 (by decide) (by decide))
    have b := (three_bands _ _ (Or.inr (Or.inl rfl))).mp (all 1 (by decide) (by decide))
    have s := (three_bands _ _ (Or.inr (Or.inr rfl))).mp (all 2 (by decide) (by decide))
    omega

/-- Both producer branches return the anchor. The child interval is
    chosen before opening and the same choice is available at every depth. -/
theorem three_contract (i : Int) (lo : 0 ≤ i) (hi : i ≤ 2) :
    (∀ parent, Inside 2 parent (4*i+1) →
      ∃ child, Inside 2 child (4*i+1) ∧
        ∀ r, Inside 2 child r → ¬ (2 ≤ r ∧ r ≤ 4) ∧ Inside 2 parent (4*i+1)) ∧
    ∃ parent, Inside 2 parent (4*i+1) ∧ ∀ r, Inside 2 parent r → r ≤ 9 := by
  have h := three_policy.1 i lo hi
  constructor
  · intro parent fits
    refine ⟨_, h.1, fun r inside => ⟨?_, fits⟩⟩
    exact h.2 ⟨2,4,by decide⟩ (by simp) r inside
  · refine ⟨4*i-1, ⟨by omega, by omega⟩, ?_⟩
    rintro r ⟨_, bound⟩
    omega

end IntervalPolicies
