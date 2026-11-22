import «thesis-review-27»

namespace SharedChoices
open IntervalOpening

/-- The largest possible start after all bands at or to the right of f. -/
def greatestKey (f w : Int) : List Band → Int
  | [] => f
  | g :: gs => if f ≤ g.hi then min (g.lo-w-1) (greatestKey f w gs) else greatestKey f w gs

private theorem cons_works (g : Band) (gs : List Band) :
    Works f w k (g::gs) ↔ Works f w k gs ∧ Avoids w k g := by
  simp only [Works, List.mem_cons, forall_eq_or_imp]
  constructor
  · exact fun ⟨fits, first, rest⟩ => ⟨⟨fits, rest⟩, first⟩
  · exact fun ⟨⟨fits, rest⟩, first⟩ => ⟨fits, first, rest⟩

theorem key_interval (f w k : Int) (hw : 0 ≤ w) (gs : List Band) :
    Works f w k gs ↔ leastKey f w gs ≤ k ∧ k ≤ greatestKey f w gs := by
  induction gs with
  | nil => simp [Works, Inside, leastKey, greatestKey]; omega
  | cons g gs ih =>
    have inside : leastKey f w gs ≤ k ∧ k ≤ greatestKey f w gs → Inside w k f :=
      fun h => (ih.mpr h).1
    unfold Inside at inside
    rw [cons_works, ih, avoids_iff w k hw g]
    have := g.ordered
    by_cases left : g.hi < f
    · have right : ¬ f ≤ g.hi := by omega
      simp only [leastKey, greatestKey, if_pos left, if_neg right]
      omega
    · have right : f ≤ g.hi := by omega
      simp only [leastKey, greatestKey, if_neg left, if_pos right]
      omega

/-- For every legal k there is an opening satisfying the comparison.
    Testing just its favorable endpoint decides this property. -/
theorem upper_probe (f w l : Int) (hw : 0 ≤ w) :
    (∀ k, Inside w k f → ∃ o, Inside w k o ∧ l ≤ o) ↔ l ≤ f := by
  constructor
  · intro all
    obtain ⟨o, ⟨_, hi⟩, test⟩ := all (f-w) ⟨by omega, by omega⟩
    omega
  · rintro test k ⟨_, hi⟩
    exact ⟨k+w, ⟨by omega, by omega⟩, by omega⟩

theorem lower_probe (f w u : Int) (hw : 0 ≤ w) :
    (∀ k, Inside w k f → ∃ o, Inside w k o ∧ o ≤ u) ↔ f ≤ u := by
  constructor
  · intro all
    obtain ⟨o, ⟨lo, _⟩, test⟩ := all f ⟨by omega, by omega⟩
    omega
  · rintro test k ⟨lo, _⟩
    exact ⟨k, ⟨by omega, by omega⟩, by omega⟩

/-- Bounded nonempty sets of integers attain their maximum, even with an
    infinite index set. The distance to the upper bound decreases. -/
private theorem bounded_max {p : Int → Prop} (u : Int) (bound : ∀ x, p x → x ≤ u)
    (a : Int) (pa : p a) : ∃ b, p b ∧ ∀ x, p x → x ≤ b := by
  classical
  suffices go : ∀ d : Nat, ∀ x, p x → (u-x).toNat = d → ∃ b, p b ∧ ∀ y, p y → y ≤ b by
    exact go _ a pa rfl
  intro d
  induction d using Nat.strongRecOn with
  | ind d ih =>
    intro x px dist
    by_cases done : ∀ y, p y → y ≤ x
    · exact ⟨x, px, done⟩
    · obtain ⟨y, py, greater⟩ : ∃ y, p y ∧ x < y := by
        apply Classical.byContradiction
        intro missing
        apply done
        intro y py
        apply Classical.byContradiction
        intro larger
        exact missing ⟨y, py, by omega⟩
      have := bound y py
      exact ih (u-y).toNat (by omega) y py rfl

/-- A call can use exactly the information see h. Each h contributes a
    closed integer interval of permissible keys, possibly empty. -/
theorem uniform_iff {H O : Type} (see : H → O) (lo hi : H → Int) :
    (∃ policy : O → Int, ∀ h, lo h ≤ policy (see h) ∧ policy (see h) ≤ hi h) ↔
      ∀ h j, see h = see j → lo h ≤ hi j := by
  constructor
  · rintro ⟨policy, ok⟩ h j same
    have a := (ok h).1
    rw [same] at a
    exact Int.le_trans a (ok j).2
  · intro cross
    classical
    have atObs (z : O) : ∃ k, ∀ h, see h = z → lo h ≤ k ∧ k ≤ hi h := by
      by_cases inhabited : ∃ h, see h = z
      · obtain ⟨j, hj⟩ := inhabited
        let p := fun n => ∃ h, see h = z ∧ lo h = n
        have bounded : ∀ n, p n → n ≤ hi j := by
          rintro n ⟨h, obs, rfl⟩
          exact cross h j (obs.trans hj.symm)
        obtain ⟨k, ⟨best, hb, value⟩, largest⟩ :=
          bounded_max (p := p) (hi j) bounded (lo j) ⟨j, hj, rfl⟩
        refine ⟨k, fun h obs => ⟨largest _ ⟨h, obs, rfl⟩, ?_⟩⟩
        rw [← value]
        exact cross best h (hb.trans obs.symm)
      · exact ⟨0, fun h obs => (inhabited ⟨h, obs⟩).elim⟩
    exact ⟨fun z => Classical.choose (atObs z),
      fun h => Classical.choose_spec (atObs (see h)) h rfl⟩

theorem history_policy_iff {H O : Type} (see : H → O) (f w : H → Int)
    (hw : ∀ h, 0 ≤ w h) (gs : H → List Band) :
    (∃ policy : O → Int, ∀ h, Works (f h) (w h) (policy (see h)) (gs h)) ↔
      ∀ h j, see h = see j → leastKey (f h) (w h) (gs h) ≤ greatestKey (f j) (w j) (gs j) := by
  rw [← uniform_iff see]
  constructor
  · rintro ⟨policy, ok⟩
    exact ⟨policy, fun h => (key_interval _ _ _ (hw h) _).mp (ok h)⟩
  · rintro ⟨policy, ok⟩
    exact ⟨policy, fun h => (key_interval _ _ _ (hw h) _).mpr (ok h)⟩

/-- An integer-affine policy exists exactly when one slope meets all
    pairwise inequalities. The intercept has been eliminated. -/
theorem affine_iff {H : Type} (x lo hi : H → Int) :
    (∃ m c : Int, ∀ h, lo h ≤ m*x h+c ∧ m*x h+c ≤ hi h) ↔
      ∃ m : Int, ∀ h j, m*(x j-x h) ≤ hi j-lo h := by
  constructor
  · rintro ⟨m, c, ok⟩
    refine ⟨m, fun h j => ?_⟩
    have := (ok h).1
    have := (ok j).2
    rw [Int.mul_sub]
    omega
  · rintro ⟨m, pairs⟩
    obtain ⟨offset, ok⟩ := (uniform_iff (fun _ : H => ())
      (fun h => lo h-m*x h) (fun h => hi h-m*x h)).mpr (by
        intro h j _
        have := pairs h j
        rw [Int.mul_sub] at this
        omega)
    refine ⟨m, offset (), fun h => ?_⟩
    obtain ⟨l, u⟩ := ok h
    omega

/-- Two observable states require opposite sides of the same guard. -/
theorem state_policy (i k : Int) (index : i = 0 ∨ i = 1) :
    Works (4*i+1) 2 k [⟨2,4,by decide⟩] ↔ k = 6*i-1 := by
  rw [key_interval _ _ _ (by decide)]
  rcases index with rfl | rfl <;> simp [leastKey, greatestKey] <;> omega

/-- Every recursive instance can choose its child by the same affine
    rule. Each external caller chooses an interval ending at its result. -/
theorem recursive_and_clients (i : Int) (index : i = 0 ∨ i = 1) :
    (∀ k, Inside 2 k (4*i+1) → Inside 2 k (4*i+1) ∧
       Works (4*i+1) 2 (6*i-1) [⟨2,4,by decide⟩]) ∧
      ∃ k, Inside 2 k (4*i+1) ∧ ∀ o, Inside 2 k o → o ≤ 5 := by
  refine ⟨fun _ fits => ⟨fits, (state_policy _ _ index).mpr rfl⟩, 4*i-1, ?_, ?_⟩
  · constructor <;> omega
  · rintro o ⟨_, hi⟩
    omega

inductive Sample | first | middle | last

def coordinate : Sample → Int | .first => 0 | .middle => 1 | .last => 2
def target : Sample → Int | .first => 0 | .middle => 1 | .last => 0

def fitsSample (m c : Int) (h : Sample) :=
  Works (target h+1) 2 (m*coordinate h+c) (twoBands (target h) 2)

theorem sample_eq (m c : Int) (h : Sample) :
    fitsSample m c h ↔ m*coordinate h+c = target h :=
  forced_interior _ _ _ _ (by omega) (by omega)

/-- Each pair of observations has an affine policy. The three together
    do not, although a policy depending on the observed input exists. -/
theorem pairwise_affine_only :
    (∀ h j, ∃ m c, fitsSample m c h ∧ fitsSample m c j) ∧
      ¬ ∃ m c, ∀ h, fitsSample m c h := by
  simp only [sample_eq]
  constructor
  · intro h j
    cases h <;> cases j <;>
      first | exact ⟨0, 0, by decide⟩ | exact ⟨1, 0, by decide⟩ | exact ⟨-1, 2, by decide⟩
  · rintro ⟨m, c, all⟩
    have a := all .first
    have b := all .middle
    have d := all .last
    simp [coordinate, target] at a b d
    omega

end SharedChoices
