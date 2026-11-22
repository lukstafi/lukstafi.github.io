"""Check which captured inputs suffice for recursive affine suppliers."""
import argparse
from fractions import Fraction
from pathlib import Path
import random
import re
import runpy
import subprocess
from tempfile import TemporaryDirectory

import z3

HERE = Path(__file__).resolve().parent
read_numeric = runpy.run_path(str(HERE/"thesis-review-28.py"))["numeric_constraints"]


def independent(rows):
    """Keep original rows, eliminating over Q to decide independence."""
    kept, pivots = [], {}
    for original in rows:
        row = list(map(Fraction, original))
        for p in sorted(pivots):
            factor = row[p]
            if factor:
                row = [x-factor*y for x, y in zip(row, pivots[p])]
        p = next((i for i, x in enumerate(row) if x), None)
        if p is not None:
            pivots[p] = [x/row[p] for x in row]
            kept.append(original)
    return kept


def dot(u, v):
    return sum(a*b for a, b in zip(u, v))


def extend(rows, matrices):
    return independent(rows + [tuple(dot(row, col) for col in zip(*matrix))
                               for row in rows for matrix in matrices])


def depth_check(matrices, c, visible, domain):
    """Compare row closure with unfolding, allowing a new legal input at every call."""
    d = len(c)
    def vector(label):
        return [z3.Real(f"{label}_{i}") for i in range(d)]

    caller, answer = vector("caller"), vector("base")
    solver = z3.Solver()
    def same_interface(x):
        solver.add(*(dot(v, x) == dot(v, caller) for v in visible))
        solver.add(*(dot(v, x) == 0 for v in domain))
    same_interface(caller)
    same_interface(answer)
    given = independent(visible + domain)
    rows = independent([c])
    unsafe = False
    for depth in range(d+1):
        solver.push()
        solver.add(dot(c, answer) > dot(c, caller))
        check = solver.check()
        assert check in (z3.sat, z3.unsat)
        unsafe |= check == z3.sat
        solver.pop()
        predicts_safe = len(independent(given + rows)) == len(given)
        assert predicts_safe == (not unsafe), (depth, matrices, c, visible, domain)
        following = extend(rows, matrices)
        if depth == d:
            assert following == rows
            return
        rows = following
        parent, new_answer = vector(f"x{depth}"), vector(f"r{depth}")
        same_interface(parent)
        error = [a-x for a,x in zip(answer,parent)]
        solver.add(z3.Or(*(z3.And(*(r == x + dot(row,error)
                                    for r,x,row in zip(new_answer,parent,matrix)))
                           for matrix in matrices)))
        answer = new_answer


def check_closure():
    rng = random.Random(42)
    for trial in range(72):
        d = 1 + trial % 4
        def row():
            return tuple(Fraction(rng.choice((-2,-1,0,0,1,2)),rng.choice((1,1,2)))
                         for _ in range(d))
        matrices = [[row() for _ in range(d)] for _ in range(1 + trial % 3)]
        depth_check(matrices, row(), [row() for _ in range(rng.randrange(d+1))],
                    [row() for _ in range(rng.randrange(d))])
    a = [(0,1,0),(0,0,0),(0,0,0)]
    b = [(0,0,0),(0,0,1),(0,0,0)]
    first, second = (1,0,0),(0,1,0)
    rows = [first]
    assert extend(rows,[a]) == [first,second] and extend(rows,[b]) == rows
    assert extend(extend(rows,[a,b]),[a,b]) == [first,second,(0,0,1)]
    for matrices in ([a],[b],[a,b]):
        for captured in ([first],[first,second]):
            for domain in ([],[(0,1,-1)]):
                depth_check(matrices,first,captured,domain)
    print("Verified row closure against recursive unfolding on 84 systems and interfaces.")


def compare_projection(driver, eager):
    for size in range(1,8):
        pairs = [(z3.Real(f"j{n}"),z3.Real(f"l{n}")) for n in range(size)]
        clauses = " ∧ ".join(f"min(i+{u},{v})≤0" for u,v in pairs)
        output = subprocess.check_output([driver],input=f"1 i=max(0,k) ∧ {clauses}\n",text=True)
        k = z3.Real("k")
        decl = {str(x):x for pair in pairs for x in pair}
        formula, = z3.parse_smt2_string(f"(assert {output})",decls=dict(decl,k=k))
        assert z3.is_or(formula) and formula.num_args() == (2**(size+1) if eager else 2)
        m = z3.If(k>=0,k,0)
        expected = z3.And(*(z3.Or(m+u<=0,v<=0) for u,v in pairs))
        solver = z3.Solver()
        solver.add(z3.Xor(expected,formula))
        assert solver.check() == z3.unsat, size
    print(f"Verified seven projection sizes on the {'earlier' if eager else 'repaired'} solver.")


def programs(compiler):
    original = (HERE/"mixed_affine_capture.gadt").read_text()
    arg = "∀i,j,k. Num i → Num j → Num k → Nat → "
    def annotate(result, source=original):
        return source.replace("let rec run x y z =", "let rec run : "+arg+result+" = fun x y z ->")
    full = annotate("∃. (Num i, Num j, Num k)")
    weak = annotate("∃l. (Num i, Num j, Num l)")
    tied = full.replace("∀i,j,k.","∀i,j,k[j=k].").replace("Num j, Num k)","Num j, Num j)").replace("3 5 7","3 5 5")
    just_b = annotate("∃l,m. (Num i, Num l, Num m)").replace("x+b+(-1*y)","x")
    with TemporaryDirectory() as temp:
        def run(name, source, output, shape=None):
            path = Path(temp)/(name+".gadt")
            path.write_text(source)
            proc = subprocess.run([compiler,"-iterations_timeout","12","-no_verif","-full_annot",
                                   "-overwrite_ml",path],text=True,capture_output=True)
            if output is None:
                assert proc.returncode and "No answer in num" in proc.stdout+proc.stderr,(name,proc)
                return
            assert proc.returncode==0,(name,proc)
            runtime = subprocess.run(["ocaml",path.with_suffix(".ml")],text=True,capture_output=True,check=True)
            assert runtime.stdout==output,(name,runtime)
            signature = " ".join(path.with_suffix(".gadti").read_text().split())
            pattern = (r"val run : ∀([\w, ]+)\. Num (\w+) → Num (\w+) → Num (\w+) → Nat → "
                       r"∃([\w, ]*)\.\(Num (\w+), Num (\w+), Num (\w+)\)$")
            m = re.search(pattern,signature)
            assert m,signature
            public = m.groups()[1:4]
            private = tuple(filter(None,m[5].split(", ")))
            assert set(m[1].split(", "))==set(public) and not (set(public)&set(private))
            expected_args, expected_payload = shape.split("/")
            actual = public + m.groups()[5:]
            names = dict(zip(expected_args + expected_payload, actual))
            assert len(set(names.values())) == len(names)
            assert tuple(names[s] for s in expected_args+expected_payload) == actual,(name,signature)
            assert set(private) == {names[s] for s in set(expected_payload)-set(expected_args)}
        run("inferred",original,"3\n","xyz/xyz")
        run("written",full,"3\n","xyz/xyz")
        run("one_missing",weak,None)
        run("only_a",weak.replace("y+c+(-1*z)","y"),"3\n","xyz/xyu")
        run("only_b",just_b,"3\n","xyz/xuv")
        run("tied",tied,"3\n","xyy/xyy")
        run("outside",tied.replace("3 5 5","3 5 7"),None)
    print("Verified seven source programs, their accepted interfaces and their OCaml results.")


def atoms(text):
    return z3.And(*read_numeric(text,z3,z3.Real))


def equivalent(a,b):
    solver = z3.Solver()
    solver.add(z3.Xor(a,b))
    assert solver.check()==z3.unsat, (a,b,solver)


def affine(coefficients, variables, constant=0):
    terms = [f"{a} {v}" for a,v in zip(coefficients,variables) if a]
    if constant or not terms:
        terms.append(f"({constant})")
    return " + ".join(terms)


def check_joins(driver):
    variables = "ijklmn"
    symbolic = list(map(z3.Real,variables))
    rng = random.Random(420)
    requests, expected = [], []
    for trial in range(48):
        signs = [-1 if trial & (1<<i) else 1 for i in range(3)]
        lengths = [rng.choice((Fraction(1,2),Fraction(3,2),1,2,3,5)) for _ in range(3)]
        # Translate each axis by a public input and by its own offset.
        offsets = [rng.randint(-3,3) for _ in range(3)]
        rows, constants = [], []
        for i,sign in enumerate(signs):
            row = [0]*6
            row[i],row[i+3] = -sign,sign
            rows.append(row)
            constants.append(-sign*offsets[i])
        distances = [dot(row,symbolic)+c for row,c in zip(rows,constants)]
        faces = [affine(row,variables,c) for row,c in zip(rows,constants)]
        weights = [Fraction(1)/u for u in lengths]
        total = affine([dot(weights,col) for col in zip(*rows)],variables,dot(weights,constants))
        cells = []
        for i in range(3):
            others = [f"{f}=0" for j,f in enumerate(faces) if j!=i]
            cells.append(" ∧ ".join(others+[f"0≤{faces[i]}",f"{faces[i]}≤({lengths[i]})"]))
        region = z3.And(*(v>=0 for v in distances),dot(weights,distances)<=1)
        requests.append([total+"≤1",*cells])
        expected.append(region)
        # Every axis endpoint violates the smaller cap.
        requests.append([total+"≤1/2",*cells])
        expected.append(None)
        # Leave one axis unbounded while keeping the two other segments.
        requests.append([total+"≤1",cells[0].rsplit(" ∧ ",1)[0],*cells[1:]])
        expected.append(None)
    response = subprocess.check_output([driver],text=True,
                                      input="".join("\t".join(line)+"\n" for line in requests))
    lines = response.splitlines()
    assert len(lines)==len(requests)
    for line,region,request in zip(lines,expected,requests):
        if region is None:
            assert line=="missing",request
        else:
            assert line.startswith("\t"), request
            equivalent(atoms([" ".join(x.split()) for x in line.split("\t")[1:]]),region)
    print("Verified 48 translated and rescaled supplier joins and 96 failing bounds.")


def allowance(compiler, before=None):
    source = (HERE/"unit_result_allowance.gadt").read_text()
    def signed(signs, cap):
        head = [x for x,t in zip("lmn",signs) if t>0]+[x for x,t in zip("ijk",signs) if t<0]
        inputs = [x for x,t in zip("ijk",signs) if t>0]+[x for x,t in zip("lmn",signs) if t<0]
        bound = "+".join(head)+"≤"+"+".join(inputs)+f"+{cap}"
        observed = "+".join(f"({t}*({r}-{x}))" for t,r,x in zip(signs,"abc","xyz"))
        program = source.replace("l+m+n≤i+j+k+1",bound).replace("a+b+c-x-y-z", observed)
        program = program.replace("<= 1",f"<= {cap}").replace("z+1",f"z+({signs[2]*cap})")
        if signs[0]!=signs[1]:
            program=program.replace("x+b+(-1*y)","x+y+(-1*b)")
        if signs[1]!=signs[2]:
            program=program.replace("y+c+(-1*z)","y+z+(-1*c)")
        return program
    def check_scheme(sig,signs,cap):
        arrow = " ".join(sig.split()).split("val run : ")[1]
        pattern = (r"∀([\w, ]+)\. Num (\w+) → Num (\w+) → Num (\w+) → Nat → "
                   r"∃([\w, ]+)\[(.*?)\]\.\(Num (\w+), Num (\w+), Num (\w+)\)")
        m = re.fullmatch(pattern,arrow)
        assert m,arrow
        outer = m.group(2,3,4)
        inner = m.group(7,8,9)
        assert set(m[1].split(", "))==set(outer) and set(m[5].split(", "))==set(inner)
        assert len(set(outer+inner))==6
        error = [t*(z3.Real(y)-z3.Real(x)) for t,x,y in zip(signs,outer,inner)]
        equivalent(atoms(m[6].split(" ∧ ")),z3.And(sum(error)<=cap,*(e>=0 for e in error)))
    with TemporaryDirectory() as temp:
        def run(exe,src,output,budget=10):
            path = Path(temp)/"allowance.gadt"
            path.write_text(src)
            r=subprocess.run([exe,"-iterations_timeout",str(budget),"-full_annot","-no_verif",
                              "-overwrite_ml",path],capture_output=True,text=True)
            if output is None:
                assert r.returncode and "No answer" in r.stdout+r.stderr,(r.stdout,r.stderr)
                return r.stdout+r.stderr
            assert r.returncode==0,(r.stdout,r.stderr)
            actual=subprocess.check_output(["ocaml",path.with_suffix(".ml")],text=True)
            assert actual==f"{output}\n",actual
            return path.with_suffix(".gadti").read_text()
        run(compiler,source,None,3)
        check_scheme(run(compiler,source,1,4),(1,1,1),1)
        for bits in range(8):
            signs=tuple(-1 if bits & (1<<i) else 1 for i in range(3))
            for cap in (1,2):
                check_scheme(run(compiler,signed(signs,cap),cap),signs,cap)
        weighted = source.replace("l+m+n≤i+j+k+1","l+2 m+6 n≤i+2 j+6 k+6").replace(
            "a+b+c-x-y-z","a+2*b+6*c-x-2*y-6*z").replace("delta <= 1","delta <= 6")
        weighted = weighted.replace("x+b+(-1*y)","x+(2*b)+(-2*y)").replace(
            "y+c+(-1*z)","y+(3*c)+(-3*z)")
        check_scheme(run(compiler,weighted,6),(1,2,6),6)
        run(compiler,weighted.replace("6 k+6","6 k+5").replace("delta <= 6","delta <= 5"),None)
        seed = 'external let seed : Num 0 → ∃n[0≤n ∧ n≤1]. Num n = "fun _ -> 1"'
        interval = source.replace("let rec run", seed+"\n\nlet rec run").replace(
            "| Z -> (x,y,z+1)", "| Z -> let t = seed 0 in (x,y,z+t)")
        check_scheme(run(compiler,interval,1),(1,1,1),1)
        fractional = interval.replace("n≤1","2 n≤3").replace(
            "l+m+n≤i+j+k+1","2 l+2 m+2 n≤2 i+2 j+2 k+3").replace("delta <= 1","2*delta <= 3")
        check_scheme(run(compiler,fractional,1),(1,1,1),Fraction(3,2))
        triangle = interval.replace(seed,'external let seed : Num 0 → ∃l,m[0≤l ∧ 0≤m ∧ l+m≤1]. '
                                    '(Num l, Num m) = "fun _ -> (0,1)"').replace(
            "let t = seed 0 in (x,y,z+t)","let (u,v) = seed 0 in (x,y+u,z+v)")
        check_scheme(run(compiler,triangle,1),(1,1,1),1)
        unbounded = interval.replace("0≤n ∧ n≤1","0≤n").replace("fun _ -> 1","fun _ -> 2")
        run(compiler,unbounded,None)
        doubled=source.replace("y+c+(-1*z), z)","y+c+(-1*z), c)").replace("A (B Z)","B Z")
        run(compiler,doubled,None)
        run(compiler,doubled.replace("i+j+k+1","i+j+k+2").replace("<= 1","<= 2"),2)
        if before:
            assert "Answers do not converge" in run(before,source,None,80)
            ann=("let rec run : ∀i,j,k. Num i → Num j → Num k → Nat → "
                 "∃l,m,n[i≤l ∧ j≤m ∧ k≤n ∧ l+m+n≤i+j+k+1]. (Num l, Num m, Num n) = fun x y z ->")
            check_scheme(run(before,source.replace("let rec run x y z =",ann),1),(1,1,1),1)
    print("Checked 16 signed simplex schemes, the weighted face and its unsafe neighbor, three bounded seeds, an unbounded seed and both duplication controls.")


def old_passes(driver):
    with TemporaryDirectory() as temp:
        source=Path(temp)/"old.gadt"
        source.write_bytes((HERE/"unit_result_allowance.gadt").read_bytes())
        r=subprocess.run([driver,"-iterations_timeout","80","-no_verif","-no_ml","-no_sig",source],
                         text=True,capture_output=True)
    assert r.returncode and "Answers do not converge" in r.stdout+r.stderr
    passes = re.findall(r"^PASS (\d+) jump (\d+) init (\w+) previous-init (\w+) stable [^\n]+ pending (\w+)\n"
                        r"INPUT (.*?)\nSTORED (.*?)\nDEMAND (.*?)\nEND_PASS",r.stderr,re.M|re.S)
    assert [int(row[0]) for row in passes]==list(range(81))
    jumps=[]
    out = z3.Reals("out1 out2 out3")
    for no, threshold, init, prev, pending, args, package, demand in passes[1:]:
        n=int(no)
        if n>=int(threshold) and init==prev=="false":
            jumps.append(n)
        x,y,z=map(z3.Real,re.findall(r"Num (n\d+) →"," ".join(args.split())))
        package=" ".join(package.split())
        match=re.search(r"δ = \(\(Num (n\d+), Num (n\d+), Num (n\d+|\(n\d+ \+ 1\))\)\)",package)
        assert match,package
        relations=[f"{v} = {term.strip('()')}" for v,term in zip(out,match.groups())]
        relations += [a for a in package.split(" ∧ ") if "δ" not in a]
        actual=atoms(relations)
        hidden=[z3.Real(v) for v in set(re.findall(r"n\d+",package))-{str(x),str(y),str(z)}]
        if hidden:
            actual=z3.Exists(hidden,actual)
        a,b,c=[v-i for v,i in zip(out,(x,y,z))]
        if n%3==1:
            expected=z3.And(a==0,b==0,c==1)
        elif n%3==2:
            expected=z3.And(a==0,b>=0,c>=0,b+c<=1)
        else:
            base=z3.And(a>=0,b>=0,c>=0,a+b<=1,b+c<=1,a+c<=1)
            fact=demand.strip().split(" ≤ ")
            assert len(fact)==2
            payload=match.groups().index(fact[0])
            if n == 3:
                assert payload == 2
            assert fact[1]==str((x,y,z)[payload])
            expected=z3.And(base,(a,b,c)[payload]<=0)
        equivalent(actual,expected)
        assert (pending=="true")==bool(demand.strip())==(n%3==0)
    assert jumps==[9,21,45],jumps
    print("Checked the semantic forms of 80 stored updates and the three widening passes.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    for key in ("compiler","before","before-trace","join","projection","before-projection"):
        parser.add_argument("--"+key,type=Path)
    args = parser.parse_args()
    if args.before and not args.compiler:
        parser.error("--before requires --compiler")
    check_closure()
    if args.compiler:
        compiler=args.compiler.resolve(strict=True)
        programs(compiler)
        allowance(compiler,args.before and args.before.resolve(strict=True))
    if args.join:
        check_joins(args.join.resolve(strict=True))
    if args.before_trace:
        old_passes(args.before_trace.resolve(strict=True))
    if args.projection:
        compare_projection(args.projection.resolve(strict=True),False)
    if args.before_projection:
        compare_projection(args.before_projection.resolve(strict=True),True)
