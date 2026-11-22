import Mathlib.Topology.Compactness.Compact
import Mathlib.Topology.Instances.Discrete
import Mathlib.Topology.Clopen
import Mathlib.Algebra.Order.Archimedean.Basic
import Mathlib.Data.Rat.Cast.Order
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Data.Finset.Prod

namespace SupportSynthesis

variable {X J T : Type*}

abbrev Node (X : Type*) := X × Finset X
def Breaks (c : X → Prop) (node : Node X) :=
  c node.1 ∧ ∀ y ∈ node.2, ¬ c y

structure Pick (X J : Type*) where
  node : Node X
  label : J

abbrev Sub {α : Type*} (p q : α → Prop) := ∀ x, p x → q x

/-- A legal support containing any positive set, least among such supports. -/
structure Generalizer (X : Type*) where
  legal : (X → Prop) → Prop
  hull : (X → Prop) → X → Prop
  extensive p : Sub p (hull p)
  valid p : legal (hull p)
  least p c : legal c → Sub p c → Sub (hull p) c

def Positive (lo : J → X → Prop) (picked : T → Pick X J) (j : J) (x : X) :=
  lo j x ∨ ∃ t, (picked t).label = j ∧ (picked t).node.1 = x

def Supports (g : J → Generalizer X) (lo hi c : J → X → Prop) :=
  ∀ j, (g j).legal (c j) ∧ Sub (lo j) (c j) ∧ Sub (c j) (hi j)

theorem synthesize (g : J → Generalizer X) (lo hi : J → X → Prop)
    (nodes : T → Finset (Node X)) :
    (∃ c, Supports g lo hi c ∧ ∀ t, ∃ w : Pick X J,
      w.node ∈ nodes t ∧ Breaks (c w.label) w.node) ↔
    ∃ pick : T → Pick X J,
      (∀ t, (pick t).node ∈ nodes t) ∧
      (∀ j, Sub ((g j).hull (Positive lo pick j)) (hi j)) ∧
      ∀ t y, y ∈ (pick t).node.2 → ¬ (g (pick t).label).hull (Positive lo pick (pick t).label) y := by
  constructor
  · rintro ⟨c, legal, hit⟩
    let pick := fun t => Classical.choose (hit t)
    have chosen := fun t => Classical.choose_spec (hit t)
    have fits (j : J) : Sub ((g j).hull (Positive lo pick j)) (c j) := by
      apply (g j).least _ _ (legal j).1
      rintro x (old | ⟨t, rfl, rfl⟩)
      · exact (legal j).2.1 x old
      · exact (chosen t).2.1
    exact ⟨pick, fun t => (chosen t).1, fun j x h => (legal j).2.2 x (fits j x h),
      fun t y hy h => (chosen t).2.2 y hy (fits _ y h)⟩
  · rintro ⟨pick, chosen, upper, absent⟩
    refine ⟨fun j => (g j).hull (Positive lo pick j), ?_, ?_⟩
    · exact fun j => ⟨(g j).valid _, fun x h => (g j).extensive _ x (Or.inl h), upper j⟩
    · exact fun t => ⟨pick t, chosen t, (g _).extensive _ _ (Or.inr ⟨t, rfl, rfl⟩), absent t⟩

/-- Finite trace constraints depend on finitely many pointwise membership bits. -/
abbrev Pattern (Z : Type*) := List (Z × Bool)

def Matches {Z : Type*} (v : Z → Bool) (pat : Pattern Z) :=
  ∀ p ∈ pat, v p.1 = p.2

private theorem matches_clopen {Z : Type*} (pat : Pattern Z) :
    IsClopen {v : Z → Bool | Matches v pat} := by
  induction pat with
  | nil =>
    simpa [Matches] using (isClopen_univ : IsClopen (Set.univ : Set (Z → Bool)))
  | cons head tail ih =>
    have eq : {v : Z → Bool | Matches v (head :: tail)} =
        (fun v : Z → Bool => v head.1) ⁻¹' {head.2} ∩ {v | Matches v tail} := by
      ext v
      simp [Matches]
    rw [eq]
    exact ((isClopen_discrete _).preimage (continuous_apply head.1)).inter ih

def Allowed {Z : Type*} (clause : List (Pattern Z)) :=
  {v : Z → Bool | ∃ pat ∈ clause, Matches v pat}

private theorem allowed_closed {Z : Type*} (clause : List (Pattern Z)) : IsClosed (Allowed clause) := by
  induction clause with
  | nil => simp [Allowed]
  | cons pat rest ih =>
    have eq : Allowed (pat :: rest) = {v | Matches v pat} ∪ Allowed rest := by
      ext v
      simp [Allowed]
    rw [eq]
    exact (matches_clopen pat).1.union ih

/-- For unrestricted bits use the whole product. Any class defined by
forbidding finite patterns is also closed in this product. -/
theorem finite_obstruction {Z : Type*} (domain : Set (Z → Bool)) (closed : IsClosed domain)
    (clauses : T → List (Pattern Z)) :
    (∃ v ∈ domain, ∀ t, v ∈ Allowed (clauses t)) ↔
    ∀ ts : Finset T, ∃ v ∈ domain, ∀ t ∈ ts, v ∈ Allowed (clauses t) := by
  constructor
  · rintro ⟨v, legal, all⟩ ts
    exact ⟨v, legal, fun t _ => all t⟩
  · intro finite
    have each (ts : Finset T) :
        (domain ∩ ⋂ t ∈ ts, Allowed (clauses t)).Nonempty := by
      obtain ⟨v, legal, checked⟩ := finite ts
      exact ⟨v, legal, by simpa using checked⟩
    obtain ⟨v, legal, all⟩ := closed.isCompact.inter_iInter_nonempty
      (fun t => Allowed (clauses t)) (fun t => allowed_closed _) each
    exact ⟨v, legal, Set.mem_iInter.mp all⟩

noncomputable def TestNode (j : J) (node : Node X) : Pattern (J × X) :=
  ((j, node.1), true) :: node.2.toList.map (fun y => ((j,y), false))

theorem matches_node (v : J × X → Bool) (j : J) (node : Node X) :
    Matches v (TestNode j node) ↔ Breaks (fun x => v (j,x) = true) node := by
  simp [Matches, TestNode, Breaks]

theorem forbid_closed {Z R : Type*} (pat : R → Pattern Z) :
    IsClosed {v : Z → Bool | ∀ i, ¬ Matches v (pat i)} := by
  have eq : {v : Z → Bool | ∀ i, ¬ Matches v (pat i)} =
      ⋂ i, {v : Z → Bool | Matches v (pat i)}ᶜ := by ext v; simp
  rw [eq]
  exact isClosed_iInter (fun i => (matches_clopen (pat i)).2.isClosed_compl)

/-- One neutral key belongs to all inputs. A single marker is supplied on
source and excluded on bad. The neutral section is forced by any source. -/
def BaseMenu (supports : J → X → Prop) (x : X) : Option J → Prop
  | none => True
  | some j => supports j x

theorem marker (supports : J → X → Prop) (source bad : X → Prop) (live : ∃ x, source x) :
    (∃ p : Option J → Prop,
      (∀ x, source x → ∀ k, BaseMenu supports x k → p k) ∧
      ∀ x, bad x → ¬ (∀ k, BaseMenu supports x k → p k)) ↔
    ∀ x, bad x → ∃ j, supports j x ∧ ∀ y, source y → ¬ supports j y := by
  classical
  constructor
  · rintro ⟨p, provided, excluded⟩ x hx
    have fail := excluded x hx
    simp only [not_forall] at fail
    obtain ⟨k, atX, absent⟩ := fail
    cases k with
    | none =>
      obtain ⟨y, hy⟩ := live
      exact False.elim (absent (provided y hy none trivial))
    | some j => exact ⟨j, atX, fun y hy atY => absent (provided y hy (.some j) atY)⟩
  · intro separate
    refine ⟨fun k => ∃ y, source y ∧ BaseMenu supports y k, ?_, ?_⟩
    · exact fun x hx k hk => ⟨x,hx,hk⟩
    · intro x hx opens
      obtain ⟨j, atX, absent⟩ := separate x hx
      obtain ⟨y, hy, atY⟩ := opens (.some j) atX
      exact absent y hy atY

/-- Each state may use a different witness. A finite set of strict row
values at those witnesses has one rational margin. -/
theorem common_margin {D : Type*} (s : Finset D) (gap : D → ℚ) :
    (∀ d ∈ s, 0 < gap d) ↔ ∃ e : ℚ, 0 < e ∧ ∀ d ∈ s, e ≤ gap d := by
  classical
  constructor
  · induction s using Finset.induction_on with
    | empty => exact fun _ => ⟨1, by norm_num, by simp⟩
    | @insert d s _ ih =>
      intro pos
      obtain ⟨e, he, all⟩ := ih (fun i hi => pos i (Finset.mem_insert_of_mem hi))
      refine ⟨min e (gap d), lt_min he (pos d (Finset.mem_insert_self ..)), ?_⟩
      intro i hi
      rcases Finset.mem_insert.mp hi with rfl | old
      · exact min_le_right ..
      · exact le_trans (min_le_left ..) (all i old)
  · rintro ⟨e, he, all⟩ d hd
    exact lt_of_lt_of_le he (all d hd)

end SupportSynthesis

namespace SupportBoundary

/-- Finite observations cannot make the least interval generalize the whole positive ray.
Even the larger interval [0, max seen] misses a positive caller. -/
theorem unseen_positive (seen : Finset ℕ) :
    ∃ next : ℕ, 0 < next ∧ ∀ n ∈ seen, n < next := by
  refine ⟨seen.sup id + 1, Nat.zero_lt_succ _, ?_⟩
  intro n hn
  exact Nat.lt_succ_of_le (Finset.le_sup (f := id) hn)

def Accept (a b c : ℚ) (x y : ℚ) := a*x + b*y ≤ c

/-- A single affine guard keeping both diagonal corners cannot reject both
off-diagonal corners, even when only the four integer points are observed. -/
theorem crossing (a b c : ℚ) (origin : Accept a b c 0 0)
    (diag : Accept a b c 1 1) : Accept a b c 0 1 ∨ Accept a b c 1 0 := by
  simp only [Accept, mul_zero, zero_add, add_zero, mul_one] at *
  by_contra! h
  linarith [h.1, h.2]

/-- Every finite prefix has one closed half-space separator. -/
theorem prefix_fits (N : ℕ) : Accept 1 (-(N : ℚ)) 0 0 0 ∧
    (∀ n : ℕ, n ≤ N → Accept 1 (-(N : ℚ)) 0 n 1) ∧ ¬ Accept 1 (-(N : ℚ)) 0 1 0 := by
  refine ⟨by norm_num [Accept], ?_, by norm_num [Accept]⟩
  intro n h
  have h' : (n : ℚ) ≤ N := by exact_mod_cast h
  simp only [Accept, one_mul, mul_one]
  linarith

/-- Every weak affine consequence of the whole positive ray and origin
also contains the single forbidden point. Hence every conjunction does. -/
theorem boundary_forced (a b c : ℚ) (origin : Accept a b c 0 0)
    (ray : ∀ n : ℕ, Accept a b c n 1) : Accept a b c 1 0 := by
  simp only [Accept, mul_zero, add_zero, mul_one] at *
  by_contra h
  have pos : 0 < a := by linarith
  obtain ⟨n, hn⟩ := exists_nat_gt ((c-b)/a)
  have crossed := (div_lt_iff₀ pos).mp hn
  nlinarith [ray n]

end SupportBoundary

namespace Adjacent

/-- A supplier at n+1 stores n. Every input must exclude its own index. -/
theorem no_stable_tail {K : Type*} (a : ℕ → K → Prop) (p : K → ℕ → Prop)
    (supply : ∀ n k, a (n+1) k → p k n)
    (reject : ∀ n, ∃ k, a n k ∧ ¬ p k n) (n : ℕ) :
    ¬ (∀ k, a n k → a (n+1) k) := by
  intro same
  obtain ⟨k, present, missing⟩ := reject n
  exact missing (supply n k (same k present))

theorem two_supports :
    let a := fun (n : ℕ) (k : Fin 2) => n % 2 = k.val
    let p := fun (k : Fin 2) (r : ℕ) => r % 2 ≠ k.val
    (∀ n k, a (n+1) k → p k n) ∧ ∀ n, ∃ k, a n k ∧ ¬ p k n := by
  dsimp
  constructor
  · intro n k hk
    omega
  · intro n
    exact ⟨⟨n % 2, Nat.mod_lt _ (by decide)⟩, rfl, fun h => h rfl⟩

end Adjacent
