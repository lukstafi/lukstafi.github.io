"""Replay guarded recursive choices, their public types, and the remaining two-site failure."""
import argparse
import os
from pathlib import Path
import re
import runpy
import subprocess
from tempfile import TemporaryDirectory

import z3

HERE = Path(__file__).resolve().parent
review28 = runpy.run_path(str(HERE / "thesis-review-28.py"))
explicit_width = runpy.run_path(str(HERE / "thesis-review-31.py"))["explicit_width"]


def public_type(signature, case):
    """Compare both sides of the printed package against the full written type."""
    sig = " ".join(signature.split()).split("val run : ")[1]
    pre, args, result, post, payload = re.match(
        r"∀[^\[]+\[(.*?)\]\. (.*?) → Nat → ∃(\w+)\[(.*?)\]\.\s*Num (\w+)", sig).groups()
    assert payload == result
    names = re.findall(r"(?:State|Num) (\w+)", args)
    key, width = re.fullmatch(r"(\w+) ≤ "+result+r" ∧ "+result+r" ≤ \1 \+ (\w+)", post).groups()
    assert width == names[-1] and key not in names
    for sort in (z3.Int, z3.Real):
        i, *observations = map(sort, names)
        k, n, r = map(sort, (key, width, result))
        sign = 3 if case == "crossing" else 1
        offset = observations[0] if case == "moving" else 0
        domain = [z3.Or(i == -sign, i == sign), n >= 0, k <= i+offset, i+offset <= k+n]
        if case == "crossing":
            for v in observations[:-1]:
                domain.extend([v >= -2, v <= 2])
        for actual, expected in ((pre, z3.And(*domain)), (post, z3.And(k <= r, r <= k+n))):
            constraints = review28["numeric_constraints"](actual.split(" ∧ "), z3, sort)
            solver = z3.Solver()
            solver.add(z3.Xor(z3.And(*constraints), expected))
            assert solver.check() == z3.unsat, (case, actual, sort)


def traces(trace, source, annotation):
    baseline = None
    for budget in (2, 3, 40, 10000):
        p = subprocess.run([trace, "-no_sig", "-no_ml", "-no_verif", *annotation,
                            "-iterations_timeout", str(budget), source], capture_output=True,
                           text=True, timeout=90, env=dict(os.environ, JCA_TRACE_DEMAND="1",
                                                          JCA_TRACE_LIVE_GUARD="1"))
        report = p.stdout + p.stderr
        assert p.returncode and "Type mismatch" in report
        assert re.findall(r"^TRACE update (\d+)$", report, re.M) == ["0","1","2"] * 5
        assert report.count("END_LIVE_GUARD") == 4 and "JUMP " not in report
        assert baseline is None or report == baseline
        baseline = report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("compiler", type=Path)
    parser.add_argument("--before", type=Path, help="InvarGenT at a549d0d")
    parser.add_argument("--trace", type=Path, help="current compiler with the four review 28 diagnostics")
    args = parser.parse_args()
    exe = args.compiler.resolve(strict=True)
    def source(name):
        return (HERE / (name+".gadt")).read_text()
    width, moving, crossing, sites = map(source, ("variable_width_interval", "moving_interval_guard",
                                                "crossing_interval_guards", "two_site_interval"))
    zero = (width.replace("datacons Pos : State 1", "datacons Pos : State 1\ndatacons Mid : State 0")
            .replace("Pos -> 1", "Pos -> 1 | Mid -> 0").replace(" ∧ min(i+1,1 + -i)≤0", ""))
    alias = moving.replace("(match prior", "let center = origin in (match prior").replace(
        "origin <= r && r <= origin", "center <= r && r <= center")
    # The inner binding makes the negative state's base result hit the guard.
    shadow = width.replace("(match prior", "let center = width in let center = (-1) in (match prior").replace(
        "0 <= r && r <= 0", "center <= r && r <= center")
    explicit = explicit_width(sites).replace("let other = run s width d",
                                               "let other = run s width (base s) d")
    exact = sites.replace("∃l[k≤l ∧ l≤k+n]", "∃l[l=i]")
    retained = sites.replace("∃l[k≤l ∧ l≤k+n]", "∃l[l=i ∧ k≤l ∧ l≤k+n]")
    shifted = width.replace("k≤i ∧ i≤k+n", "k+n≤i ∧ i≤k+2 n").replace(
        "k≤l ∧ l≤k+n", "k+n≤l ∧ l≤k+2 n")
    with TemporaryDirectory() as tmp:
        out = Path(tmp)
        def check(name, text, *, annotation=(), binary=exe, error=None, budget=2):
            return review28["compile_and_run"](out, binary, name, text, error=error,
                                               options=("-iterations_timeout",str(budget),*annotation))
        for annotation in ((), ("-full_annot",)):
            for name, src in (("width",width), ("moving",moving), ("crossing",crossing)):
                public_type(check(name, src, annotation=annotation), name)
            for name, src in (("alias",alias), ("shifted",shifted), ("separate_keys",explicit),
                              ("exact_result",exact)):
                check(name, src, annotation=annotation)
            check("retained_interval", retained, annotation=annotation, budget=3)
            for name, src in (("zero",zero), ("zero_called",zero+"let bad = run Mid 0 (S Z)\n"),
                              ("zero_child",zero.replace("run s width d","run Mid width d")),
                              ("shadow",shadow), ("sites",sites),
                              ("shared_opening",sites.replace("let other = run s width d","let other = prior"))):
                check(name, src, annotation=annotation, error="Type mismatch")
            check("wrong_client", width+"let bad = let p = run Pos 0 Z in negative p\n",
                  annotation=annotation, error="numerical abduction failed")
            if args.trace:
                traces(args.trace.resolve(strict=True), out/"sites.gadt", annotation)
        if args.before:
            check("old_width", width, binary=args.before.resolve(strict=True), error="Type mismatch")
        if args.trace:
            checker = runpy.run_path(str(HERE / "thesis-review-29.py"))["check_climb_jump"]
            checker(args.trace.resolve(strict=True), HERE/"capped_climb.gadt")
        print("Public contracts, reachable guards and recursive calls checked.", flush=True)


if __name__ == "__main__":
    main()
