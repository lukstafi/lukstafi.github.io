"""Replay two typings of one recursive result and the punctured-key counterexample."""
import argparse
import os
from pathlib import Path
import re
import runpy
import subprocess
from tempfile import TemporaryDirectory

import z3
from z3.z3util import get_vars

HERE = Path(__file__).resolve().parent
previous = runpy.run_path(str(HERE / "thesis-review-28.py"))


def same_formula(actual, expected):
    solver = z3.Solver()
    solver.set(timeout=10000)
    solver.add(z3.Xor(actual, expected))
    verdict = solver.check()
    assert verdict == z3.unsat, (actual, expected, verdict)


def public_interval(signature, *, sign=1, slack=0, narrowed=False):
    sig = " ".join(signature.split()).split("val run : ")[1]
    quant, pre, state, width, hidden, post, payload = re.match(
        r"∀([\w, ]+)\[(.*?)\]\. State (\w+) → Num (\w+) → Nat → ∃([\w, ]+)\[(.*?)\]\.\s*Num (\w+)",
        sig).groups()
    key, = set(quant.split(", ")) - {state,width}
    private = [v for v in hidden.split(", ") if v != payload]
    for sort in (z3.Int, z3.Real):
        s,n,k,r = map(sort,(state,width,key,payload))
        def read(formula):
            return z3.And(*previous["numeric_constraints"](formula.split(" ∧ "), z3, sort))
        domain = z3.And(z3.Or(s == -sign, s == sign), n >= int(narrowed),
                        s-n <= k, k <= s-int(narrowed))
        same_formula(read(pre), domain)
        body = read(post)
        if private:
            body = z3.Exists(list(map(sort,private)), body)
        same_formula(body, z3.And(k <= r, r <= k+n+slack))


def public_puncture(signature, *, bounded):
    sig = " ".join(signature.split()).split("val run : ")[1]
    quant,pre,size,out,post,payload = re.match(
        r"∀([\w, ]+)\[(.*?)\]\. Num (\w+) → Nat → ∃(\w+)\[(.*?)\]\.\s*Num (\w+)",sig).groups()
    key, = set(quant.split(", ")) - {size}
    assert out == payload
    for sort in (z3.Int,z3.Real):
        n,k,r = map(sort,(size,key,payload))
        def read(formula):
            return z3.And(*previous["numeric_constraints"](formula.split(" ∧ "),z3,sort))
        same_formula(read(pre),z3.And(1 <= k,k <= n,n <= 2 if bounded else z3.BoolVal(True)))
        body = z3.And(0 <= r,r <= n,z3.Or(r+1 <= k,k+1 <= r))
        same_formula(read(post),body if bounded else z3.And(body,r == 0))


def check_punctures():
    n,r,k,w = z3.Ints("n r k w")
    dom = z3.And(n >= 1, r >= 0, r <= n)
    keys = z3.And(1 <= k, k <= n)
    accepts = z3.And(r >= 0, r <= n, z3.Or(r+1 <= k, k+1 <= r))
    same_formula(z3.And(dom,z3.ForAll(k,z3.Implies(keys,accepts))), z3.And(dom,r == 0))
    # For fixed n the hidden quotient occurs only linearly.
    for width in (1, 2, 3, 31, 1024):
        section = z3.And(0 <= r, r <= width, 1 <= k, k <= width)
        delta = r-k-(width+1)*w
        bounds = z3.And(1 <= delta,delta <= width)
        witness = z3.If(r < k, -1, 0)
        same_formula(z3.And(section,r != k), z3.And(section,z3.substitute(bounds,(w,witness))))
        same_formula(z3.And(section,bounds,r == k), z3.BoolVal(False))


def projected_guards(report):
    after_pair = report.split("PAIRED_RETRY run", 1)[1]
    guards = re.findall(r"LIVE_GUARD (.*?) END_LIVE_GUARD", after_pair, re.S)
    assert len(guards) == 2
    for guard in guards:
        atoms = " ".join(guard.split()).split(" ∧ ")
        # Each freshly opened copy contains 0 ≤ payload.
        payloads = [a.split()[-1] for a in atoms if re.fullmatch(r"0 ≤ n\d+", a)]
        assert len(payloads) == 2 and payloads[0] != payloads[1]
        for sort in (z3.Int,z3.Real):
            n,k,r,t = map(sort,("n","k",*payloads))
            full = z3.And(*previous["numeric_constraints"](atoms,z3,sort))
            hidden = [v for v in get_vars(full) if not any(v.eq(x) for x in (n,k,r,t))]
            same_formula(z3.Exists(hidden,full), z3.And(1 <= k,k <= n,2 <= r,r <= n-1,t == r))


def trace_run(exe, file, budget, annotation):
    p = subprocess.run([exe, "-no_sig", "-no_ml", "-no_verif", *annotation,
                        "-iterations_timeout", str(budget), file], text=True, capture_output=True,
                       timeout=180, env=dict(os.environ,JCA_TRACE_DEMAND="1",JCA_TRACE_LIVE_GUARD="1"))
    return p.returncode, p.stdout+p.stderr


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("compiler", type=Path)
    parser.add_argument("--before", type=Path, help="stock executable at 3408672")
    parser.add_argument("--trace", type=Path, help="repaired executable with the review 28 and 33 diagnostics")
    parser.add_argument("--missing-admission", type=Path, help="experimental build omitting the second inferred call obligation")
    args = parser.parse_args()
    exe = args.compiler.resolve(strict=True)
    def source(name):
        return (HERE / (name+".gadt")).read_text()
    sites,wide,bad,hole = map(source, ("two_site_interval","two_result_interval",
                                      "unavailable_interval_key","punctured_key"))
    shared = sites.replace("let other = run s width d","let other = prior")
    private = shared.replace("∃l[k≤l ∧ l≤k+n]","∃j,l[l=k+j ∧ 0≤j ∧ j≤n]")
    touched = (shared.replace("let rec run", '''external let touch : ∀i. Num i → Num i = "fun i -> print_char '!'; i"
let rec run''').replace("let prior = run s width d","let prior = run s (touch width) d"))
    precise = shared + """
external let at_minus_one : ∀i[i=(-1)]. Num i → Bool = "fun i -> assert (i = -1); true"
let precise = let p = run Neg 19 (S Z) in at_minus_one p
"""
    bounded = hole.replace("k≤n","k≤n ∧ n≤2").replace("run 3","run 2")
    exact = hole.replace("∃l[0≤l","∃l[l=0 ∧ 0≤l")
    check_punctures()
    with TemporaryDirectory() as tmp:
        out = Path(tmp)
        def check(name, src, *, annotation=(), binary=exe, **kw):
            return previous["compile_and_run"](out, binary, name, src,
                                              options=("-iterations_timeout","2",*annotation), **kw)
        def output(name):
            return subprocess.run(["ocaml",out/(name+".ml")],text=True,capture_output=True,
                                  check=True,timeout=30).stdout
        for annotation in ((), ("-full_annot",)):
            for name,src in (("sites",sites), ("shared",shared), ("private",private), ("touched",touched)):
                public_interval(check(name,src,annotation=annotation))
            assert output("touched") == "!!!"
            check("external_exact_client",precise,annotation=annotation,error="numerical abduction failed")
            check("external_written",precise.replace("∃l[k≤l ∧ l≤k+n]","∃l[l=i]"),annotation=annotation)
            public_interval(check("wide",wide,annotation=annotation),sign=3,slack=1)
            assert output("wide").splitlines() == ["-2","-3"]
            live = bad.replace("-> True","-> base s")
            public_interval(check("narrow",live,annotation=annotation),narrowed=True)
            check("unavailable",bad,annotation=annotation,error="Type mismatch")
            public_puncture(check("two_keys",bounded,annotation=annotation),bounded=True)
            assert output("two_keys") == "0\n"
            check("punctured",hole,annotation=annotation,error="Type mismatch")
            check("three_keys",hole.replace("k≤n","k≤n ∧ n≤3"),annotation=annotation,error="Type mismatch")
            public_puncture(check("exact",exact,annotation=annotation),bounded=False)
            assert output("exact") == "0\n"
            if args.trace:
                trace = args.trace.resolve(strict=True)
                for name in ("shared","two_keys","punctured"):
                    code,report = trace_run(trace,out/(name+".gadt"),2,annotation)
                    assert (code != 0) == (name == "punctured")
                    assert "PAIRED_RETRY run" in report and "PAIRED_OPEN " in report
                    assert not re.search(r"^JUMP \d+ true", report, re.M)
                    if name == "punctured":
                        projected_guards(report)
                        for b in (40,10000):
                            assert trace_run(trace,out/(name+".gadt"),b,annotation) == (code,report)
        if args.before:
            before = args.before.resolve(strict=True)
            for name,src in (("old_sites",sites),("old_shared",shared),("old_bounded",bounded)):
                check(name,src,binary=before,error="Type mismatch")
        if args.missing_admission:
            check("unchecked",bad,binary=args.missing_admission.resolve(strict=True),runtime_error=True)
        if args.trace:
            runpy.run_path(str(HERE/"thesis-review-29.py"))["check_climb_jump"](
                args.trace.resolve(strict=True), HERE/"capped_climb.gadt")
    print("Checked public types, independent witnesses, call coverage and the exact probe bound.")


if __name__ == "__main__":
    main()
