import Mathlib.Algebra.Module.LinearMap.Defs
import Mathlib.Data.Rat.Cast.Order
import Mathlib.Tactic.Linarith

namespace RequiredFields

/-- The rational conic hull of a set of homogeneous caller and seed points. -/
inductive Generated {V : Type*} [AddCommMonoid V] [Module ℚ V] (seeds : Set V) : V → Prop
  | of_mem {x} : x ∈ seeds → Generated seeds x
  | zero : Generated seeds 0
  | add {x y} : Generated seeds x → Generated seeds y → Generated seeds (x+y)
  | scale {x} (r : ℚ) : 0 ≤ r → Generated seeds x → Generated seeds (r • x)

variable {V E : Type*} [AddCommMonoid V] [Module ℚ V]

theorem hull_safe (seeds : Set V) (guard : V →ₗ[ℚ] ℚ)
    (h : ∀ x ∈ seeds, guard x ≤ 0) {v : V} (hv : Generated seeds v) : guard v ≤ 0 := by
  induction hv with
  | of_mem hx => exact h _ hx
  | zero => simp
  | add hx hy ihx ihy => simpa using add_nonpos ihx ihy
  | scale r hr hx ih => simpa using mul_nonpos_of_nonneg_of_nonpos hr ih

theorem hull_inductive (seeds : Set V) (field : E → V →ₗ[ℚ] V)
    (step : ∀ e x, x ∈ seeds → Generated seeds (field e x))
    (e : E) {v : V} (hv : Generated seeds v) : Generated seeds (field e v) := by
  induction hv with
  | of_mem hx => exact step e _ hx
  | zero => simpa using (Generated.zero (seeds := seeds))
  | add hx hy ihx ihy => simpa only [map_add] using Generated.add ihx ihy
  | scale r hr hx ih => simpa only [map_smul] using Generated.scale r hr ih

def follow (field : E → V →ₗ[ℚ] V) (v : V) : List E → V
  | [] => v
  | e :: w => field e (follow field v w)

/-- Suffix order puts the newest field at the front of a word. -/
def seeds (field : E → V →ₗ[ℚ] V) (seed orbit positive : Set V) (N : ℕ) : Set V :=
  {x | x ∈ seed ∨ x ∈ orbit ∨ ∃ v ∈ positive, ∃ w : List E, w.length < N ∧ x = follow field v w}

/-- One common inductive domain for all points, homogeneous rays and invariant seed. -/
theorem caller_certificate (field : E → V →ₗ[ℚ] V) (guard : V →ₗ[ℚ] ℚ)
    (seed orbit positive : Set V) {N : ℕ} (hN : 0 < N)
    (seed_step : ∀ e x, x ∈ seed → field e x ∈ seed)
    (orbit_step : ∀ e x, x ∈ orbit → field e x ∈ orbit)
    (horizon : ∀ v ∈ positive, ∀ w : List E, w.length = N → follow field v w ∈ seed)
    (safe_seed : ∀ x ∈ seed, guard x ≤ 0) (safe_orbit : ∀ x ∈ orbit, guard x ≤ 0)
    (safe_early : ∀ v ∈ positive, ∀ w : List E, w.length < N → guard (follow field v w) ≤ 0) :
    let K := Generated (seeds field seed orbit positive N)
    (∀ v ∈ positive, K v) ∧ (∀ v ∈ orbit, K v) ∧
      (∀ v, K v → guard v ≤ 0) ∧ (∀ e v, K v → K (field e v)) := by
  dsimp only
  refine ⟨fun v hv => .of_mem (.inr (.inr ⟨v,hv,[],hN,rfl⟩)),
    fun _ h => .of_mem (.inr (.inl h)), ?_, ?_⟩
  · apply fun v hv => hull_safe _ guard ?_ hv
    rintro x (hs | ho | ⟨v,hv,w,hw,rfl⟩)
    · exact safe_seed _ hs
    · exact safe_orbit _ ho
    · exact safe_early _ hv w hw
  · apply fun e v hv => hull_inductive _ field ?_ e hv
    rintro e x (hs | ho | ⟨v,hv,w,hw,rfl⟩)
    · exact .of_mem (.inl (seed_step e x hs))
    · exact .of_mem (.inr (.inl (orbit_step e x ho)))
    · by_cases ht : (e::w).length < N
      · exact .of_mem (.inr (.inr ⟨v,hv,e::w,ht,rfl⟩))
      · have eqn : (e::w).length = N := by simp only [List.length_cons] at ht ⊢; omega
        exact .of_mem (.inl (horizon v hv (e::w) eqn))

/-- The residue graph gives one actual image per vertex whenever all
    edge differences vanish on the particular input. -/
theorem follow_representative {S : Type*} (field : E → V →ₗ[ℚ] V)
    (rep : S → V →ₗ[ℚ] V) (next : E → S → S) (root : S) (v : V)
    (unit : rep root v = v)
    (edges : ∀ e s, field e (rep s v) = rep (next e s) v) (w : List E) :
    ∃ s, follow field v w = rep s v := by
  induction w with
  | nil => exact ⟨root, unit.symm⟩
  | cons e w ih =>
    obtain ⟨s, hs⟩ := ih
    exact ⟨next e s, by rw [follow, hs, edges]⟩

end RequiredFields
