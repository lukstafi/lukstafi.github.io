import Std

namespace RecursiveIntervals

structure Band where
  lo : Int
  hi : Int
  ordered : lo ≤ hi

abbrev Outside (b : Band) (k : Int) := k < b.lo ∨ b.hi < k

theorem forbidden_keys (a b l u k : Int) (hab : a ≤ b) (hlu : l ≤ u) :
    (∀ r : Int, k+a ≤ r → r ≤ k+b → ¬ (l ≤ r ∧ r ≤ u)) ↔
    k < l-b ∨ u-a < k := by
  constructor
  · intro safe
    have bad := safe (max (k+a) l)
    omega
  · rintro ok r lower upper
    omega

theorem merge_outside (a b : Band) (first : a.lo ≤ b.lo) (touch : b.lo ≤ a.hi+1) (x : Int) :
    Outside ⟨a.lo, max a.hi b.hi, by have := a.ordered; omega⟩ x ↔ Outside a x ∧ Outside b x := by
  simp only [Outside]
  omega

def previous (b : Band) (x : Int) := if Outside b x then x else b.lo-1

/-- One max and one min express the greatest admissible integer below x. -/
theorem as_extrema (b : Band) (x : Int) :
    previous b x = min x (max (b.lo-1) (b.lo-1+(b.hi-b.lo+2)*(x-b.hi))) := by
  have order := b.ordered
  unfold previous Outside
  split
  · rename_i off
    rcases off with left | right
    · omega
    · have prod := Int.mul_nonneg (by omega : 0 ≤ b.hi-b.lo+1) (by omega : 0 ≤ x-b.hi-1)
      simp only [Int.mul_sub, Int.sub_mul, Int.add_mul, Int.mul_one, Int.one_mul,
        Int.ofNat_mul] at prod ⊢
      omega
  · rename_i inside
    have prod := Int.mul_nonpos_of_nonneg_of_nonpos (by omega : 0 ≤ b.hi-b.lo+2) (by omega : x-b.hi ≤ 0)
    omega

def project : List Band → Int → Int
  | [], x => x
  | b::bs, x => project bs (previous b x)

def Descending : List Band → Prop
  | [] => True
  | b::bs => (∀ c ∈ bs, c.lo ≤ b.lo) ∧ Descending bs

private theorem prev_spec (b : Band) (x : Int) :
    previous b x ≤ x ∧ Outside b (previous b x) ∧
    ∀ k ≤ x, Outside b k → k ≤ previous b x := by
  have := b.ordered
  unfold previous Outside
  split <;> (refine ⟨by omega, by omega, ?_⟩; intro k upper safe; omega)

theorem below (bs : List Band) (x : Int) : project bs x ≤ x := by
  induction bs generalizing x with
  | nil => exact Int.le_refl _
  | cons b bs ih => exact Int.le_trans (ih _) (prev_spec b x).1

private theorem moved (bs : List Band) (bound x : Int) (h : ∀ c ∈ bs, c.lo ≤ bound) :
    project bs x = x ∨ project bs x < bound := by
  induction bs generalizing x with
  | nil => exact Or.inl rfl
  | cons b bs ih =>
    have current := h b (by simp)
    obtain eq | lt := ih (previous b x) (fun c hc => h c (by simp [hc]))
    · change project bs (previous b x) = x ∨ project bs (previous b x) < bound
      rw [eq]
      unfold previous
      split <;> omega
    · exact Or.inr lt

theorem projection_spec (bs : List Band) (order : Descending bs) (x : Int) :
    (∀ b ∈ bs, Outside b (project bs x)) ∧
    (∀ k ≤ x, (∀ b ∈ bs, Outside b k) → k ≤ project bs x) := by
  induction bs generalizing x with
  | nil => simp [project]
  | cons b bs ih =>
    obtain ⟨tail, greatest⟩ := ih order.2 (previous b x)
    have curr := prev_spec b x
    constructor
    · intro c hc
      rcases List.mem_cons.mp hc with rfl | mem
      · rcases moved bs c.lo (previous c x) order.1 with same | low
        · simpa [project, same] using curr.2.1
        · exact Or.inl low
      · exact tail c mem
    · intro k upper all
      exact greatest k (curr.2.2 k upper (all b (by simp)))
        (fun c hc => all c (by simp [hc]))

theorem eliminate (bs : List Band) (order : Descending bs) (l u : Int) :
    (∃ k : Int, l ≤ k ∧ k ≤ u ∧ ∀ b ∈ bs, Outside b k) ↔ l ≤ project bs u := by
  obtain ⟨safe,greatest⟩ := projection_spec bs order u
  exact ⟨fun ⟨k,h,hu,ok⟩ => Int.le_trans h (greatest k hu ok),
         fun h => ⟨_,h,below bs u,safe⟩⟩

/-- Any successful pointwise choice yields a single policy in the observed
    upper endpoint, even when the histories and lower endpoints are hidden. -/
theorem uniform {H : Type} (bs : List Band) (order : Descending bs) (l u : H → Int) :
    (∀ h, ∃ k : Int, l h ≤ k ∧ k ≤ u h ∧ ∀ b ∈ bs, Outside b k) ↔
    ∃ policy : Int → Int, ∀ h, l h ≤ policy (u h) ∧ policy (u h) ≤ u h ∧
      ∀ b ∈ bs, Outside b (policy (u h)) := by
  constructor
  · intro pointwise
    exact ⟨project bs, fun h => ⟨(eliminate bs order _ _).mp (pointwise h),
      below bs _, (projection_spec bs order _).1⟩⟩
  · rintro ⟨p,works⟩ h
    exact ⟨p (u h),works h⟩

/-- By holding the sign fixed one obtains a unique safe key at every width. -/
def Works (s w k : Int) := k ≤ s ∧ s ≤ k+w ∧ (k+w < 0 ∨ 0 < k)

theorem compact_relation (s w k : Int) :
    Works s w k ↔ k ≤ s ∧ s ≤ k+w ∧ min (k+w+1) (1-k) ≤ 0 := by
  unfold Works
  omega

theorem forced (w k : Int) (hw : 0 ≤ w) :
    (Works (-1) w k ↔ k = -1-w) ∧ (Works 1 w k ↔ k = 1) := by
  unfold Works
  omega

inductive Expr
  | affine (a b c : Int)
  | add (a b : Expr)
  | neg (a : Expr)
  | min (a b : Expr)
  | max (a b : Expr)

def Expr.eval : Expr → Int → Int → Int
  | .affine a b c, s, w => a*s+b*w+c
  | .add a b, s, w => a.eval s w+b.eval s w
  | .neg a, s, w => -a.eval s w
  | .min a b, s, w => Min.min (a.eval s w) (b.eval s w)
  | .max a b, s, w => Max.max (a.eval s w) (b.eval s w)

def Expr.rate : Expr → Int
  | .affine a _ _ => Max.max a (-a)
  | .add a b => a.rate+b.rate
  | .neg a => a.rate
  | .min a b | .max a b => Max.max a.rate b.rate

/-- The change over the two-unit sign step is uniformly bounded in w.
    Integer scaling is finite addition and negation. -/
theorem bounded_change (e : Expr) (w : Int) :
    -(2*e.rate) ≤ e.eval 1 w - e.eval (-1) w ∧
    e.eval 1 w - e.eval (-1) w ≤ 2*e.rate := by
  induction e with
  | affine a b c => simp only [Expr.eval, Expr.rate, Int.mul_one, Int.mul_neg]; omega
  | add a b ia ib | min a b ia ib | max a b ia ib =>
    simp only [Expr.eval, Expr.rate]; omega
  | neg a ih => simp only [Expr.eval, Expr.rate]; omega

theorem necessary_rate (e : Expr) (w : Int) (hw : 0 ≤ w)
    (left : Works (-1) w (e.eval (-1) w)) (right : Works 1 w (e.eval 1 w)) :
    w+2 ≤ 2*e.rate := by
  have gap := bounded_change e w
  rw [(forced w _ hw).1.mp left, (forced w _ hw).2.mp right] at gap
  omega

theorem no_term (e : Expr) :
    ¬ ∀ w : Int, 0 ≤ w → Works (-1) w (e.eval (-1) w) ∧ Works 1 w (e.eval 1 w) := by
  intro all
  let w := max 0 (2*e.rate)
  have hw : 0 ≤ w := by dsimp [w]; omega
  obtain ⟨left,right⟩ := all w hw
  have := necessary_rate e w hw left right
  dsimp [w] at this
  omega

theorem bounded_width (M w : Int) (hw : 0 ≤ w) (cap : w ≤ 2*M) :
    let k := fun s : Int => min s ((M+1)*s+M-w)
    Works (-1) w (k (-1)) ∧ Works 1 w (k 1) := by
  simp only [Works, Int.mul_neg, Int.mul_one]
  omega

end RecursiveIntervals
