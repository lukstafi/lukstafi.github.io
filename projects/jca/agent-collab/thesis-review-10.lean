import Std

namespace FailedGuesses

def DisjointOn {α : Type} (A D : α → Prop) := ∀ x, A x → D x → False

-- Exactly when *every* infeasibility cut learned at D remains valid at E.
theorem transport_coverage {α : Type} (D E : α → Prop) :
    (∀ A B : α → Prop, (∀ x, B x → A x) →
      DisjointOn A D → DisjointOn B E) ↔ (∀ x, E x → D x) := by
  constructor
  · intro reuse x hx
    apply Classical.byContradiction
    intro missing
    let single := fun t : α => t = x
    have old : DisjointOn single D := by
      intro t ht hd
      exact missing (ht ▸ hd)
    exact reuse single single (fun _ h => h) old x rfl hx
  · intro subset A B stronger cut x hb he
    exact cut x (stronger x hb) (subset x he)

-- All nonempty refinements fail a pointwise obligation exactly when every
-- point admitted by the original guess fails it.
theorem no_refinement {α : Type} (A G : α → Prop) :
    (∀ B : α → Prop, (∃ x, B x) → (∀ x, B x → A x) → ¬ (∀ x, B x → G x)) ↔
      (∀ x, A x → ¬ G x) := by
  constructor
  · intro no x ha hg
    exact no (fun t => t = x) ⟨x, rfl⟩
      (fun _ h => h ▸ ha) (fun _ h => h ▸ hg)
  · rintro all B ⟨x, hx⟩ subset good
    exact all x (subset x hx) (good x hx)

-- Endpoint elimination is exact under this strict comparison.
theorem forced_arm (p u a b : Int) (miss : a < p) :
    max p u ≤ max a b ↔ p ≤ b ∧ u ≤ b := by omega

abbrev Input := Int → Int → Int → Prop
abbrev Result := Int → Int → Int → Int → Prop

-- Arguments are the cap increment d, floor p and cap parameter m.
structure Contract (P : Input) (R : Result) : Prop where
  recursive : ∀ d p m, P d p m → P d (p+1) (m+d)
  base : ∀ d p m, P d p m → R d p m p
  caller : ∀ d p m r, P d p m → R d (p+1) (m+d) r →
    p ≤ r ∧ r ≤ max (m+20) p
  payload : ∀ d p m r u, P d p m → R d (p+1) (m+d) r →
    p ≤ r → r ≤ max (m+20) p → p ≤ u → u ≤ r+1 → u ≤ m+18 → R d p m u

def cut : Input := fun _ p m => p ≤ m+19
def good : Input := fun d p m => 1 ≤ d ∧ d ≤ 2 ∧ cut d p m
def band : Result := fun _ p m r => p ≤ r ∧ r ≤ max p (m+18)

-- No choice of result predicate can make the rejected input inductive.
theorem cut_fails (R : Result) : ¬ Contract cut R := by
  intro h
  have next := h.recursive 0 19 0 (by unfold cut; decide)
  exact (by change ¬ ((19 : Int)+1 ≤ 0+0+19); decide : ¬ cut 0 (19+1) (0+0)) next

-- Nevertheless every solution entails the rejected input atom.
theorem cut_is_necessary {P R} (h : Contract P R) (d p m : Int) (hp : P d p m) :
    cut d p m := by
  have supplies := h.base _ _ _ (h.recursive _ _ _ hp)
  have upper := (h.caller _ _ _ _ hp supplies).2
  unfold cut
  omega

theorem valid_refinement : Contract good band := by
  constructor
  · unfold good cut; intros; omega
  · unfold band; intros; omega
  · unfold good cut band; intros; constructor <;> omega
  · unfold band; intros; constructor <;> omega

theorem boundary : good 1 19 0 ∧ good 2 19 0 ∧ ¬ good 3 19 0 := by unfold good cut; decide

-- With a fixed result relation, collect its local obligations in safe and
-- its recursive input obligations in edge. Input domains are closed under union.
theorem union_inputs {α ι : Type} (safe : α → Prop) (edge : α → α → Prop)
    (P : ι → α → Prop)
    (ok : ∀ i x, P i x → safe x ∧ ∀ y, edge x y → P i y) :
    ∀ x, (∃ i, P i x) → safe x ∧ ∀ y, edge x y → ∃ i, P i y := by
  rintro x ⟨i, hx⟩
  obtain ⟨valid, recur⟩ := ok i x hx
  exact ⟨valid, fun y h => ⟨i, recur y h⟩⟩

-- Specialize the maximal-domain theorem of review 8 to c=19, L=20.
theorem shift_regions (p m e d : Int) :
    (0 ≤ e ∧ d ≤ 1 ∧ e ≤ max 0 d ∧ e ≤ max 0 (m-p+20)) ↔
      ((e = 0 ∧ d ≤ 1) ∨ (e = 1 ∧ d = 1 ∧ p ≤ m+19)) := by omega

end FailedGuesses
