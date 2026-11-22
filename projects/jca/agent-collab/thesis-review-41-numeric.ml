(* One tab-separated problem per line: observed term, premise, package,
   then one field per admission cell. j,k are keys and m,n are witnesses. *)
open Defs

let names xs = vars_of_list (List.map (fun s -> VNam (Num_sort,s)) xs)
let formula s = NumS.sort_formula (Parser.formula Lexer.token (Lexing.from_string s))
let term s = match formula ("0=" ^ s) with
  | [NumDefs.Eq (_,t,_)] -> t | _ -> failwith "expected a numeric term"

let run line = match String.split_on_char '\t' line with
  | value :: pre :: post :: cells ->
    let possible = NumS.common_result_possible ~keys:(names ["j";"k"])
        ~witnesses:(names ["m";"n"]) ~admissions:(List.map formula cells) ~post:(formula post) in
    let verdict b = if b then "sat" else "unsat" in
    let pre = formula pre in
    Printf.printf "%s %s\n" (verdict (possible pre))
      (verdict (possible ~integer_result:(term value) pre))
  | _ -> failwith "expected an observation, premise and package"

let () = try while true do run (read_line ()) done with End_of_file -> ()
