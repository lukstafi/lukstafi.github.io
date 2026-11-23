import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import Mathlib.Data.Rat.Cast.Order
import Mathlib.Algebra.Order.Archimedean.Basic

namespace FixedCaller

abbrev Point := ℚ × ℚ

def turn (p : Point) : Point := ((3*p.1-4*p.2)/5, (4*p.1+3*p.2)/5)
def normSq (p : Point) := p.1^2 + p.2^2

theorem spin_norm (p : Point) : normSq (turn p) = normSq p := by
  simp only [normSq, turn]
  ring

theorem orbit_norm (n : ℕ) (p : Point) : normSq ((turn^[n]) p) = normSq p := by
  induction n with
  | zero => rfl
  | succ n ih => rw [Function.iterate_succ_apply', spin_norm, ih]

/-- A matrix entry for two hidden rational vectors. A spin needs only addition
    and subtraction in its witnesses, even though it doubles the matrix. -/
def gram (a b : Point) : ℚ := a.1*b.1+a.2*b.2

def doubleWitness (a : Point) : Point := (a.1+a.2,a.1-a.2)

theorem gram_double (a b : Point) :
    gram (doubleWitness a) (doubleWitness b) = 2*gram a b := by
  simp only [gram, doubleWitness]
  ring

theorem gram_diagonal (a : Point) : 0 ≤ gram a a := by
  unfold gram
  nlinarith [sq_nonneg a.1,sq_nonneg a.2]

theorem gram_linear (s t : ℚ) (a b c : Point) :
    gram (s*a.1+t*b.1,s*a.2+t*b.2) c = s*gram a c + t*gram b c := by
  simp only [gram]
  ring

theorem gram_symmetric (a b : Point) : gram a b = gram b a := by
  unfold gram
  ring

/-- Each scaled congruence can update a rank-one factor without a square root. -/
theorem scaled_entry {r a s q u v : ℚ} (positive : 0 < r)
    (large : r ≤ a^2) (scale : 1 ≤ s) (entry : s*q = u*v) :
    1 ≤ (a^2/r)*s ∧ ((a^2/r)*s)*(r*q) = (a*u)*(a*v) := by
  have bound : 1 ≤ a^2/r := (one_le_div positive).mpr large
  refine ⟨one_le_mul_of_one_le_of_one_le bound scale,?_⟩
  calc
    _ = (a^2/r*r)*(s*q) := by ring
    _ = _ := by rw [div_mul_cancel₀ _ positive.ne',entry]; ring

def Box (p : Point) (t : ℚ) := -t ≤ p.1 ∧ p.1 ≤ t ∧ -t ≤ p.2 ∧ p.2 ≤ t

theorem box_spin (p : Point) (t : ℚ) (bounded : Box p t) : Box (turn p) (2*t) := by
  rcases bounded with ⟨a,b,c,d⟩
  unfold Box turn
  dsimp
  constructor <;> repeat' first | constructor | linarith

theorem unit_orbit (n : ℕ) : Box ((turn^[n]) (1,0)) 1 := by
  have h := orbit_norm n (1,0)
  generalize (turn^[n]) ((1,0) : Point) = q at h ⊢
  norm_num [normSq] at h
  unfold Box
  constructor <;> repeat' first | constructor |
    nlinarith [sq_nonneg q.1, sq_nonneg q.2, sq_nonneg (q.1-1), sq_nonneg (q.1+1),
      sq_nonneg (q.2-1), sq_nonneg (q.2+1)]

/-- N exact observations followed by the stable square. -/
def Admits : ℕ → Point → ℚ → Prop
  | 0, p, t => Box p t
  | n+1, p, t => p.1 ≤ 1+t ∧ Admits n (turn p) (2*t)

theorem admits_guard {n : ℕ} {p : Point} {t : ℚ} (h : Admits n p t) : p.1 ≤ 1+t := by
  cases n with
  | zero => have hb : Box p t := h; linarith [hb.2.1]
  | succ n => exact h.1

theorem admits_transition (n : ℕ) (p : Point) (t : ℚ) (h : Admits n p t) :
    Admits n (turn p) (2*t) := by
  induction n generalizing p t with
  | zero => exact box_spin p t h
  | succ n ih => exact ⟨admits_guard h.2, ih (turn p) (2*t) h.2⟩

theorem admits_increasing (n : ℕ) (p : Point) (t : ℚ) (h : Admits n p t) :
    Admits (n+1) p t := ⟨admits_guard h, admits_transition n p t h⟩

theorem admits_unroll (n : ℕ) (p : Point) (t : ℚ) :
    Admits n p t ↔
    (∀ j < n, ((turn^[j]) p).1 ≤ 1 + 2^j*t) ∧ Box ((turn^[n]) p) (2^n*t) := by
  induction n generalizing p t with
  | zero => simp [Admits]
  | succ n ih =>
    rw [Admits, ih]
    have multiply (j : ℕ) : (2:ℚ)^j*(2*t) = 2^(j+1)*t := by rw [pow_succ]; ring
    simp only [multiply, ← Function.iterate_succ_apply]
    constructor
    · rintro ⟨head,tail,box⟩
      refine ⟨?_,box⟩
      intro j hj
      cases j with
      | zero => simpa using head
      | succ j => exact tail j (by omega)
    · rintro ⟨all,box⟩
      exact ⟨by simpa using all 0 (by omega), fun j hj => all (j+1) (by omega),box⟩

theorem positive_probe {t : ℚ} (pos : 0<t) : ∃ n, Admits n (1,0) t := by
  obtain ⟨n,hn⟩ := pow_unbounded_of_one_lt (1/t) (by decide : (1:ℚ)<2)
  have big := (div_lt_iff₀ pos).mp hn
  refine ⟨n,(admits_unroll _ _ _).mpr ⟨?_,?_⟩⟩
  · intro j _
    have bound := (unit_orbit j).2.1
    have hp : 0 ≤ (2:ℚ)^j * t := by positivity
    linarith
  · obtain ⟨a,b,c,d⟩ := unit_orbit n
    unfold Box
    exact ⟨by linarith,by linarith,by linarith,by linarith⟩

/-- At positive slack, finite certification is equivalent to semantic safety. -/
theorem all_positive_calls (p : Point) (t : ℚ) (pos : 0<t) :
    (∃ n, Admits n p t) ↔ ∀ k : ℕ, ((turn^[k]) p).1 ≤ 1+2^k*t := by
  constructor
  · rintro ⟨n,h⟩ k
    have orbit : ∀ j : ℕ, Admits n ((turn^[j]) p) (2^j*t) := by
      intro j
      induction j with
      | zero => simpa using h
      | succ j ih =>
        rw [Function.iterate_succ_apply', pow_succ]
        convert admits_transition n _ _ ih using 1
        ring
    exact admits_guard (orbit k)
  · intro safe
    obtain ⟨n,hn⟩ := pow_unbounded_of_one_lt ((normSq p+1)/t) (by decide : (1:ℚ)<2)
    have large := (div_lt_iff₀ pos).mp hn
    refine ⟨n,(admits_unroll _ _ _).mpr ⟨fun j _ => safe j,?_⟩⟩
    have radius := orbit_norm n p
    generalize (turn^[n]) p = u at radius ⊢
    unfold Box
    unfold normSq at radius large
    constructor <;> repeat' first | constructor |
      nlinarith [sq_nonneg u.1, sq_nonneg u.2, sq_nonneg (u.1-1), sq_nonneg (u.1+1),
        sq_nonneg (u.2-1), sq_nonneg (u.2+1)]

section Witnesses
variable {V E X Z I : Type*} (fields : V → List E) (target : V → E → V)
    (localRel : V → X → Z → Prop) (child : V → E → X → Z → X)
    (close : (X → Prop) → X → Prop)

def Pre (H : V → X → Prop) (v : V) (x : X) : Prop :=
  ∃ z, localRel v x z ∧ ∀ e ∈ fields v, H (target v e) (child v e x z)

/-- The closed hull needs just one witness selection for all siblings.
    The projection of their joint polyhedral constraints is itself closed
    and convex; this is the 'closedPre' premise. -/
theorem family_join (P : I → V → X → Prop)
    (hull_contains : ∀ (S : X → Prop) x, S x → close S x)
    (mono : ∀ (S T : X → Prop), (∀ x, S x → T x) → ∀ x, close S x → close T x)
    (sound : ∀ i v x, P i v x → Pre fields target localRel child (P i) v x)
    (closedPre : let H := fun v => close (fun x => ∃ i, P i v x)
      ∀ v x, close (Pre fields target localRel child H v) x → Pre fields target localRel child H v x) :
    let H := fun v => close (fun x => ∃ i, P i v x)
    ∀ v x, H v x → Pre fields target localRel child H v x := by
  intro H v x hx
  apply closedPre
  apply mono (fun q => ∃ i, P i v q) _ _ x hx
  rintro q ⟨i,hi⟩
  obtain ⟨z,hz,hw⟩ := sound i v q hi
  exact ⟨z,hz,fun e mem => hull_contains _ _ ⟨i,hw e mem⟩⟩

end Witnesses

def SquareWitness (x y z : ℚ) : Prop :=
  0 ≤ z ∧ x+y-1 ≤ z ∧ z ≤ x ∧ z ≤ y

theorem extended_square_witness (θ u v : ℚ)
    (hu : 0 ≤ u) (hu' : u ≤ 1-θ) (hv : 0 ≤ v) (hv' : v ≤ θ) :
    SquareWitness (u+v) θ v := ⟨hv, by linarith, by linarith, hv'⟩

theorem no_public_affine_witness : ¬ ∃ a b c : ℚ, ∀ x y : ℚ,
    0 ≤ x → x ≤ 1 → 0 ≤ y → y ≤ 1 → SquareWitness x y (a*x+b*y+c) := by
  rintro ⟨a,b,c,choose⟩
  have h00 := choose 0 0 (by decide) (by decide) (by decide) (by decide)
  have h10 := choose 1 0 (by decide) (by decide) (by decide) (by decide)
  have h01 := choose 0 1 (by decide) (by decide) (by decide) (by decide)
  have h11 := choose 1 1 (by decide) (by decide) (by decide) (by decide)
  simp only [SquareWitness] at h00 h10 h01 h11
  linarith [h00.1,h10.2.2.2,h01.2.2.1,h11.2.1]

/-- Quantitative witness bounds for the fixed six-index caller's short tile. -/
theorem first_tile_sharp (s : ℚ) :
    1 ≤ s*((1/2)^2+(1/4)^2+(1/4)^2) ↔ 8/3 ≤ s := by
  norm_num
  constructor <;> intro h <;> linarith

theorem later_tiles {b : ℚ} (hb : b ≤ 1/16) :
    3/8 < ((2/3)*(1-b))^2 := by
  have h : (5/8:ℚ) ≤ (2/3)*(1-b) := by linarith
  nlinarith [mul_nonneg (sub_nonneg.mpr h) (by linarith : 0 ≤ (2/3)*(1-b)+5/8)]

end FixedCaller
