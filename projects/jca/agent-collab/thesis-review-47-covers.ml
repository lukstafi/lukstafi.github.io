(* One tab-separated query per line. The first field is the target menu.
   The remaining fields are its prospective sources. Public indices
   (including keys) agree across fields. Each menu has private m,n. *)
open Defs

let formula s = NumS.sort_formula (Parser.formula Lexer.token (Lexing.from_string s))
let private_vars = vars_of_list [VNam (Num_sort,"m"); VNam (Num_sort,"n")]
let cells text = NumS.project_exists ~vars:private_vars (formula text)
let impossible = formula "1=0"

let test line = match String.split_on_char '\t' line with
  | target :: sources ->
    let exclusions = List.map (fun cell -> cell,impossible) (List.concat (List.map cells sources)) in
    List.for_all (fun cell -> not (NumS.conditional_satisfiable cell exclusions)) (cells target)
  | [] -> failwith "expected a target menu"

let () = try while true do
  print_endline (if test (read_line ()) then "covered" else "gap")
done with End_of_file -> ()
