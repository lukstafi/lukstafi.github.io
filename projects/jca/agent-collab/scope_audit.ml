(* Compare the quantified type unifier with ordinary unification in which
   universals are represented by distinct private constructor symbols. *)
open Defs
open Terms

let variables = List.map (fun name -> VNam (Type_sort, name)) ["x"; "y"; "z"]
let rigid_names = List.map (fun v -> CNam ("Skolem_" ^ var_str v)) variables

let rank variable =
  let rec index position = function
    | [] -> invalid_arg "unknown prefix variable"
    | v :: _ when v = variable -> position
    | _ :: tail -> index (position + 1) tail in
  index 0 variables

let reference q equations =
  let freeze = List.fold_left2 (fun subst v name ->
      if q.uni_v v then VarMap.add v (TCons (name, []), dummy_loc) subst
      else subst) VarMap.empty variables rigid_names in
  let solved = (unify empty_q (subst_formula freeze equations)).cnj_typ in
  let rec in_scope v = function
    | TVar _ -> true
    | TCons (name, args) ->
      List.for_all2 (fun u rigid -> name <> rigid || rank u < rank v) variables rigid_names
      && List.for_all (in_scope v) args
    | _ -> invalid_arg "outside the test grammar" in
  List.for_all (fun v ->
      q.uni_v v || in_scope v (subst_typ solved (TVar v))) variables

let accepts f = try f () with Contradiction _ -> false

let () =
  let vars = List.map (fun v -> TVar v) variables in
  let terms = vars @ [TCons (CNam "A", []); TCons (CNam "B", [])]
              @ List.map (fun t -> TCons (CNam "F", [t])) vars in
  let atoms = List.concat (List.map (fun t ->
      List.map (fun u -> Eqty (t, u, dummy_loc)) terms) terms) in
  let count = ref 0 and spurious = ref 0 and missed = ref 0 in
  for mask = 0 to 7 do
    let q = {empty_q with
             uni_v = (fun v -> mask land (1 lsl rank v) <> 0);
             cmp_v = (fun a b ->
               if a = b then Same_quant else if rank a < rank b then Left_of else Right_of)} in
    List.iter (fun a -> List.iter (fun b ->
        let equations = [a; b] in
        let actual = accepts (fun () -> ignore (unify ~use_quants:true q equations); true)
        and expected = accepts (fun () -> reference q equations) in
        incr count;
        if actual && not expected then incr spurious;
        if expected && not actual then incr missed) atoms) atoms
  done;
  Printf.printf "%d cases, %d false acceptances, %d false rejections\n" !count !spurious !missed;
  if !spurious <> 0 || !missed <> 0 then exit 1
