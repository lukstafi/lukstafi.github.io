import Mathlib.Algebra.Group.Action.Defs
import Mathlib.Data.Rat.Cast.Order
import Mathlib.Tactic.Linarith

namespace NeutralFields

variable {G X E : Type*} [Group G] [MulAction G X]

/-- Restore neutral words by taking all group translates of an invariant
    for the expanding macro-steps. Convexifying the union in the linear
    setting preserves these guard and transition obligations. -/
theorem saturate (P : X → Prop) (guard : X → Prop) (expand : E → X → X)
    (legal : ∀ x, P x → ∀ h : G, guard (h • x))
    (closed : ∀ x, P x → ∀ (e : E) (h : G), P (expand e (h • x))) :
    let S := fun y => ∃ h : G, ∃ x, P x ∧ h • x = y
    (∀ x, P x → S x) ∧ (∀ y, S y → guard y) ∧
      (∀ (h : G) y, S y → S (h • y)) ∧ (∀ e y, S y → S (expand e y)) := by
  dsimp only
  refine ⟨fun x hx => ⟨1,x,hx,one_smul G x⟩, ?_, ?_, ?_⟩
  · rintro y ⟨h,x,hx,rfl⟩
    exact legal x hx h
  · rintro h y ⟨g,x,hx,rfl⟩
    exact ⟨h*g,x,hx,mul_smul h g x⟩
  · rintro e y ⟨h,x,hx,rfl⟩
    exact ⟨1,_,closed x hx e h,one_smul G _⟩

/-- Conversely, a typing for all original moves covers every macro-step. -/
theorem macro_closed (P : X → Prop) (expand : E → X → X)
    (neutral : ∀ (h : G) x, P x → P (h • x)) (growth : ∀ e x, P x → P (expand e x)) :
    ∀ x, P x → ∀ (e : E) (h : G), P (expand e (h • x)) :=
  fun x hx e h => growth e _ (neutral h x hx)

/-- Checking both endpoint guards checks all slopes in their interval,
    for either sign of the actual slack (including recession generators). -/
theorem slope_interval {a c t lo r hi : ℚ} (low : lo ≤ r) (high : r ≤ hi)
    (first : a ≤ c + lo*t) (last : a ≤ c + hi*t) : a ≤ c + r*t := by
  rcases le_total 0 t with ht | ht
  · linarith only [first, mul_le_mul_of_nonneg_right low ht]
  · linarith only [last, mul_le_mul_of_nonpos_right high ht]

end NeutralFields
