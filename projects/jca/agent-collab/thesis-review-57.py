"""Replay the symmetric-square reduction with exact rational matrices and native source."""
import argparse
from fractions import Fraction as F
from itertools import combinations_with_replacement, product
from pathlib import Path
import subprocess
from tempfile import TemporaryDirectory

import z3

PAIRS = tuple(combinations_with_replacement(range(3), 2))
NAMES = ("i", "j", "k", "l", "m", "n")
START = (0, 1, 1)


def dot(x, y):
    return sum(a*b for a, b in zip(x, y, strict=True))


def apply(matrix, vector):
    return tuple(dot(row, vector) for row in matrix)


def tile(u, v):
    def code(word):
        return sum(F(int(digit), 4**n) for n, digit in enumerate(word, 1))
    return ((1, code(u), -code(v)), (0, F(1, 4**len(u)), 0), (0, 0, F(1, 4**len(v))))


def pair(x, y):
    return tuple(F(x[i]*y[j]+x[j]*y[i], 2) for i,j in PAIRS)


def square_map(a):
    return tuple(tuple(a[i][u]*a[j][v] + (a[i][v]*a[j][u] if u!=v else 0)
                       for u,v in PAIRS) for i,j in PAIRS)


def trace(q):
    return q[0]+q[3]+q[5]


def linear(row):
    terms = []
    for coeff, name in zip(row, NAMES, strict=True):
        if coeff:
            terms.append(name if coeff==1 else f"{coeff} {name}")
    return " + ".join(terms) or "0"


def source(tiles, annotation=""):
    fields = []
    for words in tiles:
        indices = ",".join(linear(row) for row in square_map(tile(*words)))
        fields.append(f"Orbit ({indices})")
    variables = ",".join(NAMES)
    rec_args = ",".join(["ring"]*len(tiles))
    return f"""datatype Orbit : {' * '.join(['num']*6)}
datacons Fork : ∀{variables}[1≤i+l+n]. {' * '.join(fields)} ⟶ Orbit ({variables})
let rec ring{annotation} = Fork ({rec_args})
datatype Seen
datacons Observe : ∀n[1≤n]. Orbit (0,0,0,n,n,n) ⟶ Seen
let observed = Observe ring
"""


def conic_combination(point, generators):
    weights = [z3.Real(f"w{i}") for i in range(len(generators))]
    solver = z3.Solver()
    solver.add([w>=0 for w in weights])
    for column, target in enumerate(point):
        solver.add(sum(w*g[column] for w,g in zip(weights,generators,strict=True))==target)
    assert solver.check()==z3.sat, point
    model = solver.model()
    coeffs = [model.eval(w,model_completion=True).as_fraction() for w in weights]
    assert all(w>=0 for w in coeffs)
    assert all(sum(w*g[i] for w,g in zip(coeffs,generators,strict=True))==target
               for i,target in enumerate(point))
    return coeffs


def verify_certificate(tiles):
    """Use the paper's two invariant cones and one point for every short word."""
    maps = [tile(*words) for words in tiles]
    frontier = [START]
    prefix = []
    for _ in range(8):
        prefix.extend(frontier)
        frontier = [apply(a,x) for a,x in product(maps,frontier)]
        alpha = min(abs(w)-F(2,3)*(c+d) for w,c,d in frontier)
        if alpha>0:
            break
    else:
        raise AssertionError("no separation within the selected example’s replay depth")

    margin = min([alpha**2] + [dot(x,x) for x in prefix])
    gens = [(*pair(x,x),1) for x in prefix]
    for sign in (1,-1):
        rays = [(sign,0,0,0), (sign*F(2,3),1,0,0), (sign*F(2,3),0,1,0),
                (sign*alpha,0,0,1)]
        for r,t in combinations_with_replacement(rays,2):
            gens.append((*pair(r[:3],t[:3]),r[3]*t[3]))
    gens = list(dict.fromkeys(gens))
    assert all(trace(g[:6])>=margin*g[-1] for g in gens)
    start = (*pair(START,START),1)
    conic_combination(start,gens)
    checks = 0
    for a in maps:
        lifted = square_map(a)
        for g in gens:
            conic_combination((*apply(lifted,g[:6]),g[-1]),gens)
            checks += 1
    return checks


def pull(row, a):
    return tuple(sum(x*y for x,y in zip(row,col,strict=True)) for col in zip(*a,strict=True))


def decompose(rows, a):
    """Project each observation onto the proposed rational eigenspaces."""
    eigenvalues = sorted(set(a[i][i] for i in range(len(a))))
    result = []
    for row in rows:
        parts = []
        for value in eigenvalues:
            part = row
            for other in eigenvalues:
                if other!=value:
                    part = tuple(F(x-other*y,value-other)
                                 for x,y in zip(pull(part,a),part,strict=True))
            if any(part):
                if pull(part,a)!=tuple(value*x for x in part):
                    return None
                parts.append(part)
        if tuple(map(sum,zip(*parts)))!=row:
            return None
        result.extend(parts)
    return result


def ray_contract(maps, guard, root):
    """Find lower bounds on common eigenforms that prove the guard after one field."""
    parts = [guard]
    for a in maps:
        parts = decompose(parts,a)
        if not parts:
            return None
    rates = []
    lower = []
    for row in parts:
        pivot = next(i for i,x in enumerate(row) if x)
        factors = [F(pull(row,a)[pivot],row[pivot]) for a in maps]
        if any(not 0<=k<=1 or pull(row,a)!=tuple(k*x for x in row)
               for a,k in zip(maps,factors,strict=True)):
            return None
        start = dot(row,root)
        lower.append(start if all(k==1 for k in factors) else min(0,start))
        rates.append(factors)
    least = min([dot(guard,root)] + [dot(column,lower) for column in zip(*rates,strict=True)])
    if least<=0:
        return None
    scale = max(1,F(1,least))
    return scale,[(guard,1)]+[(r,scale*b) for r,b in zip(parts,lower,strict=True)]


def annotated_example():
    # For these tiles a+2b/3 is preserved. In the six lifted indices its
    # square gives the equality below. Each child has b scaled by at most 1/4.
    ann = (" : ∀i,j,k,l,m,n[i+4/3 j+4/9 l=4 ∧ j+2/3 l≤6 ∧ 0≤l ∧ 0≤n"
           " ∧ 1≤i+l+n]. Orbit (i,j,k,l,m,n)")
    return source([("2","0"),("22","0")],ann)


def native_check(exe, folder):
    def check(program, works):
        path = Path(folder)/"orbit.gadt"
        path.write_text(program)
        flags = ["-full_annot","-overwrite_ml"] if works else ["-no_sig","-no_ml"]
        res = subprocess.run([exe,"-inform",*flags,path],text=True,
                             capture_output=True,timeout=50)
        msg = res.stdout+res.stderr
        assert (res.returncode==0)==works, msg
        if not works:
            assert "No answer" in msg or "Contradiction" in msg, msg
        else:
            ml = path.with_suffix(".ml")
            with ml.open("a") as out:
                out.write("\nlet () = match observed with Observe (Fork (x,y) as z) -> assert (x==z && y==z)\n")
            subprocess.run(["ocaml","-noinit",ml],check=True,capture_output=True,timeout=10)
    tiles = [("2","0"),("22","0")]
    maps = [square_map(tile(*words)) for words in tiles]
    scale,rows = ray_contract(maps,(1,0,0,1,0,1),pair(START,START))
    assert scale==F(9,2)
    annotation = " : ∀i,j,k,l,m,n["+" ∧ ".join(f"{b}≤{linear(r)}" for r,b in rows)
    inferred = source(tiles,annotation+"]. Orbit (i,j,k,l,m,n)")
    check(inferred+f"let at_scale : Orbit (0,0,0,{scale},{scale},{scale}) = ring\n",True)
    check(annotated_example(),True)
    check(source([("0","0"),("2","0")]),False)
    print("The compiler accepted the written and synthesized schemes, ran both cyclic heaps, and rejected the shrinking ray.")


def check_routing():
    maps = [square_map(tile(*words)) for words in [("02","2"),("22","020"),("0","0")]]
    root = pair(START,START)
    zero = (0,)*6
    for word in product(range(len(maps)),repeat=3):
        blocks = [root,zero,zero]
        position, q = 0,root
        for selected in word:
            while position!=selected:
                blocks = [blocks[-1],*blocks[:-1]]
                position = (position+1)%len(blocks)
            blocks = [apply(a,x) for a,x in zip(maps,blocks,strict=True)]
            q = apply(maps[selected],q)
            assert blocks[selected]==q and sum(map(trace,blocks))==trace(q)


def check_ray_jump():
    q = z3.Reals("q0 q1 q2 q3 q4 q5")
    root, guard = pair(START,START),(1,0,0,1,0,1)
    maps = [square_map(tile(*w)) for w in [("2","0"),("22","0")]]
    scale, rows = ray_contract(maps,guard,root)
    assert all(scale*dot(r,root)>=b for r,b in rows)
    for a in maps:
        solver = z3.Solver()
        solver.add([dot(r,q)>=b for r,b in rows])
        solver.add(z3.Or([dot(pull(r,a),q)<b for r,b in rows]))
        assert solver.check()==z3.unsat
    assert ray_contract([square_map(tile("0","0"))],guard,root) is None
    assert ray_contract([((1,1),(0,1))],(1,0),(1,1)) is None
    assert ray_contract([((-1,),)],(1,),(1,)) is None


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compiler",type=Path)
    args = parser.parse_args()
    examples = [[("2","0"),("22","0")], [("2","0"),("0","2")],
                [("0","02"),("00","002")]]
    # The last example delays the mismatch. The upper word contains only zeros.
    assert annotated_example() == Path(__file__).with_name("scaled_orbit.gadt").read_text()
    check_routing()
    check_ray_jump()
    total = sum(verify_certificate(tiles) for tiles in examples)
    for words in [('02','2'),('22','020'),('0','0')]:
        a = tile(*words)
        for x,y in product([START,(3,-2,1),(-1,0,2)],repeat=2):
            assert apply(square_map(a),pair(x,y)) == pair(apply(a,x),apply(a,y))
    # This tile has an infinite match. No fixed rational scale survives its orbit.
    a = square_map(tile("0","0"))
    for s in [1,9,1000,10**8]:
        q = tuple(s*t for t in pair(START,START))
        for k in range(12):
            assert trace(q)==F(2*s,16**k)
            q=apply(a,q)
        assert trace(q)<1
    print(f"{total} exact generator-image inclusions passed, along with guard and tensor checks.")
    if args.compiler:
        with TemporaryDirectory() as folder:
            native_check(args.compiler.resolve(),folder)


if __name__=="__main__":
    main()
