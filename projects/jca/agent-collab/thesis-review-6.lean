import Std

namespace ShiftedCap

-- The same shift is passed into each recursive call. Indices are integers.
def ceiling (offset m : Int) : Int := max (m + offset) 0
def band (offset m r : Int) : Prop := 0 ≤ r ∧ r ≤ ceiling offset m

-- Substitute the actual argument before comparing the two caps.
theorem call_at {cap limit shift m : Int} :
    (∀ r, band cap (m + shift) r → band limit m r) ↔
      m + shift + cap ≤ ceiling limit m := by
  unfold band ceiling
  constructor
  · intro h
    have hi := h (max (m + shift + cap) 0) ⟨by omega, by omega⟩
    omega
  · intros; omega

-- Each source alternative implies its corresponding target alternative.
theorem dominated_arms {p q g h : Int}
    (source : p ≤ 0 ∨ q ≤ 0) (left : g ≤ p) (right : h ≤ q) :
    g ≤ 0 ∨ h ≤ 0 := by omega

-- A separate zero constructor and bounded positive-cap constructor return
-- exactly the payloads permitted by the single max-capped constructor.
theorem split_supplier {cap m r u : Int} (hr : 0 ≤ r) :
    (u = 0 ∨ (0 ≤ u ∧ u ≤ r + 1 ∧ u ≤ m + cap)) ↔
      (band cap m u ∧ u ≤ r + 1) := by
  unfold band ceiling
  omega

structure Valid (cap limit shift : Int) (admits : Int → Prop)
    (post : Int → Int → Prop) : Prop where
  recurse : ∀ m, admits m → admits (m + shift)
  base : ∀ m, admits m → post m 0
  call : ∀ m r, admits m → post (m + shift) r → band limit m r
  step : ∀ m r u, admits m → post (m + shift) r → band limit m r →
    band cap m u → u ≤ r + 1 → post m u

theorem complete_scheme {cap limit shift : Int} (safe : cap + shift ≤ limit) :
    Valid cap limit shift (fun _ => True) (band cap) := by
  constructor
  · simp
  · intros; unfold band ceiling; omega
  · unfold band ceiling; intros; omega
  · intros; assumption

-- A two-step counterexample suffices if all inputs are admitted.
theorem two_steps {cap limit shift : Int} {admits post}
    (h : Valid cap limit shift admits post) (bad : limit < cap + shift) :
    ¬admits (-limit) := by
  intro here
  have there := h.recurse _ here
  have zero := h.base _ (h.recurse _ there)
  have one := h.step _ 0 1 there zero (h.call _ _ there zero)
    (by unfold band ceiling; omega) (by decide)
  have impossible := h.call _ 1 here one
  unfold band ceiling at impossible
  omega

-- For an upward shift all integer outputs through the cap can be produced,
-- possibly at different recursion depths.
theorem fills_band {cap limit shift : Int} {admits post}
    (h : Valid cap limit shift admits post) (up : 0 ≤ shift) (n : Nat) :
    ∀ m, admits m → (n : Int) ≤ ceiling cap m → post m (n : Int) := by
  induction n with
  | zero => intro m hm _; exact h.base m hm
  | succ n ih =>
    intro m hm bound
    have prev := ih (m + shift) (h.recurse _ hm) (by unfold ceiling at *; omega)
    exact h.step _ _ _ hm prev (h.call _ _ hm prev) ⟨by omega, bound⟩ (by omega)

theorem reachable_above {d : Int} {p : Int → Prop} (up : 1 ≤ d)
    (closed : ∀ m, p m → p (m + d)) {m : Int} (hm : p m) (k : Nat) :
    ∃ z, p z ∧ m + (k : Int) ≤ z := by
  induction k with
  | zero => exact ⟨m, hm, by omega⟩
  | succ k ih =>
    obtain ⟨z, hz, le⟩ := ih
    exact ⟨z + d, closed z hz, by omega⟩

-- No restriction on the initial m can rescue a shift exceeding the slack
-- when the input includes unindexed natural numbers of arbitrary depth.
theorem no_input_above_slack {cap limit shift : Int} {admits post}
    (slack : cap ≤ limit) (bad : limit < cap + shift)
    (h : Valid cap limit shift admits post) (m : Int) : ¬admits m := by
  intro hm
  have up : 1 ≤ shift := by omega
  obtain ⟨z, hz, le⟩ := reachable_above up h.recurse hm (-limit-m).toNat
  have nonneg : 0 ≤ z + limit := by omega
  let n := (z + limit + 1).toNat
  have hn : (n : Int) = z + limit + 1 := by dsimp [n]; omega
  have witness := fills_band h (by omega) n (z + shift) (h.recurse z hz)
    (by unfold ceiling; omega)
  have obstacle := h.call z _ hz witness
  unfold band ceiling at obstacle
  omega

theorem admissible_iff {cap limit shift m : Int} (slack : cap ≤ limit) :
    (∃ admits post, Valid cap limit shift admits post ∧ admits m) ↔ cap + shift ≤ limit := by
  constructor
  · rintro ⟨admits, post, valid, hm⟩
    apply Classical.byContradiction
    intro bad
    exact no_input_above_slack slack (by omega) valid m hm
  · intro safe
    exact ⟨_, _, complete_scheme safe, trivial⟩

end ShiftedCap
