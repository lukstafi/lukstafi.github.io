/- Two simultaneous rigid constraints: algebra used on each track. -/
import Std

namespace JCA.TwoRigid

inductive Tree (S : Type) (arity : S → Nat) (V : Type) where
  | var (v : V)
  | app (s : S) (args : Fin (arity s) → Tree S arity V)

def Tree.eval {S V A : Type} {arity : S → Nat}
    (ops : (s : S) → (Fin (arity s) → A) → A) (env : V → A) : Tree S arity V → A
  | .var v => env v
  | .app s args => ops s (fun i => (args i).eval ops env)

theorem eval_map {S V A B : Type} {arity : S → Nat}
    (f : A → B) (opA : (s : S) → (Fin (arity s) → A) → A)
    (opB : (s : S) → (Fin (arity s) → B) → B)
    (hom : ∀ s a, f (opA s a) = opB s (fun i => f (a i))) (env : V → A)
    (t : Tree S arity V) : f (t.eval opA env) = t.eval opB (f ∘ env) := by
  induction t with
  | var => rfl
  | app s args ih =>
    simp only [Tree.eval, hom]
    exact congrArg (opB s) (funext ih)

inductive Occurs {S V : Type} {arity : S → Nat} (p : V) : Tree S arity V → Prop where
  | leaf : Occurs p (.var p)
  | child {s args} (i : Fin (arity s)) : Occurs p (args i) → Occurs p (.app s args)

def nodeHeight {S : Type} {arity : S → Nat} (s : S) (kids : Fin (arity s) → Nat) : Nat :=
  (List.ofFn kids).max?.getD 0 + 1

theorem child_lt {S : Type} {arity : S → Nat} (s : S) (kids : Fin (arity s) → Nat)
    (i : Fin (arity s)) : kids i < nodeHeight s kids := by
  have b : kids i ≤ (List.ofFn kids).max?.getD 0 :=
    List.le_max?_getD_of_mem (List.mem_ofFn.mpr ⟨i, rfl⟩)
  exact Nat.lt_succ_of_le b

theorem occurrence_le {S V : Type} {arity : S → Nat} {p : V} {t : Tree S arity V}
    (e : V → Nat) (seen : Occurs p t) : e p ≤ t.eval nodeHeight e := by
  induction seen with
  | leaf => exact Nat.le_refl _
  | @child s args i _ ih =>
    exact Nat.le_trans ih (Nat.le_of_lt (child_lt s (fun j => (args j).eval nodeHeight e) i))

/-- A bare slot equal in this row to a constructor applied to a list of
    protected coordinates cannot occur in any of those coordinate patterns. -/
theorem marker_scope {S V : Type} {arity : S → Nat} {p : V} (e : V → Nat)
    (s : S) (coords : Fin (arity s) → Tree S arity V)
    (marked : e p = (Tree.app s coords).eval nodeHeight e) (i : Fin (arity s)) :
    ¬ Occurs p (coords i) := by
  intro seen
  have lower := occurrence_le e seen
  have upper := child_lt s (fun j => (coords j).eval nodeHeight e) i
  rw [marked] at lower
  exact Nat.not_le_of_gt upper lower

variable {Q : Type} [DecidableEq Q]
def countCons (target : Q) (x z : Q × Nat) : Q × Nat :=
  (z.1, z.2 + if x.1 = target then 0 else 1)

theorem tail_marker (t base : Q) :
    countCons t (t,0) (base,0) = (base,0) := by simp [countCons]

/-- Y and Z may both vary at every slot. Equality in the marker row
    and a one-cell shift in the checking row still force endpoint equality. -/
theorem shifted_trace {S V : Type} {arity : S → Nat}
    (ops : (s : S) → (Fin (arity s) → Q × Nat) → Q × Nat)
    (L R : V → Q × Nat) (agree : ∀ v, L v = R v) (Y Z : Tree S arity V)
    (start target : Q) (left : Y.eval ops L = countCons target (start,0) (Z.eval ops L))
    (right : Y.eval ops R = Z.eval ops R) : start = target := by
  have eq : L = R := funext agree
  subst R
  rw [right] at left
  have n := congrArg Prod.snd left
  by_cases e : start = target
  · exact e
  · simp [countCons, e] at n

/-- The same projection into the source algebra can be applied to malformed
    data on both tracks, then passed into the two different quotients. -/
theorem common_data {S V A B C : Type} {arity : S → Nat}
    (opA : (s : S) → (Fin (arity s) → A) → A)
    (opB : (s : S) → (Fin (arity s) → B) → B)
    (opC : (s : S) → (Fin (arity s) → C) → C)
    (f : A → B) (g : A → C)
    (hf : ∀ s a, f (opA s a) = opB s (fun i => f (a i)))
    (hg : ∀ s a, g (opA s a) = opC s (fun i => g (a i)))
    (env : V → A) (d : Tree S arity V) :
    (d.eval opB (f ∘ env), d.eval opC (g ∘ env)) =
      (f (d.eval opA env), g (d.eval opA env)) :=
  Prod.ext (eval_map f opA opB hf env d).symm (eval_map g opA opC hg env d).symm

#print axioms marker_scope
#print axioms shifted_trace
#print axioms common_data
end JCA.TwoRigid
