import Mathlib.Algebra.Order.Archimedean.Basic
import Mathlib.Data.Finset.Insert
import Mathlib.Topology.Instances.Rat
import Mathlib.Topology.Order.DenselyOrdered
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

/-! Finite menus synchronize their openings. The rational example below has a
first limit, a second increasing sequence, and a least fixed point at its
union. `finite_strict`, `after_strict`, `second_fixed` and `second_least`
are stated for the producer step itself. -/

namespace AllKeys

theorem finite_open {K : Type*} (keys : Finset K) (R : ℕ → K → Prop)
    (inc : ∀ n m, n ≤ m → ∀ k, R n k → R m k)
    (atLimit : ∀ k ∈ keys, ∃ n, R n k) : ∃ n, ∀ k ∈ keys, R n k := by
  classical
  induction keys using Finset.induction_on with
  | empty => exact ⟨0,by simp⟩
  | insert a s _ ih =>
    obtain ⟨n,old⟩ := ih (fun k hk => atLimit k (Finset.mem_insert_of_mem hk))
    obtain ⟨m,added⟩ := atLimit a (Finset.mem_insert_self a s)
    refine ⟨max n m, ?_⟩
    intro k hk
    rcases Finset.mem_insert.mp hk with rfl | prev
    · exact inc _ _ (le_max_right _ _) _ added
    · exact inc _ _ (le_max_left _ _) _ (old k prev)

section Menus
variable {X K : Type*} (legal : X → Prop) (admits : X → K → Prop)

def ExactMenu (R : K → X → Prop) := ∀ x, legal x → ∀ r,
  (∀ k, admits x k → R k r) ↔ r=x

theorem exact_menu_iff (inhabited : ∀ x, legal x → ∃ k, admits x k) :
    (∃ R, ExactMenu legal admits R) ↔
    ∀ x y, legal x → legal y → (∀ k, admits x k → admits y k) → x=y := by
  constructor
  · rintro ⟨R,exactAt⟩ x y hx hy sub
    exact ((exactAt x hx y).mp (fun k hk => (exactAt y hy y).mpr rfl k (sub k hk))).symm
  · intro sep
    refine ⟨fun k r => legal r ∧ admits r k, ?_⟩
    intro x hx r
    constructor
    · intro opened
      obtain ⟨k,hk⟩ := inhabited x hx
      exact (sep x r hx (opened k hk).1 (fun k h => (opened k h).2)).symm
    · rintro rfl k hk
      exact ⟨hx,hk⟩
end Menus

def Legal (x : ℚ) := 0 ≤ x ∧ x ≤ 1

def Admits (x k : ℚ) := Legal k ∧ (x+k ≤ 1 ∨ (x=1 ∧ k=1))

def Opens (R : ℚ → ℚ → Prop) (x r : ℚ) := ∀ k, Admits x k → R k r

structure Producers (R : ℚ → ℚ → Prop) : Prop where
  base : ∀ x, Legal x → Opens R x x
  next : ∀ x r, Legal x → Opens R x r → Opens R x (2*r-x)

theorem zero_all {R} (p : Producers R) (x : ℚ) : Opens R x 0 := by
  intro k hk
  exact p.base 0 (by constructor <;> norm_num) k ⟨hk.1, Or.inl (by linarith [hk.1.2])⟩

theorem forced {R} (p : Producers R) (x : ℚ) (hx : Legal x) (n : ℕ) :
    Opens R x (-((2:ℚ)^n-1)*x) := by
  induction n with
  | zero => simpa using zero_all p x
  | succ n ih =>
    convert p.next x _ hx ih using 1
    rw [pow_succ]
    ring

/-- The required number of producer steps can depend on the chosen key. -/
theorem minus_one_of_forced {R : ℚ → ℚ → Prop}
    (force : ∀ x, Legal x → ∀ n : ℕ, Opens R x (-((2:ℚ)^n-1)*x)) : Opens R 0 (-1) := by
  intro k hk
  by_cases top : k=1
  · subst k
    have h := force 1 (by constructor <;> norm_num) 1 1
      ⟨⟨by norm_num,le_rfl⟩, Or.inr ⟨rfl,rfl⟩⟩
    norm_num at h
    exact h
  have pos : 0 < 1-k := by linarith [lt_of_le_of_ne hk.1.2 top]
  obtain ⟨n,hn⟩ := pow_unbounded_of_one_lt (1 + 1/(1-k)) (by norm_num : (1:ℚ)<2)
  let t : ℚ := 2^n-1
  have ht : 1/(1-k) < t := by dsimp [t]; linarith
  have hp : 0 < t := lt_trans (div_pos zero_lt_one pos) ht
  have small : 1/t ≤ 1-k := by
    apply (div_le_iff₀ hp).2
    have := (div_lt_iff₀ pos).1 ht
    linarith [mul_comm t (1-k)]
  have hx : Legal (1/t) := ⟨(div_pos zero_lt_one hp).le, by linarith [hk.1.1]⟩
  have h := force (1/t) hx n k ⟨hk.1, Or.inl (by linarith)⟩
  change R k (-t * (1/t)) at h
  rwa [show -t * (1/t) = -1 by field_simp] at h

theorem minus_one_all {R} (p : Producers R) : Opens R 0 (-1) :=
  minus_one_of_forced (forced p)

def Base (k r : ℚ) := Legal r ∧ Admits r k

def Step (R : ℚ → ℚ → Prop) (k r : ℚ) :=
  Base k r ∨ ∃ x q, Legal x ∧ Admits x k ∧ Opens R x q ∧ r=2*q-x

def Stage : ℕ → ℚ → ℚ → Prop
  | 0 => Base
  | n+1 => Step (Stage n)

def slope (n : ℕ) : ℚ := 2^n-1

theorem slope_nonneg (n : ℕ) : 0 ≤ slope n := by
  exact sub_nonneg.mpr (one_le_pow₀ (by norm_num))

theorem slope_succ (n : ℕ) : slope (n+1) = 2*slope n+1 := by
  dsimp [slope]
  rw [pow_succ]
  ring

theorem ordinary_key {x k : ℚ} (ha : Admits x k) (hk : k<1) : x ≤ 1-k := by
  rcases ha.2 with h | h
  · linarith
  · linarith [h.2]

theorem opening_bounds {R : ℚ → ℚ → Prop} {c : ℚ} (hc : 0 ≤ c)
    (bound : ∀ k r, k<1 → R k r → -c*(1-k) ≤ r ∧ r ≤ 1-k)
    {x r : ℚ} (hx : Legal x) (opened : Opens R x r) : -c*x ≤ r ∧ r ≤ x := by
  have at_key (y : ℚ) (xy : x ≤ y) (pos : 0 < y) (hi : y ≤ 1) :
      -c*y ≤ r ∧ r ≤ y := by
    have key : Admits x (1-y) :=
      ⟨⟨by linarith,by linarith⟩,Or.inl (by linarith)⟩
    simpa using bound (1-y) r (by linarith) (opened _ key)
  rcases eq_or_lt_of_le hx.1 with h | h
  · subst x
    simp only [mul_zero]
    constructor
    · by_contra! neg
      let y := min 1 (-r/(2*(c+1)))
      have denom : 0 < 2*(c+1) := by linarith
      have pos : 0 < y := lt_min (by norm_num) (div_pos (by linarith) denom)
      have small := (le_div_iff₀ denom).mp (min_le_right (1:ℚ) (-r/(2*(c+1))))
      change y * (2*(c+1)) ≤ -r at small
      have lower := (at_key y pos.le pos (min_le_left _ _)).1
      nlinarith
    · by_contra! pos
      let y := min 1 (r/2)
      have hy : 0 < y := lt_min (by norm_num) (by linarith)
      have le := (at_key y hy.le hy (min_le_left _ _)).2
      linarith [show y ≤ r/2 from min_le_right _ _]
  · exact at_key x le_rfl h hx.2

theorem finite_bounds (n : ℕ) (k r : ℚ) (hk : k<1) (hr : Stage n k r) :
    -slope n*(1-k) ≤ r ∧ r ≤ 1-k := by
  induction n generalizing k r with
  | zero => exact ⟨by simpa [slope] using hr.1.1, ordinary_key hr.2 hk⟩
  | succ n ih =>
    rcases hr with hb | ⟨x,q,hx,ha,hq,rfl⟩
    · exact ⟨le_trans (mul_nonpos_of_nonpos_of_nonneg
          (neg_nonpos.mpr (slope_nonneg _)) (by linarith)) hb.1.1, ordinary_key hb.2 hk⟩
    · obtain ⟨lower,upper⟩ := opening_bounds (slope_nonneg n) ih hx hq
      have small := ordinary_key ha hk
      have major := mul_le_mul_of_nonneg_left small (slope_nonneg (n+1))
      rw [slope_succ] at major ⊢
      constructor <;> nlinarith

theorem finite_zero (n : ℕ) {r : ℚ} (h : Opens (Stage n) 0 r) : r=0 := by
  have := opening_bounds (slope_nonneg n) (finite_bounds n)
    (show Legal 0 from ⟨le_rfl, by norm_num⟩) h
  exact le_antisymm this.2 (by simpa using this.1)

theorem zero_in_stage (n : ℕ) (x : ℚ) : Opens (Stage n) x 0 := by
  intro k ha
  have b : Base k 0 := ⟨⟨le_rfl,by norm_num⟩,ha.1,Or.inl (by linarith [ha.1.2])⟩
  cases n with
  | zero => exact b
  | succ n => exact Or.inl b

theorem forced_at_stage (x : ℚ) (hx : Legal x) (n : ℕ) :
    Opens (Stage n) x (-((2:ℚ)^n-1)*x) := by
  induction n with
  | zero => simpa using zero_in_stage 0 x
  | succ n ih =>
    intro k ha
    refine Or.inr ⟨x,_,hx,ha,ih,?_⟩
    rw [pow_succ]
    ring

def FirstLimit (k r : ℚ) := ∃ n, Stage n k r

theorem minus_one_limit : Opens FirstLimit 0 (-1) := by
  apply minus_one_of_forced
  intro x hx n k ha
  exact ⟨n,forced_at_stage x hx n k ha⟩

theorem exceptional (n : ℕ) {r : ℚ} (h : Stage n 1 r) :
    r=1 ∨ ∃ j : ℕ, r=1-(2:ℚ)^j := by
  induction n generalizing r with
  | zero =>
    rcases h.2.2 with small | top
    · exact Or.inr ⟨0,by simp; linarith [h.1.1]⟩
    · exact Or.inl top.1
  | succ n ih =>
    rcases h with base | ⟨x,q,hx,ha,hq,rfl⟩
    · rcases base.2.2 with small | top
      · exact Or.inr ⟨0,by simp; linarith [base.1.1]⟩
      · exact Or.inl top.1
    · rcases ha.2 with small | top
      · have zero : x=0 := by linarith [hx.1]
        subst x
        exact Or.inr ⟨0,by simp [finite_zero n hq]⟩
      · rcases ih (hq 1 ha) with one | ⟨j,eq⟩
        · exact Or.inl (by linarith [top.1])
        · exact Or.inr ⟨j+1,by rw [pow_succ]; linarith [top.1]⟩

theorem first_limit_grows : Step FirstLimit 1 (-2) ∧ ¬ FirstLimit 1 (-2) := by
  constructor
  · exact Or.inr ⟨0,-1,⟨le_rfl,by norm_num⟩,⟨⟨by norm_num,le_rfl⟩,Or.inl (by norm_num)⟩,
      minus_one_limit,by norm_num⟩
  · rintro ⟨n,h⟩
    rcases exceptional n h with bad | ⟨j,eq⟩
    · norm_num at bad
    · have hpow : (2:ℚ)^j=3 := by linarith
      have hn : (2:ℕ)^j=3 := by exact_mod_cast hpow
      cases j with
      | zero => simp at hn
      | succ j => rw [pow_succ] at hn; omega

def Cap (k r : ℚ) := r ≤ 1 ∧ (k+r ≤ 1 ∨ k=1)

theorem cap_base (x : ℚ) (hx : Legal x) : Opens Cap x x := by
  intro k hk
  exact ⟨hx.2, hk.2.elim (fun h => Or.inl (by linarith)) (fun h => Or.inr h.2)⟩

theorem cap_safe {x r : ℚ} (hx : Legal x) (h : Opens Cap x r) : r ≤ x := by
  have key : Admits x (1-x) := ⟨⟨by linarith [hx.2],by linarith [hx.1]⟩, Or.inl (by linarith)⟩
  obtain ⟨upper,ordinary | exceptional⟩ := h _ key
  · linarith
  · have x0 : x=0 := by linarith
    subst x
    by_contra! pos
    have hk : Admits 0 (1-r/2) :=
      ⟨⟨by linarith,by linarith⟩, Or.inl (by linarith)⟩
    rcases (h _ hk).2 with hr | hr <;> linarith

theorem cap_producers : Producers Cap where
  base := cap_base
  next x r hx h := by
    have le := cap_safe hx h
    intro k hk
    obtain ⟨upper,ordinary | top⟩ := cap_base x hx k hk
    · exact ⟨by linarith,Or.inl (by linarith)⟩
    · exact ⟨by linarith,Or.inr top⟩

/-- Every nonpositive rational is forced at every ordinary key. -/
theorem ordinary_of_forced {R : ℚ → ℚ → Prop}
    (force : ∀ x, Legal x → ∀ (n : ℕ) k, Legal k → x+k≤1 → R k (-((2:ℚ)^n-1)*x))
    {k r : ℚ}
    (hk : 0 ≤ k) (ordinary : k < 1) (hr : r ≤ 0) : R k r := by
  have gap : 0 < 1-k := by linarith
  obtain ⟨n,hn⟩ := pow_unbounded_of_one_lt (2+(-r)/(1-k)) (by norm_num : (1:ℚ)<2)
  let c : ℚ := 2^n-1
  have ratio := div_nonneg (neg_nonneg.mpr hr) gap.le
  have pos : 0 < c := by dsimp [c]; linarith
  have bound : (-r)/(1-k) ≤ c := by dsimp [c]; linarith
  have small : (-r)/c ≤ 1-k := (div_le_iff₀ pos).2 (by
    have := (div_le_iff₀ gap).1 bound
    linarith [mul_comm c (1-k)])
  have hx : Legal ((-r)/c) := ⟨div_nonneg (by linarith) pos.le,by linarith⟩
  have h := force _ hx n k ⟨hk,ordinary.le⟩ (by linarith)
  change R k (-c * (-r/c)) at h
  rwa [show -c*(-r/c)=r by field_simp] at h

theorem ordinary_nonpositive {R} (p : Producers R) {k r : ℚ}
    (hk : 0 ≤ k) (small : k<1) (hr : r≤0) : R k r :=
  ordinary_of_forced (fun x hx n i hi hxi => forced p x hx n i ⟨hi,Or.inl hxi⟩) hk small hr

def ClosedCap (k r : ℚ) := r ≤ 1-k ∨ (k=1 ∧ r=1)

theorem closedCap_le_cap {k r : ℚ} (hk : Legal k) (h : ClosedCap k r) : Cap k r := by
  rcases h with lo | ⟨top,one⟩
  · exact ⟨by linarith [hk.1],Or.inl (by linarith)⟩
  · exact ⟨one.le,Or.inr top⟩

theorem closedCap_base (x : ℚ) : Opens ClosedCap x x := by
  intro k hk
  rcases hk.2 with h | h
  · exact Or.inl (by linarith)
  · exact Or.inr ⟨h.2,h.1⟩

theorem closedCap_producers : Producers ClosedCap where
  base x _ := closedCap_base x
  next x r hx h := by
    have weaker : Opens Cap x r := fun k ha => closedCap_le_cap ha.1 (h k ha)
    have safe := cap_safe hx weaker
    intro k ha
    rcases ha.2 with ordinary | ⟨rfl,rfl⟩
    · exact Or.inl (by linarith)
    · rcases h 1 ⟨⟨by norm_num,le_rfl⟩,Or.inr ⟨rfl,rfl⟩⟩ with le | ⟨_,one⟩
      · exact Or.inl (by linarith)
      · exact Or.inr ⟨rfl,by linarith⟩

/-- The endpoint premise is satisfied by any relatively closed graph. -/
theorem least_closed {R} (p : Producers R)
    (at_one : ∀ r, (∀ k, 0 ≤ k → k < 1 → R k r) → R 1 r)
    {k r : ℚ} (hk : Legal k) (h : ClosedCap k r) : R k r := by
  rcases h with lo | ⟨rfl,rfl⟩
  · by_cases hr : r ≤ 0
    · rcases lt_or_eq_of_le hk.2 with small | rfl
      · exact ordinary_nonpositive p hk.1 small hr
      · exact at_one r (fun _ nonneg small => ordinary_nonpositive p nonneg small hr)
    · exact p.base r ⟨by linarith,by linarith [hk.1]⟩ k ⟨hk,Or.inl (by linarith)⟩
  · exact p.base 1 ⟨by norm_num,le_rfl⟩ 1 ⟨hk,Or.inr ⟨rfl,rfl⟩⟩

/-- The deficits at the exceptional key after the first limit.
    A successor step appends one binary digit. -/
def Deficit : ℕ → ℕ → Prop
  | 0, d => ∃ a : ℕ, d + 1 = 2^a
  | m+1, d => Deficit m d ∨ ∃ v, Deficit m v ∧ (d = 2*v ∨ d = 2*v+1)

theorem missing_power (m q : ℕ) (hq : m < q) : ¬ Deficit m (2^q) := by
  induction m generalizing q with
  | zero =>
    rintro ⟨a,ha⟩
    obtain ⟨j,rfl⟩ := Nat.exists_eq_succ_of_ne_zero (by omega : q≠0)
    cases a with
    | zero => simp at ha
    | succ a => rw [pow_succ, pow_succ] at ha; omega
  | succ m ih =>
    obtain ⟨j,rfl⟩ := Nat.exists_eq_succ_of_ne_zero (by omega : q≠0)
    rintro (old | ⟨v,hv,e | e⟩)
    · exact ih _ (by omega) old
    · rw [pow_succ] at e
      have eq : v = 2^j := by omega
      exact ih j (by omega) (eq ▸ hv)
    · rw [pow_succ] at e
      omega

theorem reaches_power (m : ℕ) : Deficit m (2^m) := by
  induction m with
  | zero => exact ⟨1,by decide⟩
  | succ m ih => exact Or.inr ⟨_,ih,Or.inl (by rw [pow_succ, Nat.mul_comm])⟩

theorem every_deficit (d : ℕ) : ∃ m, Deficit m d := by
  induction d using Nat.strong_induction_on with
  | h d ih =>
    by_cases zero : d=0
    · exact ⟨0,0,by simp [zero]⟩
    obtain ⟨m,h⟩ := ih (d/2) (Nat.div_lt_self (by omega) (by decide))
    exact ⟨m+1,Or.inr ⟨d/2,h,by omega⟩⟩

section Iteration

theorem step_mono {R S : ℚ → ℚ → Prop} (sub : ∀ k r, R k r → S k r) :
    ∀ k r, Step R k r → Step S k r := by
  rintro k r (base | ⟨x,q,hx,ha,hq,eq⟩)
  · exact Or.inl base
  · exact Or.inr ⟨x,q,hx,ha,fun i hi => sub i q (hq i hi),eq⟩

theorem includes_step {R} (p : Producers R) : ∀ k r, Step R k r → R k r := by
  rintro k r (base | ⟨x,q,hx,ha,hq,rfl⟩)
  · exact p.base _ base.1 _ base.2
  · exact p.next _ _ hx hq k ha

theorem finite_included {R} (p : Producers R) (n : ℕ) : ∀ k r, Stage n k r → R k r := by
  induction n with
  | zero => exact fun k r h => p.base r h.1 k h.2
  | succ n ih => exact fun k r h => includes_step p k r (step_mono ih k r h)

theorem ordinary_limit {k r : ℚ} (hk : Legal k) (small : k<1) :
    FirstLimit k r ↔ r ≤ 1-k := by
  constructor
  · rintro ⟨n,hn⟩
    exact (finite_bounds n k r small hn).2
  · intro le
    by_cases neg : r ≤ 0
    · apply ordinary_of_forced _ hk.1 small neg
      exact fun x hx n i hi hxi => ⟨n,forced_at_stage x hx n i ⟨hi,Or.inl hxi⟩⟩
    · exact ⟨0,⟨by linarith,by linarith [hk.1]⟩,hk,Or.inl (by linarith)⟩

def After : ℕ → ℚ → ℚ → Prop
  | 0 => FirstLimit
  | m+1 => Step (After m)

theorem after_increases (m : ℕ) : ∀ k r, After m k r → After (m+1) k r := by
  induction m with
  | zero =>
    rintro k r ⟨n,hn⟩
    cases n with
    | zero => exact Or.inl hn
    | succ n => exact step_mono (fun _ _ h => ⟨n,h⟩) k r hn
  | succ m ih => exact step_mono ih

theorem after_bounds (m : ℕ) (k r : ℚ) :
    (FirstLimit k r → After m k r) ∧ (After m k r → ClosedCap k r) := by
  constructor
  · induction m with
    | zero => exact id
    | succ m ih => exact fun h => after_increases m k r (ih h)
  · induction m generalizing k r with
    | zero => rintro ⟨n,h⟩; exact finite_included closedCap_producers n k r h
    | succ m ih => exact fun h => includes_step closedCap_producers k r (step_mono ih k r h)

theorem after_ordinary (m : ℕ) {k r : ℚ} (hk : Legal k) (small : k<1) :
    After m k r ↔ r ≤ 1-k := by
  constructor
  · intro h
    rcases (after_bounds m k r).2 h with le | top
    · exact le
    · linarith [top.1]
  · exact fun h => (after_bounds m k r).1 ((ordinary_limit hk small).mpr h)

theorem at_one (m : ℕ) {r : ℚ} : Opens (After m) 1 r ↔ After m 1 r := by
  constructor
  · exact fun h => h 1 ⟨⟨by norm_num,le_rfl⟩,Or.inr ⟨rfl,rfl⟩⟩
  · intro h k ha
    rcases ha.2 with small | top
    · have zero : k=0 := by linarith [ha.1.1]
      subst k
      apply (after_ordinary m ha.1 (by norm_num)).2
      rcases (after_bounds m 1 r).2 h with le | one
      · linarith
      · linarith [one.2]
    · rwa [top.2]

theorem at_zero (m : ℕ) {r : ℚ} : Opens (After m) 0 r ↔ r ≤ 0 ∧ After m 1 r := by
  constructor
  · intro h
    have weaker : Opens Cap 0 r := fun k ha =>
      closedCap_le_cap ha.1 ((after_bounds m k r).2 (h k ha))
    exact ⟨cap_safe ⟨le_rfl,by norm_num⟩ weaker,h 1 ⟨⟨by norm_num,le_rfl⟩,Or.inl (by norm_num)⟩⟩
  · rintro ⟨le,h⟩ k ha
    rcases lt_or_eq_of_le ha.1.2 with small | rfl
    · exact (after_ordinary m ha.1 small).2 (by linarith)
    · exact h

theorem zero_deficit (m : ℕ) : Deficit m 0 := by
  induction m with
  | zero => exact ⟨0,by decide⟩
  | succ m ih => exact Or.inl ih

theorem after_exceptional (m : ℕ) (r : ℚ) :
    After m 1 r ↔ r=1 ∨ ∃ d : ℕ, Deficit m d ∧ r=-(d:ℚ) := by
  induction m generalizing r with
  | zero =>
    constructor
    · rintro ⟨n,h⟩
      rcases exceptional n h with one | ⟨j,eq⟩
      · exact Or.inl one
      · have pos : 1 ≤ (2:ℕ)^j := Nat.one_le_pow j 2 (by decide)
        exact Or.inr ⟨2^j-1,⟨j,by omega⟩,by rw [Nat.cast_sub pos]; push_cast; linarith⟩
    · rintro (rfl | ⟨d,⟨j,h⟩,rfl⟩)
      · exact ⟨0,⟨by norm_num,le_rfl⟩,⟨by norm_num,le_rfl⟩,Or.inr ⟨rfl,rfl⟩⟩
      · have eq : (d:ℚ)+1=2^j := by exact_mod_cast h
        have force := forced_at_stage 1 (by constructor <;> norm_num) j 1
          ⟨⟨by norm_num,le_rfl⟩,Or.inr ⟨rfl,rfl⟩⟩
        exact ⟨j,by convert force using 1; linarith⟩
  | succ m ih =>
    have kept (q : ℚ) (h : After m 1 q) := after_increases m 1 q h
    constructor
    · rintro (base | ⟨x,q,hx,ha,hq,rfl⟩)
      · rcases base.2.2 with low | top
        · exact Or.inr ⟨0,Or.inl (zero_deficit m),by simp; linarith [base.1.1]⟩
        · exact Or.inl top.1
      · rcases ha.2 with low | top
        · have zero : x=0 := by linarith [hx.1]
          subst x
          obtain ⟨le,h⟩ := (at_zero m).mp hq
          rcases (ih q).mp h with one | ⟨d,hd,rfl⟩
          · linarith
          · exact Or.inr ⟨2*d,Or.inr ⟨d,hd,Or.inl rfl⟩,by push_cast; ring⟩
        · rw [top.1] at hq ⊢
          rcases (ih q).mp ((at_one m).mp hq) with one | ⟨d,hd,rfl⟩
          · exact Or.inl (by linarith)
          · exact Or.inr ⟨2*d+1,Or.inr ⟨d,hd,Or.inr rfl⟩,by push_cast; ring⟩
    · rintro (rfl | ⟨d,old | ⟨v,hv,step⟩,rfl⟩)
      · exact kept _ ((ih _).mpr (Or.inl rfl))
      · exact kept _ ((ih _).mpr (Or.inr ⟨_,old,rfl⟩))
      · have curr := (ih _).mpr (Or.inr ⟨v,hv,rfl⟩)
        rcases step with rfl | rfl
        · exact Or.inr ⟨0,_,⟨le_rfl,by norm_num⟩,⟨⟨by norm_num,le_rfl⟩,Or.inl (by norm_num)⟩,
            (at_zero m).mpr ⟨neg_nonpos.mpr (Nat.cast_nonneg v),curr⟩,by push_cast; ring⟩
        · exact Or.inr ⟨1,_,⟨by norm_num,le_rfl⟩,⟨⟨by norm_num,le_rfl⟩,Or.inr ⟨rfl,rfl⟩⟩,
            (at_one m).mpr curr,by push_cast; ring⟩

theorem finite_strict (n : ℕ) : ∃ k r, Stage (n+1) k r ∧ ¬ Stage n k r := by
  have next := forced_at_stage 1 (by constructor <;> norm_num) (n+1) 0
    ⟨⟨le_rfl,by norm_num⟩,Or.inl (by norm_num)⟩
  refine ⟨0,_,next,?_⟩
  intro old
  have lower := (finite_bounds n 0 _ (by norm_num) old).1
  dsimp [slope] at lower
  rw [pow_succ] at lower
  linarith [pow_pos (by norm_num : (0:ℚ)<2) n]

theorem after_strict (m : ℕ) : ∃ r, After (m+1) 1 r ∧ ¬ After m 1 r := by
  let d : ℕ := 2^(m+1)
  refine ⟨-(d:ℚ), (after_exceptional _ _).mpr (Or.inr ⟨d,reaches_power _,rfl⟩), ?_⟩
  intro old
  rcases (after_exceptional _ _).mp old with one | ⟨v,hv,eq⟩
  · linarith [Nat.cast_nonneg (α:=ℚ) d]
  · have h : (d:ℚ)=(v:ℚ) := by linarith
    have equal : d=v := by exact_mod_cast h
    exact missing_power m (m+1) (by omega) (equal ▸ hv : Deficit m d)

def SecondLimit (k r : ℚ) := ∃ m, After m k r

theorem second_exceptional (r : ℚ) :
    SecondLimit 1 r ↔ r=1 ∨ ∃ d : ℕ, r=-(d:ℚ) := by
  constructor
  · rintro ⟨m,h⟩
    rcases (after_exceptional m r).mp h with one | ⟨d,_,eq⟩
    · exact Or.inl one
    · exact Or.inr ⟨d,eq⟩
  · rintro (rfl | ⟨d,rfl⟩)
    · exact ⟨0,(after_exceptional 0 1).mpr (Or.inl rfl)⟩
    · obtain ⟨m,h⟩ := every_deficit d
      exact ⟨m,(after_exceptional m _).mpr (Or.inr ⟨d,h,rfl⟩)⟩

/-- Beyond the first limit, synchronizing just the last key suffices. -/
theorem synchronized {x q : ℚ} (h : Opens SecondLimit x q) :
    ∃ m, Opens (After m) x q := by
  have at_stage (m : ℕ) (last : Admits x 1 → After m 1 q) : Opens (After m) x q := by
    intro k ha
    rcases lt_or_eq_of_le ha.1.2 with small | rfl
    · obtain ⟨n,hn⟩ := h k ha
      exact (after_ordinary m ha.1 small).mpr ((after_ordinary n ha.1 small).mp hn)
    · exact last ha
  by_cases last : Admits x 1
  · obtain ⟨m,hm⟩ := h 1 last
    exact ⟨m,at_stage m (fun _ => hm)⟩
  · exact ⟨0,at_stage 0 (fun ha => (last ha).elim)⟩

theorem second_fixed (k r : ℚ) : Step SecondLimit k r ↔ SecondLimit k r := by
  constructor
  · rintro (base | ⟨x,q,hx,ha,hq,eq⟩)
    · exact ⟨0,0,base⟩
    · obtain ⟨m,common⟩ := synchronized hq
      exact ⟨m+1,Or.inr ⟨x,q,hx,ha,common,eq⟩⟩
  · rintro ⟨m,hm⟩
    exact step_mono (fun _ _ h => ⟨m,h⟩) k r (after_increases m k r hm)

theorem second_least {R} (p : Producers R) {k r : ℚ} (h : SecondLimit k r) : R k r := by
  obtain ⟨m,hm⟩ := h
  induction m generalizing k r with
  | zero => obtain ⟨n,hn⟩ := hm; exact finite_included p n k r hn
  | succ m ih => exact includes_step p k r (step_mono (fun i q h => ih h) k r hm)

end Iteration

section ClosedGraph

def ClosedGraph (R : ℚ → ℚ → Prop) := IsClosed {z : ℚ × ℚ | R z.1 z.2}

theorem closed_endpoint {R} (closed : ClosedGraph R) (r : ℚ)
    (ordinary : ∀ k, 0 ≤ k → k < 1 → R k r) : R 1 r := by
  have slice : IsClosed {k : ℚ | R k r} :=
    closed.preimage (continuous_id.prodMk (continuous_const (y:=r)))
  have sub : Set.Ico (0:ℚ) 1 ⊆ {k | R k r} := fun _ hk => ordinary _ hk.1 hk.2
  have incl := closure_minimal sub slice
  rw [closure_Ico (by norm_num : (0:ℚ)≠1)] at incl
  exact incl (show (1:ℚ) ∈ Set.Icc 0 1 from ⟨by norm_num,le_rfl⟩)

theorem closedCap_closed : ClosedGraph ClosedCap := by
  have cap : IsClosed {z : ℚ × ℚ | z.2 ≤ 1-z.1} :=
    isClosed_le continuous_snd (continuous_const.sub continuous_fst)
  have key : IsClosed {z : ℚ × ℚ | z.1=1} := isClosed_eq continuous_fst continuous_const
  have value : IsClosed {z : ℚ × ℚ | z.2=1} := isClosed_eq continuous_snd continuous_const
  exact cap.union (key.inter value)

theorem closedCap_least_graph {R} (producer : Producers R) (closed : ClosedGraph R)
    {k r : ℚ} (hk : Legal k) : ClosedCap k r → R k r :=
  least_closed producer (closed_endpoint closed) hk

def TriangleOpens (R : ℚ → ℚ → Prop) (x r : ℚ) := ∀ k, Legal k → x+k≤1 → R k r

structure TriangleProducers (R : ℚ → ℚ → Prop) : Prop where
  base : ∀ x, Legal x → TriangleOpens R x x
  next : ∀ x r, Legal x → TriangleOpens R x r → TriangleOpens R x (2*r-x)

def TriangleLimit (k r : ℚ) := r≤1-k ∧ (k=1 → r=0)

theorem triangle_limit_valid : TriangleProducers TriangleLimit where
  base x hx k _ ha := ⟨by linarith,fun top => by linarith [hx.1]⟩
  next x r hx h k hk ha := by
    have bound := (h (1-x) ⟨by linarith [hx.2],by linarith [hx.1]⟩ (by linarith)).1
    refine ⟨by linarith, ?_⟩
    intro top
    have zero := (h k hk ha).2 top
    linarith [hx.1]

theorem triangle_limit_lower {r : ℚ} (h : TriangleOpens TriangleLimit 0 r) : 0≤r := by
  have zero := (h 1 ⟨by norm_num,le_rfl⟩ (by norm_num)).2 rfl
  linarith

theorem triangle_forced {R} (p : TriangleProducers R) (x : ℚ) (hx : Legal x) (n : ℕ) :
    TriangleOpens R x (-((2:ℚ)^n-1)*x) := by
  induction n with
  | zero =>
    intro k hk _
    simpa using p.base 0 ⟨le_rfl,by norm_num⟩ k hk (by linarith [hk.2])
  | succ n ih =>
    convert p.next x _ hx ih using 1
    rw [pow_succ]
    ring

theorem triangle_closed_impossible {R} (p : TriangleProducers R) (closed : ClosedGraph R) :
    TriangleOpens R 0 (-1) := by
  have ordinary (k : ℚ) (hk : 0≤k) (small : k<1) : R k (-1) :=
    ordinary_of_forced (triangle_forced p) hk small (by norm_num)
  intro k hk _
  rcases lt_or_eq_of_le hk.2 with small | rfl
  · exact ordinary k hk.1 small
  · exact closed_endpoint closed (-1) ordinary

end ClosedGraph

end AllKeys
