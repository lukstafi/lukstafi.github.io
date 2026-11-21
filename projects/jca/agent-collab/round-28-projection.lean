/- Typed selection plans for witness compression. Lean 4.19, no mathlib. -/
import Std
namespace JCA.WitnessPlan

inductive Tree (α : Type) where
  | atom
  | var (x : α)
  | fork (l r : Tree α)

def Tree.sub (env : α → Tree β) : Tree α → Tree β
  | .atom => .atom
  | .var x => env x
  | .fork l r => .fork (l.sub env) (r.sub env)

theorem compose (s : Tree α) (f : α → Tree β) (g : β → Tree γ) :
    (s.sub f).sub g = s.sub (fun x => (f x).sub g) := by
  induction s <;> simp_all [Tree.sub]

def readPath : List Bool → Tree α → Option (Tree α)
  | [], t => some t
  | b::p, .fork l r => readPath p (if b then r else l)
  | _::_, _ => none

theorem read_sub (p : List Bool) (s u : Tree α) (f : α → Tree β)
    (h : readPath p s = some u) : readPath p (s.sub f) = some (u.sub f) := by
  induction p generalizing s with
  | nil => simp_all [readPath]
  | cons b p ih =>
    cases s with
    | atom | var => simp [readPath] at h
    | fork l r => cases b <;> simp_all [readPath, Tree.sub]

/-- The frame is a tree on n child slots. It can preserve a constructor,
    pack many retained paths, or drop every child. -/
inductive Plan where
  | node (n : Nat) (paths : Fin n → List Bool) (frame : Tree (Fin n)) (next : Fin n → Plan)

def run : Plan → Tree α → Tree α
  | .node _ paths frame next, t =>
    match t with
    | .var x => .var x
    | _ => frame.sub (fun i => run (next i) ((readPath (paths i) t).getD .atom))

def Aligned (forVar : α → Plan) : Plan → Tree α → Prop
  | .node n p frame next, t =>
    match t with
    | .var x => forVar x = .node n p frame next
    | _ => ∀ i, ∃ u, readPath (p i) t = some u ∧ Aligned forVar (next i) u

theorem run_sub (plan : Plan) (s : Tree α) (forVar : α → Plan)
    (env : α → Tree β) (h : Aligned forVar plan s) :
    run plan (s.sub env) = (run plan s).sub (fun x => run (forVar x) (env x)) := by
  induction plan generalizing s with
  | node n p frame next ih =>
    cases s with
    | var x => simp_all [Aligned, Tree.sub, run]
    | atom | fork =>
      simp only [Aligned] at h
      simp only [Tree.sub, run, compose]
      congr 1
      funext i
      obtain ⟨u,hu,aligned⟩ := h i
      have subRead := read_sub _ _ _ env hu
      simp only [Tree.sub] at subRead
      simp [hu, subRead, ih i _ aligned]

#print axioms run_sub
end JCA.WitnessPlan
