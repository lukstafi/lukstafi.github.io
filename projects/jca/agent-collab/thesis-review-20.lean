import Std

namespace GuardedCall

/-- The leaves are full assignments. The type of a move can change at each node. -/
inductive Game (A : Type u) : Type (u+1) where
  | leaf (a : A)
  | choose {I : Type u} (next : I → Game A)
  | every {I : Type u} (next : I → Game A)

def wins {A : Type u} (P : A → Prop) : Game A → Prop
  | .leaf a => P a
  | .choose next => ∃ i, wins P (next i)
  | .every next => ∀ i, wins P (next i)

def dual {A : Type u} : Game A → Game A
  | .leaf a => .leaf a
  | .choose next => .every (fun i => dual (next i))
  | .every next => .choose (fun i => dual (next i))

theorem complement {A : Type u} (g : Game A) (P : A → Prop) :
    wins P (dual g) ↔ ¬ wins (fun a => ¬ P a) g := by
  classical
  induction g with
  | leaf => simp [wins, dual]
  | choose next ih => simp [wins, dual, ih]
  | every next ih => simp [wins, dual, ih]

/-- One strategy has a set of leaves obtained by allowing every universal move. -/
inductive Strategy {A : Type u} : Game A → Type (u+1) where
  | leaf (a : A) : Strategy (.leaf a)
  | choose {I : Type u} {next : I → Game A} (i : I) (s : Strategy (next i)) :
      Strategy (.choose next)
  | every {I : Type u} {next : I → Game A} (s : ∀ i, Strategy (next i)) :
      Strategy (.every next)

def visits {A : Type u} {g : Game A} (s : Strategy g) (a : A) : Prop :=
  match s with
  | .leaf b => a = b
  | .choose _ s => visits s a
  | .every ss => ∃ i, visits (ss i) a

theorem winning_strategy {A : Type u} (g : Game A) (P : A → Prop) :
    wins P g ↔ ∃ s : Strategy g, ∀ a, visits s a → P a := by
  classical
  induction g with
  | leaf b =>
    constructor
    · intro p
      exact ⟨.leaf b, fun _ h => h.symm ▸ p⟩
    · rintro ⟨s, legal⟩
      cases s
      exact legal b rfl
  | choose next ih =>
    constructor
    · rintro ⟨i, h⟩
      obtain ⟨s, hs⟩ := (ih i).mp h
      exact ⟨.choose i s, hs⟩
    · rintro ⟨s, h⟩
      cases s with
      | choose i s => exact ⟨i, (ih i).mpr ⟨s, h⟩⟩
  | every next ih =>
    constructor
    · intro all
      have sub := fun i => (ih i).mp (all i)
      refine ⟨.every (fun i => Classical.choose (sub i)), ?_⟩
      rintro a ⟨i, reach⟩
      exact Classical.choose_spec (sub i) a reach
    · rintro ⟨s, h⟩
      cases s with
      | every ss =>
        exact fun i => (ih i).mpr ⟨ss i, fun a reach => h a ⟨i, reach⟩⟩

/-- Keeping the original prefix is essential. A strategy that can satisfy
    the facts while avoiding the whole guard witnesses failure of necessity. -/
theorem occurrence {A : Type u} (g : Game A) (F G : A → Prop) :
    (∀ s : Strategy g, (∀ a, visits s a → F a) → ∃ a, visits s a ∧ G a) ↔
    ¬ wins (fun a => F a ∧ ¬ G a) g := by
  classical
  rw [winning_strategy]
  constructor
  · intro force avoid
    obtain ⟨s, h⟩ := avoid
    obtain ⟨a, v, good⟩ := force s (fun a v => (h a v).1)
    exact (h a v).2 good
  · intro noAvoid s legal
    apply Classical.byContradiction
    intro absent
    exact noAvoid ⟨s, fun a v => ⟨legal a v, fun h => absent ⟨a, v, h⟩⟩⟩

theorem dual_occurrence {A : Type u} (g : Game A) (F G : A → Prop) :
    (∀ s : Strategy g, (∀ a, visits s a → F a) → ∃ a, visits s a ∧ G a) ↔
      wins (fun a => F a → G a) (dual g) := by
  classical
  rw [occurrence, complement]
  simp

/-- After deciding an earlier test, its consequences can rewrite the rest
    of the guard. The previous test must remain part of the obligation. -/
theorem guarded_rewrite {A : Type} (facts earlier oldPrefix test rewritten : A → Prop)
    (before : ∀ a, facts a → (earlier a ↔ oldPrefix a))
    (after : ∀ a, facts a → earlier a → (test a ↔ rewritten a))
    (a : A) (h : facts a) :
    (earlier a ∧ test a) ↔ (oldPrefix a ∧ rewritten a) := by
  constructor
  · rintro ⟨p, t⟩
    exact ⟨(before a h).mp p, (after a h p).mp t⟩
  · rintro ⟨p, t⟩
    have hp := (before a h).mpr p
    exact ⟨hp, (after a h hp).mpr t⟩

/-- An earlier type witness may use any function of the play which is
    constant on the histories indistinguishable at that move. -/
theorem visible_witness {A H T : Type} [Nonempty T] (seen : A → H) (ty : A → T) :
    (∃ pick : H → T, ∀ a, pick (seen a) = ty a) ↔
    ∀ a b, seen a = seen b → ty a = ty b := by
  classical
  constructor
  · rintro ⟨pick, same⟩ a b h
    rw [← same a, ← same b, h]
  · intro depends
    let pick := fun h => if e : ∃ a, seen a = h then ty (Classical.choose e)
                         else Classical.choice (inferInstance : Nonempty T)
    refine ⟨pick, fun a => ?_⟩
    have e : ∃ b, seen b = seen a := ⟨a, rfl⟩
    simpa [pick, e] using depends (Classical.choose e) a (Classical.choose_spec e)

/-- Different call sites may get their required instances on different plays. -/
theorem overlap {A T : Type} {g : Game A} (s : Strategy g) (arg : A → T)
    (site domain : T → Prop) (G : A → Prop)
    (onPath : ∃ a, visits s a ∧ G a)
    (call : ∀ a, visits s a → G a → site (arg a) ∧ domain (arg a)) :
    ∃ t, site t ∧ domain t := by
  obtain ⟨a, v, h⟩ := onPath
  exact ⟨arg a, call a v h⟩

/-- A group of sites can require a common argument even when each site
    alone admits an avoiding strategy. -/
theorem common_argument {A I T : Type} {g : Game A} (F : A → Prop)
    (guards : I → A → Prop) (t : T) (domain : T → Prop)
    (forced : wins (fun a => F a → ∃ i, guards i a) (dual g))
    (s : Strategy g) (legal : ∀ a, visits s a → F a)
    (use : ∀ i a, visits s a → guards i a → domain t) : domain t := by
  obtain ⟨a, reached, i, guarded⟩ := (dual_occurrence g F _).mpr forced s legal
  exact use i a reached guarded

theorem two_sites : (∀ n : Int, n ≤ 0 ∨ 0 ≤ n) ∧
    ¬ (∀ n : Int, n ≤ 0) ∧ ¬ (∀ n : Int, 0 ≤ n) := by
  refine ⟨fun n => by omega, fun h => ?_, fun h => ?_⟩
  · have := h 1
    omega
  · have := h (-1)
    omega

/-- Opening a package from a previous call can hide all later calls in
    the consumer clauses. Evidence of one actual produced return is sufficient. -/
theorem supplier_use {B R T : Type} (base : B) (produces package : B → R → Prop)
    (continues : R → Prop) (arg : R → T) (domain : T → Prop)
    (supplier : ∀ r, produces base r → package base r)
    (opening : ∀ r, package base r → continues r → domain (arg r))
    (returning : ∃ r, produces base r ∧ continues r) :
    ∃ r, produces base r ∧ continues r ∧ domain (arg r) := by
  obtain ⟨r, actual, onward⟩ := returning
  exact ⟨r, actual, onward, opening r (supplier r actual) onward⟩

/-- Each new proposal consumes at least one original call site. -/
theorem replay_bound (remaining : Nat → Nat) (k : Nat)
    (fresh : ∀ i, i < k → remaining (i+1) < remaining i) :
    k + remaining k ≤ remaining 0 := by
  induction k with
  | zero => simp
  | succ k ih =>
    have previous := ih (fun i h => fresh i (Nat.lt.step h))
    have next := fresh k (Nat.lt_succ_self _)
    omega

inductive Ty where
  | atom : Ty
  | arrow : Ty → Ty → Ty
  | package : Ty → Ty

def arrows : Ty → Nat
  | .arrow _ b => 1 + arrows b
  | _ => 0

def afterArgs : Nat → Ty → Option Ty
  | 0, t => some t
  | n+1, .arrow _ t => afterArgs n t
  | _+1, _ => none

theorem partial_is_function (t : Ty) (k : Nat) (h : k < arrows t) :
    ∃ a b, afterArgs k t = some (.arrow a b) := by
  induction k generalizing t with
  | zero => cases t <;> simp_all [arrows, afterArgs]
  | succ k ih =>
    cases t with
    | atom | package => simp [arrows] at h
    | arrow a b =>
      simp only [arrows] at h
      exact ih b (by omega)

theorem package_as_instance (X : Ty → Prop) (p : Ty)
    (use : X (.package p)) (definition : ∀ t, X t → ∃ a b, t = .arrow a b) : False := by
  obtain ⟨a, b, h⟩ := definition _ use
  cases h

/-- A branch can disappear even when the copied test variables themselves
    have no constant bindings outside the constructor match. -/
theorem impossible_arm {i lo hi : Int}
    (bindings : i ≤ 0 → hi = i ∧ lo = 1) : ¬ (i ≤ 0 ∧ lo ≤ hi) := by
  rintro ⟨nonpos, test⟩
  obtain ⟨rfl, rfl⟩ := bindings nonpos
  omega

end GuardedCall
