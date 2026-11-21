(* Build as src/Audit.ml. Read alternating guard/formula lines, then write
   guard, original and pruned result as three tab-separated SMT expressions. *)
open NumDefs

let q = {
  Defs.cmp_v = (fun _ _ -> Defs.Same_quant);
  uni_v = (fun _ -> false);
  same_as = (fun _ _ -> ());
  upward_of = (fun _ _ -> false);
}

let parse s =
  NumS.sort_formula (Parser.formula Lexer.token (Lexing.from_string s))

let rational a b =
  let numerator =
    if a < 0 then Printf.sprintf "(- %d)" (-a) else string_of_int a in
  Printf.sprintf "(/ %s %d)" numerator b

let rec term = function
  | Cst (a, b) -> rational a b
  | Lin (a, b, v) -> Printf.sprintf "(* %s %s)" (rational a b) (Defs.var_str v)
  | Add [] -> "0"
  | Add ts -> "(+ " ^ String.concat " " (List.map term ts) ^ ")"

let atom = function
  | Eq (a, b, _) -> Printf.sprintf "(= %s %s)" (term a) (term b)
  | Leq (a, b, _) -> Printf.sprintf "(<= %s %s)" (term a) (term b)
  | Subopti (a, b, _) ->
      Printf.sprintf "(or (<= %s 0) (<= %s 0))" (term a) (term b)
  | Opti (a, b, _) ->
      let a = term a and b = term b in
      Printf.sprintf "(and (<= %s 0) (<= %s 0) (or (= %s 0) (= %s 0)))" a b a b

let smt = function
  | [] -> "true"
  | xs -> "(and " ^ String.concat " " (List.map atom xs) ^ ")"

let () =
  try while true do
    let guard = parse (read_line ()) in
    let formula = parse (read_line ()) in
    try
      let result = NumS.prune_redundant q ~guard ~initstep:false formula in
      Printf.printf "%s\t%s\t%s\n" (smt guard) (smt formula) (smt result)
    with exn -> Printf.printf "error %s\n" (Printexc.to_string exn)
  done with End_of_file -> ()
