import Std

namespace RecursiveAdmission

def Fibre (domain : W → Prop) (positions : W → Z) (z : Z) : Prop :=
  ∃ w, domain w ∧ positions w = z

/-- Each scheme instantiates its own binders; both must give the requested tuple. -/
theorem common_tuple (d : A → Prop) (e : B → Prop) (p : A → Z) (q : B → Z) (z : Z) :
    (Fibre d p z ∧ Fibre e q z) ↔ ∃ a b, d a ∧ e b ∧ p a = z ∧ q b = z := by
  constructor
  · rintro ⟨⟨a, ha, hpa⟩, ⟨b, hb, hqb⟩⟩
    exact ⟨a,b,ha,hb,hpa,hqb⟩
  · rintro ⟨a,b,ha,hb,hpa,hqb⟩
    exact ⟨⟨a,ha,hpa⟩, ⟨b,hb,hqb⟩⟩

/-- A coordinate determined by the remaining parameters may be substituted
    throughout the arrow and its domain, including inside the result package. -/
theorem substitute_graph (g : A → B) (d : A → B → Prop) (p : A → B → Z) (z : Z) :
    (∃ a b, b = g a ∧ d a b ∧ p a b = z) ↔
      ∃ a, d a (g a) ∧ p a (g a) = z := by
  constructor
  · rintro ⟨a,_,rfl,hd,hp⟩; exact ⟨a,hd,hp⟩
  · rintro ⟨a,hd,hp⟩; exact ⟨a,g a,rfl,hd,hp⟩

theorem conditional_cells (cell : I → Prop) (post : W → Prop) :
    ((∃ i, cell i) → ∃ w, post w) ↔ ∀ i, cell i → ∃ w, post w := by
  constructor
  · intro h i hi; exact h ⟨i,hi⟩
  · rintro h ⟨i,hi⟩; exact h i hi

/-- One Fourier–Motzkin step. The argument works in every inhabited total order.
    A nonempty finite list has a greatest member, or dually a least member. -/
private theorem greatest {α : Type} (le : α → α → Prop)
    (refl : ∀ a, le a a) (trans : ∀ {a b c}, le a b → le b c → le a c)
    (total : ∀ a b, le a b ∨ le b a) (a : α) (xs : List α) :
    ∃ b ∈ a::xs, ∀ t ∈ a::xs, le t b := by
  induction xs generalizing a with
  | nil => exact ⟨a, by simp, by simpa using refl a⟩
  | cons c cs ih =>
    obtain ⟨b, hb, h⟩ := ih c
    rcases total a b with hab | hba
    · exact ⟨b, List.mem_cons_of_mem _ hb, by simpa using And.intro hab h⟩
    · refine ⟨a, by simp, ?_⟩
      intro t ht
      rcases List.mem_cons.mp ht with rfl | ht
      · exact refl _
      · exact trans (h t ht) hba

theorem project_pivot {α : Type} (default : α) (le : α → α → Prop)
    (refl : ∀ a, le a a) (trans : ∀ {a b c}, le a b → le b c → le a c)
    (total : ∀ a b, le a b ∨ le b a) (lower upper : List α) :
    (∃ w, (∀ l ∈ lower, le l w) ∧ (∀ u ∈ upper, le w u)) ↔
    ∀ l ∈ lower, ∀ u ∈ upper, le l u := by
  constructor
  · rintro ⟨w,low,high⟩ l hl u hu; exact trans (low l hl) (high u hu)
  · intro pairs
    cases lower with
    | cons a xs =>
      obtain ⟨b,hb,h⟩ := greatest le refl trans total a xs
      exact ⟨b,h,pairs b hb⟩
    | nil =>
      cases upper with
      | nil => exact ⟨default, by simp, by simp⟩
      | cons a xs =>
        obtain ⟨b,_,h⟩ := greatest (fun x y => le y x) refl
          (fun h₁ h₂ => trans h₂ h₁) (fun x y => total y x) a xs
        exact ⟨b, by simp,h⟩

/-- Free coordinates on a diagonal cannot move one at a time. -/
theorem diagonal_move (new : I → Z) (old : Z) (diagonal : ∀ i j, new i = new j)
    (fixed : ∃ j, new j = old) : ∀ i, new i = old := by
  obtain ⟨j,hj⟩ := fixed
  exact fun i => (diagonal i j).trans hj

def allowed (f n k j : Int) := 0 ≤ f ∧ f ≤ 1 ∧ 2 ≤ n ∧ 0 ≤ k ∧ k ≤ n ∧
  (k ≤ 0 ∨ 1 ≤ f) ∧ j = k

def returns (f n k j r : Int) := 0 ≤ r ∧ r ≤ f ∧ r ≤ j+2 ∧
  (k+r ≤ n ∨ n+2 ≤ k+r)

theorem guard_at_zero {n : Int} (hn : 2 ≤ n) :
    allowed 1 n 0 0 ∧ returns 1 n 0 0 1 := by
  unfold allowed returns
  omega

theorem scalar_stuck {n k j : Int} (h : allowed 1 n k j) (oneFixed : k=0 ∨ j=0) :
    k=0 ∧ j=0 := by unfold allowed at h; omega

theorem joint_excludes {f n r : Int} (hn : 2 ≤ n) (hf : f ≤ 1)
    (guard : 1 ≤ r ∧ r ≤ f) : allowed f n n n ∧ ¬ returns f n n n r := by
  unfold allowed returns
  omega

def digits : List Bool → Nat
  | [] => 0
  | b :: bs => 3 * digits bs + if b then 2 else 0

theorem even_digits (bs : List Bool) : ∃ n, digits bs = 2*n := by
  induction bs with
  | nil => exact ⟨0,rfl⟩
  | cons b bs ih =>
    obtain ⟨n,hn⟩ := ih
    cases b
    · exact ⟨3*n, by simp [digits,hn]; omega⟩
    · exact ⟨3*n+1, by simp [digits,hn]; omega⟩

theorem distinct_digits (xs ys : List Bool) (len : xs.length = ys.length)
    (equal : digits xs = digits ys) : xs = ys := by
  induction xs generalizing ys with
  | nil => simpa using len.symm
  | cons b bs ih =>
    cases ys with
    | nil => simp at len
    | cons c cs =>
      simp only [List.length_cons, Nat.add_right_cancel_iff] at len
      cases b <;> cases c <;> simp [digits] at equal <;>
        first | exact congrArg (List.cons _) (ih _ len (by omega)) | omega

/-- An integer interval contained in the projection can cover only one code
    of any fixed length. Its first step above the lower code is odd. -/
theorem one_per_interval (cell : Nat → Prop)
    (between : ∀ a b c, a ≤ b → b ≤ c → cell a → cell c → cell b)
    (sound : ∀ n, cell n → ∃ k, n = 2*k)
    (xs ys : List Bool) (len : xs.length = ys.length)
    (hx : cell (digits xs)) (hy : cell (digits ys)) : xs = ys := by
  apply distinct_digits _ _ len
  obtain ⟨a,ha⟩ := even_digits xs
  obtain ⟨b,hb⟩ := even_digits ys
  by_cases ab : digits xs < digits ys
  · obtain ⟨k,h⟩ := sound _ (between _ (digits xs+1) _ (by omega) (by omega) hx hy)
    omega
  · by_cases ba : digits ys < digits xs
    · obtain ⟨k,h⟩ := sound _ (between _ (digits ys+1) _ (by omega) (by omega) hy hx)
      omega
    · omega

end RecursiveAdmission
