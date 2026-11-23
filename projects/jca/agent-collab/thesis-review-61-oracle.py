"""Compare NumS.replay_cycle with exact public projection on altered one-fold certificates.

Write --driver to src/ReplayFold.ml in a configured InvarGenT build and compile it
with the same packages as InvarGenT.native. Pass its executable to --checker.
"""
import argparse
from pathlib import Path
import re
import runpy
import subprocess

import z3

REPLAY = runpy.run_path(str(Path(__file__).with_name("thesis-review-61.py")))
DRIVER = """open Defs
open NumDefs
let parsed s = NumS.sort_formula (Parser.formula Lexer.token (Lexing.from_string s))
let term s = match parsed ("n8="^s) with [Eq (_,t,_)] -> t | _ -> failwith "bad term"
let () = try while true do
  let params = List.map (fun name -> VNam (Num_sort,name)) (String.split_on_char ',' (read_line ())) in
  let guard = parsed (read_line ()) in
  let domain = parsed (read_line ()) in
  let fields = List.map (fun f -> List.map term (String.split_on_char ',' f))
      (String.split_on_char '|' (read_line ())) in
  Printf.printf "%b\\n%!" (NumS.replay_cycle ~params ~guard ~fields domain dummy_loc)
done with End_of_file -> ()
"""


def combine(a,b,scale):
    out = dict(a)
    for var,coef in b.items():
        out[var] = out.get(var,0)+scale*coef
    return {k:v for k,v in out.items() if v}


def rows(formula):
    out = []
    for atom in formula.split("∧"):
        left,op,right = re.split("([=≤])",atom)
        row = combine(REPLAY["affine"](left),REPLAY["affine"](right),-1)
        out.append(row)
        if op=="=":
            out.append({v:-x for v,x in row.items()})
    return out


def strongest(bounds):
    parallel = {}
    for w in bounds:
        variables = sorted(v for v in w if v is not None)
        if not variables:
            if w.get(None,0)>0:
                return [{None:1}]
            continue
        scale = abs(w[variables[0]])
        direction = tuple((v,w[v]/scale) for v in variables)
        constant = w.get(None,0)/scale
        parallel[direction] = max(constant,parallel.get(direction,constant))
    return [dict(list(direction)+([(None,c)] if c else [])) for direction,c in parallel.items()]


def project(bounds):
    def private():
        return set().union(*(set(w) for w in bounds))-{None,"i","j","k"}
    while private():
        def cost(v):
            coefficients = [w.get(v,0) for w in bounds]
            return sum(k>0 for k in coefficients)*sum(k<0 for k in coefficients)
        v = min(private(),key=lambda v:(cost(v),v))
        lo = [w for w in bounds if w.get(v,0)<0]
        hi = [w for w in bounds if w.get(v,0)>0]
        keep = [w for w in bounds if v not in w]
        bounds = strongest(keep+[combine(a,b,-a[v]/b[v]) for a in lo for b in hi])
    return bounds


def inductive(bounds,guard,field):
    linear = REPLAY["linear"]
    old = {x:z3.Real(x) for x in "ijk"}
    new = {x:linear(REPLAY["affine"](t),old) for x,t in zip("ijk",field.split(","))}
    parent = z3.And([linear(w,old)<=0 for w in bounds])
    child = z3.And([linear(w,new)<=0 for w in bounds]+[linear(w,old)<=0 for w in rows(guard)])
    solver = z3.SolverFor("QF_LRA")
    solver.add(parent)
    if solver.check()==z3.unsat:
        return False
    solver.add(z3.Not(child))
    return solver.check()==z3.unsat


def compare(checker):
    base = ["0≤k","i≤i0","-i≤i0","j≤j0","-j≤j0","i1=1/3 i0+4/3 j0",
            "1/3 j0+-2/3 i0≤j1","-1/3 j0+2/3 i0≤j1","1/3 j1≤2/3 i1",
            "i1+j1≤8 k","i1+j1≤1+3 k"]
    forms = [base,base[::-1]]+[base[:i]+base[i+1:] for i in range(len(base))]
    changes = [("i1","j0"),("j1","i0"),("j1","i1"),("i0","j0"),
               ("1/3 j1","-1/3 j1"),("-1/3 j0","1/3 j0"),("i1+j1≤8 k","i1+-2 j1≤8 k"),
               ("1/3 i0+4/3 j0","1/3 i0+5/3 j0"),("8 k","0"),("1+3 k","-1+-3 k")]
    forms.extend([row.replace(a,b) for row in base] for a,b in changes)
    forms.extend([base+["1≤j1"],base+["i0≤0"],base+["i1≤0","1≤i1"]])
    fields = ["i,j,k","1/2 i,1/2 j,3 k","7/9 i+-8/9 j,4/9 i+7/9 j,3 k",
              "i,-j,2 k","3 i,3 j,2 k","i+1,j,2 k","j,i,k","0,0,0"]
    cases,expected = [],[]
    for form in forms:
        domain = " ∧ ".join(form)
        bounds = project(rows(domain))
        for guard in ["i≤1+k","0≤i"]:
            for field in fields:
                expected.append(inductive(bounds,guard,field))
                cases.extend(["i,j,k",guard,domain,field])
    result = subprocess.run([checker],input="\n".join(cases)+"\n",text=True,capture_output=True,
                            check=True,timeout=90)
    replies = result.stdout.splitlines()
    assert len(replies)==len(expected) and all(s in ("true","false") for s in replies)
    for i,(reply,want) in enumerate(zip(replies,expected)):
        assert (reply=="true")==want, (cases[4*i:4*i+4],reply,want)
    print(f"{len(expected)} replay decisions matched exact projection. {sum(expected)} were inductive.")


if __name__=="__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--driver",action="store_true")
    group.add_argument("--checker",type=Path)
    args = parser.parse_args()
    if args.driver:
        print(DRIVER,end="")
    else:
        compare(args.checker.resolve())
