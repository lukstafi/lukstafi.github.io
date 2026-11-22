"""Check compact guard certificates and the mixed native-payload decision."""
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
i, l, j, k, m, n = z3.Reals("i l j k m n")
PACKAGE = ("-1≤l ∧ l≤1 ∧ min(l+1,-l)≤0 ∧ min(l+i + -k,k+i + -l)≤0 "
           "∧ min(k + -1,l+1)≤0")
ADMIT = ["0≤k ∧ k≤1", "i=0 ∧ k=3"]


def eliminate(formula):
    return z3.Tactic("qe")(formula).as_expr()


def verdict(*facts):
    solver = z3.Solver()
    solver.add(*facts)
    result = solver.check()
    assert result != z3.unknown, solver.reason_unknown()
    return str(result)


def batch(driver, problems, timeout=None):
    lines = ["\t".join(fields) for fields, _ in problems]
    result = subprocess.run([driver], input="\n".join(lines)+"\n", text=True,
                            capture_output=True, check=True, timeout=timeout)
    actual = result.stdout.splitlines()
    assert len(actual) == len(problems)
    for line, answer, (_, expected) in zip(lines, actual, problems):
        assert answer.split() == list(expected), (line, answer, expected)


def dense_problems():
    rng = random.Random(41)

    def linear(variables):
        coefficients = [Fraction(rng.randint(-2, 2), rng.choice((1, 1, 2, 3))) for _ in variables]
        constant = rng.randint(-3, 3)
        expr = sum((z3.Q(c.numerator,c.denominator)*x for c,x in zip(coefficients, variables)), constant)
        source = [f"{c} {x}" for c,x in zip(coefficients, variables) if c]
        return " + ".join(source+[f"({constant})"]), expr

    def formula(variables):
        source, expr = [], []
        for _ in range(rng.randrange(4)):
            a,u = linear(variables)
            b,v = linear(variables)
            op = rng.randrange(4)
            source.append([f"{a}≤{b}", f"{a}={b}", f"min||max({a},{b})", f"min|max({a},{b})"][op])
            expr.append([u<=v, u==v, z3.Or(u<=0,v<=0),
                         z3.And(u<=0, v<=0, z3.Or(u==0,v==0))][op])
        return " ∧ ".join(source) or "0=0", z3.And(*expr)

    for trial in range(480):
        value = (("l", l), ("2 l", 2*l), ("i + 1/2 l", i+l/2))[trial%3]
        pre = formula([i,l])
        domains = [formula([i,j,k]) for _ in range(rng.randrange(4))]
        post = formula([i,l,j,k]+[m,n][:trial%3])
        if trial%5 == 0:
            post = post[0]+" ∧ 2 m=k+l", z3.And(post[1],2*m==k+l)
        if trial%7 == 0:
            pre = pre[0]+" ∧ 2 l=1", z3.And(pre[1],2*l==1)
        admits = z3.Or(*(a for _,a in domains))
        all_keys = eliminate(z3.ForAll([j,k],z3.Implies(admits,z3.Exists([m,n],post[1]))))
        expected = verdict(pre[1], all_keys), verdict(pre[1], all_keys, z3.IsInt(value[1]))
        yield [value[0],pre[0],post[0],*(a for a,_ in domains)], expected


def stress(driver, timeout):
    completed = 0
    incomplete = []
    for number, problem in enumerate(dense_problems(), 1):
        try:
            batch(driver, [problem], timeout)
        except subprocess.TimeoutExpired:
            incomplete.append(number)
            continue
        completed += 1
    print(f"{completed} generated problems agreed with Z3 for both sorts.", flush=True)
    if incomplete:
        raise SystemExit("Compiler queries exceeding the per-case limit: " +
                         ", ".join(map(str, incomplete)))


def boundaries(driver):
    # At either endpoint a second admitted key refutes the package.
    # Check rational open/closed intervals with arbitrary affine observations.
    problems = []
    for a in range(-3,3):
        for width in (0,1,2,3,4):
            b = a+width
            for left, right in ((True,True),(True,False),(False,True),(False,False)):
                domains = ["k= -1"]
                if left:
                    domains.append(f"k=0 ∧ 2 i={a}")
                if right:
                    domains.append(f"k=0 ∧ 2 i={b}")
                pre = f"i=l ∧ {a}≤2 l ∧ 2 l≤{b}"
                guard = z3.And(a<=2*l,2*l<=b,2*l!=a if left else True,2*l!=b if right else True)
                for value, obs in (("l",l),("2 l",2*l)):
                    problems.append(([value,pre,"k≤ -1",*domains],
                                     (verdict(guard),verdict(guard,z3.IsInt(obs)))))
    # These use unbounded intervals and a strict row with no payload coefficient.
    problems.extend([
        (["l","l=i","k≤0","k=0","i≤0 ∧ k=1"], ("sat","sat")),
        (["3/2","0=0","0=0"], ("sat","unsat")),
        (["l","l=1","2 m=k+l","2 k=1"], ("sat","sat")),
        (["l","l=1","l≤k","2 k=1"], ("unsat","unsat")),
    ])
    batch(driver, problems)
    different = sum(a!=b for _,(a,b) in problems)
    print(f"{len(problems)} boundary problems passed. {different} distinguish the sorts.",flush=True)


def compact_family(driver):
    cases = []
    def case(pre, keys, q, z):
        cases.append((["l",pre,PACKAGE,*keys],(q,z)))
    guard = "0≤l ∧ l≤1"
    case("0≤i ∧ i≤1 ∧ "+guard, ADMIT, "unsat","unsat")
    case("0≤i ∧ i≤1 ∧ l= -1", ADMIT, "sat","sat")
    case("i=0 ∧ "+guard, ADMIT[:1], "sat","sat")
    case("i=0 ∧ "+guard, ["k=3"], "unsat","unsat")
    for den in (1,2,3,4,5,8,13,16):
        t = den//2+1
        midpoints = [f"{2*t} k={2*u+1}" for u in range(t)]
        pre = f"{den} i=1 ∧ "+guard
        case(pre, midpoints,"unsat","unsat")
        # At least the right endpoint survives when the last midpoint is omitted.
        case(pre, midpoints[:-1],"sat","sat")
        case(pre, ["k=0","k=1"], "sat" if den>=2 else "unsat", "unsat")
        case(pre, ["2 k=1"], "sat" if den>=2 else "unsat", "sat" if den>=2 else "unsat")
        case(pre, ["k=l"], "unsat","unsat")
    batch(driver,cases)
    print(f"{len(cases)} compact-family checks passed.",flush=True)


def finite_cover(guard, admission, package, lo, hi):
    """Bisection on a compact scalar guard at one fixed rational input."""
    all_keys = z3.ForAll(k,z3.Implies(admission,package))
    assert verdict(guard, z3.Or(l<lo,hi<l)) == "unsat"
    if verdict(guard, eliminate(all_keys)) == "sat":
        return None
    todo, selected = [(Fraction(lo),Fraction(hi))], []
    while todo:
        a,b = todo.pop()
        part = z3.And(guard,a<=l,l<=b)
        if verdict(part) == "unsat":
            continue
        witness = z3.Solver()
        witness.add(admission, eliminate(z3.ForAll(l,z3.Implies(part,z3.Not(package)))))
        outcome = witness.check()
        if outcome == z3.sat:
            selected.append(witness.model().eval(k,model_completion=True))
        else:
            assert outcome == z3.unsat and a<b
            mid = (a+b)/2
            todo.extend(((mid,b),(a,mid)))
    for key in selected:
        assert verdict(z3.Not(z3.substitute(admission,(k,key)))) == "unsat"
    assert verdict(guard,*(z3.substitute(package,(k,key)) for key in selected)) == "unsat"
    return selected


def synthesize():
    keys = []
    for denominator in (0,1,2,3,4,5,8,13,16):
        x = z3.RealVal(0) if not denominator else z3.Q(1,denominator)
        admit = z3.Or(z3.And(0<=k,k<=1), z3.And(x==0,k==3))
        body = z3.And(-1<=l,l<=1,z3.Or(l==-1,l>=0),z3.Or(l+x<=k,k+x<=l),z3.Or(k<=1,l<=-1))
        guard = z3.And(l>=0,l<=1)
        found = finite_cover(guard,admit,body,0,1)
        assert found is not None and len(found) >= (denominator//2+1 if denominator else 1)
        keys.append(len(found))
    assert finite_cover(guard, z3.And(0<=k,k<=1), z3.BoolVal(True),0,1) is None
    assert finite_cover(z3.BoolVal(False), z3.BoolVal(False),body,0,1) == []
    print(f"Constructed and independently rechecked nine finite covers with sizes {keys}.",flush=True)


def programs(compiler, before):
    src = (HERE/"fractional_guard_result.gadt").read_text()
    with TemporaryDirectory() as temp:
        def run(exe, name, source, expected=None, opts=()):
            path = Path(temp)/(name+".gadt")
            path.write_text(source)
            proc = subprocess.run([exe,"-iterations_timeout","2","-no_verif","-full_annot",
                                   "-overwrite_ml",*opts,path],text=True,capture_output=True)
            if expected is None:
                assert proc.returncode and "Type mismatch" in proc.stdout+proc.stderr,(name,proc)
                return
            assert proc.returncode==0,(name,proc.stdout,proc.stderr)
            out = subprocess.run(["ocaml",path.with_suffix(".ml")],check=True,text=True,capture_output=True)
            assert out.stdout==expected,(name,out)
            return path.with_suffix(".gadti").read_text()

        sig = run(compiler,"native",src,"0\n")
        prior = runpy.run_path(str(HERE/"thesis-review-36.py"))
        arrow = " ".join(sig.split()).split("val run : ")[1]
        pattern = r"∀([\w, ]+)\[(.*?)\]\. Num (\w+) → Nat → ∃(\w+)\[(.*?)\]\.\s*Num (\w+)"
        names, pre, flag, r, post, result = re.fullmatch(pattern,arrow).groups()
        assert r == result
        key, = set(names.split(", "))-{flag}
        f,k1,r1 = map(z3.Real,(flag,key,r))
        parse = lambda phi: z3.And(*prior["read_atoms"](phi.split(" ∧ "),z3,z3.Real))
        prior["equivalent"](parse(pre),z3.And(0<=f,f<=2,0<=k1,k1<=1))
        prior["equivalent"](parse(post),z3.And(0<=r1,2*r1<=3,z3.Or(r1<=0,3<=2*r1),r1<=k1+2))
        live = src.replace("2 l≤3","2 l≤4").replace("3 + -2 l","4 + -2 l")
        live = live.replace("fun _ -> 0","fun _ -> 2").replace("v = 0","true")
        run(compiler,"reachable_two",live)
        def observe_arm(program, representation, zero):
            declaration = (f'external let hit : ∀i. Num i → Num 0 = '
                           f'"fun v -> print_endline (string_of_{representation} v); {zero}"\n')
            return program.replace("let rec run",declaration+"let rec run").replace("-> True","-> hit r")
        run(compiler,"numeric_two",observe_arm(live,"int","0"),"2\n0\n")
        floating = src.replace("fun _ -> 0","fun _ -> 1.5").replace("string_of_int","string_of_float")
        floating = floating.replace("v = 0","true")
        run(compiler,"reachable_float",floating,opts=("-num_is","float"))
        run(compiler,"numeric_float",observe_arm(floating,"float","0."),"1.5\n0.\n",("-num_is","float"))
        if before:
            run(before,"old_native",src)
    print("Verified the full scheme, native and float executions, and both reachable-guard controls.",flush=True)


if __name__=="__main__":
    cli = argparse.ArgumentParser(description=__doc__)
    cli.add_argument("--driver",type=Path)
    cli.add_argument("--compiler",type=Path)
    cli.add_argument("--before",type=Path)
    cli.add_argument("--stress",action="store_true",
                     help="also compare 480 seeded dense formulas against Z3")
    cli.add_argument("--case-timeout",type=float,metavar="SECONDS",
                     help="limit each stress query and report every unfinished case")
    args = cli.parse_args()
    if args.before and not args.compiler:
        cli.error("--before requires --compiler")
    if args.stress and not args.driver:
        cli.error("--stress requires --driver")
    if args.case_timeout is not None and (not args.stress or args.case_timeout <= 0):
        cli.error("--case-timeout requires --stress and a positive duration")
    synthesize()
    if args.driver:
        driver = args.driver.resolve(strict=True)
        boundaries(driver)
        compact_family(driver)
    if args.compiler:
        programs(args.compiler.resolve(strict=True),args.before and args.before.resolve(strict=True))
    if args.stress:
        stress(driver,args.case_timeout)
