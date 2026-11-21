import Std

namespace BranchReplay

-- One atom name includes its predicate and its public argument positions.
-- A row can likewise be tagged by the predicate whose supplier produced it.
variable {Atom Row : Type}

def keep (test : List Atom → Atom → Bool) (xs : List Atom) : List Atom :=
  xs.filter (test xs)

def passes (test : List Atom → Atom → Bool) (xs : List Atom) : Nat → List Atom
  | 0 => xs
  | n+1 => keep test (passes test xs n)

theorem tail_pass (test : List Atom → Atom → Bool) (xs : List Atom) (n : Nat) :
    passes test (keep test xs) n = passes test xs (n+1) := by
  induction n with
  | zero => rfl
  | succ n ih => exact congrArg (keep test) ih

-- A stable check occurs on entry to pass n, after n changes at most.
theorem finite_stabilization (test : List Atom → Atom → Bool) (budget : Nat)
    (xs : List Atom) (bound : xs.length ≤ budget) :
    ∃ n ≤ budget, keep test (passes test xs n) = passes test xs n := by
  by_cases same : keep test xs = xs
  · exact ⟨0, Nat.zero_le _, same⟩
  have sub : (keep test xs).Sublist xs := List.filter_sublist
  have shorter : (keep test xs).length < xs.length := by
    have := sub.length_le
    have ne : (keep test xs).length ≠ xs.length := fun h => same (sub.eq_of_length h)
    omega
  cases budget with
  | zero => omega
  | succ k =>
    obtain ⟨n, hn, stable⟩ := finite_stabilization test k (keep test xs) (by omega)
    rw [tail_pass] at stable
    exact ⟨n+1, by omega, stable⟩

def Closed (test : List Atom → Atom → Bool) (candidate : List Atom) : Prop :=
  ∀ a ∈ candidate, test candidate a = true

theorem preserves_closed (test : List Atom → Atom → Bool)
    (mono : ∀ {x y : List Atom} {a}, x ⊆ y → test x a = true → test y a = true)
    {candidate xs : List Atom} (initial : candidate ⊆ xs)
    (closed : Closed test candidate) (n : Nat) : candidate ⊆ passes test xs n := by
  induction n with
  | zero => exact initial
  | succ n ih =>
    intro a ha
    exact List.mem_filter.mpr ⟨ih ha, mono ih (closed a ha)⟩

-- Safety is hereditary under strengthening of caller premises.
theorem template_solution (test : List Atom → Atom → Bool)
    (mono : ∀ {x y : List Atom} {a}, x ⊆ y → test x a = true → test y a = true)
    (safe : List Atom → Prop) (hereditary : ∀ {x y}, x ⊆ y → safe x → safe y)
    (pool : List Atom) :
    ∃ n ≤ pool.length, Closed test (passes test pool n) ∧
      (∀ candidate, candidate ⊆ pool → Closed test candidate →
         candidate ⊆ passes test pool n) ∧
      ((∃ candidate, candidate ⊆ pool ∧ Closed test candidate ∧ safe candidate) ↔
        safe (passes test pool n)) := by
  obtain ⟨n, hn, h⟩ := finite_stabilization test pool.length pool (Nat.le_refl _)
  have solved : Closed test (passes test pool n) := List.filter_eq_self.mp h
  have within (k : Nat) : passes test pool k ⊆ pool := by
    induction k with
    | zero => exact fun _ h => h
    | succ k ih => exact fun _ h => ih (List.mem_filter.mp h).1
  refine ⟨n, hn, solved, fun _ inc cl => preserves_closed test mono inc cl n, ?_⟩
  constructor
  · rintro ⟨cand, inc, cl, ok⟩
    exact hereditary (preserves_closed test mono inc cl n) ok
  · intro ok
    exact ⟨_, within n, solved, ok⟩

-- Positive recursive uses make supply antitone in the list of assumed atoms.
theorem supplier_test_monotone (supplies : List Atom → Row → Prop) (atom : Atom → Row → Prop)
    (positive : ∀ {x y : List Atom} {r}, x ⊆ y → supplies y r → supplies x r)
    (test : List Atom → Atom → Bool)
    (checks : ∀ x a, test x a = true ↔ ∀ r, supplies x r → atom a r)
    {x y : List Atom} {a} (inc : x ⊆ y) (ok : test x a = true) : test y a = true :=
  (checks y a).2 fun r hr => (checks x a).1 ok r (positive inc hr)

def contract (m r : Int) : Prop := m ≤ r ∧ r ≤ max (m + 20) 0

theorem base (m : Int) : contract m m := by unfold contract; omega

theorem supplier (m r u : Int) (lo : m ≤ u) (_step : u ≤ r + 1)
    (cap : u ≤ max (m + 19) 0) : contract m u := by unfold contract; omega

theorem missing_caller_bound : (0 : Int) ≤ 21 ∧ ¬contract 0 21 := by
  unfold contract
  decide

-- Removing m from the lower bound makes its capture necessary for the
-- unrestricted program. These are the obligations after fixing the
-- outer function scheme to admit all m.
def zeroContract (m r : Int) : Prop := 0 ≤ r ∧ r ≤ max (m + 20) 0
def zeroStep (m r u : Int) : Prop := 0 ≤ u ∧ u ≤ r + 1 ∧ u ≤ max (m + 19) 0
def zeroValid (post : Int → Int → Prop) : Prop :=
  (∀ m, post m 0) ∧
  (∀ m r, post m r → zeroContract m r) ∧
  (∀ m r u, post m r → zeroContract m r → zeroStep m r u → post m u)

theorem captured_solution : zeroValid zeroContract := by
  unfold zeroValid zeroContract zeroStep
  refine ⟨?_, ?_, ?_⟩ <;> intros <;> omega

theorem capture_necessary (unary : Int → Prop) :
    ¬zeroValid (fun _ r => unary r) := by
  rintro ⟨base, caller, step⟩
  have one := step 0 0 1 (base 0) (by unfold zeroContract; decide)
    (by unfold zeroStep; decide)
  have bad := caller (-21) 1 one
  unfold zeroContract at bad
  omega

end BranchReplay
