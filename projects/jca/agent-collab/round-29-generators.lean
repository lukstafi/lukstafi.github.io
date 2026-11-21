/- Ground values over original constructors and rigid residual letters. -/
import Std
namespace JCA.SmallDAG

inductive Term {σ : Type} (rank : σ → Nat) (letter : Type) where
  | base
  | leaf (a : letter)
  | app (f : σ) (xs : Fin (rank f) → Term rank letter)

variable {σ R : Type} {rank : σ → Nat}

def fill (env : α → Term rank β) : Term rank α → Term rank β
  | .base => .base
  | .leaf x => env x
  | .app f xs => .app f (fun i => fill env (xs i))

def shrink (keep : Term rank R → Bool) : Term rank R → Term rank R
  | .base => .base
  | .leaf r => .leaf r
  | .app f xs => if keep (.app f xs) then .app f (fun i => shrink keep (xs i)) else .base

def Marked (keep : Term rank R → Bool) (env : α → Term rank R) : Term rank α → Prop
  | .base | .leaf _ => True
  | .app f xs => keep (fill env (.app f xs)) = true ∧ ∀ i, Marked keep env (xs i)

theorem preserves_expression (keep : Term rank R → Bool) (env : α → Term rank R)
    (s : Term rank α) (h : Marked keep env s) :
    shrink keep (fill env s) = fill (fun x => shrink keep (env x)) s := by
  induction s with
  | base | leaf => rfl
  | app f xs ih =>
    obtain ⟨yes, children⟩ := h
    simp only [fill] at yes ⊢
    simp only [shrink, yes, if_true]
    congr 1
    funext i
    exact ih i (children i)

inductive Generated (gens : ι → Term rank R) : Term rank R → Prop where
  | base : Generated gens .base
  | gen (i : ι) : Generated gens (gens i)
  | build (f : σ) (xs : Fin (rank f) → Term rank R) :
      (∀ i, Generated gens (xs i)) → Generated gens (.app f xs)

theorem preserves_generators (keep : Term rank R → Bool) (gens : ι → Term rank R)
    {value : Term rank R} (h : Generated gens value) :
    Generated (fun i => shrink keep (gens i)) (shrink keep value) := by
  induction h with
  | base => exact .base
  | gen i => exact .gen i
  | build f xs _ ih =>
    simp only [shrink]
    split
    · exact .build _ _ ih
    · exact .base

#print axioms preserves_expression
#print axioms preserves_generators
end JCA.SmallDAG
