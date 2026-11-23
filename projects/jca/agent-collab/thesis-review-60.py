"""Replay the fixed-axis and switched-axis recursive guards over exact rationals."""
import argparse
from collections import deque
from fractions import Fraction as F
from pathlib import Path
from math import prod
import runpy
import subprocess
from tempfile import TemporaryDirectory

import z3

A = (F(1), F(0), F(1))
COORDS = ("i", "j", "k")


def action(matrix, v):
    return tuple(sum(a*b for a,b in zip(row,v)) for row in matrix)


def classify(normal, matrices):
    """Decide finite exact unfolding for rational orthogonal normal maps and expanding slack."""
    d = len(normal)
    assert any(normal)
    equations = []
    for matrix in matrices:
        assert len(matrix) == d and all(len(row)==d for row in matrix)
        for i,row in enumerate(matrix):
            assert all(sum(a*b for a,b in zip(row,other)) == (i==j) for j,other in enumerate(matrix))
            equations.append([a-(i==j) for j,a in enumerate(row)])
    kernel = runpy.run_path(str(Path(__file__).with_name("thesis-review-59.py")))["kernel"]
    if all(sum(a*b for a,b in zip(normal,v)) == 0 for v in kernel(equations)):
        return True

    # A reduced basis for the orbit span also reads off coordinates at its pivots.
    basis = {}
    def extend(v):
        u = list(map(F,v))
        for j,row in sorted(basis.items()):
            u = [a-u[j]*b for a,b in zip(u,row)]
        j = next((i for i,a in enumerate(u) if a), None)
        if j is None:
            return
        u = [a/u[j] for a in u]
        for i,row in list(basis.items()):
            basis[i] = [a-row[j]*b for a,b in zip(row,u)]
        basis[j] = u

    extend(normal)
    while True:
        old = list(basis.values())
        for u in old:
            for matrix in matrices:
                extend(action(matrix,u))
        if len(basis)==len(old):
            break

    # Finite-order operators have integral trace on the rational orbit span.
    # This shortcut detects many infinite orbits before the finite-group bound.
    operations = [(m,) for m in matrices]+[(m,n) for m in matrices for n in matrices]
    for word in operations:
        trace = F(0)
        for j,row in basis.items():
            v = row
            for matrix in word:
                v = action(matrix,v)
            trace += v[j]
        if trace.denominator != 1:
            return False

    k = len(basis)
    bound = prod(3**k-3**j for j in range(k))
    start = tuple(map(F,normal))
    seen, queued = {start},deque([start])
    while queued:
        u = queued.popleft()
        for matrix in matrices:
            v = action(matrix,u)
            if v not in seen:
                seen.add(v)
                if len(seen)>bound:
                    return False
                queued.append(v)
    return True


def check_classifications():
    c,s = F(3,5),F(4,5)
    spin = [(c,s,0),(-s,c,0),(0,0,1)]
    flip = [(1,0,0),(0,1,0),(0,0,-1)]
    quarter = [(0,1,0),(-1,0,0),(0,0,1)]
    mirror = [(1,0,0),(0,-1,0),(0,0,1)]
    oblique = [(c,s,0),(s,-c,0),(0,0,1)]
    for a,fields,finite in [(A,[spin],False),(A,[spin,flip],True),(A,[quarter],True),
                            ((0,0,1),[spin],True),((1,0,0),[spin],True),
                            (A,[mirror,oblique],False)]:
        assert classify(a,fields) == finite
    print("Six orbit classifications passed, including two reflections whose product has infinite order.")


def pull(normal, flip):
    x,y,z = normal
    if flip:
        return x,y,-z
    return (3*x+4*y)/5,(-4*x+3*y)/5,z


def scalar(k):
    return z3.Q(k.numerator,k.denominator)


def guard(normal,rate,point,t):
    return sum(scalar(k)*x for k,x in zip(normal,point)) <= 1+rate*t


def explore(switched,limit):
    point = z3.Reals("x y z")
    t = z3.Real("t")
    solver = z3.Solver()
    solver.add(t>=1)
    seen, layer = {}, {A}
    for j in range(limit+1):
        rate = 2**j
        fresh = sorted(layer-seen.keys())
        rows = [guard(q,rate,point,t) for q in fresh]
        solver.push()
        solver.add(z3.Not(z3.And(rows)))
        result = solver.check()
        solver.pop()
        if result == z3.unsat:
            return seen,j
        assert result == z3.sat
        solver.add(*rows)
        seen.update((q,rate) for q in fresh)
        layer = {pull(q,op) for q in fresh for op in ([False,True] if switched else [False])}
    return seen,None


def replay(rows,switched):
    """Check the written H-description against each complete field and the guard."""
    point = z3.Reals("x y z")
    t = z3.Real("t")
    solver = z3.Solver()
    solver.add(t>=1,*(guard(q,r,point,t) for q,r in rows.items()))
    needed = [guard(A,1,point,t)]
    for flip in ([False,True] if switched else [False]):
        needed.extend(guard(pull(q,flip),2*r,point,t) for q,r in rows.items())
    solver.add(z3.Not(z3.And(needed)))
    assert solver.check() == z3.unsat


def cover_family(rows):
    """Decide uniform coverage of a nonempty closed polyhedral caller at the fixed-axis field.

    Input rows use the order x,y,z,t followed by the upper bound. The returned
    depth supplies a public convex typing by guarded preimages of a one-sided box.
    """
    x,y,z,t = values = z3.Reals("x y z t")
    def possible(*constraints):
        solver = z3.Solver()
        solver.add(*constraints)
        result = solver.check()
        assert result in (z3.sat,z3.unsat)
        return result==z3.sat

    forms = [sum(scalar(F(a))*v for a,v in zip(row[:4],values)) for row in rows]
    caller = z3.And(t>=1,*(lhs<=scalar(F(row[4])) for lhs,row in zip(forms,rows)))
    if not possible(caller):
        return "covered",0
    cone = z3.And(t==0,*(lhs<=0 for lhs in forms))
    arms = [x,-x,y,-y,z]
    if possible(cone,z3.Or([arm>=1 for arm in arms])):
        return "recession",None

    bound = 1
    while possible(caller,z3.Or([arm>bound*t for arm in arms])):
        bound *= 2
    depth = (4*bound-1).bit_length()
    normal = A
    for j in range(depth):
        if possible(caller,z3.Not(guard(normal,2**j,(x,y,z),t))):
            return "unsafe",j
        normal = pull(normal,False)

    def field(p,t):
        x,y,z = p
        return ((3*x-4*y)/5,(4*x+3*y)/5,z),2*t
    def predicate(p,t):
        clauses = [t>=1]
        for _ in range(depth):
            clauses.append(guard(A,1,p,t))
            p,t = field(p,t)
        x,y,z = p
        clauses.extend(2*u<=t for u in (x,-x,y,-y,z))
        return z3.And(clauses)

    p = (x,y,z)
    domain = predicate(p,t)
    assert not possible(caller,z3.Not(domain))
    assert not possible(domain,z3.Not(z3.And(guard(A,1,p,t),predicate(*field(p,t)))))
    return "covered",depth


def check_families():
    def eq(row):
        return [row,tuple(-a for a in row)]
    fixed_t = eq((0,0,0,1,1))
    y_zero = eq((0,1,0,0,0))
    tilted = fixed_t+y_zero+eq((2,0,1,0,0))+[(-1,0,0,0,0)]
    axial = fixed_t+y_zero+eq((1,0,0,0,1))+[(0,0,1,0,0)]
    bounded_tilt = tilted+[(1,0,0,0,100)]
    scaled = y_zero+eq((1,0,0,-1,0))+eq((2,0,1,0,0))
    unsafe = fixed_t+eq((1,0,0,0,1))+eq((0,1,0,0,-10))+eq((0,0,1,0,0))
    assert cover_family(tilted)[0]=="recession"
    assert all(cover_family(c)[0]=="covered" for c in (axial,bounded_tilt,scaled))
    assert cover_family(unsafe)==("unsafe",1)
    print("Five symbolic families distinguished joint coverage, a later unsafe field and the recession obstruction.")


def source(rows,switched,caller):
    bounds = ["1≤l"]
    for normal,rate in rows.items():
        lhs = " + ".join(f"{q} {name}" for q,name in zip(normal,COORDS) if q)
        bounds.append(f"{lhs}≤1+{rate} l")
    rotated = "Node (3/5 i + -4/5 j,4/5 i + 3/5 j,k,2 l)"
    fields = rotated+" * Node (i,j,-k,2 l)" if switched else rotated
    body = "Step (node,node)" if switched else "Step node"
    return ("datatype Node : num * num * num * num\n"
            f"datacons Step : ∀i,j,k,l[i+k≤1+l]. {fields} ⟶ Node (i,j,k,l)\n"
            f"let rec node : ∀i,j,k,l[{' ∧ '.join(bounds)}]. Node (i,j,k,l) = {body}\n"
            f"let start : Node ({caller}) = node\n")


def native(exe,rows):
    with TemporaryDirectory() as tmp:
        p = Path(tmp)/"switched.gadt"
        for caller,ok in [("1,0,1,1",True),("2,0,1,1",False)]:
            p.write_text(source(rows,True,caller))
            cmd = [exe,"-inform","-overwrite_ml","-full_annot",p]
            r = subprocess.run(cmd,text=True,capture_output=True,timeout=45)
            assert (r.returncode==0)==ok,(r.stdout,r.stderr)
            if ok:
                ml=p.with_suffix(".ml")
                with ml.open("a") as f:
                    f.write("\nlet () = match start with Step(a,b) -> assert (a==node && b==node)\n")
                subprocess.run(["ocaml","-noinit",ml],check=True,capture_output=True,timeout=10)
            else:
                assert "Contradiction" in r.stdout+r.stderr or "No answer" in r.stdout+r.stderr
        # One guarded predecessor of the one-sided box covers a whole negative-axis ray.
        base = source({},False,"1,0,0,1")
        face = "1≤l ∧ i+k≤1+l ∧ 3/5 i + -4/5 j≤l ∧ -3/5 i + 4/5 j≤l ∧ 4/5 i + 3/5 j≤l ∧ -4/5 i + -3/5 j≤l ∧ k≤l"
        p.write_text(base.replace("∀i,j,k,l[1≤l]","∀i,j,k,l["+face+"]")+
                     "let axis : ∀m[0≤m]. Node (1,0,-m,1) = node\n")
        r = subprocess.run([exe,"-inform","-no_ml","-no_sig",p],capture_output=True,text=True,timeout=30)
        assert r.returncode==0,(r.stdout,r.stderr)
    print("The native checker verified the written switched type, the ground boundary and both heap pointers; it rejected the outside caller and accepted the unbounded axial family.")


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compiler",type=Path)
    parser.add_argument("--source",action="store_true")
    args=parser.parse_args()
    rows,depth=explore(True,30)
    assert depth is not None
    if args.source:
        print(source(rows,True,"1,0,1,1"),end="")
        return
    check_classifications()
    check_families()
    replay(rows,True)
    orbit,never=explore(False,25)
    assert never is None and len(orbit)==26
    print(f"All 26 initial fixed-axis layers add a guard. The switched example closes at depth {depth} with {len(rows)} distinct word guards.")
    if args.compiler:
        native(args.compiler.resolve(),rows)


if __name__=="__main__":
    main()
