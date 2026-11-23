import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import Mathlib.Data.Matrix.Mul
import Mathlib.Algebra.Order.Archimedean.Basic
import Mathlib.Algebra.Order.Field.Rat

namespace CyclicSeparation

/-- A column-vector tile update, with its two word fractions and shrink factors. -/
structure Tile where
  u : ℚ
  v : ℚ
  b : ℚ
  c : ℚ
  u_nonneg : 0 ≤ u
  v_nonneg : 0 ≤ v
  b_nonneg : 0 ≤ b
  c_nonneg : 0 ≤ c
  u_bound : u ≤ (2/3) * (1-b)
  v_bound : v ≤ (2/3) * (1-c)

structure Point where
  x : ℚ
  y : ℚ
  z : ℚ

def step (t : Tile) (p : Point) : Point :=
  ⟨p.x + t.u*p.y - t.v*p.z, t.b*p.y, t.c*p.z⟩

def cone (sign scale margin : ℚ) (p : Point) : Prop :=
  0 ≤ p.y ∧ 0 ≤ p.z ∧ (2/3)*(p.y+p.z)+margin*scale ≤ sign*p.x

theorem cone_preserved (t : Tile) (p : Point) (sign scale margin : ℚ)
    (orientation : sign = 1 ∨ sign = -1) (hp : cone sign scale margin p) :
    cone sign scale margin (step t p) := by
  obtain ⟨hy,hz,ha⟩ := hp
  refine ⟨mul_nonneg t.b_nonneg hy, mul_nonneg t.c_nonneg hz, ?_⟩
  have hu := mul_le_mul_of_nonneg_right t.u_bound hy
  have hv := mul_le_mul_of_nonneg_right t.v_bound hz
  have yu := mul_nonneg t.u_nonneg hy
  have zv := mul_nonneg t.v_nonneg hz
  have by' := mul_le_mul_of_nonneg_right
    (show t.b ≤ 1 by linarith [t.u_nonneg, t.u_bound]) hy
  have cz := mul_le_mul_of_nonneg_right
    (show t.c ≤ 1 by linarith [t.v_nonneg, t.v_bound]) hz
  rcases orientation with rfl | rfl <;> dsimp only [step] <;> linarith

def dot (p q : Point) : ℚ := p.x*q.x+p.y*q.y+p.z*q.z

/-- The trace of a generator from one sign cone controls its homogenizing coordinate. -/
theorem cone_trace (p q : Point) (sign h k margin : ℚ)
    (orientation : sign = 1 ∨ sign = -1) (hh : 0 ≤ h) (hk : 0 ≤ k)
    (hm : 0 ≤ margin) (hp : cone sign h margin p) (hq : cone sign k margin q) :
    margin^2*(h*k) ≤ dot p q := by
  obtain ⟨py,pz,px⟩ := hp
  obtain ⟨qy,qz,qx⟩ := hq
  have ph : margin*h ≤ sign*p.x := by linarith
  have qk : margin*k ≤ sign*q.x := by linarith
  have prod := mul_le_mul ph qk (mul_nonneg hm hk) ((mul_nonneg hm hh).trans ph)
  have yy := mul_nonneg py qy
  have zz := mul_nonneg pz qz
  unfold dot
  rcases orientation with rfl | rfl <;> nlinarith

structure Symmetric where
  xx : ℚ
  xy : ℚ
  xz : ℚ
  yy : ℚ
  yz : ℚ
  zz : ℚ

def pair (p q : Point) : Symmetric :=
  ⟨p.x*q.x, (p.x*q.y+p.y*q.x)/2, (p.x*q.z+p.z*q.x)/2,
   p.y*q.y, (p.y*q.z+p.z*q.y)/2, p.z*q.z⟩

def image (t : Tile) (q : Symmetric) : Symmetric :=
  ⟨q.xx+2*t.u*q.xy-2*t.v*q.xz+t.u^2*q.yy-2*t.u*t.v*q.yz+t.v^2*q.zz,
   t.b*(q.xy+t.u*q.yy-t.v*q.yz), t.c*(q.xz+t.u*q.yz-t.v*q.zz),
   t.b^2*q.yy,t.b*t.c*q.yz,t.c^2*q.zz⟩

theorem bilinear_image (t : Tile) (p q : Point) :
    image t (pair p q) = pair (step t p) (step t q) := by
  simp only [image, pair, step, Symmetric.mk.injEq]
  constructor <;> repeat' first | constructor | ring

theorem trace_pair (p q : Point) :
    (pair p q).xx + (pair p q).yy + (pair p q).zz = dot p q := rfl

/-- A single nonnegative witness update works for every opening of the scheme. -/
theorem transport_weights {d m : ℕ} (A : Matrix (Fin d) (Fin d) ℚ)
    (G : Matrix (Fin d) (Fin m) ℚ) (W : Matrix (Fin m) (Fin m) ℚ)
    (compatible : A*G = G*W) (positive : ∀ i j, 0 ≤ W i j)
    (w : Fin m → ℚ) (weights : ∀ j, 0 ≤ w j) :
    A.mulVec (G.mulVec w) = G.mulVec (W.mulVec w) ∧ ∀ i, 0 ≤ W.mulVec w i := by
  constructor
  · rw [Matrix.mulVec_mulVec, Matrix.mulVec_mulVec, compatible]
  · intro i
    exact Finset.sum_nonneg (fun j _ => mul_nonneg (positive i j) (weights j))

/-- Along the matching zero tile the six-index trace eventually fails at every scale. -/
theorem shrinking_ray (s : ℚ) : ∃ n : ℕ, (2*s)/16^n < 1 := by
  obtain ⟨n,hn⟩ := pow_unbounded_of_one_lt (2*s) (by decide : (1:ℚ) < 16)
  exact ⟨n, (div_lt_one (by positivity)).mpr hn⟩

end CyclicSeparation
