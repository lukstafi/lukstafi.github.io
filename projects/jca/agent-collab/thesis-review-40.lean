import Std

namespace GroundedClients

/-- Every occurrence is evaluated in the same valuation, including the
    witnesses chosen by a candidate for the original quantified system. -/
theorem guarded_cut {P H : Prop} {D C : I → Prop} (entailed : P → H) :
    (P ∧ ∀ i, D i → C i) ↔ (P ∧ ∀ i, D i ∧ H → C i) := by
  constructor
  · rintro ⟨p,h⟩
    exact ⟨p, fun i d => h i d.1⟩
  · rintro ⟨p,h⟩
    exact ⟨p, fun i d => h i ⟨d,entailed p⟩⟩

theorem same_live_witnesses {A D H : X → Prop} (forces : ∀ x, A x → D x → H x) :
    (∃ x, A x ∧ D x) ↔ (∃ x, A x ∧ D x ∧ H x) := by
  constructor
  · rintro ⟨x,a,d⟩; exact ⟨x,a,d,forces x a d⟩
  · rintro ⟨x,a,d,_⟩; exact ⟨x,a,d⟩

/-- Conditional providers can be used simultaneously if the proofs of
    the added premises only use rows at strictly smaller ranks. -/
theorem ranked_cut {P : Prop} {I : Type} {D C H : I → Prop} (rank : I → Nat)
    (derive : ∀ i, P → D i → (∀ j, rank j < rank i → D j → C j) → H i) :
    (P ∧ ∀ i, D i → C i) ↔ (P ∧ ∀ i, D i ∧ H i → C i) := by
  constructor
  · rintro ⟨p, h⟩
    exact ⟨p, fun i d => h i d.1⟩
  · rintro ⟨p, h⟩
    have go : ∀ n i, rank i = n → D i → C i := by
      intro n
      induction n using Nat.strongRecOn with
      | ind n before =>
        intro i eq d
        exact h i ⟨d, derive i p d (fun j smaller dj =>
          before (rank j) (eq ▸ smaller) j rfl dj)⟩
    exact ⟨p, fun i => go (rank i) i rfl⟩

/-- Asking each of two original unconditional rows to justify the other
    can let the valuation x=y=1 through both rewritten rows. -/
theorem cyclic_cuts_fail :
    ∃ x y : Int, ((y=0 → x=0) ∧ (x=0 → y=0)) ∧ ¬ (x=0 ∧ y=0) := by
  exact ⟨1, 1, by decide⟩

/-- Both modes remain possible. Taking a conditional provider as global
    loses the obligation at flag one, key one, even though the strengthened
    guard is still live at flag one, key zero. -/
def Candidate (f k r : Int) : Prop :=
  (f=0 ∧ k=0 ∧ r=0) ∨ (f=1 ∧ 0≤k ∧ k≤1 ∧ r=k)

theorem conditional_cut_fails :
    (∀ f k r, Candidate f k r → f=0 → k=0) ∧
    (∀ f k r, Candidate f k r → f=1 ∧ k=0 → r=0) ∧
    Candidate 1 0 0 ∧ Candidate 1 1 1 ∧
    ¬ (∀ f k r, Candidate f k r → f=1 → r=0) := by
  refine ⟨?_, ?_, by simp [Candidate], by simp [Candidate], ?_⟩
  · intro f k r h z; unfold Candidate at h; omega
  · intro f k r h z; unfold Candidate at h; omega
  · intro h; have bad := h 1 1 1 (by simp [Candidate]) rfl; omega

theorem flag_zero_key {k : Int} (nonneg : 0≤k) (choice : k≤0 ∨ 1≤(0:Int)) :
    k=0 := by omega

/-- A finite nonempty sample from a nested family has a smallest member. -/
theorem finite_nested_min {I R : Type} (B : I → R → Prop)
    (nested : ∀ i j, (∀ r, B i r → B j r) ∨ (∀ r, B j r → B i r))
    (i : I) (rest : List I) :
    ∃ m ∈ i :: rest, ∀ j ∈ i :: rest, ∀ r, B m r → B j r := by
  induction rest generalizing i with
  | nil => exact ⟨i, by simp, by simp⟩
  | cons a xs ih =>
    obtain ⟨m, hm, least⟩ := ih a
    rcases nested i m with im | mi
    · refine ⟨i, by simp, ?_⟩
      intro j hj r h
      rcases List.mem_cons.mp hj with rfl | hj
      · exact h
      · exact least j hj r (im r h)
    · refine ⟨m, List.mem_cons_of_mem i hm, ?_⟩
      intro j hj r h
      rcases List.mem_cons.mp hj with rfl | hj
      · exact mi r h
      · exact least j hj r h

theorem finite_basis_iff_minimum {I R : Type} (B : I → R → Prop)
    (nested : ∀ i j, (∀ r, B i r → B j r) ∨ (∀ r, B j r → B i r)) :
    (∃ (i : I) (rest : List I), ∀ r, (∀ j ∈ i :: rest, B j r) ↔ ∀ j, B j r) ↔
    ∃ m, ∀ j r, B m r → B j r := by
  constructor
  · rintro ⟨i, rest, basis⟩
    obtain ⟨m, _, least⟩ := finite_nested_min B nested i rest
    exact ⟨m, fun j r h => (basis r).mp (fun l hl => least l hl r h) j⟩
  · rintro ⟨m, least⟩
    exact ⟨m, [], fun r => ⟨fun all j => least j r (all m (by simp)),
                              fun all j _ => all j⟩⟩

/-- Positive denominators of all the sampled keys divide one positive D. -/
theorem common_denominator (ds : List Nat) (pos : ∀ d ∈ ds, 0 < d) :
    ∃ D : Nat, 0 < D ∧ ∀ d ∈ ds, d ∣ D := by
  induction ds with
  | nil => exact ⟨1,by decide,by simp⟩
  | cons a xs ih =>
    obtain ⟨m,hm,hxs⟩ := ih (fun d hd => pos d (by simp [hd]))
    refine ⟨a*m, Nat.mul_pos (pos a (by simp)) hm, ?_⟩
    intro d hd
    rcases List.mem_cons.mp hd with rfl | hx
    · exact Nat.dvd_mul_right _ _
    · exact Nat.dvd_trans (hxs d hx) (Nat.dvd_mul_left _ _)

/-- N and K are in units of 1/D. Every such key permits the payload
    1/D, including the exceptional key at the width itself. -/
theorem grid_survivor (N K : Int) : K+1≤N ∨ N≤K := by omega

/-- The immediately preceding grid key attains the upper bound. H is
    one grid unit after rescaling to include the candidate result. -/
theorem grid_predecessor {N H R : Int} (pos : 0<H) :
    (N-H+R≤N ∨ N≤N-H) ↔ R≤H := by omega

/-- After rescaling by two, K=2*N-R represents the key n-r/2. -/
theorem adaptive_key {N R : Int} (positive : 0<R) (fits : R≤N) :
    ∃ K : Int, (0≤K ∧ K≤2*N) ∧ ¬ (K+2*R≤2*N ∨ 2*N≤K) := by
  exact ⟨2*N-R,by omega,by omega⟩

theorem zero_always_supplied {N K : Int} (admitted : K≤N) :
    K+0≤N ∨ N≤K := by omega

/-- In common denominator units S, an open interval of radius S
    cannot contain two marked guard results separated by at least 2S. -/
theorem separated_results {X Y K S : Int} (apart : X+2*S≤Y) :
    ¬ ((K-S<X ∧ X<K+S) ∧ (K-S<Y ∧ Y<K+S)) := by omega

/-- A key that can refute at most one marked result can be removed
    after serving its mark. Other marks retain their own keys. -/
private theorem count_marks {I K : Type} [DecidableEq K] (hits : K → I → Prop)
    (one : ∀ k i j, hits k i → hits k j → i=j)
    (marks : List I) (keys : List K) (distinct : marks.Nodup)
    (covers : ∀ i ∈ marks, ∃ k ∈ keys, hits k i) :
    marks.length ≤ keys.length := by
  induction marks generalizing keys with
  | nil => simp
  | cons a xs ih =>
    obtain ⟨fresh, tail⟩ := List.nodup_cons.mp distinct
    obtain ⟨k,hk,ha⟩ := covers a (by simp)
    have bound := ih (keys.erase k) tail (by
      intro i hi
      obtain ⟨j,hj,hit⟩ := covers i (List.mem_cons_of_mem a hi)
      have ne : j ≠ k := by
        intro eq; subst j
        exact fresh ((one k i a hit ha) ▸ hi)
      exact ⟨j, (List.mem_erase_of_ne ne).mpr hj, hit⟩)
    have enough : 0 < keys.length := List.length_pos_of_mem hk
    rw [List.length_erase_of_mem hk] at bound
    simp only [List.length_cons]
    omega

/-- The marked positions 0, 2S, ..., 2S floor(n/2) already force
    the full lower bound, for arbitrary sampled keys in units of 1/S. -/
theorem width_packing_lower (n : Nat) (S : Int) (pos : 0<S) (keys : List Int)
    (covers : ∀ i : Nat, i≤n/2 → ∃ k ∈ keys,
      k-S < (2*S)*(i:Int) ∧ (2*S)*(i:Int) < k+S) :
    n/2+1 ≤ keys.length := by
  let hits := fun (k : Int) (i : Nat) => k-S < (2*S)*(i:Int) ∧ (2*S)*(i:Int) < k+S
  have apart (i j : Nat) (before : i<j) (k : Int) (hi : hits k i) (hj : hits k j) : False := by
    have step : (i:Int)+1 ≤ j := by omega
    have gap := Int.mul_le_mul_of_nonneg_left step (by omega : 0≤2*S)
    rw [Int.mul_add, Int.mul_one] at gap
    exact (separated_results gap) ⟨hi,hj⟩
  have one : ∀ k i j, hits k i → hits k j → i=j := by
    intro k i j hi hj
    rcases Nat.lt_trichotomy i j with lt | eq | gt
    · exact (apart i j lt k hi hj).elim
    · exact eq
    · exact (apart j i gt k hj hi).elim
  have bound := count_marks hits one (List.range (n/2+1)) keys List.nodup_range (by
    intro i hi
    have h := List.mem_range.mp hi
    exact covers i (by omega))
  simpa using bound

/-- Include both endpoints, assigning the common boundary to either cell. -/
private theorem locate_cell (y w t : Nat) (positive : 0<t) (fits : y≤t*w) :
    ∃ j<t, j*w≤y ∧ y≤(j+1)*w := by
  induction t with
  | zero => omega
  | succ t ih =>
    by_cases earlier : y<t*w
    · have previous : 0<t := by
        by_cases ht : t=0
        · simp [ht] at earlier
        · omega
      obtain ⟨j,hj,inside⟩ := ih previous (Nat.le_of_lt earlier)
      exact ⟨j, by omega, inside⟩
    · exact ⟨t, by omega, by omega, fits⟩

/-- With R/S in the closed guard, use units of 1/(2tS).
    The j-th preselected midpoint has numerator A+B, where A and B
    are the cell endpoints in units of 1/(tS). -/
theorem width_packing_upper (n S R : Nat) (denom : 0<S) (fits : R≤n*S) :
    let t := n/2+1
    ∃ j<t, let K := j*(n*S)+(j+1)*(n*S)
           K≤2*(t*(n*S)) ∧ ¬ (2*(t*R)+2*(t*S)≤K ∨ K+2*(t*S)≤2*(t*R)) := by
  let t := n/2+1
  have positive : 0<t := by dsimp [t]; omega
  have narrow : n<2*t := by dsimp [t]; omega
  have small : n*S < 2*(t*S) := by
    simpa only [Nat.mul_assoc] using Nat.mul_lt_mul_of_pos_right narrow denom
  obtain ⟨j,hj,lo,hi⟩ := locate_cell (t*R) (n*S) t positive (Nat.mul_le_mul_left t fits)
  have admitted := Nat.mul_le_mul_right (n*S) (show j+1≤t by omega)
  refine ⟨j, hj, ?_⟩
  change j*(n*S)+(j+1)*(n*S) ≤ 2*(t*(n*S)) ∧
    ¬ (2*(t*R)+2*(t*S) ≤ j*(n*S)+(j+1)*(n*S) ∨
       j*(n*S)+(j+1)*(n*S)+2*(t*S) ≤ 2*(t*R))
  have upper : (j+1)*(n*S) = j*(n*S)+n*S := Nat.succ_mul j (n*S)
  simp only [upper] at admitted hi ⊢
  omega

end GroundedClients
