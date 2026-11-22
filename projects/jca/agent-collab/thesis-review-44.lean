import Mathlib.Algebra.Order.Archimedean.Basic
import Mathlib.Data.Finset.Prod
import Mathlib.Data.Finset.Union
import Mathlib.Data.Fintype.Prod
import Mathlib.Data.Fintype.Pigeonhole
import Mathlib.Order.OrderIsoNat
import Mathlib.Order.WellFounded
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

namespace PackageJump

variable {X K V : Type*}

def Store (A : X → K → Prop) (S : X → V → Prop) (k : K) (r : V) :=
  ∃ x, A x k ∧ S x r

def Open (A : X → K → Prop) (P : K → V → Prop) (x : X) (r : V) :=
  ∀ k, A x k → P k r

theorem store_open (A : X → K → Prop) (S : X → V → Prop) (P : K → V → Prop) :
    (∀ k r, Store A S k r → P k r) ↔ (∀ x r, S x r → Open A P x r) := by
  constructor
  · exact fun h x r hr k hk => h k r ⟨x, hk, hr⟩
  · rintro h k r ⟨x, hk, hr⟩
    exact h x r hr k hk

theorem exact_open (A : X → K → Prop) (S : X → V → Prop) :
    (∃ P, ∀ x r, Open A P x r ↔ S x r) ↔
      (∀ x r, Open A (Store A S) x r ↔ S x r) := by
  constructor
  · rintro ⟨P, hp⟩ x r
    constructor
    · intro h
      apply (hp x r).mp
      intro k hk
      obtain ⟨y, hy, hr⟩ := h k hk
      exact (hp y r).mpr hr k hy
    · exact fun hr k hk => ⟨x, hk, hr⟩
  · exact fun h => ⟨Store A S, h⟩

def expand (c a t : ℚ) := c + a * (t - c)

theorem upper_forces_centre {H : ℚ → Prop} {c a d : ℚ}
    (gain : 1 < a) (next : ∀ r, H r → H (expand c a r))
    (caller : ∀ r, H r → r ≤ d) {t : ℚ} (ht : H t) : t ≤ c := by
  by_contra! above
  have orbit (n : ℕ) : H (c + a^n * (t-c)) := by
    induction n with
    | zero => simpa using ht
    | succ n ih =>
      convert next _ ih using 1
      unfold expand
      rw [pow_succ]
      ring
  obtain ⟨n, hn⟩ := pow_unbounded_of_one_lt ((d-c)/(t-c)) gain
  have pass := (div_lt_iff₀ (sub_pos.mpr above)).mp hn
  linarith [caller _ (orbit n)]

def Solution (A : X → K → Prop) (g d : X → ℚ) (B : X → ℚ → Prop)
    (P : K → ℚ → Prop) :=
  (∀ x, Open A P x (g x)) ∧
  (∀ x a r, B x a → Open A P x r → Open A P x (expand (g x) a r)) ∧
  (∀ x r, Open A P x r → r ≤ d x)

def ConvexSections (P : K → ℚ → Prop) :=
  ∀ k u v r, P k u → P k v → u ≤ r → r ≤ v → P k r

def Cap (A : X → K → Prop) (g : X → ℚ) := Store A (fun y r => r ≤ g y)

/-- A single projection is complete for sectionwise convex solutions.
No finiteness, compactness or attainment assumptions on the menus. -/
theorem cap_complete (A : X → K → Prop) (g d : X → ℚ) (B : X → ℚ → Prop)
    (nonneg : ∀ x a, B x a → 0 ≤ a) (expanding : ∀ x, ∃ a, B x a ∧ 1 < a) :
    (∃ P, Solution A g d B P ∧ ConvexSections P) ↔
    Solution A g d B (Cap A g) := by
  constructor
  · rintro ⟨P, ⟨base, step, caller⟩, convex⟩
    have forces (x r) (opened : Open A (Cap A g) x r) : r ≤ g x := by
      by_contra! above
      have inP : Open A P x r := by
        intro k hk
        obtain ⟨y, hy, hr⟩ := opened k hk
        exact convex k (g x) (g y) r (base x k hk) (base y k hy) above.le hr
      obtain ⟨a, ha, big⟩ := expanding x
      exact (not_le_of_gt above) (upper_forces_centre big (fun s => step x a s ha) (caller x) inP)
    refine ⟨fun x k hk => ⟨x, hk, le_rfl⟩, ?_, ?_⟩
    · intro x a r ha hr k hk
      refine ⟨x, hk, ?_⟩
      exact add_le_of_nonpos_right (mul_nonpos_of_nonneg_of_nonpos (nonneg x a ha)
        (sub_nonpos.mpr (forces x r hr)))
    · exact fun x r hr => (forces x r hr).trans (caller x _ (base x))
  · intro sol
    refine ⟨Cap A g, sol, ?_⟩
    rintro k u v r _ ⟨y, hy, hv⟩ _ hrv
    exact ⟨y, hy, hrv.trans hv⟩

/-- An entire interval of admission policies shares a convex solution
exactly when the smallest opening menu passes the largest base projection. -/
theorem admission_interval (lo hi : X → K → Prop) (g d : X → ℚ) (B : X → ℚ → Prop)
    (nested : ∀ x k, lo x k → hi x k) (base_ok : ∀ x, g x ≤ d x)
    (nonneg : ∀ x a, B x a → 0 ≤ a) (expanding : ∀ x, ∃ a, B x a ∧ 1 < a) :
    (∃ P, ConvexSections P ∧ ∀ A : X → K → Prop,
      (∀ x k, lo x k → A x k) → (∀ x k, A x k → hi x k) → Solution A g d B P) ↔
    ∀ x r, Open lo (Cap hi g) x r → r ≤ g x := by
  constructor
  · rintro ⟨P, convex, solve⟩ x r opened
    obtain ⟨smallBase, smallStep, caller⟩ := solve lo (fun _ _ h => h) nested
    have bigBase := (solve hi nested (fun _ _ h => h)).1
    by_contra! above
    have inP : Open lo P x r := by
      intro k hk
      obtain ⟨y, hy, hr⟩ := opened k hk
      exact convex k (g x) (g y) r (smallBase x k hk) (bigBase y k hy) above.le hr
    obtain ⟨a, ha, big⟩ := expanding x
    exact (not_le_of_gt above)
      (upper_forces_centre big (fun s => smallStep x a s ha) (caller x) inP)
  · intro bounded
    refine ⟨Cap hi g, ?_, ?_⟩
    · rintro k u v r _ ⟨y, hy, hv⟩ _ hrv
      exact ⟨y, hy, hrv.trans hv⟩
    · intro A lower upper
      have forces (x r) (hr : Open A (Cap hi g) x r) : r ≤ g x :=
        bounded x r (fun k hk => hr k (lower x k hk))
      refine ⟨fun x k hk => ⟨x, upper x k hk, le_rfl⟩, ?_, ?_⟩
      · intro x a r ha hr k hk
        exact ⟨x, upper x k hk, add_le_of_nonpos_right (mul_nonpos_of_nonneg_of_nonpos
          (nonneg x a ha) (sub_nonpos.mpr (forces x r hr)))⟩
      · exact fun x r hr => (forces x r hr).trans (base_ok x)

theorem add_tail {A : X → K → Prop} {P : K → ℚ → Prop} {g d : X → ℚ}
    {allowed : X → ℚ → Prop} {m : ℚ}
    (floor_le : ∀ x, m ≤ g x) (base_caller : ∀ x, g x ≤ d x)
    (gain : ∀ x a, allowed x a → 1 ≤ a)
    (producer : ∀ x a r, allowed x a → Open A P x r → Open A P x (expand (g x) a r))
    (caller : ∀ x r, Open A P x r → r ≤ d x) :
    let Q := fun k r => r ≤ m ∨ P k r
    (∀ x a r, allowed x a → Open A Q x r → Open A Q x (expand (g x) a r)) ∧
    (∀ x r, Open A Q x r → r ≤ d x) := by
  dsimp only
  constructor
  · intro x a r ha hr k hk
    by_cases h : r ≤ m
    · left
      have := mul_nonpos_of_nonneg_of_nonpos (sub_nonneg.mpr (gain x a ha))
        (sub_nonpos.mpr (h.trans (floor_le x)))
      unfold expand
      linarith
    · exact Or.inr (producer x a r ha (fun j hj => (hr j hj).resolve_left h) k hk)
  · intro x r hr
    by_cases h : r ≤ m
    · exact h.trans ((floor_le x).trans (base_caller x))
    · exact caller x r (fun k hk => (hr k hk).resolve_left h)

/-- Strict transitions above the uniform tail. The centre and gain need
only range over finite sets, independently of the number of keys. -/
def Step (G L : Finset ℚ) (m v t : ℚ) : Prop :=
  ∃ p : G × L, t < p.1.val ∧ 1 < p.2.val ∧ m < v ∧ v = expand p.1.val p.2.val t

theorem step_wellFounded (G L : Finset ℚ) (m : ℚ) : WellFounded (Step G L m) := by
  classical
  apply WellFounded.wellFounded_iff_no_descending_seq.mpr
  constructor
  rintro ⟨t, path⟩
  choose pair hc ha hm hv using path
  have down : Antitone t := antitone_nat_of_succ_le fun i => by
    rw [hv i]
    have := mul_neg_of_pos_of_neg (sub_pos.mpr (ha i)) (sub_neg.mpr (hc i))
    unfold expand
    linarith
  obtain ⟨p, hp⟩ := Finite.exists_infinite_fiber pair
  letI := hp
  let atUse := Nat.Subtype.orderIsoOfNat (pair ⁻¹' {p})
  let ix (n : ℕ) : ℕ := (atUse n).val
  have mono : StrictMono ix := fun _ _ h => atUse.strictMono h
  have same (n : ℕ) : pair (ix n) = p := (atUse n).property
  have first := hc (ix 0)
  rw [same] at first
  have gain := ha (ix 0)
  rw [same] at gain
  let gap := (p.2.val - 1) * (p.1.val - t (ix 0))
  have pos : 0 < gap := mul_pos (sub_pos.mpr gain) (sub_pos.mpr first)
  have drop (n : ℕ) : t (ix (n+1)) ≤ t (ix n) - gap := by
    have near := down (mono.monotone (Nat.zero_le n))
    have step := hv (ix n)
    rw [same] at step
    have mid := down (show ix n + 1 ≤ ix (n+1) from mono (Nat.lt_succ_self n))
    dsimp [gap, expand] at *
    nlinarith [mul_nonneg (sub_nonneg.mpr gain.le) (sub_nonneg.mpr near)]
  have bound (n : ℕ) : t (ix n) ≤ t (ix 0) - n * gap := by
    induction n with
    | zero => simp
    | succ n ih =>
      push_cast
      linarith [drop n]
  obtain ⟨n, hn⟩ := exists_nat_gt ((t (ix 0) - m)/gap)
  have past := (div_lt_iff₀ pos).mp hn
  have after := down (show ix n ≤ ix n + 1 from Nat.le_succ _)
  linarith [bound n, hm (ix n)]

/-- Every starting value has a finite set closed under the strict transitions. -/
theorem finite_cover (G L : Finset ℚ) (m t : ℚ) :
    ∃ S : Finset ℚ, t ∈ S ∧ ∀ u ∈ S, ∀ v, Step G L m v u → v ∈ S := by
  classical
  induction t using (step_wellFounded G L m).induction with
  | h t ih =>
    let candidates := (G.product L).image (fun p => expand p.1 p.2 t)
    let children := candidates.filter (fun v => Step G L m v t)
    have child {v} (h : Step G L m v t) : v ∈ children := by
      refine Finset.mem_filter.mpr ⟨?_, h⟩
      obtain ⟨p, _, _, _, e⟩ := h
      exact Finset.mem_image.mpr
        ⟨(p.1.val, p.2.val), Finset.mem_product.mpr ⟨p.1.property, p.2.property⟩, e.symm⟩
    choose cover root closed using fun v : children =>
      ih v.val (Finset.mem_filter.mp v.property).2
    refine ⟨insert t (children.attach.biUnion cover), Finset.mem_insert_self .., ?_⟩
    intro u hu v hv
    apply Finset.mem_insert_of_mem
    rcases Finset.mem_insert.mp hu with rfl | old
    · let j : children := ⟨v, child hv⟩
      exact Finset.mem_biUnion.mpr ⟨j, Finset.mem_attach .., root j⟩
    · obtain ⟨j, hj, hu⟩ := Finset.mem_biUnion.mp old
      exact Finset.mem_biUnion.mpr ⟨j, hj, closed j u hu v hv⟩

end PackageJump
