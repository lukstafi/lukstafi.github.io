"""Replay the folded witness certificates against the native compiler and exact linear arithmetic."""
import argparse
from fractions import Fraction as F
from pathlib import Path
import re
import runpy
import subprocess
from tempfile import TemporaryDirectory

import z3

HERE = Path(__file__).resolve().parent
EARLIER = runpy.run_path(str(HERE / "thesis-review-59.py"))


def coordinates(oblique):
    if oblique:
        return (lambda i,j,k: (i+j+1, j+k-2, i+j+k-1),
                lambda u,v,t: (t-v-1, u+v-t, t-u+2))
    return (lambda i,j,k: (i,j,k)), (lambda u,v,t: (u,v,t))


def form(f):
    c = f(0,0,0)
    basis = [(1,0,0), (0,1,0), (0,0,1)]
    terms = [f"{f(*e)-c} {name}" for e,name in zip(basis, "ijk") if f(*e)!=c]
    return " + ".join(terms + ([str(c)] if c else [])) or "0"


def node(f):
    terms = [form(lambda i,j,k: f(i,j,k)[axis]) for axis in range(3)]
    return "Node (" + ",".join(terms) + ")"


ROTATION = (F(7,9), F(-8,9), F(4,9), F(7,9), F(65,64))
BACKWARD = (F(7,9), F(8,9), F(-4,9), F(7,9), F(33,32))
REFLECTIONS = [(1,0,0,-1,F(65,64)), (F(7,9),F(8,9),F(4,9),F(-7,9),F(33,32))]


def weighted_source(oblique, fields=(ROTATION,)):
    uv, public = coordinates(oblique)

    def transform(matrix):
        a,b,c,d,rate = matrix
        def field(i,j,k):
            u,v,t = uv(i,j,k)
            return public(a*u+b*v, c*u+d*v, rate*t)
        return field

    guard = form(lambda i,j,k: uv(i,j,k)[0]-1-uv(i,j,k)[2])
    children = " * ".join(node(transform(field)) for field in fields)
    constructor = "Step" if len(fields)==1 else "Fork"
    rhs = "Step node" if len(fields)==1 else "Fork (node,node)"
    return "\n".join([
        "datatype Node : num * num * num",
        f"datacons {constructor} : ∀i,j,k[{guard}≤0]. {children} ⟶ Node (i,j,k)",
        "let rec node = "+rhs, "let alias = node",
        "let root : " + node(lambda i,j,k: public(2,0,1)) + " = alias",
        "let box : ∀i,j[-1≤i ∧ i≤1 ∧ -1≤j ∧ j≤1]. " + node(lambda i,j,k: public(i,j,1)) + " = alias",
        "let ray : ∀i,k[1≤k ∧ -k≤i ∧ i≤k]. " + node(lambda i,j,k: public(i,0,k)) + " = alias",
    ]) + "\n"


def prefix_depth(vertices,rays,weight,rate):
    """First horizon with positive radial headroom at every nonzero generator."""
    assert weight>0 and rate>1 and vertices
    points = [(x*x+weight*y*y,t,1) for x,y,t in vertices]
    points.extend((x*x+weight*y*y,t,0) for x,y,t in rays)
    assert all(t>=0 and (t>0 or q==0) for q,t,_ in points)

    def enough(n):
        L = rate**n
        return all(q==0 or q<(constant+L*t)**2 for q,t,constant in points)

    lo,hi = 0,1
    while not enough(hi):
        lo,hi = hi,2*hi
    while hi-lo>1:
        mid = (lo+hi)//2
        if enough(mid):
            hi = mid
        else:
            lo = mid
    return hi


def plan_folds(vertices,rays,weight,fields):
    """Decide the caller in a supplied weighted frame and choose a sufficient fold depth."""
    for a,b,c,d,r in fields:
        assert r>1 and a*a+weight*c*c==1 and b*b+weight*d*d==weight and a*b+weight*c*d==0
    r = min(field[-1] for field in fields)
    horizon = prefix_depth(vertices,rays,weight,r)
    generators = [(u,v,t,1) for u,v,t in vertices]+[(u,v,t,0) for u,v,t in rays]
    frontier = {(F(1),F(0),F(1))}
    guards = set()
    for _ in range(horizon):
        if any(x*u+y*v>constant+rate*t for x,y,rate in frontier for u,v,t,constant in generators):
            return None
        guards.update(frontier)
        frontier = {(x*a+y*c,x*b+y*d,rate*s) for x,y,rate in frontier for a,b,c,d,s in fields}
    norms = [(u*u+weight*v*v,t,constant) for u,v,t,constant in generators]
    H = 1
    while any(4*q>(H*t)**2 for q,t,_ in norms):
        H *= 2
    future = r**horizon
    depth = 1
    while True:
        delta = F(weight,2*4**depth)
        if (delta<=r-1 and delta*H<=future*(r-1) and
            all((1+delta)**2*q <= min(H*t,constant+future*t)**2 for q,t,constant in norms)):
            return horizon,depth,H,sorted(guards)
        depth += 1


def caller_plan_checks():
    fields = [(*ROTATION[:4],F(3,2)), (*BACKWARD[:4],F(2))]
    # Every generator below has radius at most sqrt(27) and t >= 1.
    # At depth five its slack alone exceeds that radius, including on rays.
    def safe(u,v,t,intercept,depth):
        if u>intercept+t:
            return False
        return depth==5 or all(safe(a*u+b*v,c*u+d*v,rate*t,intercept,depth+1)
                               for a,b,c,d,rate in fields)
    count = positives = 0
    for u in range(-3,4):
        for v in range(-3,4):
            for ray in (False,True):
                vertices = [(0,0,1)] if ray else [(u,v,1)]
                rays = [(u,v,1)] if ray else []
                expected = safe(u,v,1,int(not ray),0)
                assert (plan_folds(vertices,rays,2,fields) is not None)==expected
                positives += expected
                count += 1
    print(f"The prefix procedure matched the independent guard check on {count} point and ray callers ({positives} safe).")


def prefix_source():
    # A safe caller beyond the one-step radius cap. All three early guard
    # normals are explicit. The same five private folds serve the frontier.
    rate = F(65,64)
    horizon,depth,H,normals = plan_folds([(F(-51,25),0,1)],[],2,[ROTATION])
    assert (horizon,depth,H)==(3,5,8)
    guards = ["0≤k"] + [f"{u} i + {v} j≤1+{s} k" for u,v,s in normals]
    rows = guards+["i≤i0","-i≤i0","j≤j0","-j≤j0"]
    gens = ["i","j","k","i0","j0"]
    for level in range(1,depth+1):
        a = F(1,2**level)
        c,s = (1-2*a*a)/(1+2*a*a), 2*a/(1+2*a*a)
        x,y = f"i{level-1}",f"j{level-1}"
        xx,yy = f"i{level}",f"j{level}"
        gens.extend([xx,yy])
        rows.extend([f"{xx}={c} {x}+{2*s} {y}",f"{c} {y}+{-s} {x}≤{yy}",f"{-c} {y}+{s} {x}≤{yy}"])
    rows.extend([f"{c} {yy}≤{s} {xx}",f"{xx}+{2*a} {yy}≤{H} k",
                 f"{xx}+{2*a} {yy}≤1+{rate**horizon} k"])
    source = weighted_source(False).split("let rec")[0]
    return (source+"let rec node : ∀"+",".join(gens)+"["+" ∧ ".join(rows)+"]. Node (i,j,k) = Step node\n"
            +"let root : Node (-51/25,0,1) = node\n")


def affine(text):
    row = {}
    for part in text.replace("(", "").replace(")", "").split("+"):
        match = re.fullmatch(r"(-?(?:\d+(?:/\d+)?)?)\s*([a-z]\d*)?", part.strip())
        assert match and any(match.groups()), part
        coefficient, name = match.groups()
        value = F({"": "1", "-": "-1"}.get(coefficient, coefficient))
        row[name] = row.get(name, 0) + value
    return {k:v for k,v in row.items() if v}


def signature(text, name):
    return " ".join(text.split("val "+name+" :",1)[1].split("val ",1)[0].split())


def scheme(text):
    _,body,result = re.fullmatch(r"∀([^\[]+)\[(.*)\]\.\s*\w+\s*\(([^()]+)\)", text).groups()
    public = [v.strip() for v in result.split(",")]
    rows = []
    for atom in body.split("∧"):
        left,op,right = re.split("([≤=])",atom)
        row = affine(left)
        for key,c in affine(right).items():
            row[key] = row.get(key,0)-c
        rows.append((op,{k:v for k,v in row.items() if v}))
    return public,rows


def z(q):
    return z3.RealVal(str(q))


def linear(row,env):
    return sum((z(c)*(env[k] if k is not None else 1) for k,c in row.items()),z(0))


def constraints(rows,env):
    return z3.And(*[(linear(w,env)==0 if op=="=" else linear(w,env)<=0) for op,w in rows])


def tight(rows,public):
    """Reconstruct witnesses from the exported constraints, independently of their names and order."""
    env = dict(public)
    unknown = set().union(*(set(row) for _,row in rows)) - {None} - env.keys()
    while unknown:
        for var in sorted(unknown):
            lower = []
            for op,row in rows:
                if set(row) & unknown != {var}:
                    continue
                k = row[var]
                rhs = {w:-c/k for w,c in row.items() if w!=var}
                if op=="=":
                    val = linear(rhs,env)
                    break
                if k<0:
                    if {w:-c for w,c in rhs.items()} in lower:
                        val = z3.Abs(linear(rhs,env))
                        break
                    lower.append(rhs)
            else:
                continue
            env[var] = val
            unknown.remove(var)
            break
        else:
            raise AssertionError(unknown)
    return env


def check(expected, *assumptions):
    solver = z3.SolverFor("QF_LRA")
    solver.set(timeout=60000)
    solver.add(*assumptions)
    actual = solver.check()
    assert actual==expected, (actual, solver.model() if actual==z3.sat else solver.reason_unknown())


def verify_export(public,rows,oblique,fields):
    uv, to_public = coordinates(oblique)
    parent = {k:z3.Real("old_"+k) for _,row in rows for k in row if k is not None}
    u,v,t = uv(*(parent[k] for k in public))
    def admit(point):
        return constraints(rows,tight(rows,dict(zip(public,to_public(*point)))))
    check(z3.unsat, constraints(rows,parent), u>1+t)
    for a,b,c,d,rate in fields:
        next_point = (z(a)*u+z(b)*v,z(c)*u+z(d)*v,z(rate)*t)
        check(z3.unsat, constraints(rows,parent), z3.Not(admit(next_point)))
    check(z3.sat, constraints(rows,parent), 10*u>1+z(F(65,64))*t)
    check(z3.unsat, z3.Not(admit((z(2),z(0),z(1)))))
    # Ask for a failing point anywhere in each symbolic caller family.
    i,j,k = z3.Reals("i j k")
    check(z3.unsat, i>=-1,i<=1,j>=-1,j<=1,z3.Not(admit((i,j,z(1)))))
    check(z3.unsat, k>=1,i>=-k,i<=k,z3.Not(admit((i,z(0),k))))


def native(exe,p,source,*,ok=True,ml=False,extra=()):
    p.write_text(source)
    flags = ["-full_annot","-overwrite_ml"] if ml else ["-no_ml"]
    result = subprocess.run([exe,*flags,*extra,p],text=True,capture_output=True,timeout=60)
    assert (result.returncode==0)==ok, (result.stdout,result.stderr)
    if not ok:
        assert "No answer" in result.stdout+result.stderr or "Contradiction" in result.stdout+result.stderr
        return ""
    return p.with_suffix(".gadti").read_text()


def replay(exe):
    caller_plan_checks()
    with TemporaryDirectory() as folder:
        p = Path(folder)/"node.gadt"
        for n in (2,3,4,8,12,18):
            cs,rate,depth = EARLIER["family"](n)
            c,s = cs
            plan = plan_folds([(2,0,1)],[],1,[(c,-s,s,c,rate)])
            horizon,planned_depth,_,_ = plan
            assert horizon==1
            written = EARLIER["folded_source"](cs,rate,1,depth,True)
            native(exe,p,written)
            body = "let rec probe = Spin probe"
            source = re.sub(r"let rec probe : [^\n]+",body,written)
            inferred = signature(native(exe,p,source),"probe")
            public,rows = scheme(inferred)
            private = set().union(*(set(row) for _,row in rows)) - {None} - set(public)
            size = sum(2 if op=="=" else 1 for op,_ in rows)
            assert len(private)==2*planned_depth+2 and size==4*planned_depth+9
            native(exe,p,source.replace(body,"let rec probe : "+inferred+" = Spin probe"))
            print(f"n={n}: written depth {depth}, inferred {len(private)} private indices, {size} inequalities.",flush=True)
        scenarios = [(False,[ROTATION]), (True,[ROTATION]),
                     (True,[ROTATION,BACKWARD]), (False,REFLECTIONS)]
        for oblique,fields in scenarios:
            source = weighted_source(oblique,fields)
            extra = () if len(fields)==1 else ("-term_abduction_timeout","1")
            text = native(exe,p,source,ml=True,extra=extra)
            sch = signature(text,"node")
            assert sch == signature(text,"alias")
            verify_export(*scheme(sch),oblique,fields)
            with p.with_suffix(".ml").open("a") as f:
                pattern = "Step a" if len(fields)==1 else "Fork (a,b)"
                children = "a==node" if len(fields)==1 else "a==node && b==node"
                f.write(f"\nlet () = match root with {pattern} -> assert ({children} && box==node && ray==node)\n")
            subprocess.run(["ocaml","-noinit",p.with_suffix(".ml")],check=True,capture_output=True,timeout=15)
            print(f"Weighted scheme, oblique={oblique}, fields={len(fields)}: Z3 verified every field and caller.",flush=True)
        assert prefix_depth([(0,0,0),(0,0,1)],[(F(51,25),0,2)],2,F(65,64))==2
        assert plan_folds([(3,0,1)],[],2,[ROTATION]) is None
        assert plan_folds([(F(51,25),0,1)],[],2,[ROTATION]) is None
        prefix = prefix_source()
        native(exe,p,prefix)
        assert F(51,25)>1+F(65,64)**2 and F(51,25)*(1+F(1,1024))<=1+F(65,64)**3
        print("A three-guard prefix and a single fold chain cover a caller outside the one-step cap.")
        source = EARLIER["folded_source"](EARLIER["rotation"](F(1,2)),2,F(1,7),1)
        native(exe,p,source)
        native(exe,p,source.replace("3/5 i + -4/5 j,4/5 i + 3/5 j,2 k","10,0,1"),ok=False)
        outside = source.replace("∀k[1/7≤k]. Probe (1,0,k) = probe","Probe (10,0,1) = probe")
        native(exe,p,outside,ok=False)
        partial = native(exe,p,source.replace("Probe (1,0,k) = probe","Probe (10,0,k) = probe"))
        assert re.search(r"∀(\w+)\[9 ≤ \1\]\. Probe \(10, 0, \1\)",signature(partial,"use"))
        print("The native checker rejected a nonclosing field and an uncovered caller.")
        largest = (1<<62)-1  # OCaml's signed integer on the 64-bit builds used above.
        decl = f'external let scale : ∀i. Num i → Num ({largest} i + {largest} i) = "fun _ -> 0"\n'
        native(exe,p,decl+"let wrong : Num (-2) = scale 1\n",ok=False)
        native(exe,p,decl+"let at_origin : Num 0 = scale 0\n")
        constructors = ("datatype Input : num\ndatacons One : Input 1\ndatacons Origin : Input 0\n"
                        "datatype Output : num\n"
                        f"datacons Scaled : ∀i. Input i ⟶ Output ({largest} i + {largest} i)\n")
        native(exe,p,constructors+"let wrong : Output (-2) = Scaled One\n",ok=False)
        interface = native(exe,p,constructors+"let at_origin : Output 0 = Scaled Origin\n")
        assert "val at_origin : Output 0" in interface
        print("Both the function and the closed constructor example reject the wrapped type and accept zero at zero.")


if __name__=="__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compiler",type=Path)
    parser.add_argument("--source",action="store_true",help="print the affinely reindexed example")
    args = parser.parse_args()
    if args.source:
        print(weighted_source(True),end="")
    if args.compiler:
        replay(args.compiler.resolve())
    elif not args.source:
        parser.error("provide --compiler or --source")
