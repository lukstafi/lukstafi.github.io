/-
A reduction from interpolation for one unknown term operation to ordinary
finite-tree JCA. Both tuple patterns and arbitrary equational answers with
fresh variables are covered. The proof uses no unification or hardness axioms.
Run: lean projects/jca/agent-collab/round-14-reduction.lean  (Lean 4.19.0)
-/
import Std

namespace JCA

inductive Tree (α : Type) where
  | a | b | var (i : α) | f (l r : Tree α)
  deriving DecidableEq, Repr

abbrev Ground := Tree Empty

namespace Tree

def bind (e : α → Tree β) : Tree α → Tree β
  | .a => .a
  | .b => .b
  | .var i => e i
  | .f l r => .f (l.bind e) (r.bind e)

theorem bind_bind (t : Tree α) (e : α → Tree β) (h : β → Tree γ) :
    (t.bind e).bind h = t.bind (fun i => (e i).bind h) := by
  induction t <;> simp_all [bind]

theorem bind_var (t : Tree α) : t.bind Tree.var = t := by
  induction t <;> simp_all [bind]

def closed (t : Ground) : Tree α := t.bind Empty.elim

@[simp] theorem bind_closed (t : Ground) (e : α → Tree β) :
    (t.closed).bind e = t.closed := by
  unfold closed
  rw [bind_bind]
  congr 1
  funext i; exact nomatch i

@[simp] theorem closed_ground (t : Ground) : t.closed = t := by
  unfold closed
  have h : (Empty.elim : Empty → Ground) = Tree.var := funext (fun i => nomatch i)
  rw [h, bind_var]

def nodes : Tree α → Nat
  | .a | .b | .var _ => 1
  | .f l r => l.nodes + r.nodes + 1

def occurs (i : α) : Tree α → Prop
  | .a | .b => False
  | .var j => j = i
  | .f l r => occurs i l ∨ occurs i r

theorem occurs_le (t : Tree α) (e : α → Tree β) (h : t.occurs i) :
    (e i).nodes ≤ (t.bind e).nodes := by
  induction t with
  | a | b => contradiction
  | var j => cases h; exact Nat.le_refl _
  | f l r hl hr =>
    simp only [bind, nodes]
    rcases h with h | h
    · have := hl h; omega
    · have := hr h; omega

theorem bind_agree (t : Tree α) (e h : α → Tree β)
    (same : ∀ i, t.occurs i → e i = h i) : t.bind e = t.bind h := by
  induction t with
  | a | b => rfl
  | var j => exact same j rfl
  | f l r hl hr =>
    simp only [bind]
    rw [hl (fun i hi => same i (Or.inl hi)), hr (fun i hi => same i (Or.inr hi))]

end Tree

open Tree

/-- The source consists of first-order equations and evaluation requests
    F(args) = rhs. F is one operation of arity k; data are global unknowns. -/
structure Sample (n k : Nat) where
  args : Fin k → Tree (Fin n)
  rhs : Tree (Fin n)

abbrev Eqn (α : Type) := Tree α × Tree α
def Holds (e : α → Ground) (eqs : List (Eqn α)) : Prop :=
  ∀ lr ∈ eqs, lr.1.bind e = lr.2.bind e

structure Instance (n k : Nat) where
  equations : List (Eqn (Fin n))
  samples : List (Sample n k)

def Solvable (I : Instance n k) : Prop :=
  ∃ (d : Fin n → Ground) (body : Tree (Fin k)), Holds d I.equations ∧
    ∀ s ∈ I.samples, body.bind (fun j => (s.args j).bind d) = s.rhs.bind d

inductive Coord (n k : Nat) where
  | data (i : Fin n) | arg (j : Fin k) | body
  deriving DecidableEq, Repr

abbrev Branch (α : Type) := List (Eqn α) × List (Eqn α)
abbrev Pattern (n k : Nat) (π : Type := Nat) := Coord n k → Tree π

def Pass (P : Pattern n k π) (br : Branch (Coord n k)) : Prop :=
  (∃ η : π → Ground, Holds (fun v => (P v).bind η) br.1) ∧
  (∀ η : π → Ground, Holds (fun v => (P v).bind η) br.1 →
    Holds (fun v => (P v).bind η) br.2)

def extendData (t : Tree (Fin n)) : Tree (Coord n k) :=
  t.bind (fun i => .var (.data i))

@[simp] theorem eval_extendData (t : Tree (Fin n)) (e : Coord n k → Ground) :
    (extendData t).bind e = t.bind (fun i => e (.data i)) := by
  rw [extendData, bind_bind]; rfl

def packed (l : List (Tree α)) : Tree α := l.foldr Tree.f .a

def raised : Nat → Tree α → Tree α
  | 0, t => t
  | n+1, t => .f (raised n t) .a

theorem eval_raised (m : Nat) (t : Tree α) (e : α → Tree β) :
    (raised m t).bind e = raised m (t.bind e) := by
  induction m <;> simp_all [raised, Tree.bind]

theorem nodes_raised (m : Nat) (t : Tree α) :
    (raised m t).nodes = t.nodes + 2*m := by
  induction m <;> simp_all [raised, nodes] <;> omega

theorem packed_ge (l : List (Tree α)) (e : α → Tree β) (t : Tree α) (ht : t ∈ l) :
    (t.bind e).nodes ≤ ((packed l).bind e).nodes := by
  induction l with
  | nil => contradiction
  | cons h l ih =>
    change (t.bind e).nodes ≤ (h.bind e).nodes + ((packed l).bind e).nodes + 1
    rcases List.mem_cons.mp ht with h | h
    · subst t; omega
    · have := ih h; omega

def dataList (n k : Nat) : List (Tree (Coord n k)) :=
  List.ofFn (fun i : Fin n => .var (.data i))

def argEqs (rhs : Fin k → Tree (Coord n k)) : List (Eqn (Coord n k)) :=
  List.ofFn (fun j => (.var (.arg j), rhs j))

@[simp] theorem holds_args (e : Coord n k → Ground) (rhs : Fin k → Tree (Coord n k)) :
    Holds e (argEqs rhs) ↔ ∀ j, e (.arg j) = (rhs j).bind e := by
  simp [Holds, argEqs, List.mem_ofFn, Tree.bind]

def firstOrder (eqs : List (Eqn (Fin n))) : List (Eqn (Coord n k)) :=
  eqs.map (fun lr => (extendData lr.1, extendData lr.2))

@[simp] theorem holds_firstOrder (e : Coord n k → Ground) (eqs : List (Eqn (Fin n))) :
    Holds e (firstOrder eqs) ↔ Holds (fun i => e (.data i)) eqs := by
  constructor
  · intro h lr hmem
    have he := h _ (List.mem_map_of_mem (f := fun lr : Eqn (Fin n) =>
      (extendData (k := k) lr.1, extendData lr.2)) hmem)
    simpa using he
  · intro h lr hmem
    obtain ⟨ab, hab, rfl⟩ := List.mem_map.mp hmem
    simpa using h ab hab

def pin (I : Instance n k) : Branch (Coord n k) :=
  (argEqs (fun _ => .a), firstOrder I.equations)

def scopeGuard (n k : Nat) : Branch (Coord n k) :=
  (argEqs (fun j => raised (j.val+1) (packed (dataList n k))), [])

def evaluation (s : Sample n k) : Branch (Coord n k) :=
  (argEqs (fun j => extendData (s.args j)), [(.var .body, extendData s.rhs)])

def compile (I : Instance n k) : List (Branch (Coord n k)) :=
  pin I :: scopeGuard n k :: I.samples.map evaluation

def HasAnswer (I : Instance n k) : Prop :=
  ∃ P : Pattern n k, ∀ br ∈ compile I, Pass P br

@[simp] theorem holds_evaluation (e : Coord n k → Ground) (s : Sample n k) :
    Holds e (evaluation s).2 ↔ e .body = s.rhs.bind (fun i => e (.data i)) := by
  simp [evaluation, Holds, Tree.bind]

/-- Evaluate a finite vector of parameters with a fixed value elsewhere. -/
noncomputable def override (params : Fin k → π) (values : Fin k → Tree α) (q : π) : Tree α := by
  classical
  exact if h : ∃ j, params j = q then values (Classical.choose h) else .a

theorem override_at {params : Fin k → π} (inj : ∀ x y, params x = params y → x = y)
    (values : Fin k → Tree α) (j : Fin k) :
    override params values (params j) = values j := by
  unfold override
  split
  · rename_i h
    rw [inj _ _ (Classical.choose_spec h)]
  · rename_i h; exact False.elim (h ⟨j, rfl⟩)

theorem override_other {params : Fin k → π} (values : Fin k → Tree α)
    (h : ¬ ∃ j, params j = q) : override params values q = .a := by
  simp [override, h]

theorem eval_packed (l : List (Tree α)) (e : α → Tree β) :
    (packed l).bind e = packed (l.map (Tree.bind e)) := by
  induction l with
  | nil => rfl
  | cons x l ih => exact congrArg (Tree.f (x.bind e)) ih

@[simp] theorem eval_dataPack (e : Coord n k → Ground) :
    (packed (dataList n k)).bind e = packed (List.ofFn (fun i => e (.data i))) := by
  rw [eval_packed]
  apply congrArg packed
  apply List.ext_getElem
  · simp [dataList]
  · intros; simp [dataList, Tree.bind]

def encoded (d : Fin n → Ground) (body : Tree (Fin k)) : Pattern n k
  | .data i => (d i).closed
  | .arg j => .var j.val
  | .body => body.bind (fun j => .var j.val)

abbrev row (P : Pattern n k π) (η : π → Ground) (v : Coord n k) := (P v).bind η

@[simp] theorem enc_data (d : Fin n → Ground) (body : Tree (Fin k)) (η : Nat → Ground) (i) :
    row (encoded d body) η (.data i) = d i := by simp [row, encoded]
@[simp] theorem enc_arg (d : Fin n → Ground) (body : Tree (Fin k)) (η : Nat → Ground) (j) :
    row (encoded d body) η (.arg j) = η j.val := rfl
@[simp] theorem enc_body (d : Fin n → Ground) (body : Tree (Fin k)) (η : Nat → Ground) :
    row (encoded d body) η .body = body.bind (fun j => η j.val) := by
  rw [row, encoded, bind_bind]; rfl

theorem extends_args (v : Fin k → Ground) (j : Fin k) :
    override Fin.val v j.val = v j :=
  override_at (fun _ _ h => Fin.ext h) v j

theorem encode_solution {I : Instance n k} (h : Solvable I) : HasAnswer I := by
  obtain ⟨d, body, eqs, calls⟩ := h
  refine ⟨encoded d body, ?_⟩
  intro br mem
  simp only [compile, List.mem_cons, List.mem_map] at mem
  rcases mem with rfl | rfl | ⟨s, hs, rfl⟩
  · constructor
    · exact ⟨fun _ => .a, (holds_args _ _).mpr (fun _ => rfl)⟩
    · intro η _
      change Holds (row (encoded d body) η) (firstOrder I.equations)
      simpa using eqs
  · let vals (j : Fin k) := raised (j.val + 1) (packed (List.ofFn d))
    refine ⟨⟨override Fin.val vals, (holds_args _ _).mpr ?_⟩, ?_⟩
    · intro j
      change row (encoded d body) _ (.arg j) =
        (raised _ (packed (dataList n k))).bind (row (encoded d body) _)
      simp [eval_raised, extends_args, vals]
    · intro η _ lr h; contradiction
  · let vals (j : Fin k) := (s.args j).bind d
    refine ⟨⟨override Fin.val vals, (holds_args _ _).mpr ?_⟩, ?_⟩
    · intro j
      change row (encoded d body) _ (.arg j) = (extendData (s.args j)).bind (row (encoded d body) _)
      simp [vals, extends_args]
    · intro η hp
      apply (holds_evaluation (row (encoded d body) η) s).mpr
      have hv := (holds_args (row (encoded d body) η) _).mp hp
      change ∀ j, row (encoded d body) η (.arg j) =
        (extendData (s.args j)).bind (row (encoded d body) η) at hv
      simp only [enc_arg, eval_extendData, enc_data] at hv
      simpa only [enc_body, enc_data, hv] using calls s hs

/-- Soundness of the two interface guards, for an arbitrary pattern answer. -/
theorem recover_interface {I : Instance n k} (P : Pattern n k π)
    (pinOK : Pass P (pin I)) (scopeOK : Pass P (scopeGuard n k)) :
    ∃ params : Fin k → π,
      (∀ j, P (.arg j) = .var (params j)) ∧
      (∀ i j, params i = params j → i = j) ∧
      ∀ i j, ¬ (P (.data i)).occurs (params j) := by
  obtain ⟨ηa, ha⟩ := pinOK.1
  obtain ⟨ηg, hg⟩ := scopeOK.1
  have pa := (holds_args (row P ηa) _).mp ha
  have pg := (holds_args (row P ηg) _).mp hg
  let base := (packed (dataList n k)).bind (row P ηg)
  have big (j : Fin k) : row P ηg (.arg j) = raised (j.val+1) base := by
    simpa only [eval_raised] using pg j
  have sz (j : Fin k) : (row P ηg (.arg j)).nodes = base.nodes + 2*(j.val+1) := by
    rw [big, nodes_raised]
  have isvar (j : Fin k) : ∃ q, P (.arg j) = .var q := by
    have ha' : (P (.arg j)).bind ηa = .a := pa j
    have hg' : (P (.arg j)).bind ηg = .f (raised j.val base) .a := big j
    cases he : P (.arg j) with
    | a => simp [he, Tree.bind] at hg'
    | b => simp [he, Tree.bind] at ha'
    | f l r => simp [he, Tree.bind] at ha'
    | var q => exact ⟨q, rfl⟩
  let params (j : Fin k) := Classical.choose (isvar j)
  have atArg (j : Fin k) : P (.arg j) = .var (params j) := Classical.choose_spec (isvar j)
  refine ⟨params, atArg, ?_, ?_⟩
  · intro i j hij
    have hi := sz i
    have hj := sz j
    simp only [row, atArg, Tree.bind, hij] at hi hj
    apply Fin.ext; omega
  · intro i j occ
    have small := occurs_le (P (.data i)) ηg occ
    have mid := packed_ge (dataList n k) (row P ηg) (.var (.data i))
      (List.mem_ofFn.mpr ⟨i, rfl⟩)
    change (row P ηg (.data i)).nodes ≤ base.nodes at mid
    have large := sz j
    simp only [row, atArg, Tree.bind] at large
    change (ηg (params j)).nodes ≤ (row P ηg (.data i)).nodes at small
    omega

theorem decode_pattern {I : Instance n k} (P : Pattern n k π)
    (pass : ∀ br ∈ compile I, Pass P br) : Solvable I := by
  have hp := pass (pin I) (by simp [compile])
  have hg := pass (scopeGuard n k) (by simp [compile])
  obtain ⟨params, atArg, inj, absent⟩ := recover_interface P hp hg
  let d (i : Fin n) := (P (.data i)).bind (fun _ => (.a : Ground))
  let body : Tree (Fin k) := (P .body).bind (override params Tree.var)
  have data_at (v : Fin k → Ground) (i : Fin n) :
      row P (override params v) (.data i) = d i := by
    apply bind_agree
    intro q occurs
    apply override_other
    rintro ⟨j, rfl⟩
    exact absent i j occurs
  have args_at (v : Fin k → Ground) (j : Fin k) :
      row P (override params v) (.arg j) = v j := by
    simp only [row, atArg, Tree.bind, override_at inj]
  have body_at (v : Fin k → Ground) : body.bind v = row P (override params v) .body := by
    change ((P .body).bind _).bind v = (P .body).bind _
    rw [bind_bind]
    congr 1
    funext q
    by_cases hq : ∃ j, params j = q
    · obtain ⟨j, rfl⟩ := hq
      simp only [override_at inj, Tree.bind]
    · simp only [override_other _ hq, Tree.bind]
  refine ⟨d, body, ?_, ?_⟩
  · let vals (_ : Fin k) : Ground := .a
    have pre := (holds_args (row P (override params vals)) (fun _ => .a)).mpr
      (fun j => args_at vals j)
    have post := (holds_firstOrder _ _).mp (hp.2 _ pre)
    simpa only [data_at] using post
  · intro s hs
    have he := pass (evaluation s) (by simp only [compile, List.mem_cons, List.mem_map]; exact Or.inr (Or.inr ⟨s, hs, rfl⟩))
    let vals (j : Fin k) := (s.args j).bind d
    have pre : Holds (row P (override params vals)) (evaluation s).1 := by
      apply (holds_args _ _).mpr
      intro j
      change row P _ (.arg j) = (extendData (s.args j)).bind (row P _)
      simp only [args_at, eval_extendData, data_at]; rfl
    have post := (holds_evaluation (row P (override params vals)) s).mp (he.2 _ pre)
    rw [← body_at] at post
    simpa only [data_at] using post

theorem decode_solution {I : Instance n k} (h : HasAnswer I) : Solvable I := by
  obtain ⟨P, pass⟩ := h
  exact decode_pattern P pass

theorem reduction (I : Instance n k) : Solvable I ↔ HasAnswer I :=
  ⟨encode_solution, decode_solution⟩

#print axioms reduction

end JCA

namespace JCA

open Tree

/-- Original equational answers, with instance coordinates on the left of
    the sum and arbitrary fresh auxiliary variables on the right. -/
abbrev AnswerVar (n k : Nat) := Sum (Coord n k) Nat

def RawPass (A : List (Eqn (AnswerVar n k))) (br : Branch (Coord n k)) : Prop :=
  (∃ e, Holds e A ∧ Holds (fun v => e (.inl v)) br.1) ∧
  (∀ e, Holds e A → Holds (fun v => e (.inl v)) br.1 → Holds (fun v => e (.inl v)) br.2)

def HasEquationalAnswer (I : Instance n k) : Prop :=
  ∃ A, ∀ br ∈ compile I, RawPass A br

def coords (n k : Nat) : List (Coord n k) :=
  .body :: (List.ofFn Coord.data ++ List.ofFn Coord.arg)

@[simp] theorem mem_coords (v : Coord n k) : v ∈ coords n k := by
  cases v <;> simp [coords, List.mem_ofFn]

def patternEqs (P : Pattern n k) : List (Eqn (AnswerVar n k)) :=
  (coords n k).map (fun v => (.var (.inl v), (P v).bind (fun q => .var (.inr q))))

theorem holds_patternEqs (P : Pattern n k) (e : AnswerVar n k → Ground) :
    Holds e (patternEqs P) ↔ ∀ v, e (.inl v) = (P v).bind (fun q => e (.inr q)) := by
  simp [Holds, patternEqs, Tree.bind_bind, Tree.bind]

theorem raw_of_pattern {I : Instance n k} (h : HasAnswer I) : HasEquationalAnswer I := by
  obtain ⟨P, pass⟩ := h
  refine ⟨patternEqs P, ?_⟩
  intro br hb
  obtain ⟨⟨η, pre⟩, relevant⟩ := pass br hb
  constructor
  · refine ⟨Sum.elim (row P η) η, (holds_patternEqs _ _).mpr (fun _ => rfl), pre⟩
  · intro e ha
    have coordsAgree := funext ((holds_patternEqs _ _).mp ha)
    rw [coordsAgree]
    exact relevant _

namespace Hull

variable {ι : Type}

def fork : Ground → Prop
  | .f _ _ => True
  | _ => False

def left : Ground → Ground
  | .f l _ => l
  | _ => .a

def right : Ground → Ground
  | .f _ r => r
  | _ => .a

/-- Share one parameter for each disagreement column. A reference row
    supplies the structural recursion bound. -/
noncomputable def generalize (ref : Ground) (v : ι → Ground) : Tree (ι → Ground) := by
  classical
  exact match ref with
  | .a => if ∀ i, v i = .a then .a else .var v
  | .b => if ∀ i, v i = .b then .b else .var v
  | .var e => nomatch e
  | .f l r =>
    if ∀ i, fork (v i) then
      .f (generalize l (fun i => left (v i))) (generalize r (fun i => right (v i)))
    else .var v

theorem project (ref : Ground) (v : ι → Ground) (i : ι) :
    (generalize ref v).bind (fun col => col i) = v i := by
  induction ref generalizing v with
  | a | b =>
    unfold generalize
    split
    · rename_i h; exact (h i).symm
    · rfl
  | var e => exact nomatch e
  | f l r hl hr =>
    unfold generalize
    split
    · rename_i h
      simp only [Tree.bind, hl, hr]
      have hi := h i
      cases e : v i <;> simp_all [fork, left, right]
    · rfl

theorem through_term (t : Tree α) (ref : α → Ground) (e : ι → α → Ground) :
    t.bind (fun x => generalize (ref x) (fun i => e i x)) =
      generalize (t.bind ref) (fun i => t.bind (e i)) := by
  induction t with
  | a | b => simp [Tree.bind, generalize]
  | var x => rfl
  | f l r hl hr =>
    simp only [Tree.bind, hl, hr]
    rw [generalize]
    simp [fork, left, right]

end Hull

/-- Generalizing full ground witnesses for A preserves all its equations
    symbolically. Projection to the instance coordinates then passes every
    branch, even if A mentions fresh auxiliary variables. -/
theorem solution_of_raw {I : Instance n k} (h : HasEquationalAnswer I) : Solvable I := by
  classical
  obtain ⟨A, pass⟩ := h
  let J := {br // br ∈ compile I}
  let first : J := ⟨pin I, by simp [compile]⟩
  let e (j : J) := Classical.choose (pass j.val j.property).1
  have good (j : J) : Holds (e j) A ∧ Holds (fun v => e j (.inl v)) j.val.1 :=
    Classical.choose_spec (pass j.val j.property).1
  let full (v : AnswerVar n k) := Hull.generalize (e first v) (fun j : J => e j v)
  have eqs (η : (J → Ground) → Ground) : Holds (fun v => (full v).bind η) A := by
    intro lr hlr
    have ref := (good first).1 lr hlr
    have cols := funext (fun j => (good j).1 lr hlr)
    have symb : lr.1.bind full = lr.2.bind full := by
      change lr.1.bind (fun x => Hull.generalize (e first x) (fun j => e j x)) = _
      rw [Hull.through_term]
      change _ = lr.2.bind (fun x => Hull.generalize (e first x) (fun j => e j x))
      rw [Hull.through_term, ref, cols]
    simpa only [Tree.bind_bind] using congrArg (Tree.bind η) symb
  let P (v : Coord n k) := full (.inl v)
  apply decode_pattern P
  intro br hb
  let j : J := ⟨br, hb⟩
  constructor
  · refine ⟨fun col => col j, ?_⟩
    have agrees : (fun v => (P v).bind (fun col => col j)) = (fun v => e j (.inl v)) :=
      funext (fun v => Hull.project _ _ j)
    rw [agrees]
    exact (good j).2
  · intro η
    exact (pass br hb).2 (fun v => (full v).bind η) (eqs η)

theorem equational_reduction (I : Instance n k) : Solvable I ↔ HasEquationalAnswer I :=
  ⟨fun h => raw_of_pattern (encode_solution h), solution_of_raw⟩

#print axioms equational_reduction

end JCA
