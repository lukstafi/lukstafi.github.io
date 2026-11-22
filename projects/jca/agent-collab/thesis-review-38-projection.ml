(* Read a mask of hidden coordinates and a numeric formula on one line.
   Print the existential projection as SMT-LIB for independent comparison. *)
open Defs
open NumDefs

let coords = ["i"; "j"; "k"; "l"]
let app op terms = "(" ^ String.concat " " (op :: terms) ^ ")"
let int n =
  let s = string_of_int n in
  if n < 0 then app "-" [String.sub s 1 (String.length s - 1)] else s
let frac n d = app "/" [int n; int d]
let rec term = function
  | Cst (n,d) -> frac n d
  | Lin (n,d,VNam (Num_sort,x)) -> app "*" [frac n d; x]
  | Add ts -> app "+" (List.map term ts)
  | Lin _ -> failwith "unexpected coordinate"
let atom = function
  | Eq (a,b,_) -> app "=" [term a;term b]
  | Leq (a,b,_) -> app "<=" [term a;term b]
  | Subopti (a,b,_) -> app "or" [app "<=" [term a;"0"];app "<=" [term b;"0"]]
  | Opti (a,b,_) -> app "and" [app "<=" [term a;"0"];app "<=" [term b;"0"];
      app "or" [app "=" [term a;"0"]; app "=" [term b;"0"]]]
let conjunction = function [] -> "true" | atoms -> app "and" (List.map atom atoms)

let run line =
  let split = String.index line ' ' in
  let mask = int_of_string (String.sub line 0 split) in
  let source = String.sub line (split+1) (String.length line - split-1) in
  let vars = List.fold_left (fun acc (n,x) ->
      if mask land (1 lsl n) <> 0 then VarSet.add (VNam (Num_sort,x)) acc else acc)
      VarSet.empty (List.mapi (fun n x -> n,x) coords) in
  let phi = NumS.sort_formula (Parser.formula Lexer.token (Lexing.from_string source)) in
  let cells = NumS.project_exists ~vars phi in
  List.iter (List.iter (fun a ->
      assert (VarSet.is_empty (VarSet.inter vars (fvs_atom a))))) cells;
  match cells with [] -> "false" | _ -> app "or" (List.map conjunction cells)

(* A linear-size lifted description of the keys with ternary digits 0 or 2. *)
let digit_example n =
  if n < 0 then invalid_arg "--digits requires a nonnegative length";
  let variable s = VNam (Num_sort,s) in
  let v x = Lin (1,1,x) and zero = Cst (0,1) and two = Cst (2,1) in
  let rec rows index sum vars phi =
    if index=n then
      NumS.project_exists ~vars (Eq (v (variable "k"),sum,dummy_loc)::phi)
    else
      let digit = variable ("j" ^ string_of_int index)
      and next = variable ("i" ^ string_of_int index) in
      let b = v digit in
      let phi = Leq (zero,b,dummy_loc) :: Leq (b,two,dummy_loc) ::
        Subopti (b, diff two b,dummy_loc) ::
        Eq (v next, Add [sum;sum;sum;b],dummy_loc) :: phi in
      rows (index+1) (v next) (VarSet.add digit (VarSet.add next vars)) phi in
  let cells = rows 0 zero VarSet.empty [] in
  Printf.printf "%d\n" (List.length cells);
  List.iter (fun cell -> print_endline (conjunction cell)) cells

let () =
  if Array.length Sys.argv=3 && Sys.argv.(1)="--digits" then
    digit_example (int_of_string Sys.argv.(2))
  else try while true do print_endline (run (read_line ())) done with End_of_file -> ()
