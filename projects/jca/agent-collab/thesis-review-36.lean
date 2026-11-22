import Std

namespace ComponentKeys

/-- Admission and hitting every possible point hole characterize a cover. -/
theorem point_cover (D : K → Prop) (q : I → K → K)
    (admitted : ∀ i x, D (q i x)) :
    (∀ x, (∀ i, q i x ≠ x) ↔ ∀ k, D k → k ≠ x) ↔
      ∀ x, D x → ∃ i, q i x = x := by
  classical
  constructor
  · intro exactAt x member
    apply Classical.byContradiction
    intro missed
    exact (exactAt x).mp (fun i h => missed ⟨i,h⟩) x member rfl
  · intro covers x
    constructor
    · intro misses k legal eq
      subst k
      obtain ⟨i,hit⟩ := covers x legal
      exact misses i hit
    · intro misses i
      exact misses _ (admitted i x)

/-- Exact proof obligation for a guarded body. The refuting key only
    needs to exist on observations satisfying the guard. -/
theorem guard_coverage (base guard : R → Prop) (adm post : R → K → Prop) :
    (∀ r, base r → guard r → ∃ k, adm r k ∧ ¬ post r k) ↔
      ∀ r, base r → (∀ k, adm r k → post r k) → ¬ guard r := by
  classical
  constructor
  · intro cover r hb all bad
    obtain ⟨k,legal,refutes⟩ := cover r hb bad
    exact refutes (all k legal)
  · intro safe r hb bad
    apply Classical.byContradiction
    intro missing
    apply safe r hb _ bad
    intro k legal
    exact Classical.byContradiction (fun refutes => missing ⟨k,legal,refutes⟩)

/-- For a fixed domain the conditionally usable typings have an exact
    one-pass semantics, including for a pool indexed by an infinite type. -/
def conditional (base : R → Prop) (adm post : R → K → Prop) (r : R) :=
  base r ∧ ∀ k, adm r k → post r k

theorem conditional_idempotent (base : R → Prop) (adm post : R → K → Prop) (r : R) :
    conditional (conditional base adm post) adm post r ↔ conditional base adm post r :=
  ⟨fun h => h.1, fun h => ⟨h,h.2⟩⟩

theorem conditional_sound (actual base : R → Prop) (adm post : R → K → Prop)
    (first : ∀ r, actual r → base r) (typed : ∀ r, actual r → ∀ k, adm r k → post r k) :
    ∀ r, actual r → conditional base adm post r :=
  fun r h => ⟨first r h,typed r h⟩

structure Band where
  lo : Int
  hi : Int
  inhabited : lo ≤ hi

def Band.has (b : Band) (k : Int) := b.lo ≤ k ∧ k ≤ b.hi
def Band.clip (b : Band) (t : Int) := min b.hi (max b.lo t)

theorem clip_mem (b : Band) (t : Int) : b.has (b.clip t) := by
  have := b.inhabited
  unfold Band.has Band.clip
  omega

def Convex (H : Int → Prop) :=
  ∀ a b x, H a → H b → a ≤ x → x ≤ b → H x

/-- A projection detects any convex forbidden set with a known member. -/
theorem clip_hits (b : Band) (inside : H t) (convex : Convex H) :
    (∃ k, b.has k ∧ H k) ↔ H (b.clip t) := by
  constructor
  · rintro ⟨k,⟨lo,hi⟩,bad⟩
    by_cases before : t < b.lo
    · exact convex t k _ inside bad (by unfold Band.clip; omega) (by unfold Band.clip; omega)
    by_cases after : b.hi < t
    · exact convex k t _ bad inside (by unfold Band.clip; omega) (by unfold Band.clip; omega)
    have fixed : b.clip t = t := by unfold Band.clip; omega
    rwa [fixed]
  · exact fun h => ⟨_,clip_mem b t,h⟩

/-- Instantiate at one input and payload. The list and the forbidden
    predicates can therefore both depend on that input and payload. -/
theorem exact_intersection (bands : List Band) (holes : List (Int → Prop))
    (center : (Int → Prop) → Int) (inside : ∀ h ∈ holes, h (center h))
    (convex : ∀ h ∈ holes, Convex h) :
    (∀ b ∈ bands, ∀ k, b.has k → ∀ h ∈ holes, ¬ h k) ↔
      ∀ b ∈ bands, ∀ h ∈ holes, ¬ h (b.clip (center h)) := by
  constructor
  · intro all b hb h hh
    exact all b hb _ (clip_mem b _) h hh
  · intro probes b hb k legal h hh hit
    exact probes b hb h hh ((clip_hits b (inside h hh) (convex h hh)).mp ⟨k,legal,hit⟩)

def separatedPost (n k r : Int) :=
  -n ≤ r ∧ r ≤ n ∧ k ≠ n+1+r ∧ k ≠ 3*n+r

theorem two_projections (n r : Int) (wide : 2 ≤ n) :
    let low : Band := ⟨1,n,by omega⟩
    let high : Band := ⟨3*n+1,4*n,by omega⟩
    (separatedPost n (low.clip (n+1+r)) r ∧ separatedPost n (high.clip (3*n+r)) r) ↔ r = 0 := by
  dsimp [Band.clip, separatedPost]
  omega

def domain (f n k : Int) := 0 ≤ k ∧ k ≤ n ∧ (k ≤ 0 ∨ 1 ≤ f)
def post (f n k r : Int) := 0 ≤ r ∧ r ≤ f ∧ k ≠ n+1-r

/-- On integer observations the selection graph uses two disjunctions
    and the enclosing bounds, all supported by the numeric language. -/
def graph (n r k : Int) := 0 ≤ k ∧ k ≤ n ∧ (r ≤ 0 ∨ n ≤ k) ∧ (1 ≤ r ∨ k ≤ 0)

theorem graph_total (n r : Int) (wide : 0 ≤ n) :
    ∃ k, graph n r k ∧ ∀ j, graph n r j → j = k := by
  by_cases zero : r ≤ 0
  · exact ⟨0, by unfold graph; omega, by unfold graph; intros; omega⟩
  · exact ⟨n, by unfold graph; omega, by unfold graph; intros; omega⟩

theorem graph_exact (n f r k : Int) (wide : 2 ≤ n) (flag : f ≤ 1)
    (initial : post f n 0 r) (selected : graph n r k) :
    domain f n k ∧ (post f n k r ↔ r = 0) := by
  unfold graph at selected
  unfold post at initial
  unfold domain post
  omega

theorem upper_key_on_guard (n f r : Int) (wide : 2 ≤ n) (flag : f ≤ 1)
    (initial : post f n 0 r) (guard : 1 ≤ r) :
    domain f n n ∧ ¬ post f n n r := by
  unfold post at initial
  unfold post domain
  omega

theorem zero_survives (n f k : Int) (flag : 0 ≤ f) (legal : domain f n k) : post f n k 0 := by
  unfold post domain at *; omega

inductive Expr
  | affine (width flag payload constant : Int)
  | add (a b : Expr)
  | neg (a : Expr)
  | min (a b : Expr)
  | max (a b : Expr)

def Expr.eval : Expr → Int → Int → Int → Int
  | .affine a b c d, n, f, r => a*n+b*f+c*r+d
  | .add a b, n, f, r => a.eval n f r + b.eval n f r
  | .neg a, n, f, r => -a.eval n f r
  | .min a b, n, f, r => Min.min (a.eval n f r) (b.eval n f r)
  | .max a b, n, f, r => Max.max (a.eval n f r) (b.eval n f r)

/-- Uniform bound on the change from disabled/zero to enabled/one. -/
def Expr.swing : Expr → Int
  | .affine _ b c _ => Max.max (b+c) (-(b+c))
  | .add a b => a.swing+b.swing
  | .neg a => a.swing
  | .min a b | .max a b => Max.max a.swing b.swing

theorem bounded (e : Expr) (n : Int) :
    -e.swing ≤ e.eval n 1 1 - e.eval n 0 0 ∧ e.eval n 1 1 - e.eval n 0 0 ≤ e.swing := by
  induction e with
  | affine a b c d => simp only [Expr.eval,Expr.swing,Int.mul_one,Int.mul_zero]; omega
  | add a b ha hb | min a b ha hb | max a b ha hb => simp only [Expr.eval,Expr.swing]; omega
  | neg a ha => simp only [Expr.eval,Expr.swing]; omega

def maxSwing : List Expr → Int
  | [] => 0
  | a :: as => max a.swing (maxSwing as)

theorem le_maxSwing {p : List Expr} (he : e ∈ p) : e.swing ≤ maxSwing p := by
  induction p with
  | nil => simp at he
  | cons a as ih =>
    rcases List.mem_cons.mp he with eq | mem
    · subst a; exact Int.le_max_left _ _
    · exact Int.le_trans (ih mem) (Int.le_max_right _ _)

/-- Any finite pool has a width at which every probe legal at both
    observations preserves the spurious result. Key 0 already permits it. -/
theorem no_uniform_pool (p : List Expr) :
    ∃ n, 2 ≤ n ∧ post 1 n 0 1 ∧
      ∀ e ∈ p, domain 0 n (e.eval n 0 0) → domain 1 n (e.eval n 1 1) →
        post 1 n (e.eval n 1 1) 1 := by
  let n := max 2 (maxSwing p + 2)
  have wide : 2 ≤ n := by dsimp [n]; omega
  refine ⟨n, wide, by unfold post; omega, ?_⟩
  intro e he off on
  have := bounded e n
  have bound := le_maxSwing he
  have cap : e.swing < n := by dsimp [n]; omega
  unfold domain post at *
  omega

/-- A fixed family of probes is licensed over all observations that
    survived earlier rounds at this width. The initial typing uses key 0. -/
def survives (n : Int) (used : List Expr) (f r : Int) :=
  post f n 0 r ∧ ∀ e ∈ used, post f n (e.eval n f r) r

inductive Licensed (pool : List Expr) (n : Int) : List Expr → Prop
  | start : Licensed pool n []
  | step {used} (prior : Licensed pool n used) {e} (inPool : e ∈ pool)
      (legal : ∀ f r, survives n used f r → domain f n (e.eval n f r)) :
      Licensed pool n (e :: used)

theorem stages_cannot_refute (pool : List Expr) :
    ∃ n, 2 ≤ n ∧ ∀ used, Licensed pool n used → survives n used 0 0 ∧ survives n used 1 1 := by
  obtain ⟨n,wide,oneAtZero,obstruction⟩ := no_uniform_pool pool
  refine ⟨n,wide,?_⟩
  intro used hist
  induction hist with
  | start =>
    exact ⟨⟨by unfold post; omega, by simp⟩, ⟨oneAtZero,by simp⟩⟩
  | @step prev prior e member legal ih =>
    obtain ⟨off,on⟩ := ih
    have atOff := legal 0 0 off
    have atOn := legal 1 1 on
    refine ⟨⟨off.1,?_⟩,⟨on.1,?_⟩⟩
    · intro q hq
      rcases List.mem_cons.mp hq with eq | mem
      · subst q; exact zero_survives n 0 _ (by decide) atOff
      · exact off.2 q mem
    · intro q hq
      rcases List.mem_cons.mp hq with eq | mem
      · subst q; exact obstruction e member atOff atOn
      · exact on.2 q mem

end ComponentKeys
