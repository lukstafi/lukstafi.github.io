(* One tab-separated problem per line: premise, package, then one field per
   admission cell. By default j,k are keys and m,n are witnesses. *)
open Defs

let names xs = vars_of_list (List.map (fun s -> VNam (Num_sort,s)) xs)
let formula s = NumS.sort_formula (Parser.formula Lexer.token (Lexing.from_string s))

let run keys witnesses line = match List.map formula (String.split_on_char '\t' line) with
  | pre :: post :: admissions ->
    NumS.common_result_possible ~keys ~witnesses
      ~admissions ~post pre
  | _ -> failwith "expected a premise and a package"

let () =
  let keys = ref "j,k" and witnesses = ref "m,n" in
  Arg.parse ["--keys", Arg.Set_string keys, "comma-separated tuple coordinates";
             "--witnesses", Arg.Set_string witnesses, "comma-separated private coordinates"]
    (fun arg -> raise (Arg.Bad arg)) "Read tab-separated numeric problems from stdin.";
  let variables s = names (if s="" then [] else String.split_on_char ',' s) in
  let keys = variables !keys and witnesses = variables !witnesses in
  try while true do
    print_endline (if run keys witnesses (read_line ()) then "sat" else "unsat")
  done with End_of_file -> ()
