import Std

namespace MarkedPayload

variable {I H V : Type} [DecidableEq H] {M C : V}

def read (m : V) (env : H → V) : Option H → V
  | none => m
  | some h => env h

/-- A ground marked call exists, and every opening at its input returns C.
    The result hole must also occur at the selected input position. -/
theorem marked_output (different : C ≠ M) (selected result : Option H)
    (rest : I → Option H) (e : H → V)
    (marked : read M e selected = C) (opened : read M e result = C)
    (others : ∀ i, read M e (rest i) = M)
    (client : ∀ f, read M f selected = C →
      (∀ i, read M f (rest i) = M) → read M f result = C) :
    ∃ h, selected = some h ∧ result = some h ∧ ∀ i, rest i ≠ some h := by
  cases selected with
  | none => exact (different marked.symm).elim
  | some j =>
    have absent (h : H) (hc : e h = C) (i : I) : rest i ≠ some h := by
      intro same
      have hm := others i
      rw [same] at hm
      exact different (hc.symm.trans hm)
    cases result with
    | none => exact (different opened.symm).elim
    | some o =>
      by_cases eq : o = j
      · exact ⟨j, rfl, congrArg some eq, absent j marked⟩
      · let f := fun h => if h = o then M else e h
        have hf : ∀ i, read M f (rest i) = M := by
          intro i
          cases hi : rest i with
          | none => rfl
          | some h =>
            have ho : h ≠ o := fun same => absent o opened i (hi.trans (congrArg some same))
            simpa [read, f, ho, hi] using others i
        have bad := client f (by simpa [read, f, Ne.symm eq] using marked) hf
        exact (different (by simpa [read, f] using bad.symm)).elim

/-- If just one unmarked input coordinate may differ from M, it is M too.
    This holds exactly when every free unmarked coordinate shares its hole. -/
theorem off_axis_iff (different : C ≠ M) (rest : I → Option H) :
    (∀ (e : H → V) (i : I), (∀ k, k ≠ i → read M e (rest k) = M) →
        read M e (rest i) = M) ↔
      ∀ i h, rest i = some h → ∃ k, k ≠ i ∧ rest k = some h := by
  constructor
  · intro safe i h hi
    apply Classical.byContradiction
    intro single
    let e := fun v => if v = h then C else M
    have others (k : I) (ne : k ≠ i) : read M e (rest k) = M := by
      cases hk : rest k with
      | none => rfl
      | some v =>
        have different_h : v ≠ h := fun eq => single ⟨k, ne, hk.trans (congrArg some eq)⟩
        simp [read, e, different_h]
    have bad := safe e i others
    exact different (by simpa [read, hi, e] using bad)
  · intro repeats e i others
    cases hi : rest i with
    | none => rfl
    | some h =>
      obtain ⟨k, ne, hk⟩ := repeats i h hi
      simpa [hk] using others k ne

/-- For a caller with a fixed argument in each public context, a guarded
    demand licenses an unconditional test for every candidate precisely
    when the guard has a private witness in each context. -/
theorem demand_coverage {B W : Type} (guard : B → W → Prop) :
    (∀ domain : B → Prop, (∀ b w, guard b w → domain b) → ∀ b, domain b) ↔
    ∀ b, ∃ w, guard b w := by
  constructor
  · intro allDomains
    exact allDomains (fun b => ∃ w, guard b w) (fun _ w h => ⟨w, h⟩)
  · intro covers domain required b
    obtain ⟨w, hw⟩ := covers b
    exact required b w hw

theorem argument_coverage {B W A : Type} (guard : B → W → Prop) (arg : B → A) :
    (∀ domain : A → Prop, (∀ b w, guard b w → domain (arg b)) → ∀ b, domain (arg b)) ↔
    ∀ b, ∃ c w, guard c w ∧ arg c = arg b := by
  constructor
  · intro allDomains
    exact allDomains (fun a => ∃ c w, guard c w ∧ arg c = a)
      (fun b w h => ⟨b, w, h, rfl⟩)
  · intro covers domain required b
    obtain ⟨c, w, hw, eq⟩ := covers b
    exact eq ▸ required c w hw

end MarkedPayload

namespace GraphFeedback

variable {S T : Type}

def lift (tag : S → T) (r : S → Prop) (row : S × T) : Prop :=
  r row.1 ∧ row.2 = tag row.1

def supply {A : Type} (base : A → Prop) (step : A → A → Prop)
    (r : A → Prop) (y : A) : Prop := base y ∨ ∃ x, r x ∧ step x y

/-- Incoming calls lie on the graph. Every outgoing branch produces the tag
    determined by its scalar state. No assumption is needed off the graph. -/
theorem graph_supply (tag : S → T) (base : S → Prop) (step : S → S → Prop)
    (base' : S × T → Prop) (step' : S × T → S × T → Prop)
    (hb : ∀ y t, base' (y,t) ↔ base y ∧ t = tag y)
    (hs : ∀ x y t, step' (x,tag x) (y,t) ↔ step x y ∧ t = tag y)
    (r : S → Prop) (y : S) (t : T) :
    supply base' step' (lift tag r) (y,t) ↔ lift tag (supply base step r) (y,t) := by
  constructor
  · rintro (b | ⟨⟨x, u⟩, ⟨rx, hu⟩, stepX⟩)
    · obtain ⟨by', ht⟩ := (hb y t).mp b
      exact ⟨Or.inl by', ht⟩
    · change u = tag x at hu
      subst u
      obtain ⟨sxy, ht⟩ := (hs x y t).mp stepX
      exact ⟨Or.inr ⟨x, rx, sxy⟩, ht⟩
  · rintro ⟨(b | ⟨x, rx, sxy⟩), ht⟩
    · exact Or.inl ((hb y t).mpr ⟨b, ht⟩)
    · exact Or.inr ⟨(x, tag x), ⟨rx, rfl⟩, (hs x y t).mpr ⟨sxy, ht⟩⟩

theorem graph_use (tag : S → T) (r : S → Prop) (accept : S × T → Prop) :
    (∀ row, lift tag r row → accept row) ↔ ∀ x, r x → accept (x, tag x) := by
  constructor
  · exact fun safe x rx => safe (x, tag x) ⟨rx, rfl⟩
  · rintro safe ⟨x,t⟩ ⟨rx, ht⟩
    change t = tag x at ht
    subst t
    exact safe x rx

def afterPass {A : Type} (next : A → A) (start : A) : Nat → A
  | 0 => start
  | n + 1 => next (afterPass next start n)

/-- S and T may include pending demands, retry information and the pass
    counter. Acceptance on every pass transfers when the whole update does. -/
theorem same_pass (embed : S → T) (next : S → S) (next' : T → T)
    (done_ : S → Prop) (done' : T → Prop)
    (update : ∀ s, next' (embed s) = embed (next s))
    (stop : ∀ s, done' (embed s) ↔ done_ s) (start : S) (n : Nat) :
    done' (afterPass next' (embed start) n) ↔ done_ (afterPass next start n) := by
  have transport (k : Nat) : afterPass next' (embed start) k = embed (afterPass next start k) := by
    induction k with
    | zero => rfl
    | succ k ih => exact (congrArg next' ih).trans (update _)
  rw [transport]
  exact stop _

end GraphFeedback
