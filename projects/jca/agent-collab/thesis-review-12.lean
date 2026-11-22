import Std

namespace WitnessAlignment

-- The observable point is fixed. R selects its admissible witness assignments.
def Compatible {I K α : Type} (name : I → K) (u : I → α) : Prop :=
  ∀ i j, name i = name j → u i = u j

theorem factors_iff {I K α : Type} [Inhabited α] (name : I → K) (u : I → α) :
    (∃ v : K → α, ∀ i, v (name i) = u i) ↔ Compatible name u := by
  constructor
  · rintro ⟨v, h⟩ i j same
    rw [← h i, ← h j, same]
  · intro h
    classical
    let v (k : K) := if p : ∃ i, name i = k then u (Classical.choose p) else default
    refine ⟨v, fun i => ?_⟩
    have p : ∃ j, name j = name i := ⟨i, rfl⟩
    simp only [v, dif_pos p]
    exact h _ i (Classical.choose_spec p)

theorem preserves_point {I K α : Type} [Inhabited α] (name : I → K)
    (R : (I → α) → Prop) :
    (∃ v : K → α, R (v ∘ name)) ↔ ∃ u, R u ∧ Compatible name u := by
  constructor
  · rintro ⟨v, h⟩
    exact ⟨v ∘ name, h, (factors_iff name _).mp ⟨v, fun _ => rfl⟩⟩
  · rintro ⟨u, h, comp⟩
    obtain ⟨v, hv⟩ := (factors_iff name u).mpr comp
    have eq : v ∘ name = u := funext hv
    exact ⟨v, eq ▸ h⟩

-- Two values suffice to distinguish any pair of independent names.
theorem uniform_iff_injective {I K : Type} (name : I → K) :
    (∀ R : (I → Bool) → Prop, (∃ u, R u) → ∃ v, R (v ∘ name)) ↔
      (∀ i j, name i = name j → i = j) := by
  classical
  constructor
  · intro all i j same
    let u : I → Bool := fun t => decide (i = t)
    obtain ⟨v, h⟩ := all (fun w => w = u) ⟨u, rfl⟩
    have comp := (factors_iff name u).mp ⟨v, fun t => congrFun h t⟩
    have eq := comp i j same
    simpa [u] using eq
  · intro inj R has
    obtain ⟨u, hu⟩ := has
    exact (preserves_point name R).mpr ⟨u, hu, fun i j h => congrArg u (inj i j h)⟩

def inferred (x y : Int) := 0 ≤ x ∧ y ≤ 2*x ∧ x = min 1 y

theorem three_pairs (x y : Int) :
    inferred x y ↔ (x = 0 ∧ y = 0) ∨ (x = 1 ∧ y = 1) ∨ (x = 1 ∧ y = 2) := by
  unfold inferred; omega

theorem pair_step {x y : Int} (h : inferred x y) : inferred 1 (x+1) := by
  unfold inferred at *; omega

-- At cap 1 the successor is (1,x+1) at every reachable state.
def next (cap : Nat) (p : Nat × Nat) := (min cap (p.1+1), p.1+1)

def pairAt (cap : Nat) : Nat → Nat × Nat
  | 0 => (0, 0)
  | n+1 => next cap (pairAt cap n)

theorem pairAt_closed (cap depth : Nat) :
    pairAt cap depth = (min cap depth, min (cap+1) depth) := by
  induction depth with
  | zero => simp [pairAt]
  | succ n ih =>
    simp only [pairAt, next, ih]
    congr 1 <;> omega

theorem diagonal_iff (cap depth : Nat) :
    (pairAt cap depth).1 = (pairAt cap depth).2 ↔ depth ≤ cap := by
  rw [pairAt_closed]; dsimp; omega

def band (cap : Nat) (p : Nat × Nat) := p.1 = min cap p.2 ∧ p.2 ≤ cap+1

theorem band_inductive {cap : Nat} {p : Nat × Nat} (h : band cap p) :
    band cap (next cap p) := by
  obtain ⟨hx, _⟩ := h
  exact ⟨rfl, by change p.1+1 ≤ cap+1; omega⟩

theorem exact_band (cap : Nat) (p : Nat × Nat) :
    band cap p ↔ ∃ depth, pairAt cap depth = p := by
  obtain ⟨x, y⟩ := p
  constructor
  · intro h
    refine ⟨y, ?_⟩
    rw [pairAt_closed]
    simp only [band] at h
    congr 1 <;> omega
  · rintro ⟨d, hd⟩
    rw [← hd, pairAt_closed]
    unfold band
    dsimp
    omega

-- With only an upper-bound client, the greatest safe invariant is a box.
theorem greatest_safe {m x y : Int} (hm : 0 ≤ m) :
    (x ≤ m ∧ y ≤ m+1) ↔
    ∃ S : Int → Int → Prop, S x y ∧ S 0 0 ∧
      (∀ a b, S a b → S (min m (a+1)) (a+1)) ∧
      (∀ a b, S a b → b ≤ m+1) := by
  constructor
  · intro h
    refine ⟨fun a b => a ≤ m ∧ b ≤ m+1, h, ⟨hm, by omega⟩, ?_, ?_⟩
    · rintro a b ⟨ha, _⟩
      exact ⟨by omega, by omega⟩
    · rintro a b ⟨_, hb⟩
      exact hb
  · rintro ⟨S, hp, _, step, safe⟩
    have hs := safe _ _ (step x y hp)
    exact ⟨by omega, safe x y hp⟩

end WitnessAlignment
