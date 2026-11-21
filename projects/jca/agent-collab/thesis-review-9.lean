import Std

namespace CallerBounds

-- A caller sees x. The predicate package carries only f x. Transporting
-- a demand to that package requires every admitted caller with these indices.
theorem transport {X Y V : Type} (P : X → Prop) (f : X → Y)
    (R : Y → V → Prop) (U : X → V → Prop) :
    (∀ x r, P x → R (f x) r → U x r) ↔
      (∀ y r, R y r → ∀ x, P x → f x = y → U x r) := by
  constructor
  · intro h y r hr x hp he
    exact h x r hp (he.symm ▸ hr)
  · intro h x r hp hr
    exact h (f x) r hr x hp rfl

-- q and s are the child indices. The parent indices are q-e and s-d.
theorem forgotten_shift (q s e L r : Int) :
    (∀ d : Int, r ≤ max (q-e) (s-d+L)) ↔ r ≤ q-e := by
  constructor
  · intro h
    have worst := h (s+L-(q-e))
    omega
  · intro h d
    omega

theorem bounded_shift (q s e L r B : Int) :
    (∀ d : Int, d ≤ B → r ≤ max (q-e) (s-d+L)) ↔
      r ≤ max (q-e) (s-B+L) := by
  constructor
  · intro h
    exact h B (Int.le_refl _)
  · intro h d hd
    omega

-- The premise admits its upper endpoint. A caller may test any payload in it.
theorem project_interval (lo hi a b : Int) (live : lo ≤ hi) :
    (∀ r : Int, lo ≤ r → r ≤ hi → r ≤ max a b) ↔ hi ≤ max a b := by
  constructor
  · intro h
    exact h hi live (Int.le_refl _)
  · intro h r _ hr
    exact Int.le_trans hr h

-- A moving endpoint and the weaker of two ordered consumer alternatives.
theorem projected_shift (lo m d c L p : Int)
    (live : lo ≤ m+d+c) (order : p ≤ m+L) :
    (∀ r : Int, lo ≤ r → r ≤ m+d+c → r ≤ max (m+L) p) ↔ d ≤ L-c := by
  rw [project_interval _ _ _ _ live]
  omega

-- Each alternative of a supplier can reach a different consumer alternative.
theorem cover_endpoints (u v a b : Int) :
    max u v ≤ max a b ↔ (u ≤ a ∨ u ≤ b) ∧ (v ≤ a ∨ v ≤ b) := by
  omega

-- A strictly rising floor forces the consumer's cap to be its active arm.
-- This also works when the supplying postcondition still contains a max.
theorem rising_payload (p m e d c L : Int) (rising : 0 < e) :
    (∀ r : Int, p+e ≤ r → r ≤ max (p+e) (m+d+c) → r ≤ max (m+L) p) ↔
      p+e ≤ m+L ∧ d ≤ L-c := by
  rw [project_interval _ _ _ _ (by omega)]
  omega

-- An input predicate may be any subset of the integers. Each transition is
-- available whenever that predicate holds. The selector is fixed on the orbit.
def Closed (guard : Prop) (steps : Int → Prop) (P : Int → Prop) : Prop :=
  (∀ x, P x → guard ∨ x ≤ 0) ∧ (∀ x k, P x → steps k → P (x+k))

private theorem can_grow {steps : Int → Prop} {P : Int → Prop}
    (step : ∀ x k, P x → steps k → P (x+k))
    {x k : Int} (start : P x) (allowed : steps k) (pos : 0 < k) (n : Nat) :
    ∃ y, P y ∧ x+(n : Int) ≤ y := by
  induction n with
  | zero => exact ⟨x, start, by omega⟩
  | succ n ih =>
    obtain ⟨y, hy, bound⟩ := ih
    exact ⟨y+k, step y k hy allowed, by omega⟩

-- The greatest input domain admitting every call and every finite call sequence.
theorem input_closure (guard : Prop) (steps : Int → Prop) (x : Int) :
    (∃ P, Closed guard steps P ∧ P x) ↔
      (guard ∨ x ≤ 0) ∧ (guard ∨ ∀ k, steps k → k ≤ 0) := by
  constructor
  · rintro ⟨P, ⟨test, step⟩, start⟩
    refine ⟨test x start, ?_⟩
    by_cases hg : guard
    · exact Or.inl hg
    · right
      intro k hk
      apply Classical.byContradiction
      intro denied
      have hp : 0 < k := by omega
      obtain ⟨y, hy, bound⟩ := can_grow step start hk hp ((-x).toNat+1)
      have safe := (test y hy).resolve_left hg
      omega
  · rintro ⟨initial, drift⟩
    refine ⟨fun y => guard ∨ y ≤ 0, ⟨fun _ h => h, ?_⟩, initial⟩
    intro y k hy hk
    rcases drift with hg | h
    · exact Or.inl hg
    · rcases hy with hg | nonpos
      · exact Or.inl hg
      · exact Or.inr (by have := h k hk; omega)

-- The child's base value must fit the parent limit at every recursive call.
-- Gap is measured as floor minus cap here, so its change is e-d.
theorem floor_test_closure (p m e d L : Int) :
    (∃ P, Closed (e ≤ 0) (fun k => k = e-d) P ∧ P (p+e-m-L)) ↔
      e ≤ max 0 (m-p+L) ∧ e ≤ max 0 d := by
  rw [input_closure]
  constructor
  · rintro ⟨base, drift⟩
    have h : e ≤ 0 ∨ e-d ≤ 0 := drift.imp_right (fun h => h (e-d) rfl)
    omega
  · intro h
    by_cases hg : e ≤ 0
    · exact ⟨Or.inl hg, Or.inl hg⟩
    · exact ⟨Or.inr (by omega), Or.inr (fun k hk => by change k = e-d at hk; omega)⟩

end CallerBounds
