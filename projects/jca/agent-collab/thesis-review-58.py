"""Check the fixed-root obstruction and replay the native constructor examples."""
import argparse
from fractions import Fraction as F
from itertools import product
from functools import cmp_to_key
from pathlib import Path
import runpy
import subprocess
from tempfile import TemporaryDirectory

import z3

HERE = Path(__file__).resolve().parent
previous = runpy.run_path(str(HERE/"thesis-review-57.py"))
tile, square, pair = (previous[k] for k in ("tile","square_map","pair"))
dot, apply, trace = (previous[k] for k in ("dot","apply","trace"))
START = pair((0,1,1),(0,1,1)) + (1,0)
NAMES = (*previous["NAMES"],"i1","j1")
ZERO = (0,)*8
TRACE = (1,0,0,1,0,1,0,0)
H = (1,F(4,3),0,F(4,9),0,0,0,0)
MIX = (0,1,0,F(2,3),0,0,0,0)
YES = [("2","0"),("22","0")]
NO = [("0","0"),("2","0")]


def basis(i):
    return tuple(int(j==i) for j in range(8))


def plus(a, k, b):
    return tuple(x+k*y for x,y in zip(a,b,strict=True))


def maps(tiles):
    for w in tiles:
        yield tuple((*row,0,0) for row in square(tile(*w))) + (basis(6),basis(7))
    yield tuple(tuple(2*c for c in basis(i)) for i in range(6)) + (
        (*ZERO[:6],F(3,5),F(-4,5)),(*ZERO[:6],F(4,5),F(3,5)))


def polygon():
    for i in [6,7]:
        for sign in [1,-1]:
            yield tuple(sign*v for v in basis(i))
    for a,b in product([-1,1],repeat=2):
        yield (*ZERO[:6],F(2*a,3),F(2*b,3))


def certificate():
    neg_h = tuple(-v for v in H)
    yield neg_h,F(-4,9)
    yield plus(MIX,F(-3,2),H),0
    for i in [3,5]:
        yield tuple(-v for v in basis(i)),0
    yield plus(tuple(-v for v in TRACE),F(1,2),H),0
    for side in polygon():
        yield plus(side,F(-1,2),H),1


def linear(row):
    return " + ".join(v if k==1 else f"{k} {v}" for k,v in zip(row,NAMES,strict=True) if k) or "0"


def fixed_source(tiles, annotated):
    variables = ",".join(NAMES)
    def image(a):
        return "Fixed ("+",".join(map(linear,a))+")"
    data = list(maps(tiles))
    fields = " * ".join(image(a) for a in data)
    annotation = ""
    if annotated:
        guard = " ∧ ".join(f"{linear(row)}≤{b}" for row,b in certificate())
        annotation = f" : ∀{variables}[{guard}]. Fixed ({variables})"
    return f"""datatype Fixed : {' * '.join(['num']*8)}
datacons Fork : ∀{variables}[i1≤1+i+l+n]. {fields} ⟶ Fixed ({variables})
let rec knot{annotation} = Fork ({','.join(['knot']*len(data))})
let at_start : Fixed ({','.join(map(str,START))}) = knot
"""


def linear_checks():
    q=z3.Reals("q0 q1 q2 q3 q4 q5 px py")
    rows=list(certificate())
    assert all(dot(r,START)<=b for r,b in rows)
    def implication(before, after):
        solver=z3.Solver()
        solver.add(before,z3.Not(after))
        assert solver.check()==z3.unsat
    admitted=z3.And([dot(r,q)<=b for r,b in rows])
    implication(admitted,q[6]<=1+dot(TRACE,q))
    for a in maps(YES):
        out=apply(a,q)
        implication(admitted,z3.And([dot(r,out)<=b for r,b in rows]))
    spin=list(maps([]))[0]
    unit=z3.And([dot(r,q)<=1 for r in polygon()])
    for r in polygon():
        implication(unit,dot(r,apply(spin,q))<=F(11,10))
    sharp=(*ZERO[:6],1,F(1,2))
    assert max(dot(r,apply(spin,sharp)) for r in polygon())==F(11,10)
    # Matching tiles can make the first six coordinates as small as requested.
    a=next(maps(NO))
    q=START
    for n in range(40):
        assert trace(q[:6])==F(2,16**n) and q[6:]==(1,0)
        q=apply(a,q)


def factor_rank_one(q):
    """Recover rational witnesses (u,s) with s>=1 and sQ=uu^T."""
    matrix={indices:F(c) for indices,c in zip(previous["PAIRS"],q,strict=True)}
    if not any(q):
        return (0,0,0),F(1)
    for i in range(3):
        d=matrix[i,i]
        if d>0:
            a=max(1,1/d)
            u=tuple(a*matrix[min(i,j),max(i,j)] for j in range(3))
            s=a*a*d
            if pair(u,u)==tuple(s*v for v in q):
                return u,s
    return None


def word_checks():
    count=0
    assert factor_rank_one((0,0,0,0,0,0))==((0,0,0),1)
    assert factor_rank_one((1,0,0,1,0,0)) is None
    assert factor_rank_one((-1,0,0,0,0,0)) is None
    for tiles in [YES,NO]:
        steps=list(maps(tiles))
        for word in product(range(len(steps)),repeat=6):
            q,p,z,k=START,(1,0),(0,1,1),0
            left,right=z,(0,0,0)
            u,scale=z,1
            for i in word:
                q=apply(steps[i],q)
                if i==len(tiles):
                    p=turn(p)
                    left,right=plus(left,1,right),plus(left,-1,right)
                    u,scale=tuple(2*v for v in u),2*scale
                    k+=1
                else:
                    step=tile(*tiles[i])
                    z=apply(step,z)
                    left,right=apply(step,left),apply(step,right)
                    u=apply(step,u)
            assert q==tuple(2**k*v for v in pair(z,z))+p
            assert q[:6]==plus(pair(left,left),1,pair(right,right))
            assert pair(u,u)==tuple(scale*v for v in q[:6])
            recovered=factor_rank_one(q[:6])
            assert recovered is not None and recovered[1]>=1
            assert p[0]**2+p[1]**2==1 and q[6]<=1+trace(q[:6])
            count+=1
    print(f"{count} mixed words obeyed the exact orbit formula. The octagon and all constructor implications passed.")


def turn(p):
    u,v=p
    return (3*u-4*v)/F(5),(4*u+3*v)/F(5)


def cross(a,b):
    return a[0]*b[1]-a[1]*b[0]

def angle(a,b):
    def half(p):
        return p[1]<0 or (p[1]==0 and p[0]<0)
    if half(a)!=half(b):return 1 if half(a) else -1
    c=cross(a,b)
    return -1 if c>0 else 1 if c<0 else 0

def facet_bound(n):
    p=(F(1),F(0))
    orbit=[]
    for _ in range(n+1):
        orbit.append(p)
        p=turn(p)
    ordered=sorted(orbit,key=cmp_to_key(angle))
    gaps=list(zip(ordered,ordered[1:]+ordered[:1]))
    assert all(cross(a,b)>0 for a,b in gaps)
    cos_gap=min(dot(a,b) for a,b in gaps)
    radius_sq=2*(1+F(1,2**n))**2/(1+cos_gap)
    separated=[]
    for u in ordered:
        if all(radius_sq*(1+dot(u,v))<2 for v in separated):
            separated.append(u)
    return len(separated),(len(separated)+1)//2

def probe_depth(point, slack):
    """Least level of the backwards chain, or None when no polyhedral typing exists."""
    if slack<=0:
        return 0 if slack==0 and point==(0,0) else None
    k=0
    while max(map(abs,point))>slack:
        if point[0]>1+slack:
            return None
        point=turn(point)
        slack*=2
        k+=1
    return k


def caller_depth(cells):
    """Least common probe depth for a finite union of closed polyhedra.

    Each nonempty cell supplies (base points, recession rays) in (x,y,t).
    Represent lineality by its two opposite rays and the empty union by [].
    """
    generators=[]
    for bases,rays in cells:
        if not bases:
            raise ValueError("a nonempty cell needs a base point")
        for group,offset in [(bases,1),(rays,0)]:
            for triple in group:
                x,y,t=map(F,triple)
                if t<0 or (t==0 and (x or y)):
                    return None
                generators.append(((x,y),t,offset))
    depth=0
    while not all(max(map(abs,p))<=t for p,t,_ in generators):
        if any(p[0]>offset+t for p,t,offset in generators):
            return None
        generators=[(turn(p),2*t,offset) for p,t,offset in generators]
        depth+=1
    return depth


def caller_checks():
    zero=([(0,0,0)],[])
    assert caller_depth([])==caller_depth([zero])==0
    for k in range(32):
        t=F(1,2**k)
        vertical=([(1,0,t)],[(0,0,1)])
        assert caller_depth([vertical,zero])==probe_depth((F(1),F(0)),t)==k
    # All base points pass, but a recession direction can fail a later guard.
    assert caller_depth([([(0,0,1)],[(0,-2,F(1,4))])]) is None
    assert caller_depth([([(0,0,1)],[(0,1,0)])]) is None
    assert caller_depth([([(0,0,1)],[(0,0,-1)])]) is None
    assert caller_depth([([(1,0,0)],[])]) is None
    assert caller_depth([([(0,0,1)],[(1,-1,1)])])==0


def probe_scheme(depth):
    """Emit the closed induction scheme and its exact lower slack at (1,0)."""
    guards=[]
    def side(x,y,rhs):
        lhs=" + ".join(f"{a} {name}" for a,name in [(x,"i"),(y,"j")] if a)
        guards.append(f"{lhs}≤{rhs}")
    c,s=F(1),F(0)
    for j in range(depth):
        side(c,-s,f"1 + {2**j} k")
        c,s=turn((c,s))
    for x,y in [(c,-s),(-c,s),(s,c),(-s,-c)]:
        side(x,y,f"{2**depth} k")
    bound=max(abs(c),abs(s))/2**depth
    decl=("datatype Probe : num * num * num\n"
          "datacons Spin : ∀i,j,k[i≤1+k]. Probe (3/5 i + -4/5 j,4/5 i + 3/5 j,2 k) ⟶ Probe (i,j,k)\n")
    return decl+"let rec probe : ∀i,j,k["+" ∧ ".join(guards)+"]. Probe (i,j,k) = Spin probe\n",bound


def native_heap(exe, folder, name, assertion):
    path=Path(folder)/(name+".gadt")
    path.write_text((HERE/path.name).read_text())
    build=subprocess.run([exe,"-inform","-overwrite_ml","-full_annot",path],
                         text=True,capture_output=True,timeout=40)
    assert build.returncode==0, build.stderr+build.stdout
    ml=path.with_suffix(".ml")
    with ml.open("a") as out:
        out.write("\nlet () = match at_start with "+assertion+"\n")
    subprocess.run(["ocaml","-noinit",ml],capture_output=True,check=True,timeout=10)


def native_schemes(exe, folder):
    """Compare exported typings at ground tuples with independent linear descriptions."""
    path=Path(folder)/"point.gadt"
    def compile_program(src, expected):
        path.write_text(src)
        run=subprocess.run([exe,"-inform","-no_ml","-no_sig",path],text=True,capture_output=True,timeout=15)
        assert (run.returncode==0)==expected, (src,run.stdout,run.stderr)
        if not expected:
            assert any(tag in run.stderr+run.stdout for tag in ("No answer","Contradiction")), (src,run.stdout,run.stderr)
        return run.stdout

    def program(rates,guard):
        fields=",".join(f"{k} {v}" for k,v in zip(rates,"ijk",strict=True))
        return (f"datatype D : num * num * num\ndatacons A : ∀i,j,k[i+j+k≤{guard}]. "
                f"D ({fields}) ⟶ D (i,j,k)\nlet rec v = A v\n")
    def feasible(*constraints):
        solver=z3.Solver()
        solver.add(*constraints)
        return solver.check()==z3.sat
    x,y,z=z3.Reals("base_x base_y base_z")
    t=z3.Real("mix")
    def cone(p):
        # P_old + the negative orthant. Both input polyhedra are cones.
        return feasible(x+y+z<=0,9*z+5*y>=0,y>=0,p[0]<=x,p[1]<=y,p[2]<=z)
    def affine(p):
        # The normalized homogeneous hull, including the recession directions
        # at mixing weights zero and one.
        u,v,w=(a-b for a,b in zip(p,(x,y,z),strict=True))
        cu,cv,cw=z3.Reals("upper_u upper_v upper_w")
        return feasible(t>=0,t<=1,x+y+z<=-t,10*z+9*y+6*t>=0,3*y+8*t>=0,
                        u+v+w<=t-1,2*u+v/2+w/3<=t-1,
                        u<=cu,cu<=0,v<=cv,cv>=0,w<=cw,cw>=0,
                        4*cu+cv/4+cw/9<=t-1)
    def reflected(p):
        a,b,c=p
        u,v,w=z3.Reals("upper_y upper_minus_y upper_z")
        return feasible(a+b+c<=0,a-b/2+c/4<=0,b<=u,-b<=v,u/2<=v,v/2<=u,
                        c<=w,w>=0,a+u/4+w/16<=0)
    points=list(product([-2,0,2],repeat=3))+[(F(-1,2),F(-1,2),F(1,2)),(1,-1,0),(-1,1,0)]
    count=0
    for rates,guard,wants in [((F(1,2),F(1,3),F(1,5)),0,cone),
                              ((2,F(1,2),F(1,3)),-1,affine),
                              ((1,F(-1,2),F(1,4)),0,reflected)]:
        src=program(rates,guard)
        for p in points:
            q=tuple(map(F,p))
            compile_program(src+"let at : D ("+",".join(map(str,q))+") = v\n",wants(q))
            count+=1
    # Try both sides of the finite alternative when the explicit hull is large.
    src=program((F(1,2),F(1,3),F(1,5)),1)
    for p in [(0,0,1),(-1,-1,-1),(2,2,2)]:
        compile_program(src+"let at : D ("+",".join(map(str,p))+") = v\n",sum(p)<=1)
    spectral=(HERE/"spectral_cyclic_value.gadt").read_text()
    info=compile_program(spectral,True)
    assert info.count("val ring :")==1 and "val middle :" in info
    for b in [F(5,2),F(8,3),F(9,2),10]:
        compile_program(spectral+f"let boundary : Orbit (0,0,0,{b},{b},{b}) = ring\n",b>=F(8,3))
    print(f"{count} ground typings matched rational hull or signed-component checks. The sharp scale passed.")
    for depth in [0,2,4,6,8,12]:
        src,bound=probe_scheme(depth)
        compile_program(src+f"let starts : ∀k[{bound}≤k]. Probe (1,0,k) = probe\n",True)
        compile_program(src+f"let outside : Probe (1,0,{bound/2}) = probe\n",False)
    print("Six generated probe schemes admitted their symbolic caller families and rejected smaller ground slacks.")


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compiler",type=Path)
    args=parser.parse_args()
    linear_checks()
    word_checks()
    caller_checks()
    assert [facet_bound(n) for n in [16,32,64,128,256]]==[(6,3),(13,7),(30,15),(47,24),(68,34)]
    assert probe_depth((F(1),F(0)),F(1,2**25))==25
    assert probe_depth((F(1),F(0)),F(0)) is None
    assert probe_depth((F(0),F(0)),F(0))==0
    assert probe_depth((F(2),F(0)),F(1,4)) is None
    print("Exact polygon checks force at least 34 public facets at slack 2^-768.")
    assert fixed_source(YES,True)==(HERE/"fixed_orbit.gadt").read_text()
    if args.compiler:
        exe=args.compiler.resolve()
        with TemporaryDirectory() as folder:
            native_heap(exe,folder,"fixed_orbit","Fork (a,b,c) -> assert (a==b && b==c && c==at_start)")
            native_heap(exe,folder,"split_orbit",
                        "Fork (a,b,(Spin c as p)) -> assert (a==at_start && b==a && p==probe && c==p)")
            print("The compiler checked both fixed-root programmes. OCaml verified the one- and two-node heaps.")
            native_schemes(exe,folder)


if __name__=="__main__":
    main()
