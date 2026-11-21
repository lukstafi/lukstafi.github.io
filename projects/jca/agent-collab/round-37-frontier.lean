/- Reconstructing a marked value from its first marked descendants preserves
   every generation requirement whose generators are themselves marked. -/
import Std
namespace Comparable

inductive T (α : Type) where
  | a
  | letter (i : α)
  | f (l r : T α)
open T

def size : T α → Nat
  | a | letter _ => 1
  | f l r => size l + size r + 1

inductive Gen (g : T α → Prop) : T α → Prop where
  | use {v} : g v → Gen g v
  | base : Gen g a
  | fork {l r} : Gen g l → Gen g r → Gen g (f l r)

theorem transport {g k : T α → Prop} (h : ∀ v, g v → Gen k v)
    {v} (d : Gen g v) : Gen k v := by
  induction d with
  | use m => exact h _ m
  | base => exact .base
  | fork _ _ il ir => exact .fork il ir

inductive First (marked : T α → Prop) : T α → T α → Prop where
  | stop {v} : marked v → First marked v v
  | left {l r w} : ¬ marked (f l r) → First marked l w → First marked (f l r) w
  | right {l r w} : ¬ marked (f l r) → First marked r w → First marked (f l r) w

theorem first_info {m : T α → Prop} {v w} (p : First m v w) :
    m w ∧ size w ≤ size v := by
  induction p with
  | stop h => exact ⟨h,Nat.le_refl _⟩
  | left _ _ ih | right _ _ ih =>
    exact ⟨ih.1,by simp only [size]; have := ih.2; omega⟩

theorem first_generated {m g : T α → Prop} (included : ∀ v, g v → m v)
    {v w} (p : First m v w) (d : Gen g v) : Gen g w := by
  induction p with
  | stop => exact d
  | left hm _ ih =>
    cases d with
    | use h => exact False.elim (hm (included _ h))
    | fork hl _ => exact ih hl
  | right hm _ ih =>
    cases d with
    | use h => exact False.elim (hm (included _ h))
    | fork _ hr => exact ih hr

def Below (m : T α → Prop) : T α → T α → Prop
  | f l r, w => First m l w ∨ First m r w
  | _, _ => False

def Img (φ : T α → T β) (g : T α → Prop) (y : T β) :=
  ∃ x, g x ∧ φ x = y

theorem reconstruction_preserves (m g : T α → Prop) (included : ∀ v, g v → m v)
    (φ : T α → T β)
    (rebuild : ∀ v, m v → (∀ x, v ≠ letter x) → Gen (Img φ (Below m v)) (φ v))
    (v : T α) (marked : m v) (generated : Gen g v) : Gen (Img φ g) (φ v) := by
  cases generated with
  | use hv => exact .use ⟨v,hv,rfl⟩
  | base =>
    apply transport _ (rebuild a marked (by intro i e; cases e))
    rintro _ ⟨_,h,_⟩
    exact False.elim h
  | @fork l r hl hr =>
    apply transport _ (rebuild (f l r) marked (by intro i e; cases e))
    rintro _ ⟨w,p,rfl⟩
    rcases p with p|p
    · have hw := first_info p
      have smaller : size w < size (f l r) := by simp only [size]; have := hw.2; omega
      exact reconstruction_preserves m g included φ rebuild w hw.1 (first_generated included p hl)
    · have hw := first_info p
      have smaller : size w < size (f l r) := by simp only [size]; have := hw.2; omega
      exact reconstruction_preserves m g included φ rebuild w hw.1 (first_generated included p hr)
termination_by size v

#print axioms reconstruction_preserves
end Comparable
