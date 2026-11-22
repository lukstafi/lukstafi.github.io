import «thesis-review-31»

namespace GuardedChoices
open RecursiveIntervals

def Safe (bs : List Band) (k : Int) := ∀ b ∈ bs, Outside b k

/-- Either extremal legal key suffices for a single forbidden band. -/
theorem endpoints (b : Band) (l u : Int) (h : l ≤ u) :
    let k := if b.hi < u then u else l
    (l ≤ k ∧ k ≤ u) ∧ ((∃ t, l ≤ t ∧ t ≤ u ∧ Outside b t) ↔ Outside b k) := by
  dsimp only
  split <;> rename_i test <;> constructor
  all_goals try omega
  all_goals
    constructor
    · rintro ⟨t,lower,upper,off⟩
      unfold Outside at off ⊢
      omega
    · intro off
      first | exact ⟨u,h,Int.le_refl _,off⟩ | exact ⟨l,Int.le_refl _,h,off⟩

private theorem dominates (bs : List Band) (x k : Int) (h : k ≤ x) (safe : Safe bs k) :
    k ≤ project bs x := by
  induction bs generalizing x with
  | nil => exact h
  | cons b bs ih =>
    apply ih (previous b x) _ (fun c hc => safe c (by simp [hc]))
    have ok := safe b (by simp)
    unfold previous Outside at *
    split <;> omega

private theorem step_progress (bs : List Band) (x : Int) :
    (project bs x = x ∧ Safe bs x) ∨
    ∃ b ∈ bs, project bs x = b.lo-1 ∧ b.lo ≤ x := by
  induction bs generalizing x with
  | nil => simp [project, Safe]
  | cons b bs ih =>
    rcases ih (previous b x) with ⟨eq,ok⟩ | ⟨c,hc,eq,lc⟩
    · change (project bs (previous b x) = x ∧ _) ∨ _
      rw [eq]
      by_cases off : Outside b x
      · left
        simp only [previous, if_pos off] at ok ⊢
        exact ⟨True.intro,fun c hc => (List.mem_cons.mp hc).elim (fun h => h ▸ off) (ok c)⟩
      · right
        exact ⟨b, by simp, by change project bs (previous b x) = b.lo - 1; rw [eq]; simp [previous,off], by unfold Outside at off; omega⟩
    · right
      have le : previous b x ≤ x := by unfold previous Outside; split <;> omega
      exact ⟨c, by simp [hc], eq, Int.le_trans lc le⟩

def countBelow (x : Int) : List Band → Nat
  | [] => 0
  | b::bs => (if b.lo ≤ x then 1 else 0) + countBelow x bs

private theorem count_mono (bs : List Band) {x y : Int} (h : x ≤ y) :
    countBelow x bs ≤ countBelow y bs := by
  induction bs with
  | nil => simp [countBelow]
  | cons b bs ih =>
    simp only [countBelow]; split <;> split <;> omega

private theorem count_drops (bs : List Band) {x y : Int} (h : x ≤ y)
    (b : Band) (hb : b ∈ bs) (cross : x < b.lo ∧ b.lo ≤ y) :
    countBelow x bs < countBelow y bs := by
  induction bs with
  | nil => simp at hb
  | cons c bs ih =>
    rcases List.mem_cons.mp hb with rfl | mem
    · have := count_mono bs h
      simp [countBelow, show ¬ x ≥ b.lo by omega, cross.2]; omega
    · have := ih mem
      simp only [countBelow]; split <;> split <;> omega

def sweeps (bs : List Band) : Nat → Int → Int
  | 0, x => x
  | n+1, x => sweeps bs n (project bs x)

private theorem safe_after (bs : List Band) (fuel : Nat) (x : Int)
    (enough : countBelow x bs ≤ fuel) : Safe bs (sweeps bs fuel x) := by
  induction fuel generalizing x with
  | zero =>
    intro b hb
    by_cases off : Outside b x
    · exact off
    · have low : b.lo ≤ x := by unfold Outside at off; omega
      have := count_drops bs (show b.lo-1 ≤ x by omega) b hb ⟨by omega,low⟩
      omega
  | succ n ih =>
    rcases step_progress bs x with ⟨eq,ok⟩ | ⟨b,hb,eq,low⟩
    · have unchanged (m : Nat) : sweeps bs m x = x := by
        induction m with
        | zero => rfl
        | succ m h => simp [sweeps,eq,h]
      simpa [unchanged] using ok
    · have dec := count_drops bs (below bs x) b hb ⟨by omega,low⟩
      exact ih _ (by omega)

theorem arbitrary_order (bs : List Band) (u : Int) :
    let p := sweeps bs bs.length u
    Safe bs p ∧ p ≤ u ∧ (∀ k ≤ u, Safe bs k → k ≤ p) := by
  have bound (x : Int) : countBelow x bs ≤ bs.length := by
    induction bs with
    | nil => simp [countBelow]
    | cons b bs ih => simp only [countBelow,List.length_cons]; split <;> omega
  have ext (m : Nat) (x : Int) :
      sweeps bs m x ≤ x ∧ ∀ k ≤ x, Safe bs k → k ≤ sweeps bs m x := by
    induction m generalizing x with
    | zero => exact ⟨Int.le_refl _,fun _ h _ => h⟩
    | succ m ih =>
      obtain ⟨le,dominates'⟩ := ih (project bs x)
      exact ⟨Int.le_trans le (below bs x),fun k hk ok => dominates' k (dominates bs x k hk ok) ok⟩
  exact ⟨safe_after bs _ _ (bound u),ext _ _⟩

/-- Clamping preserves the admitted domain on inputs where every key hits a
    band. Failure to exclude a reachable opening remains observable. -/
theorem clamped (bs : List Band) (l u : Int) (hu : l ≤ u) :
    let p := max l (sweeps bs bs.length u)
    (l ≤ p ∧ p ≤ u) ∧ ((∃ k, l ≤ k ∧ k ≤ u ∧ Safe bs k) ↔ Safe bs p) := by
  obtain ⟨ok,le,dom⟩ := arbitrary_order bs u
  constructor
  · dsimp only; omega
  · constructor
    · rintro ⟨k,low,high,safe⟩
      have := dom k high safe
      have collapse : max l (sweeps bs bs.length u) = sweeps bs bs.length u := by omega
      simpa only [collapse] using ok
    · intro safe
      exact ⟨_,by omega,by omega,safe⟩

/-- A guard-aware proposal needs existence as well as safety on its graph. -/
theorem vacuous_exclusion :
    let call := fun k : Int => k = 0
    let guard := fun r : Int => r = 0
    (∃ k, call k) ∧ (∀ k r : Int, call k → k ≠ 0 → r=k → ¬ guard r) ∧
      ¬ ∃ k, call k ∧ k ≠ 0 := by dsimp only; exact ⟨⟨0,rfl⟩, by intros; omega, by rintro ⟨k,h,hn⟩; exact hn h⟩

/-- Uniformly validating an erased parameter bounds the same observable
    payload by each admitted contract. Private opening witnesses stay local. -/
theorem erased_meet {X K R W : Type} (allowed : X → K → Prop)
    (post : X → K → R → W → Prop) (returns : X → R → Prop) :
    (∀ x k r, allowed x k → returns x r → ∃ w, post x k r w) ↔
    ∀ x r, returns x r → ∀ k, allowed x k → ∃ w, post x k r w := by
  constructor <;> intro h <;> intros <;> apply h <;> assumption

theorem translated_meet (l u a b r : Int) (admits : l ≤ u) :
    (∀ k : Int, l ≤ k → k ≤ u → k+a ≤ r ∧ r ≤ k+b) ↔ u+a ≤ r ∧ r ≤ l+b := by
  constructor
  · intro all
    exact ⟨(all u admits (Int.le_refl _)).1,(all l (Int.le_refl _) admits).2⟩
  · intro bounds k low high; omega

theorem exact_payload (s n r : Int) (width : 0 ≤ n) :
    (∀ k : Int, s-n ≤ k → k ≤ s → k ≤ r ∧ r ≤ k+n) ↔ r = s := by
  have h := translated_meet (s-n) s 0 n r (by omega)
  simp only [Int.add_zero] at h
  rw [h]
  omega

/-- A fixed anchor allows a single pass even when the forbidden bands swap order. -/
def cap (u : Int) : List Band → Int
  | [] => u
  | b::bs => if u ≤ b.hi then min (b.lo-1) (cap u bs) else cap u bs

theorem cap_spec (bs : List Band) (u x : Int) :
    x ≤ cap u bs ↔ x ≤ u ∧ ∀ b ∈ bs, u ≤ b.hi → x < b.lo := by
  induction bs with
  | nil => simp [cap]
  | cons b bs ih =>
    simp only [cap,List.forall_mem_cons]
    split <;> rename_i test
    · rw [Int.le_min, ih]
      constructor
      · rintro ⟨bound,hu,tail⟩
        exact ⟨hu,fun _ => by omega,tail⟩
      · rintro ⟨hu,first,tail⟩
        have := first test
        exact ⟨by omega,hu,tail⟩
    · rw [ih]
      constructor
      · rintro ⟨hu,tail⟩
        exact ⟨hu,fun contrary => False.elim (test contrary),tail⟩
      · rintro ⟨hu,_,tail⟩
        exact ⟨hu,tail⟩

theorem anchored (bs : List Band) (l u : Int)
    (side : ∀ b ∈ bs, b.hi < u → b.lo ≤ l)
    (feasible : ∃ k, l ≤ k ∧ k ≤ u ∧ Safe bs k) :
    l ≤ cap u bs ∧ cap u bs ≤ u ∧ Safe bs (cap u bs) ∧
      ∀ k, l ≤ k → k ≤ u → Safe bs k → k ≤ cap u bs := by
  have dom (k : Int) (hi : k ≤ u) (ok : Safe bs k) : k ≤ cap u bs := by
    apply (cap_spec bs u k).mpr
    exact ⟨hi,fun b hb upper => by have := ok b hb; unfold Outside at this; omega⟩
  obtain ⟨k,lo,hi,ok⟩ := feasible
  have dk := dom k hi ok
  obtain ⟨bound,active⟩ := (cap_spec bs u _).mp (Int.le_refl _)
  refine ⟨by omega,bound,?_,fun t _ high safe => dom t high safe⟩
  intro b hb
  by_cases test : u ≤ b.hi
  · exact Or.inl (active b hb test)
  · have := side b hb (by omega)
    have := ok b hb
    unfold Outside at *
    omega

theorem common_anchor_side (l u a b lo hi : Int)
    (common : u+a ≤ l+b) (band : lo ≤ hi) (left : hi-a < u) : lo-b ≤ l := by omega

/-- On the negative state, the two package openings force opposite keys. -/
theorem two_sites (n : Int) (width : 0 < n) :
    (∀ k : Int, -1-n ≤ k → k ≤ -1 →
      ((k+n < 0 ∨ 0 < k) ↔ k = -1-n) ∧ ((k+n < -2 ∨ -2 < k) ↔ k = -1)) ∧
    ¬ ∃ k : Int, -1-n ≤ k ∧ k ≤ -1 ∧ (k+n < 0 ∨ 0 < k) ∧ (k+n < -2 ∨ -2 < k) := by
  constructor
  · intros; constructor <;> omega
  · rintro ⟨k,h⟩; omega

/-- The two recursive results are independent at the point where the
    induction hypothesis is applied. Both base and step return the state. -/
inductive TwoSiteRun (s : Int) : Nat → Option Int → Prop where
  | base : TwoSiteRun s 0 (some s)
  | step {d r q} : TwoSiteRun s d (some r) → TwoSiteRun s d (some q) →
      TwoSiteRun s (d+1) (if r = 0 ∨ q = -2 then none else some s)

theorem two_site_solution {s : Int} (state : s = -1 ∨ s = 1) {d v}
    (run : TwoSiteRun s d v) : v = some s := by
  induction run with
  | base => rfl
  | step _ _ left right =>
    simp only [Option.some.injEq] at left right
    rw [left, right, if_neg (show ¬ (s = 0 ∨ s = -2) by omega)]

theorem two_site_total (s : Int) (state : s = -1 ∨ s = 1) (d : Nat) :
    TwoSiteRun s d (some s) := by
  induction d with
  | zero => exact .base
  | succ d ih =>
    have step := TwoSiteRun.step ih ih
    simpa only [if_neg (show ¬ (s = 0 ∨ s = -2) by omega)] using step

theorem two_site_interval {s n k : Int} (state : s = -1 ∨ s = 1)
    (low : k ≤ s) (high : s ≤ k+n) {d r} (run : TwoSiteRun s d (some r)) :
    r = s ∧ k ≤ r ∧ r ≤ k+n := by
  have eq := Option.some.inj (two_site_solution state run)
  exact ⟨eq,by omega,by omega⟩

end GuardedChoices
