/- A packed observation with a repeated rigid tag cannot occur inside another one. -/
import Std

namespace WeakConjunctions

inductive T where
  | a
  | tag
  | f (l r : T)
deriving DecidableEq
open T

def marked : T → Bool
  | a => false
  | tag => true
  | f l r => marked l || marked r

inductive Sub (v : T) : T → Prop where
  | root : Sub v v
  | left {l r} : Sub v l → Sub v (f l r)
  | right {l r} : Sub v r → Sub v (f l r)

theorem sub_marked {v t} (h : Sub v t) (m : marked v = true) : marked t = true := by
  induction h with
  | root => exact m
  | left _ ih | right _ ih => simp [marked,ih]

def spine : List T → T
  | [] => a
  | x :: xs => f (f tag x) (spine xs)

def pack (xs : List T) := f tag (f a (spine xs))

theorem outside_spine (v : T) (hv : marked v = true) (xs : List T)
    (ground : ∀ x ∈ xs, marked x = false) : ¬Sub (f tag v) (spine xs) := by
  induction xs with
  | nil => intro sub; cases sub
  | cons x xs ih =>
    intro h
    have gx := ground x (by simp)
    cases h with
    | left he =>
      cases he with
      | root => simp_all
      | left hh => cases hh
      | right hh =>
        have yes := sub_marked hh (by simp [marked])
        simp_all
    | right hs => exact ih (fun w hw => ground w (by simp [hw])) hs

theorem only_at_root (v : T) (hv : marked v = true) (xs : List T)
    (ground : ∀ x ∈ xs, marked x = false) (h : Sub (f tag v) (pack xs)) :
    f tag v = pack xs := by
  cases h with
  | root => rfl
  | left hh => cases hh
  | right hw =>
    cases hw with
    | left hh => cases hh
    | right hs => exact False.elim (outside_spine v hv xs ground hs)

theorem packed_exclusion (x : T) (xs ys : List T)
    (ground : ∀ z ∈ ys, marked z = false) (different : pack (x::xs) ≠ pack ys) :
    ¬Sub (pack (x::xs)) (pack ys) := by
  intro sub
  apply different
  apply only_at_root _ _ ys ground sub
  simp [spine,marked]

/-- Distinct probes occupy all available names once the size bound is met. -/
theorem exhaust_names [DecidableEq α] (used available : List α) (hu : used.Nodup)
    (inside : used ⊆ available) (count : available.length ≤ used.length) :
    available ⊆ used := by
  induction used generalizing available with
  | nil =>
    cases available with
    | nil => exact fun _ h => h
    | cons => simp at count
  | cons x xs ih =>
    obtain ⟨absent,tail⟩ := List.nodup_cons.mp hu
    have hx : x ∈ available := inside (by simp)
    have sub : xs ⊆ available.erase x := by
      intro y hy
      have different : y ≠ x := by rintro rfl; exact absent hy
      exact (List.mem_erase_of_ne different).mpr (inside (by simp [hy]))
    have bound : (available.erase x).length ≤ xs.length := by
      rw [List.length_erase_of_mem hx]
      simp only [List.length_cons] at count
      omega
    have all := ih (available.erase x) tail sub bound
    intro y hy
    by_cases equal : y=x
    · simp [equal]
    · exact List.mem_cons_of_mem x (all ((List.mem_erase_of_ne equal).mpr hy))

inductive Body (α : Type) where
  | atom
  | param (x : α)
  | fork (l r : Body α)

def evaluate (v : α → T) : Body α → T
  | .atom => a
  | .param x => v x
  | .fork l r => f (evaluate v l) (evaluate v r)

def permitted (s : List α) : Body α → Prop
  | .atom => True
  | .param x => x ∈ s
  | .fork l r => permitted s l ∧ permitted s r

theorem recover_body [DecidableEq α] (formals : List ι) (choose : ι → α)
    (available : List α) (unique : (formals.map choose).Nodup)
    (inside : formals.map choose ⊆ available) (count : available.length ≤ formals.length)
    (oldL oldR : α → T) (newL newR : ι → T)
    (columns : ∀ i ∈ formals, oldL (choose i) = newL i ∧ oldR (choose i) = newR i)
    (b : Body α) (hb : permitted available b) :
    ∃ p : Body ι, evaluate newL p = evaluate oldL b ∧ evaluate newR p = evaluate oldR b := by
  have all := exhaust_names (formals.map choose) available unique inside (by simpa using count)
  induction b with
  | atom => exact ⟨.atom,rfl,rfl⟩
  | param x =>
    obtain ⟨i,mem,eq⟩ := List.mem_map.mp (all hb)
    obtain ⟨left,right⟩ := columns i mem
    exact ⟨.param i,eq ▸ left.symm,eq ▸ right.symm⟩
  | fork l r il ir =>
    obtain ⟨x,l₁,l₂⟩ := il hb.1
    obtain ⟨y,r₁,r₂⟩ := ir hb.2
    exact ⟨.fork x y,by simp [evaluate,l₁,r₁],by simp [evaluate,l₂,r₂]⟩

#print axioms recover_body
#print axioms packed_exclusion
end WeakConjunctions
