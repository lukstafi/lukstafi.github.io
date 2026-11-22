"""Check shared interval choices, an explicit certificate and the outer-budget trace."""
import argparse
import os
from pathlib import Path
import re
import runpy
import subprocess
from tempfile import TemporaryDirectory

HERE = Path(__file__).resolve().parent
review26 = runpy.run_path(str(HERE / "thesis-review-26.py"))
compile_and_run = review26["compile_and_run"]


def check_trace(exe, path, budget, annotations):
    env = dict(os.environ, JCA_TRACE_LIVE_GUARD="1", JCA_TRACE_DEMAND="1")
    run = subprocess.run([exe, "-no_sig", "-no_ml", "-no_verif", *annotations,
                          "-iterations_timeout", str(budget), path], env=env,
                         text=True, capture_output=True, timeout=30)
    assert run.returncode == 2 and "Type mismatch" in run.stdout, run.stdout
    passes = re.findall(r"^TRACE (\w+) (\d+)", run.stderr, re.M)
    expected = [(event, str(i)) for i in range(min(2, budget) + 1)
                for event in ("enter", "update")] * 3
    assert passes == expected and "JUMP " not in run.stderr, passes
    guards = re.findall(r"^LIVE_GUARD (.*?) END_LIVE_GUARD", run.stderr, re.M | re.S)
    assert len(guards) == (3 if budget >= 2 else 0)
    for guard in guards:
        edges = review26["difference_edges"](" ".join(guard.split()))
        [(k, o)] = [(k, o) for k, o, c in edges if c == 6 and (o, k, 0) in edges
                    and "zero" not in (k, o)]
        def fix(v, value):
            return [("zero", v, value), (v, "zero", -value)]
        feasible = review26["feasible"]
        assert feasible(edges + fix(k, 0) + fix(o, 1))
        assert feasible(edges + fix(k, 2) + fix(o, 2))
        assert not feasible(edges + fix(k, 3))
    return run.stderr


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("compiler", type=Path)
    ap.add_argument("--before", type=Path, help="InvarGenT at 3ce4575")
    ap.add_argument("--trace", type=Path, help="review 27 with the review 22–24 and 26 trace patches")
    args = ap.parse_args()
    current = args.compiler.resolve(strict=True)
    original, interior, bands = [(HERE / (name + ".gadt")).read_text() for name in
        ("implicit_interval_parameter", "interior_interval", "guarded_interval_bands")]
    explicit = (bands.replace("State i → Nat", "State i → Num k → Nat")
                .replace("fun state ->", "fun state key ->").replace("run B d", "run B 3 d")
                .replace("run A (S", "run A (-1) (S").replace("run B (S", "run B 0 (S"))
    lower = "r when r <= 0 -> True"
    upper = "r when 4 <= r -> True"
    two_calls = interior.replace("in\n               (match prior",
                                 "in let later = run B d in\n               (match prior")
    two_calls = two_calls.replace(upper + " | _ -> 2",
                                  "_ -> (match later with r when 3 <= r -> True | _ -> 2)")
    with TemporaryDirectory() as tmp:
        root = Path(tmp)
        def check(name, source, *, error=None, width=2, exe=current):
            sig = compile_and_run(root, exe, name, source, error=error,
                                  options=("-full_annot", "-iterations_timeout", "2"))
            if not error:
                assert f"Nat → ∃j[n ≤ j ∧ j ≤ n + {width}].Num j" in " ".join(sig.split()), sig
        check("one_guard", original)
        check("interior", interior)
        check("wide", interior.replace("k+2", "k+97").replace("when 4 <=", "when 99 <="), width=97)
        check("padded", interior.replace(lower, "r when (-1) <= r && r <= 0 -> True")
              .replace(upper, "r when 4 <= r && r <= 5 -> True"))
        check("two_calls", two_calls)
        check("aliased_opening", two_calls.replace("later = run B d", "later = prior"), error="Type mismatch")
        check("no_shared_key", interior.replace("when 4 <=", "when 3 <="), error="Type mismatch")
        check("bands", bands, error="Type mismatch")
        check("explicit_bands", explicit, width=6)
        for k in (2, 4):
            check(f"wrong_key_{k}", explicit.replace("run B 3 d", f"run B {k} d"), error="Type mismatch")
        if args.before:
            before = args.before.resolve(strict=True)
            check("old_one", original, exe=before, error="numerical abduction failed")
            check("old_interior", interior, exe=before, error="Type mismatch")
        if args.trace:
            exe = args.trace.resolve(strict=True)
            for annotations in ((), ("-full_annot",)):
                traces = [check_trace(exe, root / "bands.gadt", n, annotations) for n in (0, 1, 2, 40, 10000)]
                assert traces[2] == traces[3] == traces[4]


if __name__ == "__main__":
    main()
