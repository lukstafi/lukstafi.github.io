/- Decoding the binary constructor layer of the single-missing-read reduction. -/
import Std

namespace ReadBoundary

inductive T (α : Type) where
  | a
  | hole (i : α)
  | f (l r : T α)

open T

def sub (s : α → T β) : T α → T β
  | a => a
  | hole i => s i
  | f l r => f (sub s l) (sub s r)

def nodes : T α → Nat
  | a | hole _ => 1
  | f l r => nodes l + nodes r + 1

def comb : Nat → T α
  | 0 => a
  | n+1 => f (comb n) a

def code : Bool → T α
  | false => f a (f a a)
  | true => comb 2

def tag (b : Bool) (u : T α) := f (code b) u

def macroF (x y : T α) := f (tag true a) (f (f a x) y)

def Port (t : T α) := ∃ b tail, t = f (tag b a) tail

theorem port_size {t : T α} (h : Port t) : 7 < nodes t := by
  obtain ⟨b,tail,rfl⟩ := h
  cases b <;> simp [nodes,tag,code,comb] <;> omega

theorem small_tag_reflect (s : α → T β) (ports : ∀ i, Port (s i))
    (n : Nat) (hn : n ≤ 3) (t : T α) (h : sub s t = comb n) : t = comb n := by
  induction n generalizing t with
  | zero =>
    cases t with
    | a => rfl
    | f l r => cases h
    | hole i =>
      have big := port_size (ports i)
      change s i = a at h
      simp [h,nodes] at big
  | succ n ih =>
    cases t with
    | a => cases h
    | hole i =>
      have big := port_size (ports i)
      change s i = comb (n+1) at h
      rw [h] at big
      have opts : n = 0 ∨ n = 1 ∨ n = 2 := by omega
      rcases opts with rfl | rfl | rfl <;> simp [comb,nodes] at big
    | f l r =>
      obtain ⟨hl,hr⟩ := T.f.inj h
      have rAtom : r = a := by
        cases r with
        | a => rfl
        | f x y => cases hr
        | hole i =>
          have big := port_size (ports i)
          change s i = a at hr
          simp [hr,nodes] at big
      rw [ih (by omega) l hl,rAtom]
      rfl

theorem macro_sub (s : α → T β) (x y : T α) :
    sub s (macroF x y) = macroF (sub s x) (sub s y) := by
  rfl

/-- A successful match at an existing fork was already present before filling ports. -/
theorem reflect_macro (s : α → T β) (ports : ∀ i, Port (s i))
    (l r : T α) (x y : T β) (h : sub s (f l r) = macroF x y) :
    ∃ p q, f l r = macroF p q := by
  obtain ⟨hl,hr⟩ := T.f.inj h
  have hl' := small_tag_reflect s ports 3 (by decide) l hl
  cases r with
  | a => cases hr
  | hole i =>
    obtain ⟨b,tail,hi⟩ := ports i
    change s i = f (f a x) y at hr
    rw [hi] at hr
    have impossible := (T.f.inj (T.f.inj hr).1).1
    cases b <;> cases impossible
  | f v q =>
    obtain ⟨hv,_⟩ := T.f.inj hr
    cases v with
    | a => cases hv
    | hole i =>
      obtain ⟨b,tail,hi⟩ := ports i
      change s i = f a x at hv
      rw [hi] at hv
      cases (T.f.inj hv).1
    | f k p =>
      have ka := small_tag_reflect s ports 0 (by decide) k (T.f.inj hv).1
      exact ⟨p,q,by rw [hl',ka]; rfl⟩

/-- The functional decoding rules, presented as evaluation derivations. -/
inductive Dec : T α → T α → Prop where
  | atom : Dec a a
  | leaf (i : α) : Dec (hole i) (hole i)
  | hit {x y u v} : Dec x u → Dec y v → Dec (macroF x y) (f u v)
  | miss {l r} : (∀ x y, f l r ≠ macroF x y) → Dec (f l r) a

theorem decode_commutes {t v : T α} (ht : Dec t v) (s δ : α → T β)
    (ports : ∀ i, Port (s i)) (ds : ∀ i, Dec (s i) (δ i)) :
    Dec (sub s t) (sub δ v) := by
  induction ht with
  | atom => exact .atom
  | leaf i => exact ds i
  | hit hx hy ix iy => rw [macro_sub]; exact .hit ix iy
  | miss h =>
    apply Dec.miss
    intro x y eq
    obtain ⟨p,q,hpq⟩ := reflect_macro s ports _ _ x y eq
    exact h p q hpq

#print axioms reflect_macro
#print axioms decode_commutes
end ReadBoundary
