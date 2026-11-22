import Std

namespace GuardContracts

/-- s records a retained valuation, including its designated parameters.
    w describes local observations made on one returning evaluation. -/
def Covers (enters : S → Prop) (obs : S → W → Prop) :=
  ∀ s, enters s → ∃ w, obs s w

theorem combine (left : S → A → Prop) (right : S → A → B → Prop)
    (first : Covers enters left)
    (next : ∀ s a, enters s → left s a → ∃ b, right s a b) :
    Covers enters (fun s (w : A × B) => left s w.1 ∧ right s w.1 w.2) := by
  intro s hs
  obtain ⟨a, ha⟩ := first s hs
  obtain ⟨b, hb⟩ := next s a hs ha
  exact ⟨(a,b), ha, hb⟩

theorem exclude {enters : S → Prop} {obs : S → W → Prop} (covered : Covers enters obs) (takes : S → Prop)
    (impossible : ∀ s w, obs s w → takes s → False) :
    ∀ s, enters s → ¬takes s := by
  intro s he ht
  obtain ⟨w, hw⟩ := covered s he
  exact impossible s w hw ht

/-- Exact projection makes the satisfiability test necessary as well. -/
theorem exact_image (enters takes : S → Prop) (obs : S → W → Prop)
    (exactly : ∀ s, enters s ↔ ∃ w, obs s w) :
    (∀ s, enters s → ¬takes s) ↔ ¬∃ s w, obs s w ∧ takes s := by
  constructor
  · rintro h ⟨s, w, hw, ht⟩
    exact h s ((exactly s).mpr ⟨w, hw⟩) ht
  · intro h
    exact exclude (fun s he => (exactly s).mp he) takes (fun s w hw ht => h ⟨s,w,hw,ht⟩)

/-- The ordinary branch of let elimination specializes its universally
    bound local type at the actual RHS, keeping every outer witness fixed. -/
theorem plain_open (rhs : T) (result : R) (k : T → R → Prop) :
    (∀ bound, bound = rhs → k bound result) ↔ k rhs result := by
  constructor
  · exact fun h => h rhs rfl
  · intro h b eq
    simpa [eq] using h

theorem inside_open (i j : Int) (pattern : i ≤ 0) (payload : j ≤ i) : ¬1 ≤ j := by omega

theorem escaping_singleton (i : Int) : ¬∃ r : Int, ∀ j ≤ i, r = j := by
  rintro ⟨r, h⟩
  have := h i (by omega)
  have := h (i-1) (by omega)
  omega

example (i : Int) : ∀ j ≤ i, ∃ r : Int, r = j := fun j _ => ⟨j,rfl⟩

/-- Two calls have independent witnesses unless an observation equates them. -/
example : (∃ a b : Int, a = 0 ∧ b = 1 ∧ a ≤ b) ∧
    ¬(∃ a : Int, a = 0 ∧ a = 1 ∧ a ≤ a) := by
  exact ⟨⟨0,1,rfl,rfl,by decide⟩, by rintro ⟨_, h, h', _⟩; omega⟩

/-- A closed query can succeed for every possible body by using a strategy
    that always avoids the guard. Preserving every legal strategy is stronger. -/
theorem some_strategy (legal : S → Prop) (play : S → V → Prop) (guard : V → Prop)
    :
    (∀ body : V → Prop, ∃ s, legal s ∧ ∀ v, play s v → guard v → body v) ↔
      ∃ s, legal s ∧ ∀ v, play s v → ¬guard v := by
  constructor
  · intro all
    exact all (fun _ => False)
  · rintro ⟨s, hl, h⟩ body
    exact ⟨s, hl, fun v hp hg => (h v hp hg).elim⟩

theorem every_strategy (legal : S → Prop) (play : S → V → Prop) (guard : V → Prop) :
    (∀ (s : S) (body : V → Prop), legal s → ∀ v, play s v → guard v → body v) ↔
      ∀ s, legal s → ∀ v, play s v → ¬guard v := by
  constructor
  · exact fun h s => h s (fun _ => False)
  · exact fun h s _ hl v hp hg => (h s hl v hp hg).elim

example : (∃ s : Bool, ∀ v, v = s → v ≠ true) ∧
    ¬(∀ s : Bool, ∀ v, v = s → v ≠ true) := by
  exact ⟨⟨false, by simp⟩, fun h => h true true rfl rfl⟩

/-- A local recursive definition checks its body at every admitted instance.
    Its mandatory first-order observations can be specialized at a call.
    'c' is captured at definition time. The local witnesses are per use. -/
theorem necessary_at_call (admit : C → T → Prop) (body projection : C → T → W → Prop)
    (definition : ∀ c t, admit c t → ∃ w, body c t w)
    (extract : ∀ c t w, body c t w → projection c t w)
    (use : admit c t) : ∃ w, projection c t w := by
  obtain ⟨w, hw⟩ := definition c t use
  exact ⟨w, extract c t w hw⟩

theorem ordinary_helper (admit : Int → Int → Prop)
    (fromBody : ∀ i r, admit i r → ∃ k, i = k ∧ r = k)
    (call : admit i r) (bound : i ≤ 0) : ¬1 ≤ r := by
  obtain ⟨_, hi, hr⟩ := fromBody i r call
  omega

def supplier (R : Int → Int → Prop) :=
  (∀ i, R i i) ∧ (∀ i r, R i r → R i r)

def safeUse (R : Int → Int → Prop) :=
  ∀ i r, i ≤ 0 → R i r → ¬1 ≤ r

theorem packed_certificate :
    (supplier (fun i r => r = i) ∧ safeUse (fun i r => r = i)) ∧
    (supplier (fun _ _ => True) ∧ ¬safeUse (fun _ _ => True)) := by
  refine ⟨⟨⟨fun _ => rfl, fun _ _ h => h⟩, ?_⟩,
          ⟨⟨fun _ => trivial, fun _ _ h => h⟩, ?_⟩⟩
  · intro i r hi eq
    omega
  · intro all
    exact all 0 1 (by decide) trivial (by decide)

inductive IndexSort where | num | ord
deriving DecidableEq

inductive Tree where
  | variable (v : Nat)
  | head (name : Nat)
  | app (f a : Tree)
  | arrow (a b : Tree)
  | index (sort : IndexSort) (wrapped : Bool) (payload : Nat)
deriving DecidableEq

def shape : Tree → Tree
  | .variable v => .variable v
  | .head n => .head n
  | .app f a => .app (shape f) (shape a)
  | .arrow a b => .arrow (shape a) (shape b)
  | .index s _ _ => .index s false 0

def rewriteIndices (change : IndexSort → Bool → Nat → Bool × Nat) : Tree → Tree
  | .variable v => .variable v
  | .head n => .head n
  | .app f a => .app (rewriteIndices change f) (rewriteIndices change a)
  | .arrow a b => .arrow (rewriteIndices change a) (rewriteIndices change b)
  | .index s b n => .index s (change s b n).1 (change s b n).2

theorem discard_survives (t : Tree) (change : IndexSort → Bool → Nat → Bool × Nat) :
    shape (rewriteIndices change t) = shape t := by
  induction t <;> simp_all [shape, rewriteIndices]

example : shape (.index .num true 1) ≠ shape (.index .ord false 1) := by decide

theorem duplicate_cut (rejects : Cut → Proposal → Prop) (history : List Cut)
    (seen : cut ∈ history) (p : Proposal) :
    (∃ c ∈ cut :: history, rejects c p) ↔ ∃ c ∈ history, rejects c p := by
  constructor
  · rintro ⟨c, h, hm⟩
    rcases List.mem_cons.mp h with h | h
    · exact ⟨cut, seen, h ▸ hm⟩
    · exact ⟨c, h, hm⟩
  · rintro ⟨c, h, hm⟩
    exact ⟨c, List.mem_cons_of_mem cut h, hm⟩

/-- For previously accepted exports, exactly the previously accepted
    client instantiations must be included to preserve all one-call clients. -/
theorem client_preservation (old new : T → Prop) :
    (∀ client : T → Prop, (∀ t, client t → old t) → ∀ t, client t → new t) ↔
      ∀ t, old t → new t := by
  constructor
  · exact fun h => h old (fun _ ht => ht)
  · exact fun h _ hc t ht => h t (hc t ht)

inductive Cell (H : Type) where
  | fixed (b : Bool) | hole (name : H)

def value (s : H → Bool) : Cell H → Bool
  | .fixed b => b
  | .hole h => s h

def marked [DecidableEq I] (i k : I) : Bool := decide (k = i)

def serves [DecidableEq I] (input : I → Cell H) (output : Cell H) (i : I) : Prop :=
  (∃ s, (∀ k, value s (input k) = marked i k) ∧ value s output = true) ∧
  (∀ s, (∀ k, value s (input k) = marked i k) → value s output = true)

/-- A sound pattern can type the marked client at most at one axis.
    'base' is the actual all-Marker return, required by the supplier. -/
theorem unique_axis [DecidableEq I] [DecidableEq H] (input : I → Cell H)
    (output : Cell H) (base : H → Bool) (baseRet : value base output = false)
    (hi : serves input output i) (hj : serves input output j) : i = j := by
  apply Classical.byContradiction
  intro ne
  obtain ⟨⟨si, ri, oi⟩, ci⟩ := hi
  obtain ⟨⟨sj, rj, oj⟩, _⟩ := hj
  cases output with
  | fixed b => simp [value] at baseRet oi; simp_all
  | hole h =>
    let bad := fun k => if k = h then false else si k
    have same : ∀ k, value bad (input k) = marked i k := by
      intro k
      specialize ri k
      specialize rj k
      cases e : input k with
      | fixed b => simpa [e, value] using ri
      | hole l =>
        have diff : l ≠ h := by
          intro eq
          subst l
          simp [e, value, marked] at ri rj
          simp [value] at oi oj
          simp [oi] at ri
          simp [oj] at rj
          exact ne (ri.symm.trans rj)
        simpa [e, value, bad, diff] using ri
    have last := ci bad same
    simp [value, bad] at last

theorem all_marker_input [DecidableEq I] (input : I → Cell H) (i j : I) (ne : i ≠ j)
    (si sj : H → Bool) (hi : ∀ k, value si (input k) = marked i k)
    (hj : ∀ k, value sj (input k) = marked j k) :
    ∀ k, value (fun _ => false) (input k) = false := by
  intro k
  specialize hi k
  specialize hj k
  cases e : input k with
  | hole => rfl
  | fixed b =>
    cases b with
    | false => rfl
    | true =>
      simp [e, value, marked] at hi hj
      exact (ne (hi.symm.trans hj)).elim

/-- Storing an interface per supported axis is necessary even if schemes
    have arbitrary size. This injection applies to any number of axes. -/
theorem distinct_exports (supports : E → I → Prop)
    (exclusive : ∀ e a b, supports e a → supports e b → a = b)
    (pick : I → E) (covers : ∀ i, supports (pick i) i) :
    ∀ a b, pick a = pick b → a = b := by
  intro a b eq
  exact exclusive (pick b) a b (eq ▸ covers a) (covers b)

/-- One interface per axis attains the bound for the marked calls. -/
theorem pinned_serves [DecidableEq I] (i : I) :
    serves (fun k => if k = i then Cell.hole () else .fixed false) (.hole ()) i := by
  constructor
  · refine ⟨fun _ => true, ?_, rfl⟩
    intro k
    by_cases eq : k = i <;> simp [eq, marked, value]
  · intro s rows
    simpa [marked, value] using rows i

end GuardContracts
