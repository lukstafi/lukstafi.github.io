import Mathlib.Data.Finset.Union
import Mathlib.Data.Finset.Lattice.Fold
import Mathlib.Data.Fintype.Basic
import Mathlib.Tactic.Ring

namespace MenuCover

variable {X K V : Type*}

abbrev Rel (α β : Type*) := α → β → Prop
abbrev Rules (X V : Type*) := X → V → List (X × V) → Prop
abbrev Body (s : Rel X V) (calls : List (X × V)) := ∀ q ∈ calls, s q.1 q.2

def Open (a : Rel X K) (p : Rel K V) (x : X) (r : V) := ∀ k, a x k → p k r
def Supplier (rules : Rules X V) (a : Rel X K) (p : Rel K V) :=
  ∀ x r calls, rules x r calls → Body (Open a p) calls → Open a p x r
def Covers (a : Rel X K) (x : X) (sources : Finset X) :=
  ∀ k, a x k → ∃ y ∈ sources, a y k

/-- A proof uses only the indicated inclusions between menus, with no key names. -/
inductive Derives (rules : Rules X V) (cover : X → Finset X → Prop) : X → V → Prop where
  | step (x : X) (r : V) (sources : Finset X) (calls : X → List (X × V))
      (included : cover x sources)
      (legal : ∀ y ∈ sources, rules y r (calls y))
      (children : ∀ y ∈ sources, ∀ q ∈ calls y, Derives rules cover q.1 q.2) :
      Derives rules cover x r

theorem sound {rules : Rules X V} {a : Rel X K} {p : Rel K V}
    (valid : Supplier rules a p) {x r} (h : Derives rules (Covers a) x r) : Open a p x r := by
  induction h with
  | step x r src calls inc legal _ ih =>
    intro k admitted
    obtain ⟨y, hy, supplies⟩ := inc k admitted
    exact valid y r (calls y) (legal y hy) (ih y hy) k supplies

def FiniteSubcover (a : Rel X K) :=
  ∀ (x : X) (used : X → Prop), (∀ k, a x k → ∃ y, used y ∧ a y k) →
    ∃ src : Finset X, (∀ y ∈ src, used y) ∧ Covers a x src

theorem finite_inputs [Fintype X] (a : Rel X K) : FiniteSubcover a := by
  classical
  intro x used covers
  refine ⟨Finset.univ.filter used, fun y hy => (Finset.mem_filter.mp hy).2, ?_⟩
  intro k hk
  obtain ⟨y, usedY, hy⟩ := covers k hk
  exact ⟨y, by simp [usedY], hy⟩

theorem finite_menus {a : Rel X K}
    (finite : ∀ x, ∃ keys : Finset K, ∀ k, a x k ↔ k ∈ keys) : FiniteSubcover a := by
  classical
  intro x used covers
  obtain ⟨keys, atInput⟩ := finite x
  let source (k : K) := if h : a x k then Classical.choose (covers k h) else x
  have spec k (h : a x k) : used (source k) ∧ a (source k) k := by
    simpa [source, h] using Classical.choose_spec (covers k h)
  refine ⟨keys.image source, ?_, ?_⟩
  · intro y hy
    obtain ⟨k, hk, rfl⟩ := Finset.mem_image.mp hy
    exact (spec k ((atInput k).mpr hk)).1
  · intro k hk
    exact ⟨source k, Finset.mem_image_of_mem _ ((atInput k).mp hk), (spec k hk).2⟩

theorem finite_menu_shapes {a : Rel X K} (reps : Finset X)
    (rep : ∀ x, ∃ y ∈ reps, a x = a y) : FiniteSubcover a := by
  classical
  intro x used cover
  let has := fun y => ∃ z, used z ∧ a z = a y
  let source (y : X) := if h : has y then Classical.choose h else x
  have spec y (h : has y) : used (source y) ∧ a (source y) = a y := by
    simpa [source, h] using Classical.choose_spec h
  refine ⟨(reps.filter has).image source, ?_, ?_⟩
  · intro z hz
    obtain ⟨y, hy, rfl⟩ := Finset.mem_image.mp hz
    exact (spec y (Finset.mem_filter.mp hy).2).1
  · intro k hk
    obtain ⟨z, hz, adm⟩ := cover k hk
    obtain ⟨y, hy, equal⟩ := rep z
    have h : has y := ⟨z, hz, equal⟩
    exact ⟨source y, Finset.mem_image_of_mem _ (Finset.mem_filter.mpr ⟨hy, h⟩),
      ((spec y h).2.trans equal.symm).symm ▸ adm⟩

def Produced (rules : Rules X V) (s : Rel X V) (x : X) (r : V) :=
  ∃ calls, rules x r calls ∧ Body s calls

def Package (rules : Rules X V) (a : Rel X K) (k : K) (r : V) :=
  ∃ y, Produced rules (Derives rules (Covers a)) y r ∧ a y k

theorem open_package {rules : Rules X V} {a : Rel X K} (finiteCover : FiniteSubcover a) (x r) :
    Open a (Package rules a) x r ↔ Derives rules (Covers a) x r := by
  classical
  constructor
  · intro opened
    obtain ⟨src, justified, included⟩ := finiteCover x
      (fun y => Produced rules (Derives rules (Covers a)) y r) opened
    let calls (y : X) := if hy : y ∈ src then Classical.choose (justified y hy) else []
    have chosen (y : X) (hy : y ∈ src) :
        rules y r (calls y) ∧ Body (Derives rules (Covers a)) (calls y) := by
      simpa [calls, hy] using Classical.choose_spec (justified y hy)
    exact .step x r src calls included (fun y hy => (chosen y hy).1) (fun y hy => (chosen y hy).2)
  · intro tree k hk
    cases tree with
    | step _ _ src calls inc legal children =>
      obtain ⟨y, hy, adm⟩ := inc k hk
      exact ⟨y, ⟨calls y, legal y hy, children y hy⟩, adm⟩

theorem least_package {rules : Rules X V} {a : Rel X K} (finiteCover : FiniteSubcover a) :
    Supplier rules a (Package rules a) ∧
    ∀ p, Supplier rules a p → ∀ k r, Package rules a k r → p k r := by
  constructor
  · intro x r calls rule body k hk
    exact ⟨x, ⟨calls, rule, fun q hq => (open_package finiteCover _ _).mp (body q hq)⟩, hk⟩
  · rintro p valid k r ⟨x, ⟨calls, rule, body⟩, hx⟩
    exact valid x r calls rule (fun q hq => sound valid (body q hq)) k hx

theorem safe_scheme {rules : Rules X V} {a : Rel X K} (finiteCover : FiniteSubcover a)
    (bad : Rel X V) :
    (∃ p, Supplier rules a p ∧ ∀ x r, bad x r → ¬ Open a p x r) ↔
      ∀ x r, bad x r → ¬ Derives rules (Covers a) x r := by
  constructor
  · rintro ⟨p, valid, safe⟩ x r hit tree
    exact safe x r hit (sound valid tree)
  · intro safe
    exact ⟨Package rules a, (least_package finiteCover).1,
      fun x r hit opened => safe x r hit ((open_package finiteCover x r).mp opened)⟩

def Round (rules : Rules X V) (a : Rel X K) : Nat → Rel K V
  | 0 => fun _ _ => False
  | n+1 => fun k r => ∃ x, Produced rules (Open a (Round rules a n)) x r ∧ a x k

private theorem next {rules : Rules X V} {a : Rel X K} :
    ∀ n k r, Round rules a n k r → Round rules a (n+1) k r := by
  intro n
  induction n with
  | zero => exact fun _ _ h => False.elim h
  | succ _ ih =>
    rintro k r ⟨x, ⟨calls, rule, body⟩, hx⟩
    exact ⟨x, ⟨calls, rule, fun q hq j hj => ih j q.2 (body q hq j hj)⟩, hx⟩

private theorem later {rules : Rules X V} {a : Rel X K} {n m : Nat} (h : n ≤ m)
    {x r} (atN : Open a (Round rules a n) x r) : Open a (Round rules a m) x r := by
  induction h with
  | refl => exact atN
  | step _ ih => exact fun k hk => next _ k r (ih k hk)

private theorem common_stage {α : Type*} (s : Finset α) (p : α → Nat → Prop)
    (mono : ∀ i {n m}, n ≤ m → p i n → p i m) (each : ∀ i ∈ s, ∃ n, p i n) :
    ∃ n, ∀ i ∈ s, p i n := by
  classical
  let stage i := if h : i ∈ s then Classical.choose (each i h) else 0
  refine ⟨s.sup stage, fun i hi => mono i (Finset.le_sup hi) ?_⟩
  simpa [stage, hi] using Classical.choose_spec (each i hi)

theorem proof_height {rules : Rules X V} {a : Rel X K} {x r}
    (tree : Derives rules (Covers a) x r) : ∃ n, Open a (Round rules a n) x r := by
  classical
  induction tree with
  | step x r src calls inc legal _ ih =>
    let p := fun (q : X × V) n => Open a (Round rules a n) q.1 q.2
    have perSource y (hy : y ∈ src) := common_stage (calls y).toFinset p
      (fun _ {_ _} h => later h) (fun q hq => ih y hy q (List.mem_toFinset.mp hq))
    obtain ⟨n, opened⟩ := common_stage src
      (fun y n => ∀ q ∈ (calls y).toFinset, p q n)
      (fun _ {_ _} h old q hq => later h (old q hq)) perSource
    refine ⟨n+1, ?_⟩
    intro k hk
    obtain ⟨y, hy, adm⟩ := inc k hk
    exact ⟨y, ⟨calls y, legal y hy, fun q hq => opened y hy q (List.mem_toFinset.mpr hq)⟩, adm⟩

theorem at_omega {rules : Rules X V} {a : Rel X K} (finiteCover : FiniteSubcover a) (k r) :
    Package rules a k r ↔ ∃ n, Round rules a n k r := by
  constructor
  · rintro ⟨x, produced, atX⟩
    have opened : Open a (Package rules a) x r := fun _ h => ⟨x, produced, h⟩
    obtain ⟨n, obs⟩ := proof_height ((open_package finiteCover x r).mp opened)
    exact ⟨n, obs k atX⟩
  · rintro ⟨n, member⟩
    induction n generalizing k r with
    | zero => exact False.elim member
    | succ _ ih =>
      obtain ⟨x, ⟨calls, rule, body⟩, adm⟩ := member
      exact (least_package finiteCover).1 x r calls rule (fun q hq j hj => ih j q.2 (body q hq j hj)) k adm

/-- Even base-only programs can detect a missing finite subcover. -/
theorem uniform_completeness (a : Rel X K) :
    FiniteSubcover a ↔ ∀ (rules : Rules X Unit) x,
      (∀ p, Supplier rules a p → Open a p x ()) → Derives rules (Covers a) x () := by
  constructor
  · intro finiteCover rules x forced
    exact (open_package finiteCover x ()).mp
      (forced (Package rules a) (least_package finiteCover).1)
  · intro complete x used includes
    let rules : Rules X Unit := fun y _ calls => used y ∧ calls = []
    have forced (p : Rel K Unit) (valid : Supplier rules a p) : Open a p x () := by
      intro k hk
      obtain ⟨y, produced, adm⟩ := includes k hk
      exact valid y () [] ⟨produced, rfl⟩ (by simp [Body]) k adm
    cases complete rules x forced with
    | step _ _ src _ inc legal _ => exact ⟨src, fun y hy => (legal y hy).1, inc⟩

/-- A fresh key available at just one input can only break old covers. -/
def Split (a : Rel X K) (atInput : X) (y : X) : Option K → Prop
  | none => y = atInput
  | some k => a y k

theorem split_cover {a : Rel X K} {isolated y : X} {src : Finset X} :
    Covers (Split a isolated) y src ↔ Covers a y src ∧ (y = isolated → isolated ∈ src) := by
  constructor
  · intro h
    refine ⟨fun k hk => h (some k) hk, ?_⟩
    rintro rfl
    obtain ⟨z, hz, eq⟩ := h none rfl
    exact (eq : z = y) ▸ hz
  · rintro ⟨old, member⟩ k hk
    cases k with
    | some k => exact old k hk
    | none => exact ⟨isolated, member hk, rfl⟩

/-- Collect finitely many supports while preserving an arbitrary common test. -/
private theorem gather {α β : Type*} (items : Finset α) (pass : β → Prop)
    (claim : α → (β → Prop) → Prop)
    (each : ∀ i ∈ items, ∃ s : Finset β, (∀ c ∈ s, pass c) ∧
      ∀ test, (∀ c ∈ s, test c) → claim i test) :
    ∃ s : Finset β, (∀ c ∈ s, pass c) ∧ ∀ test, (∀ c ∈ s, test c) → ∀ i ∈ items, claim i test := by
  classical
  let parts (i : α) := if h : i ∈ items then Classical.choose (each i h) else ∅
  have spec i (hi : i ∈ items) : (∀ c ∈ parts i, pass c) ∧
      ∀ test, (∀ c ∈ parts i, test c) → claim i test := by
    simpa [parts, hi] using Classical.choose_spec (each i hi)
  refine ⟨items.biUnion parts, ?_, ?_⟩
  · intro c hc
    obtain ⟨i, hi, member⟩ := Finset.mem_biUnion.mp hc
    exact (spec i hi).1 c member
  · intro test checked i hi
    exact (spec i hi).2 test (fun c hc => checked c (Finset.mem_biUnion.mpr ⟨i, hi, hc⟩))

/-- Every failed proof yields one finite condition reusable at every other policy. -/
theorem finite_support {rules : Rules X V} {cover : X → Finset X → Prop} {x r}
    (tree : Derives rules cover x r) :
    ∃ s : Finset (X × Finset X), (∀ c ∈ s, cover c.1 c.2) ∧
      ∀ (test : X × Finset X → Prop), (∀ c ∈ s, test c) →
        Derives rules (fun y src => test (y, src)) x r := by
  classical
  induction tree with
  | step x r src calls inc legal _ ih =>
    let pass := fun c : X × Finset X => cover c.1 c.2
    let child := fun (q : X × V) (test : X × Finset X → Prop) =>
      Derives rules (fun y set => test (y, set)) q.1 q.2
    have perSource (y : X) (hy : y ∈ src) :=
      gather (calls y).toFinset pass child (fun q hq => ih y hy q (List.mem_toFinset.mp hq))
    obtain ⟨support, checked, replay⟩ := gather src pass
      (fun y test => ∀ q ∈ (calls y).toFinset, child q test) perSource
    refine ⟨insert (x,src) support, ?_, ?_⟩
    · intro c hc
      rcases Finset.mem_insert.mp hc with rfl | member
      · exact inc
      · exact checked c member
    · intro test holds
      exact .step x r src calls (holds _ (Finset.mem_insert_self ..)) legal
        (fun y hy q hq => replay test (fun c hc => holds c (Finset.mem_insert_of_mem hc))
          y hy q (List.mem_toFinset.mpr hq))

/-- Extend a base policy with a chosen family of supports on fresh key labels. -/
def Extend {J : Type*} (a : Rel X K) (column : J → X → Prop) (pick : J → Prop) :
    Rel X (Sum K J)
  | x, .inl k => a x k
  | x, .inr j => pick j ∧ column j x

theorem finite_extension {J : Type*} {a : Rel X K} (finiteCover : FiniteSubcover a)
    {column : J → X → Prop} {pick : J → Prop} (labels : Finset J) (listed : ∀ j, pick j → j ∈ labels) :
    FiniteSubcover (Extend a column pick) := by
  classical
  intro x used covers
  obtain ⟨old, justified, base⟩ := finiteCover x used (fun k hk => covers (.inl k) hk)
  let active (j : J) := pick j ∧ column j x
  let source j := if h : active j then Classical.choose (covers (.inr j) h) else x
  have spec j (h : active j) : used (source j) ∧ Extend a column pick (source j) (.inr j) := by
    simpa [source, h] using Classical.choose_spec (covers (.inr j) h)
  refine ⟨old ∪ (labels.filter active).image source, ?_, ?_⟩
  · intro y hy
    rcases Finset.mem_union.mp hy with member | added
    · exact justified y member
    · obtain ⟨j, hj, rfl⟩ := Finset.mem_image.mp added
      exact (spec j (Finset.mem_filter.mp hj).2).1
  · intro key hk
    cases key with
    | inl k =>
      obtain ⟨y, hy, adm⟩ := base k hk
      exact ⟨y, Finset.mem_union_left _ hy, adm⟩
    | inr j =>
      have member : j ∈ labels.filter active := Finset.mem_filter.mpr ⟨listed j hk.1, hk⟩
      exact ⟨source j, Finset.mem_union_right _ (Finset.mem_image_of_mem _ member), (spec j hk).2⟩

/-- Existing solutions survive arbitrary extra support columns. Give new keys
the full result section and the opening stays exactly the same. -/
def Neutral {J : Type*} (old : J → Prop) (p : Rel (Sum K J) V) : Rel (Sum K J) V
  | .inl k, r => p (.inl k) r
  | .inr j, r => old j → p (.inr j) r

theorem neutral_open {J : Type*} {a : Rel X K} {column : J → X → Prop}
    {old more : J → Prop} (add : ∀ j, old j → more j) (p : Rel (Sum K J) V) (x r) :
    Open (Extend a column old) p x r ↔ Open (Extend a column more) (Neutral old p) x r := by
  constructor
  · intro h key admitted
    cases key with
    | inl k => exact h (.inl k) admitted
    | inr j => exact fun wasUsed => h (.inr j) ⟨wasUsed, admitted.2⟩
  · intro h key admitted
    cases key with
    | inl k => exact h (.inl k) admitted
    | inr j => exact h (.inr j) ⟨add j admitted.1, admitted.2⟩ admitted.1

def Separates {J : Type*} (column : J → X → Prop) (j : J) (c : X × Finset X) :=
  column j c.1 ∧ ∀ y ∈ c.2, ¬ column j y

theorem extend_cover {J : Type*} {a : Rel X K} {column : J → X → Prop} {pick : J → Prop}
    (c : X × Finset X) : Covers (Extend a column pick) c.1 c.2 ↔
      Covers a c.1 c.2 ∧ ∀ j, pick j → ¬ Separates column j c := by
  classical
  constructor
  · intro incl
    refine ⟨fun k hk => incl (.inl k) hk, ?_⟩
    rintro j chosen ⟨atTarget, missing⟩
    obtain ⟨y, hy, _, atSource⟩ := incl (.inr j) ⟨chosen, atTarget⟩
    exact missing y hy atSource
  · rintro ⟨base, prevents⟩ key admitted
    cases key with
    | inl k => exact base k admitted
    | inr j =>
      obtain ⟨chosen, atTarget⟩ := admitted
      apply Classical.byContradiction
      intro none
      exact prevents j chosen ⟨atTarget, fun y hy atSource => none ⟨y, hy, chosen, atSource⟩⟩

/-- Every safe target selection contains a fresh separator of this failure.
Soundness needs no finiteness assumption on the target's keys or sections. -/
theorem learn_cut {J : Type*} {rules : Rules X V} {a : Rel X K} {column : J → X → Prop}
    {selected : J → Prop} {x r}
    (failure : Derives rules (Covers (Extend a column selected)) x r) :
    ∃ trace : Finset (X × Finset X),
      (∀ c ∈ trace, Covers (Extend a column selected) c.1 c.2) ∧
      ∀ (target : J → Prop) (p : Rel (Sum K J) V), Supplier rules (Extend a column target) p →
        ¬ Open (Extend a column target) p x r →
        ∃ j, target j ∧ ¬ selected j ∧ ∃ c ∈ trace, Separates column j c := by
  classical
  obtain ⟨trace, holds, replay⟩ := finite_support failure
  refine ⟨trace, holds, ?_⟩
  intro target p valid safe
  apply Classical.byContradiction
  intro noSeparator
  apply safe
  apply sound valid
  apply replay (fun c => Covers (Extend a column target) c.1 c.2)
  intro c hc
  obtain ⟨base, current⟩ := (extend_cover c).mp (holds c hc)
  refine (extend_cover c).mpr ⟨base, ?_⟩
  intro j chosen separates
  exact noSeparator ⟨j, chosen, fun old => current j old separates, c, hc, separates⟩

/-- A successful branch of the search. The step relation can be computed from
any one of the failure proofs returned by the checker at this selection. -/
inductive RepairPath {J : Type*} [DecidableEq J]
    (success : Finset J → Prop) (step : Finset J → J → Prop) : Finset J → Nat → Prop where
  | done {s} : success s → RepairPath success step s 0
  | add {s j n} : ¬ success s → step s j → RepairPath success step (insert j s) n →
      RepairPath success step s (n+1)

/-- learn_cut supplies progress for every safe target, even if the checker
chooses a different failure proof on different selections. -/
theorem bounded_refinement {J : Type*} [DecidableEq J] {success : Finset J → Prop}
    {step : Finset J → J → Prop} {target : Finset J}
    (advance : ∀ s ⊆ target, ¬ success s → ∃ j ∈ target, j ∉ s ∧ step s j)
    (s : Finset J) (within : s ⊆ target) :
    ∃ n, n ≤ (target \ s).card ∧ RepairPath success step s n := by
  by_cases good : success s
  · exact ⟨0, Nat.zero_le _, .done good⟩
  · obtain ⟨j, wanted, fresh, moves⟩ := advance s within good
    have keep : insert j s ⊆ target := Finset.insert_subset wanted within
    have fewer : (target \ insert j s).card < (target \ s).card := by
      apply Finset.card_lt_card
      apply Finset.ssubset_iff_subset_ne.mpr
      refine ⟨fun i hi => ?_, ?_⟩
      · obtain ⟨inside, unused⟩ := Finset.mem_sdiff.mp hi
        exact Finset.mem_sdiff.mpr ⟨inside, fun h => unused (Finset.mem_insert_of_mem h)⟩
      · intro eq
        have keepJ := Finset.mem_sdiff.mpr ⟨wanted, fresh⟩
        have badJ : j ∈ target \ insert j s := eq.symm ▸ keepJ
        exact (Finset.mem_sdiff.mp badJ).2 (Finset.mem_insert_self ..)
    obtain ⟨n, length, path⟩ := bounded_refinement advance (insert j s) keep
    exact ⟨n+1, Nat.succ_le_of_lt (lt_of_le_of_lt length fewer), .add good moves path⟩
termination_by (target \ s).card

end MenuCover

namespace NativeColumns

variable {I : Type*}

/-- The other coefficient columns contribute any vector in rest. -/
theorem euclidean_step (u v t : I → ℤ) (q : ℤ) (rest : (I → ℤ) → Prop) :
    (∃ (a b : ℤ) (w : I → ℤ), rest w ∧ ∀ i, t i = a*u i + b*v i + w i) ↔
    (∃ (a b : ℤ) (w : I → ℤ), rest w ∧ ∀ i, t i = a*v i + b*(u i-q*v i) + w i) := by
  constructor
  · rintro ⟨a, b, w, hw, h⟩
    refine ⟨b+a*q, a, w, hw, fun i => ?_⟩
    rw [h i]
    ring
  · rintro ⟨a, b, w, hw, h⟩
    refine ⟨b, a-b*q, w, hw, fun i => ?_⟩
    rw [h i]
    ring

/-- Once the other columns vanish on the pivot row, the target on that
row must be an integer multiple of the pivot. Remove that whole column. -/
theorem pivot_row (u t : I → ℤ) (row : I) (rest : (I → ℤ) → Prop)
    (zero : ∀ w, rest w → w row = 0) :
    (∃ (a : ℤ) (w : I → ℤ), rest w ∧ ∀ i, t i = a*u i + w i) ↔
    ∃ a : ℤ, t row = a*u row ∧ rest (fun i => t i - a*u i) := by
  constructor
  · rintro ⟨a, w, hw, h⟩
    refine ⟨a, by simpa [zero w hw] using h row, ?_⟩
    have eq : (fun i => t i - a*u i) = w := by
      funext i
      rw [h i]
      ring
    exact eq.symm ▸ hw
  · rintro ⟨a, _, hw⟩
    refine ⟨a, _, hw, fun i => ?_⟩
    ring

end NativeColumns
