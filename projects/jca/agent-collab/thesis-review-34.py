"""Replay result-dependent typing, inferred admission and the signed counterexample."""
import argparse
import re
import runpy
import subprocess
from pathlib import Path
from tempfile import TemporaryDirectory

import z3

HERE = Path(__file__).resolve().parent
previous = runpy.run_path(str(HERE / "thesis-review-33.py"))
replay = previous["previous"]["compile_and_run"]
read_atoms = previous["previous"]["numeric_constraints"]
equivalent = previous["same_formula"]
trace_run = previous["trace_run"]


def public_type(signature, variant):
    sig = " ".join(signature.split()).split("val run : ")[1]
    quant, pre, size, hidden, post, payload = re.match(
        r"∀([\w, ]+)\[(.*?)\]\. Num (\w+) → Nat → ∃(\w+)\[(.*?)\]\.\s*Num (\w+)", sig).groups()
    key, = set(quant.split(", ")) - {size}
    assert hidden == payload
    for sort in (z3.Int, z3.Real):
        n, k, r = map(sort, (size, key, payload))
        def read(text):
            return z3.And(*read_atoms(text.split(" ∧ "), z3, sort))
        targets = {"offset": r-1, "reflected": n+1-r, "doubled": 2*r+1}
        target = targets.get(variant, r)
        domain = z3.And(3 <= k, k <= 2*n+1) if variant == "doubled" else z3.And(1 <= k, k <= n)
        if variant == "live":
            domain = z3.And(domain, n >= 2, z3.Or(k <= 1, k >= 3))
        equivalent(read(pre), domain)
        bounds = z3.And(0 <= r, r <= n)
        equivalent(read(post), z3.And(bounds, z3.Or(target+1 <= k, k+1 <= target)))


def check_original_jump(compiler):
    source = HERE / "capped_climb.gadt"
    for flags, succeeds in (((), False), (("-iterations_timeout", "40"), False),
                            (("-iterations_timeout", "35", "-convergence_step", "24"), True)):
        run = subprocess.run([compiler, "-inform", "-no_ml", "-no_sig", *flags, source],
                             text=True, capture_output=True, timeout=30)
        assert (run.returncode == 0) == succeeds
        if not succeeds:
            assert "Answers do not converge" in run.stdout + run.stderr


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("compiler", type=Path)
    parser.add_argument("--original", type=Path, help="the original common-atom jump at 772b9b4")
    parser.add_argument("--before", type=Path, help="the fixed-endpoint executable at 4fd76e5")
    parser.add_argument("--trace", type=Path, help="the checker with the review 22–26 and 34 diagnostics")
    parser.add_argument("--unchecked", type=Path, help="mutation skipping the final inferred-domain check")
    args = parser.parse_args()
    compiler = args.compiler.resolve(strict=True)
    if args.original:
        check_original_jump(args.original.resolve(strict=True))
    src = (HERE / "punctured_key.gadt").read_text()
    signed = (HERE / "signed_result_key.gadt").read_text()
    gap = "min(l+1 + -k,k+1 + -l)"
    translated = src.replace(gap, "min(l + -k,k+2 + -l)").replace("1 <= r &&", "2 <= r &&")
    reflected = src.replace(gap, "min(l+k + -n,n+2 + -l + -k)")
    doubled = src.replace(gap, "min(2l+2 + -k,k + -2l)").replace("1≤k ∧ k≤n", "3≤k ∧ k≤2n+1")
    bad = src.replace("| Z -> 0", "| Z -> 2")
    live = bad.replace("-> True | _ -> 0", "-> 2 | _ -> 2")
    touched = src.replace("let rec run", 'external let touch : ∀i. Num i → Num i = "fun i -> print_char \'!\'; i"\nlet rec run')
    touched = touched.replace("let prior = run size d", "let prior = run (touch size) d")
    with TemporaryDirectory() as tmp:
        out = Path(tmp)
        def check(name, source, flags=(), *, exe=compiler, **options):
            return replay(out, exe, name, source, options=("-iterations_timeout", "2", *flags), **options)
        def output(name):
            return subprocess.run(["ocaml", out/(name+".ml")], check=True, timeout=30,
                                  capture_output=True, text=True).stdout
        for flags in ((), ("-full_annot",)):
            for name, source in (("plain",src), ("offset",translated), ("reflected",reflected),
                                 ("doubled",doubled), ("live",live), ("touched",touched)):
                public_type(check(name,source,flags),name)
                expected = {"live":"2\n", "touched":"!!0\n"}.get(name,"0\n")
                assert output(name) == expected
            check("missing",bad,flags,error="Type mismatch")
            check("signed",signed,flags,error="Type mismatch")
            check("signed_exact",signed.replace("∃l[","∃l[l=0 ∧ "),flags)
            assert output("signed_exact") == "0\n"
        if args.before:
            check("fixed_only",src,exe=args.before.resolve(strict=True),error="Type mismatch")
        if args.unchecked:
            public_type(check("unchecked",bad,exe=args.unchecked.resolve(strict=True),runtime_error=True),"live")
        if args.trace:
            trace = args.trace.resolve(strict=True)
            for name in ("plain", "reflected", "doubled", "missing", "signed"):
                file = out/(name+".gadt")
                code, report = trace_run(trace,file,2,("-full_annot",))
                assert "RESULT_KEY run " in report and not re.search(r"^JUMP \d+ true",report,re.M)
                if name == "missing":
                    assert code != 0 and "KEY_ADMISSION false" in report
                elif name == "signed":
                    assert code != 0
                    assert re.search(r"^RESULT_KEY run -n\d+$",report,re.M)
                    assert re.search(r"^RESULT_KEY run n\d+$",report,re.M)
                    for budget in (40,10000):
                        assert trace_run(trace,file,budget,("-full_annot",)) == (code,report)
                else:
                    assert code == 0 and "TRACE update 2\nKEY_ADMISSION true" in report
            runpy.run_path(str(HERE/"thesis-review-29.py"))["check_climb_jump"](trace,HERE/"capped_climb.gadt")
    print("Checked inferred domains, payload-dependent keys, runtime evaluations and signed guards.")


if __name__ == "__main__":
    main()
