(* Build this file as Guard_probe.native in InvarGenT's src directory. *)
open Defs

let parse text =
  if text = "-" then [] else Parser.formula Lexer.token (Lexing.from_string text)

let query line = match String.split_on_char '\t' line with
  | [prefix; facts; parent; conditional; guard] ->
    let moves = List.mapi (fun i move ->
        String.sub move 1 (String.length move - 1), (i, move.[0] = 'A'))
        (String.split_on_char ',' prefix) in
    let position v = List.assoc (var_str v) moves in
    let cmp_v v w =
      let i, _ = position v and j, _ = position w in
      if i = j then Same_params else if i < j then Left_of else Right_of in
    let q = {empty_q with cmp_v; uni_v = (fun v -> snd (position v))} in
    let required = Invariants.forced_call_guard q [[], parse facts; parse parent, parse conditional] in
    print_endline (string_of_bool (required (parse guard)))
  | _ -> invalid_arg "expected prefix, facts, parent guard, consequence and call guard"

let () = try while true do query (read_line ()) done with End_of_file -> ()
