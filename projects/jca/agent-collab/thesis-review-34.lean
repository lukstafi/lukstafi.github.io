import Std

namespace ResultDependentKeys

/-- Fix the actual arguments and the projected package contract. The type K
    ranges over the written keys. -/
def results {K R : Type} (p : K → R → Prop) (d : K → Prop) (r : R) :=
  ∀ k, d k → p k r

def keys {K R : Type} (p : K → R → Prop) (s : R → Prop) (k : K) :=
  ∀ r, s r → p k r

theorem compatibility {K R : Type} (p : K → R → Prop) (d : K → Prop) (s : R → Prop) :
    (∀ r, s r → results p d r) ↔ ∀ k, d k → keys p s k :=
  ⟨fun h k hk r hr => h r hr k hk, fun h r hr k hk => h k hk r hr⟩

/-- Exact alternation closes the key-result compatibility relation in one
    round trip. This calculation holds without finiteness assumptions. -/
theorem close_results {K R : Type} (p : K → R → Prop) (d : K → Prop) (r : R) :
    results p (keys p (results p d)) r ↔ results p d r :=
  ⟨fun h k hk => h k (fun _ ht => ht k hk), fun h _ hk => hk r h⟩

theorem close_keys {K R : Type} (p : K → R → Prop) (s : R → Prop) (k : K) :
    keys p (results p (keys p s)) k ↔ keys p s k :=
  ⟨fun h r hr => h r (fun _ hj => hj r hr), fun h _ hr => hr k h⟩

/-- With fixed mandatory supplier outcomes, the largest compatible key
    domain gives the strongest guarantee available to this consumer. -/
theorem local_feasibility {K R : Type} (p : K → R → Prop)
    (required : K → Prop) (supplied good : R → Prop) :
    (∃ d : K → Prop, (∀ k, required k → d k) ∧
       (∀ r, supplied r → results p d r) ∧ (∀ r, results p d r → good r)) ↔
    (∀ k, required k → keys p supplied k) ∧
       (∀ r, results p (keys p supplied) r → good r) := by
  constructor
  · rintro ⟨d,must,base,consumer⟩
    have bound := (compatibility p d supplied).mp base
    exact ⟨fun k hk => bound k (must k hk),
           fun r hr => consumer r (fun k hk => hr k (bound k hk))⟩
  · rintro ⟨must,consumer⟩
    exact ⟨keys p supplied,must,fun r hr k hk => hk r hr,consumer⟩

/-- The payload 'none' is zero. Every subset of the positive keys gives a
    different closed pair, even though exact compatibility stabilizes at once. -/
theorem punctured_closed {K : Type} (d : K → Prop) (j : K) :
    let p (k : K) (r : Option K) := r ≠ some k
    results p d none ∧ (results p d (some j) ↔ ¬ d j) ∧
      (keys p (results p d) j ↔ d j) := by
  let p (k : K) (r : Option K) := r ≠ some k
  have pos : results p d (some j) ↔ ¬ d j := by
    constructor
    · exact fun h hj => h j hj rfl
    · intro no k hk equal
      exact no ((Option.some.inj equal).symm ▸ hk)
  refine ⟨fun _ _ => by simp, pos, ?_⟩
  constructor
  · intro h; apply Classical.byContradiction; intro no
    exact h (some j) (pos.mpr no) rfl
  · exact fun hj r hr => hr j hj

/-- A coverage proof can use the first opening's private witness. Admission
    must follow from that opening alone. A second witness is fresh. -/
theorem open_again {K R W : Type} {admit : K → Prop} {returns : R → Prop}
    {post : K → R → W → Prop} {first : K} {choose : R → K}
    (typed : ∀ k, admit k → ∀ r, returns r → ∃ w, post k r w)
    (beginAt : admit first)
    (covered : ∀ r w, post first r w → admit (choose r)) :
    ∀ r, returns r → ∃ u v, post first r u ∧ post (choose r) r v := by
  intro r hr
  obtain ⟨u,hu⟩ := typed first beginAt r hr
  obtain ⟨v,hv⟩ := typed (choose r) (covered r u hu) r hr
  exact ⟨u,v,hu,hv⟩

/-- An unrestricted selector observing the whole payload recovers the full
    intersection on every result, including results that match every key. -/
theorem full_observation {K R : Type} (admit : K → Prop) (post : K → R → Prop)
    (inhabited : ∃ k, admit k) :
    ∃ q : R → K, (∀ r, admit (q r)) ∧
      ∀ r, post (q r) r ↔ ∀ k, admit k → post k r := by
  classical
  let q (r : R) := if h : ∃ k, admit k ∧ ¬ post k r then
    Classical.choose h else Classical.choose inhabited
  refine ⟨q, ?_, ?_⟩
  · intro r; dsimp [q]; split
    next h => exact (Classical.choose_spec h).1
    next => exact Classical.choose_spec inhabited
  · intro r; dsimp [q]; split
    next h =>
      obtain ⟨ha,hn⟩ := Classical.choose_spec h
      exact ⟨fun yes => False.elim (hn yes), fun all => all _ ha⟩
    next h =>
      exact ⟨fun _ k hk => Classical.byContradiction (fun no => h ⟨k,hk,no⟩),
             fun all => all _ (Classical.choose_spec inhabited)⟩

/-- The observation is all that may distinguish two choices of a key list.
    'bad' may already include the constraints of a first opening. -/
theorem observation_criterion {K R O : Type} (obs : R → O) (admit : K → Prop)
    (post : K → R → Prop) (bad : R → Prop) (m : Nat) :
    (∃ qs : O → List K, (∀ o, (qs o).length ≤ m ∧ ∀ k ∈ qs o, admit k) ∧
       ∀ r, bad r → ¬ (∀ k ∈ qs (obs r), post k r)) ↔
    (∀ o, ∃ ks : List K, ks.length ≤ m ∧ (∀ k ∈ ks, admit k) ∧
       ∀ r, obs r = o → bad r → ∃ k ∈ ks, ¬ post k r) := by
  classical
  constructor
  · rintro ⟨qs,legal,excludes⟩ o
    refine ⟨qs o,(legal o).1,(legal o).2,?_⟩
    rintro r rfl hb
    apply Classical.byContradiction
    intro none
    exact excludes r hb (fun k hk => Classical.byContradiction (fun no => none ⟨k,hk,no⟩))
  · intro h
    let qs (o : O) := Classical.choose (h o)
    have spec (o : O) := Classical.choose_spec (h o)
    refine ⟨qs, fun o => ⟨(spec o).1,(spec o).2.1⟩, ?_⟩
    intro r hb all
    obtain ⟨k,hk,no⟩ := (spec (obs r)).2.2 r rfl hb
    exact no (all k hk)

/-- In a punctured package, every positive in one observation class costs
    its own key. Listing exactly those positives attains that bound. -/
theorem puncture_class (cell : List Nat) (ks : List Nat)
    (distinct : cell.Nodup)
    (hit : ∀ r ∈ cell, ∃ k ∈ ks, ¬ (r ≠ k)) : cell.length ≤ ks.length := by
  induction cell generalizing ks with
  | nil => simp
  | cons a rest ih =>
    obtain ⟨k,hk,hak⟩ := hit a (by simp)
    have eq : a = k := Classical.byContradiction hak
    subst k
    have nd := List.nodup_cons.mp distinct
    have small := ih (ks.erase a) nd.2 (by
      intro r hr
      obtain ⟨j,hj,h⟩ := hit r (by simp [hr])
      have e : r = j := Classical.byContradiction h
      subst j
      have ne : r ≠ a := by intro e; subst r; exact nd.1 hr
      exact ⟨r,(List.mem_erase_of_ne ne).mpr hj,h⟩)
    have length := List.length_erase_of_mem hk
    have pos : ks.length ≠ 0 := by
      intro z; simp [List.length_eq_zero_iff.mp z] at hk
    simp only [List.length_cons]; omega

theorem puncture_class_attained (cell : List Nat) :
    ∀ r ∈ cell, ∃ k ∈ cell, ¬ (r ≠ k) := fun r hr => ⟨r,hr,fun ne => ne rfl⟩

def clamp (n t : Int) := min n (max 1 t)
def signedPost (n k r : Int) := -n ≤ r ∧ r ≤ n ∧ r ≠ k ∧ r ≠ -k

theorem signed_selector (n r : Int) (hn : 1 ≤ n) (lo : -n ≤ r) (hi : r ≤ n) :
    let k := clamp n (max r (-r))
    (1 ≤ k ∧ k ≤ n) ∧ (signedPost n k r ↔ r = 0) := by
  dsimp [clamp,signedPost]; omega

/-- At width four or greater, the three payloads here all survive the
    initial lower key. An affine target, even after clipping, misses one. -/
theorem clipped_affine_limit (n a b : Int) (hn : 4 ≤ n) :
    ¬ (∀ r : Int, signedPost n 1 r → signedPost n (clamp n (a*r+b)) r → r = 0) := by
  intro exactness
  have point (r : Int) (hr : signedPost n 1 r) (nz : r ≠ 0) :
      ¬ signedPost n (clamp n (a*r+b)) r := fun h => nz (exactness r hr h)
  have h₂ := point 2 (by unfold signedPost; omega) (by decide)
  have h₃ := point 3 (by unfold signedPost; omega) (by decide)
  have hm := point (-2) (by unfold signedPost; omega) (by decide)
  simp only [signedPost,clamp,Int.mul_neg,Int.reduceNeg] at h₂ h₃ hm
  omega

/-- If a reachable base returns 2, its own predicate loses key 2. All
    remaining keys then agree that 2 is a possible result. -/
theorem missing_admission (n : Int) (hn : 2 ≤ n) :
    (∃ k : Int, 1 ≤ k ∧ k ≤ n ∧ k ≠ 2) ∧
    (∀ k : Int, (1 ≤ k ∧ k ≤ n ∧ k ≠ 2) → 0 ≤ (2:Int) ∧ 2 ≤ n ∧ 2 ≠ k) ∧
    clamp n 2 = 2 := by
  refine ⟨⟨1,by omega⟩,?_,?_⟩
  · intro k hk; omega
  · dsimp [clamp]; omega

end ResultDependentKeys
