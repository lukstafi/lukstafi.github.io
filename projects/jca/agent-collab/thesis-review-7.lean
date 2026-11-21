import Std

namespace ConstructorCover

variable {X I A : Type}

-- A fixed threshold on the returned index is one arm. A supplier valuation
-- outside that arm must satisfy the other arm, at the definition's variables.
def validPair (branch : I → X → Prop) (guard other : X → Prop) : Prop :=
  ∀ i x, branch i x → guard x ∨ other x

theorem outside_guard {branch : I → X → Prop} {guard other : X → Prop} :
    validPair branch guard other ↔ ∀ i x, branch i x → ¬guard x → other x := by
  classical
  constructor
  · intro h i x hx ng
    exact (h i x hx).resolve_left ng
  · intro h i x hx
    by_cases g : guard x
    · exact Or.inl g
    · exact Or.inr (h i x hx g)

-- Projecting private variables commutes with cutting out a public arm.
theorem cut_projection {Y : Type} (project : X → Y) (region : X → Prop)
    (guard : Y → Prop) (y : Y) :
    (∃ x, region x ∧ project x = y ∧ ¬guard (project x)) ↔
      (∃ x, region x ∧ project x = y) ∧ ¬guard y := by
  constructor
  · rintro ⟨x, h, rfl, ng⟩
    exact ⟨⟨x, h, rfl⟩, ng⟩
  · rintro ⟨⟨x, h, rfl⟩, ng⟩
    exact ⟨x, h, rfl, ng⟩

-- For a fixed payload direction v and a candidate affine right-hand side f,
-- s is a sufficient offset exactly when it bounds the gaps beyond the floor.
theorem offset_test (branch : I → X → Prop) (v f : X → Int) (floor s : Int) :
    validPair branch (fun x => v x ≤ floor) (fun x => v x ≤ f x + s) ↔
      ∀ i x, branch i x → floor < v x → v x - f x ≤ s := by
  rw [outside_guard]
  constructor <;> intro h i x hx ht <;> specialize h i x hx <;> omega

-- On the line r=m neither arm covers the whole line. Their union does.
theorem needs_both_arms :
    (∀ m : Int, m ≤ 0 ∨ m ≤ 2*m) ∧
    ¬(∀ m : Int, m ≤ 0) ∧ ¬(∀ m : Int, m ≤ 2*m) := by
  refine ⟨fun _ => by omega, ?_, ?_⟩
  · intro h; have := h 1; omega
  · intro h; have := h (-1); omega

-- Including the equality boundary in the residual would reject a valid cap
-- on the zero constructor.
theorem keep_boundary (m : Int) (h : m < -19) :
    (0 : Int) ≤ max 0 (m + 19) ∧ ¬(0 ≤ m + 19) := by omega

-- In positive numeric abduction, removing a provisional atom must preserve
-- every original branch under the remaining answer.
def solves (prem goal : I → X → Prop) (hyp : X → Prop) : Prop :=
  ∀ i x, hyp x → prem i x → goal i x

theorem deletion_test {prem goal : I → X → Prop} {kept atom : X → Prop}
    (old : solves prem goal (fun x => kept x ∧ atom x)) :
    solves prem goal kept ↔ ∀ i x, kept x → prem i x → ¬atom x → goal i x := by
  classical
  constructor
  · intro h i x hk hp _; exact h i x hk hp
  · intro h i x hk hp
    by_cases ha : atom x
    · exact old i x ⟨hk, ha⟩ hp
    · exact h i x hk hp ha

-- Once a deletion fails, removing further assumptions cannot make it pass.
theorem failed_deletion_persists {prem goal : I → X → Prop} {earlier later : X → Prop}
    (weaker : ∀ x, earlier x → later x) (failed : ¬solves prem goal earlier) :
    ¬solves prem goal later := by
  intro success
  exact failed (fun i x he hp => success i x (weaker x he) hp)

end ConstructorCover
