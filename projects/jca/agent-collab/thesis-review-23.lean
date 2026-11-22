import Std

namespace JointPostconditions

abbrev Rel (A : Type) := A → Prop
def Sub (r s : Rel A) := ∀ a, r a → s a

/-- A is a tagged union of all the package relations' ground tuples.
    One rule instance records its shared first-order witnesses in its index. -/
structure Rules (A I : Type) where
  needs : I → List A
  gives : I → A

inductive Derives (h : Rules A I) : A → Prop where
  | step (i : I) (children : ∀ a ∈ h.needs i, Derives h a) : Derives h (h.gives i)

def Closed (h : Rules A I) (r : Rel A) :=
  ∀ i, (∀ a ∈ h.needs i, r a) → r (h.gives i)

theorem derives_closed (h : Rules A I) : Closed h (Derives h) := Derives.step

theorem derives_least (h : Rules A I) (r : Rel A) (closed : Closed h r) :
    Sub (Derives h) r := by
  intro a tree
  induction tree with
  | step i _ ih => exact closed i ih

/-- The same other predicates and legal witness strategy can be kept
    whenever the remaining obligations are downward closed in these results. -/
theorem eliminate_results (h : Rules A I) (clients : Rel A → Prop)
    (down : ∀ r s, Sub r s → clients s → clients r) :
    (∃ r, Closed h r ∧ clients r) ↔ clients (Derives h) := by
  constructor
  · rintro ⟨r, hr, hc⟩
    exact down _ _ (derives_least h r hr) hc
  · exact fun hc => ⟨_, derives_closed h, hc⟩

theorem eliminate_written (h : Rules A I) (clients written : Rel A → Prop)
    (down : ∀ r s, Sub r s → clients s → clients r) (expressible : written (Derives h)) :
    (∃ r, written r ∧ Closed h r ∧ clients r) ↔ clients (Derives h) := by
  constructor
  · rintro ⟨r, _, hr, hc⟩
    exact down _ _ (derives_least h r hr) hc
  · exact fun hc => ⟨_, expressible, derives_closed h, hc⟩

/-- Choosing witnesses for producer heads separately may destroy the
    least-model property. The two singleton solutions have empty intersection. -/
theorem head_choice_has_no_least :
    ¬ ∃ r : Rel Bool, (∃ b, r b) ∧ ∀ s : Rel Bool, (∃ b, s b) → Sub r s := by
  rintro ⟨r, ⟨b, hr⟩, least⟩
  have h := least (fun x => x = !b) ⟨!b, rfl⟩ b hr
  cases b <;> contradiction

/-- Even the *least* postcondition can have a one-inequality presentation
    while exact finite rounds grow forever over mathematical integers. -/
def oneStep (r : Int → Int → Prop) (i o : Int) :=
  o = i ∨ ∃ x, r i x ∧ o = x - 1

def approx : Nat → Int → Int → Prop
  | 0 => fun _ _ => False
  | k+1 => oneStep (approx k)

theorem approx_band (k : Nat) (i o : Int) :
    approx (k+1) i o ↔ i - (k : Int) ≤ o ∧ o ≤ i := by
  induction k generalizing o with
  | zero => simp [approx, oneStep]; omega
  | succ k ih =>
    change (o = i ∨ ∃ x, approx (k+1) i x ∧ o = x - 1) ↔ _
    constructor
    · rintro (h | ⟨x, hx, eq⟩)
      · omega
      · have hb := (ih x).mp hx; omega
    · intro h
      by_cases eq : o = i
      · exact Or.inl eq
      · exact Or.inr ⟨o+1, (ih (o+1)).mpr (by omega), by omega⟩

theorem strict_at_every_round (k : Nat) (i : Int) :
    ∃ o, approx (k+2) i o ∧ ¬ approx (k+1) i o := by
  refine ⟨i - (k+1 : Nat), (approx_band (k+1) ..).mpr (by omega), ?_⟩
  intro h
  have hb := (approx_band k ..).mp h
  omega

theorem least_band (i o : Int) : (∃ k, approx k i o) ↔ o ≤ i := by
  constructor
  · rintro ⟨_ | k, h⟩
    · exact False.elim h
    · exact ((approx_band k ..).mp h).2
  · intro h
    exact ⟨(i-o).toNat+1, (approx_band _ ..).mpr (by omega)⟩

/-- The declared primitive may also keep its argument. Adding this
    alternative gives precisely the same finite stages, including stage 0. -/
def rangeApprox : Nat → Int → Int → Prop
  | 0 => fun _ _ => False
  | k+1 => fun i o => o = i ∨ ∃ x, rangeApprox k i x ∧ x ≤ o+1 ∧ o ≤ x

theorem range_stages (k : Nat) (i o : Int) : rangeApprox k i o ↔ approx k i o := by
  induction k generalizing o with
  | zero => rfl
  | succ k ih =>
    constructor
    · rintro (eq | ⟨x, hx, h₁, h₂⟩)
      · exact Or.inl eq
      · have prev := (ih x).mp hx
        cases k with
        | zero => exact False.elim prev
        | succ n =>
          have hb := (approx_band n ..).mp prev
          exact (approx_band (n+1) ..).mpr (by omega)
    · rintro (eq | ⟨x, hx, eq⟩)
      · exact Or.inl eq
      · exact Or.inr ⟨x, (ih x).mpr hx, by omega, by omega⟩

/-- C is the part of the item retained in every retry. Rows with a
    selected body must establish false from their full success premise. -/
def checked (choose : I → Prop) (c : V → Prop) (g body : I → V → Prop) (v : V) :=
  c v ∧ ∀ i, g i v → (choose i → False) ∧ (¬ choose i → body i v)

theorem checked_original (s : I → Prop) (c : V → Prop) (g b : I → V → Prop)
    (v : V) (h : checked s c g b v) : c v ∧ ∀ i, g i v → b i v :=
  ⟨h.1, fun i hg => (h.2 i hg).2 (h.2 i hg).1⟩

/-- History-dependent witnesses stay fixed. A play is a complete sequence
    of universal moves and the strategy determines its resulting state. -/
theorem same_strategy (play : W → U → V) (w : W) (s : I → Prop)
    (c : V → Prop) (g b : I → V → Prop)
    (h : ∀ u, checked s c g b (play w u)) :
    ∀ u, c (play w u) ∧ ∀ i, g i (play w u) → b i (play w u) :=
  fun u => checked_original s c g b (play w u) (h u)

/-- With the package parameter fixed at the input index, the base of relay
    forces the diagonal and the successor just repacks its predecessor. -/
theorem relay_least (r : Int → Int → Prop) (base : ∀ i, r i i) :
    ∀ i o, o = i → r i o := fun i _ eq => eq ▸ base i

theorem relay_obligation (i o : Int) (input : i ≤ 0) (opened : o = i) : ¬1 ≤ o := by omega

/-- The arguments are i and -i. K can carry either one. X specifies the
    available parameter at a call; R interprets the opened result. -/
def Interface (x r : Int → Int → Prop) :=
  (∀ i, ∃ k, x i k) ∧ (∀ i k, x i k → r k i) ∧
    ∀ i k o, x i k → r k o → o = i

def same (a b : Int) := b = a
def opposite (a b : Int) := b = -a

theorem same_interface : Interface same same :=
  ⟨fun i => ⟨i, rfl⟩, fun _ _ h => h.symm, fun _ _ _ h1 h2 => h2.trans h1⟩

theorem opposite_interface : Interface opposite opposite := by
  refine ⟨fun i => ⟨-i, rfl⟩, ?_, ?_⟩ <;> unfold opposite <;> intros <;> omega

/-- Even the result relations alone have no common feasible lower bound.
    This remains true if the call relation is allowed to change freely. -/
theorem no_common_result :
    ¬ ∃ x r, Interface x r ∧ (∀ k o, r k o → same k o) ∧
                               (∀ k o, r k o → opposite k o) := by
  rintro ⟨x, r, ⟨calls, returns, _⟩, pos, neg⟩
  obtain ⟨k, hx⟩ := calls 1
  have hp := pos k 1 (returns 1 k hx)
  have hn := neg k 1 (returns 1 k hx)
  unfold same at hp
  unfold opposite at hn
  omega

theorem observed_relation (x r : Int → Int → Prop) (h : Interface x r) (i o : Int) :
    (∃ k, x i k ∧ r k o) ↔ o = i := by
  constructor
  · rintro ⟨k, h1, h2⟩
    exact h.2.2 i k o h1 h2
  · intro eq
    subst o
    obtain ⟨k, hx⟩ := h.1 i
    exact ⟨k, hx, h.2.1 i k hx⟩

/-- A coordinate may merge calls precisely when every supplier output of
    either call is acceptable to each client in that coordinate's fiber. -/
theorem compatible_coordinate (key : I → K) (supply allow : I → O → Prop) :
    (∃ r : K → O → Prop,
      (∀ i o, supply i o → r (key i) o) ∧ (∀ i o, r (key i) o → allow i o)) ↔
    ∀ i j o, key i = key j → supply i o → allow j o := by
  constructor
  · rintro ⟨r, put, get⟩ i j o eq h
    exact get j o (eq ▸ put i o h)
  · intro compat
    refine ⟨fun k o => ∃ i, key i = k ∧ supply i o, fun i o h => ⟨i, rfl, h⟩, ?_⟩
    rintro j o ⟨i, eq, h⟩
    exact compat i j o eq h

theorem exact_coordinate (key : I → K) (f : I → O) :
    (∃ r : K → O → Prop,
      (∀ i o, o = f i → r (key i) o) ∧ (∀ i o, r (key i) o → o = f i)) ↔
    ∀ i j, key i = key j → f i = f j := by
  rw [compatible_coordinate]
  exact ⟨fun h i j eq => h i j (f i) eq rfl,
         fun h i j _ eq value => value.trans (h i j eq)⟩

/-- Merging two recursive interfaces can activate a supplier whose premise
    never held on its own input. Checking only the old outputs misses 2. -/
theorem merging_can_activate_a_rule :
    (∃ a b : Nat → Prop, a 0 ∧ b 1 ∧ (b 0 → b 2) ∧
      ∀ n, a n ∨ b n → n ≤ 1) ∧
    ¬ ∃ r : Nat → Prop, r 0 ∧ r 1 ∧ (r 0 → r 2) ∧ ∀ n, r n → n ≤ 1 := by
  constructor
  · refine ⟨fun n => n = 0, fun n => n = 1, rfl, rfl, ?_, ?_⟩
    · omega
    · intro n h
      rcases h with h | h <;> omega
  · rintro ⟨r, h0, _, step, safe⟩
    have bad := safe 2 (step h0)
    omega

/-- Numeric content of the two type schemes for the state-coordinate
    program. The result witnesses precede the constructor tests, and
    the recursive call parameter precedes its universally opened result. -/
def StateRows (x r : Int → Int → Prop) :=
  (∃ i k, x i k) ∧
  (∀ i k, x i k → ∃ base succ : Int, r k base ∧ r k succ ∧
    (i = 0 → base = 0 ∧ succ = 0) ∧
    (i = 1 → base = 1 ∧ ∃ j, x 1 j ∧ ∀ prev, r j prev →
                            succ = 1 ∧ (prev ≤ 0 → succ = 2))) ∧
  ∀ i : Int, (i = 0 ∨ i = 1) → ∃ k, x i k ∧ ∀ o, r k o → o ≤ 1

theorem state_certificate : StateRows same same := by
  refine ⟨⟨0, 0, rfl⟩, ?_, ?_⟩
  · intro i k eq
    change k = i at eq
    subst k
    refine ⟨i, i, rfl, rfl, fun h => ⟨h, h⟩, ?_⟩
    rintro rfl
    exact ⟨rfl, 1, rfl, fun prev hp => ⟨rfl, by unfold same at hp; omega⟩⟩
  · intro i hi
    exact ⟨i, rfl, fun o eq => by unfold same at eq; omega⟩

end JointPostconditions
