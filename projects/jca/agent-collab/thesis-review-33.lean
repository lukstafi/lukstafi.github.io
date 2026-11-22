import Std

namespace ErasedOpenings

def Possible {K R W : Type} (post : K → R → W → Prop) (k : K) (r : R) :=
  ∃ w, post k r w

/-- One evaluation, two admitted typings, and independently scoped witnesses. -/
theorem paired {K R W : Type} {allowed : K → Prop} {returns : R → Prop}
    {post : K → R → W → Prop}
    (typed : ∀ k r, allowed k → returns r → Possible post k r)
    {a b : K} (ha : allowed a) (hb : allowed b) {r} (hr : returns r) :
    ∃ w₁ w₂, post a r w₁ ∧ post b r w₂ := by
  obtain ⟨w₁,h₁⟩ := typed a r ha hr
  obtain ⟨w₂,h₂⟩ := typed b r hb hr
  exact ⟨w₁,w₂,h₁,h₂⟩

/-- Endpoint recovery on every integer interval characterizes the sections
    that are order-convex after the private witnesses have been projected. -/
theorem endpoint_criterion {R W : Type} (post : Int → R → W → Prop) :
    (∀ l u r, l ≤ u → ((∀ k, l ≤ k → k ≤ u → Possible post k r) ↔
      Possible post l r ∧ Possible post u r)) ↔
    (∀ r l k u, l ≤ k → k ≤ u → Possible post l r → Possible post u r →
      Possible post k r) := by
  constructor
  · intro h r l k u low high left right
    exact ((h l u r (Int.le_trans low high)).mpr ⟨left,right⟩) k low high
  · intro convex l u r ordered
    constructor
    · intro h
      exact ⟨h l (Int.le_refl _) ordered, h u ordered (Int.le_refl _)⟩
    · rintro ⟨left,right⟩ k low high
      exact convex r l k u low high left right

theorem attained_extrema {allowed : Int → Prop} {l u a b r : Int}
    (hl : allowed l) (hu : allowed u) (bounds : ∀ k, allowed k → l ≤ k ∧ k ≤ u) :
    (∀ k, allowed k → k+a ≤ r ∧ r ≤ k+b) ↔ u+a ≤ r ∧ r ≤ l+b := by
  constructor
  · intro h; exact ⟨(h u hu).1,(h l hl).2⟩
  · intro h k hk; have := bounds k hk; omega

theorem different_witnesses (n s : Int) (wide : 0 < n) :
    (∀ k : Int, s-n ≤ k → k ≤ s → ∃ w, 0 ≤ w ∧ w ≤ n ∧ s = k+w) ∧
    (¬ ∃ w : Int, s = (s-n)+w ∧ s = s+w) := by
  constructor
  · intro k lo hi; exact ⟨s-k,by omega,by omega,by omega⟩
  · rintro ⟨w,h⟩; omega

theorem narrowed_supplier (s n : Int) (width : 1 ≤ n) :
    (∀ k : Int, (s-n ≤ k ∧ k ≤ s ∧ k ≤ s-1 ∧ s-1 ≤ k+n) ↔
                 (s-n ≤ k ∧ k ≤ s-1)) ∧
    (s-n ≤ s-1 ∧ s-1 ≤ (s-n)+n) ∧ ¬ (s ≤ s-1 ∧ s-1 ≤ s+n) := by
  constructor
  · intro k; omega
  · omega

/-- A sample excludes all bad results exactly when it hits the excluding
    keys for each bad result. The quantifiers permit a different key per result. -/
theorem hitting {K R : Type} (sample : K → Prop) (bad : R → Prop) (p : K → R → Prop) :
    (∀ r, (∀ k, sample k → p k r) → ¬ bad r) ↔
    (∀ r, bad r → ∃ k, sample k ∧ ¬ p k r) := by
  classical
  constructor
  · intro exclude r hr
    apply Classical.byContradiction
    intro none
    apply exclude r _ hr
    intro k hk
    exact Classical.byContradiction (fun missing => none ⟨k,hk,missing⟩)
  · intro hit r all hr
    obtain ⟨k,hk,no⟩ := hit r hr
    exact no (all k hk)

/-- A proof can select a refuting key after fixing a hypothetical result.
    Its admissibility is established from information *before* its own opening. -/
theorem refute_result {K R W : Type} {allowed : K → Prop} {returns bad : R → Prop}
    {post : K → R → W → Prop}
    (typed : ∀ k r, allowed k → returns r → Possible post k r)
    (refute : ∀ r, returns r → bad r → ∃ k, allowed k ∧ ¬ Possible post k r) :
    ∀ r, returns r → ¬ bad r := by
  intro r hr hb
  obtain ⟨k,hk,no⟩ := refute r hr hb
  exact no (typed k r hk hr)

def puncture (n k r : Nat) := r ≤ n ∧ r ≠ k

theorem full_meet (n : Nat) (pos : 0 < n) (r : Nat) :
    (∀ k, 1 ≤ k → k ≤ n → puncture n k r) ↔ r = 0 := by
  constructor
  · intro h
    have bound := (h 1 (by omega) pos).1
    by_cases z : r = 0
    · exact z
    · exact False.elim ((h r (by omega) bound).2 rfl)
  · rintro rfl k low _
    unfold puncture; omega

theorem diagonal_key (n r : Nat) (pos : 1 ≤ n) (initial : r ≤ n) :
    let k := max 1 r
    (1 ≤ k ∧ k ≤ n) ∧ (puncture n k r ↔ r = 0) := by
  dsimp only [puncture]
  omega

theorem required_samples (n : Nat) (ks : List Nat) :
    (∀ r, 1 ≤ r → r ≤ n → ∃ k ∈ ks, ¬ puncture n k r) ↔
    (∀ r, 1 ≤ r → r ≤ n → r ∈ ks) := by
  constructor
  · intro h r pos le
    obtain ⟨k,hk,no⟩ := h r pos le
    have eq : r = k := by unfold puncture at no; omega
    exact eq ▸ hk
  · intro h r pos le
    exact ⟨r,h r pos le, fun hp => hp.2 rfl⟩

theorem sample_count (n : Nat) (ks : List Nat)
    (hit : ∀ r, 1 ≤ r → r ≤ n → ∃ k ∈ ks, ¬ puncture n k r) : n ≤ ks.length := by
  have cover := (required_samples n ks).mp hit
  clear hit
  induction n generalizing ks with
  | zero => omega
  | succ n ih =>
    have mem := cover (n+1) (by omega) (by omega)
    have small := ih (ks.erase (n+1)) (by
      intro r pos high
      rw [List.mem_erase_of_ne (by omega)]
      exact cover r pos (by omega))
    have len := List.length_erase_of_mem mem
    have nonempty : ks.length ≠ 0 := by
      intro empty; simp [List.length_eq_zero_iff.mp empty] at mem
    omega

theorem sample_count_sharp (n : Nat) :
    ∃ ks : List Nat, ks.length = n ∧ ∀ r, 1 ≤ r → r ≤ n → ∃ k ∈ ks, ¬ puncture n k r := by
  refine ⟨List.range' 1 n,by simp,(required_samples _ _).mpr ?_⟩
  intro r low high
  apply List.mem_range'.mpr
  exact ⟨r-1,by omega,by omega⟩

/-- Eliminating an integer private witness can split a key section, even
    for one linear equation. -/
theorem parity_section :
    (∃ w : Int, 2*w = 0) ∧ (∃ w : Int, 2*w = 2) ∧ ¬ ∃ w : Int, 2*w = 1 := by
  exact ⟨⟨0,rfl⟩,⟨1,rfl⟩,by rintro ⟨w,hw⟩; omega⟩

/-- With n fixed, the puncture is expressible by a conjunction of integer
    linear inequalities and one private integer witness. -/
theorem conjunctive_puncture (n k r : Int) (hr : 0 ≤ r ∧ r ≤ n)
    (hk : 1 ≤ k ∧ k ≤ n) :
    r ≠ k ↔ ∃ w : Int, 1 ≤ r-k-(n+1)*w ∧ r-k-(n+1)*w ≤ n := by
  constructor
  · intro neq
    by_cases lt : r < k
    · exact ⟨-1,by simp; omega,by simp; omega⟩
    · exact ⟨0,by simp; omega,by simp; omega⟩
  · rintro ⟨w,h⟩ rfl
    by_cases neg : w ≤ -1
    · have le := Int.mul_le_mul_of_nonneg_left neg (show 0 ≤ n+1 by omega)
      simp only [Int.mul_neg,Int.mul_one] at le
      omega
    · have := Int.mul_nonneg (show 0 ≤ n+1 by omega) (show 0 ≤ w by omega)
      omega

end ErasedOpenings
