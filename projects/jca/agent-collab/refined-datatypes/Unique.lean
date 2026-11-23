import Search

namespace UniqueMark

-- BEGIN generated rows
inductive Evidence : State → Tree → Type where
  | clearZero : Evidence .zero .clear
  | markOne : Evidence .one .mark
  | forkZeroZero : Evidence .zero l → Evidence .zero r → Evidence .zero (.fork l r)
  | forkZeroOne : Evidence .zero l → Evidence .one r → Evidence .one (.fork l r)
  | forkOneZero : Evidence .one l → Evidence .zero r → Evidence .one (.fork l r)
-- END generated rows

def route {t : Tree} : Evidence .one t → Path
  | .markOne => .here
  | .forkZeroOne _ right => .right (route right)
  | .forkOneZero left _ => .left (route left)

def follows : Tree → Path → Bool
  | .mark, .here => true
  | .fork l _, .left p => follows l p
  | .fork _ r, .right p => follows r p
  | _, _ => false

theorem route_hits {t} (w : Evidence .one t) : follows t (route w) = true := by
  match w with
  | .markOne => rfl
  | .forkZeroOne _ r => exact route_hits r
  | .forkOneZero l _ => exact route_hits l

def readResult {q t} (e : Evidence q t) : Result :=
  match q, e with
  | .zero, _ => .zero
  | .one, w => .hit (route w)
  | .many, w => nomatch w

theorem sound {q t} (e : Evidence q t) : scan t = readResult e := by
  induction e <;> simp_all [scan, combine, readResult, route]

def Certificate (t : Tree) : Result → Type
  | .zero => Evidence .zero t
  | .hit _ => Evidence .one t
  | .many => Unit

def certify : (t : Tree) → Certificate t (scan t)
  | .clear => Evidence.clearZero
  | .mark => Evidence.markOne
  | .fork l r => by
    have il := certify l
    have ir := certify r
    simp only [scan]
    cases hl : scan l <;> cases hr : scan r <;>
      simp only [hl, hr, Certificate] at il ir <;>
      first | exact Evidence.forkZeroZero il ir
            | exact Evidence.forkZeroOne il ir
            | exact Evidence.forkOneZero il ir
            | exact ()

theorem unique_iff (t : Tree) :
    Nonempty (Evidence .one t) ↔ ∃ p, scan t = .hit p := by
  constructor
  · rintro ⟨w⟩
    exact ⟨route w, sound w⟩
  · rintro ⟨p, h⟩
    have w := certify t
    rw [h] at w
    exact ⟨w⟩

theorem empty_iff (t : Tree) :
    Nonempty (Evidence .zero t) ↔ scan t = .zero := by
  constructor
  · rintro ⟨w⟩
    exact sound w
  · intro h
    have w := certify t
    rw [h] at w
    exact ⟨w⟩

def marks : Tree → Nat
  | .clear => 0
  | .mark => 1
  | .fork l r => marks l + marks r

def countSpec (n : Nat) : Result → Prop
  | .zero => n = 0
  | .hit _ => n = 1
  | .many => 2 ≤ n

theorem counts (t : Tree) : countSpec (marks t) (scan t) := by
  induction t with
  | clear => rfl
  | mark => rfl
  | fork l r il ir =>
    simp only [marks, scan]
    cases hl : scan l <;> cases hr : scan r <;>
      simp [hl, hr, countSpec, combine] at * <;> omega

theorem exactly_one (t : Tree) : Nonempty (Evidence .one t) ↔ marks t = 1 := by
  rw [unique_iff]
  have h := counts t
  cases hs : scan t <;> simp [hs, countSpec] at * <;> omega

-- Exact sibling equality makes every distinct subtree distinguishable at its parent.
theorem diagonal_separates {Q : Type} (state : Tree → Q) (accept : Q → Q → Prop)
    (spec : ∀ l r, accept (state l) (state r) ↔ l = r)
    {l r : Tree} (same : state l = state r) : l = r := by
  apply (spec l r).mp
  rw [same]
  exact (spec r r).mpr rfl

end UniqueMark
