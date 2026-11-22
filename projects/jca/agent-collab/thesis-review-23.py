"""Check joint exclusions, their live boundaries and both package coordinates."""
import argparse
import os
from pathlib import Path
import re
import runpy
import subprocess
from tempfile import TemporaryDirectory

HERE = Path(__file__).resolve().parent
previous = runpy.run_path(str(HERE / "thesis-review-22.py"))
compile_and_run = previous["compile_and_run"]

DOWN = '''external let step : ∀i. Num i → ∃j[i≤j+1 ∧ j≤i]. Num j =
  "fun n -> if n = min_int then n else pred n"
'''
UP = '''external let step : ∀i. Num i → ∃j[i≤j ∧ j≤i+1]. Num j =
  "fun n -> if n = max_int then n else succ n"
'''
NOTE = '''external let note : ∀i. Num i → Bool =
  "let calls = ref 0 in fun n -> if n = 73 then assert (!calls = 1) else incr calls; true"
'''


def arm(source):
    start = source.index("(match returned with")
    body = source.index("      let ok =", start)
    end = source.index("     | _ -> True)", body) + len("     | _ -> True)")
    return source[start:end], source[body:source.index("     | _ -> True)", body)]


def type_guard(source):
    start = source.index("datatype Seed")
    end = source.index("let rec f t =", start)
    decls = '''datatype Key : type
datacons KMark : Key Marker
datacons KBox : Key Cargo
''' + NOTE + '''external let seen : ∀a. Key a → Key a = "fun x -> ignore (note 0); x"

'''
    source = source[:start] + decls + source[end:]
    start = source.index("      match seed with")
    end = source.index("1 <= r ->", start) + len("1 <= r ->")
    return (source[:start] +
            "      let returned = relay KMark (S Z) in (match returned with KBox ->" +
            source[end:]).replace("observed n", "seen n").replace("observed 73", "note 73")


def separate(source):
    helper = re.search(r"test \((let rec relay .*?) in\s+match seed with", source, re.S)
    assert helper
    return source.replace(helper[0], "test (match seed with").replace(
        "let rec f t =", helper[1] + "\n\nlet rec f t =")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("invargent", type=Path)
    parser.add_argument("--before", type=Path, help="optional executable at 82587e2")
    parser.add_argument("--before-placement", type=Path, help="optional executable at e9d7a45")
    parser.add_argument("--trace", type=Path, help="executable with the pass-trace and interface patches")
    args = parser.parse_args()
    exe = args.invargent.resolve(strict=True)
    packed = (HERE / "local_packed_guard.gadt").read_text()
    opposite = (HERE / "opposite_package.gadt").read_text()
    coordinate = (HERE / "state_coordinate.gadt").read_text()
    dead, calls = arm(packed)
    with TemporaryDirectory() as tmp:
        root = Path(tmp)

        def check(name, source, *, budget=11, error=None, binary=exe, options=()):
            result = compile_and_run(root, binary, name, source, error=error,
                                     options=("-full_annot", "-iterations_timeout", str(budget), *options))
            return " ".join(result.split()) if result else ""

        for budget in (0, 1, 2, 3, 4, 5):
            check(f"small_{budget}", packed, budget=budget, error="Answers do not converge")
        for budget in (6, 11, 10000):
            assert previous["PLAIN"] in check(f"joint_{budget}", packed, budget=budget)
        assert previous["PINNED"].replace("(a,a)", "(a, a)") in check(
            "one_axis", previous["single"](packed))
        check("strict", packed, options=("-force_no_dead_code",), error="Type mismatch")
        check("actual_zero", packed.replace("1 <= r", "0 <= r"), error="term abduction failed")
        check("base_one", packed.replace("Z -> observed n", "Z -> 1"), error="term abduction failed")
        check("undefined", packed.replace("f (First Box)", "f unknown"), error="Undefined variable")
        check("local_package", packed.replace("let ok =", "let internal = efunction x -> x in let ok ="))
        note = "(match returned with r when 0 <= r -> note r | _ -> False)"
        mixed = packed.replace("external let seed", NOTE + "external let seed").replace(
            dead, "let a = " + dead + " in let b = " + note + " in " + dead.replace("1 <= r", "2 <= r"))
        check("two_dead_one_live", mixed + "\nlet ticks = note 73\n")
        check("wrong_live_body", mixed.replace("note r |", "same Box Mark |"), error="Type mismatch")
        flag = '''datatype Flag : num
datacons Pos : ∀i[1≤i]. Flag i
datacons Other : ∀i. Flag i
external let flag : ∀i. Num i → Flag i = "fun n -> if n >= 1 then Pos else Other"
'''
        flagged = packed.replace("external let seed", flag + "external let seed").replace(
            "match returned with r when 1 <= r", "match flag returned with Pos")
        check("refined_numeric_pattern", flagged)
        typed = type_guard(packed)
        check("refined_type_pattern", typed)
        check("possible_type_pattern", typed.replace("= relay KMark", "= relay KBox"),
              error="Quantifier violation")
        bounded = packed.replace("S d -> relay n d", "S d -> let x = relay n d in step x")
        decreases = bounded.replace("external let seed", DOWN + "external let seed")
        check("before_decreasing_retry", decreases, budget=9, error="Answers do not converge")
        check("decreasing", decreases, budget=10)
        assert "(*∀'k, 'n[k ≤ n].*)(* k *) num -> (* n *) ex3" in (root / "decreasing.ml").read_text()
        increasing = bounded.replace("external let seed", UP + "external let seed")
        check("increasing", increasing, error="term abduction failed")
        reaches_one = increasing.replace("external let seed", NOTE + "external let seed").replace(
            calls, "      note r\n") + "\nlet ticks = note 73\n"
        check("increasing_reaches_one", reaches_one)
        check("joint_opposites", opposite)
        raised = separate(opposite)
        assert "val relay : ∀n. Num (-n) → Num n → Nat → ∃.Num (-n)" in check("opposites", raised)
        assert "val relay : ∀n. Num (-n) → Num n → Nat → ∃.Num n" in check(
            "opposites_reversed", raised.replace("relay n m", "relay m n"))
        for name, result in (("opposites", "-n"), ("opposites_reversed", "n")):
            assert f"(* {result} *) num -> (* n *) ex1" in (root / (name + ".ml")).read_text()
        for budget in (0, 1, 2, 3, 6, 11, 10000):
            error = ("Answers do not converge" if budget == 0 else
                     "numerical abduction failed" if budget < 3 else None)
            check(f"coordinate_{budget}", coordinate, budget=budget, error=error)
        check("coordinate_alone", coordinate.partition("\ntest (")[0])
        if args.before_placement:
            for budget in (1, 10000):
                check(f"prior_coordinate_{budget}", coordinate, budget=budget,
                      binary=args.before_placement.resolve(strict=True), error="numerical abduction failed")
        keyed = coordinate.replace("run state =", "run : ∀i. State i → Nat → ∃.Num i = fun state ->")
        assert "val run : ∀n. State n → Nat → ∃.Num n" in check("coordinate_written", keyed)
        merged = keyed.replace("∃.Num i", "∃j[0≤j ∧ j≤1].Num j")
        check("coordinate_merged", merged, error="numerical abduction failed")
        check("merged_harmless", merged.replace("0 -> 2", "0 -> 1"))
        if args.before:
            old = args.before.resolve(strict=True)
            check("old_joint", packed, budget=10000, binary=old, error="Type mismatch")
            check("old_type_guard", typed, binary=old, error="Type mismatch")
        if args.trace:
            traced = args.trace.resolve(strict=True)

            def events(name, budget):
                result = subprocess.run([traced, "-inform", "-full_annot", "-no_verif",
                                         "-no_ml", "-no_sig", "-iterations_timeout", str(budget),
                                         root / (name + ".gadt")], stdout=subprocess.PIPE,
                                        stderr=subprocess.STDOUT, text=True, check=True, timeout=60)
                item, marker, _ = result.stdout.partition("val f :")
                assert marker, result.stdout
                return re.findall(r"^TRACE (enter|update|fail) (\d+)$", item, re.M)

            path = events("joint_6", 6)
            assert path == events("joint_10000", 10000)
            assert path.count(("enter", "6")) == path.count(("fail", "6")) == 3
            assert sum(k == "enter" for k, _ in path) == 34
            assert path[-12:] == [(k, str(i)) for i in range(6) for k in ("enter", "update")]
            assert events("decreasing", 11)[-1] == ("update", "9")
            rc, cuts, passes = previous["trace"](traced, root / "coordinate_1.gadt", 1)
            assert rc and not cuts
            assert passes == [("enter", 0), ("update", 0), ("enter", 1), ("fail", 1)] * 2
            assert previous["trace"](traced, root / "coordinate_1.gadt", 10000) == (rc, cuts, passes)
            observed = subprocess.run([traced, "-full_annot", "-no_sig", "-no_ml", "-no_verif",
                                       root / "coordinate_1.gadt"], capture_output=True, text=True,
                                      env=dict(os.environ, JCA_TRACE_INTERFACE="1"), timeout=60)
            candidates = re.findall(r"INTERFACE 1 (.*?) CALLS (.*?) END_INTERFACE",
                                    " ".join(observed.stderr.split()))
            assert observed.returncode and len(candidates) == 2, candidates
            for relation, arrows in candidates:
                assert re.fullmatch(r"X1:=∃(t\d+)\. δ' = \(\) ∧ δ = \1", relation), relation
                assert "State " in arrows and "X1(a, ())" in arrows, arrows
            print("verified equality, decreasing band and state-coordinate pass traces", flush=True)


if __name__ == "__main__":
    main()
