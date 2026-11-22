import Std

namespace SupplierCoverage

-- s = m - p + L and h = L - c, on a common denominator grid.
def Covers (e d s h : Int) : Prop :=
  (e ≤ 0 ∨ e ≤ s) ∧ (d ≤ h ∨ s + d ≤ h)

def Drifts (e d h : Int) : Prop :=
  (e ≤ 0 ∨ e ≤ d) ∧ (d ≤ h ∨ d ≤ e)

def Domain (e d s h : Int) : Prop :=
  0 ≤ e ∧ d ≤ h ∧ (e ≤ 0 ∨ e ≤ d) ∧ (e ≤ 0 ∨ e ≤ s)

theorem simplify_guard {e d s h : Int} (hh : 0 ≤ h) :
    (0 ≤ e ∧ Covers e d s h ∧ Drifts e d h) ↔ Domain e d s h := by
  unfold Covers Drifts Domain
  omega

theorem successor {e d s h : Int} (ok : Domain e d s h) :
    Domain e d (s + d - e) h := by
  unfold Domain at *
  omega

-- Largest supplier endpoint and largest allowed endpoint relative to p.
theorem endpoints (e d s h : Int) :
    (∀ r : Int, r ≤ max e (s+d-h) → r ≤ max 0 s) ↔ Covers e d s h := by
  unfold Covers
  constructor
  · intro all
    have h1 := all e (Int.le_max_left ..)
    have h2 := all (s+d-h) (Int.le_max_right ..)
    omega
  · intro H r hr
    omega

-- On a denominator-Q grid, the literals 1, 19 and 20 have numerators
-- Q, 19*Q and 20*Q. These implications hold uniformly in Q.
def Band (q p m r : Int) := p ≤ r ∧ r ≤ max p (m+19*q)

theorem base_and_floor (q p m : Int) : Band q p m p := by unfold Band; omega

theorem reflected_child {q p m f d r : Int}
    (dom : Domain (-f) d (m-p+20*q) q) (child : Band q (p-f) (m+d) r) :
    Domain (-f) d ((m+d)-(p-f)+20*q) q ∧ p ≤ r ∧ r ≤ max p (m+20*q) := by
  unfold Domain Band at *
  omega

theorem every_payload {q p m n f k : Int} (lo : p ≤ k)
    (_step : k ≤ n+q) (cap : k ≤ m+19*q) (_extra : k ≤ max p (m+19*q+f)) :
    Band q p m k := by unfold Band; omega

-- The external primitive satisfies the added guarantee even off the inferred domain.
theorem primitive {q p m r f : Int} :
    let k := min (min (r+q) (m+19*q)) (max p (m+19*q+f))
    k ≤ p ∨ (p ≤ k ∧ k ≤ r+q ∧ k ≤ m+19*q ∧ k ≤ max p (m+19*q+f)) := by
  dsimp
  omega

-- Adding this constructor guarantee preserves every concrete supplier.
theorem redundant_supply (k n p f : Int) :
    (k ≤ n+1 ∧ k ≤ max (n+1) (p+f)) ↔ k ≤ n+1 := by omega

theorem in_skew_coordinates (u v e d : Int) :
    2*(u+e-d) + (v+2*d-e) = (2*u+v)+e ∧
    (u+e-d) + (v+2*d-e) = (u+v)+d := by omega

-- Any result predicate can carry the redundant tag without changing what a
-- recursive caller can obtain by subtracting the child's floor.
theorem recover_tag (R : Int → Prop) (floor decoded : Int) :
    (∃ r tag, R r ∧ tag = r + floor ∧ decoded = tag - floor) ↔ R decoded := by
  constructor
  · rintro ⟨r, tag, hr, ht, hd⟩
    have : decoded = r := by omega
    exact this ▸ hr
  · intro h
    exact ⟨decoded, decoded + floor, h, rfl, by omega⟩

end SupplierCoverage

namespace Walk

-- On the grid with denominator s, the open forbidden interval is (-s,s).
def Outside (s x : Int) := x ≤ -s ∨ s ≤ x
def At (s x : Int) (n : Nat) := x + 2*s*(n : Int)

theorem step (s x : Int) (n : Nat) : At s x (n+1) = At s x n + 2*s := by
  simp [At, Int.mul_add, Int.add_assoc]

-- Find the last safe value before a first crossing into the positive ray.
theorem crossing {s x : Int} (n : Nat)
    (safe : ∀ j, Outside s (At s x j)) (cross : s ≤ At s x n) :
    s ≤ x ∨ ∃ j : Nat, At s x j = -s := by
  induction n with
  | zero => left; simpa [At] using cross
  | succ n ih =>
    rcases safe n with h | h
    · right; refine ⟨n, ?_⟩; rw [step] at cross; omega
    · exact ih h

theorem safe_iff {s x : Int} (hs : 0 < s) :
    (∀ n, Outside s (At s x n)) ↔ s ≤ x ∨ ∃ j : Nat, At s x j = -s := by
  constructor
  · intro safe
    let n := (s-x).toNat
    have hs1 : 1 ≤ 2*s := by omega
    have hn : 0 ≤ (n : Int) := by omega
    have h := Int.mul_le_mul_of_nonneg_right hs1 hn
    have reach : s ≤ At s x n := by dsimp [At, n] at *; omega
    exact crossing n safe reach
  · rintro (h | ⟨j,h⟩) n
    · right
      have h0 := Int.mul_nonneg (show 0 ≤ 2*s by omega) (show 0 ≤ (n : Int) by omega)
      unfold At; omega
    · by_cases hn : n ≤ j
      · left
        have hm := Int.mul_le_mul_of_nonneg_left (show (n : Int) ≤ j by omega)
          (show 0 ≤ 2*s by omega)
        unfold At at *; omega
      · right
        have hm := Int.mul_le_mul_of_nonneg_left (show ((j+1 : Nat) : Int) ≤ n by omega)
          (show 0 ≤ 2*s by omega)
        have hj := step s x j
        unfold At at *; omega

end Walk
