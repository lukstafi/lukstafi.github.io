import Std

namespace GuardedOpenings

/-- Each enabled typing needs one independent witness. An unavailable
    typing can be omitted even if its package has no witness. -/
theorem branches (a : I → Prop) (p : I → W → Prop) :
    (∀ i, a i → ∃ w, p i w) ↔
      ∃ pick : I → Option W, ∀ i, (pick i = none ∧ ¬ a i) ∨ ∃ w, pick i = some w ∧ p i w := by
  classical
  constructor
  · intro h
    let f (i : I) : Option W := if hi : a i then some (Classical.choose (h i hi)) else none
    refine ⟨f,?_⟩
    intro i
    by_cases hi : a i
    · exact Or.inr ⟨_,by simp [f,hi],Classical.choose_spec (h i hi)⟩
    · exact Or.inl ⟨by simp [f,hi],hi⟩
  · rintro ⟨pick,h⟩ i hi
    rcases h i with ⟨_,no⟩ | ⟨w,_,hw⟩
    · exact False.elim (no hi)
    · exact ⟨w,hw⟩

/-- The arithmetic slack construction only needs that every two positive
    margins have a positive common lower bound. -/
theorem common_slack (positive : A → Prop) (le : A → A → Prop)
    (trans : ∀ {a b c}, le a b → le b c → le a c)
    (seed : ∃ d, positive d)
    (smaller : ∀ a b, positive a → positive b → ∃ d, positive d ∧ le d a ∧ le d b)
    (up : ∀ {a b}, positive a → le a b → positive b) (xs : List A) :
    (∀ x ∈ xs, positive x) ↔ ∃ d, positive d ∧ ∀ x ∈ xs, le d x := by
  constructor
  · induction xs with
    | nil => intro _; obtain ⟨d,h⟩ := seed; exact ⟨d,h,by simp⟩
    | cons a xs ih =>
      intro h
      obtain ⟨b,hb,bound⟩ := ih (fun x hx => h x (by simp [hx]))
      obtain ⟨d,hd,da,db⟩ := smaller a b (h a (by simp)) hb
      refine ⟨d,hd,?_⟩
      intro x hx
      rcases List.mem_cons.mp hx with e | m
      · simpa [e] using da
      · exact trans db (bound x m)
  · rintro ⟨d,hd,bound⟩ x hx
    exact up hd (bound x hx)

/-- Conditional access to the two opposite endpoints on the guard r = 1. -/
def domain (n f k : Int) := -n ≤ k ∧ k ≤ n ∧ (f = 0 ∨ k ≤ 0) ∧ (f = 1 ∨ 0 ≤ k)
def package (n k r : Int) := 0 ≤ r ∧ r ≤ 1 ∧ k ≠ n+1-r ∧ k ≠ -n-1+r

theorem opposite (n : Int) (wide : 2 ≤ n) :
    (∀ f, f = 0 ∨ f = 1 → ∃ k, (k = n ∨ k = -n) ∧ domain n f k ∧ ¬ package n k 1) ∧
    (∀ f k, domain n f k → package n k 0) ∧
    (package n 0 1 ∧ ¬ domain n 0 (-n) ∧ ¬ domain n 1 n) := by
  unfold domain package
  refine ⟨?_,?_,?_⟩
  · intro f cases
    rcases cases with e | e
    · exact ⟨n,Or.inl rfl,by omega,by omega⟩
    · exact ⟨-n,Or.inr rfl,by omega,by omega⟩
  · intros; omega
  · omega

/-- The forbidden guard band can be published at integer openings. -/
theorem integer_outside (a b r : Int) :
    ¬ (a ≤ r ∧ r ≤ b) ↔ r+1 ≤ a ∨ b+1 ≤ r := by omega

/-- A coordinate that occurs only in the admission permits a new
    instantiation. Holding its first witness fixed can lose a legal key. -/
theorem private_copy (D : Int → Prop) (k : Int) :
    (∃ j : Int, D k ∧ j = k) ↔ D k :=
  ⟨fun ⟨_,h,_⟩ => h,fun h => ⟨k,h,rfl⟩⟩

theorem frozen_copy (n : Int) (wide : 2 ≤ n) :
    let D := fun k : Int => 0 ≤ k ∧ k ≤ n
    (∃ j : Int, D n ∧ j = n) ∧ ∀ j : Int, j = 0 → ¬ (D n ∧ j = n) := by
  refine ⟨⟨n,by dsimp; omega,rfl⟩,?_⟩
  intros; dsimp at *; omega

inductive Expr
  | affine (width mode offset : Int)
  | add (x y : Expr)
  | neg (x : Expr)
  | min (x y : Expr)
  | max (x y : Expr)
  deriving DecidableEq

def Expr.eval : Expr → Int → Int → Int
  | .affine a b c, n, i => a*n+b*i+c
  | .add x y, n, i => x.eval n i + y.eval n i
  | .neg x, n, i => -x.eval n i
  | .min x y, n, i => Min.min (x.eval n i) (y.eval n i)
  | .max x y, n, i => Max.max (x.eval n i) (y.eval n i)

def Expr.swing (i j : Int) : Expr → Int
  | .affine _ b _ => Max.max (b*i-b*j) (b*j-b*i)
  | .add x y => x.swing i j + y.swing i j
  | .neg x => x.swing i j
  | .min x y | .max x y => Max.max (x.swing i j) (y.swing i j)

theorem change (e : Expr) (n i j : Int) :
    -e.swing i j ≤ e.eval n i - e.eval n j ∧ e.eval n i - e.eval n j ≤ e.swing i j := by
  induction e with
  | affine a b c => simp only [Expr.eval,Expr.swing]; omega
  | add x y hx hy | min x y hx hy | max x y hx hy => simp only [Expr.eval,Expr.swing]; omega
  | neg x hx => simp only [Expr.eval,Expr.swing]; omega

def maxOn (xs : List A) (f : A → Int) : Int :=
  xs.foldr (fun x rest => max (f x) rest) 0

theorem le_maxOn {xs : List A} (hx : x ∈ xs) (f : A → Int) : f x ≤ maxOn xs f := by
  induction xs with
  | nil => simp at hx
  | cons a xs ih =>
    rcases List.mem_cons.mp hx with e | m
    · subst x; exact Int.le_max_left _ _
    · exact Int.le_trans (ih m) (Int.le_max_right _ _)

theorem opposite_uniform_fails (pool : List Expr) :
    ∃ n, 2 ≤ n ∧ ∀ e ∈ pool,
      domain n 0 (e.eval n 0) → domain n 1 (e.eval n 1) →
      package n (e.eval n 0) 1 ∧ package n (e.eval n 1) 1 := by
  let bound := maxOn pool (fun e => e.swing 0 1)
  let n := max 2 (bound+1)
  have wide : 2 ≤ n := by dsimp [n]; omega
  refine ⟨n,wide,?_⟩
  intro e he off on
  have close := change e n 0 1
  have cap : e.swing 0 1 ≤ bound := le_maxOn he _
  have below : bound < n := by dsimp [n]; omega
  unfold domain package at *
  omega

/-- If one probe can hit at most one listed mode, covering all modes
    requires at least as many probes, even when admissions are conditional. -/
theorem count_hits [DecidableEq E] (modes : List Int) (queries : List E) (hits : E → Int → Prop)
    (nd : modes.Nodup) (unique : ∀ e ∈ queries, ∀ i ∈ modes, ∀ j ∈ modes, hits e i → hits e j → i=j)
    (cover : ∀ i ∈ modes, ∃ e ∈ queries, hits e i) : modes.length ≤ queries.length := by
  induction modes generalizing queries with
  | nil => simp
  | cons a tail ih =>
    obtain ⟨outside,distinct⟩ := List.nodup_cons.mp nd
    obtain ⟨q,hq,hitsA⟩ := cover a (by simp)
    have smaller := ih (queries.erase q) distinct (by
      intro e he i hi j hj
      exact unique e (List.erase_sublist.subset he) i (by simp [hi]) j (by simp [hj])) (by
      intro i hi
      obtain ⟨e,he,hit⟩ := cover i (by simp [hi])
      have ne : e ≠ q := by
        intro eq
        subst e
        have same := unique q hq a (by simp) i (by simp [hi]) hitsA hit
        exact outside (same ▸ hi)
      exact ⟨e,(List.mem_erase_of_ne ne).mpr he,hit⟩)
    have size := List.length_erase_of_mem hq
    have positive : queries.length ≠ 0 := by intro h; simp_all
    simp only [List.length_cons]; omega

/-- At a sufficiently large common width, hitting the key i*n at
    two distinct modes i,j would exceed a probe's entire mode swing. -/
theorem separated_modes (modes : List Int) (pool : List Expr) (nd : modes.Nodup) :
    ∃ n : Int, 2 ≤ n ∧
      ((∀ i ∈ modes, ∃ e ∈ pool, e.eval n i = i*n) → modes.length ≤ pool.length) := by
  let per (e : Expr) := maxOn modes (fun i => maxOn modes (fun j => e.swing i j))
  let n := max 2 (maxOn pool per + 1)
  have wide : 2 ≤ n := by dsimp [n]; omega
  refine ⟨n,wide,fun cover => count_hits modes pool (fun e i => e.eval n i = i*n) nd ?_ cover⟩
  intro e he i hi j hj ei ej
  have bound : e.swing i j < n := by
    have a := le_maxOn hj (fun j => e.swing i j)
    have b := le_maxOn hi (fun i => maxOn modes (fun j => e.swing i j))
    have c := le_maxOn he per
    dsimp [n,per] at *; omega
  have close := change e n i j
  rw [ei,ej] at close
  have order (x y : Int) (h : x < y) : n ≤ y*n-x*n := by
    have gap := Int.mul_le_mul_of_nonneg_right (show 1 ≤ y-x by omega) (show 0 ≤ n by omega)
    simpa [Int.sub_mul] using gap
  rcases Int.lt_trichotomy i j with lt | eq | gt
  · have := order i j lt; omega
  · exact eq
  · have := order j i gt; omega

theorem enough (modes : List Int) :
    let pool := modes.map (fun i => Expr.affine i 0 0)
    pool.length = modes.length ∧ ∀ n i, i ∈ modes → ∃ e ∈ pool, e.eval n i = i*n := by
  dsimp
  constructor
  · simp
  · intro n i hi
    exact ⟨Expr.affine i 0 0,List.mem_map.mpr ⟨i,hi,rfl⟩,by simp [Expr.eval]⟩

end GuardedOpenings
