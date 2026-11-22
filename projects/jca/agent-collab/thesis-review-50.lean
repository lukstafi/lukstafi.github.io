import Mathlib.Logic.Basic
import Mathlib.Tactic.Push

namespace TermPackages

inductive Tree where
  | leaf (symbol : Nat)
  | pair (left right : Tree)
  deriving DecidableEq

inductive Pat (V : Type*) where
  | hole (v : V)
  | leaf (symbol : Nat)
  | pair (left right : Pat V)

variable {V : Type*}

def eval (s : V → Tree) : Pat V → Tree
  | .hole v => s v
  | .leaf c => .leaf c
  | .pair l r => .pair (eval s l) (eval s r)

def occurs (v : V) : Pat V → Prop
  | .hole w => v = w
  | .leaf _ => False
  | .pair l r => occurs v l ∨ occurs v r

theorem agree {s t : V → Tree} (p : Pat V) :
    eval s p = eval t p ↔ ∀ v, occurs v p → s v = t v := by
  induction p with
  | hole w => simp [eval, occurs]
  | leaf c => simp [eval, occurs]
  | pair l r il ir =>
    simp only [eval, occurs, Tree.pair.injEq, il, ir]
    constructor
    · rintro ⟨hl,hr⟩ v (h|h)
      · exact hl v h
      · exact hr v h
    · intro h
      exact ⟨fun v hv => h v (Or.inl hv), fun v hv => h v (Or.inr hv)⟩

def Package (s t : Pat V) (k r : Tree) :=
  ∃ subst, eval subst s = k ∧ eval subst t = r

/-- Three corners in the relation force the fourth corner. -/
theorem rectangle (s t : Pat V) (k l r u : Tree)
    (kr : Package s t k r) (lr : Package s t l r) (lu : Package s t l u) :
    Package s t k u := by
  classical
  obtain ⟨a, ak, ar⟩ := kr
  obtain ⟨b, bl, br⟩ := lr
  obtain ⟨c, cl, cu⟩ := lu
  let subst := fun v => if occurs v s then a v else c v
  refine ⟨subst, Eq.trans ((agree s).mpr ?_) ak, Eq.trans ((agree t).mpr ?_) cu⟩
  · intro v hv
    simp [subst,hv]
  · intro v hv
    by_cases h : occurs v s
    · simp only [subst,if_pos h]
      exact ((agree t).mp (ar.trans br.symm) v hv).trans ((agree s).mp (bl.trans cl.symm) v h)
    · simp [subst,h]

variable {K R : Type*}

/-- The two witnesses can be fixed before the caller chooses a result. -/
theorem two_keys (P : K → R → Prop) (menu : K → Prop) (live : ∃ k, menu k)
    (rect : ∀ k l r u, P k r → P l r → P l u → P k u) :
    ∃ k l, menu k ∧ menu l ∧ ∀ r, (∀ j, menu j → P j r) ↔ P k r ∧ P l r := by
  classical
  obtain ⟨k,hk⟩ := live
  by_cases all : ∀ r, P k r → ∀ j, menu j → P j r
  · exact ⟨k,k,hk,hk,fun r => ⟨fun h => ⟨h k hk,h k hk⟩,fun h => all r h.1⟩⟩
  · push_neg at all
    obtain ⟨u,ku,l,hl,missing⟩ := all
    refine ⟨k,l,hk,hl,fun r => ⟨fun h => ⟨h k hk,h l hl⟩, ?_⟩⟩
    rintro ⟨kr,lr⟩
    exact False.elim (missing (rect l k r u lr kr ku))

theorem inhabited_opening (P : K → R → Prop) (menu : K → Prop)
    (rect : ∀ k l r u, P k r → P l r → P l u → P k u) (r : R)
    (opens : ∀ k, menu k → P k r) (k : K) (hk : menu k) (u : R) :
    (∀ j, menu j → P j u) ↔ P k u :=
  ⟨fun h => h k hk, fun h j hj => rect j k r u (opens j hj) (opens k hk) h⟩

/-- The probe tags require one constant and one binary constructor. -/
def tag : Nat → Tree
  | 0 => .leaf 0
  | n+1 => .pair (tag n) (.leaf 0)

def spine : Tree → Nat
  | .leaf _ => 0
  | .pair l _ => spine l + 1

@[simp] theorem spine_tag (n : Nat) : spine (tag n) = n := by
  induction n with
  | zero => rfl
  | succ _ ih => simp [tag, spine, ih]

/-- Preserve agreeing constructors, choosing a value at a disagreement. -/
def zipTrees (fill : Tree → Tree → Tree) : Tree → Tree → Tree
  | .leaf a, .leaf b => if a = b then .leaf a else fill (.leaf a) (.leaf b)
  | .pair l r, .pair s t => .pair (zipTrees fill l s) (zipTrees fill r t)
  | l, r => fill l r

theorem zip_eval (fill : Tree → Tree → Tree) (p : Pat V) (s t : V → Tree) :
    zipTrees fill (eval s p) (eval t p) =
    eval (fun v => zipTrees fill (s v) (t v)) p := by
  induction p with
  | hole _ => rfl
  | leaf _ => simp [eval,zipTrees]
  | pair _ _ il ir => simp [eval,zipTrees,il,ir]

/-- Two ground probes of a pattern test containment in *every* target
pattern. For packages take shape=(admitted key, fixed ground result). -/
theorem probes_cover (shape : Pat Nat) (target : Pat V) :
    (∀ env, ∃ b, eval b target = eval env shape) ↔
    (∃ b, eval b target = eval (fun _ => .leaf 0) shape) ∧
    (∃ b, eval b target = eval (fun n => tag (n+1)) shape) := by
  constructor
  · intro h
    exact ⟨h _, h _⟩
  · rintro ⟨⟨s,hs⟩,⟨t,ht⟩⟩ env
    let fill : Tree → Tree → Tree := fun _ right => match right with
      | .leaf _ => .leaf 0
      | .pair l _ => env (spine l)
    refine ⟨fun v => zipTrees fill (s v) (t v), ?_⟩
    rw [← zip_eval, hs, ht, zip_eval]
    apply (agree shape).mpr
    intro n _
    simp [tag,zipTrees,fill]

end TermPackages
