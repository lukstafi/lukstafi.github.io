import Mathlib.Data.Fintype.Basic

namespace TermAdmissions

variable {X K L R : Type*}

def Domain (A : X → K → Prop) (x : X) := ∃ k, A x k
def Shared (A : X → K → Prop) (x y : X) := ∃ k, A x k ∧ A y k
def Rect (A : X → K → Prop) :=
  ∀ x y k j, A x k → A y k → A y j → A x j
def Opened (A : X → K → Prop) (P : K → R → Prop) (x : X) (r : R) :=
  Domain A x ∧ ∀ k, A x k → P k r
def Store (A : X → K → Prop) (U : X → R → Prop) (k : K) (r : R) :=
  ∃ x, A x k ∧ U x r
def Saturated (A : X → K → Prop) (U : X → R → Prop) :=
  (∀ x r, U x r → Domain A x) ∧
  ∀ x y r, Shared A x y → U y r → U x r
def Sub {I J : Type*} (U V : I → J → Prop) := ∀ i j, U i j → V i j

theorem same_menu {A : X → K → Prop} (rect : Rect A) {x y : X}
    (e : Shared A x y) {j : K} : A x j ↔ A y j := by
  obtain ⟨k, hx, hy⟩ := e
  exact ⟨rect y x k j hy hx, rect x y k j hx hy⟩

theorem opened_saturated {A : X → K → Prop} (rect : Rect A) (P : K → R → Prop) :
    Saturated A (Opened A P) := by
  refine ⟨fun _ _ h => h.1, ?_⟩
  intro x y r e h
  exact ⟨⟨e.choose, e.choose_spec.1⟩, fun j hj => h.2 j ((same_menu rect e).1 hj)⟩

theorem open_store {A : X → K → Prop} (rect : Rect A) (U : X → R → Prop) (x : X) (r : R) :
    Opened A (Store A U) x r ↔ ∃ y, Shared A x y ∧ U y r := by
  constructor
  · rintro ⟨⟨k, hx⟩, h⟩
    obtain ⟨y, hy, u⟩ := h k hx
    exact ⟨y, ⟨k, hx, hy⟩, u⟩
  · rintro ⟨y, e, u⟩
    exact ⟨⟨e.choose, e.choose_spec.1⟩, fun j hj => ⟨y, (same_menu rect e).1 hj, u⟩⟩

theorem representable {A : X → K → Prop} (rect : Rect A) (U : X → R → Prop) :
    (∃ P, Opened A P = U) ↔ Saturated A U := by
  constructor
  · rintro ⟨P, rfl⟩
    exact opened_saturated rect P
  · intro h
    refine ⟨Store A U, ?_⟩
    funext x r
    apply propext
    rw [open_store rect]
    constructor
    · rintro ⟨y, e, u⟩
      exact h.2 x y r e u
    · intro u
      obtain ⟨k, hk⟩ := h.1 x r u
      exact ⟨x, ⟨k, hk, hk⟩, u⟩

theorem least_store (A : X → K → Prop) (P : K → R → Prop) :
    Sub (Store A (Opened A P)) P := by
  rintro k r ⟨x, ha, u⟩
  exact u.2 k ha

theorem transfer {A : X → K → Prop} {B : X → L → Prop} {U : X → R → Prop}
    (domain : ∀ x, Domain B x → Domain A x)
    (finer : ∀ x y, Shared A x y → Shared B x y) (h : Saturated B U) : Saturated A U :=
  ⟨fun x r u => domain x (h.1 x r u), fun x y r e => h.2 x y r (finer x y e)⟩

/-- The least public inductive pattern on a finer partition is more precise.
    Good can also require membership in a specified pattern language. -/
theorem least_finer {A : X → K → Prop} {B : X → L → Prop}
    (domain : ∀ x, Domain B x → Domain A x)
    (finer : ∀ x y, Shared A x y → Shared B x y)
    (Good : (X → R → Prop) → Prop) (fine coarse : X → R → Prop)
    (least : ∀ U, Good U → Saturated A U → Sub fine U)
    (good : Good coarse) (sat : Saturated B coarse) : Sub fine coarse :=
  least coarse good (transfer domain finer sat)

/-- Keep call admission separate even when the result section is empty. -/
theorem identity_key (D : X → Prop) (U : X → R → Prop) (live : ∀ x r, U x r → D x) :
    Opened (fun x k => D x ∧ k = x) U = U := by
  funext x r
  apply propext
  constructor
  · rintro ⟨⟨_, hd, rfl⟩, h⟩
    exact h _ ⟨hd, rfl⟩
  · intro u
    refine ⟨⟨x, live x r u, rfl⟩, ?_⟩
    rintro _ ⟨_, rfl⟩
    exact u

/-- A coordinate is essential if changing just that coordinate can lose an observation. -/
def Essential {I T : Type*} (U : (I → T) → R → Prop) (i : I) :=
  ∃ a b r, (∀ j, j ≠ i → a j = b j) ∧ U a r ∧ ¬ U b r

theorem capture_criterion {I T : Type*} [Fintype I] (U : (I → T) → R → Prop)
    (C : Finset I) :
    (∀ a b r, (∀ i ∈ C, a i = b i) → U a r → U b r) ↔
    ∀ i, Essential U i → i ∈ C := by
  classical
  constructor
  · intro preserve i h
    obtain ⟨a,b,r,eq,ua,ub⟩ := h
    by_contra missing
    apply ub (preserve a b r _ ua)
    intro j hj
    exact eq j (fun hji => missing (hji ▸ hj))
  · intro covers a b r agree ua
    have changeSet (s : Finset I) (x : I → T) (outside : ∀ i ∈ s, i ∉ C)
        (fixed : ∀ i, i ∉ s → x i = b i) (ux : U x r) : U b r := by
      induction s using Finset.induction_on generalizing x with
      | empty =>
        have eq : x = b := funext (fun i => fixed i (by simp))
        exact eq ▸ ux
      | @insert i s hi ih =>
        let y := Function.update x i (b i)
        have uy : U y r := by
          by_contra hy
          apply outside i (by simp)
          exact covers i ⟨x, y, r, fun j hj => (Function.update_of_ne hj _ _).symm, ux, hy⟩
        apply ih y (fun j hj => outside j (Finset.mem_insert_of_mem hj)) _ uy
        intro j hj
        by_cases hji : j = i
        · subst j
          simp [y]
        · exact (Function.update_of_ne hji _ _).trans (fixed j (by simp [hji, hj]))
    apply changeSet (Finset.univ \ C) a _ _ ua
    · intro i hi
      exact (Finset.mem_sdiff.mp hi).2
    · intro i hi
      apply agree i
      simpa using hi

end TermAdmissions
