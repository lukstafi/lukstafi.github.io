(* GADT examples from Dependent Types from Rocq to Lean 4. *)

type z = Z
type 'n s = S of 'n

type (_, _) vec =
  | VNil : (z, 'a) vec
  | VCons : 'a * ('n, 'a) vec -> ('n s, 'a) vec

let head_vec : type n a. (n s, a) vec -> a = function
  | VCons (x, _) -> x


type (_, _, _) plus =
  | PlusZ : (z, 'm, 'm) plus
  | PlusS : ('n, 'm, 'k) plus -> ('n s, 'm, 'k s) plus

let rec append : type n m k a.
    (n, m, k) plus -> (n, a) vec -> (m, a) vec -> (k, a) vec =
  fun sum xs ys ->
    match sum, xs with
    | PlusZ, VNil -> ys
    | PlusS smaller, VCons (x, rest) ->
        VCons (x, append smaller rest ys)
