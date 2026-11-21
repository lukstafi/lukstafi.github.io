import Std

namespace ThesisReview

/-- The truth of a guard at a public row can include private branch witnesses. -/
theorem alternatives {Row Alt : Type} (guard answer : Row → Prop)
    (part : Alt → Row → Prop) (covers : ∀ r, guard r ↔ ∃ j, part j r) :
    (∃ r, guard r ∧ answer r) ↔ ∃ j r, part j r ∧ answer r := by
  constructor
  · rintro ⟨r, hg, ha⟩
    obtain ⟨j, hp⟩ := (covers r).mp hg
    exact ⟨j, r, hp, ha⟩
  · rintro ⟨j, r, hp, ha⟩
    exact ⟨r, (covers r).mpr ⟨j, hp⟩, ha⟩

theorem impossibleGuard (answer : Bool → Prop) :
    ¬ ∃ r, (false = true) ∧ answer r := by
  rintro ⟨_, h, _⟩
  cases h

theorem splitChangesWitnesses :
    (∃ x : Bool, (x = false ∨ x = true) ∧ x = false) ∧
    ¬ (∃ x : Bool, x = true ∧ x = false) := by
  refine ⟨⟨false, Or.inl rfl, rfl⟩, ?_⟩
  rintro ⟨_, rfl, h⟩
  cases h

-- Nat is the finite-tree algebra with a constant and one unary constructor.
theorem scopeBefore : ∃ x : Nat, ∀ _h : Nat, ∃ v : Nat, x = v.succ :=
  ⟨1, fun _ => ⟨0, rfl⟩⟩

theorem scopeAfter : ¬ ∃ x : Nat, ∀ h : Nat, ∃ _v : Nat, x = h.succ := by
  rintro ⟨x, wins⟩
  obtain ⟨_, h₀⟩ := wins 0
  obtain ⟨_, h₁⟩ := wins 1
  omega

inductive IndexedTy where
  | num (index : Nat)
  | arrow (dom cod : IndexedTy)

theorem jointProjection (n m : Nat) :
    (∃ u : IndexedTy, u = .num n ∧ u = .num m) ↔ n = m := by
  constructor
  · rintro ⟨_, rfl, h⟩
    exact IndexedTy.num.inj h
  · rintro rfl
    exact ⟨.num n, rfl, rfl⟩

theorem separateProjection (n m : Nat) :
    (∃ u : IndexedTy, u = .num n) ∧ (∃ u : IndexedTy, u = .num m) :=
  ⟨⟨_, rfl⟩, ⟨_, rfl⟩⟩

theorem lostIndexEquality :
    ¬ ∀ (u : IndexedTy) (n m : Nat), u = .num m → n = m := by
  intro allRows
  cases allRows (.num 1) 0 1 rfl

/-- An injective constructor fixes its indices when the output is chosen.
    A prefix over inhabited sorts is monotone and has at least one play. -/
theorem freezeIndices {Idx Out Row : Type}
    (ctor : Idx → Out) (injective : ∀ {i j}, ctor i = ctor j → i = j)
    (indices : Row → Idx) (side : Row → Prop) (wins : (Row → Prop) → Prop)
    (mono : ∀ {p q : Row → Prop}, (∀ r, p r → q r) → wins p → wins q)
    (realizes : ∀ {p : Row → Prop}, wins p → ∃ r, p r) :
    (∃ x, wins (fun r => x = ctor (indices r) ∧ side r)) ↔
    (∃ c, wins (fun r => c = indices r ∧ side r)) := by
  constructor
  · rintro ⟨x, win⟩
    obtain ⟨r₀, hx, _⟩ := realizes win
    refine ⟨indices r₀, mono ?_ win⟩
    intro r hr
    exact ⟨injective (hx.symm.trans hr.1), hr.2⟩
  · rintro ⟨c, win⟩
    refine ⟨ctor c, mono ?_ win⟩
    intro r hr
    exact ⟨congrArg ctor hr.1, hr.2⟩

inductive IndexedList (α : Type) : Int → Type where
  | nil : IndexedList α 0
  | cons {n : Int} (guard : 0 ≤ n) (x : α) (xs : IndexedList α n) :
      IndexedList α (n + 1)

theorem lengthNonnegative {α : Type} {n : Int} (xs : IndexedList α n) : 0 ≤ n := by
  induction xs with
  | nil => decide
  | cons _ _ _ ih => exact Int.add_nonneg ih (by decide)

/-- Append needs a constructor guard on the recursive result. The invariant
    of the second input supplies it without matching on that input. -/
def append {α : Type} {k n : Int} (xs : IndexedList α k) (ys : IndexedList α n) :
    IndexedList α (n + k) := by
  match xs with
  | .nil => simpa using ys
  | .cons guard x tail =>
    have bound := Int.add_nonneg (lengthNonnegative ys) guard
    simpa only [Int.add_assoc] using IndexedList.cons bound x (append tail ys)

-- The extra input guard printed by the solver excludes two constructed values.
example : IndexedList Unit 0 × IndexedList Unit 0 := ⟨.nil, .nil⟩
example : ¬ (1 ≤ (0 : Int) + 0 ∧ 1 ≤ (0 : Int)) := by decide

inductive Tree where
  | a | b | pair (left right : Tree)
  deriving DecidableEq

inductive Pattern where
  | first | second | ground (t : Tree) | pair (left right : Pattern)

def Pattern.eval : Pattern → Tree → Tree → Tree
  | .first, h, _ => h
  | .second, _, k => k
  | .ground t, _, _ => t
  | .pair p q, h, k => .pair (p.eval h k) (q.eval h k)

def Selects (s : Tree → Tree → Tree) : Prop :=
  (∀ k, s .a k = k) ∧ (∀ h, s h .a = h)

theorem pointwiseSelector : ∃ s, Selects s := by
  refine ⟨fun h k => if h = .a then k else h, ?_, ?_⟩
  · intro k
    simp
  · intro h
    by_cases eq : h = .a <;> simp [eq]

theorem noConstructorSelector (p : Pattern) : ¬ Selects p.eval := by
  intro fits
  cases p with
  | first => cases fits.1 .b
  | second => cases fits.2 .b
  | ground t =>
    have h : Tree.a = Tree.b := (fits.1 .a).symm.trans (fits.1 .b)
    cases h
  | pair p q => cases fits.1 .a

-- Ground instances of an existential conjunction of free type equations form
-- one tuple pattern. Its holes may be shared between coordinates.
inductive TyPat where
  | hole (i : Nat) | ground (t : Tree) | pair (l r : TyPat)

def TyPat.eval (σ : Nat → Tree) : TyPat → Tree
  | .hole i => σ i
  | .ground t => t
  | .pair l r => .pair (l.eval σ) (r.eval σ)

def HasRow (h k y : TyPat) (left right result : Tree) : Prop :=
  ∃ σ, h.eval σ = left ∧ k.eval σ = right ∧ y.eval σ = result

theorem holeOfBoth (p : TyPat) (σ τ : Nat → Tree)
    (a : p.eval σ = .a) (b : p.eval τ = .b) : ∃ i, p = .hole i := by
  cases p with
  | hole i => exact ⟨i, rfl⟩
  | ground t => cases a.symm.trans b
  | pair l r => cases a

theorem payloadObstruction (h k y : TyPat)
    (aaa : HasRow h k y .a .a .a) (abb : HasRow h k y .a .b .b)
    (bab : HasRow h k y .b .a .b) : HasRow h k y .a .a .b := by
  obtain ⟨s, hs, ks, ys⟩ := aaa
  obtain ⟨t, ht, kt, yt⟩ := abb
  obtain ⟨u, hu, ku, yu⟩ := bab
  obtain ⟨i, rfl⟩ := holeOfBoth h s u hs hu
  obtain ⟨j, rfl⟩ := holeOfBoth k s t ks kt
  obtain ⟨o, rfl⟩ := holeOfBoth y s t ys yt
  have hi : i ≠ o := by
    rintro rfl
    cases ht.symm.trans yt
  have hj : j ≠ o := by
    rintro rfl
    cases ku.symm.trans yu
  refine ⟨fun p => if p = o then Tree.b else Tree.a, ?_⟩
  simp [TyPat.eval, hi, hj]

def SafeRow (h k y : Tree) : Prop := (h = .a → y = k) ∧ (k = .a → y = h)

theorem leftScheme (t : Tree) : SafeRow .a t t :=
  ⟨fun _ => rfl, fun ht => ht⟩

theorem rightScheme (t : Tree) : SafeRow t .a t :=
  ⟨fun ht => ht, fun _ => rfl⟩

theorem diagonalScheme (t : Tree) : SafeRow t t t :=
  ⟨fun _ => rfl, fun _ => rfl⟩

theorem noCommonSoundScheme (h k y : TyPat)
    (sound : ∀ u v w, HasRow h k y u v w → SafeRow u v w)
    (left : ∀ t, HasRow h k y .a t t) (right : ∀ t, HasRow h k y t .a t) :
    False := by
  have bad := payloadObstruction h k y (left .a) (left .b) (right .b)
  cases (sound .a .a .b bad).1 rfl

theorem keepAtom (t : TyPat) (σ : Nat → Tree) (v : Nat) (atom : Tree)
    (atomic : ∀ l r, Tree.pair l r ≠ atom) (before : t.eval σ = atom)
    (distinct : t ≠ .hole v) :
    t.eval (fun q => if q = v then .a else σ q) = atom := by
  cases t with
  | hole q =>
    have h : q ≠ v := fun eq => distinct (congrArg TyPat.hole eq)
    simpa [TyPat.eval, h] using before
  | ground _ => exact before
  | pair l r => exact False.elim (atomic _ _ before)

def axis {I : Type} [DecidableEq I] (i k : I) : Tree :=
  if k = i then .b else .a

/-- A single tuple pattern covering two of the marked applications necessarily
    types the common all-A input with the wrong result B. -/
theorem twoAxes {I : Type} [DecidableEq I] (args : I → TyPat) (out : TyPat)
    (i j : I) (distinct : i ≠ j) (σ τ : Nat → Tree)
    (rowI : ∀ k, (args k).eval σ = axis i k) (outI : out.eval σ = .b)
    (rowJ : ∀ k, (args k).eval τ = axis j k) (outJ : out.eval τ = .b) :
    ∃ ρ, (∀ k, (args k).eval ρ = .a) ∧ out.eval ρ = .b := by
  have ai : (args i).eval τ = .a := by simpa [axis, distinct] using rowJ i
  have bi : (args i).eval σ = .b := by simpa [axis] using rowI i
  obtain ⟨v, hv⟩ := holeOfBoth (args i) τ σ ai bi
  rw [hv] at ai bi
  refine ⟨fun q => if q = v then .a else σ q, ?_, ?_⟩
  · intro k
    by_cases eq : k = i
    · subst k
      simp [hv, TyPat.eval]
    · have initial : (args k).eval σ = .a := by simpa [axis, eq] using rowI k
      apply keepAtom (args k) σ v .a (fun _ _ eqn => by cases eqn) initial
      intro alias
      rw [alias] at initial
      cases bi.symm.trans initial
  · apply keepAtom out σ v .b (fun _ _ eqn => by cases eqn) outI
    intro alias
    rw [alias] at outJ
    cases ai.symm.trans outJ

end ThesisReview
