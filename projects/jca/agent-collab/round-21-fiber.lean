/- A nonidentity in one variable has at most one solution on finite binary trees. -/
import Std

namespace JCA.OneInput
inductive Term where
  | hole
  | atom (n : Nat)
  | fork (a b : Term)
  deriving DecidableEq

def plug (x : Term) : Term → Term
  | .hole => x
  | .atom n => .atom n
  | .fork a b => .fork (plug x a) (plug x b)

def nodes : Term → Nat
  | .hole | .atom _ => 1
  | .fork a b => 1 + nodes a + nodes b

def uses : Term → Bool
  | .hole => true
  | .atom _ => false
  | .fork a b => uses a || uses b

theorem independent (x y t : Term) (pure : uses t = false) : plug x t = plug y t := by
  induction t with
  | hole => contradiction
  | atom => rfl
  | fork a b ha hb =>
    simp [uses] at pure
    simp [plug, ha pure.1, hb pure.2]

theorem lower_bound (x t : Term) (occ : uses t = true) : nodes x ≤ nodes (plug x t) := by
  induction t with
  | hole => exact Nat.le_refl _
  | atom => contradiction
  | fork a b ha hb =>
    simp only [uses, Bool.or_eq_true] at occ
    simp only [plug, nodes]
    rcases occ with o | o
    · have := ha o; omega
    · have := hb o; omega

theorem fixed_unique {t x y : Term} (nontrivial : t ≠ .hole)
    (hx : plug x t = x) (hy : plug y t = y) : x = y := by
  by_cases pure : uses t = false
  · exact hx.symm.trans ((independent x y t pure).trans hy)
  cases t with
  | hole => contradiction
  | atom => contradiction
  | fork a b =>
    have sz := congrArg nodes hx
    simp only [plug, nodes] at sz
    have occ : uses a = true ∨ uses b = true := by
      cases ea : uses a <;> cases eb : uses b <;> simp_all [uses]
    rcases occ with h | h
    · have := lower_bound x a h; omega
    · have := lower_bound x b h; omega

theorem two_points {x y : Term} (different : x ≠ y) (t u : Term)
    (hx : plug x t = plug x u) (hy : plug y t = plug y u) : t = u := by
  induction t generalizing u with
  | hole =>
    by_cases e : u = .hole
    · exact e.symm
    · exact False.elim (different (fixed_unique e hx.symm hy.symm))
  | atom n =>
    cases u with
    | hole => exact False.elim (different (fixed_unique (by intro e; cases e) hx hy))
    | atom m => exact hx
    | fork => contradiction
  | fork a b ha hb =>
    cases u with
    | hole => exact False.elim (different (fixed_unique (by intro e; cases e) hx hy))
    | atom => contradiction
    | fork c d =>
      obtain ⟨xa, xb⟩ := Term.fork.inj hx
      obtain ⟨ya, yb⟩ := Term.fork.inj hy
      rw [ha c xa ya, hb d xb yb]

#print axioms two_points
end JCA.OneInput
