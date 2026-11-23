import Mathlib.Tactic.Linarith
import Mathlib.Algebra.Order.Field.Rat

namespace JointInference

/-- Membership in either whole support can be checked one pair of faces at a time. -/
theorem two_supports {J K : Type*} (left : J → Prop) (right : K → Prop) :
    ((∀ j, left j) ∨ (∀ k, right k)) ↔ ∀ j k, left j ∨ right k := by
  constructor
  · rintro (h | h) j k
    · exact Or.inl (h j)
    · exact Or.inr (h k)
  · intro h
    by_cases allLeft : ∀ j, left j
    · exact Or.inl allLeft
    · obtain ⟨j,hj⟩ := Classical.not_forall.mp allLeft
      exact Or.inr (fun k => (h j k).resolve_left hj)

/-- A nonnegative normalized mixture certifies a pair of alternative faces. -/
theorem mixture (t a b : ℚ) (ht : 0 ≤ t) (ht' : t ≤ 1)
    (h : 1 ≤ t*a+(1-t)*b) : 1 ≤ a ∨ 1 ≤ b := by
  by_contra no
  have ha : a < 1 := lt_of_not_ge (fun h => no (Or.inl h))
  have hb : b < 1 := lt_of_not_ge (fun h => no (Or.inr h))
  have hm : max a b < 1 := max_lt ha hb
  have h₁ := mul_le_mul_of_nonneg_left (le_max_left a b) ht
  have h₂ := mul_le_mul_of_nonneg_left (le_max_right a b) (sub_nonneg.mpr ht')
  linarith

abbrev Pt := ℚ × ℚ
def MidClosed (P : Pt → Prop) :=
  ∀ a b : Pt, P a → P b → P ((a.1+b.1)/2, (a.2+b.2)/2)
def Clear (P : Pt → Prop) := ¬ P (0,1) ∧ ¬ P (0,2)
def Base (P : Pt → Prop) := ∀ x : ℚ, -2 ≤ x → x ≤ 2 → P (x,0)

theorem conflict (P : Pt → Prop) (conv : MidClosed P) (safe : Clear P) :
    ¬(P (-2,2) ∧ P (2,2)) ∧ ¬(P (-2,2) ∧ Base P) ∧ ¬(P (2,2) ∧ Base P) := by
  refine ⟨?_,?_,?_⟩
  · rintro ⟨l,r⟩
    have h := conv (-2,2) (2,2) l r
    norm_num at h
    exact safe.2 h
  · rintro ⟨l,b⟩
    have h := conv (-2,2) (2,0) l (b 2 (by decide) le_rfl)
    norm_num at h
    exact safe.1 h
  · rintro ⟨r,b⟩
    have h := conv (2,2) (-2,0) r (b (-2) le_rfl (by decide))
    norm_num at h
    exact safe.1 h

theorem split_covers (x : ℚ) : x+0 ≤ 0 ∨ -x+0 ≤ 0 := by
  rcases le_total x 0 with h | h
  · exact Or.inl (by linarith)
  · exact Or.inr (by linarith)

theorem cannot_assign_whole_cells (P Q : Pt → Prop)
    (pConv : MidClosed P) (pClear : Clear P) (qConv : MidClosed Q) (qClear : Clear Q)
    (left : P (-2,2) ∨ Q (-2,2)) (right : P (2,2) ∨ Q (2,2)) :
    ¬(Base P ∨ Base Q) := by
  obtain ⟨pLR,pLB,pRB⟩ := conflict P pConv pClear
  obtain ⟨qLR,qLB,qRB⟩ := conflict Q qConv qClear
  rintro (pb | qb)
  · exact qLR ⟨left.resolve_left (fun l => pLB ⟨l,pb⟩),
      right.resolve_left (fun r => pRB ⟨r,pb⟩)⟩
  · exact pLR ⟨left.resolve_right (fun l => qLB ⟨l,qb⟩),
      right.resolve_right (fun r => qRB ⟨r,qb⟩)⟩

def QuarterClosed (P : Pt → Prop) :=
  ∀ a b : Pt, P a → P b → P ((3*a.1+b.1)/4, (3*a.2+b.2)/4)

def DiamondClear (P : Pt → Prop) :=
  ¬ P (6,6) ∧ ¬ P (3,3) ∧ ¬ P (-3,3) ∧ ¬ P (3,-3)

def TipConflicts (P : Pt → Prop) :=
  ¬(P (12,0) ∧ P (0,12)) ∧ ¬(P (4,0) ∧ P (0,12)) ∧ ¬(P (-4,0) ∧ P (0,12)) ∧
  ¬(P (0,4) ∧ P (12,0)) ∧ ¬(P (0,-4) ∧ P (12,0))

theorem tip_conflicts (P : Pt → Prop) (mid : MidClosed P) (quarter : QuarterClosed P)
    (safe : DiamondClear P) : TipConflicts P := by
  obtain ⟨far,ne,nw,se⟩ := safe
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> rintro ⟨a,b⟩
  · have h := mid (12,0) (0,12) a b
    norm_num at h
    exact far h
  · have h := quarter (4,0) (0,12) a b
    norm_num at h
    exact ne h
  · have h := quarter (-4,0) (0,12) a b
    norm_num at h
    exact nw h
  · have h := quarter (0,4) (12,0) a b
    norm_num at h
    exact ne h
  · have h := quarter (0,-4) (12,0) a b
    norm_num at h
    exact se h

theorem forced_axes (P Q : Pt → Prop) (p : TipConflicts P) (q : TipConflicts Q)
    (hor : P (12,0) ∨ Q (12,0)) (vert : P (0,12) ∨ Q (0,12))
    (east : P (4,0) ∨ Q (4,0)) (west : P (-4,0) ∨ Q (-4,0))
    (north : P (0,4) ∨ Q (0,4)) (south : P (0,-4) ∨ Q (0,-4)) :
    (P (4,0) ∧ P (-4,0) ∧ Q (0,4) ∧ Q (0,-4)) ∨
    (Q (4,0) ∧ Q (-4,0) ∧ P (0,4) ∧ P (0,-4)) := by
  obtain ⟨pHV,pEV,pWV,pNH,pSH⟩ := p
  obtain ⟨qHV,qEV,qWV,qNH,qSH⟩ := q
  rcases hor with h | h
  · have v := vert.resolve_left (fun v => pHV ⟨h,v⟩)
    exact Or.inl ⟨east.resolve_right (fun e => qEV ⟨e,v⟩),
      west.resolve_right (fun w => qWV ⟨w,v⟩),
      north.resolve_left (fun n => pNH ⟨n,h⟩),
      south.resolve_left (fun s => pSH ⟨s,h⟩)⟩
  · have v := vert.resolve_right (fun v => qHV ⟨h,v⟩)
    exact Or.inr ⟨east.resolve_left (fun e => pEV ⟨e,v⟩),
      west.resolve_left (fun w => pWV ⟨w,v⟩),
      north.resolve_right (fun n => qNH ⟨n,h⟩),
      south.resolve_right (fun s => qSH ⟨s,h⟩)⟩

/-- Even weak separation of the two forced pairs of diamond vertices makes
    the putative cutting form identically zero. -/
theorem cannot_cut_diamond (a b c : ℚ) (east : 4*a ≤ c) (west : -(4*a) ≤ c)
    (north : c ≤ 4*b) (south : c ≤ -(4*b)) : a = 0 ∧ b = 0 ∧ c = 0 := by
  refine ⟨?_, ?_, ?_⟩ <;> linarith

/-- A type/index pair is inhabited by a finite constructor derivation. -/
inductive Built {X : Type*} (rule : (n : ℕ) → (Fin n → X) → X → Prop) : X → Prop
  | ctor {n f x} : rule n f x → (∀ i, Built rule (f i)) → Built rule x

theorem constructor_invariant {X : Type*}
    (rule : (n : ℕ) → (Fin n → X) → X → Prop) (I : X → Prop)
    (step : ∀ n f x, rule n f x → (∀ i, I (f i)) → I x) :
    ∀ x, Built rule x → I x := by
  intro x derivation
  induction derivation with
  | ctor allowed children ih => exact step _ _ _ allowed ih

/-- Any mutually inductive subset of the template pool survives one pruning step. -/
theorem preserve_templates {X A : Type*} (holds : A → X → Prop)
    (rule : (n : ℕ) → (Fin n → X) → X → Prop)
    (target current : A → Prop) (included : ∀ a, target a → current a)
    (stable : ∀ n f x, rule n f x →
      (∀ i a, target a → holds a (f i)) → ∀ a, target a → holds a x) :
    ∀ a, target a → current a ∧ ∀ n f x, rule n f x →
        (∀ i b, current b → holds b (f i)) → holds a x := by
  intro a ha
  exact ⟨included a ha, fun n f x r ih =>
    stable n f x r (fun i b hb => ih i b (included b hb)) a ha⟩

end JointInference
