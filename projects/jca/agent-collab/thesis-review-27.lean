import Std

namespace IntervalOpening

/-- A nonempty closed interval forbidden by a guard on the opened integer. -/
structure Band where
  lo : Int
  hi : Int
  ordered : lo ≤ hi

def Inside (w k o : Int) := k ≤ o ∧ o ≤ k+w
def Avoids (w k : Int) (g : Band) :=
  ∀ o, Inside w k o → ¬ (g.lo ≤ o ∧ o ≤ g.hi)

def Works (f w k : Int) (bans : List Band) :=
  Inside w k f ∧ ∀ g ∈ bans, Avoids w k g

theorem avoids_iff (w k : Int) (hw : 0 ≤ w) (g : Band) :
    Avoids w k g ↔ k+w < g.lo ∨ g.hi < k := by
  constructor
  · intro safe
    have h := safe (max k g.lo)
    have := g.ordered
    unfold Inside at h
    omega
  · rintro h o ⟨_, _⟩ ⟨_, _⟩
    omega

/-- Anchor the interval at the required supplier value f, then move its
    start just past every forbidden band to the left of f. -/
def leastKey (f w : Int) : List Band → Int
  | [] => f-w
  | g :: gs => if g.hi < f then max (g.hi+1) (leastKey f w gs) else leastKey f w gs

theorem key_bounds (f w : Int) (hw : 0 ≤ w) (gs : List Band) :
    f-w ≤ leastKey f w gs ∧ leastKey f w gs ≤ f := by
  induction gs with
  | nil => simp [leastKey]; omega
  | cons g gs ih => simp only [leastKey]; split <;> omega

theorem left_cleared (f w : Int) (gs : List Band) (g : Band)
    (mem : g ∈ gs) (left : g.hi < f) : g.hi < leastKey f w gs := by
  induction gs with
  | nil => simp at mem
  | cons a gs ih =>
    rcases List.mem_cons.mp mem with rfl | tail
    · simp [leastKey, left]; omega
    · have := ih tail
      simp only [leastKey]; split <;> omega

theorem least_needed (hw : 0 ≤ w) {gs : List Band} (ok : Works f w k gs) :
    leastKey f w gs ≤ k := by
  obtain ⟨⟨lower, upper⟩, safe⟩ := ok
  induction gs with
  | nil => simp [leastKey]; omega
  | cons g gs ih =>
    have rest := ih (fun a ha => safe a (List.mem_cons_of_mem _ ha))
    have first := (avoids_iff w k hw g).mp (safe g (by simp))
    have := g.ordered
    simp only [leastKey]; split <;> omega

/-- This test decides the shared key without enumerating the possible k.
    It rejects a band containing f as well as a band too close on the right. -/
theorem eliminate_key (f w : Int) (hw : 0 ≤ w) (gs : List Band) :
    (∃ k, Works f w k gs) ↔
      ∀ g ∈ gs, f ≤ g.hi → leastKey f w gs + w < g.lo := by
  constructor
  · rintro ⟨k, ok⟩ g mem right
    have least := least_needed hw ok
    obtain ⟨⟨lower, upper⟩, safe⟩ := ok
    have := (avoids_iff w k hw g).mp (safe g mem)
    omega
  · intro clear
    have ⟨lb, ub⟩ := key_bounds f w hw gs
    refine ⟨leastKey f w gs, ⟨ub, by omega⟩, ?_⟩
    intro g mem
    apply (avoids_iff w _ hw g).mpr
    by_cases h : g.hi < f
    · exact Or.inr (left_cleared f w gs g mem h)
    · exact Or.inl (clear g mem (by omega))

/-- For the two-state source, the declaration admits every interval
    containing the state's result. Both external calls require an upper cap.
    Each admitted B instance must itself make a legal recursive B call. -/
def WrittenRows (a b w : Int) (gs : List Band) :=
  (∀ v, v = a ∨ v = b → ∃ k, Inside w k v ∧ ∀ o, Inside w k o → o ≤ b) ∧
  ∀ v k, (v = a ∨ v = b) → Inside w k v →
    Inside w k v ∧ (v = b → ∃ j, Works b w j gs)

theorem written_iff (a b w : Int) (ab : a < b) (hw : 0 ≤ w) (gs : List Band) :
    WrittenRows a b w gs ↔ ∀ g ∈ gs, b ≤ g.hi → leastKey b w gs + w < g.lo := by
  rw [← eliminate_key b w hw gs]
  constructor
  · rintro ⟨_, body⟩
    exact (body b b (Or.inr rfl) ⟨by omega, by omega⟩).2 rfl
  · intro recursive
    constructor
    · rintro v hv
      refine ⟨v-w, ⟨by omega, by omega⟩, ?_⟩
      rintro o ⟨_, hi⟩
      rcases hv with rfl | rfl <;> omega
    · exact fun _ _ _ fits => ⟨fits, fun _ => recursive⟩

def twoBands (s w : Int) : List Band :=
  [⟨s-2, s-1, by omega⟩, ⟨s+w+1, s+w+2, by omega⟩]

/-- Every proposed interior key can be the unique possible choice.
    Neither endpoint of the declaration's key range [f-w,f] then works. -/
theorem forced_interior (s w f k : Int) (h1 : s < f) (h2 : f < s+w) :
    Works f w k (twoBands s w) ↔ k = s := by
  constructor
  · rintro ⟨⟨lb, ub⟩, safe⟩
    have low := safe ⟨s-2, s-1, by omega⟩ (by simp [twoBands]) (s-1)
    have high := safe ⟨s+w+1, s+w+2, by omega⟩ (by simp [twoBands]) (s+w+1)
    simp only [Inside] at low high
    omega
  · rintro rfl
    refine ⟨⟨by omega, by omega⟩, ?_⟩
    intro g hg o ho
    simp only [twoBands, List.mem_cons, List.not_mem_nil, or_false] at hg
    rcases hg with rfl | rfl <;> unfold Inside at ho <;> dsimp <;> omega

end IntervalOpening
