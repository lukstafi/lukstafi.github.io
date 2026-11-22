"""Replay component-wise key admission, the narrowed domain, and the flag-controlled interval."""
import argparse
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
import re
import runpy
import subprocess
from tempfile import TemporaryDirectory

import z3

HERE = Path(__file__).resolve().parent
previous = runpy.run_path(str(HERE / "thesis-review-35.py"))
compile_and_run = previous["compile_and_run"]
read_atoms = previous["read_atoms"]
equivalent = previous["old"]["same_formula"]


def contracts(signature, case):
    arrow = " ".join(signature.split()).split("val run : ")[1]
    quant, pre, args, hidden, post, payload = re.fullmatch(
        r"∀([\w, ]+)\[(.*?)\]\. ((?:Num \w+ → )+)Nat → ∃([\w, ]+)\[(.*?)\]\.\s*Num (\w+)", arrow
    ).groups()
    inputs = re.findall(r"Num (\w+)", args)
    key, = set(quant.split(", ")) - set(inputs)
    for sort in (z3.Int, z3.Real):
        k, n, r = map(sort, (key, inputs[-1], payload))
        def read(formula):
            return z3.And(*read_atoms(formula.split(" ∧ "), z3, sort))
        def outside(target):
            return z3.Or(k+1 <= target, target+1 <= k)
        if len(inputs) == 2:
            f = sort(inputs[0])
            domain = z3.And(0 <= f, f <= 1, n >= 2, 0 <= k, k <= n, z3.Or(k <= 0, 1 <= f))
            shape = z3.And(0 <= r, r <= f, outside(n+1-r))
            if case == "explicit":
                shape = z3.And(r == 0, shape)
        else:
            narrowed = case in ("live", "mutant")
            domain = z3.And(n >= (4 if narrowed else 2), 1 <= k, k <= 4*n, z3.Or(k <= n, k >= 3*n+1))
            if narrowed:
                domain = z3.And(domain, outside(n-1))
            shape = z3.And(-n <= r, r <= n, outside(n+1+r), outside(3*n+r))
        actual = read(post)
        private = [sort(x) for x in hidden.split(", ") if x != payload]
        if case == "effect":
            witness, = private
            equivalent(actual, z3.And(shape, r == k+witness))
        if private:
            actual = z3.Exists(private, actual)
        equivalent(read(pre), domain)
        equivalent(actual, shape)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("compiler", type=Path)
    parser.add_argument("--before", type=Path, help="revision b56ec02")
    parser.add_argument("--trace", type=Path, help="review 22, 23, 24, 26 and 35 diagnostics")
    parser.add_argument("--written-only", type=Path, help="omit the inferred predicate from the replay goals")
    opts = parser.parse_args()
    exe = opts.compiler.resolve(strict=True)
    bands = (HERE/"separated_result_keys.gadt").read_text()
    switch = (HERE/"switched_result_band.gadt").read_text()
    bad = bands.replace("2≤n", "4≤n").replace("| Z -> 0", "| Z -> (-2)").replace("v >= 0", "v >= -2")
    effect = bands.replace("∃l[", "∃j,l[l=k+j ∧ ").replace("run size d", "run (touch size) d")
    effect = effect.replace("let rec run", """external let touch : ∀j. Num j → Num j = "fun n -> print_char '!'; n"
let rec run""")
    cases = {
        "bands": bands, "effect": effect, "bad": bad,
        "live": bad.replace("-> True", "-> (-2)").replace("_ -> 0", "_ -> (-2)"),
        "switch": switch, "explicit": switch.replace("∃l[", "∃l[l=0 ∧ "),
        "all_numeric": switch.replace("-> True", "-> 0"),
    }
    with TemporaryDirectory() as tmp:
        out = Path(tmp)
        def check(job):
            name, budget, annotated = job
            work = out/f"{name}-{budget}-{annotated}"
            work.mkdir()
            options = ("-iterations_timeout", str(budget), *(("-full_annot",) if annotated else ()))
            error = "Type mismatch" if name in ("bad", "switch") else None
            sig = compile_and_run(work, exe, name, cases[name], options=options, error=error)
            if error:
                return
            executed = subprocess.run(["ocaml", work/(name+".ml")], text=True, capture_output=True, check=True, timeout=30)
            stdout = executed.stdout
            assert stdout == {"effect":"!!0\n", "live":"-2\n", "explicit":"0\n0\n",
                              "all_numeric":"0\n0\n"}.get(name, "0\n"), (name, stdout)
            return name, sig
        jobs = [(name, 2, True) for name in cases]
        jobs += [("bands",2,False), ("switch",40,True), ("switch",10000,True)]
        # Z3's default context is shared. Keep formula verification on the main thread.
        with ThreadPoolExecutor(3) as pool:
            for result in pool.map(check, jobs):
                if result is not None:
                    name, sig = result
                    contracts(sig, name)
        if opts.written_only:
            sig = compile_and_run(out, opts.written_only.resolve(strict=True), "mutant", bad,
                                  options=("-iterations_timeout","2","-full_annot"), runtime_error=True)
            contracts(sig, "mutant")
            ocaml = subprocess.run(["ocaml", out/"mutant.ml"], capture_output=True, text=True)
            line = int(re.search(r'mutant\.ml",\s*(\d+),', ocaml.stderr)[1])
            assert "r <= -1 -> assert false" in (out/"mutant.ml").read_text().splitlines()[line-1]
        if opts.before:
            compile_and_run(out, opts.before.resolve(strict=True), "old", bands,
                            options=("-iterations_timeout","10000"), error="Type mismatch")
        if opts.trace:
            trace = opts.trace.resolve(strict=True)
            def report(job):
                name,budget = job
                result = subprocess.run([trace, "-no_sig", "-no_ml", "-no_verif", "-full_annot",
                                         "-iterations_timeout", str(budget), out/f"{name}-{budget}-True"/(name+".gadt")],
                                        capture_output=True, text=True, timeout=180)
                assert (result.returncode != 0) == (name == "switch")
                rounds = re.findall(r"^ADMISSION_ROUND (\d+ \d+)$", result.stderr, re.M)
                assert not re.search(r"^JUMP \d+ true", result.stderr, re.M)
                assert max(map(int, re.findall(r"^TRACE enter (\d+)", result.stderr, re.M))) == 2
                if name == "switch":
                    assert rounds and all(r == "0 1" for r in rounds), rounds
                else:
                    assert "0 2" in rounds and rounds[-1] == "2 0", rounds
            with ThreadPoolExecutor(2) as pool:
                list(pool.map(report, [("bands",2), ("switch",10000)]))
            runpy.run_path(str(HERE/"thesis-review-29.py"))["check_climb_jump"](trace, HERE/"capped_climb.gadt")
    print("Verified the public contracts, runtime guards, component projections and the switched interval.")


if __name__ == "__main__":
    main()
