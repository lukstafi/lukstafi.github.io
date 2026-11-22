import «thesis-review-25»

open MatchContracts

namespace FixedPackages

/-- h is an admitted arrow instance. A strategy w respects the program's
    quantifier prefix. Locally checks its nonrecursive work at the fixed
    result relations, and Calls lists the arrow instances it can use. -/
structure Body (H W : Type) where
  Locally : H → W → Prop
  Calls : H → W → H → Prop

def Step (b : Body H W) (s : H → Prop) (h : H) :=
  ∃ w, b.Locally h w ∧ ∀ j, b.Calls h w j → s j

def Closed (b : Body H W) (s : H → Prop) := ∀ h, s h → Step b s h
def Largest (b : Body H W) (h : H) := ∃ s, Closed b s ∧ s h

theorem step_mono (b : Body H W) {s t : H → Prop} (sub : ∀ h, s h → t h)
    (h : H) : Step b s h → Step b t h := by
  rintro ⟨w, localOK, calls⟩
  exact ⟨w, localOK, fun j hj => sub j (calls j hj)⟩

theorem closed_largest (b : Body H W) : Closed b (Largest b) := by
  rintro h ⟨s, closed, sh⟩
  exact step_mono b (fun j sj => ⟨s, closed, sj⟩) h (closed h sh)

theorem largest_fixed (b : Body H W) (h : H) : Largest b h ↔ Step b (Largest b) h := by
  exact ⟨closed_largest b h, fun ok => ⟨Step b (Largest b), step_mono b (closed_largest b), ok⟩⟩

theorem eliminate_calls (b : Body H W) (demand : (H → Prop) → Prop)
    (up : ∀ s t, (∀ h, s h → t h) → demand s → demand t) :
    (∃ s, Closed b s ∧ demand s) ↔ demand (Largest b) := by
  constructor
  · rintro ⟨s, closed, d⟩
    exact up s _ (fun h sh => ⟨s, closed, sh⟩) d
  · exact fun d => ⟨Largest b, closed_largest b, d⟩

end FixedPackages

namespace FixedResult

def Upper (r : K → Int → Prop) (k : K) (b : Int) := ∀ o, r k o → o ≤ b
def Above (r : K → Int → Prop) (k : K) (a : Int) := ∀ o, r k o → a < o

/-- External A, external B, and recursive B. The quantifiers are independent. -/
def ThreeUses (a b : Int) (r : Int → Int → Prop) :=
  (∃ k, r k a ∧ Upper r k b) ∧ (∃ k, r k b ∧ Upper r k b) ∧
  ∃ k, r k b ∧ Above r k a

theorem eliminate_arrows (a b : Int) (r : Int → Int → Prop) :
    (∃ x, NumericRows a b x r) ↔ ThreeUses a b r := by
  constructor
  · rintro ⟨x, _, produce, clients⟩
    obtain ⟨ka, xa, ca⟩ := clients 0 (Or.inl rfl)
    obtain ⟨kb, xb, cb⟩ := clients 1 (Or.inr rfl)
    obtain ⟨t, inst, base, _, ht, hb, ra, _, atA, _⟩ := produce 0 ka xa
    have baseA : base = a := hb.trans (ht.trans (atA rfl).1)
    obtain ⟨u, inst', base', succ, hu, hb', rb, _, _, atB⟩ := produce 1 kb xb
    obtain ⟨ub, j, xj, step⟩ := atB rfl
    have baseB : base' = b := hb'.trans (hu.trans ub)
    obtain ⟨v, inst'', base'', _, hv, hb'', rj, _, _, inner⟩ := produce 1 j xj
    have recB : base'' = b := hb''.trans (hv.trans (inner rfl).1)
    refine ⟨⟨ka, baseA ▸ ra, ca⟩, ⟨kb, baseB ▸ rb, cb⟩, j, recB ▸ rj, ?_⟩
    intro o ro
    obtain ⟨_, guard⟩ := step o ro
    omega
  · rintro ⟨⟨ka, ra, ca⟩, ⟨kb, rb, cb⟩, ⟨kj, rj, guard⟩⟩
    let x := fun (i k : Int) => (i = 0 ∧ k = ka) ∨ (i = 1 ∧ (k = kb ∨ k = kj))
    have xa : x 0 ka := Or.inl ⟨rfl, rfl⟩
    have xb : x 1 kb := Or.inr ⟨rfl, Or.inl rfl⟩
    have xj : x 1 kj := Or.inr ⟨rfl, Or.inr rfl⟩
    refine ⟨x, ⟨0, ka, xa⟩, ?_, ?_⟩
    · intro i k call
      rcases call with ⟨rfl, rfl⟩ | ⟨rfl, keys⟩
      · exact ⟨a, a, a, a, rfl, rfl, ra, ra, fun _ => ⟨rfl, rfl⟩, by omega⟩
      · have allowed : r k b := keys.elim (fun h => h ▸ rb) (fun h => h ▸ rj)
        exact ⟨b, b, b, b, rfl, rfl, allowed, allowed, by omega,
          fun _ => ⟨rfl, kj, xj, fun o ro => ⟨rfl, by have := guard o ro; omega⟩⟩⟩
    · rintro i (rfl | rfl)
      · exact ⟨ka, xa, ca⟩
      · exact ⟨kb, xb, cb⟩

def Interval (w k o : Int) := k ≤ o ∧ o ≤ k+w

theorem arbitrary_width (a b w : Int) (gap : a < b) (width : 0 ≤ w) :
    ∃ x, NumericRows a b x (Interval w) := by
  apply (eliminate_arrows ..).2
  refine ⟨⟨a-w, ⟨by omega, by omega⟩, fun _ ⟨_, h⟩ => by omega⟩,
          ⟨b-w, ⟨by omega, by omega⟩, fun _ ⟨_, h⟩ => by omega⟩,
          b, ⟨by omega, by omega⟩, fun _ ⟨h, _⟩ => by omega⟩

/-- The width-w source annotation admits every interval containing the
    exact output, including on indices with no state constructor. -/
theorem written_width (a b w : Int) (gap : a < b) (width : 0 ≤ w) :
    let f := fun i => (b-a)*i+a
    NumericRows a b (fun i k => Interval w k (f i)) (Interval w) := by
  dsimp only
  have atA : (b-a)*0+a = a := by simp
  have atB : (b-a)*1+a = b := by simp
  refine ⟨⟨0, a, ?_⟩, ?_, ?_⟩
  · simp only [atA]
    exact ⟨by omega, by omega⟩
  · intro i k call
    let v := (b-a)*i+a
    refine ⟨v, v, v, v, rfl, rfl, call, call, ?_, ?_⟩
    · rintro rfl
      exact ⟨atA, atA⟩
    · rintro rfl
      refine ⟨atB, b, ?_, fun _ ⟨floor, _⟩ => ⟨atB, by omega⟩⟩
      simp only [atB]
      exact ⟨by omega, by omega⟩
  · rintro i (rfl | rfl)
    · simp only [atA]
      exact ⟨a-w, ⟨by omega, by omega⟩, fun _ ⟨_, h⟩ => by omega⟩
    · simp only [atB]
      exact ⟨b-w, ⟨by omega, by omega⟩, fun _ ⟨_, h⟩ => by omega⟩

def OneAtB (x : Int → Int → Prop) := ∀ k j, x 1 k → x 1 j → k = j

theorem single_width_iff (a b w : Int) (gap : a < b) (width : 0 ≤ w) :
    (∃ x, NumericRows a b x (Interval w) ∧ OneAtB x) ↔ w < b-a := by
  constructor
  · rintro ⟨x, ⟨_, produce, clients⟩, single⟩
    obtain ⟨k, xk, cap⟩ := clients 1 (Or.inr rfl)
    obtain ⟨_, _, _, succ, _, _, _, _, _, step⟩ := produce 1 k xk
    obtain ⟨_, j, xj, recStep⟩ := step rfl
    obtain rfl := single k j xk xj
    have top := cap (k+w) ⟨by omega, by omega⟩
    obtain ⟨_, bad⟩ := recStep k ⟨by omega, by omega⟩
    omega
  · intro fits
    let x := fun (i k : Int) => (i = 0 ∧ k = a-w) ∨ (i = 1 ∧ k = b-w)
    have xa : x 0 (a-w) := Or.inl ⟨rfl, rfl⟩
    have xb : x 1 (b-w) := Or.inr ⟨rfl, rfl⟩
    refine ⟨x, ⟨⟨0, a-w, xa⟩, ?_, ?_⟩, ?_⟩
    · rintro _ _ (⟨rfl, rfl⟩ | ⟨rfl, rfl⟩)
      · have base : Interval w (a-w) a := ⟨by omega, by omega⟩
        exact ⟨a, a, a, a, rfl, rfl, base, base, fun _ => ⟨rfl, rfl⟩, by omega⟩
      · have base : Interval w (b-w) b := ⟨by omega, by omega⟩
        exact ⟨b, b, b, b, rfl, rfl, base, base, by omega,
          fun _ => ⟨rfl, b-w, xb, fun _ ⟨lo, _⟩ => ⟨rfl, by omega⟩⟩⟩
    · rintro _ (rfl | rfl)
      · exact ⟨a-w, xa, fun _ ⟨_, hi⟩ => by omega⟩
      · exact ⟨b-w, xb, fun _ ⟨_, hi⟩ => by omega⟩
    · intro k j ck cj
      rcases ck with ⟨h, _⟩ | ⟨_, h⟩ <;> rcases cj with ⟨h', _⟩ | ⟨_, h'⟩ <;> omega

/-- A fixed relation can force three distinct call coordinates. -/
def threeFibers (k o : Int) :=
  (k = 0 ∧ o = 0) ∨ (k = 1 ∧ (o = -1 ∨ o = 1)) ∨ (k = 2 ∧ (o = 1 ∨ o = 2))

theorem sharp_three : ThreeUses 0 1 threeFibers ∧
    (∀ k, threeFibers k 0 ∧ Upper threeFibers k 1 → k = 0) ∧
    (∀ k, threeFibers k 1 ∧ Upper threeFibers k 1 → k = 1) ∧
    (∀ k, threeFibers k 1 ∧ Above threeFibers k 0 → k = 2) := by
  have hi : threeFibers 2 2 := by unfold threeFibers; decide
  have lo : threeFibers 1 (-1) := by unfold threeFibers; decide
  constructor
  · refine ⟨⟨0, by unfold threeFibers; decide, ?_⟩, ⟨1, by unfold threeFibers; decide, ?_⟩, 2, by unfold threeFibers; decide, ?_⟩ <;>
      intro o h <;> unfold threeFibers at h <;> omega
  · refine ⟨?_, ?_, ?_⟩
    · rintro k ⟨h, _⟩
      unfold threeFibers at h
      omega
    · rintro k ⟨h, cap⟩
      have ne : k ≠ 2 := fun eq => by have := cap 2 (eq ▸ hi); omega
      unfold threeFibers at h
      omega
    · rintro k ⟨h, floor⟩
      have ne : k ≠ 1 := fun eq => by have := floor (-1) (eq ▸ lo); omega
      unfold threeFibers at h
      omega

end FixedResult

namespace AffineFit

/-- Rational slopes in integer coordinates, with denominators cleared.
    This row is a consequence of any affine graph through the two points,
    and on a nonvertical pair defines exactly that graph. -/
def Secant (x₀ y₀ x₁ y₁ x y : Int) := (x₁-x₀)*(y-y₀) = (y₁-y₀)*(x-x₀)

theorem anchors (x₀ y₀ x₁ y₁ : Int) :
    Secant x₀ y₀ x₁ y₁ x₀ y₀ ∧ Secant x₀ y₀ x₁ y₁ x₁ y₁ := by
  simp [Secant, Int.mul_comm]

theorem unique_graph (d n x₀ y₀ x₁ y₁ x y : Int) (den : d ≠ 0) (different : x₁ ≠ x₀)
    (second : d*(y₁-y₀) = n*(x₁-x₀)) :
    Secant x₀ y₀ x₁ y₁ x y ↔ d*(y-y₀) = n*(x-x₀) := by
  have dx : x₁-x₀ ≠ 0 := by omega
  have scaled : d*((y₁-y₀)*(x-x₀)) = (x₁-x₀)*(n*(x-x₀)) := by
    rw [← Int.mul_assoc, second]
    ac_rfl
  constructor
  · intro h
    apply Int.eq_of_mul_eq_mul_left dx
    calc (x₁-x₀)*(d*(y-y₀)) = d*((x₁-x₀)*(y-y₀)) := by ac_rfl
         _ = d*((y₁-y₀)*(x-x₀)) := congrArg (d*·) h
         _ = _ := scaled
  · intro h
    apply Int.eq_of_mul_eq_mul_left den
    calc d*((x₁-x₀)*(y-y₀)) = (x₁-x₀)*(d*(y-y₀)) := by ac_rfl
         _ = (x₁-x₀)*(n*(x-x₀)) := congrArg ((x₁-x₀)*·) h
         _ = _ := scaled.symm

end AffineFit
