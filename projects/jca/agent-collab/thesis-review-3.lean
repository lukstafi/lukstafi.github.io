import Std

namespace PostconditionJump

-- b is the captured input index. The public result index is y.
def band (width : Nat) (b y : Int) : Prop := b ≤ y ∧ y ≤ b + (width : Int)

def box (cap : Nat) (b r y : Int) : Prop :=
  b ≤ y ∧ y ≤ r + 1 ∧ y ≤ b + (cap : Int)

def supplies (cap limit : Nat) (old : Int → Int → Prop) (b y : Int) : Prop :=
  y = b ∨ ∃ r, old b r ∧ band limit b r ∧ box cap b r y

def valid (cap limit : Nat) (post : Int → Int → Prop) : Prop :=
  (∀ b y, supplies cap limit post b y → post b y) ∧
  (∀ b r, post b r → band limit b r)

theorem band_valid {cap width limit : Nat} (h₁ : cap ≤ width) (h₂ : width ≤ limit) :
    valid cap limit (band width) := by
  constructor
  · intro b y h
    rcases h with rfl | ⟨r, _, _, lo, _, hi⟩
    · unfold band
      omega
    · unfold band
      exact ⟨lo, by omega⟩
  · rintro b r ⟨lo, hi⟩
    exact ⟨lo, by omega⟩

-- Raising the supplier cap above the use limit makes the obligations inconsistent.
theorem unsafe_above_limit {cap limit : Nat} (gap : limit < cap)
    (post : Int → Int → Prop) : ¬ valid cap limit post := by
  rintro ⟨closed, safe⟩
  have reachable (n : Nat) (hn : n ≤ limit + 1) : post 0 (n : Int) := by
    induction n with
    | zero => exact closed 0 0 (Or.inl rfl)
    | succ n ih =>
      have prev := ih (by omega)
      apply closed
      right
      exact ⟨(n : Int), prev, safe 0 _ prev, by simp only [box]; omega⟩
  have ⟨_, bound⟩ := safe 0 _ (reachable (limit + 1) (by omega))
  omega

-- The projection is exact. For the reverse inclusion, r = b + width supplies
-- every permitted y through the GADT constructor's public signature.
theorem projected {cap width limit : Nat} (h : width ≤ limit) (b y : Int) :
    supplies cap limit (band width) b y ↔ band (min (width + 1) cap) b y := by
  simp only [supplies, band, box]
  constructor
  · rintro (rfl | ⟨r, ⟨_, hr⟩, _, hlo, hstep, hcap⟩) <;> omega
  · rintro ⟨hlo, hhi⟩
    right
    exact ⟨b + (width : Int), ⟨by omega, by omega⟩, ⟨by omega, by omega⟩,
      hlo, by omega, by omega⟩

-- Only the upper atom can change. none means that widening dropped it.
def commonUpper (old raw : Nat) : Option Nat :=
  if old = raw then some old else none

def impliedUpper (old raw : Nat) : Option Nat :=
  if raw ≤ old then some old else none

structure Outcome where
  stored : Nat
  demanded : Bool
  deriving DecidableEq

-- The recursive user requires the upper bound 'limit'. Store both constraints
-- when necessary. Equation 4.7 needs no extra precondition when cap ≤ limit.
def useUpper (limit : Nat) : Option Nat → Outcome
  | none => ⟨limit, true⟩
  | some u => ⟨min u limit, decide (limit < u)⟩

def step (widen : Nat → Nat → Option Nat) (cap limit old : Nat) : Outcome :=
  useUpper limit (widen old (min (old + 1) cap))

theorem enter_loop {old cap limit : Nat} (growing : old < cap) :
    step commonUpper cap limit old = ⟨limit, true⟩ := by
  have h : min (old + 1) cap = old + 1 := by omega
  simp [step, h, commonUpper, useUpper]

theorem repeat_demand {cap limit : Nat} (gap : cap < limit) :
    step commonUpper cap limit limit = ⟨limit, true⟩ := by
  have h : min (limit + 1) cap = cap := by omega
  have ne : limit ≠ cap := by omega
  simp [step, h, commonUpper, ne, useUpper]

def afterJump (cap limit old : Nat) : Nat → Outcome
  | 0 => step commonUpper cap limit old
  | k + 1 => step commonUpper cap limit (afterJump cap limit old k).stored

theorem never_accepts {cap limit old : Nat} (growing : old < cap) (gap : cap < limit)
    (k : Nat) : afterJump cap limit old k = ⟨limit, true⟩ := by
  induction k with
  | zero => exact enter_loop growing
  | succ _ ih =>
    simp only [afterJump, ih]
    exact repeat_demand gap

theorem recognize_solution {cap limit : Nat} (h : cap ≤ limit) :
    step impliedUpper cap limit limit = ⟨limit, false⟩ := by
  have raw : min (limit + 1) cap = cap := by omega
  simp [step, raw, impliedUpper, h, useUpper]

-- A slot records the presence of one atom on a fixed interface.
def distance {α : Type} (wanted stored : α → Bool) : List α → Nat
  | [] => 0
  | a :: rest => (if stored a = wanted a then 0 else 1) + distance wanted stored rest

theorem distance_le {α : Type} {d old next : α → Bool}
    (stable : ∀ a, old a = d a → next a = d a) (slots : List α) :
    distance d next slots ≤ distance d old slots := by
  induction slots with
  | nil => simp [distance]
  | cons a tail ih =>
    simp only [distance]
    by_cases h : old a = d a
    · simpa [h, stable a h] using ih
    · by_cases g : next a = d a <;> simp [h, g] <;> omega

theorem distance_lt {α : Type} {d old next : α → Bool}
    (stable : ∀ a, old a = d a → next a = d a)
    (slots : List α) (change : ∃ a ∈ slots, old a ≠ d a ∧ next a = d a) :
    distance d next slots < distance d old slots := by
  induction slots with
  | nil => simp at change
  | cons a tail ih =>
    obtain ⟨b, member, was, now⟩ := change
    rcases List.mem_cons.mp member with rfl | later
    · have bound := distance_le stable tail
      simp only [distance, if_neg was, if_pos now]
      omega
    · have bound := ih ⟨b, later, was, now⟩
      simp only [distance]
      by_cases h : old a = d a
      · simpa [h, stable a h] using bound
      · by_cases g : next a = d a <;> simp [h, g] <;> omega

-- No old caller atom can be lost, and no new non-caller atom can be introduced.
theorem keep_agreement {d old kept added : Bool}
    (fromOld : kept = true → old = true)
    (keepCaller : old = true → d = true → kept = true)
    (fromCaller : added = true → d = true)
    (agrees : old = d) : (kept || added) = d := by
  cases d <;> cases old <;> cases kept <;> cases added <;> simp_all

theorem pass_bound {α : Type} (d : α → Bool) (states : Nat → α → Bool)
    (slots : List α) (accepts : Nat → Prop)
    (stable : ∀ k a, states k a = d a → states (k+1) a = d a)
    (advance : ∀ k, ¬ accepts k →
      ∃ a ∈ slots, states k a ≠ d a ∧ states (k+1) a = d a) :
    ∃ k, k ≤ distance d (states 0) slots ∧ accepts k := by
  classical
  apply Classical.byContradiction
  intro none
  let budget := distance d (states 0) slots
  have countdown (k : Nat) (le : k ≤ budget + 1) :
      distance d (states k) slots + k ≤ budget := by
    induction k with
    | zero => simp [budget]
    | succ k ih =>
      have hk : k ≤ budget := by omega
      have pending : ¬ accepts k := fun h => none ⟨k, hk, h⟩
      have drop := distance_lt (stable k) slots (advance k pending)
      have prev := ih (by omega)
      omega
  have impossible := countdown (budget + 1) (by omega)
  omega

end PostconditionJump
