open Defs
open NumDefs

let q = Defs.empty_q
let parse text = NumS.sort_formula (Parser.formula Lexer.token (Lexing.from_string text))

let rec subsets = function
  | [] -> [VarSet.empty]
  | x :: xs ->
    let sets = subsets xs in
    sets @ List.map (VarSet.add x) sets

let checked = ref 0
let weaker = ref 0
let stronger = ref 0
let errors = ref 0

let audit source =
  let sets = subsets (VarSet.elements (fvs_formula source)) in
  let input = NumS.satisfiable_exn source in
  List.iter (fun bvs -> List.iter (fun keep ->
    List.iter (fun no_csts -> List.iter (fun apply ->
      incr checked;
      let _, sb, residual = NumS.separate_subst q ~bvs ~keep ~no_csts ~apply source in
      let output = VarMap.fold (fun v t phi -> Eq (Lin (1,1,v), t, dummy_loc) :: phi)
          sb residual in
      if not (NumS.implies_cnj input output) then incr stronger;
      if not (NumS.implies_cnj (NumS.satisfiable_exn output) source) then (
        if !weaker < 2 then Format.printf "lost equation in %a@.returned %a@."
            pr_formula source pr_formula output;
        incr weaker)) [false; true]) [false; true]) sets) sets

let () =
  let atoms = List.map parse ["n1=n2"; "n2=n3"; "n3=n1"; "n1=n2+n3";
      "n2=n1+n3"; "n1=1"; "n2=1"; "n3=1"; "n2=0"; "n1=n2+1";
      "n1=n2+n2"; "2 n1=n2+n3"; "n1<=n3"; "n3<=max(n1,n2)"] in
  let audit_if_sat f = match NumS.satisfiable f with
    | Aux.Left _ -> ()
    | Aux.Right _ -> try audit f with Terms.Contradiction _ -> incr errors in
  List.iter (fun a -> List.iter (fun b -> audit_if_sat (a @ b)) atoms) atoms;
  List.iter (fun text -> audit_if_sat (parse text))
    ["n1=n2+n3 ∧ n1=n4+n5"; "n1=n2+n3 ∧ n1=n4+n5 ∧ n2<=n5";
     "n1=1 ∧ n2=1 ∧ n3=1"; "n1=n2+n3 ∧ n2=n3 ∧ n1<=n4"];
  Printf.printf "%d comparisons, %d weaker, %d stronger, %d exceptions\n"
    !checked !weaker !stronger !errors;
  if !weaker + !stronger + !errors <> 0 then exit 1
