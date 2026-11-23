"""Replay constructor-value inference against generated OCaml and ground type instances."""
import argparse
from fractions import Fraction
from itertools import product
from pathlib import Path
import re
import runpy
import subprocess
from tempfile import TemporaryDirectory

HERE = Path(__file__).resolve().parent


def compile_source(exe, source, folder, *, execute=False, check="", expect=True, diagnostic=None):
    path = Path(folder)/"case.gadt"
    path.write_text(source)
    flags = ["-full_annot","-overwrite_ml"] if execute else ["-no_ml","-no_sig"]
    result = subprocess.run([exe,"-inform",*flags,path],capture_output=True,text=True,timeout=40)
    log = result.stdout+result.stderr
    if not expect:
        assert result.returncode and ("No answer" in log or "Contradiction" in log), log
        if diagnostic:
            assert diagnostic in log, log
    else:
        assert result.returncode == 0, log
        if execute:
            ml = path.with_suffix(".ml")
            body = ml.read_text()
            ml.write_text(body+"\n"+check+"\n")
            subprocess.run(["ocaml","-noinit",ml],check=True,capture_output=True,timeout=15)
            return body, path.with_suffix(".gadti").read_text()
    return log


def checks(exe, before, folder):
    def run(src, **kwargs):
        return compile_source(exe,src,folder,**kwargs)

    values = (HERE/"constructor_value_bounds.gadt").read_text()
    ml,sig = run(values,execute=True,check="let () = assert (checked && cyclic && loaded)")
    append = ml.split("let rec append",1)[1].split("let empty",1)[0]
    assert append.count("function")==1 and "fun l -> l" in append and "append xs l" in append
    assert re.search(r"val append : ∀[^.\[]+\. List",sig) and "0 ≤ n]. Tower n" in sig
    assert re.search(r"val unpack : ∀[^.\[]+\. Cargo",sig)
    run(values+"\nlet bad = use observed (-1)\n",expect=False)
    late = values+"\ndatacons Owed : Cargo (-1)\n"
    assert "[0 ≤" in run(late).split("val unpack :",1)[1].split("val ",1)[0]
    run(late+"let bad = unpack Owed\n",expect=False)
    order = """datatype Interval : num * num
datacons Pair : ∀i,j[i≤j]. Num i * Num j ⟶ Interval(i,j)
datatype Reversed : num * num
datacons Rev : ∀i,j. Interval(i,j) ⟶ Reversed(j,i)
external let consume : ∀i,j[j≤i]. Reversed(i,j) → Bool = "fun _ -> true"
let check : ∀i,j. Reversed(i,j) → Bool = fun r -> consume r
"""
    assert re.search(r"val check : ∀[^.\[]+\. Reversed",run(order))
    run(order+"datacons Other : Reversed(0,1)\nlet bad = check Other\n",expect=False)

    cycles = (HERE/"affine_cyclic_values.gadt").read_text()
    _, sig = run(cycles,execute=True)
    assert "val ring : Orbit (0, 0)" in sig
    for bad,expression in [("Scale 0","forever"),("Sum (1,-2)","sum"),("Axes (-1,0)","fork"),
                           ("Orbit (1,0)","ring"),("Mirror 4","mirror"),("Cross (2,2)","cross")]:
        run(cycles+f"\nlet bad : {bad} = {expression}\n",expect=False)
    drift = """datatype Tree : num
datacons Fork : ∀n[n≤5]. Tree (n+1) * Tree (n+ -1) ⟶ Tree n
let rec ring = Fork (ring,ring)
"""
    run(drift,expect=False,diagnostic="No index satisfies every unfolding")
    if before:
        for case in [values,cycles]:
            compile_source(before,case,folder,expect=False)
        mirror = cycles.split("datatype Mirror",1)[1].split("let left",1)[0]
        assert "val mirror : Mirror 0" in compile_source(before,"datatype Mirror"+mirror,folder)
    print("Unchanged append body, runtime cycle, late constructor, argument order and curve controls passed.")


def scalar_replay(exe,folder):
    theory = runpy.run_path(str(HERE/"thesis-review-56.py"))
    affine, edge = theory["affine_domains"], theory["AffineEdge"]
    rows = {"n≤3":[((1,),3)], "-1≤n":[((-1,),1)], "-1≤n ∧ n≤3":[((-1,),1),((1,),3)]}
    compared = 0
    for scale,offset,guard in product(range(-2,3),range(3),rows):
        program = f"""datatype Ring : num
datacons Wrap : ∀n[{guard}]. Ring ({scale} n+{offset}) ⟶ Ring n
let rec ring = Wrap ring
"""
        family = affine(0,{0:rows[guard]},[edge(0,0,((scale,),),(offset,))],{(-1,),(1,)})
        for x in [Fraction(-7,2),-2,-1,0,Fraction(1,2),2,3,4]:
            safe = family is not None and all(a[0]*x<=b for a,b in family[0].items())
            compile_source(exe,program+f"let observed : Ring ({x}) = ring\n",folder,expect=safe)
            compared += 1
    print(f"{compared} native index checks matched the exact affine domains.")


def plane_replay(exe,folder):
    theory = runpy.run_path(str(HERE/"thesis-review-56.py"))
    affine, edge = theory["affine_domains"], theory["AffineEdge"]
    directions = {(1,0),(-1,0),(0,1),(0,-1)}
    guard = {0:[((1,0),2),((0,-1),1)]}
    def child(matrix, shift):
        indices = [f"{a} i + {b} j + {d}" for (a,b),d in zip(matrix,shift,strict=True)]
        return "Plane (" + ",".join(indices) + ")"
    count = 0
    for scale,offset,branch in product([-2,-1,0,1,2],[-1,1],[False,True]):
        maps = [(((0,scale),(1,0)),(offset,0))]
        if branch:
            maps.append((((1,0),(0,-1)),(0,1)))
        family = affine(0,guard,[edge(0,0,m,t) for m,t in maps],directions)
        fields = " * ".join(child(m,t) for m,t in maps)
        body = "Wrap (knot,knot)" if branch else "Wrap knot"
        code = f"""datatype Plane : num * num
datacons Wrap : ∀i,j[i≤2 ∧ -1≤j]. {fields} ⟶ Plane (i,j)
let rec knot = {body}
"""
        for i,j in [(-2,-1),(-1,0),(0,0),(0,2),(1,-1),(1,1),(2,3),(3,2)]:
            safe = family is not None and all(a*i+b*j<=c for (a,b),c in family[0].items())
            compile_source(exe,code+f"let observed : Plane ({i},{j}) = knot\n",folder,expect=safe)
            count += 1
    print(f"{count} two-index native checks matched the affine domains.")


if __name__ == "__main__":
    args = argparse.ArgumentParser(description=__doc__)
    args.add_argument("--compiler",type=Path,required=True)
    args.add_argument("--before",type=Path)
    opts = args.parse_args()
    with TemporaryDirectory() as folder:
        compiler = opts.compiler.resolve()
        checks(compiler,opts.before.resolve() if opts.before else None,folder)
        scalar_replay(compiler,folder)
        plane_replay(compiler,folder)
