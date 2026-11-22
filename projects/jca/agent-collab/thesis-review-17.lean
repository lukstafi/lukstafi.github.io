import Std

namespace PackageOpening

-- A package may be opened only after its shape has been established.
def accepts {W V : Type} (pack : W → V) (test : W → Prop) (v : V) :=
  (∃ w, pack w = v) ∧ ∀ w, pack w = v → test w

theorem exact_projection {W V : Type} (pack : W → V) (test : W → Prop) :
    (∀ v, accepts pack test v ↔ ∃ w, pack w = v ∧ test w) ↔
    (∀ x y, pack x = pack y → test x → test y) := by
  constructor
  · intro all x y h hx
    have checked := (all (pack x)).2 ⟨x, rfl, hx⟩
    exact checked.2 y h.symm
  · intro transport v
    constructor
    · rintro ⟨⟨w, hw⟩, every⟩
      exact ⟨w, hw, every w hw⟩
    · rintro ⟨w, hw, good⟩
      exact ⟨⟨w, hw⟩, fun y hy => transport w y (hw.trans hy.symm) good⟩

-- Keep the arbitrary sibling local to each individual opening.
theorem first_of_pair {A B : Type} (c : A) (v : A × B) :
    accepts id (fun p : A × B => p.1 = c) v ↔ ∃ b, v = (c,b) := by
  cases v with
  | mk a b =>
    constructor
    · intro h
      obtain rfl := h.2 (a,b) rfl
      exact ⟨b,rfl⟩
    · rintro ⟨b',h⟩
      cases h
      exact ⟨⟨_,rfl⟩, fun _ hp => congrArg Prod.fst hp⟩

example : (∃ b : Bool, (fun _ : Bool => ()) b = () ∧ b = true) ∧
    ¬ accepts (fun _ : Bool => ()) (fun b => b = true) () := by
  exact ⟨⟨true,rfl,rfl⟩, fun h => Bool.noConfusion (h.2 false rfl)⟩

end PackageOpening

namespace QuantifiedEquality

inductive Ty where
  | marker | cargo | box (arg : Ty)
  deriving DecidableEq

theorem orient : ∀ u : Ty, ∃ z, u = z := fun u => ⟨u,rfl⟩
theorem no_late_dependency : ¬ ∃ x : Ty, ∀ u : Ty, ∃ z : Ty, x = .box z ∧ z = u := by
  rintro ⟨x,h⟩
  obtain ⟨_,hx,rfl⟩ := h .marker
  obtain ⟨_,hy,rfl⟩ := h .cargo
  cases hx.symm.trans hy

end QuantifiedEquality

namespace FourAxes

inductive Tag : Type → Type → Type → Type → Type 1 where
  | first {a : Type} : a → Tag a Unit Unit Unit
  | second {a : Type} : a → Tag Unit a Unit Unit
  | third {a : Type} : a → Tag Unit Unit a Unit
  | fourth {a : Type} : a → Tag Unit Unit Unit a

def get {a : Type} : Tag Unit Unit a Unit → a
  | .first x => x
  | .second x => x
  | .third x => x
  | .fourth x => x

def f {a : Type} (tag : Tag Unit Unit a Unit) : Nat → a × a
  | 0 => (get tag, get tag)
  | n+1 => f tag n

theorem all_depths {a : Type} (tag : Tag Unit Unit a Unit) (depth : Nat) :
    f tag depth = (get tag, get tag) := by
  induction depth with
  | zero => rfl
  | succ n ih => exact ih

example : f (.third true) 1 = (true,true) := rfl
example : f (.first ()) 1 = ((),()) := rfl
example : f (.second ()) 1 = ((),()) := rfl
example : f (.fourth ()) 1 = ((),()) := rfl

end FourAxes
