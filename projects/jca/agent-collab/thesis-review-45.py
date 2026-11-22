"""Check interval policies, moving native menus, and joint integer guard proofs."""
import argparse
from itertools import product
from pathlib import Path
from random import Random
import re
import subprocess
from tempfile import TemporaryDirectory

import z3

HERE = Path(__file__).resolve().parent


def policy_checks():
    # A bit per (input,key). Each of the four pairs can be forbidden, optional,
    # or mandatory. Each package has a bit per (key,result).
    def admitted(policy, x, k):
        return (policy >> (2*x+k)) & 1

    def stored(package, k, r):
        return (package >> (2*k+r)) & 1

    def body(policy, package, calls):
        return all(not admitted(policy, x, k) or stored(package, k, r)
                   for x, r in calls for k in (0, 1))

    def bad(policy, package, x, k, r, calls):
        return admitted(policy, x, k) and not stored(package, k, r) and body(policy, package, calls)

    # Exchange input names to fix the destination at zero, and result names
    # to fix the supplied result at one. Compare the whole set of failing keys.
    calls = [(), ((0, 0),), ((1, 0),), ((0, 0), (1, 1)), ((0, 0), (0, 1))]
    checks = coverage = 0
    for status in product(range(3), repeat=4):
        lo = sum(1 << j for j, s in enumerate(status) if s == 2)
        hi = sum(1 << j for j, s in enumerate(status) if s)
        family = [a for a in range(16) if a & lo == lo and a | hi == hi]
        for p, cs in product(range(16), calls):
            for k in (0, 1):
                exact = any(bad(a, p, 0, k, 1, cs) for a in family)
                pin = lo | 1 << k
                test = bool(admitted(hi, 0, k) and bad(pin, p, 0, k, 1, cs))
                assert exact == test, (lo, hi, p, k, cs)
                checks += 1
                compatible = sum(1 << (2*y+j) for y, j in product((0,1), repeat=2)
                                 if admitted(hi, y, j) and all(y != z or stored(p, j, t) for z, t in cs))
                for must_hit in (3, 12, 6):
                    # The last group allows a key at either input.
                    model = any(a & must_hit and bad(a, p, 0, k, 1, cs) for a in family)
                    greatest = bool(compatible & must_hit and lo & compatible == lo
                                    and admitted(compatible, 0, k) and not stored(p, k, 1))
                    assert model == greatest
                    coverage += 1
    print(f"{checks} one-key tests and {coverage} coverage tests agreed with policy enumeration")


def prove(formula):
    solver = z3.Solver()
    solver.add(z3.Tactic("qe")(z3.Not(formula)).as_expr())
    assert solver.check() == z3.unsat, formula


def moving_projection():
    i, r, k = z3.Reals("i r k")
    limit = z3.If(2*i >= 3, 2*i-3, 3-2*i)
    menu = z3.And(0 <= k, k <= 1, k <= limit)
    package = z3.And(0 <= r, r+k <= 1)
    opened = z3.ForAll([k], z3.Implies(menu, package))
    prove(opened == z3.And(0 <= r, r <= 1-z3.If(limit < 1, limit, 1)))
    for integer in range(3):
        prove(z3.Implies(i == integer, opened == (r == 0)))
    prove(z3.Implies(2*i == 3, opened == z3.And(0 <= r, r <= 1)))


def descending_admission():
    n, j, k, r = z3.Reals("n j k r")

    def permits(key, value):
        return z3.Or(value+1 <= key, key+1 <= value)

    opened = z3.ForAll(j, z3.Implies(n <= j, permits(j, r)))
    prove(opened == (r+1 <= n))
    step = z3.ForAll(r, z3.Implies(z3.And(0 <= r, r+1 <= n), permits(k, r+1)))
    row = z3.And(0 <= k, permits(k, 0), step)
    prove(z3.Implies(z3.Or(n == 0, n >= 1), row == (n+1 <= k)))
    # With only the isolated keys remaining every numeric result opens.
    live = z3.ForAll(r, z3.Implies(0 <= r, permits(k, r+1)))
    prove(z3.Not(z3.And(0 <= k, permits(k, 0), live)))


def verdict(*facts):
    solver = z3.Solver()
    solver.add(*facts)
    answer = solver.check()
    assert answer != z3.unknown, solver.reason_unknown()
    return str(answer)


def arithmetic(driver):
    i, l = z3.Reals("i l")
    rng = Random(45)
    exact, general = [], []
    for n in range(200):
        # Unit difference bounds after rounding. An extra key is admitted on
        # the complement of each strict side, and refutes the result there.
        text, facts, cells = [], [], ["k=0"]
        for doubled, value in (("2 i", i), ("2 l", l), ("2 l + -2 i", l-i)):
            lo = rng.randrange(-5, 3)
            hi = lo + rng.randrange(7)
            for side, strict in ((True, rng.choice([False, True])), (False, rng.choice([False, True]))):
                bound = lo if side else hi
                lhs, rhs = (str(bound), doubled) if side else (doubled, str(bound))
                numeric = (bound, 2*value) if side else (2*value, bound)
                facts.append(numeric[0] < numeric[1] if strict else numeric[0] <= numeric[1])
                if strict:
                    cells.append(f"k=1 ∧ {rhs}≤{lhs}")
                else:
                    text.append(f"{lhs}≤{rhs}")
        exact.append((["l;i", " ∧ ".join(text) or "0=0", "k≤0 ∧ 2 m=k+l", *cells],
                      (verdict(*facts), verdict(*facts, z3.IsInt(l)),
                       verdict(*facts, z3.IsInt(l), z3.IsInt(i)))))

    for n in range(160):
        # Non-unit directions also occur with affine native arguments. The
        # multivariate check is a relaxation and may keep a spurious model.
        lines, facts = [], []
        for _ in range(4):
            a, b, d = rng.randrange(-4, 5), rng.randrange(-4, 5), rng.randrange(-9, 10)
            op = rng.choice(["≤", "≤", "="])
            lines.append(f"{a} i + {b} l {op} {d}")
            facts.append(a*i+b*l <= d if op == "≤" else a*i+b*l == d)
        term, value = (("i", i), ("2 i", 2*i), ("1/2 i + l", i/2+l))[n % 3]
        general.append(([f"l;{term}", " ∧ ".join(lines), "2 m=l+k", "2 k=1"],
                        (verdict(*facts), verdict(*facts, z3.IsInt(l)),
                         verdict(*facts, z3.IsInt(l), z3.IsInt(value)))))
    exact.extend([
        (["l;i", "2 l+2 i=5", "2 m=l+k", "2 k=1"], ("sat", "sat", "unsat")),
        (["l;2 i", "2 i=1 ∧ l=2", "2 m=l+k", "2 k=1"], ("sat", "sat", "sat")),
        (["l;i", "0≤i ∧ i≤2 ∧ l=1", "l+k≤1",
          "0≤k ∧ k≤1 ∧ min(k+2 i + -3,k+3 + -2 i)≤0"], ("sat", "sat", "unsat")),
        (["l;i", "min|max(2 i+2 l + -5,2 i+2 l + -3)",
          "0=0", "0=0"], ("sat", "sat", "unsat")),
        (["l;i", "min||max(2 i+2 l + -5,2 i+2 l + -3)",
          "0=0", "0=0"], ("sat", "sat", "sat")),
    ])
    diamond = "1≤5 i+5 l ∧ 5 i+5 l≤9 ∧ -4≤5 i + -5 l ∧ 5 i + -5 l≤4"
    bounds = [1 <= 5*(i+l), 5*(i+l) <= 9, -4 <= 5*(i-l), 5*(i-l) <= 4]
    general.append((["l;i", diamond, "0=0", "0=0"],
                    (verdict(*bounds), verdict(*bounds, z3.IsInt(l)),
                     verdict(*bounds, z3.IsInt(l), z3.IsInt(i)))))
    problems = exact + general
    query = "".join("\t".join(fields)+"\n" for fields, _ in problems)
    run = subprocess.run([driver], input=query, capture_output=True, text=True, check=True)
    answers = run.stdout.splitlines()
    assert len(answers) == len(problems)
    extra = 0
    for n, ((fields, expected), line) in enumerate(zip(problems, answers)):
        got = tuple(line.split())
        assert len(got) == 3 and got[:2] == expected[:2], (fields, got, expected)
        if got[2] != expected[2]:
            assert n >= len(exact) and (got[2], expected[2]) == ("sat", "unsat"), (fields, got, expected)
            extra += 1
    print(f"{len(exact)} exact mixed checks and {len(general)} general checks ({extra} conservative)")


def source_checks(compiler, before):
    paired = (HERE/"joint_native_guard.gadt").read_text()
    joint = paired.replace("∀i,j,k[", "∀i,k[").replace("(Num i, Num j) → Nat", "Num i → Nat")
    joint = joint.replace("fun (flag,hi) ->", "fun flag ->").replace("run (flag,hi)", "run flag")
    joint = joint.replace("r <= hi", "r <= flag").replace("run (2,2)", "run 2")
    moving = (HERE/"moving_native_menu.gadt").read_text()
    with TemporaryDirectory() as temp:
        def run(exe, name, source, expected=None, opts=()):
            path = Path(temp)/(name+".gadt")
            path.write_text(source)
            proc = subprocess.run([exe, "-iterations_timeout", "4", "-num_abduction_timeout", "40",
                                   "-no_verif", "-full_annot", "-overwrite_ml", *opts, path],
                                  text=True, capture_output=True)
            if expected is None:
                assert proc.returncode and "Type mismatch" in proc.stdout+proc.stderr, (name, proc)
                return
            assert proc.returncode == 0, (name, proc)
            result = subprocess.run(["ocaml", path.with_suffix(".ml")], check=True, text=True, capture_output=True)
            assert result.stdout == expected, (name, result)
            return " ".join(path.with_suffix(".gadti").read_text().split())
        signature = run(compiler, "moving", moving, "0\n0\n")
        actual = signature.split("val run : ")[1]
        assert re.fullmatch(r"∀(\w+), (\w+)\[\1 ≤ 2 ∧ 0 ≤ \1 ∧ \2 ≤ 1 ∧ 0 ≤ \2 ∧ "
                            r"\2≤max \(-2 \1 \+ 3, 2 \1 \+ -3\)\]\. Num \1 → Nat → "
                            r"∃(\w+)\[0 ≤ \3 ∧ \3 \+ \2 ≤ 1\]\.Num \3", actual), actual
        run(compiler, "joint", joint, "0\n")
        run(compiler, "paired", paired, "0\n")
        alias = paired.replace("let prior =", "let ceiling = hi in let prior =").replace("r <= hi", "r <= ceiling")
        run(compiler, "tuple_alias", alias, "0\n")
        # Every native input admits a positive key. In this version all such
        # keys are fractional, so an integer-key approximation loses the proof.
        scaled = moving.replace("k≤1", "2 k≤1").replace("min(k+2 i + -3,k+3", "min(2 k+2 i + -3,2 k+3")
        scaled = scaled.replace("l+k≤1", "l+2 k≤1")
        run(compiler, "scaled", scaled, "0\n0\n")
        if before:
            run(before, "old_joint", joint)
            run(before, "old_moving", moving)
            run(before, "old_paired", paired)
        # At integer input one this neighbouring seed returns one.
        live = joint.replace("≤5", "≤4").replace("5 + -2", "4 + -2").replace(
            '"fun _ -> 0"', '"fun x -> 2-x"').replace("run 2 (", "run 1 (")
        run(compiler, "live", live)

        def numeric(program, kind, zero):
            primitive = (f'external let hit : ∀i. Num i → Num 0 = '
                         f'"fun v -> print_endline (string_of_{kind} v); {zero}"\n')
            return program.replace("let rec run", primitive+"let rec run").replace("-> True |", "-> hit r |")
        run(compiler, "live_numeric", numeric(live, "int", "0"), "1\n0\n")
        # If hi were confused with flag, this input would hide the live arm.
        adjacent = paired.replace("≤5", "≤4").replace("5 + -2", "4 + -2").replace(
            '"fun _ -> 0"', '"fun x -> 2-x"').replace("run (2,2)", "run (0,2)")
        run(compiler, "live_tuple", adjacent)
        run(compiler, "live_tuple_numeric", numeric(adjacent, "int", "0"), "2\n0\n")
        phantom = joint.replace("external let observe", "datatype Token : num\ndatacons Half : ∀i[2 i=3]. Token i\n\nexternal let observe")
        phantom = phantom.replace("Num i → ∃l", "Token i → ∃l").replace("Num i → Nat →", "Token i → Num 2 → Nat →")
        phantom = phantom.replace("fun flag ->", "fun tok flag ->").replace("seed flag", "seed tok")
        phantom = phantom.replace("run flag d", "run tok flag d").replace("run 2 (", "run Half 2 (").replace('"fun _ -> 0"', '"fun _ -> 1"')
        run(compiler, "phantom", phantom)
        run(compiler, "phantom_numeric", numeric(phantom, "int", "0"), "1\n0\n")
        affine = joint.replace("Num i → ∃l", "Num (2 i) → ∃l").replace("Num i → Nat", "Num (2 i) → Nat")
        affine = affine.replace('"fun _ -> 0"', '"fun x -> if x = 3 then 1 else 0"').replace("run 2 (", "run 3 (")
        run(compiler, "affine_argument", affine)
        run(compiler, "affine_argument_numeric", numeric(affine, "int", "0"), "1\n0\n")
        floating = joint.replace("string_of_int", "string_of_float").replace("v = 0", "true")
        floating = floating.replace('"fun _ -> 0"', '"fun x -> if x = 1.5 then 1. else 0."')
        floating = floating.replace("let rec run", 'external let half : Num 0 → Num (3/2) = "fun _ -> 1.5"\nlet rec run')
        floating = floating.replace("run 2 (", "run (half 0) (")
        run(compiler, "float", floating, opts=("-num_is", "float"))
        run(compiler, "float_numeric", numeric(floating, "float", "0."), "1.\n0.\n", ("-num_is", "float"))
    print("Verified both native programs, the exported moving menu and five reachable-guard controls")


def trace_checks(compiler):
    with TemporaryDirectory() as temp:
        path = Path(temp)/"moving.gadt"
        path.write_bytes((HERE/"moving_native_menu.gadt").read_bytes())
        for jump in (1, 8):
            run = subprocess.run([compiler, "-iterations_timeout", "4", "-num_abduction_timeout", "40",
                                  "-convergence_step", str(jump), "-no_verif", "-full_annot", "-overwrite_ml", path],
                                 check=True, text=True, capture_output=True)
            events = run.stderr.splitlines()
            accepted = events.index("CERTIFIED")
            trial = max(n for n in range(accepted) if events[n].startswith("PROPOSAL"))
            assert events[trial:accepted+1] == ["PROPOSAL all", *(f"PASS {n}/{jump}" for n in range(3)), "CERTIFIED"]
            assert "WIDEN" not in events
    print("Checked the accepted trial at widening thresholds one and eight")


if __name__ == "__main__":
    cli = argparse.ArgumentParser(description=__doc__)
    cli.add_argument("--driver", type=Path)
    cli.add_argument("--compiler", type=Path)
    cli.add_argument("--before", type=Path)
    cli.add_argument("--trace", type=Path)
    args = cli.parse_args()
    if args.before and not args.compiler:
        cli.error("--before requires --compiler")
    policy_checks()
    moving_projection()
    descending_admission()
    if args.driver:
        arithmetic(args.driver.resolve(strict=True))
    if args.compiler:
        source_checks(args.compiler.resolve(strict=True), args.before and args.before.resolve(strict=True))
    if args.trace:
        trace_checks(args.trace.resolve(strict=True))
