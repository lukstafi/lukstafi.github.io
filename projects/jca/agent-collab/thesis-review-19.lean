import Std

namespace BranchEquations

/-- The two obligations have identical truth values at each assignment.
    Any outer quantifiers or witness choices can therefore be preserved. -/
theorem reduce_under_guard {S : Type} (g c : S → Prop) (subst : S → S)
    (fixed : ∀ x, g x → subst x = x) (x : S) :
    (g x → c x) ↔ (g x → c (subst x)) := by
  constructor <;> intro h hg <;> simpa [fixed x hg] using h hg

/-- A solved substitution parametrizes the guard exactly. Equality of the
    resulting functions is equivalent to agreement on the guarded rows. -/
theorem normal_forms {S P V : Type} (g : S → Prop) (fill : P → S)
    (image : ∀ x, g x ↔ ∃ p, fill p = x) (f h : S → V) :
    (∀ x, g x → f x = h x) ↔ ∀ p, f (fill p) = h (fill p) := by
  constructor
  · exact fun same p => same _ ((image _).mpr ⟨p, rfl⟩)
  · intro same x gx
    obtain ⟨p, rfl⟩ := (image x).mp gx
    exact same p

theorem child_payload (p e q r t : Int) (floor : q = p + e)
    (tag : t = q + r) : t - p - e = r := by omega

/-- A signed affine tag has the same caller demand, including at a moving
    recursive input. The predicate can inspect the entire recovered payload. -/
theorem affine_caller (k b p e q r tag : Int) (floor : q = p + e)
    (graph : tag = r + k * q + b) (demand : Int → Prop) :
    demand (tag - k * p - k * e - b) ↔ demand r := by
  rw [floor, Int.mul_add] at graph
  have recover : tag - k * p - k * e - b = r := by omega
  rw [recover]

/-- An upper test on a tag can forget a private choice of floor exactly
    when all its thresholds agree. The empty set of choices is allowed. -/
theorem hide_floor {E : Type} (cap : E → Int) :
    (∃ D : Int → Prop, ∀ e s, D s ↔ s ≤ cap e) ↔ ∀ e f, cap e = cap f := by
  constructor
  · rintro ⟨D, test⟩ e f
    have le (i j : E) : cap i ≤ cap j :=
      (test j _).mp ((test i _).mpr (Int.le_refl _))
    exact Int.le_antisymm (le e f) (le f e)
  · intro same
    refine ⟨fun s => ∀ f, s ≤ cap f, ?_⟩
    intro e s
    constructor
    · exact fun h => h e
    · intro h f
      rwa [← same e f]

/-- The supplier on pass 2 also gives a lower bound. A common caller test
    exists precisely when every safe endpoint is safe wherever it is feasible. -/
theorem hide_with_lower {E : Type} (lo cap : E → Int) :
    (∃ D : Int → Prop, ∀ e s, lo e ≤ s → (D s ↔ s ≤ cap e)) ↔
    ∀ i j, lo i ≤ cap i → lo j ≤ cap i → cap i ≤ cap j := by
  constructor
  · rintro ⟨D, test⟩ i j hi hj
    exact (test j _ hj).mp ((test i _ hi).mpr (Int.le_refl _))
  · intro endpoints
    refine ⟨fun s => ∃ f, lo f ≤ s ∧ s ≤ cap f, ?_⟩
    intro e s he
    constructor
    · rintro ⟨f, hf, hcap⟩
      exact Int.le_trans hcap (endpoints f e (Int.le_trans hf hcap) (Int.le_trans he hcap))
    · exact fun h => ⟨e, he, h⟩

theorem hide_with_live_bounds {E : Type} (lo cap : E → Int) (live : ∀ i, lo i ≤ cap i) :
    (∃ D : Int → Prop, ∀ e s, lo e ≤ s → (D s ↔ s ≤ cap e)) ↔
    ∀ i j, cap i = cap j := by
  rw [hide_with_lower]
  constructor
  · intro ends i j
    have le (a b : E) : cap a ≤ cap b := by
      by_cases h : cap a ≤ cap b
      · exact h
      · have hb := live b
        exact ends a b (live a) (by omega)
    exact Int.le_antisymm (le i j) (le j i)
  · intro same i j _ _
    rw [same i j]
    exact Int.le_refl _

theorem two_floors (upper k : Int) :
    (∃ D : Int → Prop, ∀ (rise : Bool) s,
      D s ↔ s ≤ (if rise then upper + k else upper)) ↔ k = 0 := by
  rw [hide_floor (fun rise : Bool => if rise then upper + k else upper)]
  constructor
  · intro h
    have same := h false true
    simp at same
    omega
  · rintro rfl e f
    simp

inductive Connected {I : Type} (edges : I → I → Prop) : I → I → Prop
  | refl (i) : Connected edges i i
  | edge {i j} : edges i j → Connected edges i j
  | symm {i j} : Connected edges i j → Connected edges j i
  | trans {i j k} : Connected edges i j → Connected edges j k → Connected edges i k

/-- With two distinguishable values, conjunctions of aliases imply exactly
    the equalities inside the connected components of the retained edges. -/
theorem aliases {I V : Type} (a b : V) (different : a ≠ b)
    (edges : I → I → Prop) (i j : I) :
    (∀ f : I → V, (∀ x y, edges x y → f x = f y) → f i = f j) ↔ Connected edges i j := by
  classical
  constructor
  · intro forces
    apply Classical.byContradiction
    intro apart
    let f := fun k => if Connected edges i k then a else b
    have respects (x y : I) (e : edges x y) : f x = f y := by
      have iff : Connected edges i x ↔ Connected edges i y :=
        ⟨fun h => .trans h (.edge e), fun h => .trans h (.symm (.edge e))⟩
      by_cases hx : Connected edges i x
      · simp [f, hx, iff.mp hx]
      · have hy : ¬ Connected edges i y := fun h => hx (iff.mpr h)
        simp [f, hx, hy]
    exact different (by simpa [f, Connected.refl i, apart] using forces f respects)
  · intro path f respects
    induction path with
    | refl => rfl
    | edge h => exact respects _ _ h
    | symm _ ih => exact ih.symm
    | trans _ _ ih₁ ih₂ => exact ih₁.trans ih₂

/-- A repivot preserves the other rows when they read its new right-hand side. -/
theorem exchange {S A B : Type} (rhs : S → B → A) (inverse : S → A → B)
    (pivot : ∀ s a b, a = rhs s b ↔ b = inverse s a)
    (other : S → A → B → Prop) (s : S) (a : A) (b : B) :
    (a = rhs s b ∧ other s a b) ↔ (b = inverse s a ∧ other s a (inverse s a)) := by
  constructor
  · rintro ⟨eq, rest⟩
    have h := (pivot s a b).mp eq
    exact ⟨h, h ▸ rest⟩
  · rintro ⟨h, rest⟩
    exact ⟨(pivot s a b).mpr h, h.symm ▸ rest⟩

end BranchEquations
