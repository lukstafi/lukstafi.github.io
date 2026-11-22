import Std

namespace AffineTag

-- Both suppliers have a common affine graph, for any recursive argument map.
def pair (k p : Int) : Nat → Int × Int
  | 0 => (p, (k+1)*p)
  | _+1 => (p+1, (k+1)*p+k)

theorem graph (k p : Int) (n : Nat) :
    (pair k p n).2 = p + k*(pair k p n).1 := by
  cases n <;> simp [pair, Int.add_mul, Int.mul_add] <;> omega

theorem recursive_check (k p : Int) (move : Int → Int) (n : Nat) :
    (pair k (move p) n).2 = move p + k*(pair k (move p) n).1 :=
  graph k (move p) n

-- Every affine equation shared by the two lines is a multiple of their graph.
theorem all_equations (k a b c h : Int)
    (base : ∀ p : Int, a*p + b*p + c*((k+1)*p) + h = 0)
    (step : ∀ p : Int, a*p + b*(p+1) + c*((k+1)*p+k) + h = 0) :
    h = 0 ∧ b = -(c*k) ∧ a = -c := by
  have z := base 0
  have one := base 1
  have off := step 0
  simp [Int.mul_add] at z one off
  omega

end AffineTag

namespace PackedPayload

inductive Tag : Type → Type → Type 1 where
  | left {a : Type} (x : a) : Tag Unit a
  | right {a : Type} (x : a) : Tag a Unit

def get {a : Type} : Tag Unit a → a
  | .left x => x
  | .right x => x

def f {a : Type} (tag : Tag Unit a) : Nat → a × a
  | 0 => (get tag, get tag)
  | n+1 => f tag n

theorem result {a : Type} (tag : Tag Unit a) (n : Nat) :
    f tag n = (get tag, get tag) := by
  induction n with
  | zero => rfl
  | succ n ih => exact ih

example : f (.left true) 1 = (true,true) := rfl
example : f (.right ()) 1 = ((),()) := rfl

end PackedPayload

namespace SupplierIteration

def Incl {X : Type} (P Q : X → Prop) := ∀ x, P x → Q x

structure Closure (X : Type) where
  hull : (X → Prop) → X → Prop
  contains : ∀ P, Incl P (hull P)
  monotone : ∀ {P Q}, Incl P Q → Incl (hull P) (hull Q)

variable {X : Type} (c : Closure X) (base : X → Prop) (step : X → X → Prop)

def next (S : X → Prop) := c.hull (fun y => base y ∨ ∃ x, S x ∧ step x y)

def pass : Nat → X → Prop
  | 0 => c.hull base
  | n+1 => next c base step (pass n)

theorem increasing (n : Nat) : Incl (pass c base step n) (pass c base step (n+1)) := by
  induction n with
  | zero => exact c.monotone (fun _ hb => Or.inl hb)
  | succ n ih =>
    apply c.monotone
    rintro y (hb | ⟨x,hx,hxy⟩)
    · exact Or.inl hb
    · exact Or.inr ⟨x,ih x hx,hxy⟩

theorem below_solution {R : X → Prop} (closed : Incl (c.hull R) R)
    (hb : Incl base R) (inductiveStep : ∀ x y, R x → step x y → R y) (n : Nat) :
    Incl (pass c base step n) R := by
  induction n with
  | zero => exact fun x hx => closed x (c.monotone hb x hx)
  | succ n ih =>
    have inside : Incl (fun y => base y ∨ ∃ x, pass c base step n x ∧ step x y) R := by
      rintro y (h | ⟨x,hx,hxy⟩)
      · exact hb y h
      · exact inductiveStep x y (ih x hx) hxy
    exact fun y hy => closed y (c.monotone inside y hy)

-- For a nonempty affine subspace, rank is its ordinary dimension. Each
-- proper extension adds at least one independent direction.
theorem stationary_by_dimension (d : Nat) (rank : Nat → Nat)
    (bounded : ∀ n, rank n ≤ d)
    (grows : ∀ n, ¬ Incl (pass c base step (n+1)) (pass c base step n) →
      rank n < rank (n+1)) :
    ∃ n, n ≤ d - rank 0 ∧ Incl (pass c base step (n+1)) (pass c base step n) := by
  apply Classical.byContradiction
  intro absent
  have gain (n : Nat) (early : n ≤ d - rank 0) : rank n < rank (n+1) := by
    apply grows
    exact fun h => absent ⟨n,early,h⟩
  have lower (n : Nat) (early : n ≤ d - rank 0 + 1) : rank 0 + n ≤ rank n := by
    induction n with
    | zero => omega
    | succ n ih =>
      have := gain n (by omega)
      have := ih (by omega)
      omega
  have := lower (d - rank 0 + 1) (by omega)
  have := bounded (d - rank 0 + 1)
  have := bounded 0
  omega

theorem inductive_at_stop (n : Nat)
    (stop : Incl (pass c base step (n+1)) (pass c base step n)) :
    Incl base (pass c base step n) ∧
      ∀ x y, pass c base step n x → step x y → pass c base step n y := by
  constructor
  · exact fun x hb => stop x (c.contains _ x (Or.inl hb))
  · exact fun x y hx hxy => stop y (c.contains _ y (Or.inr ⟨x,hx,hxy⟩))

end SupplierIteration
