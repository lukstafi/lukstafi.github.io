import Std

namespace UniqueMark

inductive Tree where
  | clear | mark | fork (left right : Tree)

inductive Path where
  | here | left (rest : Path) | right (rest : Path)
  deriving DecidableEq

inductive Result where
  | zero | hit (path : Path) | many
  deriving DecidableEq

def combine : Result → Result → Result
  | .zero, .zero => .zero
  | .hit p, .zero => .hit (.left p)
  | .zero, .hit p => .hit (.right p)
  | _, _ => .many

def scan : Tree → Result
  | .clear => .zero
  | .mark => .hit .here
  | .fork l r => combine (scan l) (scan r)

-- Each subtree exposes one of three tags to its parent.
inductive State where
  | zero | one | many
  deriving DecidableEq

def tag : Result → State
  | .zero => .zero
  | .hit _ => .one
  | .many => .many

def representative : State → Result
  | .zero => .zero
  | .one => .hit .here
  | .many => .many

def step (l r : State) : State := tag (combine (representative l) (representative r))

theorem step_exact (l r : Result) : tag (combine l r) = step (tag l) (tag r) := by
  cases l <;> cases r <;> rfl

theorem many_absorbs (q : State) : step .many q = .many ∧ step q .many = .many := by
  cases q <;> exact ⟨rfl, rfl⟩

def State.name : State → String
  | .zero => "zero"
  | .one => "one"
  | .many => "many"

end UniqueMark

open UniqueMark in
def main : IO Unit := do
  IO.println s!"clear {(tag (scan .clear)).name}"
  IO.println s!"mark {(tag (scan .mark)).name}"
  let states : List State := [.zero, .one, .many]
  for l in states do
    for r in states do
      IO.println s!"fork {l.name} {r.name} {(step l r).name}"
