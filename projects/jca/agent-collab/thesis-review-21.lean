import Std

namespace GuardedBody

/-- A numeric specialization of (4.1–4.6) with fixed input, interface,
    and caller requirement. Supplier justification makes (4.7) empty. -/
def stored (w : (V → Prop) → V → Prop) (d r : V → Prop) : V → Prop :=
  fun v => w r v ∧ d v

def renews (w : (V → Prop) → V → Prop) (d r : V → Prop) : Prop :=
  ∃ v, w r v ∧ ¬d v

def rounds (w : (V → Prop) → V → Prop) (d r : V → Prop) : Nat → V → Prop
  | 0 => r
  | n + 1 => stored w d (rounds w d r n)

theorem recurrent_demand (w : (V → Prop) → V → Prop) (d r : V → Prop)
    (fixed : ∀ v, (w r v ∧ d v) ↔ r v) (gap : renews w d r) (n : Nat) :
    rounds w d r n = r ∧ renews w d (rounds w d r n) := by
  have same : stored w d r = r := funext fun v => propext (fixed v)
  have iter : rounds w d r n = r := by
    induction n with
    | zero => rfl
    | succ n ih => simpa [rounds, ih] using same
  exact ⟨iter, iter.symm ▸ gap⟩

/-- Retaining an old inductive conjunction entails every demand that it
    already covered. An upper bound, a lower bound and an equality can
    each have different presentations in the new supplier summary. -/
theorem no_renewal (w : (V → Prop) → V → Prop) (d r : V → Prop)
    (kept : ∀ v, w r v → r v) (covered : ∀ v, r v → d v) : ¬renews w d r := by
  rintro ⟨v, hw, hd⟩
  exact hd (covered v (kept v hw))

/-- Each leaf represents one complete play, with its original witnesses. -/
inductive Game (V : Type) where
  | leaf (v : V)
  | all (moves : Type) (next : moves → Game V)
  | ex (moves : Type) (next : moves → Game V)

def wins (g : Game V) (goal : V → Prop) : Prop :=
  match g with
  | .leaf v => goal v
  | .all _ next => ∀ m, wins (next m) goal
  | .ex _ next => ∃ m, wins (next m) goal

theorem transport (g : Game V) (p q : V → Prop) (h : ∀ v, p v → q v) :
    wins g p → wins g q := by
  induction g with
  | leaf v => exact h v
  | all _ _ ih => exact fun s m => ih m (s m)
  | ex _ _ ih =>
    intro s
    obtain ⟨m, rest⟩ := s
    exact ⟨m, ih m rest⟩

def branch (F P E G B : V → Prop) (v : V) :=
  F v ∧ (P v → E v ∧ (G v → B v))

theorem erase_body (g : Game V) (F P E G B : V → Prop)
    (dead : ∀ v, F v → P v → E v → G v → False) :
    wins g (branch F P E G B) ↔ wins g (fun v => F v ∧ (P v → E v)) := by
  constructor
  · apply transport
    exact fun _ h => ⟨h.1, fun hp => (h.2 hp).1⟩
  · apply transport
    exact fun v h => ⟨h.1, fun hp => ⟨h.2 hp, fun hg => (dead v h.1 hp (h.2 hp) hg).elim⟩⟩

/-- C includes all of the unmodified obligations, including negative clauses.
    Each retained guard is weaker than the corresponding original guard. -/
theorem stronger_calls (g : Game V) (C : V → Prop) (old kept body : I → V → Prop)
    (weaker : ∀ i v, old i v → kept i v) :
    wins g (fun v => C v ∧ ∀ i, kept i v → body i v) →
    wins g (fun v => C v ∧ ∀ i, old i v → body i v) := by
  apply transport
  exact fun v h => ⟨h.1, fun i ho => h.2 i (weaker i v ho)⟩

/-- Two bodies can force their guard false together. Deleting both would
    remove that very restriction. -/
example : (∀ p x : Prop, (p → x) → (p → ¬x) → ¬p) ∧
    (∃ p x : Prop, ¬ ((p → x) ∧ (p → ¬x))) := by
  exact ⟨fun _ _ a b h => b h (a h), True, True, fun h => h.2 trivial trivial⟩

/-- The trace includes all observable effects of testing the guard. An abort
    can carry an exception or an infinite execution as the observation O. -/
inductive Guard (S O : Type) where
  | abort (observation : O)
  | done (take : Bool) (state : S)

def runArm (t : Guard S O) (yes no : S → O) : O :=
  match t with
  | .abort o => o
  | .done true s => yes s
  | .done false s => no s

theorem replace_dead (t : Guard S O) (dead : ∀ s, t ≠ .done true s)
    (body replacement fallthrough : S → O) :
    runArm t body fallthrough = runArm t replacement fallthrough := by
  cases t with
  | abort => rfl
  | done take s => cases take with
    | false => rfl
    | true => exact (dead s rfl).elim

example : runArm (.done false 1 : Guard Nat Nat) id id ≠ id 0 := by decide

/-- Witnesses for the guard-evaluation row, chosen after opening Pick.
    The continuation may contain any number of calls and package openings. -/
theorem opaque_guard_witnesses (body : Int → Int → Int → Int → Prop) :
    ∀ i : Int, ∃ o h l : Int, (i ≤ 0 → o = i ∧ h = o ∧ l = 1) ∧
      (i ≤ 0 → l ≤ h → body i o h l) := by
  intro i
  exact ⟨i, i, 1, fun _ => ⟨rfl, rfl, rfl⟩, fun hi hl => by omega⟩

/-- The free input constructor at the four-axis supplier. A field holds
    the type of its payload, which may itself be any ground type. -/
inductive Axis (T : Type) where
  | first (payload : T) | second (payload : T) | third (payload : T) | fourth (payload : T)

def indices (marker : T) : Axis T → T × T × T × T
  | .first a => (a,marker,marker,marker)
  | .second a => (marker,a,marker,marker)
  | .third a => (marker,marker,a,marker)
  | .fourth a => (marker,marker,marker,a)

def payload : Axis T → T
  | .first a | .second a | .third a | .fourth a => a

def supply (tag : Axis T) : Nat → T × T
  | 0 => (payload tag, payload tag)
  | n + 1 => supply tag n

theorem third_axis_certificate (tag : Axis T) (m a : T) (n : Nat)
    (instanceOf : indices m tag = (m,m,a,m)) : supply tag n = (a,a) := by
  have field : payload tag = a := by
    cases tag <;> simp_all [indices, payload]
  induction n with
  | zero => simp [supply, field]
  | succ n ih => exact ih

/-- A type at a leaf of a conjunctive free-constructor pattern is fixed
    or is a type hole. Restrict instantiations to Marker and Cargo. -/
inductive Cell (H : Type) where
  | fixed (cargo : Bool)
  | hole (name : H)
deriving DecidableEq

def value (assignment : H → Bool) : Cell H → Bool
  | .fixed b => b
  | .hole h => assignment h

/-- Supply the three actual returns. The output hole must be independent
    of every input cell, or one of the three runs distinguishes them.
    It can therefore admit the wrong return at the first marked input. -/
theorem independent_return [DecidableEq H] (input : I → Cell H) (output : Cell H)
    (base third first : H → Bool)
    (baseRet : value base output = false) (thirdRet : value third output = true)
    (firstRet : value first output = true)
    (axes : ∀ i, value third (input i) = false ∨ value first (input i) = false) :
    ∃ bad : H → Bool, (∀ i, value bad (input i) = value third (input i)) ∧
      value bad output = false := by
  cases output with
  | fixed b => simp [value] at baseRet thirdRet; simp_all
  | hole h =>
    refine ⟨fun k => if k = h then false else third k, ?_, by simp [value]⟩
    intro i
    specialize axes i
    cases e : input i with
    | fixed b => rfl
    | hole k =>
      have ne : k ≠ h := by
        intro eq
        subst k
        simp [e, value] at axes
        simp [value] at firstRet thirdRet
        simp [firstRet, thirdRet] at axes
      simp [value, ne]

end GuardedBody
