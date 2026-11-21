/- Isolation of ground congruences on color copies; Lean 4.19, no mathlib. -/
import Std
namespace JCA.ColorCopies
inductive T (α : Type) where
  | atom (a : α)
  | fork (l r : T α)
  deriving DecidableEq
def T.map (f : α → β) : T α → T β
  | .atom a => .atom (f a)
  | .fork l r => .fork (l.map f) (r.map f)
def color (i : I) (t : T α) := t.map (fun a => (i,a))
def erase (t : T (I × α)) := t.map Prod.snd
@[simp] theorem erase_color (i : I) (t : T α) : erase (color i t) = t := by
  induction t with
  | atom => rfl
  | fork l r lH rH => change T.fork (erase (color i l)) (erase (color i r)) = _; rw [lH,rH]
def first : T α → α
  | .atom a => a
  | .fork l _ => first l
@[simp] theorem first_color (i : I) (t : T α) : (first (color i t)).1 = i := by
  induction t with | atom => rfl | fork l r lh rh => exact lh

def Pure (i : I) : T (I × α) → Prop
  | .atom a => i = a.1
  | .fork l r => Pure i l ∧ Pure i r
@[simp] theorem pure_color (i j : I) (t : T α) : Pure i (color j t) ↔ i=j := by
  induction t with
  | atom => rfl
  | fork l r hl hr => change (Pure i (color j l) ∧ Pure i (color j r)) ↔ _; rw [hl,hr]; simp
theorem recovers {i : I} (t : T (I × α)) (h : Pure i t) : color i (erase t) = t := by
  induction t with
  | atom p =>
    obtain ⟨j,c⟩ := p
    change i=j at h
    cases h; rfl
  | fork l r hl hr => change T.fork (color i (erase l)) (color i (erase r)) = _; rw [hl h.1,hr h.2]

inductive Step (E : T α → T α → Prop) : T α → T α → Prop where
  | rule {a b} : E a b → Step E a b
  | back {a b} : E b a → Step E a b
  | left {a b} (r) : Step E a b → Step E (.fork a r) (.fork b r)
  | right {a b} (l) : Step E a b → Step E (.fork l a) (.fork l b)
inductive Conv (E : T α → T α → Prop) : T α → T α → Prop where
  | refl (a) : Conv E a a
  | next {a b c} : Step E a b → Conv E b c → Conv E a c

def Union (E : I → T α → T α → Prop) (a b : T (I × α)) :=
  ∃ i s t, E i s t ∧ a=color i s ∧ b=color i t

theorem step_pure {E : T (I × α) → T (I × α) → Prop} (i : I)
    (roots : ∀ a b, E a b → (Pure i a ↔ Pure i b)) {a b} (h : Step E a b) :
    Pure i a ↔ Pure i b := by
  induction h with
  | rule e => exact roots _ _ e
  | back e => exact (roots _ _ e).symm
  | left r _ ih => exact and_congr_left (fun _ => ih)
  | right l _ ih => exact and_congr_right (fun _ => ih)

theorem conv_pure {E : T (I × α) → T (I × α) → Prop} (i : I)
    (roots : ∀ a b, E a b → (Pure i a ↔ Pure i b)) {a b} (h : Conv E a b) :
    Pure i a ↔ Pure i b := by
  induction h with
  | refl => rfl
  | next step _ ih => exact (step_pure i roots step).trans ih

theorem union_pure (E : I → T α → T α → Prop) (i : I) (a b) (edge : Union E a b) :
    Pure i a ↔ Pure i b := by
  obtain ⟨j,s,t,_,rfl,rfl⟩ := edge
  simp

theorem project_step {E : I → T α → T α → Prop} (i : I) {a b}
    (h : Step (Union E) a b) (p : Pure i a) : Step (E i) (erase a) (erase b) := by
  induction h with
  | rule edge =>
    obtain ⟨j,s,t,h,rfl,rfl⟩ := edge
    obtain rfl := (pure_color i j s).mp p
    simpa using Step.rule h
  | back edge =>
    obtain ⟨j,s,t,h,rfl,rfl⟩ := edge
    obtain rfl := (pure_color i j t).mp p
    simpa using Step.back h
  | left r _ ih => exact .left _ (ih p.1)
  | right l _ ih => exact .right _ (ih p.2)

theorem project_conv {E : I → T α → T α → Prop} (i : I) {a b}
    (h : Conv (Union E) a b) (p : Pure i a) : Conv (E i) (erase a) (erase b) := by
  induction h with
  | refl => exact .refl _
  | next h _ later =>
    exact .next (project_step i h p) (later ((step_pure i (union_pure E i) h).mp p))

theorem map_step {E : T α → T α → Prop} {F : T β → T β → Prop} (f : α → β)
    (roots : ∀ a b, E a b → F (a.map f) (b.map f)) {a b} (h : Step E a b) :
    Step F (a.map f) (b.map f) := by
  induction h with
  | rule e => exact .rule (roots _ _ e)
  | back e => exact .back (roots _ _ e)
  | left _ _ ih => exact .left _ ih
  | right _ _ ih => exact .right _ ih

theorem copy_exact (E : I → T α → T α → Prop) (i : I) (a b : T α) :
    Conv (Union E) (color i a) (color i b) ↔ Conv (E i) a b := by
  constructor
  · intro h
    simpa using project_conv i h ((pure_color i i a).mpr rfl)
  · intro h
    induction h with
    | refl => exact .refl _
    | next step _ ih =>
      exact .next (map_step (fun c => (i,c))
        (fun l r elr => ⟨i,l,r,elr,rfl,rfl⟩) step) ih

#print axioms copy_exact
#print axioms conv_pure
#print axioms recovers
end JCA.ColorCopies
