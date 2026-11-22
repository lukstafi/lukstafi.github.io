import «thesis-review-8»

namespace MovingFloor

-- The Floor constructor supplies zero even when the unfloored cap is negative.
structure TwoCaps (c b L e d stride : Int)
    (P : Int → Int → Prop) (Q : Int → Int → Int → Prop) : Prop where
  recur : ∀ p x, P p x → P (p+e) (x+d-e)
  base : ∀ p x, P p x → Q p x 0
  call : ∀ p x t, P p x → Q (p+e) (x+d-e) t → band L x (e+t)
  payload : ∀ p x t u, P p x → Q (p+e) (x+d-e) t → band L x (e+t) →
    0 ≤ u → u ≤ x+c → u ≤ max 0 (x+b) → u ≤ e+t+stride → Q p x u

theorem two_caps_iff {c b L e d stride : Int} {P Q} :
    TwoCaps c b L e d stride P Q ↔ GridValid (min c b) L e d stride P Q := by
  constructor
  · intro h
    refine ⟨h.recur, h.base, h.call, ?_⟩
    intro p x t u hp ht hl hu hs
    by_cases hz : u = 0
    · subst u; exact h.base _ _ hp
    · unfold band at hu
      exact h.payload _ _ _ _ hp ht hl hu.1 (by omega) (by omega) hs
  · intro h
    refine ⟨h.recur, h.base, h.call, ?_⟩
    intro p x t u hp ht hl hz hc hb hs
    exact h.step _ _ _ _ hp ht hl (by unfold band; omega) hs

theorem two_caps_exact {c b L e d stride p x : Int} (slack : c ≤ L) (inc : 1 ≤ stride) :
    (∃ P Q, TwoCaps c b L e d stride P Q ∧ P p x) ↔ allows (min c b) L e d x := by
  simp only [two_caps_iff]
  exact grid_exact (by omega) inc

-- A weaker upper bound retains the greatest input domain and needs just
-- one result maximum, regardless of which of the two caps covers the call.
theorem caller_cap_scheme (c b L e d stride : Int) :
    TwoCaps c b L e d stride
      (fun _ x => allows (min c b) L e d x)
      (fun _ x t => band (L-d) x t) := by
  apply two_caps_iff.mpr
  constructor
  · unfold allows; intros; omega
  · unfold band; intros; omega
  · unfold allows band; intros; omega
  · unfold allows band; intros; omega

-- q numerator units represent one program unit. The source passes f = -e.
theorem lowered_cap {q e d x : Int} :
    allows (min (19*q) (19*q-e)) (20*q) e d x ↔
    0 ≤ e ∧ d ≤ q+e ∧ e ≤ max 0 d ∧ e ≤ max 0 (x+20*q) := by
  unfold allows; omega

-- With second cap 22-2e the positive floor rates form two intervals.
-- Existentially quantifying d permits any cap rate, even at the unsafe midpoint.
theorem crossing_rates {q e x : Int} (qpos : 0 < q) (pos : 0 < e) :
    (∃ d, allows (min (19*q) (22*q-2*e)) (20*q) e d x) ↔
    e ≤ x+20*q ∧ (e ≤ q ∨ 2*q ≤ e) := by
  unfold allows
  constructor
  · rintro ⟨d, hd⟩; omega
  · intro h; exact ⟨e, by omega⟩

-- Four input atoms and three output atoms express the exact scheme.
theorem crossing_guard {q e d x : Int} :
    allows (min (19*q) (22*q-2*e)) (20*q) e d x ↔
    0 ≤ e ∧ d ≤ max q (2*e-2*q) ∧ e ≤ max 0 d ∧ e ≤ max 0 (x+20*q) := by
  unfold allows; omega

theorem both_upper_bounds {c b x t : Int} :
    band (min c b) x t ↔ 0 ≤ t ∧ t ≤ max 0 (x+c) ∧ t ≤ max 0 (x+b) := by
  unfold band; omega

-- Both caps must come from the same premise. The solver tries a fixed
-- caller arm for the second conjunct, then validates the resulting guard.
theorem joint_coverage (f a b g h : Int) :
    max f (min a b) ≤ max g h ↔
    f ≤ max g h ∧ ((a ≤ g ∨ b ≤ g) ∨ (a ≤ h ∨ b ≤ h)) := by omega

-- Doubling the rate in the second cap leaves a six-atom exact scheme.
theorem double_rate {q e d x : Int} :
    allows (min (19*q) (19*q-2*e)) (20*q) e d x ↔
    0 ≤ e ∧ d ≤ q+2*e ∧ e ≤ max 0 d ∧ e ≤ max 0 (x+20*q) := by
  unfold allows; omega

theorem double_rate_certificate (q e d : Int) :
    TwoCaps (19*q) (19*q-2*e) (20*q) e d q
      (fun _ x => 0 ≤ e ∧ d ≤ q+2*e ∧ e ≤ max 0 d ∧ e ≤ max 0 (x+20*q))
      (fun _ x t => band (19*q-2*e) x t) := by
  constructor
  · intros; omega
  · unfold band; intros; omega
  · unfold band; intros; omega
  · unfold band; intros; omega

theorem double_rate_clients {q : Int} (hq : 0 < q) :
    allows (min (19*q) (19*q-2*0)) (20*q) 0 (-q) (-21*q) ∧
    allows (min (19*q) (19*q-2*q)) (20*q) q q (-19*q) := by
  unfold allows; omega

-- At the attached rising call p=3, m=-16, d=e=1, the child has x=-19.
-- Raising its first cap to 20 admits a payload the parent cannot consume.
theorem jump_loses_call :
    band (min 20 (22-2*1)) (-19) 1 ∧
    ¬ band 20 (-19) (1+1) ∧ ¬ band (min 19 (22-2*1)) (-19) 1 := by unfold band; decide

end MovingFloor
