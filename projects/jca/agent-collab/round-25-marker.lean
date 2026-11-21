/- A one-constant scope marker inserted in a fixed leaf of any macro tag. -/
import «round-17-proof»
namespace JCA.BinaryMarker
open BinaryJCA BinaryJCA.OneConstant

def mark (tag payload : Tree α) : Tree α :=
  .fork .a (.fork generator (.fork tag payload))

def spineTag : Nat → Tree α
  | 0 => .a
  | i+1 => label i

/-- The path (left,right,left) within makeMacro is the first atom in
    generator at the tag's right. Only this fixed occurrence is replaced. -/
def patched (i : Nat) (xs : List (Tree α)) (u : Tree α) : Tree α :=
  .fork (.fork (spineTag i) (.fork u .a)) (pack xs)

theorem marked_opaque (tag payload : Tree α) (bound : Nat) :
    state bound (mark tag payload) = .opaque := by rfl

theorem marked_unreadable (tag payload : Tree α) (bound i arity : Nat) :
    parse bound i arity (mark tag payload) = none := by rfl

theorem patch_atom (i : Nat) (xs : List (Tree α)) : patched i xs .a = makeMacro i xs := by
  cases i <;> rfl

theorem patch_label (u : Tree α) (bound : Nat) (h : state bound u = .opaque) (i : Nat) :
    state bound (.fork (spineTag i) (.fork u .a)) = state bound (label i : Tree α) := by
  cases i <;> simp [spineTag, state, label, generator, h]

theorem patch_opaque (u : Tree α) (bound i : Nat) (h : state bound u = .opaque)
    (hi : i < bound) (xs : List (Tree α)) : state bound (patched i xs u) = .opaque := by
  change delta bound _ _ = _
  rw [patch_label _ _ h, label_state _ _ hi]
  cases xs <;> rfl

theorem patch_parse (u : Tree α) (bound i k arity : Nat) (h : state bound u = .opaque)
    (xs : List (Tree α)) : parse bound k arity (patched i xs u) =
    parse bound k arity (makeMacro i xs) := by
  simp only [patched, makeMacro, parse, patch_label _ _ h]

theorem marker_inj {s t x y : Tree α} (h : mark s x = mark t y) : s=t ∧ x=y := by
  exact Tree.fork.inj (Tree.fork.inj (Tree.fork.inj h).2).2

theorem patched_inj {u v : Tree α} {i j : Nat} {xs ys : List (Tree α)}
    (h : patched i xs u = patched j ys v) : u=v := by
  exact (Tree.fork.inj (Tree.fork.inj (Tree.fork.inj h).1).2).1

theorem marker_ne_patched (tag payload u : Tree α) (i : Nat) (xs : List (Tree α)) :
    mark tag payload ≠ patched i xs u := by intro h; cases (Tree.fork.inj h).1

/-- The two bodies realize the clean endpoints (macro, atom), and
    literally coincide in the marker row, even for data-dependent slots. -/
theorem half_edge (i : Nat) (xs : List (Tree α)) (tag payload : Tree α) :
    let body := patched i xs
    let marker := mark tag payload
    (body .a, (.a : Tree α)) = (makeMacro i xs, .a) ∧
      (body marker, patched i xs marker) = (body marker, body marker) := by
  exact ⟨by simp [patch_atom],rfl⟩

private def nodes : Tree α → Nat
  | .fork l r => nodes l + nodes r + 1
  | _ => 1

private theorem split_children {t l r : Tree α}
    (h : split bound want t = some (l,r)) : t = .fork l r := by
  unfold split at h
  split at h
  · cases t <;> simp_all
  · contradiction

private theorem spine_smaller {t u : Tree α} {xs : List (Tree α)}
    (h : readSpine bound arity t = some xs) (hu : u ∈ xs) : nodes u < nodes t := by
  induction arity generalizing t xs with
  | zero =>
    simp only [readSpine] at h
    split at h <;> simp_all
  | succ n ih =>
    cases e : split bound .link t with
    | none => simp [readSpine,e] at h
    | some p =>
      obtain ⟨head,tail⟩ := p
      cases g : split bound .entry head with
      | none => simp [readSpine,e,g] at h
      | some p =>
        obtain ⟨tag,slot⟩ := p
        cases q : readSpine bound n tail with
        | none => simp [readSpine,e,g,q] at h
        | some rest =>
          simp [readSpine,e,g,q] at h
          subst xs
          rw [split_children e, nodes, split_children g, nodes]
          rcases List.mem_cons.mp hu with eq | mem
          · subst u; omega
          · have := ih q mem
            omega

private theorem parse_smaller {t u : Tree α} {xs : List (Tree α)}
    (h : parse bound i arity t = some xs) (hu : u ∈ xs) : nodes u < nodes t := by
  cases t with
  | a | b | hole => simp [parse] at h
  | fork l r =>
    simp only [parse] at h
    split at h
    · have := spine_smaller h hu
      simp only [nodes]
      omega
    · contradiction

variable {Mode A : Type}

/-- What a decoder can observe at a node: the available macro matches,
    with the interpretation of each argument at every mode. -/
def observed (bound : Nat) (eval : Mode → Tree β → A) (t : Tree β) (i arity : Nat) :=
  (parse bound i arity t).map (List.map (fun child mode => eval mode child))

/-- A decoder may select any symbol, arity and child modes. Agreement at
    all modes of opaque holes lifts to arbitrary binary syntax. -/
theorem all_modes {bound : Nat} (eval : Mode → Tree β → A)
    (step : ∀ s t, observed bound eval s = observed bound eval t →
      ∀ k, eval k s = eval k t)
    (left right : α → Tree β)
    (hl : ∀ x, state bound (left x) = .opaque)
    (hr : ∀ x, state bound (right x) = .opaque)
    (agree : ∀ x k, eval k (left x) = eval k (right x))
    (t : Tree α) (k : Mode) : eval k (t.sub left) = eval k (t.sub right) := by
  by_cases hole : ∃ x, t = .hole x
  · obtain ⟨x,rfl⟩ := hole
    exact agree x k
  have root : ∀ x, t ≠ .hole x := by simpa using hole
  apply step _ _ _ k
  funext i arity
  simp only [observed, parse_sub _ _ hl _ _ _ root, parse_sub _ _ hr _ _ _ root]
  cases p : parse bound i arity t with
  | none => rfl
  | some xs =>
    simp only [Option.map, List.map_map, Option.some.injEq]
    apply List.map_congr_left
    intro u hu
    funext m
    exact all_modes eval step left right hl hr agree u m
termination_by nodes t
decreasing_by exact parse_smaller p hu

abbrev DecoderStep (Mode A : Type) :=
  Mode → (Nat → Nat → Option (List (Mode → A))) → A

/-- A failed match supplies none. A successful one supplies each strict
    child's value as a function of the mode requested by the parent. -/
def interpret (bound : Nat) (action : DecoderStep Mode A) (t : Tree β) (k : Mode) : A :=
  action k (fun i arity =>
    match h : parse bound i arity t with
    | none => none
    | some xs => some (xs.attach.map (fun u m => interpret bound action u.val m)))
termination_by nodes t
decreasing_by exact parse_smaller h u.property

private theorem interpret_step (bound : Nat) (action : DecoderStep Mode A)
    (t : Tree β) (k : Mode) :
    interpret bound action t k =
      action k (observed bound (fun m u => interpret bound action u m) t) := by
  rw [interpret.eq_1]
  congr 1
  funext i arity
  unfold observed
  split <;> simp_all

theorem interpret_context (bound : Nat) (action : DecoderStep Mode A)
    (left right : α → Tree β)
    (hl : ∀ x, state bound (left x) = .opaque)
    (hr : ∀ x, state bound (right x) = .opaque)
    (agree : ∀ x k, interpret bound action (left x) k = interpret bound action (right x) k)
    (t : Tree α) (k : Mode) :
    interpret bound action (t.sub left) k = interpret bound action (t.sub right) k := by
  apply all_modes (fun m u => interpret bound action u m) _ left right hl hr agree t k
  intro s r h m
  exact (interpret_step bound action s m).trans
    ((congrArg (action m) h).trans (interpret_step bound action r m).symm)

#print axioms patch_parse
#print axioms patch_opaque
#print axioms half_edge
#print axioms all_modes
#print axioms interpret_context
end JCA.BinaryMarker
