(* Tab-separated live formulas, then "--", then forbidden formulas.
   Print how many live branches retain a witness and how many forbidden
   branches are excluded by the complete returned precondition. *)
open Defs
open NumDefs
let q = {cmp_v=(fun _ _ -> Same_quant); uni_v=(fun _ -> false);
         same_as=(fun _ _ -> ()); upward_of=(fun _ _ -> false)}
let formula s = NumS.sort_formula (Parser.formula Lexer.token (Lexing.from_string s))

let run line =
  let rec inputs live = function
    | [] -> failwith "missing --"
    | "--" :: bad -> List.rev live, List.map formula bad
    | first :: rest -> inputs (formula first :: live) rest in
  let live,bad = inputs [] (String.split_on_char '\t' line) in
  let states = List.map NumS.satisfiable_exn live in
  let answer = NumS.negation_elim q ~bvs:VarSet.empty ~verif_cns:states
      (List.map (fun phi -> phi,dummy_loc) bad) in
  let sat facts = match NumS.satisfiable (facts @ answer) with Aux.Right _ -> true | Aux.Left _ -> false in
  let all = List.fold_left (fun vars phi -> VarSet.union vars (fvs_formula phi)) VarSet.empty bad in
  assert (VarSet.subset (fvs_formula answer) all);
  Printf.printf "%d %d\n" (List.length (List.filter sat live))
    (List.length (List.filter (fun facts -> not (sat facts)) bad))

let () = try while true do run (read_line ()) done with End_of_file -> ()
