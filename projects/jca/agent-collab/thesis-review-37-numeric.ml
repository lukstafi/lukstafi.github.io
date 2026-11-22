(* One line per numeric problem. Each affine term is given by the two
   variable coefficients and its constant. Each formula starts with its size. *)
open Defs
open NumDefs

let run line =
  let input = ref (List.map int_of_string (String.split_on_char ' ' line)) in
  let take () = match !input with n::rest -> input := rest; n | [] -> failwith "short input" in
  let term () =
    let a = take () in let b = take () in let c = take () in
    Add [Lin (a,1,VNam (Num_sort,"i")); Lin (b,1,VNam (Num_sort,"j")); Cst (c,1)] in
  let atom () =
    let op = take () in let a = term () in let b = term () in
    match op with
    | 0 -> Leq (a,b,dummy_loc) | 1 -> Eq (a,b,dummy_loc)
    | 2 -> Subopti (a,b,dummy_loc) | 3 -> Opti (a,b,dummy_loc)
    | _ -> failwith "unknown numeric atom" in
  let formula () = List.init (take ()) (fun _ -> atom ()) in
  let premise = formula () in
  let clauses = List.init (take ()) (fun _ -> let admission = formula () in admission,formula ()) in
  if !input<>[] then failwith "extra input";
  NumS.conditional_satisfiable premise clauses

let () =
  try while true do
    let line = read_line () in
    print_endline (if run line then "sat" else "unsat")
  done with End_of_file -> ()
