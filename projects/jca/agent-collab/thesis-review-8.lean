import Std

namespace MovingFloor

-- p is the parent's floor and x = m - p is its distance to the cap parameter.
-- The child has floor p+e and distance x+d-e. Payloads are relative to
-- their own call's floor, so a child value t arrives at its parent as e+t.
def band (a x t : Int) : Prop := 0 ≤ t ∧ t ≤ max (x+a) 0
def allows (c L e d x : Int) : Prop :=
  0 ≤ e ∧ d ≤ L-c ∧ e ≤ max 0 d ∧ e ≤ max 0 (x+L)

structure GridValid (c L e d stride : Int) (P : Int → Int → Prop) (Q : Int → Int → Int → Prop) : Prop where
  recur : ∀ p x, P p x → P (p+e) (x+d-e)
  base : ∀ p x, P p x → Q p x 0
  call : ∀ p x t, P p x → Q (p+e) (x+d-e) t → band L x (e+t)
  step : ∀ p x t u, P p x → Q (p+e) (x+d-e) t → band L x (e+t) →
    band c x u → u ≤ e+t+stride → Q p x u

abbrev Valid (c L e d : Int) := GridValid c L e d 1

theorem grid_scheme (c L e d stride : Int) :
    GridValid c L e d stride (fun _ x => allows c L e d x) (fun _ x t => band c x t) := by
  constructor
  · unfold allows; intros; omega
  · unfold band; intros; omega
  · unfold allows band; intros; omega
  · intros; assumption

theorem scheme (c L e d : Int) :
    Valid c L e d (fun _ x => allows c L e d x) (fun _ x t => band c x t) :=
  grid_scheme c L e d 1

theorem first_call {c L e d : Int} {P Q} (h : Valid c L e d P Q)
    {p x : Int} (hp : P p x) : band L x e := by
  simpa using h.call p x 0 hp (h.base _ _ (h.recur _ _ hp))

theorem orbit {c L e d : Int} {P Q} (h : Valid c L e d P Q)
    {p x : Int} (hp : P p x) (n : Nat) :
    ∃ z y, P z y ∧ (e < d → x + (n : Int) ≤ y) ∧ (d < e → y ≤ x - (n : Int)) := by
  induction n with
  | zero => exact ⟨p, x, hp, by omega, by omega⟩
  | succ n ih =>
    obtain ⟨z,y,hy,hu,hd⟩ := ih
    exact ⟨z+e, y+d-e, h.recur _ _ hy, by push_cast; omega, by push_cast; omega⟩

theorem positive_floor {c L e d : Int} {P Q} (h : Valid c L e d P Q)
    {p x : Int} (hp : P p x) (pos : 0 < e) : e ≤ d := by
  apply Classical.byContradiction
  intro bad
  obtain ⟨z,y,hy,_,down⟩ := orbit h hp (x+L+1).toNat
  have bound := (first_call h hy).2
  have low := down (by omega)
  omega

theorem fills {c L e d : Int} {P Q} (h : Valid c L e d P Q)
    (nonneg : 0 ≤ e) (up : e ≤ d) (n : Nat) :
    ∀ p x, P p x → (n : Int) ≤ max (x+c) 0 → Q p x n := by
  induction n with
  | zero => intro p x hp _; exact h.base _ _ hp
  | succ n ih =>
    intro p x hp bound
    have child := ih (p+e) (x+d-e) (h.recur _ _ hp) (by omega)
    exact h.step _ _ _ _ hp child (h.call _ _ _ hp child)
      ⟨by omega, bound⟩ (by omega)

theorem cap_offset {c L e d : Int} {P Q} (h : Valid c L e d P Q)
    (slack : c ≤ L) {p x : Int} (hp : P p x) : d ≤ L-c := by
  have ⟨he, start⟩ := first_call h hp
  apply Classical.byContradiction
  intro bad
  have up : e ≤ d := by
    by_cases zero : e = 0
    · omega
    · exact positive_floor h hp (by omega)
  have enough : ∃ z y, P z y ∧ e ≤ y+L := by
    by_cases pos : 0 < e
    · exact ⟨p,x,hp,by omega⟩
    · obtain ⟨z,y,hy,higher,_⟩ := orbit h hp (-L-x).toNat
      have large := higher (by omega)
      exact ⟨z,y,hy,by omega⟩
  obtain ⟨z,y,hy,lo⟩ := enough
  let n := (y+L-e+1).toNat
  have hn : (n : Int) = y+L-e+1 := by dsimp [n]; omega
  have child := fills h he up n (z+e) (y+d-e) (h.recur _ _ hy) (by omega)
  have high := (h.call _ _ _ hy child).2
  omega

theorem exact_input {c L e d p x : Int} (slack : c ≤ L) :
    (∃ P Q, Valid c L e d P Q ∧ P p x) ↔ allows c L e d x := by
  constructor
  · rintro ⟨P,Q,h,hp⟩
    have ⟨he, hi⟩ := first_call h hp
    have hd := cap_offset h slack hp
    unfold allows
    by_cases pos : 0 < e
    · have up := positive_floor h hp pos
      omega
    · omega
  · intro allowed
    exact ⟨_,_,scheme c L e d,allowed⟩

-- On a grid with denominator N, a payload increment of one is N numerator
-- units. Every unit step used in the necessity proof is still available.
theorem grid_exact {c L e d stride p x : Int} (slack : c ≤ L) (hstep : 1 ≤ stride) :
    (∃ P Q, GridValid c L e d stride P Q ∧ P p x) ↔ allows c L e d x := by
  constructor
  · rintro ⟨P,Q,h,hp⟩
    have unit : Valid c L e d P Q := by
      refine ⟨h.recur, h.base, h.call, ?_⟩
      intro p x t u hp ht hl hc hu
      exact h.step p x t u hp ht hl hc (by omega)
    exact (exact_input slack).mp ⟨P,Q,unit,hp⟩
  · intro hp
    exact ⟨_,_,grid_scheme c L e d stride,hp⟩

-- The stationary set and the closure of the rising set each have a
-- linear description. Their union is the full domain on every grid.
theorem two_convex_regions (c L e d x : Int) :
    allows c L e d x ↔ (e = 0 ∧ d ≤ L-c) ∨
      (0 ≤ e ∧ e ≤ d ∧ d ≤ L-c ∧ e ≤ x+L) := by unfold allows; omega

-- Along (N * stationary + rising)/(N+1), the positive numerator of
-- the rise is fixed. Any affine margin valid on that entire segment
-- must have a nonnegative value at the stationary endpoint.
theorem stationary_margin {e a b : Int} (he : 0 < e)
    (h : ∀ n : Nat, e ≤ max 0 ((n : Int)*a + b)) : 0 ≤ a := by
  apply Classical.byContradiction
  intro neg
  let n := b.toNat + 1
  have hn : b < (n : Int) := by dsimp [n]; omega
  have low := Int.mul_le_mul_of_nonneg_left (show a ≤ -1 by omega)
    (show 0 ≤ (n : Int) by omega)
  simp at low
  have bound := h n
  omega

theorem stationary_in_rising_closure {e d₀ d₁ s₀ s₁ : Int} (he : 0 < e)
    (convex_safe : ∀ n : Nat,
      e ≤ max 0 ((n : Int)*d₀+d₁) ∧ e ≤ max 0 ((n : Int)*s₀+s₁)) :
    0 ≤ d₀ ∧ 0 ≤ s₀ :=
  ⟨stationary_margin he (fun n => (convex_safe n).1),
   stationary_margin he (fun n => (convex_safe n).2)⟩

-- Numerators on the halves grid, where c=19 and L=20. Both endpoints
-- are admissible, but their midpoint would require 1 ≤ max 0 0.
theorem nonconvex_on_halves :
    allows 38 40 0 (-2) (-42) ∧ allows 38 40 2 2 (-38) ∧
    ¬ allows 38 40 1 0 (-40) := by unfold allows; decide

theorem fractional_boundary : allows 38 40 1 1 (-39) := by unfold allows; decide

theorem rising_domain (d x : Int) :
    allows 19 20 1 d x ↔ d = 1 ∧ -19 ≤ x := by unfold allows; omega

-- The concrete failing source therefore has a solution using no extrema
-- in either inferred predicate, with d still a symbolic input.
theorem linear_solution (d : Int) :
    Valid 19 20 1 d (fun _ x => d = 1 ∧ -19 ≤ x)
      (fun _ x t => 0 ≤ t ∧ t ≤ x+19) := by
  constructor
  · intros; omega
  · intros; omega
  · unfold band; intros; omega
  · unfold band; intros; omega

-- Unroll only the necessary first-call test and recursive admission.
-- With floor shift 1 the distance changes by d-1 per call.
def checks : Nat → Int → Int → Prop
  | 0, _, _ => True
  | n+1, d, x => 1 ≤ x+20 ∧ checks n d (x+d-1)

theorem zero_shift_checks (n : Nat) (x : Int) :
    checks n 0 x ↔ n = 0 ∨ (n : Int)-20 ≤ x := by
  induction n generalizing x with
  | zero => simp [checks]
  | succ n ih => rw [checks, ih]; omega

theorem descending_domains (n : Nat) :
    (∀ d x, checks (n+1) d x → checks n d x) ∧
    (∃ d x, checks n d x ∧ ¬checks (n+1) d x) := by
  constructor
  · induction n with
    | zero => intros; trivial
    | succ n ih =>
      intro d x h
      exact ⟨h.1, ih _ _ h.2⟩
  · refine ⟨0, (n : Int)-20, ?_, ?_⟩ <;> rw [zero_shift_checks] <;> omega

theorem unit_shift_checks (n : Nat) {x : Int} (hx : -19 ≤ x) : checks n 1 x := by
  induction n with
  | zero => trivial
  | succ n ih => exact ⟨by omega, by simpa using ih⟩

theorem limit_on_two_shifts {d x : Int} (choice : d = 0 ∨ d = 1) :
    (∀ n, checks n d x) ↔ d = 1 ∧ -19 ≤ x := by
  constructor
  · intro all
    rcases choice with rfl | rfl
    · have h := (zero_shift_checks (x+21).toNat.succ x).mp (all _)
      omega
    · exact ⟨rfl, by have := (all 1).1; omega⟩
  · rintro ⟨rfl, hx⟩
    exact fun n => unit_shift_checks n hx

end MovingFloor
