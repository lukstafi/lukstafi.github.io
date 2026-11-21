/- Raw equational answers for ∃ data ∀ arguments ∃ result, with arbitrary
   leading fresh variables. Lean 4.19.0; build instructions in the note. -/
import «round-14-reduction»
namespace JCA.Prefix
open Tree

def play (b : Nat → Ground) (d : Fin n → Ground) (h : Fin k → Ground) (y : Ground) :
    AnswerVar n k → Ground
  | .inr j => b j
  | .inl (.data i) => d i
  | .inl (.arg j) => h j
  | .inl .body => y

def Valid (A : List (Eqn (AnswerVar n k))) : Prop :=
  ∀ b, ∃ d, ∀ h, ∃ y, Holds (play b d h y) A

def graph (d : Fin n → Ground) (body : Tree (Fin k)) : List (Eqn (AnswerVar n k)) :=
  (.var (.inl .body), body.bind (fun j => .var (.inl (.arg j)))) ::
  List.ofFn (fun i => (.var (.inl (.data i)), (d i).closed))

theorem holds_graph (e : AnswerVar n k → Ground) :
    Holds e (graph d body) ↔
    (e (.inl .body) = body.bind (fun j => e (.inl (.arg j)))) ∧
    ∀ i, e (.inl (.data i)) = d i := by
  simp [Holds, graph, Tree.bind, Tree.bind_bind, List.mem_ofFn]

theorem graph_valid (d : Fin n → Ground) (body : Tree (Fin k)) : Valid (graph d body) := by
  intro b
  exact ⟨d, fun h => ⟨body.bind h, (holds_graph _).mpr ⟨rfl, fun _ => rfl⟩⟩⟩

def HasPrefixAnswer (I : Instance n k) : Prop :=
  ∃ A, Valid A ∧ ∀ s ∈ I.samples, RawPass A (evaluation s)

theorem from_solution {I : Instance n k} (sol : Solvable I) : HasPrefixAnswer I := by
  obtain ⟨d, body, _, calls⟩ := sol
  refine ⟨graph d body, graph_valid d body, ?_⟩
  intro s hs
  let h (j : Fin k) := (s.args j).bind d
  let e := play (fun _ => .a) d h (body.bind h)
  constructor
  · refine ⟨e, (holds_graph _).mpr ⟨rfl, fun _ => rfl⟩, (holds_args _ _).mpr ?_⟩
    intro j
    change h j = (extendData (s.args j)).bind _
    rw [eval_extendData]; rfl
  · intro env ha he
    obtain ⟨ey, ed⟩ := (holds_graph env).mp ha
    have eh := (holds_args _ _).mp he
    change ∀ j, env (.inl (.arg j)) = (extendData (s.args j)).bind _ at eh
    simp only [eval_extendData, ed] at eh
    apply (holds_evaluation _ s).mpr
    simp only [ey, ed, eh]
    exact calls s hs

/-- Prefix validity alone supplies both guard witnesses for the old reduction. -/
theorem from_answer {I : Instance n k} (noDataEqs : I.equations = [])
    (ans : HasPrefixAnswer I) : Solvable I := by
  obtain ⟨A,valid,calls⟩ := ans
  obtain ⟨d, cover⟩ := valid (fun _ => .a)
  apply solution_of_raw
  refine ⟨A, ?_⟩
  intro br mem
  simp only [compile, List.mem_cons, List.mem_map] at mem
  rcases mem with rfl | rfl | ⟨s,hs,rfl⟩
  · obtain ⟨y, ha⟩ := cover (fun _ => .a)
    refine ⟨⟨_, ha, (holds_args _ _).mpr (fun _ => rfl)⟩, ?_⟩
    intro e _ _
    simp [pin, noDataEqs, firstOrder, Holds]
  · let h (j : Fin k) := raised (j.val+1) (packed (List.ofFn d))
    obtain ⟨y, ha⟩ := cover h
    refine ⟨⟨_, ha, (holds_args _ _).mpr ?_⟩, ?_⟩
    · intro j
      change h j = (raised _ (packed (dataList n k))).bind _
      rw [eval_raised, eval_dataPack]; rfl
    · intro e _ _ lr hm; contradiction
  · exact calls s hs

theorem prefix_interpolation (I : Instance n k) (noDataEqs : I.equations = []) :
    Solvable I ↔ HasPrefixAnswer I := ⟨from_solution, from_answer noDataEqs⟩

#print axioms prefix_interpolation
end JCA.Prefix
