import Std

namespace JCARepair

inductive Ty where
  | unit
  | num (n : Nat)
  | arr (left right : Ty)

/-- Two live branches. A type-index link witnesses each, and explains its goal. -/
theorem bridge (i : Nat) :
    (∃ u : Ty, ∃ n, u = .num i ∧ u = .num n) ∧
    (∀ (u : Ty) n, u = .num i → u = .num n → n = i) := by
  refine ⟨⟨.num i, i, rfl, rfl⟩, ?_⟩
  rintro _ _ rfl h
  exact (Ty.num.inj h).symm

theorem emptyArithmeticProduct (side : Nat → Prop) :
    ¬ ((∃ n, side n) ∧ (∀ n, side n → n = 0) ∧ (∀ n, side n → n = 1)) := by
  rintro ⟨⟨n, hn⟩, h0, h1⟩
  have := (h0 n hn).symm.trans (h1 n hn)
  contradiction

/-- Quantifiers of two disjoint sorts can interleave arbitrarily. -/
inductive Move where | allL | exL | allR | exR

def play {L R : Type} : List Move → (List L → List R → Prop) → List L → List R → Prop
  | [], p, l, r => p l r
  | .allL :: qs, p, l, r => ∀ x, play qs p (x :: l) r
  | .exL :: qs, p, l, r => ∃ x, play qs p (x :: l) r
  | .allR :: qs, p, l, r => ∀ x, play qs p l (x :: r)
  | .exR :: qs, p, l, r => ∃ x, play qs p l (x :: r)

def left {L : Type} : List Move → (List L → Prop) → List L → Prop
  | [], p, l => p l
  | .allL :: qs, p, l => ∀ x, left qs p (x :: l)
  | .exL :: qs, p, l => ∃ x, left qs p (x :: l)
  | _ :: qs, p, l => left qs p l

def right {R : Type} : List Move → (List R → Prop) → List R → Prop
  | [], p, r => p r
  | .allR :: qs, p, r => ∀ x, right qs p (x :: r)
  | .exR :: qs, p, r => ∃ x, right qs p (x :: r)
  | _ :: qs, p, r => right qs p r

theorem factor {L R : Type} [Inhabited L] [Inhabited R] (qs : List Move)
    (p : List L → Prop) (q : List R → Prop) (l : List L) (r : List R) :
    play qs (fun a b => p a ∧ q b) l r ↔ left qs p l ∧ right qs q r := by
  induction qs generalizing l r with
  | nil => rfl
  | cons m qs ih =>
    cases m <;> simp only [play, left, right, ih]
    · exact ⟨fun h => ⟨fun x => (h x).1, (h default).2⟩,
             fun h x => ⟨h.1 x, h.2⟩⟩
    · constructor
      · rintro ⟨x, hx, h⟩; exact ⟨⟨x, hx⟩, h⟩
      · rintro ⟨⟨x, hx⟩, h⟩; exact ⟨x, hx, h⟩
    · exact ⟨fun h => ⟨(h default).1, fun x => (h x).2⟩,
             fun h x => ⟨h.1, h.2 x⟩⟩
    · constructor
      · rintro ⟨x, h, hx⟩; exact ⟨h, x, hx⟩
      · rintro ⟨h, x, hx⟩; exact ⟨x, h, hx⟩

/-- Expanding one hole occurring m times by a constructor of arity a with
    distinct fresh arguments changes (nodes, holes) by (m*a, a-1). -/
theorem expansionRaisesRank (nodes holes m a : Nat) (used : 1 ≤ m) :
    (nodes : Int) - holes < (nodes : Int) + (m*a : Nat) - ((holes : Int) - 1 + a) := by
  have bound : a ≤ m*a := by
    simpa using Nat.mul_le_mul_right a used
  omega

theorem boundedStrictSteps (rank : Nat → Nat) (k budget : Nat)
    (improves : ∀ i, i < k → rank i < rank (i+1)) (cap : rank k ≤ budget) :
    rank 0 + k ≤ budget := by
  suffices h : rank 0 + k ≤ rank k by omega
  induction k with
  | zero => omega
  | succ k ih =>
    have last := improves k (by omega)
    have prev := ih (fun i hi => improves i (by omega)) (by omega)
    omega

/-- The weakest k-step arithmetic precondition for drift. -/
def safe : Nat → Int → Int → Prop
  | 0, x, _ => x ≤ 0
  | k+1, x, d => x ≤ 0 ∧ safe k (x+d) d

theorem invariant (k : Nat) {x d : Int} (hx : x ≤ 0) (hd : d ≤ 0) : safe k x d := by
  induction k generalizing x with
  | zero => exact hx
  | succ k ih => exact ⟨hx, ih (by omega)⟩

theorem unitSteps (k : Nat) (x : Int) : safe k x 1 ↔ x + (k : Int) ≤ 0 := by
  induction k generalizing x with
  | zero => simp [safe]
  | succ k ih => simp only [safe, ih, Int.natCast_succ]; omega

theorem strictAtEveryStep (k : Nat) :
    ∃ x d, safe k x d ∧ ¬ safe (k+1) x d := by
  refine ⟨-(k : Int), 1, (unitSteps _ _).mpr (by omega), ?_⟩
  intro h
  have := (unitSteps _ _).mp h
  omega

theorem positiveDrift (k : Nat) {x d : Int} (hd : 1 ≤ d) (ok : safe k x d) :
    x + (k : Int) ≤ 0 := by
  induction k generalizing x with
  | zero => simpa [safe] using ok
  | succ k ih =>
    have step := ih ok.2
    omega

theorem limit (x d : Int) : (∀ k, safe k x d) ↔ x ≤ 0 ∧ d ≤ 0 := by
  constructor
  · intro allSteps
    refine ⟨allSteps 0, ?_⟩
    by_cases hd : d ≤ 0
    · exact hd
    · have := positiveDrift ((-x).toNat + 1) (x := x) (d := d) (by omega) (allSteps _)
      omega
  · rintro ⟨hx, hd⟩ k
    exact invariant k hx hd

end JCARepair
