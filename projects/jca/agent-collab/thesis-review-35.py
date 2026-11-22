"""Check staged admissions, the rejected circular proof, and the exported numeric contracts."""
import argparse
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
import re
import runpy
import subprocess
from tempfile import TemporaryDirectory

import z3

HERE = Path(__file__).resolve().parent
old = runpy.run_path(str(HERE / "thesis-review-33.py"))
compile_and_run = old["previous"]["compile_and_run"]
read_atoms = old["previous"]["numeric_constraints"]


def sources():
    signed = (HERE / "signed_result_key.gadt").read_text()
    stage = (HERE / "staged_result_keys.gadt").read_text()
    circle = stage.replace("k≤n ∧", "k≤n ∧ min(k + -5,7 + -k)≤0 ∧")
    circle = circle.replace("l≤n ∧ min(l+5,1 + -l)", "l≤3 ∧ min(l+5,3 + -l)").replace("| Z -> (-5)", "| Z -> 3")
    extra = signed.replace("1≤k ∧ k≤n", "3≤n ∧ 1≤k ∧ k≤2n")
    extra = extra.replace("1 + -k + -l)≤0]", "1 + -k + -l)≤0 ∧ min(l+n+2 + -k,k + -n + -l)≤0]")
    wrapped = signed.replace("min(k+l+1,1 + -k + -l)", "min(l+n+2 + -k,k + -l + -n)")
    wrapped = wrapped.replace("∃l[-n≤l", "∃j,l[l=k+j ∧ -n≤l")
    wrapped = wrapped.replace("let rec run", '''external let touch : ∀j. Num j → Num j = "fun n -> print_char '!'; n"
let rec run''').replace("let prior = run size d", "let prior = run (touch size) d")
    return {"signed": signed, "stage": stage, "circle": circle, "wrapped": wrapped, "extra": extra,
            "live": circle.replace("-> True", "-> 3").replace("_ -> (-5)", "_ -> 3"),
            "separate": (HERE / "separated_result_keys.gadt").read_text()}


def check_signature(sig, name):
    quant, pre, size, hidden, post, payload = re.fullmatch(
        r"∀([\w, ]+)\[(.*?)\]\. Num (\w+) → Nat → ∃([\w, ]+)\[(.*?)\]\.\s*Num (\w+)",
        " ".join(sig.split()).split("val run : ")[1]).groups()
    key, = set(quant.split(", ")) - {size}
    for sort in (z3.Int, z3.Real):
        n, k, r = map(sort, (size, key, payload))
        def read(text):
            return z3.And(*read_atoms(text.split(" ∧ "), z3, sort))
        def outside(t):
            return z3.Or(t+1 <= k, k+1 <= t)
        domain = z3.And(1 <= k, k <= n)
        shape = z3.And(-n <= r, r <= n)
        holes = [r, -r]
        if name == "wrapped":
            holes = [r, n+1+r]
        elif name == "extra":
            domain = z3.And(3 <= n, 1 <= k, k <= 2*n, z3.Or(k <= n, n+2 <= k))
            holes.append(n+1+r)
        elif name in ("stage", "live", "circle"):
            domain = z3.And(domain, n >= 6, z3.Or(k <= 2, 4 <= k))
            holes = [r, r+3]
            shape = z3.And(-5 <= r, r <= n, z3.Or(r <= -5, 1 <= r))
            if name in ("live", "circle"):
                domain = z3.And(domain, z3.Or(k <= 5, 7 <= k))
                shape = z3.And(-5 <= r, r <= 3, z3.Or(r <= -5, 3 <= r))
        elif name in ("bands_live", "bands_exact"):
            domain = z3.And(n >= 2, 1 <= k, k <= 4*n, z3.Or(k <= n, 3*n+1 <= k))
            holes = [n+1+r, 3*n+r]
            if name == "bands_exact":
                shape = z3.And(shape, r == 0)
        numeric = read(post)
        private = [sort(x) for x in hidden.split(", ") if x != payload]
        if private:
            numeric = z3.Exists(private, numeric)
        old["same_formula"](read(pre), domain)
        old["same_formula"](numeric, z3.And(shape, *map(outside, holes)))


def main():
    args = argparse.ArgumentParser(description=__doc__)
    args.add_argument("compiler", type=Path)
    args.add_argument("--before", type=Path, help="single-probe compiler at 72c1ec3")
    args.add_argument("--trace", type=Path, help="review 22, 23, 24, 26 and 35 diagnostics")
    args.add_argument("--circular", type=Path, help="mutation using unchecked siblings in admission")
    opts = args.parse_args()
    compiler = opts.compiler.resolve(strict=True)
    cases = sources()
    with TemporaryDirectory() as tmp:
        directory = Path(tmp)
        def run(job):
            name, annotation = job
            work = directory / (name + ("-full" if annotation else ""))
            work.mkdir()
            flags = ("-iterations_timeout", "2", *annotation)
            error = "Type mismatch" if name in ("circle", "separate") else None
            sig = compile_and_run(work, compiler, name, cases[name], options=flags, error=error)
            if not error:
                check_signature(sig, name)
                output = subprocess.check_output(["ocaml", work/(name+".ml")], text=True, timeout=30)
                assert output == {"wrapped": "!!0\n", "live": "3\n", "stage": "-5\n"}.get(name, "0\n")
        with ThreadPoolExecutor(4) as workers:
            list(workers.map(run, [(n,a) for a in ((), ("-full_annot",)) for n in cases]))
        for name, source in (("bands_exact", cases["separate"].replace("∃l[", "∃l[l=0 ∧ ")),
                             ("bands_live", cases["separate"].replace("-> True", "-> 0"))):
            signature = compile_and_run(directory, compiler, name, source, options=("-iterations_timeout", "40"))
            check_signature(signature, name)
        if opts.before:
            compile_and_run(directory, opts.before.resolve(strict=True), "old_signed", cases["signed"],
                            options=("-iterations_timeout", "2"), error="Type mismatch")
        if opts.circular:
            sig = compile_and_run(directory, opts.circular.resolve(strict=True), "unchecked", cases["circle"],
                                  options=("-iterations_timeout", "2"), runtime_error=True)
            check_signature(sig, "circle")
        if opts.trace:
            trace = opts.trace.resolve(strict=True)
            for name, expected in (("signed", ["2 0"]), ("stage", ["1 1", "1 0"]),
                                   ("extra", ["2 1", "0 1"]), ("circle", ["0 2"]),
                                   ("separate", ["0 2"])):
                source = directory/(name+"-full")/(name+".gadt")
                code, report = old["trace_run"](trace, source, 2, ("-full_annot",))
                assert (code != 0) == (name in ("circle", "separate"))
                outcomes = re.findall(r"^ADMISSION_ROUND (\d+ \d+)$", report, re.M)
                assert any(outcomes[i:i+len(expected)] == expected for i in range(len(outcomes))), (name, outcomes)
                if name == "extra":
                    assert outcomes[-1] == "2 0"
                assert not re.search(r"^JUMP \d+ true", report, re.M)
            runpy.run_path(str(HERE/"thesis-review-29.py"))["check_climb_jump"](trace,HERE/"capped_climb.gadt")
    print("Checked exported contracts, fresh witnesses, admission rounds and the circular counterexample.")


if __name__ == "__main__":
    main()
