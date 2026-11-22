import Std

namespace OpeningClosure

structure Rules (I R : Type) where
  base : R → Prop
  admits : I → R → Prop
  post : I → R → Prop

def Rules.possible (a : Rules I R) (seen : List I) (r : R) : Prop :=
  a.base r ∧ ∀ i ∈ seen, a.post i r

def Rules.enabled (a : Rules I R) (seen : List I) (i : I) : Prop :=
  ∀ r, a.possible seen r → a.admits i r

theorem enable_mono (a : Rules I R) {s t : List I} (h : s ⊆ t) :
    a.enabled s i → a.enabled t i :=
  fun hs r ⟨hb,ht⟩ => hs r ⟨hb,fun j hj => ht j (h hj)⟩

/-- A batch is admitted using only earlier batches. -/
inductive Trace (a : Rules I R) (pool : List I) : Nat → List I → Prop
  | start : Trace a pool 0 []
  | step {n seen batch} (previous : Trace a pool n seen)
      (used : ∀ i ∈ batch, i ∈ pool ∧ a.enabled seen i) (more : batch ≠ []) :
      Trace a pool (n+1) (batch ++ seen)

def Closed (a : Rules I R) (pool seen : List I) :=
  ∀ i ∈ pool, a.enabled seen i → i ∈ seen

theorem licensed (a : Rules I R) {actual : R → Prop} (base : ∀ r, actual r → a.base r)
    (typed : ∀ i ∈ pool, ∀ r, actual r → a.admits i r → a.post i r)
    (history : Trace a pool steps seen) : ∀ r, actual r → a.possible seen r := by
  induction history with
  | start => exact fun r hr => ⟨base r hr,by simp⟩
  | step old used more ih =>
    intro r hr
    refine ⟨base r hr,?_⟩
    intro i hi
    rcases List.mem_append.mp hi with new | prior
    · exact typed i (used i new).1 r hr ((used i new).2 r (ih r hr))
    · exact (ih r hr).2 i prior

/-- On a singleton observation cell any legal refutation has a one-probe
    refutation. On that cell all earlier postconditions either hold, or one
    already refutes the observation. -/
theorem pointwise (a : Rules I R) (pool : List I) (r : R) :
    let cell := { a with base := fun t => t = r }
    (∃ m ts, Trace cell pool m ts ∧ ¬ cell.possible ts r) ↔
      ∃ i ∈ pool, a.admits i r ∧ ¬ a.post i r := by
  dsimp only
  let cell := { a with base := fun t => t = r }
  constructor
  · rintro ⟨m,ts,built,no⟩
    apply Classical.byContradiction
    intro missing
    apply no
    apply licensed cell (actual := fun t => t = r) (fun _ h => h) _ built r rfl
    intro i hi t ht allowed
    subst t
    exact Classical.byContradiction (fun fails => missing ⟨i,hi,allowed,fails⟩)
  · rintro ⟨i,hi,licensedAt,excludes⟩
    have one : Trace cell pool 1 ([i] ++ []) := by
      apply Trace.step Trace.start _ (by simp)
      intro j hj
      have eq : j = i := by simpa using hj
      subst j
      exact ⟨hi,fun t ht => ht.1 ▸ licensedAt⟩
    exact ⟨1,[i] ++ [],one,fun possible => excludes (possible.2 i (by simp))⟩

/-- Every legal order is included in every closed collection. If the
    closed collection is itself reached, it is the greatest reachable one. -/
theorem greatest (a : Rules I R) (stop : Closed a pool final)
    (history : Trace a pool steps seen) : seen ⊆ final := by
  induction history with
  | start => simp
  | step old used more ih =>
    intro i hi
    rcases List.mem_append.mp hi with new | prior
    · obtain ⟨member,enabled⟩ := used i new
      exact stop i member (enable_mono a ih enabled)
    · exact ih prior

private theorem finish (a : Rules I R) (pool seen pending : List I) (n : Nat)
    (history : Trace a pool n seen) (remaining : pending ⊆ pool)
    (cover : ∀ i ∈ pool, i ∈ seen ∨ i ∈ pending) :
    ∃ m final, m ≤ n + pending.length ∧ Trace a pool m final ∧ Closed a pool final := by
  classical
  by_cases any : ∃ i ∈ pending, a.enabled seen i
  · let ready := pending.filter (fun i => decide (a.enabled seen i))
    let rest := pending.filter (fun i => decide (¬ a.enabled seen i))
    obtain ⟨w,hw,enabled⟩ := any
    have hready : w ∈ ready := by simp [ready,hw,enabled]
    have short : rest.length < pending.length :=
      List.length_filter_lt_length_iff_exists.mpr ⟨w,hw,by simp [enabled]⟩
    have advance : Trace a pool (n+1) (ready++seen) := by
      apply Trace.step history
      · intro i hi
        obtain ⟨hp,he⟩ := List.mem_filter.mp hi
        exact ⟨remaining hp,of_decide_eq_true he⟩
      · intro empty; simp [empty] at hready
    obtain ⟨m,final,bound,trace,closed⟩ := finish a pool (ready++seen) rest (n+1)
      advance (fun _ hi => remaining (List.mem_filter.mp hi).1) (by
        intro i hi; rcases cover i hi with old | left
        · exact Or.inl (List.mem_append_right _ old)
        · by_cases on : a.enabled seen i
          · exact Or.inl (List.mem_append_left _ (by simp [ready,left,on]))
          · exact Or.inr (by simp [rest,left,on]))
    exact ⟨m,final,by omega,trace,closed⟩
  · refine ⟨n,seen,by omega,history,?_⟩
    intro i hi on
    exact (cover i hi).resolve_right (fun wait => any ⟨i,wait,on⟩)
termination_by pending.length

theorem finite_admission (a : Rules I R) (pool : List I) :
    ∃ m final, m ≤ pool.length ∧ Trace a pool m final ∧ Closed a pool final := by
  simpa using finish a pool [] pool 0 Trace.start (fun _ hi => hi) (fun _ hi => Or.inr hi)

def chain (m : Nat) : Rules Nat Nat where
  base r := r ≤ m
  admits i r := i = 0 ∨ r ≠ i
  post i r := r ≠ i+1

theorem chain_remaining (m j r : Nat) :
    (chain m).possible (List.range j) r ↔ r ≤ m ∧ (r = 0 ∨ j < r) := by
  simp only [Rules.possible,chain,List.mem_range]
  constructor
  · rintro ⟨h,seen⟩
    refine ⟨h,?_⟩
    apply Classical.byContradiction; intro fail
    have := seen (r-1) (by omega)
    omega
  · rintro ⟨h,remains⟩; exact ⟨h,by intro i hi; omega⟩

/-- Of the untried probes j..m-1, exactly j is enabled at round j.
    Thus m probes can require m productive rounds even in parallel. -/
theorem chain_next (m j i : Nat) (pending : j ≤ i) (bound : i < m) :
    (chain m).enabled (List.range j) i ↔ i = j := by
  constructor
  · intro e
    apply Classical.byContradiction; intro ne
    have h := e i ((chain_remaining m j i).mpr ⟨by omega,Or.inr (by omega)⟩)
    change i = 0 ∨ i ≠ i at h; omega
  · rintro rfl r possible
    have := (chain_remaining m _ r).mp possible
    change _ = 0 ∨ r ≠ _
    omega

theorem chain_final (m r : Nat) :
    (chain m).possible (List.range m) r ↔ r = 0 := by
  rw [chain_remaining]; omega

/-- Without a finite pool, the same schema can make a limit necessary.
    A probe licensed only at zero is enabled at the intersection of all
    finite-prefix states, but at no finite prefix. -/
theorem countable_chain :
    (∀ r : Nat, (∀ j : Nat, ∀ i < j, r ≠ i+1) ↔ r = 0) ∧
    (∀ j : Nat, ∃ r : Nat, r ≠ 0 ∧ ∀ i < j, r ≠ i+1) := by
  constructor
  · intro r
    constructor
    · intro finite
      by_cases hr : r = 0
      · exact hr
      · have := finite r (r-1) (by omega); omega
    · rintro rfl j i hi; omega
  · intro j; exact ⟨j+1,by omega,by intro i hi; omega⟩

/-- Starting with no certified keys matters: two mutually enabling probes
    can support an impossible strengthening of a real observation. -/
def circle : Rules Bool Bool where
  base _ := True
  admits _ r := r = false
  post _ r := r = false

theorem circular :
    (∀ i, ¬ circle.enabled [] i) ∧ circle.enabled [false] true ∧
    circle.enabled [true] false ∧ circle.possible [] true ∧ ¬ circle.possible [true,false] true := by
  simp [Rules.enabled,Rules.possible,circle]

/-- Eliminating point holes against any inhabited admitted domain.
    The key and payload types may differ. -/
theorem eliminate_holes {K R : Type} (domain : K → Prop) (inhabited : ∃ k, domain k)
    (base : R → Prop) (holes : List (R → K)) (r : R) :
    (∀ k, domain k → base r ∧ ∀ h ∈ holes, h r ≠ k) ↔
    base r ∧ ∀ h ∈ holes, ¬ domain (h r) := by
  obtain ⟨k,hk⟩ := inhabited
  constructor
  · intro all
    exact ⟨(all k hk).1,fun h hh mem => (all _ mem).2 h hh rfl⟩
  · rintro ⟨hb,miss⟩ j hj
    exact ⟨hb,fun h hh eq => miss h hh (eq ▸ hj)⟩


def clip (n t : Int) := min n (max 1 t)
def wrapped (n k r : Int) := -n ≤ r ∧ r ≤ n ∧ r ≠ k ∧ r+n+1 ≠ k

theorem wrapped_pair (n r : Int) (width : 1 ≤ n) :
    wrapped n (clip n r) r ∧ wrapped n (clip n (r+n+1)) r ↔ r = 0 := by
  unfold wrapped clip; omega

theorem wrapped_witnesses (n : Int) (width : 1 < n) :
    ∃ a b : Int, 0 = clip n 0 + a ∧ 0 = clip n (0+n+1) + b ∧ a ≠ b := by
  refine ⟨-1,-n,?_⟩; unfold clip; omega

/-- Even after the lower-key opening, these nearby hypothetical payloads
    force keys an unbounded distance apart. -/
theorem forced (n : Int) (width : 4 ≤ n) (q : Int → Int)
    (allowed : ∀ r, wrapped n 1 r → 1 ≤ q r ∧ q r ≤ n)
    (rulesOut : ∀ r, wrapped n 1 r → wrapped n (q r) r → r = 0) :
    q (-1) = n ∧ q 2 = 2 := by
  have neg := rulesOut (-1) (by unfold wrapped; omega)
  have pos := rulesOut 2 (by unfold wrapped; omega)
  have := allowed (-1) (by unfold wrapped; omega)
  have := allowed 2 (by unfold wrapped; omega)
  unfold wrapped at *; omega

inductive Expr
  | affine (a b c : Int)
  | add (a b : Expr)
  | neg (a : Expr)
  | min (a b : Expr)
  | max (a b : Expr)

def Expr.eval : Expr → Int → Int → Int
  | .affine a b c, r, n => a*r+b*n+c
  | .add a b, r, n => a.eval r n+b.eval r n
  | .neg a, r, n => -a.eval r n
  | .min a b, r, n => Min.min (a.eval r n) (b.eval r n)
  | .max a b, r, n => Max.max (a.eval r n) (b.eval r n)

def Expr.rate : Expr → Int
  | .affine a _ _ => Max.max a (-a)
  | .add a b => a.rate+b.rate
  | .neg a => a.rate
  | .min a b | .max a b => Max.max a.rate b.rate

theorem bounded_change (e : Expr) (n : Int) :
    -(3*e.rate) ≤ e.eval (-1) n - e.eval 2 n ∧ e.eval (-1) n - e.eval 2 n ≤ 3*e.rate := by
  induction e with
  | affine a b c => simp only [Expr.eval,Expr.rate,Int.mul_neg,Int.mul_one]; omega
  | add a b ha hb | min a b ha hb | max a b ha hb => simp only [Expr.eval,Expr.rate]; omega
  | neg a ha => simp only [Expr.eval,Expr.rate]; omega

theorem no_single_expression (e : Expr) :
    ¬ ∀ n : Int, 4 ≤ n →
        (∀ r, wrapped n 1 r → 1 ≤ e.eval r n ∧ e.eval r n ≤ n) ∧
        ∀ r, wrapped n 1 r → wrapped n (e.eval r n) r → r = 0 := by
  intro works
  let n := max 4 (3*e.rate+4)
  have width : 4 ≤ n := by dsimp [n]; omega
  obtain ⟨legal,refutes⟩ := works n width
  have forcedKeys := forced n width (fun r => e.eval r n) legal refutes
  have diff := bounded_change e n
  dsimp [n] at *; omega

def stagedDomain (n k : Int) := 1 ≤ k ∧ k ≤ n ∧ k ≠ 3
def stagedPost (n k r : Int) :=
  (r = -5 ∨ 1 ≤ r) ∧ -5 ≤ r ∧ r ≤ n ∧ r ≠ k ∧ r+3 ≠ k

theorem two_rounds (n : Int) (width : 6 ≤ n) :
    (∀ r, stagedPost n 1 r → stagedDomain n (clip n (r+3))) ∧
    (stagedPost n 1 3 ∧ ¬ stagedDomain n (clip n 3)) ∧
    (∀ r, stagedPost n 1 r → stagedPost n (clip n (r+3)) r → stagedDomain n (clip n r)) ∧
    (stagedPost n 1 (n-1) ∧ stagedPost n (clip n ((n-1)+3)) (n-1)) ∧
    (∀ r, stagedPost n 1 r → stagedPost n (clip n (r+3)) r → stagedPost n (clip n r) r →
      r = -5) := by
  unfold stagedPost stagedDomain clip
  refine ⟨?_,?_,?_,?_,?_⟩ <;> intros <;> omega

def twoBands (n k : Int) := 1 ≤ k ∧ k ≤ 4*n ∧ (k ≤ n ∨ 3*n < k)
def bandPost (n k r : Int) := -n ≤ r ∧ r ≤ n ∧ r+n+1 ≠ k ∧ r+3*n ≠ k
def bandKey (n r : Int) := if r < 0 then r+n+1 else if 0 < r then r+3*n else 1

theorem conditional_admission (n : Int) (width : 2 ≤ n) :
    (bandPost n 1 0 ∧ ¬ twoBands n (clip (4*n) (n+1)) ∧ ¬ twoBands n (clip (4*n) (3*n))) ∧
    (∀ r, -n ≤ r → r ≤ n →
      twoBands n (bandKey n r) ∧ (bandPost n (bandKey n r) r ↔ r = 0)) := by
  constructor
  · unfold twoBands bandPost clip; omega
  · intro r lo hi
    unfold bandKey; split
    · unfold twoBands bandPost; omega
    · split <;> unfold twoBands bandPost <;> omega

end OpeningClosure
