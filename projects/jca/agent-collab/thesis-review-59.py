"""Replay the public-facet lower bound, compact rational witnesses and native callers."""
import argparse
from fractions import Fraction as F
from itertools import combinations_with_replacement, product
from math import lcm
from pathlib import Path
import subprocess
from tempfile import TemporaryDirectory

HERE = Path(__file__).resolve().parent


def rotation(a):
    return (1-a*a)/(1+a*a), 2*a/(1+a*a)


def turn(p, cs):
    x,y=p
    c,s=cs
    return c*x-s*y,s*x+c*y


def squared(p):
    return sum(x*x for x in p)


def fold(p, depth):
    x,y=map(abs,p)
    original=squared(p)
    for j in range(1,depth+1):
        a=F(1,2**j)
        c,s=rotation(a)
        x,y=c*x+s*y,abs(c*y-s*x)
        assert x>=0 and 0<=y<=s*x/c and x*x+y*y==original
    final=x+a*y
    assert original<=final*final<=(1+a*a)*original
    return final


def family(n):
    h=F(1,2**n)
    rate=1+h**3/16
    depth=(3*n+5)//2
    delta=F(1,2*4**depth)
    assert 2*delta<=rate-1
    return rotation(h),rate,depth


def public_bound(n):
    """Check one angular net and slab in rational arithmetic for small n."""
    cs,rate,_=family(n)
    c,s=cs
    h=F(1,2**n)
    assert c*c+s*s==1 and rate>1
    points=[(F(1),F(0))]
    while True:
        q=turn(points[-1],cs)
        if points[-1][1]<0<=q[1] and q[0]>0:
            break
        points.append(q)
    k=len(points)-1
    assert k<7/h
    # Consecutive outer normals are a theta-turn apart. The wraparound gap
    # is positive and at most theta (its cosine is at least c).
    assert points[-1][0]>=c and points[-1][1]<0
    delta=(rate**(2*k)-1)/2
    assert delta<h*h
    outer_squared=(1+delta)**2*(1+h*h)
    assert outer_squared<1/(c*c)
    # Cover an arc shorter than a half turn. Consecutive selected directions
    # are two turns apart and require different vertices of the projection.
    selected=points[:2**n+1:2]
    assert all(y>=0 for x,y in selected)
    cos_two=c*c-s*s
    assert outer_squared*(1+cos_two)<2
    assert len(selected)==2**(n-1)+1
    return (len(selected)+1)//2


def polar_prefix(n):
    """First redundant future guard on all t >= 1, by an exact planar polar hull."""
    cs, rate, _ = family(n)
    direction, multiplier = (F(1), F(0)), F(1)
    hull = [(0, 0, 1, -1)]

    def cross(a, b, q):
        x,y,w = q[:3]
        return ((a[1]*b[2]-a[2]*b[1])*x + (a[2]*b[0]-a[0]*b[2])*y +
                (a[0]*b[1]-a[1]*b[0])*w)

    for j in range(23*2**n+1):
        x,y = (u/(1+multiplier) for u in direction)
        den = lcm(x.denominator, y.denominator)
        vertex = (int(x*den), int(y*den), den, j)
        if j < 2:
            # The origin and the first two directions are counterclockwise.
            hull.append(vertex)
        else:
            visible = [cross(a, hull[(i+1)%len(hull)], vertex) < 0 for i,a in enumerate(hull)]
            if not any(visible):
                faces = sorted(q[3] for i,q in enumerate(hull)
                               if cross(hull[i-1],q,hull[(i+1)%len(hull)]) > 0)
                assert faces[0] >= 0  # The origin is in the interior.
                return j, faces
            first = next(i for i in range(len(hull)) if visible[i] and not visible[i-1])
            end = next(i for i in range(len(hull)) if not visible[i] and visible[i-1])
            # A point outside a convex polygon sees one contiguous arc of edges.
            if first < end:
                hull = hull[:first+1]+[vertex]+hull[end:]
            else:
                hull = hull[end:first+1]+[vertex]
        direction = turn(direction,cs)
        multiplier *= rate
    raise AssertionError("the upper bound must contain a redundant guard")


def folding_checks():
    for depth in range(1,9):
        for x,y in product(range(-7,8),repeat=2):
            fold((F(x,3),F(y,7)),depth)
    for n in (2,4,8,12,20,40):
        cs,rate,depth=family(n)
        p=(F(2),F(0))
        t=F(1)
        for _ in range(12):
            assert p[0]<=1+t
            p=turn(p,cs)
            t*=rate
            assert fold(p,depth)<=1+t
    for n in range(2,6):
        assert public_bound(n)==2**(n-2)+1
    prefixes = [polar_prefix(n) for n in range(2,6)]
    rounds = [depth for depth,_ in prefixes]
    assert rounds == [51,76,151,201]
    assert [1+len(faces) for _,faces in prefixes] == [52,77,152,202]
    print(f"First redundant public guard for n=2 through 5: {rounds}.")
    _,_,depth=family(20)
    rows = 4*depth+8
    vertices = 2**19+1
    choices = (vertices+2*rows-1)//(2*rows)
    assert choices == 1928
    print(f"At n=20 the proof requires {2**18+1:,} public facets; the lifted proof has {rows} inequalities and {2*depth+2} private coordinates.")
    print(f"Opening that ground orbit with {rows} rows needs at least {choices:,} affine witness choices.")


def kernel(rows):
    """A rational basis for column vectors annihilated by all rows."""
    matrix = [list(map(F, row)) for row in rows]
    width = len(matrix[0])
    pivots = []
    for col in range(width):
        k = len(pivots)
        pivot = next((i for i in range(k, len(matrix)) if matrix[i][col]), None)
        if pivot is None:
            continue
        matrix[k], matrix[pivot] = matrix[pivot], matrix[k]
        matrix[k] = [a/matrix[k][col] for a in matrix[k]]
        for i, row in enumerate(matrix):
            if i != k and row[col]:
                matrix[i] = [a-row[col]*b for a, b in zip(row, matrix[k])]
        pivots.append(col)
    basis = []
    for free in (j for j in range(width) if j not in pivots):
        vector = [F(0)]*width
        vector[free] = F(1)
        for row, col in zip(matrix, pivots):
            vector[col] = -row[free]
        basis.append(vector)
    return basis


def measurements():
    """Recover the radius level and slack line after rational affine coordinate changes."""
    def multiply(a, b):
        return [[sum(x*y for x,y in zip(row,col)) for col in zip(*b)] for row in a]

    pairs = list(combinations_with_replacement(range(4), 2))

    def monomial_action(a):
        return [[a[i][k]*a[j][l] + (a[i][l]*a[j][k] if k != l else 0)
                 for k,l in pairs] for i,j in pairs]

    def eigenforms(action, eigenvalue):
        return kernel([[c-eigenvalue*(i==j) for j,c in enumerate(col)]
                       for i,col in enumerate(zip(*action))])

    def proportional(a, b):
        i = next(i for i,x in enumerate(a) if x)
        return b[i] != 0 and all(x*b[i] == y*a[i] for x,y in zip(a,b))

    identity = [[int(i==j) for j in range(4)] for i in range(4)]
    shears = [(0,1,2),(2,0,F(1,3)),(1,2,-1),(2,3,5),(0,3,-2)]
    checked = 0
    for n in (2,5,20):
        (c,s),rate,_ = family(n)
        action = [[c,-s,0,0],[s,c,0,0],[0,0,rate,0],[0,0,0,1]]
        original = identity
        for i,j,shift in shears:
            forward, back = ([row.copy() for row in identity] for _ in range(2))
            forward[i][j],back[i][j] = shift,-shift
            action = multiply(back, multiply(action, forward))
            original = multiply(original, forward)
            # Recover the two eigenform spaces from the transformed field alone.
            forms = eigenforms(monomial_action(action), 1)
            (a,b,c0), (d,e,f), (g,h,i0) = [row[:3] for row in action[:3]]
            multiplier = a*(e*i0-f*h)-b*(d*i0-f*g)+c0*(d*h-e*g)
            slacks = eigenforms(action, multiplier)
            assert multiplier == rate
            assert len(forms) == 2 and len(slacks) == 1
            assert proportional(original[2], slacks[0])
            squares = monomial_action(original)
            radius = [a+b for a,b in zip(squares[pairs.index((0,0))], squares[pairs.index((1,1))])]
            nonconstant = [q[:-1] for q in forms if any(q[:-1])]
            assert nonconstant and all(proportional(radius[:-1], q) for q in nonconstant)
            checked += 1
    print(f"Recovered the radius and slack on all {checked} affinely transformed instances.")


def folded_source(cs, rate, eps, depth, fixed=False):
    """Emit the lifted typing. Tight folds supply fresh witnesses at each opening."""
    c,s=cs
    private=[v+str(j) for j in range(depth+1) for v in ("i","j")]
    atoms=["i≤i0","-i≤i0","j≤j0","-j≤j0",f"{eps}≤k"]
    if fixed:
        atoms=[f"{c} i + {-s} j≤i0",f"{-c} i + {s} j≤i0",
               f"{s} i + {c} j≤j0",f"{-s} i + {-c} j≤j0","1≤k","i≤1+k"]
    for j in range(1,depth+1):
        a=F(1,2**j)
        u,v=rotation(a)
        x,y=f"i{j-1}",f"j{j-1}"
        atoms.extend([f"i{j}={u} {x} + {v} {y}",
                      f"{u} {y} + {-v} {x}≤j{j}",f"{v} {x} + {-u} {y}≤j{j}"])
    rhs=f"1+{rate} k" if fixed else "1+k"
    atoms.extend([f"j{depth}≤{v/u} i{depth}",f"i{depth} + {a} j{depth}≤{rhs}"])
    use="let use : Probe (2,0,1) = probe\n" if fixed else f"let use : ∀k[{eps}≤k]. Probe (1,0,k) = probe\n"
    return ("datatype Probe : num * num * num\n"
            f"datacons Spin : ∀i,j,k[i≤1+k]. Probe ({c} i + {-s} j,{s} i + {c} j,{rate} k) ⟶ Probe (i,j,k)\n"
            "let rec probe : ∀i,j,k,"+",".join(private)+"["+" ∧ ".join(atoms)+"]. Probe (i,j,k) = Spin probe\n"
            +use)


def invoke(exe,path,ok,flags=()):
    r=subprocess.run([exe,"-inform",*flags,path],text=True,capture_output=True,timeout=25)
    assert (r.returncode==0)==ok,(path.read_text(),r.stdout,r.stderr)
    if not ok:
        assert any(t in r.stdout+r.stderr for t in ("No answer","Contradiction")),r.stderr
    return r.stdout


def depth_for(p,t):
    p=tuple(map(F,p))
    t=F(t)
    if t<=0:
        return 0 if t==0 and p==(0,0) else None
    d=0
    while max(map(abs,p))>t:
        if p[0]>1+t:
            return None
        p=turn(p,rotation(F(1,2)))
        t*=2
        d+=1
    return d


def native_checks(exe):
    fixture=(HERE/"caller_cyclic_value.gadt").read_text()
    probe=fixture.split("let alias")[0]
    with TemporaryDirectory() as folder:
        p=Path(folder)/"cycle.gadt"
        p.write_text(fixture)
        out=invoke(exe,p,True,["-overwrite_ml","-full_annot"])
        assert out.count("val probe :")==1
        ml=p.with_suffix(".ml")
        with ml.open("a") as f:
            f.write("\nlet () = match family,starts,later with "
                    "Spin a,Fork(b,c),Pause(d,e,f) -> assert "
                    "(a==probe && b==both && c==both && d==paused && e==paused && f==paused)\n")
        subprocess.run(["ocaml","-noinit",ml],check=True,capture_output=True,timeout=10)
        count=0
        for x,y,t in product([-2,0,1,2],[-1,0,2],[F(0),F(1,8),F(1,2),2]):
            p.write_text(probe+f"let at : Probe ({x},{y},{t}) = probe\n")
            invoke(exe,p,depth_for((x,y),t) is not None,["-no_ml","-no_sig"])
            count+=1
        for d in [1,3,6,9,12]:
            p.write_text(probe+f"let alias = probe\nlet family : ∀n[1/{2**d}≤n]. Probe (1,0,n) = alias\n")
            invoke(exe,p,True,["-no_ml","-no_sig"])
        p.write_text(fixture+"let wrong : Branch (0,3,1/4) = both\n")
        invoke(exe,p,False,["-no_ml","-no_sig"])
        for layers in range(1,6):
            delta=F(1,2*4**layers)
            src=folded_source(rotation(F(1,2)),2,delta/(1-delta),layers)
            if layers==3:
                assert src==(HERE/"folded_cyclic_value.gadt").read_text()
            p.write_text(src)
            invoke(exe,p,True,["-no_ml","-no_sig"])
        cs,rate,layers=family(2)
        p.write_text(folded_source(cs,rate,1,layers,True))
        invoke(exe,p,True,["-full_annot","-overwrite_ml"])
        ml=p.with_suffix(".ml")
        with ml.open("a") as f:
            f.write("\nlet () = match use with Spin child -> assert (child==use)\n")
        subprocess.run(["ocaml","-noinit",ml],check=True,capture_output=True,timeout=10)
        print(f"All {count} ground calls matched the rational oracle. Five symbolic families and five lifted schemes passed; OCaml verified four recursive heaps, including the n=2 fixed caller.")


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compiler",type=Path)
    parser.add_argument("--instance",type=int,metavar="N",help="print the depth-N family member at the fixed caller")
    parser.add_argument("--folded",action="store_true",help="include its private certificate")
    parser.add_argument("--rounds",type=int,metavar="N",help="compute the exact public stabilization depth at N")
    args=parser.parse_args()
    if args.rounds is not None:
        if args.rounds<2:
            parser.error("use N >= 2")
        depth, faces = polar_prefix(args.rounds)
        print(f"First redundant guard at depth {depth}. The exact safe domain has {1+len(faces)} facets including the slack bound.")
        return
    if args.instance is not None:
        if args.instance<2:
            parser.error("use N >= 2")
        cs,rate,depth=family(args.instance)
        src=folded_source(cs,rate,1,depth,True)
        if not args.folded:
            src="\n".join("let rec probe = Spin probe" if line.startswith("let rec probe ") else line for line in src.splitlines())+"\n"
        print(src,end="")
        return
    folding_checks()
    measurements()
    if args.compiler:
        native_checks(args.compiler.resolve())


if __name__=="__main__":
    main()
