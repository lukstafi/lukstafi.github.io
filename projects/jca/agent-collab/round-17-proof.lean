/- The protected-template substitution lemma and the model distinguishing
   symmetric conversion from directed reachability. Lean 4.19.0, no mathlib. -/
import Std

namespace BinaryJCA

inductive Tree (α : Type) where
  | a | b | hole (value : α) | fork (l r : Tree α)
  deriving DecidableEq

def Tree.sub (env : α → Tree β) : Tree α → Tree β
  | .a => .a
  | .b => .b
  | .hole x => env x
  | .fork l r => .fork (l.sub env) (r.sub env)

inductive Shape where
  | slot | b | fork (l r : Shape)

def Shape.read : Shape → Tree α → Option (List (Tree α))
  | .slot, t => some [t]
  | .b, .b => some []
  | .fork l r, .fork s t => do
      let left ← l.read s
      let right ← r.read t
      return left ++ right
  | _, _ => none

/-- Every fixed position (including the root) rejects inserted arguments. -/
def Safe (env : α → Tree β) : Shape → Prop
  | .slot => True
  | .b => ∀ x, (Shape.b.read (env x)).isNone
  | .fork l r => (∀ x, ((Shape.fork l r).read (env x)).isNone) ∧ Safe env l ∧ Safe env r

theorem append_reads (p q : Option (List (Tree α))) (env : α → Tree β) :
    (do let l ← p.map (List.map (Tree.sub env))
        let r ← q.map (List.map (Tree.sub env))
        pure (l ++ r)) =
    (do let l ← p; let r ← q; pure (l ++ r)).map (List.map (Tree.sub env)) := by
  cases p <;> cases q <;> simp [List.map_append]

theorem read_sub (pat : Shape) (t : Tree α) (env : α → Tree β) (h : Safe env pat) :
    pat.read (t.sub env) = (pat.read t).map (List.map (Tree.sub env)) := by
  induction pat generalizing t with
  | slot => simp [Shape.read]
  | b =>
    cases t with
    | a | b | fork => rfl
    | hole x => exact Option.isNone_iff_eq_none.mp (h x)
  | fork l r hl hr =>
    cases t with
    | a | b => rfl
    | hole x => exact Option.isNone_iff_eq_none.mp (h.1 x)
    | fork s t =>
      simp only [Tree.sub, Shape.read, hl _ h.2.1, hr _ h.2.2]
      exact append_reads _ _ _

/-- A macro need only shield its strict positions for a non-hole body. -/
theorem macro_sub (left right : Shape) (t : Tree α) (env : α → Tree β)
    (root : ∀ x, t ≠ .hole x) (hl : Safe env left) (hr : Safe env right) :
    (Shape.fork left right).read (t.sub env) =
    ((Shape.fork left right).read t).map (List.map (Tree.sub env)) := by
  cases t with
  | a | b => rfl
  | hole x => exact (root x rfl).elim
  | fork s t =>
    simp only [Tree.sub, Shape.read, read_sub left s env hl, read_sub right t env hr]
    exact append_reads _ _ _

def frame : Tree α := .fork .b .b
def marker : Tree α := .fork .b frame
def frameShape : Shape := .fork .b .b
def markerShape : Shape := .fork .b frameShape

def tag : Nat → Shape
  | 0 => .b
  | n+1 => .fork (tag n) .b

def spine : Nat → Shape
  | 0 => .b
  | n+1 => .fork (.fork frameShape .slot) (spine n)

def binaryMacro (symbol arity : Nat) : Shape := .fork markerShape (.fork (tag symbol) (spine arity))

section Protection
variable {α β : Type} (env : α → Tree β)
variable (protectedArg : ∀ i, env i = .a ∨ ∃ v, env i = .fork marker v)

include protectedArg in
theorem leaf_safe : Safe env .b := by
  intro i
  rcases protectedArg i with h | ⟨v, h⟩ <;> rw [h] <;> rfl

include protectedArg in
theorem fork_safe {l r : Shape} (hl : Safe env l) (hr : Safe env r)
    (reject : l.read (marker : Tree β) = none) : Safe env (.fork l r) := by
  refine ⟨?_, hl, hr⟩
  intro i
  rcases protectedArg i with h | ⟨v, h⟩
  · rw [h]; rfl
  · rw [h]; simp [Shape.read, reject]

theorem tag_rejects (n : Nat) : (tag n).read (marker : Tree β) = none := by
  cases n with
  | zero => rfl
  | succ k => simp [tag, marker, frame, Shape.read]

include protectedArg in
theorem binary_macro_sub (symbol arity : Nat) (t : Tree α) (root : ∀ x, t ≠ .hole x) :
    (binaryMacro symbol arity).read (t.sub env) =
    ((binaryMacro symbol arity).read t).map (List.map (Tree.sub env)) := by
  have b := leaf_safe env protectedArg
  have fr : Safe env frameShape := fork_safe env protectedArg b b rfl
  have mr : Safe env markerShape := fork_safe env protectedArg b fr rfl
  have ts (n) : Safe env (tag n) := by
    induction n with
    | zero => exact b
    | succ k ih => exact fork_safe env protectedArg ih b (tag_rejects k)
  have ss (n) : Safe env (spine n) := by
    induction n with
    | zero => exact b
    | succ k ih =>
      have inner : Safe env (.fork frameShape .slot) := fork_safe env protectedArg fr trivial rfl
      exact fork_safe env protectedArg inner ih rfl
  exact macro_sub _ _ t env root mr (fork_safe env protectedArg (ts _) (ss _) (tag_rejects _))

end Protection

/- The variant with one constant. Every complete macro has state opaque. -/
inductive State where
  | opaque | gen | entry | link | tag (i : Nat)
  deriving DecidableEq

namespace OneConstant
open State

def delta (limit : Nat) : State → State → State
  | .opaque, .opaque => .gen
  | .gen, _ => .entry
  | .entry, _ => .link
  | .opaque, .gen => .tag 0
  | .tag i, .gen => if i+1 < limit then .tag (i+1) else .opaque
  | _, _ => .opaque

def state (limit : Nat) : Tree α → State
  | .fork l r => delta limit (state limit l) (state limit r)
  | _ => .opaque

def generator : Tree α := .fork .a .a

def label : Nat → Tree α
  | 0 => .fork .a generator
  | n+1 => .fork (label n) generator

theorem label_state (n bound : Nat) (h : n < bound) :
    state bound (label n : Tree α) = .tag n := by
  induction n with
  | zero => rfl
  | succ i ih => simp [label, state, ih (by omega), generator, delta, h]

def pack : List (Tree α) → Tree α
  | [] => .a
  | x::xs => .fork (.fork generator x) (pack xs)

def makeMacro (i : Nat) (xs : List (Tree α)) : Tree α := .fork (label i) (pack xs)

theorem macro_opaque (i bound : Nat) (xs : List (Tree α)) (hi : i < bound) :
    state bound (makeMacro i xs) = .opaque := by
  cases xs <;> simp [makeMacro, state, label_state _ _ hi, pack, generator, delta]

def split (bound : Nat) (want : State) (t : Tree α) : Option (Tree α × Tree α) :=
  if state bound t = want then
    match t with
    | .fork l r => some (l,r)
    | _ => none
  else none

def readSpine (bound : Nat) : Nat → Tree α → Option (List (Tree α))
  | 0, t => if state bound t = .opaque then some [] else none
  | n+1, t => do
    let (head, tail) ← split bound .link t
    let (_, slot) ← split bound .entry head
    return slot :: (← readSpine bound n tail)

def parse (bound i arity : Nat) : Tree α → Option (List (Tree α))
  | .fork l r => if state bound l = .tag i then readSpine bound arity r else none
  | _ => none

theorem read_pack (bound : Nat) (xs : List (Tree α)) :
    readSpine bound xs.length (pack xs) = some xs := by
  induction xs with
  | nil => rfl
  | cons x xs ih => simp [pack, readSpine, split, generator, state, delta, ih]

theorem parse_make (bound i : Nat) (hi : i < bound) (xs : List (Tree α)) :
    parse bound i xs.length (makeMacro i xs) = some xs := by
  simp [makeMacro, parse, label_state _ _ hi, read_pack]

variable {α β : Type} (bound : Nat) (env : α → Tree β)
variable (neutral : ∀ x, state bound (env x) = .opaque)

include neutral in
theorem state_sub (t : Tree α) : state bound (t.sub env) = state bound t := by
  induction t with
  | a | b => rfl
  | hole x => exact neutral x
  | fork _ _ hl hr => simp only [Tree.sub, state, hl, hr]

include neutral in
theorem split_sub (want : State) (w : want ≠ .opaque) (t : Tree α) :
    split bound want (t.sub env) = (split bound want t).map
      (fun (l,r) => (l.sub env, r.sub env)) := by
  simp only [split, state_sub bound env neutral]
  by_cases eq : state bound t = want
  · simp only [eq, if_true]
    cases t with
    | a | b | hole => exact (w eq.symm).elim
    | fork => rfl
  · simp [eq]

include neutral in
theorem spine_sub (n : Nat) (t : Tree α) :
    readSpine bound n (t.sub env) =
      (readSpine bound n t).map (List.map (Tree.sub env)) := by
  induction n generalizing t with
  | zero =>
    simp only [readSpine, state_sub bound env neutral]
    split <;> rfl
  | succ i ih =>
    simp only [readSpine, split_sub bound env neutral .link (by decide)]
    cases h : split bound .link t with
    | none => rfl
    | some pair =>
      obtain ⟨hd,tl⟩ := pair
      dsimp
      rw [split_sub bound env neutral .entry (by decide)]
      cases hh : split bound .entry hd with
      | none => rfl
      | some pair =>
        obtain ⟨k,slot⟩ := pair
        simp only [Option.map_some, Option.bind_some, ih]
        cases readSpine bound i tl <;> rfl

include neutral in
theorem parse_sub (i arity : Nat) (t : Tree α) (root : ∀ x, t ≠ .hole x) :
    parse bound i arity (t.sub env) = (parse bound i arity t).map (List.map (Tree.sub env)) := by
  cases t with
  | a | b => rfl
  | hole x => exact (root x rfl).elim
  | fork l r =>
    simp only [Tree.sub, parse, state_sub bound env neutral]
    split
    · apply spine_sub _ _ neutral
    · rfl

end OneConstant

/- All ranks are allowed. The list symbols of the reduction are fresh. -/
variable {σ α β A ι : Type}

inductive Term (rank : σ → Nat) (α : Type) where
  | var (x : α)
  | node (g : σ) (xs : Fin (rank g) → Term rank α)
  | nil
  | cons (x y : Term rank α)

variable {rank : σ → Nat}

abbrev Ground (rank : σ → Nat) := Term rank Empty

def Term.fill (env : α → Term rank β) : Term rank α → Term rank β
  | .var x => env x
  | .nil => .nil
  | .cons x y => .cons (x.fill env) (y.fill env)
  | .node g xs => .node g (fun i => (xs i).fill env)

def eval (ops : (g : σ) → (Fin (rank g) → A) → A) (nil : A)
    (cons : A → A → A) : Ground rank → A
  | .var x => nomatch x
  | .nil => nil
  | .cons x y => cons (eval ops nil cons x) (eval ops nil cons y)
  | .node g xs => ops g (fun i => eval ops nil cons (xs i))

theorem eval_fill_eq (ops : (g : σ) → (Fin (rank g) → A) → A) (nil : A)
    (cons : A → A → A) (L R : α → Ground rank) (t : Term rank α)
    (agree : ∀ x, eval ops nil cons (L x) = eval ops nil cons (R x)) :
    eval ops nil cons (t.fill L) = eval ops nil cons (t.fill R) := by
  induction t with
  | var x => exact agree x
  | nil => rfl
  | cons x y ih ig => simp only [Term.fill, eval, ih, ig]
  | node g _ ih => exact congrArg (ops g) (funext ih)

section Count
variable {Q σ : Type} {rank : σ → Nat}
variable (ops : (g : σ) → (Fin (rank g) → Q) → Q) (base : Q)

def project := eval ops base (fun _ q => q)

def liftOps (g : σ) (xs : Fin (rank g) → Q × Nat) : Q × Nat :=
  (ops g (fun i => (xs i).1), 0)

def countCons [DecidableEq Q] (target : Q) (x y : Q × Nat) : Q × Nat :=
  (y.1, y.2 + if x.1 = target then 0 else 1)

def count [DecidableEq Q] (target : Q) :=
  eval (liftOps ops) (base, 0) (countCons target)

theorem count_first [DecidableEq Q] (target : Q) (t : Ground rank) :
    (count ops base target t).1 = project ops base t := by
  induction t with
  | var e => exact e.elim
  | nil => rfl
  | cons _ _ _ ih => exact ih
  | node g _ ih => exact congrArg (ops g) (funext ih)

/-- Rule pairs must agree in the quotient model. Original ground rule sides
    get count zero. The extra last argument supplies precisely the removable tail. -/
theorem endpoint [DecidableEq Q] (s t : Ground rank) (ls rs : ι → Ground rank)
    (Y Z : Term rank (Option ι))
    (left : Y.fill (fun j => j.elim (.cons t .nil) ls) =
      .cons s (Z.fill (fun j => j.elim (.cons t .nil) ls)))
    (right : Y.fill (fun j => j.elim .nil rs) = Z.fill (fun j => j.elim .nil rs))
    (rules : ∀ i, count ops base (project ops base t) (ls i) =
                  count ops base (project ops base t) (rs i)) :
    project ops base s = project ops base t := by
  let target := project ops base t
  let L (j : Option ι) : Ground rank := j.elim (.cons t .nil) ls
  let R (j : Option ι) : Ground rank := j.elim .nil rs
  let measure := count ops base target
  have same (j : Option ι) : measure (L j) = measure (R j) := by
    cases j with
    | some i => exact rules i
    | none =>
      change countCons target (measure t) (base, 0) = (base, 0)
      have := count_first ops base target t
      simp [countCons, measure, target, this]
  have body (v : Term rank (Option ι)) : measure (v.fill L) = measure (v.fill R) :=
    eval_fill_eq _ _ _ _ _ _ same
  have eq : measure (.cons s (Z.fill L)) = measure (Z.fill L) :=
    (congrArg measure left).symm.trans ((body Y).trans ((congrArg measure right).trans (body Z).symm))
  have snd := congrArg Prod.snd eq
  change (measure (Z.fill L)).2 + (if (measure s).1 = target then 0 else 1) =
    (measure (Z.fill L)).2 at snd
  by_cases result : project ops base s = project ops base t
  · exact result
  have ne : (measure s).1 ≠ target := fun h => result ((count_first ops base target s).symm.trans h)
  rw [if_neg ne] at snd
  omega

end Count
#print axioms binary_macro_sub
#print axioms OneConstant.macro_opaque
#print axioms OneConstant.parse_make
#print axioms OneConstant.parse_sub
#print axioms endpoint
end BinaryJCA
