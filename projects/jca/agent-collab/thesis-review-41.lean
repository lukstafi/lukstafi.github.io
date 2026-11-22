import Mathlib.Topology.Compactness.Compact
import Mathlib.Topology.Constructions.SumProd
import Mathlib.Tactic.Choose
import Mathlib.Data.Fintype.Card
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.FieldSimp

namespace CompactGuards
open Set

/-- The keys can already be restricted to the admitted rational ones.
    The guard here lies in the real observation space. -/
theorem finite_fixed {R K : Type*} [TopologicalSpace R] (guard : Set R)
    (allowed : Set K) (package : K → Set R) (compact : IsCompact guard)
    (closed : ∀ k ∈ allowed, IsClosed (package k))
    (excludes : ∀ r ∈ guard, ∃ k ∈ allowed, r ∉ package k) :
    ∃ s : Set K, s ⊆ allowed ∧ s.Finite ∧ ∀ r ∈ guard, ∃ k ∈ s, r ∉ package k := by
  obtain ⟨s, legal, finite, covers⟩ := compact.elim_finite_subcover_image
    (c := fun k => (package k)ᶜ) (fun k hk => (closed k hk).isOpen_compl) (by
      intro r hr; simpa using excludes r hr)
  exact ⟨s, legal, finite, fun r hr => by simpa using covers hr⟩

def Legal {X K : Type*} (A : X → K → Prop) (policy : X → Option K) :=
  ∀ x k, policy x = some k → A x k

/-- Lower hemicontinuity of admission lets one input-dependent choice
    work throughout a neighborhood in the joint guard. Compactness then
    bounds the number of such policies uniformly over all inputs. -/
theorem finite_policies {X R K : Type*} [TopologicalSpace X] [TopologicalSpace R]
    [TopologicalSpace K] (G : Set (X × R)) (A : X → K → Prop)
    (F : Set ((X × R) × K)) (compact : IsCompact G) (refuteOpen : IsOpen F)
    (lowerHemi : ∀ W : Set K, IsOpen W → IsOpen {x | ∃ k ∈ W, A x k})
    (complete : ∀ y ∈ G, ∃ k, A y.1 k ∧ (y,k) ∈ F) :
    ∃ policies : Finset (X → Option K), (∀ f ∈ policies, Legal A f) ∧
      ∀ y ∈ G, ∃ f ∈ policies, ∃ k, f y.1 = some k ∧ (y,k) ∈ F := by
  classical
  have near (y : G) : ∃ (V : Set (X × R)) (f : X → Option K),
      IsOpen V ∧ y.val ∈ V ∧ Legal A f ∧
      ∀ p ∈ V, ∃ k, f p.1 = some k ∧ (p,k) ∈ F := by
    obtain ⟨k, ak, refutes⟩ := complete y.val y.property
    obtain ⟨U,W,ou,ow,yu,kw,box⟩ := isOpen_prod_iff.mp refuteOpen y.val k refutes
    let hit (x : X) := ∃ k ∈ W, A x k
    let f (x : X) := if h : hit x then some h.choose else none
    refine ⟨U ∩ Prod.fst ⁻¹' {x | hit x}, f,
      ou.inter ((lowerHemi W ow).preimage continuous_fst), ⟨yu,k,kw,ak⟩, ?_, ?_⟩
    · intro x j eq
      by_cases hx : hit x
      · have ident : hx.choose = j := by simpa [f,hx] using eq
        exact ident ▸ hx.choose_spec.2
      · simp [f,hx] at eq
    · intro p hp
      have h : hit p.1 := hp.2
      exact ⟨h.choose, by simp [f,h], box ⟨hp.1,h.choose_spec.1⟩⟩
  choose V f opened belongs legal refutes using near
  obtain ⟨s, covers⟩ := compact.elim_finite_subcover V opened (by
    intro y hy; exact mem_iUnion.mpr ⟨⟨y,hy⟩,belongs ⟨y,hy⟩⟩)
  refine ⟨s.image f, ?_, ?_⟩
  · intro g hg
    obtain ⟨y,_,rfl⟩ := Finset.mem_image.mp hg
    exact legal y
  · intro y hy
    obtain ⟨j,hj,member⟩ : ∃ j ∈ s, y ∈ V j := by simpa using covers hy
    exact ⟨f j, Finset.mem_image.mpr ⟨j,hj,rfl⟩,refutes j y member⟩

/-- For a finite set of observed payloads, every input has a certificate
    of at most that cardinality, without any continuity condition. -/
theorem finite_observations {R K : Type*} (results : Finset R) (G : R → Prop)
    (A : K → Prop) (F : R → K → Prop) (bounded : ∀ r, G r → r ∈ results)
    (excludes : ∀ r, G r → ∃ k, A k ∧ F r k) :
    ∃ s : Finset K, s.card ≤ results.card ∧ (∀ k ∈ s, A k) ∧
      ∀ r, G r → ∃ k ∈ s, F r k := by
  classical
  let live := results.filter G
  have select (r : live) := excludes r (Finset.mem_filter.mp r.property).2
  choose k ak fk using select
  let s := live.attach.image k
  refine ⟨s, ?_, ?_, ?_⟩
  · calc
      s.card ≤ live.attach.card := Finset.card_image_le
      _ = live.card := Finset.card_attach
      _ ≤ results.card := Finset.card_filter_le _ _
  · intro a ha
    obtain ⟨r,_,rfl⟩ := Finset.mem_image.mp ha
    exact ak r
  · intro r gr
    let i : live := ⟨r,Finset.mem_filter.mpr ⟨bounded r gr,gr⟩⟩
    exact ⟨k i, Finset.mem_image.mpr ⟨i,Finset.mem_attach _ _,rfl⟩, fk i⟩

/-- With t proposed keys, at least one of the t+1 scaled marks
    0, 2, ..., 2t avoids every open radius-one refutation. -/
theorem missed_mark {t : ℕ} (keys : Fin t → ℚ) :
    ∃ j : Fin (t+1), ∀ a,
      2*(j.val:ℚ)+1 ≤ keys a ∨ keys a+1 ≤ 2*j.val := by
  classical
  by_contra! allHit
  choose pick left right using allHit
  have injective : Function.Injective pick := by
    intro u v equal
    have step (a b : Fin (t+1)) (lt : a.val < b.val) (same : pick a = pick b) : False := by
      have apart : (a.val:ℚ)+1 ≤ b.val := by exact_mod_cast lt
      have ha := left a
      have hb := right b
      rw [same] at ha
      linarith
    apply Fin.ext
    rcases lt_trichotomy u.val v.val with h | h | h
    · exact (step u v h equal).elim
    · exact h
    · exact (step v u h equal.symm).elim
  have size := Fintype.card_le_of_injective pick injective
  simp at size

/-- Rescale the same obstruction to a bounded input, key and guard.
    This holds even for proposals outside the admitted interval. -/
theorem bounded_width_misses {t : ℕ} (positive : 0<t) (keys : Fin t → ℚ) :
    ∃ r : ℚ, 0≤r ∧ r≤1 ∧ ∀ a,
      r+1/(2*t:ℚ) ≤ keys a ∨ keys a+1/(2*t:ℚ) ≤ r := by
  have h : (0:ℚ)<t := by exact_mod_cast positive
  obtain ⟨j,missed⟩ := missed_mark (fun a => (2*t:ℚ)*keys a)
  have bound : (j.val:ℚ) ≤ t := by exact_mod_cast (Nat.lt_succ_iff.mp j.isLt)
  have den : (0:ℚ) < 2*t := by linarith
  have scale : (2*(t:ℚ))*((j.val:ℚ)/t) = 2*j.val := by field_simp; ac_rfl
  have unit : (2*(t:ℚ))*(1/(2*t:ℚ)) = 1 := by field_simp
  refine ⟨(j.val:ℚ)/t, div_nonneg (Nat.cast_nonneg _) h.le,
    (div_le_iff₀ h).mpr (by simpa using bound), ?_⟩
  intro a
  rcases missed a with lo | hi
  · left
    apply le_of_mul_le_mul_left _ den
    rw [mul_add,scale,unit]
    exact lo
  · right
    apply le_of_mul_le_mul_left _ den
    rw [mul_add,unit,scale]
    exact hi

end CompactGuards
