import «thesis-review-14»

namespace MovingFloor

-- A result predicate observes the floor, x = m-p, and the captured key.
-- Modes with the same key must offer the same relation at these coordinates.
def Shared {Mode Key : Type} (key : Mode → Key) (C e d : Mode → Int)
    (L stride : Int) (Q : Key → Int → Int → Int → Prop) : Prop :=
  ∀ s, GridValid (C s) L (e s) (d s) stride
    (fun _ x => allows (C s) L (e s) (d s) x) (Q (key s))

def CoversKeys {Mode Key : Type} (key : Mode → Key) (C d : Mode → Int) (L : Int) : Prop :=
  ∀ s t, key s = key t → C s + d t ≤ L

-- Take all caller bounds that could apply to an observation of this key.
-- This construction works without enumerating the modes or taking a supremum.
theorem common_contract {Mode Key : Type} {key : Mode → Key} {C e d : Mode → Int}
    {L stride : Int} (h : CoversKeys key C d L) :
    ∃ Q, Shared key C e d L stride Q := by
  refine ⟨fun z _ x u => 0 ≤ u ∧ ∀ t, z = key t → u ≤ max (x+L-d t) 0, ?_⟩
  intro s
  constructor
  · unfold allows; intros; omega
  · intro p x hp
    exact ⟨by omega, fun t _ => by omega⟩
  · intro p x u hp hu
    obtain ⟨low, high⟩ := hu
    have bound := high s rfl
    unfold allows at hp
    unfold band
    omega
  · intro p x u v hp hu hl hv hinc
    refine ⟨hv.1, fun t ht => ?_⟩
    have cap := h s t ht
    unfold band at hv
    omega

-- A sender with nondecreasing slack can generate every unit-grid payload in
-- its band. Compare its largest payload with an arbitrary recipient's limit.
theorem shared_necessary {Mode Key : Type} {key : Mode → Key} {C e d : Mode → Int}
    {L stride : Int} {Q} (v : Shared key C e d L stride Q) (inc : 1 ≤ stride)
    (admitted : ∀ s, 0 ≤ e s ∧ e s ≤ max 0 (d s) ∧ d s ≤ L - C s) :
    CoversKeys key C d L := by
  intro s t same
  obtain ⟨hs, ds, cs⟩ := admitted s
  obtain ⟨ht, dt, ct⟩ := admitted t
  by_cases up : e s ≤ d s
  · let x := max (-C s) (max (e s - L) (d t - L))
    have src : allows (C s) L (e s) (d s) x := by unfold allows; dsimp [x]; omega
    have dst : allows (C t) L (e t) (d t) (x-d t+e t) := by unfold allows; dsimp [x]; omega
    have vs := v s
    have unit : Valid (C s) L (e s) (d s)
        (fun _ x => allows (C s) L (e s) (d s) x) (Q (key s)) := by
      refine ⟨vs.recur, vs.base, vs.call, ?_⟩
      intro p y u w hp hu hl hw hi
      exact vs.step _ _ _ _ hp hu hl hw (by omega)
    let n := (x+C s).toNat
    have hn : (n : Int) = x+C s := by dsimp [n,x]; omega
    have offer := fills unit hs up n 0 x src (by omega)
    rw [same] at offer
    have arg : -e t + e t = 0 := by omega
    have distance : x - d t + e t + d t - e t = x := by omega
    have received := (v t).call (-e t) (x-d t+e t) n dst (by simpa only [arg, distance] using offer)
    unfold band at received
    dsimp [x] at *
    omega
  · -- With decreasing slack the sender's floor is stationary. Place the
    -- parent at its floor boundary, so even a one-unit payload is too high.
    have zero : e s = 0 := by omega
    apply Classical.byContradiction
    intro bad
    let x := d t - L
    have hp : allows (C s) L (e s) (d s) x := by unfold allows; omega
    have child := (v s).base (0+e s) (x+d s-e s) ((v s).recur 0 x hp)
    have validCall := (v s).call 0 x 0 hp child
    have one := (v s).step 0 x 0 1 hp child validCall
      (by unfold band; dsimp [x]; omega) (by omega)
    rw [same] at one
    have dst : allows (C t) L (e t) (d t) (e t-L) := by unfold allows; omega
    have arg : -e t + e t = 0 := by omega
    have dist : e t - L + d t - e t = x := by dsimp [x]; omega
    have received := (v t).call (-e t) (e t-L) 1 dst (by simpa only [arg,dist] using one)
    unfold band at received
    omega

theorem shared_iff {Mode Key : Type} {key : Mode → Key} {C e d : Mode → Int}
    {L stride : Int} (inc : 1 ≤ stride)
    (admitted : ∀ s, 0 ≤ e s ∧ e s ≤ max 0 (d s) ∧ d s ≤ L - C s) :
    (∃ Q, Shared key C e d L stride Q) ↔ CoversKeys key C d L :=
  ⟨fun ⟨_, v⟩ => shared_necessary v inc admitted, common_contract⟩

-- At e = n+2, d = 2e-2 the crossing caps have zero spare capacity.
-- Any shared key on this single program distinguishes all natural numbers.
def edgeRate (n : Nat) : Int := (n : Int) + 2
def edgeShift (n : Nat) : Int := 2 * edgeRate n - 2
def edgeCap (n : Nat) : Int := min 19 (22 - 2 * edgeRate n)

theorem edge_key_injective {Key : Type} {key : Nat → Key} {Q}
    (v : Shared key edgeCap edgeRate edgeShift 20 1 Q) :
    ∀ a b, key a = key b → a = b := by
  have adm : ∀ n, 0 ≤ edgeRate n ∧ edgeRate n ≤ max 0 (edgeShift n) ∧
      edgeShift n ≤ 20 - edgeCap n := by
    intro n; unfold edgeRate edgeShift edgeCap edgeRate; omega
  have covered := shared_necessary v (by decide) adm
  intro a b h
  have ab := covered a b h
  have ba := covered b a h.symm
  unfold edgeCap edgeShift edgeRate at ab ba
  omega

-- Three actual integer modes of the crossing-cap program. Each endpoint
-- can share a class with the middle mode, but not with the other endpoint.
inductive Mode3 | left | middle | right

def rate3 : Mode3 → Int | .left => 3 | .middle => 4 | .right => 4
def shift3 : Mode3 → Int | .left => 4 | .middle => 4 | .right => 6
def cap3 (s : Mode3) : Int := min 19 (22 - 2 * rate3 s)
def sameRate3 (s : Mode3) : Int := rate3 s
def sameShift3 (s : Mode3) : Int := shift3 s

theorem rate3_suffices : ∃ Q, Shared sameRate3 cap3 rate3 shift3 20 1 Q := by
  apply common_contract
  intro s t; cases s <;> cases t <;> decide

theorem shift3_suffices : ∃ Q, Shared sameShift3 cap3 rate3 shift3 20 1 Q := by
  apply common_contract
  intro s t; cases s <;> cases t <;> decide

theorem no_common_coarsening {Key : Type} {key : Mode3 → Key}
    (forRate : ∀ s t, sameRate3 s = sameRate3 t → key s = key t)
    (forShift : ∀ s t, sameShift3 s = sameShift3 t → key s = key t) :
    ¬ ∃ Q, Shared key cap3 rate3 shift3 20 1 Q := by
  rintro ⟨Q, valid⟩
  have admitted : ∀ s, 0 ≤ rate3 s ∧ rate3 s ≤ max 0 (shift3 s) ∧
      shift3 s ≤ 20-cap3 s := by intro s; cases s <;> decide
  have lr := (forShift .left .middle rfl).trans (forRate .middle .right rfl)
  have bound := shared_necessary valid (by decide) admitted .left .right lr
  exact (by decide : ¬ cap3 .left + shift3 .right ≤ 20) bound

-- Even two concrete clients suffice. Allow arbitrary input predicates,
-- including domains much smaller than the greatest one.
theorem two_clients_need_distinct_keys {Key : Type} {a b : Key}
    {S T : Int → Int → Prop} {Q : Key → Int → Int → Int → Prop}
    (source : Valid 16 20 3 4 S (Q a)) (target : Valid 14 20 4 6 T (Q b))
    (sourceClient : S 0 0) (targetClient : T (-4) (-2)) : a ≠ b := by
  intro same
  have offer := fills source (by decide) (by decide) 16 0 0 sourceClient (by decide)
  rw [same] at offer
  have clash := target.call (-4) (-2) 16 targetClient (by simpa using offer)
  exact (by decide : ¬ 4 + (16 : Int) ≤ max (-2+20) 0) clash.2

-- The full crossing-cap program has offset min(19,22-2e).
def ceiling (e : Int) : Int := max 1 (2*e-2)
def feasible (e d : Int) : Prop := 0 ≤ e ∧ e ≤ max 0 d ∧ d ≤ ceiling e
def scalarCovers (a b : Int) : Prop :=
  ∀ e d e' d', feasible e d → feasible e' d' →
    a*e + b*d = a*e' + b*d' → d' ≤ ceiling e

private theorem positive_key {a b : Int} (ha : 0 ≤ a) (hb : 0 ≤ b) (nz : 0 < a+b) :
    scalarCovers a b := by
  intro e d e' d' hs ht same
  apply Classical.byContradiction
  intro bad
  unfold feasible ceiling at *
  have eUp : e < e' := by omega
  have dUp : d < d' := by omega
  have leA := Int.mul_le_mul_of_nonneg_left (Int.le_of_lt eUp) ha
  have leB := Int.mul_le_mul_of_nonneg_left (Int.le_of_lt dUp) hb
  by_cases ap : 0 < a
  · have strictA := Int.mul_lt_mul_of_pos_left eUp ap; omega
  · have strictB := Int.mul_lt_mul_of_pos_left dUp (show 0 < b by omega); omega

private theorem flip_key {a b : Int} (h : scalarCovers a b) : scalarCovers (-a) (-b) := by
  intro e d e' d' hs ht same
  apply h e d e' d' hs ht
  simp only [Int.neg_mul] at same
  omega

private theorem mixed_key {v u : Int} (hv : 0 < v) (hu : 0 < u) : ¬ scalarCovers v (-u) := by
  intro h
  let E := v+2*u+3
  let D := 2*E-2 - max 0 (v-2*u)
  have hs : feasible E D := by unfold feasible ceiling; dsimp [D,E]; omega
  have ht : feasible (E+u) (D+v) := by unfold feasible ceiling; dsimp [D,E]; omega
  have same : v*E+(-u)*D = v*(E+u)+(-u)*(D+v) := by
    simp only [Int.mul_add, Int.neg_mul]
    rw [Int.mul_comm u v]
    omega
  have covered := h _ _ _ _ hs ht same
  unfold ceiling at covered
  dsimp [D,E] at covered
  omega

theorem affine_keys (a b : Int) :
    scalarCovers a b ↔
    (0 ≤ a ∧ 0 ≤ b ∧ 0 < a+b) ∨ (a ≤ 0 ∧ b ≤ 0 ∧ a+b < 0) := by
  constructor
  · intro h
    by_cases sign : (0 ≤ a ∧ 0 ≤ b ∧ 0 < a+b) ∨ (a ≤ 0 ∧ b ≤ 0 ∧ a+b < 0)
    · exact sign
    · exfalso
      by_cases ap : 0 < a
      · have fail := mixed_key ap (show 0 < -b by omega)
        exact fail (by simpa using h)
      by_cases bp : 0 < b
      · have fail := mixed_key (show 0 < -a by omega) bp
        exact fail (flip_key h)
      have za : a = 0 := by omega
      have zb : b = 0 := by omega
      subst a; subst b
      have clash := h 3 4 4 6 (by unfold feasible ceiling; decide)
        (by unfold feasible ceiling; decide) (by decide)
      exact (by decide : ¬ 6 ≤ max (1 : Int) (2*3-2)) clash
  · rintro (⟨ha,hb,nz⟩ | ⟨ha,hb,nz⟩)
    · exact positive_key ha hb nz
    · have pos := positive_key (show 0 ≤ -a by omega) (show 0 ≤ -b by omega)
        (show 0 < -a + -b by omega)
      simpa using flip_key pos

abbrev CrossingMode := {r : Int × Int // feasible r.1 r.2}
def floorRate (s : CrossingMode) := s.val.1
def capRate (s : CrossingMode) := s.val.2
def capOffset (s : CrossingMode) := min 19 (22-2*floorRate s)

theorem scalar_interface_exact (a b : Int) :
    (∃ Q, Shared (fun s => a*floorRate s+b*capRate s)
      capOffset floorRate capRate 20 1 Q) ↔
    (0 ≤ a ∧ 0 ≤ b ∧ 0 < a+b) ∨ (a ≤ 0 ∧ b ≤ 0 ∧ a+b < 0) := by
  have adm : ∀ s, 0 ≤ floorRate s ∧ floorRate s ≤ max 0 (capRate s) ∧
      capRate s ≤ 20-capOffset s := by
    rintro ⟨⟨e,d⟩,h⟩
    simp only [floorRate, capRate, capOffset]
    unfold feasible ceiling at h; omega
  rw [shared_iff (by decide) adm, ← affine_keys]
  constructor
  · intro h e d e' d' hs ht same
    have bound := h ⟨(e,d),hs⟩ ⟨(e',d'),ht⟩ same
    simp only [capOffset, floorRate, capRate] at bound
    unfold ceiling; omega
  · rintro h ⟨⟨e,d⟩,hs⟩ ⟨⟨e',d'⟩,ht⟩ same
    have bound := h e d e' d' hs ht same
    simp only [capOffset, floorRate, capRate]
    unfold ceiling at bound; omega

-- Interpolate between a supplier arm b and the caller cap h. The first
-- arm c stays visible. The result needs only the combination a*b+k*h.
def weightedBand (a k c b h x t : Int) : Prop :=
  0 ≤ t ∧ t ≤ max 0 (x+c) ∧
    (a+k)*t ≤ max 0 ((a+k)*x + (a*b+k*h))

private theorem band_to_weighted {a k c b h x t : Int} (ha : 0 ≤ a) (hk : 0 ≤ k)
    (hc : min c b ≤ h) (v : band (min c b) x t) : weightedBand a k c b h x t := by
  unfold band at v
  unfold weightedBand
  refine ⟨v.1, by omega, ?_⟩
  by_cases zero : t = 0
  · subst t; simp only [Int.mul_zero]; omega
  · have l := Int.mul_le_mul_of_nonneg_left (show t ≤ x+b by omega) ha
    have r := Int.mul_le_mul_of_nonneg_left (show t ≤ x+h by omega) hk
    simp only [Int.add_mul, Int.mul_add] at *
    omega

private theorem weighted_to_band {a k c b h x t : Int} (ha : 0 ≤ a)
    (nz : 0 < a+k) (hc : min c b ≤ h) (v : weightedBand a k c b h x t) : band h x t := by
  unfold weightedBand at v
  unfold band
  refine ⟨v.1, ?_⟩
  by_cases left : c ≤ h
  · omega
  · apply Classical.byContradiction
    intro bad
    have b_le := Int.mul_le_mul_of_nonneg_left (show b ≤ h by omega) ha
    have pos := Int.mul_pos nz (show 0 < t by omega)
    have gt := Int.mul_lt_mul_of_pos_left (show x+h < t by omega) nz
    simp only [Int.mul_add, Int.add_mul] at *
    omega

theorem weighted_cap_scheme (a k c b L e d stride : Int)
    (ha : 0 ≤ a) (hk : 0 ≤ k) (nz : 0 < a+k) :
    TwoCaps c b L e d stride (fun _ x => allows (min c b) L e d x)
      (fun _ x t => weightedBand a k c b (L-d) x t) := by
  have caller := caller_cap_scheme c b L e d stride
  refine ⟨caller.recur, ?_, ?_, ?_⟩
  · intros; unfold weightedBand; simp only [Int.mul_zero]; omega
  · intro p x u hp hu
    exact caller.call p x u hp (weighted_to_band ha nz (by unfold allows at hp; omega) hu)
  · intro p x u v hp hu hl hv vc vb vi
    apply band_to_weighted ha hk (by unfold allows at hp; omega)
    unfold band
    omega

-- At a mode with nondecreasing slack, every sufficient simple band must
-- put its offset between the supplier cap and the caller cap.
theorem simple_band_bounds {C L e d H stride : Int} (inc : 1 ≤ stride)
    (he : 0 ≤ e) (up : e ≤ d) (admit : d ≤ L-C)
    (v : GridValid C L e d stride (fun _ x => allows C L e d x)
      (fun _ x t => band H x t)) : C ≤ H ∧ H ≤ L-d := by
  let x := max (-C) (max (-H) (max (d-L) (e-L)))
  have src : allows C L e d x := by unfold allows; dsimp [x]; omega
  have dst : allows C L e d (x-d+e) := by unfold allows; dsimp [x]; omega
  have unit : Valid C L e d (fun _ x => allows C L e d x)
      (fun _ x t => band H x t) := by
    refine ⟨v.recur, v.base, v.call, ?_⟩
    intro p y t w hp ht hl hw hi
    exact v.step p y t w hp ht hl hw (by omega)
  let n := (x+C).toNat
  have hn : (n : Int) = x+C := by dsimp [n,x]; omega
  have offered : band H x n := fills unit he up n 0 x src (by omega)
  have upper := v.call (-e) (x-d+e) (x+H) dst (by unfold band; dsimp [x]; omega)
  unfold band at offered upper
  dsimp [x] at *
  omega

-- The two low modes and one high mode have singleton offset intervals.
-- q clears the denominators of an affine offset in the captured key.
theorem single_affine_cap_impossible {a b q g h : Int} (ha : a ≠ 0) (hq : 0 < q) :
    ¬ (g*b+h = 19*q ∧ g*(a+b)+h = 19*q ∧ g*(3*a+4*b)+h = 16*q) := by
  rintro ⟨lowLeft, lowRight, high⟩
  have prod : g*a = 0 := by rw [Int.mul_add] at lowRight; omega
  have zero : g = 0 := (Int.mul_eq_zero.mp prod).resolve_right ha
  subst g
  simp only [Int.zero_mul, Int.zero_add] at *
  omega

-- An explicit two-cap result using only z=e+d as its extra parameter.
theorem sum_cap_scheme (q e d : Int) (hq : 0 < q) :
    TwoCaps (19*q) (22*q-2*e) (20*q) e d q
      (fun _ x => allows (min (19*q) (22*q-2*e)) (20*q) e d x)
      (fun _ x t => 0 ≤ t ∧ t ≤ max 0 (x+19*q) ∧
        3*t ≤ max 0 (3*x+62*q-2*(e+d))) := by
  constructor
  · unfold allows; intros; omega
  · intros; omega
  · intro p x u hp hu
    unfold allows at hp
    unfold band
    by_cases low : d ≤ q <;> omega
  · intro p x u v hp hu hl vz vc vb vi
    unfold allows at hp
    by_cases low : d ≤ q <;> omega

end MovingFloor

namespace Abduction
-- The candidate and its witnesses have the same interpretation in both uses
-- of E. Quantifying fresh witnesses separately would change this equivalence.
theorem separate_equations {State : Type} (A P E D : State → Prop) :
    (∀ s, A s → P s → E s ∧ D s) ↔
      (∀ s, A s → P s → E s) ∧ (∀ s, A s → P s → E s → D s) := by
  constructor
  · intro h
    exact ⟨fun s a p => (h s a p).1, fun s a p _ => (h s a p).2⟩
  · rintro ⟨eqs, rest⟩ s a p
    exact ⟨eqs s a p, rest s a p (eqs s a p)⟩

end Abduction
