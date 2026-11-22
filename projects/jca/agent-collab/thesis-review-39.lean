import Std

namespace AllRecursiveTypings

def Common (admits : K → Prop) (post : K → R → W → Prop) (r : R) :=
  ∀ k, admits k → ∃ w, post k r w

theorem all_probes (a : K → Prop) (p : K → R → W → Prop) (r : R) :
    Common a p r ↔ ∀ choose : R → K, a (choose r) → ∃ w, p (choose r) r w := by
  constructor
  · intro h choose; exact h (choose r)
  · intro h k; exact h (fun _ => k)

theorem refutable (a : K → Prop) (p : K → R → W → Prop) (r : R) :
    ¬ Common a p r ↔ ∃ k, a k ∧ ¬ ∃ w, p k r w := by
  classical
  simp [Common]

/-- A change of coordinates may duplicate typings. Covering the admitted
    image and preserving each projected package suffices. -/
theorem change_coordinates (f : J → K) (a : J → Prop) (b : K → Prop)
    (p : J → R → U → Prop) (q : K → R → V → Prop)
    (maps : ∀ j, a j → b (f j)) (covers : ∀ k, b k → ∃ j, a j ∧ f j = k)
    (agrees : ∀ j r, a j → ((∃ u, p j r u) ↔ ∃ v, q (f j) r v)) (r : R) :
    Common a p r ↔ Common b q r := by
  constructor
  · intro h k hk
    obtain ⟨j,hj,rfl⟩ := covers k hk
    exact (agrees j r hj).mp (h j hj)
  · intro h j hj
    exact (agrees j r hj).mpr (h _ (maps j hj))

/-- Interpret d=1/(t+1). After clearing the other rational denominators,
    u+c*d has the sign of u*(t+1)+c. -/
theorem right_sign (u c : Int) : ∃ N : Nat, ∀ t ≥ N,
    (0 < u*((t:Int)+1)+c ↔ 0 < u ∨ (u=0 ∧ 0<c)) := by
  refine ⟨c.natAbs+1,?_⟩
  intro t ht
  have big : (c.natAbs:Int) < (t:Int)+1 := by omega
  have lo : -(c.natAbs:Int) ≤ c := by omega
  have hi : c ≤ (c.natAbs:Int) := by omega
  by_cases pos : 0 < u
  · have h := Int.mul_le_mul_of_nonneg_right (a:=1) (b:=u) (by omega) (by show 0 ≤ (t:Int)+1; omega)
    simp at h
    omega
  · by_cases neg : u < 0
    · have h := Int.mul_le_mul_of_nonneg_right (a:=u) (b:= -1) (by omega) (by show 0 ≤ (t:Int)+1; omega)
      simp at h
      omega
    · have z : u=0 := by omega
      simp [z]

/-- A finite family of projected rows has a common threshold for a fixed
    observation. Above it every Boolean combination sees its limiting signs. -/
theorem finite_threshold (rows : List A) (holds : A → Nat → Prop) (limit : A → Prop)
    (eventual : ∀ a, ∃ N, ∀ t ≥ N, holds a t ↔ limit a) :
    ∃ N, ∀ t ≥ N, ∀ a ∈ rows, holds a t ↔ limit a := by
  induction rows with
  | nil => exact ⟨0,by simp⟩
  | cons a xs ih =>
    obtain ⟨n,h⟩ := ih
    obtain ⟨m,g⟩ := eventual a
    refine ⟨max n m,?_⟩
    intro t ht b hb
    rcases List.mem_cons.mp hb with rfl | hx
    · exact g t (by omega)
    · exact h t (by omega) b hx

theorem decreasing_gaps (admits : Nat → Prop)
    (smaller : ∀ i j, i ≤ j → admits i → admits j) :
    (∃ t, admits t) ↔ ∃ N, ∀ t ≥ N, admits t := by
  constructor
  · rintro ⟨n,h⟩; exact ⟨n,fun t ht => smaller n t ht h⟩
  · rintro ⟨n,h⟩; exact ⟨n,h n (Nat.le_refl _)⟩

/-- Here t represents shrinking positive slack. Regions produced by
    escaping earlier cells persist under further shrinking. -/
theorem skip_disjoint_cell {region cell : X → Nat → Prop}
    (persists : ∀ x i j, i ≤ j → region x i → region x j)
    (disjoint : ∀ x t, region x t → ¬ cell x t)
    {x : X} {i : Nat} (inside : region x i) :
    ¬ ∃ N, ∀ t ≥ N, cell x t := by
  rintro ⟨n,h⟩
  exact disjoint x (max i n) (persists x i _ (Nat.le_max_left ..) inside)
    (h _ (Nat.le_max_right ..))

/-- At an odd width, no integral k lies strictly between the two
    endpoints of the forbidden band. Twice a legal rational key can equal n. -/
theorem odd_width (s k : Int) : ¬ (2*s < 2*k ∧ 2*k < 2*s+2) := by omega
/-- h is twice the proposed key. At the guard f=r=1, h=n is admitted
    and violates both arms of the package, at any positive width. -/
theorem half_key {n f r : Int} (width : 2≤n) (flag : f≤1) (guard : 1≤r ∧ r≤f) :
    (0≤n ∧ (n≤0 ∨ 1≤f)) ∧ ¬ (n+r≤n ∨ n+2≤n+r) := by omega

/-- W is a positive width. The upper package index follows a hinge in the
    offset s. Any refutation from the reference (0,0) needs 0<k≤W. -/
def Hinge (W s k j : Int) := 0<k ∧ k≤W ∧ j=max 0 (s+k)

theorem two_hinge_probes {W s : Int} (pos : 0<W) :
    Hinge W s W 0 ∨ Hinge W s W (s+W) := by
  by_cases h : s+W ≤ 0
  · exact Or.inl ⟨pos,by omega,by omega⟩
  · exact Or.inr ⟨pos,by omega,by omega⟩

/-- Along three equally spaced offsets the values of any one affine
    coordinate are in arithmetic progression. The argument also applies to
    rational proposals after multiplication by their common denominator. -/
theorem no_single_affine_probe {W a b c u v w : Int}
    (first : Hinge W (-2*W) a u) (middle : Hinge W (-W) b v)
    (last : Hinge W 0 c w) (affine : u+w=2*v) : False := by
  unfold Hinge at *
  omega

/-- After clearing denominators, the zeros of a nonconstant affine row
    occupy at most one point on a line parallel to a nonzero coefficient. -/
theorem affine_fibre {a u x y : Int} (slope : a ≠ 0)
    (root₁ : a*x+u=0) (root₂ : a*y+u=0) : x=y :=
  Int.eq_of_mul_eq_mul_left slope (by omega)

/-- On an L^d grid, slice is L^(d-1). If fewer than L proposals
    cover the grid, some proposal covers more than a slice. -/
theorem heavy_proposal (counts : List Nat) {L slice : Nat}
    (wide : counts.length < L) (pos : 0 < slice) (covers : L*slice ≤ counts.sum) :
    ∃ c ∈ counts, slice < c := by
  apply Classical.byContradiction
  intro missing
  have h : ∀ c ∈ counts, c ≤ slice := by
    intro c hc
    exact Nat.le_of_not_gt (fun gt => missing ⟨c,hc,gt⟩)
  have bound (xs : List Nat) (small : ∀ c ∈ xs, c ≤ slice) :
      xs.sum ≤ xs.length * slice := by
    induction xs with
    | nil => simp
    | cons x xs ih =>
      have hx := small x (by simp)
      have ht := ih (fun c hc => small c (by simp [hc]))
      simp only [List.sum_cons, List.length_cons, Nat.succ_mul]
      omega
  have tooSmall := Nat.mul_lt_mul_of_pos_right wide pos
  have upper := bound counts h
  omega

theorem opposing_arms {a b u v : Int} (aPos : 0<a) (bPos : 0<b)
    (covered : a*u+b*v ≤ 0) : u≤0 ∨ v≤0 := by
  by_cases hu : 0<u
  · by_cases hv : 0<v
    · have h₁ := Int.mul_pos aPos hu
      have h₂ := Int.mul_pos bPos hv
      omega
    · exact Or.inr (by omega)
  · exact Or.inl (by omega)

theorem integer_seed {r : Int} (low : 0≤r) (hi : 2*r≤3)
    (ends : r≤0 ∨ 3≤2*r) : r=0 := by omega

end AllRecursiveTypings
