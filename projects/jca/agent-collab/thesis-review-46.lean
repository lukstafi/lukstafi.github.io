import Mathlib.Logic.Basic

namespace JointOpening

variable {X K V I : Type*}

abbrev Rel (α β : Type*) := α → β → Prop

def Sub {α β : Type*} (a b : Rel α β) := ∀ x y, a x y → b x y

def Opens (a : Rel X K) (p : Rel K V) (x : X) (r : V) :=
  ∀ k, a x k → p k r

abbrev Rules (X V : Type*) := X → V → List (X × V) → Prop

def Closed (rules : Rules X V) (s : Rel X V) :=
  ∀ x r calls, rules x r calls → (∀ q ∈ calls, s q.1 q.2) → s x r

def Suppliers (rules : Rules X V) (a : Rel X K) (p : Rel K V) :=
  ∀ x r calls, rules x r calls → (∀ q ∈ calls, Opens a p q.1 q.2) →
    ∀ k, a x k → p k r

theorem supplier_iff {rules : Rules X V} {a : Rel X K} {p : Rel K V} :
    Suppliers rules a p ↔ Closed rules (Opens a p) := Iff.rfl

theorem blocked_iff {a : Rel X K} {p : Rel K V} {x r} :
    ¬ Opens a p x r ↔ ∃ k, a x k ∧ ¬ p k r := by
  classical
  simp [Opens, not_forall]

/-- Each task needs one admitted key that rejects every result in its veto.
An empty veto asks only for admission. Different tasks can share a key. -/
structure Tasks (I X K V : Type*) where
  input : I → X
  allowed : I → K → Prop
  veto : I → V → Prop

def Fits (lo hi : Rel X K) (keep : Rel X V) (t : Tasks I X K V)
    (a : Rel X K) (p : Rel K V) :=
  Sub lo a ∧ Sub a hi ∧ Sub keep (Opens a p) ∧
    ∀ i, ∃ k, t.allowed i k ∧ a (t.input i) k ∧ ∀ r, t.veto i r → ¬ p k r

def Compatible (lo hi : Rel X K) (keep : Rel X V) (t : Tasks I X K V)
    (key : I → K) :=
  (∀ i, t.allowed i (key i) ∧ hi (t.input i) (key i)) ∧
  (∀ i x r, lo x (key i) → keep x r → ¬ t.veto i r) ∧
  (∀ i j r, key i = key j → keep (t.input j) r → ¬ t.veto i r)

def ChosenAdmission (lo : Rel X K) (t : Tasks I X K V) (key : I → K) (x : X) (k : K) :=
  lo x k ∨ ∃ i, t.input i = x ∧ key i = k

def RequiredPackage (a : Rel X K) (keep : Rel X V) (k : K) (r : V) :=
  ∃ x, a x k ∧ keep x r

theorem construct {lo hi : Rel X K} {keep : Rel X V} {t : Tasks I X K V} {key : I → K}
    (bounds : Sub lo hi) (compatible : Compatible lo hi keep t key) :
    let a := ChosenAdmission lo t key
    Fits lo hi keep t a (RequiredPackage a keep) := by
  rcases compatible with ⟨allowed, mandatory, pairwise⟩
  refine ⟨fun _ _ h => Or.inl h, ?_, ?_, ?_⟩
  · intro x k h
    rcases h with lower | ⟨i, rfl, rfl⟩
    · exact bounds _ _ lower
    · exact (allowed i).2
  · exact fun x r kept k admitted => ⟨x, admitted, kept⟩
  · intro i
    refine ⟨key i, (allowed i).1, Or.inr ⟨i, rfl, rfl⟩, ?_⟩
    rintro r forbid ⟨x, adm, stored⟩
    rcases adm with lower | ⟨j, rfl, same⟩
    · exact mandatory i x r lower stored forbid
    · exact pairwise i j r same.symm stored forbid

theorem simultaneous_fit {lo hi : Rel X K} {keep : Rel X V} {t : Tasks I X K V}
    (bounds : Sub lo hi) :
    (∃ a p, Fits lo hi keep t a p) ↔ ∃ key, Compatible lo hi keep t key := by
  constructor
  · rintro ⟨a, p, lower, upper, kept, witnesses⟩
    let key := fun i => Classical.choose (witnesses i)
    have witness := fun i => Classical.choose_spec (witnesses i)
    refine ⟨key, fun i => ⟨(witness i).1, upper _ _ (witness i).2.1⟩, ?_, ?_⟩
    · intro i x r admitted stored forbid
      exact (witness i).2.2 r forbid (kept x r stored _ (lower _ _ admitted))
    · intro i j r same stored forbid
      apply (witness i).2.2 r forbid
      change p (key i) r
      rw [same]
      exact kept _ r stored _ (witness j).2.1
  · rintro ⟨key, compatible⟩
    exact ⟨_, _, construct bounds compatible⟩

inductive ExactTask (s : Rel X V) where
  | admit (x : X)
  | block (x : X) (r : V) (absent : ¬ s x r)

def exactTasks (s : Rel X V) : Tasks (ExactTask s) X K V where
  input
    | .admit x | .block x _ _ => x
  allowed _ _ := True
  veto
    | .admit _ => fun _ => False
    | .block _ v _ => fun r => r = v

theorem exact_fit {lo hi a : Rel X K} {p : Rel K V} {s : Rel X V} :
    Fits lo hi s (exactTasks s) a p ↔
      Sub lo a ∧ Sub a hi ∧ (∀ x, ∃ k, a x k) ∧ Opens a p = s := by
  classical
  constructor
  · rintro ⟨lower, upper, keep, witness⟩
    refine ⟨lower, upper, ?_, ?_⟩
    · intro x
      obtain ⟨k, _, admitted, _⟩ := witness (.admit x)
      exact ⟨k, admitted⟩
    · funext x r
      apply propext
      refine ⟨?_, keep x r⟩
      intro opened
      apply Classical.byContradiction
      intro h
      obtain ⟨k, _, admitted, rejects⟩ := witness (.block x r h)
      exact rejects r rfl (opened k admitted)
  · rintro ⟨lower, upper, total, rfl⟩
    refine ⟨lower, upper, fun _ _ h => h, ?_⟩
    intro i
    cases i with
    | admit x =>
      obtain ⟨k, admitted⟩ := total x
      exact ⟨k, trivial, admitted, fun _ h => False.elim h⟩
    | block x r h =>
      obtain ⟨k, admitted, rejects⟩ := blocked_iff.mp h
      exact ⟨k, trivial, admitted, fun v (hv : v = r) => hv.symm ▸ rejects⟩

/-- All dependence of the caller on a scheme factors through the opening.
Extra direct tests on admission, if any, must be accounted for separately. -/
theorem joint_solution {lo hi : Rel X K} (bounds : Sub lo hi)
    (rules : Rules X V) (caller : Rel X V → Prop) :
    (∃ a p, Sub lo a ∧ Sub a hi ∧ (∀ x, ∃ k, a x k) ∧
      Suppliers rules a p ∧ caller (Opens a p)) ↔
    ∃ s, Closed rules s ∧ caller s ∧ ∃ key, Compatible lo hi s (exactTasks s) key := by
  constructor
  · rintro ⟨a, p, lower, upper, total, producers, accepted⟩
    exact ⟨Opens a p, producers, accepted, (simultaneous_fit bounds).mp
      ⟨a, p, exact_fit.mpr ⟨lower, upper, total, rfl⟩⟩⟩
  · rintro ⟨s, closed, accepted, colors⟩
    obtain ⟨a, p, fit⟩ := (simultaneous_fit bounds).mpr colors
    obtain ⟨lower, upper, total, rfl⟩ := exact_fit.mp fit
    exact ⟨a, p, lower, upper, total, closed, accepted⟩

/-- Each input needs a typing. A caller at x also excludes result x. -/
def vertexTasks (caller : X → Prop) (K : Type*) : Tasks X X K X where
  input := id
  allowed _ _ := True
  veto x r := caller x ∧ r = x

theorem graph_feasible (edge : Rel X X) (caller : X → Prop) :
    (∃ (a : Rel X K) (p : Rel K X), Fits (fun _ _ => False) (fun _ _ => True) edge
      (vertexTasks caller K) a p) ↔
    ∃ key : X → K, ∀ x y, edge x y → caller y → key x ≠ key y := by
  rw [simultaneous_fit (fun _ _ h => False.elim h)]
  constructor
  · rintro ⟨key, _, _, pairwise⟩
    exact ⟨key, fun x y neighbour active same =>
      pairwise y x y same.symm neighbour ⟨active, rfl⟩⟩
  · rintro ⟨key, proper⟩
    refine ⟨key, fun _ => ⟨trivial, trivial⟩, fun _ _ _ h => False.elim h, ?_⟩
    rintro i j r same opened ⟨active, eq⟩
    change r = i at eq
    subst r
    exact proper j i opened active same.symm

/-- With an unrestricted key for each input, every proposed opening is realizable. -/
theorem input_keys (s : Rel X V) :
    ∀ x r, Opens (fun x k => x = k) s x r ↔ s x r := by
  intro x r
  exact ⟨fun openAt => openAt x rfl, fun h _ eq => eq ▸ h⟩

namespace Flip

/-- Two ordinary results and one out-of-band result. -/
inductive Rule : Bool → Option Bool → List (Bool × Option Bool) → Prop where
  | base (x) : Rule x (some x) []
  | flip (x : Bool) (r : Option Bool) : Rule x (r.map Bool.not) [(!x, r)]

def Diagonal (x : Bool) (r : Option Bool) := r = some x

def Band (_ : Bool) (r : Option Bool) := ∃ b, r = some b

theorem least_diagonal : Closed Rule Diagonal ∧ ∀ s, Closed Rule s → Sub Diagonal s := by
  constructor
  · intro x r calls instanceRule opened
    cases instanceRule with
    | base => rfl
    | flip r =>
      have h : r = some (!x) := opened (!x, r) (by simp)
      simp [Diagonal, h]
  · rintro s closed x _ rfl
    exact closed _ _ _ (.base x) (by simp)

theorem single_key_cannot_store_diagonal {a : Rel Bool Unit} {p : Rel Unit (Option Bool)}
    (total : ∀ x, ∃ k, a x k) : Opens a p ≠ Diagonal := by
  intro eq
  have diag : Opens a p true (some true) := eq.symm ▸ (rfl : Diagonal true (some true))
  obtain ⟨k, admitted⟩ := total true
  have other : Opens a p false (some true) := fun _ _ => diag k admitted
  have impossible : Diagonal false (some true) := eq ▸ other
  cases impossible

theorem one_key_band : Closed Rule Band ∧
    Opens (fun (_ : Bool) (_ : Unit) => True) (fun _ => Band false) = Band := by
  constructor
  · intro x r calls instanceRule opened
    cases instanceRule with
    | base => exact ⟨x, rfl⟩
    | flip r =>
      obtain ⟨b, h : r = some b⟩ := opened (!x, r) (by simp)
      exact ⟨!b, by simp [h]⟩
  · funext x r
    exact propext ⟨fun h => h () trivial, fun h _ _ => h⟩

end Flip
end JointOpening
