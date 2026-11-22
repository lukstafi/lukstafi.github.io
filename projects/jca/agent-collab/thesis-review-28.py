"""Check package boundary proposals, input-dependent witnesses and the final guard."""
import argparse
import os
from pathlib import Path
import re
import runpy
import subprocess
from tempfile import TemporaryDirectory

HERE = Path(__file__).resolve().parent
compile_and_run = runpy.run_path(str(HERE / "thesis-review-13.py"))["compile_and_run"]


def check_projection(guard, z3, sort, states=(0, 1)):
    """Read the exact linear constraints printed in this program's guard."""
    from z3.z3util import get_vars

    def term(source):
        summands = []
        for monomial in source.strip().split(" + "):
            var = re.fullmatch(r"(-?)([a-z]\w*)", monomial)
            if var:
                value = sort(var[2])
                summands.append(-value if var[1] else value)
            elif " " in monomial:
                coefficient, name = monomial.split()
                summands.append(z3.RealVal(coefficient.strip("()")) * sort(name))
            else:
                summands.append(z3.RealVal(monomial.strip("()")))
        return sum(summands)

    atoms = " ".join(guard.split()).split(" ∧ ")
    constraints = []
    for atom in atoms:
        if atom.startswith("min||max ("):
            left, right = atom[len("min||max ("):-1].split(", ")
            constraints.append(z3.Or(term(left) <= 0, term(right) <= 0))
        else:
            left, sign, right = re.fullmatch(r"(.+) (≤|=) (.+)", atom).groups()
            constraints.append(term(left) <= term(right) if sign == "≤" else term(left) == term(right))
    # Locate the fresh key and returned value by the declared two bounds.
    intervals = set()
    for atom in atoms:
        band = re.fullmatch(r"(n\d+) ≤ (n\d+) \+ 2", atom)
        if band and f"{band[2]} ≤ {band[1]}" in atoms:
            intervals.add(band.groups())
    [(output, child)] = intervals
    r, j, i, k = map(sort, (output, child, "i", "k"))
    expected = z3.And(z3.Or([i == x for x in states]), k <= 4*i+1, 4*i+1 <= k+2,
                      j == k, j <= r, r <= j+2, 2 <= r, r <= 4)
    full = z3.And(*constraints)
    hidden = [v for v in get_vars(full) if not any(v.eq(obs) for obs in (r, j, i, k))]
    oracle = z3.Solver()
    oracle.set(timeout=30000)
    oracle.add(z3.Xor(z3.Exists(hidden, full), expected))
    assert oracle.check() == z3.unsat, oracle.reason_unknown()


def trace(exe, source, options, states=(0, 1)):
    import z3
    stable = None
    for budget in (0, 1, 2, 3, 40, 10000):
        run = subprocess.run([exe, "-no_sig", "-no_ml", "-no_verif", *options,
                              "-iterations_timeout", str(budget), source], text=True,
                             capture_output=True, timeout=30,
                             env=dict(os.environ, JCA_TRACE_LIVE_GUARD="1", JCA_TRACE_DEMAND="1"))
        assert run.returncode == 2
        events = re.findall(r"^TRACE (\w+) (\d+)", run.stderr, re.M)
        sequence = [(event, str(i)) for i in range(min(2, budget)+1) for event in ("enter", "update")]
        assert events == sequence * (1 if budget < 2 else 3) and "JUMP " not in run.stderr, events
        guards = re.findall(r"^LIVE_GUARD (.*?) END_LIVE_GUARD", run.stderr, re.M | re.S)
        assert len(guards) == (0 if budget < 2 else 2)
        if budget == 2:
            stable = run.stderr
            for guard in guards:
                for sort in (z3.Int, z3.Real):
                    check_projection(guard, z3, sort, states)
        elif budget > 2:
            assert run.stderr == stable


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("compiler", type=Path)
    parser.add_argument("--before", type=Path, help="compiler at revision 41750f0")
    parser.add_argument("--trace", type=Path, help="review 28 with the review 22–24 and 26 diagnostics; requires z3-solver")
    args = parser.parse_args()
    exe = args.compiler.resolve(strict=True)
    bands = (HERE / "guarded_interval_bands.gadt").read_text()
    policy = (HERE / "state_dependent_interval.gadt").read_text()
    explicit = (policy.replace("let rec run :", "let key : ∀i. State i → Num (6 i + (-1)) = function A -> (-1) | B -> 5\n\nlet rec run :")
                .replace("State i → Nat →", "State i → Num k → Nat →").replace("fun s -> efunction", "fun s keyarg -> efunction")
                .replace("run s d", "run s (key s) d").replace("run A (S", "run A (-1) (S").replace("run B (S", "run B 3 (S"))
    split_at = "  | S d -> "
    before, rest = policy.split(split_at)
    body, tests = rest.split("\ntest ")
    split = before + split_at + "(match s with " + " | ".join(
        state + " -> (" + body.replace("run s d", "run "+state+" d").replace("base s", "base "+state) + ")"
        for state in ("A", "B")) + ")\ntest " + tests
    guarded_assertions = bands.replace("-> True |", "-> assert false |")
    tap = (guarded_assertions.replace("let rec run :", 'external let tap : ∀i. Num i → Num i = "fun n -> print_endline (string_of_int n); n"\nlet rec run :')
           .replace("<= r && r <=", "<= tap r && tap r <="))
    reachable = ('external let sample : Num 0 → ∃j[0≤j ∧ j≤6]. Num j = "fun _ -> 3"\n'
                 'let bad = let r = sample 0 in match r with v when 2 <= v && v <= 4 -> assert false | _ -> True\n')
    with TemporaryDirectory() as tmp:
        out = Path(tmp)
        def check(name, source, *, binary=exe, error=None, options=(), width=None):
            sig = compile_and_run(out, binary, name, source, error=error,
                                  options=("-full_annot", "-iterations_timeout", "2", *options))
            if width is not None:
                assert f"Nat → ∃j[n ≤ j ∧ j ≤ n + {width}].Num j" in " ".join(sig.split()), sig
        check("bands", bands, width=6)
        check("reordered", bands.replace("1 <= r && r <= 2", "r <= 2 && 1 <= r")
              .replace("10 <= r && r <= 11", "r <= 11 && 10 <= r"), width=6)
        wide = (bands.replace("k+6", "k+97").replace("1 <= r && r <= 2", "(-41) <= r && r <= (-40)")
                .replace("10 <= r && r <= 11", "59 <= r && r <= 60"))
        check("signed_wide", wide, width=97)
        for name, options in (("tap", ()), ("kept_tap", ("-keep_assert_false",))):
            check(name, tap, options=options, width=6)
            result = subprocess.run(["ocaml", "-noinit", out / (name+".ml")], capture_output=True, text=True, check=True)
            assert result.stdout.splitlines() == ["6"]*6, result.stdout
        check("reachable", reachable, error="negative clause")
        check("implicit", policy, width=2)
        check("explicit", explicit, width=2)
        check("split", split, width=2)
        if args.before:
            old = args.before.resolve(strict=True)
            check("old_bands", bands, binary=old, error="Type mismatch")
            check("old_assertions", guarded_assertions, binary=old, error="numerical abduction failed")
        if args.trace:
            for options in ((), ("-full_annot",)):
                trace(args.trace.resolve(strict=True), out / "implicit.gadt", options)


if __name__ == "__main__":
    main()
