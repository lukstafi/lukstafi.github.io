"""Replay guard-local admission and compare the numeric implication checker with Z3."""
import argparse
from concurrent.futures import ThreadPoolExecutor
import os
from pathlib import Path
import random
import re
import runpy
import subprocess
from tempfile import TemporaryDirectory

import z3

HERE = Path(__file__).resolve().parent
prior = runpy.run_path(str(HERE/"thesis-review-36.py"))
compile_and_run = prior["compile_and_run"]


def sources():
    switch = (HERE/"switched_result_band.gadt").read_text()
    bad = switch.split("test ")[0].replace("| Z -> 0", "| Z -> 1").replace("l≤i", "l≤1")
    bad += "test (let q = run 1 4 (S (S Z)) in observe q)\n"
    live = bad.replace("-> True", "-> 1").replace("_ -> 0", "_ -> 1").replace("v = 0", "v >= 0")
    private = switch.replace("∀i,n,k[", "∀i,n,k,j[j=k ∧ ")
    effect = switch.replace("let rec run", """external let touch : ∀j. Num j → Num j = "fun n -> print_char '!'; n"
let rec run""").replace("run flag width d", "run flag (touch width) d").replace("∃l[", "∃j,l[l=k+j ∧ ")
    return {
        "switch": switch, "opposite": (HERE/"opposite_result_bands.gadt").read_text(),
        "lower": switch.replace(" && r <= flag", ""), "unbounded": switch.replace(" ∧ 0≤k", ""),
        "upper": switch.replace("0≤l ∧ l≤i","0≤l+i ∧ l≤0").replace(
            "k+l + -n,n+2 + -k + -l", "k + -l + -n,n+2 + -k+l").replace(
            "r when 1 <= r && r <= flag","r when r <= (-1)"),
        "bad": bad, "live": live, "effect": effect,
        "nonrefuting": bad.replace(" ∧ min(k+l + -n,n+2 + -k + -l)≤0", " ∧ l≤k+2"),
        "private": private, "private_live": private.replace("-> True","-> 0"),
        "private_exact": private.replace("∃l[","∃l[l=0 ∧ "),
    }


def contract(sig, case):
    arrow = " ".join(sig.split()).split("val run : ")[1]
    quant, pre, flag, width, hidden, post, payload = re.fullmatch(
        r"∀([\w, ]+)\[(.*?)\]\. Num (\w+) → Num (\w+) → Nat → ∃([\w, ]+)\[(.*?)\]\.\s*Num (\w+)", arrow
    ).groups()
    key, = set(quant.split(", "))-{flag,width}
    for sort in (z3.Int, z3.Real):
        f,n,k,r = map(sort,(flag,width,key,payload))
        def read(txt):
            return z3.And(*prior["read_atoms"](txt.split(" ∧ "),z3,sort))
        def outside(h):
            return z3.Or(k+1<=h,h+1<=k)
        domain = z3.And(0<=f, f<=1, 2<=n, k<=n, z3.Or(k<=0,1<=f))
        if case != "unbounded":
            domain = z3.And(domain,0<=k)
        shape = z3.And(0<=r,r<=f,outside(n+1-r))
        if case == "opposite":
            domain = z3.And(2<=n, -n<=k, k<=n, z3.Or(f==0,f==1),
                            z3.Or(f==0,k<=0),z3.Or(f==1,0<=k))
            shape = z3.And(0<=r,r<=1,outside(n+1-r),outside(-n-1+r))
        elif case == "upper":
            shape = z3.And(-f<=r,r<=0,outside(n+1+r))
        elif case in ("live","mutant"):
            domain = z3.And(domain,outside(n))
            shape = z3.And(0<=r,r<=1,outside(n+1-r))
        elif case == "private_exact":
            shape = z3.And(r==0,shape)
        aux = [sort(x) for x in hidden.split(", ") if x!=payload]
        if case == "effect":
            j, = aux
            prior["equivalent"](read(post),z3.And(shape,r==k+j))
        prior["equivalent"](read(pre),domain)
        prior["equivalent"](z3.Exists(aux,read(post)) if aux else read(post),shape)


def numeric_oracle(driver):
    rng = random.Random(37)
    x,y = z3.Reals("x y")
    def term(t):
        a,b,c = t
        return a*x+b*y+c
    def atom(a):
        op,left,right = a
        u,v = term(left),term(right)
        return (u<=v,u==v,z3.Or(u<=0,v<=0),z3.And(u<=0,v<=0,z3.Or(u==0,v==0)))[op]
    def formula(xs):
        return z3.And(*map(atom,xs))
    def encode(xs):
        return [len(xs),*(v for op,a,b in xs for v in (op,*a,*b))]
    def random_atom():
        def affine():
            return tuple(rng.randint(-2,2) for _ in range(3))
        return rng.randrange(4),affine(),affine()
    def rows(size):
        return [random_atom() for _ in range(rng.randint(0,size))]
    inputs,expected = [],[]
    for _ in range(512):
        pre = rows(3)
        clauses = [(rows(2),rows(2)) for _ in range(rng.randrange(6))]
        problem = [*encode(pre),len(clauses)]
        s = z3.Solver()
        s.add(formula(pre))
        for cond,post in clauses:
            problem.extend(encode(cond)+encode(post))
            s.add(z3.Implies(formula(cond),formula(post)))
        inputs.append(" ".join(map(str,problem)))
        expected.append(str(s.check()))
    actual = subprocess.run([driver],input="\n".join(inputs)+"\n",text=True,
                            capture_output=True,check=True,timeout=90).stdout.splitlines()
    assert len(actual)==len(expected)
    for i,(a,b) in enumerate(zip(actual,expected)):
        assert a==b,(i,inputs[i],a,b)
    print(f"Numeric oracle agreed on {len(inputs)} rational formulas ({expected.count('sat')} satisfiable).")


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("compiler", type=Path)
    p.add_argument("--before", type=Path, help="compiler at 98a3e17")
    p.add_argument("--trace", type=Path, help="review 22, 23, 24, 26 and 37 diagnostics")
    p.add_argument("--written-only", type=Path, help="drop inferred admission goals only for conditional probes")
    p.add_argument("--numeric-driver", type=Path, help="compiled thesis-review-37-numeric.ml")
    opts = p.parse_args()
    exe = opts.compiler.resolve(strict=True)
    cases = sources()
    with TemporaryDirectory() as tmp:
        out = Path(tmp)
        def run(job):
            case,budget,full = job
            work = out/f"{case}-{budget}-{full}"; work.mkdir()
            flags = ("-iterations_timeout",str(budget), *(("-full_annot",) if full else ()))
            error = "Type mismatch" if case in ("bad","private","nonrefuting") else None
            sig = compile_and_run(work,exe,case,cases[case],options=flags,error=error)
            if error:
                return
            outcode = subprocess.run(["ocaml",work/(case+".ml")],text=True,capture_output=True,check=True)
            assert outcode.stdout == {"live":"1\n","effect":"!!0\n!!0\n"}.get(case,"0\n0\n"),(case,outcode)
            return case,sig
        jobs = [(n,2,True) for n in cases] + [("opposite",2,False),("private",10000,True)]
        with ThreadPoolExecutor(4) as pool:
            for pair in pool.map(run,jobs):
                if pair:
                    contract(pair[1],pair[0])
        path = out/"switch-2-True/switch.gadt"
        r = subprocess.run([exe,"-num_is","float","-no_sig","-no_ml","-no_verif",path],
                           text=True,capture_output=True,timeout=60)
        assert r.returncode and "Type mismatch" in r.stdout+r.stderr
        if opts.before:
            compile_and_run(out,opts.before.resolve(strict=True),"old",cases["switch"],
                            options=("-iterations_timeout","10000"),error="Type mismatch")
        if opts.written_only:
            sig = compile_and_run(out,opts.written_only.resolve(strict=True),"mutant",cases["bad"],
                                  options=("-iterations_timeout","2","-full_annot"),runtime_error=True)
            contract(sig,"mutant")
            ocaml = subprocess.run(["ocaml",out/"mutant.ml"],text=True,capture_output=True)
            line = int(re.search(r'mutant\.ml",\s*(\d+),',ocaml.stderr)[1])
            assert "-> assert false" in (out/"mutant.ml").read_text().splitlines()[line-1]
        if opts.trace:
            trace = opts.trace.resolve(strict=True)
            for name in ("opposite","switch","nonrefuting","private"):
                src = out/f"{name}-2-True"/(name+".gadt")
                r = subprocess.run([trace,"-iterations_timeout","2","-no_ml","-no_sig","-no_verif",src],
                                   env=dict(os.environ,JCA_SINGLE_PROBES="1"),capture_output=True,text=True,timeout=180)
                report = r.stdout+r.stderr
                assert (r.returncode==0)==(name in ("switch","opposite"))
                assert max(map(int,re.findall(r"^TRACE enter (\d+)",report,re.M)))==2
                assert not re.search(r"^JUMP \d+ true",report,re.M)
                if name=="opposite":
                    assert "GUARD_COVER 4 true\n"+"GUARD_SINGLE false\n"*4 in report
                elif name=="switch":
                    assert re.search(r"GUARD_COVER \d+ true",report)
                else:
                    assert re.search(r"GUARD_COVER \d+ false",report)
            runpy.run_path(str(HERE/"thesis-review-29.py"))["check_climb_jump"](trace,HERE/"capped_climb.gadt")
        if opts.numeric_driver:
            numeric_oracle(opts.numeric_driver.resolve(strict=True))
    print("Verified the conditional guard covers, public types, executions and witness controls.")


if __name__ == "__main__":
    main()
