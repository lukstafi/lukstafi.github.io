import Std

namespace MatchContracts

/-- d and c range over the legal definition and call histories. At a call
    history, an arrow is chosen using just the available information.
    'need' may quantify over all later plays of that call. -/
structure Site (D C K A : Type) where
  scope : D → K
  visible : C → K
  body : D → A → Prop
  need : C → A → Prop

def Safe (s : Site D C K A) (q : K → A → Prop) :=
  ∀ d a, q (s.scope d) a → s.body d a

def Covers (s : Site D C K A) (q : K → A → Prop) :=
  ∀ c, ∃ a, s.need c a ∧ q (s.visible c) a

def Largest (s : Site D C K A) (k : K) (a : A) :=
  ∀ d, s.scope d = k → s.body d a

theorem safe_iff_contained (s : Site D C K A) (q : K → A → Prop) :
    Safe s q ↔ ∀ k a, q k a → Largest s k a := by
  constructor
  · intro h k a hq d eq
    exact h d a (eq.symm ▸ hq)
  · exact fun h d a hq => h _ a hq d rfl

theorem eliminate_cut (s : Site D C K A) :
    (∃ q, Safe s q ∧ Covers s q) ↔ Covers s (Largest s) := by
  constructor
  · rintro ⟨q, hs, hc⟩ c
    obtain ⟨a, need, allowed⟩ := hc c
    exact ⟨a, need, (safe_iff_contained s q).mp hs _ _ allowed⟩
  · intro cover
    exact ⟨Largest s, fun d a allowed => allowed d rfl, cover⟩

/-- One arrow per nonanticipating call history suffices, while keeping all
    definition histories. This is a semantic subrelation, possibly unwritable. -/
theorem thin_cut (s : Site D C K A) (q : K → A → Prop)
    (hs : Safe s q) (hc : Covers s q) :
    ∃ f : C → A,
      let chosen := fun k a => ∃ c, s.visible c = k ∧ f c = a
      Safe s chosen ∧ Covers s chosen ∧ ∀ k a, chosen k a → q k a := by
  let f := fun c => Classical.choose (hc c)
  have use (c) : s.need c (f c) ∧ q (s.visible c) (f c) := Classical.choose_spec (hc c)
  let chosen := fun k a => ∃ c, s.visible c = k ∧ f c = a
  have sub : ∀ k a, chosen k a → q k a := by
    rintro _ _ ⟨c, rfl, rfl⟩
    exact (use c).2
  exact ⟨f, fun d a h => hs d a (sub _ a h),
            fun c => ⟨f c, (use c).1, c, rfl, rfl⟩, sub⟩

/-- Eliminate the fresh predicate at a call without changing the chosen
    arrow. The same captured variables in the definition stay in scope. -/
theorem inline_at (s : Site D C K A) (q : K → A → Prop)
    (hs : Safe s q) (hc : Covers s q) (c : C) :
    ∃ a, s.need c a ∧ ∀ d, s.scope d = s.visible c → s.body d a := by
  obtain ⟨a, n, h⟩ := hc c
  exact ⟨a, n, (safe_iff_contained s q).mp hs _ a h⟩

def capture (key : Bool → K) : Site Bool Bool K Bool :=
  ⟨key, key, fun h a => a = h, fun h a => a = h⟩

theorem local_choices : ∀ h : Bool, ∃ a : Bool, a = h := fun h => ⟨h, rfl⟩

theorem exposed_capture : ∃ q, Safe (capture id) q ∧ Covers (capture id) q :=
  ⟨fun h a => a = h, fun _ _ eq => eq, fun h => ⟨h, rfl, rfl⟩⟩

theorem hidden_capture : ¬ ∃ q, Safe (capture (fun _ => ())) q ∧ Covers (capture (fun _ => ())) q := by
  rintro ⟨q, hs, hc⟩
  obtain ⟨a, ha, hq⟩ := hc true
  have no := hs false a hq
  change a = true at ha
  change a = false at no
  simp [ha] at no

/-- A discard refers to a particular binder instance at each opening.
    Each regeneration below has the same role with a different fresh name. -/
def opening (pass : Nat) (site : Bool) (key : Bool × Nat) : Option Bool :=
  if key = (site, pass) then some site else none

theorem every_previous_discard_misses (pass : Nat) :
    ∀ old, old < pass → ∀ site, opening pass site (site, old) = none := by
  intro old h site
  simp [opening, Nat.ne_of_lt h]

theorem transported_discard (old fresh : Nat) (owner site : Bool) :
    opening fresh owner (site, fresh) = opening old owner (site, old) := by
  simp [opening]

theorem collapsing_openings_breaks_transport :
    ¬ ∃ x : Option Bool, x = opening 0 true (true, 0) ∧ x = opening 0 false (false, 0) := by
  simp [opening]

/-- H is the helper's unary arrow predicate with its domain and codomain
    written separately. X chooses the outer call, and R types its opening.
    The definition must verify every admitted arrow, including a GADT match
    for which neither of these constructors exists. -/
def TagRows (M C : T) (h x r : T → T → Prop) :=
  (∀ t o, h t o → (t = M → o = M) ∧ (t = C → o = C)) ∧
  (∃ i k, x i k) ∧
  (∀ i k, x i k → (∃ a, h i a ∧ r k a) ∧
    ∃ j, x i j ∧ ∀ a, r j a → r k a) ∧
  ∀ i, (i = M ∨ i = C) → ∃ k, x i k ∧ ∀ a, r k a → a = i

theorem tag_certificate (m c : T) : TagRows m c Eq Eq Eq := by
  refine ⟨?_, ⟨m, m, rfl⟩, ?_, ?_⟩
  · rintro t _ rfl
    exact ⟨id, id⟩
  · rintro t _ rfl
    exact ⟨⟨t, rfl, rfl⟩, t, rfl, fun _ eq => eq⟩
  · exact fun i _ => ⟨i, rfl, fun _ eq => eq.symm⟩

theorem tag_needs_parameter (m c : T) (ne : m ≠ c) (h x : T → T → Prop) (r : T → Prop) :
    ¬ TagRows m c h x (fun _ a => r a) := by
  rintro ⟨_, _, producer, client⟩
  obtain ⟨km, xm, mark⟩ := client m (Or.inl rfl)
  obtain ⟨_, _, cargo⟩ := client c (Or.inr rfl)
  obtain ⟨a, _, ra⟩ := (producer m km xm).1
  exact ne ((mark a ra).symm.trans (cargo a ra))

/-- The offset shifts payloads, guard thresholds and client bounds. Input
    indices and the package coordinates chosen by calls are unchanged. -/
def NumericRows (a b : Int) (x r : Int → Int → Prop) :=
  (∃ i k, x i k) ∧
  (∀ i k, x i k → ∃ t inst base succ : Int,
    inst = t ∧ base = inst ∧ r k base ∧ r k succ ∧
    (i = 0 → t = a ∧ succ = a) ∧
    (i = 1 → t = b ∧ ∃ j, x 1 j ∧ ∀ prev, r j prev →
      succ = b ∧ (prev ≤ a → succ = b + 1))) ∧
  ∀ i : Int, (i = 0 ∨ i = 1) → ∃ k, x i k ∧ ∀ o, r k o → o ≤ b

abbrev Rows (z : Int) := NumericRows z (z+1)

def shift (d : Int) (r : Int → Int → Prop) (k o : Int) := r k (o - d)

theorem translate {z : Int} {x r : Int → Int → Prop} (d : Int) (h : Rows z x r) :
    Rows (z + d) x (shift d r) := by
  obtain ⟨inhabited, body, clients⟩ := h
  refine ⟨inhabited, ?_, ?_⟩
  · intro i k call
    obtain ⟨t, inst, base, succ, ht, hb, rb, rs, atA, atB⟩ := body i k call
    refine ⟨t+d, inst+d, base+d, succ+d, by omega, by omega,
      by simpa [shift] using rb, by simpa [shift] using rs, ?_, ?_⟩
    · intro atZero
      obtain ⟨_, _⟩ := atA atZero
      exact ⟨by omega, by omega⟩
    · intro atOne
      obtain ⟨_, j, cj, step⟩ := atB atOne
      refine ⟨by omega, j, cj, ?_⟩
      intro prev rp
      obtain ⟨_, guarded⟩ := step (prev-d) rp
      exact ⟨by omega, fun limit => by have := guarded (by omega); omega⟩
  · intro i hi
    obtain ⟨k, ck, bound⟩ := clients i hi
    exact ⟨k, ck, fun o ro => by have := bound (o-d) ro; omega⟩

theorem translate_iff (z d : Int) (x r : Int → Int → Prop) :
    Rows z x r ↔ Rows (z+d) x (shift d r) := by
  constructor
  · exact translate d
  · intro h
    have inverse : shift (-d) (shift d r) = r := by
      funext k o
      unfold shift
      have arith : o - -d - d = o := by omega
      rw [arith]
    have hz : z + d + -d = z := by omega
    simpa only [inverse, hz] using translate (-d) h

theorem shifted_certificate (z : Int) : Rows z Eq (fun k o => o = k+z) := by
  refine ⟨⟨0, 0, rfl⟩, ?_, ?_⟩
  · intro i k eq
    subst k
    refine ⟨i+z, i+z, i+z, i+z, rfl, rfl, rfl, rfl,
      fun hz => ⟨by omega, by omega⟩, ?_⟩
    rintro rfl
    exact ⟨by omega, 1, rfl, fun _ eq => ⟨by omega, by omega⟩⟩
  · exact fun i hi => ⟨i, rfl, fun _ eq => by omega⟩

theorem shifted_needs_parameter (z : Int) (x : Int → Int → Prop) (r : Int → Prop) :
    ¬ Rows z x (fun _ o => r o) := by
  rintro ⟨_, body, client⟩
  obtain ⟨ka, ca, _⟩ := client 0 (Or.inl rfl)
  obtain ⟨kb, cb, _⟩ := client 1 (Or.inr rfl)
  obtain ⟨t, inst, base, _, ht, hb, rb, _, a, _⟩ := body 0 ka ca
  have hbase : base = z := by have := (a rfl).1; omega
  obtain ⟨_, _, _, succ, _, _, _, _, _, b⟩ := body 1 kb cb
  obtain ⟨_, _, _, step⟩ := b rfl
  obtain ⟨_, guard⟩ := step base rb
  have := guard (by omega)
  omega

/-- The same two inequalities seen on full passes suffice. External calls use
    coordinate zero; inside the B arm the recursive call uses coordinate one. -/
def band (z k o : Int) := k + z ≤ o ∧ o ≤ k + z + 1

theorem band_with_two_choices (z : Int) : Rows z (fun i k => k ≤ i ∧ i ≤ k+1) (band z) := by
  refine ⟨⟨0, 0, by omega, by omega⟩, ?_, ?_⟩
  · rintro i k ⟨lo, hi⟩
    have member : band z k (i+z) := ⟨by omega, by omega⟩
    refine ⟨i+z, i+z, i+z, i+z, rfl, rfl, member, member,
      fun h => ⟨by omega, by omega⟩, ?_⟩
    rintro rfl
    exact ⟨by omega, 1, ⟨by omega, by omega⟩, fun _ ⟨low, _⟩ => ⟨by omega, by omega⟩⟩
  · intro i hi
    exact ⟨0, ⟨by omega, by omega⟩, fun _ ⟨_, bound⟩ => by omega⟩

/-- If all calls at B share one coordinate, the clients' upper bound and
    the recursive guard force its entire integer result fiber to a singleton. -/
theorem single_B_fiber {z : Int} {x r : Int → Int → Prop} (rows : Rows z x r)
    (single : ∀ k j, x 1 k → x 1 j → k = j) :
    ∃ k, x 1 k ∧ ∀ o, r k o ↔ o = z+1 := by
  obtain ⟨_, body, client⟩ := rows
  obtain ⟨k, ck, cap⟩ := client 1 (Or.inr rfl)
  obtain ⟨t, inst, base, succ, ht, hb, rb, _, _, atB⟩ := body 1 k ck
  obtain ⟨tval, j, cj, step⟩ := atB rfl
  obtain rfl := single k j ck cj
  refine ⟨k, ck, fun o => ⟨?_, ?_⟩⟩
  · intro ro
    obtain ⟨_, guard⟩ := step o ro
    have := cap o ro
    omega
  · intro eq
    have h : o = base := by omega
    exact h ▸ rb

theorem band_needs_two_choices {z : Int} {x : Int → Int → Prop} (rows : Rows z x (band z)) :
    ∃ k j, x 1 k ∧ x 1 j ∧ k ≠ j := by
  apply Classical.byContradiction
  intro h
  have single k j (ck : x 1 k) (cj : x 1 j) : k = j := by
    apply Classical.byContradiction
    exact fun ne => h ⟨k, j, ck, cj, ne⟩
  obtain ⟨k, _, fiber⟩ := single_B_fiber rows single
  have low := (fiber (k+z)).mp ⟨by omega, by omega⟩
  have high := (fiber (k+z+1)).mp ⟨by omega, by omega⟩
  omega

/-- In the scaled example the base indices are 0 and b. The exact answer
    uses slope b. A weaker inductive answer uses only unit coefficients. -/
theorem scaled_exact (b : Int) (pos : 0 < b) : NumericRows 0 b Eq (fun k o => o = b*k) := by
  refine ⟨⟨0, 0, rfl⟩, ?_, ?_⟩
  · rintro i _ rfl
    refine ⟨b*i, b*i, b*i, b*i, rfl, rfl, rfl, rfl, ?_, ?_⟩
    · rintro rfl
      simp
    · rintro rfl
      simp only [Int.mul_one]
      exact ⟨True.intro, 1, rfl, fun _ h => ⟨True.intro, by simp at h; omega⟩⟩
  · intro i hi
    refine ⟨i, rfl, ?_⟩
    rintro _ rfl
    rcases hi with h | h <;> subst i <;> simp <;> omega

theorem scaled_unit_band (b : Int) (pos : 0 < b) :
    NumericRows 0 b (fun i k => k = i ∧ i ≤ b) (fun k o => k ≤ o ∧ o ≤ b) := by
  refine ⟨⟨0, 0, rfl, by omega⟩, ?_, ?_⟩
  · rintro i k ⟨key, cap⟩
    subst k
    let value := if i = 1 then b else i
    have valid : i ≤ value ∧ value ≤ b := by unfold value; split <;> omega
    refine ⟨value, value, value, value, rfl, rfl, valid, valid, ?_, ?_⟩
    · rintro rfl
      simp [value]
    · rintro rfl
      simp only [value, if_true]
      exact ⟨True.intro, 1, ⟨rfl, by omega⟩, fun _ ⟨lower, _⟩ => ⟨True.intro, by omega⟩⟩
  · intro i hi
    exact ⟨i, ⟨rfl, by omega⟩, fun _ h => h.2⟩

end MatchContracts
