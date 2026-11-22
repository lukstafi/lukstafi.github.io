import Std

namespace RecursiveWitness

structure Row where
  x : Int
  lo : Int
  hi : Int
  deriving DecidableEq

structure Line where
  m : Int
  c : Int

def Line.atX (f : Line) (x : Int) := f.m*x + f.c

/-- Every line clears every lower endpoint. At each row, one line clears
    the upper test. Equivalently the pointwise minimum fits that row. -/
def Covers (rows : List Row) (lines : List Line) :=
  (∀ h ∈ rows, ∀ f ∈ lines, h.lo ≤ f.atX h.x) ∧
  (∀ h ∈ rows, ∃ f ∈ lines, f.atX h.x ≤ h.hi)

def Supports (h j : Row) (m : Int) :=
  m*(j.x-h.x) ≤ j.hi-h.lo

theorem support_iff (rows : List Row) :
    (∃ fs, Covers rows fs) ↔ ∀ j ∈ rows, ∃ m, ∀ h ∈ rows, Supports h j m := by
  constructor
  · rintro ⟨fs,lower,upper⟩ j hj
    obtain ⟨f,hf,cap⟩ := upper j hj
    refine ⟨f.m, fun h hh => ?_⟩
    have low := lower h hh f hf
    unfold Supports
    rw [Int.mul_sub]
    unfold Line.atX at low cap
    omega
  · intro existsSlope
    classical
    let line (j : {j // j ∈ rows}) : Line :=
      let m := Classical.choose (existsSlope j.val j.property)
      ⟨m, j.val.hi-m*j.val.x⟩
    refine ⟨rows.attach.map line, ?_, ?_⟩
    · intro h hh f hf
      obtain ⟨j,_,rfl⟩ := List.mem_map.mp hf
      have p := Classical.choose_spec (existsSlope j.val j.property) h hh
      unfold Supports at p
      rw [Int.mul_sub] at p
      simp only [Line.atX, line]
      omega
    · intro h hh
      let j : {j // j ∈ rows} := ⟨h,hh⟩
      exact ⟨line j, List.mem_map.mpr ⟨j, List.mem_attach _ _, rfl⟩, by simp only [Line.atX, line, j]; omega⟩

/-- A finite family of integer half-line constraints has a common slope
    whenever each pair does. A violated new constraint determines the
    nearest admissible endpoint. That endpoint preserves every old one. -/
private theorem rays (cs : List (Int × Int))
    (pairs : ∀ p ∈ cs, ∀ q ∈ cs, ∃ m : Int, m*p.1 ≤ p.2 ∧ m*q.1 ≤ q.2) :
    ∃ m : Int, ∀ p ∈ cs, m*p.1 ≤ p.2 := by
  induction cs with
  | nil => exact ⟨0, by simp⟩
  | cons p ps ih =>
    obtain ⟨old,ok⟩ := ih (fun a ha b hb => pairs a (by simp [ha]) b (by simp [hb]))
    by_cases enough : old*p.1 ≤ p.2
    · exact ⟨old, by simpa using And.intro enough ok⟩
    have side (q) (hq : q ∈ ps) := pairs p (by simp) q (by simp [hq])
    by_cases pos : 0 < p.1
    · let stop := p.2 / p.1
      have cut (n : Int) : n ≤ stop ↔ n*p.1 ≤ p.2 := Int.le_ediv_iff_mul_le pos
      have below : stop ≤ old := by have := cut old; omega
      refine ⟨stop, List.forall_mem_cons.mpr ⟨(cut stop).mp (Int.le_refl _), ?_⟩⟩
      intro q hq
      obtain ⟨n,works,h⟩ := side q hq
      by_cases inc : 0 ≤ q.1
      · exact Int.le_trans (Int.mul_le_mul_of_nonneg_right below inc) (ok q hq)
      · exact Int.le_trans (Int.mul_le_mul_of_nonpos_right ((cut n).mpr works) (by omega)) h
    · by_cases neg : p.1 < 0
      · let stop := -(p.2 / -p.1)
        have cut (n : Int) : stop ≤ n ↔ n*p.1 ≤ p.2 := by
          have q := Int.le_ediv_iff_mul_le (a := -n) (b := p.2) (c := -p.1) (by omega)
          simp only [Int.neg_mul_neg] at q
          dsimp only [stop]
          omega
        have above : old ≤ stop := by have := cut old; omega
        refine ⟨stop, List.forall_mem_cons.mpr ⟨(cut stop).mp (Int.le_refl _), ?_⟩⟩
        intro q hq
        obtain ⟨n,works,h⟩ := side q hq
        by_cases inc : 0 ≤ q.1
        · exact Int.le_trans (Int.mul_le_mul_of_nonneg_right ((cut n).mpr works) inc) h
        · exact Int.le_trans (Int.mul_le_mul_of_nonpos_right above (by omega)) (ok q hq)
      · obtain ⟨n,h,_⟩ := pairs p (by simp) p (by simp)
        have zero : p.1 = 0 := by omega
        simp [zero] at h enough
        omega

theorem three_iff (rows : List Row) :
    (∃ fs, Covers rows fs) ↔
    ∀ j ∈ rows, ∀ h ∈ rows, ∀ t ∈ rows, ∃ fs, Covers [j,h,t] fs := by
  constructor
  · rintro ⟨fs,lo,hi⟩ j hj h hh t ht
    refine ⟨fs, ?_, ?_⟩ <;> intro r hr <;> simp only [List.mem_cons, List.not_mem_nil, or_false] at hr
    · rcases hr with rfl | rfl | rfl <;> apply lo <;> assumption
    · rcases hr with rfl | rfl | rfl <;> apply hi <;> assumption
  · intro triples
    apply (support_iff rows).mpr
    intro j hj
    let coeff := fun h : Row => (j.x-h.x,j.hi-h.lo)
    obtain ⟨m,ok⟩ := rays (rows.map coeff) (by
      intro a ha b hb
      obtain ⟨h,hh,rfl⟩ := List.mem_map.mp ha
      obtain ⟨t,ht,rfl⟩ := List.mem_map.mp hb
      obtain ⟨m,fits⟩ := (support_iff _).mp (triples j hj h hh t ht) j (by simp)
      exact ⟨m,fits h (by simp),fits t (by simp)⟩)
    exact ⟨m,fun h hh => ok (coeff h) (List.mem_map.mpr ⟨h,hh,rfl⟩)⟩

/-- Exact interpolation across an integer gap. The larger of the two
    consecutive slopes is used on precisely the final remainder units. -/
theorem bridge (d dy : Int) (pos : 0 < d) :
    let slope := dy / d
    let rem := dy % d
    (0 ≤ rem ∧ rem < d) ∧ slope*d + max 0 (d-(d-rem)) = dy ∧
      slope*0 + max 0 (0-(d-rem)) = 0 := by
  dsimp only
  have r := Int.emod_nonneg dy (by omega : d ≠ 0)
  have small := Int.emod_lt_of_pos dy pos
  have eq := Int.emod_add_ediv dy d
  rw [Int.mul_comm d (dy/d)] at eq
  omega

/-- Integer affine terms with addition, constant scaling and positive part
    suffice for an arbitrary policy on a finite set of distinct observations. -/
inductive Expr
  | affine (m c : Int)
  | add (a b : Expr)
  | scale (m : Int) (a : Expr)
  | pos (a : Expr)

def Expr.eval : Expr → Int → Int
  | .affine m c, x => m*x+c
  | .add a b, x => a.eval x+b.eval x
  | .scale m a, x => m*a.eval x
  | .pos a, x => max 0 (a.eval x)

def spike (atX : Int) : Expr :=
  .add (.add (.pos (.affine 1 (1-atX))) (.scale (-2) (.pos (.affine 1 (-atX)))))
       (.pos (.affine 1 (-atX-1)))

theorem spike_value (a x : Int) : (spike a).eval x = if x=a then 1 else 0 := by
  simp only [spike, Expr.eval, Int.one_mul]
  split <;> omega

def table (value : Int → Int) : List Int → Expr
  | [] => .affine 0 0
  | a :: rest => .add (.scale (value a) (spike a)) (table value rest)

theorem table_value (value : Int → Int) (xs : List Int) (unique : xs.Nodup) (x : Int) :
    (table value xs).eval x = if x ∈ xs then value x else 0 := by
  induction xs with
  | nil => simp [table, Expr.eval]
  | cons a rest ih =>
    obtain ⟨absent,tail⟩ := List.nodup_cons.mp unique
    by_cases same : x = a
    · subst x
      simp [table, Expr.eval, spike_value, ih tail, absent]
    · simp [table, Expr.eval, spike_value, ih tail, same]

/-- Two rows never expose this obstruction. At the middle observation
    the upper test forces slope at most two and at least six. -/
theorem three_sharp :
    let a : Row := ⟨1,5,5⟩
    let b : Row := ⟨2,7,7⟩
    let c : Row := ⟨3,13,13⟩
    (∃ fs, Covers [a,b] fs) ∧ (∃ fs, Covers [a,c] fs) ∧
    (∃ fs, Covers [b,c] fs) ∧ ¬ ∃ fs, Covers [a,b,c] fs := by
  dsimp only
  refine ⟨⟨[⟨2,3⟩], ?_⟩, ⟨[⟨4,1⟩], ?_⟩, ⟨[⟨6,-5⟩], ?_⟩, ?_⟩
  · simp [Covers, Line.atX]
  · simp [Covers, Line.atX]
  · simp [Covers, Line.atX]
  intro all
  obtain ⟨m,h⟩ := (support_iff _).mp all ⟨2,7,7⟩ (by simp)
  have left := h ⟨1,5,5⟩ (by simp)
  have right := h ⟨3,13,13⟩ (by simp)
  simp [Supports] at left right
  omega

def zigzag : List Row := [⟨0,-1,-1⟩,⟨1,5,5⟩,⟨2,7,7⟩,⟨3,13,13⟩]
def reflect (r : Row) : Row := ⟨r.x, -r.hi, -r.lo⟩

theorem neither_extremum :
    (¬ ∃ fs, Covers zigzag fs) ∧ (¬ ∃ fs, Covers (zigzag.map reflect) fs) := by
  constructor
  · intro all
    obtain ⟨m,h⟩ := (support_iff _).mp all ⟨2,7,7⟩ (by simp [zigzag])
    have left := h ⟨1,5,5⟩ (by simp [zigzag])
    have right := h ⟨3,13,13⟩ (by simp [zigzag])
    simp [Supports] at left right
    omega
  · intro all
    obtain ⟨m,h⟩ := (support_iff _).mp all ⟨1,-5,-5⟩ (by simp [zigzag,reflect])
    have left := h ⟨0,1,1⟩ (by simp [zigzag,reflect])
    have right := h ⟨2,-7,-7⟩ (by simp [zigzag,reflect])
    simp [Supports] at left right
    omega

def pairKey (i j k : Int) :=
  let f := 4*i+4*j+1
  k ≤ f ∧ f ≤ k+2 ∧ ∀ r, k ≤ r → r ≤ k+2 → ¬ (2 ≤ r ∧ r ≤ 4)

theorem needs_both_inputs :
    (∀ i j : Int, (i=0 ∨ i=1) → (j=0 ∨ j=1) →
      pairKey i j (min (6*(i+j)-1) (4*(i+j)+1))) ∧
    (¬ ∃ p : Int → Int, ∀ i j, (i=0 ∨ i=1) → (j=0 ∨ j=1) → pairKey i j (p i)) ∧
    (¬ ∃ p : Int → Int, ∀ i j, (i=0 ∨ i=1) → (j=0 ∨ j=1) → pairKey i j (p j)) := by
  constructor
  · rintro i j (rfl | rfl) (rfl | rfl) <;> unfold pairKey <;> refine ⟨by decide, by decide, ?_⟩ <;>
      intro r low high <;> omega
  · constructor
    · rintro ⟨p,h⟩
      have aa := h 0 0 (by decide) (by decide)
      have ab := h 0 1 (by decide) (by decide)
      simp [pairKey] at aa ab
      omega
    · rintro ⟨p,h⟩
      have aa := h 0 0 (by decide) (by decide)
      have ba := h 1 0 (by decide) (by decide)
      simp [pairKey] at aa ba
      omega

/-- A trim that preserves a public atom using only the other public
    obligations leaves the public interface equivalent for all clients. -/
theorem trim_public {X : Type} (kept atom : X → Prop) (ok : ∀ x, kept x → atom x) :
    ∀ x, (kept x ∧ atom x) ↔ kept x :=
  fun x => ⟨And.left, fun h => ⟨h, ok x h⟩⟩

/-- Dropping an atom under private facts can preserve the joint formula
    while changing the set of public calls when the facts are hidden. -/
theorem residual_scope :
    (∀ x y : Int, (y=x ∧ y≤0) → x≤0) ∧ ¬ (∀ x : Int, ∃ y : Int, y=x ∧ y≤0) := by
  constructor
  · omega
  · intro all
    obtain ⟨y,h⟩ := all 1
    omega

end RecursiveWitness
