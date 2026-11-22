import Std

namespace CasePackages

/-- At a fixed elaboration, selection includes evaluating the scrutinee and
    testing its ordered guards. finish includes the chosen opening and K. -/
theorem move_into_arms {M : Type → Type} [Monad M] [LawfulMonad M]
    (selectArm : M B) (body : B → M V) (finish : V → M K) :
    (selectArm >>= body) >>= finish = selectArm >>= (fun arm => body arm >>= finish) :=
  bind_assoc _ _ _

/-- h contains information available before case selection. b includes
    the chosen arm and its local observations. inside may quantify over
    all plays still to come. The interface is fixed in both predicates. -/
def Joined (reach : H → B → Prop) (outside : H → W → Prop)
    (inside : H → B → W → Prop) :=
  ∃ f : H → W, ∀ h, outside h (f h) ∧ ∀ b, reach h b → inside h b (f h)

def Split (reach : H → B → Prop) (outside : H → W → Prop)
    (inside : H → B → W → Prop) :=
  ∀ h b, reach h b → ∃ w, outside h w ∧ inside h b w

theorem joined_split {r : H → B → Prop} {u : H → W → Prop} {v : H → B → W → Prop}
    (h : Joined r u v) : Split r u v := by
  obtain ⟨f, hf⟩ := h
  exact fun x b hr => ⟨f x, (hf x).1, (hf x).2 b hr⟩

/-- Intersection test on each legal prefix, including the unconditional
    supplier when the set of reachable arms is empty. -/
theorem joined_iff_common (r : H → B → Prop) (u : H → W → Prop)
    (v : H → B → W → Prop) :
    Joined r u v ↔ ∀ h, ∃ w, u h w ∧ ∀ b, r h b → v h b w := by
  constructor
  · rintro ⟨f, hf⟩ h
    exact ⟨f h, hf h⟩
  · intro common
    exact ⟨fun h => Classical.choose (common h), fun h => Classical.choose_spec (common h)⟩

/-- A state index visible at h selects one witness before looking at the arm. -/
theorem indexed_join :
    Joined (fun (i : Int) (b : Bool) => i = if b then 1 else 0)
      (fun i w => w = i) (fun _ b w => w = if b then 1 else 0) :=
  ⟨id, fun _ => ⟨rfl, fun _ eq => eq⟩⟩

/-- The two heads of a heterogeneous payload share no monotype before
    selection. The outer package can still be the same on both arms. -/
theorem hidden_heads :
    let r := fun (_ : Unit) (_ : Bool) => True
    let u := fun (_ : Unit) (_ : Bool) => True
    let v := fun (_ : Unit) (b w : Bool) => w = b
    Split r u v ∧ ¬ Joined r u v := by
  dsimp [Split, Joined]
  constructor
  · exact fun _ b _ => ⟨b, trivial, rfl⟩
  · rintro ⟨f, hf⟩
    have eq := ((hf ()).2 true trivial).symm.trans ((hf ()).2 false trivial)
    contradiction

theorem uncovered_prefix :
    Split (fun (_ _ : Unit) => False) (fun _ (_ : Unit) => False) (fun _ _ _ => True) ∧
    ¬ Joined (fun (_ _ : Unit) => False) (fun _ (_ : Unit) => False) (fun _ _ _ => True) :=
  ⟨fun _ _ h => h.elim, fun ⟨_, h⟩ => (h ()).1⟩

/-- The joined base now calls obs at the chosen match type. Its written
    contract guarantees the same index on every return. prev is chosen
    universally only after the recursive call has been instantiated. -/
def ObserverRows (x r : Int → Int → Prop) :=
  (∃ i k, x i k) ∧
  (∀ i k, x i k → ∃ t inst base succ : Int,
    inst = t ∧ base = inst ∧ r k base ∧ r k succ ∧
    (i = 0 → t = 0 ∧ succ = 0) ∧
    (i = 1 → t = 1 ∧ ∃ j, x 1 j ∧ ∀ prev, r j prev →
      succ = 1 ∧ (prev ≤ 0 → succ = 2))) ∧
  ∀ i : Int, (i = 0 ∨ i = 1) → ∃ k, x i k ∧ ∀ o, r k o → o ≤ 1

theorem observer_certificate : ObserverRows (fun i k => k = i) (fun k o => o = k) := by
  refine ⟨⟨0, 0, rfl⟩, ?_, ?_⟩
  · intro i k eq
    subst k
    refine ⟨i, i, i, i, rfl, rfl, rfl, rfl, fun h => ⟨h, h⟩, ?_⟩
    rintro rfl
    exact ⟨rfl, 1, rfl, fun _ eq => ⟨rfl, by omega⟩⟩
  · intro i hi
    exact ⟨i, rfl, fun _ eq => by omega⟩

/-- Even with arbitrary unary call choices, an output relation that forgets
    the parameter admits zero to the recursive opening in the B arm. -/
theorem observer_needs_parameter (x : Int → Int → Prop) (r : Int → Prop) :
    ¬ ObserverRows x (fun _ o => r o) := by
  rintro ⟨_, produce, call⟩
  obtain ⟨a, xa, _⟩ := call 0 (Or.inl rfl)
  obtain ⟨t, n, o, _, hn, ho, ro, _, atA, _⟩ := produce 0 a xa
  have r0 : r 0 := by
    have hz : o = 0 := ho.trans (hn.trans (atA rfl).1)
    exact hz ▸ ro
  obtain ⟨b, xb, safe⟩ := call 1 (Or.inr rfl)
  obtain ⟨_, _, _, s, _, _, _, rs, _, atB⟩ := produce 1 b xb
  obtain ⟨_, _, _, step⟩ := atB rfl
  have two := (step 0 r0).2 (by decide)
  have small := safe s rs
  omega

end CasePackages
