(* One requested bound, then the supplier cells, separated by tabs.
   l, m, n are results. All other coordinates are captured parameters. *)
open Defs
open NumDefs

let q = {cmp_v=(fun _ _ -> Same_quant); uni_v=(fun _ -> false);
         same_as=(fun _ _ -> ()); upward_of=(fun _ _ -> false)}
let numeric s = NumS.sort_formula (Parser.formula Lexer.token (Lexing.from_string s))
let results = vars_of_list (List.map (fun x -> VNam (Num_sort,x)) ["l";"m";"n"])
let run line = match String.split_on_char '\t' line with
  | goal :: (_ :: _ as cells) ->
    let cells = List.map numeric cells and goal = numeric goal in
    let parameters = VarSet.diff (vars_of_map fvs_formula cells) results in
    let preserve = VarSet.union results parameters in
    let join () =
      let _,_,summary,_ = NumS.disjelim q ~target_vs:results ~preserve
          ~bvs:VarSet.empty ~param_bvs:parameters ~guess:false ~initstep:false
          (List.map (fun p -> [],p) cells) in
      if NumS.implies_cnj (NumS.satisfiable_exn summary) goal then summary
      else raise (Terms.NoAnswer (Num_sort,"caller bound missing",None,dummy_loc)) in
    (try
       let summary = NumS.with_affine_retry join in
       let linear = List.filter (function Eq _ | Leq _ -> true | _ -> false) summary in
       List.iter (fun a ->
           Printf.printf "\t%s" (String.concat " " (String.split_on_char '\n'
             (Format.asprintf "%a" pr_atom a)))) linear;
       print_newline ()
     with Terms.NoAnswer (_, "caller bound missing", _, _) -> print_endline "missing")
  | _ -> invalid_arg "expected a goal and at least one supplier"

let () = try while true do run (read_line ()) done with End_of_file -> ()
