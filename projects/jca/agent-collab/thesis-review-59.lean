import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import Mathlib.Tactic.FieldSimp
import Mathlib.Data.Rat.Cast.Order
import Mathlib.Algebra.Order.Field.Basic
import Mathlib.Algebra.Order.Ring.Abs

namespace PrivateFolds

def cosine (a : ℚ) := (1-a^2)/(1+a^2)
def sine (a : ℚ) := 2*a/(1+a^2)

theorem rational_rotation (a : ℚ) : cosine a ^ 2 + sine a ^ 2 = 1 := by
  have h : 0 < 1+a^2 := by positivity
  unfold cosine sine
  field_simp
  ring

theorem relaxed_fold (c s x y z : ℚ) (unit : c^2+s^2=1)
    (lo : -(c*y-s*x) ≤ z) (hi : c*y-s*x ≤ z) :
    x^2+y^2 ≤ (c*x+s*y)^2+z^2 := by
  have sq : 0 ≤ (z-(c*y-s*x))*(z+(c*y-s*x)) :=
    mul_nonneg (by linarith) (by linarith)
  nlinarith [congrArg (fun k : ℚ => k*(x^2+y^2)) unit]

theorem last_wedge (a x y : ℚ) (pos : 0 ≤ y) (w : (1-a^2)*y ≤ 2*a*x) :
    x^2+y^2 ≤ (x+a*y)^2 ∧ (x+a*y)^2 ≤ (1+a^2)*(x^2+y^2) := by
  constructor
  · nlinarith [mul_le_mul_of_nonneg_right w pos]
  · nlinarith [sq_nonneg (a*x-y)]

/-- A fold aimed between the previous wedge's midpoint and its far edge. -/
theorem next_wedge {a x y : ℚ} (ha : 0 ≤ a) (small : a ≤ 1/4)
    (hy : 0 ≤ y) (previous : (1-4*a^2)*y ≤ 4*a*x) :
    (1-a^2)*|(1-a^2)*y-2*a*x| ≤ 2*a*((1-a^2)*x+2*a*y) := by
  have aa : a^2 ≤ 1 := by nlinarith [mul_nonneg (sub_nonneg.mpr small) ha]
  have h₁ := mul_le_mul_of_nonneg_left previous (by linarith : 0 ≤ 1-a^2)
  have h₂ := mul_nonneg (show 0 ≤ a^2+3*a^4 by positivity) hy
  by_cases h : 0 ≤ (1-a^2)*y-2*a*x
  · rw [abs_of_nonneg h]
    nlinarith
  · rw [abs_of_neg (lt_of_not_ge h)]
    nlinarith [mul_nonneg (sq_nonneg (1-a^2)) hy, mul_nonneg (sq_nonneg a) hy]

theorem first_wedge {x y : ℚ} (hx : 0 ≤ x) (hy : 0 ≤ y) :
    (3/5)*|(3/5)*y-(4/5)*x| ≤ (4/5)*((3/5)*x+(4/5)*y) := by
  rcases le_total 0 ((3/5)*y-(4/5)*x) with h|h
  · rw [abs_of_nonneg h]; linarith
  · rw [abs_of_nonpos h]; linarith

theorem slack_closes {r δ ε t : ℚ} (hd : 0 ≤ δ) (he : 0 < ε) (ht : ε ≤ t)
    (enough : δ*(1+ε) ≤ (r-1)*ε) :
    (1+δ)*(1+t) ≤ 1+r*t := by
  have gap : 0 ≤ r-1-δ := by
    by_contra! h
    nlinarith [mul_neg_of_neg_of_pos h he]
  nlinarith [mul_nonneg gap (sub_nonneg.mpr ht)]

theorem fixed_start_margin {h δ t : ℚ} (hd : 0 ≤ δ) (budget : 2*δ ≤ h^3/16)
    (ht : 1 ≤ t) :
    2*(1+δ) ≤ 1+(1+h^3/16) ∧ (1+δ)*(1+t) ≤ 1+(1+h^3/16)*t := by
  constructor
  · linarith
  · exact slack_closes hd (by decide : (0:ℚ) < 1) ht (by linarith)

/-- Nonnegative guard weights summing to at least one extend the unit-slice proof to every slack. -/
theorem slice_transfer {mass slope target t : ℚ} (weights : 1≤mass)
    (at_one : mass+slope ≤ 1+target) (ht : 1≤t) :
    mass+slope*t ≤ 1+target*t := by
  have h : slope ≤ target := by linarith
  nlinarith [mul_nonneg (sub_nonneg.mpr h) (sub_nonneg.mpr ht)]

/-- Growth over the extra turns absorbs the radial error of the first angular net. -/
theorem net_margin {z u scale : ℚ} (hz : 0≤z) (hu : 1≤u) (hg : 1+z≤scale) :
    (1+u)*(1+z/2) ≤ 1+scale*u := by
  nlinarith [mul_nonneg hz (sub_nonneg.mpr hu),
             mul_nonneg (sub_nonneg.mpr hg) (show 0 ≤ u by linarith)]

/-- Squared radial bound times squared cosine of one angular step. -/
theorem separated_radius {h η : ℚ} (hp : 0 < h) (small : h < 1)
    (positive : 0 ≤ η) (margin : η < h^2) :
    (1+η)^2*(1+h^2)*(cosine h)^2 < 1 := by
  have hh : h^2 < 1 := by nlinarith [mul_pos (sub_pos.mpr small) (show 0 < 1+h by linarith)]
  have more : (1+η)^2 < (1+h^2)^2 := by
    nlinarith [mul_pos (sub_pos.mpr margin) (show 0 < 2+η+h^2 by positivity)]
  have pos : 0 < (1-h^2)^2 := sq_pos_of_pos (sub_pos.mpr hh)
  have hpos : 0 < 1+h^2 := by positivity
  have step₁ := mul_lt_mul_of_pos_right more pos
  have step₂ : (1+h^2)*(1-h^2)^2 < 1 := by
    nlinarith [sq_pos_of_pos hp, mul_nonneg (sq_nonneg (h^2)) (sub_nonneg.mpr hh.le)]
  have step₃ := mul_lt_mul_of_pos_right step₂ hpos
  calc
    _ = ((1+η)^2*(1-h^2)^2)/(1+h^2) := by unfold cosine; field_simp; ring
    _ < 1 := (div_lt_iff₀ hpos).mpr (by nlinarith)

/-- Two separated inner orbit points cannot share a short supporting vertex. -/
theorem two_supports {x y u v a b : ℚ} (e₁ : x^2+y^2=1) (e₂ : u^2+v^2=1)
    (s₁ : 1 ≤ x*a+y*b) (s₂ : 1 ≤ u*a+v*b) :
    2 ≤ (1+x*u+y*v)*(a^2+b^2) := by
  have h : 2 ≤ (x+u)*a+(y+v)*b := by linarith
  have sq := mul_nonneg (sub_nonneg.mpr h) (show 0 ≤ (x+u)*a+(y+v)*b+2 by linarith)
  have id : (x+u)^2+(y+v)^2=2*(1+x*u+y*v) := by nlinarith
  nlinarith [sq_nonneg ((x+u)*b-(y+v)*a),congrArg (fun k : ℚ => k*(a^2+b^2)) id]

abbrev Point := ℚ × ℚ
def normSq (p : Point) := p.1^2+p.2^2

def width : ℕ → ℚ
  | 0 => 1/2
  | j+1 => width j/2

theorem width_bounds (j : ℕ) : 0 < width j ∧ width j ≤ 1/2 := by
  induction j with
  | zero => norm_num [width]
  | succ j ih => rw [width]; constructor <;> linarith [ih.1,ih.2]

def Step (a : ℚ) (p q : Point) : Prop :=
  q.1 = cosine a*p.1+sine a*p.2 ∧ |cosine a*p.2-sine a*p.1| ≤ q.2

def Wedge (a : ℚ) (q : Point) : Prop := (1-a^2)*q.2 ≤ 2*a*q.1

def tightStep (a : ℚ) (p : Point) : Point :=
  (cosine a*p.1+sine a*p.2, |cosine a*p.2-sine a*p.1|)

def tight (p : Point) : ℕ → Point
  | 0 => tightStep (width 0) (|p.1|,|p.2|)
  | j+1 => tightStep (width (j+1)) (tight p j)

/-- The unrolled existential chain, with one fresh pair per fold. -/
def Lift (p : Point) : ℕ → Point → Prop
  | 0, q => ∃ z : Point, |p.1| ≤ z.1 ∧ |p.2| ≤ z.2 ∧ Step (width 0) z q
  | j+1, q => ∃ z : Point, Lift p j z ∧ Step (width (j+1)) z q

theorem tight_step (a : ℚ) (p : Point) : Step a p (tightStep a p) := ⟨rfl,le_rfl⟩

theorem tight_lifts (p : Point) (j : ℕ) : Lift p j (tight p j) := by
  induction j with
  | zero => exact ⟨(|p.1|,|p.2|),le_rfl,le_rfl,tight_step _ _⟩
  | succ j ih => exact ⟨tight p j,ih,tight_step _ _⟩

theorem step_nonneg {j : ℕ} {p q : Point} (st : Step (width j) p q)
    (hx : 0 ≤ p.1) (hy : 0 ≤ p.2) : 0 ≤ q.1 ∧ 0 ≤ q.2 := by
  have w := width_bounds j
  have hw : (width j)^2 ≤ 1 := by nlinarith [mul_nonneg (sub_nonneg.mpr w.2) w.1.le]
  have hc : 0 ≤ cosine (width j) := div_nonneg (sub_nonneg.mpr hw) (by positivity)
  have hs : 0 ≤ sine (width j) := div_nonneg (by linarith [w.1]) (by positivity)
  exact ⟨st.1 ▸ add_nonneg (mul_nonneg hc hx) (mul_nonneg hs hy),le_trans (abs_nonneg _) st.2⟩

theorem lift_nonneg {p q : Point} {j : ℕ} (h : Lift p j q) : 0 ≤ q.1 ∧ 0 ≤ q.2 := by
  induction j generalizing q with
  | zero =>
    obtain ⟨z,hx,hy,st⟩ := h
    exact step_nonneg st ((abs_nonneg _).trans hx) ((abs_nonneg _).trans hy)
  | succ j ih =>
    obtain ⟨z,hz,st⟩ := h
    exact step_nonneg st (ih hz).1 (ih hz).2

theorem step_norm {a : ℚ} {p q : Point} (h : Step a p q) : normSq p ≤ normSq q := by
  obtain ⟨hx,hy⟩ := h
  unfold normSq
  rw [hx]
  exact relaxed_fold _ _ _ _ _ (rational_rotation a) ((neg_le_abs _).trans hy) ((le_abs_self _).trans hy)

theorem lift_norm {p q : Point} {j : ℕ} (h : Lift p j q) : normSq p ≤ normSq q := by
  induction j generalizing q with
  | zero =>
    obtain ⟨z,hx,hy,st⟩ := h
    apply le_trans _ (step_norm st)
    unfold normSq
    nlinarith [sq_abs p.1,sq_abs p.2,
      mul_nonneg (sub_nonneg.mpr hx) (add_nonneg ((abs_nonneg p.1).trans hx) (abs_nonneg p.1)),
      mul_nonneg (sub_nonneg.mpr hy) (add_nonneg ((abs_nonneg p.2).trans hy) (abs_nonneg p.2))]
  | succ j ih => obtain ⟨z,hz,st⟩ := h; exact (ih hz).trans (step_norm st)

theorem tight_step_norm (a : ℚ) (p : Point) : normSq (tightStep a p) = normSq p := by
  simp only [tightStep,normSq,sq_abs]
  nlinarith [congrArg (fun k : ℚ => k*(p.1^2+p.2^2)) (rational_rotation a)]

theorem tight_norm (p : Point) (j : ℕ) : normSq (tight p j) = normSq p := by
  induction j with
  | zero => rw [tight,tight_step_norm]; simp [normSq]
  | succ j ih => rw [tight,tight_step_norm,ih]

theorem tight_wedge (p : Point) (j : ℕ) : Wedge (width j) (tight p j) := by
  induction j with
  | zero =>
    have h := first_wedge (abs_nonneg p.1) (abs_nonneg p.2)
    norm_num [Wedge,width,tight,tightStep,cosine,sine] at h ⊢
    linarith
  | succ j ih =>
    let a := width (j+1)
    let z := tight p j
    have small : a ≤ 1/4 := by dsimp only [a,width]; linarith [(width_bounds j).2]
    have prev : width j=2*a := by dsimp only [a,width]; ring
    have hprev : (1-4*a^2)*z.2 ≤ 4*a*z.1 := by
      change (1-(width j)^2)*z.2 ≤ 2*width j*z.1 at ih
      rw [prev] at ih
      linarith
    have h := next_wedge (width_bounds (j+1)).1.le small (lift_nonneg (tight_lifts p j)).2 hprev
    change (1-a^2)*|cosine a*z.2-sine a*z.1| ≤ 2*a*(cosine a*z.1+sine a*z.2)
    have hd : 0 < 1+a^2 := by positivity
    have xeq : cosine a*z.1+sine a*z.2=((1-a^2)*z.1+2*a*z.2)/(1+a^2) := by
      unfold cosine sine; field_simp
    have yeq : cosine a*z.2-sine a*z.1=((1-a^2)*z.2-2*a*z.1)/(1+a^2) := by
      unfold cosine sine; field_simp
    rw [xeq,yeq,abs_div,abs_of_pos hd,← mul_div_assoc,← mul_div_assoc]
    exact (div_le_div_iff_of_pos_right hd).mpr h

def Tail (j : ℕ) (p : Point) (t : ℚ) : Prop :=
  1 ≤ t ∧ ∃ q, Lift p j q ∧ Wedge (width j) q ∧ q.1+width j*q.2 ≤ 1+t

theorem tail_sound {j : ℕ} {p : Point} {t : ℚ} (h : Tail j p t) : normSq p ≤ (1+t)^2 := by
  obtain ⟨ht,q,hq,hw,cap⟩ := h
  have nn := lift_nonneg hq
  have nonneg := add_nonneg nn.1 (mul_nonneg (width_bounds j).1.le nn.2)
  apply (lift_norm hq).trans
  apply (last_wedge _ _ _ nn.2 hw).1.trans
  nlinarith [mul_nonneg (sub_nonneg.mpr cap) (add_nonneg (by linarith : 0≤1+t) nonneg)]

theorem tail_complete {j : ℕ} {p : Point} {t : ℚ} (ht : 1 ≤ t)
    (margin : (1+(width j)^2)*normSq p ≤ (1+t)^2) : Tail j p t := by
  let q := tight p j
  have hz := tight_lifts p j
  have hw := tight_wedge p j
  refine ⟨ht,q,hz,hw,?_⟩
  have hq : q.1^2+q.2^2=normSq p := tight_norm p j
  have bound := (last_wedge _ _ _ (lift_nonneg hz).2 hw).2
  change (q.1+width j*q.2)^2 ≤ (1+(width j)^2)*(q.1^2+q.2^2) at bound
  rw [hq] at bound
  by_contra! hn
  nlinarith [mul_pos (sub_pos.mpr hn) (show 0 < q.1+width j*q.2+(1+t) by linarith)]

/-- All possible parents, all rational tight child openings, and the one fixed caller. -/
theorem fixed_certificate (j : ℕ) (g : Point → Point) (isometry : ∀ p, normSq (g p)=normSq p)
    (r : ℚ) (rate : (width j)^2 ≤ r-1) :
    let P := fun (p : Point) t => 1 ≤ t ∧ p.1 ≤ 1+t ∧ Tail j (g p) (r*t)
    P (2,0) 1 ∧ ∀ p t, P p t → p.1 ≤ 1+t ∧ P (g p) (r*t) := by
  intro P
  have hr : 1 ≤ r := by nlinarith [sq_nonneg (width j)]
  have advance (p : Point) (t : ℚ) (ht : 1≤t) (norm : normSq p ≤ (1+t)^2) :
      Tail j (g p) (r*t) := by
    apply tail_complete (one_le_mul_of_one_le_of_one_le hr ht)
    rw [isometry]
    have cap : (1+(width j)^2/2)*(1+t) ≤ 1+r*t :=
      slack_closes (δ := (width j)^2/2) (by positivity) (by decide : (0:ℚ)<1) ht (by linarith)
    have mult := mul_le_mul_of_nonneg_left norm (by positivity : 0 ≤ 1+(width j)^2)
    have sq := mul_nonneg (sub_nonneg.mpr cap) (show 0 ≤ 1+r*t+(1+(width j)^2/2)*(1+t) by
      have hb : 0 ≤ (1+(width j)^2/2)*(1+t) := mul_nonneg (by positivity) (by linarith)
      linarith [one_le_mul_of_one_le_of_one_le hr ht])
    have extra := mul_nonneg (sq_nonneg ((width j)^2/2)) (sq_nonneg (1+t))
    nlinarith
  constructor
  · exact ⟨le_rfl,by norm_num,advance (2,0) 1 le_rfl (by norm_num [normSq])⟩
  · rintro p t ⟨_,guard,child⟩
    have safe := tail_sound child
    have ht := child.1
    have childGuard : (g p).1 ≤ 1+r*t := by
      unfold normSq at safe
      by_contra! hn
      have hp : 0 < (g p).1+(1+r*t) := by linarith
      nlinarith [sq_nonneg (g p).2, mul_pos (sub_pos.mpr hn) hp]
    exact ⟨guard,ht,childGuard,advance _ _ ht safe⟩

def rotate (h : ℚ) (p : Point) : Point :=
  (cosine h*p.1-sine h*p.2, sine h*p.1+cosine h*p.2)

theorem rotate_norm (h : ℚ) (p : Point) : normSq (rotate h p) = normSq p := by
  unfold normSq rotate
  dsimp only
  nlinarith [congrArg (fun k : ℚ => k*(p.1^2+p.2^2)) (rational_rotation h)]

theorem width_pow (j : ℕ) : width j = (1/2 : ℚ)^(j+1) := by
  induction j with
  | zero => norm_num [width]
  | succ j ih => rw [width, ih, pow_succ _ (j+1)]; ring

/-- The precise field, rate, depth and caller in the surface programme. -/
theorem source_certificate (n : ℕ) :
    let j := (3*n+3)/2
    let h := (1/2 : ℚ)^n
    let r := 1+h^3/16
    let P := fun (p : Point) t => 1 ≤ t ∧ p.1 ≤ 1+t ∧ Tail j (rotate h p) (r*t)
    P (2,0) 1 ∧ ∀ p t, P p t → p.1 ≤ 1+t ∧ P (rotate h p) (r*t) := by
  intro j h r
  apply fixed_certificate j (rotate h) (rotate_norm h) r
  have exponents : n*3+4 ≤ (j+1)*2 := by dsimp [j]; omega
  have bound := pow_le_pow_of_le_one (by norm_num : 0 ≤ (1/2 : ℚ)) (by norm_num) exponents
  rw [pow_add, pow_mul, pow_mul] at bound
  rw [width_pow]
  dsimp [h,r]
  norm_num at bound ⊢
  linarith

/-- A two-inequality public certificate when the language admits squared radius. -/
theorem quadratic_certificate (h r : ℚ) (hr : 1 ≤ r) :
    let P := fun (p : Point) (t : ℚ) => normSq p ≤ 4 ∧ 1 ≤ t
    P (2,0) 1 ∧ ∀ p t, P p t → p.1 ≤ 1+t ∧ P (rotate h p) (r*t) := by
  intro P
  constructor
  · exact ⟨by norm_num [normSq],le_rfl⟩
  · rintro p t ⟨hp,ht⟩
    refine ⟨?_,(rotate_norm h p).le.trans hp,one_le_mul_of_one_le_of_one_le hr ht⟩
    unfold normSq at hp
    by_contra! hn
    have hx : 2 < p.1 := by linarith
    nlinarith [sq_nonneg p.2, mul_pos (sub_pos.mpr hx) (show 0 < p.1+2 by linarith)]

/-- The preserved homogeneous planar quadratics are precisely the multiples of radius squared. -/
theorem radius_unique (a b d c s : ℚ) (unit : c^2+s^2=1) (turns : s≠0)
    (invariant : ∀ x y : ℚ,
      a*(c*x-s*y)^2+2*b*(c*x-s*y)*(s*x+c*y)+d*(s*x+c*y)^2 = a*x^2+2*b*x*y+d*y^2) :
    a=d ∧ b=0 := by
  have e := invariant 1 0
  have f := invariant 0 1
  have g := invariant 1 1
  have one : s*((d-a)*s+2*b*c)=0 := by
    nlinarith [congrArg (fun v : ℚ => a*v) unit]
  have two : s*((d-a)*c-2*b*s)=0 := by
    nlinarith [congrArg (fun v : ℚ => b*v) unit]
  have u := (mul_eq_zero.mp one).resolve_left turns
  have v := (mul_eq_zero.mp two).resolve_left turns
  constructor
  · nlinarith [congrArg (fun k : ℚ => s*k) u, congrArg (fun k : ℚ => c*k) v,
               congrArg (fun k : ℚ => (d-a)*k) unit]
  · nlinarith [congrArg (fun k : ℚ => c*k) u, congrArg (fun k : ℚ => s*k) v,
               congrArg (fun k : ℚ => b*k) unit]

/-- The fixed-axis cone covers every caller on the tilted ray with a quadratic guard. -/
theorem axis_cone_certificate (h : ℚ) :
    let P := fun (p : Point) (z t : ℚ) => z≤0 ∧ normSq p≤z^2 ∧ 1≤t
    (∀ u : ℚ, 0≤u → P (u,0) (-2*u) 1) ∧
    ∀ p z t, P p z t → p.1+z≤1+t ∧ P (rotate h p) z (2*t) := by
  intro P
  constructor
  · intro u hu
    exact ⟨by linarith,by dsimp [normSq]; nlinarith [sq_nonneg u],le_rfl⟩
  · rintro p z t ⟨hz,hn,ht⟩
    refine ⟨?_,hz,(rotate_norm h p).le.trans hn,by linarith⟩
    unfold normSq at hn
    by_contra! bad
    have high : -z<p.1 := by linarith
    nlinarith [sq_nonneg p.2, mul_pos (sub_pos.mpr high) (show 0<p.1-z by linarith)]

section Unfolding
variable {X E : Type*} (guard : X → Prop) (step : E → X → X)

def Pre (P : X → Prop) (x : X) : Prop := guard x ∧ ∀ e, P (step e x)

theorem pre_mono {P Q : X → Prop} (incl : ∀ x, P x → Q x) (x : X) :
    Pre guard step P x → Pre guard step Q x := fun ⟨hg,h⟩ => ⟨hg,fun e => incl _ (h e)⟩

def level (seed : X → Prop) : ℕ → X → Prop
  | 0 => seed
  | n+1 => Pre guard step (level seed n)

theorem increasing (seed : X → Prop) (base : ∀ x, seed x → Pre guard step seed x) :
    ∀ n x, level guard step seed n x → level guard step seed (n+1) x := by
  intro n
  induction n with
  | zero => exact base
  | succ n ih => exact pre_mono guard step ih

def follow (x : X) : List E → X
  | [] => x
  | e::es => follow (step e x) es

/-- An entire finite branching frontier reaches the seed, with guards at every earlier node. -/
theorem reaches_seed (seed : X → Prop) (n : ℕ) (x : X)
    (guardsAt : ∀ es : List E, es.length<n → guard (follow step x es))
    (frontier : ∀ es : List E, es.length=n → seed (follow step x es)) :
    level guard step seed n x := by
  induction n generalizing x with
  | zero => exact frontier [] rfl
  | succ n ih =>
    refine ⟨guardsAt [] (by simp), fun e => ih (step e x) ?_ ?_⟩
    · intro es h
      exact guardsAt (e::es) (by simp [h])
    · intro es h
      exact frontier (e::es) (by simp [h])

/-- One common inductive predicate for an arbitrary family with a uniform frontier depth. -/
theorem uniform_certificate (seed caller : X → Prop) (n : ℕ)
    (base : ∀ x, seed x → Pre guard step seed x)
    (guardsAt : ∀ x, caller x → ∀ es : List E, es.length<n → guard (follow step x es))
    (frontier : ∀ x, caller x → ∀ es : List E, es.length=n → seed (follow step x es)) :
    (∀ x, caller x → level guard step seed n x) ∧
    ∀ x, level guard step seed n x → Pre guard step (level guard step seed n) x := by
  exact ⟨fun x h => reaches_seed guard step seed n x (guardsAt x h) (frontier x h),
         increasing guard step seed base n⟩

end Unfolding
end PrivateFolds
