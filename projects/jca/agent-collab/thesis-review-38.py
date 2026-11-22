"""Compare projected admissions with quantified rational arithmetic and replay recursive calls."""
import argparse
from pathlib import Path
import random
import re
import runpy
import subprocess
from tempfile import TemporaryDirectory

import z3

HERE = Path(__file__).resolve().parent
prior = runpy.run_path(str(HERE / "thesis-review-37.py"))


def projection_oracle(driver):
    rng = random.Random(38)
    xs = z3.Reals("i j k l")
    lines, expected = [], []
    for trial in range(1280):
        mask = trial % 16
        def term():
            cs = [rng.choice([-2,-1,0,0,0,1,2]) for _ in xs]
            offset = rng.randint(-2,2)
            ds = [rng.choice([1,1,2,3]) for _ in range(5)] if trial >= 640 else [1]*5
            def coefficient(a,d):
                return str(a) if d == 1 else f"{a}/{d}"
            terms = [f"{coefficient(a,d)} {x}" for a,d,x in zip(cs,ds,xs) if a]
            terms.append(f"({coefficient(offset,ds[-1])})")
            return " + ".join(terms),sum(
                (z3.Q(a,d)*x for a,d,x in zip(cs,ds,xs)), z3.Q(offset,ds[-1]))
        atoms, source = [], []
        for _ in range(1 + rng.randrange(6)):
            (a,u),(b,v) = term(),term()
            op = rng.randrange(4)
            source.append([f"{a}≤{b}",f"{a}={b}",f"min||max({a},{b})",f"min|max({a},{b})"][op])
            atoms.append([u<=v,u==v,z3.Or(u<=0,v<=0),
                          z3.And(u<=0,v<=0,z3.Or(u==0,v==0))][op])
        lines.append(f"{mask} " + " ∧ ".join(source))
        hidden = [x for n,x in enumerate(xs) if (mask >> n) & 1]
        phi = z3.And(*atoms)
        expected.append(z3.Exists(hidden,phi) if hidden else phi)
    run = subprocess.run([driver], input="\n".join(lines)+"\n",capture_output=True,text=True)
    if run.returncode:
        raise RuntimeError((lines[len(run.stdout.splitlines())],run.stderr))
    actual = run.stdout.splitlines()
    assert len(actual) == len(expected)
    for src,want,got in zip(lines,expected,actual):
        formula, = z3.parse_smt2_string(f"(assert {got})",decls={str(x):x for x in xs})
        s = z3.Solver()
        s.add(z3.Xor(formula,want))
        assert s.check() == z3.unsat,(src,got,s)
    print(f"All {len(lines)} projections agree with quantified linear arithmetic.")


def check_digits(driver, paired=False):
    k = z3.Real("k")
    values = [0]
    counts = []
    for length in range(6):
        output = subprocess.check_output([driver,"--digits",str(length)],text=True).splitlines()
        count = int(output[0])
        cells = [z3.parse_smt2_string(f"(assert {row})",decls={"k":k})[0]
                 for row in output[1:]]
        assert len(cells) == count
        prior["prior"]["equivalent"](z3.Or(*cells),z3.Or(*(k==v for v in values)))
        if length >= 2:
            per_cell = 2 if paired else 1
            assert count * per_cell == len(values)
            for cell in cells:
                s = z3.Solver()
                s.add(cell)
                for _ in range(per_cell):
                    assert s.check() == z3.sat
                    witness = s.model().eval(k)
                    s.add(k != witness)
                assert s.check() == z3.unsat
        counts.append(count)
        values = [3*v+b for v in values for b in (0,2)]
    print(f"Projected ternary-digit cell counts at lengths 0 through 5: {counts}")


def check_compound(sig):
    arrow = " ".join(sig.split()).split("val run : ")[1]
    quant,pre,flag,width,total,postvar,post,payload = re.fullmatch(
        r"∀([\w, ]+)\[(.*?)\]\. Num (\w+) → Num (\w+) → Num (\w+) → Nat → ∃(\w+)\[(.*?)\]\.\s*Num (\w+)",
        arrow).groups()
    assert postvar == payload
    key, = set(quant.split(", "))-{flag,width,total}
    for sort in (z3.Int,z3.Real):
        f,n,t,k,r = map(sort,(flag,width,total,key,payload))
        def formula(s):
            return z3.And(*prior["prior"]["read_atoms"](s.split(" ∧ "),z3,sort))
        prior["prior"]["equivalent"](formula(pre),z3.And(
            0<=f,f<=1,2<=n,n<=t,0<=k,k<=n,z3.Or(k<=0,1<=f)))
        prior["prior"]["equivalent"](formula(post),z3.And(
            0<=r,r<=f,z3.Or(k+r<=n,n+2<=k+r)))


def check_programs(compiler, before=None):
    raw = (HERE / "switched_result_band.gadt").read_text()
    def quantified(phi):
        return raw.replace("∀i,n,k[", f"∀i,n,k,j[{phi} ∧ ")
    strip = (HERE / "private_result_key.gadt").read_text()
    assert strip == quantified("j≤k ∧ k≤j+1")
    equal = quantified("j=k")
    tied = equal.replace("∃l[", "∃l[l≤j+2 ∧ ")
    staged = (HERE / "staged_result_keys.gadt").read_text()
    endpoints = (HERE / "two_result_interval.gadt").read_text()

    with TemporaryDirectory() as folder:
        out = Path(folder)
        def run(exe, name, src, budget=2, error=None):
            return prior["compile_and_run"](out,exe,name,src,
                options=("-iterations_timeout",str(budget),"-full_annot"),error=error)
        for name,src in [("equal",equal),("strip",strip),("half",quantified("2 j=k")),
                         ("maximum",quantified("j=max(k,1 + -k)"))]:
            sig = run(compiler,name,src)
            prior["contract"](sig,"switch")
            result = subprocess.run(["ocaml",str(out / (name+".ml"))],
                                    text=True,capture_output=True,check=True).stdout
            assert result == "0\n0\n"
        compound = (HERE / "compound_result_key.gadt").read_text()
        check_compound(run(compiler,"compound",compound))
        for name,src,marker in [("staged",staged,"∀k,n["),("endpoints",endpoints,"∀i,k,n[")]:
            ordinary = run(compiler,name,src)
            hidden = src.replace(marker,marker[:-1]+",j[j≤k ∧ k≤j+1 ∧ ")
            actual = run(compiler,name+"_hidden",hidden)
            assert " ".join(actual.split()) == " ".join(ordinary.split()),(name,ordinary,actual)
        negative = prior["sources"]()
        def private(src):
            return src.replace("∀i,n,k[","∀i,n,k,j[j=k ∧ ")
        run(compiler,"reachable",private(negative["bad"]),error="Type mismatch")
        live = run(compiler,"reachable_live",private(negative["live"]))
        prior["contract"](live,"live")
        run(compiler,"tied",tied,error="Type mismatch")
        run(compiler,"tied_high",tied,10000,error="Type mismatch")
        run(compiler,"tied_exact",tied.replace("∃l[","∃l[l=0 ∧ "))
        tied_live = run(compiler,"tied_live",tied.replace("-> True","-> 0"))
        quotient = raw.replace("∃l[","∃l[l≤k+2 ∧ ")
        assert run(compiler,"substituted",quotient).split() == tied_live.split()
        if before:
            run(before,"frozen",equal,10000,error="Type mismatch")
            run(before,"frozen_sum",compound,error="Type mismatch")

    print("Checked hidden witnesses, shared package coordinates and exported schemes.")


if __name__ == "__main__":
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("compiler", nargs="?",type=Path)
    p.add_argument("--before", type=Path,help="revision be8af94")
    p.add_argument("--numeric-driver", type=Path)
    p.add_argument("--paired-digits", action="store_true",
                   help="check the later projector that retains two digit values per cell")
    args = p.parse_args()
    if not (args.compiler or args.numeric_driver):
        p.error("supply a compiler or a numeric driver")
    if args.numeric_driver:
        driver = args.numeric_driver.resolve(strict=True)
        projection_oracle(driver)
        check_digits(driver, args.paired_digits)
    if args.compiler:
        check_programs(args.compiler.resolve(strict=True),
                       args.before.resolve(strict=True) if args.before else None)
