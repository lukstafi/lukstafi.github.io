/- The finite-subterm lemma for any ranked signature. Lean 4.19, no mathlib. -/
import Std
namespace JCA.OneBranch

inductive Tree (S : Type) (arity : S → Nat) (R W : Type) where
  | op (s : S) (args : Fin (arity s) → Tree S arity R W)
  | rigid (r : R)
  | slot (w : W)

variable {S : Type} {arity : S → Nat} {R W : Type}
abbrev Value (S : Type) (arity : S → Nat) (R : Type) := Tree S arity R Empty

def expand (env : W → Value S arity R) : Tree S arity R W → Value S arity R
  | .slot w => env w
  | .rigid r => .rigid r
  | .op s args => .op s (fun i => expand env (args i))

inductive Sub : Tree S arity R W → Tree S arity R W → Prop where
  | refl (v) : Sub v v
  | child {v s args} (i : Fin (arity s)) : Sub v (args i) → Sub v (.op s args)

theorem Sub.trans {u v t : Value S arity R} (first : Sub u v) (second : Sub v t) : Sub u t := by
  induction second with
  | refl => exact first
  | child i _ ih => exact .child i ih

/-- Membership in the algebra built from the allowed whole input trees. -/
inductive Built (allow : Value S arity R → Prop) : Value S arity R → Prop where
  | take {v} : allow v → Built allow v
  | make (s : S) (args : Fin (arity s) → Value S arity R) :
      (∀ i, Built allow (args i)) → Built allow (.op s args)

/-- If every slot value under this tree is protected, its expansion is unchanged. -/
theorem keep_expansion (env newEnv : W → Value S arity R) (t : Tree S arity R W)
    (keep : ∀ w, Sub (env w) (expand env t) → newEnv w = env w) :
    expand newEnv t = expand env t := by
  induction t with
  | slot w => exact keep w (.refl _)
  | rigid => rfl
  | op s args ih =>
    apply congrArg (Tree.op s)
    funext i
    exact ih i (fun w h => keep w (.child i h))

/-- Changing irreducible slots away from the subtrees of all generators preserves
    membership, including when a slot is shared by several output templates. -/
theorem replace_slots (allow : Value S arity R → Prop) (env newEnv : W → Value S arity R)
    (protect : ∀ w g, allow g → Sub (env w) g → newEnv w = env w)
    (replaceable : ∀ w, newEnv w = env w ∨ Built allow (newEnv w))
    (t : Tree S arity R W) (old : Built allow (expand env t)) :
    Built allow (expand newEnv t) := by
  induction t with
  | rigid => exact old
  | slot w =>
    rcases replaceable w with e | b
    · simpa [expand, e] using old
    · exact b
  | op s args ih =>
    cases old with
    | take h =>
      rw [keep_expansion env newEnv _ (fun w hw => protect w _ h hw)]
      exact .take h
    | make _ _ kids => exact .make _ _ (fun i => ih i (kids i))

/-- A subtree containing a rigid leaf starts at a node of the generator template
    whenever all input slots expand to trees free of rigid leaves. -/
theorem mixed_subterm_origin (env : W → Value S arity R) (r : R)
    (pureSlots : ∀ w, ¬ Sub (.rigid r) (env w)) (g : Tree S arity R W)
    (v : Value S arity R) (mixed : Sub (.rigid r) v) (inside : Sub v (expand env g)) :
    ∃ piece : Tree S arity R W, expand env piece = v ∧
      Sub piece g := by
  induction g with
  | slot w => exact False.elim (pureSlots w (mixed.trans inside))
  | rigid r0 =>
    cases inside with
    | refl => exact ⟨.rigid r0, rfl, .refl _⟩
  | op s args ih =>
    cases inside with
    | refl => exact ⟨.op s args, rfl, .refl _⟩
    | child i h =>
      obtain ⟨piece, eq, path⟩ := ih i h
      exact ⟨piece, eq, .child i path⟩

#print axioms replace_slots
#print axioms mixed_subterm_origin
end JCA.OneBranch
