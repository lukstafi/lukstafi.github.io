/-
The arithmetic and scope lemmas for constructor-free joint constraint abduction.
Lean 4.19.0 and mathlib v4.19.0. See round-15-constructor-free.md.
-/
import Mathlib.Topology.Algebra.Polynomial
import Mathlib.Topology.Order.IntermediateValue
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring
import Mathlib.Tactic.NormNum

namespace FlatJCA
open Polynomial
abbrev P := Polynomial ℝ

inductive T (α : Type) where
  | a | b | var (v : α) | fork (l r : T α)
  deriving DecidableEq

namespace T

def bind (e : α → T β) : T α → T β
  | .a => .a
  | .b => .b
  | .var j => e j
  | .fork l r => .fork (l.bind e) (r.bind e)

noncomputable def wt (e : α → P) : T α → P
  | .a | .b => 0
  | .var i => e i
  | .fork l r => X * (l.wt e + r.wt e)

theorem wt_bind (t : T α) (env : α → T β) (e : β → P) :
    (t.bind env).wt e = t.wt (fun i => (env i).wt e) := by
  induction t <;> simp_all [bind, wt]

noncomputable def occ [DecidableEq α] (t : T α) (i : α) :=
  t.wt (fun j => if j = i then 1 else 0)

def uses [DecidableEq α] (i : α) : T α → Prop
  | .a | .b => False
  | .var j => j = i
  | .fork l r => uses i l ∨ uses i r

theorem eval_nonneg [DecidableEq α] (t : T α) (i : α) (z : ℝ) (hz : 0 ≤ z) :
    0 ≤ (t.occ i).eval z := by
  induction t with
  | a | b => simp [occ, wt]
  | var j => by_cases h : j = i <;> simp [occ, wt, h]
  | fork l r hl hr =>
    simpa [occ, wt] using mul_nonneg hz (add_nonneg hl hr)

theorem eval_pos [DecidableEq α] (t : T α) (i : α) (z : ℝ) (hz : 0 < z)
    (u : uses i t) : 0 < (t.occ i).eval z := by
  induction t with
  | a | b => contradiction
  | var j => simp_all [uses, occ, wt]
  | fork l r hl hr =>
    apply (show 0 < z * ((l.occ i).eval z + (r.occ i).eval z) → _ from by simp [occ, wt])
    apply mul_pos hz
    rcases u with u | u
    · exact add_pos_of_pos_of_nonneg (hl u) (eval_nonneg r i z hz.le)
    · exact add_pos_of_nonneg_of_pos (eval_nonneg l i z hz.le) (hr u)

theorem eval_one_ge [DecidableEq α] (t : T α) (i : α) (u : uses i t) :
    1 ≤ (t.occ i).eval 1 := by
  induction t with
  | a | b => contradiction
  | var j => simp_all [uses, occ, wt]
  | fork l r hl hr =>
    change 1 ≤ (X * (l.occ i + r.occ i)).eval 1
    simp only [eval_mul, eval_X, one_mul, eval_add]
    rcases u with u | u
    · exact (hl u).trans (le_add_of_nonneg_right (eval_nonneg r i 1 zero_le_one))
    · exact (hr u).trans (le_add_of_nonneg_left (eval_nonneg l i 1 zero_le_one))

end T
open T

noncomputable def head (L : T Bool) : P := L.occ true
noncomputable def tail (L : T Bool) : P := L.occ false

def pair (L : T Bool) (x y : T α) := L.bind (fun j => if j then x else y)

theorem wt_pair (L : T Bool) (x y : T α) (e : α → P) :
    (pair L x y).wt e = head L * x.wt e + tail L * y.wt e := by
  rw [pair, wt_bind]
  induction L with
  | a | b => simp [head, tail, occ, wt]
  | var j => cases j <;> simp [head, tail, occ, wt]
  | fork l r hl hr =>
    simp only [wt, hl, hr, head, tail, occ] at *
    ring

def numeral (L : T Bool) (v w x : T α) : Nat → T α
  | 0 => x
  | k+1 => pair L v (pair L w (numeral L v w x k))

noncomputable def geom (s : P) : Nat → P
  | 0 => 0
  | k+1 => 1 + s * geom s k

theorem geom_sub (s : P) (k : Nat) : (s - 1) * geom s k = s^k - 1 := by
  induction k with
  | zero => simp [geom]
  | succ k ih =>
    rw [geom, pow_succ]
    linear_combination s * ih

theorem wt_num (L : T Bool) (v w x : T α) (k : Nat) (e : α → P) :
    (numeral L v w x k).wt e =
      (head L * v.wt e + tail L * head L * w.wt e) * geom (tail L ^ 2) k +
      (tail L ^ 2)^k * x.wt e := by
  induction k with
  | zero => simp [numeral, geom]
  | succ k ih => simp only [numeral, wt_pair, ih, geom, pow_succ]; ring

inductive Port where
  | r | x | y | v | w | i | j
  deriving DecidableEq

open Port

def args (rr xx yy vv ww ii jj : α) : Port → α
  | .r => rr | .x => xx | .y => yy | .v => vv | .w => ww | .i => ii | .j => jj

def history (G : T Port) (rr xx yy : T Port) :=
  G.bind (args rr xx yy (.var v) (.var w) (.var i) (.var j))

theorem wt_ports (G : T Port) (e : Port → P) :
    G.wt e = G.occ r * e r + G.occ x * e x + G.occ y * e y +
      G.occ v * e v + G.occ w * e w + G.occ i * e i + G.occ j * e j := by
  induction G with
  | a | b => simp [wt, occ]
  | var l => cases l <;> simp [wt, occ]
  | fork l d hl hd =>
    change X * (l.wt e + d.wt e) = _
    rw [hl, hd]
    simp only [occ, wt]
    ring

theorem wt_history (G : T Port) (rr xx yy : T Port) (e : Port → P) :
    (history G rr xx yy).wt e = G.occ r * rr.wt e + G.occ x * xx.wt e + G.occ y * yy.wt e +
      G.occ v * e v + G.occ w * e w + G.occ i * e i + G.occ j * e j := by
  rw [history, wt_bind, wt_ports]; rfl

def Identity (L : T Bool) (G : T Port) (m n p : Nat) : Prop :=
  let N (k : Nat) := numeral L (.var v) (.var w) (.var x) k
  let M (k : Nat) := numeral L (.var i) (.var j) (.var y) k
  history G (pair L (pair L (N p) (M m)) (.var r)) (.var x) (.var y) =
    pair L (pair L (.var x) (.var y)) (history G (.var r) (N n) (M 1))

structure Track (h q R K A V : P) (e d : Nat) : Prop where
  base : K*R*(q^2)^e + A = K + q*A*(q^2)^d
  color : K*R*h*geom (q^2) e + V = q*V + q*A*h*geom (q^2) d

theorem tracks (L : T Bool) (G : T Port) (hid : Identity L G m n p) :
    Track (head L) (tail L) (G.occ r) ((head L)^2) (G.occ x) (G.occ v) p n ∧
    Track (head L) (tail L) (G.occ r) (head L * tail L) (G.occ y) (G.occ i) m 1 := by
  let read (k : Port) (t : T Port) := t.wt (fun l => if l = k then 1 else 0)
  unfold Identity at hid
  have hx := congrArg (read x) hid
  have hv := congrArg (read v) hid
  have hy := congrArg (read y) hid
  have hi := congrArg (read i) hid
  simp [read, wt_history, wt_pair, wt_num, wt, geom] at hx hv hy hi
  constructor
  · constructor
    · linear_combination hx
    · linear_combination hv
  · constructor
    · linear_combination hy
    · simp [geom]
      linear_combination hi

theorem eliminate {h q R K A V : P} (t : Track h q R K A V e d) :
    K*h*(R-1) = (q-1)*(h*A-(q^2-1)*V) := by
  linear_combination h * t.base - (q^2 - 1) * t.color +
    K*R*h*(geom_sub (q^2) e) - q*A*h*(geom_sub (q^2) d)

theorem normalize (L : T Bool) (uh : L.uses true) (uq : L.uses false) :
    tail L ≠ 1 ∧ ∃ z : ℝ, (tail L).eval z = 1 ∧ 0 < (head L).eval z := by
  have zero : (tail L).eval 0 = 0 := by
    cases L with
    | a | b => contradiction
    | var t => cases t <;> simp_all [uses]
    | fork l d => simp [tail, occ, wt]
  have q1 := T.eval_one_ge L false uq
  have continuous := (tail L).continuous
  have atOne : (1 : ℝ) ∈ Set.Icc ((tail L).eval 0) ((tail L).eval 1) :=
    ⟨by rw [zero]; norm_num, q1⟩
  obtain ⟨z, hz, qz⟩ := intermediate_value_Icc (zero_le_one : (0:ℝ) ≤ 1)
    continuous.continuousOn atOne
  have nonzero : z ≠ 0 := by
    rintro rfl
    change (tail L).eval 0 = 1 at qz
    rw [zero] at qz
    exact zero_ne_one qz
  refine ⟨?_, z, qz, T.eval_pos L true z (lt_of_le_of_ne hz.1 (Ne.symm nonzero)) uh⟩
  intro eq
  rw [eq] at zero
  simp at zero

theorem eval_geom_one (q : P) (z : ℝ) (qz : q.eval z = 1) (k : Nat) :
    (geom (q^2) k).eval z = (k : ℝ) := by
  induction k with
  | zero => simp [geom]
  | succ k ih => simp [geom, qz, ih, add_comm]

theorem endpoint {h q R K A V : P} {z : ℝ} (t : Track h q R K A V e d)
    (qz : q.eval z = 1) (kh : 0 < K.eval z) (hh : 0 < h.eval z) :
    K.eval z * (e:ℝ) = A.eval z * (d:ℝ) := by
  have base := congrArg (Polynomial.eval z) t.base
  have color := congrArg (Polynomial.eval z) t.color
  simp [qz, eval_geom_one q z qz] at base color
  have rz : R.eval z = 1 := by
    apply mul_left_cancel₀ (ne_of_gt kh)
    linarith
  rw [rz] at color
  apply mul_right_cancel₀ (ne_of_gt hh)
  linear_combination color

theorem identity_implies_product (L : T Bool) (G : T Port)
    (uh : L.uses true) (uq : L.uses false) (hid : Identity L G m n p) : p = m*n := by
  obtain ⟨q_ne_one, z, qz, hh⟩ := normalize L uh uq
  obtain ⟨t1,t2⟩ := tracks L G hid
  let h := head L
  let q := tail L
  have cancel : q - 1 ≠ 0 := sub_ne_zero.mpr q_ne_one
  have cross : (h*q)*(h*(G.occ x)-(q^2-1)*(G.occ v)) =
      h^2*(h*(G.occ y)-(q^2-1)*(G.occ i)) := by
    apply mul_left_cancel₀ cancel
    dsimp [h, q]
    linear_combination (head L)^2 * eliminate t2 - (head L * tail L) * eliminate t1
  have atZ := congrArg (Polynomial.eval z) cross
  simp [h,q,qz] at atZ
  have e1 := endpoint t1 qz (by simpa using sq_pos_of_pos hh) hh
  have e2 := endpoint t2 qz (by simpa [qz] using hh) hh
  simp [qz] at e1 e2
  have scaled : (G.occ x).eval z = (head L).eval z * (G.occ y).eval z := by
    apply mul_left_cancel₀ (ne_of_gt (sq_pos_of_pos hh))
    linear_combination atZ
  have castEq : (p : ℝ) = (m : ℝ) * (n : ℝ) := by
    apply mul_left_cancel₀ (ne_of_gt (sq_pos_of_pos hh))
    rw [scaled, ← e2] at e1
    linear_combination e1
  exact_mod_cast castEq

#print axioms identity_implies_product

end FlatJCA

namespace FlatJCA.Context
set_option linter.constructorNameAsVariable false
open T (uses)
abbrev Ctx := T Port
abbrev unit : Ctx := .var .x
abbrev live (t : Ctx) := t.uses .x

def sub (a b : Ctx) := a.bind (fun j => if j = .x then b else .var j)
local infixr:65 " ⊚ " => sub

@[simp] theorem unit_sub (t : Ctx) : unit ⊚ t = t := rfl
@[simp] theorem sub_unit (t : Ctx) : t ⊚ unit = t := by
  induction t with
  | var i => cases i <;> rfl
  | a | b => rfl
  | fork l r hl hr => exact congrArg₂ T.fork hl hr

theorem assoc (a b c : Ctx) : (a ⊚ b) ⊚ c = a ⊚ (b ⊚ c) := by
  induction a with
  | var i => cases i <;> rfl
  | a | b => rfl
  | fork l r hl hr => exact congrArg₂ T.fork hl hr

theorem uses_sub (a b : Ctx) (k : Port) : (a ⊚ b).uses k ↔
    (a.uses k ∧ k ≠ .x) ∨ (live a ∧ b.uses k) := by
  induction a with
  | a | b => simp [sub, T.bind, uses, live]
  | var j =>
    by_cases hj : j = .x <;> by_cases hk : j = k <;> simp_all [sub, T.bind, uses, live]
  | fork l r hl hr =>
    change ((l ⊚ b).uses k ∨ (r ⊚ b).uses k) ↔ _
    rw [hl, hr]
    simp only [live, uses]
    tauto

@[simp] theorem live_sub (a b : Ctx) : live (a ⊚ b) ↔ live a ∧ live b := by
  simpa [live] using uses_sub a b .x

def size : Ctx → Nat
  | .fork l r => size l + size r + 1
  | _ => 1

theorem size_pos (t : Ctx) : 0 < size t := by cases t <;> simp [size]
theorem size_sub (a b : Ctx) : size a ≤ size (a ⊚ b) := by
  induction a with
  | a | b => rfl
  | var j => cases j <;> first | exact size_pos b | rfl
  | fork l r hl hr =>
    change size l + size r + 1 ≤ size (l ⊚ b) + size (r ⊚ b) + 1
    omega

theorem size_growth (a b : Ctx) (ha : live a) (hb : 1 < size b) :
    size a < size (a ⊚ b) := by
  induction a with
  | a | b => contradiction
  | var j => change j = .x at ha; subst j; exact hb
  | fork l r hl hr =>
    change size l + size r + 1 < size (l ⊚ b) + size (r ⊚ b) + 1
    rcases ha with h | h
    · have := hl h; have := size_sub r b; omega
    · have := hr h; have := size_sub l b; omega

theorem large_of_live (a : Ctx) (ha : live a) (ne : a ≠ unit) : 1 < size a := by
  cases a with
  | a | b => contradiction
  | var j => change j = .x at ha; subst j; contradiction
  | fork l r => have := size_pos l; have := size_pos r; simp [size]; omega

/-- Subterms of a substitution either lie strictly inside an inserted tree
    or are themselves the substitution of a whole outer subterm. -/
inductive Inside (a : Ctx) : Ctx → Prop
  | root : Inside a a
  | left {l} (r) : Inside a l → Inside a (.fork l r)
  | right (l) {r} : Inside a r → Inside a (.fork l r)

theorem self_or_smaller (h : Inside a b) : a = b ∨ size a < size b := by
  induction h with
  | root => exact Or.inl rfl
  | left r _ ih => right; simp only [size]; rcases ih with rfl | h <;> omega
  | right l _ ih => right; simp only [size]; rcases ih with rfl | h <;> omega

theorem inserted (a d : Ctx) (ha : live a) : Inside d (a ⊚ d) := by
  induction a with
  | a | b => contradiction
  | var j => change j = .x at ha; subst j; exact .root
  | fork l r hl hr =>
    rcases ha with h | h
    · exact .left _ (hl h)
    · exact .right _ (hr h)

theorem factor_inside (a d t : Ctx) (hh : Inside t (a ⊚ d)) (sz : size d ≤ size t) :
    ∃ e, t = e ⊚ d := by
  induction a with
  | var j =>
    by_cases hj : j = .x
    · subst j; change Inside t d at hh; have h := self_or_smaller hh
      exact ⟨unit, h.resolve_right (by omega)⟩
    · have h : Inside t (.var j) := by simpa [sub,T.bind,hj] using hh
      cases h; exact ⟨.var j, by simp [sub,T.bind,hj]⟩
  | a => cases hh; exact ⟨.a,rfl⟩
  | b => cases hh; exact ⟨.b,rfl⟩
  | fork l r hl hr =>
    change Inside t (.fork (l ⊚ d) (r ⊚ d)) at hh
    cases hh with
    | root => exact ⟨.fork l r,rfl⟩
    | left _ h => exact hl h
    | right _ h => exact hr h

theorem right_factor (a b c d : Ctx) (ha : live a) (hb : live b)
    (eq : a ⊚ b = c ⊚ d) (sz : size d ≤ size b) : ∃ e, live e ∧ b = e ⊚ d := by
  have hh := inserted a b ha
  rw [eq] at hh
  obtain ⟨e, eb⟩ := factor_inside c d b hh sz
  exact ⟨e, ((live_sub e d).mp (by rwa [← eb])).1, eb⟩

def contract (d : Ctx) : Ctx → Ctx
  | .a => if T.a = d then unit else .a
  | .b => if T.b = d then unit else .b
  | .var k => if T.var k = d then unit else .var k
  | .fork l r => if T.fork l r = d then unit else .fork (contract d l) (contract d r)

theorem contract_self (d : Ctx) : contract d d = unit := by
  cases d <;> simp [contract]

theorem le_of_inside (hh : Inside a b) : size a ≤ size b := by
  rcases self_or_smaller hh with eq | lt
  · exact le_of_eq (congrArg size eq)
  · exact lt.le

theorem sub_ne (a d : Ctx) (hd : live d) (ne : a ≠ unit) : a ⊚ d ≠ d := by
  intro eq
  have ha := ((live_sub a d).mp (by rwa [eq])).1
  cases a with
  | a | b => contradiction
  | var j => change j = .x at ha; subst j; contradiction
  | fork l r =>
    have ee : size (l ⊚ d) + size (r ⊚ d) + 1 = size d := congrArg size eq
    rcases ha with hl | hr
    · have := le_of_inside (inserted l d hl); omega
    · have := le_of_inside (inserted r d hr); omega

theorem uncontract (a d : Ctx) (hd : live d) : contract d (a ⊚ d) = a := by
  induction a with
  | var j =>
    by_cases hj : j = .x
    · subst j; exact contract_self d
    · have ne : T.var j ⊚ d ≠ d := sub_ne _ _ hd (by simpa [unit] using hj)
      simp [sub,T.bind,hj] at ne
      simp [sub,T.bind,hj,contract,ne]
  | a =>
    have ne : T.a ≠ d := sub_ne T.a d hd (by decide)
    simp [sub,T.bind,contract,ne]
  | b =>
    have ne : T.b ≠ d := sub_ne T.b d hd (by decide)
    simp [sub,T.bind,contract,ne]
  | fork l r hl hr =>
    have ne : T.fork (l ⊚ d) (r ⊚ d) ≠ d := sub_ne (.fork l r) d hd (by intro h; cases h)
    change contract d (.fork (l ⊚ d) (r ⊚ d)) = _
    simp [contract,ne,hl,hr]

theorem cancel_right (a b d : Ctx) (hd : live d) (h : a ⊚ d = b ⊚ d) : a=b := by
  simpa only [uncontract _ _ hd] using congrArg (contract d) h

def power (t : Ctx) : Nat → Ctx
  | 0 => unit
  | n+1 => power t n ⊚ t

theorem power_add (t : Ctx) (m n : Nat) : power t (m+n) = power t m ⊚ power t n := by
  induction n with
  | zero => simp [power]
  | succ n ih =>
    change power t (m+n) ⊚ t = power t m ⊚ (power t n ⊚ t)
    rw [ih, assoc]

theorem power_live (t : Ctx) (ht : live t) (n : Nat) : live (power t n) := by
  induction n with
  | zero => rfl
  | succ n ih => exact (live_sub _ _).mpr ⟨ih, ht⟩

theorem marker_power (t : Ctx) (ht : live t) (k : Port) (hk : k ≠ .x) (n : Nat) :
    (power t (n+1)).uses k ↔ t.uses k := by
  induction n with
  | zero => simp [power]
  | succ n ih =>
    rw [power, uses_sub, ih]
    simp [hk, power_live t ht]

def Common (a b : Ctx) : Prop :=
  ∃ t m n, live t ∧ a = power t m ∧ b = power t n

theorem ordered_step (a b : Ctx) (ha : live a) (hb : live b) (bne : b ≠ unit)
    (ab : a ⊚ b = b ⊚ a) (sz : size b ≤ size a)
    (smaller : ∀ e, live e → size e < size a → e ⊚ b = b ⊚ e → Common e b) :
    Common a b := by
  obtain ⟨e, he, eq⟩ := right_factor b a a b hb ha ab.symm sz
  have esz : size e < size a := eq ▸ size_growth e b he (large_of_live b hb bne)
  have residual : e ⊚ b = b ⊚ e := by
    apply cancel_right _ _ b hb
    rw [← eq, assoc b e b, ← eq, ab]
  obtain ⟨t,u,v,ht,et,bt⟩ := smaller e he esz residual
  exact ⟨t,u+v,v,ht, by rw [eq, et, bt, power_add], bt⟩

theorem common_powers (a b : Ctx) (ha : live a) (hb : live b)
    (ab : a ⊚ b = b ⊚ a) : Common a b := by
  by_cases a0 : a = unit
  · exact ⟨b,0,1,hb,a0,by simp [power]⟩
  by_cases b0 : b = unit
  · exact ⟨a,1,0,ha,by simp [power],b0⟩
  rcases le_total (size b) (size a) with ord | ord
  · apply ordered_step a b ha hb b0 ab ord
    intro e he esz comm
    exact common_powers e b he hb comm
  · have swapped : Common b a := by
      apply ordered_step b a hb ha a0 ab.symm ord
      intro e he esz comm
      exact common_powers e a he ha comm
    obtain ⟨t,m,n,ht,bt,at'⟩ := swapped
    exact ⟨t,n,m,ht,at',bt⟩
termination_by size a + size b
decreasing_by all_goals omega

/-- A marked outer factor followed by a differently marked inner factor
    cannot be a repeated word. This proof only uses comparison of right
    factors, so there is no need to construct the full list of irreducibles. -/
theorem primitive (a b d : Ctx) (ha : live a) (hb : live b) (hd : live d)
    (av : a.uses .v) (aw : ¬ a.uses .w) (bw : b.uses .w) (bv : ¬ b.uses .v)
    (n : Nat) : a ⊚ b ≠ power d (n+2) := by
  intro eq
  have pv : d.uses .v := (marker_power d hd .v (by decide) (n+1)).mp
    (eq ▸ (uses_sub a b .v).mpr (Or.inl ⟨av, by decide⟩))
  have pw : d.uses .w := (marker_power d hd .w (by decide) (n+1)).mp
    (eq ▸ (uses_sub a b .w).mpr (Or.inr ⟨ha, bw⟩))
  change a ⊚ b = power d (n+1) ⊚ d at eq
  rcases le_total (size d) (size b) with sz | sz
  · obtain ⟨e, he, be⟩ := right_factor a b _ d ha hb eq sz
    exact bv (be ▸ (uses_sub e d .v).mpr (Or.inr ⟨he,pv⟩))
  · obtain ⟨e, _, de⟩ := right_factor _ d a b (power_live d hd _) hd eq.symm sz
    have ac : a = power d (n+1) ⊚ e := by
      apply cancel_right _ _ b hb
      calc a ⊚ b = power d (n+1) ⊚ d := eq
           _ = power d (n+1) ⊚ (e ⊚ b) := congrArg (fun v => power d (n+1) ⊚ v) de
           _ = _ := (assoc _ _ _).symm
    have earlier := (marker_power d hd .w (by decide) n).mpr pw
    exact aw (ac ▸ (uses_sub _ _ .w).mpr (Or.inl ⟨earlier, by decide⟩))

theorem uses_pair (L : T Bool) (s t : Ctx) (k : Port) : (pair L s t).uses k ↔
    (L.uses true ∧ s.uses k) ∨ (L.uses false ∧ t.uses k) := by
  induction L with
  | a | b => simp [pair,T.bind,uses]
  | var j => cases j <;> simp [pair,T.bind,uses]
  | fork l r hl hr =>
    change ((pair l s t).uses k ∨ (pair r s t).uses k) ↔ _
    rw [hl, hr]; simp only [uses]; tauto

theorem pair_sub (L : T Bool) (a b t : Ctx) :
    (pair L a b) ⊚ t = pair L (a ⊚ t) (b ⊚ t) := by
  induction L with
  | a | b => rfl
  | var j => cases j <;> rfl
  | fork l r hl hr => exact congrArg₂ T.fork hl hr

theorem numeral_rigidity (L : T Bool) (N : Ctx) (lu : L.uses true) (lv : L.uses false)
    (comm : N ⊚ (pair L (.var .v) (pair L (.var .w) unit)) =
      (pair L (.var .v) (pair L (.var .w) unit)) ⊚ N) :
    ∃ n, N = numeral L (.var .v) (.var .w) unit n := by
  let a : Ctx := pair L (.var .v) unit
  let b : Ctx := pair L (.var .w) unit
  have ha : live a := (uses_pair _ _ _ _).mpr (Or.inr ⟨lv,rfl⟩)
  have hb : live b := (uses_pair _ _ _ _).mpr (Or.inr ⟨lv,rfl⟩)
  have av : a.uses .v := (uses_pair _ _ _ _).mpr (Or.inl ⟨lu,rfl⟩)
  have bw : b.uses .w := (uses_pair _ _ _ _).mpr (Or.inl ⟨lu,rfl⟩)
  have aw : ¬ a.uses .w := by simp [a,uses_pair,uses,unit]
  have bv : ¬ b.uses .v := by simp [b,uses_pair,uses,unit]
  have step (t : Ctx) : (a ⊚ b) ⊚ t = pair L (.var .v) (pair L (.var .w) t) := by
    simp only [a,b,assoc,pair_sub,unit_sub]; rfl
  have one : a ⊚ b = pair L (.var .v) (pair L (.var .w) unit) := by simpa using step unit
  rw [← one] at comm
  have hs := (live_sub a b).mpr ⟨ha,hb⟩
  have sne : a ⊚ b ≠ unit := by
    have vs := (uses_sub a b .v).mpr (Or.inl ⟨av, by decide⟩)
    intro he; rw [he] at vs; contradiction
  have hn : live N := by
    by_contra dead
    have unchanged (t : Ctx) (h : ¬ live t) : t ⊚ (a ⊚ b) = t := by
      induction t with
      | a | b => rfl
      | var j => cases j <;> first | rfl | contradiction
      | fork l r hl hr => exact congrArg₂ T.fork (hl (fun u => h (Or.inl u))) (hr (fun u => h (Or.inr u)))
    rw [unchanged N dead] at comm
    have ne (d : Ctx) (hd : live d) (dn : d ≠ unit) (t : Ctx) : size t < size (d ⊚ t) := by
      cases d with
      | a | b => contradiction
      | var j => change j = .x at hd; subst j; contradiction
      | fork l r =>
        change size t < size (l ⊚ t) + size (r ⊚ t) + 1
        rcases hd with hl | hr
        · have := le_of_inside (inserted l t hl); omega
        · have := le_of_inside (inserted r t hr); omega
    exact (ne _ hs sne N).ne (congrArg size comm)
  obtain ⟨d,k,m,hd,nEq,sEq⟩ := common_powers N (a ⊚ b) hn hs comm
  cases m with
  | zero => exact False.elim (sne sEq)
  | succ m =>
    cases m with
    | succ m => exact False.elim (primitive a b d ha hb hd av aw bw bv m sEq)
    | zero =>
      have ed : a ⊚ b = d := by simpa [power] using sEq
      refine ⟨k, nEq.trans ?_⟩
      rw [← ed]
      clear nEq
      induction k with
      | zero => rfl
      | succ k ih =>
        have ek : power (a ⊚ b) (k+1) = (a ⊚ b) ⊚ power (a ⊚ b) k := by
          rw [Nat.add_comm, power_add]; simp [power]
        rw [ek, step, ih]; rfl

#print axioms numeral_rigidity

end FlatJCA.Context

namespace FlatJCA
set_option linter.constructorNameAsVariable false
open T Port

theorem bind_pair (L : T Bool) (a b : T α) (env : α → T β) :
    (pair L a b).bind env = pair L (a.bind env) (b.bind env) := by
  induction L with
  | a | b => rfl
  | var j => cases j <;> rfl
  | fork l r hl hr => exact congrArg₂ T.fork hl hr

theorem bind_num (L : T Bool) (v w x : T α) (n : Nat) (env : α → T β) :
    (numeral L v w x n).bind env = numeral L (v.bind env) (w.bind env) (x.bind env) n := by
  induction n with
  | zero => rfl
  | succ n ih => simp only [numeral, bind_pair, ih]

theorem num_add (L : T Bool) (v w x : T α) (a b : Nat) :
    numeral L v w (numeral L v w x a) b = numeral L v w x (a+b) := by
  induction b with
  | zero => rfl
  | succ b ih =>
    change pair L v (pair L w _) = pair L v (pair L w _)
    exact congrArg (fun t => pair L v (pair L w t)) ih

/-- A history with len entries, starting at the indicated counter values. -/
def build (L : T Bool) (n : Nat) (v w i j : T α) : Nat → T α → T α → T α → T α
  | 0, tail, _, _ => tail
  | len+1, rest, first, second =>
    pair L (pair L first second)
      (build L n v w i j len rest (numeral L v w first n) (numeral L i j second 1))

theorem bind_build (L : T Bool) (n len : Nat) (v w i j r x y : T α) (env : α → T β) :
    (build L n v w i j len r x y).bind env =
      build L n (v.bind env) (w.bind env) (i.bind env) (j.bind env) len
        (r.bind env) (x.bind env) (y.bind env) := by
  induction len generalizing x y with
  | zero => rfl
  | succ len ih => simp only [build, bind_pair, bind_num, ih]

theorem append_endpoint (L : T Bool) (n m : Nat) (v w i j r x y : T α) :
    build L n v w i j m (pair L (pair L (numeral L v w x (m*n)) (numeral L i j y m)) r) x y =
      build L n v w i j (m+1) r x y := by
  induction m generalizing x y with
  | zero => simp [build, numeral]
  | succ m ih =>
    change pair L (pair L x y) _ = pair L (pair L x y) _
    apply congrArg (pair L (pair L x y))
    have h := ih (numeral L v w x n) (numeral L i j y 1)
    simpa only [num_add, Nat.succ_mul, Nat.add_comm n (m*n), Nat.add_comm 1 m] using h

theorem multiplication_iff (L : T Bool) (uh : L.uses true) (uq : L.uses false)
    (m n p : Nat) : (∃ G, Identity L G m n p) ↔ p = m*n := by
  constructor
  · rintro ⟨G,h⟩; exact identity_implies_product L G uh uq h
  · rintro rfl
    let G : T Port := build L n (.var v) (.var w) (.var i) (.var j) m (.var r) (.var x) (.var y)
    refine ⟨G, ?_⟩
    simp only [Identity, G, history, bind_build, T.bind, args]
    exact append_endpoint L n m _ _ _ _ _ _ _

#print axioms multiplication_iff

end FlatJCA

namespace FlatJCA.Scope
set_option linter.constructorNameAsVariable false
open T (uses)
abbrev Pat := T Nat
abbrev Ground := T Empty
abbrev Env := Nat → Ground

def nodes : T α → Nat
  | .fork l r => nodes l + nodes r + 1
  | _ => 1

def compound : T α → Prop
  | .fork _ _ => True
  | _ => False

theorem occurs_bound (t : Pat) (q : Nat) (e : Env) (h : t.uses q) :
    nodes (e q) ≤ nodes (t.bind e) := by
  induction t with
  | a | b => contradiction
  | var i => cases h; rfl
  | fork l r hl hr =>
    change _ ≤ nodes (l.bind e) + nodes (r.bind e) + 1
    rcases h with h | h
    · have := hl h; omega
    · have := hr h; omega

theorem occurs_strict (t : Pat) (q : Nat) (e : Env) (root : compound t) (h : t.uses q) :
    nodes (e q) < nodes (t.bind e) := by
  cases t with
  | a | b | var => contradiction
  | fork l r =>
    change _ < nodes (l.bind e) + nodes (r.bind e) + 1
    rcases h with h | h
    · have := occurs_bound l _ e h; omega
    · have := occurs_bound r _ e h; omega

def changeAt (e : Env) (q : Nat) (v : Ground) (i : Nat) := if i=q then v else e i

theorem ignore_change (t : Pat) (e : Env) (q : Nat) (v : Ground) (h : ¬t.uses q) :
    t.bind (changeAt e q v) = t.bind e := by
  induction t with
  | a | b => rfl
  | var i => simpa [T.bind,changeAt,uses] using (show (if i=q then v else e i) = e i from if_neg h)
  | fork l r hl hr => exact congrArg₂ T.fork (hl (fun k => h (Or.inl k))) (hr (fun k => h (Or.inr k)))

theorem bare_of_switch (t : Pat) (ea eb : Env) (ha : t.bind ea = .a) (hb : t.bind eb = .b) :
    ∃ q, t = .var q := by
  cases t <;> simp_all [T.bind]

abbrev EqualAt (s t : Pat) (e : Env) := s.bind e = t.bind e

/-- A single comparison with a variable on one side cannot force two
    distinct free parameters to prescribed constants. -/
theorem bare_comparison (z p r : Nat) (t : Pat) (pr : p ≠ r)
    (sat : ∃ e : Env, e z = t.bind e)
    (post : ∀ e : Env, e z = t.bind e → e p = .a ∧ e r = .b) : False := by
  obtain ⟨e0, eq⟩ := sat
  by_cases occurs : t.uses z
  · cases t with
    | a | b => contradiction
    | var k =>
      change k = z at occurs
      subst k
      have := (post (fun _ => .a) rfl).2
      contradiction
    | fork l rr =>
      have small := occurs_strict (.fork l rr) z e0 (by trivial) occurs
      exact (Nat.ne_of_lt small) (congrArg nodes eq)
  · have set (c : Ground) :
        let e := changeAt (fun _ => c) z (t.bind (fun _ => c))
        e z = t.bind e := by
      dsimp only
      rw [ignore_change _ _ _ _ occurs]
      simp [changeAt]
    by_cases zp : z=p
    · subst p
      have bad := (post _ (set .a)).2
      simp [changeAt, Ne.symm pr] at bad
    · have bad := (post _ (set .b)).1
      simp [changeAt, Ne.symm zp] at bad

theorem both_compound (s t : Pat) (p r : Nat) (pr : p ≠ r)
    (sat : ∃ e, EqualAt s t e)
    (post : ∀ e, EqualAt s t e → e p = .a ∧ e r = .b) : compound s ∧ compound t := by
  have left (s t : Pat) (sat : ∃ e, EqualAt s t e)
      (post : ∀ e, EqualAt s t e → e p = .a ∧ e r = .b) : compound s := by
    cases s with
    | fork => trivial
    | var z => exact (bare_comparison z p r t pr sat post).elim
    | a | b =>
      cases t with
      | var z =>
        exact (bare_comparison z p r _ pr (sat.imp (fun _ eq => eq.symm))
                   (fun e eq => post e eq.symm)).elim
      | a | b | fork =>
        obtain ⟨e,eq⟩ := sat
        first | contradiction | exact (T.noConfusion (post (fun _ => T.a) rfl).2)
  exact ⟨left s t sat post, left t s (sat.imp (fun _ h => h.symm)) (fun e h => post e h.symm)⟩

structure FourBranches (q : Nat) (x u v p r : Pat) : Prop where
  comparison : ∃ e, EqualAt u v e
  bindings : ∀ e, EqualAt u v e → p.bind e = .a ∧ r.bind e = .b
  flip : ∃ e : Env, p.bind e = .b ∧ r.bind e = .a
  insideLeft : ∃ e, EqualAt p u e
  expose : ∃ e : Env, EqualAt p x e ∧ e q = v.bind e

theorem exclusion (q : Nat) (x u v p r : Pat) (h : FourBranches q x u v p r) :
    ¬ x.uses q := by
  obtain ⟨e,eq⟩ := h.comparison
  obtain ⟨first,second⟩ := h.bindings e eq
  obtain ⟨d,pb,ra⟩ := h.flip
  obtain ⟨s,rfl⟩ := bare_of_switch p e d first pb
  obtain ⟨t,rfl⟩ := bare_of_switch r d e ra second
  have ne : s ≠ t := by
    rintro rfl
    exact T.noConfusion (first.symm.trans second)
  obtain ⟨uc,vc⟩ := both_compound u v s t ne h.comparison h.bindings
  obtain ⟨eu,ue⟩ := h.insideLeft
  have absent : ¬u.uses s := fun us =>
    (Nat.ne_of_lt (occurs_strict u s eu uc us)) (congrArg nodes ue)
  have inV : v.uses s := by
    by_contra nv
    have eql : EqualAt u v (changeAt e s .b) := by
      unfold EqualAt
      rw [ignore_change _ _ _ _ absent, ignore_change _ _ _ _ nv]
      exact eq
    have bad := (h.bindings _ eql).1
    simp [T.bind,changeAt] at bad
  obtain ⟨last,xe,ve⟩ := h.expose
  intro ox
  have small := occurs_strict v s last vc inV
  have large := occurs_bound x q last ox
  change last s = x.bind last at xe
  rw [← xe, ve] at large
  omega

#print axioms exclusion

def ceiling : Pat → Nat
  | .var k => k
  | .fork l r => max (ceiling l) (ceiling r)
  | _ => 0

theorem below_ceiling (t : Pat) (k : Nat) (u : t.uses k) : k ≤ ceiling t := by
  induction t with
  | a | b => contradiction
  | var z => cases u; rfl
  | fork l r hl hr =>
    rcases u with ul | ur
    · exact (hl ul).trans (le_max_left _ _)
    · exact (hr ur).trans (le_max_right _ _)

theorem flat_scope_iff (q : Nat) (x : Pat) :
    (∃ u v p r, FourBranches q x u v p r) ↔ ¬ x.uses q := by
  constructor
  · rintro ⟨u,v,p,r,h⟩; exact exclusion _ _ _ _ _ _ h
  · intro absent
    let s := max q (ceiling x) + 1
    let t := s+1
    have qs : q ≠ s := by dsimp [s]; omega
    have qt : q ≠ t := by dsimp [s,t]; omega
    have st : s ≠ t := by dsimp [t]; omega
    have noS : ¬ x.uses s := by
      intro u
      have h := below_ceiling x s u
      dsimp [s] at h; omega
    let d : Env := fun _ => .a
    let value := x.bind d
    let e := changeAt (changeAt d q (.fork value .a)) s value
    refine ⟨.fork .a .b, .fork (.var s) (.var t), .var s, .var t, ?_⟩
    constructor
    · refine ⟨changeAt d t .b, ?_⟩
      simp [EqualAt,T.bind,changeAt,d,st]
    · intro env eq
      simpa [EqualAt,T.bind,eq_comm] using eq
    · refine ⟨changeAt d s .b, ?_⟩
      simp [changeAt,d,T.bind,Ne.symm st]
    · exact ⟨fun _ => .fork .a .b, rfl⟩
    · have xe : x.bind e = value :=
        (ignore_change x _ _ _ noS).trans (ignore_change x _ _ _ absent)
      refine ⟨e, ?_, ?_⟩
      · change e s = x.bind e
        rw [xe]
        simp [e,changeAt]
      · simp [T.bind,e,changeAt,d,qs,Ne.symm st,Ne.symm qt]

#print axioms flat_scope_iff

end FlatJCA.Scope
